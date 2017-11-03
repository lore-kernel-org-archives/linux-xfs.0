Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50754 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932620AbdKCOp5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 10:45:57 -0400
Received: from [94.72.11.11] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eAdEG-0001mc-68
        for linux-xfs@vger.kernel.org; Fri, 03 Nov 2017 14:45:52 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/21] xfs: treat idx as a cursor in xfs_bmap_add_extent_delay_real
Date: Fri,  3 Nov 2017 17:45:21 +0300
Message-Id: <20171103144539.2187-4-hch@lst.de>
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
 fs/xfs/libxfs/xfs_bmap.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e1d61face277..c0216e9e2af8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1648,12 +1648,13 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in all of a previously delayed allocation extent.
 		 * The left and right neighbors are both contiguous with new.
 		 */
-		bma->idx--;
 		LEFT.br_blockcount += PREV.br_blockcount + RIGHT.br_blockcount;
-		xfs_iext_update_extent(bma->ip, state, bma->idx, &LEFT);
 
-		xfs_iext_remove(bma->ip, bma->idx + 1, 2, state);
+		xfs_iext_remove(bma->ip, bma->idx, 2, state);
+		bma->idx--;
+		xfs_iext_update_extent(bma->ip, state, bma->idx, &LEFT);
 		(*nextents)--;
+
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -1681,13 +1682,13 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in all of a previously delayed allocation extent.
 		 * The left neighbor is contiguous, the right is not.
 		 */
-		bma->idx--;
-
 		old = LEFT;
 		LEFT.br_blockcount += PREV.br_blockcount;
+
+		xfs_iext_remove(bma->ip, bma->idx, 1, state);
+		bma->idx--;
 		xfs_iext_update_extent(bma->ip, state, bma->idx, &LEFT);
 
-		xfs_iext_remove(bma->ip, bma->idx + 1, 1, state);
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_DEXT;
 		else {
@@ -1709,9 +1710,12 @@ xfs_bmap_add_extent_delay_real(
 		 */
 		PREV.br_startblock = new->br_startblock;
 		PREV.br_blockcount += RIGHT.br_blockcount;
+
+		bma->idx++;
+		xfs_iext_remove(bma->ip, bma->idx, 1, state);
+		bma->idx--;
 		xfs_iext_update_extent(bma->ip, state, bma->idx, &PREV);
 
-		xfs_iext_remove(bma->ip, bma->idx + 1, 1, state);
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_DEXT;
 		else {
@@ -1763,12 +1767,14 @@ xfs_bmap_add_extent_delay_real(
 				startblockval(PREV.br_startblock));
 
 		LEFT.br_blockcount += new->br_blockcount;
-		xfs_iext_update_extent(bma->ip, state, bma->idx - 1, &LEFT);
 
 		PREV.br_blockcount = temp;
 		PREV.br_startoff += new->br_blockcount;
 		PREV.br_startblock = nullstartblock(da_new);
+
 		xfs_iext_update_extent(bma->ip, state, bma->idx, &PREV);
+		bma->idx--;
+		xfs_iext_update_extent(bma->ip, state, bma->idx, &LEFT);
 
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_DEXT;
@@ -1783,7 +1789,6 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 
-		bma->idx--;
 		break;
 
 	case BMAP_LEFT_FILLING:
@@ -1836,7 +1841,6 @@ xfs_bmap_add_extent_delay_real(
 		RIGHT.br_startoff = new->br_startoff;
 		RIGHT.br_startblock = new->br_startblock;
 		RIGHT.br_blockcount += new->br_blockcount;
-		xfs_iext_update_extent(bma->ip, state, bma->idx + 1, &RIGHT);
 
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_DEXT;
@@ -1857,9 +1861,10 @@ xfs_bmap_add_extent_delay_real(
 
 		PREV.br_blockcount = temp;
 		PREV.br_startblock = nullstartblock(da_new);
-		xfs_iext_update_extent(bma->ip, state, bma->idx, &PREV);
 
+		xfs_iext_update_extent(bma->ip, state, bma->idx, &PREV);
 		bma->idx++;
+		xfs_iext_update_extent(bma->ip, state, bma->idx, &RIGHT);
 		break;
 
 	case BMAP_RIGHT_FILLING:
-- 
2.14.2

