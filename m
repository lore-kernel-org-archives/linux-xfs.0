Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49729 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755958AbcI3DMZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:12:25 -0400
Subject: [PATCH 61/63] xfs: various swapext cleanups
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:12:19 -0700
Message-ID: <147520513969.29434.6906497983480048097.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Replace structure typedefs with struct expressions and fix some
whitespace issues that result.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index fd4b6bb..afe0319 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1556,8 +1556,8 @@ xfs_insert_file_space(
  */
 static int
 xfs_swap_extents_check_format(
-	xfs_inode_t	*ip,	/* target inode */
-	xfs_inode_t	*tip)	/* tmp inode */
+	struct xfs_inode	*ip,	/* target inode */
+	struct xfs_inode	*tip)	/* tmp inode */
 {
 
 	/* Should never get a local format */
@@ -1643,22 +1643,22 @@ xfs_swap_extent_flush(
 
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

