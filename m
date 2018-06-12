Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54618 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754146AbeFLTbt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jun 2018 15:31:49 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 5/7] mkfs: properly fix TOCTOU open/stat race in config file handling
Date: Tue, 12 Jun 2018 14:31:21 -0500
Message-Id: <1528831883-21879-6-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1528831883-21879-1-git-send-email-sandeen@sandeen.net>
References: <1528831883-21879-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

After open of the configfile, simply fstat() that fd to ensure that
we are checking the file we just opened, not something that got
renamed in between.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 mkfs/config.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mkfs/config.c b/mkfs/config.c
index f27e480..940a055 100644
--- a/mkfs/config.c
+++ b/mkfs/config.c
@@ -550,7 +550,7 @@ open_cli_config(
 		if (fd < 0)
 			goto out;
 
-		ret = fstatat(dirfd, cli_config_file, &st, AT_SYMLINK_NOFOLLOW);
+		ret = fstat(fd, &st);
 		if (ret != 0)
 			goto err_out_close;
 
@@ -563,7 +563,7 @@ open_cli_config(
 
 	memcpy(*fpath, cli_config_file, strlen(cli_config_file));
 
-	ret = fstatat(AT_FDCWD, cli_config_file, &st, AT_SYMLINK_NOFOLLOW);
+	ret = fstat(fd, &st);
 	if (ret != 0)
 		goto err_out_close;
 
@@ -593,7 +593,7 @@ int
 open_config_file(
 	const char			*cli_config_file,
 	struct mkfs_default_params	*dft,
-	char				**fpath)
+	char				**fpath)	/* path where config is found */
 {
 	int				dirfd, fd = -1, len, ret;
 	struct stat			st;
@@ -628,7 +628,7 @@ open_config_file(
 		goto err_out_close;
 	}
 
-	ret = fstatat(dirfd, "default", &st, AT_SYMLINK_NOFOLLOW);
+	ret = fstat(fd, &st);
 	if (ret != 0)
 		goto err_out_close;
 
-- 
1.8.3.1

