Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753624AbeFPADa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jun 2018 20:03:30 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH] mkfs: add mkfs_config_version specifier for the config file
Date: Fri, 15 Jun 2018 17:03:28 -0700
Message-Id: <20180616000328.22304-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, david@fromorbit.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

We may opt later to bump this and add new features which we
don't want a v1 parser to use. So peg a version number. We use
mkfs_config_version as special token as other sections may use
'version' already, such is the case for log.

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 man/man8/mkfs.xfs.8.in |  7 ++++++-
 mkfs/config.c          | 55 +++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index cf4bdf827d9c..71573daec718 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -965,12 +965,17 @@ option follow a simple ini-style format as shown below.
 Available options consist of a small subset of the parameters available
 via the
 .BR mkfs.xfs (8)
-command line.
+command line. All configuration files must start with an annotation of
+the configuration file format, specified with the keyword
+.B mkfs_config_version
+and the only supported version format is 1.
 Currently all default parameters can only be either enabled or disabled,
 with a value of 1 to enable or 0 to disable.
 See below for a list of all supported configuration parameters and their
 current built-in default settings.
 .PP
+.BI mkfs_config_version=1
+.br
 .BI [data]
 .br
 .BI noalign=0
diff --git a/mkfs/config.c b/mkfs/config.c
index 835adc45f02d..072ac16ab796 100644
--- a/mkfs/config.c
+++ b/mkfs/config.c
@@ -379,6 +379,31 @@ parse_get_line_type(
 	return PARSE_INVALID;
 }
 
+static bool
+check_version_supported(
+		uint64_t		version,
+		bool			version_set)
+{
+	if (!version_set) {
+		fprintf(stderr,
+_("Version for configuration file not specified\n"));
+		goto out;
+	}
+
+	if (version != 1) {
+		errno = EOPNOTSUPP;
+		fprintf(stderr,
+_("Only version 1 supported, you specified version %lu\n"), version);
+		goto out;
+	}
+
+	return true;
+
+out:
+	errno = EOPNOTSUPP;
+	return false;
+}
+
 static int
 parse_config_stream(
 	struct mkfs_default_params	*dft,
@@ -389,7 +414,8 @@ parse_config_stream(
 	char				*line = NULL;
 	ssize_t				linelen;
 	size_t				len = 0, lineno = 0;
-	uint64_t			value;
+	uint64_t			value, version = 0;
+	bool				version_set = false;
 	enum parse_line_type		parse_type;
 	struct confopts			*confopt = NULL;
 	int				subopt;
@@ -400,6 +426,7 @@ parse_config_stream(
 		char	*p;
 
 		lineno++;
+		value = 0;
 
 		/*
 		 * tag is allocated for us by scanf(), it must freed only on
@@ -420,6 +447,9 @@ parse_config_stream(
 					  config_file, lineno, line);
 			goto out;
 		case PARSE_SECTION:
+			if (!check_version_supported(version, version_set))
+				goto out_free_tag;
+
 			confopt = get_confopts(tag);
 			if (!confopt) {
 				fprintf(stderr,
@@ -445,12 +475,35 @@ _("Section '%s' respecified\n"),
 			break;
 		case PARSE_TAG_VALUE:
 			if (!confopt) {
+				if (strcmp("mkfs_config_version", tag) == 0) {
+					if (!version_set) {
+						free(tag);
+						version = value;
+						version_set = true;
+					} else {
+						fprintf(stderr,
+_("Version respecified on line %s:%zu : %s\n"),
+							config_file, lineno,
+							line);
+						goto out_free_tag;
+					}
+
+					break;
+				}
+
+				if (!check_version_supported(version,
+							     version_set))
+					goto out_free_tag;
+
 				fprintf(stderr,
 _("No section specified yet on line %s:%zu : %s\n"),
 					config_file, lineno, line);
 				goto out_free_tag;
 			}
 
+			if (!check_version_supported(version, version_set))
+				goto out_free_tag;
+
 			/*
 			 * We re-use the line buffer allocated by getline(),
 			 * however line must be kept pointing to its original
-- 
2.16.3

