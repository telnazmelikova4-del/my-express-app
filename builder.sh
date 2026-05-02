#!/bin/bash

# Проверка, что переданы 2 аргумента
if [ $# -ne 2 ]; then
  echo "Ошибка: укажите два аргумента"
  echo "Пример: ./builder.sh mluukkai/express_app mluukkai/testing"
  exit 1
fi

GITHUB_REPO=$1   # например, mluukkai/express_app
DOCKER_REPO=$2   # например, wiqipa88/my-express-app

# Извлекаем имя репозитория из GitHub-пути (последняя часть)
REPO_NAME=$(basename "$GITHUB_REPO")

# 1. Клонируем репозиторий
echo " Клонируем $GITHUB_REPO ..."
git clone "https://github.com/$GITHUB_REPO.git" "$REPO_NAME"
if [ $? -ne 0 ]; then
  echo " Ошибка: не удалось клонировать репозиторий"
  exit 1
fi

# 2. Переходим в папку проекта
cd "$REPO_NAME" || exit 1

# 3. Собираем Docker образ
echo " Собираем образ $DOCKER_REPO:latest ..."
docker build -t "$DOCKER_REPO:latest" .

# 4. Пушим образ в Docker Hub
echo " Пушим образ $DOCKER_REPO:latest ..."
docker push "$DOCKER_REPO:latest"

# 5. Возвращаемся обратно и чистим за собой (опционально)
cd ..
rm -rf "$REPO_NAME"

echo " Готово! Образ опубликован: $DOCKER_REPO:latest"