Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51998 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751342AbeAEDjy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jan 2018 22:39:54 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w053bqM0021754
        for <linux-xfs@vger.kernel.org>; Fri, 5 Jan 2018 03:39:53 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2fa04d85x5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 05 Jan 2018 03:39:53 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w053dqOw031346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 5 Jan 2018 03:39:53 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w053dqIb004740
        for <linux-xfs@vger.kernel.org>; Fri, 5 Jan 2018 03:39:52 GMT
Subject: [PATCH 3/3] xfs: refactor the geometry structure filling function
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 04 Jan 2018 19:39:51 -0800
Message-ID: <151512359134.14363.8696043274247703808.stgit@magnolia>
In-Reply-To: <151512356118.14363.7797314285394643799.stgit@magnolia>
References: <151512356118.14363.7797314285394643799.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the geometry structure filling function to use the superblock
to fill the fields.  While we're at it, make the function less indenty
and use some whitespace to make the function easier to read.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.c |  167 ++++++++++++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_sb.h |    5 +
 fs/xfs/xfs_ioctl.c     |    4 +
 fs/xfs/xfs_ioctl32.c   |    2 -
 4 files changed, 103 insertions(+), 75 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 139517a..70e5126 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -879,77 +879,104 @@ xfs_sync_sb(
 
 int
 xfs_fs_geometry(
-	xfs_mount_t		*mp,
-	xfs_fsop_geom_t		*geo,
-	int			new_version)
+	struct xfs_sb		*sbp,
+	struct xfs_fsop_geom	*geo,
+	int			struct_version)
 {
+	memset(geo, 0, sizeof(struct xfs_fsop_geom));
+
+	geo->blocksize = sbp->sb_blocksize;
+	geo->rtextsize = sbp->sb_rextsize;
+	geo->agblocks = sbp->sb_agblocks;
+	geo->agcount = sbp->sb_agcount;
+	geo->logblocks = sbp->sb_logblocks;
+	geo->sectsize = sbp->sb_sectsize;
+	geo->inodesize = sbp->sb_inodesize;
+	geo->imaxpct = sbp->sb_imax_pct;
+	geo->datablocks = sbp->sb_dblocks;
+	geo->rtblocks = sbp->sb_rblocks;
+	geo->rtextents = sbp->sb_rextents;
+	geo->logstart = sbp->sb_logstart;
+	BUILD_BUG_ON(sizeof(geo->uuid) != sizeof(sbp->sb_uuid));
+	memcpy(geo->uuid, &sbp->sb_uuid, sizeof(sbp->sb_uuid));
+
+	if (struct_version < 2)
+		return 0;
+
+	geo->sunit = sbp->sb_unit;
+	geo->swidth = sbp->sb_width;
+
+	if (struct_version < 3)
+		return 0;
+
+	geo->version = XFS_FSOP_GEOM_VERSION;
+	geo->flags = XFS_FSOP_GEOM_FLAGS_NLINK |
+		     XFS_FSOP_GEOM_FLAGS_DIRV2;
+
+
+	if (xfs_sb_version_hasattr(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATTR;
+
+	if (xfs_sb_version_hasquota(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_QUOTA;
+
+	if (xfs_sb_version_hasalign(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_IALIGN;
+
+	if (xfs_sb_version_hasdalign(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_DALIGN;
+
+	if (xfs_sb_version_hasextflgbit(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_EXTFLG;
+
+	if (xfs_sb_version_hassector(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
+
+	if (xfs_sb_version_hasasciici(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_DIRV2CI;
+
+	if (xfs_sb_version_haslazysbcount(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_LAZYSB;
+
+	if (xfs_sb_version_hasattr2(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATTR2;
+
+	if (xfs_sb_version_hasprojid32bit(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_PROJID32;
+
+	if (xfs_sb_version_hascrc(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_V5SB;
+
+	if (xfs_sb_version_hasftype(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_FTYPE;
+
+	if (xfs_sb_version_hasfinobt(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_FINOBT;
+
+	if (xfs_sb_version_hassparseinodes(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_SPINODES;
+
+	if (xfs_sb_version_hasrmapbt(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_RMAPBT;
+
+	if (xfs_sb_version_hasreflink(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_REFLINK;
+
+	if (xfs_sb_version_hassector(sbp))
+		geo->logsectsize = sbp->sb_logsectsize;
+	else
+		geo->logsectsize = BBSIZE;
+
+	geo->rtsectsize = sbp->sb_blocksize;
+	geo->dirblocksize = 1 << (sbp->sb_blocklog + sbp->sb_dirblklog);
+
+	if (struct_version < 3)
+		return 0;
+
+	if (xfs_sb_version_haslogv2(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_LOGV2;
+
+	geo->logsunit = sbp->sb_logsunit;
 
-	memset(geo, 0, sizeof(*geo));
-
-	geo->blocksize = mp->m_sb.sb_blocksize;
-	geo->rtextsize = mp->m_sb.sb_rextsize;
-	geo->agblocks = mp->m_sb.sb_agblocks;
-	geo->agcount = mp->m_sb.sb_agcount;
-	geo->logblocks = mp->m_sb.sb_logblocks;
-	geo->sectsize = mp->m_sb.sb_sectsize;
-	geo->inodesize = mp->m_sb.sb_inodesize;
-	geo->imaxpct = mp->m_sb.sb_imax_pct;
-	geo->datablocks = mp->m_sb.sb_dblocks;
-	geo->rtblocks = mp->m_sb.sb_rblocks;
-	geo->rtextents = mp->m_sb.sb_rextents;
-	geo->logstart = mp->m_sb.sb_logstart;
-	ASSERT(sizeof(geo->uuid) == sizeof(mp->m_sb.sb_uuid));
-	memcpy(geo->uuid, &mp->m_sb.sb_uuid, sizeof(mp->m_sb.sb_uuid));
-	if (new_version >= 2) {
-		geo->sunit = mp->m_sb.sb_unit;
-		geo->swidth = mp->m_sb.sb_width;
-	}
-	if (new_version >= 3) {
-		geo->version = XFS_FSOP_GEOM_VERSION;
-		geo->flags = XFS_FSOP_GEOM_FLAGS_NLINK |
-			     XFS_FSOP_GEOM_FLAGS_DIRV2 |
-			(xfs_sb_version_hasattr(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_ATTR : 0) |
-			(xfs_sb_version_hasquota(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_QUOTA : 0) |
-			(xfs_sb_version_hasalign(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_IALIGN : 0) |
-			(xfs_sb_version_hasdalign(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_DALIGN : 0) |
-			(xfs_sb_version_hasextflgbit(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_EXTFLG : 0) |
-			(xfs_sb_version_hassector(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_SECTOR : 0) |
-			(xfs_sb_version_hasasciici(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_DIRV2CI : 0) |
-			(xfs_sb_version_haslazysbcount(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_LAZYSB : 0) |
-			(xfs_sb_version_hasattr2(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_ATTR2 : 0) |
-			(xfs_sb_version_hasprojid32bit(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_PROJID32 : 0) |
-			(xfs_sb_version_hascrc(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_V5SB : 0) |
-			(xfs_sb_version_hasftype(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_FTYPE : 0) |
-			(xfs_sb_version_hasfinobt(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_FINOBT : 0) |
-			(xfs_sb_version_hassparseinodes(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_SPINODES : 0) |
-			(xfs_sb_version_hasrmapbt(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_RMAPBT : 0) |
-			(xfs_sb_version_hasreflink(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_REFLINK : 0);
-		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
-				mp->m_sb.sb_logsectsize : BBSIZE;
-		geo->rtsectsize = mp->m_sb.sb_blocksize;
-		geo->dirblocksize = mp->m_dir_geo->blksize;
-	}
-	if (new_version >= 4) {
-		geo->flags |=
-			(xfs_sb_version_haslogv2(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_LOGV2 : 0);
-		geo->logsunit = mp->m_sb.sb_logsunit;
-	}
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index a16632c..63dcd2a 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -34,7 +34,8 @@ extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
 extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
 extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
 
-extern int	xfs_fs_geometry(struct xfs_mount *mp, struct xfs_fsop_geom *geo,
-				int nversion);
+#define XFS_FS_GEOM_MAX_STRUCT_VER	(4)
+extern int	xfs_fs_geometry(struct xfs_sb *sbp, struct xfs_fsop_geom *geo,
+				int struct_version);
 
 #endif	/* __XFS_SB_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3015e17..89fb1eb 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -810,7 +810,7 @@ xfs_ioc_fsgeometry_v1(
 	xfs_fsop_geom_t         fsgeo;
 	int			error;
 
-	error = xfs_fs_geometry(mp, &fsgeo, 3);
+	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, 3);
 	if (error)
 		return error;
 
@@ -832,7 +832,7 @@ xfs_ioc_fsgeometry(
 	xfs_fsop_geom_t		fsgeo;
 	int			error;
 
-	error = xfs_fs_geometry(mp, &fsgeo, 4);
+	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, 4);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 66cc3cd..10fbde3 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -67,7 +67,7 @@ xfs_compat_ioc_fsgeometry_v1(
 	xfs_fsop_geom_t		  fsgeo;
 	int			  error;
 
-	error = xfs_fs_geometry(mp, &fsgeo, 3);
+	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, 3);
 	if (error)
 		return error;
 	/* The 32-bit variant simply has some padding at the end */

