Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:39951 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726021AbeHTIDQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Aug 2018 04:03:16 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0006S9-89
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0000QP-7A
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/10] xfs: convert xfs_fs_geometry to use mount feature checks
Date: Mon, 20 Aug 2018 14:48:48 +1000
Message-Id: <20180820044851.414-8-david@fromorbit.com>
In-Reply-To: <20180820044851.414-1-david@fromorbit.com>
References: <20180820044851.414-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Reporting filesystem features to userspace is currently superblock
based. Now we have a general mount-based feature infrastructure,
switch to using the xfs_mount rather than the superblock directly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c | 44 ++++++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_sb.h |  2 +-
 fs/xfs/xfs_ioctl.c     |  4 ++--
 fs/xfs/xfs_ioctl32.c   |  2 +-
 4 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index ee4d483e1209..bedf6c6bf990 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1144,10 +1144,12 @@ xfs_sync_sb_buf(
 
 int
 xfs_fs_geometry(
-	struct xfs_sb		*sbp,
+	struct xfs_mount	*mp,
 	struct xfs_fsop_geom	*geo,
 	int			struct_version)
 {
+	struct xfs_sb		*sbp = &mp->m_sb;
+
 	memset(geo, 0, sizeof(struct xfs_fsop_geom));
 
 	geo->blocksize = sbp->sb_blocksize;
@@ -1177,49 +1179,49 @@ xfs_fs_geometry(
 	geo->version = XFS_FSOP_GEOM_VERSION;
 	geo->flags = XFS_FSOP_GEOM_FLAGS_NLINK |
 		     XFS_FSOP_GEOM_FLAGS_DIRV2;
-	if (xfs_sb_version_hasattr(sbp))
+	if (xfs_has_attr(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATTR;
-	if (xfs_sb_version_hasquota(sbp))
+	if (xfs_has_quota(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_QUOTA;
-	if (xfs_sb_version_hasalign(sbp))
+	if (xfs_has_align(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_IALIGN;
-	if (xfs_sb_version_hasdalign(sbp))
+	if (xfs_has_dalign(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_DALIGN;
-	if (xfs_sb_version_hasextflg(sbp))
+	if (xfs_has_extflg(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_EXTFLG;
-	if (xfs_sb_version_hassector(sbp))
-		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
-	if (xfs_sb_version_hasasciici(sbp))
+	if (xfs_has_asciici(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_DIRV2CI;
-	if (xfs_sb_version_haslazysbcount(sbp))
+	if (xfs_has_lazysbcount(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_LAZYSB;
-	if (xfs_sb_version_hasattr2(sbp))
+	if (xfs_has_attr2(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATTR2;
-	if (xfs_sb_version_hasprojid32(sbp))
+	if (xfs_has_projid32(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_PROJID32;
-	if (xfs_sb_version_hascrc(sbp))
+	if (xfs_has_crc(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_V5SB;
-	if (xfs_sb_version_hasftype(sbp))
+	if (xfs_has_ftype(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_FTYPE;
-	if (xfs_sb_version_hasfinobt(sbp))
+	if (xfs_has_finobt(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_FINOBT;
-	if (xfs_sb_version_hassparseinodes(sbp))
+	if (xfs_has_sparseinodes(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_SPINODES;
-	if (xfs_sb_version_hasrmapbt(sbp))
+	if (xfs_has_rmapbt(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_RMAPBT;
-	if (xfs_sb_version_hasreflink(sbp))
+	if (xfs_has_reflink(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_REFLINK;
-	if (xfs_sb_version_hassector(sbp))
+	if (xfs_has_sector(mp)) {
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
 		geo->logsectsize = sbp->sb_logsectsize;
-	else
+	} else {
 		geo->logsectsize = BBSIZE;
+	}
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
 	if (struct_version < 4)
 		return 0;
 
-	if (xfs_sb_version_haslogv2(sbp))
+	if (xfs_has_logv2(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_LOGV2;
 
 	geo->logsunit = sbp->sb_logsunit;
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 640a438402aa..8f4cbe2b639c 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -34,7 +34,7 @@ extern uint64_t	xfs_sb_version_to_features(struct xfs_sb *sbp);
 extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);
 
 #define XFS_FS_GEOM_MAX_STRUCT_VER	(4)
-extern int	xfs_fs_geometry(struct xfs_sb *sbp, struct xfs_fsop_geom *geo,
+extern int	xfs_fs_geometry(struct xfs_mount *mp, struct xfs_fsop_geom *geo,
 				int struct_version);
 extern int	xfs_sb_read_secondary(struct xfs_mount *mp,
 				struct xfs_trans *tp, xfs_agnumber_t agno,
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6238b6bb7653..8071a297bb44 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -794,7 +794,7 @@ xfs_ioc_fsgeometry_v1(
 	xfs_fsop_geom_t         fsgeo;
 	int			error;
 
-	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, 3);
+	error = xfs_fs_geometry(mp, &fsgeo, 3);
 	if (error)
 		return error;
 
@@ -816,7 +816,7 @@ xfs_ioc_fsgeometry(
 	xfs_fsop_geom_t		fsgeo;
 	int			error;
 
-	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, 4);
+	error = xfs_fs_geometry(mp, &fsgeo, 4);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 375d5baead9e..6b395dd63ea1 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -55,7 +55,7 @@ xfs_compat_ioc_fsgeometry_v1(
 	xfs_fsop_geom_t		  fsgeo;
 	int			  error;
 
-	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, 3);
+	error = xfs_fs_geometry(mp, &fsgeo, 3);
 	if (error)
 		return error;
 	/* The 32-bit variant simply has some padding at the end */
-- 
2.17.0
