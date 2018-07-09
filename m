Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from gateway21.websitewelcome.com ([192.185.45.95]:49840 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932961AbeGIQmp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jul 2018 12:42:45 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 0B52640116905
        for <linux-xfs@vger.kernel.org>; Mon,  9 Jul 2018 11:13:21 -0500 (CDT)
Date: Mon, 9 Jul 2018 11:12:47 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] xfs_attr_leaf: use swap macro in xfs_attr3_leaf_rebalance
Message-ID: <20180709161247.GA4746@embeddedor.com>
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
 fs/xfs/libxfs/xfs_attr_leaf.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 76e9004..ec0bf96 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1570,17 +1570,10 @@ xfs_attr3_leaf_rebalance(
 	 */
 	swap = 0;
 	if (xfs_attr3_leaf_order(blk1->bp, &ichdr1, blk2->bp, &ichdr2)) {
-		struct xfs_da_state_blk	*tmp_blk;
-		struct xfs_attr3_icleaf_hdr tmp_ichdr;
+		swap(blk1, blk2);
 
-		tmp_blk = blk1;
-		blk1 = blk2;
-		blk2 = tmp_blk;
-
-		/* struct copies to swap them rather than reconverting */
-		tmp_ichdr = ichdr1;
-		ichdr1 = ichdr2;
-		ichdr2 = tmp_ichdr;
+		/* swap structures rather than reconverting them */
+		swap(ichdr1, ichdr2);
 
 		leaf1 = blk1->bp->b_addr;
 		leaf2 = blk2->bp->b_addr;
-- 
2.7.4

