Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20401 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964876AbcI1DAO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 23:00:14 -0400
Subject: [PATCH 61/63] xfs: various swapext cleanups
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 20:00:09 -0700
Message-ID: <147503160974.30303.8562472846604180499.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Replace structure typedefs with struct expressions and fix some
whitespace issues that result.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 268639a..b58a935 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1551,8 +1551,8 @@ xfs_insert_file_space(
  */
 static int
 xfs_swap_extents_check_format(
-	xfs_inode_t	*ip,	/* target inode */
-	xfs_inode_t	*tip)	/* tmp inode */
+	struct xfs_inode	*ip,	/* target inode */
+	struct xfs_inode	*tip)	/* tmp inode */
 {
 
 	/* Should never get a local format */
@@ -1638,22 +1638,22 @@ xfs_swap_extent_flush(
 
 int
 xfs_swap_extents(
-	xfs_inode_t	*ip,	/* target inode */
-	xfs_inode_t	*tip,	/* tmp inode */
-	xfs_swapext_t	*sxp)
+	struct xfs_inode	*ip,	/* target inode */
+	struct xfs_inode	*tip,	/* tmp inode */
+	struct xfs_swapext	*sxp)
 {
-	xfs_mount_t	*mp = ip->i_mount;
-	xfs_trans_t	*tp;
-	xfs_bstat_t	*sbp = &sxp->sx_stat;
-	xfs_ifork_t	*tempifp, *ifp, *tifp;
-	int		src_log_flags, target_log_flags;
-	int		error = 0;
-	int		aforkblks = 0;
-	int		taforkblks = 0;
-	__uint64_t	tmp;
-	int		lock_flags;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	struct xfs_bstat	*sbp = &sxp->sx_stat;
+	struct xfs_ifork	*tempifp, *ifp, *tifp;
+	int			src_log_flags, target_log_flags;
+	int			error = 0;
+	int			aforkblks = 0;
+	int			taforkblks = 0;
+	__uint64_t		tmp;
+	int			lock_flags;
 	struct xfs_ifork	*cowfp;
-	__uint64_t	f;
+	__uint64_t		f;
 
 	/* XXX: we can't do this with rmap, will fix later */
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))

