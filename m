Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41445 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751686AbdJSHAG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 03:00:06 -0400
Received: from 212095007233.public.telering.at ([212.95.7.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e54oG-0004Kd-SJ
        for linux-xfs@vger.kernel.org; Thu, 19 Oct 2017 07:00:05 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/15] xfs: move pre/post-bmap tracing into xfs_iext_update_extent
Date: Thu, 19 Oct 2017 08:59:31 +0200
Message-Id: <20171019065942.18813-5-hch@lst.de>
In-Reply-To: <20171019065942.18813-1-hch@lst.de>
References: <20171019065942.18813-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_iext_update_extent already has basically all the information needed
to centralize the bmap pre/post tracing.  We just need to pass inode +
bmap state instead of the inode fork pointer to get all trace annotations.

In addition to covering all the existing trace points this gives us
tracing coverage for the extent shifting operations for free.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c       | 167 ++++++++++++-----------------------------
 fs/xfs/libxfs/xfs_inode_fork.c |   7 +-
 fs/xfs/libxfs/xfs_inode_fork.h |   4 +-
 3 files changed, 55 insertions(+), 123 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8c2e5d6bced2..ff9a8e1d4a96 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1669,10 +1669,8 @@ xfs_bmap_add_extent_delay_real(
 		 * The left and right neighbors are both contiguous with new.
 		 */
 		bma->idx--;
-		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
 		LEFT.br_blockcount += PREV.br_blockcount + RIGHT.br_blockcount;
-		xfs_iext_update_extent(ifp, bma->idx, &LEFT);
-		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
+		xfs_iext_update_extent(bma->ip, state, bma->idx, &LEFT);
 
 		xfs_iext_remove(bma->ip, bma->idx + 1, 2, state);
 		(*nextents)--;
@@ -1706,10 +1704,8 @@ xfs_bmap_add_extent_delay_real(
 		bma->idx--;
 
 		old = LEFT;
-		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
 		LEFT.br_blockcount += PREV.br_blockcount;
-		xfs_iext_update_extent(ifp, bma->idx, &LEFT);
-		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
+		xfs_iext_update_extent(bma->ip, state, bma->idx, &LEFT);
 
 		xfs_iext_remove(bma->ip, bma->idx + 1, 1, state);
 		if (bma->cur == NULL)
@@ -1731,11 +1727,9 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in all of a previously delayed allocation extent.
 		 * The right neighbor is contiguous, the left is not.
 		 */
-		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
 		PREV.br_startblock = new->br_startblock;
 		PREV.br_blockcount += RIGHT.br_blockcount;
-		xfs_iext_update_extent(ifp, bma->idx, &PREV);
-		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
+		xfs_iext_update_extent(bma->ip, state, bma->idx, &PREV);
 
 		xfs_iext_remove(bma->ip, bma->idx + 1, 1, state);
 		if (bma->cur == NULL)
@@ -1758,11 +1752,9 @@ xfs_bmap_add_extent_delay_real(
 		 * Neither the left nor right neighbors are contiguous with
 		 * the new one.
 		 */
-		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
 		PREV.br_startblock = new->br_startblock;
 		PREV.br_state = new->br_state;
-		xfs_iext_update_extent(ifp, bma->idx, &PREV);
-		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
+		xfs_iext_update_extent(bma->ip, state, bma->idx, &PREV);
 
 		(*nextents)++;
 		if (bma->cur == NULL)
@@ -1790,17 +1782,13 @@ xfs_bmap_add_extent_delay_real(
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 				startblockval(PREV.br_startblock));
 
-		trace_xfs_bmap_pre_update(bma->ip, bma->idx - 1, state, _THIS_IP_);
 		LEFT.br_blockcount += new->br_blockcount;
-		xfs_iext_update_extent(ifp, bma->idx - 1, &LEFT);
-		trace_xfs_bmap_post_update(bma->ip, bma->idx - 1, state, _THIS_IP_);
+		xfs_iext_update_extent(bma->ip, state, bma->idx - 1, &LEFT);
 
-		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
 		PREV.br_blockcount = temp = PREV.br_blockcount - new->br_blockcount;
 		PREV.br_startoff += new->br_blockcount;
 		PREV.br_startblock = nullstartblock(da_new);
-		xfs_iext_update_extent(ifp, bma->idx, &PREV);
-		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
+		xfs_iext_update_extent(bma->ip, state, bma->idx, &PREV);
 
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_DEXT;
@@ -1853,13 +1841,10 @@ xfs_bmap_add_extent_delay_real(
 			startblockval(PREV.br_startblock) -
 			(bma->cur ? bma->cur->bc_private.b.allocated : 0));
 
-		trace_xfs_bmap_pre_update(bma->ip, bma->idx + 1, state, _THIS_IP_);
 		PREV.br_startoff = new_endoff;
 		PREV.br_blockcount = temp;
 		PREV.br_startblock = nullstartblock(da_new);
-		xfs_iext_update_extent(ifp, bma->idx + 1, &PREV);
-		trace_xfs_bmap_post_update(bma->ip, bma->idx + 1, state, _THIS_IP_);
-
+		xfs_iext_update_extent(bma->ip, state, bma->idx + 1, &PREV);
 		break;
 
 	case BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -1868,12 +1853,10 @@ xfs_bmap_add_extent_delay_real(
 		 * The right neighbor is contiguous with the new allocation.
 		 */
 		old = RIGHT;
-		trace_xfs_bmap_pre_update(bma->ip, bma->idx + 1, state, _THIS_IP_);
 		RIGHT.br_startoff = new->br_startoff;
 		RIGHT.br_startblock = new->br_startblock;
 		RIGHT.br_blockcount += new->br_blockcount;
-		xfs_iext_update_extent(ifp, bma->idx + 1, &RIGHT);
-		trace_xfs_bmap_post_update(bma->ip, bma->idx + 1, state, _THIS_IP_);
+		xfs_iext_update_extent(bma->ip, state, bma->idx + 1, &RIGHT);
 
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_DEXT;
@@ -1892,11 +1875,9 @@ xfs_bmap_add_extent_delay_real(
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock));
 
-		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
 		PREV.br_blockcount = temp;
 		PREV.br_startblock = nullstartblock(da_new);
-		xfs_iext_update_extent(ifp, bma->idx, &PREV);
-		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
+		xfs_iext_update_extent(bma->ip, state, bma->idx, &PREV);
 
 		bma->idx++;
 		break;
@@ -1936,11 +1917,9 @@ xfs_bmap_add_extent_delay_real(
 			startblockval(PREV.br_startblock) -
 			(bma->cur ? bma->cur->bc_private.b.allocated : 0));
 
-		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
 		PREV.br_startblock = nullstartblock(da_new);
 		PREV.br_blockcount = temp;
-		xfs_iext_update_extent(ifp, bma->idx, &PREV);
-		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
+		xfs_iext_update_extent(bma->ip, state, bma->idx, &PREV);
 
 		bma->idx++;
 		break;
@@ -1981,13 +1960,11 @@ xfs_bmap_add_extent_delay_real(
 					RIGHT.br_blockcount));
 
 		/* truncate PREV */
-		trace_xfs_bmap_pre_update(bma->ip, bma->idx, 0, _THIS_IP_);
 		PREV.br_blockcount = new->br_startoff - PREV.br_startoff;
 		PREV.br_startblock =
 			nullstartblock(xfs_bmap_worst_indlen(bma->ip,
 					PREV.br_blockcount));
-		xfs_iext_update_extent(ifp, bma->idx, &PREV);
-		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
+		xfs_iext_update_extent(bma->ip, state, bma->idx, &PREV);
 
 		/* insert LEFT (r[0]) and RIGHT (r[1]) at the same time */
 		xfs_iext_insert(bma->ip, bma->idx + 1, 2, &LEFT, state);
@@ -2192,10 +2169,8 @@ xfs_bmap_add_extent_unwritten_real(
 		 */
 		--*idx;
 
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		LEFT.br_blockcount += PREV.br_blockcount + RIGHT.br_blockcount;
-		xfs_iext_update_extent(ifp, *idx, &LEFT);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, &LEFT);
 
 		xfs_iext_remove(ip, *idx + 1, 2, state);
 		XFS_IFORK_NEXT_SET(ip, whichfork,
@@ -2233,10 +2208,8 @@ xfs_bmap_add_extent_unwritten_real(
 		 */
 		--*idx;
 
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		LEFT.br_blockcount += PREV.br_blockcount;
-		xfs_iext_update_extent(ifp, *idx, &LEFT);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, &LEFT);
 
 		xfs_iext_remove(ip, *idx + 1, 1, state);
 		XFS_IFORK_NEXT_SET(ip, whichfork,
@@ -2266,11 +2239,9 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting all of a previous oldext extent to newext.
 		 * The right neighbor is contiguous, the left is not.
 		 */
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		PREV.br_blockcount += RIGHT.br_blockcount;
 		PREV.br_state = new->br_state;
-		xfs_iext_update_extent(ifp, *idx, &PREV);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, &PREV);
 
 		xfs_iext_remove(ip, *idx + 1, 1, state);
 		XFS_IFORK_NEXT_SET(ip, whichfork,
@@ -2301,10 +2272,8 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Neither the left nor right neighbors are contiguous with
 		 * the new one.
 		 */
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		PREV.br_state = new->br_state;
-		xfs_iext_update_extent(ifp, *idx, &PREV);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, &PREV);
 
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
@@ -2325,18 +2294,14 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting the first part of a previous oldext extent to newext.
 		 * The left neighbor is contiguous.
 		 */
-		trace_xfs_bmap_pre_update(ip, *idx - 1, state, _THIS_IP_);
 		LEFT.br_blockcount += new->br_blockcount;
-		xfs_iext_update_extent(ifp, *idx - 1, &LEFT);
-		trace_xfs_bmap_post_update(ip, *idx - 1, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx - 1, &LEFT);
 
 		old = PREV;
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		PREV.br_startoff += new->br_blockcount;
 		PREV.br_startblock += new->br_blockcount;
 		PREV.br_blockcount -= new->br_blockcount;
-		xfs_iext_update_extent(ifp, *idx, &PREV);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, &PREV);
 
 		--*idx;
 
@@ -2366,12 +2331,10 @@ xfs_bmap_add_extent_unwritten_real(
 		 * The left neighbor is not contiguous.
 		 */
 		old = PREV;
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		PREV.br_startoff += new->br_blockcount;
 		PREV.br_startblock += new->br_blockcount;
 		PREV.br_blockcount -= new->br_blockcount;
-		xfs_iext_update_extent(ifp, *idx, &PREV);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, &PREV);
 
 		xfs_iext_insert(ip, *idx, 1, new, state);
 		XFS_IFORK_NEXT_SET(ip, whichfork,
@@ -2400,19 +2363,15 @@ xfs_bmap_add_extent_unwritten_real(
 		 * The right neighbor is contiguous with the new allocation.
 		 */
 		old = PREV;
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		PREV.br_blockcount -= new->br_blockcount;
-		xfs_iext_update_extent(ifp, *idx, &PREV);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, &PREV);
 
 		++*idx;
 
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		RIGHT.br_startoff = new->br_startoff;
 		RIGHT.br_startblock = new->br_startblock;
 		RIGHT.br_blockcount += new->br_blockcount;
-		xfs_iext_update_extent(ifp, *idx, &RIGHT);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, &RIGHT);
 
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
@@ -2440,10 +2399,8 @@ xfs_bmap_add_extent_unwritten_real(
 		 * The right neighbor is not contiguous.
 		 */
 		old = PREV;
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		PREV.br_blockcount -= new->br_blockcount;
-		xfs_iext_update_extent(ifp, *idx, &PREV);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, &PREV);
 
 		++*idx;
 		xfs_iext_insert(ip, *idx, 1, new, state);
@@ -2478,10 +2435,8 @@ xfs_bmap_add_extent_unwritten_real(
 		 * One extent becomes three extents.
 		 */
 		old = PREV;
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		PREV.br_blockcount = new->br_startoff - PREV.br_startoff;
-		xfs_iext_update_extent(ifp, *idx, &PREV);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, &PREV);
 
 		r[0] = *new;
 		r[1].br_startoff = new_endoff;
@@ -2648,7 +2603,6 @@ xfs_bmap_add_extent_hole_delay(
 		temp = left.br_blockcount + new->br_blockcount +
 			right.br_blockcount;
 
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		oldlen = startblockval(left.br_startblock) +
 			startblockval(new->br_startblock) +
 			startblockval(right.br_startblock);
@@ -2656,8 +2610,7 @@ xfs_bmap_add_extent_hole_delay(
 					 oldlen);
 		left.br_startblock = nullstartblock(newlen);
 		left.br_blockcount = temp;
-		xfs_iext_update_extent(ifp, *idx, &left);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, &left);
 
 		xfs_iext_remove(ip, *idx + 1, 1, state);
 		break;
@@ -2671,15 +2624,13 @@ xfs_bmap_add_extent_hole_delay(
 		--*idx;
 		temp = left.br_blockcount + new->br_blockcount;
 
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		oldlen = startblockval(left.br_startblock) +
 			startblockval(new->br_startblock);
 		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 					 oldlen);
 		left.br_blockcount = temp;
 		left.br_startblock = nullstartblock(newlen);
-		xfs_iext_update_extent(ifp, *idx, &left);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, &left);
 		break;
 
 	case BMAP_RIGHT_CONTIG:
@@ -2688,7 +2639,6 @@ xfs_bmap_add_extent_hole_delay(
 		 * on the right.
 		 * Merge the new allocation with the right neighbor.
 		 */
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		temp = new->br_blockcount + right.br_blockcount;
 		oldlen = startblockval(new->br_startblock) +
 			startblockval(right.br_startblock);
@@ -2697,8 +2647,7 @@ xfs_bmap_add_extent_hole_delay(
 		right.br_startoff = new->br_startoff;
 		right.br_startblock = nullstartblock(newlen);
 		right.br_blockcount = temp;
-		xfs_iext_update_extent(ifp, *idx, &right);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, &right);
 		break;
 
 	case 0:
@@ -2808,10 +2757,8 @@ xfs_bmap_add_extent_hole_real(
 		 * Merge all three into a single extent record.
 		 */
 		--*idx;
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		left.br_blockcount += new->br_blockcount + right.br_blockcount;
-		xfs_iext_update_extent(ifp, *idx, &left);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, &left);
 
 		xfs_iext_remove(ip, *idx + 1, 1, state);
 
@@ -2847,10 +2794,9 @@ xfs_bmap_add_extent_hole_real(
 		 */
 		--*idx;
 		old = left;
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+
 		left.br_blockcount += new->br_blockcount;
-		xfs_iext_update_extent(ifp, *idx, &left);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, &left);
 
 		if (cur == NULL) {
 			rval = xfs_ilog_fext(whichfork);
@@ -2873,12 +2819,11 @@ xfs_bmap_add_extent_hole_real(
 		 * Merge the new allocation with the right neighbor.
 		 */
 		old = right;
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+
 		right.br_startoff = new->br_startoff;
 		right.br_startblock = new->br_startblock;
 		right.br_blockcount += new->br_blockcount;
-		xfs_iext_update_extent(ifp, *idx, &right);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, &right);
 
 		if (cur == NULL) {
 			rval = xfs_ilog_fext(whichfork);
@@ -4769,26 +4714,22 @@ xfs_bmap_del_extent_delay(
 		/*
 		 * Deleting the first part of the extent.
 		 */
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		got->br_startoff = del_endoff;
 		got->br_blockcount -= del->br_blockcount;
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip,
 				got->br_blockcount), da_old);
 		got->br_startblock = nullstartblock((int)da_new);
-		xfs_iext_update_extent(ifp, *idx, got);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, got);
 		break;
 	case BMAP_RIGHT_FILLING:
 		/*
 		 * Deleting the last part of the extent.
 		 */
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		got->br_blockcount = got->br_blockcount - del->br_blockcount;
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip,
 				got->br_blockcount), da_old);
 		got->br_startblock = nullstartblock((int)da_new);
-		xfs_iext_update_extent(ifp, *idx, got);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, got);
 		break;
 	case 0:
 		/*
@@ -4800,8 +4741,6 @@ xfs_bmap_del_extent_delay(
 		 * Warn if either of the new indlen reservations is zero as this
 		 * can lead to delalloc problems.
 		 */
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-
 		got->br_blockcount = del->br_startoff - got->br_startoff;
 		got_indlen = xfs_bmap_worst_indlen(ip, got->br_blockcount);
 
@@ -4813,8 +4752,7 @@ xfs_bmap_del_extent_delay(
 						       del->br_blockcount);
 
 		got->br_startblock = nullstartblock((int)got_indlen);
-		xfs_iext_update_extent(ifp, *idx, got);
-		trace_xfs_bmap_post_update(ip, *idx, 0, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, got);
 
 		new.br_startoff = del_endoff;
 		new.br_state = got->br_state;
@@ -4879,30 +4817,24 @@ xfs_bmap_del_extent_cow(
 		/*
 		 * Deleting the first part of the extent.
 		 */
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		got->br_startoff = del_endoff;
 		got->br_blockcount -= del->br_blockcount;
 		got->br_startblock = del->br_startblock + del->br_blockcount;
-		xfs_iext_update_extent(ifp, *idx, got);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, got);
 		break;
 	case BMAP_RIGHT_FILLING:
 		/*
 		 * Deleting the last part of the extent.
 		 */
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		got->br_blockcount -= del->br_blockcount;
-		xfs_iext_update_extent(ifp, *idx, got);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, got);
 		break;
 	case 0:
 		/*
 		 * Deleting the middle of the extent.
 		 */
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		got->br_blockcount = del->br_startoff - got->br_startoff;
-		xfs_iext_update_extent(ifp, *idx, got);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, got);
 
 		new.br_startoff = del_endoff;
 		new.br_blockcount = got_endoff - del_endoff;
@@ -5019,7 +4951,6 @@ xfs_bmap_del_extent_real(
 		/*
 		 * Matches the whole extent.  Delete the entry.
 		 */
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		xfs_iext_remove(ip, *idx, 1, state);
 		--*idx;
 
@@ -5038,12 +4969,10 @@ xfs_bmap_del_extent_real(
 		/*
 		 * Deleting the first part of the extent.
 		 */
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		got.br_startoff = del_endoff;
 		got.br_startblock = del_endblock;
 		got.br_blockcount -= del->br_blockcount;
-		xfs_iext_update_extent(ifp, *idx, &got);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, &got);
 		if (!cur) {
 			flags |= xfs_ilog_fext(whichfork);
 			break;
@@ -5056,10 +4985,8 @@ xfs_bmap_del_extent_real(
 		/*
 		 * Deleting the last part of the extent.
 		 */
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		got.br_blockcount -= del->br_blockcount;
-		xfs_iext_update_extent(ifp, *idx, &got);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_update_extent(ip, state, *idx, &got);
 		if (!cur) {
 			flags |= xfs_ilog_fext(whichfork);
 			break;
@@ -5072,11 +4999,10 @@ xfs_bmap_del_extent_real(
 		/*
 		 * Deleting the middle of the extent.
 		 */
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-
 		old = got;
+
 		got.br_blockcount = del->br_startoff - got.br_startoff;
-		xfs_iext_update_extent(ifp, *idx, &got);
+		xfs_iext_update_extent(ip, state, *idx, &got);
 
 		new.br_startoff = del_endoff;
 		new.br_blockcount = got_endoff - del_endoff;
@@ -5120,7 +5046,7 @@ xfs_bmap_del_extent_real(
 				 * Reset the extent record back
 				 * to the original value.
 				 */
-				xfs_iext_update_extent(ifp, *idx, &old);
+				xfs_iext_update_extent(ip, state, *idx, &old);
 				flags = 0;
 				error = -ENOSPC;
 				goto done;
@@ -5130,7 +5056,6 @@ xfs_bmap_del_extent_real(
 			flags |= xfs_ilog_fext(whichfork);
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 			XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 		xfs_iext_insert(ip, *idx + 1, 1, &new, state);
 		++*idx;
 		break;
@@ -5605,7 +5530,6 @@ xfs_bmse_merge(
 	int				*logflags,	/* output */
 	struct xfs_defer_ops		*dfops)
 {
-	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_bmbt_irec		new;
 	xfs_filblks_t			blockcount;
 	int				error, i;
@@ -5654,7 +5578,8 @@ xfs_bmse_merge(
 		return error;
 
 done:
-	xfs_iext_update_extent(ifp, current_ext - 1, &new);
+	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork),
+			current_ext - 1, &new);
 	xfs_iext_remove(ip, current_ext, 1, 0);
 
 	/* update reverse mapping. rmap functions merge the rmaps for us */
@@ -5772,7 +5697,8 @@ xfs_bmse_shift_one(
 		*logflags |= XFS_ILOG_DEXT;
 	}
 
-	xfs_iext_update_extent(ifp, *current_ext, &new);
+	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork),
+			*current_ext, &new);
 
 	if (direction == SHIFT_LEFT)
 		(*current_ext)++;
@@ -6019,7 +5945,8 @@ xfs_bmap_split_extent_at(
 	}
 
 	got.br_blockcount = gotblkcnt;
-	xfs_iext_update_extent(ifp, current_ext, &got);
+	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork),
+			current_ext, &got);
 
 	logflags = XFS_ILOG_CORE;
 	if (cur) {
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 31840ca24018..7f40f53e6c43 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -2023,12 +2023,17 @@ xfs_iext_get_extent(
 
 void
 xfs_iext_update_extent(
-	struct xfs_ifork	*ifp,
+	struct xfs_inode	*ip,
+	int			state,
 	xfs_extnum_t		idx,
 	struct xfs_bmbt_irec	*gotp)
 {
+	struct xfs_ifork	*ifp = xfs_iext_state_to_fork(ip, state);
+
 	ASSERT(idx >= 0);
 	ASSERT(idx < xfs_iext_count(ifp));
 
+	trace_xfs_bmap_pre_update(ip, idx, state, _RET_IP_);
 	xfs_bmbt_set_all(xfs_iext_get_ext(ifp, idx), gotp);
+	trace_xfs_bmap_post_update(ip, idx, state, _RET_IP_);
 }
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 11af705219f6..6750f0462d21 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -187,8 +187,8 @@ bool		xfs_iext_lookup_extent(struct xfs_inode *ip,
 			xfs_extnum_t *idxp, struct xfs_bmbt_irec *gotp);
 bool		xfs_iext_get_extent(struct xfs_ifork *ifp, xfs_extnum_t idx,
 			struct xfs_bmbt_irec *gotp);
-void		xfs_iext_update_extent(struct xfs_ifork *ifp, xfs_extnum_t idx,
-			struct xfs_bmbt_irec *gotp);
+void		xfs_iext_update_extent(struct xfs_inode *ip, int state,
+			xfs_extnum_t idx, struct xfs_bmbt_irec *gotp);
 
 extern struct kmem_zone	*xfs_ifork_zone;
 
-- 
2.14.1

