Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54616 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754081AbeFLTbt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jun 2018 15:31:49 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 4/7] mkfs: tidy up whitespace in mkfs/config.c
Date: Tue, 12 Jun 2018 14:31:20 -0500
Message-Id: <1528831883-21879-5-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1528831883-21879-1-git-send-email-sandeen@sandeen.net>
References: <1528831883-21879-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Fix 80 col wraps, inconsistent whitespace, etc.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 mkfs/config.c   | 98 ++++++++++++++++++++++++++++++---------------------------
 mkfs/xfs_mkfs.c | 13 ++++----
 2 files changed, 59 insertions(+), 52 deletions(-)

diff --git a/mkfs/config.c b/mkfs/config.c
index f7f40fc..f27e480 100644
--- a/mkfs/config.c
+++ b/mkfs/config.c
@@ -64,8 +64,9 @@ enum rtdev_subopts {
 /* Just define the max options array size manually right now */
 #define MAX_SUBOPTS	5
 
-static int config_check_bool(
-	uint64_t			value)
+static int
+config_check_bool(
+	uint64_t	value)
 {
 	if (value > 1)
 		goto out;
@@ -83,7 +84,7 @@ data_config_parser(
 	int				psubopt,
 	uint64_t			value)
 {
-	enum data_subopts	subopt = psubopt;
+	enum data_subopts		subopt = psubopt;
 
 	if (config_check_bool(value) != 0)
 		return -1;
@@ -102,7 +103,7 @@ inode_config_parser(
 	int				psubopt,
 	uint64_t			value)
 {
-	enum inode_subopts	subopt = psubopt;
+	enum inode_subopts		subopt = psubopt;
 
 	if (config_check_bool(value) != 0)
 		return -1;
@@ -127,7 +128,7 @@ log_config_parser(
 	int				psubopt,
 	uint64_t			value)
 {
-	enum log_subopts	subopt = psubopt;
+	enum log_subopts		subopt = psubopt;
 
 	if (config_check_bool(value) != 0)
 		return -1;
@@ -146,7 +147,7 @@ metadata_config_parser(
 	int				psubopt,
 	uint64_t			value)
 {
-	enum metadata_subopts	subopt = psubopt;
+	enum metadata_subopts		subopt = psubopt;
 
 	if (config_check_bool(value) != 0)
 		return -1;
@@ -176,7 +177,7 @@ naming_config_parser(
 	int				psubopt,
 	uint64_t			value)
 {
-	enum naming_subopts	subopt = psubopt;
+	enum naming_subopts		subopt = psubopt;
 
 	if (config_check_bool(value) != 0)
 		return -1;
@@ -195,7 +196,7 @@ rtdev_config_parser(
 	int				psubopt,
 	uint64_t			value)
 {
-	enum rtdev_subopts	subopt = psubopt;
+	enum rtdev_subopts		subopt = psubopt;
 
 	if (config_check_bool(value) != 0)
 		return -1;
@@ -209,11 +210,11 @@ rtdev_config_parser(
 }
 
 struct confopts {
-	const char		*name;
-	const char		*subopts[MAX_SUBOPTS];
-	int			(*parser)(struct mkfs_default_params *dft,
-					  int psubopt, uint64_t value);
-	bool			seen;
+	const char	*name;
+	const char	*subopts[MAX_SUBOPTS];
+	int		(*parser)(struct mkfs_default_params *dft,
+				  int psubopt, uint64_t value);
+	bool		seen;
 } confopts_tab[] = {
 	{
 		.name = "data",
@@ -392,17 +393,17 @@ parse_config_stream(
 	enum parse_line_type		parse_type;
 	struct confopts			*confopt = NULL;
 	int				subopt;
-	char *tag = NULL;
+	char				*tag = NULL;
 
 	while ((linelen = getline(&line, &len, fp)) != -1) {
-		char *ignore_value;
-		char *p;
+		char	*ignore_value;
+		char	*p;
 
 		lineno++;
 
 		/*
-		 * tag is allocated for us by scanf(), it must freed only on any
-		 * successful parse of a section or tag-value pair.
+		 * tag is allocated for us by scanf(), it must freed only on
+		 * any successful parse of a section or tag-value pair.
 		 */
 		parse_type = parse_get_line_type(line, linelen, &tag, &value);
 
@@ -421,19 +422,22 @@ parse_config_stream(
 		case PARSE_SECTION:
 			confopt = get_confopts(tag);
 			if (!confopt) {
-				fprintf(stderr, _("Invalid section on line %s:%zu : %s\n"),
-						config_file, lineno, tag);
+				fprintf(stderr,
+_("Invalid section on line %s:%zu : %s\n"),
+					config_file, lineno, tag);
 				goto out_free_tag;
 			}
 			if (!confopt->subopts) {
-				fprintf(stderr, _("Section not yet supported on line %s:%zu : %s\n"),
-						config_file, lineno, tag);
+				fprintf(stderr,
+_("Section not yet supported on line %s:%zu : %s\n"),
+					config_file, lineno, tag);
 				goto out_free_tag;
 			}
 			if (confopt->seen) {
 				errno = EINVAL;
-				fprintf(stderr, _("Section '%s' respecified\n"),
-						tag);
+				fprintf(stderr,
+_("Section '%s' respecified\n"),
+					tag);
 				goto out_free_tag;
 			}
 			confopt->seen = true;
@@ -441,8 +445,9 @@ parse_config_stream(
 			break;
 		case PARSE_TAG_VALUE:
 			if (!confopt) {
-				fprintf(stderr, _("No section specified yet on line %s:%zu : %s\n"),
-						config_file, lineno, line);
+				fprintf(stderr,
+_("No section specified yet on line %s:%zu : %s\n"),
+					config_file, lineno, line);
 				goto out_free_tag;
 			}
 
@@ -475,8 +480,9 @@ parse_config_stream(
 			ret = confopt->parser(dft, subopt, value);
 			if (ret) {
 				errno = EINVAL;
-				fprintf(stderr, _("Error parsine line %s:%zu : %s\n"),
-						config_file, lineno, line);
+				fprintf(stderr,
+_("Error parsine line %s:%zu : %s\n"),
+					config_file, lineno, line);
 				goto out;
 			}
 
@@ -501,7 +507,7 @@ out_free_tag:
 
 static int
 config_stat_check(
-	struct stat		*sp)
+	struct stat	*sp)
 {
 	if (!S_ISREG(sp->st_mode)) {
 		errno = EINVAL;
@@ -523,12 +529,12 @@ config_stat_check(
  */
 int
 open_cli_config(
-	int			dirfd,
-	const char		*cli_config_file,
-	char			**fpath)
+	int		dirfd,
+	const char	*cli_config_file,
+	char		**fpath)
 {
-	int			fd = -1, len, ret;
-	struct stat		st;
+	int		fd = -1, len, ret;
+	struct stat	st;
 
 	fd = openat(AT_FDCWD, cli_config_file, O_NOFOLLOW, O_RDONLY);
 	if (fd < 0) {
@@ -544,8 +550,7 @@ open_cli_config(
 		if (fd < 0)
 			goto out;
 
-		ret = fstatat(dirfd, cli_config_file, &st,
-			      AT_SYMLINK_NOFOLLOW);
+		ret = fstatat(dirfd, cli_config_file, &st, AT_SYMLINK_NOFOLLOW);
 		if (ret != 0)
 			goto err_out_close;
 
@@ -590,8 +595,8 @@ open_config_file(
 	struct mkfs_default_params	*dft,
 	char				**fpath)
 {
-	int			dirfd, fd = -1, len, ret;
-	struct stat		st;
+	int				dirfd, fd = -1, len, ret;
+	struct stat			st;
 
 	*fpath = malloc(PATH_MAX);
 	if (!*fpath)
@@ -634,9 +639,10 @@ open_config_file(
 out:
 	if (fd < 0) {
 		if (dft->type != DEFAULTS_BUILTIN) {
-			fprintf(stderr, _("Unable to open %s config file: %s : %s\n"),
-					default_type_str(dft->type), *fpath,
-					strerror(errno));
+			fprintf(stderr,
+_("Unable to open %s config file: %s : %s\n"),
+				default_type_str(dft->type), *fpath,
+				strerror(errno));
 			free(*fpath);
 			exit(1);
 		}
@@ -657,12 +663,12 @@ err_out_close:
  */
 int
 parse_defaults_file(
-	int					fd,
-	struct mkfs_default_params		*dft,
-	const char				*config_file)
+	int				fd,
+	struct mkfs_default_params	*dft,
+	const char			*config_file)
 {
-	FILE			*fp;
-	int			ret;
+	FILE				*fp;
+	int				ret;
 
 	fp = fdopen(fd, "r");
 	if (!fp)
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 022323a..be3094b 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3780,7 +3780,8 @@ main(
 		switch (c) {
 		case 'c':
 			if (cli_config_file) {
-				fprintf(stderr, _("respecification of configuration not allowed\n"));
+				fprintf(stderr,
+_("respecification of configuration not allowed\n"));
 				exit(1);
 			}
 			cli_config_file = optarg;
@@ -3795,10 +3796,10 @@ main(
 	if (fd >= 0) {
 		ret = parse_defaults_file(fd, &dft, config_file);
 		if (ret) {
-			fprintf(stderr, _("Error parsing %s config file: %s : %s\n"),
-					default_type_str(dft.type),
-					config_file,
-					strerror(errno));
+			fprintf(stderr,
+_("Error parsing %s config file: %s : %s\n"),
+				default_type_str(dft.type),
+				config_file, strerror(errno));
 			free(config_file);
 			close(fd);
 			exit(1);
@@ -3819,7 +3820,7 @@ main(
 
 	platform_getoptreset();
 
-	while ((c = getopt(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
+	while ((c = getopt(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF){
 		switch (c) {
 		case 'c':
 			/* already validated and parsed, ignore */
-- 
1.8.3.1

