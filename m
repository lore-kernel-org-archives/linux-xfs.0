Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:55482 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751887AbdH2XvG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:06 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0002dw-Dd
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0005XB-CX
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 38/42] mkfs: factor initial mount setup
Date: Wed, 30 Aug 2017 09:50:48 +1000
Message-Id: <20170829235052.21050-39-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 265 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 141 insertions(+), 124 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index ae6514cb0a1f..3fc485524d99 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1223,96 +1223,6 @@ discard_blocks(dev_t dev, uint64_t nsectors)
 		platform_discard_blocks(fd, 0, nsectors << 9);
 }
 
-static void
-sb_set_features(
-	struct xfs_sb		*sbp,
-	struct sb_feat_args	*fp,
-	int			sectsize,
-	int			lsectsize,
-	int			dsunit)
-{
-
-	sbp->sb_versionnum = XFS_DFL_SB_VERSION_BITS;
-	if (fp->crcs_enabled)
-		sbp->sb_versionnum |= XFS_SB_VERSION_5;
-	else
-		sbp->sb_versionnum |= XFS_SB_VERSION_4;
-
-	if (fp->inode_align)
-		sbp->sb_versionnum |= XFS_SB_VERSION_ALIGNBIT;
-	if (dsunit)
-		sbp->sb_versionnum |= XFS_SB_VERSION_DALIGNBIT;
-	if (fp->log_version == 2)
-		sbp->sb_versionnum |= XFS_SB_VERSION_LOGV2BIT;
-	if (fp->attr_version == 1)
-		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
-	if (sectsize > BBSIZE || lsectsize > BBSIZE)
-		sbp->sb_versionnum |= XFS_SB_VERSION_SECTORBIT;
-	if (fp->nci)
-		sbp->sb_versionnum |= XFS_SB_VERSION_BORGBIT;
-
-
-	sbp->sb_features2 = 0;
-	if (fp->lazy_sb_counters)
-		sbp->sb_features2 |= XFS_SB_VERSION2_LAZYSBCOUNTBIT;
-	if (!fp->projid16bit)
-		sbp->sb_features2 |= XFS_SB_VERSION2_PROJID32BIT;
-	if (fp->parent_pointers)
-		sbp->sb_features2 |= XFS_SB_VERSION2_PARENTBIT;
-	if (fp->crcs_enabled)
-		sbp->sb_features2 |= XFS_SB_VERSION2_CRCBIT;
-	if (fp->attr_version == 2)
-		sbp->sb_features2 |= XFS_SB_VERSION2_ATTR2BIT;
-
-	/* v5 superblocks have their own feature bit for dirftype */
-	if (fp->dirftype && !fp->crcs_enabled)
-		sbp->sb_features2 |= XFS_SB_VERSION2_FTYPE;
-
-	/* update whether extended features are in use */
-	if (sbp->sb_features2 != 0)
-		sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
-
-	/*
-	 * Due to a structure alignment issue, sb_features2 ended up in one
-	 * of two locations, the second "incorrect" location represented by
-	 * the sb_bad_features2 field. To avoid older kernels mounting
-	 * filesystems they shouldn't, set both field to the same value.
-	 */
-	sbp->sb_bad_features2 = sbp->sb_features2;
-
-	if (!fp->crcs_enabled)
-		return;
-
-	/* default features for v5 filesystems */
-	sbp->sb_features_compat = 0;
-	sbp->sb_features_ro_compat = 0;
-	sbp->sb_features_incompat = XFS_SB_FEAT_INCOMPAT_FTYPE;
-	sbp->sb_features_log_incompat = 0;
-
-	if (fp->finobt)
-		sbp->sb_features_ro_compat = XFS_SB_FEAT_RO_COMPAT_FINOBT;
-	if (fp->rmapbt)
-		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
-	if (fp->reflink)
-		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
-
-	/*
-	 * Sparse inode chunk support has two main inode alignment requirements.
-	 * First, sparse chunk alignment must match the cluster size. Second,
-	 * full chunk alignment must match the inode chunk size.
-	 *
-	 * Copy the already calculated/scaled inoalignmt to spino_align and
-	 * update the former to the full inode chunk size.
-	 */
-	if (fp->spinodes) {
-		sbp->sb_spino_align = sbp->sb_inoalignmt;
-		sbp->sb_inoalignmt = XFS_INODES_PER_CHUNK *
-			sbp->sb_inodesize >> sbp->sb_blocklog;
-		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_SPINODES;
-	}
-
-}
-
 static __attribute__((noreturn)) void
 illegal_option(
 	const char		*value,
@@ -2868,6 +2778,137 @@ calculate_imaxpct(
 		cfg->imaxpct = 1;
 }
 
+/*
+ * Set up the initial state of the superblock so we can start using the
+ * libxfs geometry macros.
+ */
+static void
+sb_set_features(
+	struct mkfs_params	*cfg,
+	struct xfs_sb		*sbp)
+{
+	struct sb_feat_args	*fp = &cfg->sb_feat;
+
+	sbp->sb_versionnum = XFS_DFL_SB_VERSION_BITS;
+	if (fp->crcs_enabled)
+		sbp->sb_versionnum |= XFS_SB_VERSION_5;
+	else
+		sbp->sb_versionnum |= XFS_SB_VERSION_4;
+
+	if (fp->inode_align) {
+		int     cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
+
+		sbp->sb_versionnum |= XFS_SB_VERSION_ALIGNBIT;
+		if (cfg->sb_feat.crcs_enabled)
+			cluster_size *= cfg->inodesize / XFS_DINODE_MIN_SIZE;
+		sbp->sb_inoalignmt = cluster_size >> cfg->blocklog;
+	} else
+		sbp->sb_inoalignmt = 0;
+
+	if (cfg->dsunit)
+		sbp->sb_versionnum |= XFS_SB_VERSION_DALIGNBIT;
+	if (fp->log_version == 2)
+		sbp->sb_versionnum |= XFS_SB_VERSION_LOGV2BIT;
+	if (fp->attr_version == 1)
+		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
+	if (fp->nci)
+		sbp->sb_versionnum |= XFS_SB_VERSION_BORGBIT;
+
+	if (cfg->sectorsize > BBSIZE || cfg->lsectorsize > BBSIZE) {
+		sbp->sb_versionnum |= XFS_SB_VERSION_SECTORBIT;
+		sbp->sb_logsectlog = (uint8_t)cfg->lsectorlog;
+		sbp->sb_logsectsize = (uint16_t)cfg->lsectorsize;
+	} else {
+		sbp->sb_logsectlog = 0;
+		sbp->sb_logsectsize = 0;
+	}
+
+	sbp->sb_features2 = 0;
+	if (fp->lazy_sb_counters)
+		sbp->sb_features2 |= XFS_SB_VERSION2_LAZYSBCOUNTBIT;
+	if (!fp->projid16bit)
+		sbp->sb_features2 |= XFS_SB_VERSION2_PROJID32BIT;
+	if (fp->parent_pointers)
+		sbp->sb_features2 |= XFS_SB_VERSION2_PARENTBIT;
+	if (fp->crcs_enabled)
+		sbp->sb_features2 |= XFS_SB_VERSION2_CRCBIT;
+	if (fp->attr_version == 2)
+		sbp->sb_features2 |= XFS_SB_VERSION2_ATTR2BIT;
+
+	/* v5 superblocks have their own feature bit for dirftype */
+	if (fp->dirftype && !fp->crcs_enabled)
+		sbp->sb_features2 |= XFS_SB_VERSION2_FTYPE;
+
+	/* update whether extended features are in use */
+	if (sbp->sb_features2 != 0)
+		sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
+
+	/*
+	 * Due to a structure alignment issue, sb_features2 ended up in one
+	 * of two locations, the second "incorrect" location represented by
+	 * the sb_bad_features2 field. To avoid older kernels mounting
+	 * filesystems they shouldn't, set both field to the same value.
+	 */
+	sbp->sb_bad_features2 = sbp->sb_features2;
+
+	if (!fp->crcs_enabled)
+		return;
+
+	/* default features for v5 filesystems */
+	sbp->sb_features_compat = 0;
+	sbp->sb_features_ro_compat = 0;
+	sbp->sb_features_incompat = XFS_SB_FEAT_INCOMPAT_FTYPE;
+	sbp->sb_features_log_incompat = 0;
+
+	if (fp->finobt)
+		sbp->sb_features_ro_compat = XFS_SB_FEAT_RO_COMPAT_FINOBT;
+	if (fp->rmapbt)
+		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
+	if (fp->reflink)
+		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
+
+	/*
+	 * Sparse inode chunk support has two main inode alignment requirements.
+	 * First, sparse chunk alignment must match the cluster size. Second,
+	 * full chunk alignment must match the inode chunk size.
+	 *
+	 * Copy the already calculated/scaled inoalignmt to spino_align and
+	 * update the former to the full inode chunk size.
+	 */
+	if (fp->spinodes) {
+		sbp->sb_spino_align = sbp->sb_inoalignmt;
+		sbp->sb_inoalignmt = XFS_INODES_PER_CHUNK *
+				cfg->inodesize >> cfg->blocklog;
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_SPINODES;
+	}
+
+}
+
+/*
+ * Set up mount and superblock with the minimum parameters required for
+ * the libxfs macros needed by the log sizing code to run successfully.
+ */
+static void
+initialise_mount(
+	struct mkfs_params	*cfg,
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp)
+{
+	sbp->sb_blocklog = (uint8_t)cfg->blocklog;
+	sbp->sb_sectlog = (uint8_t)cfg->sectorlog;
+	sbp->sb_agblklog = (uint8_t)libxfs_log2_roundup(cfg->agsize);
+	sbp->sb_agblocks = (xfs_agblock_t)cfg->agsize;
+	sbp->sb_agcount = (xfs_agnumber_t)cfg->agcount;
+	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
+	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
+
+	/*
+	 * sb_versionnum, finobt and rmapbt flags must be set before we use
+	 * libxfs_prealloc_blocks().
+	 */
+	sb_set_features(cfg, sbp);
+}
+
 static void
 print_mkfs_cfg(
 	struct mkfs_params	*cfg,
@@ -2963,21 +3004,6 @@ setup_superblock(
 	} else
 		sbp->sb_logsunit = 0;
 
-	if (cfg->sb_feat.inode_align) {
-		int	cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
-		if (cfg->sb_feat.crcs_enabled)
-			cluster_size *= cfg->inodesize / XFS_DINODE_MIN_SIZE;
-		sbp->sb_inoalignmt = cluster_size >> cfg->blocklog;
-	} else
-		sbp->sb_inoalignmt = 0;
-
-	if (cfg->lsectorsize != BBSIZE || cfg->sectorsize != BBSIZE) {
-		sbp->sb_logsectlog = (uint8_t)cfg->lsectorlog;
-		sbp->sb_logsectsize = (uint16_t)cfg->lsectorsize;
-	} else {
-		sbp->sb_logsectlog = 0;
-		sbp->sb_logsectsize = 0;
-	}
 }
 
 /*
@@ -3525,8 +3551,6 @@ main(
 	int			lsectorsize;
 	int			lsunit;
 	int			min_logblocks;
-	xfs_mount_t		*mp;
-	xfs_mount_t		mbuf;
 	xfs_extlen_t		nbmblocks;
 	int			dry_run = 0;
 	int			discard = 1;
@@ -3537,11 +3561,13 @@ main(
 	xfs_extlen_t		rtextblocks;
 	xfs_rtblock_t		rtextents;
 	char			*rtfile;
-	xfs_sb_t		*sbp;
 	int			sectorlog;
 	uuid_t			uuid;
 	int			worst_freelist;
 	libxfs_init_t		xi;
+	struct xfs_mount	mbuf = {};
+	struct xfs_mount	*mp = &mbuf;
+	struct xfs_sb		*sbp = &mp->m_sb;
 	struct fs_topology	ft;
 	struct sb_feat_args	sb_feat;
 	/* build time defaults */
@@ -3742,6 +3768,13 @@ main(
 
 	calculate_imaxpct(&cfg, &cli);
 
+	/*
+	 * Set up the basic superblock parameters now so that we can use
+	 * the geometry information we've already validated in libxfs
+	 * provided functions to determine on-disk format information.
+	 */
+	initialise_mount(&cfg, mp, sbp);
+
 	/* temp don't break code */
 	sectorsize = cfg.sectorsize;
 	sectorlog = cfg.sectorlog;
@@ -3821,22 +3854,6 @@ main(
 	validate_log_size(logblocks, blocklog, min_logblocks);
 
 	protostring = setup_proto(protofile);
-	mp = &mbuf;
-	sbp = &mp->m_sb;
-	memset(mp, 0, sizeof(xfs_mount_t));
-	sbp->sb_blocklog = (uint8_t)blocklog;
-	sbp->sb_sectlog = (uint8_t)sectorlog;
-	sbp->sb_agblklog = (uint8_t)libxfs_log2_roundup((unsigned int)agsize);
-	sbp->sb_agblocks = (xfs_agblock_t)agsize;
-	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
-	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
-
-	/*
-	 * sb_versionnum, finobt and rmapbt flags must be set before we use
-	 * libxfs_prealloc_blocks().
-	 */
-	sb_set_features(&mp->m_sb, &sb_feat, sectorsize, lsectorsize, dsunit);
-
 
 	if (loginternal) {
 		/*
-- 
2.13.3

