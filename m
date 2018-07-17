Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from gateway22.websitewelcome.com ([192.185.47.144]:42211 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729461AbeGQRI0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jul 2018 13:08:26 -0400
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 162211226F
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jul 2018 11:11:58 -0500 (CDT)
Date: Tue, 17 Jul 2018 11:11:27 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] xfs: use swap macro in xfs_dir2_leafn_rebalance
Message-ID: <20180717161127.GA16337@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>

Make use of the swap macro and remove unnecessary variable *tmp*. This
makes the code easier to read and maintain. Also, slightly refactor some
code.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 2daf874..f1bb343 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1012,7 +1012,7 @@ xfs_dir2_leafn_rebalance(
 	int			oldstale;	/* old count of stale leaves */
 #endif
 	int			oldsum;		/* old total leaf count */
-	int			swap;		/* swapped leaf blocks */
+	int			swap_blocks;	/* swapped leaf blocks */
 	struct xfs_dir2_leaf_entry *ents1;
 	struct xfs_dir2_leaf_entry *ents2;
 	struct xfs_dir3_icleaf_hdr hdr1;
@@ -1023,13 +1023,10 @@ xfs_dir2_leafn_rebalance(
 	/*
 	 * If the block order is wrong, swap the arguments.
 	 */
-	if ((swap = xfs_dir2_leafn_order(dp, blk1->bp, blk2->bp))) {
-		xfs_da_state_blk_t	*tmp;	/* temp for block swap */
+	swap_blocks = xfs_dir2_leafn_order(dp, blk1->bp, blk2->bp);
+	if (swap_blocks)
+		swap(blk1, blk2);
 
-		tmp = blk1;
-		blk1 = blk2;
-		blk2 = tmp;
-	}
 	leaf1 = blk1->bp->b_addr;
 	leaf2 = blk2->bp->b_addr;
 	dp->d_ops->leaf_hdr_from_disk(&hdr1, leaf1);
@@ -1093,11 +1090,11 @@ xfs_dir2_leafn_rebalance(
 	 * Mark whether we're inserting into the old or new leaf.
 	 */
 	if (hdr1.count < hdr2.count)
-		state->inleaf = swap;
+		state->inleaf = swap_blocks;
 	else if (hdr1.count > hdr2.count)
-		state->inleaf = !swap;
+		state->inleaf = !swap_blocks;
 	else
-		state->inleaf = swap ^ (blk1->index <= hdr1.count);
+		state->inleaf = swap_blocks ^ (blk1->index <= hdr1.count);
 	/*
 	 * Adjust the expected index for insertion.
 	 */
-- 
2.7.4

