Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Aug 2008 18:33:40 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m741XR13032394
	for <xfs@oss.sgi.com>; Sun, 3 Aug 2008 18:33:28 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51B4A1976449
	for <xfs@oss.sgi.com>; Sun,  3 Aug 2008 18:34:40 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 0Ek3iYo5HJdN4VKP for <xfs@oss.sgi.com>; Sun, 03 Aug 2008 18:34:40 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m741YfIF009184
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 03:34:42 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m741YfKb009182
	for xfs@oss.sgi.com; Mon, 4 Aug 2008 03:34:41 +0200
Date: Mon, 4 Aug 2008 03:34:41 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/26] implement generic xfs_btree_rshift
Message-ID: <20080804013441.GQ8819@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-common-btree-rshift
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Make the btree right shift code generic.  Based on a patch from David Chinner
with lots of changes to follow the original btree implementations more
closely.  While this loses some of the generic helper routines for
inserting/moving/removing records it also solves some of the one off
bugs in the original code and makes it easier to verify.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-08-03 13:23:30.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-08-03 13:32:52.000000000 +0200
@@ -34,6 +34,7 @@
 #include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_inode_item.h"
 #include "xfs_btree.h"
 #include "xfs_btree_trace.h"
 #include "xfs_ialloc.h"
@@ -943,6 +944,137 @@ xfs_btree_read_buf_block(
 	return error;
 }
 
+STATIC void
+xfs_btree_set_ptr(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr_addr,
+	int			index,
+	union xfs_btree_ptr	*newptr)
+{
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		__be64		*pp = &ptr_addr->l;
+
+		pp[index] = newptr->l;
+	} else {
+		__be32		*pp = &ptr_addr->s;
+
+		pp[index] = newptr->s;
+	}
+}
+
+STATIC void
+xfs_btree_move_ptrs(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*base,
+	int			from,
+	int			to,
+	int			numptrs)
+{
+	ASSERT(from >= 0);
+	ASSERT(to >= 0);
+	ASSERT(numptrs >= 0);
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		__be64		*lpp = &base->l;
+
+		memmove(&lpp[to], &lpp[from], numptrs * sizeof(*lpp));
+	} else {
+		__be32		*spp = &base->s;
+
+		memmove(&spp[to], &spp[from], numptrs * sizeof(*spp));
+	}
+}
+
+/*
+ * Log block pointer fields from a btree block (nonleaf).
+ */
+STATIC void
+xfs_btree_log_ptrs(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	struct xfs_buf		*bp,	/* buffer containing btree block */
+	int			first,	/* index of first pointer to log */
+	int			last)	/* index of last pointer to log */
+{
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
+
+	if (bp) {
+		struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+		char			*baddr = (char *)block;
+		union xfs_btree_ptr	*pp;
+		int			start;	/* first byte offset logged */
+		int			end;	/* last byte offset logged */
+
+		pp = cur->bc_ops->ptr_addr(cur, 1, block);
+
+		if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+			__be64		*lpp = &pp->l;
+
+			start = (char *)&lpp[first - 1] - baddr;
+			end = (char *)&lpp[last] - 1 - baddr;
+		} else {
+			__be32		*spp = &pp->s;
+
+			start = (char *)&spp[first - 1] - baddr;
+			end = (char *)&spp[last] - 1 - baddr;
+		}
+
+		xfs_trans_log_buf(cur->bc_tp, bp, start, end);
+	} else {
+		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
+			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
+	}
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+}
+
+/*
+ * Log fields from the short from btree block header.
+ */
+STATIC void
+xfs_btree_log_block(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	struct xfs_buf		*bp,	/* buffer containing btree block */
+	int			fields)	/* mask of fields: XFS_BB_... */
+{
+	int			first;	/* first byte offset logged */
+	int			last;	/* last byte offset logged */
+	static const short	soffsets[] = {	/* table of offsets (short) */
+		offsetof(struct xfs_btree_sblock, bb_magic),
+		offsetof(struct xfs_btree_sblock, bb_level),
+		offsetof(struct xfs_btree_sblock, bb_numrecs),
+		offsetof(struct xfs_btree_sblock, bb_leftsib),
+		offsetof(struct xfs_btree_sblock, bb_rightsib),
+		sizeof(struct xfs_btree_sblock)
+	};
+	static const short	loffsets[] = {	/* table of offsets (long) */
+		offsetof(struct xfs_btree_lblock, bb_magic),
+		offsetof(struct xfs_btree_lblock, bb_level),
+		offsetof(struct xfs_btree_lblock, bb_numrecs),
+		offsetof(struct xfs_btree_lblock, bb_leftsib),
+		offsetof(struct xfs_btree_lblock, bb_rightsib),
+		sizeof(struct xfs_btree_lblock)
+	};
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGBI(cur, bp, fields);
+
+	if (bp) {
+		xfs_btree_offsets(fields,
+				  (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
+					loffsets : soffsets,
+				  XFS_BB_NUM_BITS, &first, &last);
+		xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+	} else {
+		/* XXX(hch): maybe factor out into a method? */
+		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
+			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
+	}
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+}
+
+
 /*
  * Increment cursor by one record at the level.
  * For nonzero levels the leaf-ward information is untouched.
@@ -1149,7 +1281,6 @@ error0:
 	return error;
 }
 
-
 STATIC int
 xfs_btree_lookup_get_block(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
@@ -1480,3 +1611,177 @@ error0:
 	return error;
 }
 
+/*
+ * Move 1 record right from cur/level if possible.
+ * Update cur to reflect the new path.
+ */
+int					/* error */
+xfs_btree_rshift(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	int			*stat)		/* success/failure */
+{
+	union xfs_btree_key	key;		/* btree key */
+	struct xfs_buf		*lbp;		/* left buffer pointer */
+	struct xfs_btree_block	*left;		/* left btree block */
+	struct xfs_buf		*rbp;		/* right buffer pointer */
+	struct xfs_btree_block	*right;		/* right btree block */
+	struct xfs_btree_cur	*tcur;		/* temporary btree cursor */
+	union xfs_btree_ptr	rptr;		/* right block pointer */
+	union xfs_btree_key	*rkp;		/* right btree key */
+	int			rrecs;		/* right record count */
+	int			lrecs;		/* left record count */
+	int			error;		/* error return value */
+	int			i;		/* loop counter */
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGI(cur, level);
+
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    (level == cur->bc_nlevels - 1))
+		goto out0;
+
+	/* Set up variables for this block as "left". */
+	left = xfs_btree_get_block(cur, level, &lbp);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, left, level, lbp);
+	if (error)
+		goto error0;
+#endif
+
+	/* If we've got no right sibling then we can't shift an entry right. */
+	xfs_btree_get_sibling(cur, left, &rptr, XFS_BB_RIGHTSIB);
+	if (xfs_btree_ptr_is_null(cur, &rptr))
+		goto out0;
+
+	/*
+	 * If the cursor entry is the one that would be moved, don't
+	 * do it... it's too complicated.
+	 */
+	lrecs = xfs_btree_get_numrecs(left);
+	if (cur->bc_ptrs[level] >= lrecs)
+		goto out0;
+
+	/* Set up the right neighbor as "right". */
+	error = xfs_btree_read_buf_block(cur, &rptr, level, 0, &right, &rbp);
+	if (error)
+		goto error0;
+
+	/* If it's full, it can't take another entry. */
+	rrecs = xfs_btree_get_numrecs(right);
+	if (rrecs == cur->bc_ops->get_maxrecs(cur, level))
+		goto out0;
+
+	XFS_BTREE_STATS_INC(cur, rshift);
+	XFS_BTREE_STATS_ADD(cur, moves, rrecs);
+
+	/*
+	 * Make a hole at the start of the right neighbor block, then
+	 * copy the last left block entry to the hole.
+	 */
+	if (level > 0) {
+		/* It's a nonleaf. make a hole in the keys and ptrs */
+		union xfs_btree_key	*lkp;
+		union xfs_btree_ptr	*lpp;
+		union xfs_btree_ptr	*rpp;
+
+		lkp = cur->bc_ops->key_addr(cur, lrecs, left);
+		lpp = cur->bc_ops->ptr_addr(cur, lrecs, left);
+		rkp = cur->bc_ops->key_addr(cur, 1, right);
+		rpp = cur->bc_ops->ptr_addr(cur, 1, right);
+
+#ifdef DEBUG
+		for (i = rrecs - 1; i >= 0; i--) {
+			error = xfs_btree_check_ptr(cur, rpp, i, level);
+			if (error)
+				goto error0;
+		}
+#endif
+
+		cur->bc_ops->move_keys(cur, rkp, 0, 1, rrecs);
+		xfs_btree_move_ptrs(cur, rpp, 0, 1, rrecs);
+
+#ifdef DEBUG
+		error = xfs_btree_check_ptr(cur, lpp, 0, level);
+		if (error)
+			goto error0;
+#endif
+
+		/* Now put the new data in, and log it. */
+		cur->bc_ops->set_key(cur, rkp, 0, lkp);
+		xfs_btree_set_ptr(cur, rpp, 0, lpp);
+
+		cur->bc_ops->log_keys(cur, rbp, 1, rrecs + 1);
+		xfs_btree_log_ptrs(cur, rbp, 1, rrecs + 1);
+
+		xfs_btree_check_key(cur->bc_btnum, rkp,
+				    cur->bc_ops->key_addr(cur, 2, right));
+	} else {
+		/* It's a leaf. make a hole in the records */
+		union xfs_btree_rec	*lrp;
+		union xfs_btree_rec	*rrp;
+
+		lrp = cur->bc_ops->rec_addr(cur, lrecs, left);
+		rrp = cur->bc_ops->rec_addr(cur, 1, right);
+
+		cur->bc_ops->move_recs(cur, rrp, 0, 1, rrecs);
+
+		/* Now put the new data in, and log it. */
+		cur->bc_ops->set_rec(cur, rrp, 0, lrp);
+		cur->bc_ops->log_recs(cur, rbp, 1, rrecs + 1);
+
+		cur->bc_ops->init_key_from_rec(cur, &key, rrp);
+		rkp = &key;
+
+		xfs_btree_check_rec(cur->bc_btnum, rrp,
+				    cur->bc_ops->rec_addr(cur, 2, right));
+	}
+
+	/*
+	 * Decrement and log left's numrecs, bump and log right's numrecs.
+	 */
+	xfs_btree_set_numrecs(left, --lrecs);
+	xfs_btree_log_block(cur, lbp, XFS_BB_NUMRECS);
+
+	xfs_btree_set_numrecs(right, ++rrecs);
+	xfs_btree_log_block(cur, rbp, XFS_BB_NUMRECS);
+
+	/*
+	 * Using a temporary cursor, update the parent key values of the
+	 * block on the right.
+	 */
+	error = xfs_btree_dup_cursor(cur, &tcur);
+	if (error)
+		goto error0;
+	i = xfs_btree_lastrec(tcur, level);
+	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+	error = xfs_btree_increment(tcur, level, &i);
+	if (error)
+		goto error1;
+
+	error = xfs_btree_updkey(tcur, rkp, level + 1);
+	if (error)
+		goto error1;
+
+	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
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
+
+error1:
+	XFS_BTREE_TRACE_CURSOR(tcur, XBT_ERROR);
+	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
+	return error;
+}
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-08-03 13:23:30.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-08-03 13:30:46.000000000 +0200
@@ -214,6 +214,22 @@ struct xfs_btree_ops {
 	__int64_t (*key_diff)(struct xfs_btree_cur *cur,
 			      union xfs_btree_key *key);
 
+	/* set values of btree structures */
+	void	(*set_key)(struct xfs_btree_cur *cur,
+			   union xfs_btree_key *oldkey, int index,
+			   union xfs_btree_key *newkey);
+	void	(*set_rec)(struct xfs_btree_cur *cur,
+			   union xfs_btree_rec *oldrec, int index,
+			   union xfs_btree_rec *newrec);
+
+	/* move bits of btree blocks within a block */
+	void	(*move_keys)(struct xfs_btree_cur *cur,
+			     union xfs_btree_key *base, int src_index,
+			     int dst_index, int numkeys);
+	void	(*move_recs)(struct xfs_btree_cur *cur,
+			     union xfs_btree_rec *base, int src_index,
+			     int dst_index, int numrecs);
+
 	/* copy bits of btree blocks between blocks */
 	void	(*copy_keys)(struct xfs_btree_cur *cur,
 			     union xfs_btree_key *src_key,
@@ -555,6 +571,7 @@ int xfs_btree_decrement(struct xfs_btree
 int xfs_btree_lookup(struct xfs_btree_cur *, xfs_lookup_t, int *);
 int xfs_btree_updkey(struct xfs_btree_cur *, union xfs_btree_key *, int);
 int xfs_btree_update(struct xfs_btree_cur *, union xfs_btree_rec *);
+int xfs_btree_rshift(struct xfs_btree_cur *, int, int *);
 
 
 /*
@@ -567,6 +584,12 @@ xfs_btree_get_numrecs(struct xfs_btree_b
 	return be16_to_cpu(block->bb_numrecs);
 }
 
+static inline void
+xfs_btree_set_numrecs(struct xfs_btree_block *block, __uint16_t numrecs)
+{
+	block->bb_numrecs = cpu_to_be16(numrecs);
+}
+
 #endif	/* __KERNEL__ */
 
 
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-08-03 13:23:30.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-08-03 13:30:46.000000000 +0200
@@ -54,7 +54,6 @@ STATIC void xfs_allocbt_log_recs(xfs_btr
 	xfs_allocbt_log_recs(c, b, i, j)
 STATIC int xfs_alloc_lshift(xfs_btree_cur_t *, int, int *);
 STATIC int xfs_alloc_newroot(xfs_btree_cur_t *, int *);
-STATIC int xfs_alloc_rshift(xfs_btree_cur_t *, int, int *);
 STATIC int xfs_alloc_split(xfs_btree_cur_t *, int, xfs_agblock_t *,
 		xfs_alloc_key_t *, xfs_btree_cur_t **, int *);
 
@@ -396,7 +395,7 @@ xfs_alloc_delrec(
 		 */
 		if (be16_to_cpu(left->bb_numrecs) - 1 >=
 		     XFS_ALLOC_BLOCK_MINRECS(level, cur)) {
-			if ((error = xfs_alloc_rshift(tcur, level, &i)))
+			if ((error = xfs_btree_rshift(tcur, level, &i)))
 				goto error0;
 			if (i) {
 				ASSERT(be16_to_cpu(block->bb_numrecs) >=
@@ -688,7 +687,7 @@ xfs_alloc_insrec(
 		/*
 		 * First, try shifting an entry to the right neighbor.
 		 */
-		if ((error = xfs_alloc_rshift(cur, level, &i)))
+		if ((error = xfs_btree_rshift(cur, level, &i)))
 			return error;
 		if (i) {
 			/* nothing */
@@ -1181,137 +1180,6 @@ xfs_alloc_newroot(
 }
 
 /*
- * Move 1 record right from cur/level if possible.
- * Update cur to reflect the new path.
- */
-STATIC int				/* error */
-xfs_alloc_rshift(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level to shift record on */
-	int			*stat)	/* success/failure */
-{
-	int			error;	/* error return value */
-	int			i;	/* loop index */
-	xfs_alloc_key_t		key;	/* key value for leaf level upward */
-	xfs_buf_t		*lbp;	/* buffer for left (current) block */
-	xfs_alloc_block_t	*left;	/* left (current) btree block */
-	xfs_buf_t		*rbp;	/* buffer for right neighbor block */
-	xfs_alloc_block_t	*right;	/* right neighbor btree block */
-	xfs_alloc_key_t		*rkp;	/* key pointer for right block */
-	xfs_btree_cur_t		*tcur;	/* temporary cursor */
-
-	/*
-	 * Set up variables for this block as "left".
-	 */
-	lbp = cur->bc_bufs[level];
-	left = XFS_BUF_TO_ALLOC_BLOCK(lbp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
-		return error;
-#endif
-	/*
-	 * If we've got no right sibling then we can't shift an entry right.
-	 */
-	if (be32_to_cpu(left->bb_rightsib) == NULLAGBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * If the cursor entry is the one that would be moved, don't
-	 * do it... it's too complicated.
-	 */
-	if (cur->bc_ptrs[level] >= be16_to_cpu(left->bb_numrecs)) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * Set up the right neighbor as "right".
-	 */
-	if ((error = xfs_btree_read_bufs(cur->bc_mp, cur->bc_tp,
-			cur->bc_private.a.agno, be32_to_cpu(left->bb_rightsib),
-			0, &rbp, XFS_ALLOC_BTREE_REF)))
-		return error;
-	right = XFS_BUF_TO_ALLOC_BLOCK(rbp);
-	if ((error = xfs_btree_check_sblock(cur, right, level, rbp)))
-		return error;
-	/*
-	 * If it's full, it can't take another entry.
-	 */
-	if (be16_to_cpu(right->bb_numrecs) == XFS_ALLOC_BLOCK_MAXRECS(level, cur)) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * Make a hole at the start of the right neighbor block, then
-	 * copy the last left block entry to the hole.
-	 */
-	if (level > 0) {
-		xfs_alloc_key_t	*lkp;	/* key pointer for left block */
-		xfs_alloc_ptr_t	*lpp;	/* address pointer for left block */
-		xfs_alloc_ptr_t	*rpp;	/* address pointer for right block */
-
-		lkp = XFS_ALLOC_KEY_ADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		lpp = XFS_ALLOC_PTR_ADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		rkp = XFS_ALLOC_KEY_ADDR(right, 1, cur);
-		rpp = XFS_ALLOC_PTR_ADDR(right, 1, cur);
-#ifdef DEBUG
-		for (i = be16_to_cpu(right->bb_numrecs) - 1; i >= 0; i--) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(rpp[i]), level)))
-				return error;
-		}
-#endif
-		memmove(rkp + 1, rkp, be16_to_cpu(right->bb_numrecs) * sizeof(*rkp));
-		memmove(rpp + 1, rpp, be16_to_cpu(right->bb_numrecs) * sizeof(*rpp));
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(*lpp), level)))
-			return error;
-#endif
-		*rkp = *lkp;
-		*rpp = *lpp;
-		xfs_alloc_log_keys(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-		xfs_alloc_log_ptrs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-		xfs_btree_check_key(cur->bc_btnum, rkp, rkp + 1);
-	} else {
-		xfs_alloc_rec_t	*lrp;	/* record pointer for left block */
-		xfs_alloc_rec_t	*rrp;	/* record pointer for right block */
-
-		lrp = XFS_ALLOC_REC_ADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		rrp = XFS_ALLOC_REC_ADDR(right, 1, cur);
-		memmove(rrp + 1, rrp, be16_to_cpu(right->bb_numrecs) * sizeof(*rrp));
-		*rrp = *lrp;
-		xfs_alloc_log_recs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-		key.ar_startblock = rrp->ar_startblock;
-		key.ar_blockcount = rrp->ar_blockcount;
-		rkp = &key;
-		xfs_btree_check_rec(cur->bc_btnum, rrp, rrp + 1);
-	}
-	/*
-	 * Decrement and log left's numrecs, bump and log right's numrecs.
-	 */
-	be16_add(&left->bb_numrecs, -1);
-	xfs_alloc_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS);
-	be16_add(&right->bb_numrecs, 1);
-	xfs_alloc_log_block(cur->bc_tp, rbp, XFS_BB_NUMRECS);
-	/*
-	 * Using a temporary cursor, update the parent key values of the
-	 * block on the right.
-	 */
-	if ((error = xfs_btree_dup_cursor(cur, &tcur)))
-		return error;
-	i = xfs_btree_lastrec(tcur, level);
-	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-	if ((error = xfs_btree_increment(tcur, level, &i)) ||
-	    (error = xfs_btree_updkey(tcur, (union xfs_btree_key *)rkp, level + 1)))
-		goto error0;
-	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
-	*stat = 1;
-	return 0;
-error0:
-	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
-	return error;
-}
-
-/*
  * Split cur/level block in half.
  * Return new block number and its first record (to be inserted into parent).
  */
@@ -1737,6 +1605,64 @@ xfs_allocbt_key_diff(
 }
 
 STATIC void
+xfs_allocbt_set_key(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key_addr,
+	int			index,
+	union xfs_btree_key	*newkey)
+{
+	xfs_alloc_key_t		*kp = &key_addr->alloc;
+
+	kp[index] = newkey->alloc;
+}
+
+STATIC void
+xfs_allocbt_set_rec(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec_addr,
+	int			index,
+	union xfs_btree_rec	*newrec)
+{
+	xfs_alloc_rec_t		*rp = &rec_addr->alloc;
+
+	rp[index] = newrec->alloc;
+}
+
+STATIC void
+xfs_allocbt_move_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*base,
+	int			from,
+	int			to,
+	int			numkeys)
+{
+	xfs_alloc_key_t		*kp = &base->alloc;
+
+	ASSERT(from >= 0);
+	ASSERT(to >= 0);
+	ASSERT(numkeys >= 0);
+
+	memmove(&kp[to], &kp[from], numkeys * sizeof(*kp));
+}
+
+STATIC void
+xfs_allocbt_move_recs(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*base,
+	int			from,
+	int			to,
+	int			numrecs)
+{
+	xfs_alloc_rec_t		*rp = &base->alloc;
+
+	ASSERT(from >= 0);
+	ASSERT(to >= 0);
+	ASSERT(numrecs >= 0);
+
+	memmove(&rp[to], &rp[from], numrecs * sizeof(*rp));
+}
+
+STATIC void
 xfs_allocbt_copy_keys(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_key	*src_key,
@@ -1910,6 +1836,10 @@ static const struct xfs_btree_ops xfs_al
 	.key_addr		= xfs_allocbt_key_addr,
 	.rec_addr		= xfs_allocbt_rec_addr,
 	.key_diff		= xfs_allocbt_key_diff,
+	.set_key		= xfs_allocbt_set_key,
+	.set_rec		= xfs_allocbt_set_rec,
+	.move_keys		= xfs_allocbt_move_keys,
+	.move_recs		= xfs_allocbt_move_recs,
 	.copy_keys		= xfs_allocbt_copy_keys,
 	.copy_recs		= xfs_allocbt_copy_recs,
 	.log_keys		= xfs_allocbt_log_keys,
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-08-03 13:23:30.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-08-03 13:30:46.000000000 +0200
@@ -46,7 +46,6 @@ STATIC void xfs_inobt_log_ptrs(xfs_btree
 STATIC void xfs_inobt_log_recs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
 STATIC int xfs_inobt_lshift(xfs_btree_cur_t *, int, int *);
 STATIC int xfs_inobt_newroot(xfs_btree_cur_t *, int *);
-STATIC int xfs_inobt_rshift(xfs_btree_cur_t *, int, int *);
 STATIC int xfs_inobt_split(xfs_btree_cur_t *, int, xfs_agblock_t *,
 		xfs_inobt_key_t *, xfs_btree_cur_t **, int *);
 
@@ -338,7 +337,7 @@ xfs_inobt_delrec(
 		 */
 		if (be16_to_cpu(left->bb_numrecs) - 1 >=
 		     XFS_INOBT_BLOCK_MINRECS(level, cur)) {
-			if ((error = xfs_inobt_rshift(tcur, level, &i)))
+			if ((error = xfs_btree_rshift(tcur, level, &i)))
 				goto error0;
 			if (i) {
 				ASSERT(be16_to_cpu(block->bb_numrecs) >=
@@ -609,7 +608,7 @@ xfs_inobt_insrec(
 		/*
 		 * First, try shifting an entry to the right neighbor.
 		 */
-		if ((error = xfs_inobt_rshift(cur, level, &i)))
+		if ((error = xfs_btree_rshift(cur, level, &i)))
 			return error;
 		if (i) {
 			/* nothing */
@@ -1074,136 +1073,6 @@ xfs_inobt_newroot(
 }
 
 /*
- * Move 1 record right from cur/level if possible.
- * Update cur to reflect the new path.
- */
-STATIC int				/* error */
-xfs_inobt_rshift(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level to shift record on */
-	int			*stat)	/* success/failure */
-{
-	int			error;	/* error return value */
-	int			i;	/* loop index */
-	xfs_inobt_key_t		key;	/* key value for leaf level upward */
-	xfs_buf_t		*lbp;	/* buffer for left (current) block */
-	xfs_inobt_block_t	*left;	/* left (current) btree block */
-	xfs_inobt_key_t		*lkp;	/* key pointer for left block */
-	xfs_inobt_ptr_t		*lpp;	/* address pointer for left block */
-	xfs_inobt_rec_t		*lrp;	/* record pointer for left block */
-	xfs_buf_t		*rbp;	/* buffer for right neighbor block */
-	xfs_inobt_block_t	*right;	/* right neighbor btree block */
-	xfs_inobt_key_t		*rkp;	/* key pointer for right block */
-	xfs_inobt_ptr_t		*rpp;	/* address pointer for right block */
-	xfs_inobt_rec_t		*rrp=NULL;	/* record pointer for right block */
-	xfs_btree_cur_t		*tcur;	/* temporary cursor */
-
-	/*
-	 * Set up variables for this block as "left".
-	 */
-	lbp = cur->bc_bufs[level];
-	left = XFS_BUF_TO_INOBT_BLOCK(lbp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
-		return error;
-#endif
-	/*
-	 * If we've got no right sibling then we can't shift an entry right.
-	 */
-	if (be32_to_cpu(left->bb_rightsib) == NULLAGBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * If the cursor entry is the one that would be moved, don't
-	 * do it... it's too complicated.
-	 */
-	if (cur->bc_ptrs[level] >= be16_to_cpu(left->bb_numrecs)) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * Set up the right neighbor as "right".
-	 */
-	if ((error = xfs_btree_read_bufs(cur->bc_mp, cur->bc_tp,
-			cur->bc_private.a.agno, be32_to_cpu(left->bb_rightsib),
-			0, &rbp, XFS_INO_BTREE_REF)))
-		return error;
-	right = XFS_BUF_TO_INOBT_BLOCK(rbp);
-	if ((error = xfs_btree_check_sblock(cur, right, level, rbp)))
-		return error;
-	/*
-	 * If it's full, it can't take another entry.
-	 */
-	if (be16_to_cpu(right->bb_numrecs) == XFS_INOBT_BLOCK_MAXRECS(level, cur)) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * Make a hole at the start of the right neighbor block, then
-	 * copy the last left block entry to the hole.
-	 */
-	if (level > 0) {
-		lkp = XFS_INOBT_KEY_ADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		lpp = XFS_INOBT_PTR_ADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		rkp = XFS_INOBT_KEY_ADDR(right, 1, cur);
-		rpp = XFS_INOBT_PTR_ADDR(right, 1, cur);
-#ifdef DEBUG
-		for (i = be16_to_cpu(right->bb_numrecs) - 1; i >= 0; i--) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(rpp[i]), level)))
-				return error;
-		}
-#endif
-		memmove(rkp + 1, rkp, be16_to_cpu(right->bb_numrecs) * sizeof(*rkp));
-		memmove(rpp + 1, rpp, be16_to_cpu(right->bb_numrecs) * sizeof(*rpp));
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(*lpp), level)))
-			return error;
-#endif
-		*rkp = *lkp;
-		*rpp = *lpp;
-		xfs_inobt_log_keys(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-		xfs_inobt_log_ptrs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-	} else {
-		lrp = XFS_INOBT_REC_ADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		rrp = XFS_INOBT_REC_ADDR(right, 1, cur);
-		memmove(rrp + 1, rrp, be16_to_cpu(right->bb_numrecs) * sizeof(*rrp));
-		*rrp = *lrp;
-		xfs_inobt_log_recs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-		key.ir_startino = rrp->ir_startino;
-		rkp = &key;
-	}
-	/*
-	 * Decrement and log left's numrecs, bump and log right's numrecs.
-	 */
-	be16_add(&left->bb_numrecs, -1);
-	xfs_inobt_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS);
-	be16_add(&right->bb_numrecs, 1);
-#ifdef DEBUG
-	if (level > 0)
-		xfs_btree_check_key(cur->bc_btnum, rkp, rkp + 1);
-	else
-		xfs_btree_check_rec(cur->bc_btnum, rrp, rrp + 1);
-#endif
-	xfs_inobt_log_block(cur->bc_tp, rbp, XFS_BB_NUMRECS);
-	/*
-	 * Using a temporary cursor, update the parent key values of the
-	 * block on the right.
-	 */
-	if ((error = xfs_btree_dup_cursor(cur, &tcur)))
-		return error;
-	xfs_btree_lastrec(tcur, level);
-	if ((error = xfs_btree_increment(tcur, level, &i)) ||
-	    (error = xfs_btree_updkey(tcur, (union xfs_btree_key *)rkp, level + 1))) {
-		xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
-		return error;
-	}
-	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
-	*stat = 1;
-	return 0;
-}
-
-/*
  * Split cur/level block in half.
  * Return new block number and its first record (to be inserted into parent).
  */
@@ -1585,6 +1454,64 @@ xfs_inobt_key_diff(
 }
 
 STATIC void
+xfs_inobt_set_key(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key_addr,
+	int			index,
+	union xfs_btree_key	*newkey)
+{
+	xfs_inobt_key_t		*kp = &key_addr->inobt;
+
+	kp[index] = newkey->inobt;
+}
+
+STATIC void
+xfs_inobt_set_rec(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec_addr,
+	int			index,
+	union xfs_btree_rec	*newrec)
+{
+	xfs_inobt_rec_t		*rp = &rec_addr->inobt;
+
+	rp[index] = newrec->inobt;
+}
+
+STATIC void
+xfs_inobt_move_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*base,
+	int			from,
+	int			to,
+	int			numkeys)
+{
+	xfs_inobt_key_t		*kp = &base->inobt;
+
+	ASSERT(from >= 0);
+	ASSERT(to >= 0);
+	ASSERT(numkeys >= 0);
+
+	memmove(&kp[to], &kp[from], numkeys * sizeof(*kp));
+}
+
+STATIC void
+xfs_inobt_move_recs(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*base,
+	int			from,
+	int			to,
+	int			numrecs)
+{
+	xfs_inobt_rec_t		*rp = &base->inobt;
+
+	ASSERT(from >= 0);
+	ASSERT(to >= 0);
+	ASSERT(numrecs >= 0);
+
+	memmove(&rp[to], &rp[from], numrecs * sizeof(*rp));
+}
+
+STATIC void
 xfs_inobt_copy_keys(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_key	*src_key,
@@ -1735,6 +1662,11 @@ static const struct xfs_btree_ops xfs_in
 	.key_addr		= xfs_inobt_key_addr,
 	.rec_addr		= xfs_inobt_rec_addr,
 	.key_diff		= xfs_inobt_key_diff,
+	.set_key		= xfs_inobt_set_key,
+	.set_rec		= xfs_inobt_set_rec,
+	.move_keys		= xfs_inobt_move_keys,
+	.move_recs		= xfs_inobt_move_recs,
+
 	.copy_keys		= xfs_inobt_copy_keys,
 	.copy_recs		= xfs_inobt_copy_recs,
 	.log_keys		= xfs_inobt_log_keys,
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-08-03 13:23:30.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-08-03 13:30:46.000000000 +0200
@@ -53,7 +53,6 @@ STATIC int xfs_bmbt_killroot(xfs_btree_c
 STATIC void xfs_bmbt_log_keys(xfs_btree_cur_t *, xfs_buf_t *, int, int);
 STATIC void xfs_bmbt_log_ptrs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
 STATIC int xfs_bmbt_lshift(xfs_btree_cur_t *, int, int *);
-STATIC int xfs_bmbt_rshift(xfs_btree_cur_t *, int, int *);
 STATIC int xfs_bmbt_split(xfs_btree_cur_t *, int, xfs_fsblock_t *,
 		__uint64_t *, xfs_btree_cur_t **, int *);
 
@@ -327,7 +326,7 @@ xfs_bmbt_delrec(
 		bno = be64_to_cpu(left->bb_rightsib);
 		if (be16_to_cpu(left->bb_numrecs) - 1 >=
 		    XFS_BMAP_BLOCK_IMINRECS(level, cur)) {
-			if ((error = xfs_bmbt_rshift(tcur, level, &i))) {
+			if ((error = xfs_btree_rshift(tcur, level, &i))) {
 				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 				goto error0;
 			}
@@ -538,7 +537,7 @@ xfs_bmbt_insrec(
 				logflags);
 			block = xfs_bmbt_get_block(cur, level, &bp);
 		} else {
-			if ((error = xfs_bmbt_rshift(cur, level, &i))) {
+			if ((error = xfs_btree_rshift(cur, level, &i))) {
 				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 				return error;
 			}
@@ -909,143 +908,6 @@ xfs_bmbt_lshift(
 }
 
 /*
- * Move 1 record right from cur/level if possible.
- * Update cur to reflect the new path.
- */
-STATIC int					/* error */
-xfs_bmbt_rshift(
-	xfs_btree_cur_t		*cur,
-	int			level,
-	int			*stat)		/* success/failure */
-{
-	int			error;		/* error return value */
-	int			i;		/* loop counter */
-	xfs_bmbt_key_t		key;		/* bmap btree key */
-	xfs_buf_t		*lbp;		/* left buffer pointer */
-	xfs_bmbt_block_t	*left;		/* left btree block */
-	xfs_bmbt_key_t		*lkp;		/* left btree key */
-	xfs_bmbt_ptr_t		*lpp;		/* left address pointer */
-	xfs_bmbt_rec_t		*lrp;		/* left record pointer */
-	xfs_mount_t		*mp;		/* file system mount point */
-	xfs_buf_t		*rbp;		/* right buffer pointer */
-	xfs_bmbt_block_t	*right;		/* right btree block */
-	xfs_bmbt_key_t		*rkp;		/* right btree key */
-	xfs_bmbt_ptr_t		*rpp;		/* right address pointer */
-	xfs_bmbt_rec_t		*rrp=NULL;	/* right record pointer */
-	struct xfs_btree_cur	*tcur;		/* temporary btree cursor */
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGI(cur, level);
-	if (level == cur->bc_nlevels - 1) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	lbp = cur->bc_bufs[level];
-	left = XFS_BUF_TO_BMBT_BLOCK(lbp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_lblock(cur, left, level, lbp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-#endif
-	if (be64_to_cpu(left->bb_rightsib) == NULLDFSBNO) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	if (cur->bc_ptrs[level] >= be16_to_cpu(left->bb_numrecs)) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	mp = cur->bc_mp;
-	if ((error = xfs_btree_read_bufl(mp, cur->bc_tp, be64_to_cpu(left->bb_rightsib), 0,
-			&rbp, XFS_BMAP_BTREE_REF))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	right = XFS_BUF_TO_BMBT_BLOCK(rbp);
-	if ((error = xfs_btree_check_lblock(cur, right, level, rbp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	if (be16_to_cpu(right->bb_numrecs) == XFS_BMAP_BLOCK_IMAXRECS(level, cur)) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	if (level > 0) {
-		lkp = XFS_BMAP_KEY_IADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		lpp = XFS_BMAP_PTR_IADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		rkp = XFS_BMAP_KEY_IADDR(right, 1, cur);
-		rpp = XFS_BMAP_PTR_IADDR(right, 1, cur);
-#ifdef DEBUG
-		for (i = be16_to_cpu(right->bb_numrecs) - 1; i >= 0; i--) {
-			if ((error = xfs_btree_check_lptr_disk(cur, rpp[i], level))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				return error;
-			}
-		}
-#endif
-		memmove(rkp + 1, rkp, be16_to_cpu(right->bb_numrecs) * sizeof(*rkp));
-		memmove(rpp + 1, rpp, be16_to_cpu(right->bb_numrecs) * sizeof(*rpp));
-#ifdef DEBUG
-		if ((error = xfs_btree_check_lptr_disk(cur, *lpp, level))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-#endif
-		*rkp = *lkp;
-		*rpp = *lpp;
-		xfs_bmbt_log_keys(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-		xfs_bmbt_log_ptrs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-	} else {
-		lrp = XFS_BMAP_REC_IADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		rrp = XFS_BMAP_REC_IADDR(right, 1, cur);
-		memmove(rrp + 1, rrp, be16_to_cpu(right->bb_numrecs) * sizeof(*rrp));
-		*rrp = *lrp;
-		xfs_bmbt_log_recs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-		key.br_startoff = cpu_to_be64(xfs_bmbt_disk_get_startoff(rrp));
-		rkp = &key;
-	}
-	be16_add(&left->bb_numrecs, -1);
-	xfs_bmbt_log_block(cur, lbp, XFS_BB_NUMRECS);
-	be16_add(&right->bb_numrecs, 1);
-#ifdef DEBUG
-	if (level > 0)
-		xfs_btree_check_key(XFS_BTNUM_BMAP, rkp, rkp + 1);
-	else
-		xfs_btree_check_rec(XFS_BTNUM_BMAP, rrp, rrp + 1);
-#endif
-	xfs_bmbt_log_block(cur, rbp, XFS_BB_NUMRECS);
-	if ((error = xfs_btree_dup_cursor(cur, &tcur))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	i = xfs_btree_lastrec(tcur, level);
-	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-	if ((error = xfs_btree_increment(tcur, level, &i))) {
-		XFS_BMBT_TRACE_CURSOR(tcur, ERROR);
-		goto error1;
-	}
-	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-	if ((error = xfs_btree_updkey(tcur, (union xfs_btree_key *)rkp, level + 1))) {
-		XFS_BMBT_TRACE_CURSOR(tcur, ERROR);
-		goto error1;
-	}
-	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*stat = 1;
-	return 0;
-error0:
-	XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-error1:
-	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
-	return error;
-}
-
-/*
  * Determine the extent state.
  */
 /* ARGSUSED */
@@ -2018,6 +1880,64 @@ xfs_bmbt_key_diff(
 }
 
 STATIC void
+xfs_bmbt_set_key(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key_addr,
+	int			index,
+	union xfs_btree_key	*newkey)
+{
+	xfs_bmbt_key_t		*kp = &key_addr->bmbt;
+
+	kp[index] = newkey->bmbt;
+}
+
+STATIC void
+xfs_bmbt_set_rec(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec_addr,
+	int			index,
+	union xfs_btree_rec	*newrec)
+{
+	xfs_bmbt_rec_t		*rp = &rec_addr->bmbt;
+
+	rp[index] = newrec->bmbt;
+}
+
+STATIC void
+xfs_bmbt_move_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*base,
+	int			from,
+	int			to,
+	int			numkeys)
+{
+	xfs_bmbt_key_t		*kp = &base->bmbt;
+
+	ASSERT(from >= 0 && from <= 1000);
+	ASSERT(to >= 0 && to <= 1000);
+	ASSERT(numkeys >= 0);
+
+	memmove(&kp[to], &kp[from], numkeys * sizeof(*kp));
+}
+
+STATIC void
+xfs_bmbt_move_recs(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*base,
+	int			from,
+	int			to,
+	int			numrecs)
+{
+	xfs_bmbt_rec_t		*rp = &base->bmbt;
+
+	ASSERT(from >= 0);
+	ASSERT(to >= 0);
+	ASSERT(numrecs >= 0);
+
+	memmove(&rp[to], &rp[from], numrecs * sizeof(*rp));
+}
+
+STATIC void
 xfs_bmbt_copy_keys(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_key	*src_key,
@@ -2192,6 +2112,10 @@ static const struct xfs_btree_ops xfs_bm
 	.key_addr		= xfs_bmbt_key_addr,
 	.rec_addr		= xfs_bmbt_rec_addr,
 	.key_diff		= xfs_bmbt_key_diff,
+	.set_key		= xfs_bmbt_set_key,
+	.set_rec		= xfs_bmbt_set_rec,
+	.move_keys		= xfs_bmbt_move_keys,
+	.move_recs		= xfs_bmbt_move_recs,
 	.copy_keys		= xfs_bmbt_copy_keys,
 	.copy_recs		= xfs_bmbt_copy_recs,
 	.log_keys		= xfs_bmbt_log_keys,

-- 
