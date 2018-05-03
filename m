Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55736 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751095AbeECSGr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 14:06:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w43I16Jf087115
        for <linux-xfs@vger.kernel.org>; Thu, 3 May 2018 18:06:47 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2hmgxg30qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 03 May 2018 18:06:47 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w43I6kiL001352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 3 May 2018 18:06:46 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w43I6jTp015475
        for <linux-xfs@vger.kernel.org>; Thu, 3 May 2018 18:06:46 GMT
Subject: [PATCH 08/12] xfs: superblock scrub should use short-lived buffers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 May 2018 11:06:44 -0700
Message-ID: <152537080489.16676.3127430066483939602.stgit@magnolia>
In-Reply-To: <152537075334.16676.10600900179473864298.stgit@magnolia>
References: <152537075334.16676.10600900179473864298.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

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
index d9b94bd5f689..d9bef41a3f26 100644
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
index 63dcd2a1a657..5166d78b2c34 100644
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
index d0b84da0cb1e..d23f33c02f64 100644
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
index 018aabbd9394..cd24ac56c21e 100644
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

