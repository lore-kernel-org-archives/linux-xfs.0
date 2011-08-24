Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O66lrg014544 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 01:06:51 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2114F10519B
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 23:06:45 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	v7rjedpuS72GgeD9 for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 23:06:45 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qw6bt-0005IS-BB
	for xfs@oss.sgi.com; Wed, 24 Aug 2011 06:06:45 +0000
Message-Id: <20110824060645.290805402@bombadil.infradead.org>
Date: Wed, 24 Aug 2011 02:04:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 22/25] xfs: pass bmalloca to xfs_bmap_add_extent_delay_real
References: <20110824060428.789245205@bombadil.infradead.org>
Content-Disposition: inline;
	filename=xfs-bmalloca-xfs_bmap_add_extent_delay_real
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

All the parameters passed to xfs_bmap_add_extent_delay_real() are in the
xfs_bmalloca structure now. Just pass the bmalloca parameter to the
function instead of 8 separate parameters.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-08-23 21:14:45.412027859 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-08-23 21:14:46.848686741 +0200
@@ -375,16 +375,9 @@ xfs_bmap_add_attrfork_local(
  */
 STATIC int				/* error */
 xfs_bmap_add_extent_delay_real(
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_inode_t		*ip,	/* incore inode pointer */
-	xfs_extnum_t		*idx,	/* extent number to update/insert */
-	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
-	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
-	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
-	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
-	int			*logflagsp) /* inode logging flags */
+	struct xfs_bmalloca	*bma)
 {
-	xfs_btree_cur_t		*cur;	/* btree cursor */
+	struct xfs_bmbt_irec	*new = &bma->got;
 	int			diff;	/* temp value */
 	xfs_bmbt_rec_host_t	*ep;	/* extent entry for idx */
 	int			error;	/* error return value */
@@ -401,18 +394,16 @@ xfs_bmap_add_extent_delay_real(
 	xfs_filblks_t		temp2=0;/* value for da_new calculations */
 	int			tmp_rval;	/* partial logging flags */
 
-	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-	cur = *curp;
+	ifp = XFS_IFORK_PTR(bma->ip, XFS_DATA_FORK);
 
-	ASSERT(*idx >= 0);
-	ASSERT(*idx <= ifp->if_bytes / sizeof(struct xfs_bmbt_rec));
+	ASSERT(bma->idx >= 0);
+	ASSERT(bma->idx <= ifp->if_bytes / sizeof(struct xfs_bmbt_rec));
 	ASSERT(!isnullstartblock(new->br_startblock));
-	ASSERT(!cur || (cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
+	ASSERT(!bma->cur ||
+	       (bma->cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
 
 	XFS_STATS_INC(xs_add_exlist);
 
-	*logflagsp = 0;
-
 #define	LEFT		r[0]
 #define	RIGHT		r[1]
 #define	PREV		r[2]
@@ -420,7 +411,7 @@ xfs_bmap_add_extent_delay_real(
 	/*
 	 * Set up a bunch of variables to make the tests simpler.
 	 */
-	ep = xfs_iext_get_ext(ifp, *idx);
+	ep = xfs_iext_get_ext(ifp, bma->idx);
 	xfs_bmbt_get_all(ep, &PREV);
 	new_endoff = new->br_startoff + new->br_blockcount;
 	ASSERT(PREV.br_startoff <= new->br_startoff);
@@ -442,9 +433,9 @@ xfs_bmap_add_extent_delay_real(
 	 * Check and set flags if this segment has a left neighbor.
 	 * Don't set contiguous if the combined extent would be too large.
 	 */
-	if (*idx > 0) {
+	if (bma->idx > 0) {
 		state |= BMAP_LEFT_VALID;
-		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx - 1), &LEFT);
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma->idx - 1), &LEFT);
 
 		if (isnullstartblock(LEFT.br_startblock))
 			state |= BMAP_LEFT_DELAY;
@@ -462,9 +453,9 @@ xfs_bmap_add_extent_delay_real(
 	 * Don't set contiguous if the combined extent would be too large.
 	 * Also check for all-three-contiguous being too large.
 	 */
-	if (*idx < ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1) {
+	if (bma->idx < bma->ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1) {
 		state |= BMAP_RIGHT_VALID;
-		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx + 1), &RIGHT);
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma->idx + 1), &RIGHT);
 
 		if (isnullstartblock(RIGHT.br_startblock))
 			state |= BMAP_RIGHT_DELAY;
@@ -495,35 +486,39 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in all of a previously delayed allocation extent.
 		 * The left and right neighbors are both contiguous with new.
 		 */
-		--*idx;
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx),
+		bma->idx--;
+		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, bma->idx),
 			LEFT.br_blockcount + PREV.br_blockcount +
 			RIGHT.br_blockcount);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
-		xfs_iext_remove(ip, *idx + 1, 2, state);
-		ip->i_d.di_nextents--;
-		if (cur == NULL)
+		xfs_iext_remove(bma->ip, bma->idx + 1, 2, state);
+		bma->ip->i_d.di_nextents--;
+		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
 			rval = XFS_ILOG_CORE;
-			if ((error = xfs_bmbt_lookup_eq(cur, RIGHT.br_startoff,
+			error = xfs_bmbt_lookup_eq(bma->cur, RIGHT.br_startoff,
 					RIGHT.br_startblock,
-					RIGHT.br_blockcount, &i)))
+					RIGHT.br_blockcount, &i);
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
-			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
+			error = xfs_bmbt_update(bma->cur, LEFT.br_startoff,
 					LEFT.br_startblock,
 					LEFT.br_blockcount +
 					PREV.br_blockcount +
-					RIGHT.br_blockcount, LEFT.br_state)))
+					RIGHT.br_blockcount, LEFT.br_state);
+			if (error)
 				goto done;
 		}
 		break;
@@ -533,27 +528,29 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in all of a previously delayed allocation extent.
 		 * The left neighbor is contiguous, the right is not.
 		 */
-		--*idx;
+		bma->idx--;
 
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx),
+		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, bma->idx),
 			LEFT.br_blockcount + PREV.br_blockcount);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
-		xfs_iext_remove(ip, *idx + 1, 1, state);
-		if (cur == NULL)
+		xfs_iext_remove(bma->ip, bma->idx + 1, 1, state);
+		if (bma->cur == NULL)
 			rval = XFS_ILOG_DEXT;
 		else {
 			rval = 0;
-			if ((error = xfs_bmbt_lookup_eq(cur, LEFT.br_startoff,
+			error = xfs_bmbt_lookup_eq(bma->cur, LEFT.br_startoff,
 					LEFT.br_startblock, LEFT.br_blockcount,
-					&i)))
+					&i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
+			error = xfs_bmbt_update(bma->cur, LEFT.br_startoff,
 					LEFT.br_startblock,
 					LEFT.br_blockcount +
-					PREV.br_blockcount, LEFT.br_state)))
+					PREV.br_blockcount, LEFT.br_state);
+			if (error)
 				goto done;
 		}
 		break;
@@ -563,26 +560,28 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in all of a previously delayed allocation extent.
 		 * The right neighbor is contiguous, the left is not.
 		 */
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
 		xfs_bmbt_set_startblock(ep, new->br_startblock);
 		xfs_bmbt_set_blockcount(ep,
 			PREV.br_blockcount + RIGHT.br_blockcount);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
-		xfs_iext_remove(ip, *idx + 1, 1, state);
-		if (cur == NULL)
+		xfs_iext_remove(bma->ip, bma->idx + 1, 1, state);
+		if (bma->cur == NULL)
 			rval = XFS_ILOG_DEXT;
 		else {
 			rval = 0;
-			if ((error = xfs_bmbt_lookup_eq(cur, RIGHT.br_startoff,
+			error = xfs_bmbt_lookup_eq(bma->cur, RIGHT.br_startoff,
 					RIGHT.br_startblock,
-					RIGHT.br_blockcount, &i)))
+					RIGHT.br_blockcount, &i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_update(cur, PREV.br_startoff,
+			error = xfs_bmbt_update(bma->cur, PREV.br_startoff,
 					new->br_startblock,
 					PREV.br_blockcount +
-					RIGHT.br_blockcount, PREV.br_state)))
+					RIGHT.br_blockcount, PREV.br_state);
+			if (error)
 				goto done;
 		}
 		break;
@@ -593,22 +592,24 @@ xfs_bmap_add_extent_delay_real(
 		 * Neither the left nor right neighbors are contiguous with
 		 * the new one.
 		 */
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
 		xfs_bmbt_set_startblock(ep, new->br_startblock);
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
-		ip->i_d.di_nextents++;
-		if (cur == NULL)
+		bma->ip->i_d.di_nextents++;
+		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
 			rval = XFS_ILOG_CORE;
-			if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
+			error = xfs_bmbt_lookup_eq(bma->cur, new->br_startoff,
 					new->br_startblock, new->br_blockcount,
-					&i)))
+					&i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
-			cur->bc_rec.b.br_state = XFS_EXT_NORM;
-			if ((error = xfs_btree_insert(cur, &i)))
+			bma->cur->bc_rec.b.br_state = XFS_EXT_NORM;
+			error = xfs_btree_insert(bma->cur, &i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
@@ -619,38 +620,40 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in the first part of a previous delayed allocation.
 		 * The left neighbor is contiguous.
 		 */
-		trace_xfs_bmap_pre_update(ip, *idx - 1, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx - 1),
+		trace_xfs_bmap_pre_update(bma->ip, bma->idx - 1, state, _THIS_IP_);
+		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, bma->idx - 1),
 			LEFT.br_blockcount + new->br_blockcount);
 		xfs_bmbt_set_startoff(ep,
 			PREV.br_startoff + new->br_blockcount);
-		trace_xfs_bmap_post_update(ip, *idx - 1, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(bma->ip, bma->idx - 1, state, _THIS_IP_);
 
 		temp = PREV.br_blockcount - new->br_blockcount;
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);
-		if (cur == NULL)
+		if (bma->cur == NULL)
 			rval = XFS_ILOG_DEXT;
 		else {
 			rval = 0;
-			if ((error = xfs_bmbt_lookup_eq(cur, LEFT.br_startoff,
+			error = xfs_bmbt_lookup_eq(bma->cur, LEFT.br_startoff,
 					LEFT.br_startblock, LEFT.br_blockcount,
-					&i)))
+					&i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
+			error = xfs_bmbt_update(bma->cur, LEFT.br_startoff,
 					LEFT.br_startblock,
 					LEFT.br_blockcount +
 					new->br_blockcount,
-					LEFT.br_state)))
+					LEFT.br_state);
+			if (error)
 				goto done;
 		}
-		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock));
 		xfs_bmbt_set_startblock(ep, nullstartblock(da_new));
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
-		--*idx;
+		bma->idx--;
 		break;
 
 	case BMAP_LEFT_FILLING:
@@ -658,41 +661,43 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in the first part of a previous delayed allocation.
 		 * The left neighbor is not contiguous.
 		 */
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
 		xfs_bmbt_set_startoff(ep, new_endoff);
 		temp = PREV.br_blockcount - new->br_blockcount;
 		xfs_bmbt_set_blockcount(ep, temp);
-		xfs_iext_insert(ip, *idx, 1, new, state);
-		ip->i_d.di_nextents++;
-		if (cur == NULL)
+		xfs_iext_insert(bma->ip, bma->idx, 1, new, state);
+		bma->ip->i_d.di_nextents++;
+		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
 			rval = XFS_ILOG_CORE;
-			if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
+			error = xfs_bmbt_lookup_eq(bma->cur, new->br_startoff,
 					new->br_startblock, new->br_blockcount,
-					&i)))
+					&i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
-			cur->bc_rec.b.br_state = XFS_EXT_NORM;
-			if ((error = xfs_btree_insert(cur, &i)))
+			bma->cur->bc_rec.b.br_state = XFS_EXT_NORM;
+			error = xfs_btree_insert(bma->cur, &i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
-		if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
-		    ip->i_d.di_nextents > ip->i_df.if_ext_max) {
-			error = xfs_bmap_extents_to_btree(tp, ip,
-					first, flist, &cur, 1, &tmp_rval,
-					XFS_DATA_FORK);
+		if (bma->ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
+		    bma->ip->i_d.di_nextents > bma->ip->i_df.if_ext_max) {
+			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
+					bma->firstblock, bma->flist,
+					&bma->cur, 1, &tmp_rval, XFS_DATA_FORK);
 			rval |= tmp_rval;
 			if (error)
 				goto done;
 		}
-		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock) -
-			(cur ? cur->bc_private.b.allocated : 0));
-		ep = xfs_iext_get_ext(ifp, *idx + 1);
+			(bma->cur ? bma->cur->bc_private.b.allocated : 0));
+		ep = xfs_iext_get_ext(ifp, bma->idx + 1);
 		xfs_bmbt_set_startblock(ep, nullstartblock(da_new));
-		trace_xfs_bmap_post_update(ip, *idx + 1, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(bma->ip, bma->idx + 1, state, _THIS_IP_);
 		break;
 
 	case BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -701,37 +706,39 @@ xfs_bmap_add_extent_delay_real(
 		 * The right neighbor is contiguous with the new allocation.
 		 */
 		temp = PREV.br_blockcount - new->br_blockcount;
-		trace_xfs_bmap_pre_update(ip, *idx + 1, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(bma->ip, bma->idx + 1, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);
-		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, *idx + 1),
+		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, bma->idx + 1),
 			new->br_startoff, new->br_startblock,
 			new->br_blockcount + RIGHT.br_blockcount,
 			RIGHT.br_state);
-		trace_xfs_bmap_post_update(ip, *idx + 1, state, _THIS_IP_);
-		if (cur == NULL)
+		trace_xfs_bmap_post_update(bma->ip, bma->idx + 1, state, _THIS_IP_);
+		if (bma->cur == NULL)
 			rval = XFS_ILOG_DEXT;
 		else {
 			rval = 0;
-			if ((error = xfs_bmbt_lookup_eq(cur, RIGHT.br_startoff,
+			error = xfs_bmbt_lookup_eq(bma->cur, RIGHT.br_startoff,
 					RIGHT.br_startblock,
-					RIGHT.br_blockcount, &i)))
+					RIGHT.br_blockcount, &i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_update(cur, new->br_startoff,
+			error = xfs_bmbt_update(bma->cur, new->br_startoff,
 					new->br_startblock,
 					new->br_blockcount +
 					RIGHT.br_blockcount,
-					RIGHT.br_state)))
+					RIGHT.br_state);
+			if (error)
 				goto done;
 		}
 
-		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock));
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
 		xfs_bmbt_set_startblock(ep, nullstartblock(da_new));
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
-		++*idx;
+		bma->idx++;
 		break;
 
 	case BMAP_RIGHT_FILLING:
@@ -740,41 +747,43 @@ xfs_bmap_add_extent_delay_real(
 		 * The right neighbor is not contiguous.
 		 */
 		temp = PREV.br_blockcount - new->br_blockcount;
-		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);
-		xfs_iext_insert(ip, *idx + 1, 1, new, state);
-		ip->i_d.di_nextents++;
-		if (cur == NULL)
+		xfs_iext_insert(bma->ip, bma->idx + 1, 1, new, state);
+		bma->ip->i_d.di_nextents++;
+		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
 			rval = XFS_ILOG_CORE;
-			if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
+			error = xfs_bmbt_lookup_eq(bma->cur, new->br_startoff,
 					new->br_startblock, new->br_blockcount,
-					&i)))
+					&i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
-			cur->bc_rec.b.br_state = XFS_EXT_NORM;
-			if ((error = xfs_btree_insert(cur, &i)))
+			bma->cur->bc_rec.b.br_state = XFS_EXT_NORM;
+			error = xfs_btree_insert(bma->cur, &i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
-		if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
-		    ip->i_d.di_nextents > ip->i_df.if_ext_max) {
-			error = xfs_bmap_extents_to_btree(tp, ip,
-				first, flist, &cur, 1, &tmp_rval,
-				XFS_DATA_FORK);
+		if (bma->ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
+		    bma->ip->i_d.di_nextents > bma->ip->i_df.if_ext_max) {
+			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
+				bma->firstblock, bma->flist, &bma->cur, 1,
+				&tmp_rval, XFS_DATA_FORK);
 			rval |= tmp_rval;
 			if (error)
 				goto done;
 		}
-		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock) -
-			(cur ? cur->bc_private.b.allocated : 0));
-		ep = xfs_iext_get_ext(ifp, *idx);
+			(bma->cur ? bma->cur->bc_private.b.allocated : 0));
+		ep = xfs_iext_get_ext(ifp, bma->idx);
 		xfs_bmbt_set_startblock(ep, nullstartblock(da_new));
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
-		++*idx;
+		bma->idx++;
 		break;
 
 	case 0:
@@ -800,46 +809,48 @@ xfs_bmap_add_extent_delay_real(
 		 */
 		temp = new->br_startoff - PREV.br_startoff;
 		temp2 = PREV.br_startoff + PREV.br_blockcount - new_endoff;
-		trace_xfs_bmap_pre_update(ip, *idx, 0, _THIS_IP_);
+		trace_xfs_bmap_pre_update(bma->ip, bma->idx, 0, _THIS_IP_);
 		xfs_bmbt_set_blockcount(ep, temp);	/* truncate PREV */
 		LEFT = *new;
 		RIGHT.br_state = PREV.br_state;
 		RIGHT.br_startblock = nullstartblock(
-				(int)xfs_bmap_worst_indlen(ip, temp2));
+				(int)xfs_bmap_worst_indlen(bma->ip, temp2));
 		RIGHT.br_startoff = new_endoff;
 		RIGHT.br_blockcount = temp2;
 		/* insert LEFT (r[0]) and RIGHT (r[1]) at the same time */
-		xfs_iext_insert(ip, *idx + 1, 2, &LEFT, state);
-		ip->i_d.di_nextents++;
-		if (cur == NULL)
+		xfs_iext_insert(bma->ip, bma->idx + 1, 2, &LEFT, state);
+		bma->ip->i_d.di_nextents++;
+		if (bma->cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
 			rval = XFS_ILOG_CORE;
-			if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
+			error = xfs_bmbt_lookup_eq(bma->cur, new->br_startoff,
 					new->br_startblock, new->br_blockcount,
-					&i)))
+					&i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
-			cur->bc_rec.b.br_state = XFS_EXT_NORM;
-			if ((error = xfs_btree_insert(cur, &i)))
+			bma->cur->bc_rec.b.br_state = XFS_EXT_NORM;
+			error = xfs_btree_insert(bma->cur, &i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
-		if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
-		    ip->i_d.di_nextents > ip->i_df.if_ext_max) {
-			error = xfs_bmap_extents_to_btree(tp, ip,
-					first, flist, &cur, 1, &tmp_rval,
-					XFS_DATA_FORK);
+		if (bma->ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
+		    bma->ip->i_d.di_nextents > bma->ip->i_df.if_ext_max) {
+			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
+					bma->firstblock, bma->flist, &bma->cur,
+					1, &tmp_rval, XFS_DATA_FORK);
 			rval |= tmp_rval;
 			if (error)
 				goto done;
 		}
-		temp = xfs_bmap_worst_indlen(ip, temp);
-		temp2 = xfs_bmap_worst_indlen(ip, temp2);
+		temp = xfs_bmap_worst_indlen(bma->ip, temp);
+		temp2 = xfs_bmap_worst_indlen(bma->ip, temp2);
 		diff = (int)(temp + temp2 - startblockval(PREV.br_startblock) -
-			(cur ? cur->bc_private.b.allocated : 0));
+			(bma->cur ? bma->cur->bc_private.b.allocated : 0));
 		if (diff > 0) {
-			error = xfs_icsb_modify_counters(ip->i_mount,
+			error = xfs_icsb_modify_counters(bma->ip->i_mount,
 					XFS_SBS_FDBLOCKS,
 					-((int64_t)diff), 0);
 			ASSERT(!error);
@@ -847,15 +858,15 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 
-		ep = xfs_iext_get_ext(ifp, *idx);
+		ep = xfs_iext_get_ext(ifp, bma->idx);
 		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
-		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
-		trace_xfs_bmap_pre_update(ip, *idx + 2, state, _THIS_IP_);
-		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, *idx + 2),
+		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
+		trace_xfs_bmap_pre_update(bma->ip, bma->idx + 2, state, _THIS_IP_);
+		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, bma->idx + 2),
 			nullstartblock((int)temp2));
-		trace_xfs_bmap_post_update(ip, *idx + 2, state, _THIS_IP_);
+		trace_xfs_bmap_post_update(bma->ip, bma->idx + 2, state, _THIS_IP_);
 
-		++*idx;
+		bma->idx++;
 		da_new = temp + temp2;
 		break;
 
@@ -873,14 +884,15 @@ xfs_bmap_add_extent_delay_real(
 	}
 
 	/* convert to a btree if necessary */
-	if (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) == XFS_DINODE_FMT_EXTENTS &&
-	    XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) > ifp->if_ext_max) {
+	if (XFS_IFORK_FORMAT(bma->ip, XFS_DATA_FORK) == XFS_DINODE_FMT_EXTENTS &&
+	    XFS_IFORK_NEXTENTS(bma->ip, XFS_DATA_FORK) > ifp->if_ext_max) {
 		int	tmp_logflags;	/* partial log flag return val */
 
-		ASSERT(cur == NULL);
-		error = xfs_bmap_extents_to_btree(tp, ip, first, flist, &cur,
+		ASSERT(bma->cur == NULL);
+		error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
+				bma->firstblock, bma->flist, &bma->cur,
 				da_old > 0, &tmp_logflags, XFS_DATA_FORK);
-		*logflagsp |= tmp_logflags;
+		bma->logflags |= tmp_logflags;
 		if (error)
 			goto done;
 	}
@@ -888,22 +900,22 @@ xfs_bmap_add_extent_delay_real(
 	/* adjust for changes in reserved delayed indirect blocks */
 	if (da_old || da_new) {
 		temp = da_new;
-		if (cur)
-			temp += cur->bc_private.b.allocated;
+		if (bma->cur)
+			temp += bma->cur->bc_private.b.allocated;
 		ASSERT(temp <= da_old);
 		if (temp < da_old)
-			xfs_icsb_modify_counters(ip->i_mount, XFS_SBS_FDBLOCKS,
-				(int64_t)(da_old - temp), 0);
+			xfs_icsb_modify_counters(bma->ip->i_mount,
+					XFS_SBS_FDBLOCKS,
+					(int64_t)(da_old - temp), 0);
 	}
 
 	/* clear out the allocated field, done with it now in any case. */
-	if (cur) {
-		cur->bc_private.b.allocated = 0;
-		*curp = cur;
-	}
-	xfs_bmap_check_leaf_extents(cur, ip, XFS_DATA_FORK);
+	if (bma->cur)
+		bma->cur->bc_private.b.allocated = 0;
+
+	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, XFS_DATA_FORK);
 done:
-	*logflagsp |= rval;
+	bma->logflags |= rval;
 	return error;
 #undef	LEFT
 #undef	RIGHT
@@ -4695,9 +4707,7 @@ xfs_bmapi_allocate(
 		bma->got.br_state = XFS_EXT_UNWRITTEN;
 
 	if (bma->wasdel) {
-		error = xfs_bmap_add_extent_delay_real(bma->tp, bma->ip,
-				&bma->idx, &bma->cur, &bma->got,
-				bma->firstblock, bma->flist, &tmp_logflags);
+		error = xfs_bmap_add_extent_delay_real(bma);
 	} else {
 		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip,
 				&bma->idx, &bma->cur, &bma->got,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
