;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "William Madruga"
      user-mail-address "william.madruga@netsuite.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default: doom-one
(setq doom-theme 'doom-acario-dark)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Projectile
(setq projectile-project-search-path '("~/git" "~/src"))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; EXWM
;; (require 'exwm)
;; (require 'exwm-config)
;; (exwm-config-default)

;; (require 'exwm-systemtray)
;; (exwm-systemtray-enable)

;; (require 'exwm-randr)
;; (exwm-randr-enable)

;; (setq exwm-randr-workspace-output-plist '(0 "HDMI-2" 1 "DP-1"))
;; (add-hook 'exwm-randr-screen-change-hook
;;           (lambda ()
;;             (start-process-shell-command
;;              "xrandr" nil
;;              ;; "xrandr --output DP-1 --auto --right-of HDMI-2 --rotate left")))
;;              "xrandr --output DP-1 --auto --left-of HDMI-2 --rotate left")))
;; (exwm-randr-enable)

;; Automatic Multi Monitor setup for EXWM
;; (defun exwm-change-screen-hook ()
;;   (let ((xrandr-output-regexp "\n\\([^ ]+\\) connected ")
;;         default-output)
;;     (with-temp-buffer
;;       (call-process "xrandr" nil t nil)
;;       (goto-char (point-min))
;;       (re-search-forward xrandr-output-regexp nil 'noerror)
;;       (setq default-output (match-string 1))
;;       (forward-line)
;;       (if (not (re-search-forward xrandr-output-regexp nil 'noerror))
;;           (call-process "xrandr" nil nil nil "--output" default-output "--auto")
;;         (call-process
;;          "xrandr" nil nil nil
;;          "--output" (match-string 1) "--primary" "--auto"
;;          "--output" default-output "--off")
;;         (setq exwm-randr-workspace-output-plist (list 0 (match-string 1)))))))

;; CONFIG ;;

(setq undo-limit 80000000               ; Raise undo-limit to 80Mb
      auto-save-default t               ; auto-save
      js-indent-level 2                 ; javascript indentation
      )

(setq-default indent-tabs-mode nil
              fill-column 140
              tab-width 2)

;; Replace selection when inserting text
(delete-selection-mode 1)

;; Enable time in the mode-line
(display-time-mode 1)

;; Display battery, if available
(unless (equal "Battery status not available" (battery))
  (display-battery-mode 1))

;; Iterate through CamelCase words
(global-subword-mode 1)

;; set to fullscreen if started by emacs command or desktop file
(if (eq initial-window-system 'x)
    (toggle-frame-maximized)
  (toggle-frame-fullscreen))

;; Tabs config
(setq centaur-tabs-style "wave")
(setq centaur-tabs-height 40)
(setq centaur-tabs-set-icons t)
(setq centaur-tabs-set-bar 'under)
(setq x-underline-at-descent-line t)
(setq centaur-tabs-set-close-button nil)

(setq org-agenda-files "~/.doom.d/agenda.el")

(custom-set-variables
 '(elfeed-feeds
   '("https://www.redhat.com/sysadmin/rss.xml" "https://sachachua.com/blog/category/emacs-news/feed" "https://insideclojure.org/feed.xml")))

;; FUNCTIONS ;;

;; Run babashka script that uploads buffer to Netsuite.
(defun wmad/upload-to-netsuite ()
  "Send buffer to Netsuite."
  (interactive)
  (let ((cmd (concat "ns-upload" " " (buffer-file-name))))
    (message (shell-command-to-string cmd))
    ))

;; Shutdown emacs server
(defun wmad/server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs)
  )

;; Duplicate line :)
(defun wmad/duplicate-line ()
  (interactive)
  (let* ((cursor-column (current-column)))
    (move-beginning-of-line 1)
    (kill-line)
    (yank)
    (forward-line 1)
    (yank)
    (move-to-column cursor-column)))

;; Transpose windows: https://www.emacswiki.org/emacs/TransposeWindows
(defun wmad/transpose-windows ()
  "Transpose two windows.  If more or less than two windows are visible, error."
  (interactive)
  (unless (= 2 (count-windows))
    (error "There are not 2 windows."))
  (let* ((windows (window-list))
         (w1 (car windows))
         (w2 (nth 1 windows))
         (w1b (window-buffer w1))
         (w2b (window-buffer w2)))
    (set-window-buffer w1 w2b)
    (set-window-buffer w2 w1b)))

;; Mappings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(map! :g "C-c u" 'wmad/upload-to-netsuite)
(map! :g "C-c t" 'wmad/transpose-windows)
(map! :g "C-c <down>" 'wmad/duplicate-line)
(map! :g "<f8>" 'treemacs)
(map! :g "M-p" '+evil/alt-paste)
(map! :leader "b 0" 'bufler)
