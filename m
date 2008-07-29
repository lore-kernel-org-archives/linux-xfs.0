Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 12:29:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6TJTjti031840
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:29:45 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C15BD33F1FF
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:30:55 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id OGZwb7t6EBvrhFGj for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:30:55 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6TJUrIF019266
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 21:30:53 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6TJUrMP019264
	for xfs@oss.sgi.com; Tue, 29 Jul 2008 21:30:53 +0200
Date: Tue, 29 Jul 2008 21:30:53 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/21] implement generic xfs_btree_increment
Message-ID: <20080729193053.GJ19104@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-common-btree-increment
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

From: Dave Chinner <dgc@sgi.com>

Because this is the first major generic btree routine this patch
includes some infrastrucure, fistly a few routines to deal with
a btree block that can be either in short or long form, and secondly
xfs_btree_read_buf_block, which is the new central routine to read
a btree block given a cursor.

[hch: split out from bigger patch and minor adaptions]

Signed-off-by: Christoph Hellwig <hch@lst.de>

Notes:

 - xfs_btree_read_buf_block now includes a xfs_btree_check_block, removed duplicate call

Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-07-21 04:41:59.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-07-21 06:46:13.000000000 +0200
@@ -191,6 +191,10 @@ struct xfs_btree_ops {
 	/* get inode rooted btree root */
 	struct xfs_btree_block *(*get_root_from_inode)(struct xfs_btree_cur *);
 
+	/* return address of btree structures */
+	union xfs_btree_ptr *(*ptr_addr)(struct xfs_btree_cur *cur, int index,
+					 struct xfs_btree_block *block);
+
 	/* btree tracing */
 #ifdef XFS_BTREE_TRACE
 	void		(*trace_enter)(struct xfs_btree_cur *, const char *,
@@ -502,6 +506,23 @@ xfs_btree_setbuf(
 	int			lev,	/* level in btree */
 	struct xfs_buf		*bp);	/* new buffer to set */
 
+/*
+ * Common btree core entry points.
+ */
+
+int xfs_btree_increment(struct xfs_btree_cur *, int, int *);
+
+
+/*
+ * Helpers.
+ */
+
+static inline int
+xfs_btree_get_numrecs(struct xfs_btree_block *block)
+{
+	return be16_to_cpu(block->bb_h.bb_numrecs);
+}
+
 #endif	/* __KERNEL__ */
 
 
Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-07-21 04:41:51.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-07-21 06:47:21.000000000 +0200
@@ -35,6 +35,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
+#include "xfs_btree_trace.h"
 #include "xfs_ialloc.h"
 #include "xfs_error.h"
 
@@ -829,3 +830,230 @@ xfs_btree_setbuf(
 			cur->bc_ra[lev] |= XFS_BTCUR_RIGHTRA;
 	}
 }
+
+STATIC int
+xfs_btree_ptr_is_null(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		return be64_to_cpu(ptr->l) == NULLFSBLOCK;
+	else
+		return be32_to_cpu(ptr->s) == NULLAGBLOCK;
+}
+
+/*
+ * Get/set/init sibling pointers
+ */
+STATIC void
+xfs_btree_get_sibling(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	union xfs_btree_ptr	*ptr,
+	int			lr)
+{
+	ASSERT(lr == XFS_BB_LEFTSIB || lr == XFS_BB_RIGHTSIB);
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		if (lr == XFS_BB_RIGHTSIB)
+			ptr->l = block->bb_u.l.bb_rightsib;
+		else
+			ptr->l = block->bb_u.l.bb_leftsib;
+	} else {
+		if (lr == XFS_BB_RIGHTSIB)
+			ptr->s = block->bb_u.s.bb_rightsib;
+		else
+			ptr->s = block->bb_u.s.bb_leftsib;
+	}
+}
+
+STATIC struct xfs_btree_block *
+xfs_btree_buf_to_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	if (!bp) {
+		ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
+		return cur->bc_ops->get_root_from_inode(cur);
+	}
+	return XFS_BUF_TO_BLOCK(bp);
+}
+
+STATIC xfs_daddr_t
+xfs_btree_ptr_to_daddr(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		ASSERT(be64_to_cpu(ptr->l) != NULLFSBLOCK);
+
+		return XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->l));
+	} else {
+		ASSERT(cur->bc_private.a.agno != NULLAGNUMBER);
+		ASSERT(be32_to_cpu(ptr->s) != NULLAGBLOCK);
+
+		return XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno,
+					be32_to_cpu(ptr->s));
+	}
+}
+
+STATIC void
+xfs_btree_set_refs(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	switch (cur->bc_btnum) {
+	case XFS_BTNUM_BNO:
+	case XFS_BTNUM_CNT:
+		XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_MAP, XFS_ALLOC_BTREE_REF);
+		break;
+	case XFS_BTNUM_INO:
+		XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_INOMAP, XFS_INO_BTREE_REF);
+		break;
+	case XFS_BTNUM_BMAP:
+		XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_MAP, XFS_BMAP_BTREE_REF);
+		break;
+	default:
+		ASSERT(0);
+	}
+}
+
+/*
+ * Read in the buffer at the given ptr and return the buffer and
+ * the block pointer within the buffer.
+ */
+STATIC int
+xfs_btree_read_buf_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	int			level,
+	int			flags,
+	struct xfs_btree_block	**block,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	xfs_daddr_t		d;
+	int			error;
+
+	/* need to sort out how callers deal with failures first */
+	ASSERT(!(flags & XFS_BUF_TRYLOCK));
+
+	d = xfs_btree_ptr_to_daddr(cur, ptr);
+	error = xfs_trans_read_buf(mp, cur->bc_tp, mp->m_ddev_targp, d,
+				   mp->m_bsize, flags, bpp);
+	if (error)
+		return error;
+
+	ASSERT(*bpp != NULL);
+	ASSERT(!XFS_BUF_GETERROR(*bpp));
+
+	xfs_btree_set_refs(cur, *bpp);
+	*block = XFS_BUF_TO_BLOCK(*bpp);
+
+	return xfs_btree_check_block(cur, *block, level, *bpp);
+}
+
+/*
+ * Increment cursor by one record at the level.
+ * For nonzero levels the leaf-ward information is untouched.
+ */
+int						/* error */
+xfs_btree_increment(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	int			*stat)		/* success/failure */
+{
+	struct xfs_btree_block	*block;
+	union xfs_btree_ptr	ptr;
+	struct xfs_buf		*bp;
+	int			error;		/* error return value */
+	int			lev;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGI(cur, level);
+
+	ASSERT(level < cur->bc_nlevels);
+
+	/* Read-ahead to the right at this level. */
+	xfs_btree_readahead(cur, level, XFS_BTCUR_RIGHTRA);
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
+	/* We're done if we remain in the block after the increment. */
+	if (++cur->bc_ptrs[level] <= xfs_btree_get_numrecs(block))
+		goto out1;
+
+	/* Fail if we just went off the right edge of the tree. */
+	xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_RIGHTSIB);
+	if (xfs_btree_ptr_is_null(cur, &ptr))
+		goto out0;
+
+	XFS_BTREE_STATS_INC(cur, increment);
+
+	/*
+	 * March up the tree incrementing pointers.
+	 * Stop when we don't go off the right edge of a block.
+	 */
+	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
+		block = xfs_btree_get_block(cur, lev, &bp);
+
+#ifdef DEBUG
+		error = xfs_btree_check_block(cur, block, lev, bp);
+		if (error)
+			goto error0;
+#endif
+
+		if (++cur->bc_ptrs[lev] <= xfs_btree_get_numrecs(block))
+			break;
+
+		/* Read-ahead the right block for the next loop. */
+		xfs_btree_readahead(cur, lev, XFS_BTCUR_RIGHTRA);
+	}
+
+	/*
+	 * If we went off the root then we are either seriously
+	 * confused or have the tree root in an inode.
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
+
+		xfs_btree_setbuf(cur, lev, bp);
+		cur->bc_ptrs[lev] = 1;
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
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-07-21 04:41:59.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-07-21 06:46:13.000000000 +0200
@@ -303,7 +303,7 @@ xfs_alloc_delrec(
 		 */
 		i = xfs_btree_lastrec(tcur, level);
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_alloc_increment(tcur, level, &i)))
+		if ((error = xfs_btree_increment(tcur, level, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		i = xfs_btree_lastrec(tcur, level);
@@ -517,7 +517,7 @@ xfs_alloc_delrec(
 	 * us, increment the cursor at that level.
 	 */
 	else if (level + 1 < cur->bc_nlevels &&
-		 (error = xfs_alloc_increment(cur, level + 1, &i)))
+		 (error = xfs_btree_increment(cur, level + 1, &i)))
 		return error;
 	/*
 	 * Fix up the number of records in the surviving block.
@@ -1134,7 +1134,7 @@ xfs_alloc_lookup(
 			int	i;
 
 			cur->bc_ptrs[0] = keyno;
-			if ((error = xfs_alloc_increment(cur, 0, &i)))
+			if ((error = xfs_btree_increment(cur, 0, &i)))
 				return error;
 			XFS_WANT_CORRUPTED_RETURN(i == 1);
 			*stat = 1;
@@ -1570,7 +1570,7 @@ xfs_alloc_rshift(
 		return error;
 	i = xfs_btree_lastrec(tcur, level);
 	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-	if ((error = xfs_alloc_increment(tcur, level, &i)) ||
+	if ((error = xfs_btree_increment(tcur, level, &i)) ||
 	    (error = xfs_alloc_updkey(tcur, rkp, level + 1)))
 		goto error0;
 	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
@@ -1943,97 +1943,6 @@ xfs_alloc_get_rec(
 }
 
 /*
- * Increment cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-int					/* error */
-xfs_alloc_increment(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level in btree, 0 is leaf */
-	int			*stat)	/* success/failure */
-{
-	xfs_alloc_block_t	*block;	/* btree block */
-	xfs_buf_t		*bp;	/* tree block buffer */
-	int			error;	/* error return value */
-	int			lev;	/* btree level */
-
-	ASSERT(level < cur->bc_nlevels);
-	/*
-	 * Read-ahead to the right at this level.
-	 */
-	xfs_btree_readahead(cur, level, XFS_BTCUR_RIGHTRA);
-	/*
-	 * Get a pointer to the btree block.
-	 */
-	bp = cur->bc_bufs[level];
-	block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, level, bp)))
-		return error;
-#endif
-	/*
-	 * Increment the ptr at this level.  If we're still in the block
-	 * then we're done.
-	 */
-	if (++cur->bc_ptrs[level] <= be16_to_cpu(block->bb_numrecs)) {
-		*stat = 1;
-		return 0;
-	}
-	/*
-	 * If we just went off the right edge of the tree, return failure.
-	 */
-	if (be32_to_cpu(block->bb_rightsib) == NULLAGBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * March up the tree incrementing pointers.
-	 * Stop when we don't go off the right edge of a block.
-	 */
-	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
-		bp = cur->bc_bufs[lev];
-		block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sblock(cur, block, lev, bp)))
-			return error;
-#endif
-		if (++cur->bc_ptrs[lev] <= be16_to_cpu(block->bb_numrecs))
-			break;
-		/*
-		 * Read-ahead the right block, we're going to read it
-		 * in the next loop.
-		 */
-		xfs_btree_readahead(cur, lev, XFS_BTCUR_RIGHTRA);
-	}
-	/*
-	 * If we went off the root then we are seriously confused.
-	 */
-	ASSERT(lev < cur->bc_nlevels);
-	/*
-	 * Now walk back down the tree, fixing up the cursor's buffer
-	 * pointers and key numbers.
-	 */
-	for (bp = cur->bc_bufs[lev], block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-	     lev > level; ) {
-		xfs_agblock_t	agbno;	/* block number of btree block */
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
-		cur->bc_ptrs[lev] = 1;
-	}
-	*stat = 1;
-	return 0;
-}
-
-/*
  * Insert the current record at the point referenced by cur.
  * The cursor may be inconsistent on return if splits have been done.
  */
@@ -2219,6 +2128,16 @@ xfs_allocbt_dup_cursor(
 			cur->bc_btnum);
 }
 
+STATIC union xfs_btree_ptr *
+xfs_allocbt_ptr_addr(
+	struct xfs_btree_cur	*cur,
+	int			index,
+	struct xfs_btree_block	*block)
+{
+	return (union xfs_btree_ptr *)
+		XFS_ALLOC_PTR_ADDR(&block->bb_h, index, cur);
+}
+
 #ifdef XFS_BTREE_TRACE
 
 ktrace_t	*xfs_allocbt_trace_buf;
@@ -2288,6 +2207,7 @@ xfs_allocbt_trace_record(
 
 static const struct xfs_btree_ops xfs_allocbt_ops = {
 	.dup_cursor		= xfs_allocbt_dup_cursor,
+	.ptr_addr		= xfs_allocbt_ptr_addr,
 
 #ifdef XFS_BTREE_TRACE
 	.trace_enter		= xfs_allocbt_trace_enter,
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.h	2008-07-21 04:41:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h	2008-07-21 06:46:13.000000000 +0200
@@ -114,12 +114,6 @@ extern int xfs_alloc_get_rec(struct xfs_
 				xfs_extlen_t *len, int *stat);
 
 /*
- * Increment cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-extern int xfs_alloc_increment(struct xfs_btree_cur *cur, int level, int *stat);
-
-/*
  * Insert the current record at the point referenced by cur.
  * The cursor may be inconsistent on return if splits have been done.
  */
Index: linux-2.6-xfs/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc.c	2008-07-21 04:41:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc.c	2008-07-21 06:46:13.000000000 +0200
@@ -818,7 +818,7 @@ xfs_alloc_ag_vextent_near(
 				XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 				if (ltlen >= args->minlen)
 					break;
-				if ((error = xfs_alloc_increment(cnt_cur, 0, &i)))
+				if ((error = xfs_btree_increment(cnt_cur, 0, &i)))
 					goto error0;
 			} while (i);
 			ASSERT(ltlen >= args->minlen);
@@ -828,7 +828,7 @@ xfs_alloc_ag_vextent_near(
 		i = cnt_cur->bc_ptrs[0];
 		for (j = 1, blen = 0, bdiff = 0;
 		     !error && j && (blen < args->maxlen || bdiff > 0);
-		     error = xfs_alloc_increment(cnt_cur, 0, &j)) {
+		     error = xfs_btree_increment(cnt_cur, 0, &j)) {
 			/*
 			 * For each entry, decide if it's better than
 			 * the previous best entry.
@@ -938,7 +938,7 @@ xfs_alloc_ag_vextent_near(
 	 * Increment the cursor, so we will point at the entry just right
 	 * of the leftward entry if any, or to the leftmost entry.
 	 */
-	if ((error = xfs_alloc_increment(bno_cur_gt, 0, &i)))
+	if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
 		goto error0;
 	if (!i) {
 		/*
@@ -977,7 +977,7 @@ xfs_alloc_ag_vextent_near(
 					args->minlen, &gtbnoa, &gtlena);
 			if (gtlena >= args->minlen)
 				break;
-			if ((error = xfs_alloc_increment(bno_cur_gt, 0, &i)))
+			if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
 				goto error0;
 			if (!i) {
 				xfs_btree_del_cursor(bno_cur_gt,
@@ -1066,7 +1066,7 @@ xfs_alloc_ag_vextent_near(
 					/*
 					 * Fell off the right end.
 					 */
-					if ((error = xfs_alloc_increment(
+					if ((error = xfs_btree_increment(
 							bno_cur_gt, 0, &i)))
 						goto error0;
 					if (!i) {
@@ -1548,7 +1548,7 @@ xfs_free_ag_extent(
 	 * Look for a neighboring block on the right (higher block numbers)
 	 * that is contiguous with this space.
 	 */
-	if ((error = xfs_alloc_increment(bno_cur, 0, &haveright)))
+	if ((error = xfs_btree_increment(bno_cur, 0, &haveright)))
 		goto error0;
 	if (haveright) {
 		/*
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-07-21 04:41:59.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-07-21 06:46:13.000000000 +0200
@@ -253,7 +253,7 @@ xfs_inobt_delrec(
 		 */
 		i = xfs_btree_lastrec(tcur, level);
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_inobt_increment(tcur, level, &i)))
+		if ((error = xfs_btree_increment(tcur, level, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		i = xfs_btree_lastrec(tcur, level);
@@ -463,7 +463,7 @@ xfs_inobt_delrec(
 	 * us, increment the cursor at that level.
 	 */
 	else if (level + 1 < cur->bc_nlevels &&
-		 (error = xfs_alloc_increment(cur, level + 1, &i)))
+		 (error = xfs_btree_increment(cur, level + 1, &i)))
 		return error;
 	/*
 	 * Fix up the number of records in the surviving block.
@@ -1014,7 +1014,7 @@ xfs_inobt_lookup(
 			int	i;
 
 			cur->bc_ptrs[0] = keyno;
-			if ((error = xfs_inobt_increment(cur, 0, &i)))
+			if ((error = xfs_btree_increment(cur, 0, &i)))
 				return error;
 			ASSERT(i == 1);
 			*stat = 1;
@@ -1443,7 +1443,7 @@ xfs_inobt_rshift(
 	if ((error = xfs_btree_dup_cursor(cur, &tcur)))
 		return error;
 	xfs_btree_lastrec(tcur, level);
-	if ((error = xfs_inobt_increment(tcur, level, &i)) ||
+	if ((error = xfs_btree_increment(tcur, level, &i)) ||
 	    (error = xfs_inobt_updkey(tcur, rkp, level + 1))) {
 		xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
 		return error;
@@ -1821,97 +1821,6 @@ xfs_inobt_get_rec(
 }
 
 /*
- * Increment cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-int					/* error */
-xfs_inobt_increment(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level in btree, 0 is leaf */
-	int			*stat)	/* success/failure */
-{
-	xfs_inobt_block_t	*block;	/* btree block */
-	xfs_buf_t		*bp;	/* buffer containing btree block */
-	int			error;	/* error return value */
-	int			lev;	/* btree level */
-
-	ASSERT(level < cur->bc_nlevels);
-	/*
-	 * Read-ahead to the right at this level.
-	 */
-	xfs_btree_readahead(cur, level, XFS_BTCUR_RIGHTRA);
-	/*
-	 * Get a pointer to the btree block.
-	 */
-	bp = cur->bc_bufs[level];
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, level, bp)))
-		return error;
-#endif
-	/*
-	 * Increment the ptr at this level.  If we're still in the block
-	 * then we're done.
-	 */
-	if (++cur->bc_ptrs[level] <= be16_to_cpu(block->bb_numrecs)) {
-		*stat = 1;
-		return 0;
-	}
-	/*
-	 * If we just went off the right edge of the tree, return failure.
-	 */
-	if (be32_to_cpu(block->bb_rightsib) == NULLAGBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * March up the tree incrementing pointers.
-	 * Stop when we don't go off the right edge of a block.
-	 */
-	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
-		bp = cur->bc_bufs[lev];
-		block = XFS_BUF_TO_INOBT_BLOCK(bp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sblock(cur, block, lev, bp)))
-			return error;
-#endif
-		if (++cur->bc_ptrs[lev] <= be16_to_cpu(block->bb_numrecs))
-			break;
-		/*
-		 * Read-ahead the right block, we're going to read it
-		 * in the next loop.
-		 */
-		xfs_btree_readahead(cur, lev, XFS_BTCUR_RIGHTRA);
-	}
-	/*
-	 * If we went off the root then we are seriously confused.
-	 */
-	ASSERT(lev < cur->bc_nlevels);
-	/*
-	 * Now walk back down the tree, fixing up the cursor's buffer
-	 * pointers and key numbers.
-	 */
-	for (bp = cur->bc_bufs[lev], block = XFS_BUF_TO_INOBT_BLOCK(bp);
-	     lev > level; ) {
-		xfs_agblock_t	agbno;	/* block number of btree block */
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
-		cur->bc_ptrs[lev] = 1;
-	}
-	*stat = 1;
-	return 0;
-}
-
-/*
  * Insert the current record at the point referenced by cur.
  * The cursor may be inconsistent on return if splits have been done.
  */
@@ -2085,6 +1994,16 @@ xfs_inobt_dup_cursor(
 			cur->bc_private.a.agbp, cur->bc_private.a.agno);
 }
 
+STATIC union xfs_btree_ptr *
+xfs_inobt_ptr_addr(
+	struct xfs_btree_cur	*cur,
+	int			index,
+	struct xfs_btree_block	*block)
+{
+	return (union xfs_btree_ptr *)
+		XFS_INOBT_PTR_ADDR(&block->bb_h, index, cur);
+}
+
 #ifdef XFS_BTREE_TRACE
 
 ktrace_t	*xfs_inobt_trace_buf;
@@ -2154,6 +2073,7 @@ xfs_inobt_trace_record(
 
 static const struct xfs_btree_ops xfs_inobt_ops = {
 	.dup_cursor		= xfs_inobt_dup_cursor,
+	.ptr_addr		= xfs_inobt_ptr_addr,
 
 #ifdef XFS_BTREE_TRACE
 	.trace_enter		= xfs_inobt_trace_enter,
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c	2008-07-21 04:41:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c	2008-07-21 06:46:13.000000000 +0200
@@ -695,7 +695,7 @@ nextag:
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 			freecount += rec.ir_freecount;
-			if ((error = xfs_inobt_increment(cur, 0, &i)))
+			if ((error = xfs_btree_increment(cur, 0, &i)))
 				goto error0;
 		} while (i == 1);
 
@@ -753,7 +753,7 @@ nextag:
 			/*
 			 * Search right with cur, go forward 1 record.
 			 */
-			if ((error = xfs_inobt_increment(cur, 0, &i)))
+			if ((error = xfs_btree_increment(cur, 0, &i)))
 				goto error1;
 			doneright = !i;
 			if (!doneright) {
@@ -835,7 +835,7 @@ nextag:
 				 * further right.
 				 */
 				else {
-					if ((error = xfs_inobt_increment(cur, 0,
+					if ((error = xfs_btree_increment(cur, 0,
 							&i)))
 						goto error1;
 					doneright = !i;
@@ -890,7 +890,7 @@ nextag:
 				XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 				if (rec.ir_freecount > 0)
 					break;
-				if ((error = xfs_inobt_increment(cur, 0, &i)))
+				if ((error = xfs_btree_increment(cur, 0, &i)))
 					goto error0;
 				XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 			}
@@ -924,7 +924,7 @@ nextag:
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 			freecount += rec.ir_freecount;
-			if ((error = xfs_inobt_increment(cur, 0, &i)))
+			if ((error = xfs_btree_increment(cur, 0, &i)))
 				goto error0;
 		} while (i == 1);
 		ASSERT(freecount == be32_to_cpu(agi->agi_freecount) ||
@@ -1033,7 +1033,7 @@ xfs_difree(
 				goto error0;
 			if (i) {
 				freecount += rec.ir_freecount;
-				if ((error = xfs_inobt_increment(cur, 0, &i)))
+				if ((error = xfs_btree_increment(cur, 0, &i)))
 					goto error0;
 			}
 		} while (i == 1);
@@ -1138,7 +1138,7 @@ xfs_difree(
 				goto error0;
 			if (i) {
 				freecount += rec.ir_freecount;
-				if ((error = xfs_inobt_increment(cur, 0, &i)))
+				if ((error = xfs_btree_increment(cur, 0, &i)))
 					goto error0;
 			}
 		} while (i == 1);
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.h	2008-07-21 04:41:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h	2008-07-21 06:46:13.000000000 +0200
@@ -136,12 +136,6 @@ extern int xfs_inobt_get_rec(struct xfs_
 			     __int32_t *fcnt, xfs_inofree_t *free, int *stat);
 
 /*
- * Increment cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-extern int xfs_inobt_increment(struct xfs_btree_cur *cur, int level, int *stat);
-
-/*
  * Insert the current record at the point referenced by cur.
  * The cursor may be inconsistent on return if splits have been done.
  */
Index: linux-2.6-xfs/fs/xfs/xfs_itable.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_itable.c	2008-07-21 04:41:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_itable.c	2008-07-21 04:42:09.000000000 +0200
@@ -473,7 +473,7 @@ xfs_bulkstat(
 			 * In any case, increment to the next record.
 			 */
 			if (!error)
-				error = xfs_inobt_increment(cur, 0, &tmp);
+				error = xfs_btree_increment(cur, 0, &tmp);
 		} else {
 			/*
 			 * Start of ag.  Lookup the first inode chunk.
@@ -540,7 +540,7 @@ xfs_bulkstat(
 			 * Set agino to after this chunk and bump the cursor.
 			 */
 			agino = gino + XFS_INODES_PER_CHUNK;
-			error = xfs_inobt_increment(cur, 0, &tmp);
+			error = xfs_btree_increment(cur, 0, &tmp);
 			cond_resched();
 		}
 		/*
@@ -887,7 +887,7 @@ xfs_inumbers(
 			bufidx = 0;
 		}
 		if (left) {
-			error = xfs_inobt_increment(cur, 0, &tmp);
+			error = xfs_btree_increment(cur, 0, &tmp);
 			if (error) {
 				xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 				cur = NULL;
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-07-21 04:41:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-07-21 06:46:13.000000000 +0200
@@ -1646,7 +1646,7 @@ xfs_bmap_add_extent_unwritten_real(
 				PREV.br_blockcount - new->br_blockcount,
 				oldext)))
 				goto done;
-			if ((error = xfs_bmbt_increment(cur, 0, &i)))
+			if ((error = xfs_btree_increment(cur, 0, &i)))
 				goto done;
 			if ((error = xfs_bmbt_update(cur, new->br_startoff,
 				new->br_startblock,
@@ -3253,7 +3253,7 @@ xfs_bmap_del_extent(
 						got.br_startblock, temp,
 						got.br_state)))
 					goto done;
-				if ((error = xfs_bmbt_increment(cur, 0, &i)))
+				if ((error = xfs_btree_increment(cur, 0, &i)))
 					goto done;
 				cur->bc_rec.b = new;
 				error = xfs_bmbt_insert(cur, &i);
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-07-21 04:41:59.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-07-21 06:46:13.000000000 +0200
@@ -253,7 +253,7 @@ xfs_bmbt_delrec(
 	if (rbno != NULLFSBLOCK) {
 		i = xfs_btree_lastrec(tcur, level);
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_bmbt_increment(tcur, level, &i))) {
+		if ((error = xfs_btree_increment(tcur, level, &i))) {
 			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 			goto error0;
 		}
@@ -444,7 +444,7 @@ xfs_bmbt_delrec(
 		cur->bc_bufs[level] = lbp;
 		cur->bc_ptrs[level] += lrecs;
 		cur->bc_ra[level] = 0;
-	} else if ((error = xfs_bmbt_increment(cur, level + 1, &i))) {
+	} else if ((error = xfs_btree_increment(cur, level + 1, &i))) {
 		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 		goto error0;
 	}
@@ -928,7 +928,7 @@ xfs_bmbt_lookup(
 		if (dir == XFS_LOOKUP_GE && keyno > be16_to_cpu(block->bb_numrecs) &&
 		    be64_to_cpu(block->bb_rightsib) != NULLDFSBNO) {
 			cur->bc_ptrs[0] = keyno;
-			if ((error = xfs_bmbt_increment(cur, 0, &i))) {
+			if ((error = xfs_btree_increment(cur, 0, &i))) {
 				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 				return error;
 			}
@@ -1201,7 +1201,7 @@ xfs_bmbt_rshift(
 	}
 	i = xfs_btree_lastrec(tcur, level);
 	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-	if ((error = xfs_bmbt_increment(tcur, level, &i))) {
+	if ((error = xfs_btree_increment(tcur, level, &i))) {
 		XFS_BMBT_TRACE_CURSOR(tcur, ERROR);
 		goto error1;
 	}
@@ -1759,86 +1759,6 @@ xfs_bmbt_disk_get_startoff(
 }
 
 /*
- * Increment cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-int						/* error */
-xfs_bmbt_increment(
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
-	xfs_btree_readahead(cur, level, XFS_BTCUR_RIGHTRA);
-	block = xfs_bmbt_get_block(cur, level, &bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_lblock(cur, block, level, bp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-#endif
-	if (++cur->bc_ptrs[level] <= be16_to_cpu(block->bb_numrecs)) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 1;
-		return 0;
-	}
-	if (be64_to_cpu(block->bb_rightsib) == NULLDFSBNO) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
-		block = xfs_bmbt_get_block(cur, lev, &bp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_lblock(cur, block, lev, bp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-#endif
-		if (++cur->bc_ptrs[lev] <= be16_to_cpu(block->bb_numrecs))
-			break;
-		xfs_btree_readahead(cur, lev, XFS_BTCUR_RIGHTRA);
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
-		cur->bc_ptrs[lev] = 1;
-	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*stat = 1;
-	return 0;
-}
-
-/*
  * Insert the current record at the point referenced by cur.
  *
  * A multi-level split of the tree on insert will invalidate the original
@@ -2423,6 +2343,16 @@ xfs_bmbt_get_root_from_inode(
 	return (struct xfs_btree_block *)ifp->if_broot;
 }
 
+STATIC union xfs_btree_ptr *
+xfs_bmbt_ptr_addr(
+	struct xfs_btree_cur	*cur,
+	int			index,
+	struct xfs_btree_block	*block)
+{
+	return (union xfs_btree_ptr *)
+		XFS_BMAP_PTR_IADDR(&block->bb_h, index, cur);
+}
+
 #ifdef XFS_BTREE_TRACE
 
 ktrace_t	*xfs_bmbt_trace_buf;
@@ -2512,6 +2442,7 @@ xfs_bmbt_trace_record(
 static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.dup_cursor		= xfs_bmbt_dup_cursor,
 	.get_root_from_inode	= xfs_bmbt_get_root_from_inode,
+	.ptr_addr		= xfs_bmbt_ptr_addr,
 
 #ifdef XFS_BTREE_TRACE
 	.trace_enter		= xfs_bmbt_trace_enter,
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.h	2008-07-21 04:41:59.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h	2008-07-21 06:46:13.000000000 +0200
@@ -251,7 +251,6 @@ extern void xfs_bmbt_disk_get_all(xfs_bm
 extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(xfs_bmbt_rec_t *r);
 extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(xfs_bmbt_rec_t *r);
 
-extern int xfs_bmbt_increment(struct xfs_btree_cur *, int, int *);
 extern int xfs_bmbt_insert(struct xfs_btree_cur *, int *);
 extern void xfs_bmbt_log_block(struct xfs_btree_cur *, struct xfs_buf *, int);
 extern void xfs_bmbt_log_recs(struct xfs_btree_cur *, struct xfs_buf *, int,

-- 
