Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33125 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752069AbdDKLK2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2017 07:10:28 -0400
Received: from 212095007090.public.telering.at ([212.95.7.90] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cxtgp-0004pF-RL
        for linux-xfs@vger.kernel.org; Tue, 11 Apr 2017 11:10:28 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] xfs: pass individual arguments to xfs_bmap_add_extent_hole_real
Date: Tue, 11 Apr 2017 13:10:08 +0200
Message-Id: <20170411111011.9437-4-hch@lst.de>
In-Reply-To: <20170411111011.9437-1-hch@lst.de>
References: <20170411111011.9437-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

For the reflink case we'd much rather pass the required arguments than
faking up a struct xfs_bmalloca.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 123 ++++++++++++++++++++++++-----------------------
 1 file changed, 64 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b95e66fd0935..f32b2dab16a4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2879,27 +2879,30 @@ xfs_bmap_add_extent_hole_delay(
  */
 STATIC int				/* error */
 xfs_bmap_add_extent_hole_real(
-	struct xfs_bmalloca	*bma,
-	int			whichfork)
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	int			whichfork,
+	xfs_extnum_t		*idx,
+	struct xfs_btree_cur	**curp,
+	struct xfs_bmbt_irec	*new,
+	xfs_fsblock_t		*first,
+	struct xfs_defer_ops	*dfops,
+	int			*logflagsp)
 {
-	struct xfs_bmbt_irec	*new = &bma->got;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_btree_cur	*cur = *curp;
 	int			error;	/* error return value */
 	int			i;	/* temp state */
-	xfs_ifork_t		*ifp;	/* inode fork pointer */
 	xfs_bmbt_irec_t		left;	/* left neighbor extent entry */
 	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
 	int			rval=0;	/* return value (logging flags) */
 	int			state;	/* state bits, accessed thru macros */
-	struct xfs_mount	*mp;
 
-	mp = bma->ip->i_mount;
-	ifp = XFS_IFORK_PTR(bma->ip, whichfork);
-
-	ASSERT(bma->idx >= 0);
-	ASSERT(bma->idx <= xfs_iext_count(ifp));
+	ASSERT(*idx >= 0);
+	ASSERT(*idx <= xfs_iext_count(ifp));
 	ASSERT(!isnullstartblock(new->br_startblock));
-	ASSERT(!bma->cur ||
-	       !(bma->cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
+	ASSERT(!cur || !(cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
 
 	XFS_STATS_INC(mp, xs_add_exlist);
 
@@ -2912,9 +2915,9 @@ xfs_bmap_add_extent_hole_real(
 	/*
 	 * Check and set flags if this segment has a left neighbor.
 	 */
-	if (bma->idx > 0) {
+	if (*idx > 0) {
 		state |= BMAP_LEFT_VALID;
-		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma->idx - 1), &left);
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx - 1), &left);
 		if (isnullstartblock(left.br_startblock))
 			state |= BMAP_LEFT_DELAY;
 	}
@@ -2923,9 +2926,9 @@ xfs_bmap_add_extent_hole_real(
 	 * Check and set flags if this segment has a current value.
 	 * Not true if we're inserting into the "hole" at eof.
 	 */
-	if (bma->idx < xfs_iext_count(ifp)) {
+	if (*idx < xfs_iext_count(ifp)) {
 		state |= BMAP_RIGHT_VALID;
-		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma->idx), &right);
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx), &right);
 		if (isnullstartblock(right.br_startblock))
 			state |= BMAP_RIGHT_DELAY;
 	}
@@ -2962,36 +2965,36 @@ xfs_bmap_add_extent_hole_real(
 		 * left and on the right.
 		 * Merge all three into a single extent record.
 		 */
-		--bma->idx;
-		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, bma->idx),
+		--*idx;
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx),
 			left.br_blockcount + new->br_blockcount +
 			right.br_blockcount);
-		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
-		xfs_iext_remove(bma->ip, bma->idx + 1, 1, state);
+		xfs_iext_remove(ip, *idx + 1, 1, state);
 
-		XFS_IFORK_NEXT_SET(bma->ip, whichfork,
-			XFS_IFORK_NEXTENTS(bma->ip, whichfork) - 1);
-		if (bma->cur == NULL) {
+		XFS_IFORK_NEXT_SET(ip, whichfork,
+			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
+		if (cur == NULL) {
 			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 		} else {
 			rval = XFS_ILOG_CORE;
-			error = xfs_bmbt_lookup_eq(bma->cur, right.br_startoff,
+			error = xfs_bmbt_lookup_eq(cur, right.br_startoff,
 					right.br_startblock, right.br_blockcount,
 					&i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_btree_delete(bma->cur, &i);
+			error = xfs_btree_delete(cur, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_btree_decrement(bma->cur, 0, &i);
+			error = xfs_btree_decrement(cur, 0, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_bmbt_update(bma->cur, left.br_startoff,
+			error = xfs_bmbt_update(cur, left.br_startoff,
 					left.br_startblock,
 					left.br_blockcount +
 						new->br_blockcount +
@@ -3008,23 +3011,23 @@ xfs_bmap_add_extent_hole_real(
 		 * on the left.
 		 * Merge the new allocation with the left neighbor.
 		 */
-		--bma->idx;
-		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, bma->idx),
+		--*idx;
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx),
 			left.br_blockcount + new->br_blockcount);
-		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
-		if (bma->cur == NULL) {
+		if (cur == NULL) {
 			rval = xfs_ilog_fext(whichfork);
 		} else {
 			rval = 0;
-			error = xfs_bmbt_lookup_eq(bma->cur, left.br_startoff,
+			error = xfs_bmbt_lookup_eq(cur, left.br_startoff,
 					left.br_startblock, left.br_blockcount,
 					&i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_bmbt_update(bma->cur, left.br_startoff,
+			error = xfs_bmbt_update(cur, left.br_startoff,
 					left.br_startblock,
 					left.br_blockcount +
 						new->br_blockcount,
@@ -3040,25 +3043,25 @@ xfs_bmap_add_extent_hole_real(
 		 * on the right.
 		 * Merge the new allocation with the right neighbor.
 		 */
-		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
-		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, bma->idx),
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, *idx),
 			new->br_startoff, new->br_startblock,
 			new->br_blockcount + right.br_blockcount,
 			right.br_state);
-		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
-		if (bma->cur == NULL) {
+		if (cur == NULL) {
 			rval = xfs_ilog_fext(whichfork);
 		} else {
 			rval = 0;
-			error = xfs_bmbt_lookup_eq(bma->cur,
+			error = xfs_bmbt_lookup_eq(cur,
 					right.br_startoff,
 					right.br_startblock,
 					right.br_blockcount, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			error = xfs_bmbt_update(bma->cur, new->br_startoff,
+			error = xfs_bmbt_update(cur, new->br_startoff,
 					new->br_startblock,
 					new->br_blockcount +
 						right.br_blockcount,
@@ -3074,22 +3077,22 @@ xfs_bmap_add_extent_hole_real(
 		 * real allocation.
 		 * Insert a new entry.
 		 */
-		xfs_iext_insert(bma->ip, bma->idx, 1, new, state);
-		XFS_IFORK_NEXT_SET(bma->ip, whichfork,
-			XFS_IFORK_NEXTENTS(bma->ip, whichfork) + 1);
-		if (bma->cur == NULL) {
+		xfs_iext_insert(ip, *idx, 1, new, state);
+		XFS_IFORK_NEXT_SET(ip, whichfork,
+			XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
+		if (cur == NULL) {
 			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 		} else {
 			rval = XFS_ILOG_CORE;
-			error = xfs_bmbt_lookup_eq(bma->cur,
+			error = xfs_bmbt_lookup_eq(cur,
 					new->br_startoff,
 					new->br_startblock,
 					new->br_blockcount, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
-			bma->cur->bc_rec.b.br_state = new->br_state;
-			error = xfs_btree_insert(bma->cur, &i);
+			cur->bc_rec.b.br_state = new->br_state;
+			error = xfs_btree_insert(cur, &i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
@@ -3098,30 +3101,30 @@ xfs_bmap_add_extent_hole_real(
 	}
 
 	/* add reverse mapping */
-	error = xfs_rmap_map_extent(mp, bma->dfops, bma->ip, whichfork, new);
+	error = xfs_rmap_map_extent(mp, dfops, ip, whichfork, new);
 	if (error)
 		goto done;
 
 	/* convert to a btree if necessary */
-	if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
+	if (xfs_bmap_needs_btree(ip, whichfork)) {
 		int	tmp_logflags;	/* partial log flag return val */
 
-		ASSERT(bma->cur == NULL);
-		error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
-				bma->firstblock, bma->dfops, &bma->cur,
+		ASSERT(cur == NULL);
+		error = xfs_bmap_extents_to_btree(tp, ip, first, dfops, curp,
 				0, &tmp_logflags, whichfork);
-		bma->logflags |= tmp_logflags;
+		*logflagsp |= tmp_logflags;
+		cur = *curp;
 		if (error)
 			goto done;
 	}
 
 	/* clear out the allocated field, done with it now in any case. */
-	if (bma->cur)
-		bma->cur->bc_private.b.allocated = 0;
+	if (cur)
+		cur->bc_private.b.allocated = 0;
 
-	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, whichfork);
+	xfs_bmap_check_leaf_extents(cur, ip, whichfork);
 done:
-	bma->logflags |= rval;
+	*logflagsp |= rval;
 	return error;
 }
 
@@ -4386,7 +4389,9 @@ xfs_bmapi_allocate(
 	if (bma->wasdel)
 		error = xfs_bmap_add_extent_delay_real(bma, whichfork);
 	else
-		error = xfs_bmap_add_extent_hole_real(bma, whichfork);
+		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip,
+				whichfork, &bma->idx, &bma->cur, &bma->got,
+				bma->firstblock, bma->dfops, &bma->logflags);
 
 	bma->logflags |= tmp_logflags;
 	if (error)
-- 
2.11.0

