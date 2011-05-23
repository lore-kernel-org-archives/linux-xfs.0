Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4N8qvvp252134 for <xfs@oss.sgi.com>; Mon, 23 May 2011 03:52:59 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D76241654DCF
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 01:52:55 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id z9zeN031oB0HVPQM for
	<xfs@oss.sgi.com>; Mon, 23 May 2011 01:52:55 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QOQsf-0004Af-G9
	for xfs@oss.sgi.com; Mon, 23 May 2011 08:52:53 +0000
Date: Mon, 23 May 2011 04:52:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/9 v2] xfs: remove if_lastex
Message-ID: <20110523085253.GA15985@infradead.org>
References: <20110511150402.258164661@bombadil.infradead.org>
	<20110511150711.549194744@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110511150711.549194744@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The if_lastex field in struct xfs_ifork is only used as a temporary index
during xfs_bmapi and xfs_bunmapi.  Instead of using the inode fork to store
it keep it local in the callchain.  Fortunately this is very easy as
we already pass a stack copy of it down the whole chain which can simplify
be changed to be passed by reference.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-05-22 12:45:44.944448378 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-05-22 12:54:37.379971757 +0200
@@ -89,28 +89,13 @@ xfs_bmap_add_attrfork_local(
 	int			*flags);	/* inode logging flags */
 
 /*
- * Called by xfs_bmapi to update file extent records and the btree
- * after allocating space (or doing a delayed allocation).
- */
-STATIC int				/* error */
-xfs_bmap_add_extent(
-	xfs_inode_t		*ip,	/* incore inode pointer */
-	xfs_extnum_t		idx,	/* extent number to update/insert */
-	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
-	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
-	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
-	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
-	int			*logflagsp, /* inode logging flags */
-	int			whichfork); /* data or attr fork */
-
-/*
  * Called by xfs_bmap_add_extent to handle cases converting a delayed
  * allocation to a real allocation.
  */
 STATIC int				/* error */
 xfs_bmap_add_extent_delay_real(
 	xfs_inode_t		*ip,	/* incore inode pointer */
-	xfs_extnum_t		idx,	/* extent number to update/insert */
+	xfs_extnum_t		*idx,	/* extent number to update/insert */
 	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	xfs_filblks_t		*dnew,	/* new delayed-alloc indirect blocks */
@@ -125,7 +110,7 @@ xfs_bmap_add_extent_delay_real(
 STATIC int				/* error */
 xfs_bmap_add_extent_hole_delay(
 	xfs_inode_t		*ip,	/* incore inode pointer */
-	xfs_extnum_t		idx,	/* extent number to update/insert */
+	xfs_extnum_t		*idx,	/* extent number to update/insert */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	int			*logflagsp); /* inode logging flags */
 
@@ -136,7 +121,7 @@ xfs_bmap_add_extent_hole_delay(
 STATIC int				/* error */
 xfs_bmap_add_extent_hole_real(
 	xfs_inode_t		*ip,	/* incore inode pointer */
-	xfs_extnum_t		idx,	/* extent number to update/insert */
+	xfs_extnum_t		*idx,	/* extent number to update/insert */
 	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	int			*logflagsp, /* inode logging flags */
@@ -149,7 +134,7 @@ xfs_bmap_add_extent_hole_real(
 STATIC int				/* error */
 xfs_bmap_add_extent_unwritten_real(
 	xfs_inode_t		*ip,	/* incore inode pointer */
-	xfs_extnum_t		idx,	/* extent number to update/insert */
+	xfs_extnum_t		*idx,	/* extent number to update/insert */
 	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	int			*logflagsp); /* inode logging flags */
@@ -455,7 +440,7 @@ xfs_bmap_add_attrfork_local(
 STATIC int				/* error */
 xfs_bmap_add_extent(
 	xfs_inode_t		*ip,	/* incore inode pointer */
-	xfs_extnum_t		idx,	/* extent number to update/insert */
+	xfs_extnum_t		*idx,	/* extent number to update/insert */
 	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
@@ -472,23 +457,27 @@ xfs_bmap_add_extent(
 	xfs_extnum_t		nextents; /* number of extents in file now */
 
 	XFS_STATS_INC(xs_add_exlist);
+
 	cur = *curp;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
-	ASSERT(idx <= nextents);
 	da_old = da_new = 0;
 	error = 0;
+
+	ASSERT(*idx >= 0);
+	ASSERT(*idx <= nextents);
+
 	/*
 	 * This is the first extent added to a new/empty file.
 	 * Special case this one, so other routines get to assume there are
 	 * already extents in the list.
 	 */
 	if (nextents == 0) {
-		xfs_iext_insert(ip, 0, 1, new,
+		xfs_iext_insert(ip, *idx, 1, new,
 				whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0);
 
 		ASSERT(cur == NULL);
-		ifp->if_lastex = 0;
+
 		if (!isnullstartblock(new->br_startblock)) {
 			XFS_IFORK_NEXT_SET(ip, whichfork, 1);
 			logflags = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
@@ -502,27 +491,25 @@ xfs_bmap_add_extent(
 		if (cur)
 			ASSERT((cur->bc_private.b.flags &
 				XFS_BTCUR_BPRV_WASDEL) == 0);
-		error = xfs_bmap_add_extent_hole_delay(ip, idx, new, &logflags);
-		if (error)
-			goto done;
+		error = xfs_bmap_add_extent_hole_delay(ip, idx, new,
+						       &logflags);
 	}
 	/*
 	 * Real allocation off the end of the file.
 	 */
-	else if (idx == nextents) {
+	else if (*idx == nextents) {
 		if (cur)
 			ASSERT((cur->bc_private.b.flags &
 				XFS_BTCUR_BPRV_WASDEL) == 0);
-		if ((error = xfs_bmap_add_extent_hole_real(ip, idx, cur, new,
-				&logflags, whichfork)))
-			goto done;
+		error = xfs_bmap_add_extent_hole_real(ip, idx, cur, new,
+				&logflags, whichfork);
 	} else {
 		xfs_bmbt_irec_t	prev;	/* old extent at offset idx */
 
 		/*
 		 * Get the record referred to by idx.
 		 */
-		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), &prev);
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx), &prev);
 		/*
 		 * If it's a real allocation record, and the new allocation ends
 		 * after the start of the referred to record, then we're filling
@@ -537,23 +524,18 @@ xfs_bmap_add_extent(
 				if (cur)
 					ASSERT(cur->bc_private.b.flags &
 						XFS_BTCUR_BPRV_WASDEL);
-				error = xfs_bmap_add_extent_delay_real(ip, idx,
-						&cur, new, &da_new, first,
-						flist, &logflags);
-				if (error)
-					goto done;
-			} else if (new->br_state == XFS_EXT_NORM) {
-				ASSERT(new->br_state == XFS_EXT_NORM);
-				if ((error = xfs_bmap_add_extent_unwritten_real(
-					ip, idx, &cur, new, &logflags)))
-					goto done;
+				error = xfs_bmap_add_extent_delay_real(ip,
+						idx, &cur, new, &da_new,
+						first, flist, &logflags);
 			} else {
-				ASSERT(new->br_state == XFS_EXT_UNWRITTEN);
-				if ((error = xfs_bmap_add_extent_unwritten_real(
-					ip, idx, &cur, new, &logflags)))
+				ASSERT(new->br_state == XFS_EXT_NORM ||
+				       new->br_state == XFS_EXT_UNWRITTEN);
+
+				error = xfs_bmap_add_extent_unwritten_real(ip,
+						idx, &cur, new, &logflags);
+				if (error)
 					goto done;
 			}
-			ASSERT(*curp == cur || *curp == NULL);
 		}
 		/*
 		 * Otherwise we're filling in a hole with an allocation.
@@ -562,13 +544,15 @@ xfs_bmap_add_extent(
 			if (cur)
 				ASSERT((cur->bc_private.b.flags &
 					XFS_BTCUR_BPRV_WASDEL) == 0);
-			if ((error = xfs_bmap_add_extent_hole_real(ip, idx, cur,
-					new, &logflags, whichfork)))
-				goto done;
+			error = xfs_bmap_add_extent_hole_real(ip, idx, cur,
+					new, &logflags, whichfork);
 		}
 	}
 
+	if (error)
+		goto done;
 	ASSERT(*curp == cur || *curp == NULL);
+
 	/*
 	 * Convert to a btree if necessary.
 	 */
@@ -621,7 +605,7 @@ done:
 STATIC int				/* error */
 xfs_bmap_add_extent_delay_real(
 	xfs_inode_t		*ip,	/* incore inode pointer */
-	xfs_extnum_t		idx,	/* extent number to update/insert */
+	xfs_extnum_t		*idx,	/* extent number to update/insert */
 	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	xfs_filblks_t		*dnew,	/* new delayed-alloc indirect blocks */
@@ -653,7 +637,7 @@ xfs_bmap_add_extent_delay_real(
 	 */
 	cur = *curp;
 	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-	ep = xfs_iext_get_ext(ifp, idx);
+	ep = xfs_iext_get_ext(ifp, *idx);
 	xfs_bmbt_get_all(ep, &PREV);
 	new_endoff = new->br_startoff + new->br_blockcount;
 	ASSERT(PREV.br_startoff <= new->br_startoff);
@@ -672,9 +656,9 @@ xfs_bmap_add_extent_delay_real(
 	 * Check and set flags if this segment has a left neighbor.
 	 * Don't set contiguous if the combined extent would be too large.
 	 */
-	if (idx > 0) {
+	if (*idx > 0) {
 		state |= BMAP_LEFT_VALID;
-		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx - 1), &LEFT);
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx - 1), &LEFT);
 
 		if (isnullstartblock(LEFT.br_startblock))
 			state |= BMAP_LEFT_DELAY;
@@ -692,9 +676,9 @@ xfs_bmap_add_extent_delay_real(
 	 * Don't set contiguous if the combined extent would be too large.
 	 * Also check for all-three-contiguous being too large.
 	 */
-	if (idx < ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1) {
+	if (*idx < ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1) {
 		state |= BMAP_RIGHT_VALID;
-		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx + 1), &RIGHT);
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx + 1), &RIGHT);
 
 		if (isnullstartblock(RIGHT.br_startblock))
 			state |= BMAP_RIGHT_DELAY;
@@ -725,14 +709,14 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in all of a previously delayed allocation extent.
 		 * The left and right neighbors are both contiguous with new.
 		 */
-		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
+		--*idx;
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx),
 			LEFT.br_blockcount + PREV.br_blockcount +
 			RIGHT.br_blockcount);
-		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
-		xfs_iext_remove(ip, idx, 2, state);
-		ip->i_df.if_lastex = idx - 1;
+		xfs_iext_remove(ip, *idx + 1, 2, state);
 		ip->i_d.di_nextents--;
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -764,13 +748,14 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in all of a previously delayed allocation extent.
 		 * The left neighbor is contiguous, the right is not.
 		 */
-		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
+		--*idx;
+
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx),
 			LEFT.br_blockcount + PREV.br_blockcount);
-		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
-		ip->i_df.if_lastex = idx - 1;
-		xfs_iext_remove(ip, idx, 1, state);
+		xfs_iext_remove(ip, *idx + 1, 1, state);
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
 		else {
@@ -794,14 +779,13 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in all of a previously delayed allocation extent.
 		 * The right neighbor is contiguous, the left is not.
 		 */
-		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		xfs_bmbt_set_startblock(ep, new->br_startblock);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount + RIGHT.br_blockcount);
-		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
-		ip->i_df.if_lastex = idx;
-		xfs_iext_remove(ip, idx + 1, 1, state);
+		xfs_iext_remove(ip, *idx + 1, 1, state);
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
 		else {
@@ -817,6 +801,7 @@ xfs_bmap_add_extent_delay_real(
 					RIGHT.br_blockcount, PREV.br_state)))
 				goto done;
 		}
+
 		*dnew = 0;
 		break;
 
@@ -826,11 +811,10 @@ xfs_bmap_add_extent_delay_real(
 		 * Neither the left nor right neighbors are contiguous with
 		 * the new one.
 		 */
-		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		xfs_bmbt_set_startblock(ep, new->br_startblock);
-		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
-		ip->i_df.if_lastex = idx;
 		ip->i_d.di_nextents++;
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -846,6 +830,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
+
 		*dnew = 0;
 		break;
 
@@ -854,17 +839,16 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in the first part of a previous delayed allocation.
 		 * The left neighbor is contiguous.
 		 */
-		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
+		trace_xfs_bmap_pre_update(ip, *idx - 1, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx - 1),
 			LEFT.br_blockcount + new->br_blockcount);
 		xfs_bmbt_set_startoff(ep,
 			PREV.br_startoff + new->br_blockcount);
-		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx - 1, state, _THIS_IP_);
 
 		temp = PREV.br_blockcount - new->br_blockcount;
-		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);
-		ip->i_df.if_lastex = idx - 1;
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
 		else {
@@ -884,7 +868,9 @@ xfs_bmap_add_extent_delay_real(
 		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 			startblockval(PREV.br_startblock));
 		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
-		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+
+		--*idx;
 		*dnew = temp;
 		break;
 
@@ -893,12 +879,11 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in the first part of a previous delayed allocation.
 		 * The left neighbor is not contiguous.
 		 */
-		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		xfs_bmbt_set_startoff(ep, new_endoff);
 		temp = PREV.br_blockcount - new->br_blockcount;
 		xfs_bmbt_set_blockcount(ep, temp);
-		xfs_iext_insert(ip, idx, 1, new, state);
-		ip->i_df.if_lastex = idx;
+		xfs_iext_insert(ip, *idx, 1, new, state);
 		ip->i_d.di_nextents++;
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -926,9 +911,10 @@ xfs_bmap_add_extent_delay_real(
 		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 			startblockval(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
-		ep = xfs_iext_get_ext(ifp, idx + 1);
+		ep = xfs_iext_get_ext(ifp, *idx + 1);
 		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
-		trace_xfs_bmap_post_update(ip, idx + 1, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx + 1, state, _THIS_IP_);
+
 		*dnew = temp;
 		break;
 
@@ -938,15 +924,13 @@ xfs_bmap_add_extent_delay_real(
 		 * The right neighbor is contiguous with the new allocation.
 		 */
 		temp = PREV.br_blockcount - new->br_blockcount;
-		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
-		trace_xfs_bmap_pre_update(ip, idx + 1, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, *idx + 1, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);
-		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, idx + 1),
+		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, *idx + 1),
 			new->br_startoff, new->br_startblock,
 			new->br_blockcount + RIGHT.br_blockcount,
 			RIGHT.br_state);
-		trace_xfs_bmap_post_update(ip, idx + 1, state, _THIS_IP_);
-		ip->i_df.if_lastex = idx + 1;
+		trace_xfs_bmap_post_update(ip, *idx + 1, state, _THIS_IP_);
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
 		else {
@@ -963,10 +947,14 @@ xfs_bmap_add_extent_delay_real(
 					RIGHT.br_state)))
 				goto done;
 		}
+
 		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 			startblockval(PREV.br_startblock));
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
-		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+
+		++*idx;
 		*dnew = temp;
 		break;
 
@@ -976,10 +964,9 @@ xfs_bmap_add_extent_delay_real(
 		 * The right neighbor is not contiguous.
 		 */
 		temp = PREV.br_blockcount - new->br_blockcount;
-		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);
-		xfs_iext_insert(ip, idx + 1, 1, new, state);
-		ip->i_df.if_lastex = idx + 1;
+		xfs_iext_insert(ip, *idx + 1, 1, new, state);
 		ip->i_d.di_nextents++;
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -1007,9 +994,11 @@ xfs_bmap_add_extent_delay_real(
 		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 			startblockval(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
-		ep = xfs_iext_get_ext(ifp, idx);
+		ep = xfs_iext_get_ext(ifp, *idx);
 		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
-		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+
+		++*idx;
 		*dnew = temp;
 		break;
 
@@ -1036,7 +1025,7 @@ xfs_bmap_add_extent_delay_real(
 		 */
 		temp = new->br_startoff - PREV.br_startoff;
 		temp2 = PREV.br_startoff + PREV.br_blockcount - new_endoff;
-		trace_xfs_bmap_pre_update(ip, idx, 0, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, *idx, 0, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);	/* truncate PREV */
 		LEFT = *new;
 		RIGHT.br_state = PREV.br_state;
@@ -1045,8 +1034,7 @@ xfs_bmap_add_extent_delay_real(
 		RIGHT.br_startoff = new_endoff;
 		RIGHT.br_blockcount = temp2;
 		/* insert LEFT (r[0]) and RIGHT (r[1]) at the same time */
-		xfs_iext_insert(ip, idx + 1, 2, &LEFT, state);
-		ip->i_df.if_lastex = idx + 1;
+		xfs_iext_insert(ip, *idx + 1, 2, &LEFT, state);
 		ip->i_d.di_nextents++;
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -1103,13 +1091,15 @@ xfs_bmap_add_extent_delay_real(
 				}
 			}
 		}
-		ep = xfs_iext_get_ext(ifp, idx);
+		ep = xfs_iext_get_ext(ifp, *idx);
 		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
-		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
-		trace_xfs_bmap_pre_update(ip, idx + 2, state, _THIS_IP_);
-		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, idx + 2),
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, *idx + 2, state, _THIS_IP_);
+		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, *idx + 2),
 			nullstartblock((int)temp2));
-		trace_xfs_bmap_post_update(ip, idx + 2, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx + 2, state, _THIS_IP_);
+
+		++*idx;
 		*dnew = temp + temp2;
 		break;
 
@@ -1141,7 +1131,7 @@ done:
 STATIC int				/* error */
 xfs_bmap_add_extent_unwritten_real(
 	xfs_inode_t		*ip,	/* incore inode pointer */
-	xfs_extnum_t		idx,	/* extent number to update/insert */
+	xfs_extnum_t		*idx,	/* extent number to update/insert */
 	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	int			*logflagsp) /* inode logging flags */
@@ -1168,7 +1158,7 @@ xfs_bmap_add_extent_unwritten_real(
 	error = 0;
 	cur = *curp;
 	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-	ep = xfs_iext_get_ext(ifp, idx);
+	ep = xfs_iext_get_ext(ifp, *idx);
 	xfs_bmbt_get_all(ep, &PREV);
 	newext = new->br_state;
 	oldext = (newext == XFS_EXT_UNWRITTEN) ?
@@ -1191,9 +1181,9 @@ xfs_bmap_add_extent_unwritten_real(
 	 * Check and set flags if this segment has a left neighbor.
 	 * Don't set contiguous if the combined extent would be too large.
 	 */
-	if (idx > 0) {
+	if (*idx > 0) {
 		state |= BMAP_LEFT_VALID;
-		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx - 1), &LEFT);
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx - 1), &LEFT);
 
 		if (isnullstartblock(LEFT.br_startblock))
 			state |= BMAP_LEFT_DELAY;
@@ -1211,9 +1201,9 @@ xfs_bmap_add_extent_unwritten_real(
 	 * Don't set contiguous if the combined extent would be too large.
 	 * Also check for all-three-contiguous being too large.
 	 */
-	if (idx < ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1) {
+	if (*idx < ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1) {
 		state |= BMAP_RIGHT_VALID;
-		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx + 1), &RIGHT);
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx + 1), &RIGHT);
 		if (isnullstartblock(RIGHT.br_startblock))
 			state |= BMAP_RIGHT_DELAY;
 	}
@@ -1242,14 +1232,15 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting all of a previous oldext extent to newext.
 		 * The left and right neighbors are both contiguous with new.
 		 */
-		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
+		--*idx;
+
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx),
 			LEFT.br_blockcount + PREV.br_blockcount +
 			RIGHT.br_blockcount);
-		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
-		xfs_iext_remove(ip, idx, 2, state);
-		ip->i_df.if_lastex = idx - 1;
+		xfs_iext_remove(ip, *idx + 1, 2, state);
 		ip->i_d.di_nextents -= 2;
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -1285,13 +1276,14 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting all of a previous oldext extent to newext.
 		 * The left neighbor is contiguous, the right is not.
 		 */
-		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
+		--*idx;
+
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx),
 			LEFT.br_blockcount + PREV.br_blockcount);
-		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
-		ip->i_df.if_lastex = idx - 1;
-		xfs_iext_remove(ip, idx, 1, state);
+		xfs_iext_remove(ip, *idx + 1, 1, state);
 		ip->i_d.di_nextents--;
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -1321,13 +1313,12 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting all of a previous oldext extent to newext.
 		 * The right neighbor is contiguous, the left is not.
 		 */
-		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount + RIGHT.br_blockcount);
 		xfs_bmbt_set_state(ep, newext);
-		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
-		ip->i_df.if_lastex = idx;
-		xfs_iext_remove(ip, idx + 1, 1, state);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_remove(ip, *idx + 1, 1, state);
 		ip->i_d.di_nextents--;
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -1358,11 +1349,10 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Neither the left nor right neighbors are contiguous with
 		 * the new one.
 		 */
-		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		xfs_bmbt_set_state(ep, newext);
-		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
-		ip->i_df.if_lastex = idx;
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
 		else {
@@ -1384,21 +1374,22 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting the first part of a previous oldext extent to newext.
 		 * The left neighbor is contiguous.
 		 */
-		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
+		trace_xfs_bmap_pre_update(ip, *idx - 1, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx - 1),
 			LEFT.br_blockcount + new->br_blockcount);
 		xfs_bmbt_set_startoff(ep,
 			PREV.br_startoff + new->br_blockcount);
-		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx - 1, state, _THIS_IP_);
 
-		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		xfs_bmbt_set_startblock(ep,
 			new->br_startblock + new->br_blockcount);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount - new->br_blockcount);
-		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+
+		--*idx;
 
-		ip->i_df.if_lastex = idx - 1;
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
 		else {
@@ -1429,17 +1420,16 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting the first part of a previous oldext extent to newext.
 		 * The left neighbor is not contiguous.
 		 */
-		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		ASSERT(ep && xfs_bmbt_get_state(ep) == oldext);
 		xfs_bmbt_set_startoff(ep, new_endoff);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount - new->br_blockcount);
 		xfs_bmbt_set_startblock(ep,
 			new->br_startblock + new->br_blockcount);
-		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
-		xfs_iext_insert(ip, idx, 1, new, state);
-		ip->i_df.if_lastex = idx;
+		xfs_iext_insert(ip, *idx, 1, new, state);
 		ip->i_d.di_nextents++;
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -1468,17 +1458,19 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting the last part of a previous oldext extent to newext.
 		 * The right neighbor is contiguous with the new allocation.
 		 */
-		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
-		trace_xfs_bmap_pre_update(ip, idx + 1, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount - new->br_blockcount);
-		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
-		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, idx + 1),
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+
+		++*idx;
+
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, *idx),
 			new->br_startoff, new->br_startblock,
 			new->br_blockcount + RIGHT.br_blockcount, newext);
-		trace_xfs_bmap_post_update(ip, idx + 1, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
-		ip->i_df.if_lastex = idx + 1;
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
 		else {
@@ -1508,13 +1500,14 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting the last part of a previous oldext extent to newext.
 		 * The right neighbor is not contiguous.
 		 */
-		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount - new->br_blockcount);
-		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+
+		++*idx;
+		xfs_iext_insert(ip, *idx, 1, new, state);
 
-		xfs_iext_insert(ip, idx + 1, 1, new, state);
-		ip->i_df.if_lastex = idx + 1;
 		ip->i_d.di_nextents++;
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -1548,10 +1541,10 @@ xfs_bmap_add_extent_unwritten_real(
 		 * newext.  Contiguity is impossible here.
 		 * One extent becomes three extents.
 		 */
-		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep,
 			new->br_startoff - PREV.br_startoff);
-		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
 		r[0] = *new;
 		r[1].br_startoff = new_endoff;
@@ -1559,8 +1552,10 @@ xfs_bmap_add_extent_unwritten_real(
 			PREV.br_startoff + PREV.br_blockcount - new_endoff;
 		r[1].br_startblock = new->br_startblock + new->br_blockcount;
 		r[1].br_state = oldext;
-		xfs_iext_insert(ip, idx + 1, 2, &r[0], state);
-		ip->i_df.if_lastex = idx + 1;
+
+		++*idx;
+		xfs_iext_insert(ip, *idx, 2, &r[0], state);
+
 		ip->i_d.di_nextents += 2;
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
@@ -1630,7 +1625,7 @@ done:
 STATIC int				/* error */
 xfs_bmap_add_extent_hole_delay(
 	xfs_inode_t		*ip,	/* incore inode pointer */
-	xfs_extnum_t		idx,	/* extent number to update/insert */
+	xfs_extnum_t		*idx,	/* extent number to update/insert */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	int			*logflagsp) /* inode logging flags */
 {
@@ -1644,16 +1639,16 @@ xfs_bmap_add_extent_hole_delay(
 	xfs_filblks_t		temp=0;	/* temp for indirect calculations */
 
 	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-	ep = xfs_iext_get_ext(ifp, idx);
+	ep = xfs_iext_get_ext(ifp, *idx);
 	state = 0;
 	ASSERT(isnullstartblock(new->br_startblock));
 
 	/*
 	 * Check and set flags if this segment has a left neighbor
 	 */
-	if (idx > 0) {
+	if (*idx > 0) {
 		state |= BMAP_LEFT_VALID;
-		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx - 1), &left);
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx - 1), &left);
 
 		if (isnullstartblock(left.br_startblock))
 			state |= BMAP_LEFT_DELAY;
@@ -1663,7 +1658,7 @@ xfs_bmap_add_extent_hole_delay(
 	 * Check and set flags if the current (right) segment exists.
 	 * If it doesn't exist, we're converting the hole at end-of-file.
 	 */
-	if (idx < ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
+	if (*idx < ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
 		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(ep, &right);
 
@@ -1698,21 +1693,21 @@ xfs_bmap_add_extent_hole_delay(
 		 * on the left and on the right.
 		 * Merge all three into a single extent record.
 		 */
+		--*idx;
 		temp = left.br_blockcount + new->br_blockcount +
 			right.br_blockcount;
 
-		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1), temp);
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx), temp);
 		oldlen = startblockval(left.br_startblock) +
 			startblockval(new->br_startblock) +
 			startblockval(right.br_startblock);
 		newlen = xfs_bmap_worst_indlen(ip, temp);
-		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, idx - 1),
+		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, *idx),
 			nullstartblock((int)newlen));
-		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
-		xfs_iext_remove(ip, idx, 1, state);
-		ip->i_df.if_lastex = idx - 1;
+		xfs_iext_remove(ip, *idx + 1, 1, state);
 		break;
 
 	case BMAP_LEFT_CONTIG:
@@ -1721,17 +1716,17 @@ xfs_bmap_add_extent_hole_delay(
 		 * on the left.
 		 * Merge the new allocation with the left neighbor.
 		 */
+		--*idx;
 		temp = left.br_blockcount + new->br_blockcount;
-		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1), temp);
+
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx), temp);
 		oldlen = startblockval(left.br_startblock) +
 			startblockval(new->br_startblock);
 		newlen = xfs_bmap_worst_indlen(ip, temp);
-		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, idx - 1),
+		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, *idx),
 			nullstartblock((int)newlen));
-		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
-
-		ip->i_df.if_lastex = idx - 1;
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 		break;
 
 	case BMAP_RIGHT_CONTIG:
@@ -1740,16 +1735,14 @@ xfs_bmap_add_extent_hole_delay(
 		 * on the right.
 		 * Merge the new allocation with the right neighbor.
 		 */
-		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		temp = new->br_blockcount + right.br_blockcount;
 		oldlen = startblockval(new->br_startblock) +
 			startblockval(right.br_startblock);
 		newlen = xfs_bmap_worst_indlen(ip, temp);
 		xfs_bmbt_set_allf(ep, new->br_startoff,
 			nullstartblock((int)newlen), temp, right.br_state);
-		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
-
-		ip->i_df.if_lastex = idx;
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 		break;
 
 	case 0:
@@ -1759,8 +1752,7 @@ xfs_bmap_add_extent_hole_delay(
 		 * Insert a new entry.
 		 */
 		oldlen = newlen = 0;
-		xfs_iext_insert(ip, idx, 1, new, state);
-		ip->i_df.if_lastex = idx;
+		xfs_iext_insert(ip, *idx, 1, new, state);
 		break;
 	}
 	if (oldlen != newlen) {
@@ -1782,7 +1774,7 @@ xfs_bmap_add_extent_hole_delay(
 STATIC int				/* error */
 xfs_bmap_add_extent_hole_real(
 	xfs_inode_t		*ip,	/* incore inode pointer */
-	xfs_extnum_t		idx,	/* extent number to update/insert */
+	xfs_extnum_t		*idx,	/* extent number to update/insert */
 	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	int			*logflagsp, /* inode logging flags */
@@ -1798,8 +1790,8 @@ xfs_bmap_add_extent_hole_real(
 	int			state;	/* state bits, accessed thru macros */
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-	ASSERT(idx <= ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t));
-	ep = xfs_iext_get_ext(ifp, idx);
+	ASSERT(*idx <= ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t));
+	ep = xfs_iext_get_ext(ifp, *idx);
 	state = 0;
 
 	if (whichfork == XFS_ATTR_FORK)
@@ -1808,9 +1800,9 @@ xfs_bmap_add_extent_hole_real(
 	/*
 	 * Check and set flags if this segment has a left neighbor.
 	 */
-	if (idx > 0) {
+	if (*idx > 0) {
 		state |= BMAP_LEFT_VALID;
-		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx - 1), &left);
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx - 1), &left);
 		if (isnullstartblock(left.br_startblock))
 			state |= BMAP_LEFT_DELAY;
 	}
@@ -1819,7 +1811,7 @@ xfs_bmap_add_extent_hole_real(
 	 * Check and set flags if this segment has a current value.
 	 * Not true if we're inserting into the "hole" at eof.
 	 */
-	if (idx < ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
+	if (*idx < ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
 		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(ep, &right);
 		if (isnullstartblock(right.br_startblock))
@@ -1858,14 +1850,15 @@ xfs_bmap_add_extent_hole_real(
 		 * left and on the right.
 		 * Merge all three into a single extent record.
 		 */
-		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
+		--*idx;
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx),
 			left.br_blockcount + new->br_blockcount +
 			right.br_blockcount);
-		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+
+		xfs_iext_remove(ip, *idx + 1, 1, state);
 
-		xfs_iext_remove(ip, idx, 1, state);
-		ifp->if_lastex = idx - 1;
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
 		if (cur == NULL) {
@@ -1900,12 +1893,12 @@ xfs_bmap_add_extent_hole_real(
 		 * on the left.
 		 * Merge the new allocation with the left neighbor.
 		 */
-		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
+		--*idx;
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx),
 			left.br_blockcount + new->br_blockcount);
-		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
-		ifp->if_lastex = idx - 1;
 		if (cur == NULL) {
 			rval = xfs_ilog_fext(whichfork);
 		} else {
@@ -1931,13 +1924,12 @@ xfs_bmap_add_extent_hole_real(
 		 * on the right.
 		 * Merge the new allocation with the right neighbor.
 		 */
-		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		xfs_bmbt_set_allf(ep, new->br_startoff, new->br_startblock,
 			new->br_blockcount + right.br_blockcount,
 			right.br_state);
-		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
-		ifp->if_lastex = idx;
 		if (cur == NULL) {
 			rval = xfs_ilog_fext(whichfork);
 		} else {
@@ -1963,8 +1955,7 @@ xfs_bmap_add_extent_hole_real(
 		 * real allocation.
 		 * Insert a new entry.
 		 */
-		xfs_iext_insert(ip, idx, 1, new, state);
-		ifp->if_lastex = idx;
+		xfs_iext_insert(ip, *idx, 1, new, state);
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 			XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
 		if (cur == NULL) {
@@ -2812,7 +2803,7 @@ STATIC int				/* error */
 xfs_bmap_del_extent(
 	xfs_inode_t		*ip,	/* incore inode pointer */
 	xfs_trans_t		*tp,	/* current transaction pointer */
-	xfs_extnum_t		idx,	/* extent number to update/delete */
+	xfs_extnum_t		*idx,	/* extent number to update/delete */
 	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
 	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*del,	/* data to remove from extents */
@@ -2848,10 +2839,10 @@ xfs_bmap_del_extent(
 
 	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-	ASSERT((idx >= 0) && (idx < ifp->if_bytes /
+	ASSERT((*idx >= 0) && (*idx < ifp->if_bytes /
 		(uint)sizeof(xfs_bmbt_rec_t)));
 	ASSERT(del->br_blockcount > 0);
-	ep = xfs_iext_get_ext(ifp, idx);
+	ep = xfs_iext_get_ext(ifp, *idx);
 	xfs_bmbt_get_all(ep, &got);
 	ASSERT(got.br_startoff <= del->br_startoff);
 	del_endoff = del->br_startoff + del->br_blockcount;
@@ -2925,9 +2916,8 @@ xfs_bmap_del_extent(
 		/*
 		 * Matches the whole extent.  Delete the entry.
 		 */
-		xfs_iext_remove(ip, idx, 1,
+		xfs_iext_remove(ip, *idx, 1,
 				whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0);
-		ifp->if_lastex = idx;
 		if (delay)
 			break;
 		XFS_IFORK_NEXT_SET(ip, whichfork,
@@ -2946,21 +2936,20 @@ xfs_bmap_del_extent(
 		/*
 		 * Deleting the first part of the extent.
 		 */
-		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		xfs_bmbt_set_startoff(ep, del_endoff);
 		temp = got.br_blockcount - del->br_blockcount;
 		xfs_bmbt_set_blockcount(ep, temp);
-		ifp->if_lastex = idx;
 		if (delay) {
 			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 				da_old);
 			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
-			trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+			trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 			da_new = temp;
 			break;
 		}
 		xfs_bmbt_set_startblock(ep, del_endblock);
-		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 		if (!cur) {
 			flags |= xfs_ilog_fext(whichfork);
 			break;
@@ -2976,18 +2965,17 @@ xfs_bmap_del_extent(
 		 * Deleting the last part of the extent.
 		 */
 		temp = got.br_blockcount - del->br_blockcount;
-		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);
-		ifp->if_lastex = idx;
 		if (delay) {
 			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 				da_old);
 			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
-			trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+			trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 			da_new = temp;
 			break;
 		}
-		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 		if (!cur) {
 			flags |= xfs_ilog_fext(whichfork);
 			break;
@@ -3004,7 +2992,7 @@ xfs_bmap_del_extent(
 		 * Deleting the middle of the extent.
 		 */
 		temp = del->br_startoff - got.br_startoff;
-		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);
 		new.br_startoff = del_endoff;
 		temp2 = got_endoff - del_endoff;
@@ -3091,9 +3079,9 @@ xfs_bmap_del_extent(
 				}
 			}
 		}
-		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
-		xfs_iext_insert(ip, idx + 1, 1, &new, state);
-		ifp->if_lastex = idx + 1;
+		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		xfs_iext_insert(ip, *idx + 1, 1, &new, state);
+		++*idx;
 		break;
 	}
 	/*
@@ -4674,13 +4662,12 @@ xfs_bmapi(
 				if (!wasdelay && (flags & XFS_BMAPI_PREALLOC))
 					got.br_state = XFS_EXT_UNWRITTEN;
 			}
-			error = xfs_bmap_add_extent(ip, lastx, &cur, &got,
+			error = xfs_bmap_add_extent(ip, &lastx, &cur, &got,
 				firstblock, flist, &tmp_logflags,
 				whichfork);
 			logflags |= tmp_logflags;
 			if (error)
 				goto error0;
-			lastx = ifp->if_lastex;
 			ep = xfs_iext_get_ext(ifp, lastx);
 			nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
 			xfs_bmbt_get_all(ep, &got);
@@ -4776,13 +4763,12 @@ xfs_bmapi(
 			mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
 						? XFS_EXT_NORM
 						: XFS_EXT_UNWRITTEN;
-			error = xfs_bmap_add_extent(ip, lastx, &cur, mval,
+			error = xfs_bmap_add_extent(ip, &lastx, &cur, mval,
 				firstblock, flist, &tmp_logflags,
 				whichfork);
 			logflags |= tmp_logflags;
 			if (error)
 				goto error0;
-			lastx = ifp->if_lastex;
 			ep = xfs_iext_get_ext(ifp, lastx);
 			nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
 			xfs_bmbt_get_all(ep, &got);
@@ -4848,7 +4834,6 @@ xfs_bmapi(
 		else
 			xfs_bmbt_get_all(ep, &got);
 	}
-	ifp->if_lastex = lastx;
 	*nmap = n;
 	/*
 	 * Transform from btree to extents, give it cur.
@@ -4957,7 +4942,6 @@ xfs_bmapi_single(
 	ASSERT(!isnullstartblock(got.br_startblock));
 	ASSERT(bno < got.br_startoff + got.br_blockcount);
 	*fsb = got.br_startblock + (bno - got.br_startoff);
-	ifp->if_lastex = lastx;
 	return 0;
 }
 
@@ -5132,7 +5116,7 @@ xfs_bunmapi(
 				del.br_blockcount = mod;
 			}
 			del.br_state = XFS_EXT_UNWRITTEN;
-			error = xfs_bmap_add_extent(ip, lastx, &cur, &del,
+			error = xfs_bmap_add_extent(ip, &lastx, &cur, &del,
 				firstblock, flist, &logflags,
 				XFS_DATA_FORK);
 			if (error)
@@ -5186,7 +5170,8 @@ xfs_bunmapi(
 					prev.br_startoff = start;
 				}
 				prev.br_state = XFS_EXT_UNWRITTEN;
-				error = xfs_bmap_add_extent(ip, lastx - 1, &cur,
+				lastx--;
+				error = xfs_bmap_add_extent(ip, &lastx, &cur,
 					&prev, firstblock, flist, &logflags,
 					XFS_DATA_FORK);
 				if (error)
@@ -5195,7 +5180,7 @@ xfs_bunmapi(
 			} else {
 				ASSERT(del.br_state == XFS_EXT_NORM);
 				del.br_state = XFS_EXT_UNWRITTEN;
-				error = xfs_bmap_add_extent(ip, lastx, &cur,
+				error = xfs_bmap_add_extent(ip, &lastx, &cur,
 					&del, firstblock, flist, &logflags,
 					XFS_DATA_FORK);
 				if (error)
@@ -5249,14 +5234,13 @@ xfs_bunmapi(
 			error = XFS_ERROR(ENOSPC);
 			goto error0;
 		}
-		error = xfs_bmap_del_extent(ip, tp, lastx, flist, cur, &del,
+		error = xfs_bmap_del_extent(ip, tp, &lastx, flist, cur, &del,
 				&tmp_logflags, whichfork);
 		logflags |= tmp_logflags;
 		if (error)
 			goto error0;
 		bno = del.br_startoff - 1;
 nodelete:
-		lastx = ifp->if_lastex;
 		/*
 		 * If not done go on to the next (previous) record.
 		 * Reset ep in case the extents array was re-alloced.
@@ -5273,7 +5257,6 @@ nodelete:
 			extno++;
 		}
 	}
-	ifp->if_lastex = lastx;
 	*done = bno == (xfs_fileoff_t)-1 || bno < start || lastx < 0;
 	ASSERT(ifp->if_ext_max ==
 	       XFS_IFORK_SIZE(ip, whichfork) / (uint)sizeof(xfs_bmbt_rec_t));
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-05-20 15:25:52.409233306 +0200
+++ xfs/fs/xfs/xfs_inode.c	2011-05-22 12:45:45.824962083 +0200
@@ -920,7 +920,6 @@ xfs_iread_extents(
 	/*
 	 * We know that the size is valid (it's checked in iformat_btree)
 	 */
-	ifp->if_lastex = NULLEXTNUM;
 	ifp->if_bytes = ifp->if_real_bytes = 0;
 	ifp->if_flags |= XFS_IFEXTENTS;
 	xfs_iext_add(ifp, 0, nextents);
@@ -3191,7 +3190,6 @@ xfs_iext_add(
 		}
 		ifp->if_u1.if_extents = ifp->if_u2.if_inline_ext;
 		ifp->if_real_bytes = 0;
-		ifp->if_lastex = nextents + ext_diff;
 	}
 	/*
 	 * Otherwise use a linear (direct) extent list.
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2011-05-20 13:32:26.512306370 +0200
+++ xfs/fs/xfs/xfs_inode.h	2011-05-22 12:45:45.832948481 +0200
@@ -67,7 +67,6 @@ typedef struct xfs_ifork {
 	short			if_broot_bytes;	/* bytes allocated for root */
 	unsigned char		if_flags;	/* per-fork flags */
 	unsigned char		if_ext_max;	/* max # of extent records */
-	xfs_extnum_t		if_lastex;	/* last if_extents used */
 	union {
 		xfs_bmbt_rec_host_t *if_extents;/* linear map file exts */
 		xfs_ext_irec_t	*if_ext_irec;	/* irec map file exts */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
