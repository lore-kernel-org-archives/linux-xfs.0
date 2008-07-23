Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 13:09:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NK8nNV016954
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:08:49 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21C07E8E89B
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:09:56 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id o8f0XO6f4pZNR39t for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:09:56 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6NK9kNg007658
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 22:09:46 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6NK9jIx007656
	for xfs@oss.sgi.com; Wed, 23 Jul 2008 22:09:45 +0200
Date: Wed, 23 Jul 2008 22:09:45 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/15] implement generic xfs_btree_update
Message-ID: <20080723200945.GP7401@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename=xfs-common-btree-update
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

From: Dave Chinner <dgc@sgi.com>

The most complicated part here is the lastrec tracking for
the alloc btree.  Most logic is in the update_lastrec method
which has to do some hopefully good enough dirty magic to
maintain it.

[hch: split out from bigger patch and a rework of the lastrec
 logic]


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-07-21 05:10:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-07-21 05:24:20.000000000 +0200
@@ -867,6 +867,30 @@ xfs_btree_get_sibling(
 	}
 }
 
+/*
+ * Return true if ptr is the last record in the btree and
+ * we need to track updateѕ to this record.  The decision
+ * will be further refined in the update_lastrec method.
+ */
+STATIC int
+xfs_btree_is_lastrec(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	int			level)
+{
+	union xfs_btree_ptr	ptr;
+
+	if (level > 0)
+		return 0;
+	if (!(cur->bc_flags & XFS_BTREE_LASTREC_UPDATE))
+		return 0;
+
+	xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_RIGHTSIB);
+	if (!xfs_btree_ptr_is_null(cur, &ptr))
+		return 0;
+	return 1;
+}
+
 STATIC struct xfs_btree_block *
 xfs_btree_buf_to_block(
 	struct xfs_btree_cur	*cur,
@@ -1417,3 +1441,66 @@ xfs_btree_updkey(
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 	return 0;
 }
+
+/*
+ * Update the record referred to by cur to the value in the
+ * given record. This either works (return 0) or gets an
+ * EFSCORRUPTED error.
+ */
+int
+xfs_btree_update(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
+{
+	struct xfs_btree_block	*block;
+	struct xfs_buf		*bp;
+	int			error;
+	int			ptr;
+	union xfs_btree_rec	*rp;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGR(cur, rec);
+
+	/* Pick up the current block. */
+	block = xfs_btree_get_block(cur, 0, &bp);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, block, 0, bp);
+	if (error)
+		goto error0;
+#endif
+	/* Get the address of the rec to be updated. */
+	ptr = cur->bc_ptrs[0];
+	rp = cur->bc_ops->rec_addr(cur, ptr, block);
+
+	/* Fill in the new contents and log them. */
+	cur->bc_ops->copy_recs(cur, rec, rp, 1);
+	cur->bc_ops->log_recs(cur, bp, ptr, ptr);
+
+	/*
+	 * If we are tracking the last record in the tree and
+	 * we are at the far right edge of the tree, update it.
+	 */
+	if (xfs_btree_is_lastrec(cur, block, 0)) {
+		cur->bc_ops->update_lastrec(cur, block, rec,
+					    ptr, LASTREC_UPDATE);
+	}
+
+	/* Updating first rec in leaf. Pass new key value up to our parent. */
+	if (ptr == 1) {
+		union xfs_btree_key	key;
+
+		cur->bc_ops->init_key_from_rec(cur, &key, rec);
+		error = xfs_btree_updkey(cur, &key, 1);
+		if (error)
+			goto error0;
+	}
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	return 0;
+
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-07-21 05:10:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-07-21 05:45:02.000000000 +0200
@@ -49,7 +49,9 @@ STATIC void xfs_allocbt_log_keys(xfs_btr
 #define xfs_alloc_log_keys(c, b, i, j) \
 	xfs_allocbt_log_keys(c, b, i, j)
 STATIC void xfs_alloc_log_ptrs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-STATIC void xfs_alloc_log_recs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
+STATIC void xfs_allocbt_log_recs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
+#define xfs_alloc_log_recs(c, b, i, j) \
+	xfs_allocbt_log_recs(c, b, i, j)
 STATIC int xfs_alloc_lshift(xfs_btree_cur_t *, int, int *);
 STATIC int xfs_alloc_newroot(xfs_btree_cur_t *, int *);
 STATIC int xfs_alloc_rshift(xfs_btree_cur_t *, int, int *);
@@ -883,41 +885,6 @@ xfs_alloc_log_ptrs(
 }
 
 /*
- * Log records from a btree block (leaf).
- */
-STATIC void
-xfs_alloc_log_recs(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			rfirst,	/* index of first record to log */
-	int			rlast)	/* index of last record to log */
-{
-	xfs_alloc_block_t	*block;	/* btree block to log from */
-	int			first;	/* first byte offset logged */
-	int			last;	/* last byte offset logged */
-	xfs_alloc_rec_t		*rp;	/* record pointer for btree block */
-
-
-	block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-	rp = XFS_ALLOC_REC_ADDR(block, 1, cur);
-#ifdef DEBUG
-	{
-		xfs_agf_t	*agf;
-		xfs_alloc_rec_t	*p;
-
-		agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
-		for (p = &rp[rfirst - 1]; p <= &rp[rlast - 1]; p++)
-			ASSERT(be32_to_cpu(p->ar_startblock) +
-			       be32_to_cpu(p->ar_blockcount) <=
-			       be32_to_cpu(agf->agf_length));
-	}
-#endif
-	first = (int)((xfs_caddr_t)&rp[rfirst - 1] - (xfs_caddr_t)block);
-	last = (int)(((xfs_caddr_t)&rp[rlast] - 1) - (xfs_caddr_t)block);
-	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
-}
-
-/*
  * Move 1 record left from cur/level if possible.
  * Update cur to reflect the new path.
  */
@@ -1642,83 +1609,50 @@ xfs_alloc_insert(
 	return 0;
 }
 
+STATIC struct xfs_btree_cur *
+xfs_allocbt_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	return xfs_allocbt_init_cursor(cur->bc_mp, cur->bc_tp,
+			cur->bc_private.a.agbp, cur->bc_private.a.agno,
+			cur->bc_btnum);
+}
+
 /*
- * Update the record referred to by cur, to the value given by [bno, len].
- * This either works (return 0) or gets an EFSCORRUPTED error.
+ * Update the longest extent in the AGF
  */
-int					/* error */
-xfs_alloc_update(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_agblock_t		bno,	/* starting block of extent */
-	xfs_extlen_t		len)	/* length of extent */
+STATIC void
+xfs_allocbt_update_lastrec(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	union xfs_btree_rec	*rec,
+	int			ptr,
+	int			reason)
 {
-	xfs_alloc_block_t	*block;	/* btree block to update */
-	int			error;	/* error return value */
-	int			ptr;	/* current record number (updating) */
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
+	__be32			len;
 
-	ASSERT(len > 0);
-	/*
-	 * Pick up the a.g. freelist struct and the current block.
-	 */
-	block = XFS_BUF_TO_ALLOC_BLOCK(cur->bc_bufs[0]);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, 0, cur->bc_bufs[0])))
-		return error;
-#endif
-	/*
-	 * Get the address of the rec to be updated.
-	 */
-	ptr = cur->bc_ptrs[0];
-	{
-		xfs_alloc_rec_t		*rp;	/* pointer to updated record */
+	ASSERT(cur->bc_btnum == XFS_BTNUM_CNT);
 
-		rp = XFS_ALLOC_REC_ADDR(block, ptr, cur);
+	switch (reason) {
+	case LASTREC_UPDATE:
 		/*
-		 * Fill in the new contents and log them.
+		 * If this is the last leaf block and it's the last record,
+		 * then update the size of the longest extent in the AG.
 		 */
-		rp->ar_startblock = cpu_to_be32(bno);
-		rp->ar_blockcount = cpu_to_be32(len);
-		xfs_alloc_log_recs(cur, cur->bc_bufs[0], ptr, ptr);
+		if (ptr != xfs_btree_get_numrecs(block))
+			return;
+		len = rec->alloc.ar_blockcount;
+		break;
+	default:
+		ASSERT(0);
+		return;
 	}
-	/*
-	 * If it's the by-size btree and it's the last leaf block and
-	 * it's the last record... then update the size of the longest
-	 * extent in the a.g., which we cache in the a.g. freelist header.
-	 */
-	if (cur->bc_btnum == XFS_BTNUM_CNT &&
-	    be32_to_cpu(block->bb_rightsib) == NULLAGBLOCK &&
-	    ptr == be16_to_cpu(block->bb_numrecs)) {
-		xfs_agf_t	*agf;	/* a.g. freespace header */
-		xfs_agnumber_t	seqno;
-
-		agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
-		seqno = be32_to_cpu(agf->agf_seqno);
-		cur->bc_mp->m_perag[seqno].pagf_longest = len;
-		agf->agf_longest = cpu_to_be32(len);
-		xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp,
-			XFS_AGF_LONGEST);
-	}
-	/*
-	 * Updating first record in leaf. Pass new key value up to our parent.
-	 */
-	if (ptr == 1) {
-		xfs_alloc_key_t	key;	/* key containing [bno, len] */
-
-		key.ar_startblock = cpu_to_be32(bno);
-		key.ar_blockcount = cpu_to_be32(len);
-		if ((error = xfs_btree_updkey(cur, (union xfs_btree_key *)&key, 1)))
-			return error;
-	}
-	return 0;
-}
 
-STATIC struct xfs_btree_cur *
-xfs_allocbt_dup_cursor(
-	struct xfs_btree_cur	*cur)
-{
-	return xfs_allocbt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_private.a.agbp, cur->bc_private.a.agno,
-			cur->bc_btnum);
+	agf->agf_longest = len;
+	cur->bc_mp->m_perag[seqno].pagf_longest = be32_to_cpu(len);
+	xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp, XFS_AGF_LONGEST);
 }
 
 STATIC void
@@ -1808,6 +1742,17 @@ xfs_allocbt_copy_keys(
 	memcpy(dst_key, src_key, numkeys * sizeof(xfs_alloc_key_t));
 }
 
+STATIC void
+xfs_allocbt_copy_recs(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*src_rec,
+	union xfs_btree_rec	*dst_rec,
+	int			numrecs)
+{
+	ASSERT(numrecs >= 0);
+	memcpy(dst_rec, src_rec, numrecs * sizeof(xfs_alloc_rec_t));
+}
+
 /*
  * Log keys from a btree block (nonleaf).
  */
@@ -1835,6 +1780,44 @@ xfs_allocbt_log_keys(
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 }
 
+/*
+ * Log records from a btree block (leaf).
+ */
+STATIC void
+xfs_alloc_log_recs(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	struct xfs_buf		*bp,	/* buffer containing btree block */
+	int			rfirst,	/* index of first record to log */
+	int			rlast)	/* index of last record to log */
+{
+	struct xfs_btree_sblock	*block;	/* btree block to log from */
+	int			first;	/* first byte offset logged */
+	int			last;	/* last byte offset logged */
+	xfs_alloc_rec_t		*rp;	/* record pointer for btree block */
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, rfirst, rlast);
+
+	block = XFS_BUF_TO_SBLOCK(bp);
+	rp = XFS_ALLOC_REC_ADDR(block, 1, cur);
+#ifdef DEBUG
+	{
+		struct xfs_agf	*agf;
+		xfs_alloc_rec_t	*p;
+
+		agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+		for (p = &rp[rfirst - 1]; p <= &rp[rlast - 1]; p++)
+			ASSERT(be32_to_cpu(p->ar_startblock) +
+			       be32_to_cpu(p->ar_blockcount) <=
+			       be32_to_cpu(agf->agf_length));
+	}
+#endif
+	first = (int)((xfs_caddr_t)&rp[rfirst - 1] - (xfs_caddr_t)block);
+	last = (int)(((xfs_caddr_t)&rp[rlast] - 1) - (xfs_caddr_t)block);
+	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+}
 
 #ifdef XFS_BTREE_TRACE
 
@@ -1905,6 +1888,7 @@ xfs_allocbt_trace_record(
 
 static const struct xfs_btree_ops xfs_allocbt_ops = {
 	.dup_cursor		= xfs_allocbt_dup_cursor,
+	.update_lastrec		= xfs_allocbt_update_lastrec,
 	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
 	.ptr_addr		= xfs_allocbt_ptr_addr,
@@ -1912,7 +1896,9 @@ static const struct xfs_btree_ops xfs_al
 	.rec_addr		= xfs_allocbt_rec_addr,
 	.key_diff		= xfs_allocbt_key_diff,
 	.copy_keys		= xfs_allocbt_copy_keys,
+	.copy_recs		= xfs_allocbt_copy_recs,
 	.log_keys		= xfs_allocbt_log_keys,
+	.log_recs		= xfs_allocbt_log_recs,
 
 #ifdef XFS_BTREE_TRACE
 	.trace_enter		= xfs_allocbt_trace_enter,
@@ -1947,6 +1933,8 @@ xfs_allocbt_init_cursor(
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 
 	cur->bc_ops = &xfs_allocbt_ops;
+	if (btnum == XFS_BTNUM_CNT)
+		cur->bc_flags = XFS_BTREE_LASTREC_UPDATE;
 
 	cur->bc_private.a.agbp = agbp;
 	cur->bc_private.a.agno = agno;
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-07-21 05:11:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-07-21 05:23:07.000000000 +0200
@@ -191,6 +191,11 @@ struct xfs_btree_ops {
 	/* get inode rooted btree root */
 	struct xfs_btree_block *(*get_root_from_inode)(struct xfs_btree_cur *);
 
+	/* updated last record information */
+	void	(*update_lastrec)(struct xfs_btree_cur *,
+				  struct xfs_btree_block *,
+				  union xfs_btree_rec *, int, int);
+
 	/* return address of btree structures */
 	union xfs_btree_ptr *(*ptr_addr)(struct xfs_btree_cur *cur, int index,
 					 struct xfs_btree_block *block);
@@ -214,11 +219,15 @@ struct xfs_btree_ops {
 	void	(*copy_keys)(struct xfs_btree_cur *cur,
 			     union xfs_btree_key *src_key,
 			     union xfs_btree_key *dst_key, int numkeys);
+	void	(*copy_recs)(struct xfs_btree_cur *cur,
+			     union xfs_btree_rec *src_rec,
+			     union xfs_btree_rec *dst_rec, int numkeys);
 
 	/* log changes to btree structures */
 	void	(*log_keys)(struct xfs_btree_cur *cur, struct xfs_buf *bp,
 			    int first, int last);
-
+	void	(*log_recs)(struct xfs_btree_cur *cur, struct xfs_buf *bp,
+			    int first, int last);
 
 	/* btree tracing */
 #ifdef XFS_BTREE_TRACE
@@ -241,6 +250,12 @@ struct xfs_btree_ops {
 };
 
 /*
+ * Reasons for the update_lastrec method to be called.
+ */
+#define LASTREC_UPDATE	0
+
+
+/*
  * Btree cursor structure.
  * This collects all information needed by the btree code in one place.
  */
@@ -284,6 +299,7 @@ typedef struct xfs_btree_cur
 /* cursor flags */
 #define XFS_BTREE_LONG_PTRS		(1<<0)	/* pointers are 64bits long */
 #define XFS_BTREE_ROOT_IN_INODE		(1<<1)	/* root may be variable size */
+#define XFS_BTREE_LASTREC_UPDATE	(1<<2)	/* track last rec externally */
 
 
 #define	XFS_BTREE_NOERROR	0
@@ -539,6 +555,7 @@ int xfs_btree_increment(struct xfs_btree
 int xfs_btree_decrement(struct xfs_btree_cur *, int, int *);
 int xfs_btree_lookup(struct xfs_btree_cur *, xfs_lookup_t, int *);
 int xfs_btree_updkey(struct xfs_btree_cur *, union xfs_btree_key *, int);
+int xfs_btree_update(struct xfs_btree_cur *, union xfs_btree_rec *);
 
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_btree_trace.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree_trace.c	2008-07-21 05:08:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree_trace.c	2008-07-21 05:17:12.000000000 +0200
@@ -158,6 +158,27 @@ xfs_btree_trace_argik(
 }
 
 /*
+ * Add a trace buffer entry for arguments, for record.
+ */
+void
+xfs_btree_trace_argr(
+	const char		*func,
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec,
+	int			line)
+{
+	__uint64_t		l0, l1, l2;
+
+	cur->bc_ops->trace_record(cur, rec, &l0, &l1, &l2);
+	cur->bc_ops->trace_enter(cur, func, XBT_ARGS, XFS_BTREE_KTRACE_ARGR,
+			      line,
+			      l0 >> 32, (int)l0,
+			      l1 >> 32, (int)l1,
+			      l2 >> 32, (int)l2,
+			      0, 0, 0, 0, 0);
+}
+
+/*
  * Add a trace buffer entry for the cursor/operation.
  */
 void
Index: linux-2.6-xfs/fs/xfs/xfs_btree_trace.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree_trace.h	2008-07-21 05:08:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree_trace.h	2008-07-21 05:17:12.000000000 +0200
@@ -44,7 +44,8 @@ struct xfs_buf;
 #define XFS_BTREE_KTRACE_ARGIFK  5
 #define XFS_BTREE_KTRACE_ARGIFR  6
 #define XFS_BTREE_KTRACE_ARGIK   7
-#define XFS_BTREE_KTRACE_CUR     8
+#define XFS_BTREE_KTRACE_ARGR	 8
+#define XFS_BTREE_KTRACE_CUR     9
 
 /*
  * Sub-types for cursor traces.
@@ -67,6 +68,8 @@ void xfs_btree_trace_argifr(const char *
 		xfs_fsblock_t, union xfs_btree_rec *, int);
 void xfs_btree_trace_argik(const char *, struct xfs_btree_cur *, int,
 		union xfs_btree_key *, int);
+void xfs_btree_trace_argr(const char *, struct xfs_btree_cur *,
+		union xfs_btree_rec *, int);
 void xfs_btree_trace_cursor(const char *, struct xfs_btree_cur *, int, int);
 
 
@@ -95,6 +98,8 @@ extern ktrace_t	*xfs_bmbt_trace_buf;
 	xfs_btree_trace_argifr(__func__, c, i, f, r, __LINE__)
 #define	XFS_BTREE_TRACE_ARGIK(c,i,k)	\
 	xfs_btree_trace_argik(__func__, c, i, k, __LINE__)
+#define XFS_BTREE_TRACE_ARGR(c,r)	\
+	xfs_btree_trace_argr(__func__, c, r, __LINE__)
 #define	XFS_BTREE_TRACE_CURSOR(c,t)	\
 	xfs_btree_trace_cursor(__func__, c, t, __LINE__)
 #else
@@ -105,6 +110,7 @@ extern ktrace_t	*xfs_bmbt_trace_buf;
 #define	XFS_BTREE_TRACE_ARGIFK(c,i,f,s)
 #define	XFS_BTREE_TRACE_ARGIFR(c,i,f,r)
 #define	XFS_BTREE_TRACE_ARGIK(c,i,k)
+#define XFS_BTREE_TRACE_ARGR(c,r)
 #define	XFS_BTREE_TRACE_CURSOR(c,t)
 #endif	/* XFS_BTREE_TRACE */
 
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-07-21 05:08:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-07-21 05:17:12.000000000 +0200
@@ -2952,6 +2952,15 @@ xfs_btree_trace_entry(
 				      (unsigned long)ktep->val[8],
 				      (unsigned long)ktep->val[9]);
 		break;
+	case XFS_BTREE_KTRACE_ARGR:
+		xfsidb_btree_trace_record(btnum,
+					 (unsigned long)ktep->val[5],
+					 (unsigned long)ktep->val[6],
+					 (unsigned long)ktep->val[7],
+					 (unsigned long)ktep->val[8],
+					 (unsigned long)ktep->val[9],
+					 (unsigned long)ktep->val[10]);
+		break;
 	case XFS_BTREE_KTRACE_CUR:
 
 		xfsidb_btree_trace_cursor(btnum,
Index: linux-2.6-xfs/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc.c	2008-07-21 05:08:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc.c	2008-07-21 05:22:00.000000000 +0200
@@ -136,6 +136,23 @@ xfs_alloc_lookup_le(
 	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
 }
 
+/*
+ * Update the record referred to by cur to the value given
+ * by [bno, len].
+ * This either works (return 0) or gets an EFSCORRUPTED error.
+ */
+STATIC int				/* error */
+xfs_alloc_update(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	xfs_extlen_t		len)	/* length of extent */
+{
+	union xfs_btree_rec	rec;
+
+	rec.alloc.ar_startblock = cpu_to_be32(bno);
+	rec.alloc.ar_blockcount = cpu_to_be32(len);
+	return xfs_btree_update(cur, &rec);
+}
 
 /*
  * Compute aligned version of the found extent.
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.h	2008-07-21 05:08:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h	2008-07-21 05:17:12.000000000 +0200
@@ -113,13 +113,6 @@ extern int xfs_alloc_get_rec(struct xfs_
  */
 extern int xfs_alloc_insert(struct xfs_btree_cur *cur, int *stat);
 
-/*
- * Update the record referred to by cur, to the value given by [bno, len].
- * This either works (return 0) or gets an EFSCORRUPTED error.
- */
-extern int xfs_alloc_update(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-				xfs_extlen_t len);
-
 
 extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *,
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c	2008-07-21 05:25:57.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c	2008-07-21 05:30:09.000000000 +0200
@@ -172,6 +172,26 @@ xfs_inobt_lookup_le(
 }
 
 /*
+ * Update the record referred to by cur to the value given
+ * by [ino, fcnt, free].
+ * This either works (return 0) or gets an EFSCORRUPTED error.
+ */
+STATIC int				/* error */
+xfs_inobt_update(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agino_t		ino,	/* starting inode of chunk */
+	__int32_t		fcnt,	/* free inode count */
+	xfs_inofree_t		free)	/* free inode mask */
+{
+	union xfs_btree_rec	rec;
+
+	rec.inobt.ir_startino = cpu_to_be32(ino);
+	rec.inobt.ir_freecount = cpu_to_be32(fcnt);
+	rec.inobt.ir_free = cpu_to_be64(free);
+	return xfs_btree_update(cur, &rec);
+}
+
+/*
  * Allocate new inodes in the allocation group specified by agbp.
  * Return 0 for success, else error code.
  */
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-07-21 05:25:48.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-07-21 05:44:35.000000000 +0200
@@ -785,28 +785,6 @@ xfs_inobt_log_ptrs(
 }
 
 /*
- * Log records from a btree block (leaf).
- */
-STATIC void
-xfs_inobt_log_recs(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			rfirst,	/* index of first record to log */
-	int			rlast)	/* index of last record to log */
-{
-	xfs_inobt_block_t	*block;	/* btree block to log from */
-	int			first;	/* first byte offset logged */
-	int			last;	/* last byte offset logged */
-	xfs_inobt_rec_t		*rp;	/* record pointer for btree block */
-
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-	rp = XFS_INOBT_REC_ADDR(block, 1, cur);
-	first = (int)((xfs_caddr_t)&rp[rfirst - 1] - (xfs_caddr_t)block);
-	last = (int)(((xfs_caddr_t)&rp[rlast] - 1) - (xfs_caddr_t)block);
-	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
-}
-
-/*
  * Move 1 record left from cur/level if possible.
  * Update cur to reflect the new path.
  */
@@ -1530,58 +1508,6 @@ xfs_inobt_insert(
 	return 0;
 }
 
-/*
- * Update the record referred to by cur, to the value given
- * by [ino, fcnt, free].
- * This either works (return 0) or gets an EFSCORRUPTED error.
- */
-int					/* error */
-xfs_inobt_update(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_agino_t		ino,	/* starting inode of chunk */
-	__int32_t		fcnt,	/* free inode count */
-	xfs_inofree_t		free)	/* free inode mask */
-{
-	xfs_inobt_block_t	*block;	/* btree block to update */
-	xfs_buf_t		*bp;	/* buffer containing btree block */
-	int			error;	/* error return value */
-	int			ptr;	/* current record number (updating) */
-	xfs_inobt_rec_t		*rp;	/* pointer to updated record */
-
-	/*
-	 * Pick up the current block.
-	 */
-	bp = cur->bc_bufs[0];
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, 0, bp)))
-		return error;
-#endif
-	/*
-	 * Get the address of the rec to be updated.
-	 */
-	ptr = cur->bc_ptrs[0];
-	rp = XFS_INOBT_REC_ADDR(block, ptr, cur);
-	/*
-	 * Fill in the new contents and log them.
-	 */
-	rp->ir_startino = cpu_to_be32(ino);
-	rp->ir_freecount = cpu_to_be32(fcnt);
-	rp->ir_free = cpu_to_be64(free);
-	xfs_inobt_log_recs(cur, bp, ptr, ptr);
-	/*
-	 * Updating first record in leaf. Pass new key value up to our parent.
-	 */
-	if (ptr == 1) {
-		xfs_inobt_key_t	key;	/* key containing [ino] */
-
-		key.ir_startino = cpu_to_be32(ino);
-		if ((error = xfs_btree_updkey(cur, (union xfs_btree_key *)&key, 1)))
-			return error;
-	}
-	return 0;
-}
-
 STATIC struct xfs_btree_cur *
 xfs_inobt_dup_cursor(
 	struct xfs_btree_cur	*cur)
@@ -1664,6 +1590,17 @@ xfs_inobt_copy_keys(
 	memcpy(dst_key, src_key, numkeys * sizeof(xfs_inobt_key_t));
 }
 
+STATIC void
+xfs_inobt_copy_recs(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*src_rec,
+	union xfs_btree_rec	*dst_rec,
+	int			numrecs)
+{
+	ASSERT(numrecs >= 0);
+	memcpy(dst_rec, src_rec, numrecs * sizeof(xfs_inobt_rec_t));
+}
+
 /*
  * Log keys from a btree block (nonleaf).
  */
@@ -1691,6 +1628,34 @@ xfs_inobt_log_keys(
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 }
 
+/*
+ * Log records from a btree block (leaf).
+ */
+STATIC void
+xfs_inobt_log_recs(
+	xfs_btree_cur_t		*cur,	/* btree cursor */
+	xfs_buf_t		*bp,	/* buffer containing btree block */
+	int			rfirst,	/* index of first record to log */
+	int			rlast)	/* index of last record to log */
+{
+	struct xfs_btree_sblock	*block;	/* btree block to log from */
+	int			first;	/* first byte offset logged */
+	int			last;	/* last byte offset logged */
+	xfs_inobt_rec_t		*rp;	/* record pointer for btree block */
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, rfirst, rlast);
+
+	block = XFS_BUF_TO_SBLOCK(bp);
+	rp = XFS_INOBT_REC_ADDR(block, 1, cur);
+	first = (int)((xfs_caddr_t)&rp[rfirst - 1] - (xfs_caddr_t)block);
+	last = (int)(((xfs_caddr_t)&rp[rlast] - 1) - (xfs_caddr_t)block);
+	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+}
+
+
 #ifdef XFS_BTREE_TRACE
 
 ktrace_t	*xfs_inobt_trace_buf;
@@ -1767,7 +1732,9 @@ static const struct xfs_btree_ops xfs_in
 	.rec_addr		= xfs_inobt_rec_addr,
 	.key_diff		= xfs_inobt_key_diff,
 	.copy_keys		= xfs_inobt_copy_keys,
+	.copy_recs		= xfs_inobt_copy_recs,
 	.log_keys		= xfs_inobt_log_keys,
+	.log_recs		= xfs_inobt_log_recs,
 
 #ifdef XFS_BTREE_TRACE
 	.trace_enter		= xfs_inobt_trace_enter,
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.h	2008-07-21 05:25:23.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h	2008-07-21 05:25:47.000000000 +0200
@@ -135,14 +135,6 @@ extern int xfs_inobt_get_rec(struct xfs_
  */
 extern int xfs_inobt_insert(struct xfs_btree_cur *cur, int *stat);
 
-/*
- * Update the record referred to by cur, to the value given
- * by [ino, fcnt, free].
- * This either works (return 0) or gets an EFSCORRUPTED error.
- */
-extern int xfs_inobt_update(struct xfs_btree_cur *cur, xfs_agino_t ino,
-				__int32_t fcnt, xfs_inofree_t free);
-
 
 extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t);
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-07-21 05:27:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-07-21 05:29:42.000000000 +0200
@@ -430,6 +430,24 @@ xfs_bmbt_lookup_ge(
 	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
 }
 
+/*
+* Update the record referred to by cur to the value given
+ * by [off, bno, len, state].
+ * This either works (return 0) or gets an EFSCORRUPTED error.
+ */
+STATIC int
+xfs_bmbt_update(
+	struct xfs_btree_cur	*cur,
+	xfs_fileoff_t		off,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
+	xfs_exntst_t		state)
+{
+	union xfs_btree_rec	rec;
+
+	xfs_bmbt_disk_set_allf(&rec.bmbt, off, bno, len, state);
+	return xfs_btree_update(cur, &rec);
+}
 
 /*
  * Called from xfs_bmap_add_attrfork to handle btree format files.
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-07-21 05:27:36.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-07-21 05:49:46.000000000 +0200
@@ -1565,34 +1565,6 @@ xfs_bmbt_log_block(
 }
 
 /*
- * Log record values from the btree block.
- */
-void
-xfs_bmbt_log_recs(
-	xfs_btree_cur_t		*cur,
-	xfs_buf_t		*bp,
-	int			rfirst,
-	int			rlast)
-{
-	xfs_bmbt_block_t	*block;
-	int			first;
-	int			last;
-	xfs_bmbt_rec_t		*rp;
-	xfs_trans_t		*tp;
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGBII(cur, bp, rfirst, rlast);
-	ASSERT(bp);
-	tp = cur->bc_tp;
-	block = XFS_BUF_TO_BMBT_BLOCK(bp);
-	rp = XFS_BMAP_REC_DADDR(block, 1, cur);
-	first = (int)((xfs_caddr_t)&rp[rfirst - 1] - (xfs_caddr_t)block);
-	last = (int)(((xfs_caddr_t)&rp[rlast] - 1) - (xfs_caddr_t)block);
-	xfs_trans_log_buf(tp, bp, first, last);
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-}
-
-/*
  * Give the bmap btree a new root block.  Copy the old broot contents
  * down into a real block and make the broot point to it.
  */
@@ -1926,51 +1898,6 @@ xfs_bmbt_to_bmdr(
 }
 
 /*
- * Update the record to the passed values.
- */
-int
-xfs_bmbt_update(
-	xfs_btree_cur_t		*cur,
-	xfs_fileoff_t		off,
-	xfs_fsblock_t		bno,
-	xfs_filblks_t		len,
-	xfs_exntst_t		state)
-{
-	xfs_bmbt_block_t	*block;
-	xfs_buf_t		*bp;
-	int			error;
-	xfs_bmbt_key_t		key;
-	int			ptr;
-	xfs_bmbt_rec_t		*rp;
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGFFFI(cur, (xfs_dfiloff_t)off, (xfs_dfsbno_t)bno,
-		(xfs_dfilblks_t)len, (int)state);
-	block = xfs_bmbt_get_block(cur, 0, &bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_lblock(cur, block, 0, bp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-#endif
-	ptr = cur->bc_ptrs[0];
-	rp = XFS_BMAP_REC_IADDR(block, ptr, cur);
-	xfs_bmbt_disk_set_allf(rp, off, bno, len, state);
-	xfs_bmbt_log_recs(cur, bp, ptr, ptr);
-	if (ptr > 1) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		return 0;
-	}
-	key.br_startoff = cpu_to_be64(off);
-	if ((error = xfs_btree_updkey(cur, (union xfs_btree_key *)&key, 1))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	return 0;
-}
-
-/*
  * Check extent records, which have just been read, for
  * any bit in the extent flag field. ASSERT on debug
  * kernels, as this condition should not occur.
@@ -2094,6 +2021,17 @@ xfs_bmbt_copy_keys(
 	memcpy(dst_key, src_key, numkeys * sizeof(xfs_bmbt_key_t));
 }
 
+STATIC void
+xfs_bmbt_copy_recs(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*src_rec,
+	union xfs_btree_rec	*dst_rec,
+	int			numrecs)
+{
+	ASSERT(numrecs >= 0);
+	memcpy(dst_rec, src_rec, numrecs * sizeof(xfs_bmbt_rec_t));
+}
+
 /*
  * Log key values from the btree block.
  */
@@ -2126,6 +2064,33 @@ xfs_bmbt_log_keys(
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 }
 
+/*
+ * Log record values from the btree block.
+ */
+void
+xfs_bmbt_log_recs(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp,
+	int			rfirst,
+	int			rlast)
+{
+	struct xfs_btree_lblock	*block;
+	int			first;
+	int			last;
+	xfs_bmbt_rec_t		*rp;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, rfirst, rlast);
+
+	block = XFS_BUF_TO_LBLOCK(bp);
+	rp = XFS_BMAP_REC_DADDR(block, 1, cur);
+	first = (int)((xfs_caddr_t)&rp[rfirst - 1] - (xfs_caddr_t)block);
+	last = (int)(((xfs_caddr_t)&rp[rlast] - 1) - (xfs_caddr_t)block);
+	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+}
+
 #ifdef XFS_BTREE_TRACE
 
 ktrace_t	*xfs_bmbt_trace_buf;
@@ -2222,7 +2187,9 @@ static const struct xfs_btree_ops xfs_bm
 	.rec_addr		= xfs_bmbt_rec_addr,
 	.key_diff		= xfs_bmbt_key_diff,
 	.copy_keys		= xfs_bmbt_copy_keys,
+	.copy_recs		= xfs_bmbt_copy_recs,
 	.log_keys		= xfs_bmbt_log_keys,
+	.log_recs		= xfs_bmbt_log_recs,
 
 #ifdef XFS_BTREE_TRACE
 	.trace_enter		= xfs_bmbt_trace_enter,
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.h	2008-07-21 05:27:31.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h	2008-07-21 05:27:35.000000000 +0200
@@ -274,8 +274,6 @@ extern void xfs_bmbt_disk_set_allf(xfs_b
 			xfs_fsblock_t b, xfs_filblks_t c, xfs_exntst_t v);
 
 extern void xfs_bmbt_to_bmdr(xfs_bmbt_block_t *, int, xfs_bmdr_block_t *, int);
-extern int xfs_bmbt_update(struct xfs_btree_cur *, xfs_fileoff_t,
-				xfs_fsblock_t, xfs_filblks_t, xfs_exntst_t);
 
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);

-- 
