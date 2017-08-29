Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:40488 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751869AbdH2XvB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:01 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002bt-Do
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005VU-CW
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/42] mkfs: introduce a structure to hold CLI options
Date: Wed, 30 Aug 2017 09:50:13 +1000
Message-Id: <20170829235052.21050-4-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We need to hold the values set from command line options so they can
later be validated and discriminated from the default values that
might be set. This structure will form a connector between th einput
parsing and the rest of the mkfs code.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 include/libxfs.h |   2 +-
 mkfs/xfs_mkfs.c  | 107 ++++++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 91 insertions(+), 18 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index e5e152378c2c..b77819b1adcc 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -95,7 +95,7 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 /*
  * Argument structure for libxfs_init().
  */
-typedef struct {
+typedef struct libxfs_xinit {
 				/* input parameters */
 	char            *volname;       /* pathname of volume */
 	char            *dname;         /* pathname of data "subvolume" */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 43f631a647b4..2b264ec32974 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -709,6 +709,96 @@ struct opt_params mopts = {
 	},
 };
 
+/* quick way of checking is a parameter was set on the CLI */
+static bool
+cli_opt_set(
+	struct opt_params	*opts,
+	int			subopt)
+{
+	return opts->subopt_params[subopt].seen ||
+	       opts->subopt_params[subopt].str_seen;
+}
+
+/*
+ * Options configured on the command line.
+ *
+ * This stores all the specific config parameters the user sets on the command
+ * line. We do not use these values directly - they are inputs to the mkfs
+ * geometry validation and override any default configuration value we have.
+ *
+ * We don't keep flags to indicate what parameters are set - it is invalid to
+ * set values of -1 for any input, so we initialise values that can be set to
+ * zero to this, otherwise they are initialised to zero. Some parameters are
+ * stored as strings for later parsing (e.g. after block size and sector size
+ * have been validated), so they get initialised to NULL.
+ *
+ * This allows us to check that values have been set without needing separate
+ * flags for each value, and hence avoids needing to record and check for each
+ * specific option that can set the value later on in the code. In the cases
+ * where we don't have a cli_params structure around, the above cli_opt_set()
+ * function can be used.
+ */
+struct sb_feat_args {
+	int	log_version;
+	int	attr_version;
+	int	dir_version;
+	bool	inode_align;
+	bool	nci;
+	bool	lazy_sb_counters;
+	bool	projid16bit;
+	bool	crcs_enabled;
+	bool	dirftype;
+	bool	finobt;
+	bool	spinodes;
+	bool	rmapbt;
+	bool	reflink;
+	bool	parent_pointers;
+	bool	nodalign;
+	bool	nortalign;
+	uuid_t	m_uuid;
+};
+
+struct cli_params {
+	int	sectorsize;
+	int	blocksize;
+
+	/* parameters that depend on sector/block size being validated. */
+	char	*dsize;
+	char	*agsize;
+	char	*dsu;
+	char	*dirblocksize;
+	char	*logsize;
+	char	*lsu;
+	char	*rtextsize;
+	char	*rtsize;
+
+	/* parameters where 0 is a valid CLI value */
+	int	dsunit;
+	int	dswidth;
+	int	dsw;
+	int64_t	logagno;
+	int	loginternal;
+	int	lsunit;
+
+	/* parameters where 0 is not a valid value */
+	int64_t	agcount;
+	int	dirblocklog;
+	int	inodesize;
+	int	inopblock;
+	int	imaxpct;
+	int	lsectorsize;
+	uuid_t	uuid;
+
+	/* feature flags that are set */
+	struct sb_feat_args	sb_feat;
+
+	/* root inode characteristics */
+	struct fsxattr		fsx;
+
+	/* libxfs device setup */
+	struct libxfs_xinit	*xi;
+};
+
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
 #define MEGABYTES(count, blog)	((uint64_t)(count) << (20 - (blog)))
@@ -1150,23 +1240,6 @@ discard_blocks(dev_t dev, uint64_t nsectors)
 		platform_discard_blocks(fd, 0, nsectors << 9);
 }
 
-struct sb_feat_args {
-	int	log_version;
-	int	attr_version;
-	int	dir_version;
-	int	spinodes;
-	int	finobt;
-	bool	inode_align;
-	bool	nci;
-	bool	lazy_sb_counters;
-	bool	projid16bit;
-	bool	crcs_enabled;
-	bool	dirftype;
-	bool	parent_pointers;
-	bool	rmapbt;
-	bool	reflink;
-};
-
 static void
 sb_set_features(
 	struct xfs_sb		*sbp,
-- 
2.13.3

