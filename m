Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Aug 2008 18:33:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m741Xl19000378
	for <xfs@oss.sgi.com>; Sun, 3 Aug 2008 18:33:48 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F3A97EF6ACC
	for <xfs@oss.sgi.com>; Sun,  3 Aug 2008 18:34:59 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id dDFfYXUiP5eZLEtC for <xfs@oss.sgi.com>; Sun, 03 Aug 2008 18:34:59 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m741Z0IF009207
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 03:35:00 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m741Z0uR009205
	for xfs@oss.sgi.com; Mon, 4 Aug 2008 03:35:00 +0200
Date: Mon, 4 Aug 2008 03:35:00 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/26] implement generic xfs_btree_lshift
Message-ID: <20080804013500.GR8819@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-common-btree-lshift
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Make the btree left shift code generic.  Based on a patch from David Chinner
with lots of changes to follow the original btree implementations more
closely.  While this loses some of the generic helper routines for
inserting/moving/removing records it also solves some of the one off
bugs in the original code and makes it easier to verify.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-08-03 13:32:52.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-08-03 13:33:04.000000000 +0200
@@ -985,6 +985,21 @@ xfs_btree_move_ptrs(
 	}
 }
 
+STATIC void
+xfs_btree_copy_ptrs(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*src_ptr,
+	union xfs_btree_ptr	*dst_ptr,
+	int			numptrs)
+{
+	ASSERT(numptrs > 0);
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		memcpy(dst_ptr, src_ptr, numptrs * sizeof(__be64));
+	else
+		memcpy(dst_ptr, src_ptr, numptrs * sizeof(__be32));
+}
+
 /*
  * Log block pointer fields from a btree block (nonleaf).
  */
@@ -1612,6 +1627,186 @@ error0:
 }
 
 /*
+ * Move 1 record left from cur/level if possible.
+ * Update cur to reflect the new path.
+ */
+int					/* error */
+xfs_btree_lshift(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	int			*stat)		/* success/failure */
+{
+	union xfs_btree_key	key;		/* btree key */
+	struct xfs_buf		*lbp;		/* left buffer pointer */
+	struct xfs_btree_block	*left;		/* left btree block */
+	int			lrecs;		/* left record count */
+	struct xfs_buf		*rbp;		/* right buffer pointer */
+	struct xfs_btree_block	*right;		/* right btree block */
+	int			rrecs;		/* right record count */
+	union xfs_btree_ptr	lptr;		/* left btree pointer */
+	union xfs_btree_key	*rkp = NULL;	/* right btree key */
+	union xfs_btree_ptr	*rpp = NULL;	/* right address pointer */
+	union xfs_btree_rec	*rrp = NULL;	/* right record pointer */
+	int			error;		/* error return value */
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGI(cur, level);
+
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    level == cur->bc_nlevels - 1)
+		goto out0;
+
+	/* Set up variables for this block as "right". */
+	right = xfs_btree_get_block(cur, level, &rbp);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, right, level, rbp);
+	if (error)
+		goto error0;
+#endif
+
+	/* If we've got no left sibling then we can't shift an entry left. */
+	xfs_btree_get_sibling(cur, right, &lptr, XFS_BB_LEFTSIB);
+	if (xfs_btree_ptr_is_null(cur, &lptr))
+		goto out0;
+
+	/*
+	 * If the cursor entry is the one that would be moved, don't
+	 * do it... it's too complicated.
+	 */
+	if (cur->bc_ptrs[level] <= 1)
+		goto out0;
+
+	/* Set up the left neighbor as "left". */
+	error = xfs_btree_read_buf_block(cur, &lptr, level, 0, &left, &lbp);
+	if (error)
+		goto error0;
+
+	/* If it's full, it can't take another entry. */
+	lrecs = xfs_btree_get_numrecs(left);
+	if (lrecs == cur->bc_ops->get_maxrecs(cur, level))
+		goto out0;
+
+	rrecs = xfs_btree_get_numrecs(right);
+
+	/*
+	 * We add one entry to the left side and remove one for the right side.
+	 * Accout for it here, the changes will be updated on disk and logged
+	 * later.
+	 */
+	lrecs++;
+	rrecs--;
+
+	XFS_BTREE_STATS_INC(cur, lshift);
+	XFS_BTREE_STATS_ADD(cur, moves, 1);
+
+	/*
+	 * If non-leaf, copy a key and a ptr to the left block.
+	 * Log the changes to the left block.
+	 */
+	if (level > 0) {
+		/* It's a non-leaf.  Move keys and pointers. */
+		union xfs_btree_key	*lkp;	/* left btree key */
+		union xfs_btree_ptr	*lpp;	/* left address pointer */
+
+		lkp = cur->bc_ops->key_addr(cur, lrecs, left);
+		rkp = cur->bc_ops->key_addr(cur, 1, right);
+
+		lpp = cur->bc_ops->ptr_addr(cur, lrecs, left);
+		rpp = cur->bc_ops->ptr_addr(cur, 1, right);
+#ifdef DEBUG
+		error = xfs_btree_check_ptr(cur, rpp, 0, level);
+		if (error)
+			goto error0;
+#endif
+		cur->bc_ops->copy_keys(cur, rkp, lkp, 1);
+		xfs_btree_copy_ptrs(cur, rpp, lpp, 1);
+
+		cur->bc_ops->log_keys(cur, lbp, lrecs, lrecs);
+		xfs_btree_log_ptrs(cur, lbp, lrecs, lrecs);
+
+		xfs_btree_check_key(cur->bc_btnum,
+				    cur->bc_ops->key_addr(cur, lrecs - 1, left),
+				    lkp);
+	} else {
+		/* It's a leaf.  Move records.  */
+		union xfs_btree_rec	*lrp;	/* left record pointer */
+
+		lrp = cur->bc_ops->rec_addr(cur, lrecs, left);
+		rrp = cur->bc_ops->rec_addr(cur, 1, right);
+
+		cur->bc_ops->copy_recs(cur, rrp, lrp, 1);
+		cur->bc_ops->log_recs(cur, lbp, lrecs, lrecs);
+
+		xfs_btree_check_rec(cur->bc_btnum,
+				    cur->bc_ops->rec_addr(cur, lrecs - 1, left),
+				    lrp);
+	}
+
+	xfs_btree_set_numrecs(left, lrecs);
+	xfs_btree_log_block(cur, lbp, XFS_BB_NUMRECS);
+
+	xfs_btree_set_numrecs(right, rrecs);
+	xfs_btree_log_block(cur, rbp, XFS_BB_NUMRECS);
+
+	/*
+	 * Slide the contents of right down one entry.
+	 */
+	XFS_BTREE_STATS_ADD(cur, moves, rrecs - 1);
+	if (level > 0) {
+		/* It's a nonleaf. operate on keys and ptrs */
+#ifdef DEBUG
+		int			i;		/* loop index */
+
+		for (i = 0; i < rrecs; i++) {
+			error = xfs_btree_check_ptr(cur, rpp, i + 1, level);
+			if (error)
+				goto error0;
+		}
+#endif
+
+		cur->bc_ops->move_keys(cur, rkp, 1, 0, rrecs);
+		xfs_btree_move_ptrs(cur, rpp, 1, 0, rrecs);
+		cur->bc_ops->log_keys(cur, rbp, 1, rrecs);
+		xfs_btree_log_ptrs(cur, rbp, 1, rrecs);
+	} else {
+		/* It's a leaf. operate on records */
+
+		rrp = cur->bc_ops->rec_addr(cur, 1, right);
+		cur->bc_ops->move_recs(cur, rrp, 1, 0, rrecs);
+		cur->bc_ops->log_recs(cur, rbp, 1, rrecs);
+
+		/*
+		 * If it's the first record in the block, we'll need a key
+		 * structure to pass up to the next level (updkey).
+		 */
+		cur->bc_ops->init_key_from_rec(cur, &key, rrp);
+		rkp = &key;
+	}
+
+	/* Update the parent key values of right. */
+	error = xfs_btree_updkey(cur, rkp, level + 1);
+	if (error)
+		goto error0;
+
+	/* Slide the cursor value left one. */
+	cur->bc_ptrs[level]--;
+
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
+/*
  * Move 1 record right from cur/level if possible.
  * Update cur to reflect the new path.
  */
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-08-03 13:30:46.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-08-03 13:33:04.000000000 +0200
@@ -52,7 +52,6 @@ STATIC void xfs_alloc_log_ptrs(xfs_btree
 STATIC void xfs_allocbt_log_recs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
 #define xfs_alloc_log_recs(c, b, i, j) \
 	xfs_allocbt_log_recs(c, b, i, j)
-STATIC int xfs_alloc_lshift(xfs_btree_cur_t *, int, int *);
 STATIC int xfs_alloc_newroot(xfs_btree_cur_t *, int *);
 STATIC int xfs_alloc_split(xfs_btree_cur_t *, int, xfs_agblock_t *,
 		xfs_alloc_key_t *, xfs_btree_cur_t **, int *);
@@ -331,7 +330,7 @@ xfs_alloc_delrec(
 		 */
 		if (be16_to_cpu(right->bb_numrecs) - 1 >=
 		     XFS_ALLOC_BLOCK_MINRECS(level, cur)) {
-			if ((error = xfs_alloc_lshift(tcur, level, &i)))
+			if ((error = xfs_btree_lshift(tcur, level, &i)))
 				goto error0;
 			if (i) {
 				ASSERT(be16_to_cpu(block->bb_numrecs) >=
@@ -696,7 +695,7 @@ xfs_alloc_insrec(
 		 * Next, try shifting an entry to the left neighbor.
 		 */
 		else {
-			if ((error = xfs_alloc_lshift(cur, level, &i)))
+			if ((error = xfs_btree_lshift(cur, level, &i)))
 				return error;
 			if (i)
 				optr = ptr = cur->bc_ptrs[level];
@@ -884,147 +883,6 @@ xfs_alloc_log_ptrs(
 }
 
 /*
- * Move 1 record left from cur/level if possible.
- * Update cur to reflect the new path.
- */
-STATIC int				/* error */
-xfs_alloc_lshift(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level to shift record on */
-	int			*stat)	/* success/failure */
-{
-	int			error;	/* error return value */
-#ifdef DEBUG
-	int			i;	/* loop index */
-#endif
-	xfs_alloc_key_t		key;	/* key value for leaf level upward */
-	xfs_buf_t		*lbp;	/* buffer for left neighbor block */
-	xfs_alloc_block_t	*left;	/* left neighbor btree block */
-	int			nrec;	/* new number of left block entries */
-	xfs_buf_t		*rbp;	/* buffer for right (current) block */
-	xfs_alloc_block_t	*right;	/* right (current) btree block */
-	xfs_alloc_key_t		*rkp=NULL;	/* key pointer for right block */
-	xfs_alloc_ptr_t		*rpp=NULL;	/* address pointer for right block */
-	xfs_alloc_rec_t		*rrp=NULL;	/* record pointer for right block */
-
-	/*
-	 * Set up variables for this block as "right".
-	 */
-	rbp = cur->bc_bufs[level];
-	right = XFS_BUF_TO_ALLOC_BLOCK(rbp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, right, level, rbp)))
-		return error;
-#endif
-	/*
-	 * If we've got no left sibling then we can't shift an entry left.
-	 */
-	if (be32_to_cpu(right->bb_leftsib) == NULLAGBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * If the cursor entry is the one that would be moved, don't
-	 * do it... it's too complicated.
-	 */
-	if (cur->bc_ptrs[level] <= 1) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * Set up the left neighbor as "left".
-	 */
-	if ((error = xfs_btree_read_bufs(cur->bc_mp, cur->bc_tp,
-			cur->bc_private.a.agno, be32_to_cpu(right->bb_leftsib),
-			0, &lbp, XFS_ALLOC_BTREE_REF)))
-		return error;
-	left = XFS_BUF_TO_ALLOC_BLOCK(lbp);
-	if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
-		return error;
-	/*
-	 * If it's full, it can't take another entry.
-	 */
-	if (be16_to_cpu(left->bb_numrecs) == XFS_ALLOC_BLOCK_MAXRECS(level, cur)) {
-		*stat = 0;
-		return 0;
-	}
-	nrec = be16_to_cpu(left->bb_numrecs) + 1;
-	/*
-	 * If non-leaf, copy a key and a ptr to the left block.
-	 */
-	if (level > 0) {
-		xfs_alloc_key_t	*lkp;	/* key pointer for left block */
-		xfs_alloc_ptr_t	*lpp;	/* address pointer for left block */
-
-		lkp = XFS_ALLOC_KEY_ADDR(left, nrec, cur);
-		rkp = XFS_ALLOC_KEY_ADDR(right, 1, cur);
-		*lkp = *rkp;
-		xfs_alloc_log_keys(cur, lbp, nrec, nrec);
-		lpp = XFS_ALLOC_PTR_ADDR(left, nrec, cur);
-		rpp = XFS_ALLOC_PTR_ADDR(right, 1, cur);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(*rpp), level)))
-			return error;
-#endif
-		*lpp = *rpp;
-		xfs_alloc_log_ptrs(cur, lbp, nrec, nrec);
-		xfs_btree_check_key(cur->bc_btnum, lkp - 1, lkp);
-	}
-	/*
-	 * If leaf, copy a record to the left block.
-	 */
-	else {
-		xfs_alloc_rec_t	*lrp;	/* record pointer for left block */
-
-		lrp = XFS_ALLOC_REC_ADDR(left, nrec, cur);
-		rrp = XFS_ALLOC_REC_ADDR(right, 1, cur);
-		*lrp = *rrp;
-		xfs_alloc_log_recs(cur, lbp, nrec, nrec);
-		xfs_btree_check_rec(cur->bc_btnum, lrp - 1, lrp);
-	}
-	/*
-	 * Bump and log left's numrecs, decrement and log right's numrecs.
-	 */
-	be16_add(&left->bb_numrecs, 1);
-	xfs_alloc_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS);
-	be16_add(&right->bb_numrecs, -1);
-	xfs_alloc_log_block(cur->bc_tp, rbp, XFS_BB_NUMRECS);
-	/*
-	 * Slide the contents of right down one entry.
-	 */
-	if (level > 0) {
-#ifdef DEBUG
-		for (i = 0; i < be16_to_cpu(right->bb_numrecs); i++) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(rpp[i + 1]),
-					level)))
-				return error;
-		}
-#endif
-		memmove(rkp, rkp + 1, be16_to_cpu(right->bb_numrecs) * sizeof(*rkp));
-		memmove(rpp, rpp + 1, be16_to_cpu(right->bb_numrecs) * sizeof(*rpp));
-		xfs_alloc_log_keys(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		xfs_alloc_log_ptrs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-	} else {
-		memmove(rrp, rrp + 1, be16_to_cpu(right->bb_numrecs) * sizeof(*rrp));
-		xfs_alloc_log_recs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		key.ar_startblock = rrp->ar_startblock;
-		key.ar_blockcount = rrp->ar_blockcount;
-		rkp = &key;
-	}
-	/*
-	 * Update the parent key values of right.
-	 */
-	if ((error = xfs_btree_updkey(cur, (union xfs_btree_key *)rkp, level + 1)))
-		return error;
-	/*
-	 * Slide the cursor value left one.
-	 */
-	cur->bc_ptrs[level]--;
-	*stat = 1;
-	return 0;
-}
-
-/*
  * Allocate a new root block, fill it in.
  */
 STATIC int				/* error */
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-08-03 13:30:46.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-08-03 13:33:04.000000000 +0200
@@ -52,7 +52,6 @@
 STATIC int xfs_bmbt_killroot(xfs_btree_cur_t *);
 STATIC void xfs_bmbt_log_keys(xfs_btree_cur_t *, xfs_buf_t *, int, int);
 STATIC void xfs_bmbt_log_ptrs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-STATIC int xfs_bmbt_lshift(xfs_btree_cur_t *, int, int *);
 STATIC int xfs_bmbt_split(xfs_btree_cur_t *, int, xfs_fsblock_t *,
 		__uint64_t *, xfs_btree_cur_t **, int *);
 
@@ -270,7 +269,7 @@ xfs_bmbt_delrec(
 		bno = be64_to_cpu(right->bb_leftsib);
 		if (be16_to_cpu(right->bb_numrecs) - 1 >=
 		    XFS_BMAP_BLOCK_IMINRECS(level, cur)) {
-			if ((error = xfs_bmbt_lshift(tcur, level, &i))) {
+			if ((error = xfs_btree_lshift(tcur, level, &i))) {
 				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 				goto error0;
 			}
@@ -544,7 +543,7 @@ xfs_bmbt_insrec(
 			if (i) {
 				/* nothing */
 			} else {
-				if ((error = xfs_bmbt_lshift(cur, level, &i))) {
+				if ((error = xfs_btree_lshift(cur, level, &i))) {
 					XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 					return error;
 				}
@@ -775,139 +774,6 @@ xfs_bmbt_log_ptrs(
 }
 
 /*
- * Move 1 record left from cur/level if possible.
- * Update cur to reflect the new path.
- */
-STATIC int					/* error */
-xfs_bmbt_lshift(
-	xfs_btree_cur_t		*cur,
-	int			level,
-	int			*stat)		/* success/failure */
-{
-	int			error;		/* error return value */
-#ifdef DEBUG
-	int			i;		/* loop counter */
-#endif
-	xfs_bmbt_key_t		key;		/* bmap btree key */
-	xfs_buf_t		*lbp;		/* left buffer pointer */
-	xfs_bmbt_block_t	*left;		/* left btree block */
-	xfs_bmbt_key_t		*lkp=NULL;	/* left btree key */
-	xfs_bmbt_ptr_t		*lpp;		/* left address pointer */
-	int			lrecs;		/* left record count */
-	xfs_bmbt_rec_t		*lrp=NULL;	/* left record pointer */
-	xfs_mount_t		*mp;		/* file system mount point */
-	xfs_buf_t		*rbp;		/* right buffer pointer */
-	xfs_bmbt_block_t	*right;		/* right btree block */
-	xfs_bmbt_key_t		*rkp=NULL;	/* right btree key */
-	xfs_bmbt_ptr_t		*rpp=NULL;	/* right address pointer */
-	xfs_bmbt_rec_t		*rrp=NULL;	/* right record pointer */
-	int			rrecs;		/* right record count */
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGI(cur, level);
-	if (level == cur->bc_nlevels - 1) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	rbp = cur->bc_bufs[level];
-	right = XFS_BUF_TO_BMBT_BLOCK(rbp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_lblock(cur, right, level, rbp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-#endif
-	if (be64_to_cpu(right->bb_leftsib) == NULLDFSBNO) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	if (cur->bc_ptrs[level] <= 1) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	mp = cur->bc_mp;
-	if ((error = xfs_btree_read_bufl(mp, cur->bc_tp, be64_to_cpu(right->bb_leftsib), 0,
-			&lbp, XFS_BMAP_BTREE_REF))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	left = XFS_BUF_TO_BMBT_BLOCK(lbp);
-	if ((error = xfs_btree_check_lblock(cur, left, level, lbp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	if (be16_to_cpu(left->bb_numrecs) == XFS_BMAP_BLOCK_IMAXRECS(level, cur)) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	lrecs = be16_to_cpu(left->bb_numrecs) + 1;
-	if (level > 0) {
-		lkp = XFS_BMAP_KEY_IADDR(left, lrecs, cur);
-		rkp = XFS_BMAP_KEY_IADDR(right, 1, cur);
-		*lkp = *rkp;
-		xfs_bmbt_log_keys(cur, lbp, lrecs, lrecs);
-		lpp = XFS_BMAP_PTR_IADDR(left, lrecs, cur);
-		rpp = XFS_BMAP_PTR_IADDR(right, 1, cur);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_lptr_disk(cur, *rpp, level))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-#endif
-		*lpp = *rpp;
-		xfs_bmbt_log_ptrs(cur, lbp, lrecs, lrecs);
-	} else {
-		lrp = XFS_BMAP_REC_IADDR(left, lrecs, cur);
-		rrp = XFS_BMAP_REC_IADDR(right, 1, cur);
-		*lrp = *rrp;
-		xfs_bmbt_log_recs(cur, lbp, lrecs, lrecs);
-	}
-	left->bb_numrecs = cpu_to_be16(lrecs);
-	xfs_bmbt_log_block(cur, lbp, XFS_BB_NUMRECS);
-#ifdef DEBUG
-	if (level > 0)
-		xfs_btree_check_key(XFS_BTNUM_BMAP, lkp - 1, lkp);
-	else
-		xfs_btree_check_rec(XFS_BTNUM_BMAP, lrp - 1, lrp);
-#endif
-	rrecs = be16_to_cpu(right->bb_numrecs) - 1;
-	right->bb_numrecs = cpu_to_be16(rrecs);
-	xfs_bmbt_log_block(cur, rbp, XFS_BB_NUMRECS);
-	if (level > 0) {
-#ifdef DEBUG
-		for (i = 0; i < rrecs; i++) {
-			if ((error = xfs_btree_check_lptr_disk(cur, rpp[i + 1],
-					level))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				return error;
-			}
-		}
-#endif
-		memmove(rkp, rkp + 1, rrecs * sizeof(*rkp));
-		memmove(rpp, rpp + 1, rrecs * sizeof(*rpp));
-		xfs_bmbt_log_keys(cur, rbp, 1, rrecs);
-		xfs_bmbt_log_ptrs(cur, rbp, 1, rrecs);
-	} else {
-		memmove(rrp, rrp + 1, rrecs * sizeof(*rrp));
-		xfs_bmbt_log_recs(cur, rbp, 1, rrecs);
-		key.br_startoff = cpu_to_be64(xfs_bmbt_disk_get_startoff(rrp));
-		rkp = &key;
-	}
-	if ((error = xfs_btree_updkey(cur, (union xfs_btree_key *)rkp, level + 1))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	cur->bc_ptrs[level]--;
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*stat = 1;
-	return 0;
-}
-
-/*
  * Determine the extent state.
  */
 /* ARGSUSED */
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-08-03 13:30:46.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-08-03 13:33:04.000000000 +0200
@@ -571,6 +571,7 @@ int xfs_btree_decrement(struct xfs_btree
 int xfs_btree_lookup(struct xfs_btree_cur *, xfs_lookup_t, int *);
 int xfs_btree_updkey(struct xfs_btree_cur *, union xfs_btree_key *, int);
 int xfs_btree_update(struct xfs_btree_cur *, union xfs_btree_rec *);
+int xfs_btree_lshift(struct xfs_btree_cur *, int, int *);
 int xfs_btree_rshift(struct xfs_btree_cur *, int, int *);
 
 
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-08-03 13:30:46.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-08-03 13:33:04.000000000 +0200
@@ -44,7 +44,6 @@ STATIC void xfs_inobt_log_block(xfs_tran
 STATIC void xfs_inobt_log_keys(xfs_btree_cur_t *, xfs_buf_t *, int, int);
 STATIC void xfs_inobt_log_ptrs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
 STATIC void xfs_inobt_log_recs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-STATIC int xfs_inobt_lshift(xfs_btree_cur_t *, int, int *);
 STATIC int xfs_inobt_newroot(xfs_btree_cur_t *, int *);
 STATIC int xfs_inobt_split(xfs_btree_cur_t *, int, xfs_agblock_t *,
 		xfs_inobt_key_t *, xfs_btree_cur_t **, int *);
@@ -277,7 +276,7 @@ xfs_inobt_delrec(
 		 */
 		if (be16_to_cpu(right->bb_numrecs) - 1 >=
 		     XFS_INOBT_BLOCK_MINRECS(level, cur)) {
-			if ((error = xfs_inobt_lshift(tcur, level, &i)))
+			if ((error = xfs_btree_lshift(tcur, level, &i)))
 				goto error0;
 			if (i) {
 				ASSERT(be16_to_cpu(block->bb_numrecs) >=
@@ -617,7 +616,7 @@ xfs_inobt_insrec(
 		 * Next, try shifting an entry to the left neighbor.
 		 */
 		else {
-			if ((error = xfs_inobt_lshift(cur, level, &i)))
+			if ((error = xfs_btree_lshift(cur, level, &i)))
 				return error;
 			if (i) {
 				optr = ptr = cur->bc_ptrs[level];
@@ -784,148 +783,6 @@ xfs_inobt_log_ptrs(
 }
 
 /*
- * Move 1 record left from cur/level if possible.
- * Update cur to reflect the new path.
- */
-STATIC int				/* error */
-xfs_inobt_lshift(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level to shift record on */
-	int			*stat)	/* success/failure */
-{
-	int			error;	/* error return value */
-#ifdef DEBUG
-	int			i;	/* loop index */
-#endif
-	xfs_inobt_key_t		key;	/* key value for leaf level upward */
-	xfs_buf_t		*lbp;	/* buffer for left neighbor block */
-	xfs_inobt_block_t	*left;	/* left neighbor btree block */
-	xfs_inobt_key_t		*lkp=NULL;	/* key pointer for left block */
-	xfs_inobt_ptr_t		*lpp;	/* address pointer for left block */
-	xfs_inobt_rec_t		*lrp=NULL;	/* record pointer for left block */
-	int			nrec;	/* new number of left block entries */
-	xfs_buf_t		*rbp;	/* buffer for right (current) block */
-	xfs_inobt_block_t	*right;	/* right (current) btree block */
-	xfs_inobt_key_t		*rkp=NULL;	/* key pointer for right block */
-	xfs_inobt_ptr_t		*rpp=NULL;	/* address pointer for right block */
-	xfs_inobt_rec_t		*rrp=NULL;	/* record pointer for right block */
-
-	/*
-	 * Set up variables for this block as "right".
-	 */
-	rbp = cur->bc_bufs[level];
-	right = XFS_BUF_TO_INOBT_BLOCK(rbp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, right, level, rbp)))
-		return error;
-#endif
-	/*
-	 * If we've got no left sibling then we can't shift an entry left.
-	 */
-	if (be32_to_cpu(right->bb_leftsib) == NULLAGBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * If the cursor entry is the one that would be moved, don't
-	 * do it... it's too complicated.
-	 */
-	if (cur->bc_ptrs[level] <= 1) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * Set up the left neighbor as "left".
-	 */
-	if ((error = xfs_btree_read_bufs(cur->bc_mp, cur->bc_tp,
-			cur->bc_private.a.agno, be32_to_cpu(right->bb_leftsib),
-			0, &lbp, XFS_INO_BTREE_REF)))
-		return error;
-	left = XFS_BUF_TO_INOBT_BLOCK(lbp);
-	if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
-		return error;
-	/*
-	 * If it's full, it can't take another entry.
-	 */
-	if (be16_to_cpu(left->bb_numrecs) == XFS_INOBT_BLOCK_MAXRECS(level, cur)) {
-		*stat = 0;
-		return 0;
-	}
-	nrec = be16_to_cpu(left->bb_numrecs) + 1;
-	/*
-	 * If non-leaf, copy a key and a ptr to the left block.
-	 */
-	if (level > 0) {
-		lkp = XFS_INOBT_KEY_ADDR(left, nrec, cur);
-		rkp = XFS_INOBT_KEY_ADDR(right, 1, cur);
-		*lkp = *rkp;
-		xfs_inobt_log_keys(cur, lbp, nrec, nrec);
-		lpp = XFS_INOBT_PTR_ADDR(left, nrec, cur);
-		rpp = XFS_INOBT_PTR_ADDR(right, 1, cur);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(*rpp), level)))
-			return error;
-#endif
-		*lpp = *rpp;
-		xfs_inobt_log_ptrs(cur, lbp, nrec, nrec);
-	}
-	/*
-	 * If leaf, copy a record to the left block.
-	 */
-	else {
-		lrp = XFS_INOBT_REC_ADDR(left, nrec, cur);
-		rrp = XFS_INOBT_REC_ADDR(right, 1, cur);
-		*lrp = *rrp;
-		xfs_inobt_log_recs(cur, lbp, nrec, nrec);
-	}
-	/*
-	 * Bump and log left's numrecs, decrement and log right's numrecs.
-	 */
-	be16_add(&left->bb_numrecs, 1);
-	xfs_inobt_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS);
-#ifdef DEBUG
-	if (level > 0)
-		xfs_btree_check_key(cur->bc_btnum, lkp - 1, lkp);
-	else
-		xfs_btree_check_rec(cur->bc_btnum, lrp - 1, lrp);
-#endif
-	be16_add(&right->bb_numrecs, -1);
-	xfs_inobt_log_block(cur->bc_tp, rbp, XFS_BB_NUMRECS);
-	/*
-	 * Slide the contents of right down one entry.
-	 */
-	if (level > 0) {
-#ifdef DEBUG
-		for (i = 0; i < be16_to_cpu(right->bb_numrecs); i++) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(rpp[i + 1]),
-					level)))
-				return error;
-		}
-#endif
-		memmove(rkp, rkp + 1, be16_to_cpu(right->bb_numrecs) * sizeof(*rkp));
-		memmove(rpp, rpp + 1, be16_to_cpu(right->bb_numrecs) * sizeof(*rpp));
-		xfs_inobt_log_keys(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		xfs_inobt_log_ptrs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-	} else {
-		memmove(rrp, rrp + 1, be16_to_cpu(right->bb_numrecs) * sizeof(*rrp));
-		xfs_inobt_log_recs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		key.ir_startino = rrp->ir_startino;
-		rkp = &key;
-	}
-	/*
-	 * Update the parent key values of right.
-	 */
-	if ((error = xfs_btree_updkey(cur, (union xfs_btree_key *)rkp, level + 1)))
-		return error;
-	/*
-	 * Slide the cursor value left one.
-	 */
-	cur->bc_ptrs[level]--;
-	*stat = 1;
-	return 0;
-}
-
-/*
  * Allocate a new root block, fill it in.
  */
 STATIC int				/* error */

-- 
