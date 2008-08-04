Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Aug 2008 18:34:37 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m741YN4K001218
	for <xfs@oss.sgi.com>; Sun, 3 Aug 2008 18:34:25 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 10C3A1976457
	for <xfs@oss.sgi.com>; Sun,  3 Aug 2008 18:35:34 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 37S0h13Uo3vzaGkg for <xfs@oss.sgi.com>; Sun, 03 Aug 2008 18:35:34 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m741ZZIF009283
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 03:35:35 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m741ZZFi009281
	for xfs@oss.sgi.com; Mon, 4 Aug 2008 03:35:35 +0200
Date: Mon, 4 Aug 2008 03:35:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 21/26] implement =?unknown-8bit?Q?g?=
	=?unknown-8bit?Q?eneric_xfs=5Fbtree=5Fin=D1=95ert=2Finsrec?=
Message-ID: <20080804013535.GV8819@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-common-btree-insert
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Make the btree insert code generic.  Based on a patch from David Chinner
with lots of changes to follow the original btree implementations more
closely.  While this loses some of the generic helper routines for
inserting/moving/removing records it also solves some of the one off
bugs in the original code and makes it easier to verify.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-08-03 16:03:38.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-08-03 16:11:08.000000000 +0200
@@ -818,6 +818,17 @@ xfs_btree_ptr_is_null(
 		return be32_to_cpu(ptr->s) == NULLAGBLOCK;
 }
 
+STATIC void
+xfs_btree_set_ptr_null(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		ptr->l = cpu_to_be64(NULLFSBLOCK);
+	else
+		ptr->s = cpu_to_be32(NULLAGBLOCK);
+}
+
 /*
  * Get/set/init sibling pointers
  */
@@ -2476,3 +2487,354 @@ out0:
 	*stat = 0;
 	return 0;
 }
+
+STATIC int
+xfs_btree_make_block_unfull(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	int			level,	/* btree level */
+	int			numrecs,/* # of recs in block */
+	int			*oindex,/* old tree index */
+	int			*index,	/* new tree index */
+	union xfs_btree_ptr	*nptr,	/* new btree ptr */
+	struct xfs_btree_cur	**ncur,	/* new btree cursor */
+	union xfs_btree_rec	*nrec,	/* new record */
+	int			*stat)
+{
+	union xfs_btree_key	key;	/* new btree key value */
+	int			error = 0;
+
+	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+		if (numrecs < cur->bc_ops->get_dmaxrecs(cur, level)) {
+			/* A resizeable root block that can be made bigger. */
+			cur->bc_ops->realloc_root(cur, 1);
+			return 0;
+		}
+		if (level == cur->bc_nlevels - 1) {
+			/* A root block that needs replacing */
+			int	logflags = 0;
+
+			error = xfs_btree_iroot_to_root(cur, &logflags, stat);
+			if (error || *stat == 0)
+				return error;
+
+			xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
+						logflags);
+			return 0;
+		}
+	}
+
+	/* First, try shifting an entry to the right neighbor. */
+	error = xfs_btree_rshift(cur, level, stat);
+	if (error || *stat)
+		return error;
+
+	/* Next, try shifting an entry to the left neighbor. */
+	error = xfs_btree_lshift(cur, level, stat);
+	if (error)
+		return error;
+
+	if (*stat) {
+		*oindex = *index = cur->bc_ptrs[level];
+		return 0;
+	}
+
+	/*
+	 * Next, try splitting the current block in half.
+	 *
+	 * If this works we have to re-set our variables because we
+	 * could be in a different block now.
+	 */
+	error = xfs_btree_split(cur, level, nptr, &key, ncur, stat);
+	if (error || *stat == 0)
+		return error;
+
+
+	*index = cur->bc_ptrs[level];
+	cur->bc_ops->init_rec_from_key(&key, nrec);
+	return 0;
+}
+
+/*
+ * Insert one record/level.  Return information to the caller
+ * allowing the next level up to proceed if necessary.
+ */
+STATIC int
+xfs_btree_insrec(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	int			level,	/* level to insert record at */
+	union xfs_btree_ptr	*ptrp,	/* i/o: block number inserted */
+	union xfs_btree_rec	*recp,	/* i/o: record data inserted */
+	struct xfs_btree_cur	**curp,	/* output: new cursor replacing cur */
+	int			*stat)	/* success/failure */
+{
+	struct xfs_btree_block	*block;	/* bmap btree block */
+	struct xfs_buf		*bp;	/* buffer for block */
+	union xfs_btree_key	key;	/* bmap btree key */
+	union xfs_btree_ptr	nptr;	/* new block ptr */
+	struct xfs_btree_cur	*ncur;	/* new btree cursor */
+	union xfs_btree_rec	nrec;	/* new record count */
+	int			optr;	/* old key/record index */
+	int			ptr;	/* key/record index */
+	int			numrecs;/* number of records */
+	int			error;	/* error return value */
+#ifdef DEBUG
+	int			i;
+#endif
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGIPR(cur, level, *ptrp, recp);
+
+	ncur = NULL;
+
+	/*
+	 * If we have an external root pointer, and we've made it to the
+	 * root level, allocate a new root block and we're done.
+	 */
+	if (!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    (level >= cur->bc_nlevels)) {
+		error = xfs_btree_new_root(cur, stat);
+		xfs_btree_set_ptr_null(cur, ptrp);
+
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		return error;
+	}
+
+	/* Make a key out of the record data to be inserted, and save it. */
+	cur->bc_ops->init_key_from_rec(cur, &key, recp);
+
+	/* If we're off the left edge, return failure. */
+	ptr = cur->bc_ptrs[level];
+	if (ptr == 0) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+
+	optr = ptr;
+
+	XFS_BTREE_STATS_INC(cur, insrec);
+
+	/* Get pointers to the btree buffer and block. */
+	block = xfs_btree_get_block(cur, level, &bp);
+	numrecs = xfs_btree_get_numrecs(block);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, block, level, bp);
+	if (error)
+		goto error0;
+
+	/* Check that the new entry is being inserted in the right place. */
+	if (ptr <= numrecs) {
+		if (level == 0) {
+			xfs_btree_check_rec(cur->bc_btnum, recp,
+					cur->bc_ops->rec_addr(cur, ptr, block));
+		} else {
+			xfs_btree_check_key(cur->bc_btnum, &key,
+					cur->bc_ops->key_addr(cur, ptr, block));
+		}
+	}
+#endif
+
+	/*
+	 * If the block is full, we can't insert the new entry until we
+	 * make the block un-full.
+	 */
+	xfs_btree_set_ptr_null(cur, &nptr);
+	if (numrecs == cur->bc_ops->get_maxrecs(cur, level)) {
+		error = xfs_btree_make_block_unfull(cur, level, numrecs,
+					&optr, &ptr, &nptr, &ncur, &nrec, stat);
+		if (error || *stat == 0)
+			goto error0;
+	}
+
+	/* The current block may have changed during the split. */
+	block = xfs_btree_get_block(cur, level, &bp);
+	numrecs = xfs_btree_get_numrecs(block);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, block, level, bp);
+	if (error)
+		return error;
+#endif
+
+	/*
+	 * At this point we know there's room for our new entry in the block
+	 * we're pointing at.
+	 */
+	XFS_BTREE_STATS_ADD(cur, moves, numrecs - ptr + 1);
+
+	if (level > 0) {
+		/* It's a nonleaf. make a hole in the keys and ptrs */
+		union xfs_btree_key	*kp;
+		union xfs_btree_ptr	*pp;
+
+		kp = cur->bc_ops->key_addr(cur, 1, block);
+		pp = cur->bc_ops->ptr_addr(cur, 1, block);
+
+#ifdef DEBUG
+		for (i = ptr; i < numrecs; i++) {
+			error = xfs_btree_check_ptr(cur, pp, i - 1, level);
+			if (error)
+				goto error0;
+		}
+#endif
+
+		cur->bc_ops->move_keys(cur, kp, ptr - 1, ptr,
+					numrecs - ptr + 1);
+		xfs_btree_move_ptrs(cur, pp, ptr - 1, ptr,
+					numrecs - ptr + 1);
+
+#ifdef DEBUG
+		error = xfs_btree_check_ptr(cur, ptrp, 0, level);
+		if (error)
+			goto error0;
+#endif
+
+		/* Now put the new data in, bump numrecs and log it. */
+		cur->bc_ops->set_key(cur, kp, ptr - 1, &key);
+		xfs_btree_set_ptr(cur, pp, ptr - 1, ptrp);
+		numrecs++;
+		xfs_btree_set_numrecs(block, numrecs);
+		xfs_btree_log_ptrs(cur, bp, ptr, numrecs);
+		cur->bc_ops->log_keys(cur, bp, ptr, numrecs);
+#ifdef DEBUG
+		if (ptr < numrecs) {
+			xfs_btree_check_key(cur->bc_btnum,
+				cur->bc_ops->key_addr(cur, ptr, block),
+				cur->bc_ops->key_addr(cur, ptr + 1, block));
+		}
+#endif
+	} else {
+		/* It's a leaf. make a hole in the records */
+		union xfs_btree_rec		*rp;
+
+		rp = cur->bc_ops->rec_addr(cur, 1, block);
+		cur->bc_ops->move_recs(cur, rp, ptr - 1, ptr,
+				       numrecs - ptr + 1);
+
+		/* Now put the new data in, bump numrecs and log it. */
+		cur->bc_ops->set_rec(cur, rp, ptr - 1, recp);
+		numrecs++;
+		xfs_btree_set_numrecs(block, numrecs);
+		cur->bc_ops->log_recs(cur, bp, ptr, numrecs);
+#ifdef DEBUG
+		if (ptr < numrecs) {
+			xfs_btree_check_rec(cur->bc_btnum,
+				cur->bc_ops->rec_addr(cur, ptr, block),
+				cur->bc_ops->rec_addr(cur, ptr + 1, block));
+		}
+#endif
+	}
+
+	/* Log the new number of records in the btree header. */
+	xfs_btree_log_block(cur, bp, XFS_BB_NUMRECS);
+
+	/* If we inserted at the start of a block, update the parents' keys. */
+	if (optr == 1) {
+		error = xfs_btree_updkey(cur, &key, level + 1);
+		if (error)
+			goto error0;
+	}
+
+	/*
+	 * If we are tracking the last record in the tree and
+	 * we are at the far right edge of the tree, update it.
+	 */
+	if (xfs_btree_is_lastrec(cur, block, level)) {
+		cur->bc_ops->update_lastrec(cur, block, recp,
+					    ptr, LASTREC_INSREC);
+	}
+
+	/*
+	 * Return the new block number, if any.
+	 * If there is one, give back a record value and a cursor too.
+	 */
+	*ptrp = nptr;
+	if (!xfs_btree_ptr_is_null(cur, &nptr)) {
+		*recp = nrec;
+		*curp = ncur;
+	}
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
+/*
+ * Insert the record at the point referenced by cur.
+ *
+ * A multi-level split of the tree on insert will invalidate the original
+ * cursor.  All callers of this function should assume that the cursor is
+ * no longer valid and revalidate it.
+ */
+int
+xfs_btree_insert(
+	struct xfs_btree_cur	*cur,
+	int			*stat)
+{
+	int			error;	/* error return value */
+	int			i;	/* result value, 0 for failure */
+	int			level;	/* current level number in btree */
+	union xfs_btree_ptr	nptr;	/* new block number (split result) */
+	struct xfs_btree_cur	*ncur;	/* new cursor (split result) */
+	struct xfs_btree_cur	*pcur;	/* previous level's cursor */
+	union xfs_btree_rec	rec;	/* record to insert */
+
+	level = 0;
+	ncur = NULL;
+	pcur = cur;
+
+	xfs_btree_set_ptr_null(cur, &nptr);
+	cur->bc_ops->init_rec_from_cur(cur, &rec);
+
+	/*
+	 * Loop going up the tree, starting at the leaf level.
+	 * Stop when we don't get a split block, that must mean that
+	 * the insert is finished with this level.
+	 */
+	do {
+		/*
+		 * Insert nrec/nptr into this level of the tree.
+		 * Note if we fail, nptr will be null.
+		 */
+		error = xfs_btree_insrec(pcur, level, &nptr, &rec, &ncur, &i);
+		if (error) {
+			if (pcur != cur)
+				xfs_btree_del_cursor(pcur, XFS_BTREE_ERROR);
+			goto error0;
+		}
+
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		level++;
+
+		/*
+		 * See if the cursor we just used is trash.
+		 * Can't trash the caller's cursor, but otherwise we should
+		 * if ncur is a new cursor or we're about to be done.
+		 */
+		if (pcur != cur &&
+		    (ncur || xfs_btree_ptr_is_null(cur, &nptr))) {
+			/* Save the state from the cursor before we trash it */
+			if (cur->bc_ops->update_cursor)
+				cur->bc_ops->update_cursor(pcur, cur);
+			cur->bc_nlevels = pcur->bc_nlevels;
+			xfs_btree_del_cursor(pcur, XFS_BTREE_NOERROR);
+		}
+		/* If we got a new cursor, switch to it. */
+		if (ncur) {
+			pcur = ncur;
+			ncur = NULL;
+		}
+	} while (!xfs_btree_ptr_is_null(cur, &nptr));
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
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-08-03 15:57:58.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-08-03 16:04:53.000000000 +0200
@@ -587,256 +587,6 @@ error0:
 }
 
 /*
- * Insert one record/level.  Return information to the caller
- * allowing the next level up to proceed if necessary.
- */
-STATIC int				/* error */
-xfs_alloc_insrec(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level to insert record at */
-	xfs_agblock_t		*bnop,	/* i/o: block number inserted */
-	xfs_alloc_rec_t		*recp,	/* i/o: record data inserted */
-	xfs_btree_cur_t		**curp,	/* output: new cursor replacing cur */
-	int			*stat)	/* output: success/failure */
-{
-	xfs_agf_t		*agf;	/* allocation group freelist header */
-	xfs_alloc_block_t	*block;	/* btree block record/key lives in */
-	xfs_buf_t		*bp;	/* buffer for block */
-	int			error;	/* error return value */
-	int			i;	/* loop index */
-	xfs_alloc_key_t		key;	/* key value being inserted */
-	xfs_alloc_key_t		*kp;	/* pointer to btree keys */
-	xfs_agblock_t		nbno;	/* block number of allocated block */
-	xfs_btree_cur_t		*ncur;	/* new cursor to be used at next lvl */
-	xfs_alloc_key_t		nkey;	/* new key value, from split */
-	xfs_alloc_rec_t		nrec;	/* new record value, for caller */
-	int			numrecs;
-	int			optr;	/* old ptr value */
-	xfs_alloc_ptr_t		*pp;	/* pointer to btree addresses */
-	int			ptr;	/* index in btree block for this rec */
-	xfs_alloc_rec_t		*rp;	/* pointer to btree records */
-
-	ASSERT(be32_to_cpu(recp->ar_blockcount) > 0);
-
-	/*
-	 * GCC doesn't understand the (arguably complex) control flow in
-	 * this function and complains about uninitialized structure fields
-	 * without this.
-	 */
-	memset(&nrec, 0, sizeof(nrec));
-
-	/*
-	 * If we made it to the root level, allocate a new root block
-	 * and we're done.
-	 */
-	if (level >= cur->bc_nlevels) {
-		XFS_STATS_INC(xs_abt_insrec);
-		if ((error = xfs_btree_new_root(cur, &i)))
-			return error;
-		*bnop = NULLAGBLOCK;
-		*stat = i;
-		return 0;
-	}
-	/*
-	 * Make a key out of the record data to be inserted, and save it.
-	 */
-	key.ar_startblock = recp->ar_startblock;
-	key.ar_blockcount = recp->ar_blockcount;
-	optr = ptr = cur->bc_ptrs[level];
-	/*
-	 * If we're off the left edge, return failure.
-	 */
-	if (ptr == 0) {
-		*stat = 0;
-		return 0;
-	}
-	XFS_STATS_INC(xs_abt_insrec);
-	/*
-	 * Get pointers to the btree buffer and block.
-	 */
-	bp = cur->bc_bufs[level];
-	block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-	numrecs = be16_to_cpu(block->bb_numrecs);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, level, bp)))
-		return error;
-	/*
-	 * Check that the new entry is being inserted in the right place.
-	 */
-	if (ptr <= numrecs) {
-		if (level == 0) {
-			rp = XFS_ALLOC_REC_ADDR(block, ptr, cur);
-			xfs_btree_check_rec(cur->bc_btnum, recp, rp);
-		} else {
-			kp = XFS_ALLOC_KEY_ADDR(block, ptr, cur);
-			xfs_btree_check_key(cur->bc_btnum, &key, kp);
-		}
-	}
-#endif
-	nbno = NULLAGBLOCK;
-	ncur = NULL;
-	/*
-	 * If the block is full, we can't insert the new entry until we
-	 * make the block un-full.
-	 */
-	if (numrecs == XFS_ALLOC_BLOCK_MAXRECS(level, cur)) {
-		/*
-		 * First, try shifting an entry to the right neighbor.
-		 */
-		if ((error = xfs_btree_rshift(cur, level, &i)))
-			return error;
-		if (i) {
-			/* nothing */
-		}
-		/*
-		 * Next, try shifting an entry to the left neighbor.
-		 */
-		else {
-			if ((error = xfs_btree_lshift(cur, level, &i)))
-				return error;
-			if (i)
-				optr = ptr = cur->bc_ptrs[level];
-			else {
-				union xfs_btree_ptr bno = { .s = cpu_to_be32(nbno) };
-				/*
-				 * Next, try splitting the current block in
-				 * half. If this works we have to re-set our
-				 * variables because we could be in a
-				 * different block now.
-				 */
-				if ((error = xfs_btree_split(cur, level, &bno,
-						(union xfs_btree_key *)&nkey,
-						&ncur, &i)))
-					return error;
-				nbno = be32_to_cpu(bno.s);
-				if (i) {
-					bp = cur->bc_bufs[level];
-					block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-#ifdef DEBUG
-					if ((error =
-						xfs_btree_check_sblock(cur,
-							block, level, bp)))
-						return error;
-#endif
-					ptr = cur->bc_ptrs[level];
-					nrec.ar_startblock = nkey.ar_startblock;
-					nrec.ar_blockcount = nkey.ar_blockcount;
-				}
-				/*
-				 * Otherwise the insert fails.
-				 */
-				else {
-					*stat = 0;
-					return 0;
-				}
-			}
-		}
-	}
-	/*
-	 * At this point we know there's room for our new entry in the block
-	 * we're pointing at.
-	 */
-	numrecs = be16_to_cpu(block->bb_numrecs);
-	if (level > 0) {
-		/*
-		 * It's a non-leaf entry.  Make a hole for the new data
-		 * in the key and ptr regions of the block.
-		 */
-		kp = XFS_ALLOC_KEY_ADDR(block, 1, cur);
-		pp = XFS_ALLOC_PTR_ADDR(block, 1, cur);
-#ifdef DEBUG
-		for (i = numrecs; i >= ptr; i--) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(pp[i - 1]), level)))
-				return error;
-		}
-#endif
-		memmove(&kp[ptr], &kp[ptr - 1],
-			(numrecs - ptr + 1) * sizeof(*kp));
-		memmove(&pp[ptr], &pp[ptr - 1],
-			(numrecs - ptr + 1) * sizeof(*pp));
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sptr(cur, *bnop, level)))
-			return error;
-#endif
-		/*
-		 * Now stuff the new data in, bump numrecs and log the new data.
-		 */
-		kp[ptr - 1] = key;
-		pp[ptr - 1] = cpu_to_be32(*bnop);
-		numrecs++;
-		block->bb_numrecs = cpu_to_be16(numrecs);
-		xfs_alloc_log_keys(cur, bp, ptr, numrecs);
-		xfs_alloc_log_ptrs(cur, bp, ptr, numrecs);
-#ifdef DEBUG
-		if (ptr < numrecs)
-			xfs_btree_check_key(cur->bc_btnum, kp + ptr - 1,
-				kp + ptr);
-#endif
-	} else {
-		/*
-		 * It's a leaf entry.  Make a hole for the new record.
-		 */
-		rp = XFS_ALLOC_REC_ADDR(block, 1, cur);
-		memmove(&rp[ptr], &rp[ptr - 1],
-			(numrecs - ptr + 1) * sizeof(*rp));
-		/*
-		 * Now stuff the new record in, bump numrecs
-		 * and log the new data.
-		 */
-		rp[ptr - 1] = *recp;
-		numrecs++;
-		block->bb_numrecs = cpu_to_be16(numrecs);
-		xfs_alloc_log_recs(cur, bp, ptr, numrecs);
-#ifdef DEBUG
-		if (ptr < numrecs)
-			xfs_btree_check_rec(cur->bc_btnum, rp + ptr - 1,
-				rp + ptr);
-#endif
-	}
-	/*
-	 * Log the new number of records in the btree header.
-	 */
-	xfs_alloc_log_block(cur->bc_tp, bp, XFS_BB_NUMRECS);
-	/*
-	 * If we inserted at the start of a block, update the parents' keys.
-	 */
-	if (optr == 1 && (error = xfs_btree_updkey(cur, (union xfs_btree_key *)&key, level + 1)))
-		return error;
-	/*
-	 * Look to see if the longest extent in the allocation group
-	 * needs to be updated.
-	 */
-
-	agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
-	if (level == 0 &&
-	    cur->bc_btnum == XFS_BTNUM_CNT &&
-	    be32_to_cpu(block->bb_rightsib) == NULLAGBLOCK &&
-	    be32_to_cpu(recp->ar_blockcount) > be32_to_cpu(agf->agf_longest)) {
-		/*
-		 * If this is a leaf in the by-size btree and there
-		 * is no right sibling block and this block is bigger
-		 * than the previous longest block, update it.
-		 */
-		agf->agf_longest = recp->ar_blockcount;
-		cur->bc_mp->m_perag[be32_to_cpu(agf->agf_seqno)].pagf_longest
-			= be32_to_cpu(recp->ar_blockcount);
-		xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp,
-			XFS_AGF_LONGEST);
-	}
-	/*
-	 * Return the new block number, if any.
-	 * If there is one, give back a record value and a cursor too.
-	 */
-	*bnop = nbno;
-	if (nbno != NULLAGBLOCK) {
-		*recp = nrec;
-		*curp = ncur;
-	}
-	*stat = 1;
-	return 0;
-}
-
-/*
  * Log header fields from a btree block.
  */
 STATIC void
@@ -966,65 +716,6 @@ xfs_alloc_get_rec(
 	return 0;
 }
 
-/*
- * Insert the current record at the point referenced by cur.
- * The cursor may be inconsistent on return if splits have been done.
- */
-int					/* error */
-xfs_alloc_insert(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	int		*stat)		/* success/failure */
-{
-	int		error;		/* error return value */
-	int		i;		/* result value, 0 for failure */
-	int		level;		/* current level number in btree */
-	xfs_agblock_t	nbno;		/* new block number (split result) */
-	xfs_btree_cur_t	*ncur;		/* new cursor (split result) */
-	xfs_alloc_rec_t	nrec;		/* record being inserted this level */
-	xfs_btree_cur_t	*pcur;		/* previous level's cursor */
-
-	level = 0;
-	nbno = NULLAGBLOCK;
-	nrec.ar_startblock = cpu_to_be32(cur->bc_rec.a.ar_startblock);
-	nrec.ar_blockcount = cpu_to_be32(cur->bc_rec.a.ar_blockcount);
-	ncur = NULL;
-	pcur = cur;
-	/*
-	 * Loop going up the tree, starting at the leaf level.
-	 * Stop when we don't get a split block, that must mean that
-	 * the insert is finished with this level.
-	 */
-	do {
-		/*
-		 * Insert nrec/nbno into this level of the tree.
-		 * Note if we fail, nbno will be null.
-		 */
-		if ((error = xfs_alloc_insrec(pcur, level++, &nbno, &nrec, &ncur,
-				&i))) {
-			if (pcur != cur)
-				xfs_btree_del_cursor(pcur, XFS_BTREE_ERROR);
-			return error;
-		}
-		/*
-		 * See if the cursor we just used is trash.
-		 * Can't trash the caller's cursor, but otherwise we should
-		 * if ncur is a new cursor or we're about to be done.
-		 */
-		if (pcur != cur && (ncur || nbno == NULLAGBLOCK)) {
-			cur->bc_nlevels = pcur->bc_nlevels;
-			xfs_btree_del_cursor(pcur, XFS_BTREE_NOERROR);
-		}
-		/*
-		 * If we got a new cursor, switch to it.
-		 */
-		if (ncur) {
-			pcur = ncur;
-			ncur = NULL;
-		}
-	} while (nbno != NULLAGBLOCK);
-	*stat = i;
-	return 0;
-}
 
 STATIC struct xfs_btree_cur *
 xfs_allocbt_dup_cursor(
@@ -1117,6 +808,12 @@ xfs_allocbt_update_lastrec(
 			return;
 		len = rec->alloc.ar_blockcount;
 		break;
+	case LASTREC_INSREC:
+		if (be32_to_cpu(rec->alloc.ar_blockcount) <=
+		    be32_to_cpu(agf->agf_longest))
+			return;
+		len = rec->alloc.ar_blockcount;
+		break;
 	default:
 		ASSERT(0);
 		return;
@@ -1160,6 +857,28 @@ xfs_allocbt_init_ptr_from_cur(
 	ptr->s = agf->agf_roots[cur->bc_btnum];
 }
 
+STATIC void
+xfs_allocbt_init_rec_from_key(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	ASSERT(key->alloc.ar_startblock != 0);
+
+	rec->alloc.ar_startblock = key->alloc.ar_startblock;
+	rec->alloc.ar_blockcount = key->alloc.ar_blockcount;
+}
+
+STATIC void
+xfs_allocbt_init_rec_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
+{
+	ASSERT(cur->bc_rec.a.ar_startblock != 0);
+
+	rec->alloc.ar_startblock = cpu_to_be32(cur->bc_rec.a.ar_startblock);
+	rec->alloc.ar_blockcount = cpu_to_be32(cur->bc_rec.a.ar_blockcount);
+}
+
 STATIC union xfs_btree_ptr *
 xfs_allocbt_ptr_addr(
 	struct xfs_btree_cur	*cur,
@@ -1438,6 +1157,8 @@ static const struct xfs_btree_ops xfs_al
 	.get_maxrecs		= xfs_allocbt_get_maxrecs,
 	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
+	.init_rec_from_key	= xfs_allocbt_init_rec_from_key,
+	.init_rec_from_cur	= xfs_allocbt_init_rec_from_cur,
 	.ptr_addr		= xfs_allocbt_ptr_addr,
 	.key_addr		= xfs_allocbt_key_addr,
 	.rec_addr		= xfs_allocbt_rec_addr,
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-08-03 16:02:53.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-08-03 16:08:48.000000000 +0200
@@ -456,198 +456,6 @@ error0:
 	return error;
 }
 
-/*
- * Insert one record/level.  Return information to the caller
- * allowing the next level up to proceed if necessary.
- */
-STATIC int					/* error */
-xfs_bmbt_insrec(
-	xfs_btree_cur_t		*cur,
-	int			level,
-	xfs_fsblock_t		*bnop,
-	xfs_bmbt_rec_t		*recp,
-	xfs_btree_cur_t		**curp,
-	int			*stat)		/* no-go/done/continue */
-{
-	xfs_bmbt_block_t	*block;		/* bmap btree block */
-	xfs_buf_t		*bp;		/* buffer for block */
-	int			error;		/* error return value */
-	int			i;		/* loop index */
-	xfs_bmbt_key_t		key;		/* bmap btree key */
-	xfs_bmbt_key_t		*kp=NULL;	/* pointer to bmap btree key */
-	int			logflags;	/* inode logging flags */
-	xfs_fsblock_t		nbno;		/* new block number */
-	struct xfs_btree_cur	*ncur;		/* new btree cursor */
-	__uint64_t		startoff;	/* new btree key value */
-	xfs_bmbt_rec_t		nrec;		/* new record count */
-	int			optr;		/* old key/record index */
-	xfs_bmbt_ptr_t		*pp;		/* pointer to bmap block addr */
-	int			ptr;		/* key/record index */
-	xfs_bmbt_rec_t		*rp=NULL;	/* pointer to bmap btree rec */
-	int			numrecs;
-
-	ASSERT(level < cur->bc_nlevels);
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGIFR(cur, level, *bnop, recp);
-	ncur = NULL;
-	key.br_startoff = cpu_to_be64(xfs_bmbt_disk_get_startoff(recp));
-	optr = ptr = cur->bc_ptrs[level];
-	if (ptr == 0) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	XFS_STATS_INC(xs_bmbt_insrec);
-	block = xfs_bmbt_get_block(cur, level, &bp);
-	numrecs = be16_to_cpu(block->bb_numrecs);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_lblock(cur, block, level, bp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	if (ptr <= numrecs) {
-		if (level == 0) {
-			rp = XFS_BMAP_REC_IADDR(block, ptr, cur);
-			xfs_btree_check_rec(XFS_BTNUM_BMAP, recp, rp);
-		} else {
-			kp = XFS_BMAP_KEY_IADDR(block, ptr, cur);
-			xfs_btree_check_key(XFS_BTNUM_BMAP, &key, kp);
-		}
-	}
-#endif
-	nbno = NULLFSBLOCK;
-	if (numrecs == XFS_BMAP_BLOCK_IMAXRECS(level, cur)) {
-		if (numrecs < XFS_BMAP_BLOCK_DMAXRECS(level, cur)) {
-			/*
-			 * A root block, that can be made bigger.
-			 */
-			xfs_iroot_realloc(cur->bc_private.b.ip, 1,
-				cur->bc_private.b.whichfork);
-			block = xfs_bmbt_get_block(cur, level, &bp);
-		} else if (level == cur->bc_nlevels - 1) {
-			if ((error = xfs_btree_iroot_to_root(cur, &logflags, stat)) ||
-			    *stat == 0) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				return error;
-			}
-			xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
-				logflags);
-			block = xfs_bmbt_get_block(cur, level, &bp);
-		} else {
-			if ((error = xfs_btree_rshift(cur, level, &i))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				return error;
-			}
-			if (i) {
-				/* nothing */
-			} else {
-				if ((error = xfs_btree_lshift(cur, level, &i))) {
-					XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-					return error;
-				}
-				if (i) {
-					optr = ptr = cur->bc_ptrs[level];
-				} else {
-					union xfs_btree_ptr bno = { .l = cpu_to_be64(nbno) };
-					union xfs_btree_key skey;
-					if ((error = xfs_btree_split(cur, level,
-							&bno, &skey, &ncur,
-							&i))) {
-						XFS_BMBT_TRACE_CURSOR(cur,
-							ERROR);
-						return error;
-					}
-					nbno = be64_to_cpu(bno.l);
-					startoff = be64_to_cpu(skey.bmbt.br_startoff);
-					if (i) {
-						block = xfs_bmbt_get_block(
-							    cur, level, &bp);
-#ifdef DEBUG
-						if ((error =
-						    xfs_btree_check_lblock(cur,
-							    block, level, bp))) {
-							XFS_BMBT_TRACE_CURSOR(
-								cur, ERROR);
-							return error;
-						}
-#endif
-						ptr = cur->bc_ptrs[level];
-						xfs_bmbt_disk_set_allf(&nrec,
-							startoff, 0, 0,
-							XFS_EXT_NORM);
-					} else {
-						XFS_BMBT_TRACE_CURSOR(cur,
-							EXIT);
-						*stat = 0;
-						return 0;
-					}
-				}
-			}
-		}
-	}
-	numrecs = be16_to_cpu(block->bb_numrecs);
-	if (level > 0) {
-		kp = XFS_BMAP_KEY_IADDR(block, 1, cur);
-		pp = XFS_BMAP_PTR_IADDR(block, 1, cur);
-#ifdef DEBUG
-		for (i = numrecs; i >= ptr; i--) {
-			if ((error = xfs_btree_check_lptr_disk(cur, pp[i - 1],
-					level))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				return error;
-			}
-		}
-#endif
-		memmove(&kp[ptr], &kp[ptr - 1],
-			(numrecs - ptr + 1) * sizeof(*kp));
-		memmove(&pp[ptr], &pp[ptr - 1],
-			(numrecs - ptr + 1) * sizeof(*pp));
-#ifdef DEBUG
-		if ((error = xfs_btree_check_lptr(cur, *bnop, level))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-#endif
-		kp[ptr - 1] = key;
-		pp[ptr - 1] = cpu_to_be64(*bnop);
-		numrecs++;
-		block->bb_numrecs = cpu_to_be16(numrecs);
-		xfs_bmbt_log_keys(cur, bp, ptr, numrecs);
-		xfs_bmbt_log_ptrs(cur, bp, ptr, numrecs);
-	} else {
-		rp = XFS_BMAP_REC_IADDR(block, 1, cur);
-		memmove(&rp[ptr], &rp[ptr - 1],
-			(numrecs - ptr + 1) * sizeof(*rp));
-		rp[ptr - 1] = *recp;
-		numrecs++;
-		block->bb_numrecs = cpu_to_be16(numrecs);
-		xfs_bmbt_log_recs(cur, bp, ptr, numrecs);
-	}
-	xfs_bmbt_log_block(cur, bp, XFS_BB_NUMRECS);
-#ifdef DEBUG
-	if (ptr < numrecs) {
-		if (level == 0)
-			xfs_btree_check_rec(XFS_BTNUM_BMAP, rp + ptr - 1,
-				rp + ptr);
-		else
-			xfs_btree_check_key(XFS_BTNUM_BMAP, kp + ptr - 1,
-				kp + ptr);
-	}
-#endif
-	if (optr == 1 && (error = xfs_btree_updkey(cur, (union xfs_btree_key *)&key, level + 1))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	*bnop = nbno;
-	if (nbno != NULLFSBLOCK) {
-		*recp = nrec;
-		*curp = ncur;
-	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*stat = 1;
-	return 0;
-}
-
 STATIC int
 xfs_bmbt_killroot(
 	xfs_btree_cur_t		*cur)
@@ -1024,67 +832,6 @@ xfs_bmbt_disk_get_startoff(
 }
 
 /*
- * Insert the current record at the point referenced by cur.
- *
- * A multi-level split of the tree on insert will invalidate the original
- * cursor.  All callers of this function should assume that the cursor is
- * no longer valid and revalidate it.
- */
-int					/* error */
-xfs_bmbt_insert(
-	xfs_btree_cur_t	*cur,
-	int		*stat)		/* success/failure */
-{
-	int		error;		/* error return value */
-	int		i;
-	int		level;
-	xfs_fsblock_t	nbno;
-	xfs_btree_cur_t	*ncur;
-	xfs_bmbt_rec_t	nrec;
-	xfs_btree_cur_t	*pcur;
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	level = 0;
-	nbno = NULLFSBLOCK;
-	xfs_bmbt_disk_set_all(&nrec, &cur->bc_rec.b);
-	ncur = NULL;
-	pcur = cur;
-	do {
-		if ((error = xfs_bmbt_insrec(pcur, level++, &nbno, &nrec, &ncur,
-				&i))) {
-			if (pcur != cur)
-				xfs_btree_del_cursor(pcur, XFS_BTREE_ERROR);
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if (pcur != cur && (ncur || nbno == NULLFSBLOCK)) {
-			cur->bc_nlevels = pcur->bc_nlevels;
-			cur->bc_private.b.allocated +=
-				pcur->bc_private.b.allocated;
-			pcur->bc_private.b.allocated = 0;
-			ASSERT((cur->bc_private.b.firstblock != NULLFSBLOCK) ||
-			       XFS_IS_REALTIME_INODE(cur->bc_private.b.ip));
-			cur->bc_private.b.firstblock =
-				pcur->bc_private.b.firstblock;
-			ASSERT(cur->bc_private.b.flist ==
-			       pcur->bc_private.b.flist);
-			xfs_btree_del_cursor(pcur, XFS_BTREE_NOERROR);
-		}
-		if (ncur) {
-			pcur = ncur;
-			ncur = NULL;
-		}
-	} while (nbno != NULLFSBLOCK);
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*stat = i;
-	return 0;
-error0:
-	XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-	return error;
-}
-
-/*
  * Log fields from the btree block header.
  */
 void
@@ -1386,6 +1133,21 @@ xfs_bmbt_dup_cursor(
 	return new;
 }
 
+STATIC void
+xfs_bmbt_update_cursor(
+	struct xfs_btree_cur	*src,
+	struct xfs_btree_cur	*dst)
+{
+	ASSERT((dst->bc_private.b.firstblock != NULLFSBLOCK) ||
+	       (dst->bc_private.b.ip->i_d.di_flags & XFS_DIFLAG_REALTIME));
+	ASSERT(dst->bc_private.b.flist == src->bc_private.b.flist);
+
+	dst->bc_private.b.allocated += src->bc_private.b.allocated;
+	dst->bc_private.b.firstblock = src->bc_private.b.firstblock;
+
+	src->bc_private.b.allocated = 0;
+}
+
 STATIC int
 xfs_bmbt_alloc_block(
 	struct xfs_btree_cur	*cur,
@@ -1499,6 +1261,14 @@ xfs_bmbt_get_maxrecs(
 	return XFS_BMAP_BLOCK_IMAXRECS(level, cur);
 }
 
+STATIC int
+xfs_bmbt_get_dmaxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return XFS_BMAP_BLOCK_DMAXRECS(level, cur);
+}
+
 STATIC void
 xfs_bmbt_init_key_from_rec(
 	struct xfs_btree_cur	*cur,
@@ -1517,6 +1287,25 @@ xfs_bmbt_init_ptr_from_cur(
 	ptr->l = 0;
 }
 
+STATIC void
+xfs_bmbt_init_rec_from_key(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	ASSERT(key->bmbt.br_startoff != 0);
+
+	xfs_bmbt_disk_set_allf(&rec->bmbt, be64_to_cpu(key->bmbt.br_startoff),
+			       0, 0, XFS_EXT_NORM);
+}
+
+STATIC void
+xfs_bmbt_init_rec_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
+{
+	xfs_bmbt_disk_set_all(&rec->bmbt, &cur->bc_rec.b);
+}
+
 STATIC union xfs_btree_ptr *
 xfs_bmbt_ptr_addr(
 	struct xfs_btree_cur	*cur,
@@ -1778,12 +1567,16 @@ xfs_bmbt_trace_record(
 
 static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.dup_cursor		= xfs_bmbt_dup_cursor,
+	.update_cursor		= xfs_bmbt_update_cursor,
 	.get_root_from_inode	= xfs_bmbt_get_root_from_inode,
 	.realloc_root		= xfs_bmbt_realloc_root,
 	.alloc_block		= xfs_bmbt_alloc_block,
 	.init_key_from_rec	= xfs_bmbt_init_key_from_rec,
 	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
+	.init_rec_from_key	= xfs_bmbt_init_rec_from_key,
+	.init_rec_from_cur	= xfs_bmbt_init_rec_from_cur,
 	.get_maxrecs		= xfs_bmbt_get_maxrecs,
+	.get_dmaxrecs		= xfs_bmbt_get_dmaxrecs,
 	.ptr_addr		= xfs_bmbt_ptr_addr,
 	.key_addr		= xfs_bmbt_key_addr,
 	.rec_addr		= xfs_bmbt_rec_addr,
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-08-03 16:03:16.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-08-03 16:06:13.000000000 +0200
@@ -182,6 +182,8 @@ do {    \
 struct xfs_btree_ops {
 	/* cursor operations */
 	struct xfs_btree_cur *(*dup_cursor)(struct xfs_btree_cur *);
+	void	(*update_cursor)(struct xfs_btree_cur *src,
+				 struct xfs_btree_cur *dst);
 
 	/* btree root in inode support */
 	struct xfs_btree_block *(*get_root_from_inode)(struct xfs_btree_cur *);
@@ -213,6 +215,7 @@ struct xfs_btree_ops {
 
 	/* records in block/level */
 	int	(*get_maxrecs)(struct xfs_btree_cur *cur, int level);
+	int	(*get_dmaxrecs)(struct xfs_btree_cur *cur, int level);
 
 	/* init values of btree structures */
 	void	(*init_key_from_rec)(struct xfs_btree_cur *cur,
@@ -220,6 +223,10 @@ struct xfs_btree_ops {
 				     union xfs_btree_rec *rec);
 	void	(*init_ptr_from_cur)(struct xfs_btree_cur *cur,
 				     union xfs_btree_ptr *ptr);
+	void	(*init_rec_from_key)(union xfs_btree_key *key,
+				     union xfs_btree_rec *rec);
+	void	(*init_rec_from_cur)(struct xfs_btree_cur *cur,
+				     union xfs_btree_rec *rec);
 
 	/* difference between key value and cursor value */
 	__int64_t (*key_diff)(struct xfs_btree_cur *cur,
@@ -279,6 +286,7 @@ struct xfs_btree_ops {
  * Reasons for the update_lastrec method to be called.
  */
 #define LASTREC_UPDATE	0
+#define LASTREC_INSREC	1
 
 
 /*
@@ -588,6 +596,7 @@ int xfs_btree_split(struct xfs_btree_cur
 		union xfs_btree_key *, struct xfs_btree_cur **, int *);
 int xfs_btree_new_root(struct xfs_btree_cur *, int *);
 int xfs_btree_iroot_to_root(struct xfs_btree_cur *, int *, int *);
+int xfs_btree_insert(struct xfs_btree_cur *, int *);
 
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-08-03 15:57:58.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-08-03 16:04:53.000000000 +0200
@@ -515,228 +515,6 @@ error0:
 }
 
 /*
- * Insert one record/level.  Return information to the caller
- * allowing the next level up to proceed if necessary.
- */
-STATIC int				/* error */
-xfs_inobt_insrec(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level to insert record at */
-	xfs_agblock_t		*bnop,	/* i/o: block number inserted */
-	xfs_inobt_rec_t		*recp,	/* i/o: record data inserted */
-	xfs_btree_cur_t		**curp,	/* output: new cursor replacing cur */
-	int			*stat)	/* success/failure */
-{
-	xfs_inobt_block_t	*block;	/* btree block record/key lives in */
-	xfs_buf_t		*bp;	/* buffer for block */
-	int			error;	/* error return value */
-	int			i;	/* loop index */
-	xfs_inobt_key_t		key;	/* key value being inserted */
-	xfs_inobt_key_t		*kp=NULL;	/* pointer to btree keys */
-	xfs_agblock_t		nbno;	/* block number of allocated block */
-	xfs_btree_cur_t		*ncur;	/* new cursor to be used at next lvl */
-	xfs_inobt_key_t		nkey;	/* new key value, from split */
-	xfs_inobt_rec_t		nrec;	/* new record value, for caller */
-	int			numrecs;
-	int			optr;	/* old ptr value */
-	xfs_inobt_ptr_t		*pp;	/* pointer to btree addresses */
-	int			ptr;	/* index in btree block for this rec */
-	xfs_inobt_rec_t		*rp=NULL;	/* pointer to btree records */
-
-	/*
-	 * GCC doesn't understand the (arguably complex) control flow in
-	 * this function and complains about uninitialized structure fields
-	 * without this.
-	 */
-	memset(&nrec, 0, sizeof(nrec));
-
-	/*
-	 * If we made it to the root level, allocate a new root block
-	 * and we're done.
-	 */
-	if (level >= cur->bc_nlevels) {
-		error = xfs_btree_new_root(cur, &i);
-		*bnop = NULLAGBLOCK;
-		*stat = i;
-		return error;
-	}
-	/*
-	 * Make a key out of the record data to be inserted, and save it.
-	 */
-	key.ir_startino = recp->ir_startino;
-	optr = ptr = cur->bc_ptrs[level];
-	/*
-	 * If we're off the left edge, return failure.
-	 */
-	if (ptr == 0) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * Get pointers to the btree buffer and block.
-	 */
-	bp = cur->bc_bufs[level];
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-	numrecs = be16_to_cpu(block->bb_numrecs);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, level, bp)))
-		return error;
-	/*
-	 * Check that the new entry is being inserted in the right place.
-	 */
-	if (ptr <= numrecs) {
-		if (level == 0) {
-			rp = XFS_INOBT_REC_ADDR(block, ptr, cur);
-			xfs_btree_check_rec(cur->bc_btnum, recp, rp);
-		} else {
-			kp = XFS_INOBT_KEY_ADDR(block, ptr, cur);
-			xfs_btree_check_key(cur->bc_btnum, &key, kp);
-		}
-	}
-#endif
-	nbno = NULLAGBLOCK;
-	ncur = NULL;
-	/*
-	 * If the block is full, we can't insert the new entry until we
-	 * make the block un-full.
-	 */
-	if (numrecs == XFS_INOBT_BLOCK_MAXRECS(level, cur)) {
-		/*
-		 * First, try shifting an entry to the right neighbor.
-		 */
-		if ((error = xfs_btree_rshift(cur, level, &i)))
-			return error;
-		if (i) {
-			/* nothing */
-		}
-		/*
-		 * Next, try shifting an entry to the left neighbor.
-		 */
-		else {
-			if ((error = xfs_btree_lshift(cur, level, &i)))
-				return error;
-			if (i) {
-				optr = ptr = cur->bc_ptrs[level];
-			} else {
-				union xfs_btree_ptr bno = { .s = cpu_to_be32(nbno) };
-				/*
-				 * Next, try splitting the current block
-				 * in half. If this works we have to
-				 * re-set our variables because
-				 * we could be in a different block now.
-				 */
-				if ((error = xfs_btree_split(cur, level, &bno,
-						(union xfs_btree_key *)&nkey,
-						&ncur, &i)))
-					return error;
-				nbno = be32_to_cpu(bno.s);
-				if (i) {
-					bp = cur->bc_bufs[level];
-					block = XFS_BUF_TO_INOBT_BLOCK(bp);
-#ifdef DEBUG
-					if ((error = xfs_btree_check_sblock(cur,
-							block, level, bp)))
-						return error;
-#endif
-					ptr = cur->bc_ptrs[level];
-					nrec.ir_startino = nkey.ir_startino;
-				} else {
-					/*
-					 * Otherwise the insert fails.
-					 */
-					*stat = 0;
-					return 0;
-				}
-			}
-		}
-	}
-	/*
-	 * At this point we know there's room for our new entry in the block
-	 * we're pointing at.
-	 */
-	numrecs = be16_to_cpu(block->bb_numrecs);
-	if (level > 0) {
-		/*
-		 * It's a non-leaf entry.  Make a hole for the new data
-		 * in the key and ptr regions of the block.
-		 */
-		kp = XFS_INOBT_KEY_ADDR(block, 1, cur);
-		pp = XFS_INOBT_PTR_ADDR(block, 1, cur);
-#ifdef DEBUG
-		for (i = numrecs; i >= ptr; i--) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(pp[i - 1]), level)))
-				return error;
-		}
-#endif
-		memmove(&kp[ptr], &kp[ptr - 1],
-			(numrecs - ptr + 1) * sizeof(*kp));
-		memmove(&pp[ptr], &pp[ptr - 1],
-			(numrecs - ptr + 1) * sizeof(*pp));
-		/*
-		 * Now stuff the new data in, bump numrecs and log the new data.
-		 */
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sptr(cur, *bnop, level)))
-			return error;
-#endif
-		kp[ptr - 1] = key;
-		pp[ptr - 1] = cpu_to_be32(*bnop);
-		numrecs++;
-		block->bb_numrecs = cpu_to_be16(numrecs);
-		xfs_inobt_log_keys(cur, bp, ptr, numrecs);
-		xfs_inobt_log_ptrs(cur, bp, ptr, numrecs);
-	} else {
-		/*
-		 * It's a leaf entry.  Make a hole for the new record.
-		 */
-		rp = XFS_INOBT_REC_ADDR(block, 1, cur);
-		memmove(&rp[ptr], &rp[ptr - 1],
-			(numrecs - ptr + 1) * sizeof(*rp));
-		/*
-		 * Now stuff the new record in, bump numrecs
-		 * and log the new data.
-		 */
-		rp[ptr - 1] = *recp;
-		numrecs++;
-		block->bb_numrecs = cpu_to_be16(numrecs);
-		xfs_inobt_log_recs(cur, bp, ptr, numrecs);
-	}
-	/*
-	 * Log the new number of records in the btree header.
-	 */
-	xfs_inobt_log_block(cur->bc_tp, bp, XFS_BB_NUMRECS);
-#ifdef DEBUG
-	/*
-	 * Check that the key/record is in the right place, now.
-	 */
-	if (ptr < numrecs) {
-		if (level == 0)
-			xfs_btree_check_rec(cur->bc_btnum, rp + ptr - 1,
-				rp + ptr);
-		else
-			xfs_btree_check_key(cur->bc_btnum, kp + ptr - 1,
-				kp + ptr);
-	}
-#endif
-	/*
-	 * If we inserted at the start of a block, update the parents' keys.
-	 */
-	if (optr == 1 && (error = xfs_btree_updkey(cur, (union xfs_btree_key *)&key, level + 1)))
-		return error;
-	/*
-	 * Return the new block number, if any.
-	 * If there is one, give back a record value and a cursor too.
-	 */
-	*bnop = nbno;
-	if (nbno != NULLAGBLOCK) {
-		*recp = nrec;
-		*curp = ncur;
-	}
-	*stat = 1;
-	return 0;
-}
-
-/*
  * Log header fields from a btree block.
  */
 STATIC void
@@ -868,66 +646,6 @@ xfs_inobt_get_rec(
 	return 0;
 }
 
-/*
- * Insert the current record at the point referenced by cur.
- * The cursor may be inconsistent on return if splits have been done.
- */
-int					/* error */
-xfs_inobt_insert(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	int		*stat)		/* success/failure */
-{
-	int		error;		/* error return value */
-	int		i;		/* result value, 0 for failure */
-	int		level;		/* current level number in btree */
-	xfs_agblock_t	nbno;		/* new block number (split result) */
-	xfs_btree_cur_t	*ncur;		/* new cursor (split result) */
-	xfs_inobt_rec_t	nrec;		/* record being inserted this level */
-	xfs_btree_cur_t	*pcur;		/* previous level's cursor */
-
-	level = 0;
-	nbno = NULLAGBLOCK;
-	nrec.ir_startino = cpu_to_be32(cur->bc_rec.i.ir_startino);
-	nrec.ir_freecount = cpu_to_be32(cur->bc_rec.i.ir_freecount);
-	nrec.ir_free = cpu_to_be64(cur->bc_rec.i.ir_free);
-	ncur = NULL;
-	pcur = cur;
-	/*
-	 * Loop going up the tree, starting at the leaf level.
-	 * Stop when we don't get a split block, that must mean that
-	 * the insert is finished with this level.
-	 */
-	do {
-		/*
-		 * Insert nrec/nbno into this level of the tree.
-		 * Note if we fail, nbno will be null.
-		 */
-		if ((error = xfs_inobt_insrec(pcur, level++, &nbno, &nrec, &ncur,
-				&i))) {
-			if (pcur != cur)
-				xfs_btree_del_cursor(pcur, XFS_BTREE_ERROR);
-			return error;
-		}
-		/*
-		 * See if the cursor we just used is trash.
-		 * Can't trash the caller's cursor, but otherwise we should
-		 * if ncur is a new cursor or we're about to be done.
-		 */
-		if (pcur != cur && (ncur || nbno == NULLAGBLOCK)) {
-			cur->bc_nlevels = pcur->bc_nlevels;
-			xfs_btree_del_cursor(pcur, XFS_BTREE_NOERROR);
-		}
-		/*
-		 * If we got a new cursor, switch to it.
-		 */
-		if (ncur) {
-			pcur = ncur;
-			ncur = NULL;
-		}
-	} while (nbno != NULLAGBLOCK);
-	*stat = i;
-	return 0;
-}
 
 STATIC struct xfs_btree_cur *
 xfs_inobt_dup_cursor(
@@ -1025,6 +743,24 @@ xfs_inobt_init_ptr_from_cur(
 	ptr->s = agi->agi_root;
 }
 
+STATIC void
+xfs_inobt_init_rec_from_key(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	rec->inobt.ir_startino = key->inobt.ir_startino;
+}
+
+STATIC void
+xfs_inobt_init_rec_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
+{
+	rec->inobt.ir_startino = cpu_to_be32(cur->bc_rec.i.ir_startino);
+	rec->inobt.ir_freecount = cpu_to_be32(cur->bc_rec.i.ir_freecount);
+	rec->inobt.ir_free = cpu_to_be64(cur->bc_rec.i.ir_free);
+}
+
 STATIC union xfs_btree_ptr *
 xfs_inobt_ptr_addr(
 	struct xfs_btree_cur	*cur,
@@ -1268,6 +1004,8 @@ static const struct xfs_btree_ops xfs_in
 	.get_maxrecs		= xfs_inobt_get_maxrecs,
 	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
+	.init_rec_from_key	= xfs_inobt_init_rec_from_key,
+	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
 	.ptr_addr		= xfs_inobt_ptr_addr,
 	.key_addr		= xfs_inobt_key_addr,
 	.rec_addr		= xfs_inobt_rec_addr,
Index: linux-2.6-xfs/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc.c	2008-08-03 15:57:58.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc.c	2008-08-03 16:04:53.000000000 +0200
@@ -408,7 +408,7 @@ xfs_alloc_fixup_trees(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, nfbno1, nflen1, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 0);
-		if ((error = xfs_alloc_insert(cnt_cur, &i)))
+		if ((error = xfs_btree_insert(cnt_cur, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 1);
 	}
@@ -416,7 +416,7 @@ xfs_alloc_fixup_trees(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, nfbno2, nflen2, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 0);
-		if ((error = xfs_alloc_insert(cnt_cur, &i)))
+		if ((error = xfs_btree_insert(cnt_cur, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 1);
 	}
@@ -444,7 +444,7 @@ xfs_alloc_fixup_trees(
 		if ((error = xfs_alloc_lookup_eq(bno_cur, nfbno2, nflen2, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 0);
-		if ((error = xfs_alloc_insert(bno_cur, &i)))
+		if ((error = xfs_btree_insert(bno_cur, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 1);
 	}
@@ -1756,7 +1756,7 @@ xfs_free_ag_extent(
 	else {
 		nbno = bno;
 		nlen = len;
-		if ((error = xfs_alloc_insert(bno_cur, &i)))
+		if ((error = xfs_btree_insert(bno_cur, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 	}
@@ -1768,7 +1768,7 @@ xfs_free_ag_extent(
 	if ((error = xfs_alloc_lookup_eq(cnt_cur, nbno, nlen, &i)))
 		goto error0;
 	XFS_WANT_CORRUPTED_GOTO(i == 0, error0);
-	if ((error = xfs_alloc_insert(cnt_cur, &i)))
+	if ((error = xfs_btree_insert(cnt_cur, &i)))
 		goto error0;
 	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.h	2008-08-03 15:57:58.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h	2008-08-03 16:04:53.000000000 +0200
@@ -107,12 +107,6 @@ extern int xfs_alloc_delete(struct xfs_b
 extern int xfs_alloc_get_rec(struct xfs_btree_cur *cur,	xfs_agblock_t *bno,
 				xfs_extlen_t *len, int *stat);
 
-/*
- * Insert the current record at the point referenced by cur.
- * The cursor may be inconsistent on return if splits have been done.
- */
-extern int xfs_alloc_insert(struct xfs_btree_cur *cur, int *stat);
-
 
 extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *,
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-08-03 16:03:02.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-08-03 16:04:53.000000000 +0200
@@ -977,7 +977,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
@@ -1053,7 +1053,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
@@ -1143,7 +1143,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
@@ -1198,7 +1198,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
@@ -1651,7 +1651,7 @@ xfs_bmap_add_extent_unwritten_real(
 				oldext)))
 				goto done;
 			cur->bc_rec.b = *new;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
@@ -1741,7 +1741,7 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
@@ -1789,7 +1789,7 @@ xfs_bmap_add_extent_unwritten_real(
 			cur->bc_rec.b = PREV;
 			cur->bc_rec.b.br_blockcount =
 				new->br_startoff - PREV.br_startoff;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			/*
@@ -1804,7 +1804,7 @@ xfs_bmap_add_extent_unwritten_real(
 			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			/* new middle extent - newext */
 			cur->bc_rec.b.br_state = new->br_state;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
@@ -2264,7 +2264,7 @@ xfs_bmap_add_extent_hole_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			cur->bc_rec.b.br_state = new->br_state;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
@@ -3303,7 +3303,7 @@ xfs_bmap_del_extent(
 				if ((error = xfs_btree_increment(cur, 0, &i)))
 					goto done;
 				cur->bc_rec.b = new;
-				error = xfs_bmbt_insert(cur, &i);
+				error = xfs_btree_insert(cur, &i);
 				if (error && error != ENOSPC)
 					goto done;
 				/*
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.h	2008-08-03 16:01:30.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h	2008-08-03 16:04:53.000000000 +0200
@@ -250,7 +250,6 @@ extern void xfs_bmbt_disk_get_all(xfs_bm
 extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(xfs_bmbt_rec_t *r);
 extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(xfs_bmbt_rec_t *r);
 
-extern int xfs_bmbt_insert(struct xfs_btree_cur *, int *);
 extern void xfs_bmbt_log_block(struct xfs_btree_cur *, struct xfs_buf *, int);
 extern void xfs_bmbt_log_recs(struct xfs_btree_cur *, struct xfs_buf *, int,
 				int);
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c	2008-08-03 15:57:58.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c	2008-08-03 16:04:53.000000000 +0200
@@ -418,7 +418,7 @@ xfs_ialloc_ag_alloc(
 			return error;
 		}
 		ASSERT(i == 0);
-		if ((error = xfs_inobt_insert(cur, &i))) {
+		if ((error = xfs_btree_insert(cur, &i))) {
 			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 			return error;
 		}
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.h	2008-08-03 15:57:58.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h	2008-08-03 16:04:53.000000000 +0200
@@ -129,12 +129,6 @@ extern int xfs_inobt_delete(struct xfs_b
 extern int xfs_inobt_get_rec(struct xfs_btree_cur *cur, xfs_agino_t *ino,
 			     __int32_t *fcnt, xfs_inofree_t *free, int *stat);
 
-/*
- * Insert the current record at the point referenced by cur.
- * The cursor may be inconsistent on return if splits have been done.
- */
-extern int xfs_inobt_insert(struct xfs_btree_cur *cur, int *stat);
-
 
 extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t);

-- 
