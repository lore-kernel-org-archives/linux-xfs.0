Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58002 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932620AbdKCOp6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 10:45:58 -0400
Received: from [94.72.11.11] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eAdEL-0001nF-LN
        for linux-xfs@vger.kernel.org; Fri, 03 Nov 2017 14:45:58 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/21] xfs: treat idx as a cursor in xfs_bmap_add_extent_hole_delay
Date: Fri,  3 Nov 2017 17:45:22 +0300
Message-Id: <20171103144539.2187-5-hch@lst.de>
In-Reply-To: <20171103144539.2187-1-hch@lst.de>
References: <20171103144539.2187-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Stop poking before and after the index and just increment or decrement
it while doing our operations on it to prepare for a new extent list
implementation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c0216e9e2af8..e2d8cbd054fe 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2584,7 +2584,6 @@ xfs_bmap_add_extent_hole_delay(
 		 * on the left and on the right.
 		 * Merge all three into a single extent record.
 		 */
-		--*idx;
 		temp = left.br_blockcount + new->br_blockcount +
 			right.br_blockcount;
 
@@ -2595,9 +2594,10 @@ xfs_bmap_add_extent_hole_delay(
 					 oldlen);
 		left.br_startblock = nullstartblock(newlen);
 		left.br_blockcount = temp;
-		xfs_iext_update_extent(ip, state, *idx, &left);
 
-		xfs_iext_remove(ip, *idx + 1, 1, state);
+		xfs_iext_remove(ip, *idx, 1, state);
+		--*idx;
+		xfs_iext_update_extent(ip, state, *idx, &left);
 		break;
 
 	case BMAP_LEFT_CONTIG:
@@ -2606,7 +2606,6 @@ xfs_bmap_add_extent_hole_delay(
 		 * on the left.
 		 * Merge the new allocation with the left neighbor.
 		 */
-		--*idx;
 		temp = left.br_blockcount + new->br_blockcount;
 
 		oldlen = startblockval(left.br_startblock) +
@@ -2615,6 +2614,8 @@ xfs_bmap_add_extent_hole_delay(
 					 oldlen);
 		left.br_blockcount = temp;
 		left.br_startblock = nullstartblock(newlen);
+
+		--*idx;
 		xfs_iext_update_extent(ip, state, *idx, &left);
 		break;
 
-- 
2.14.2

