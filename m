Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Aug 2008 18:50:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m741YeFP001455
	for <xfs@oss.sgi.com>; Sun, 3 Aug 2008 18:34:40 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 06C513566D5
	for <xfs@oss.sgi.com>; Sun,  3 Aug 2008 18:35:50 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id W3LPQ4D8y3yUKQQH for <xfs@oss.sgi.com>; Sun, 03 Aug 2008 18:35:50 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m741ZoIF009311
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 03:35:50 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m741ZoEA009309
	for xfs@oss.sgi.com; Mon, 4 Aug 2008 03:35:50 +0200
Date: Mon, 4 Aug 2008 03:35:50 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 23/26] implement generic xfs_btree_delete/delrec
Message-ID: <20080804013550.GX8819@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-common-btree-delete
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Make the btree delete code generic.  Based on a patch from David Chinner
with lots of changes to follow the original btree implementations more
closely.  While this loses some of the generic helper routines for
inserting/moving/removing records it also solves some of the one off
bugs in the original code and makes it easier to verify.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-08-04 01:18:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-08-04 01:18:45.000000000 +0200
@@ -2943,3 +2943,639 @@ out0:
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 	return 0;
 }
+
+STATIC int
+xfs_btree_dec_cursor(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	int			*stat)
+{
+	int			error;
+	int			i;
+
+	if (level > 0) {
+		error = xfs_btree_decrement(cur, level, &i);
+		if (error)
+			return error;
+	}
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+}
+
+STATIC int
+xfs_btree_update_root(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp,
+	int			level,
+	union xfs_btree_ptr	*newroot)
+{
+	int			error;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_STATS_INC(cur, killroot);
+
+#ifdef DEBUG
+	if (cur->bc_btnum == XFS_BTNUM_BNO || cur->bc_btnum == XFS_BTNUM_CNT) {
+		struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+		struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+
+		ASSERT(be32_to_cpu(agf->agf_roots[cur->bc_btnum]) ==
+		       XFS_DADDR_TO_AGBNO(cur->bc_mp, XFS_BUF_ADDR(bp)));
+	} else if (cur->bc_btnum == XFS_BTNUM_INO) {
+		struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+		struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
+		xfs_fsblock_t		fsbno;
+
+		fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
+				       be32_to_cpu(agi->agi_root));
+
+		ASSERT(fsbno == XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)));
+	}
+#endif
+
+	/*
+	 * Update the root pointer, decreasing the level by 1 and then
+	 * free the old root.
+	 */
+	cur->bc_ops->set_root(cur, newroot, -1);
+	error = cur->bc_ops->free_block(cur, bp, 1);
+	if (error) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+		return error;
+	}
+
+	XFS_BTREE_STATS_INC(cur, free);
+
+	/* Update the cursor so there's one fewer level. */
+	xfs_btree_setbuf(cur, level, NULL);
+	cur->bc_nlevels--;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	return 0;
+}
+
+/*
+ * Single level of the btree record deletion routine.
+ * Delete record pointed to by cur/level.
+ * Remove the record from its block then rebalance the tree.
+ * Return 0 for error, 1 for done, 2 to go on to the next level.
+ */
+STATIC int					/* error */
+xfs_btree_delrec(
+	struct xfs_btree_cur	*cur,		/* btree cursor */
+	int			level,		/* level removing record from */
+	int			*stat)		/* fail/done/go-on */
+{
+	struct xfs_btree_block	*block;		/* bmap btree block */
+	union xfs_btree_ptr	cptr;		/* current block ptr */
+	struct xfs_buf		*bp;		/* buffer for block */
+	int			error;		/* error return value */
+	int			i;		/* loop counter */
+	union xfs_btree_key	key;		/* bmap btree key */
+	union xfs_btree_ptr	lptr;		/* left sibling block ptr */
+	struct xfs_buf		*lbp;		/* left buffer pointer */
+	struct xfs_btree_block	*left;		/* left btree block */
+	int			lrecs = 0;	/* left record count */
+	int			ptr;		/* key/record index */
+	union xfs_btree_ptr	rptr;		/* right sibling block ptr */
+	struct xfs_buf		*rbp;		/* right buffer pointer */
+	struct xfs_btree_block	*right;		/* right btree block */
+	struct xfs_btree_block	*rrblock;	/* right-right btree block */
+	struct xfs_buf		*rrbp;		/* right-right buffer pointer */
+	int			rrecs = 0;	/* right record count */
+	struct xfs_btree_cur	*tcur;		/* temporary btree cursor */
+	int			numrecs;	/* temporary numrec count */
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGI(cur, level);
+
+	tcur = NULL;
+
+	/* Get the index of the entry being deleted, check for nothing there. */
+	ptr = cur->bc_ptrs[level];
+	if (ptr == 0) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+
+	/* Get the buffer & block containing the record or key/ptr. */
+	block = xfs_btree_get_block(cur, level, &bp);
+	numrecs = xfs_btree_get_numrecs(block);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, block, level, bp);
+	if (error)
+		goto error0;
+#endif
+
+	/* Fail if we're off the end of the block. */
+	if (ptr > numrecs) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+
+	XFS_BTREE_STATS_INC(cur, delrec);
+	XFS_BTREE_STATS_ADD(cur, moves, numrecs - ptr);
+
+	/* Excise the entries being deleted. */
+	if (level > 0) {
+		/* It's a nonleaf. operate on keys and ptrs */
+		union xfs_btree_key	*lkp;	/* pointer to bmap btree key */
+		union xfs_btree_ptr	*lpp;	/* pointer to bmap block addr */
+
+		lkp = cur->bc_ops->key_addr(cur, 1, block);
+		lpp = cur->bc_ops->ptr_addr(cur, 1, block);
+
+#ifdef DEBUG
+		for (i = ptr; i < numrecs; i++) {
+			error = xfs_btree_check_ptr(cur, lpp, i, level);
+			if (error)
+				goto error0;
+		}
+#endif
+
+		if (ptr < numrecs) {
+			cur->bc_ops->move_keys(cur, lkp, ptr, ptr - 1,
+						numrecs - ptr);
+			xfs_btree_move_ptrs(cur, lpp, ptr, ptr - 1,
+						numrecs - ptr);
+			cur->bc_ops->log_keys(cur, bp, ptr, numrecs - 1);
+			xfs_btree_log_ptrs(cur, bp, ptr, numrecs - 1);
+		}
+	} else {
+		/* It's a leaf. operate on records */
+		union xfs_btree_rec	*lrp;	/* pointer to bmap btree rec */
+
+		lrp = cur->bc_ops->rec_addr(cur, 1, block);
+		if (ptr < numrecs) {
+			cur->bc_ops->move_recs(cur, lrp, ptr, ptr - 1,
+						numrecs - ptr);
+			cur->bc_ops->log_recs(cur, bp, ptr, numrecs - 1);
+		}
+
+		/*
+		 * If it's the first record in the block, we'll need a key
+		 * structure to pass up to the next level (updkey).
+		 */
+		if (ptr == 1)
+			cur->bc_ops->init_key_from_rec(cur, &key, lrp);
+	}
+
+	/*
+	 * Decrement and log the number of entries in the block.
+	 */
+	xfs_btree_set_numrecs(block, --numrecs);
+	xfs_btree_log_block(cur, bp, XFS_BB_NUMRECS);
+
+	/*
+	 * If we are tracking the last record in the tree and
+	 * we are at the far right edge of the tree, update it.
+	 */
+	if (xfs_btree_is_lastrec(cur, block, level)) {
+		cur->bc_ops->update_lastrec(cur, block, NULL,
+					    ptr, LASTREC_DELREC);
+	}
+
+	/*
+	 * We're at the root level.  First, shrink the root block in-memory.
+	 * Try to get rid of the next level down.  If we can't then there's
+	 * nothing left to do.
+	 */
+	if (level == cur->bc_nlevels - 1) {
+		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+			cur->bc_ops->realloc_root(cur, -1);
+
+			error = xfs_btree_root_to_iroot(cur);
+			if (error)
+				goto error0;
+
+			error = xfs_btree_dec_cursor(cur, level, stat);
+			if (error)
+				goto error0;
+			*stat = 1;
+			return 0;
+		}
+
+		/*
+		 * If this is the root level, and there's only one entry left,
+		 * and it's NOT the leaf level, then we can get rid of this
+		 * level.
+		 */
+		if (numrecs == 1 && level > 0) {
+			union xfs_btree_ptr	*pp;
+			/*
+			 * pp is still set to the first pointer in the block.
+			 * Make it the new root of the btree.
+			 */
+			pp = cur->bc_ops->ptr_addr(cur, 1, block);
+			error = xfs_btree_update_root(cur, bp, level, pp);
+			if (error)
+				goto error0;
+		} else if (level > 0) {
+			error = xfs_btree_dec_cursor(cur, level, stat);
+			if (error)
+				goto error0;
+		}
+		*stat = 1;
+		return 0;
+	}
+
+	/*
+	 * If we deleted the leftmost entry in the block, update the
+	 * key values above us in the tree.
+	 */
+	if (ptr == 1) {
+		error = xfs_btree_updkey(cur, &key, level + 1);
+		if (error)
+			goto error0;
+	}
+
+	/*
+	 * If the number of records remaining in the block is at least
+	 * the minimum, we're done.
+	 */
+	if (numrecs >= cur->bc_ops->get_minrecs(cur, level)) {
+		error = xfs_btree_dec_cursor(cur, level, stat);
+		if (error)
+			goto error0;
+		return 0;
+	}
+
+	/*
+	 * Otherwise, we have to move some records around to keep the
+	 * tree balanced.  Look at the left and right sibling blocks to
+	 * see if we can re-balance by moving only one record.
+	 */
+	xfs_btree_get_sibling(cur, block, &rptr, XFS_BB_RIGHTSIB);
+	xfs_btree_get_sibling(cur, block, &lptr, XFS_BB_LEFTSIB);
+
+	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+		/*
+		 * One child of root, need to get a chance to copy its contents
+		 * into the root and delete it. Can't go up to next level,
+		 * there's nothing to delete there.
+		 */
+		if (xfs_btree_ptr_is_null(cur, &rptr) &&
+		    xfs_btree_ptr_is_null(cur, &lptr) &&
+		    level == cur->bc_nlevels - 2) {
+			error = xfs_btree_root_to_iroot(cur);
+			if (!error)
+				error = xfs_btree_dec_cursor(cur, level, stat);
+			if (error)
+				goto error0;
+			return 0;
+		}
+	}
+
+	ASSERT(!xfs_btree_ptr_is_null(cur, &rptr) ||
+	       !xfs_btree_ptr_is_null(cur, &lptr));
+
+	/*
+	 * Duplicate the cursor so our btree manipulations here won't
+	 * disrupt the next level up.
+	 */
+	error = xfs_btree_dup_cursor(cur, &tcur);
+	if (error)
+		goto error0;
+
+	/*
+	 * If there's a right sibling, see if it's ok to shift an entry
+	 * out of it.
+	 */
+	if (!xfs_btree_ptr_is_null(cur, &rptr)) {
+		/*
+		 * Move the temp cursor to the last entry in the next block.
+		 * Actually any entry but the first would suffice.
+		 */
+		i = xfs_btree_lastrec(tcur, level);
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+		error = xfs_btree_increment(tcur, level, &i);
+		if (error)
+			goto error0;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+		i = xfs_btree_lastrec(tcur, level);
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+		/* Grab a pointer to the block. */
+		right = xfs_btree_get_block(tcur, level, &rbp);
+#ifdef DEBUG
+		error = xfs_btree_check_block(tcur, right, level, rbp);
+		if (error)
+			goto error0;
+#endif
+		/* Grab the current block number, for future use. */
+		xfs_btree_get_sibling(tcur, right, &cptr, XFS_BB_LEFTSIB);
+
+		/*
+		 * If right block is full enough so that removing one entry
+		 * won't make it too empty, and left-shifting an entry out
+		 * of right to us works, we're done.
+		 */
+		if (xfs_btree_get_numrecs(right) - 1 >=
+		    cur->bc_ops->get_minrecs(tcur, level)) {
+			error = xfs_btree_lshift(tcur, level, &i);
+			if (error)
+				goto error0;
+			if (i) {
+				ASSERT(xfs_btree_get_numrecs(block) >=
+				       cur->bc_ops->get_minrecs(tcur, level));
+
+				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+				tcur = NULL;
+
+				error = xfs_btree_dec_cursor(cur, level, stat);
+				if (error)
+					goto error0;
+				return 0;
+			}
+		}
+
+		/*
+		 * Otherwise, grab the number of records in right for
+		 * future reference, and fix up the temp cursor to point
+		 * to our block again (last record).
+		 */
+		rrecs = xfs_btree_get_numrecs(right);
+		if (!xfs_btree_ptr_is_null(cur, &lptr)) {
+			i = xfs_btree_firstrec(tcur, level);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+			error = xfs_btree_decrement(tcur, level, &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		}
+	}
+
+	/*
+	 * If there's a left sibling, see if it's ok to shift an entry
+	 * out of it.
+	 */
+	if (!xfs_btree_ptr_is_null(cur, &lptr)) {
+		/*
+		 * Move the temp cursor to the first entry in the
+		 * previous block.
+		 */
+		i = xfs_btree_firstrec(tcur, level);
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+		error = xfs_btree_decrement(tcur, level, &i);
+		if (error)
+			goto error0;
+		i = xfs_btree_firstrec(tcur, level);
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+		/* Grab a pointer to the block. */
+		left = xfs_btree_get_block(tcur, level, &lbp);
+#ifdef DEBUG
+		error = xfs_btree_check_block(cur, left, level, lbp);
+		if (error)
+			goto error0;
+#endif
+		/* Grab the current block number, for future use. */
+		xfs_btree_get_sibling(tcur, left, &cptr, XFS_BB_RIGHTSIB);
+
+		/*
+		 * If left block is full enough so that removing one entry
+		 * won't make it too empty, and right-shifting an entry out
+		 * of left to us works, we're done.
+		 */
+		if (xfs_btree_get_numrecs(left) - 1 >=
+		    cur->bc_ops->get_minrecs(tcur, level)) {
+			error = xfs_btree_rshift(tcur, level, &i);
+			if (error)
+				goto error0;
+			if (i) {
+				ASSERT(xfs_btree_get_numrecs(block) >=
+				       cur->bc_ops->get_minrecs(tcur, level));
+				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+				tcur = NULL;
+				if (level == 0)
+					cur->bc_ptrs[0]++;
+				XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+				*stat = 1;
+				return 0;
+			}
+		}
+
+		/*
+		 * Otherwise, grab the number of records in right for
+		 * future reference.
+		 */
+		lrecs = xfs_btree_get_numrecs(left);
+	}
+
+	/* Delete the temp cursor, we're done with it. */
+	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+	tcur = NULL;
+
+	/* If here, we need to do a join to keep the tree balanced. */
+	ASSERT(!xfs_btree_ptr_is_null(cur, &cptr));
+
+	if (!xfs_btree_ptr_is_null(cur, &lptr) &&
+	    lrecs + xfs_btree_get_numrecs(block) <=
+			cur->bc_ops->get_maxrecs(cur, level)) {
+		/*
+		 * Set "right" to be the starting block,
+		 * "left" to be the left neighbor.
+		 */
+		rptr = cptr;
+		right = block;
+		rbp = bp;
+		error = xfs_btree_read_buf_block(cur, &lptr, level,
+							0, &left, &lbp);
+		if (error)
+			goto error0;
+
+	/*
+	 * If that won't work, see if we can join with the right neighbor block.
+	 */
+	} else if (!xfs_btree_ptr_is_null(cur, &rptr) &&
+		   rrecs + xfs_btree_get_numrecs(block) <=
+			cur->bc_ops->get_maxrecs(cur, level)) {
+		/*
+		 * Set "left" to be the starting block,
+		 * "right" to be the right neighbor.
+		 */
+		lptr = cptr;
+		left = block;
+		lbp = bp;
+		error = xfs_btree_read_buf_block(cur, &rptr, level,
+							0, &right, &rbp);
+		if (error)
+			goto error0;
+
+	/*
+	 * Otherwise, we can't fix the imbalance.
+	 * Just return.  This is probably a logic error, but it's not fatal.
+	 */
+	} else {
+		error = xfs_btree_dec_cursor(cur, level, stat);
+		if (error)
+			goto error0;
+		return 0;
+	}
+
+	rrecs = xfs_btree_get_numrecs(right);
+	lrecs = xfs_btree_get_numrecs(left);
+
+	/*
+	 * We're now going to join "left" and "right" by moving all the stuff
+	 * in "right" to "left" and deleting "right".
+	 */
+	XFS_BTREE_STATS_ADD(cur, moves, rrecs);
+	if (level > 0) {
+		/* It's a non-leaf.  Move keys and pointers. */
+		union xfs_btree_key	*lkp;	/* left btree key */
+		union xfs_btree_ptr	*lpp;	/* left address pointer */
+		union xfs_btree_key	*rkp;	/* right btree key */
+		union xfs_btree_ptr	*rpp;	/* right address pointer */
+
+		lkp = cur->bc_ops->key_addr(cur, lrecs + 1, left);
+		lpp = cur->bc_ops->ptr_addr(cur, lrecs + 1, left);
+		rkp = cur->bc_ops->key_addr(cur, 1, right);
+		rpp = cur->bc_ops->ptr_addr(cur, 1, right);
+#ifdef DEBUG
+		for (i = 1; i < rrecs; i++) {
+			error = xfs_btree_check_ptr(cur, rpp, i, level);
+			if (error)
+				goto error0;
+		}
+#endif
+		cur->bc_ops->copy_keys(cur, rkp, lkp, rrecs);
+		xfs_btree_copy_ptrs(cur, rpp, lpp, rrecs);
+
+		cur->bc_ops->log_keys(cur, lbp, lrecs + 1, lrecs + rrecs);
+		xfs_btree_log_ptrs(cur, lbp, lrecs + 1, lrecs + rrecs);
+	} else {
+		/* It's a leaf.  Move records.  */
+		union xfs_btree_rec	*lrp;	/* left record pointer */
+		union xfs_btree_rec	*rrp;	/* right record pointer */
+
+		lrp = cur->bc_ops->rec_addr(cur, lrecs + 1, left);
+		rrp = cur->bc_ops->rec_addr(cur, 1, right);
+
+		cur->bc_ops->copy_recs(cur, rrp, lrp, rrecs);
+		cur->bc_ops->log_recs(cur, lbp, lrecs + 1, lrecs + rrecs);
+	}
+
+	XFS_BTREE_STATS_INC(cur, join);
+
+	/*
+	 * Fix up the the number of records and right block pointer in the
+	 * surviving block, and log it.
+	 */
+	xfs_btree_set_numrecs(left, lrecs + rrecs);
+	xfs_btree_get_sibling(cur, right, &cptr, XFS_BB_RIGHTSIB),
+	xfs_btree_set_sibling(cur, left, &cptr, XFS_BB_RIGHTSIB);
+	xfs_btree_log_block(cur, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
+
+	/* If there is a right sibling, point it to the remaining block. */
+	xfs_btree_get_sibling(cur, left, &cptr, XFS_BB_RIGHTSIB);
+	if (!xfs_btree_ptr_is_null(cur, &cptr)) {
+		error = xfs_btree_read_buf_block(cur, &cptr, level,
+							0, &rrblock, &rrbp);
+		if (error)
+			goto error0;
+		xfs_btree_set_sibling(cur, rrblock, &lptr, XFS_BB_LEFTSIB);
+		xfs_btree_log_block(cur, rrbp, XFS_BB_LEFTSIB);
+	}
+	/* Free the deleted block. */
+	error = cur->bc_ops->free_block(cur, rbp, 1);
+	if (error)
+		goto error0;
+	XFS_BTREE_STATS_INC(cur, free);
+
+	/*
+	 * If we joined with the left neighbor, set the buffer in the
+	 * cursor to the left block, and fix up the index.
+	 */
+	if (bp != lbp) {
+		cur->bc_bufs[level] = lbp;
+		cur->bc_ptrs[level] += lrecs;
+		cur->bc_ra[level] = 0;
+	}
+	/*
+	 * If we joined with the right neighbor and there's a level above
+	 * us, increment the cursor at that level.
+	 */
+	else if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) ||
+		   (level + 1 < cur->bc_nlevels)) {
+		error = xfs_btree_increment(cur, level + 1, &i);
+		if (error)
+			goto error0;
+	}
+
+	/*
+	 * Readjust the ptr at this level if it's not a leaf, since it's
+	 * still pointing at the deletion point, which makes the cursor
+	 * inconsistent.  If this makes the ptr 0, the caller fixes it up.
+	 * We can't use decrement because it would change the next level up.
+	 */
+	if (level > 0)
+		cur->bc_ptrs[level]--;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	/* Return value means the next level up has something to do. */
+	*stat = 2;
+	return 0;
+
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	if (tcur)
+		xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
+	return error;
+}
+
+/*
+ * Delete the record pointed to by cur.
+ * The cursor refers to the place where the record was (could be inserted)
+ * when the operation returns.
+ */
+int					/* error */
+xfs_btree_delete(
+	struct xfs_btree_cur	*cur,
+	int			*stat)	/* success/failure */
+{
+	int			error;	/* error return value */
+	int			level;
+	int			i;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+
+	/*
+	 * Go up the tree, starting at leaf level.
+	 *
+	 * If 2 is returned then a join was done; go to the next level.
+	 * Otherwise we are done.
+	 */
+	for (level = 0, i = 2; i == 2; level++) {
+		error = xfs_btree_delrec(cur, level, &i);
+		if (error)
+			goto error0;
+	}
+
+	if (i == 0) {
+		for (level = 1; level < cur->bc_nlevels; level++) {
+			if (cur->bc_ptrs[level] == 0) {
+				error = xfs_btree_decrement(cur, level, &i);
+				if (error)
+					goto error0;
+				break;
+			}
+		}
+	}
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = i;
+	return 0;
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-08-04 01:18:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-08-04 01:18:45.000000000 +0200
@@ -40,638 +40,6 @@
 #include "xfs_alloc.h"
 #include "xfs_error.h"
 
-/*
- * Prototypes for internal functions.
- */
-
-STATIC void xfs_alloc_log_block(xfs_trans_t *, xfs_buf_t *, int);
-STATIC void xfs_allocbt_log_keys(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-#define xfs_alloc_log_keys(c, b, i, j) \
-	xfs_allocbt_log_keys(c, b, i, j)
-STATIC void xfs_alloc_log_ptrs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-STATIC void xfs_allocbt_log_recs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-#define xfs_alloc_log_recs(c, b, i, j) \
-	xfs_allocbt_log_recs(c, b, i, j)
-
-/*
- * Internal functions.
- */
-
-/*
- * Single level of the xfs_alloc_delete record deletion routine.
- * Delete record pointed to by cur/level.
- * Remove the record from its block then rebalance the tree.
- * Return 0 for error, 1 for done, 2 to go on to the next level.
- */
-STATIC int				/* error */
-xfs_alloc_delrec(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level removing record from */
-	int			*stat)	/* fail/done/go-on */
-{
-	xfs_agf_t		*agf;	/* allocation group freelist header */
-	xfs_alloc_block_t	*block;	/* btree block record/key lives in */
-	xfs_agblock_t		bno;	/* btree block number */
-	xfs_buf_t		*bp;	/* buffer for block */
-	int			error;	/* error return value */
-	int			i;	/* loop index */
-	xfs_alloc_key_t		key;	/* kp points here if block is level 0 */
-	xfs_agblock_t		lbno;	/* left block's block number */
-	xfs_buf_t		*lbp;	/* left block's buffer pointer */
-	xfs_alloc_block_t	*left;	/* left btree block */
-	xfs_alloc_key_t		*lkp=NULL;	/* left block key pointer */
-	xfs_alloc_ptr_t		*lpp=NULL;	/* left block address pointer */
-	int			lrecs=0;	/* number of records in left block */
-	xfs_alloc_rec_t		*lrp;	/* left block record pointer */
-	xfs_mount_t		*mp;	/* mount structure */
-	int			ptr;	/* index in btree block for this rec */
-	xfs_agblock_t		rbno;	/* right block's block number */
-	xfs_buf_t		*rbp;	/* right block's buffer pointer */
-	xfs_alloc_block_t	*right;	/* right btree block */
-	xfs_alloc_key_t		*rkp;	/* right block key pointer */
-	xfs_alloc_ptr_t		*rpp;	/* right block address pointer */
-	int			rrecs=0;	/* number of records in right block */
-	int			numrecs;
-	xfs_alloc_rec_t		*rrp;	/* right block record pointer */
-	xfs_btree_cur_t		*tcur;	/* temporary btree cursor */
-
-	/*
-	 * Get the index of the entry being deleted, check for nothing there.
-	 */
-	ptr = cur->bc_ptrs[level];
-	if (ptr == 0) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * Get the buffer & block containing the record or key/ptr.
-	 */
-	bp = cur->bc_bufs[level];
-	block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, level, bp)))
-		return error;
-#endif
-	/*
-	 * Fail if we're off the end of the block.
-	 */
-	numrecs = be16_to_cpu(block->bb_numrecs);
-	if (ptr > numrecs) {
-		*stat = 0;
-		return 0;
-	}
-	XFS_STATS_INC(xs_abt_delrec);
-	/*
-	 * It's a nonleaf.  Excise the key and ptr being deleted, by
-	 * sliding the entries past them down one.
-	 * Log the changed areas of the block.
-	 */
-	if (level > 0) {
-		lkp = XFS_ALLOC_KEY_ADDR(block, 1, cur);
-		lpp = XFS_ALLOC_PTR_ADDR(block, 1, cur);
-#ifdef DEBUG
-		for (i = ptr; i < numrecs; i++) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(lpp[i]), level)))
-				return error;
-		}
-#endif
-		if (ptr < numrecs) {
-			memmove(&lkp[ptr - 1], &lkp[ptr],
-				(numrecs - ptr) * sizeof(*lkp));
-			memmove(&lpp[ptr - 1], &lpp[ptr],
-				(numrecs - ptr) * sizeof(*lpp));
-			xfs_alloc_log_ptrs(cur, bp, ptr, numrecs - 1);
-			xfs_alloc_log_keys(cur, bp, ptr, numrecs - 1);
-		}
-	}
-	/*
-	 * It's a leaf.  Excise the record being deleted, by sliding the
-	 * entries past it down one.  Log the changed areas of the block.
-	 */
-	else {
-		lrp = XFS_ALLOC_REC_ADDR(block, 1, cur);
-		if (ptr < numrecs) {
-			memmove(&lrp[ptr - 1], &lrp[ptr],
-				(numrecs - ptr) * sizeof(*lrp));
-			xfs_alloc_log_recs(cur, bp, ptr, numrecs - 1);
-		}
-		/*
-		 * If it's the first record in the block, we'll need a key
-		 * structure to pass up to the next level (updkey).
-		 */
-		if (ptr == 1) {
-			key.ar_startblock = lrp->ar_startblock;
-			key.ar_blockcount = lrp->ar_blockcount;
-			lkp = &key;
-		}
-	}
-	/*
-	 * Decrement and log the number of entries in the block.
-	 */
-	numrecs--;
-	block->bb_numrecs = cpu_to_be16(numrecs);
-	xfs_alloc_log_block(cur->bc_tp, bp, XFS_BB_NUMRECS);
-	/*
-	 * See if the longest free extent in the allocation group was
-	 * changed by this operation.  True if it's the by-size btree, and
-	 * this is the leaf level, and there is no right sibling block,
-	 * and this was the last record.
-	 */
-	agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
-	mp = cur->bc_mp;
-
-	if (level == 0 &&
-	    cur->bc_btnum == XFS_BTNUM_CNT &&
-	    be32_to_cpu(block->bb_rightsib) == NULLAGBLOCK &&
-	    ptr > numrecs) {
-		ASSERT(ptr == numrecs + 1);
-		/*
-		 * There are still records in the block.  Grab the size
-		 * from the last one.
-		 */
-		if (numrecs) {
-			rrp = XFS_ALLOC_REC_ADDR(block, numrecs, cur);
-			agf->agf_longest = rrp->ar_blockcount;
-		}
-		/*
-		 * No free extents left.
-		 */
-		else
-			agf->agf_longest = 0;
-		mp->m_perag[be32_to_cpu(agf->agf_seqno)].pagf_longest =
-			be32_to_cpu(agf->agf_longest);
-		xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp,
-			XFS_AGF_LONGEST);
-	}
-	/*
-	 * Is this the root level?  If so, we're almost done.
-	 */
-	if (level == cur->bc_nlevels - 1) {
-		/*
-		 * If this is the root level,
-		 * and there's only one entry left,
-		 * and it's NOT the leaf level,
-		 * then we can get rid of this level.
-		 */
-		if (numrecs == 1 && level > 0) {
-			/*
-			 * lpp is still set to the first pointer in the block.
-			 * Make it the new root of the btree.
-			 */
-			bno = be32_to_cpu(agf->agf_roots[cur->bc_btnum]);
-			agf->agf_roots[cur->bc_btnum] = *lpp;
-			be32_add(&agf->agf_levels[cur->bc_btnum], -1);
-			mp->m_perag[be32_to_cpu(agf->agf_seqno)].pagf_levels[cur->bc_btnum]--;
-			/*
-			 * Put this buffer/block on the ag's freelist.
-			 */
-			error = xfs_alloc_put_freelist(cur->bc_tp,
-					cur->bc_private.a.agbp, NULL, bno, 1);
-			if (error)
-				return error;
-			/*
-			 * Since blocks move to the free list without the
-			 * coordination used in xfs_bmap_finish, we can't allow
-			 * block to be available for reallocation and
-			 * non-transaction writing (user data) until we know
-			 * that the transaction that moved it to the free list
-			 * is permanently on disk. We track the blocks by
-			 * declaring these blocks as "busy"; the busy list is
-			 * maintained on a per-ag basis and each transaction
-			 * records which entries should be removed when the
-			 * iclog commits to disk. If a busy block is
-			 * allocated, the iclog is pushed up to the LSN
-			 * that freed the block.
-			 */
-			xfs_alloc_mark_busy(cur->bc_tp,
-				be32_to_cpu(agf->agf_seqno), bno, 1);
-
-			xfs_trans_agbtree_delta(cur->bc_tp, -1);
-			xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp,
-				XFS_AGF_ROOTS | XFS_AGF_LEVELS);
-			/*
-			 * Update the cursor so there's one fewer level.
-			 */
-			xfs_btree_setbuf(cur, level, NULL);
-			cur->bc_nlevels--;
-		} else if (level > 0 &&
-			   (error = xfs_btree_decrement(cur, level, &i)))
-			return error;
-		*stat = 1;
-		return 0;
-	}
-	/*
-	 * If we deleted the leftmost entry in the block, update the
-	 * key values above us in the tree.
-	 */
-	if (ptr == 1 && (error = xfs_btree_updkey(cur, (union xfs_btree_key *)lkp, level + 1)))
-		return error;
-	/*
-	 * If the number of records remaining in the block is at least
-	 * the minimum, we're done.
-	 */
-	if (numrecs >= XFS_ALLOC_BLOCK_MINRECS(level, cur)) {
-		if (level > 0 && (error = xfs_btree_decrement(cur, level, &i)))
-			return error;
-		*stat = 1;
-		return 0;
-	}
-	/*
-	 * Otherwise, we have to move some records around to keep the
-	 * tree balanced.  Look at the left and right sibling blocks to
-	 * see if we can re-balance by moving only one record.
-	 */
-	rbno = be32_to_cpu(block->bb_rightsib);
-	lbno = be32_to_cpu(block->bb_leftsib);
-	bno = NULLAGBLOCK;
-	ASSERT(rbno != NULLAGBLOCK || lbno != NULLAGBLOCK);
-	/*
-	 * Duplicate the cursor so our btree manipulations here won't
-	 * disrupt the next level up.
-	 */
-	if ((error = xfs_btree_dup_cursor(cur, &tcur)))
-		return error;
-	/*
-	 * If there's a right sibling, see if it's ok to shift an entry
-	 * out of it.
-	 */
-	if (rbno != NULLAGBLOCK) {
-		/*
-		 * Move the temp cursor to the last entry in the next block.
-		 * Actually any entry but the first would suffice.
-		 */
-		i = xfs_btree_lastrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_btree_increment(tcur, level, &i)))
-			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		i = xfs_btree_lastrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		/*
-		 * Grab a pointer to the block.
-		 */
-		rbp = tcur->bc_bufs[level];
-		right = XFS_BUF_TO_ALLOC_BLOCK(rbp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sblock(cur, right, level, rbp)))
-			goto error0;
-#endif
-		/*
-		 * Grab the current block number, for future use.
-		 */
-		bno = be32_to_cpu(right->bb_leftsib);
-		/*
-		 * If right block is full enough so that removing one entry
-		 * won't make it too empty, and left-shifting an entry out
-		 * of right to us works, we're done.
-		 */
-		if (be16_to_cpu(right->bb_numrecs) - 1 >=
-		     XFS_ALLOC_BLOCK_MINRECS(level, cur)) {
-			if ((error = xfs_btree_lshift(tcur, level, &i)))
-				goto error0;
-			if (i) {
-				ASSERT(be16_to_cpu(block->bb_numrecs) >=
-				       XFS_ALLOC_BLOCK_MINRECS(level, cur));
-				xfs_btree_del_cursor(tcur,
-						     XFS_BTREE_NOERROR);
-				if (level > 0 &&
-				    (error = xfs_btree_decrement(cur, level,
-					    &i)))
-					return error;
-				*stat = 1;
-				return 0;
-			}
-		}
-		/*
-		 * Otherwise, grab the number of records in right for
-		 * future reference, and fix up the temp cursor to point
-		 * to our block again (last record).
-		 */
-		rrecs = be16_to_cpu(right->bb_numrecs);
-		if (lbno != NULLAGBLOCK) {
-			i = xfs_btree_firstrec(tcur, level);
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-			if ((error = xfs_btree_decrement(tcur, level, &i)))
-				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		}
-	}
-	/*
-	 * If there's a left sibling, see if it's ok to shift an entry
-	 * out of it.
-	 */
-	if (lbno != NULLAGBLOCK) {
-		/*
-		 * Move the temp cursor to the first entry in the
-		 * previous block.
-		 */
-		i = xfs_btree_firstrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_btree_decrement(tcur, level, &i)))
-			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		xfs_btree_firstrec(tcur, level);
-		/*
-		 * Grab a pointer to the block.
-		 */
-		lbp = tcur->bc_bufs[level];
-		left = XFS_BUF_TO_ALLOC_BLOCK(lbp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
-			goto error0;
-#endif
-		/*
-		 * Grab the current block number, for future use.
-		 */
-		bno = be32_to_cpu(left->bb_rightsib);
-		/*
-		 * If left block is full enough so that removing one entry
-		 * won't make it too empty, and right-shifting an entry out
-		 * of left to us works, we're done.
-		 */
-		if (be16_to_cpu(left->bb_numrecs) - 1 >=
-		     XFS_ALLOC_BLOCK_MINRECS(level, cur)) {
-			if ((error = xfs_btree_rshift(tcur, level, &i)))
-				goto error0;
-			if (i) {
-				ASSERT(be16_to_cpu(block->bb_numrecs) >=
-				       XFS_ALLOC_BLOCK_MINRECS(level, cur));
-				xfs_btree_del_cursor(tcur,
-						     XFS_BTREE_NOERROR);
-				if (level == 0)
-					cur->bc_ptrs[0]++;
-				*stat = 1;
-				return 0;
-			}
-		}
-		/*
-		 * Otherwise, grab the number of records in right for
-		 * future reference.
-		 */
-		lrecs = be16_to_cpu(left->bb_numrecs);
-	}
-	/*
-	 * Delete the temp cursor, we're done with it.
-	 */
-	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
-	/*
-	 * If here, we need to do a join to keep the tree balanced.
-	 */
-	ASSERT(bno != NULLAGBLOCK);
-	/*
-	 * See if we can join with the left neighbor block.
-	 */
-	if (lbno != NULLAGBLOCK &&
-	    lrecs + numrecs <= XFS_ALLOC_BLOCK_MAXRECS(level, cur)) {
-		/*
-		 * Set "right" to be the starting block,
-		 * "left" to be the left neighbor.
-		 */
-		rbno = bno;
-		right = block;
-		rrecs = be16_to_cpu(right->bb_numrecs);
-		rbp = bp;
-		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
-				cur->bc_private.a.agno, lbno, 0, &lbp,
-				XFS_ALLOC_BTREE_REF)))
-			return error;
-		left = XFS_BUF_TO_ALLOC_BLOCK(lbp);
-		lrecs = be16_to_cpu(left->bb_numrecs);
-		if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
-			return error;
-	}
-	/*
-	 * If that won't work, see if we can join with the right neighbor block.
-	 */
-	else if (rbno != NULLAGBLOCK &&
-		 rrecs + numrecs <= XFS_ALLOC_BLOCK_MAXRECS(level, cur)) {
-		/*
-		 * Set "left" to be the starting block,
-		 * "right" to be the right neighbor.
-		 */
-		lbno = bno;
-		left = block;
-		lrecs = be16_to_cpu(left->bb_numrecs);
-		lbp = bp;
-		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
-				cur->bc_private.a.agno, rbno, 0, &rbp,
-				XFS_ALLOC_BTREE_REF)))
-			return error;
-		right = XFS_BUF_TO_ALLOC_BLOCK(rbp);
-		rrecs = be16_to_cpu(right->bb_numrecs);
-		if ((error = xfs_btree_check_sblock(cur, right, level, rbp)))
-			return error;
-	}
-	/*
-	 * Otherwise, we can't fix the imbalance.
-	 * Just return.  This is probably a logic error, but it's not fatal.
-	 */
-	else {
-		if (level > 0 && (error = xfs_btree_decrement(cur, level, &i)))
-			return error;
-		*stat = 1;
-		return 0;
-	}
-	/*
-	 * We're now going to join "left" and "right" by moving all the stuff
-	 * in "right" to "left" and deleting "right".
-	 */
-	if (level > 0) {
-		/*
-		 * It's a non-leaf.  Move keys and pointers.
-		 */
-		lkp = XFS_ALLOC_KEY_ADDR(left, lrecs + 1, cur);
-		lpp = XFS_ALLOC_PTR_ADDR(left, lrecs + 1, cur);
-		rkp = XFS_ALLOC_KEY_ADDR(right, 1, cur);
-		rpp = XFS_ALLOC_PTR_ADDR(right, 1, cur);
-#ifdef DEBUG
-		for (i = 0; i < rrecs; i++) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(rpp[i]), level)))
-				return error;
-		}
-#endif
-		memcpy(lkp, rkp, rrecs * sizeof(*lkp));
-		memcpy(lpp, rpp, rrecs * sizeof(*lpp));
-		xfs_alloc_log_keys(cur, lbp, lrecs + 1, lrecs + rrecs);
-		xfs_alloc_log_ptrs(cur, lbp, lrecs + 1, lrecs + rrecs);
-	} else {
-		/*
-		 * It's a leaf.  Move records.
-		 */
-		lrp = XFS_ALLOC_REC_ADDR(left, lrecs + 1, cur);
-		rrp = XFS_ALLOC_REC_ADDR(right, 1, cur);
-		memcpy(lrp, rrp, rrecs * sizeof(*lrp));
-		xfs_alloc_log_recs(cur, lbp, lrecs + 1, lrecs + rrecs);
-	}
-	/*
-	 * If we joined with the left neighbor, set the buffer in the
-	 * cursor to the left block, and fix up the index.
-	 */
-	if (bp != lbp) {
-		xfs_btree_setbuf(cur, level, lbp);
-		cur->bc_ptrs[level] += lrecs;
-	}
-	/*
-	 * If we joined with the right neighbor and there's a level above
-	 * us, increment the cursor at that level.
-	 */
-	else if (level + 1 < cur->bc_nlevels &&
-		 (error = xfs_btree_increment(cur, level + 1, &i)))
-		return error;
-	/*
-	 * Fix up the number of records in the surviving block.
-	 */
-	lrecs += rrecs;
-	left->bb_numrecs = cpu_to_be16(lrecs);
-	/*
-	 * Fix up the right block pointer in the surviving block, and log it.
-	 */
-	left->bb_rightsib = right->bb_rightsib;
-	xfs_alloc_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
-	/*
-	 * If there is a right sibling now, make it point to the
-	 * remaining block.
-	 */
-	if (be32_to_cpu(left->bb_rightsib) != NULLAGBLOCK) {
-		xfs_alloc_block_t	*rrblock;
-		xfs_buf_t		*rrbp;
-
-		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
-				cur->bc_private.a.agno, be32_to_cpu(left->bb_rightsib), 0,
-				&rrbp, XFS_ALLOC_BTREE_REF)))
-			return error;
-		rrblock = XFS_BUF_TO_ALLOC_BLOCK(rrbp);
-		if ((error = xfs_btree_check_sblock(cur, rrblock, level, rrbp)))
-			return error;
-		rrblock->bb_leftsib = cpu_to_be32(lbno);
-		xfs_alloc_log_block(cur->bc_tp, rrbp, XFS_BB_LEFTSIB);
-	}
-	/*
-	 * Free the deleting block by putting it on the freelist.
-	 */
-	error = xfs_alloc_put_freelist(cur->bc_tp,
-					 cur->bc_private.a.agbp, NULL, rbno, 1);
-	if (error)
-		return error;
-	/*
-	 * Since blocks move to the free list without the coordination
-	 * used in xfs_bmap_finish, we can't allow block to be available
-	 * for reallocation and non-transaction writing (user data)
-	 * until we know that the transaction that moved it to the free
-	 * list is permanently on disk. We track the blocks by declaring
-	 * these blocks as "busy"; the busy list is maintained on a
-	 * per-ag basis and each transaction records which entries
-	 * should be removed when the iclog commits to disk. If a
-	 * busy block is allocated, the iclog is pushed up to the
-	 * LSN that freed the block.
-	 */
-	xfs_alloc_mark_busy(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1);
-	xfs_trans_agbtree_delta(cur->bc_tp, -1);
-
-	/*
-	 * Adjust the current level's cursor so that we're left referring
-	 * to the right node, after we're done.
-	 * If this leaves the ptr value 0 our caller will fix it up.
-	 */
-	if (level > 0)
-		cur->bc_ptrs[level]--;
-	/*
-	 * Return value means the next level up has something to do.
-	 */
-	*stat = 2;
-	return 0;
-
-error0:
-	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
-	return error;
-}
-
-/*
- * Log header fields from a btree block.
- */
-STATIC void
-xfs_alloc_log_block(
-	xfs_trans_t		*tp,	/* transaction pointer */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			fields)	/* mask of fields: XFS_BB_... */
-{
-	int			first;	/* first byte offset logged */
-	int			last;	/* last byte offset logged */
-	static const short	offsets[] = {	/* table of offsets */
-		offsetof(xfs_alloc_block_t, bb_magic),
-		offsetof(xfs_alloc_block_t, bb_level),
-		offsetof(xfs_alloc_block_t, bb_numrecs),
-		offsetof(xfs_alloc_block_t, bb_leftsib),
-		offsetof(xfs_alloc_block_t, bb_rightsib),
-		sizeof(xfs_alloc_block_t)
-	};
-
-	xfs_btree_offsets(fields, offsets, XFS_BB_NUM_BITS, &first, &last);
-	xfs_trans_log_buf(tp, bp, first, last);
-}
-
-/*
- * Log block pointer fields from a btree block (nonleaf).
- */
-STATIC void
-xfs_alloc_log_ptrs(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			pfirst,	/* index of first pointer to log */
-	int			plast)	/* index of last pointer to log */
-{
-	xfs_alloc_block_t	*block;	/* btree block to log from */
-	int			first;	/* first byte offset logged */
-	int			last;	/* last byte offset logged */
-	xfs_alloc_ptr_t		*pp;	/* block-pointer pointer in btree blk */
-
-	block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-	pp = XFS_ALLOC_PTR_ADDR(block, 1, cur);
-	first = (int)((xfs_caddr_t)&pp[pfirst - 1] - (xfs_caddr_t)block);
-	last = (int)(((xfs_caddr_t)&pp[plast] - 1) - (xfs_caddr_t)block);
-	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
-}
-
-
-/*
- * Externally visible routines.
- */
-
-/*
- * Delete the record pointed to by cur.
- * The cursor refers to the place where the record was (could be inserted)
- * when the operation returns.
- */
-int					/* error */
-xfs_alloc_delete(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	int		*stat)		/* success/failure */
-{
-	int		error;		/* error return value */
-	int		i;		/* result code */
-	int		level;		/* btree level */
-
-	/*
-	 * Go up the tree, starting at leaf level.
-	 * If 2 is returned then a join was done; go to the next level.
-	 * Otherwise we are done.
-	 */
-	for (level = 0, i = 2; i == 2; level++) {
-		if ((error = xfs_alloc_delrec(cur, level, &i)))
-			return error;
-	}
-	if (i == 0) {
-		for (level = 1; level < cur->bc_nlevels; level++) {
-			if (cur->bc_ptrs[level] == 0) {
-				if ((error = xfs_btree_decrement(cur, level, &i)))
-					return error;
-				break;
-			}
-		}
-	}
-	*stat = i;
-	return 0;
-}
 
 /*
  * Get the data from the pointed-to record.
@@ -828,6 +196,7 @@ xfs_allocbt_update_lastrec(
 	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
 	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	__be32			len;
+	int			numrecs;
 
 	ASSERT(cur->bc_btnum == XFS_BTNUM_CNT);
 
@@ -847,6 +216,22 @@ xfs_allocbt_update_lastrec(
 			return;
 		len = rec->alloc.ar_blockcount;
 		break;
+	case LASTREC_DELREC:
+		numrecs = xfs_btree_get_numrecs(block);
+		if (ptr <= numrecs)
+			return;
+		ASSERT(ptr == numrecs + 1);
+
+		if (numrecs) {
+			xfs_alloc_rec_t *rrp;
+
+			rrp = XFS_ALLOC_REC_ADDR(block, numrecs, cur);
+			len = rrp->ar_blockcount;
+		} else {
+			len = 0;
+		}
+
+		break;
 	default:
 		ASSERT(0);
 		return;
@@ -858,6 +243,14 @@ xfs_allocbt_update_lastrec(
 }
 
 STATIC int
+xfs_allocbt_get_minrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_alloc_mnr[level != 0];
+}
+
+STATIC int
 xfs_allocbt_get_maxrecs(
 	struct xfs_btree_cur	*cur,
 	int			level)
@@ -1091,7 +484,7 @@ xfs_alloc_log_recs_check(
  * Log records from a btree block (leaf).
  */
 STATIC void
-xfs_alloc_log_recs(
+xfs_allocbt_log_recs(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	struct xfs_buf		*bp,	/* buffer containing btree block */
 	int			first,	/* index of first record to log */
@@ -1188,6 +581,7 @@ static const struct xfs_btree_ops xfs_al
 	.alloc_block		= xfs_allocbt_alloc_block,
 	.free_block		= xfs_allocbt_free_block,
 	.update_lastrec		= xfs_allocbt_update_lastrec,
+	.get_minrecs		= xfs_allocbt_get_minrecs,
 	.get_maxrecs		= xfs_allocbt_get_maxrecs,
 	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-08-04 01:18:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-08-04 01:19:05.000000000 +0200
@@ -44,14 +44,6 @@
 #include "xfs_error.h"
 #include "xfs_quota.h"
 
-/*
- * Prototypes for internal btree functions.
- */
-
-
-STATIC void xfs_bmbt_log_keys(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-STATIC void xfs_bmbt_log_ptrs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-
 #undef EXIT
 
 #define ENTRY	XBT_ENTRY
@@ -82,416 +74,6 @@ STATIC void xfs_bmbt_log_ptrs(xfs_btree_
 
 
 /*
- * Internal functions.
- */
-
-/*
- * Delete record pointed to by cur/level.
- */
-STATIC int					/* error */
-xfs_bmbt_delrec(
-	xfs_btree_cur_t		*cur,
-	int			level,
-	int			*stat)		/* success/failure */
-{
-	xfs_bmbt_block_t	*block;		/* bmap btree block */
-	xfs_fsblock_t		bno;		/* fs-relative block number */
-	xfs_buf_t		*bp;		/* buffer for block */
-	int			error;		/* error return value */
-	int			i;		/* loop counter */
-	int			j;		/* temp state */
-	xfs_bmbt_key_t		key;		/* bmap btree key */
-	xfs_bmbt_key_t		*kp=NULL;	/* pointer to bmap btree key */
-	xfs_fsblock_t		lbno;		/* left sibling block number */
-	xfs_buf_t		*lbp;		/* left buffer pointer */
-	xfs_bmbt_block_t	*left;		/* left btree block */
-	xfs_bmbt_key_t		*lkp;		/* left btree key */
-	xfs_bmbt_ptr_t		*lpp;		/* left address pointer */
-	int			lrecs=0;	/* left record count */
-	xfs_bmbt_rec_t		*lrp;		/* left record pointer */
-	xfs_mount_t		*mp;		/* file system mount point */
-	xfs_bmbt_ptr_t		*pp;		/* pointer to bmap block addr */
-	int			ptr;		/* key/record index */
-	xfs_fsblock_t		rbno;		/* right sibling block number */
-	xfs_buf_t		*rbp;		/* right buffer pointer */
-	xfs_bmbt_block_t	*right;		/* right btree block */
-	xfs_bmbt_key_t		*rkp;		/* right btree key */
-	xfs_bmbt_rec_t		*rp;		/* pointer to bmap btree rec */
-	xfs_bmbt_ptr_t		*rpp;		/* right address pointer */
-	xfs_bmbt_block_t	*rrblock;	/* right-right btree block */
-	xfs_buf_t		*rrbp;		/* right-right buffer pointer */
-	int			rrecs=0;	/* right record count */
-	xfs_bmbt_rec_t		*rrp;		/* right record pointer */
-	xfs_btree_cur_t		*tcur;		/* temporary btree cursor */
-	int			numrecs;	/* temporary numrec count */
-	int			numlrecs, numrrecs;
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGI(cur, level);
-	ptr = cur->bc_ptrs[level];
-	tcur = NULL;
-	if (ptr == 0) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	block = xfs_bmbt_get_block(cur, level, &bp);
-	numrecs = be16_to_cpu(block->bb_numrecs);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_lblock(cur, block, level, bp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		goto error0;
-	}
-#endif
-	if (ptr > numrecs) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	XFS_STATS_INC(xs_bmbt_delrec);
-	if (level > 0) {
-		kp = XFS_BMAP_KEY_IADDR(block, 1, cur);
-		pp = XFS_BMAP_PTR_IADDR(block, 1, cur);
-#ifdef DEBUG
-		for (i = ptr; i < numrecs; i++) {
-			if ((error = xfs_btree_check_lptr_disk(cur, pp[i], level))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				goto error0;
-			}
-		}
-#endif
-		if (ptr < numrecs) {
-			memmove(&kp[ptr - 1], &kp[ptr],
-				(numrecs - ptr) * sizeof(*kp));
-			memmove(&pp[ptr - 1], &pp[ptr],
-				(numrecs - ptr) * sizeof(*pp));
-			xfs_bmbt_log_ptrs(cur, bp, ptr, numrecs - 1);
-			xfs_bmbt_log_keys(cur, bp, ptr, numrecs - 1);
-		}
-	} else {
-		rp = XFS_BMAP_REC_IADDR(block, 1, cur);
-		if (ptr < numrecs) {
-			memmove(&rp[ptr - 1], &rp[ptr],
-				(numrecs - ptr) * sizeof(*rp));
-			xfs_bmbt_log_recs(cur, bp, ptr, numrecs - 1);
-		}
-		if (ptr == 1) {
-			key.br_startoff =
-				cpu_to_be64(xfs_bmbt_disk_get_startoff(rp));
-			kp = &key;
-		}
-	}
-	numrecs--;
-	block->bb_numrecs = cpu_to_be16(numrecs);
-	xfs_bmbt_log_block(cur, bp, XFS_BB_NUMRECS);
-	/*
-	 * We're at the root level.
-	 * First, shrink the root block in-memory.
-	 * Try to get rid of the next level down.
-	 * If we can't then there's nothing left to do.
-	 */
-	if (level == cur->bc_nlevels - 1) {
-		xfs_iroot_realloc(cur->bc_private.b.ip, -1,
-			cur->bc_private.b.whichfork);
-		if ((error = xfs_btree_root_to_iroot(cur))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		if (level > 0 && (error = xfs_btree_decrement(cur, level, &j))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 1;
-		return 0;
-	}
-	if (ptr == 1 && (error = xfs_btree_updkey(cur, (union xfs_btree_key *)kp, level + 1))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		goto error0;
-	}
-	if (numrecs >= XFS_BMAP_BLOCK_IMINRECS(level, cur)) {
-		if (level > 0 && (error = xfs_btree_decrement(cur, level, &j))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 1;
-		return 0;
-	}
-	rbno = be64_to_cpu(block->bb_rightsib);
-	lbno = be64_to_cpu(block->bb_leftsib);
-	/*
-	 * One child of root, need to get a chance to copy its contents
-	 * into the root and delete it. Can't go up to next level,
-	 * there's nothing to delete there.
-	 */
-	if (lbno == NULLFSBLOCK && rbno == NULLFSBLOCK &&
-	    level == cur->bc_nlevels - 2) {
-		if ((error = xfs_btree_root_to_iroot(cur))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		if (level > 0 && (error = xfs_btree_decrement(cur, level, &i))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 1;
-		return 0;
-	}
-	ASSERT(rbno != NULLFSBLOCK || lbno != NULLFSBLOCK);
-	if ((error = xfs_btree_dup_cursor(cur, &tcur))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		goto error0;
-	}
-	bno = NULLFSBLOCK;
-	if (rbno != NULLFSBLOCK) {
-		i = xfs_btree_lastrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_btree_increment(tcur, level, &i))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		i = xfs_btree_lastrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		rbp = tcur->bc_bufs[level];
-		right = XFS_BUF_TO_BMBT_BLOCK(rbp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_lblock(cur, right, level, rbp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-#endif
-		bno = be64_to_cpu(right->bb_leftsib);
-		if (be16_to_cpu(right->bb_numrecs) - 1 >=
-		    XFS_BMAP_BLOCK_IMINRECS(level, cur)) {
-			if ((error = xfs_btree_lshift(tcur, level, &i))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				goto error0;
-			}
-			if (i) {
-				ASSERT(be16_to_cpu(block->bb_numrecs) >=
-				       XFS_BMAP_BLOCK_IMINRECS(level, tcur));
-				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
-				tcur = NULL;
-				if (level > 0) {
-					if ((error = xfs_btree_decrement(cur,
-							level, &i))) {
-						XFS_BMBT_TRACE_CURSOR(cur,
-							ERROR);
-						goto error0;
-					}
-				}
-				XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-				*stat = 1;
-				return 0;
-			}
-		}
-		rrecs = be16_to_cpu(right->bb_numrecs);
-		if (lbno != NULLFSBLOCK) {
-			i = xfs_btree_firstrec(tcur, level);
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-			if ((error = xfs_btree_decrement(tcur, level, &i))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				goto error0;
-			}
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		}
-	}
-	if (lbno != NULLFSBLOCK) {
-		i = xfs_btree_firstrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		/*
-		 * decrement to last in block
-		 */
-		if ((error = xfs_btree_decrement(tcur, level, &i))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		i = xfs_btree_firstrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		lbp = tcur->bc_bufs[level];
-		left = XFS_BUF_TO_BMBT_BLOCK(lbp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_lblock(cur, left, level, lbp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-#endif
-		bno = be64_to_cpu(left->bb_rightsib);
-		if (be16_to_cpu(left->bb_numrecs) - 1 >=
-		    XFS_BMAP_BLOCK_IMINRECS(level, cur)) {
-			if ((error = xfs_btree_rshift(tcur, level, &i))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				goto error0;
-			}
-			if (i) {
-				ASSERT(be16_to_cpu(block->bb_numrecs) >=
-				       XFS_BMAP_BLOCK_IMINRECS(level, tcur));
-				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
-				tcur = NULL;
-				if (level == 0)
-					cur->bc_ptrs[0]++;
-				XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-				*stat = 1;
-				return 0;
-			}
-		}
-		lrecs = be16_to_cpu(left->bb_numrecs);
-	}
-	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
-	tcur = NULL;
-	mp = cur->bc_mp;
-	ASSERT(bno != NULLFSBLOCK);
-	if (lbno != NULLFSBLOCK &&
-	    lrecs + be16_to_cpu(block->bb_numrecs) <= XFS_BMAP_BLOCK_IMAXRECS(level, cur)) {
-		rbno = bno;
-		right = block;
-		rbp = bp;
-		if ((error = xfs_btree_read_bufl(mp, cur->bc_tp, lbno, 0, &lbp,
-				XFS_BMAP_BTREE_REF))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		left = XFS_BUF_TO_BMBT_BLOCK(lbp);
-		if ((error = xfs_btree_check_lblock(cur, left, level, lbp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-	} else if (rbno != NULLFSBLOCK &&
-		   rrecs + be16_to_cpu(block->bb_numrecs) <=
-		   XFS_BMAP_BLOCK_IMAXRECS(level, cur)) {
-		lbno = bno;
-		left = block;
-		lbp = bp;
-		if ((error = xfs_btree_read_bufl(mp, cur->bc_tp, rbno, 0, &rbp,
-				XFS_BMAP_BTREE_REF))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		right = XFS_BUF_TO_BMBT_BLOCK(rbp);
-		if ((error = xfs_btree_check_lblock(cur, right, level, rbp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		lrecs = be16_to_cpu(left->bb_numrecs);
-	} else {
-		if (level > 0 && (error = xfs_btree_decrement(cur, level, &i))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 1;
-		return 0;
-	}
-	numlrecs = be16_to_cpu(left->bb_numrecs);
-	numrrecs = be16_to_cpu(right->bb_numrecs);
-	if (level > 0) {
-		lkp = XFS_BMAP_KEY_IADDR(left, numlrecs + 1, cur);
-		lpp = XFS_BMAP_PTR_IADDR(left, numlrecs + 1, cur);
-		rkp = XFS_BMAP_KEY_IADDR(right, 1, cur);
-		rpp = XFS_BMAP_PTR_IADDR(right, 1, cur);
-#ifdef DEBUG
-		for (i = 0; i < numrrecs; i++) {
-			if ((error = xfs_btree_check_lptr_disk(cur, rpp[i], level))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				goto error0;
-			}
-		}
-#endif
-		memcpy(lkp, rkp, numrrecs * sizeof(*lkp));
-		memcpy(lpp, rpp, numrrecs * sizeof(*lpp));
-		xfs_bmbt_log_keys(cur, lbp, numlrecs + 1, numlrecs + numrrecs);
-		xfs_bmbt_log_ptrs(cur, lbp, numlrecs + 1, numlrecs + numrrecs);
-	} else {
-		lrp = XFS_BMAP_REC_IADDR(left, numlrecs + 1, cur);
-		rrp = XFS_BMAP_REC_IADDR(right, 1, cur);
-		memcpy(lrp, rrp, numrrecs * sizeof(*lrp));
-		xfs_bmbt_log_recs(cur, lbp, numlrecs + 1, numlrecs + numrrecs);
-	}
-	be16_add(&left->bb_numrecs, numrrecs);
-	left->bb_rightsib = right->bb_rightsib;
-	xfs_bmbt_log_block(cur, lbp, XFS_BB_RIGHTSIB | XFS_BB_NUMRECS);
-	if (be64_to_cpu(left->bb_rightsib) != NULLDFSBNO) {
-		if ((error = xfs_btree_read_bufl(mp, cur->bc_tp,
-				be64_to_cpu(left->bb_rightsib),
-				0, &rrbp, XFS_BMAP_BTREE_REF))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		rrblock = XFS_BUF_TO_BMBT_BLOCK(rrbp);
-		if ((error = xfs_btree_check_lblock(cur, rrblock, level, rrbp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		rrblock->bb_leftsib = cpu_to_be64(lbno);
-		xfs_bmbt_log_block(cur, rrbp, XFS_BB_LEFTSIB);
-	}
-	xfs_bmap_add_free(XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(rbp)), 1,
-		cur->bc_private.b.flist, mp);
-	cur->bc_private.b.ip->i_d.di_nblocks--;
-	xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip, XFS_ILOG_CORE);
-	XFS_TRANS_MOD_DQUOT_BYINO(mp, cur->bc_tp, cur->bc_private.b.ip,
-			XFS_TRANS_DQ_BCOUNT, -1L);
-	xfs_trans_binval(cur->bc_tp, rbp);
-	if (bp != lbp) {
-		cur->bc_bufs[level] = lbp;
-		cur->bc_ptrs[level] += lrecs;
-		cur->bc_ra[level] = 0;
-	} else if ((error = xfs_btree_increment(cur, level + 1, &i))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		goto error0;
-	}
-	if (level > 0)
-		cur->bc_ptrs[level]--;
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*stat = 2;
-	return 0;
-
-error0:
-	if (tcur)
-		xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
-	return error;
-}
-
-/*
- * Log pointer values from the btree block.
- */
-STATIC void
-xfs_bmbt_log_ptrs(
-	xfs_btree_cur_t	*cur,
-	xfs_buf_t	*bp,
-	int		pfirst,
-	int		plast)
-{
-	xfs_trans_t	*tp;
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGBII(cur, bp, pfirst, plast);
-	tp = cur->bc_tp;
-	if (bp) {
-		xfs_bmbt_block_t	*block;
-		int			first;
-		int			last;
-		xfs_bmbt_ptr_t		*pp;
-
-		block = XFS_BUF_TO_BMBT_BLOCK(bp);
-		pp = XFS_BMAP_PTR_DADDR(block, 1, cur);
-		first = (int)((xfs_caddr_t)&pp[pfirst - 1] - (xfs_caddr_t)block);
-		last = (int)(((xfs_caddr_t)&pp[plast] - 1) - (xfs_caddr_t)block);
-		xfs_trans_log_buf(tp, bp, first, last);
-	} else {
-		xfs_inode_t		*ip;
-
-		ip = cur->bc_private.b.ip;
-		xfs_trans_log_inode(tp, ip,
-			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
-	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-}
-
-/*
  * Determine the extent state.
  */
 /* ARGSUSED */
@@ -540,42 +122,6 @@ xfs_bmdr_to_bmbt(
 }
 
 /*
- * Delete the record pointed to by cur.
- */
-int					/* error */
-xfs_bmbt_delete(
-	xfs_btree_cur_t	*cur,
-	int		*stat)		/* success/failure */
-{
-	int		error;		/* error return value */
-	int		i;
-	int		level;
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	for (level = 0, i = 2; i == 2; level++) {
-		if ((error = xfs_bmbt_delrec(cur, level, &i))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-	}
-	if (i == 0) {
-		for (level = 1; level < cur->bc_nlevels; level++) {
-			if (cur->bc_ptrs[level] == 0) {
-				if ((error = xfs_btree_decrement(cur, level,
-						&i))) {
-					XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-					return error;
-				}
-				break;
-			}
-		}
-	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*stat = i;
-	return 0;
-}
-
-/*
  * Convert a compressed bmap extent record to an uncompressed form.
  * This code must be in sync with the routines xfs_bmbt_get_startoff,
  * xfs_bmbt_get_startblock, xfs_bmbt_get_blockcount and xfs_bmbt_get_state.
@@ -629,31 +175,6 @@ xfs_bmbt_get_all(
 }
 
 /*
- * Get the block pointer for the given level of the cursor.
- * Fill in the buffer pointer, if applicable.
- */
-xfs_bmbt_block_t *
-xfs_bmbt_get_block(
-	xfs_btree_cur_t		*cur,
-	int			level,
-	xfs_buf_t		**bpp)
-{
-	xfs_ifork_t		*ifp;
-	xfs_bmbt_block_t	*rval;
-
-	if (level < cur->bc_nlevels - 1) {
-		*bpp = cur->bc_bufs[level];
-		rval = XFS_BUF_TO_BMBT_BLOCK(*bpp);
-	} else {
-		*bpp = NULL;
-		ifp = XFS_IFORK_PTR(cur->bc_private.b.ip,
-			cur->bc_private.b.whichfork);
-		rval = ifp->if_broot;
-	}
-	return rval;
-}
-
-/*
  * Extract the blockcount field from an in memory bmap extent record.
  */
 xfs_filblks_t
@@ -1180,6 +701,14 @@ xfs_bmbt_realloc_root(
 }
 
 STATIC int
+xfs_bmbt_get_minrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return XFS_BMAP_BLOCK_IMINRECS(level, cur);
+}
+
+STATIC int
 xfs_bmbt_get_maxrecs(
 	struct xfs_btree_cur	*cur,
 	int			level)
@@ -1502,6 +1031,7 @@ static const struct xfs_btree_ops xfs_bm
 	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
 	.init_rec_from_key	= xfs_bmbt_init_rec_from_key,
 	.init_rec_from_cur	= xfs_bmbt_init_rec_from_cur,
+	.get_minrecs		= xfs_bmbt_get_minrecs,
 	.get_maxrecs		= xfs_bmbt_get_maxrecs,
 	.get_dmaxrecs		= xfs_bmbt_get_dmaxrecs,
 	.ptr_addr		= xfs_bmbt_ptr_addr,
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-08-04 01:18:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-08-04 01:18:45.000000000 +0200
@@ -216,6 +216,7 @@ struct xfs_btree_ops {
 					 struct xfs_btree_block *block);
 
 	/* records in block/level */
+	int	(*get_minrecs)(struct xfs_btree_cur *cur, int level);
 	int	(*get_maxrecs)(struct xfs_btree_cur *cur, int level);
 	int	(*get_dmaxrecs)(struct xfs_btree_cur *cur, int level);
 
@@ -289,6 +290,7 @@ struct xfs_btree_ops {
  */
 #define LASTREC_UPDATE	0
 #define LASTREC_INSREC	1
+#define LASTREC_DELREC	2
 
 
 /*
@@ -600,6 +602,7 @@ int xfs_btree_new_root(struct xfs_btree_
 int xfs_btree_iroot_to_root(struct xfs_btree_cur *, int *, int *);
 int xfs_btree_root_to_iroot(struct xfs_btree_cur *);
 int xfs_btree_insert(struct xfs_btree_cur *, int *);
+int xfs_btree_delete(struct xfs_btree_cur *, int *);
 
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-08-04 01:18:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-08-04 01:18:45.000000000 +0200
@@ -40,567 +40,6 @@
 #include "xfs_alloc.h"
 #include "xfs_error.h"
 
-STATIC void xfs_inobt_log_block(xfs_trans_t *, xfs_buf_t *, int);
-STATIC void xfs_inobt_log_keys(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-STATIC void xfs_inobt_log_ptrs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-STATIC void xfs_inobt_log_recs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-
-/*
- * Single level of the xfs_inobt_delete record deletion routine.
- * Delete record pointed to by cur/level.
- * Remove the record from its block then rebalance the tree.
- * Return 0 for error, 1 for done, 2 to go on to the next level.
- */
-STATIC int				/* error */
-xfs_inobt_delrec(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level removing record from */
-	int			*stat)	/* fail/done/go-on */
-{
-	xfs_buf_t		*agbp;	/* buffer for a.g. inode header */
-	xfs_mount_t		*mp;	/* mount structure */
-	xfs_agi_t		*agi;	/* allocation group inode header */
-	xfs_inobt_block_t	*block;	/* btree block record/key lives in */
-	xfs_agblock_t		bno;	/* btree block number */
-	xfs_buf_t		*bp;	/* buffer for block */
-	int			error;	/* error return value */
-	int			i;	/* loop index */
-	xfs_inobt_key_t		key;	/* kp points here if block is level 0 */
-	xfs_inobt_key_t		*kp = NULL;	/* pointer to btree keys */
-	xfs_agblock_t		lbno;	/* left block's block number */
-	xfs_buf_t		*lbp;	/* left block's buffer pointer */
-	xfs_inobt_block_t	*left;	/* left btree block */
-	xfs_inobt_key_t		*lkp;	/* left block key pointer */
-	xfs_inobt_ptr_t		*lpp;	/* left block address pointer */
-	int			lrecs = 0;	/* number of records in left block */
-	xfs_inobt_rec_t		*lrp;	/* left block record pointer */
-	xfs_inobt_ptr_t		*pp = NULL;	/* pointer to btree addresses */
-	int			ptr;	/* index in btree block for this rec */
-	xfs_agblock_t		rbno;	/* right block's block number */
-	xfs_buf_t		*rbp;	/* right block's buffer pointer */
-	xfs_inobt_block_t	*right;	/* right btree block */
-	xfs_inobt_key_t		*rkp;	/* right block key pointer */
-	xfs_inobt_rec_t		*rp;	/* pointer to btree records */
-	xfs_inobt_ptr_t		*rpp;	/* right block address pointer */
-	int			rrecs = 0;	/* number of records in right block */
-	int			numrecs;
-	xfs_inobt_rec_t		*rrp;	/* right block record pointer */
-	xfs_btree_cur_t		*tcur;	/* temporary btree cursor */
-
-	mp = cur->bc_mp;
-
-	/*
-	 * Get the index of the entry being deleted, check for nothing there.
-	 */
-	ptr = cur->bc_ptrs[level];
-	if (ptr == 0) {
-		*stat = 0;
-		return 0;
-	}
-
-	/*
-	 * Get the buffer & block containing the record or key/ptr.
-	 */
-	bp = cur->bc_bufs[level];
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, level, bp)))
-		return error;
-#endif
-	/*
-	 * Fail if we're off the end of the block.
-	 */
-
-	numrecs = be16_to_cpu(block->bb_numrecs);
-	if (ptr > numrecs) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * It's a nonleaf.  Excise the key and ptr being deleted, by
-	 * sliding the entries past them down one.
-	 * Log the changed areas of the block.
-	 */
-	if (level > 0) {
-		kp = XFS_INOBT_KEY_ADDR(block, 1, cur);
-		pp = XFS_INOBT_PTR_ADDR(block, 1, cur);
-#ifdef DEBUG
-		for (i = ptr; i < numrecs; i++) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(pp[i]), level)))
-				return error;
-		}
-#endif
-		if (ptr < numrecs) {
-			memmove(&kp[ptr - 1], &kp[ptr],
-				(numrecs - ptr) * sizeof(*kp));
-			memmove(&pp[ptr - 1], &pp[ptr],
-				(numrecs - ptr) * sizeof(*kp));
-			xfs_inobt_log_keys(cur, bp, ptr, numrecs - 1);
-			xfs_inobt_log_ptrs(cur, bp, ptr, numrecs - 1);
-		}
-	}
-	/*
-	 * It's a leaf.  Excise the record being deleted, by sliding the
-	 * entries past it down one.  Log the changed areas of the block.
-	 */
-	else {
-		rp = XFS_INOBT_REC_ADDR(block, 1, cur);
-		if (ptr < numrecs) {
-			memmove(&rp[ptr - 1], &rp[ptr],
-				(numrecs - ptr) * sizeof(*rp));
-			xfs_inobt_log_recs(cur, bp, ptr, numrecs - 1);
-		}
-		/*
-		 * If it's the first record in the block, we'll need a key
-		 * structure to pass up to the next level (updkey).
-		 */
-		if (ptr == 1) {
-			key.ir_startino = rp->ir_startino;
-			kp = &key;
-		}
-	}
-	/*
-	 * Decrement and log the number of entries in the block.
-	 */
-	numrecs--;
-	block->bb_numrecs = cpu_to_be16(numrecs);
-	xfs_inobt_log_block(cur->bc_tp, bp, XFS_BB_NUMRECS);
-	/*
-	 * Is this the root level?  If so, we're almost done.
-	 */
-	if (level == cur->bc_nlevels - 1) {
-		/*
-		 * If this is the root level,
-		 * and there's only one entry left,
-		 * and it's NOT the leaf level,
-		 * then we can get rid of this level.
-		 */
-		if (numrecs == 1 && level > 0) {
-			agbp = cur->bc_private.a.agbp;
-			agi = XFS_BUF_TO_AGI(agbp);
-			/*
-			 * pp is still set to the first pointer in the block.
-			 * Make it the new root of the btree.
-			 */
-			bno = be32_to_cpu(agi->agi_root);
-			agi->agi_root = *pp;
-			be32_add(&agi->agi_level, -1);
-			/*
-			 * Free the block.
-			 */
-			if ((error = xfs_free_extent(cur->bc_tp,
-				XFS_AGB_TO_FSB(mp, cur->bc_private.a.agno, bno), 1)))
-				return error;
-			xfs_trans_binval(cur->bc_tp, bp);
-			xfs_ialloc_log_agi(cur->bc_tp, agbp,
-				XFS_AGI_ROOT | XFS_AGI_LEVEL);
-			/*
-			 * Update the cursor so there's one fewer level.
-			 */
-			cur->bc_bufs[level] = NULL;
-			cur->bc_nlevels--;
-		} else if (level > 0 &&
-			   (error = xfs_btree_decrement(cur, level, &i)))
-			return error;
-		*stat = 1;
-		return 0;
-	}
-	/*
-	 * If we deleted the leftmost entry in the block, update the
-	 * key values above us in the tree.
-	 */
-	if (ptr == 1 && (error = xfs_btree_updkey(cur, (union xfs_btree_key *)kp, level + 1)))
-		return error;
-	/*
-	 * If the number of records remaining in the block is at least
-	 * the minimum, we're done.
-	 */
-	if (numrecs >= XFS_INOBT_BLOCK_MINRECS(level, cur)) {
-		if (level > 0 &&
-		    (error = xfs_btree_decrement(cur, level, &i)))
-			return error;
-		*stat = 1;
-		return 0;
-	}
-	/*
-	 * Otherwise, we have to move some records around to keep the
-	 * tree balanced.  Look at the left and right sibling blocks to
-	 * see if we can re-balance by moving only one record.
-	 */
-	rbno = be32_to_cpu(block->bb_rightsib);
-	lbno = be32_to_cpu(block->bb_leftsib);
-	bno = NULLAGBLOCK;
-	ASSERT(rbno != NULLAGBLOCK || lbno != NULLAGBLOCK);
-	/*
-	 * Duplicate the cursor so our btree manipulations here won't
-	 * disrupt the next level up.
-	 */
-	if ((error = xfs_btree_dup_cursor(cur, &tcur)))
-		return error;
-	/*
-	 * If there's a right sibling, see if it's ok to shift an entry
-	 * out of it.
-	 */
-	if (rbno != NULLAGBLOCK) {
-		/*
-		 * Move the temp cursor to the last entry in the next block.
-		 * Actually any entry but the first would suffice.
-		 */
-		i = xfs_btree_lastrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_btree_increment(tcur, level, &i)))
-			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		i = xfs_btree_lastrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		/*
-		 * Grab a pointer to the block.
-		 */
-		rbp = tcur->bc_bufs[level];
-		right = XFS_BUF_TO_INOBT_BLOCK(rbp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sblock(cur, right, level, rbp)))
-			goto error0;
-#endif
-		/*
-		 * Grab the current block number, for future use.
-		 */
-		bno = be32_to_cpu(right->bb_leftsib);
-		/*
-		 * If right block is full enough so that removing one entry
-		 * won't make it too empty, and left-shifting an entry out
-		 * of right to us works, we're done.
-		 */
-		if (be16_to_cpu(right->bb_numrecs) - 1 >=
-		     XFS_INOBT_BLOCK_MINRECS(level, cur)) {
-			if ((error = xfs_btree_lshift(tcur, level, &i)))
-				goto error0;
-			if (i) {
-				ASSERT(be16_to_cpu(block->bb_numrecs) >=
-				       XFS_INOBT_BLOCK_MINRECS(level, cur));
-				xfs_btree_del_cursor(tcur,
-						     XFS_BTREE_NOERROR);
-				if (level > 0 &&
-				    (error = xfs_btree_decrement(cur, level,
-						&i)))
-					return error;
-				*stat = 1;
-				return 0;
-			}
-		}
-		/*
-		 * Otherwise, grab the number of records in right for
-		 * future reference, and fix up the temp cursor to point
-		 * to our block again (last record).
-		 */
-		rrecs = be16_to_cpu(right->bb_numrecs);
-		if (lbno != NULLAGBLOCK) {
-			xfs_btree_firstrec(tcur, level);
-			if ((error = xfs_btree_decrement(tcur, level, &i)))
-				goto error0;
-		}
-	}
-	/*
-	 * If there's a left sibling, see if it's ok to shift an entry
-	 * out of it.
-	 */
-	if (lbno != NULLAGBLOCK) {
-		/*
-		 * Move the temp cursor to the first entry in the
-		 * previous block.
-		 */
-		xfs_btree_firstrec(tcur, level);
-		if ((error = xfs_btree_decrement(tcur, level, &i)))
-			goto error0;
-		xfs_btree_firstrec(tcur, level);
-		/*
-		 * Grab a pointer to the block.
-		 */
-		lbp = tcur->bc_bufs[level];
-		left = XFS_BUF_TO_INOBT_BLOCK(lbp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
-			goto error0;
-#endif
-		/*
-		 * Grab the current block number, for future use.
-		 */
-		bno = be32_to_cpu(left->bb_rightsib);
-		/*
-		 * If left block is full enough so that removing one entry
-		 * won't make it too empty, and right-shifting an entry out
-		 * of left to us works, we're done.
-		 */
-		if (be16_to_cpu(left->bb_numrecs) - 1 >=
-		     XFS_INOBT_BLOCK_MINRECS(level, cur)) {
-			if ((error = xfs_btree_rshift(tcur, level, &i)))
-				goto error0;
-			if (i) {
-				ASSERT(be16_to_cpu(block->bb_numrecs) >=
-				       XFS_INOBT_BLOCK_MINRECS(level, cur));
-				xfs_btree_del_cursor(tcur,
-						     XFS_BTREE_NOERROR);
-				if (level == 0)
-					cur->bc_ptrs[0]++;
-				*stat = 1;
-				return 0;
-			}
-		}
-		/*
-		 * Otherwise, grab the number of records in right for
-		 * future reference.
-		 */
-		lrecs = be16_to_cpu(left->bb_numrecs);
-	}
-	/*
-	 * Delete the temp cursor, we're done with it.
-	 */
-	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
-	/*
-	 * If here, we need to do a join to keep the tree balanced.
-	 */
-	ASSERT(bno != NULLAGBLOCK);
-	/*
-	 * See if we can join with the left neighbor block.
-	 */
-	if (lbno != NULLAGBLOCK &&
-	    lrecs + numrecs <= XFS_INOBT_BLOCK_MAXRECS(level, cur)) {
-		/*
-		 * Set "right" to be the starting block,
-		 * "left" to be the left neighbor.
-		 */
-		rbno = bno;
-		right = block;
-		rrecs = be16_to_cpu(right->bb_numrecs);
-		rbp = bp;
-		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
-				cur->bc_private.a.agno, lbno, 0, &lbp,
-				XFS_INO_BTREE_REF)))
-			return error;
-		left = XFS_BUF_TO_INOBT_BLOCK(lbp);
-		lrecs = be16_to_cpu(left->bb_numrecs);
-		if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
-			return error;
-	}
-	/*
-	 * If that won't work, see if we can join with the right neighbor block.
-	 */
-	else if (rbno != NULLAGBLOCK &&
-		 rrecs + numrecs <= XFS_INOBT_BLOCK_MAXRECS(level, cur)) {
-		/*
-		 * Set "left" to be the starting block,
-		 * "right" to be the right neighbor.
-		 */
-		lbno = bno;
-		left = block;
-		lrecs = be16_to_cpu(left->bb_numrecs);
-		lbp = bp;
-		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
-				cur->bc_private.a.agno, rbno, 0, &rbp,
-				XFS_INO_BTREE_REF)))
-			return error;
-		right = XFS_BUF_TO_INOBT_BLOCK(rbp);
-		rrecs = be16_to_cpu(right->bb_numrecs);
-		if ((error = xfs_btree_check_sblock(cur, right, level, rbp)))
-			return error;
-	}
-	/*
-	 * Otherwise, we can't fix the imbalance.
-	 * Just return.  This is probably a logic error, but it's not fatal.
-	 */
-	else {
-		if (level > 0 && (error = xfs_btree_decrement(cur, level, &i)))
-			return error;
-		*stat = 1;
-		return 0;
-	}
-	/*
-	 * We're now going to join "left" and "right" by moving all the stuff
-	 * in "right" to "left" and deleting "right".
-	 */
-	if (level > 0) {
-		/*
-		 * It's a non-leaf.  Move keys and pointers.
-		 */
-		lkp = XFS_INOBT_KEY_ADDR(left, lrecs + 1, cur);
-		lpp = XFS_INOBT_PTR_ADDR(left, lrecs + 1, cur);
-		rkp = XFS_INOBT_KEY_ADDR(right, 1, cur);
-		rpp = XFS_INOBT_PTR_ADDR(right, 1, cur);
-#ifdef DEBUG
-		for (i = 0; i < rrecs; i++) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(rpp[i]), level)))
-				return error;
-		}
-#endif
-		memcpy(lkp, rkp, rrecs * sizeof(*lkp));
-		memcpy(lpp, rpp, rrecs * sizeof(*lpp));
-		xfs_inobt_log_keys(cur, lbp, lrecs + 1, lrecs + rrecs);
-		xfs_inobt_log_ptrs(cur, lbp, lrecs + 1, lrecs + rrecs);
-	} else {
-		/*
-		 * It's a leaf.  Move records.
-		 */
-		lrp = XFS_INOBT_REC_ADDR(left, lrecs + 1, cur);
-		rrp = XFS_INOBT_REC_ADDR(right, 1, cur);
-		memcpy(lrp, rrp, rrecs * sizeof(*lrp));
-		xfs_inobt_log_recs(cur, lbp, lrecs + 1, lrecs + rrecs);
-	}
-	/*
-	 * If we joined with the left neighbor, set the buffer in the
-	 * cursor to the left block, and fix up the index.
-	 */
-	if (bp != lbp) {
-		xfs_btree_setbuf(cur, level, lbp);
-		cur->bc_ptrs[level] += lrecs;
-	}
-	/*
-	 * If we joined with the right neighbor and there's a level above
-	 * us, increment the cursor at that level.
-	 */
-	else if (level + 1 < cur->bc_nlevels &&
-		 (error = xfs_btree_increment(cur, level + 1, &i)))
-		return error;
-	/*
-	 * Fix up the number of records in the surviving block.
-	 */
-	lrecs += rrecs;
-	left->bb_numrecs = cpu_to_be16(lrecs);
-	/*
-	 * Fix up the right block pointer in the surviving block, and log it.
-	 */
-	left->bb_rightsib = right->bb_rightsib;
-	xfs_inobt_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
-	/*
-	 * If there is a right sibling now, make it point to the
-	 * remaining block.
-	 */
-	if (be32_to_cpu(left->bb_rightsib) != NULLAGBLOCK) {
-		xfs_inobt_block_t	*rrblock;
-		xfs_buf_t		*rrbp;
-
-		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
-				cur->bc_private.a.agno, be32_to_cpu(left->bb_rightsib), 0,
-				&rrbp, XFS_INO_BTREE_REF)))
-			return error;
-		rrblock = XFS_BUF_TO_INOBT_BLOCK(rrbp);
-		if ((error = xfs_btree_check_sblock(cur, rrblock, level, rrbp)))
-			return error;
-		rrblock->bb_leftsib = cpu_to_be32(lbno);
-		xfs_inobt_log_block(cur->bc_tp, rrbp, XFS_BB_LEFTSIB);
-	}
-	/*
-	 * Free the deleting block.
-	 */
-	if ((error = xfs_free_extent(cur->bc_tp, XFS_AGB_TO_FSB(mp,
-				     cur->bc_private.a.agno, rbno), 1)))
-		return error;
-	xfs_trans_binval(cur->bc_tp, rbp);
-	/*
-	 * Readjust the ptr at this level if it's not a leaf, since it's
-	 * still pointing at the deletion point, which makes the cursor
-	 * inconsistent.  If this makes the ptr 0, the caller fixes it up.
-	 * We can't use decrement because it would change the next level up.
-	 */
-	if (level > 0)
-		cur->bc_ptrs[level]--;
-	/*
-	 * Return value means the next level up has something to do.
-	 */
-	*stat = 2;
-	return 0;
-
-error0:
-	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
-	return error;
-}
-
-/*
- * Log header fields from a btree block.
- */
-STATIC void
-xfs_inobt_log_block(
-	xfs_trans_t		*tp,	/* transaction pointer */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			fields)	/* mask of fields: XFS_BB_... */
-{
-	int			first;	/* first byte offset logged */
-	int			last;	/* last byte offset logged */
-	static const short	offsets[] = {	/* table of offsets */
-		offsetof(xfs_inobt_block_t, bb_magic),
-		offsetof(xfs_inobt_block_t, bb_level),
-		offsetof(xfs_inobt_block_t, bb_numrecs),
-		offsetof(xfs_inobt_block_t, bb_leftsib),
-		offsetof(xfs_inobt_block_t, bb_rightsib),
-		sizeof(xfs_inobt_block_t)
-	};
-
-	xfs_btree_offsets(fields, offsets, XFS_BB_NUM_BITS, &first, &last);
-	xfs_trans_log_buf(tp, bp, first, last);
-}
-
-/*
- * Log block pointer fields from a btree block (nonleaf).
- */
-STATIC void
-xfs_inobt_log_ptrs(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			pfirst,	/* index of first pointer to log */
-	int			plast)	/* index of last pointer to log */
-{
-	xfs_inobt_block_t	*block;	/* btree block to log from */
-	int			first;	/* first byte offset logged */
-	int			last;	/* last byte offset logged */
-	xfs_inobt_ptr_t		*pp;	/* block-pointer pointer in btree blk */
-
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-	pp = XFS_INOBT_PTR_ADDR(block, 1, cur);
-	first = (int)((xfs_caddr_t)&pp[pfirst - 1] - (xfs_caddr_t)block);
-	last = (int)(((xfs_caddr_t)&pp[plast] - 1) - (xfs_caddr_t)block);
-	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
-}
-
-
-/*
- * Externally visible routines.
- */
-
-/*
- * Delete the record pointed to by cur.
- * The cursor refers to the place where the record was (could be inserted)
- * when the operation returns.
- */
-int					/* error */
-xfs_inobt_delete(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	int		*stat)		/* success/failure */
-{
-	int		error;
-	int		i;		/* result code */
-	int		level;		/* btree level */
-
-	/*
-	 * Go up the tree, starting at leaf level.
-	 * If 2 is returned then a join was done; go to the next level.
-	 * Otherwise we are done.
-	 */
-	for (level = 0, i = 2; i == 2; level++) {
-		if ((error = xfs_inobt_delrec(cur, level, &i)))
-			return error;
-	}
-	if (i == 0) {
-		for (level = 1; level < cur->bc_nlevels; level++) {
-			if (cur->bc_ptrs[level] == 0) {
-				if ((error = xfs_btree_decrement(cur, level, &i)))
-					return error;
-				break;
-			}
-		}
-	}
-	*stat = i;
-	return 0;
-}
-
 
 /*
  * Get the data from the pointed-to record.
@@ -945,6 +384,13 @@ xfs_inobt_log_recs(
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 }
 
+STATIC int
+xfs_inobt_get_minrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_inobt_mnr[level != 0];
+}
 
 #ifdef XFS_BTREE_TRACE
 
@@ -1018,6 +464,7 @@ static const struct xfs_btree_ops xfs_in
 	.set_root		= xfs_inobt_set_root,
 	.alloc_block		= xfs_inobt_alloc_block,
 	.free_block		= xfs_inobt_free_block,
+	.get_minrecs		= xfs_inobt_get_minrecs,
 	.get_maxrecs		= xfs_inobt_get_maxrecs,
 	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
Index: linux-2.6-xfs/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc.c	2008-08-04 01:18:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc.c	2008-08-04 01:18:45.000000000 +0200
@@ -398,7 +398,7 @@ xfs_alloc_fixup_trees(
 	/*
 	 * Delete the entry from the by-size btree.
 	 */
-	if ((error = xfs_alloc_delete(cnt_cur, &i)))
+	if ((error = xfs_btree_delete(cnt_cur, &i)))
 		return error;
 	XFS_WANT_CORRUPTED_RETURN(i == 1);
 	/*
@@ -427,7 +427,7 @@ xfs_alloc_fixup_trees(
 		/*
 		 * No remaining freespace, just delete the by-block tree entry.
 		 */
-		if ((error = xfs_alloc_delete(bno_cur, &i)))
+		if ((error = xfs_btree_delete(bno_cur, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 1);
 	} else {
@@ -1651,7 +1651,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, ltbno, ltlen, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_alloc_delete(cnt_cur, &i)))
+		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		/*
@@ -1660,13 +1660,13 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, gtbno, gtlen, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_alloc_delete(cnt_cur, &i)))
+		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		/*
 		 * Delete the old by-block entry for the right block.
 		 */
-		if ((error = xfs_alloc_delete(bno_cur, &i)))
+		if ((error = xfs_btree_delete(bno_cur, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		/*
@@ -1711,7 +1711,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, ltbno, ltlen, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_alloc_delete(cnt_cur, &i)))
+		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		/*
@@ -1737,7 +1737,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, gtbno, gtlen, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_alloc_delete(cnt_cur, &i)))
+		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		/*
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.h	2008-08-04 01:18:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h	2008-08-04 01:18:45.000000000 +0200
@@ -95,13 +95,6 @@ typedef	struct xfs_btree_sblock xfs_allo
 	XFS_BTREE_PTR_ADDR(xfs_alloc, bb, i, XFS_ALLOC_BLOCK_MAXRECS(1, cur))
 
 /*
- * Delete the record pointed to by cur.
- * The cursor refers to the place where the record was (could be inserted)
- * when the operation returns.
- */
-extern int xfs_alloc_delete(struct xfs_btree_cur *cur, int *stat);
-
-/*
  * Get the data from the pointed-to record.
  */
 extern int xfs_alloc_get_rec(struct xfs_btree_cur *cur,	xfs_agblock_t *bno,
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-08-04 01:18:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-08-04 01:18:45.000000000 +0200
@@ -864,7 +864,7 @@ xfs_bmap_add_extent_delay_real(
 					RIGHT.br_blockcount, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_delete(cur, &i)))
+			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
@@ -1425,13 +1425,13 @@ xfs_bmap_add_extent_unwritten_real(
 					RIGHT.br_blockcount, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_delete(cur, &i)))
+			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_delete(cur, &i)))
+			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
@@ -1474,7 +1474,7 @@ xfs_bmap_add_extent_unwritten_real(
 					&i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_delete(cur, &i)))
+			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
@@ -1517,7 +1517,7 @@ xfs_bmap_add_extent_unwritten_real(
 					RIGHT.br_blockcount, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_delete(cur, &i)))
+			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
@@ -2152,7 +2152,7 @@ xfs_bmap_add_extent_hole_real(
 					right.br_blockcount, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_delete(cur, &i)))
+			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
@@ -3216,7 +3216,7 @@ xfs_bmap_del_extent(
 			flags |= XFS_ILOG_FEXT(whichfork);
 			break;
 		}
-		if ((error = xfs_bmbt_delete(cur, &i)))
+		if ((error = xfs_btree_delete(cur, &i)))
 			goto done;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		break;
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.h	2008-08-04 01:18:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h	2008-08-04 01:18:45.000000000 +0200
@@ -237,10 +237,7 @@ typedef struct xfs_btree_lblock xfs_bmbt
  * Prototypes for xfs_bmap.c to call.
  */
 extern void xfs_bmdr_to_bmbt(xfs_bmdr_block_t *, int, xfs_bmbt_block_t *, int);
-extern int xfs_bmbt_delete(struct xfs_btree_cur *, int *);
 extern void xfs_bmbt_get_all(xfs_bmbt_rec_host_t *r, xfs_bmbt_irec_t *s);
-extern xfs_bmbt_block_t *xfs_bmbt_get_block(struct xfs_btree_cur *cur,
-						int, struct xfs_buf **bpp);
 extern xfs_filblks_t xfs_bmbt_get_blockcount(xfs_bmbt_rec_host_t *r);
 extern xfs_fsblock_t xfs_bmbt_get_startblock(xfs_bmbt_rec_host_t *r);
 extern xfs_fileoff_t xfs_bmbt_get_startoff(xfs_bmbt_rec_host_t *r);
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c	2008-08-04 01:18:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c	2008-08-04 01:18:45.000000000 +0200
@@ -1168,8 +1168,8 @@ xfs_difree(
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, -ilen);
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -(ilen - 1));
 
-		if ((error = xfs_inobt_delete(cur, &i))) {
-			cmn_err(CE_WARN, "xfs_difree: xfs_inobt_delete returned an error %d on %s.\n",
+		if ((error = xfs_btree_delete(cur, &i))) {
+			cmn_err(CE_WARN, "xfs_difree: xfs_btree_delete returned an error %d on %s.\n",
 				error, mp->m_fsname);
 			goto error0;
 		}
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.h	2008-08-04 01:18:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h	2008-08-04 01:18:45.000000000 +0200
@@ -117,13 +117,6 @@ typedef	struct xfs_btree_sblock xfs_inob
 				i, XFS_INOBT_BLOCK_MAXRECS(1, cur)))
 
 /*
- * Delete the record pointed to by cur.
- * The cursor refers to the place where the record was (could be inserted)
- * when the operation returns.
- */
-extern int xfs_inobt_delete(struct xfs_btree_cur *cur, int *stat);
-
-/*
  * Get the data from the pointed-to record.
  */
 extern int xfs_inobt_get_rec(struct xfs_btree_cur *cur, xfs_agino_t *ino,

-- 
