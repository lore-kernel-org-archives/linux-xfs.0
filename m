Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36636 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753056AbdJaOWk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 10:22:40 -0400
Received: from bzq-164-168-31-210.red.bezeqint.net ([31.168.164.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e9XRA-0007Zm-6N
        for linux-xfs@vger.kernel.org; Tue, 31 Oct 2017 14:22:40 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/18] xfs: don't create overlapping extents in xfs_bmap_add_extent_delay_real
Date: Tue, 31 Oct 2017 16:22:14 +0200
Message-Id: <20171031142230.11755-3-hch@lst.de>
In-Reply-To: <20171031142230.11755-1-hch@lst.de>
References: <20171031142230.11755-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Two cases in xfs_bmap_add_extent_delay_real currently insert a new
extent before updating the existing one that is being split.  While
this works fine with a simple extent list, a more complex tree can't
easily cope with overlapping extent.  Reshuffle the code a bit to update
the slot of the existing delalloc extent to the new real extent before
inserting the shortened delalloc extent before or after it.  This
avoids the overlapping extents while still allowing to update the
br_startblock field of the delalloc extent with the updated indirect
block reservation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b2b6832b9e6b..0eda6892b9d0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1790,7 +1790,7 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in the first part of a previous delayed allocation.
 		 * The left neighbor is not contiguous.
 		 */
-		xfs_iext_insert(bma->ip, bma->idx, 1, new, state);
+		xfs_iext_update_extent(bma->ip, state, bma->idx, new);
 		(*nextents)++;
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -1823,7 +1823,7 @@ xfs_bmap_add_extent_delay_real(
 		PREV.br_startoff = new_endoff;
 		PREV.br_blockcount = temp;
 		PREV.br_startblock = nullstartblock(da_new);
-		xfs_iext_update_extent(bma->ip, state, bma->idx + 1, &PREV);
+		xfs_iext_insert(bma->ip, bma->idx + 1, 1, &PREV, state);
 		break;
 
 	case BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -1866,7 +1866,7 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in the last part of a previous delayed allocation.
 		 * The right neighbor is not contiguous.
 		 */
-		xfs_iext_insert(bma->ip, bma->idx + 1, 1, new, state);
+		xfs_iext_update_extent(bma->ip, state, bma->idx, new);
 		(*nextents)++;
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -1898,7 +1898,7 @@ xfs_bmap_add_extent_delay_real(
 
 		PREV.br_startblock = nullstartblock(da_new);
 		PREV.br_blockcount = temp;
-		xfs_iext_update_extent(bma->ip, state, bma->idx, &PREV);
+		xfs_iext_insert(bma->ip, bma->idx, 1, &PREV, state);
 
 		bma->idx++;
 		break;
-- 
2.14.2

