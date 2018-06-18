Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935531AbeFRSF0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jun 2018 14:05:26 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v2] mkfs: add mkfs config version specifier for the config file
Date: Mon, 18 Jun 2018 11:05:20 -0700
Message-Id: <20180618180520.22146-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, david@fromorbit.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

We may opt later to bump this and add new features which we
don't want a v1 parser to use. So peg a version number. We add
a new [global] section dedicated for special configuration file
option specifiers, with the only subtopt supported being 'version'.

The only we support for now is version 1.

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---

As suggested by Sandeed, added a [global] section which makes the
code easier to read and maintain.

 man/man8/mkfs.xfs.8.in |  9 ++++-
 mkfs/config.c          | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+), 1 deletion(-)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index cf4bdf827d9c..c86d559ba3e1 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -965,12 +965,19 @@ option follow a simple ini-style format as shown below.
 Available options consist of a small subset of the parameters available
 via the
 .BR mkfs.xfs (8)
-command line.
+command line. All configuration files must start with an annotation of
+the configuration file format, specified in the global section with the keyword
+.B version
+and the only supported version format is 1.
 Currently all default parameters can only be either enabled or disabled,
 with a value of 1 to enable or 0 to disable.
 See below for a list of all supported configuration parameters and their
 current built-in default settings.
 .PP
+.BI [global]
+.br
+.BI version=1
+.PP
 .BI [data]
 .br
 .BI noalign=0
diff --git a/mkfs/config.c b/mkfs/config.c
index 835adc45f02d..4bb371d6b1e8 100644
--- a/mkfs/config.c
+++ b/mkfs/config.c
@@ -32,6 +32,8 @@
  * We only provide definitions for what we currently support parsing.
  */
 
+static uint64_t mkfs_config_version;
+
 enum data_subopts {
 	D_NOALIGN = 0,
 };
@@ -42,6 +44,14 @@ enum inode_subopts {
 	I_SPINODES,
 };
 
+/*
+ * These are not part of the defaults but rather global generic configuration
+ * file options.
+ */
+enum global_subopts {
+	G_VERSION = 0,
+};
+
 enum log_subopts {
 	L_LAZYSBCNTR = 0,
 };
@@ -122,6 +132,24 @@ inode_config_parser(
 	return -1;
 }
 
+static int
+global_config_parser(
+	struct mkfs_default_params	*dft,
+	int				psubopt,
+	uint64_t			value)
+{
+	enum global_subopts		subopt = psubopt;
+
+	switch (subopt) {
+	case G_VERSION:
+		if (value != 1)
+			return -1;
+		mkfs_config_version = value;
+		return 0;
+	}
+	return -1;
+}
+
 static int
 log_config_parser(
 	struct mkfs_default_params	*dft,
@@ -234,6 +262,14 @@ struct confopts {
 		},
 		.parser = inode_config_parser,
 	},
+	{
+		.name = "global",
+		.subopts = {
+			[G_VERSION] = "version",
+			NULL
+		},
+		.parser = global_config_parser,
+	},
 	{
 		.name = "log",
 		.subopts = {
@@ -287,6 +323,24 @@ get_confopts(
 	return NULL;
 }
 
+static bool config_version_set(void)
+{
+	/* cannot fail */
+	struct confopts *opts = get_confopts("global");
+
+	return opts->seen;
+}
+
+static uint64_t config_version(void)
+{
+	/* cannot fail */
+	struct confopts *opts = get_confopts("global");
+
+	if (!opts->seen)
+		return 0;
+	return mkfs_config_version;
+}
+
 enum parse_line_type {
 	PARSE_COMMENT = 0,
 	PARSE_EMPTY,
@@ -379,6 +433,32 @@ parse_get_line_type(
 	return PARSE_INVALID;
 }
 
+static bool
+check_version_supported(
+		void)
+{
+	uint64_t version = config_version();
+
+	if (!version) {
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
@@ -420,6 +500,7 @@ parse_config_stream(
 					  config_file, lineno, line);
 			goto out;
 		case PARSE_SECTION:
+
 			confopt = get_confopts(tag);
 			if (!confopt) {
 				fprintf(stderr,
@@ -451,6 +532,13 @@ _("No section specified yet on line %s:%zu : %s\n"),
 				goto out_free_tag;
 			}
 
+			if (!config_version_set() &&
+			    strcmp(confopt->name, "global") != 0) {
+				fprintf(stderr,
+_("A global section with a version set was not detected and must be set first\n"));
+				goto out_free_tag;
+			}
+
 			/*
 			 * We re-use the line buffer allocated by getline(),
 			 * however line must be kept pointing to its original
@@ -486,6 +574,9 @@ _("Error parsing line %s:%zu : %s\n"),
 				goto out;
 			}
 
+			if (!check_version_supported())
+				goto out;
+
 			break;
 		}
 		free(line);
-- 
2.16.3

