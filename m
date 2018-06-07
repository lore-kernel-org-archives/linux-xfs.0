Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752156AbeFGXzg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Jun 2018 19:55:36 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v5 3/4] mkfs: replace defaults source with an enum
Date: Thu,  7 Jun 2018 16:55:32 -0700
Message-Id: <20180607235533.20391-4-mcgrof@kernel.org>
In-Reply-To: <20180607235533.20391-1-mcgrof@kernel.org>
References: <20180607235533.20391-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

Using an enum will let us later just use a switch statement to print
out the source, this makes sources easier to document, update and
manage.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 mkfs/config.h   | 22 +++++++++++++++++++++-
 mkfs/xfs_mkfs.c |  5 +++--
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/mkfs/config.h b/mkfs/config.h
index e5ea968e2d65..a3c6c99c3064 100644
--- a/mkfs/config.h
+++ b/mkfs/config.h
@@ -54,6 +54,17 @@ struct sb_feat_args {
 	bool	nortalign;
 };
 
+/*
+ * File configuration type settings
+ *
+ * These are the different possibilities by which you can end up parsing
+ * default settings with. DEFAULTS_BUILTIN indicates there was no configuration
+ * file parsed and we are using the built-in defaults on this code.
+ */
+enum default_params_type {
+	DEFAULTS_BUILTIN = 0,
+};
+
 /*
  * Default filesystem features and configuration values
  *
@@ -63,7 +74,7 @@ struct sb_feat_args {
  * calculations.
  */
 struct mkfs_default_params {
-	char	*source;	/* where the defaults came from */
+	enum default_params_type type; /* where the defaults came from */
 
 	int	sectorsize;
 	int	blocksize;
@@ -75,4 +86,13 @@ struct mkfs_default_params {
 	struct fsxattr		fsx;
 };
 
+static inline const char *default_type_str(enum default_params_type type)
+{
+	switch (type) {
+	case DEFAULTS_BUILTIN:
+		return _("package built-in definitions");
+	}
+	return _("Unkown\n");
+}
+
 #endif /* _XFS_MKFS_CONFIG_H */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 56e869d666be..2e344aa9dad1 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3722,7 +3722,7 @@ main(
 
 	/* build time defaults */
 	struct mkfs_default_params	dft = {
-		.source = _("package build definitions"),
+		.type = DEFAULTS_BUILTIN,
 		.sectorsize = XFS_MIN_SECTORSIZE,
 		.blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
 		.sb_feat = {
@@ -3762,7 +3762,8 @@ main(
 	 * implemented, emit a message to indicate where the defaults being
 	 * used came from.
 	 *
-	 * printf(_("Default configuration sourced from %s\n"), dft.source);
+	 * printf(_("Default configuration sourced from %s\n"),
+	 *	  default_type_str(dft.type));
 	 */
 
 	/* copy new defaults into CLI parsing structure */
-- 
2.16.3

