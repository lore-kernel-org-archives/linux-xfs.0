Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 13:09:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NK8g8O016837
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:08:43 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 57EE931C28D
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:09:51 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 4wPR1EgLyG2uqGyb for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 13:09:51 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6NK9fNg007633
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 22:09:41 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6NK9eki007631
	for xfs@oss.sgi.com; Wed, 23 Jul 2008 22:09:40 +0200
Date: Wed, 23 Jul 2008 22:09:40 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/15] implement generic xfs_btree_updkey
Message-ID: <20080723200940.GO7401@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-common-btree-updkey
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

From: Dave Chinner <dgc@sgi.com>

Note that there are many > 80 char lines introduced due to the
xfs_btree_key casts.  But the places where this happens is throw-away
code once the whole btree code gets merged into a common implementation.

The same is true for the temporary xfs_alloc_log_keys define to the new
name.  All old users will be gone after a few patches.


[hch: split out from bigger patch and minor adaptions]

Signed-off-by: Christoph Hellwig <hch@lst.de>


Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-07-21 04:42:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-07-21 05:10:43.000000000 +0200
@@ -1370,3 +1370,50 @@ error0:
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
 	return error;
 }
+
+/*
+ * Update keys at all levels from here to the root along the cursor's path.
+ */
+int
+xfs_btree_updkey(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*keyp,
+	int			level)
+{
+	struct xfs_btree_block	*block;
+	struct xfs_buf		*bp;
+	union xfs_btree_key	*kp;
+	int			ptr;
+#ifdef DEBUG
+	int			error;
+#endif
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGIK(cur, level, keyp);
+
+	ASSERT(!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) || level >= 1);
+
+	/*
+	 * Go up the tree from this level toward the root.
+	 * At each level, update the key value to the value input.
+	 * Stop when we reach a level where the cursor isn't pointing
+	 * at the first entry in the block.
+	 */
+	for (ptr = 1; ptr == 1 && level < cur->bc_nlevels; level++) {
+		block = xfs_btree_get_block(cur, level, &bp);
+#ifdef DEBUG
+		error = xfs_btree_check_block(cur, block, level, bp);
+		if (error) {
+			XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+			return error;
+		}
+#endif
+		ptr = cur->bc_ptrs[level];
+		kp = cur->bc_ops->key_addr(cur, ptr, block);
+		cur->bc_ops->copy_keys(cur, keyp, kp, 1);
+		cur->bc_ops->log_keys(cur, bp, ptr, ptr);
+	}
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	return 0;
+}
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-07-21 04:42:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-07-21 05:11:01.000000000 +0200
@@ -210,6 +210,16 @@ struct xfs_btree_ops {
 	__int64_t (*key_diff)(struct xfs_btree_cur *cur,
 			      union xfs_btree_key *key);
 
+	/* copy bits of btree blocks between blocks */
+	void	(*copy_keys)(struct xfs_btree_cur *cur,
+			     union xfs_btree_key *src_key,
+			     union xfs_btree_key *dst_key, int numkeys);
+
+	/* log changes to btree structures */
+	void	(*log_keys)(struct xfs_btree_cur *cur, struct xfs_buf *bp,
+			    int first, int last);
+
+
 	/* btree tracing */
 #ifdef XFS_BTREE_TRACE
 	void		(*trace_enter)(struct xfs_btree_cur *, const char *,
@@ -528,6 +538,7 @@ xfs_btree_setbuf(
 int xfs_btree_increment(struct xfs_btree_cur *, int, int *);
 int xfs_btree_decrement(struct xfs_btree_cur *, int, int *);
 int xfs_btree_lookup(struct xfs_btree_cur *, xfs_lookup_t, int *);
+int xfs_btree_updkey(struct xfs_btree_cur *, union xfs_btree_key *, int);
 
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-07-21 04:42:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-07-21 05:10:35.000000000 +0200
@@ -35,6 +35,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
+#include "xfs_btree_trace.h"
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_error.h"
@@ -44,7 +45,9 @@
  */
 
 STATIC void xfs_alloc_log_block(xfs_trans_t *, xfs_buf_t *, int);
-STATIC void xfs_alloc_log_keys(xfs_btree_cur_t *, xfs_buf_t *, int, int);
+STATIC void xfs_allocbt_log_keys(xfs_btree_cur_t *, xfs_buf_t *, int, int);
+#define xfs_alloc_log_keys(c, b, i, j) \
+	xfs_allocbt_log_keys(c, b, i, j)
 STATIC void xfs_alloc_log_ptrs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
 STATIC void xfs_alloc_log_recs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
 STATIC int xfs_alloc_lshift(xfs_btree_cur_t *, int, int *);
@@ -52,7 +55,6 @@ STATIC int xfs_alloc_newroot(xfs_btree_c
 STATIC int xfs_alloc_rshift(xfs_btree_cur_t *, int, int *);
 STATIC int xfs_alloc_split(xfs_btree_cur_t *, int, xfs_agblock_t *,
 		xfs_alloc_key_t *, xfs_btree_cur_t **, int *);
-STATIC int xfs_alloc_updkey(xfs_btree_cur_t *, xfs_alloc_key_t *, int);
 
 /*
  * Internal functions.
@@ -265,7 +267,7 @@ xfs_alloc_delrec(
 	 * If we deleted the leftmost entry in the block, update the
 	 * key values above us in the tree.
 	 */
-	if (ptr == 1 && (error = xfs_alloc_updkey(cur, lkp, level + 1)))
+	if (ptr == 1 && (error = xfs_btree_updkey(cur, (union xfs_btree_key *)lkp, level + 1)))
 		return error;
 	/*
 	 * If the number of records remaining in the block is at least
@@ -798,7 +800,7 @@ xfs_alloc_insrec(
 	/*
 	 * If we inserted at the start of a block, update the parents' keys.
 	 */
-	if (optr == 1 && (error = xfs_alloc_updkey(cur, &key, level + 1)))
+	if (optr == 1 && (error = xfs_btree_updkey(cur, (union xfs_btree_key *)&key, level + 1)))
 		return error;
 	/*
 	 * Look to see if the longest extent in the allocation group
@@ -859,28 +861,6 @@ xfs_alloc_log_block(
 }
 
 /*
- * Log keys from a btree block (nonleaf).
- */
-STATIC void
-xfs_alloc_log_keys(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			kfirst,	/* index of first key to log */
-	int			klast)	/* index of last key to log */
-{
-	xfs_alloc_block_t	*block;	/* btree block to log from */
-	int			first;	/* first byte offset logged */
-	xfs_alloc_key_t		*kp;	/* key pointer in btree block */
-	int			last;	/* last byte offset logged */
-
-	block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-	kp = XFS_ALLOC_KEY_ADDR(block, 1, cur);
-	first = (int)((xfs_caddr_t)&kp[kfirst - 1] - (xfs_caddr_t)block);
-	last = (int)(((xfs_caddr_t)&kp[klast] - 1) - (xfs_caddr_t)block);
-	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
-}
-
-/*
  * Log block pointer fields from a btree block (nonleaf).
  */
 STATIC void
@@ -1068,7 +1048,7 @@ xfs_alloc_lshift(
 	/*
 	 * Update the parent key values of right.
 	 */
-	if ((error = xfs_alloc_updkey(cur, rkp, level + 1)))
+	if ((error = xfs_btree_updkey(cur, (union xfs_btree_key *)rkp, level + 1)))
 		return error;
 	/*
 	 * Slide the cursor value left one.
@@ -1354,7 +1334,7 @@ xfs_alloc_rshift(
 	i = xfs_btree_lastrec(tcur, level);
 	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 	if ((error = xfs_btree_increment(tcur, level, &i)) ||
-	    (error = xfs_alloc_updkey(tcur, rkp, level + 1)))
+	    (error = xfs_btree_updkey(tcur, (union xfs_btree_key *)rkp, level + 1)))
 		goto error0;
 	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
 	*stat = 1;
@@ -1520,45 +1500,6 @@ xfs_alloc_split(
 }
 
 /*
- * Update keys at all levels from here to the root along the cursor's path.
- */
-STATIC int				/* error */
-xfs_alloc_updkey(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_alloc_key_t		*keyp,	/* new key value to update to */
-	int			level)	/* starting level for update */
-{
-	int			ptr;	/* index of key in block */
-
-	/*
-	 * Go up the tree from this level toward the root.
-	 * At each level, update the key value to the value input.
-	 * Stop when we reach a level where the cursor isn't pointing
-	 * at the first entry in the block.
-	 */
-	for (ptr = 1; ptr == 1 && level < cur->bc_nlevels; level++) {
-		xfs_alloc_block_t	*block;	/* btree block */
-		xfs_buf_t		*bp;	/* buffer for block */
-#ifdef DEBUG
-		int			error;	/* error return value */
-#endif
-		xfs_alloc_key_t		*kp;	/* ptr to btree block keys */
-
-		bp = cur->bc_bufs[level];
-		block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sblock(cur, block, level, bp)))
-			return error;
-#endif
-		ptr = cur->bc_ptrs[level];
-		kp = XFS_ALLOC_KEY_ADDR(block, ptr, cur);
-		*kp = *keyp;
-		xfs_alloc_log_keys(cur, bp, ptr, ptr);
-	}
-	return 0;
-}
-
-/*
  * Externally visible routines.
  */
 
@@ -1765,7 +1706,7 @@ xfs_alloc_update(
 
 		key.ar_startblock = cpu_to_be32(bno);
 		key.ar_blockcount = cpu_to_be32(len);
-		if ((error = xfs_alloc_updkey(cur, &key, 1)))
+		if ((error = xfs_btree_updkey(cur, (union xfs_btree_key *)&key, 1)))
 			return error;
 	}
 	return 0;
@@ -1856,6 +1797,45 @@ xfs_allocbt_key_diff(
 	return (__int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
 }
 
+STATIC void
+xfs_allocbt_copy_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*src_key,
+	union xfs_btree_key	*dst_key,
+	int			numkeys)
+{
+	ASSERT(numkeys >= 0);
+	memcpy(dst_key, src_key, numkeys * sizeof(xfs_alloc_key_t));
+}
+
+/*
+ * Log keys from a btree block (nonleaf).
+ */
+STATIC void
+xfs_allocbt_log_keys(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	struct xfs_buf		*bp,	/* buffer containing btree block */
+	int			kfirst,	/* index of first key to log */
+	int			klast)	/* index of last key to log */
+{
+	struct xfs_btree_sblock	*block;	/* btree block to log from */
+	int			first;	/* first byte offset logged */
+	xfs_alloc_key_t		*kp;	/* key pointer in btree block */
+	int			last;	/* last byte offset logged */
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, kfirst, klast);
+
+	block = XFS_BUF_TO_SBLOCK(bp);
+	kp = XFS_ALLOC_KEY_ADDR(block, 1, cur);
+	first = (int)((xfs_caddr_t)&kp[kfirst - 1] - (xfs_caddr_t)block);
+	last = (int)(((xfs_caddr_t)&kp[klast] - 1) - (xfs_caddr_t)block);
+	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+}
+
+
 #ifdef XFS_BTREE_TRACE
 
 ktrace_t	*xfs_allocbt_trace_buf;
@@ -1931,6 +1911,8 @@ static const struct xfs_btree_ops xfs_al
 	.key_addr		= xfs_allocbt_key_addr,
 	.rec_addr		= xfs_allocbt_rec_addr,
 	.key_diff		= xfs_allocbt_key_diff,
+	.copy_keys		= xfs_allocbt_copy_keys,
+	.log_keys		= xfs_allocbt_log_keys,
 
 #ifdef XFS_BTREE_TRACE
 	.trace_enter		= xfs_allocbt_trace_enter,
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-07-21 04:42:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-07-21 05:16:01.000000000 +0200
@@ -35,6 +35,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
+#include "xfs_btree_trace.h"
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_error.h"
@@ -48,7 +49,6 @@ STATIC int xfs_inobt_newroot(xfs_btree_c
 STATIC int xfs_inobt_rshift(xfs_btree_cur_t *, int, int *);
 STATIC int xfs_inobt_split(xfs_btree_cur_t *, int, xfs_agblock_t *,
 		xfs_inobt_key_t *, xfs_btree_cur_t **, int *);
-STATIC int xfs_inobt_updkey(xfs_btree_cur_t *, xfs_inobt_key_t *, int);
 
 /*
  * Single level of the xfs_inobt_delete record deletion routine.
@@ -214,7 +214,7 @@ xfs_inobt_delrec(
 	 * If we deleted the leftmost entry in the block, update the
 	 * key values above us in the tree.
 	 */
-	if (ptr == 1 && (error = xfs_inobt_updkey(cur, kp, level + 1)))
+	if (ptr == 1 && (error = xfs_btree_updkey(cur, (union xfs_btree_key *)kp, level + 1)))
 		return error;
 	/*
 	 * If the number of records remaining in the block is at least
@@ -723,7 +723,7 @@ xfs_inobt_insrec(
 	/*
 	 * If we inserted at the start of a block, update the parents' keys.
 	 */
-	if (optr == 1 && (error = xfs_inobt_updkey(cur, &key, level + 1)))
+	if (optr == 1 && (error = xfs_btree_updkey(cur, (union xfs_btree_key *)&key, level + 1)))
 		return error;
 	/*
 	 * Return the new block number, if any.
@@ -763,28 +763,6 @@ xfs_inobt_log_block(
 }
 
 /*
- * Log keys from a btree block (nonleaf).
- */
-STATIC void
-xfs_inobt_log_keys(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			kfirst,	/* index of first key to log */
-	int			klast)	/* index of last key to log */
-{
-	xfs_inobt_block_t	*block;	/* btree block to log from */
-	int			first;	/* first byte offset logged */
-	xfs_inobt_key_t		*kp;	/* key pointer in btree block */
-	int			last;	/* last byte offset logged */
-
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-	kp = XFS_INOBT_KEY_ADDR(block, 1, cur);
-	first = (int)((xfs_caddr_t)&kp[kfirst - 1] - (xfs_caddr_t)block);
-	last = (int)(((xfs_caddr_t)&kp[klast] - 1) - (xfs_caddr_t)block);
-	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
-}
-
-/*
  * Log block pointer fields from a btree block (nonleaf).
  */
 STATIC void
@@ -960,7 +938,7 @@ xfs_inobt_lshift(
 	/*
 	 * Update the parent key values of right.
 	 */
-	if ((error = xfs_inobt_updkey(cur, rkp, level + 1)))
+	if ((error = xfs_btree_updkey(cur, (union xfs_btree_key *)rkp, level + 1)))
 		return error;
 	/*
 	 * Slide the cursor value left one.
@@ -1238,7 +1216,7 @@ xfs_inobt_rshift(
 		return error;
 	xfs_btree_lastrec(tcur, level);
 	if ((error = xfs_btree_increment(tcur, level, &i)) ||
-	    (error = xfs_inobt_updkey(tcur, rkp, level + 1))) {
+	    (error = xfs_btree_updkey(tcur, (union xfs_btree_key *)rkp, level + 1))) {
 		xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
 		return error;
 	}
@@ -1407,45 +1385,6 @@ xfs_inobt_split(
 }
 
 /*
- * Update keys at all levels from here to the root along the cursor's path.
- */
-STATIC int				/* error */
-xfs_inobt_updkey(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_inobt_key_t		*keyp,	/* new key value to update to */
-	int			level)	/* starting level for update */
-{
-	int			ptr;	/* index of key in block */
-
-	/*
-	 * Go up the tree from this level toward the root.
-	 * At each level, update the key value to the value input.
-	 * Stop when we reach a level where the cursor isn't pointing
-	 * at the first entry in the block.
-	 */
-	for (ptr = 1; ptr == 1 && level < cur->bc_nlevels; level++) {
-		xfs_buf_t		*bp;	/* buffer for block */
-		xfs_inobt_block_t	*block;	/* btree block */
-#ifdef DEBUG
-		int			error;	/* error return value */
-#endif
-		xfs_inobt_key_t		*kp;	/* ptr to btree block keys */
-
-		bp = cur->bc_bufs[level];
-		block = XFS_BUF_TO_INOBT_BLOCK(bp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sblock(cur, block, level, bp)))
-			return error;
-#endif
-		ptr = cur->bc_ptrs[level];
-		kp = XFS_INOBT_KEY_ADDR(block, ptr, cur);
-		*kp = *keyp;
-		xfs_inobt_log_keys(cur, bp, ptr, ptr);
-	}
-	return 0;
-}
-
-/*
  * Externally visible routines.
  */
 
@@ -1637,7 +1576,7 @@ xfs_inobt_update(
 		xfs_inobt_key_t	key;	/* key containing [ino] */
 
 		key.ir_startino = cpu_to_be32(ino);
-		if ((error = xfs_inobt_updkey(cur, &key, 1)))
+		if ((error = xfs_btree_updkey(cur, (union xfs_btree_key *)&key, 1)))
 			return error;
 	}
 	return 0;
@@ -1714,6 +1653,44 @@ xfs_inobt_key_diff(
 			  cur->bc_rec.i.ir_startino;
 }
 
+STATIC void
+xfs_inobt_copy_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*src_key,
+	union xfs_btree_key	*dst_key,
+	int                     numkeys)
+{
+	ASSERT(numkeys >= 0);
+	memcpy(dst_key, src_key, numkeys * sizeof(xfs_inobt_key_t));
+}
+
+/*
+ * Log keys from a btree block (nonleaf).
+ */
+STATIC void
+xfs_inobt_log_keys(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	struct xfs_buf		*bp,	/* buffer containing btree block */
+	int			kfirst,	/* index of first key to log */
+	int			klast)	/* index of last key to log */
+{
+	struct xfs_btree_sblock	*block;	/* btree block to log from */
+	int			first;	/* first byte offset logged */
+	xfs_inobt_key_t		*kp;	/* key pointer in btree block */
+	int			last;	/* last byte offset logged */
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, kfirst, klast);
+
+	block = XFS_BUF_TO_SBLOCK(bp);
+	kp = XFS_INOBT_KEY_ADDR(block, 1, cur);
+	first = (int)((xfs_caddr_t)&kp[kfirst - 1] - (xfs_caddr_t)block);
+	last = (int)(((xfs_caddr_t)&kp[klast] - 1) - (xfs_caddr_t)block);
+	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+}
+
 #ifdef XFS_BTREE_TRACE
 
 ktrace_t	*xfs_inobt_trace_buf;
@@ -1789,6 +1766,8 @@ static const struct xfs_btree_ops xfs_in
 	.key_addr		= xfs_inobt_key_addr,
 	.rec_addr		= xfs_inobt_rec_addr,
 	.key_diff		= xfs_inobt_key_diff,
+	.copy_keys		= xfs_inobt_copy_keys,
+	.log_keys		= xfs_inobt_log_keys,
 
 #ifdef XFS_BTREE_TRACE
 	.trace_enter		= xfs_inobt_trace_enter,
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-07-21 04:42:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-07-21 05:15:11.000000000 +0200
@@ -56,7 +56,6 @@ STATIC int xfs_bmbt_lshift(xfs_btree_cur
 STATIC int xfs_bmbt_rshift(xfs_btree_cur_t *, int, int *);
 STATIC int xfs_bmbt_split(xfs_btree_cur_t *, int, xfs_fsblock_t *,
 		__uint64_t *, xfs_btree_cur_t **, int *);
-STATIC int xfs_bmbt_updkey(xfs_btree_cur_t *, xfs_bmbt_key_t *, int);
 
 #undef EXIT
 
@@ -210,7 +209,7 @@ xfs_bmbt_delrec(
 		*stat = 1;
 		return 0;
 	}
-	if (ptr == 1 && (error = xfs_bmbt_updkey(cur, kp, level + 1))) {
+	if (ptr == 1 && (error = xfs_btree_updkey(cur, (union xfs_btree_key *)kp, level + 1))) {
 		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 		goto error0;
 	}
@@ -634,7 +633,7 @@ xfs_bmbt_insrec(
 				kp + ptr);
 	}
 #endif
-	if (optr == 1 && (error = xfs_bmbt_updkey(cur, &key, level + 1))) {
+	if (optr == 1 && (error = xfs_btree_updkey(cur, (union xfs_btree_key *)&key, level + 1))) {
 		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 		return error;
 	}
@@ -740,42 +739,6 @@ xfs_bmbt_killroot(
 }
 
 /*
- * Log key values from the btree block.
- */
-STATIC void
-xfs_bmbt_log_keys(
-	xfs_btree_cur_t	*cur,
-	xfs_buf_t	*bp,
-	int		kfirst,
-	int		klast)
-{
-	xfs_trans_t	*tp;
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGBII(cur, bp, kfirst, klast);
-	tp = cur->bc_tp;
-	if (bp) {
-		xfs_bmbt_block_t	*block;
-		int			first;
-		xfs_bmbt_key_t		*kp;
-		int			last;
-
-		block = XFS_BUF_TO_BMBT_BLOCK(bp);
-		kp = XFS_BMAP_KEY_DADDR(block, 1, cur);
-		first = (int)((xfs_caddr_t)&kp[kfirst - 1] - (xfs_caddr_t)block);
-		last = (int)(((xfs_caddr_t)&kp[klast] - 1) - (xfs_caddr_t)block);
-		xfs_trans_log_buf(tp, bp, first, last);
-	} else {
-		xfs_inode_t		 *ip;
-
-		ip = cur->bc_private.b.ip;
-		xfs_trans_log_inode(tp, ip,
-			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
-	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-}
-
-/*
  * Log pointer values from the btree block.
  */
 STATIC void
@@ -934,7 +897,7 @@ xfs_bmbt_lshift(
 		key.br_startoff = cpu_to_be64(xfs_bmbt_disk_get_startoff(rrp));
 		rkp = &key;
 	}
-	if ((error = xfs_bmbt_updkey(cur, rkp, level + 1))) {
+	if ((error = xfs_btree_updkey(cur, (union xfs_btree_key *)rkp, level + 1))) {
 		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 		return error;
 	}
@@ -1066,7 +1029,7 @@ xfs_bmbt_rshift(
 		goto error1;
 	}
 	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-	if ((error = xfs_bmbt_updkey(tcur, rkp, level + 1))) {
+	if ((error = xfs_btree_updkey(tcur, (union xfs_btree_key *)rkp, level + 1))) {
 		XFS_BMBT_TRACE_CURSOR(tcur, ERROR);
 		goto error1;
 	}
@@ -1274,44 +1237,6 @@ xfs_bmbt_split(
 	return 0;
 }
 
-
-/*
- * Update keys for the record.
- */
-STATIC int
-xfs_bmbt_updkey(
-	xfs_btree_cur_t		*cur,
-	xfs_bmbt_key_t		*keyp,	/* on-disk format */
-	int			level)
-{
-	xfs_bmbt_block_t	*block;
-	xfs_buf_t		*bp;
-#ifdef DEBUG
-	int			error;
-#endif
-	xfs_bmbt_key_t		*kp;
-	int			ptr;
-
-	ASSERT(level >= 1);
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGIK(cur, level, keyp);
-	for (ptr = 1; ptr == 1 && level < cur->bc_nlevels; level++) {
-		block = xfs_bmbt_get_block(cur, level, &bp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_lblock(cur, block, level, bp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-#endif
-		ptr = cur->bc_ptrs[level];
-		kp = XFS_BMAP_KEY_IADDR(block, ptr, cur);
-		*kp = *keyp;
-		xfs_bmbt_log_keys(cur, bp, ptr, ptr);
-	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	return 0;
-}
-
 /*
  * Convert on-disk form of btree root to in-memory form.
  */
@@ -2037,7 +1962,7 @@ xfs_bmbt_update(
 		return 0;
 	}
 	key.br_startoff = cpu_to_be64(off);
-	if ((error = xfs_bmbt_updkey(cur, &key, 1))) {
+	if ((error = xfs_btree_updkey(cur, (union xfs_btree_key *)&key, 1))) {
 		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 		return error;
 	}
@@ -2158,6 +2083,49 @@ xfs_bmbt_key_diff(
 				      cur->bc_rec.b.br_startoff;
 }
 
+STATIC void
+xfs_bmbt_copy_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*src_key,
+	union xfs_btree_key	*dst_key,
+	int			numkeys)
+{
+	ASSERT(numkeys >= 0);
+	memcpy(dst_key, src_key, numkeys * sizeof(xfs_bmbt_key_t));
+}
+
+/*
+ * Log key values from the btree block.
+ */
+STATIC void
+xfs_bmbt_log_keys(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp,
+	int			kfirst,
+	int			klast)
+{
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, kfirst, klast);
+
+	if (bp) {
+		struct xfs_btree_lblock	*block;
+		int			first;
+		xfs_bmbt_key_t		*kp;
+		int			last;
+
+		block = XFS_BUF_TO_LBLOCK(bp);
+		kp = XFS_BMAP_KEY_DADDR(block, 1, cur);
+		first = (int)((xfs_caddr_t)&kp[kfirst - 1] - (xfs_caddr_t)block);
+		last = (int)(((xfs_caddr_t)&kp[klast] - 1) - (xfs_caddr_t)block);
+		xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+	} else {
+		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
+			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
+	}
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+}
+
 #ifdef XFS_BTREE_TRACE
 
 ktrace_t	*xfs_bmbt_trace_buf;
@@ -2253,6 +2221,8 @@ static const struct xfs_btree_ops xfs_bm
 	.key_addr		= xfs_bmbt_key_addr,
 	.rec_addr		= xfs_bmbt_rec_addr,
 	.key_diff		= xfs_bmbt_key_diff,
+	.copy_keys		= xfs_bmbt_copy_keys,
+	.log_keys		= xfs_bmbt_log_keys,
 
 #ifdef XFS_BTREE_TRACE
 	.trace_enter		= xfs_bmbt_trace_enter,

-- 
