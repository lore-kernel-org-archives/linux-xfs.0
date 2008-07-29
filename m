Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 12:29:53 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6TJTkOp031874
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:29:47 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D05871947CF2
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:30:57 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 2jGH4JGEBSxQUIBO for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:30:57 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6TJUwIF019278
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 21:30:59 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6TJUwG8019276
	for xfs@oss.sgi.com; Tue, 29 Jul 2008 21:30:58 +0200
Date: Tue, 29 Jul 2008 21:30:58 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/21] implement generic xfs_btree_decrement
Message-ID: <20080729193058.GK19104@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-common-btree-decrement
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

From: Dave Chinner <dgc@sgi.com>

[hch: split out from bigger patch and minor adaptions]

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-07-15 17:46:47.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-07-15 17:51:36.000000000 +0200
@@ -1057,3 +1057,99 @@ error0:
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
 	return error;
 }
+
+/*
+ * Decrement cursor by one record at the level.
+ * For nonzero levels the leaf-ward information is untouched.
+ */
+int						/* error */
+xfs_btree_decrement(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	int			*stat)		/* success/failure */
+{
+	struct xfs_btree_block	*block;
+	xfs_buf_t		*bp;
+	int			error;		/* error return value */
+	int			lev;
+	union xfs_btree_ptr	ptr;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGI(cur, level);
+
+	ASSERT(level < cur->bc_nlevels);
+
+	/* Read-ahead to the left at this level. */
+	xfs_btree_readahead(cur, level, XFS_BTCUR_LEFTRA);
+
+	/* We're done if we remain in the block after the decrement. */
+	if (--cur->bc_ptrs[level] > 0)
+		goto out1;
+
+	/* Get a pointer to the btree block. */
+	block = xfs_btree_get_block(cur, level, &bp);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, block, level, bp);
+	if (error)
+		goto error0;
+#endif
+
+	/* Fail if we just went off the left edge of the tree. */
+	xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_LEFTSIB);
+	if (xfs_btree_ptr_is_null(cur, &ptr))
+		goto out0;
+
+	XFS_BTREE_STATS_INC(cur, decrement);
+
+	/*
+	 * March up the tree decrementing pointers.
+	 * Stop when we don't go off the left edge of a block.
+	 */
+	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
+		if (--cur->bc_ptrs[lev] > 0)
+			break;
+		/* Read-ahead the left block for the next loop. */
+		xfs_btree_readahead(cur, lev, XFS_BTCUR_LEFTRA);
+	}
+
+	/*
+	 * If we went off the root then we are seriously confused.
+	 * or the root of the tree is in an inode.
+	 */
+	if (lev == cur->bc_nlevels) {
+		ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
+		goto out0;
+	}
+	ASSERT(lev < cur->bc_nlevels);
+
+	/*
+	 * Now walk back down the tree, fixing up the cursor's buffer
+	 * pointers and key numbers.
+	 */
+	for (block = xfs_btree_get_block(cur, lev, &bp); lev > level; ) {
+		union xfs_btree_ptr	*ptrp;
+
+		ptrp = cur->bc_ops->ptr_addr(cur, cur->bc_ptrs[lev], block);
+		error = xfs_btree_read_buf_block(cur, ptrp, --lev,
+							0, &block, &bp);
+		if (error)
+			goto error0;
+		xfs_btree_setbuf(cur, lev, bp);
+		cur->bc_ptrs[lev] = xfs_btree_get_numrecs(block);
+	}
+out1:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+
+out0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 0;
+	return 0;
+
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
Index: linux-2.6-xfs/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc.c	2008-07-15 17:46:47.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc.c	2008-07-15 17:46:52.000000000 +0200
@@ -961,7 +961,7 @@ xfs_alloc_ag_vextent_near(
 					args->minlen, &ltbnoa, &ltlena);
 			if (ltlena >= args->minlen)
 				break;
-			if ((error = xfs_alloc_decrement(bno_cur_lt, 0, &i)))
+			if ((error = xfs_btree_decrement(bno_cur_lt, 0, &i)))
 				goto error0;
 			if (!i) {
 				xfs_btree_del_cursor(bno_cur_lt,
@@ -1162,7 +1162,7 @@ xfs_alloc_ag_vextent_near(
 					/*
 					 * Fell off the left end.
 					 */
-					if ((error = xfs_alloc_decrement(
+					if ((error = xfs_btree_decrement(
 							bno_cur_lt, 0, &i)))
 						goto error0;
 					if (!i) {
@@ -1321,7 +1321,7 @@ xfs_alloc_ag_vextent_size(
 		bestflen = flen;
 		bestfbno = fbno;
 		for (;;) {
-			if ((error = xfs_alloc_decrement(cnt_cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cnt_cur, 0, &i)))
 				goto error0;
 			if (i == 0)
 				break;
@@ -1416,7 +1416,7 @@ xfs_alloc_ag_vextent_small(
 	xfs_extlen_t	flen;
 	int		i;
 
-	if ((error = xfs_alloc_decrement(ccur, 0, &i)))
+	if ((error = xfs_btree_decrement(ccur, 0, &i)))
 		goto error0;
 	if (i) {
 		if ((error = xfs_alloc_get_rec(ccur, &fbno, &flen, &i)))
@@ -1607,7 +1607,7 @@ xfs_free_ag_extent(
 		/*
 		 * Move the by-block cursor back to the left neighbor.
 		 */
-		if ((error = xfs_alloc_decrement(bno_cur, 0, &i)))
+		if ((error = xfs_btree_decrement(bno_cur, 0, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 #ifdef DEBUG
@@ -1653,7 +1653,7 @@ xfs_free_ag_extent(
 		 * Back up the by-block cursor to the left neighbor, and
 		 * update its length.
 		 */
-		if ((error = xfs_alloc_decrement(bno_cur, 0, &i)))
+		if ((error = xfs_btree_decrement(bno_cur, 0, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		nbno = ltbno;
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-07-15 17:46:47.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-07-15 17:46:52.000000000 +0200
@@ -256,7 +256,7 @@ xfs_alloc_delrec(
 			xfs_btree_setbuf(cur, level, NULL);
 			cur->bc_nlevels--;
 		} else if (level > 0 &&
-			   (error = xfs_alloc_decrement(cur, level, &i)))
+			   (error = xfs_btree_decrement(cur, level, &i)))
 			return error;
 		*stat = 1;
 		return 0;
@@ -272,7 +272,7 @@ xfs_alloc_delrec(
 	 * the minimum, we're done.
 	 */
 	if (numrecs >= XFS_ALLOC_BLOCK_MINRECS(level, cur)) {
-		if (level > 0 && (error = xfs_alloc_decrement(cur, level, &i)))
+		if (level > 0 && (error = xfs_btree_decrement(cur, level, &i)))
 			return error;
 		*stat = 1;
 		return 0;
@@ -336,7 +336,7 @@ xfs_alloc_delrec(
 				xfs_btree_del_cursor(tcur,
 						     XFS_BTREE_NOERROR);
 				if (level > 0 &&
-				    (error = xfs_alloc_decrement(cur, level,
+				    (error = xfs_btree_decrement(cur, level,
 					    &i)))
 					return error;
 				*stat = 1;
@@ -352,7 +352,7 @@ xfs_alloc_delrec(
 		if (lbno != NULLAGBLOCK) {
 			i = xfs_btree_firstrec(tcur, level);
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-			if ((error = xfs_alloc_decrement(tcur, level, &i)))
+			if ((error = xfs_btree_decrement(tcur, level, &i)))
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		}
@@ -368,7 +368,7 @@ xfs_alloc_delrec(
 		 */
 		i = xfs_btree_firstrec(tcur, level);
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_alloc_decrement(tcur, level, &i)))
+		if ((error = xfs_btree_decrement(tcur, level, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		xfs_btree_firstrec(tcur, level);
@@ -468,7 +468,7 @@ xfs_alloc_delrec(
 	 * Just return.  This is probably a logic error, but it's not fatal.
 	 */
 	else {
-		if (level > 0 && (error = xfs_alloc_decrement(cur, level, &i)))
+		if (level > 0 && (error = xfs_btree_decrement(cur, level, &i)))
 			return error;
 		*stat = 1;
 		return 0;
@@ -1780,90 +1780,6 @@ xfs_alloc_updkey(
  */
 
 /*
- * Decrement cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-int					/* error */
-xfs_alloc_decrement(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level in btree, 0 is leaf */
-	int			*stat)	/* success/failure */
-{
-	xfs_alloc_block_t	*block;	/* btree block */
-	int			error;	/* error return value */
-	int			lev;	/* btree level */
-
-	ASSERT(level < cur->bc_nlevels);
-	/*
-	 * Read-ahead to the left at this level.
-	 */
-	xfs_btree_readahead(cur, level, XFS_BTCUR_LEFTRA);
-	/*
-	 * Decrement the ptr at this level.  If we're still in the block
-	 * then we're done.
-	 */
-	if (--cur->bc_ptrs[level] > 0) {
-		*stat = 1;
-		return 0;
-	}
-	/*
-	 * Get a pointer to the btree block.
-	 */
-	block = XFS_BUF_TO_ALLOC_BLOCK(cur->bc_bufs[level]);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, level,
-			cur->bc_bufs[level])))
-		return error;
-#endif
-	/*
-	 * If we just went off the left edge of the tree, return failure.
-	 */
-	if (be32_to_cpu(block->bb_leftsib) == NULLAGBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * March up the tree decrementing pointers.
-	 * Stop when we don't go off the left edge of a block.
-	 */
-	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
-		if (--cur->bc_ptrs[lev] > 0)
-			break;
-		/*
-		 * Read-ahead the left block, we're going to read it
-		 * in the next loop.
-		 */
-		xfs_btree_readahead(cur, lev, XFS_BTCUR_LEFTRA);
-	}
-	/*
-	 * If we went off the root then we are seriously confused.
-	 */
-	ASSERT(lev < cur->bc_nlevels);
-	/*
-	 * Now walk back down the tree, fixing up the cursor's buffer
-	 * pointers and key numbers.
-	 */
-	for (block = XFS_BUF_TO_ALLOC_BLOCK(cur->bc_bufs[lev]); lev > level; ) {
-		xfs_agblock_t	agbno;	/* block number of btree block */
-		xfs_buf_t	*bp;	/* buffer pointer for block */
-
-		agbno = be32_to_cpu(*XFS_ALLOC_PTR_ADDR(block, cur->bc_ptrs[lev], cur));
-		if ((error = xfs_btree_read_bufs(cur->bc_mp, cur->bc_tp,
-				cur->bc_private.a.agno, agbno, 0, &bp,
-				XFS_ALLOC_BTREE_REF)))
-			return error;
-		lev--;
-		xfs_btree_setbuf(cur, lev, bp);
-		block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-		if ((error = xfs_btree_check_sblock(cur, block, lev, bp)))
-			return error;
-		cur->bc_ptrs[lev] = be16_to_cpu(block->bb_numrecs);
-	}
-	*stat = 1;
-	return 0;
-}
-
-/*
  * Delete the record pointed to by cur.
  * The cursor refers to the place where the record was (could be inserted)
  * when the operation returns.
@@ -1889,7 +1805,7 @@ xfs_alloc_delete(
 	if (i == 0) {
 		for (level = 1; level < cur->bc_nlevels; level++) {
 			if (cur->bc_ptrs[level] == 0) {
-				if ((error = xfs_alloc_decrement(cur, level, &i)))
+				if ((error = xfs_btree_decrement(cur, level, &i)))
 					return error;
 				break;
 			}
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.h	2008-07-15 17:46:47.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h	2008-07-15 17:46:52.000000000 +0200
@@ -95,12 +95,6 @@ typedef	struct xfs_btree_sblock xfs_allo
 	XFS_BTREE_PTR_ADDR(xfs_alloc, bb, i, XFS_ALLOC_BLOCK_MAXRECS(1, cur))
 
 /*
- * Decrement cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-extern int xfs_alloc_decrement(struct xfs_btree_cur *cur, int level, int *stat);
-
-/*
  * Delete the record pointed to by cur.
  * The cursor refers to the place where the record was (could be inserted)
  * when the operation returns.
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-07-15 17:46:47.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-07-15 17:46:52.000000000 +0200
@@ -820,7 +820,7 @@ xfs_bmap_add_extent_delay_real(
 			if ((error = xfs_bmbt_delete(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
@@ -1381,13 +1381,13 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_bmbt_delete(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_delete(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
@@ -1430,7 +1430,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_bmbt_delete(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
@@ -1473,7 +1473,7 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_bmbt_delete(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, new->br_startoff,
@@ -1556,7 +1556,7 @@ xfs_bmap_add_extent_unwritten_real(
 				PREV.br_blockcount - new->br_blockcount,
 				oldext)))
 				goto done;
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			if (xfs_bmbt_update(cur, LEFT.br_startoff,
 				LEFT.br_startblock,
@@ -2108,7 +2108,7 @@ xfs_bmap_add_extent_hole_real(
 			if ((error = xfs_bmbt_delete(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, left.br_startoff,
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-07-15 17:46:47.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-07-15 17:46:52.000000000 +0200
@@ -202,7 +202,7 @@ xfs_bmbt_delrec(
 			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 			goto error0;
 		}
-		if (level > 0 && (error = xfs_bmbt_decrement(cur, level, &j))) {
+		if (level > 0 && (error = xfs_btree_decrement(cur, level, &j))) {
 			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 			goto error0;
 		}
@@ -215,7 +215,7 @@ xfs_bmbt_delrec(
 		goto error0;
 	}
 	if (numrecs >= XFS_BMAP_BLOCK_IMINRECS(level, cur)) {
-		if (level > 0 && (error = xfs_bmbt_decrement(cur, level, &j))) {
+		if (level > 0 && (error = xfs_btree_decrement(cur, level, &j))) {
 			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 			goto error0;
 		}
@@ -236,7 +236,7 @@ xfs_bmbt_delrec(
 			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 			goto error0;
 		}
-		if (level > 0 && (error = xfs_bmbt_decrement(cur, level, &i))) {
+		if (level > 0 && (error = xfs_btree_decrement(cur, level, &i))) {
 			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 			goto error0;
 		}
@@ -281,7 +281,7 @@ xfs_bmbt_delrec(
 				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
 				tcur = NULL;
 				if (level > 0) {
-					if ((error = xfs_bmbt_decrement(cur,
+					if ((error = xfs_btree_decrement(cur,
 							level, &i))) {
 						XFS_BMBT_TRACE_CURSOR(cur,
 							ERROR);
@@ -297,7 +297,7 @@ xfs_bmbt_delrec(
 		if (lbno != NULLFSBLOCK) {
 			i = xfs_btree_firstrec(tcur, level);
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-			if ((error = xfs_bmbt_decrement(tcur, level, &i))) {
+			if ((error = xfs_btree_decrement(tcur, level, &i))) {
 				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 				goto error0;
 			}
@@ -310,7 +310,7 @@ xfs_bmbt_delrec(
 		/*
 		 * decrement to last in block
 		 */
-		if ((error = xfs_bmbt_decrement(tcur, level, &i))) {
+		if ((error = xfs_btree_decrement(tcur, level, &i))) {
 			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 			goto error0;
 		}
@@ -382,7 +382,7 @@ xfs_bmbt_delrec(
 		}
 		lrecs = be16_to_cpu(left->bb_numrecs);
 	} else {
-		if (level > 0 && (error = xfs_bmbt_decrement(cur, level, &i))) {
+		if (level > 0 && (error = xfs_btree_decrement(cur, level, &i))) {
 			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 			goto error0;
 		}
@@ -1485,80 +1485,6 @@ xfs_bmdr_to_bmbt(
 }
 
 /*
- * Decrement cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-int						/* error */
-xfs_bmbt_decrement(
-	xfs_btree_cur_t		*cur,
-	int			level,
-	int			*stat)		/* success/failure */
-{
-	xfs_bmbt_block_t	*block;
-	xfs_buf_t		*bp;
-	int			error;		/* error return value */
-	xfs_fsblock_t		fsbno;
-	int			lev;
-	xfs_mount_t		*mp;
-	xfs_trans_t		*tp;
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGI(cur, level);
-	ASSERT(level < cur->bc_nlevels);
-
-	xfs_btree_readahead(cur, level, XFS_BTCUR_LEFTRA);
-
-	if (--cur->bc_ptrs[level] > 0) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 1;
-		return 0;
-	}
-	block = xfs_bmbt_get_block(cur, level, &bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_lblock(cur, block, level, bp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-#endif
-	if (be64_to_cpu(block->bb_leftsib) == NULLDFSBNO) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
-		if (--cur->bc_ptrs[lev] > 0)
-			break;
-		xfs_btree_readahead(cur, lev, XFS_BTCUR_LEFTRA);
-	}
-	if (lev == cur->bc_nlevels) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	tp = cur->bc_tp;
-	mp = cur->bc_mp;
-	for (block = xfs_bmbt_get_block(cur, lev, &bp); lev > level; ) {
-		fsbno = be64_to_cpu(*XFS_BMAP_PTR_IADDR(block, cur->bc_ptrs[lev], cur));
-		if ((error = xfs_btree_read_bufl(mp, tp, fsbno, 0, &bp,
-				XFS_BMAP_BTREE_REF))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-		lev--;
-		xfs_btree_setbuf(cur, lev, bp);
-		block = XFS_BUF_TO_BMBT_BLOCK(bp);
-		if ((error = xfs_btree_check_lblock(cur, block, lev, bp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-		cur->bc_ptrs[lev] = be16_to_cpu(block->bb_numrecs);
-	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*stat = 1;
-	return 0;
-}
-
-/*
  * Delete the record pointed to by cur.
  */
 int					/* error */
@@ -1580,7 +1506,7 @@ xfs_bmbt_delete(
 	if (i == 0) {
 		for (level = 1; level < cur->bc_nlevels; level++) {
 			if (cur->bc_ptrs[level] == 0) {
-				if ((error = xfs_bmbt_decrement(cur, level,
+				if ((error = xfs_btree_decrement(cur, level,
 						&i))) {
 					XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 					return error;
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.h	2008-07-15 17:46:47.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h	2008-07-15 17:46:52.000000000 +0200
@@ -237,7 +237,6 @@ typedef struct xfs_btree_lblock xfs_bmbt
  * Prototypes for xfs_bmap.c to call.
  */
 extern void xfs_bmdr_to_bmbt(xfs_bmdr_block_t *, int, xfs_bmbt_block_t *, int);
-extern int xfs_bmbt_decrement(struct xfs_btree_cur *, int, int *);
 extern int xfs_bmbt_delete(struct xfs_btree_cur *, int *);
 extern void xfs_bmbt_get_all(xfs_bmbt_rec_host_t *r, xfs_bmbt_irec_t *s);
 extern xfs_bmbt_block_t *xfs_bmbt_get_block(struct xfs_btree_cur *cur,
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c	2008-07-15 17:46:47.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c	2008-07-15 17:46:52.000000000 +0200
@@ -739,7 +739,7 @@ nextag:
 			/*
 			 * Search left with tcur, back up 1 record.
 			 */
-			if ((error = xfs_inobt_decrement(tcur, 0, &i)))
+			if ((error = xfs_btree_decrement(tcur, 0, &i)))
 				goto error1;
 			doneleft = !i;
 			if (!doneleft) {
@@ -815,7 +815,7 @@ nextag:
 				 * further left.
 				 */
 				if (useleft) {
-					if ((error = xfs_inobt_decrement(tcur, 0,
+					if ((error = xfs_btree_decrement(tcur, 0,
 							&i)))
 						goto error1;
 					doneleft = !i;
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-07-15 17:46:47.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-07-15 17:46:52.000000000 +0200
@@ -205,7 +205,7 @@ xfs_inobt_delrec(
 			cur->bc_bufs[level] = NULL;
 			cur->bc_nlevels--;
 		} else if (level > 0 &&
-			   (error = xfs_inobt_decrement(cur, level, &i)))
+			   (error = xfs_btree_decrement(cur, level, &i)))
 			return error;
 		*stat = 1;
 		return 0;
@@ -222,7 +222,7 @@ xfs_inobt_delrec(
 	 */
 	if (numrecs >= XFS_INOBT_BLOCK_MINRECS(level, cur)) {
 		if (level > 0 &&
-		    (error = xfs_inobt_decrement(cur, level, &i)))
+		    (error = xfs_btree_decrement(cur, level, &i)))
 			return error;
 		*stat = 1;
 		return 0;
@@ -286,7 +286,7 @@ xfs_inobt_delrec(
 				xfs_btree_del_cursor(tcur,
 						     XFS_BTREE_NOERROR);
 				if (level > 0 &&
-				    (error = xfs_inobt_decrement(cur, level,
+				    (error = xfs_btree_decrement(cur, level,
 						&i)))
 					return error;
 				*stat = 1;
@@ -301,7 +301,7 @@ xfs_inobt_delrec(
 		rrecs = be16_to_cpu(right->bb_numrecs);
 		if (lbno != NULLAGBLOCK) {
 			xfs_btree_firstrec(tcur, level);
-			if ((error = xfs_inobt_decrement(tcur, level, &i)))
+			if ((error = xfs_btree_decrement(tcur, level, &i)))
 				goto error0;
 		}
 	}
@@ -315,7 +315,7 @@ xfs_inobt_delrec(
 		 * previous block.
 		 */
 		xfs_btree_firstrec(tcur, level);
-		if ((error = xfs_inobt_decrement(tcur, level, &i)))
+		if ((error = xfs_btree_decrement(tcur, level, &i)))
 			goto error0;
 		xfs_btree_firstrec(tcur, level);
 		/*
@@ -414,7 +414,7 @@ xfs_inobt_delrec(
 	 * Just return.  This is probably a logic error, but it's not fatal.
 	 */
 	else {
-		if (level > 0 && (error = xfs_inobt_decrement(cur, level, &i)))
+		if (level > 0 && (error = xfs_btree_decrement(cur, level, &i)))
 			return error;
 		*stat = 1;
 		return 0;
@@ -1656,90 +1656,6 @@ xfs_inobt_updkey(
  */
 
 /*
- * Decrement cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-int					/* error */
-xfs_inobt_decrement(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level in btree, 0 is leaf */
-	int			*stat)	/* success/failure */
-{
-	xfs_inobt_block_t	*block;	/* btree block */
-	int			error;
-	int			lev;	/* btree level */
-
-	ASSERT(level < cur->bc_nlevels);
-	/*
-	 * Read-ahead to the left at this level.
-	 */
-	xfs_btree_readahead(cur, level, XFS_BTCUR_LEFTRA);
-	/*
-	 * Decrement the ptr at this level.  If we're still in the block
-	 * then we're done.
-	 */
-	if (--cur->bc_ptrs[level] > 0) {
-		*stat = 1;
-		return 0;
-	}
-	/*
-	 * Get a pointer to the btree block.
-	 */
-	block = XFS_BUF_TO_INOBT_BLOCK(cur->bc_bufs[level]);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, level,
-			cur->bc_bufs[level])))
-		return error;
-#endif
-	/*
-	 * If we just went off the left edge of the tree, return failure.
-	 */
-	if (be32_to_cpu(block->bb_leftsib) == NULLAGBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * March up the tree decrementing pointers.
-	 * Stop when we don't go off the left edge of a block.
-	 */
-	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
-		if (--cur->bc_ptrs[lev] > 0)
-			break;
-		/*
-		 * Read-ahead the left block, we're going to read it
-		 * in the next loop.
-		 */
-		xfs_btree_readahead(cur, lev, XFS_BTCUR_LEFTRA);
-	}
-	/*
-	 * If we went off the root then we are seriously confused.
-	 */
-	ASSERT(lev < cur->bc_nlevels);
-	/*
-	 * Now walk back down the tree, fixing up the cursor's buffer
-	 * pointers and key numbers.
-	 */
-	for (block = XFS_BUF_TO_INOBT_BLOCK(cur->bc_bufs[lev]); lev > level; ) {
-		xfs_agblock_t	agbno;	/* block number of btree block */
-		xfs_buf_t	*bp;	/* buffer containing btree block */
-
-		agbno = be32_to_cpu(*XFS_INOBT_PTR_ADDR(block, cur->bc_ptrs[lev], cur));
-		if ((error = xfs_btree_read_bufs(cur->bc_mp, cur->bc_tp,
-				cur->bc_private.a.agno, agbno, 0, &bp,
-				XFS_INO_BTREE_REF)))
-			return error;
-		lev--;
-		xfs_btree_setbuf(cur, lev, bp);
-		block = XFS_BUF_TO_INOBT_BLOCK(bp);
-		if ((error = xfs_btree_check_sblock(cur, block, lev, bp)))
-			return error;
-		cur->bc_ptrs[lev] = be16_to_cpu(block->bb_numrecs);
-	}
-	*stat = 1;
-	return 0;
-}
-
-/*
  * Delete the record pointed to by cur.
  * The cursor refers to the place where the record was (could be inserted)
  * when the operation returns.
@@ -1765,7 +1681,7 @@ xfs_inobt_delete(
 	if (i == 0) {
 		for (level = 1; level < cur->bc_nlevels; level++) {
 			if (cur->bc_ptrs[level] == 0) {
-				if ((error = xfs_inobt_decrement(cur, level, &i)))
+				if ((error = xfs_btree_decrement(cur, level, &i)))
 					return error;
 				break;
 			}
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.h	2008-07-15 17:46:47.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h	2008-07-15 17:46:52.000000000 +0200
@@ -117,12 +117,6 @@ typedef	struct xfs_btree_sblock xfs_inob
 				i, XFS_INOBT_BLOCK_MAXRECS(1, cur)))
 
 /*
- * Decrement cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-extern int xfs_inobt_decrement(struct xfs_btree_cur *cur, int level, int *stat);
-
-/*
  * Delete the record pointed to by cur.
  * The cursor refers to the place where the record was (could be inserted)
  * when the operation returns.
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-07-15 17:46:47.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-07-15 17:46:52.000000000 +0200
@@ -511,6 +511,7 @@ xfs_btree_setbuf(
  */
 
 int xfs_btree_increment(struct xfs_btree_cur *, int, int *);
+int xfs_btree_decrement(struct xfs_btree_cur *, int, int *);
 
 
 /*

-- 
