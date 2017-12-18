Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:51060 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758231AbdLRJMM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Dec 2017 04:12:12 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1eQrSr-0002ss-Mr
        for linux-xfs@vger.kernel.org; Mon, 18 Dec 2017 20:12:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1eQrSr-0003qL-Lk
        for linux-xfs@vger.kernel.org; Mon, 18 Dec 2017 20:12:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/7] mkfs: simplify minimum log size calculation
Date: Mon, 18 Dec 2017 20:11:53 +1100
Message-Id: <20171218091158.14537-3-david@fromorbit.com>
In-Reply-To: <20171218091158.14537-1-david@fromorbit.com>
References: <20171218091158.14537-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

mkfs jumps through hoops to call libxfs_log_calc_minimum_size() to
set the minimum log size. We already have a xfs_mount at this point,
we just need to set the superblock up slightly earlier and then mkfs
can call libxfs_log_calc_minimum_size() directly. This means we can
remove mkfs/maxtrres.c completely.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_multidisk.h |   6 ---
 mkfs/Makefile           |   2 +-
 mkfs/maxtrres.c         | 102 ------------------------------------------------
 mkfs/xfs_mkfs.c         |  94 ++++++++++++++++++++++++--------------------
 4 files changed, 52 insertions(+), 152 deletions(-)
 delete mode 100644 mkfs/maxtrres.c

diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
index e5f53b7ea065..7482d14a9474 100644
--- a/include/xfs_multidisk.h
+++ b/include/xfs_multidisk.h
@@ -65,10 +65,4 @@ extern char *setup_proto (char *fname);
 extern void parse_proto (xfs_mount_t *mp, struct fsxattr *fsx, char **pp);
 extern void res_failed (int err);
 
-/* maxtrres.c */
-extern int max_trans_res(unsigned long agsize, int crcs_enabled, int dirversion,
-		int sectorlog, int blocklog, int inodelog, int dirblocklog,
-		int logversion, int log_sunit, int finobt, int rmapbt,
-		int reflink, int inode_align);
-
 #endif	/* __XFS_MULTIDISK_H__ */
diff --git a/mkfs/Makefile b/mkfs/Makefile
index e2dc1d4f4711..c84f9b6ae63b 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = mkfs.xfs
 
 HFILES =
-CFILES = maxtrres.c proto.c xfs_mkfs.c
+CFILES = proto.c xfs_mkfs.c
 
 LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
 	$(LIBUUID)
diff --git a/mkfs/maxtrres.c b/mkfs/maxtrres.c
deleted file mode 100644
index 0fa18c8f2714..000000000000
--- a/mkfs/maxtrres.c
+++ /dev/null
@@ -1,102 +0,0 @@
-/*
- * Copyright (c) 2000-2001,2004-2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-/*
- * maxtrres.c
- *
- * Compute the maximum transaction reservation for a legal combination
- * of sector size, block size, inode size, directory version, and
- * directory block size.
- */
-#include "libfrog.h"
-#include "libxfs.h"
-#include "xfs_multidisk.h"
-
-int
-max_trans_res(
-	unsigned long	agsize,
-	int		crcs_enabled,
-	int		dirversion,
-	int		sectorlog,
-	int		blocklog,
-	int		inodelog,
-	int		dirblocklog,
-	int		logversion,
-	int		log_sunit,
-	int		finobt,
-	int		rmapbt,
-	int		reflink,
-	int		inode_align)
-{
-	xfs_sb_t	*sbp;
-	xfs_mount_t	mount;
-	int		maxfsb;
-
-	memset(&mount, 0, sizeof(mount));
-	sbp = &mount.m_sb;
-	sbp->sb_magicnum = XFS_SB_MAGIC;
-	sbp->sb_sectlog = sectorlog;
-	sbp->sb_sectsize = 1 << sbp->sb_sectlog;
-	sbp->sb_blocklog = blocklog;
-	sbp->sb_blocksize = 1 << blocklog;
-	sbp->sb_agblocks = agsize;
-	sbp->sb_agblklog = (uint8_t)log2_roundup((unsigned int)agsize);
-	sbp->sb_inodelog = inodelog;
-	sbp->sb_inopblog = blocklog - inodelog;
-	sbp->sb_inodesize = 1 << inodelog;
-	sbp->sb_inopblock = 1 << (blocklog - inodelog);
-	sbp->sb_dirblklog = dirblocklog - blocklog;
-
-	if (inode_align) {
-		int	cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
-		if (crcs_enabled)
-			cluster_size *= sbp->sb_inodesize / XFS_DINODE_MIN_SIZE;
-		sbp->sb_inoalignmt = cluster_size >> blocklog;
-	}
-
-	if (log_sunit > 0) {
-		log_sunit <<= blocklog;
-		logversion = 2;
-	} else
-		log_sunit = 1;
-	sbp->sb_logsunit = log_sunit;
-
-	sbp->sb_versionnum =
-			(crcs_enabled ? XFS_SB_VERSION_5 : XFS_SB_VERSION_4) |
-			(dirversion == 2 ? XFS_SB_VERSION_DIRV2BIT : 0) |
-			(logversion > 1 ? XFS_SB_VERSION_LOGV2BIT : 0) |
-			XFS_DFL_SB_VERSION_BITS;
-	if (finobt)
-		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_FINOBT;
-	if (rmapbt)
-		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
-	if (reflink)
-		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
-
-	libxfs_mount(&mount, sbp, 0,0,0,0);
-	maxfsb = libxfs_log_calc_minimum_size(&mount);
-	libxfs_umount(&mount);
-
-#if 0
-	printf("#define\tMAXTRRES_S%d_B%d_I%d_D%d_V%d_LSU%d\t%d\n",
-		sectorlog, blocklog, inodelog, dirblocklog, dirversion,
-		log_sunit, maxfsb);
-#endif
-
-	return maxfsb;
-}
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f79062da4ff4..4a9c457ce603 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3051,16 +3051,16 @@ calculate_log_size(
 	struct cli_params	*cli,
 	struct xfs_mount	*mp)
 {
-	struct sb_feat_args	*fp = &cfg->sb_feat;
 	struct xfs_sb		*sbp = &mp->m_sb;
 	int			min_logblocks;
+	struct xfs_mount	mount;
 
-	min_logblocks = max_trans_res(sbp->sb_agblocks, fp->crcs_enabled,
-				      fp->dir_version, cfg->sectorlog,
-				      cfg->blocklog, cfg->inodelog,
-				      cfg->dirblocklog, fp->log_version,
-				      cfg->lsunit, fp->finobt, fp->rmapbt,
-				      fp->reflink, fp->inode_align);
+	/* we need a temporary mount to calculate the minimum log size. */
+	memset(&mount, 0, sizeof(mount));
+	mount.m_sb = *sbp;
+	libxfs_mount(&mount, &mp->m_sb, 0, 0, 0, 0);
+	min_logblocks = libxfs_log_calc_minimum_size(&mount);
+	libxfs_umount(&mount);
 
 	ASSERT(min_logblocks);
 	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
@@ -3175,28 +3175,60 @@ _("log ag number %lld too large, must be less than %lld\n"),
 }
 
 /*
- * Set up mount and superblock with the minimum parameters required for
+ * Set up superblock with the minimum parameters required for
  * the libxfs macros needed by the log sizing code to run successfully.
+ * This includes a minimum log size calculation, so we need everything
+ * that goes into that calculation to be setup here including feature
+ * flags.
  */
 static void
-initialise_mount(
+start_superblock_setup(
 	struct mkfs_params	*cfg,
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
-	sbp->sb_blocklog = (uint8_t)cfg->blocklog;
+	sbp->sb_magicnum = XFS_SB_MAGIC;
+	sbp->sb_sectsize = (uint16_t)cfg->sectorsize;
 	sbp->sb_sectlog = (uint8_t)cfg->sectorlog;
-	sbp->sb_agblklog = (uint8_t)log2_roundup(cfg->agsize);
+	sbp->sb_blocksize = cfg->blocksize;
+	sbp->sb_blocklog = (uint8_t)cfg->blocklog;
+
 	sbp->sb_agblocks = (xfs_agblock_t)cfg->agsize;
+	sbp->sb_agblklog = (uint8_t)log2_roundup(cfg->agsize);
 	sbp->sb_agcount = (xfs_agnumber_t)cfg->agcount;
-	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
-	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
+
+	sbp->sb_inodesize = (uint16_t)cfg->inodesize;
+	sbp->sb_inodelog = (uint8_t)cfg->inodelog;
+	sbp->sb_inopblock = (uint16_t)(cfg->blocksize / cfg->inodesize);
+	sbp->sb_inopblog = (uint8_t)(cfg->blocklog - cfg->inodelog);
+
+	sbp->sb_dirblklog = cfg->dirblocklog - cfg->blocklog;
+
+	sb_set_features(cfg, sbp);
 
 	/*
-	 * sb_versionnum, finobt and rmapbt flags must be set before we use
-	 * libxfs_prealloc_blocks().
+	 * log stripe unit is stored in bytes on disk and cannot be zero
+	 * for v2 logs.
 	 */
-	sb_set_features(cfg, sbp);
+	if (cfg->sb_feat.log_version == 2) {
+		if (cfg->lsunit)
+			sbp->sb_logsunit = XFS_FSB_TO_B(mp, cfg->lsunit);
+		else
+			sbp->sb_logsunit = 1;
+	} else
+		sbp->sb_logsunit = 0;
+
+}
+
+static void
+initialise_mount(
+	struct mkfs_params	*cfg,
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp)
+{
+	/* Minimum needed for libxfs_prealloc_blocks() */
+	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
+	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
 }
 
 static void
@@ -3239,7 +3271,7 @@ print_mkfs_cfg(
  * copy, so no need to care about endian swapping here.
  */
 static void
-setup_superblock(
+finish_superblock_setup(
 	struct mkfs_params	*cfg,
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
@@ -3247,8 +3279,6 @@ setup_superblock(
 	if (cfg->label)
 		strncpy(sbp->sb_fname, cfg->label, sizeof(sbp->sb_fname));
 
-	sbp->sb_magicnum = XFS_SB_MAGIC;
-	sbp->sb_blocksize = cfg->blocksize;
 	sbp->sb_dblocks = cfg->dblocks;
 	sbp->sb_rblocks = cfg->rtblocks;
 	sbp->sb_rextents = cfg->rtextents;
@@ -3261,12 +3291,6 @@ setup_superblock(
 	sbp->sb_agcount = (xfs_agnumber_t)cfg->agcount;
 	sbp->sb_rbmblocks = cfg->rtbmblocks;
 	sbp->sb_logblocks = (xfs_extlen_t)cfg->logblocks;
-	sbp->sb_sectsize = (uint16_t)cfg->sectorsize;
-	sbp->sb_inodesize = (uint16_t)cfg->inodesize;
-	sbp->sb_inopblock = (uint16_t)(cfg->blocksize / cfg->inodesize);
-	sbp->sb_sectlog = (uint8_t)cfg->sectorlog;
-	sbp->sb_inodelog = (uint8_t)cfg->inodelog;
-	sbp->sb_inopblog = (uint8_t)(cfg->blocklog - cfg->inodelog);
 	sbp->sb_rextslog = (uint8_t)(cfg->rtextents ?
 			libxfs_highbit32((unsigned int)cfg->rtextents) : 0);
 	sbp->sb_inprogress = 1;	/* mkfs is in progress */
@@ -3281,19 +3305,6 @@ setup_superblock(
 	sbp->sb_qflags = 0;
 	sbp->sb_unit = cfg->dsunit;
 	sbp->sb_width = cfg->dswidth;
-	sbp->sb_dirblklog = cfg->dirblocklog - cfg->blocklog;
-
-	/*
-	 * log stripe unit is stored in bytes on disk and cannot be zero
-	 * for v2 logs.
-	 */
-	if (cfg->sb_feat.log_version == 2) {
-		if (cfg->lsunit)
-			sbp->sb_logsunit = XFS_FSB_TO_B(mp, cfg->lsunit);
-		else
-			sbp->sb_logsunit = 1;
-	} else
-		sbp->sb_logsunit = 0;
 
 }
 
@@ -4004,6 +4015,7 @@ main(
 	 * the geometry information we've already validated in libxfs
 	 * provided functions to determine on-disk format information.
 	 */
+	start_superblock_setup(&cfg, mp, sbp);
 	initialise_mount(&cfg, mp, sbp);
 
 	/*
@@ -4019,11 +4031,7 @@ main(
 		if (dry_run)
 			exit(0);
 	}
-
-	/*
-	 * Finish setting up the superblock state ready for formatting.
-	 */
-	setup_superblock(&cfg, mp, sbp);
+	finish_superblock_setup(&cfg, mp, sbp);
 
 	/*
 	 * we need the libxfs buffer cache from here on in.
-- 
2.15.0

