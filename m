Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKfniB201017 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:41:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 119E817206E
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:41:47 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	hR7mJtTKHLlPMlZo for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:41:47 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R5OBP-0004qs-JG
	for xfs@oss.sgi.com; Sun, 18 Sep 2011 20:41:47 +0000
Message-Id: <20110918204147.542358803@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:41:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 25/27] xfs: pass bmalloca to xfs_bmap_add_extent_hole_real
References: <20110918204040.266805129@bombadil.infradead.org>
Content-Disposition: inline;
	filename=xfs-bmalloca-xfs_bmap_add_extent_hole_real
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

All the parameters passed to xfs_bmap_add_extent_hole_real() are in the
xfs_bmalloca structure now. Just pass the bmalloca parameter to the
function instead of 8 separate parameters.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-09-11 09:07:08.926447946 -0400
+++ xfs/fs/xfs/xfs_bmap.c	2011-09-11 09:07:12.679781257 -0400
@@ -1596,34 +1596,25 @@ xfs_bmap_add_extent_hole_delay(
  */
 STATIC int				/* error */
 xfs_bmap_add_extent_hole_real(
-	struct xfs_trans	*tp,
-	xfs_inode_t		*ip,	/* incore inode pointer */
-	xfs_extnum_t		*idx,	/* extent number to update/insert */
-	xfs_btree_cur_t		**curp,	/* if null, not a btree */
-	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
-	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
-	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
-	int			*logflagsp, /* inode logging flags */
-	int			whichfork) /* data or attr fork */
+	struct xfs_bmalloca	*bma,
+	int			whichfork)
 {
+	struct xfs_bmbt_irec	*new = &bma->got;
 	int			error;	/* error return value */
 	int			i;	/* temp state */
-	xfs_btree_cur_t		*cur;	/* if null, not a btree */
 	xfs_ifork_t		*ifp;	/* inode fork pointer */
 	xfs_bmbt_irec_t		left;	/* left neighbor extent entry */
 	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
 	int			rval=0;	/* return value (logging flags) */
 	int			state;	/* state bits, accessed thru macros */
 
-	*logflagsp = 0;
+	ifp = XFS_IFORK_PTR(bma->ip, whichfork);
 
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	cur = *curp;
-
-	ASSERT(*idx >= 0);
-	ASSERT(*idx <= ifp->if_bytes / sizeof(struct xfs_bmbt_rec));
+	ASSERT(bma->idx >= 0);
+	ASSERT(bma->idx <= ifp->if_bytes / sizeof(struct xfs_bmbt_rec));
 	ASSERT(!isnullstartblock(new->br_startblock));
-	ASSERT(!cur || !(cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
+	ASSERT(!bma->cur ||
+	       !(bma->cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
 
 	XFS_STATS_INC(xs_add_exlist);
 
@@ -1634,9 +1625,9 @@ xfs_bmap_add_extent_hole_real(
 	/*
 	 * Check and set flags if this segment has a left neighbor.
 	 */
-	if (*idx > 0) {
+	if (bma->idx > 0) {
 		state |= BMAP_LEFT_VALID;
-		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx - 1), &left);
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma->idx - 1), &left);
 		if (isnullstartblock(left.br_startblock))
 			state |= BMAP_LEFT_DELAY;
 	}
@@ -1645,9 +1636,9 @@ xfs_bmap_add_extent_hole_real(
 	 * Check and set flags if this segment has a current value.
 	 * Not true if we're inserting into the "hole" at eof.
 	 */
-	if (*idx < ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
+	if (bma->idx < ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
 		state |= BMAP_RIGHT_VALID;
-		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx), &right);
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma->idx), &right);
 		if (isnullstartblock(right.br_startblock))
 			state |= BMAP_RIGHT_DELAY;
 	}
@@ -1684,39 +1675,42 @@ xfs_bmap_add_extent_hole_real(
 		 * left and on the right.
 		 * Merge all three into a single extent record.
 		 */
-		--*idx;
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx),
+		--bma->idx;
+		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, bma->idx),
 			left.br_blockcount + new->br_blockcount +
 			right.br_blockcount);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
-		xfs_iext_remove(ip, *idx + 1, 1, state);
+		xfs_iext_remove(bma->ip, bma->idx + 1, 1, state);
 
-		XFS_IFORK_NEXT_SET(ip, whichfork,
-			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
-		if (cur == NULL) {
+		XFS_IFORK_NEXT_SET(bma->ip, whichfork,
+			XFS_IFORK_NEXTENTS(bma->ip, whichfork) - 1);
+		if (bma->cur == NULL) {
 			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 		} else {
 			rval = XFS_ILOG_CORE;
-			if ((error = xfs_bmbt_lookup_eq(cur,
-					right.br_startoff,
-					right.br_startblock,
-					right.br_blockcount, &i)))
+			error = xfs_bmbt_lookup_eq(bma->cur, right.br_startoff,
+					right.br_startblock, right.br_blockcount,
+					&i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_btree_delete(cur, &i)))
+			error = xfs_btree_delete(bma->cur, &i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_btree_decrement(cur, 0, &i)))
+			error = xfs_btree_decrement(bma->cur, 0, &i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_update(cur, left.br_startoff,
+			error = xfs_bmbt_update(bma->cur, left.br_startoff,
 					left.br_startblock,
 					left.br_blockcount +
 						new->br_blockcount +
 						right.br_blockcount,
-					left.br_state)))
+					left.br_state);
+			if (error)
 				goto done;
 		}
 		break;
@@ -1727,27 +1721,28 @@ xfs_bmap_add_extent_hole_real(
 		 * on the left.
 		 * Merge the new allocation with the left neighbor.
 		 */
-		--*idx;
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx),
+		--bma->idx;
+		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, bma->idx),
 			left.br_blockcount + new->br_blockcount);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
-		if (cur == NULL) {
+		if (bma->cur == NULL) {
 			rval = xfs_ilog_fext(whichfork);
 		} else {
 			rval = 0;
-			if ((error = xfs_bmbt_lookup_eq(cur,
-					left.br_startoff,
-					left.br_startblock,
-					left.br_blockcount, &i)))
+			error = xfs_bmbt_lookup_eq(bma->cur, left.br_startoff,
+					left.br_startblock, left.br_blockcount,
+					&i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_update(cur, left.br_startoff,
+			error = xfs_bmbt_update(bma->cur, left.br_startoff,
 					left.br_startblock,
 					left.br_blockcount +
 						new->br_blockcount,
-					left.br_state)))
+					left.br_state);
+			if (error)
 				goto done;
 		}
 		break;
@@ -1758,28 +1753,30 @@ xfs_bmap_add_extent_hole_real(
 		 * on the right.
 		 * Merge the new allocation with the right neighbor.
 		 */
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, *idx),
+		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
+		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, bma->idx),
 			new->br_startoff, new->br_startblock,
 			new->br_blockcount + right.br_blockcount,
 			right.br_state);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
-		if (cur == NULL) {
+		if (bma->cur == NULL) {
 			rval = xfs_ilog_fext(whichfork);
 		} else {
 			rval = 0;
-			if ((error = xfs_bmbt_lookup_eq(cur,
+			error = xfs_bmbt_lookup_eq(bma->cur,
 					right.br_startoff,
 					right.br_startblock,
-					right.br_blockcount, &i)))
+					right.br_blockcount, &i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_update(cur, new->br_startoff,
+			error = xfs_bmbt_update(bma->cur, new->br_startoff,
 					new->br_startblock,
 					new->br_blockcount +
 						right.br_blockcount,
-					right.br_state)))
+					right.br_state);
+			if (error)
 				goto done;
 		}
 		break;
@@ -1790,21 +1787,23 @@ xfs_bmap_add_extent_hole_real(
 		 * real allocation.
 		 * Insert a new entry.
 		 */
-		xfs_iext_insert(ip, *idx, 1, new, state);
-		XFS_IFORK_NEXT_SET(ip, whichfork,
-			XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
-		if (cur == NULL) {
+		xfs_iext_insert(bma->ip, bma->idx, 1, new, state);
+		XFS_IFORK_NEXT_SET(bma->ip, whichfork,
+			XFS_IFORK_NEXTENTS(bma->ip, whichfork) + 1);
+		if (bma->cur == NULL) {
 			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 		} else {
 			rval = XFS_ILOG_CORE;
-			if ((error = xfs_bmbt_lookup_eq(cur,
+			error = xfs_bmbt_lookup_eq(bma->cur,
 					new->br_startoff,
 					new->br_startblock,
-					new->br_blockcount, &i)))
+					new->br_blockcount, &i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
-			cur->bc_rec.b.br_state = new->br_state;
-			if ((error = xfs_btree_insert(cur, &i)))
+			bma->cur->bc_rec.b.br_state = new->br_state;
+			error = xfs_btree_insert(bma->cur, &i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
@@ -1812,26 +1811,26 @@ xfs_bmap_add_extent_hole_real(
 	}
 
 	/* convert to a btree if necessary */
-	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
-	    XFS_IFORK_NEXTENTS(ip, whichfork) > ifp->if_ext_max) {
+	if (XFS_IFORK_FORMAT(bma->ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
+	    XFS_IFORK_NEXTENTS(bma->ip, whichfork) > ifp->if_ext_max) {
 		int	tmp_logflags;	/* partial log flag return val */
 
-		ASSERT(cur == NULL);
-		error = xfs_bmap_extents_to_btree(tp, ip, first,
-			flist, &cur, 0, &tmp_logflags, whichfork);
-		*logflagsp |= tmp_logflags;
+		ASSERT(bma->cur == NULL);
+		error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
+				bma->firstblock, bma->flist, &bma->cur,
+				0, &tmp_logflags, whichfork);
+		bma->logflags |= tmp_logflags;
 		if (error)
 			goto done;
 	}
 
 	/* clear out the allocated field, done with it now in any case. */
-	if (cur) {
-		cur->bc_private.b.allocated = 0;
-		*curp = cur;
-	}
-	xfs_bmap_check_leaf_extents(cur, ip, whichfork);
+	if (bma->cur)
+		bma->cur->bc_private.b.allocated = 0;
+
+	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, whichfork);
 done:
-	*logflagsp |= rval;
+	bma->logflags |= rval;
 	return error;
 }
 
@@ -4709,14 +4708,10 @@ xfs_bmapi_allocate(
 	    xfs_sb_version_hasextflgbit(&mp->m_sb))
 		bma->got.br_state = XFS_EXT_UNWRITTEN;
 
-	if (bma->wasdel) {
+	if (bma->wasdel)
 		error = xfs_bmap_add_extent_delay_real(bma);
-	} else {
-		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip,
-				&bma->idx, &bma->cur, &bma->got,
-				bma->firstblock, bma->flist, &tmp_logflags,
-				whichfork);
-	}
+	else
+		error = xfs_bmap_add_extent_hole_real(bma, whichfork);
 
 	bma->logflags |= tmp_logflags;
 	if (error)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
