#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"

source "${CURRENT_DIR}/helpers.sh"

if is_osx && is_command_available 'reattach-to-user-namespace'; then
  reattach-to-user-namespace pbpaste | tmux load-buffer -
fi

# remove newline if one sentence
if [[ $(tmux show-buffer | hexdump | grep -cE '[[:space:]](0[ad]|0d0a)[[:space:]]?') -eq 1 ]]; then
  tmux show-buffer | tr -d '\n' | tmux load-buffer -
  tmux paste-buffer
fi

if tmux show-buffer | hexdump | grep -qE '[[:space:]](0[ad]|0d0a)[[:space:]]?'; then
  tmux confirm-before -p "Include newline. Paste?(y/n)" "run-shell 'tmux paste-buffer'"
else
  tmux paste-buffer
fi
