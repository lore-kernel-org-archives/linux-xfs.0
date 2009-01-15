Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0F5ME7X003195 for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 23:22:14 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BAF51800F8B
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 21:22:09 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id WMb9NfGTFEhwA7tp for
	<xfs@oss.sgi.com>; Wed, 14 Jan 2009 21:22:09 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 43CAE9F59B7
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 23:22:08 -0600 (CST)
Message-ID: <496EC7FF.5040705@sandeen.net>
Date: Wed, 14 Jan 2009 23:22:07 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [patch 4/4 V2] Remove the rest of the macro-to-function indirections.
References: <20090101224009.616367334@sandeen.net>
	<20090101224057.782251520@sandeen.net>
In-Reply-To: <20090101224057.782251520@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Remove the last of the macros-defined-to-static-functions.

Test built only.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

(sorry, somehow the last send was on an old tree)


diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index 591ca66..d68b4e1 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -421,7 +421,7 @@ xfs_qm_dqalloc(
 	/*
 	 * Initialize the bmap freelist prior to calling bmapi code.
 	 */
-	XFS_BMAP_INIT(&flist, &firstblock);
+	xfs_bmap_init(&flist, &firstblock);
 	xfs_ilock(quotip, XFS_ILOCK_EXCL);
 	/*
 	 * Return if this type of quotas is turned off while we didn't
diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index d3b3cf7..143d63e 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -244,8 +244,8 @@ typedef struct xfs_perag
 #define	XFS_AG_CHECK_DADDR(mp,d,len)	\
 	((len) == 1 ? \
 	    ASSERT((d) == XFS_SB_DADDR || \
-		   XFS_DADDR_TO_AGBNO(mp, d) != XFS_SB_DADDR) : \
-	    ASSERT(XFS_DADDR_TO_AGNO(mp, d) == \
-		   XFS_DADDR_TO_AGNO(mp, (d) + (len) - 1)))
+		   xfs_daddr_to_agbno(mp, d) != XFS_SB_DADDR) : \
+	    ASSERT(xfs_daddr_to_agno(mp, d) == \
+		   xfs_daddr_to_agno(mp, (d) + (len) - 1)))
 
 #endif	/* __XFS_AG_H__ */
diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
index 733cb75..c10c3a2 100644
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -115,7 +115,7 @@ xfs_allocbt_free_block(
 	xfs_agblock_t		bno;
 	int			error;
 
-	bno = XFS_DADDR_TO_AGBNO(cur->bc_mp, XFS_BUF_ADDR(bp));
+	bno = xfs_daddr_to_agbno(cur->bc_mp, XFS_BUF_ADDR(bp));
 	error = xfs_alloc_put_freelist(cur->bc_tp, agbp, NULL, bno, 1);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index f7cdc28..5fde165 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -374,7 +374,7 @@ xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
 		 * It won't fit in the shortform, transform to a leaf block.
 		 * GROT: another possible req'mt for a double-split btree op.
 		 */
-		XFS_BMAP_INIT(args.flist, args.firstblock);
+		xfs_bmap_init(args.flist, args.firstblock);
 		error = xfs_attr_shortform_to_leaf(&args);
 		if (!error) {
 			error = xfs_bmap_finish(&args.trans, args.flist,
@@ -956,7 +956,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 * Commit that transaction so that the node_addname() call
 		 * can manage its own transactions.
 		 */
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_attr_leaf_to_node(args);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
@@ -1057,7 +1057,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 * If the result is small enough, shrink it all into the inode.
 		 */
 		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-			XFS_BMAP_INIT(args->flist, args->firstblock);
+			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_attr_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (!error) {
@@ -1135,7 +1135,7 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 	 * If the result is small enough, shrink it all into the inode.
 	 */
 	if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_attr_leaf_to_shortform(bp, args, forkoff);
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (!error) {
@@ -1290,7 +1290,7 @@ restart:
 			 * have been a b-tree.
 			 */
 			xfs_da_state_free(state);
-			XFS_BMAP_INIT(args->flist, args->firstblock);
+			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_attr_leaf_to_node(args);
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
@@ -1331,7 +1331,7 @@ restart:
 		 * in the index/blkno/rmtblkno/rmtblkcnt fields and
 		 * in the index2/blkno2/rmtblkno2/rmtblkcnt2 fields.
 		 */
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_da_split(state);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
@@ -1443,7 +1443,7 @@ restart:
 		 * Check to see if the tree needs to be collapsed.
 		 */
 		if (retval && (state->path.active > 1)) {
-			XFS_BMAP_INIT(args->flist, args->firstblock);
+			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_da_join(state);
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
@@ -1579,7 +1579,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	 * Check to see if the tree needs to be collapsed.
 	 */
 	if (retval && (state->path.active > 1)) {
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_da_join(state);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
@@ -1630,7 +1630,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 						       == XFS_ATTR_LEAF_MAGIC);
 
 		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-			XFS_BMAP_INIT(args->flist, args->firstblock);
+			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_attr_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (!error) {
@@ -2069,7 +2069,7 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 		/*
 		 * Allocate a single extent, up to the size of the value.
 		 */
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		nmap = 1;
 		error = xfs_bmapi(args->trans, dp, (xfs_fileoff_t)lblkno,
 				  blkcnt,
@@ -2123,7 +2123,7 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 		/*
 		 * Try to remember where we decided to put the value.
 		 */
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		nmap = 1;
 		error = xfs_bmapi(NULL, dp, (xfs_fileoff_t)lblkno,
 				  args->rmtblkcnt,
@@ -2188,7 +2188,7 @@ xfs_attr_rmtval_remove(xfs_da_args_t *args)
 		/*
 		 * Try to remember where we decided to put the value.
 		 */
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		nmap = 1;
 		error = xfs_bmapi(NULL, args->dp, (xfs_fileoff_t)lblkno,
 					args->rmtblkcnt,
@@ -2229,7 +2229,7 @@ xfs_attr_rmtval_remove(xfs_da_args_t *args)
 	blkcnt = args->rmtblkcnt;
 	done = 0;
 	while (!done) {
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
 				    XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
 				    1, args->firstblock, args->flist,
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 138308e..c852cd6 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -595,9 +595,9 @@ xfs_bmap_add_extent(
 		xfs_iext_insert(ifp, 0, 1, new);
 		ASSERT(cur == NULL);
 		ifp->if_lastex = 0;
-		if (!ISNULLSTARTBLOCK(new->br_startblock)) {
+		if (!isnullstartblock(new->br_startblock)) {
 			XFS_IFORK_NEXT_SET(ip, whichfork, 1);
-			logflags = XFS_ILOG_CORE | XFS_ILOG_FEXT(whichfork);
+			logflags = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 		} else
 			logflags = 0;
 		/* DELTA: single new extent */
@@ -613,7 +613,7 @@ xfs_bmap_add_extent(
 	/*
 	 * Any kind of new delayed allocation goes here.
 	 */
-	else if (ISNULLSTARTBLOCK(new->br_startblock)) {
+	else if (isnullstartblock(new->br_startblock)) {
 		if (cur)
 			ASSERT((cur->bc_private.b.flags &
 				XFS_BTCUR_BPRV_WASDEL) == 0);
@@ -644,11 +644,11 @@ xfs_bmap_add_extent(
 		 * in a delayed or unwritten allocation with a real one, or
 		 * converting real back to unwritten.
 		 */
-		if (!ISNULLSTARTBLOCK(new->br_startblock) &&
+		if (!isnullstartblock(new->br_startblock) &&
 		    new->br_startoff + new->br_blockcount > prev.br_startoff) {
 			if (prev.br_state != XFS_EXT_UNWRITTEN &&
-			    ISNULLSTARTBLOCK(prev.br_startblock)) {
-				da_old = STARTBLOCKVAL(prev.br_startblock);
+			    isnullstartblock(prev.br_startblock)) {
+				da_old = startblockval(prev.br_startblock);
 				if (cur)
 					ASSERT(cur->bc_private.b.flags &
 						XFS_BTCUR_BPRV_WASDEL);
@@ -803,7 +803,7 @@ xfs_bmap_add_extent_delay_real(
 	 */
 	if (STATE_SET_TEST(LEFT_VALID, idx > 0)) {
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx - 1), &LEFT);
-		STATE_SET(LEFT_DELAY, ISNULLSTARTBLOCK(LEFT.br_startblock));
+		STATE_SET(LEFT_DELAY, isnullstartblock(LEFT.br_startblock));
 	}
 	STATE_SET(LEFT_CONTIG,
 		STATE_TEST(LEFT_VALID) && !STATE_TEST(LEFT_DELAY) &&
@@ -820,7 +820,7 @@ xfs_bmap_add_extent_delay_real(
 			idx <
 			ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1)) {
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx + 1), &RIGHT);
-		STATE_SET(RIGHT_DELAY, ISNULLSTARTBLOCK(RIGHT.br_startblock));
+		STATE_SET(RIGHT_DELAY, isnullstartblock(RIGHT.br_startblock));
 	}
 	STATE_SET(RIGHT_CONTIG,
 		STATE_TEST(RIGHT_VALID) && !STATE_TEST(RIGHT_DELAY) &&
@@ -1019,8 +1019,8 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
-			STARTBLOCKVAL(PREV.br_startblock));
-		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
+			startblockval(PREV.br_startblock));
+		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 		XFS_BMAP_TRACE_POST_UPDATE("LF|LC", ip, idx, XFS_DATA_FORK);
 		*dnew = temp;
 		/* DELTA: The boundary between two in-core extents moved. */
@@ -1067,10 +1067,10 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
-			STARTBLOCKVAL(PREV.br_startblock) -
+			startblockval(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
 		ep = xfs_iext_get_ext(ifp, idx + 1);
-		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
+		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 		XFS_BMAP_TRACE_POST_UPDATE("LF", ip, idx + 1, XFS_DATA_FORK);
 		*dnew = temp;
 		/* DELTA: One in-core extent is split in two. */
@@ -1110,8 +1110,8 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
-			STARTBLOCKVAL(PREV.br_startblock));
-		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
+			startblockval(PREV.br_startblock));
+		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 		XFS_BMAP_TRACE_POST_UPDATE("RF|RC", ip, idx, XFS_DATA_FORK);
 		*dnew = temp;
 		/* DELTA: The boundary between two in-core extents moved. */
@@ -1157,10 +1157,10 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
-			STARTBLOCKVAL(PREV.br_startblock) -
+			startblockval(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
 		ep = xfs_iext_get_ext(ifp, idx);
-		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
+		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 		XFS_BMAP_TRACE_POST_UPDATE("RF", ip, idx, XFS_DATA_FORK);
 		*dnew = temp;
 		/* DELTA: One in-core extent is split in two. */
@@ -1213,7 +1213,7 @@ xfs_bmap_add_extent_delay_real(
 		}
 		temp = xfs_bmap_worst_indlen(ip, temp);
 		temp2 = xfs_bmap_worst_indlen(ip, temp2);
-		diff = (int)(temp + temp2 - STARTBLOCKVAL(PREV.br_startblock) -
+		diff = (int)(temp + temp2 - startblockval(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
 		if (diff > 0 &&
 		    xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS, -((int64_t)diff), rsvd)) {
@@ -1241,11 +1241,11 @@ xfs_bmap_add_extent_delay_real(
 			}
 		}
 		ep = xfs_iext_get_ext(ifp, idx);
-		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
+		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 		XFS_BMAP_TRACE_POST_UPDATE("0", ip, idx, XFS_DATA_FORK);
 		XFS_BMAP_TRACE_PRE_UPDATE("0", ip, idx + 2, XFS_DATA_FORK);
 		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, idx + 2),
-			NULLSTARTBLOCK((int)temp2));
+			nullstartblock((int)temp2));
 		XFS_BMAP_TRACE_POST_UPDATE("0", ip, idx + 2, XFS_DATA_FORK);
 		*dnew = temp + temp2;
 		/* DELTA: One in-core extent is split in three. */
@@ -1365,7 +1365,7 @@ xfs_bmap_add_extent_unwritten_real(
 	 */
 	if (STATE_SET_TEST(LEFT_VALID, idx > 0)) {
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx - 1), &LEFT);
-		STATE_SET(LEFT_DELAY, ISNULLSTARTBLOCK(LEFT.br_startblock));
+		STATE_SET(LEFT_DELAY, isnullstartblock(LEFT.br_startblock));
 	}
 	STATE_SET(LEFT_CONTIG,
 		STATE_TEST(LEFT_VALID) && !STATE_TEST(LEFT_DELAY) &&
@@ -1382,7 +1382,7 @@ xfs_bmap_add_extent_unwritten_real(
 			idx <
 			ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1)) {
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx + 1), &RIGHT);
-		STATE_SET(RIGHT_DELAY, ISNULLSTARTBLOCK(RIGHT.br_startblock));
+		STATE_SET(RIGHT_DELAY, isnullstartblock(RIGHT.br_startblock));
 	}
 	STATE_SET(RIGHT_CONTIG,
 		STATE_TEST(RIGHT_VALID) && !STATE_TEST(RIGHT_DELAY) &&
@@ -1889,13 +1889,13 @@ xfs_bmap_add_extent_hole_delay(
 	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	ep = xfs_iext_get_ext(ifp, idx);
 	state = 0;
-	ASSERT(ISNULLSTARTBLOCK(new->br_startblock));
+	ASSERT(isnullstartblock(new->br_startblock));
 	/*
 	 * Check and set flags if this segment has a left neighbor
 	 */
 	if (STATE_SET_TEST(LEFT_VALID, idx > 0)) {
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx - 1), &left);
-		STATE_SET(LEFT_DELAY, ISNULLSTARTBLOCK(left.br_startblock));
+		STATE_SET(LEFT_DELAY, isnullstartblock(left.br_startblock));
 	}
 	/*
 	 * Check and set flags if the current (right) segment exists.
@@ -1905,7 +1905,7 @@ xfs_bmap_add_extent_hole_delay(
 			   idx <
 			   ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t))) {
 		xfs_bmbt_get_all(ep, &right);
-		STATE_SET(RIGHT_DELAY, ISNULLSTARTBLOCK(right.br_startblock));
+		STATE_SET(RIGHT_DELAY, isnullstartblock(right.br_startblock));
 	}
 	/*
 	 * Set contiguity flags on the left and right neighbors.
@@ -1938,12 +1938,12 @@ xfs_bmap_add_extent_hole_delay(
 		XFS_BMAP_TRACE_PRE_UPDATE("LC|RC", ip, idx - 1,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1), temp);
-		oldlen = STARTBLOCKVAL(left.br_startblock) +
-			STARTBLOCKVAL(new->br_startblock) +
-			STARTBLOCKVAL(right.br_startblock);
+		oldlen = startblockval(left.br_startblock) +
+			startblockval(new->br_startblock) +
+			startblockval(right.br_startblock);
 		newlen = xfs_bmap_worst_indlen(ip, temp);
 		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, idx - 1),
-			NULLSTARTBLOCK((int)newlen));
+			nullstartblock((int)newlen));
 		XFS_BMAP_TRACE_POST_UPDATE("LC|RC", ip, idx - 1,
 			XFS_DATA_FORK);
 		XFS_BMAP_TRACE_DELETE("LC|RC", ip, idx, 1, XFS_DATA_FORK);
@@ -1964,11 +1964,11 @@ xfs_bmap_add_extent_hole_delay(
 		XFS_BMAP_TRACE_PRE_UPDATE("LC", ip, idx - 1,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1), temp);
-		oldlen = STARTBLOCKVAL(left.br_startblock) +
-			STARTBLOCKVAL(new->br_startblock);
+		oldlen = startblockval(left.br_startblock) +
+			startblockval(new->br_startblock);
 		newlen = xfs_bmap_worst_indlen(ip, temp);
 		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, idx - 1),
-			NULLSTARTBLOCK((int)newlen));
+			nullstartblock((int)newlen));
 		XFS_BMAP_TRACE_POST_UPDATE("LC", ip, idx - 1,
 			XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx - 1;
@@ -1985,11 +1985,11 @@ xfs_bmap_add_extent_hole_delay(
 		 */
 		XFS_BMAP_TRACE_PRE_UPDATE("RC", ip, idx, XFS_DATA_FORK);
 		temp = new->br_blockcount + right.br_blockcount;
-		oldlen = STARTBLOCKVAL(new->br_startblock) +
-			STARTBLOCKVAL(right.br_startblock);
+		oldlen = startblockval(new->br_startblock) +
+			startblockval(right.br_startblock);
 		newlen = xfs_bmap_worst_indlen(ip, temp);
 		xfs_bmbt_set_allf(ep, new->br_startoff,
-			NULLSTARTBLOCK((int)newlen), temp, right.br_state);
+			nullstartblock((int)newlen), temp, right.br_state);
 		XFS_BMAP_TRACE_POST_UPDATE("RC", ip, idx, XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx;
 		/* DELTA: One in-core extent grew into a hole. */
@@ -2085,7 +2085,7 @@ xfs_bmap_add_extent_hole_real(
 	 */
 	if (STATE_SET_TEST(LEFT_VALID, idx > 0)) {
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx - 1), &left);
-		STATE_SET(LEFT_DELAY, ISNULLSTARTBLOCK(left.br_startblock));
+		STATE_SET(LEFT_DELAY, isnullstartblock(left.br_startblock));
 	}
 	/*
 	 * Check and set flags if this segment has a current value.
@@ -2095,7 +2095,7 @@ xfs_bmap_add_extent_hole_real(
 			   idx <
 			   ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t))) {
 		xfs_bmbt_get_all(ep, &right);
-		STATE_SET(RIGHT_DELAY, ISNULLSTARTBLOCK(right.br_startblock));
+		STATE_SET(RIGHT_DELAY, isnullstartblock(right.br_startblock));
 	}
 	/*
 	 * We're inserting a real allocation between "left" and "right".
@@ -2143,7 +2143,7 @@ xfs_bmap_add_extent_hole_real(
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
 		if (cur == NULL) {
-			rval = XFS_ILOG_CORE | XFS_ILOG_FEXT(whichfork);
+			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 		} else {
 			rval = XFS_ILOG_CORE;
 			if ((error = xfs_bmbt_lookup_eq(cur,
@@ -2185,7 +2185,7 @@ xfs_bmap_add_extent_hole_real(
 		XFS_BMAP_TRACE_POST_UPDATE("LC", ip, idx - 1, whichfork);
 		ifp->if_lastex = idx - 1;
 		if (cur == NULL) {
-			rval = XFS_ILOG_FEXT(whichfork);
+			rval = xfs_ilog_fext(whichfork);
 		} else {
 			rval = 0;
 			if ((error = xfs_bmbt_lookup_eq(cur,
@@ -2220,7 +2220,7 @@ xfs_bmap_add_extent_hole_real(
 		XFS_BMAP_TRACE_POST_UPDATE("RC", ip, idx, whichfork);
 		ifp->if_lastex = idx;
 		if (cur == NULL) {
-			rval = XFS_ILOG_FEXT(whichfork);
+			rval = xfs_ilog_fext(whichfork);
 		} else {
 			rval = 0;
 			if ((error = xfs_bmbt_lookup_eq(cur,
@@ -2254,7 +2254,7 @@ xfs_bmap_add_extent_hole_real(
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 			XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
 		if (cur == NULL) {
-			rval = XFS_ILOG_CORE | XFS_ILOG_FEXT(whichfork);
+			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 		} else {
 			rval = XFS_ILOG_CORE;
 			if ((error = xfs_bmbt_lookup_eq(cur,
@@ -2482,7 +2482,7 @@ xfs_bmap_adjacent(
 	 * try to use it's last block as our starting point.
 	 */
 	if (ap->eof && ap->prevp->br_startoff != NULLFILEOFF &&
-	    !ISNULLSTARTBLOCK(ap->prevp->br_startblock) &&
+	    !isnullstartblock(ap->prevp->br_startblock) &&
 	    ISVALID(ap->prevp->br_startblock + ap->prevp->br_blockcount,
 		    ap->prevp->br_startblock)) {
 		ap->rval = ap->prevp->br_startblock + ap->prevp->br_blockcount;
@@ -2511,7 +2511,7 @@ xfs_bmap_adjacent(
 		 * start block based on it.
 		 */
 		if (ap->prevp->br_startoff != NULLFILEOFF &&
-		    !ISNULLSTARTBLOCK(ap->prevp->br_startblock) &&
+		    !isnullstartblock(ap->prevp->br_startblock) &&
 		    (prevbno = ap->prevp->br_startblock +
 			       ap->prevp->br_blockcount) &&
 		    ISVALID(prevbno, ap->prevp->br_startblock)) {
@@ -2552,7 +2552,7 @@ xfs_bmap_adjacent(
 		 * If there's a following (right) block, select a requested
 		 * start block based on it.
 		 */
-		if (!ISNULLSTARTBLOCK(ap->gotp->br_startblock)) {
+		if (!isnullstartblock(ap->gotp->br_startblock)) {
 			/*
 			 * Calculate gap to start of next block.
 			 */
@@ -3082,7 +3082,7 @@ xfs_bmap_btree_to_extents(
 	ASSERT(ifp->if_broot == NULL);
 	ASSERT((ifp->if_flags & XFS_IFBROOT) == 0);
 	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
-	*logflagsp = XFS_ILOG_CORE | XFS_ILOG_FEXT(whichfork);
+	*logflagsp = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 	return 0;
 }
 
@@ -3136,8 +3136,8 @@ xfs_bmap_del_extent(
 	del_endoff = del->br_startoff + del->br_blockcount;
 	got_endoff = got.br_startoff + got.br_blockcount;
 	ASSERT(got_endoff >= del_endoff);
-	delay = ISNULLSTARTBLOCK(got.br_startblock);
-	ASSERT(ISNULLSTARTBLOCK(del->br_startblock) == delay);
+	delay = isnullstartblock(got.br_startblock);
+	ASSERT(isnullstartblock(del->br_startblock) == delay);
 	flags = 0;
 	qfield = 0;
 	error = 0;
@@ -3189,7 +3189,7 @@ xfs_bmap_del_extent(
 		}
 		da_old = da_new = 0;
 	} else {
-		da_old = STARTBLOCKVAL(got.br_startblock);
+		da_old = startblockval(got.br_startblock);
 		da_new = 0;
 		nblks = 0;
 		do_fx = 0;
@@ -3213,7 +3213,7 @@ xfs_bmap_del_extent(
 			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
 		flags |= XFS_ILOG_CORE;
 		if (!cur) {
-			flags |= XFS_ILOG_FEXT(whichfork);
+			flags |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		if ((error = xfs_btree_delete(cur, &i)))
@@ -3233,7 +3233,7 @@ xfs_bmap_del_extent(
 		if (delay) {
 			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 				da_old);
-			xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
+			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 			XFS_BMAP_TRACE_POST_UPDATE("2", ip, idx,
 				whichfork);
 			da_new = temp;
@@ -3242,7 +3242,7 @@ xfs_bmap_del_extent(
 		xfs_bmbt_set_startblock(ep, del_endblock);
 		XFS_BMAP_TRACE_POST_UPDATE("2", ip, idx, whichfork);
 		if (!cur) {
-			flags |= XFS_ILOG_FEXT(whichfork);
+			flags |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		if ((error = xfs_bmbt_update(cur, del_endoff, del_endblock,
@@ -3262,7 +3262,7 @@ xfs_bmap_del_extent(
 		if (delay) {
 			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 				da_old);
-			xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
+			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 			XFS_BMAP_TRACE_POST_UPDATE("1", ip, idx,
 				whichfork);
 			da_new = temp;
@@ -3270,7 +3270,7 @@ xfs_bmap_del_extent(
 		}
 		XFS_BMAP_TRACE_POST_UPDATE("1", ip, idx, whichfork);
 		if (!cur) {
-			flags |= XFS_ILOG_FEXT(whichfork);
+			flags |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		if ((error = xfs_bmbt_update(cur, got.br_startoff,
@@ -3345,22 +3345,22 @@ xfs_bmap_del_extent(
 				}
 				XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			} else
-				flags |= XFS_ILOG_FEXT(whichfork);
+				flags |= xfs_ilog_fext(whichfork);
 			XFS_IFORK_NEXT_SET(ip, whichfork,
 				XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
 		} else {
 			ASSERT(whichfork == XFS_DATA_FORK);
 			temp = xfs_bmap_worst_indlen(ip, temp);
-			xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
+			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 			temp2 = xfs_bmap_worst_indlen(ip, temp2);
-			new.br_startblock = NULLSTARTBLOCK((int)temp2);
+			new.br_startblock = nullstartblock((int)temp2);
 			da_new = temp + temp2;
 			while (da_new > da_old) {
 				if (temp) {
 					temp--;
 					da_new--;
 					xfs_bmbt_set_startblock(ep,
-						NULLSTARTBLOCK((int)temp));
+						nullstartblock((int)temp));
 				}
 				if (da_new == da_old)
 					break;
@@ -3368,7 +3368,7 @@ xfs_bmap_del_extent(
 					temp2--;
 					da_new--;
 					new.br_startblock =
-						NULLSTARTBLOCK((int)temp2);
+						nullstartblock((int)temp2);
 				}
 			}
 		}
@@ -3545,7 +3545,7 @@ xfs_bmap_extents_to_btree(
 	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
 	for (cnt = i = 0; i < nextents; i++) {
 		ep = xfs_iext_get_ext(ifp, i);
-		if (!ISNULLSTARTBLOCK(xfs_bmbt_get_startblock(ep))) {
+		if (!isnullstartblock(xfs_bmbt_get_startblock(ep))) {
 			arp->l0 = cpu_to_be64(ep->l0);
 			arp->l1 = cpu_to_be64(ep->l1);
 			arp++; cnt++;
@@ -3572,7 +3572,7 @@ xfs_bmap_extents_to_btree(
 	xfs_btree_log_recs(cur, abp, 1, be16_to_cpu(ablock->bb_numrecs));
 	ASSERT(*curp == NULL);
 	*curp = cur;
-	*logflagsp = XFS_ILOG_CORE | XFS_ILOG_FBROOT(whichfork);
+	*logflagsp = XFS_ILOG_CORE | xfs_ilog_fbroot(whichfork);
 	return 0;
 }
 
@@ -3676,7 +3676,7 @@ xfs_bmap_local_to_extents(
 		ip->i_d.di_nblocks = 1;
 		XFS_TRANS_MOD_DQUOT_BYINO(args.mp, tp, ip,
 			XFS_TRANS_DQ_BCOUNT, 1L);
-		flags |= XFS_ILOG_FEXT(whichfork);
+		flags |= xfs_ilog_fext(whichfork);
 	} else {
 		ASSERT(XFS_IFORK_NEXTENTS(ip, whichfork) == 0);
 		xfs_bmap_forkoff_reset(ip->i_mount, ip, whichfork);
@@ -4082,7 +4082,7 @@ xfs_bmap_add_attrfork(
 		XFS_IFORK_ASIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
 	ip->i_afp->if_flags = XFS_IFEXTENTS;
 	logflags = 0;
-	XFS_BMAP_INIT(&flist, &firstblock);
+	xfs_bmap_init(&flist, &firstblock);
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		error = xfs_bmap_add_attrfork_local(tp, ip, &firstblock, &flist,
@@ -4162,7 +4162,7 @@ xfs_bmap_add_free(
 	ASSERT(bno != NULLFSBLOCK);
 	ASSERT(len > 0);
 	ASSERT(len <= MAXEXTLEN);
-	ASSERT(!ISNULLSTARTBLOCK(bno));
+	ASSERT(!isnullstartblock(bno));
 	agno = XFS_FSB_TO_AGNO(mp, bno);
 	agbno = XFS_FSB_TO_AGBNO(mp, bno);
 	ASSERT(agno < mp->m_sb.sb_agcount);
@@ -4909,7 +4909,7 @@ xfs_bmapi(
 			got.br_startoff = end;
 		inhole = eof || got.br_startoff > bno;
 		wasdelay = wr && !inhole && !(flags & XFS_BMAPI_DELAY) &&
-			ISNULLSTARTBLOCK(got.br_startblock);
+			isnullstartblock(got.br_startblock);
 		/*
 		 * First, deal with the hole before the allocated space
 		 * that we found, if any.
@@ -5028,7 +5028,7 @@ xfs_bmapi(
 				}
 
 				ip->i_delayed_blks += alen;
-				abno = NULLSTARTBLOCK(indlen);
+				abno = nullstartblock(indlen);
 			} else {
 				/*
 				 * If first time, allocate and fill in
@@ -5144,8 +5144,8 @@ xfs_bmapi(
 				aoff + alen);
 #ifdef DEBUG
 			if (flags & XFS_BMAPI_DELAY) {
-				ASSERT(ISNULLSTARTBLOCK(got.br_startblock));
-				ASSERT(STARTBLOCKVAL(got.br_startblock) > 0);
+				ASSERT(isnullstartblock(got.br_startblock));
+				ASSERT(startblockval(got.br_startblock) > 0);
 			}
 			ASSERT(got.br_state == XFS_EXT_NORM ||
 			       got.br_state == XFS_EXT_UNWRITTEN);
@@ -5179,7 +5179,7 @@ xfs_bmapi(
 			ASSERT((bno >= obno) || (n == 0));
 			ASSERT(bno < end);
 			mval->br_startoff = bno;
-			if (ISNULLSTARTBLOCK(got.br_startblock)) {
+			if (isnullstartblock(got.br_startblock)) {
 				ASSERT(!wr || (flags & XFS_BMAPI_DELAY));
 				mval->br_startblock = DELAYSTARTBLOCK;
 			} else
@@ -5201,7 +5201,7 @@ xfs_bmapi(
 			ASSERT(mval->br_blockcount <= len);
 		} else {
 			*mval = got;
-			if (ISNULLSTARTBLOCK(mval->br_startblock)) {
+			if (isnullstartblock(mval->br_startblock)) {
 				ASSERT(!wr || (flags & XFS_BMAPI_DELAY));
 				mval->br_startblock = DELAYSTARTBLOCK;
 			}
@@ -5329,12 +5329,12 @@ error0:
 	 * Log everything.  Do this after conversion, there's no point in
 	 * logging the extent records if we've converted to btree format.
 	 */
-	if ((logflags & XFS_ILOG_FEXT(whichfork)) &&
+	if ((logflags & xfs_ilog_fext(whichfork)) &&
 	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
-		logflags &= ~XFS_ILOG_FEXT(whichfork);
-	else if ((logflags & XFS_ILOG_FBROOT(whichfork)) &&
+		logflags &= ~xfs_ilog_fext(whichfork);
+	else if ((logflags & xfs_ilog_fbroot(whichfork)) &&
 		 XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)
-		logflags &= ~XFS_ILOG_FBROOT(whichfork);
+		logflags &= ~xfs_ilog_fbroot(whichfork);
 	/*
 	 * Log whatever the flags say, even if error.  Otherwise we might miss
 	 * detecting a case where the data is changed, there's an error,
@@ -5411,7 +5411,7 @@ xfs_bmapi_single(
 		*fsb = NULLFSBLOCK;
 		return 0;
 	}
-	ASSERT(!ISNULLSTARTBLOCK(got.br_startblock));
+	ASSERT(!isnullstartblock(got.br_startblock));
 	ASSERT(bno < got.br_startoff + got.br_blockcount);
 	*fsb = got.br_startblock + (bno - got.br_startoff);
 	ifp->if_lastex = lastx;
@@ -5543,7 +5543,7 @@ xfs_bunmapi(
 		 */
 		ASSERT(ep != NULL);
 		del = got;
-		wasdel = ISNULLSTARTBLOCK(del.br_startblock);
+		wasdel = isnullstartblock(del.br_startblock);
 		if (got.br_startoff < start) {
 			del.br_startoff = start;
 			del.br_blockcount -= start - got.br_startoff;
@@ -5638,7 +5638,7 @@ xfs_bunmapi(
 				xfs_bmbt_get_all(xfs_iext_get_ext(ifp,
 						lastx - 1), &prev);
 				ASSERT(prev.br_state == XFS_EXT_NORM);
-				ASSERT(!ISNULLSTARTBLOCK(prev.br_startblock));
+				ASSERT(!isnullstartblock(prev.br_startblock));
 				ASSERT(del.br_startblock ==
 				       prev.br_startblock + prev.br_blockcount);
 				if (prev.br_startoff < start) {
@@ -5666,7 +5666,7 @@ xfs_bunmapi(
 			}
 		}
 		if (wasdel) {
-			ASSERT(STARTBLOCKVAL(del.br_startblock) > 0);
+			ASSERT(startblockval(del.br_startblock) > 0);
 			/* Update realtime/data freespace, unreserve quota */
 			if (isrt) {
 				xfs_filblks_t rtexts;
@@ -5782,12 +5782,12 @@ error0:
 	 * Log everything.  Do this after conversion, there's no point in
 	 * logging the extent records if we've converted to btree format.
 	 */
-	if ((logflags & XFS_ILOG_FEXT(whichfork)) &&
+	if ((logflags & xfs_ilog_fext(whichfork)) &&
 	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
-		logflags &= ~XFS_ILOG_FEXT(whichfork);
-	else if ((logflags & XFS_ILOG_FBROOT(whichfork)) &&
+		logflags &= ~xfs_ilog_fext(whichfork);
+	else if ((logflags & xfs_ilog_fbroot(whichfork)) &&
 		 XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)
-		logflags &= ~XFS_ILOG_FBROOT(whichfork);
+		logflags &= ~xfs_ilog_fbroot(whichfork);
 	/*
 	 * Log inode even in the error case, if the transaction
 	 * is dirty we'll need to shut down the filesystem.
@@ -5838,7 +5838,7 @@ xfs_getbmapx_fix_eof_hole(
 		if (startblock == DELAYSTARTBLOCK)
 			out->bmv_block = -2;
 		else
-			out->bmv_block = XFS_FSB_TO_DB(ip, startblock);
+			out->bmv_block = xfs_fsb_to_db(ip, startblock);
 		fileblock = XFS_BB_TO_FSB(ip->i_mount, out->bmv_offset);
 		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 		if (xfs_iext_bno_to_ext(ifp, fileblock, &lastx) &&
@@ -5979,7 +5979,7 @@ xfs_getbmap(
 	if (nex > XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1)
 		nex = XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1;
 
-	bmapi_flags = XFS_BMAPI_AFLAG(whichfork) |
+	bmapi_flags = xfs_bmapi_aflag(whichfork) |
 			((iflags & BMV_IF_PREALLOC) ? 0 : XFS_BMAPI_IGSTATE);
 
 	/*
@@ -6098,7 +6098,7 @@ xfs_bmap_isaeof(
 	 */
 	*aeof = (off >= s.br_startoff &&
 		 off < s.br_startoff + s.br_blockcount &&
-		 ISNULLSTARTBLOCK(s.br_startblock)) ||
+		 isnullstartblock(s.br_startblock)) ||
 		off >= s.br_startoff + s.br_blockcount;
 	return 0;
 }
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index 284571c..be2979d 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -95,7 +95,6 @@ typedef	struct xfs_bmap_free
 					/* need write cache flushing and no */
 					/* additional allocation alignments */
 
-#define	XFS_BMAPI_AFLAG(w)	xfs_bmapi_aflag(w)
 static inline int xfs_bmapi_aflag(int w)
 {
 	return (w == XFS_ATTR_FORK ? XFS_BMAPI_ATTRFORK : 0);
@@ -107,7 +106,6 @@ static inline int xfs_bmapi_aflag(int w)
 #define	DELAYSTARTBLOCK		((xfs_fsblock_t)-1LL)
 #define	HOLESTARTBLOCK		((xfs_fsblock_t)-2LL)
 
-#define	XFS_BMAP_INIT(flp,fbp)	xfs_bmap_init(flp,fbp)
 static inline void xfs_bmap_init(xfs_bmap_free_t *flp, xfs_fsblock_t *fbp)
 {
 	((flp)->xbf_first = NULL, (flp)->xbf_count = 0, \
diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index ba6b08c..0760d35 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -121,7 +121,7 @@ __xfs_bmbt_get_all(
 
 		b = (((xfs_dfsbno_t)l0 & xfs_mask64lo(9)) << 43) |
 		    (((xfs_dfsbno_t)l1) >> 21);
-		ASSERT((b >> 32) == 0 || ISNULLDSTARTBLOCK(b));
+		ASSERT((b >> 32) == 0 || isnulldstartblock(b));
 		s->br_startblock = (xfs_fsblock_t)b;
 	}
 #else	/* !DEBUG */
@@ -172,7 +172,7 @@ xfs_bmbt_get_startblock(
 
 	b = (((xfs_dfsbno_t)r->l0 & xfs_mask64lo(9)) << 43) |
 	    (((xfs_dfsbno_t)r->l1) >> 21);
-	ASSERT((b >> 32) == 0 || ISNULLDSTARTBLOCK(b));
+	ASSERT((b >> 32) == 0 || isnulldstartblock(b));
 	return (xfs_fsblock_t)b;
 #else	/* !DEBUG */
 	return (xfs_fsblock_t)(((xfs_dfsbno_t)r->l1) >> 21);
@@ -261,7 +261,7 @@ xfs_bmbt_set_allf(
 		((xfs_bmbt_rec_base_t)blockcount &
 		(xfs_bmbt_rec_base_t)xfs_mask64lo(21));
 #else	/* !XFS_BIG_BLKNOS */
-	if (ISNULLSTARTBLOCK(startblock)) {
+	if (isnullstartblock(startblock)) {
 		r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
 			((xfs_bmbt_rec_base_t)startoff << 9) |
 			 (xfs_bmbt_rec_base_t)xfs_mask64lo(9);
@@ -321,7 +321,7 @@ xfs_bmbt_disk_set_allf(
 		 ((xfs_bmbt_rec_base_t)blockcount &
 		  (xfs_bmbt_rec_base_t)xfs_mask64lo(21)));
 #else	/* !XFS_BIG_BLKNOS */
-	if (ISNULLSTARTBLOCK(startblock)) {
+	if (isnullstartblock(startblock)) {
 		r->l0 = cpu_to_be64(
 			((xfs_bmbt_rec_base_t)extent_flag << 63) |
 			 ((xfs_bmbt_rec_base_t)startoff << 9) |
@@ -382,7 +382,7 @@ xfs_bmbt_set_startblock(
 	r->l1 = (r->l1 & (xfs_bmbt_rec_base_t)xfs_mask64lo(21)) |
 		  (xfs_bmbt_rec_base_t)(v << 21);
 #else	/* !XFS_BIG_BLKNOS */
-	if (ISNULLSTARTBLOCK(v)) {
+	if (isnullstartblock(v)) {
 		r->l0 |= (xfs_bmbt_rec_base_t)xfs_mask64lo(9);
 		r->l1 = (xfs_bmbt_rec_base_t)xfs_mask64hi(11) |
 			  ((xfs_bmbt_rec_base_t)v << 21) |
diff --git a/fs/xfs/xfs_bmap_btree.h b/fs/xfs/xfs_bmap_btree.h
index a4555ab..0e8df00 100644
--- a/fs/xfs/xfs_bmap_btree.h
+++ b/fs/xfs/xfs_bmap_btree.h
@@ -76,26 +76,22 @@ typedef struct xfs_bmbt_rec_host {
 #define DSTARTBLOCKMASK		\
 	(((((xfs_dfsbno_t)1) << DSTARTBLOCKMASKBITS) - 1) << STARTBLOCKVALBITS)
 
-#define ISNULLSTARTBLOCK(x)	isnullstartblock(x)
 static inline int isnullstartblock(xfs_fsblock_t x)
 {
 	return ((x) & STARTBLOCKMASK) == STARTBLOCKMASK;
 }
 
-#define ISNULLDSTARTBLOCK(x)	isnulldstartblock(x)
 static inline int isnulldstartblock(xfs_dfsbno_t x)
 {
 	return ((x) & DSTARTBLOCKMASK) == DSTARTBLOCKMASK;
 }
 
-#define NULLSTARTBLOCK(k)	nullstartblock(k)
 static inline xfs_fsblock_t nullstartblock(int k)
 {
 	ASSERT(k < (1 << STARTBLOCKVALBITS));
 	return STARTBLOCKMASK | (k);
 }
 
-#define STARTBLOCKVAL(x)	startblockval(x)
 static inline xfs_filblks_t startblockval(xfs_fsblock_t x)
 {
 	return (xfs_filblks_t)((x) & ~STARTBLOCKMASK);
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 2c3ef20..4681519 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -960,7 +960,7 @@ xfs_btree_buf_to_ptr(
 		ptr->l = cpu_to_be64(XFS_DADDR_TO_FSB(cur->bc_mp,
 					XFS_BUF_ADDR(bp)));
 	else {
-		ptr->s = cpu_to_be32(XFS_DADDR_TO_AGBNO(cur->bc_mp,
+		ptr->s = cpu_to_be32(xfs_daddr_to_agbno(cur->bc_mp,
 					XFS_BUF_ADDR(bp)));
 	}
 }
@@ -2454,7 +2454,7 @@ xfs_btree_new_iroot(
 	xfs_btree_log_ptrs(cur, cbp, 1, be16_to_cpu(cblock->bb_numrecs));
 
 	*logflags |=
-		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork);
+		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_private.b.whichfork);
 	*stat = 1;
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 	return 0;
@@ -3048,7 +3048,7 @@ xfs_btree_kill_iroot(
 	cur->bc_bufs[level - 1] = NULL;
 	be16_add_cpu(&block->bb_level, -1);
 	xfs_trans_log_inode(cur->bc_tp, ip,
-		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
+		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_private.b.whichfork));
 	cur->bc_nlevels--;
 out0:
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index a11a839..c45f74f 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -1597,7 +1597,7 @@ xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno)
 	nmap = 1;
 	ASSERT(args->firstblock != NULL);
 	if ((error = xfs_bmapi(tp, dp, bno, count,
-			XFS_BMAPI_AFLAG(w)|XFS_BMAPI_WRITE|XFS_BMAPI_METADATA|
+			xfs_bmapi_aflag(w)|XFS_BMAPI_WRITE|XFS_BMAPI_METADATA|
 			XFS_BMAPI_CONTIG,
 			args->firstblock, args->total, &map, &nmap,
 			args->flist, NULL))) {
@@ -1618,7 +1618,7 @@ xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno)
 			nmap = MIN(XFS_BMAP_MAX_NMAP, count);
 			c = (int)(bno + count - b);
 			if ((error = xfs_bmapi(tp, dp, b, c,
-					XFS_BMAPI_AFLAG(w)|XFS_BMAPI_WRITE|
+					xfs_bmapi_aflag(w)|XFS_BMAPI_WRITE|
 					XFS_BMAPI_METADATA,
 					args->firstblock, args->total,
 					&mapp[mapi], &nmap, args->flist,
@@ -1882,7 +1882,7 @@ xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
 		 * the last block to the place we want to kill.
 		 */
 		if ((error = xfs_bunmapi(tp, dp, dead_blkno, count,
-				XFS_BMAPI_AFLAG(w)|XFS_BMAPI_METADATA,
+				xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA,
 				0, args->firstblock, args->flist, NULL,
 				&done)) == ENOSPC) {
 			if (w != XFS_DATA_FORK)
@@ -1987,7 +1987,7 @@ xfs_da_do_buf(
 			if ((error = xfs_bmapi(trans, dp, (xfs_fileoff_t)bno,
 					nfsb,
 					XFS_BMAPI_METADATA |
-						XFS_BMAPI_AFLAG(whichfork),
+						xfs_bmapi_aflag(whichfork),
 					NULL, 0, mapp, &nmap, NULL, NULL)))
 				goto exit0;
 		}
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index e6ebbae..ab016e5 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -357,7 +357,7 @@ xfs_ialloc_ag_alloc(
 			int	ioffset = i << args.mp->m_sb.sb_inodelog;
 			uint	isize = sizeof(struct xfs_dinode);
 
-			free = XFS_MAKE_IPTR(args.mp, fbuf, i);
+			free = xfs_make_iptr(args.mp, fbuf, i);
 			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 			free->di_version = version;
 			free->di_gen = cpu_to_be32(gen);
@@ -937,7 +937,7 @@ nextag:
 			}
 		}
 	}
-	offset = XFS_IALLOC_FIND_FREE(&rec.ir_free);
+	offset = xfs_ialloc_find_free(&rec.ir_free);
 	ASSERT(offset >= 0);
 	ASSERT(offset < XFS_INODES_PER_CHUNK);
 	ASSERT((XFS_AGINO_TO_OFFSET(mp, rec.ir_startino) %
@@ -1279,7 +1279,7 @@ xfs_imap(
 		offset = XFS_INO_TO_OFFSET(mp, ino);
 		ASSERT(offset < mp->m_sb.sb_inopblock);
 
-		cluster_agbno = XFS_DADDR_TO_AGBNO(mp, imap->im_blkno);
+		cluster_agbno = xfs_daddr_to_agbno(mp, imap->im_blkno);
 		offset += (agbno - cluster_agbno) * mp->m_sb.sb_inopblock;
 
 		imap->im_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
diff --git a/fs/xfs/xfs_ialloc.h b/fs/xfs/xfs_ialloc.h
index 50f558a..aeee827 100644
--- a/fs/xfs/xfs_ialloc.h
+++ b/fs/xfs/xfs_ialloc.h
@@ -39,7 +39,6 @@ struct xfs_trans;
 /*
  * Make an inode pointer out of the buffer/offset.
  */
-#define	XFS_MAKE_IPTR(mp,b,o)		xfs_make_iptr(mp,b,o)
 static inline struct xfs_dinode *
 xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
 {
@@ -50,7 +49,6 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
 /*
  * Find a free (set) bit in the inode bitmask.
  */
-#define	XFS_IALLOC_FIND_FREE(fp)	xfs_ialloc_find_free(fp)
 static inline int xfs_ialloc_find_free(xfs_inofree_t *fp)
 {
 	return xfs_lowbit64(*fp);
diff --git a/fs/xfs/xfs_ialloc_btree.h b/fs/xfs/xfs_ialloc_btree.h
index 37e5dd0..5580e25 100644
--- a/fs/xfs/xfs_ialloc_btree.h
+++ b/fs/xfs/xfs_ialloc_btree.h
@@ -36,7 +36,6 @@ typedef	__uint64_t	xfs_inofree_t;
 #define	XFS_INODES_PER_CHUNK_LOG	(XFS_NBBYLOG + 3)
 #define	XFS_INOBT_ALL_FREE	((xfs_inofree_t)-1)
 
-#define	XFS_INOBT_MASKN(i,n)		xfs_inobt_maskn(i,n)
 static inline xfs_inofree_t xfs_inobt_maskn(int i, int n)
 {
 	return (((n) >= XFS_INODES_PER_CHUNK ? \
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5a5e035..be2ca4d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1601,10 +1601,10 @@ xfs_itruncate_finish(
 		 * in this file with garbage in them once recovery
 		 * runs.
 		 */
-		XFS_BMAP_INIT(&free_list, &first_block);
+		xfs_bmap_init(&free_list, &first_block);
 		error = xfs_bunmapi(ntp, ip,
 				    first_unmap_block, unmap_len,
-				    XFS_BMAPI_AFLAG(fork) |
+				    xfs_bmapi_aflag(fork) |
 				      (sync ? 0 : XFS_BMAPI_ASYNC),
 				    XFS_ITRUNC_MAX_EXTENTS,
 				    &first_block, &free_list,
@@ -2557,7 +2557,7 @@ xfs_iextents_copy(
 	for (i = 0; i < nrecs; i++) {
 		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
 		start_block = xfs_bmbt_get_startblock(ep);
-		if (ISNULLSTARTBLOCK(start_block)) {
+		if (isnullstartblock(start_block)) {
 			/*
 			 * It's a delayed allocation extent, so skip it.
 			 */
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 1ff04cc..9957d06 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -111,20 +111,16 @@ typedef struct xfs_inode_log_format_64 {
 
 #define	XFS_ILI_IOLOCKED_ANY   (XFS_ILI_IOLOCKED_EXCL | XFS_ILI_IOLOCKED_SHARED)
 
-
-#define	XFS_ILOG_FBROOT(w)	xfs_ilog_fbroot(w)
 static inline int xfs_ilog_fbroot(int w)
 {
 	return (w == XFS_DATA_FORK ? XFS_ILOG_DBROOT : XFS_ILOG_ABROOT);
 }
 
-#define	XFS_ILOG_FEXT(w)	xfs_ilog_fext(w)
 static inline int xfs_ilog_fext(int w)
 {
 	return (w == XFS_DATA_FORK ? XFS_ILOG_DEXT : XFS_ILOG_AEXT);
 }
 
-#define	XFS_ILOG_FDATA(w)	xfs_ilog_fdata(w)
 static inline int xfs_ilog_fdata(int w)
 {
 	return (w == XFS_DATA_FORK ? XFS_ILOG_DDATA : XFS_ILOG_ADATA);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 911062c..08ce723 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -155,7 +155,7 @@ xfs_imap_to_bmap(
 			iomapp->iomap_bn = IOMAP_DADDR_NULL;
 			iomapp->iomap_flags |= IOMAP_DELAY;
 		} else {
-			iomapp->iomap_bn = XFS_FSB_TO_DB(ip, start_block);
+			iomapp->iomap_bn = xfs_fsb_to_db(ip, start_block);
 			if (ISUNWRITTEN(imap))
 				iomapp->iomap_flags |= IOMAP_UNWRITTEN;
 		}
@@ -261,7 +261,7 @@ xfs_iomap(
 		xfs_iunlock(ip, lockmode);
 		lockmode = 0;
 
-		if (nimaps && !ISNULLSTARTBLOCK(imap.br_startblock)) {
+		if (nimaps && !isnullstartblock(imap.br_startblock)) {
 			xfs_iomap_map_trace(XFS_IOMAP_WRITE_MAP, ip,
 					offset, count, iomapp, &imap, flags);
 			break;
@@ -491,7 +491,7 @@ xfs_iomap_write_direct(
 	/*
 	 * Issue the xfs_bmapi() call to allocate the blocks
 	 */
-	XFS_BMAP_INIT(&free_list, &firstfsb);
+	xfs_bmap_init(&free_list, &firstfsb);
 	nimaps = 1;
 	error = xfs_bmapi(tp, ip, offset_fsb, count_fsb, bmapi_flag,
 		&firstfsb, 0, &imap, &nimaps, &free_list, NULL);
@@ -751,7 +751,7 @@ xfs_iomap_write_allocate(
 			xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 			xfs_trans_ihold(tp, ip);
 
-			XFS_BMAP_INIT(&free_list, &first_block);
+			xfs_bmap_init(&free_list, &first_block);
 
 			/*
 			 * it is possible that the extents have changed since
@@ -911,7 +911,7 @@ xfs_iomap_write_unwritten(
 		/*
 		 * Modify the unwritten extent state of the buffer.
 		 */
-		XFS_BMAP_INIT(&free_list, &firstfsb);
+		xfs_bmap_init(&free_list, &firstfsb);
 		nimaps = 1;
 		error = xfs_bmapi(tp, ip, offset_fsb, count_fsb,
 				  XFS_BMAPI_WRITE|XFS_BMAPI_CONVERT, &firstfsb,
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index e19d0a8..cf98a80 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -453,7 +453,7 @@ xfs_bulkstat(
 			    (chunkidx = agino - gino + 1) <
 				    XFS_INODES_PER_CHUNK &&
 					/* there are some left allocated */
-			    XFS_INOBT_MASKN(chunkidx,
+			    xfs_inobt_maskn(chunkidx,
 				    XFS_INODES_PER_CHUNK - chunkidx) & ~gfree) {
 				/*
 				 * Grab the chunk record.  Mark all the
@@ -464,7 +464,7 @@ xfs_bulkstat(
 					if (XFS_INOBT_MASK(i) & ~gfree)
 						gcnt++;
 				}
-				gfree |= XFS_INOBT_MASKN(0, chunkidx);
+				gfree |= xfs_inobt_maskn(0, chunkidx);
 				irbp->ir_startino = gino;
 				irbp->ir_freecount = gcnt;
 				irbp->ir_free = gfree;
@@ -535,7 +535,7 @@ xfs_bulkstat(
 				     chunkidx < XFS_INODES_PER_CHUNK;
 				     chunkidx += nicluster,
 				     agbno += nbcluster) {
-					if (XFS_INOBT_MASKN(chunkidx,
+					if (xfs_inobt_maskn(chunkidx,
 							    nicluster) & ~gfree)
 						xfs_btree_reada_bufs(mp, agno,
 							agbno, nbcluster);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index c1e0284..9bb41a9 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -44,9 +44,9 @@ typedef struct xfs_trans_reservations {
 
 #ifndef __KERNEL__
 
-#define XFS_DADDR_TO_AGNO(mp,d) \
+#define xfs_daddr_to_agno(mp,d) \
 	((xfs_agnumber_t)(XFS_BB_TO_FSBT(mp, d) / (mp)->m_sb.sb_agblocks))
-#define XFS_DADDR_TO_AGBNO(mp,d) \
+#define xfs_daddr_to_agbno(mp,d) \
 	((xfs_agblock_t)(XFS_BB_TO_FSBT(mp, d) % (mp)->m_sb.sb_agblocks))
 
 #else /* __KERNEL__ */
@@ -439,7 +439,6 @@ void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
  */
 #define XFS_MFSI_QUIET		0x40	/* Be silent if mount errors found */
 
-#define XFS_DADDR_TO_AGNO(mp,d)         xfs_daddr_to_agno(mp,d)
 static inline xfs_agnumber_t
 xfs_daddr_to_agno(struct xfs_mount *mp, xfs_daddr_t d)
 {
@@ -448,7 +447,6 @@ xfs_daddr_to_agno(struct xfs_mount *mp, xfs_daddr_t d)
 	return (xfs_agnumber_t) ld;
 }
 
-#define XFS_DADDR_TO_AGBNO(mp,d)        xfs_daddr_to_agbno(mp,d)
 static inline xfs_agblock_t
 xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 {
diff --git a/fs/xfs/xfs_rename.c b/fs/xfs/xfs_rename.c
index 86471bb..58f85e9 100644
--- a/fs/xfs/xfs_rename.c
+++ b/fs/xfs/xfs_rename.c
@@ -147,7 +147,7 @@ xfs_rename(
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip,
 				inodes, &num_inodes);
 
-	XFS_BMAP_INIT(&free_list, &first_block);
+	xfs_bmap_init(&free_list, &first_block);
 	tp = xfs_trans_alloc(mp, XFS_TRANS_RENAME);
 	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index edf12c7..c5bb86f 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -120,7 +120,7 @@ xfs_growfs_rt_alloc(
 		if ((error = xfs_trans_iget(mp, tp, ino, 0,
 						XFS_ILOCK_EXCL, &ip)))
 			goto error_cancel;
-		XFS_BMAP_INIT(&flist, &firstblock);
+		xfs_bmap_init(&flist, &firstblock);
 		/*
 		 * Allocate blocks to the bitmap file.
 		 */
diff --git a/fs/xfs/xfs_rw.h b/fs/xfs/xfs_rw.h
index f87db53..f76c003 100644
--- a/fs/xfs/xfs_rw.h
+++ b/fs/xfs/xfs_rw.h
@@ -28,7 +28,6 @@ struct xfs_mount;
  * file is a real time file or not, because the bmap code
  * does.
  */
-#define	XFS_FSB_TO_DB(ip,fsb)	xfs_fsb_to_db(ip,fsb)
 static inline xfs_daddr_t
 xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
 {
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 1ed7191..1b017c6 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -505,7 +505,7 @@ static inline void xfs_sb_version_removeattr2(xfs_sb_t *sbp)
 
 #define	XFS_HDR_BLOCK(mp,d)	((xfs_agblock_t)XFS_BB_TO_FSBT(mp,d))
 #define	XFS_DADDR_TO_FSB(mp,d)	XFS_AGB_TO_FSB(mp, \
-			XFS_DADDR_TO_AGNO(mp,d), XFS_DADDR_TO_AGBNO(mp,d))
+			xfs_daddr_to_agno(mp,d), xfs_daddr_to_agbno(mp,d))
 #define	XFS_FSB_TO_DADDR(mp,fsbno)	XFS_AGB_TO_DADDR(mp, \
 			XFS_FSB_TO_AGNO(mp,fsbno), XFS_FSB_TO_AGBNO(mp,fsbno))
 
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index f07bf87..0e55c5d 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -862,7 +862,7 @@ xfs_inactive_symlink_rmt(
 	 * Find the block(s) so we can inval and unmap them.
 	 */
 	done = 0;
-	XFS_BMAP_INIT(&free_list, &first_block);
+	xfs_bmap_init(&free_list, &first_block);
 	nmaps = ARRAY_SIZE(mval);
 	if ((error = xfs_bmapi(tp, ip, 0, XFS_B_TO_FSB(mp, size),
 			XFS_BMAPI_METADATA, &first_block, 0, mval, &nmaps,
@@ -1288,7 +1288,7 @@ xfs_inactive(
 	/*
 	 * Free the inode.
 	 */
-	XFS_BMAP_INIT(&free_list, &first_block);
+	xfs_bmap_init(&free_list, &first_block);
 	error = xfs_ifree(tp, ip, &free_list);
 	if (error) {
 		/*
@@ -1461,7 +1461,7 @@ xfs_create(
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = B_TRUE;
 
-	XFS_BMAP_INIT(&free_list, &first_block);
+	xfs_bmap_init(&free_list, &first_block);
 
 	ASSERT(ip == NULL);
 
@@ -1879,7 +1879,7 @@ xfs_remove(
 		}
 	}
 
-	XFS_BMAP_INIT(&free_list, &first_block);
+	xfs_bmap_init(&free_list, &first_block);
 	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
 					&first_block, &free_list, resblks);
 	if (error) {
@@ -2059,7 +2059,7 @@ xfs_link(
 	if (error)
 		goto error_return;
 
-	XFS_BMAP_INIT(&free_list, &first_block);
+	xfs_bmap_init(&free_list, &first_block);
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
 					&first_block, &free_list, resblks);
@@ -2231,7 +2231,7 @@ xfs_mkdir(
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	unlock_dp_on_error = B_FALSE;
 
-	XFS_BMAP_INIT(&free_list, &first_block);
+	xfs_bmap_init(&free_list, &first_block);
 
 	error = xfs_dir_createname(tp, dp, dir_name, cdp->i_ino,
 					&first_block, &free_list, resblks ?
@@ -2438,7 +2438,7 @@ xfs_symlink(
 	 * Initialize the bmap freelist prior to calling either
 	 * bmapi or the directory create code.
 	 */
-	XFS_BMAP_INIT(&free_list, &first_block);
+	xfs_bmap_init(&free_list, &first_block);
 
 	/*
 	 * Allocate an inode for the symlink.
@@ -2860,7 +2860,7 @@ retry:
 		/*
 		 * Issue the xfs_bmapi() call to allocate the blocks
 		 */
-		XFS_BMAP_INIT(&free_list, &firstfsb);
+		xfs_bmap_init(&free_list, &firstfsb);
 		error = xfs_bmapi(tp, ip, startoffset_fsb,
 				  allocatesize_fsb, bmapi_flag,
 				  &firstfsb, 0, imapp, &nimaps,
@@ -2980,7 +2980,7 @@ xfs_zero_remaining_bytes(
 		XFS_BUF_UNDONE(bp);
 		XFS_BUF_UNWRITE(bp);
 		XFS_BUF_READ(bp);
-		XFS_BUF_SET_ADDR(bp, XFS_FSB_TO_DB(ip, imap.br_startblock));
+		XFS_BUF_SET_ADDR(bp, xfs_fsb_to_db(ip, imap.br_startblock));
 		xfsbdstrat(mp, bp);
 		error = xfs_iowait(bp);
 		if (error) {
@@ -3186,7 +3186,7 @@ xfs_free_file_space(
 		/*
 		 * issue the bunmapi() call to free the blocks
 		 */
-		XFS_BMAP_INIT(&free_list, &firstfsb);
+		xfs_bmap_init(&free_list, &firstfsb);
 		error = xfs_bunmapi(tp, ip, startoffset_fsb,
 				  endoffset_fsb - startoffset_fsb,
 				  0, 2, &firstfsb, &free_list, NULL, &done);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
