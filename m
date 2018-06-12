Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54620 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754181AbeFLTbt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jun 2018 15:31:49 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 6/7] mkfs: consolidate and streamline config opening function
Date: Tue, 12 Jun 2018 14:31:22 -0500
Message-Id: <1528831883-21879-7-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1528831883-21879-1-git-send-email-sandeen@sandeen.net>
References: <1528831883-21879-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

There was a lot of duplication between open_cli_config and open_config_file
which was unnecessary.  Collapse all the logic into one function.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 mkfs/config.c   | 148 +++++++++++++++++++++-----------------------------------
 mkfs/xfs_mkfs.c |   1 -
 2 files changed, 56 insertions(+), 93 deletions(-)

diff --git a/mkfs/config.c b/mkfs/config.c
index 940a055..173ab9a 100644
--- a/mkfs/config.c
+++ b/mkfs/config.c
@@ -523,60 +523,6 @@ config_stat_check(
 	return 0;
 }
 
-/*
- * If the file is not found -1 is returned and errno set. Otherwise
- * the file descriptor is returned.
- */
-int
-open_cli_config(
-	int		dirfd,
-	const char	*cli_config_file,
-	char		**fpath)
-{
-	int		fd = -1, len, ret;
-	struct stat	st;
-
-	fd = openat(AT_FDCWD, cli_config_file, O_NOFOLLOW, O_RDONLY);
-	if (fd < 0) {
-		len = snprintf(*fpath, PATH_MAX, "%s/%s", MKFS_XFS_CONF_DIR,
-			       cli_config_file);
-		/* Indicates truncation */
-		if (len >= PATH_MAX) {
-			errno = ENAMETOOLONG;
-			goto out;
-		}
-
-		fd = openat(dirfd, cli_config_file, O_NOFOLLOW, O_RDONLY);
-		if (fd < 0)
-			goto out;
-
-		ret = fstat(fd, &st);
-		if (ret != 0)
-			goto err_out_close;
-
-		ret = config_stat_check(&st);
-		if (ret != 0)
-			goto err_out_close;
-
-		goto out;
-	}
-
-	memcpy(*fpath, cli_config_file, strlen(cli_config_file));
-
-	ret = fstat(fd, &st);
-	if (ret != 0)
-		goto err_out_close;
-
-	ret = config_stat_check(&st);
-	if (ret != 0)
-		goto err_out_close;
-out:
-	return fd;
-err_out_close:
-	close(fd);
-	return -1;
-}
-
 #ifndef O_PATH
 #if defined __alpha__
 #define O_PATH		040000000
@@ -589,13 +535,26 @@ err_out_close:
 #endif
 #endif /* O_PATH */
 
+/*
+ * Try to open a config file, either cli-specified, or default.
+ *
+ * If specified on commandline, search relative to pwd or absolute path.
+ * If not specified or if above fails, try either cli-spec'd file or "default"
+ * in MKFS_XFS_CONF_DIR.
+ *
+ * If any config file is successfully opened, dft->type is set to reflect the
+ * source.
+ *
+ * If a cli-specified file is not found -1 is returned and errno set. Otherwise
+ * the file descriptor is returned.
+ */
 int
 open_config_file(
-	const char			*cli_config_file,
+	const char			*config_file,
 	struct mkfs_default_params	*dft,
-	char				**fpath)	/* path where config is found */
+	char				**fpath)	/* path where we found config */
 {
-	int				dirfd, fd = -1, len, ret;
+	int				dirfd = -1, fd = -1, len, ret = 0;
 	struct stat			st;
 
 	*fpath = malloc(PATH_MAX);
@@ -604,57 +563,62 @@ open_config_file(
 
 	memset(*fpath, 0, PATH_MAX);
 
-	dirfd = open(MKFS_XFS_CONF_DIR, O_PATH|O_NOFOLLOW|O_DIRECTORY);
-
-	if (cli_config_file) {
-		if (strlen(cli_config_file) > PATH_MAX) {
+	/* first try relative to pwd or absolute path to cli configfile */
+	if (config_file) {
+		dft->type = DEFAULTS_CLI_CONFIG;
+		if (strlen(config_file) > PATH_MAX) {
 			errno = ENAMETOOLONG;
 			goto out;
 		}
-		fd = open_cli_config(dirfd, cli_config_file, fpath);
-		goto out;
+		memcpy(*fpath, config_file, strlen(config_file));
+		fd = openat(AT_FDCWD, config_file, O_NOFOLLOW, O_RDONLY);
 	}
 
-	fd = openat(dirfd, "default", O_NOFOLLOW, O_RDONLY);
-	if (fd < 0)
-		goto out;
-
-	dft->type = DEFAULTS_CONFIG;
-
-	len = snprintf(*fpath, PATH_MAX, "%s/%s", MKFS_XFS_CONF_DIR, "default");
-	/* Indicates truncation */
-	if (len >= PATH_MAX) {
-		errno = ENAMETOOLONG;
-		goto err_out_close;
+	/* on failure search for cli config or default file in sysconfdir */
+	if (fd < 0) {
+		if (!config_file)
+			config_file = "default";
+		len = snprintf(*fpath, PATH_MAX, "%s/%s", MKFS_XFS_CONF_DIR,
+				config_file);
+		/* Indicates truncation */
+		if (len >= PATH_MAX) {
+			errno = ENAMETOOLONG;
+			goto out;
+		}
+		dirfd = open(MKFS_XFS_CONF_DIR, O_PATH|O_NOFOLLOW|O_DIRECTORY);
+		if (dirfd < 0)
+			goto out;
+		fd = openat(dirfd, config_file, O_NOFOLLOW, O_RDONLY);
+		if (fd < 0)
+			goto out;
+		if (!strcmp(config_file, "default"))
+			dft->type = DEFAULTS_CONFIG;
 	}
 
 	ret = fstat(fd, &st);
 	if (ret != 0)
-		goto err_out_close;
-
+		goto out;
 	ret = config_stat_check(&st);
 	if (ret != 0)
-		goto err_out_close;
-
+		goto out;
+	
 out:
-	if (fd < 0) {
-		if (dft->type != DEFAULTS_BUILTIN) {
-			fprintf(stderr,
+	/* stat check is always fatal; missing is fatal only if cli-specified */
+	if (ret ||
+	    (fd < 0 && dft->type == DEFAULTS_CLI_CONFIG)) {
+		fprintf(stderr,
 _("Unable to open %s config file: %s : %s\n"),
-				default_type_str(dft->type), *fpath,
-				strerror(errno));
-			free(*fpath);
-			exit(1);
-		}
+			default_type_str(dft->type), *fpath,
+			strerror(errno));
+		free(*fpath);
+		exit(1);
 	}
+
+	if (ret && fd >= 0)
+		close(fd);
 	if (dirfd >= 0)
 		close(dirfd);
-	return fd;
-
-err_out_close:
-	close(fd);
-	fd = -1;
-	goto out;
+	return ret ? ret : fd;
 }
 
 /*
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index be3094b..acd98f6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3785,7 +3785,6 @@ _("respecification of configuration not allowed\n"));
 				exit(1);
 			}
 			cli_config_file = optarg;
-			dft.type = DEFAULTS_CLI_CONFIG;
 			break;
 		default:
 			continue;
-- 
1.8.3.1

