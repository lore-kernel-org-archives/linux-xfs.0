Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:55482 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751937AbdH2XvJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:09 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002cn-PW
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005W4-OR
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/42] mkfs: factor in memory superblock setup
Date: Wed, 30 Aug 2017 09:50:25 +1000
Message-Id: <20170829235052.21050-16-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 141 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 82 insertions(+), 59 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4c67062047d9..0e115bf3cf4d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1915,6 +1915,84 @@ print_mkfs_cfg(
 			(long long)cfg->rtblocks, (long long)cfg->rtextents);
 }
 
+/*
+ * Format everything from the generated config into the superblock that
+ * will be used to initialise the on-disk superblock. This is the in-memory
+ * copy, so no need to care about endian swapping here.
+ */
+static void
+setup_superblock(
+	struct mkfs_params	*cfg,
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp)
+{
+	if (cfg->label)
+		strncpy(sbp->sb_fname, cfg->label, sizeof(sbp->sb_fname));
+
+	sbp->sb_magicnum = XFS_SB_MAGIC;
+	sbp->sb_blocksize = cfg->blocksize;
+	sbp->sb_dblocks = cfg->dblocks;
+	sbp->sb_rblocks = cfg->rtblocks;
+	sbp->sb_rextents = cfg->rtextents;
+	platform_uuid_copy(&sbp->sb_uuid, &cfg->uuid);
+	/* Only in memory; libxfs expects this as if read from disk */
+	platform_uuid_copy(&sbp->sb_meta_uuid, &cfg->uuid);
+	sbp->sb_logstart = cfg->logstart;
+	sbp->sb_rootino = sbp->sb_rbmino = sbp->sb_rsumino = NULLFSINO;
+	sbp->sb_rextsize = cfg->rtextblocks;
+	sbp->sb_agcount = (xfs_agnumber_t)cfg->agcount;
+	sbp->sb_rbmblocks = cfg->rtbmblocks;
+	sbp->sb_logblocks = (xfs_extlen_t)cfg->logblocks;
+	sbp->sb_sectsize = (uint16_t)cfg->sectorsize;
+	sbp->sb_inodesize = (uint16_t)cfg->inodesize;
+	sbp->sb_inopblock = (uint16_t)(cfg->blocksize / cfg->inodesize);
+	sbp->sb_sectlog = (uint8_t)cfg->sectorlog;
+	sbp->sb_inodelog = (uint8_t)cfg->inodelog;
+	sbp->sb_inopblog = (uint8_t)(cfg->blocklog - cfg->inodelog);
+	sbp->sb_rextslog = (uint8_t)(cfg->rtextents ?
+			libxfs_highbit32((unsigned int)cfg->rtextents) : 0);
+	sbp->sb_inprogress = 1;	/* mkfs is in progress */
+	sbp->sb_imax_pct = cfg->imaxpct;
+	sbp->sb_icount = 0;
+	sbp->sb_ifree = 0;
+	sbp->sb_fdblocks = cfg->dblocks -
+			   cfg->agcount * libxfs_prealloc_blocks(mp) -
+			   (cfg->loginternal ? cfg->logblocks : 0);
+	sbp->sb_frextents = 0;	/* will do a free later */
+	sbp->sb_uquotino = sbp->sb_gquotino = sbp->sb_pquotino = 0;
+	sbp->sb_qflags = 0;
+	sbp->sb_unit = cfg->dsunit;
+	sbp->sb_width = cfg->dswidth;
+	sbp->sb_dirblklog = cfg->dirblocklog - cfg->blocklog;
+
+	/*
+	 * log stripe unit is stored in bytes on disk and cannot be zero
+	 * for v2 logs.
+	 */
+	if (cfg->sb_feat.log_version == 2) {
+		int	lsunit = (cfg->lsunit == 0) ? 1 : cfg->lsunit;
+
+		sbp->sb_logsunit = XFS_FSB_TO_B(mp, lsunit);;
+	} else
+		sbp->sb_logsunit = 0;
+
+	if (cfg->sb_feat.inode_align) {
+		int	cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
+		if (cfg->sb_feat.crcs_enabled)
+			cluster_size *= cfg->inodesize / XFS_DINODE_MIN_SIZE;
+		sbp->sb_inoalignmt = cluster_size >> cfg->blocklog;
+	} else
+		sbp->sb_inoalignmt = 0;
+
+	if (cfg->lsectorsize != BBSIZE || cfg->sectorsize != BBSIZE) {
+		sbp->sb_logsectlog = (uint8_t)cfg->lsectorlog;
+		sbp->sb_logsectsize = (uint16_t)cfg->lsectorsize;
+	} else {
+		sbp->sb_logsectlog = 0;
+		sbp->sb_logsectsize = 0;
+	}
+}
+
 int
 main(
 	int			argc,
@@ -3091,65 +3169,10 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			exit(0);
 	}
 
-	if (label)
-		strncpy(sbp->sb_fname, label, sizeof(sbp->sb_fname));
-	sbp->sb_magicnum = XFS_SB_MAGIC;
-	sbp->sb_blocksize = blocksize;
-	sbp->sb_dblocks = dblocks;
-	sbp->sb_rblocks = rtblocks;
-	sbp->sb_rextents = rtextents;
-	platform_uuid_copy(&sbp->sb_uuid, &uuid);
-	/* Only in memory; libxfs expects this as if read from disk */
-	platform_uuid_copy(&sbp->sb_meta_uuid, &uuid);
-	sbp->sb_logstart = logstart;
-	sbp->sb_rootino = sbp->sb_rbmino = sbp->sb_rsumino = NULLFSINO;
-	sbp->sb_rextsize = rtextblocks;
-	sbp->sb_agcount = (xfs_agnumber_t)agcount;
-	sbp->sb_rbmblocks = nbmblocks;
-	sbp->sb_logblocks = (xfs_extlen_t)logblocks;
-	sbp->sb_sectsize = (uint16_t)sectorsize;
-	sbp->sb_inodesize = (uint16_t)isize;
-	sbp->sb_inopblock = (uint16_t)(blocksize / isize);
-	sbp->sb_sectlog = (uint8_t)sectorlog;
-	sbp->sb_inodelog = (uint8_t)inodelog;
-	sbp->sb_inopblog = (uint8_t)(blocklog - inodelog);
-	sbp->sb_rextslog =
-		(uint8_t)(rtextents ?
-			libxfs_highbit32((unsigned int)rtextents) : 0);
-	sbp->sb_inprogress = 1;	/* mkfs is in progress */
-	sbp->sb_imax_pct = imaxpct;
-	sbp->sb_icount = 0;
-	sbp->sb_ifree = 0;
-	sbp->sb_fdblocks = dblocks - agcount * libxfs_prealloc_blocks(mp) -
-		(loginternal ? logblocks : 0);
-	sbp->sb_frextents = 0;	/* will do a free later */
-	sbp->sb_uquotino = sbp->sb_gquotino = sbp->sb_pquotino = 0;
-	sbp->sb_qflags = 0;
-	sbp->sb_unit = dsunit;
-	sbp->sb_width = dswidth;
-	sbp->sb_dirblklog = dirblocklog - blocklog;
-	if (sb_feat.log_version == 2) {	/* This is stored in bytes */
-		lsunit = (lsunit == 0) ? 1 : XFS_FSB_TO_B(mp, lsunit);
-		sbp->sb_logsunit = lsunit;
-	} else
-		sbp->sb_logsunit = 0;
-	if (sb_feat.inode_align) {
-		int	cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
-		if (sb_feat.crcs_enabled)
-			cluster_size *= isize / XFS_DINODE_MIN_SIZE;
-		sbp->sb_inoalignmt = cluster_size >> blocklog;
-		sb_feat.inode_align = sbp->sb_inoalignmt != 0;
-	} else
-		sbp->sb_inoalignmt = 0;
-	if (lsectorsize != BBSIZE || sectorsize != BBSIZE) {
-		sbp->sb_logsectlog = (uint8_t)lsectorlog;
-		sbp->sb_logsectsize = (uint16_t)lsectorsize;
-	} else {
-		sbp->sb_logsectlog = 0;
-		sbp->sb_logsectsize = 0;
-	}
-
-	sb_set_features(&mp->m_sb, &sb_feat, sectorsize, lsectorsize, dsunit);
+	/*
+	 * Finish setting up the superblock state ready for formatting.
+	 */
+	setup_superblock(&cfg, mp, sbp);
 
 	if (force_overwrite)
 		zero_old_xfs_structures(&xi, sbp);
-- 
2.13.3

