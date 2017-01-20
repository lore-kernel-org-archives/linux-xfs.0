Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36464 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751516AbdATJXM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jan 2017 04:23:12 -0500
Received: by mail-wm0-f65.google.com with SMTP id r126so5217640wmr.3
        for <linux-xfs@vger.kernel.org>; Fri, 20 Jan 2017 01:22:13 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] xfs_io: fix missing syncfs command
Date: Fri, 20 Jan 2017 11:21:58 +0200
Message-Id: <1484904118-17703-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

Fixes commit c7dd81c7cd ("xfs_io: add sync and syncfs commands")

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 configure.ac          | 1 +
 include/builddefs.in  | 1 +
 m4/package_libcdev.m4 | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 3a4655f..1506b5e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -135,6 +135,7 @@ AC_HAVE_FIEMAP
 AC_HAVE_PREADV
 AC_HAVE_COPY_FILE_RANGE
 AC_HAVE_SYNC_FILE_RANGE
+AC_HAVE_SYNCFS
 AC_HAVE_MNTENT
 AC_HAVE_FLS
 AC_HAVE_READDIR
diff --git a/include/builddefs.in b/include/builddefs.in
index 612b547..ec1fe61 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -105,6 +105,7 @@ HAVE_FIEMAP = @have_fiemap@
 HAVE_PREADV = @have_preadv@
 HAVE_COPY_FILE_RANGE = @have_copy_file_range@
 HAVE_SYNC_FILE_RANGE = @have_sync_file_range@
+HAVE_SYNCFS = @have_syncfs@
 HAVE_READDIR = @have_readdir@
 HAVE_MNTENT = @have_mntent@
 HAVE_FLS = @have_fls@
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 7d5a42d..bc3b4ce 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -189,7 +189,7 @@ AC_DEFUN([AC_HAVE_SYNCFS],
 #include <unistd.h>
     ], [
          syncfs(0);
-    ], have_sync_fs=yes
+    ], have_syncfs=yes
        AC_MSG_RESULT(yes),
        AC_MSG_RESULT(no))
     AC_SUBST(have_syncfs)
-- 
2.7.4

