Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Aug 2008 18:34:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m741YTG0001299
	for <xfs@oss.sgi.com>; Sun, 3 Aug 2008 18:34:29 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E10FAEF6AC6
	for <xfs@oss.sgi.com>; Sun,  3 Aug 2008 18:35:12 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id SB6Bg88kyzdxBPGP for <xfs@oss.sgi.com>; Sun, 03 Aug 2008 18:35:12 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m741ZEIF009238
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 03:35:14 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m741ZEBS009236
	for xfs@oss.sgi.com; Mon, 4 Aug 2008 03:35:14 +0200
Date: Mon, 4 Aug 2008 03:35:14 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 19/26] implement semi-generic xfs_btree_new_root
Message-ID: <20080804013514.GT8819@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-common-btree-newroot
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

From: Dave Chinner <dgc@sgi.com>

Add a xfs_btree_new_root helper for the alloc and ialloc btrees.  The bmap
btree needs it's own version and is not converted.

[hch: split out from bigger patch and minor adaptions]


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-08-03 13:33:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-08-03 13:33:16.000000000 +0200
@@ -52,7 +52,6 @@ STATIC void xfs_alloc_log_ptrs(xfs_btree
 STATIC void xfs_allocbt_log_recs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
 #define xfs_alloc_log_recs(c, b, i, j) \
 	xfs_allocbt_log_recs(c, b, i, j)
-STATIC int xfs_alloc_newroot(xfs_btree_cur_t *, int *);
 
 /*
  * Internal functions.
@@ -632,7 +631,7 @@ xfs_alloc_insrec(
 	 */
 	if (level >= cur->bc_nlevels) {
 		XFS_STATS_INC(xs_abt_insrec);
-		if ((error = xfs_alloc_newroot(cur, &i)))
+		if ((error = xfs_btree_new_root(cur, &i)))
 			return error;
 		*bnop = NULLAGBLOCK;
 		*stat = i;
@@ -883,161 +882,6 @@ xfs_alloc_log_ptrs(
 	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
 }
 
-/*
- * Allocate a new root block, fill it in.
- */
-STATIC int				/* error */
-xfs_alloc_newroot(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			*stat)	/* success/failure */
-{
-	int			error;	/* error return value */
-	xfs_agblock_t		lbno;	/* left block number */
-	xfs_buf_t		*lbp;	/* left btree buffer */
-	xfs_alloc_block_t	*left;	/* left btree block */
-	xfs_mount_t		*mp;	/* mount structure */
-	xfs_agblock_t		nbno;	/* new block number */
-	xfs_buf_t		*nbp;	/* new (root) buffer */
-	xfs_alloc_block_t	*new;	/* new (root) btree block */
-	int			nptr;	/* new value for key index, 1 or 2 */
-	xfs_agblock_t		rbno;	/* right block number */
-	xfs_buf_t		*rbp;	/* right btree buffer */
-	xfs_alloc_block_t	*right;	/* right btree block */
-
-	mp = cur->bc_mp;
-
-	ASSERT(cur->bc_nlevels < XFS_AG_MAXLEVELS(mp));
-	/*
-	 * Get a buffer from the freelist blocks, for the new root.
-	 */
-	error = xfs_alloc_get_freelist(cur->bc_tp,
-					cur->bc_private.a.agbp, &nbno, 1);
-	if (error)
-		return error;
-	/*
-	 * None available, we fail.
-	 */
-	if (nbno == NULLAGBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	xfs_trans_agbtree_delta(cur->bc_tp, 1);
-	nbp = xfs_btree_get_bufs(mp, cur->bc_tp, cur->bc_private.a.agno, nbno,
-		0);
-	new = XFS_BUF_TO_ALLOC_BLOCK(nbp);
-	/*
-	 * Set the root data in the a.g. freespace structure.
-	 */
-	{
-		xfs_agf_t	*agf;	/* a.g. freespace header */
-		xfs_agnumber_t	seqno;
-
-		agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
-		agf->agf_roots[cur->bc_btnum] = cpu_to_be32(nbno);
-		be32_add(&agf->agf_levels[cur->bc_btnum], 1);
-		seqno = be32_to_cpu(agf->agf_seqno);
-		mp->m_perag[seqno].pagf_levels[cur->bc_btnum]++;
-		xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp,
-			XFS_AGF_ROOTS | XFS_AGF_LEVELS);
-	}
-	/*
-	 * At the previous root level there are now two blocks: the old
-	 * root, and the new block generated when it was split.
-	 * We don't know which one the cursor is pointing at, so we
-	 * set up variables "left" and "right" for each case.
-	 */
-	lbp = cur->bc_bufs[cur->bc_nlevels - 1];
-	left = XFS_BUF_TO_ALLOC_BLOCK(lbp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, left, cur->bc_nlevels - 1, lbp)))
-		return error;
-#endif
-	if (be32_to_cpu(left->bb_rightsib) != NULLAGBLOCK) {
-		/*
-		 * Our block is left, pick up the right block.
-		 */
-		lbno = XFS_DADDR_TO_AGBNO(mp, XFS_BUF_ADDR(lbp));
-		rbno = be32_to_cpu(left->bb_rightsib);
-		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
-				cur->bc_private.a.agno, rbno, 0, &rbp,
-				XFS_ALLOC_BTREE_REF)))
-			return error;
-		right = XFS_BUF_TO_ALLOC_BLOCK(rbp);
-		if ((error = xfs_btree_check_sblock(cur, right,
-				cur->bc_nlevels - 1, rbp)))
-			return error;
-		nptr = 1;
-	} else {
-		/*
-		 * Our block is right, pick up the left block.
-		 */
-		rbp = lbp;
-		right = left;
-		rbno = XFS_DADDR_TO_AGBNO(mp, XFS_BUF_ADDR(rbp));
-		lbno = be32_to_cpu(right->bb_leftsib);
-		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
-				cur->bc_private.a.agno, lbno, 0, &lbp,
-				XFS_ALLOC_BTREE_REF)))
-			return error;
-		left = XFS_BUF_TO_ALLOC_BLOCK(lbp);
-		if ((error = xfs_btree_check_sblock(cur, left,
-				cur->bc_nlevels - 1, lbp)))
-			return error;
-		nptr = 2;
-	}
-	/*
-	 * Fill in the new block's btree header and log it.
-	 */
-	new->bb_magic = cpu_to_be32(xfs_magics[cur->bc_btnum]);
-	new->bb_level = cpu_to_be16(cur->bc_nlevels);
-	new->bb_numrecs = cpu_to_be16(2);
-	new->bb_leftsib = cpu_to_be32(NULLAGBLOCK);
-	new->bb_rightsib = cpu_to_be32(NULLAGBLOCK);
-	xfs_alloc_log_block(cur->bc_tp, nbp, XFS_BB_ALL_BITS);
-	ASSERT(lbno != NULLAGBLOCK && rbno != NULLAGBLOCK);
-	/*
-	 * Fill in the key data in the new root.
-	 */
-	{
-		xfs_alloc_key_t		*kp;	/* btree key pointer */
-
-		kp = XFS_ALLOC_KEY_ADDR(new, 1, cur);
-		if (be16_to_cpu(left->bb_level) > 0) {
-			kp[0] = *XFS_ALLOC_KEY_ADDR(left, 1, cur);
-			kp[1] = *XFS_ALLOC_KEY_ADDR(right, 1, cur);
-		} else {
-			xfs_alloc_rec_t	*rp;	/* btree record pointer */
-
-			rp = XFS_ALLOC_REC_ADDR(left, 1, cur);
-			kp[0].ar_startblock = rp->ar_startblock;
-			kp[0].ar_blockcount = rp->ar_blockcount;
-			rp = XFS_ALLOC_REC_ADDR(right, 1, cur);
-			kp[1].ar_startblock = rp->ar_startblock;
-			kp[1].ar_blockcount = rp->ar_blockcount;
-		}
-	}
-	xfs_alloc_log_keys(cur, nbp, 1, 2);
-	/*
-	 * Fill in the pointer data in the new root.
-	 */
-	{
-		xfs_alloc_ptr_t		*pp;	/* btree address pointer */
-
-		pp = XFS_ALLOC_PTR_ADDR(new, 1, cur);
-		pp[0] = cpu_to_be32(lbno);
-		pp[1] = cpu_to_be32(rbno);
-	}
-	xfs_alloc_log_ptrs(cur, nbp, 1, 2);
-	/*
-	 * Fix up the cursor.
-	 */
-	xfs_btree_setbuf(cur, cur->bc_nlevels, nbp);
-	cur->bc_ptrs[cur->bc_nlevels] = nptr;
-	cur->bc_nlevels++;
-	*stat = 1;
-	return 0;
-}
-
 
 /*
  * Externally visible routines.
@@ -1191,6 +1035,26 @@ xfs_allocbt_dup_cursor(
 			cur->bc_btnum);
 }
 
+STATIC void
+xfs_allocbt_set_root(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	int			inc)
+{
+	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
+	int			btnum = cur->bc_btnum;
+
+	ASSERT(ptr->s != 0);
+
+	agf->agf_roots[btnum] = ptr->s;
+	be32_add(&agf->agf_levels[btnum], inc);
+	cur->bc_mp->m_perag[seqno].pagf_levels[btnum] += inc;
+
+	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
+}
+
 STATIC int
 xfs_allocbt_alloc_block(
 	struct xfs_btree_cur	*cur,
@@ -1568,6 +1432,7 @@ xfs_allocbt_trace_record(
 
 static const struct xfs_btree_ops xfs_allocbt_ops = {
 	.dup_cursor		= xfs_allocbt_dup_cursor,
+	.set_root		= xfs_allocbt_set_root,
 	.alloc_block		= xfs_allocbt_alloc_block,
 	.update_lastrec		= xfs_allocbt_update_lastrec,
 	.get_maxrecs		= xfs_allocbt_get_maxrecs,
Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-08-03 13:33:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-08-03 13:33:31.000000000 +0200
@@ -2248,3 +2248,131 @@ error0:
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
 	return error;
 }
+
+/*
+ * Allocate a new root block, fill it in.
+ */
+int				/* error */
+xfs_btree_new_root(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	int			*stat)	/* success/failure */
+{
+	struct xfs_btree_block	*block;	/* one half of the old root block */
+	struct xfs_buf		*bp;	/* buffer containing block */
+	int			error;	/* error return value */
+	union xfs_btree_key	*kp;	/* btree key pointer */
+	struct xfs_buf		*lbp;	/* left buffer pointer */
+	struct xfs_btree_block	*left;	/* left btree block */
+	struct xfs_buf		*nbp;	/* new (root) buffer */
+	struct xfs_btree_block	*new;	/* new (root) btree block */
+	int			nptr;	/* new value for key index, 1 or 2 */
+	union xfs_btree_ptr	*pp;	/* btree address pointer */
+	struct xfs_buf		*rbp;	/* right buffer pointer */
+	struct xfs_btree_block	*right;	/* right btree block */
+	union xfs_btree_ptr	rptr;
+	union xfs_btree_ptr	lptr;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_STATS_INC(cur, newroot);
+
+	/* initialise our start point from the cursor */
+	cur->bc_ops->init_ptr_from_cur(cur, &rptr);
+
+	/* Allocate the new block. If we can't do it, we're toast. Give up. */
+	error = cur->bc_ops->alloc_block(cur, &rptr, &lptr, 1, stat);
+	if (error)
+		goto error0;
+	if (*stat == 0)
+		goto out0;
+	XFS_BTREE_STATS_INC(cur, alloc);
+
+	/* Set up the new block. */
+	error = xfs_btree_get_buf_block(cur, &lptr, 0, &new, &nbp);
+	if (error)
+		goto error0;
+
+	/* Set the root in the holding structure  increasing the level by 1. */
+	cur->bc_ops->set_root(cur, &lptr, 1);
+
+	/*
+	 * At the previous root level there are now two blocks: the old root,
+	 * and the new block generated when it was split.  We don't know which
+	 * one the cursor is pointing at, so we set up variables "left" and
+	 * "right" for each case.
+	 */
+	block = xfs_btree_get_block(cur, cur->bc_nlevels - 1, &bp);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, block, cur->bc_nlevels - 1, bp);
+	if (error)
+		goto error0;
+#endif
+
+	xfs_btree_get_sibling(cur, block, &rptr, XFS_BB_RIGHTSIB);
+	if (!xfs_btree_ptr_is_null(cur, &rptr)) {
+		/* Our block is left, pick up the right block. */
+		lbp = bp;
+		xfs_btree_buf_to_ptr(cur, lbp, &lptr);
+		left = block;
+		error = xfs_btree_read_buf_block(cur, &rptr,
+					cur->bc_nlevels - 1, 0, &right, &rbp);
+		if (error)
+			goto error0;
+		bp = rbp;
+		nptr = 1;
+	} else {
+		/* Our block is right, pick up the left block. */
+		rbp = bp;
+		xfs_btree_buf_to_ptr(cur, rbp, &rptr);
+		right = block;
+		xfs_btree_get_sibling(cur, right, &lptr, XFS_BB_LEFTSIB);
+		error = xfs_btree_read_buf_block(cur, &lptr,
+					cur->bc_nlevels - 1, 0, &left, &lbp);
+		if (error)
+			goto error0;
+		bp = lbp;
+		nptr = 2;
+	}
+	/* Fill in the new block's btree header and log it. */
+	xfs_btree_init_block(cur, cur->bc_nlevels, 2, new);
+	xfs_btree_log_block(cur, nbp, XFS_BB_ALL_BITS);
+	ASSERT(!xfs_btree_ptr_is_null(cur, &lptr) &&
+			!xfs_btree_ptr_is_null(cur, &rptr));
+
+	/* Fill in the key data in the new root. */
+	kp = cur->bc_ops->key_addr(cur, 1, new);
+	if (xfs_btree_get_level(left) > 0) {
+		cur->bc_ops->set_key(cur, kp, 0,
+				cur->bc_ops->key_addr(cur, 1, left));
+		cur->bc_ops->set_key(cur, kp, 1,
+				cur->bc_ops->key_addr(cur, 1, right));
+	} else {
+		cur->bc_ops->init_key_from_rec(cur, kp,
+				cur->bc_ops->rec_addr(cur, 1, left));
+		kp = cur->bc_ops->key_addr(cur, 2, new);
+		cur->bc_ops->init_key_from_rec(cur,
+				kp, cur->bc_ops->rec_addr(cur, 1, right));
+	}
+	cur->bc_ops->log_keys(cur, nbp, 1, 2);
+
+	/* Fill in the pointer data in the new root. */
+	pp = cur->bc_ops->ptr_addr(cur, 1, new);
+	xfs_btree_set_ptr(cur, pp, 0, &lptr);
+	xfs_btree_set_ptr(cur, pp, 1, &rptr);
+	xfs_btree_log_ptrs(cur, nbp, 1, 2);
+
+	/* Fix up the cursor. */
+	xfs_btree_setbuf(cur, cur->bc_nlevels, nbp);
+	cur->bc_ptrs[cur->bc_nlevels] = nptr;
+	cur->bc_nlevels++;
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+out0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 0;
+	return 0;
+}
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-08-03 13:33:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-08-03 13:33:16.000000000 +0200
@@ -186,6 +186,10 @@ struct xfs_btree_ops {
 	/* get inode rooted btree root */
 	struct xfs_btree_block *(*get_root_from_inode)(struct xfs_btree_cur *);
 
+	/* btree root operations */
+	void	(*set_root)(struct xfs_btree_cur *cur,
+				union xfs_btree_ptr *nptr, int level_change);
+
 	/* block allocation / freeing */
 	int	(*alloc_block)(struct xfs_btree_cur *cur,
 			       union xfs_btree_ptr *start_bno,
@@ -581,6 +585,7 @@ int xfs_btree_lshift(struct xfs_btree_cu
 int xfs_btree_rshift(struct xfs_btree_cur *, int, int *);
 int xfs_btree_split(struct xfs_btree_cur *, int, union xfs_btree_ptr *,
 		union xfs_btree_key *, struct xfs_btree_cur **, int *);
+int xfs_btree_new_root(struct xfs_btree_cur *, int *);
 
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-08-03 13:33:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-08-03 13:33:16.000000000 +0200
@@ -44,7 +44,6 @@ STATIC void xfs_inobt_log_block(xfs_tran
 STATIC void xfs_inobt_log_keys(xfs_btree_cur_t *, xfs_buf_t *, int, int);
 STATIC void xfs_inobt_log_ptrs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
 STATIC void xfs_inobt_log_recs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-STATIC int xfs_inobt_newroot(xfs_btree_cur_t *, int *);
 
 /*
  * Single level of the xfs_inobt_delete record deletion routine.
@@ -556,7 +555,7 @@ xfs_inobt_insrec(
 	 * and we're done.
 	 */
 	if (level >= cur->bc_nlevels) {
-		error = xfs_inobt_newroot(cur, &i);
+		error = xfs_btree_new_root(cur, &i);
 		*bnop = NULLAGBLOCK;
 		*stat = i;
 		return error;
@@ -783,152 +782,6 @@ xfs_inobt_log_ptrs(
 	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
 }
 
-/*
- * Allocate a new root block, fill it in.
- */
-STATIC int				/* error */
-xfs_inobt_newroot(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			*stat)	/* success/failure */
-{
-	xfs_agi_t		*agi;	/* a.g. inode header */
-	xfs_alloc_arg_t		args;	/* allocation argument structure */
-	xfs_inobt_block_t	*block;	/* one half of the old root block */
-	xfs_buf_t		*bp;	/* buffer containing block */
-	int			error;	/* error return value */
-	xfs_inobt_key_t		*kp;	/* btree key pointer */
-	xfs_agblock_t		lbno;	/* left block number */
-	xfs_buf_t		*lbp;	/* left buffer pointer */
-	xfs_inobt_block_t	*left;	/* left btree block */
-	xfs_buf_t		*nbp;	/* new (root) buffer */
-	xfs_inobt_block_t	*new;	/* new (root) btree block */
-	int			nptr;	/* new value for key index, 1 or 2 */
-	xfs_inobt_ptr_t		*pp;	/* btree address pointer */
-	xfs_agblock_t		rbno;	/* right block number */
-	xfs_buf_t		*rbp;	/* right buffer pointer */
-	xfs_inobt_block_t	*right;	/* right btree block */
-	xfs_inobt_rec_t		*rp;	/* btree record pointer */
-
-	ASSERT(cur->bc_nlevels < XFS_IN_MAXLEVELS(cur->bc_mp));
-
-	/*
-	 * Get a block & a buffer.
-	 */
-	agi = XFS_BUF_TO_AGI(cur->bc_private.a.agbp);
-	args.tp = cur->bc_tp;
-	args.mp = cur->bc_mp;
-	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.a.agno,
-		be32_to_cpu(agi->agi_root));
-	args.mod = args.minleft = args.alignment = args.total = args.wasdel =
-		args.isfl = args.userdata = args.minalignslop = 0;
-	args.minlen = args.maxlen = args.prod = 1;
-	args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	if ((error = xfs_alloc_vextent(&args)))
-		return error;
-	/*
-	 * None available, we fail.
-	 */
-	if (args.fsbno == NULLFSBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	ASSERT(args.len == 1);
-	nbp = xfs_btree_get_bufs(args.mp, args.tp, args.agno, args.agbno, 0);
-	new = XFS_BUF_TO_INOBT_BLOCK(nbp);
-	/*
-	 * Set the root data in the a.g. inode structure.
-	 */
-	agi->agi_root = cpu_to_be32(args.agbno);
-	be32_add(&agi->agi_level, 1);
-	xfs_ialloc_log_agi(args.tp, cur->bc_private.a.agbp,
-		XFS_AGI_ROOT | XFS_AGI_LEVEL);
-	/*
-	 * At the previous root level there are now two blocks: the old
-	 * root, and the new block generated when it was split.
-	 * We don't know which one the cursor is pointing at, so we
-	 * set up variables "left" and "right" for each case.
-	 */
-	bp = cur->bc_bufs[cur->bc_nlevels - 1];
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, cur->bc_nlevels - 1, bp)))
-		return error;
-#endif
-	if (be32_to_cpu(block->bb_rightsib) != NULLAGBLOCK) {
-		/*
-		 * Our block is left, pick up the right block.
-		 */
-		lbp = bp;
-		lbno = XFS_DADDR_TO_AGBNO(args.mp, XFS_BUF_ADDR(lbp));
-		left = block;
-		rbno = be32_to_cpu(left->bb_rightsib);
-		if ((error = xfs_btree_read_bufs(args.mp, args.tp, args.agno,
-				rbno, 0, &rbp, XFS_INO_BTREE_REF)))
-			return error;
-		bp = rbp;
-		right = XFS_BUF_TO_INOBT_BLOCK(rbp);
-		if ((error = xfs_btree_check_sblock(cur, right,
-				cur->bc_nlevels - 1, rbp)))
-			return error;
-		nptr = 1;
-	} else {
-		/*
-		 * Our block is right, pick up the left block.
-		 */
-		rbp = bp;
-		rbno = XFS_DADDR_TO_AGBNO(args.mp, XFS_BUF_ADDR(rbp));
-		right = block;
-		lbno = be32_to_cpu(right->bb_leftsib);
-		if ((error = xfs_btree_read_bufs(args.mp, args.tp, args.agno,
-				lbno, 0, &lbp, XFS_INO_BTREE_REF)))
-			return error;
-		bp = lbp;
-		left = XFS_BUF_TO_INOBT_BLOCK(lbp);
-		if ((error = xfs_btree_check_sblock(cur, left,
-				cur->bc_nlevels - 1, lbp)))
-			return error;
-		nptr = 2;
-	}
-	/*
-	 * Fill in the new block's btree header and log it.
-	 */
-	new->bb_magic = cpu_to_be32(xfs_magics[cur->bc_btnum]);
-	new->bb_level = cpu_to_be16(cur->bc_nlevels);
-	new->bb_numrecs = cpu_to_be16(2);
-	new->bb_leftsib = cpu_to_be32(NULLAGBLOCK);
-	new->bb_rightsib = cpu_to_be32(NULLAGBLOCK);
-	xfs_inobt_log_block(args.tp, nbp, XFS_BB_ALL_BITS);
-	ASSERT(lbno != NULLAGBLOCK && rbno != NULLAGBLOCK);
-	/*
-	 * Fill in the key data in the new root.
-	 */
-	kp = XFS_INOBT_KEY_ADDR(new, 1, cur);
-	if (be16_to_cpu(left->bb_level) > 0) {
-		kp[0] = *XFS_INOBT_KEY_ADDR(left, 1, cur);
-		kp[1] = *XFS_INOBT_KEY_ADDR(right, 1, cur);
-	} else {
-		rp = XFS_INOBT_REC_ADDR(left, 1, cur);
-		kp[0].ir_startino = rp->ir_startino;
-		rp = XFS_INOBT_REC_ADDR(right, 1, cur);
-		kp[1].ir_startino = rp->ir_startino;
-	}
-	xfs_inobt_log_keys(cur, nbp, 1, 2);
-	/*
-	 * Fill in the pointer data in the new root.
-	 */
-	pp = XFS_INOBT_PTR_ADDR(new, 1, cur);
-	pp[0] = cpu_to_be32(lbno);
-	pp[1] = cpu_to_be32(rbno);
-	xfs_inobt_log_ptrs(cur, nbp, 1, 2);
-	/*
-	 * Fix up the cursor.
-	 */
-	xfs_btree_setbuf(cur, cur->bc_nlevels, nbp);
-	cur->bc_ptrs[cur->bc_nlevels] = nptr;
-	cur->bc_nlevels++;
-	*stat = 1;
-	return 0;
-}
 
 /*
  * Externally visible routines.
@@ -1084,6 +937,20 @@ xfs_inobt_dup_cursor(
 			cur->bc_private.a.agbp, cur->bc_private.a.agno);
 }
 
+STATIC void
+xfs_inobt_set_root(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*nptr,
+	int			inc)	/* level change */
+{
+	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
+
+	agi->agi_root = nptr->s;
+	be32_add(&agi->agi_level, inc);
+	xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_ROOT | XFS_AGI_LEVEL);
+}
+
 STATIC int
 xfs_inobt_alloc_block(
 	struct xfs_btree_cur	*cur,
@@ -1396,6 +1263,7 @@ xfs_inobt_trace_record(
 
 static const struct xfs_btree_ops xfs_inobt_ops = {
 	.dup_cursor		= xfs_inobt_dup_cursor,
+	.set_root		= xfs_inobt_set_root,
 	.alloc_block		= xfs_inobt_alloc_block,
 	.get_maxrecs		= xfs_inobt_get_maxrecs,
 	.init_key_from_rec	= xfs_inobt_init_key_from_rec,

-- 
