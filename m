Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38900 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754807AbeDVPI3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Apr 2018 11:08:29 -0400
Subject: [PATCH 06/10] xfs: superblock scrub should use short-lived buffers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 22 Apr 2018 08:08:11 -0700
Message-ID: <152440969101.30048.3596353270429386608.stgit@magnolia>
In-Reply-To: <152440964593.30048.15577210457233332459.stgit@magnolia>
References: <152440964593.30048.15577210457233332459.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Secondary superblocks are rarely used, so create a helper to read a
given non-primary AG's superblock and ensure that it won't stick around
hogging memory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.c     |   22 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.h     |    3 +++
 fs/xfs/libxfs/xfs_shared.h |    1 +
 fs/xfs/scrub/agheader.c    |    4 +---
 4 files changed, 27 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index d9b94bd..d9bef41 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -972,3 +972,25 @@ xfs_fs_geometry(
 
 	return 0;
 }
+
+/* Read a secondary superblock. */
+int
+xfs_sb_read_secondary(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_buf		*bp;
+	int			error;
+
+	ASSERT(agno != 0 && agno != NULLAGNUMBER);
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
+			XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
+			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
+	if (error)
+		return error;
+	xfs_buf_set_ref(bp, XFS_SSB_REF);
+	*bpp = bp;
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 63dcd2a..5166d78 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -37,5 +37,8 @@ extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
 #define XFS_FS_GEOM_MAX_STRUCT_VER	(4)
 extern int	xfs_fs_geometry(struct xfs_sb *sbp, struct xfs_fsop_geom *geo,
 				int struct_version);
+extern int	xfs_sb_read_secondary(struct xfs_mount *mp,
+				struct xfs_trans *tp, xfs_agnumber_t agno,
+				struct xfs_buf **bpp);
 
 #endif	/* __XFS_SB_H__ */
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index d0b84da..d23f33c 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -127,6 +127,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_ATTR_BTREE_REF	1
 #define	XFS_DQUOT_REF		1
 #define	XFS_REFC_BTREE_REF	1
+#define	XFS_SSB_REF		0
 
 /*
  * Flags for xfs_trans_ichgtime().
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 018aabbd..cd24ac56 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -157,9 +157,7 @@ xfs_scrub_superblock(
 	if (agno == 0)
 		return 0;
 
-	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
-		  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
-		  XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
+	error = xfs_sb_read_secondary(mp, sc->tp, agno, &bp);
 	/*
 	 * The superblock verifier can return several different error codes
 	 * if it thinks the superblock doesn't look right.  For a mount these

