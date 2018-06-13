Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46284 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935060AbeFMThC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Jun 2018 15:37:02 -0400
Received: from Liberator-5.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id CF5672ACC
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jun 2018 14:36:37 -0500 (CDT)
Subject: [PATCH 2/2] mkfs: remove notion of config "type"
From: Eric Sandeen <sandeen@sandeen.net>
References: <7a30c780-d69a-71d4-d0e6-a5fcefda08e6@sandeen.net>
Message-ID: <8c2a5a07-5d47-48a1-1593-e93eb0fb883a@sandeen.net>
Date: Wed, 13 Jun 2018 14:37:01 -0500
MIME-Version: 1.0
In-Reply-To: <7a30c780-d69a-71d4-d0e6-a5fcefda08e6@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

The whole notion of a defaults "type" led to complications that
simply doesn't need to be there.  If a configuration file was
used for defaults, simply state that fact and carry on.

This also removes ambiguity for config files specified as
a relative path by calling realpath.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

 config.c   |   20 ++++++++------------
 config.h   |   31 -------------------------------
 xfs_mkfs.c |    8 +++-----
 3 files changed, 11 insertions(+), 48 deletions(-)

diff --git a/mkfs/config.c b/mkfs/config.c
index 1a2cd35..3a389ad 100644
--- a/mkfs/config.c
+++ b/mkfs/config.c
@@ -557,6 +557,7 @@ open_config_file(
 {
 	int				dirfd = -1, fd = -1, len, ret = 0;
 	struct stat			st;
+	bool				cli_specified = false;
 
 	*fpath = malloc(PATH_MAX);
 	if (!*fpath)
@@ -566,18 +567,19 @@ open_config_file(
 
 	/* first try relative to pwd or absolute path to cli configfile */
 	if (config_file) {
-		dft->type = DEFAULTS_CLI_CONFIG;
+		cli_specified = true;
 		if (strlen(config_file) > PATH_MAX) {
 			errno = ENAMETOOLONG;
 			goto out;
 		}
-		memcpy(*fpath, config_file, strlen(config_file));
+		/* Get absolute path to this file */
+		realpath(config_file, *fpath);
 		fd = openat(AT_FDCWD, config_file, O_NOFOLLOW, O_RDONLY);
 	}
 
 	/* on failure search for cli config or default file in sysconfdir */
 	if (fd < 0) {
-		if (!config_file)
+		if (!cli_specified)
 			config_file = MKFS_XFS_DEFAULT_CONFIG;
 		len = snprintf(*fpath, PATH_MAX, "%s/%s", MKFS_XFS_CONF_DIR,
 				config_file);
@@ -592,8 +594,6 @@ open_config_file(
 		fd = openat(dirfd, config_file, O_NOFOLLOW, O_RDONLY);
 		if (fd < 0)
 			goto out;
-		if (!strcmp(config_file, MKFS_XFS_DEFAULT_CONFIG))
-			dft->type = DEFAULTS_CONFIG;
 	}
 
 	ret = fstat(fd, &st);
@@ -606,11 +606,9 @@ open_config_file(
 out:
 	/* stat check is always fatal; missing is fatal only if cli-specified */
 	if (ret ||
-	    (fd < 0 && dft->type == DEFAULTS_CLI_CONFIG)) {
-		fprintf(stderr,
-_("Unable to open %s config file: %s : %s\n"),
-			default_type_str(dft->type), *fpath,
-			strerror(errno));
+	    (fd < 0 && cli_specified)) {
+		fprintf(stderr, _("Unable to open config file: %s : %s\n"),
+			*fpath, strerror(errno));
 		free(*fpath);
 		exit(1);
 	}
@@ -645,7 +643,5 @@ parse_defaults_file(
 		return -1;
 	}
 
-	printf(_("config-file=%s\n"), config_file);
-
 	return 0;
 }
diff --git a/mkfs/config.h b/mkfs/config.h
index db22ade..f4af2c7 100644
--- a/mkfs/config.h
+++ b/mkfs/config.h
@@ -58,22 +58,6 @@ struct sb_feat_args {
 };
 
 /*
- * File configuration type settings
- *
- * These are the different possibilities by which you can end up parsing
- * default settings with. DEFAULTS_BUILTIN indicates there was no configuration
- * file parsed and we are using the built-in defaults on this code.
- * DEFAULTS_CONFIG means the default configuration file was found and used.
- * DEFAULTS_CLI_CONFIG means the user asked for a custom configuration type
- * through the command line interface and it was used.
- */
-enum default_params_type {
-	DEFAULTS_BUILTIN = 0,
-	DEFAULTS_CONFIG,
-	DEFAULTS_CLI_CONFIG,
-};
-
-/*
  * Default filesystem features and configuration values
  *
  * This structure contains the default mkfs values that are to be used when
@@ -82,8 +66,6 @@ enum default_params_type {
  * calculations.
  */
 struct mkfs_default_params {
-	enum default_params_type type; /* where the defaults came from */
-
 	int	sectorsize;
 	int	blocksize;
 
@@ -94,19 +76,6 @@ struct mkfs_default_params {
 	struct fsxattr		fsx;
 };
 
-static inline const char *default_type_str(enum default_params_type type)
-{
-	switch (type) {
-	case DEFAULTS_BUILTIN:
-		return _("package built-in definitions");
-	case DEFAULTS_CONFIG:
-		return _("package default config file");
-	case DEFAULTS_CLI_CONFIG:
-		return _("CLI supplied file");
-	}
-	return _("Unkown\n");
-}
-
 int
 open_config_file(
 	const char			*cli_config_file,
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d32c2c8..56e5f03 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3722,7 +3722,6 @@ main(
 
 	/* build time defaults */
 	struct mkfs_default_params	dft = {
-		.type = DEFAULTS_BUILTIN,
 		.sectorsize = XFS_MIN_SECTORSIZE,
 		.blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
 		.sb_feat = {
@@ -3796,19 +3795,18 @@ _("respecification of configuration not allowed\n"));
 		ret = parse_defaults_file(fd, &dft, config_file);
 		if (ret) {
 			fprintf(stderr,
-_("Error parsing %s config file: %s : %s\n"),
-				default_type_str(dft.type),
+_("Error parsing config file: %s : %s\n"),
 				config_file, strerror(errno));
 			free(config_file);
 			close(fd);
 			exit(1);
 		}
+		printf(_("Configuration file used for defaults: %s\n"),
+			config_file);
 		free(config_file);
 		close(fd);
 	}
 
-	printf(_("Default configuration sourced from %s\n"),
-	       default_type_str(dft.type));
 
 	/*
 	 * Done parsing defaults now, so memcpy defaults into CLI

