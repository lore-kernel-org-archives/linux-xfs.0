Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 12:30:47 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6TJURFr032760
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:30:30 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DE9D1947DC0
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:31:36 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id lZEENjion2EsdT7k for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:31:36 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6TJVbIF019381
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 21:31:37 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6TJVbb2019379
	for xfs@oss.sgi.com; Tue, 29 Jul 2008 21:31:37 +0200
Date: Tue, 29 Jul 2008 21:31:37 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/21] implement generic xfs_btree_split
Message-ID: <20080729193137.GR19104@lst.de>
References: <20080729192113.493074843@verein.lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename=xfs-common-btree-split
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Make the btree split code generic.  Based on a patch from David Chinner
with lots of changes to follow the original btree implementations more
closely.  While this loses some of the generic helper routines for
inserting/moving/removing records it also solves some of the one off
bugs in the original code and makes it easier to verify.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-07-29 16:48:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-07-29 16:49:06.000000000 +0200
@@ -844,6 +844,48 @@ xfs_btree_get_sibling(
 	}
 }
 
+STATIC void
+xfs_btree_set_sibling(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	union xfs_btree_ptr	*ptr,
+	int			lr)
+{
+	ASSERT(lr == XFS_BB_LEFTSIB || lr == XFS_BB_RIGHTSIB);
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		if (lr == XFS_BB_RIGHTSIB)
+			block->bb_u.l.bb_rightsib = ptr->l;
+		else
+			block->bb_u.l.bb_leftsib = ptr->l;
+	} else {
+		if (lr == XFS_BB_RIGHTSIB)
+			block->bb_u.s.bb_rightsib = ptr->s;
+		else
+			block->bb_u.s.bb_leftsib = ptr->s;
+	}
+}
+
+STATIC void
+xfs_btree_init_block(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	int			numrecs,
+	struct xfs_btree_block	*new)	/* new block */
+{
+	new->bb_h.bb_magic = cpu_to_be32(xfs_magics[cur->bc_btnum]);
+	new->bb_h.bb_level = cpu_to_be16(level);
+	new->bb_h.bb_numrecs = cpu_to_be16(numrecs);
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		new->bb_u.l.bb_leftsib = cpu_to_be64(NULLFSBLOCK);
+		new->bb_u.l.bb_rightsib = cpu_to_be64(NULLFSBLOCK);
+	} else {
+		new->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
+		new->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
+	}
+}
+
 /*
  * Return true if ptr is the last record in the btree and
  * we need to track updateѕ to this record.  The decision
@@ -880,6 +922,21 @@ xfs_btree_buf_to_block(
 	return XFS_BUF_TO_BLOCK(bp);
 }
 
+STATIC void
+xfs_btree_buf_to_ptr(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp,
+	union xfs_btree_ptr	*ptr)
+{
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		ptr->l = cpu_to_be64(XFS_DADDR_TO_FSB(cur->bc_mp,
+					XFS_BUF_ADDR(bp)));
+	else {
+		ptr->s = cpu_to_be32(XFS_DADDR_TO_AGBNO(cur->bc_mp,
+					XFS_BUF_ADDR(bp)));
+	}
+}
+
 STATIC xfs_daddr_t
 xfs_btree_ptr_to_daddr(
 	struct xfs_btree_cur	*cur,
@@ -919,6 +976,31 @@ xfs_btree_set_refs(
 	}
 }
 
+STATIC int
+xfs_btree_get_buf_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	int			flags,
+	struct xfs_btree_block	**block,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	xfs_daddr_t		d;
+
+	/* need to sort out how callers deal with failures first */
+	ASSERT(!(flags & XFS_BUF_TRYLOCK));
+
+	d = xfs_btree_ptr_to_daddr(cur, ptr);
+	*bpp = xfs_trans_get_buf(cur->bc_tp, mp->m_ddev_targp, d,
+				 mp->m_bsize, flags);
+
+	ASSERT(*bpp);
+	ASSERT(!XFS_BUF_GETERROR(*bpp));
+
+	*block = XFS_BUF_TO_BLOCK(*bpp);
+	return 0;
+}
+
 /*
  * Read in the buffer at the given ptr and return the buffer and
  * the block pointer within the buffer.
@@ -1968,3 +2050,189 @@ error1:
 	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
 	return error;
 }
+
+/*
+ * Split cur/level block in half.
+ * Return new block number and the key to its first
+ * record (to be inserted into parent).
+ */
+int						/* error */
+xfs_btree_split(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	union xfs_btree_ptr	*ptrp,
+	union xfs_btree_key	*key,
+	struct xfs_btree_cur	**curp,
+	int			*stat)		/* success/failure */
+{
+	union xfs_btree_ptr	lptr;		/* left sibling block ptr */
+	struct xfs_buf		*lbp;		/* left buffer pointer */
+	struct xfs_btree_block	*left;		/* left btree block */
+	union xfs_btree_ptr	rptr;		/* right sibling block ptr */
+	struct xfs_buf		*rbp;		/* right buffer pointer */
+	struct xfs_btree_block	*right;		/* right btree block */
+	union xfs_btree_ptr	rrptr;		/* right-right sibling ptr */
+	struct xfs_buf		*rrbp;		/* right-right buffer pointer */
+	struct xfs_btree_block	*rrblock;	/* right-right btree block */
+	int			lrecs;
+	int			rrecs;
+	int			src_index;
+	int			error;		/* error return value */
+#ifdef DEBUG
+	int			i;
+#endif
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGIPK(cur, level, *ptrp, key);
+
+	XFS_BTREE_STATS_INC(cur, split);
+
+	/* Set up left block (current one). */
+	left = xfs_btree_get_block(cur, level, &lbp);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, left, level, lbp);
+	if (error)
+		goto error0;
+#endif
+
+	xfs_btree_buf_to_ptr(cur, lbp, &lptr);
+
+	/* Allocate the new block. If we can't do it, we're toast. Give up. */
+	error = cur->bc_ops->alloc_block(cur, &lptr, &rptr, 1, stat);
+	if (error)
+		goto error0;
+	if (*stat == 0)
+		goto out0;
+	XFS_BTREE_STATS_INC(cur, alloc);
+
+	/* Set up the new block as "right". */
+	error = xfs_btree_get_buf_block(cur, &rptr, 0, &right, &rbp);
+	if (error)
+		goto error0;
+
+	/* Fill in the btree header for the new right block. */
+	xfs_btree_init_block(cur, be16_to_cpu(left->bb_h.bb_level), 0, right);
+
+	/*
+	 * Split the entries between the old and the new block evenly.
+	 * Make sure that if there's an odd number of entries now, that
+	 * each new block will have the same number of entries.
+	 */
+	lrecs = xfs_btree_get_numrecs(left);
+	rrecs = lrecs / 2;
+	if ((lrecs & 1) && cur->bc_ptrs[level] <= rrecs + 1)
+		rrecs++;
+	src_index = (lrecs - rrecs + 1);
+
+	XFS_BTREE_STATS_ADD(cur, moves, rrecs);
+
+	/*
+	 * Copy btree block entries from the left block over to the
+	 * new block, the right. Update the right block and log the
+	 * changes.
+	 */
+	if (level > 0) {
+		/* It's a non-leaf.  Move keys and pointers. */
+		union xfs_btree_key	*lkp;	/* left btree key */
+		union xfs_btree_ptr	*lpp;	/* left address pointer */
+		union xfs_btree_key	*rkp;	/* right btree key */
+		union xfs_btree_ptr	*rpp;	/* right address pointer */
+
+		lkp = cur->bc_ops->key_addr(cur, src_index, left);
+		lpp = cur->bc_ops->ptr_addr(cur, src_index, left);
+		rkp = cur->bc_ops->key_addr(cur, 1, right);
+		rpp = cur->bc_ops->ptr_addr(cur, 1, right);
+
+#ifdef DEBUG
+		for (i = src_index; i < rrecs; i++) {
+			error = xfs_btree_check_ptr(cur, lpp, i, level);
+			if (error)
+				goto error0;
+		}
+#endif
+
+		cur->bc_ops->copy_keys(cur, lkp, rkp, rrecs);
+		xfs_btree_copy_ptrs(cur, lpp, rpp, rrecs);
+
+		cur->bc_ops->log_keys(cur, rbp, 1, rrecs);
+		xfs_btree_log_ptrs(cur, rbp, 1, rrecs);
+
+		/* Grab the keys to the entries moved to the right block */
+		cur->bc_ops->copy_keys(cur, rkp, key, 1);
+	} else {
+		/* It's a leaf.  Move records.  */
+		union xfs_btree_rec	*lrp;	/* left record pointer */
+		union xfs_btree_rec	*rrp;	/* right record pointer */
+
+		lrp = cur->bc_ops->rec_addr(cur, src_index, left);
+		rrp = cur->bc_ops->rec_addr(cur, 1, right);
+
+		cur->bc_ops->copy_recs(cur, lrp, rrp, rrecs);
+		cur->bc_ops->log_recs(cur, rbp, 1, rrecs);
+
+		cur->bc_ops->init_key_from_rec(cur, key,
+			cur->bc_ops->rec_addr(cur, 1, right));
+	}
+
+
+	/*
+	 * Find the left block number by looking in the buffer.
+	 * Adjust numrecs, sibling pointers.
+	 */
+	xfs_btree_get_sibling(cur, left, &rrptr, XFS_BB_RIGHTSIB);
+	xfs_btree_set_sibling(cur, right, &rrptr, XFS_BB_RIGHTSIB);
+	xfs_btree_set_sibling(cur, right, &lptr, XFS_BB_LEFTSIB);
+	xfs_btree_set_sibling(cur, left, &rptr, XFS_BB_RIGHTSIB);
+
+	lrecs -= rrecs;
+	xfs_btree_set_numrecs(left, lrecs);
+	xfs_btree_set_numrecs(right, xfs_btree_get_numrecs(right) + rrecs);
+
+	xfs_btree_log_block(cur, rbp, XFS_BB_ALL_BITS);
+	xfs_btree_log_block(cur, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
+
+	/*
+	 * If there's a block to the new block's right, make that block
+	 * point back to right instead of to left.
+	 */
+	if (!xfs_btree_ptr_is_null(cur, &rrptr)) {
+		error = xfs_btree_read_buf_block(cur, &rrptr, level,
+							0, &rrblock, &rrbp);
+		if (error)
+			goto error0;
+		xfs_btree_set_sibling(cur, rrblock, &rptr, XFS_BB_LEFTSIB);
+		xfs_btree_log_block(cur, rrbp, XFS_BB_LEFTSIB);
+	}
+	/*
+	 * If the cursor is really in the right block, move it there.
+	 * If it's just pointing past the last entry in left, then we'll
+	 * insert there, so don't change anything in that case.
+	 */
+	if (cur->bc_ptrs[level] > lrecs + 1) {
+		xfs_btree_setbuf(cur, level, rbp);
+		cur->bc_ptrs[level] -= lrecs;
+	}
+	/*
+	 * If there are more levels, we'll need another cursor which refers
+	 * the right block, no matter where this cursor was.
+	 */
+	if (level + 1 < cur->bc_nlevels) {
+		error = xfs_btree_dup_cursor(cur, curp);
+		if (error)
+			goto error0;
+		(*curp)->bc_ptrs[level + 1]++;
+	}
+	*ptrp = rptr;
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+out0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 0;
+	return 0;
+
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-07-29 16:48:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-07-29 16:48:46.000000000 +0200
@@ -191,6 +191,12 @@ struct xfs_btree_ops {
 	/* get inode rooted btree root */
 	struct xfs_btree_block *(*get_root_from_inode)(struct xfs_btree_cur *);
 
+	/* block allocation / freeing */
+	int	(*alloc_block)(struct xfs_btree_cur *cur,
+			       union xfs_btree_ptr *sbno,
+			       union xfs_btree_ptr *nbno,
+			       int length, int *stat);
+
 	/* updated last record information */
 	void	(*update_lastrec)(struct xfs_btree_cur *,
 				  struct xfs_btree_block *,
@@ -577,6 +583,8 @@ int xfs_btree_updkey(struct xfs_btree_cu
 int xfs_btree_update(struct xfs_btree_cur *, union xfs_btree_rec *);
 int xfs_btree_lshift(struct xfs_btree_cur *, int, int *);
 int xfs_btree_rshift(struct xfs_btree_cur *, int, int *);
+int xfs_btree_split(struct xfs_btree_cur *, int, union xfs_btree_ptr *,
+		union xfs_btree_key *, struct xfs_btree_cur **, int *);
 
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-07-29 16:48:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-07-29 16:48:46.000000000 +0200
@@ -53,8 +53,6 @@ STATIC void xfs_allocbt_log_recs(xfs_btr
 #define xfs_alloc_log_recs(c, b, i, j) \
 	xfs_allocbt_log_recs(c, b, i, j)
 STATIC int xfs_alloc_newroot(xfs_btree_cur_t *, int *);
-STATIC int xfs_alloc_split(xfs_btree_cur_t *, int, xfs_agblock_t *,
-		xfs_alloc_key_t *, xfs_btree_cur_t **, int *);
 
 /*
  * Internal functions.
@@ -700,15 +698,18 @@ xfs_alloc_insrec(
 			if (i)
 				optr = ptr = cur->bc_ptrs[level];
 			else {
+				union xfs_btree_ptr bno = { .s = cpu_to_be32(nbno) };
 				/*
 				 * Next, try splitting the current block in
 				 * half. If this works we have to re-set our
 				 * variables because we could be in a
 				 * different block now.
 				 */
-				if ((error = xfs_alloc_split(cur, level, &nbno,
-						&nkey, &ncur, &i)))
+				if ((error = xfs_btree_split(cur, level, &bno,
+						(union xfs_btree_key *)&nkey,
+						&ncur, &i)))
 					return error;
+				nbno = be32_to_cpu(bno.s);
 				if (i) {
 					bp = cur->bc_bufs[level];
 					block = XFS_BUF_TO_ALLOC_BLOCK(bp);
@@ -1037,160 +1038,6 @@ xfs_alloc_newroot(
 	return 0;
 }
 
-/*
- * Split cur/level block in half.
- * Return new block number and its first record (to be inserted into parent).
- */
-STATIC int				/* error */
-xfs_alloc_split(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level to split */
-	xfs_agblock_t		*bnop,	/* output: block number allocated */
-	xfs_alloc_key_t		*keyp,	/* output: first key of new block */
-	xfs_btree_cur_t		**curp,	/* output: new cursor */
-	int			*stat)	/* success/failure */
-{
-	int			error;	/* error return value */
-	int			i;	/* loop index/record number */
-	xfs_agblock_t		lbno;	/* left (current) block number */
-	xfs_buf_t		*lbp;	/* buffer for left block */
-	xfs_alloc_block_t	*left;	/* left (current) btree block */
-	xfs_agblock_t		rbno;	/* right (new) block number */
-	xfs_buf_t		*rbp;	/* buffer for right block */
-	xfs_alloc_block_t	*right;	/* right (new) btree block */
-
-	/*
-	 * Allocate the new block from the freelist.
-	 * If we can't do it, we're toast.  Give up.
-	 */
-	error = xfs_alloc_get_freelist(cur->bc_tp,
-					 cur->bc_private.a.agbp, &rbno, 1);
-	if (error)
-		return error;
-	if (rbno == NULLAGBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	xfs_trans_agbtree_delta(cur->bc_tp, 1);
-	rbp = xfs_btree_get_bufs(cur->bc_mp, cur->bc_tp, cur->bc_private.a.agno,
-		rbno, 0);
-	/*
-	 * Set up the new block as "right".
-	 */
-	right = XFS_BUF_TO_ALLOC_BLOCK(rbp);
-	/*
-	 * "Left" is the current (according to the cursor) block.
-	 */
-	lbp = cur->bc_bufs[level];
-	left = XFS_BUF_TO_ALLOC_BLOCK(lbp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
-		return error;
-#endif
-	/*
-	 * Fill in the btree header for the new block.
-	 */
-	right->bb_magic = cpu_to_be32(xfs_magics[cur->bc_btnum]);
-	right->bb_level = left->bb_level;
-	right->bb_numrecs = cpu_to_be16(be16_to_cpu(left->bb_numrecs) / 2);
-	/*
-	 * Make sure that if there's an odd number of entries now, that
-	 * each new block will have the same number of entries.
-	 */
-	if ((be16_to_cpu(left->bb_numrecs) & 1) &&
-	    cur->bc_ptrs[level] <= be16_to_cpu(right->bb_numrecs) + 1)
-		be16_add(&right->bb_numrecs, 1);
-	i = be16_to_cpu(left->bb_numrecs) - be16_to_cpu(right->bb_numrecs) + 1;
-	/*
-	 * For non-leaf blocks, copy keys and addresses over to the new block.
-	 */
-	if (level > 0) {
-		xfs_alloc_key_t	*lkp;	/* left btree key pointer */
-		xfs_alloc_ptr_t	*lpp;	/* left btree address pointer */
-		xfs_alloc_key_t	*rkp;	/* right btree key pointer */
-		xfs_alloc_ptr_t	*rpp;	/* right btree address pointer */
-
-		lkp = XFS_ALLOC_KEY_ADDR(left, i, cur);
-		lpp = XFS_ALLOC_PTR_ADDR(left, i, cur);
-		rkp = XFS_ALLOC_KEY_ADDR(right, 1, cur);
-		rpp = XFS_ALLOC_PTR_ADDR(right, 1, cur);
-#ifdef DEBUG
-		for (i = 0; i < be16_to_cpu(right->bb_numrecs); i++) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(lpp[i]), level)))
-				return error;
-		}
-#endif
-		memcpy(rkp, lkp, be16_to_cpu(right->bb_numrecs) * sizeof(*rkp));
-		memcpy(rpp, lpp, be16_to_cpu(right->bb_numrecs) * sizeof(*rpp));
-		xfs_alloc_log_keys(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		xfs_alloc_log_ptrs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		*keyp = *rkp;
-	}
-	/*
-	 * For leaf blocks, copy records over to the new block.
-	 */
-	else {
-		xfs_alloc_rec_t	*lrp;	/* left btree record pointer */
-		xfs_alloc_rec_t	*rrp;	/* right btree record pointer */
-
-		lrp = XFS_ALLOC_REC_ADDR(left, i, cur);
-		rrp = XFS_ALLOC_REC_ADDR(right, 1, cur);
-		memcpy(rrp, lrp, be16_to_cpu(right->bb_numrecs) * sizeof(*rrp));
-		xfs_alloc_log_recs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		keyp->ar_startblock = rrp->ar_startblock;
-		keyp->ar_blockcount = rrp->ar_blockcount;
-	}
-	/*
-	 * Find the left block number by looking in the buffer.
-	 * Adjust numrecs, sibling pointers.
-	 */
-	lbno = XFS_DADDR_TO_AGBNO(cur->bc_mp, XFS_BUF_ADDR(lbp));
-	be16_add(&left->bb_numrecs, -(be16_to_cpu(right->bb_numrecs)));
-	right->bb_rightsib = left->bb_rightsib;
-	left->bb_rightsib = cpu_to_be32(rbno);
-	right->bb_leftsib = cpu_to_be32(lbno);
-	xfs_alloc_log_block(cur->bc_tp, rbp, XFS_BB_ALL_BITS);
-	xfs_alloc_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
-	/*
-	 * If there's a block to the new block's right, make that block
-	 * point back to right instead of to left.
-	 */
-	if (be32_to_cpu(right->bb_rightsib) != NULLAGBLOCK) {
-		xfs_alloc_block_t	*rrblock;	/* rr btree block */
-		xfs_buf_t		*rrbp;		/* buffer for rrblock */
-
-		if ((error = xfs_btree_read_bufs(cur->bc_mp, cur->bc_tp,
-				cur->bc_private.a.agno, be32_to_cpu(right->bb_rightsib), 0,
-				&rrbp, XFS_ALLOC_BTREE_REF)))
-			return error;
-		rrblock = XFS_BUF_TO_ALLOC_BLOCK(rrbp);
-		if ((error = xfs_btree_check_sblock(cur, rrblock, level, rrbp)))
-			return error;
-		rrblock->bb_leftsib = cpu_to_be32(rbno);
-		xfs_alloc_log_block(cur->bc_tp, rrbp, XFS_BB_LEFTSIB);
-	}
-	/*
-	 * If the cursor is really in the right block, move it there.
-	 * If it's just pointing past the last entry in left, then we'll
-	 * insert there, so don't change anything in that case.
-	 */
-	if (cur->bc_ptrs[level] > be16_to_cpu(left->bb_numrecs) + 1) {
-		xfs_btree_setbuf(cur, level, rbp);
-		cur->bc_ptrs[level] -= be16_to_cpu(left->bb_numrecs);
-	}
-	/*
-	 * If there are more levels, we'll need another cursor which refers to
-	 * the right block, no matter where this cursor was.
-	 */
-	if (level + 1 < cur->bc_nlevels) {
-		if ((error = xfs_btree_dup_cursor(cur, curp)))
-			return error;
-		(*curp)->bc_ptrs[level + 1]++;
-	}
-	*bnop = rbno;
-	*stat = 1;
-	return 0;
-}
 
 /*
  * Externally visible routines.
@@ -1344,6 +1191,41 @@ xfs_allocbt_dup_cursor(
 			cur->bc_btnum);
 }
 
+STATIC int
+xfs_allocbt_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*start,
+	union xfs_btree_ptr	*new,
+	int			length,
+	int			*stat)
+{
+	int			error;
+	xfs_agblock_t		bno;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+
+	/* Allocate the new block from the freelist. If we can't, give up.  */
+	error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_private.a.agbp,
+				       &bno, 1);
+	if (error) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+		return error;
+	}
+
+	if (bno == NULLAGBLOCK) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+
+	xfs_trans_agbtree_delta(cur->bc_tp, 1);
+	new->s = cpu_to_be32(bno);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+}
+
 /*
  * Update the longest extent in the AGF
  */
@@ -1680,6 +1562,7 @@ xfs_allocbt_trace_record(
 
 static const struct xfs_btree_ops xfs_allocbt_ops = {
 	.dup_cursor		= xfs_allocbt_dup_cursor,
+	.alloc_block		= xfs_allocbt_alloc_block,
 	.update_lastrec		= xfs_allocbt_update_lastrec,
 	.get_maxrecs		= xfs_allocbt_get_maxrecs,
 	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-07-29 16:48:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-07-29 16:48:46.000000000 +0200
@@ -45,8 +45,6 @@ STATIC void xfs_inobt_log_keys(xfs_btree
 STATIC void xfs_inobt_log_ptrs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
 STATIC void xfs_inobt_log_recs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
 STATIC int xfs_inobt_newroot(xfs_btree_cur_t *, int *);
-STATIC int xfs_inobt_split(xfs_btree_cur_t *, int, xfs_agblock_t *,
-		xfs_inobt_key_t *, xfs_btree_cur_t **, int *);
 
 /*
  * Single level of the xfs_inobt_delete record deletion routine.
@@ -621,15 +619,18 @@ xfs_inobt_insrec(
 			if (i) {
 				optr = ptr = cur->bc_ptrs[level];
 			} else {
+				union xfs_btree_ptr bno = { .s = cpu_to_be32(nbno) };
 				/*
 				 * Next, try splitting the current block
 				 * in half. If this works we have to
 				 * re-set our variables because
 				 * we could be in a different block now.
 				 */
-				if ((error = xfs_inobt_split(cur, level, &nbno,
-						&nkey, &ncur, &i)))
+				if ((error = xfs_btree_split(cur, level, &bno,
+						(union xfs_btree_key *)&nkey,
+						&ncur, &i)))
 					return error;
+				nbno = be32_to_cpu(bno.s);
 				if (i) {
 					bp = cur->bc_bufs[level];
 					block = XFS_BUF_TO_INOBT_BLOCK(bp);
@@ -930,165 +931,6 @@ xfs_inobt_newroot(
 }
 
 /*
- * Split cur/level block in half.
- * Return new block number and its first record (to be inserted into parent).
- */
-STATIC int				/* error */
-xfs_inobt_split(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level to split */
-	xfs_agblock_t		*bnop,	/* output: block number allocated */
-	xfs_inobt_key_t		*keyp,	/* output: first key of new block */
-	xfs_btree_cur_t		**curp,	/* output: new cursor */
-	int			*stat)	/* success/failure */
-{
-	xfs_alloc_arg_t		args;	/* allocation argument structure */
-	int			error;	/* error return value */
-	int			i;	/* loop index/record number */
-	xfs_agblock_t		lbno;	/* left (current) block number */
-	xfs_buf_t		*lbp;	/* buffer for left block */
-	xfs_inobt_block_t	*left;	/* left (current) btree block */
-	xfs_inobt_key_t		*lkp;	/* left btree key pointer */
-	xfs_inobt_ptr_t		*lpp;	/* left btree address pointer */
-	xfs_inobt_rec_t		*lrp;	/* left btree record pointer */
-	xfs_buf_t		*rbp;	/* buffer for right block */
-	xfs_inobt_block_t	*right;	/* right (new) btree block */
-	xfs_inobt_key_t		*rkp;	/* right btree key pointer */
-	xfs_inobt_ptr_t		*rpp;	/* right btree address pointer */
-	xfs_inobt_rec_t		*rrp;	/* right btree record pointer */
-
-	/*
-	 * Set up left block (current one).
-	 */
-	lbp = cur->bc_bufs[level];
-	args.tp = cur->bc_tp;
-	args.mp = cur->bc_mp;
-	lbno = XFS_DADDR_TO_AGBNO(args.mp, XFS_BUF_ADDR(lbp));
-	/*
-	 * Allocate the new block.
-	 * If we can't do it, we're toast.  Give up.
-	 */
-	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.a.agno, lbno);
-	args.mod = args.minleft = args.alignment = args.total = args.wasdel =
-		args.isfl = args.userdata = args.minalignslop = 0;
-	args.minlen = args.maxlen = args.prod = 1;
-	args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	if ((error = xfs_alloc_vextent(&args)))
-		return error;
-	if (args.fsbno == NULLFSBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	ASSERT(args.len == 1);
-	rbp = xfs_btree_get_bufs(args.mp, args.tp, args.agno, args.agbno, 0);
-	/*
-	 * Set up the new block as "right".
-	 */
-	right = XFS_BUF_TO_INOBT_BLOCK(rbp);
-	/*
-	 * "Left" is the current (according to the cursor) block.
-	 */
-	left = XFS_BUF_TO_INOBT_BLOCK(lbp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
-		return error;
-#endif
-	/*
-	 * Fill in the btree header for the new block.
-	 */
-	right->bb_magic = cpu_to_be32(xfs_magics[cur->bc_btnum]);
-	right->bb_level = left->bb_level;
-	right->bb_numrecs = cpu_to_be16(be16_to_cpu(left->bb_numrecs) / 2);
-	/*
-	 * Make sure that if there's an odd number of entries now, that
-	 * each new block will have the same number of entries.
-	 */
-	if ((be16_to_cpu(left->bb_numrecs) & 1) &&
-	    cur->bc_ptrs[level] <= be16_to_cpu(right->bb_numrecs) + 1)
-		be16_add(&right->bb_numrecs, 1);
-	i = be16_to_cpu(left->bb_numrecs) - be16_to_cpu(right->bb_numrecs) + 1;
-	/*
-	 * For non-leaf blocks, copy keys and addresses over to the new block.
-	 */
-	if (level > 0) {
-		lkp = XFS_INOBT_KEY_ADDR(left, i, cur);
-		lpp = XFS_INOBT_PTR_ADDR(left, i, cur);
-		rkp = XFS_INOBT_KEY_ADDR(right, 1, cur);
-		rpp = XFS_INOBT_PTR_ADDR(right, 1, cur);
-#ifdef DEBUG
-		for (i = 0; i < be16_to_cpu(right->bb_numrecs); i++) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(lpp[i]), level)))
-				return error;
-		}
-#endif
-		memcpy(rkp, lkp, be16_to_cpu(right->bb_numrecs) * sizeof(*rkp));
-		memcpy(rpp, lpp, be16_to_cpu(right->bb_numrecs) * sizeof(*rpp));
-		xfs_inobt_log_keys(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		xfs_inobt_log_ptrs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		*keyp = *rkp;
-	}
-	/*
-	 * For leaf blocks, copy records over to the new block.
-	 */
-	else {
-		lrp = XFS_INOBT_REC_ADDR(left, i, cur);
-		rrp = XFS_INOBT_REC_ADDR(right, 1, cur);
-		memcpy(rrp, lrp, be16_to_cpu(right->bb_numrecs) * sizeof(*rrp));
-		xfs_inobt_log_recs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		keyp->ir_startino = rrp->ir_startino;
-	}
-	/*
-	 * Find the left block number by looking in the buffer.
-	 * Adjust numrecs, sibling pointers.
-	 */
-	be16_add(&left->bb_numrecs, -(be16_to_cpu(right->bb_numrecs)));
-	right->bb_rightsib = left->bb_rightsib;
-	left->bb_rightsib = cpu_to_be32(args.agbno);
-	right->bb_leftsib = cpu_to_be32(lbno);
-	xfs_inobt_log_block(args.tp, rbp, XFS_BB_ALL_BITS);
-	xfs_inobt_log_block(args.tp, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
-	/*
-	 * If there's a block to the new block's right, make that block
-	 * point back to right instead of to left.
-	 */
-	if (be32_to_cpu(right->bb_rightsib) != NULLAGBLOCK) {
-		xfs_inobt_block_t	*rrblock;	/* rr btree block */
-		xfs_buf_t		*rrbp;		/* buffer for rrblock */
-
-		if ((error = xfs_btree_read_bufs(args.mp, args.tp, args.agno,
-				be32_to_cpu(right->bb_rightsib), 0, &rrbp,
-				XFS_INO_BTREE_REF)))
-			return error;
-		rrblock = XFS_BUF_TO_INOBT_BLOCK(rrbp);
-		if ((error = xfs_btree_check_sblock(cur, rrblock, level, rrbp)))
-			return error;
-		rrblock->bb_leftsib = cpu_to_be32(args.agbno);
-		xfs_inobt_log_block(args.tp, rrbp, XFS_BB_LEFTSIB);
-	}
-	/*
-	 * If the cursor is really in the right block, move it there.
-	 * If it's just pointing past the last entry in left, then we'll
-	 * insert there, so don't change anything in that case.
-	 */
-	if (cur->bc_ptrs[level] > be16_to_cpu(left->bb_numrecs) + 1) {
-		xfs_btree_setbuf(cur, level, rbp);
-		cur->bc_ptrs[level] -= be16_to_cpu(left->bb_numrecs);
-	}
-	/*
-	 * If there are more levels, we'll need another cursor which refers
-	 * the right block, no matter where this cursor was.
-	 */
-	if (level + 1 < cur->bc_nlevels) {
-		if ((error = xfs_btree_dup_cursor(cur, curp)))
-			return error;
-		(*curp)->bc_ptrs[level + 1]++;
-	}
-	*bnop = args.agbno;
-	*stat = 1;
-	return 0;
-}
-
-/*
  * Externally visible routines.
  */
 
@@ -1243,6 +1085,48 @@ xfs_inobt_dup_cursor(
 }
 
 STATIC int
+xfs_inobt_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*start,
+	union xfs_btree_ptr	*new,
+	int			length,
+	int			*stat)
+{
+	xfs_alloc_arg_t		args;		/* block allocation args */
+	int			error;		/* error return value */
+	xfs_agblock_t		sbno = be32_to_cpu(start->s);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+
+	memset(&args, 0, sizeof(args));
+	args.tp = cur->bc_tp;
+	args.mp = cur->bc_mp;
+	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.a.agno, sbno);
+	args.minlen = 1;
+	args.maxlen = 1;
+	args.prod = 1;
+	args.type = XFS_ALLOCTYPE_NEAR_BNO;
+
+	error = xfs_alloc_vextent(&args);
+	if (error) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+		return error;
+	}
+	if (args.fsbno == NULLFSBLOCK) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+	ASSERT(args.len == 1);
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+
+	new->s = cpu_to_be32(XFS_FSB_TO_AGBNO(args.mp, args.fsbno));
+	*stat = 1;
+	return 0;
+}
+
+
+STATIC int
 xfs_inobt_get_maxrecs(
 	struct xfs_btree_cur	*cur,
 	int			level)
@@ -1517,6 +1401,7 @@ xfs_inobt_trace_record(
 
 static const struct xfs_btree_ops xfs_inobt_ops = {
 	.dup_cursor		= xfs_inobt_dup_cursor,
+	.alloc_block		= xfs_inobt_alloc_block,
 	.get_maxrecs		= xfs_inobt_get_maxrecs,
 	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-07-29 16:48:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-07-29 16:48:46.000000000 +0200
@@ -52,8 +52,6 @@
 STATIC int xfs_bmbt_killroot(xfs_btree_cur_t *);
 STATIC void xfs_bmbt_log_keys(xfs_btree_cur_t *, xfs_buf_t *, int, int);
 STATIC void xfs_bmbt_log_ptrs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-STATIC int xfs_bmbt_split(xfs_btree_cur_t *, int, xfs_fsblock_t *,
-		__uint64_t *, xfs_btree_cur_t **, int *);
 
 #undef EXIT
 
@@ -549,13 +547,17 @@ xfs_bmbt_insrec(
 				if (i) {
 					optr = ptr = cur->bc_ptrs[level];
 				} else {
-					if ((error = xfs_bmbt_split(cur, level,
-							&nbno, &startoff, &ncur,
+					union xfs_btree_ptr bno = { .l = cpu_to_be64(nbno) };
+					union xfs_btree_key skey;
+					if ((error = xfs_btree_split(cur, level,
+							&bno, &skey, &ncur,
 							&i))) {
 						XFS_BMBT_TRACE_CURSOR(cur,
 							ERROR);
 						return error;
 					}
+					nbno = be64_to_cpu(bno.l);
+					startoff = be64_to_cpu(skey.bmbt.br_startoff);
 					if (i) {
 						block = xfs_bmbt_get_block(
 							    cur, level, &bp);
@@ -788,184 +790,6 @@ xfs_extent_state(
 	return XFS_EXT_NORM;
 }
 
-
-/*
- * Split cur/level block in half.
- * Return new block number and its first record (to be inserted into parent).
- */
-STATIC int					/* error */
-xfs_bmbt_split(
-	xfs_btree_cur_t		*cur,
-	int			level,
-	xfs_fsblock_t		*bnop,
-	__uint64_t		*startoff,
-	xfs_btree_cur_t		**curp,
-	int			*stat)		/* success/failure */
-{
-	xfs_alloc_arg_t		args;		/* block allocation args */
-	int			error;		/* error return value */
-	int			i;		/* loop counter */
-	xfs_fsblock_t		lbno;		/* left sibling block number */
-	xfs_buf_t		*lbp;		/* left buffer pointer */
-	xfs_bmbt_block_t	*left;		/* left btree block */
-	xfs_bmbt_key_t		*lkp;		/* left btree key */
-	xfs_bmbt_ptr_t		*lpp;		/* left address pointer */
-	xfs_bmbt_rec_t		*lrp;		/* left record pointer */
-	xfs_buf_t		*rbp;		/* right buffer pointer */
-	xfs_bmbt_block_t	*right;		/* right btree block */
-	xfs_bmbt_key_t		*rkp;		/* right btree key */
-	xfs_bmbt_ptr_t		*rpp;		/* right address pointer */
-	xfs_bmbt_block_t	*rrblock;	/* right-right btree block */
-	xfs_buf_t		*rrbp;		/* right-right buffer pointer */
-	xfs_bmbt_rec_t		*rrp;		/* right record pointer */
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	// disable until merged into common code
-//	XFS_BMBT_TRACE_ARGIFK(cur, level, *bnop, *startoff);
-	args.tp = cur->bc_tp;
-	args.mp = cur->bc_mp;
-	lbp = cur->bc_bufs[level];
-	lbno = XFS_DADDR_TO_FSB(args.mp, XFS_BUF_ADDR(lbp));
-	left = XFS_BUF_TO_BMBT_BLOCK(lbp);
-	args.fsbno = cur->bc_private.b.firstblock;
-	args.firstblock = args.fsbno;
-	args.minleft = 0;
-	if (args.fsbno == NULLFSBLOCK) {
-		args.fsbno = lbno;
-		args.type = XFS_ALLOCTYPE_START_BNO;
-		/*
-		 * Make sure there is sufficient room left in the AG to
-		 * complete a full tree split for an extent insert.  If
-		 * we are converting the middle part of an extent then
-		 * we may need space for two tree splits.
-		 *
-		 * We are relying on the caller to make the correct block
-		 * reservation for this operation to succeed.  If the
-		 * reservation amount is insufficient then we may fail a
-		 * block allocation here and corrupt the filesystem.
-		 */
-		args.minleft = xfs_trans_get_block_res(args.tp);
-	} else if (cur->bc_private.b.flist->xbf_low)
-		args.type = XFS_ALLOCTYPE_START_BNO;
-	else
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	args.mod = args.alignment = args.total = args.isfl =
-		args.userdata = args.minalignslop = 0;
-	args.minlen = args.maxlen = args.prod = 1;
-	args.wasdel = cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL;
-	if (!args.wasdel && xfs_trans_get_block_res(args.tp) == 0) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return XFS_ERROR(ENOSPC);
-	}
-	if ((error = xfs_alloc_vextent(&args))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	if (args.fsbno == NULLFSBLOCK && args.minleft) {
-		/*
-		 * Could not find an AG with enough free space to satisfy
-		 * a full btree split.  Try again without minleft and if
-		 * successful activate the lowspace algorithm.
-		 */
-		args.fsbno = 0;
-		args.type = XFS_ALLOCTYPE_FIRST_AG;
-		args.minleft = 0;
-		if ((error = xfs_alloc_vextent(&args))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-		cur->bc_private.b.flist->xbf_low = 1;
-	}
-	if (args.fsbno == NULLFSBLOCK) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	ASSERT(args.len == 1);
-	cur->bc_private.b.firstblock = args.fsbno;
-	cur->bc_private.b.allocated++;
-	cur->bc_private.b.ip->i_d.di_nblocks++;
-	xfs_trans_log_inode(args.tp, cur->bc_private.b.ip, XFS_ILOG_CORE);
-	XFS_TRANS_MOD_DQUOT_BYINO(args.mp, args.tp, cur->bc_private.b.ip,
-			XFS_TRANS_DQ_BCOUNT, 1L);
-	rbp = xfs_btree_get_bufl(args.mp, args.tp, args.fsbno, 0);
-	right = XFS_BUF_TO_BMBT_BLOCK(rbp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_lblock(cur, left, level, rbp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-#endif
-	right->bb_magic = cpu_to_be32(XFS_BMAP_MAGIC);
-	right->bb_level = left->bb_level;
-	right->bb_numrecs = cpu_to_be16(be16_to_cpu(left->bb_numrecs) / 2);
-	if ((be16_to_cpu(left->bb_numrecs) & 1) &&
-	    cur->bc_ptrs[level] <= be16_to_cpu(right->bb_numrecs) + 1)
-		be16_add(&right->bb_numrecs, 1);
-	i = be16_to_cpu(left->bb_numrecs) - be16_to_cpu(right->bb_numrecs) + 1;
-	if (level > 0) {
-		lkp = XFS_BMAP_KEY_IADDR(left, i, cur);
-		lpp = XFS_BMAP_PTR_IADDR(left, i, cur);
-		rkp = XFS_BMAP_KEY_IADDR(right, 1, cur);
-		rpp = XFS_BMAP_PTR_IADDR(right, 1, cur);
-#ifdef DEBUG
-		for (i = 0; i < be16_to_cpu(right->bb_numrecs); i++) {
-			if ((error = xfs_btree_check_lptr_disk(cur, lpp[i], level))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				return error;
-			}
-		}
-#endif
-		memcpy(rkp, lkp, be16_to_cpu(right->bb_numrecs) * sizeof(*rkp));
-		memcpy(rpp, lpp, be16_to_cpu(right->bb_numrecs) * sizeof(*rpp));
-		xfs_bmbt_log_keys(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		xfs_bmbt_log_ptrs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		*startoff = be64_to_cpu(rkp->br_startoff);
-	} else {
-		lrp = XFS_BMAP_REC_IADDR(left, i, cur);
-		rrp = XFS_BMAP_REC_IADDR(right, 1, cur);
-		memcpy(rrp, lrp, be16_to_cpu(right->bb_numrecs) * sizeof(*rrp));
-		xfs_bmbt_log_recs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		*startoff = xfs_bmbt_disk_get_startoff(rrp);
-	}
-	be16_add(&left->bb_numrecs, -(be16_to_cpu(right->bb_numrecs)));
-	right->bb_rightsib = left->bb_rightsib;
-	left->bb_rightsib = cpu_to_be64(args.fsbno);
-	right->bb_leftsib = cpu_to_be64(lbno);
-	xfs_bmbt_log_block(cur, rbp, XFS_BB_ALL_BITS);
-	xfs_bmbt_log_block(cur, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
-	if (be64_to_cpu(right->bb_rightsib) != NULLDFSBNO) {
-		if ((error = xfs_btree_read_bufl(args.mp, args.tp,
-				be64_to_cpu(right->bb_rightsib), 0, &rrbp,
-				XFS_BMAP_BTREE_REF))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-		rrblock = XFS_BUF_TO_BMBT_BLOCK(rrbp);
-		if ((error = xfs_btree_check_lblock(cur, rrblock, level, rrbp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-		rrblock->bb_leftsib = cpu_to_be64(args.fsbno);
-		xfs_bmbt_log_block(cur, rrbp, XFS_BB_LEFTSIB);
-	}
-	if (cur->bc_ptrs[level] > be16_to_cpu(left->bb_numrecs) + 1) {
-		xfs_btree_setbuf(cur, level, rbp);
-		cur->bc_ptrs[level] -= be16_to_cpu(left->bb_numrecs);
-	}
-	if (level + 1 < cur->bc_nlevels) {
-		if ((error = xfs_btree_dup_cursor(cur, curp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-		(*curp)->bc_ptrs[level + 1]++;
-	}
-	*bnop = args.fsbno;
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*stat = 1;
-	return 0;
-}
-
 /*
  * Convert on-disk form of btree root to in-memory form.
  */
@@ -1672,6 +1496,92 @@ xfs_bmbt_dup_cursor(
 	return new;
 }
 
+STATIC int
+xfs_bmbt_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*start,
+	union xfs_btree_ptr	*new,
+	int			length,
+	int			*stat)
+{
+	xfs_alloc_arg_t		args;		/* block allocation args */
+	int			error;		/* error return value */
+
+	memset(&args, 0, sizeof(args));
+	args.tp = cur->bc_tp;
+	args.mp = cur->bc_mp;
+	args.fsbno = cur->bc_private.b.firstblock;
+	args.firstblock = args.fsbno;
+
+	if (args.fsbno == NULLFSBLOCK) {
+		args.fsbno = be64_to_cpu(start->l);
+		args.type = XFS_ALLOCTYPE_START_BNO;
+		/*
+		 * Make sure there is sufficient room left in the AG to
+		 * complete a full tree split for an extent insert.  If
+		 * we are converting the middle part of an extent then
+		 * we may need space for two tree splits.
+		 *
+		 * We are relying on the caller to make the correct block
+		 * reservation for this operation to succeed.  If the
+		 * reservation amount is insufficient then we may fail a
+		 * block allocation here and corrupt the filesystem.
+		 */
+		args.minleft = xfs_trans_get_block_res(args.tp);
+	} else if (cur->bc_private.b.flist->xbf_low) {
+		args.type = XFS_ALLOCTYPE_START_BNO;
+	} else {
+		args.type = XFS_ALLOCTYPE_NEAR_BNO;
+	}
+
+	args.minlen = args.maxlen = args.prod = 1;
+	args.wasdel = cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL;
+	if (!args.wasdel && xfs_trans_get_block_res(args.tp) == 0) {
+		error = XFS_ERROR(ENOSPC);
+		goto error0;
+	}
+	error = xfs_alloc_vextent(&args);
+	if (error)
+		goto error0;
+
+	if (args.fsbno == NULLFSBLOCK && args.minleft) {
+		/*
+		 * Could not find an AG with enough free space to satisfy
+		 * a full btree split.  Try again without minleft and if
+		 * successful activate the lowspace algorithm.
+		 */
+		args.fsbno = 0;
+		args.type = XFS_ALLOCTYPE_FIRST_AG;
+		args.minleft = 0;
+		error = xfs_alloc_vextent(&args);
+		if (error)
+			goto error0;
+		cur->bc_private.b.flist->xbf_low = 1;
+	}
+	if (args.fsbno == NULLFSBLOCK) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+	ASSERT(args.len == 1);
+	cur->bc_private.b.firstblock = args.fsbno;
+	cur->bc_private.b.allocated++;
+	cur->bc_private.b.ip->i_d.di_nblocks++;
+	xfs_trans_log_inode(args.tp, cur->bc_private.b.ip, XFS_ILOG_CORE);
+	XFS_TRANS_MOD_DQUOT_BYINO(args.mp, args.tp, cur->bc_private.b.ip,
+			XFS_TRANS_DQ_BCOUNT, 1L);
+
+	new->l = cpu_to_be64(args.fsbno);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+
+ error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
 STATIC struct xfs_btree_block *
 xfs_bmbt_get_root_from_inode(
 	struct xfs_btree_cur	*cur)
@@ -1975,6 +1885,7 @@ xfs_bmbt_trace_record(
 static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.dup_cursor		= xfs_bmbt_dup_cursor,
 	.get_root_from_inode	= xfs_bmbt_get_root_from_inode,
+	.alloc_block		= xfs_bmbt_alloc_block,
 	.init_key_from_rec	= xfs_bmbt_init_key_from_rec,
 	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
 	.get_maxrecs		= xfs_bmbt_get_maxrecs,

-- 
