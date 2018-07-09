Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from gateway32.websitewelcome.com ([192.185.145.1]:30171 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932980AbeGIVZc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jul 2018 17:25:32 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id F066C74B6BB
        for <linux-xfs@vger.kernel.org>; Mon,  9 Jul 2018 16:03:00 -0500 (CDT)
Date: Mon, 9 Jul 2018 16:02:59 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH v2] xfs_bmap_util: use swap macro
Message-ID: <20180709210259.GA18992@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>

Make use of the swap macro and remove some unnecessary variables.
This makes the code easier to read and maintain. Also, reduces the
stack usage.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
Changes in v2
 - Use swap in a couple more of places.

 fs/xfs/xfs_bmap_util.c | 28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 83b1e8c..a657d0a 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1691,7 +1691,6 @@ xfs_swap_extent_forks(
 	int			*src_log_flags,
 	int			*target_log_flags)
 {
-	struct xfs_ifork	tempifp, *ifp, *tifp;
 	xfs_filblks_t		aforkblks = 0;
 	xfs_filblks_t		taforkblks = 0;
 	xfs_extnum_t		junk;
@@ -1733,11 +1732,7 @@ xfs_swap_extent_forks(
 	/*
 	 * Swap the data forks of the inodes
 	 */
-	ifp = &ip->i_df;
-	tifp = &tip->i_df;
-	tempifp = *ifp;		/* struct copy */
-	*ifp = *tifp;		/* struct copy */
-	*tifp = tempifp;	/* struct copy */
+	swap(ip->i_df, tip->i_df);
 
 	/*
 	 * Fix the on-disk inode values
@@ -1746,13 +1741,8 @@ xfs_swap_extent_forks(
 	ip->i_d.di_nblocks = tip->i_d.di_nblocks - taforkblks + aforkblks;
 	tip->i_d.di_nblocks = tmp + taforkblks - aforkblks;
 
-	tmp = (uint64_t) ip->i_d.di_nextents;
-	ip->i_d.di_nextents = tip->i_d.di_nextents;
-	tip->i_d.di_nextents = tmp;
-
-	tmp = (uint64_t) ip->i_d.di_format;
-	ip->i_d.di_format = tip->i_d.di_format;
-	tip->i_d.di_format = tmp;
+	swap(ip->i_d.di_nextents, tip->i_d.di_nextents);
+	swap(ip->i_d.di_format, tip->i_d.di_format);
 
 	/*
 	 * The extents in the source inode could still contain speculative
@@ -1846,7 +1836,6 @@ xfs_swap_extents(
 	int			src_log_flags, target_log_flags;
 	int			error = 0;
 	int			lock_flags;
-	struct xfs_ifork	*cowfp;
 	uint64_t		f;
 	int			resblks = 0;
 
@@ -1987,18 +1976,11 @@ xfs_swap_extents(
 
 	/* Swap the cow forks. */
 	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
-		xfs_extnum_t	extnum;
-
 		ASSERT(ip->i_cformat == XFS_DINODE_FMT_EXTENTS);
 		ASSERT(tip->i_cformat == XFS_DINODE_FMT_EXTENTS);
 
-		extnum = ip->i_cnextents;
-		ip->i_cnextents = tip->i_cnextents;
-		tip->i_cnextents = extnum;
-
-		cowfp = ip->i_cowfp;
-		ip->i_cowfp = tip->i_cowfp;
-		tip->i_cowfp = cowfp;
+		swap(ip->i_cnextents, tip->i_cnextents);
+		swap(ip->i_cowfp, tip->i_cowfp);
 
 		if (ip->i_cowfp && ip->i_cowfp->if_bytes)
 			xfs_inode_set_cowblocks_tag(ip);
-- 
2.7.4

