Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:36957 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751913AbdH2XvI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:08 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002d3-TB
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005WG-S1
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 19/42] mkfs: introduce default configuration structure
Date: Wed, 30 Aug 2017 09:50:29 +1000
Message-Id: <20170829235052.21050-20-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

mkfs has lots of options that require default values. Some of these
are centralised, but others aren't. Introduce a new structure
designed to hold default values for all the parameters that need
defaults in one place.

This structure also provides a mechanism for providing mkfs defaults
from a config file. This is not implemented in this series, but a
comment is left where it is expected this functionality will hook
in.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 77 +++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 61 insertions(+), 16 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 1fd5108be520..e53e56a1bd47 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -851,6 +851,27 @@ struct mkfs_params {
 	struct sb_feat_args	sb_feat;
 };
 
+/*
+ * Default filesystem features and configuration values
+ *
+ * This structure contains the default mkfs values that are to be used when
+ * a user does not specify the option on the command line. We do not use these
+ * values directly - they are inputs to the mkfs geometry validation and
+ * calculations.
+ */
+struct mkfs_default_params {
+	char	*source;	/* where the defaults came from */
+
+	int	sectorsize;
+	int	blocksize;
+
+	/* feature flags that are set */
+	struct sb_feat_args	sb_feat;
+
+	/* root inode characteristics */
+	struct fsxattr		fsx;
+};
+
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
 #define MEGABYTES(count, blog)	((uint64_t)(count) << (20 - (blog)))
@@ -2587,25 +2608,33 @@ main(
 	int			worst_freelist;
 	libxfs_init_t		xi;
 	struct fs_topology	ft;
-	struct sb_feat_args	sb_feat = {
-		.finobt = 1,
-		.spinodes = 0,
-		.log_version = 2,
-		.attr_version = 2,
-		.dir_version = XFS_DFL_DIR_VERSION,
-		.inode_align = XFS_IFLAG_ALIGN,
-		.nci = false,
-		.lazy_sb_counters = true,
-		.projid16bit = false,
-		.crcs_enabled = true,
-		.dirftype = true,
-		.parent_pointers = false,
-		.rmapbt = false,
-		.reflink = false,
+	struct sb_feat_args	sb_feat;
+	/* build time defaults */
+	struct mkfs_default_params	dft = {
+		.source = "package build definitions",
+		.sectorsize = XFS_MIN_SECTORSIZE,
+		.blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
+		.sb_feat = {
+			.log_version = 2,
+			.attr_version = 2,
+			.dir_version = XFS_DFL_DIR_VERSION,
+			.inode_align = XFS_IFLAG_ALIGN,
+			.nci = false,
+			.lazy_sb_counters = true,
+			.projid16bit = false,
+			.crcs_enabled = true,
+			.dirftype = true,
+			.finobt = true,
+			.spinodes = false,
+			.rmapbt = false,
+			.reflink = false,
+			.parent_pointers = false,
+			.nodalign = false,
+			.nortalign = false,
+		},
 	};
 	struct cli_params	cli = {
 		.xi = &xi,
-		.sb_feat = sb_feat,
 	};
 	struct mkfs_params	cfg = {};
 
@@ -2615,6 +2644,22 @@ main(
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
+	/*
+	 * TODO: Sourcing defaults from a config file
+	 *
+	 * Before anything else, see if there's a config file with different
+	 * defaults. If a file exists in <package location>, read in the new
+	 * default values and overwrite them in the &dft structure. This way the
+	 * new defaults will apply before we parse the CLI, and the CLI will
+	 * still be able to override them. Emit a message to indicate where the
+	 * defaults being used came from.
+	 */
+	printf(_("Default configuration sourced from %s\n"), dft.source);
+
+	/* copy new defaults into CLI parsing structure */
+	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
+	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
+
 	blflag = bsflag = slflag = ssflag = lslflag = lssflag = 0;
 	blocklog = blocksize = 0;
 	sectorlog = lsectorlog = 0;
-- 
2.13.3

