Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Aug 2008 18:35:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m741YvRZ001757
	for <xfs@oss.sgi.com>; Sun, 3 Aug 2008 18:34:57 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A7DFEF6ACA
	for <xfs@oss.sgi.com>; Sun,  3 Aug 2008 18:36:08 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 84ar1Mfn7ywzdarM for <xfs@oss.sgi.com>; Sun, 03 Aug 2008 18:36:08 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m741a8IF009360
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 03:36:08 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m741a8t4009358
	for xfs@oss.sgi.com; Mon, 4 Aug 2008 03:36:08 +0200
Date: Mon, 4 Aug 2008 03:36:08 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 26/26] add rec_len and key_len fields to struct xfs_btree_ops
Message-ID: <20080804013608.GA8819@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-btree-rec-key-size
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

XXX: add detailed patch explanation here

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-08-04 01:48:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-08-04 01:49:13.000000000 +0200
@@ -261,33 +261,6 @@ xfs_allocbt_init_rec_from_cur(
 	rec->alloc.ar_blockcount = cpu_to_be32(cur->bc_rec.a.ar_blockcount);
 }
 
-STATIC union xfs_btree_ptr *
-xfs_allocbt_ptr_addr(
-	struct xfs_btree_cur	*cur,
-	int			index,
-	struct xfs_btree_block	*block)
-{
-	return (union xfs_btree_ptr *)XFS_ALLOC_PTR_ADDR(block, index, cur);
-}
-
-STATIC union xfs_btree_key *
-xfs_allocbt_key_addr(
-	struct xfs_btree_cur	*cur,
-	int			index,
-	struct xfs_btree_block	*block)
-{
-	return (union xfs_btree_key *)XFS_ALLOC_KEY_ADDR(block, index, cur);
-}
-
-STATIC union xfs_btree_rec *
-xfs_allocbt_rec_addr(
-	struct xfs_btree_cur	*cur,
-	int			index,
-	struct xfs_btree_block	*block)
-{
-	return (union xfs_btree_rec *)XFS_ALLOC_REC_ADDR(block, index, cur);
-}
-
 STATIC __int64_t
 xfs_allocbt_key_diff(
 	struct xfs_btree_cur	*cur,
@@ -309,161 +282,6 @@ xfs_allocbt_key_diff(
 	return (__int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
 }
 
-STATIC void
-xfs_allocbt_set_key(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*key_addr,
-	int			index,
-	union xfs_btree_key	*newkey)
-{
-	xfs_alloc_key_t		*kp = &key_addr->alloc;
-
-	kp[index] = newkey->alloc;
-}
-
-STATIC void
-xfs_allocbt_set_rec(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*rec_addr,
-	int			index,
-	union xfs_btree_rec	*newrec)
-{
-	xfs_alloc_rec_t		*rp = &rec_addr->alloc;
-
-	rp[index] = newrec->alloc;
-}
-
-STATIC void
-xfs_allocbt_move_keys(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*base,
-	int			from,
-	int			to,
-	int			numkeys)
-{
-	xfs_alloc_key_t		*kp = &base->alloc;
-
-	ASSERT(from >= 0);
-	ASSERT(to >= 0);
-	ASSERT(numkeys >= 0);
-
-	memmove(&kp[to], &kp[from], numkeys * sizeof(*kp));
-}
-
-STATIC void
-xfs_allocbt_move_recs(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*base,
-	int			from,
-	int			to,
-	int			numrecs)
-{
-	xfs_alloc_rec_t		*rp = &base->alloc;
-
-	ASSERT(from >= 0);
-	ASSERT(to >= 0);
-	ASSERT(numrecs >= 0);
-
-	memmove(&rp[to], &rp[from], numrecs * sizeof(*rp));
-}
-
-STATIC void
-xfs_allocbt_copy_keys(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*src_key,
-	union xfs_btree_key	*dst_key,
-	int			numkeys)
-{
-	ASSERT(numkeys >= 0);
-	memcpy(dst_key, src_key, numkeys * sizeof(xfs_alloc_key_t));
-}
-
-STATIC void
-xfs_allocbt_copy_recs(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*src_rec,
-	union xfs_btree_rec	*dst_rec,
-	int			numrecs)
-{
-	ASSERT(numrecs >= 0);
-	memcpy(dst_rec, src_rec, numrecs * sizeof(xfs_alloc_rec_t));
-}
-
-/*
- * Log keys from a btree block (nonleaf).
- */
-STATIC void
-xfs_allocbt_log_keys(
-	struct xfs_btree_cur	*cur,	/* btree cursor */
-	struct xfs_buf		*bp,	/* buffer containing btree block */
-	int			first,	/* index of first key to log */
-	int			last)	/* index of last key to log */
-{
-	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
-	xfs_alloc_key_t		*kp = XFS_ALLOC_KEY_ADDR(block, 1, cur);
-	char			*baddr = (char *)block;
-	int			start;	/* first byte offset logged */
-	int			end;	/* last byte offset logged */
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
-
-	start = (char *)&kp[first - 1] - baddr;
-	end = (char *)&kp[last] - 1 - baddr;
-	xfs_trans_log_buf(cur->bc_tp, bp, start, end);
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
-}
-
-#ifdef DEBUG
-STATIC void
-xfs_alloc_log_recs_check(
-	struct xfs_btree_cur	*cur,
-	xfs_alloc_rec_t		*rp,
-	int			first,
-	int			last)
-{
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
-	xfs_alloc_rec_t		*p;
-
-	for (p = &rp[first - 1]; p <= &rp[last - 1]; p++) {
-		ASSERT(be32_to_cpu(p->ar_startblock) +
-		       be32_to_cpu(p->ar_blockcount) <=
-		       be32_to_cpu(agf->agf_length));
-	}
-}
-#else
-#define xfs_alloc_log_recs_check(cur, bp, first, last)
-#endif
-
-/*
- * Log records from a btree block (leaf).
- */
-STATIC void
-xfs_allocbt_log_recs(
-	struct xfs_btree_cur	*cur,	/* btree cursor */
-	struct xfs_buf		*bp,	/* buffer containing btree block */
-	int			first,	/* index of first record to log */
-	int			last)	/* index of last record to log */
-{
-	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
-	xfs_alloc_rec_t		*rp = XFS_ALLOC_REC_ADDR(block, 1, cur);
-	char			*baddr = (char *)block;
-	int			start;	/* first byte offset logged */
-	int			end;	/* last byte offset logged */
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
-
-	xfs_alloc_log_recs_check(cur, rp, first, last);
-
-	start = (char *)&rp[first - 1] - baddr;
-	end = (char *)&rp[last] - 1 - baddr;
-	xfs_trans_log_buf(cur->bc_tp, bp, start, end);
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
-}
-
 #ifdef XFS_BTREE_TRACE
 
 ktrace_t	*xfs_allocbt_trace_buf;
@@ -532,6 +350,9 @@ xfs_allocbt_trace_record(
 #endif /* XFS_BTREE_TRACE */
 
 static const struct xfs_btree_ops xfs_allocbt_ops = {
+	.key_len		= sizeof(xfs_alloc_key_t),
+	.rec_len		= sizeof(xfs_alloc_rec_t),
+
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
 	.alloc_block		= xfs_allocbt_alloc_block,
@@ -543,18 +364,7 @@ static const struct xfs_btree_ops xfs_al
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
 	.init_rec_from_key	= xfs_allocbt_init_rec_from_key,
 	.init_rec_from_cur	= xfs_allocbt_init_rec_from_cur,
-	.ptr_addr		= xfs_allocbt_ptr_addr,
-	.key_addr		= xfs_allocbt_key_addr,
-	.rec_addr		= xfs_allocbt_rec_addr,
 	.key_diff		= xfs_allocbt_key_diff,
-	.set_key		= xfs_allocbt_set_key,
-	.set_rec		= xfs_allocbt_set_rec,
-	.move_keys		= xfs_allocbt_move_keys,
-	.move_recs		= xfs_allocbt_move_recs,
-	.copy_keys		= xfs_allocbt_copy_keys,
-	.copy_recs		= xfs_allocbt_copy_recs,
-	.log_keys		= xfs_allocbt_log_keys,
-	.log_recs		= xfs_allocbt_log_recs,
 
 #ifdef XFS_BTREE_TRACE
 	.trace_enter		= xfs_allocbt_trace_enter,
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-08-04 01:48:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-08-04 01:49:13.000000000 +0200
@@ -699,33 +699,6 @@ xfs_bmbt_init_rec_from_cur(
 	xfs_bmbt_disk_set_all(&rec->bmbt, &cur->bc_rec.b);
 }
 
-STATIC union xfs_btree_ptr *
-xfs_bmbt_ptr_addr(
-	struct xfs_btree_cur	*cur,
-	int			index,
-	struct xfs_btree_block	*block)
-{
-	return (union xfs_btree_ptr *)XFS_BMAP_PTR_IADDR(block, index, cur);
-}
-
-STATIC union xfs_btree_key *
-xfs_bmbt_key_addr(
-	struct xfs_btree_cur	*cur,
-	int			index,
-	struct xfs_btree_block	*block)
-{
-	return (union xfs_btree_key *)XFS_BMAP_KEY_IADDR(block, index, cur);
-}
-
-STATIC union xfs_btree_rec *
-xfs_bmbt_rec_addr(
-	struct xfs_btree_cur	*cur,
-	int			index,
-	struct xfs_btree_block	*block)
-{
-	return (union xfs_btree_rec *)XFS_BMAP_REC_IADDR(block, index, cur);
-}
-
 STATIC __int64_t
 xfs_bmbt_key_diff(
 	struct xfs_btree_cur	*cur,
@@ -735,142 +708,6 @@ xfs_bmbt_key_diff(
 				      cur->bc_rec.b.br_startoff;
 }
 
-STATIC void
-xfs_bmbt_set_key(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*key_addr,
-	int			index,
-	union xfs_btree_key	*newkey)
-{
-	xfs_bmbt_key_t		*kp = &key_addr->bmbt;
-
-	kp[index] = newkey->bmbt;
-}
-
-STATIC void
-xfs_bmbt_set_rec(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*rec_addr,
-	int			index,
-	union xfs_btree_rec	*newrec)
-{
-	xfs_bmbt_rec_t		*rp = &rec_addr->bmbt;
-
-	rp[index] = newrec->bmbt;
-}
-
-STATIC void
-xfs_bmbt_move_keys(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*base,
-	int			from,
-	int			to,
-	int			numkeys)
-{
-	xfs_bmbt_key_t		*kp = &base->bmbt;
-
-	ASSERT(from >= 0 && from <= 1000);
-	ASSERT(to >= 0 && to <= 1000);
-	ASSERT(numkeys >= 0);
-
-	memmove(&kp[to], &kp[from], numkeys * sizeof(*kp));
-}
-
-STATIC void
-xfs_bmbt_move_recs(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*base,
-	int			from,
-	int			to,
-	int			numrecs)
-{
-	xfs_bmbt_rec_t		*rp = &base->bmbt;
-
-	ASSERT(from >= 0);
-	ASSERT(to >= 0);
-	ASSERT(numrecs >= 0);
-
-	memmove(&rp[to], &rp[from], numrecs * sizeof(*rp));
-}
-
-STATIC void
-xfs_bmbt_copy_keys(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*src_key,
-	union xfs_btree_key	*dst_key,
-	int			numkeys)
-{
-	ASSERT(numkeys >= 0);
-	memcpy(dst_key, src_key, numkeys * sizeof(xfs_bmbt_key_t));
-}
-
-STATIC void
-xfs_bmbt_copy_recs(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*src_rec,
-	union xfs_btree_rec	*dst_rec,
-	int			numrecs)
-{
-	ASSERT(numrecs >= 0);
-	memcpy(dst_rec, src_rec, numrecs * sizeof(xfs_bmbt_rec_t));
-}
-
-/*
- * Log key values from the btree block.
- */
-STATIC void
-xfs_bmbt_log_keys(
-	struct xfs_btree_cur	*cur,
-	struct xfs_buf		*bp,
-	int			first,
-	int			last)
-{
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
-
-	if (bp) {
-		struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
-		xfs_bmbt_key_t		*kp = XFS_BMAP_KEY_DADDR(block, 1, cur);
-		char			*baddr = (char *)block;
-		int			start;
-		int			end;
-
-		start = (char *)&kp[first - 1] - baddr;
-		end = (char *)&kp[last] - 1 - baddr;
-		xfs_trans_log_buf(cur->bc_tp, bp, start, end);
-	} else {
-		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
-			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
-	}
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
-}
-
-/*
- * Log record values from the btree block.
- */
-void
-xfs_bmbt_log_recs(
-	struct xfs_btree_cur	*cur,
-	struct xfs_buf		*bp,
-	int			first,
-	int			last)
-{
-	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
-	xfs_bmbt_rec_t		*rp = XFS_BMAP_REC_DADDR(block, 1, cur);
-	char			*baddr = (char *)block;
-	int			start;
-	int			end;
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
-
-	start = (char *)&rp[first - 1] - baddr;
-	end = (char *)&rp[last] - 1 - baddr;
-	xfs_trans_log_buf(cur->bc_tp, bp, start, end);
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
-}
 
 #ifdef XFS_BTREE_TRACE
 
@@ -959,6 +796,9 @@ xfs_bmbt_trace_record(
 #endif /* XFS_BTREE_TRACE */
 
 static const struct xfs_btree_ops xfs_bmbt_ops = {
+	.key_len		= sizeof(xfs_bmbt_key_t),
+	.rec_len		= sizeof(xfs_bmbt_rec_t),
+
 	.dup_cursor		= xfs_bmbt_dup_cursor,
 	.update_cursor		= xfs_bmbt_update_cursor,
 	.get_root_from_inode	= xfs_bmbt_get_root_from_inode,
@@ -972,18 +812,7 @@ static const struct xfs_btree_ops xfs_bm
 	.get_minrecs		= xfs_bmbt_get_minrecs,
 	.get_maxrecs		= xfs_bmbt_get_maxrecs,
 	.get_dmaxrecs		= xfs_bmbt_get_dmaxrecs,
-	.ptr_addr		= xfs_bmbt_ptr_addr,
-	.key_addr		= xfs_bmbt_key_addr,
-	.rec_addr		= xfs_bmbt_rec_addr,
 	.key_diff		= xfs_bmbt_key_diff,
-	.set_key		= xfs_bmbt_set_key,
-	.set_rec		= xfs_bmbt_set_rec,
-	.move_keys		= xfs_bmbt_move_keys,
-	.move_recs		= xfs_bmbt_move_recs,
-	.copy_keys		= xfs_bmbt_copy_keys,
-	.copy_recs		= xfs_bmbt_copy_recs,
-	.log_keys		= xfs_bmbt_log_keys,
-	.log_recs		= xfs_bmbt_log_recs,
 
 #ifdef XFS_BTREE_TRACE
 	.trace_enter		= xfs_bmbt_trace_enter,
Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-08-04 01:48:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-08-04 01:49:13.000000000 +0200
@@ -1037,6 +1037,82 @@ xfs_btree_read_buf_block(
 	return error;
 }
 
+static inline size_t xfs_btree_block_len(struct xfs_btree_cur *cur)
+{
+	return (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
+		sizeof(struct xfs_btree_lblock) :
+		sizeof(struct xfs_btree_sblock);
+}
+
+static inline size_t xfs_btree_ptr_len(struct xfs_btree_cur *cur)
+{
+	return (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
+		sizeof(__be64) : sizeof(__be32);
+}
+
+static size_t
+xfs_btree_ptr_offset(
+	struct xfs_btree_cur	*cur,
+	int			index,
+	int			level)
+{
+	return xfs_btree_block_len(cur) +
+		cur->bc_ops->get_maxrecs(cur, level) * cur->bc_ops->key_len +
+		(index - 1) * xfs_btree_ptr_len(cur);
+}
+
+static size_t
+xfs_btree_key_offset(
+	struct xfs_btree_cur	*cur,
+	int			index)
+{
+	return xfs_btree_block_len(cur) +
+		(index - 1) * cur->bc_ops->key_len;
+}
+
+static size_t
+xfs_btree_rec_offset(
+	struct xfs_btree_cur	*cur,
+	int			index)
+{
+	return xfs_btree_block_len(cur) +
+		(index - 1) * cur->bc_ops->rec_len;
+}
+
+static union xfs_btree_ptr *
+xfs_btree_ptr_addr(
+	struct xfs_btree_cur	*cur,
+	int			index,
+	struct xfs_btree_block	*block)
+{
+	int			level = xfs_btree_get_level(block);
+
+	ASSERT(block->bb_level != 0);
+
+	return (union xfs_btree_ptr *)
+		((char *)block + xfs_btree_ptr_offset(cur, index, level));
+}
+
+static union xfs_btree_key *
+xfs_btree_key_addr(
+	struct xfs_btree_cur	*cur,
+	int			index,
+	struct xfs_btree_block	*block)
+{
+	return (union xfs_btree_key *)
+		((char *)block + xfs_btree_key_offset(cur, index));
+}
+
+static union xfs_btree_rec *
+xfs_btree_rec_addr(
+	struct xfs_btree_cur	*cur,
+	int			index,
+	struct xfs_btree_block	*block)
+{
+	return (union xfs_btree_rec *)
+		((char *)block + xfs_btree_rec_offset(cur, index));
+}
+
 STATIC void
 xfs_btree_set_ptr(
 	struct xfs_btree_cur	*cur,
@@ -1056,6 +1132,34 @@ xfs_btree_set_ptr(
 }
 
 STATIC void
+xfs_btree_set_key(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key_addr,
+	int			index,
+	union xfs_btree_key	*newkey)
+{
+	char			*kp;
+
+	kp = (char *)key_addr + (index * cur->bc_ops->key_len);
+
+	memcpy(kp, newkey, cur->bc_ops->key_len);
+}
+
+STATIC void
+xfs_btree_set_rec(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec_addr,
+	int			index,
+	union xfs_btree_rec	*newrec)
+{
+	char			*rp;
+
+	rp = (char *)rec_addr + (index * cur->bc_ops->rec_len);
+
+	memcpy(rp, newrec, cur->bc_ops->rec_len);
+}
+
+STATIC void
 xfs_btree_move_ptrs(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*base,
@@ -1079,6 +1183,44 @@ xfs_btree_move_ptrs(
 }
 
 STATIC void
+xfs_btree_move_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key,
+	int			from,
+	int			to,
+	int			numkeys)
+{
+	char			*base = (char *)key;
+
+	ASSERT(from >= 0);
+	ASSERT(to >= 0);
+	ASSERT(numkeys >= 0);
+
+	memmove(base + (to * cur->bc_ops->key_len),
+		base + (from * cur->bc_ops->key_len),
+		numkeys * cur->bc_ops->key_len);
+}
+
+STATIC void
+xfs_btree_move_recs(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec,
+	int			from,
+	int			to,
+	int			numrecs)
+{
+	char			*base = (char *)rec;
+
+	ASSERT(from >= 0);
+	ASSERT(to >= 0);
+	ASSERT(numrecs >= 0);
+
+	memmove(base + (to * cur->bc_ops->rec_len),
+		base + (from * cur->bc_ops->rec_len),
+		numrecs * cur->bc_ops->rec_len);
+}
+
+STATIC void
 xfs_btree_copy_ptrs(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*src_ptr,
@@ -1087,10 +1229,29 @@ xfs_btree_copy_ptrs(
 {
 	ASSERT(numptrs > 0);
 
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
-		memcpy(dst_ptr, src_ptr, numptrs * sizeof(__be64));
-	else
-		memcpy(dst_ptr, src_ptr, numptrs * sizeof(__be32));
+	memcpy(dst_ptr, src_ptr, numptrs * xfs_btree_ptr_len(cur));
+}
+
+STATIC void
+xfs_btree_copy_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*src_key,
+	union xfs_btree_key	*dst_key,
+	int			numkeys)
+{
+	ASSERT(numkeys >= 0);
+	memcpy(dst_key, src_key, numkeys * cur->bc_ops->key_len);
+}
+
+STATIC void
+xfs_btree_copy_recs(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*src_rec,
+	union xfs_btree_rec	*dst_rec,
+	int			numrecs)
+{
+	ASSERT(numrecs >= 0);
+	memcpy(dst_rec, src_rec, numrecs * cur->bc_ops->rec_len);
 }
 
 /*
@@ -1108,26 +1269,36 @@ xfs_btree_log_ptrs(
 
 	if (bp) {
 		struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
-		char			*baddr = (char *)block;
-		union xfs_btree_ptr	*pp;
-		int			start;	/* first byte offset logged */
-		int			end;	/* last byte offset logged */
-
-		pp = cur->bc_ops->ptr_addr(cur, 1, block);
+		int			level = xfs_btree_get_level(block);
 
-		if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-			__be64		*lpp = &pp->l;
+		xfs_trans_log_buf(cur->bc_tp, bp,
+				xfs_btree_ptr_offset(cur, first, level),
+				xfs_btree_ptr_offset(cur, last + 1, level) - 1);
+	} else {
+		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
+			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
+	}
 
-			start = (char *)&lpp[first - 1] - baddr;
-			end = (char *)&lpp[last] - 1 - baddr;
-		} else {
-			__be32		*spp = &pp->s;
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+}
 
-			start = (char *)&spp[first - 1] - baddr;
-			end = (char *)&spp[last] - 1 - baddr;
-		}
+/*
+ * Log key values from the btree block.
+ */
+void
+xfs_btree_log_keys(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp,
+	int			first,
+	int			last)
+{
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
 
-		xfs_trans_log_buf(cur->bc_tp, bp, start, end);
+	if (bp) {
+		xfs_trans_log_buf(cur->bc_tp, bp,
+				  xfs_btree_key_offset(cur, first),
+				  xfs_btree_key_offset(cur, last + 1) - 1);
 	} else {
 		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
 			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
@@ -1137,6 +1308,26 @@ xfs_btree_log_ptrs(
 }
 
 /*
+ * Log record values from the btree block.
+ */
+void
+xfs_btree_log_recs(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp,
+	int			first,
+	int			last)
+{
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
+
+	xfs_trans_log_buf(cur->bc_tp, bp,
+			  xfs_btree_rec_offset(cur, first),
+			  xfs_btree_rec_offset(cur, last + 1) - 1);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+}
+
+/*
  * Log fields from the short from btree block header.
  */
 void
@@ -1267,7 +1458,7 @@ xfs_btree_increment(
 	for (block = xfs_btree_get_block(cur, lev, &bp); lev > level; ) {
 		union xfs_btree_ptr	*ptrp;
 
-		ptrp = cur->bc_ops->ptr_addr(cur, cur->bc_ptrs[lev], block);
+		ptrp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[lev], block);
 		error = xfs_btree_read_buf_block(cur, ptrp, --lev,
 							0, &block, &bp);
 		if (error)
@@ -1366,7 +1557,7 @@ xfs_btree_decrement(
 	for (block = xfs_btree_get_block(cur, lev, &bp); lev > level; ) {
 		union xfs_btree_ptr	*ptrp;
 
-		ptrp = cur->bc_ops->ptr_addr(cur, cur->bc_ptrs[lev], block);
+		ptrp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[lev], block);
 		error = xfs_btree_read_buf_block(cur, ptrp, --lev,
 							0, &block, &bp);
 		if (error)
@@ -1442,12 +1633,12 @@ xfs_lookup_get_search_key(
 	if (level == 0) {
 		union xfs_btree_rec	*rp;
 
-		rp = cur->bc_ops->rec_addr(cur, keyno, block);
+		rp = xfs_btree_rec_addr(cur, keyno, block);
 		cur->bc_ops->init_key_from_rec(cur, kp, rp);
 		return kp;
 	}
 
-	return cur->bc_ops->key_addr(cur, keyno, block);
+	return xfs_btree_key_addr(cur, keyno, block);
 }
 
 /*
@@ -1558,7 +1749,7 @@ xfs_btree_lookup(
 			 */
 			if (diff > 0 && --keyno < 1)
 				keyno = 1;
-			pp = cur->bc_ops->ptr_addr(cur, keyno, block);
+			pp = xfs_btree_ptr_addr(cur, keyno, block);
 
 #ifdef DEBUG
 			error = xfs_btree_check_ptr(cur, pp, 0, level);
@@ -1648,9 +1839,9 @@ xfs_btree_updkey(
 		}
 #endif
 		ptr = cur->bc_ptrs[level];
-		kp = cur->bc_ops->key_addr(cur, ptr, block);
-		cur->bc_ops->copy_keys(cur, keyp, kp, 1);
-		cur->bc_ops->log_keys(cur, bp, ptr, ptr);
+		kp = xfs_btree_key_addr(cur, ptr, block);
+		xfs_btree_copy_keys(cur, keyp, kp, 1);
+		xfs_btree_log_keys(cur, bp, ptr, ptr);
 	}
 
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
@@ -1686,11 +1877,11 @@ xfs_btree_update(
 #endif
 	/* Get the address of the rec to be updated. */
 	ptr = cur->bc_ptrs[0];
-	rp = cur->bc_ops->rec_addr(cur, ptr, block);
+	rp = xfs_btree_rec_addr(cur, ptr, block);
 
 	/* Fill in the new contents and log them. */
-	cur->bc_ops->copy_recs(cur, rec, rp, 1);
-	cur->bc_ops->log_recs(cur, bp, ptr, ptr);
+	xfs_btree_copy_recs(cur, rec, rp, 1);
+	xfs_btree_log_recs(cur, bp, ptr, ptr);
 
 	/*
 	 * If we are tracking the last record in the tree and
@@ -1802,37 +1993,37 @@ xfs_btree_lshift(
 		union xfs_btree_key	*lkp;	/* left btree key */
 		union xfs_btree_ptr	*lpp;	/* left address pointer */
 
-		lkp = cur->bc_ops->key_addr(cur, lrecs, left);
-		rkp = cur->bc_ops->key_addr(cur, 1, right);
+		lkp = xfs_btree_key_addr(cur, lrecs, left);
+		rkp = xfs_btree_key_addr(cur, 1, right);
 
-		lpp = cur->bc_ops->ptr_addr(cur, lrecs, left);
-		rpp = cur->bc_ops->ptr_addr(cur, 1, right);
+		lpp = xfs_btree_ptr_addr(cur, lrecs, left);
+		rpp = xfs_btree_ptr_addr(cur, 1, right);
 #ifdef DEBUG
 		error = xfs_btree_check_ptr(cur, rpp, 0, level);
 		if (error)
 			goto error0;
 #endif
-		cur->bc_ops->copy_keys(cur, rkp, lkp, 1);
+		xfs_btree_copy_keys(cur, rkp, lkp, 1);
 		xfs_btree_copy_ptrs(cur, rpp, lpp, 1);
 
-		cur->bc_ops->log_keys(cur, lbp, lrecs, lrecs);
+		xfs_btree_log_keys(cur, lbp, lrecs, lrecs);
 		xfs_btree_log_ptrs(cur, lbp, lrecs, lrecs);
 
 		xfs_btree_check_key(cur->bc_btnum,
-				    cur->bc_ops->key_addr(cur, lrecs - 1, left),
+				    xfs_btree_key_addr(cur, lrecs - 1, left),
 				    lkp);
 	} else {
 		/* It's a leaf.  Move records.  */
 		union xfs_btree_rec	*lrp;	/* left record pointer */
 
-		lrp = cur->bc_ops->rec_addr(cur, lrecs, left);
-		rrp = cur->bc_ops->rec_addr(cur, 1, right);
+		lrp = xfs_btree_rec_addr(cur, lrecs, left);
+		rrp = xfs_btree_rec_addr(cur, 1, right);
 
-		cur->bc_ops->copy_recs(cur, rrp, lrp, 1);
-		cur->bc_ops->log_recs(cur, lbp, lrecs, lrecs);
+		xfs_btree_copy_recs(cur, rrp, lrp, 1);
+		xfs_btree_log_recs(cur, lbp, lrecs, lrecs);
 
 		xfs_btree_check_rec(cur->bc_btnum,
-				    cur->bc_ops->rec_addr(cur, lrecs - 1, left),
+				    xfs_btree_rec_addr(cur, lrecs - 1, left),
 				    lrp);
 	}
 
@@ -1858,16 +2049,16 @@ xfs_btree_lshift(
 		}
 #endif
 
-		cur->bc_ops->move_keys(cur, rkp, 1, 0, rrecs);
+		xfs_btree_move_keys(cur, rkp, 1, 0, rrecs);
 		xfs_btree_move_ptrs(cur, rpp, 1, 0, rrecs);
-		cur->bc_ops->log_keys(cur, rbp, 1, rrecs);
+		xfs_btree_log_keys(cur, rbp, 1, rrecs);
 		xfs_btree_log_ptrs(cur, rbp, 1, rrecs);
 	} else {
 		/* It's a leaf. operate on records */
 
-		rrp = cur->bc_ops->rec_addr(cur, 1, right);
-		cur->bc_ops->move_recs(cur, rrp, 1, 0, rrecs);
-		cur->bc_ops->log_recs(cur, rbp, 1, rrecs);
+		rrp = xfs_btree_rec_addr(cur, 1, right);
+		xfs_btree_move_recs(cur, rrp, 1, 0, rrecs);
+		xfs_btree_log_recs(cur, rbp, 1, rrecs);
 
 		/*
 		 * If it's the first record in the block, we'll need a key
@@ -1974,10 +2165,10 @@ xfs_btree_rshift(
 		union xfs_btree_ptr	*lpp;
 		union xfs_btree_ptr	*rpp;
 
-		lkp = cur->bc_ops->key_addr(cur, lrecs, left);
-		lpp = cur->bc_ops->ptr_addr(cur, lrecs, left);
-		rkp = cur->bc_ops->key_addr(cur, 1, right);
-		rpp = cur->bc_ops->ptr_addr(cur, 1, right);
+		lkp = xfs_btree_key_addr(cur, lrecs, left);
+		lpp = xfs_btree_ptr_addr(cur, lrecs, left);
+		rkp = xfs_btree_key_addr(cur, 1, right);
+		rpp = xfs_btree_ptr_addr(cur, 1, right);
 
 #ifdef DEBUG
 		for (i = rrecs - 1; i >= 0; i--) {
@@ -1987,7 +2178,7 @@ xfs_btree_rshift(
 		}
 #endif
 
-		cur->bc_ops->move_keys(cur, rkp, 0, 1, rrecs);
+		xfs_btree_move_keys(cur, rkp, 0, 1, rrecs);
 		xfs_btree_move_ptrs(cur, rpp, 0, 1, rrecs);
 
 #ifdef DEBUG
@@ -1997,33 +2188,33 @@ xfs_btree_rshift(
 #endif
 
 		/* Now put the new data in, and log it. */
-		cur->bc_ops->set_key(cur, rkp, 0, lkp);
+		xfs_btree_set_key(cur, rkp, 0, lkp);
 		xfs_btree_set_ptr(cur, rpp, 0, lpp);
 
-		cur->bc_ops->log_keys(cur, rbp, 1, rrecs + 1);
+		xfs_btree_log_keys(cur, rbp, 1, rrecs + 1);
 		xfs_btree_log_ptrs(cur, rbp, 1, rrecs + 1);
 
 		xfs_btree_check_key(cur->bc_btnum, rkp,
-				    cur->bc_ops->key_addr(cur, 2, right));
+				    xfs_btree_key_addr(cur, 2, right));
 	} else {
 		/* It's a leaf. make a hole in the records */
 		union xfs_btree_rec	*lrp;
 		union xfs_btree_rec	*rrp;
 
-		lrp = cur->bc_ops->rec_addr(cur, lrecs, left);
-		rrp = cur->bc_ops->rec_addr(cur, 1, right);
+		lrp = xfs_btree_rec_addr(cur, lrecs, left);
+		rrp = xfs_btree_rec_addr(cur, 1, right);
 
-		cur->bc_ops->move_recs(cur, rrp, 0, 1, rrecs);
+		xfs_btree_move_recs(cur, rrp, 0, 1, rrecs);
 
 		/* Now put the new data in, and log it. */
-		cur->bc_ops->set_rec(cur, rrp, 0, lrp);
-		cur->bc_ops->log_recs(cur, rbp, 1, rrecs + 1);
+		xfs_btree_set_rec(cur, rrp, 0, lrp);
+		xfs_btree_log_recs(cur, rbp, 1, rrecs + 1);
 
 		cur->bc_ops->init_key_from_rec(cur, &key, rrp);
 		rkp = &key;
 
 		xfs_btree_check_rec(cur->bc_btnum, rrp,
-				    cur->bc_ops->rec_addr(cur, 2, right));
+				    xfs_btree_rec_addr(cur, 2, right));
 	}
 
 	/*
@@ -2162,10 +2353,10 @@ xfs_btree_split(
 		union xfs_btree_key	*rkp;	/* right btree key */
 		union xfs_btree_ptr	*rpp;	/* right address pointer */
 
-		lkp = cur->bc_ops->key_addr(cur, src_index, left);
-		lpp = cur->bc_ops->ptr_addr(cur, src_index, left);
-		rkp = cur->bc_ops->key_addr(cur, 1, right);
-		rpp = cur->bc_ops->ptr_addr(cur, 1, right);
+		lkp = xfs_btree_key_addr(cur, src_index, left);
+		lpp = xfs_btree_ptr_addr(cur, src_index, left);
+		rkp = xfs_btree_key_addr(cur, 1, right);
+		rpp = xfs_btree_ptr_addr(cur, 1, right);
 
 #ifdef DEBUG
 		for (i = src_index; i < rrecs; i++) {
@@ -2175,27 +2366,27 @@ xfs_btree_split(
 		}
 #endif
 
-		cur->bc_ops->copy_keys(cur, lkp, rkp, rrecs);
+		xfs_btree_copy_keys(cur, lkp, rkp, rrecs);
 		xfs_btree_copy_ptrs(cur, lpp, rpp, rrecs);
 
-		cur->bc_ops->log_keys(cur, rbp, 1, rrecs);
+		xfs_btree_log_keys(cur, rbp, 1, rrecs);
 		xfs_btree_log_ptrs(cur, rbp, 1, rrecs);
 
 		/* Grab the keys to the entries moved to the right block */
-		cur->bc_ops->copy_keys(cur, rkp, key, 1);
+		xfs_btree_copy_keys(cur, rkp, key, 1);
 	} else {
 		/* It's a leaf.  Move records.  */
 		union xfs_btree_rec	*lrp;	/* left record pointer */
 		union xfs_btree_rec	*rrp;	/* right record pointer */
 
-		lrp = cur->bc_ops->rec_addr(cur, src_index, left);
-		rrp = cur->bc_ops->rec_addr(cur, 1, right);
+		lrp = xfs_btree_rec_addr(cur, src_index, left);
+		rrp = xfs_btree_rec_addr(cur, 1, right);
 
-		cur->bc_ops->copy_recs(cur, lrp, rrp, rrecs);
-		cur->bc_ops->log_recs(cur, rbp, 1, rrecs);
+		xfs_btree_copy_recs(cur, lrp, rrp, rrecs);
+		xfs_btree_log_recs(cur, rbp, 1, rrecs);
 
 		cur->bc_ops->init_key_from_rec(cur, key,
-			cur->bc_ops->rec_addr(cur, 1, right));
+			xfs_btree_rec_addr(cur, 1, right));
 	}
 
 
@@ -2291,7 +2482,7 @@ xfs_btree_iroot_to_root(
 	level = cur->bc_nlevels - 1;
 	/* XXX(hch): this should be an get_inode_from_root, right? */
 	block = xfs_btree_get_block(cur, level, &bp);
-	pp = cur->bc_ops->ptr_addr(cur, 1, block);
+	pp = xfs_btree_ptr_addr(cur, 1, block);
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
 	error = cur->bc_ops->alloc_block(cur, pp, &nptr, 1, stat);
@@ -2318,11 +2509,11 @@ xfs_btree_iroot_to_root(
 	cur->bc_nlevels++;
 	cur->bc_ptrs[level + 1] = 1;
 
-	kp = cur->bc_ops->key_addr(cur, 1, block);
-	ckp = cur->bc_ops->key_addr(cur, 1, cblock);
-	cur->bc_ops->copy_keys(cur, kp, ckp, xfs_btree_get_numrecs(cblock));
+	kp = xfs_btree_key_addr(cur, 1, block);
+	ckp = xfs_btree_key_addr(cur, 1, cblock);
+	xfs_btree_copy_keys(cur, kp, ckp, xfs_btree_get_numrecs(cblock));
 
-	cpp = cur->bc_ops->ptr_addr(cur, 1, cblock);
+	cpp = xfs_btree_ptr_addr(cur, 1, cblock);
 #ifdef DEBUG
 	for (i = 0; i < be16_to_cpu(cblock->bb_numrecs); i++) {
 		error = xfs_btree_check_ptr(cur, pp, i, level);
@@ -2347,7 +2538,7 @@ xfs_btree_iroot_to_root(
 	 * the root is at the right level.
 	 */
 	xfs_btree_log_block(cur, cbp, XFS_BB_ALL_BITS);
-	cur->bc_ops->log_keys(cur, cbp, 1, be16_to_cpu(cblock->bb_numrecs));
+	xfs_btree_log_keys(cur, cbp, 1, be16_to_cpu(cblock->bb_numrecs));
 	xfs_btree_log_ptrs(cur, cbp, 1, be16_to_cpu(cblock->bb_numrecs));
 
 	*logflags |=
@@ -2451,23 +2642,23 @@ xfs_btree_new_root(
 			!xfs_btree_ptr_is_null(cur, &rptr));
 
 	/* Fill in the key data in the new root. */
-	kp = cur->bc_ops->key_addr(cur, 1, new);
+	kp = xfs_btree_key_addr(cur, 1, new);
 	if (xfs_btree_get_level(left) > 0) {
-		cur->bc_ops->set_key(cur, kp, 0,
-				cur->bc_ops->key_addr(cur, 1, left));
-		cur->bc_ops->set_key(cur, kp, 1,
-				cur->bc_ops->key_addr(cur, 1, right));
+		xfs_btree_set_key(cur, kp, 0,
+				xfs_btree_key_addr(cur, 1, left));
+		xfs_btree_set_key(cur, kp, 1,
+				xfs_btree_key_addr(cur, 1, right));
 	} else {
 		cur->bc_ops->init_key_from_rec(cur, kp,
-				cur->bc_ops->rec_addr(cur, 1, left));
-		kp = cur->bc_ops->key_addr(cur, 2, new);
+				xfs_btree_rec_addr(cur, 1, left));
+		kp = xfs_btree_key_addr(cur, 2, new);
 		cur->bc_ops->init_key_from_rec(cur,
-				kp, cur->bc_ops->rec_addr(cur, 1, right));
+				kp, xfs_btree_rec_addr(cur, 1, right));
 	}
-	cur->bc_ops->log_keys(cur, nbp, 1, 2);
+	xfs_btree_log_keys(cur, nbp, 1, 2);
 
 	/* Fill in the pointer data in the new root. */
-	pp = cur->bc_ops->ptr_addr(cur, 1, new);
+	pp = xfs_btree_ptr_addr(cur, 1, new);
 	xfs_btree_set_ptr(cur, pp, 0, &lptr);
 	xfs_btree_set_ptr(cur, pp, 1, &rptr);
 	xfs_btree_log_ptrs(cur, nbp, 1, 2);
@@ -2627,10 +2818,10 @@ xfs_btree_insrec(
 	if (ptr <= numrecs) {
 		if (level == 0) {
 			xfs_btree_check_rec(cur->bc_btnum, recp,
-					cur->bc_ops->rec_addr(cur, ptr, block));
+					xfs_btree_rec_addr(cur, ptr, block));
 		} else {
 			xfs_btree_check_key(cur->bc_btnum, &key,
-					cur->bc_ops->key_addr(cur, ptr, block));
+					xfs_btree_key_addr(cur, ptr, block));
 		}
 	}
 #endif
@@ -2668,8 +2859,8 @@ xfs_btree_insrec(
 		union xfs_btree_key	*kp;
 		union xfs_btree_ptr	*pp;
 
-		kp = cur->bc_ops->key_addr(cur, 1, block);
-		pp = cur->bc_ops->ptr_addr(cur, 1, block);
+		kp = xfs_btree_key_addr(cur, 1, block);
+		pp = xfs_btree_ptr_addr(cur, 1, block);
 
 #ifdef DEBUG
 		for (i = ptr; i < numrecs; i++) {
@@ -2679,7 +2870,7 @@ xfs_btree_insrec(
 		}
 #endif
 
-		cur->bc_ops->move_keys(cur, kp, ptr - 1, ptr,
+		xfs_btree_move_keys(cur, kp, ptr - 1, ptr,
 					numrecs - ptr + 1);
 		xfs_btree_move_ptrs(cur, pp, ptr - 1, ptr,
 					numrecs - ptr + 1);
@@ -2691,37 +2882,37 @@ xfs_btree_insrec(
 #endif
 
 		/* Now put the new data in, bump numrecs and log it. */
-		cur->bc_ops->set_key(cur, kp, ptr - 1, &key);
+		xfs_btree_set_key(cur, kp, ptr - 1, &key);
 		xfs_btree_set_ptr(cur, pp, ptr - 1, ptrp);
 		numrecs++;
 		xfs_btree_set_numrecs(block, numrecs);
 		xfs_btree_log_ptrs(cur, bp, ptr, numrecs);
-		cur->bc_ops->log_keys(cur, bp, ptr, numrecs);
+		xfs_btree_log_keys(cur, bp, ptr, numrecs);
 #ifdef DEBUG
 		if (ptr < numrecs) {
 			xfs_btree_check_key(cur->bc_btnum,
-				cur->bc_ops->key_addr(cur, ptr, block),
-				cur->bc_ops->key_addr(cur, ptr + 1, block));
+				xfs_btree_key_addr(cur, ptr, block),
+				xfs_btree_key_addr(cur, ptr + 1, block));
 		}
 #endif
 	} else {
 		/* It's a leaf. make a hole in the records */
 		union xfs_btree_rec		*rp;
 
-		rp = cur->bc_ops->rec_addr(cur, 1, block);
-		cur->bc_ops->move_recs(cur, rp, ptr - 1, ptr,
+		rp = xfs_btree_rec_addr(cur, 1, block);
+		xfs_btree_move_recs(cur, rp, ptr - 1, ptr,
 				       numrecs - ptr + 1);
 
 		/* Now put the new data in, bump numrecs and log it. */
-		cur->bc_ops->set_rec(cur, rp, ptr - 1, recp);
+		xfs_btree_set_rec(cur, rp, ptr - 1, recp);
 		numrecs++;
 		xfs_btree_set_numrecs(block, numrecs);
-		cur->bc_ops->log_recs(cur, bp, ptr, numrecs);
+		xfs_btree_log_recs(cur, bp, ptr, numrecs);
 #ifdef DEBUG
 		if (ptr < numrecs) {
 			xfs_btree_check_rec(cur->bc_btnum,
-				cur->bc_ops->rec_addr(cur, ptr, block),
-				cur->bc_ops->rec_addr(cur, ptr + 1, block));
+				xfs_btree_rec_addr(cur, ptr, block),
+				xfs_btree_rec_addr(cur, ptr + 1, block));
 		}
 #endif
 	}
@@ -2913,12 +3104,12 @@ xfs_btree_root_to_iroot(
 	be16_add(&block->bb_numrecs, index);
 	ASSERT(block->bb_numrecs == numrecs);
 
-	kp = cur->bc_ops->key_addr(cur, 1, block);
-	ckp = cur->bc_ops->key_addr(cur, 1, cblock);
-	cur->bc_ops->copy_keys(cur, ckp, kp, numrecs);
+	kp = xfs_btree_key_addr(cur, 1, block);
+	ckp = xfs_btree_key_addr(cur, 1, cblock);
+	xfs_btree_copy_keys(cur, ckp, kp, numrecs);
 
-	pp = cur->bc_ops->ptr_addr(cur, 1, block);
-	cpp = cur->bc_ops->ptr_addr(cur, 1, cblock);
+	pp = xfs_btree_ptr_addr(cur, 1, block);
+	cpp = xfs_btree_ptr_addr(cur, 1, cblock);
 #ifdef DEBUG
 	for (i = 0; i < numrecs; i++) {
 		int		error;
@@ -3088,8 +3279,8 @@ xfs_btree_delrec(
 		union xfs_btree_key	*lkp;	/* pointer to bmap btree key */
 		union xfs_btree_ptr	*lpp;	/* pointer to bmap block addr */
 
-		lkp = cur->bc_ops->key_addr(cur, 1, block);
-		lpp = cur->bc_ops->ptr_addr(cur, 1, block);
+		lkp = xfs_btree_key_addr(cur, 1, block);
+		lpp = xfs_btree_ptr_addr(cur, 1, block);
 
 #ifdef DEBUG
 		for (i = ptr; i < numrecs; i++) {
@@ -3100,22 +3291,22 @@ xfs_btree_delrec(
 #endif
 
 		if (ptr < numrecs) {
-			cur->bc_ops->move_keys(cur, lkp, ptr, ptr - 1,
+			xfs_btree_move_keys(cur, lkp, ptr, ptr - 1,
 						numrecs - ptr);
 			xfs_btree_move_ptrs(cur, lpp, ptr, ptr - 1,
 						numrecs - ptr);
-			cur->bc_ops->log_keys(cur, bp, ptr, numrecs - 1);
+			xfs_btree_log_keys(cur, bp, ptr, numrecs - 1);
 			xfs_btree_log_ptrs(cur, bp, ptr, numrecs - 1);
 		}
 	} else {
 		/* It's a leaf. operate on records */
 		union xfs_btree_rec	*lrp;	/* pointer to bmap btree rec */
 
-		lrp = cur->bc_ops->rec_addr(cur, 1, block);
+		lrp = xfs_btree_rec_addr(cur, 1, block);
 		if (ptr < numrecs) {
-			cur->bc_ops->move_recs(cur, lrp, ptr, ptr - 1,
+			xfs_btree_move_recs(cur, lrp, ptr, ptr - 1,
 						numrecs - ptr);
-			cur->bc_ops->log_recs(cur, bp, ptr, numrecs - 1);
+			xfs_btree_log_recs(cur, bp, ptr, numrecs - 1);
 		}
 
 		/*
@@ -3172,7 +3363,7 @@ xfs_btree_delrec(
 			 * pp is still set to the first pointer in the block.
 			 * Make it the new root of the btree.
 			 */
-			pp = cur->bc_ops->ptr_addr(cur, 1, block);
+			pp = xfs_btree_ptr_addr(cur, 1, block);
 			error = xfs_btree_update_root(cur, bp, level, pp);
 			if (error)
 				goto error0;
@@ -3438,10 +3629,10 @@ xfs_btree_delrec(
 		union xfs_btree_key	*rkp;	/* right btree key */
 		union xfs_btree_ptr	*rpp;	/* right address pointer */
 
-		lkp = cur->bc_ops->key_addr(cur, lrecs + 1, left);
-		lpp = cur->bc_ops->ptr_addr(cur, lrecs + 1, left);
-		rkp = cur->bc_ops->key_addr(cur, 1, right);
-		rpp = cur->bc_ops->ptr_addr(cur, 1, right);
+		lkp = xfs_btree_key_addr(cur, lrecs + 1, left);
+		lpp = xfs_btree_ptr_addr(cur, lrecs + 1, left);
+		rkp = xfs_btree_key_addr(cur, 1, right);
+		rpp = xfs_btree_ptr_addr(cur, 1, right);
 #ifdef DEBUG
 		for (i = 1; i < rrecs; i++) {
 			error = xfs_btree_check_ptr(cur, rpp, i, level);
@@ -3449,21 +3640,21 @@ xfs_btree_delrec(
 				goto error0;
 		}
 #endif
-		cur->bc_ops->copy_keys(cur, rkp, lkp, rrecs);
+		xfs_btree_copy_keys(cur, rkp, lkp, rrecs);
 		xfs_btree_copy_ptrs(cur, rpp, lpp, rrecs);
 
-		cur->bc_ops->log_keys(cur, lbp, lrecs + 1, lrecs + rrecs);
+		xfs_btree_log_keys(cur, lbp, lrecs + 1, lrecs + rrecs);
 		xfs_btree_log_ptrs(cur, lbp, lrecs + 1, lrecs + rrecs);
 	} else {
 		/* It's a leaf.  Move records.  */
 		union xfs_btree_rec	*lrp;	/* left record pointer */
 		union xfs_btree_rec	*rrp;	/* right record pointer */
 
-		lrp = cur->bc_ops->rec_addr(cur, lrecs + 1, left);
-		rrp = cur->bc_ops->rec_addr(cur, 1, right);
+		lrp = xfs_btree_rec_addr(cur, lrecs + 1, left);
+		rrp = xfs_btree_rec_addr(cur, 1, right);
 
-		cur->bc_ops->copy_recs(cur, rrp, lrp, rrecs);
-		cur->bc_ops->log_recs(cur, lbp, lrecs + 1, lrecs + rrecs);
+		xfs_btree_copy_recs(cur, rrp, lrp, rrecs);
+		xfs_btree_log_recs(cur, lbp, lrecs + 1, lrecs + rrecs);
 	}
 
 	XFS_BTREE_STATS_INC(cur, join);
@@ -3616,7 +3807,7 @@ xfs_btree_getrec(
 	/*
 	 * Point to the record and extract its data.
 	 */
-	*recp = cur->bc_ops->rec_addr(cur, ptr, block);
+	*recp = xfs_btree_rec_addr(cur, ptr, block);
 	*stat = 1;
 	return 0;
 }
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-08-04 01:48:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-08-04 01:49:13.000000000 +0200
@@ -180,6 +180,10 @@ do {    \
 #define	XFS_BTREE_MAXLEVELS	8	/* max of all btrees */
 
 struct xfs_btree_ops {
+	/* size of the key and record structures */
+	size_t	key_len;
+	size_t	rec_len;
+
 	/* cursor operations */
 	struct xfs_btree_cur *(*dup_cursor)(struct xfs_btree_cur *);
 	void	(*update_cursor)(struct xfs_btree_cur *src,
@@ -207,14 +211,6 @@ struct xfs_btree_ops {
 				  union xfs_btree_rec *rec,
 				  int ptr, int reason);
 
-	/* return address of btree structures */
-	union xfs_btree_ptr *(*ptr_addr)(struct xfs_btree_cur *cur, int index,
-					 struct xfs_btree_block *block);
-	union xfs_btree_key *(*key_addr)(struct xfs_btree_cur *cur, int index,
-					 struct xfs_btree_block *block);
-	union xfs_btree_rec *(*rec_addr)(struct xfs_btree_cur *cur, int index,
-					 struct xfs_btree_block *block);
-
 	/* records in block/level */
 	int	(*get_minrecs)(struct xfs_btree_cur *cur, int level);
 	int	(*get_maxrecs)(struct xfs_btree_cur *cur, int level);
@@ -235,36 +231,6 @@ struct xfs_btree_ops {
 	__int64_t (*key_diff)(struct xfs_btree_cur *cur,
 			      union xfs_btree_key *key);
 
-	/* set values of btree structures */
-	void	(*set_key)(struct xfs_btree_cur *cur,
-			   union xfs_btree_key *oldkey, int index,
-			   union xfs_btree_key *newkey);
-	void	(*set_rec)(struct xfs_btree_cur *cur,
-			   union xfs_btree_rec *oldrec, int index,
-			   union xfs_btree_rec *newrec);
-
-	/* move bits of btree blocks within a block */
-	void	(*move_keys)(struct xfs_btree_cur *cur,
-			     union xfs_btree_key *base, int src_index,
-			     int dst_index, int numkeys);
-	void	(*move_recs)(struct xfs_btree_cur *cur,
-			     union xfs_btree_rec *base, int src_index,
-			     int dst_index, int numrecs);
-
-	/* copy bits of btree blocks between blocks */
-	void	(*copy_keys)(struct xfs_btree_cur *cur,
-			     union xfs_btree_key *src_key,
-			     union xfs_btree_key *dst_key, int numkeys);
-	void	(*copy_recs)(struct xfs_btree_cur *cur,
-			     union xfs_btree_rec *src_rec,
-			     union xfs_btree_rec *dst_rec, int numkeys);
-
-	/* log changes to btree structures */
-	void	(*log_keys)(struct xfs_btree_cur *cur, struct xfs_buf *bp,
-			    int first, int last);
-	void	(*log_recs)(struct xfs_btree_cur *cur, struct xfs_buf *bp,
-			    int first, int last);
-
 	/* btree tracing */
 #ifdef XFS_BTREE_TRACE
 	void		(*trace_enter)(struct xfs_btree_cur *, const char *,
@@ -609,6 +575,7 @@ int xfs_btree_getrec(struct xfs_btree_cu
  * Internal btree helpers also used by xfs_bmap.c.
  */
 void xfs_btree_log_block(struct xfs_btree_cur *, struct xfs_buf *, int);
+void xfs_btree_log_recs(struct xfs_btree_cur *, struct xfs_buf *, int, int);
 
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-08-04 01:48:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-08-04 01:49:13.000000000 +0200
@@ -171,33 +171,6 @@ xfs_inobt_init_rec_from_cur(
 	rec->inobt.ir_free = cpu_to_be64(cur->bc_rec.i.ir_free);
 }
 
-STATIC union xfs_btree_ptr *
-xfs_inobt_ptr_addr(
-	struct xfs_btree_cur	*cur,
-	int			index,
-	struct xfs_btree_block	*block)
-{
-	return (union xfs_btree_ptr *)XFS_INOBT_PTR_ADDR(block, index, cur);
-}
-
-STATIC union xfs_btree_key *
-xfs_inobt_key_addr(
-	struct xfs_btree_cur	*cur,
-	int			index,
-	struct xfs_btree_block	*block)
-{
-	return (union xfs_btree_key *)XFS_INOBT_KEY_ADDR(block, index, cur);
-}
-
-STATIC union xfs_btree_rec *
-xfs_inobt_rec_addr(
-	struct xfs_btree_cur	*cur,
-	int			index,
-	struct xfs_btree_block	*block)
-{
-	return (union xfs_btree_rec *)XFS_INOBT_REC_ADDR(block, index, cur);
-}
-
 STATIC __int64_t
 xfs_inobt_key_diff(
 	struct xfs_btree_cur	*cur,
@@ -207,138 +180,6 @@ xfs_inobt_key_diff(
 			  cur->bc_rec.i.ir_startino;
 }
 
-STATIC void
-xfs_inobt_set_key(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*key_addr,
-	int			index,
-	union xfs_btree_key	*newkey)
-{
-	xfs_inobt_key_t		*kp = &key_addr->inobt;
-
-	kp[index] = newkey->inobt;
-}
-
-STATIC void
-xfs_inobt_set_rec(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*rec_addr,
-	int			index,
-	union xfs_btree_rec	*newrec)
-{
-	xfs_inobt_rec_t		*rp = &rec_addr->inobt;
-
-	rp[index] = newrec->inobt;
-}
-
-STATIC void
-xfs_inobt_move_keys(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*base,
-	int			from,
-	int			to,
-	int			numkeys)
-{
-	xfs_inobt_key_t		*kp = &base->inobt;
-
-	ASSERT(from >= 0);
-	ASSERT(to >= 0);
-	ASSERT(numkeys >= 0);
-
-	memmove(&kp[to], &kp[from], numkeys * sizeof(*kp));
-}
-
-STATIC void
-xfs_inobt_move_recs(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*base,
-	int			from,
-	int			to,
-	int			numrecs)
-{
-	xfs_inobt_rec_t		*rp = &base->inobt;
-
-	ASSERT(from >= 0);
-	ASSERT(to >= 0);
-	ASSERT(numrecs >= 0);
-
-	memmove(&rp[to], &rp[from], numrecs * sizeof(*rp));
-}
-
-STATIC void
-xfs_inobt_copy_keys(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*src_key,
-	union xfs_btree_key	*dst_key,
-	int                     numkeys)
-{
-	ASSERT(numkeys >= 0);
-	memcpy(dst_key, src_key, numkeys * sizeof(xfs_inobt_key_t));
-}
-
-STATIC void
-xfs_inobt_copy_recs(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*src_rec,
-	union xfs_btree_rec	*dst_rec,
-	int			numrecs)
-{
-	ASSERT(numrecs >= 0);
-	memcpy(dst_rec, src_rec, numrecs * sizeof(xfs_inobt_rec_t));
-}
-
-/*
- * Log keys from a btree block (nonleaf).
- */
-STATIC void
-xfs_inobt_log_keys(
-	struct xfs_btree_cur	*cur,	/* btree cursor */
-	struct xfs_buf		*bp,	/* buffer containing btree block */
-	int			first,	/* index of first key to log */
-	int			last)	/* index of last key to log */
-{
-	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
-	xfs_inobt_key_t		*kp = XFS_INOBT_KEY_ADDR(block, 1, cur);
-	char			*baddr = (char *)block;
-	int			start;	/* first byte offset logged */
-	int			end;	/* last byte offset logged */
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
-
-	start = (char *)&kp[first - 1] - baddr;
-	end = (char *)&kp[last] - 1 - baddr;
-	xfs_trans_log_buf(cur->bc_tp, bp, start, end);
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
-}
-
-/*
- * Log records from a btree block (leaf).
- */
-STATIC void
-xfs_inobt_log_recs(
-	struct xfs_btree_cur	*cur,	/* btree cursor */
-	struct xfs_buf		*bp,	/* buffer containing btree block */
-	int			first,	/* index of first record to log */
-	int			last)	/* index of last record to log */
-{
-	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
-	xfs_inobt_rec_t		*rp = XFS_INOBT_REC_ADDR(block, 1, cur);
-	char			*baddr = (char *)block;
-	int			start;	/* first byte offset logged */
-	int			end;	/* last byte offset logged */
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
-
-	start = (char *)&rp[first - 1] - baddr;
-	end = (char *)&rp[last] - 1 - baddr;
-	xfs_trans_log_buf(cur->bc_tp, bp, start, end);
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
-}
-
 STATIC int
 xfs_inobt_get_minrecs(
 	struct xfs_btree_cur	*cur,
@@ -415,6 +256,9 @@ xfs_inobt_trace_record(
 #endif /* XFS_BTREE_TRACE */
 
 static const struct xfs_btree_ops xfs_inobt_ops = {
+	.key_len		= sizeof(xfs_inobt_key_t),
+	.rec_len		= sizeof(xfs_inobt_rec_t),
+
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_inobt_set_root,
 	.alloc_block		= xfs_inobt_alloc_block,
@@ -425,19 +269,7 @@ static const struct xfs_btree_ops xfs_in
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
 	.init_rec_from_key	= xfs_inobt_init_rec_from_key,
 	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
-	.ptr_addr		= xfs_inobt_ptr_addr,
-	.key_addr		= xfs_inobt_key_addr,
-	.rec_addr		= xfs_inobt_rec_addr,
 	.key_diff		= xfs_inobt_key_diff,
-	.set_key		= xfs_inobt_set_key,
-	.set_rec		= xfs_inobt_set_rec,
-	.move_keys		= xfs_inobt_move_keys,
-	.move_recs		= xfs_inobt_move_recs,
-
-	.copy_keys		= xfs_inobt_copy_keys,
-	.copy_recs		= xfs_inobt_copy_recs,
-	.log_keys		= xfs_inobt_log_keys,
-	.log_recs		= xfs_inobt_log_recs,
 
 #ifdef XFS_BTREE_TRACE
 	.trace_enter		= xfs_inobt_trace_enter,
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-08-04 01:48:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-08-04 01:49:13.000000000 +0200
@@ -3564,7 +3564,7 @@ xfs_bmap_extents_to_btree(
 	 * the root is at the right level.
 	 */
 	xfs_btree_log_block(cur, abp, XFS_BB_ALL_BITS);
-	xfs_bmbt_log_recs(cur, abp, 1, be16_to_cpu(ablock->bb_numrecs));
+	xfs_btree_log_recs(cur, abp, 1, be16_to_cpu(ablock->bb_numrecs));
 	ASSERT(*curp == NULL);
 	*curp = cur;
 	*logflagsp = XFS_ILOG_CORE | XFS_ILOG_FBROOT(whichfork);

-- 
