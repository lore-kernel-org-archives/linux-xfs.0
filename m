Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o87NXNtt003025 for <xfs@oss.sgi.com>; Tue, 7 Sep 2010 18:33:26 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2054C17B81D7
	for <xfs@oss.sgi.com>; Tue,  7 Sep 2010 16:34:07 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id UiGdKNXcPVT2EskX for
	<xfs@oss.sgi.com>; Tue, 07 Sep 2010 16:34:07 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Ot7fz-0004lO-NT
	for xfs@oss.sgi.com; Tue, 07 Sep 2010 23:34:07 +0000
Date: Tue, 7 Sep 2010 19:34:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: remove the ->kill_root btree operation
Message-ID: <20100907233407.GA17728@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The implementation os ->kill_root only differ by either simply zeroing
out the now unused buffer in the btree cursor in the inode allocation
btree or using xfs_btree_setbuf in the allocation btree.

Initially both of them used xfs_btree_setbuf, but the use in the ialloc
btree was removed early on because it interacted badly with xfs_trans_binval.

In addition to zeroing out the buffer in the cursor xfs_btree_setbuf updates
the bc_ra array in the btree cursor, and calls xfs_trans_brelse on the
buffer previous occupying the slot.

The bc_ra update should be done for the alloc btree updated too, although
the lack of it does not cause serious problems.  The xfs_trans_brelse
call on the other hand is effectively a no-op in the end - it keeps
decrementing the bli_recur refcount until it hits zero, and then just
skips out because the buffer will always be dirty at this point.  So
removing it for the allocation btree is just fine.

So unify the code and move it to xfs_btree.c.  While we're at it also
replace the call to xfs_btree_setbuf with a NULL bp argument in
xfs_btree_del_cursor with a direct call to xfs_trans_brelse given
that the cursor is beeing freed just after this and the state updates
are superflous.  After this xfs_btree_setbuf is only used with a non-NULL
bp argument and can thus be simplified.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc_btree.c	2010-08-15 10:16:46.660004281 -0300
+++ xfs/fs/xfs/xfs_alloc_btree.c	2010-09-06 18:18:30.491206020 -0300
@@ -280,38 +280,6 @@ xfs_allocbt_key_diff(
 	return (__int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
 }
 
-STATIC int
-xfs_allocbt_kill_root(
-	struct xfs_btree_cur	*cur,
-	struct xfs_buf		*bp,
-	int			level,
-	union xfs_btree_ptr	*newroot)
-{
-	int			error;
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_STATS_INC(cur, killroot);
-
-	/*
-	 * Update the root pointer, decreasing the level by 1 and then
-	 * free the old root.
-	 */
-	xfs_allocbt_set_root(cur, newroot, -1);
-	error = xfs_allocbt_free_block(cur, bp);
-	if (error) {
-		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
-		return error;
-	}
-
-	XFS_BTREE_STATS_INC(cur, free);
-
-	xfs_btree_setbuf(cur, level, NULL);
-	cur->bc_nlevels--;
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
-	return 0;
-}
-
 #ifdef DEBUG
 STATIC int
 xfs_allocbt_keys_inorder(
@@ -423,7 +391,6 @@ static const struct xfs_btree_ops xfs_al
 
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
-	.kill_root		= xfs_allocbt_kill_root,
 	.alloc_block		= xfs_allocbt_alloc_block,
 	.free_block		= xfs_allocbt_free_block,
 	.update_lastrec		= xfs_allocbt_update_lastrec,
Index: xfs/fs/xfs/xfs_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_btree.c	2010-07-27 12:49:25.051494680 -0300
+++ xfs/fs/xfs/xfs_btree.c	2010-09-06 18:18:30.496206020 -0300
@@ -217,7 +217,7 @@ xfs_btree_del_cursor(
 	 */
 	for (i = 0; i < cur->bc_nlevels; i++) {
 		if (cur->bc_bufs[i])
-			xfs_btree_setbuf(cur, i, NULL);
+			xfs_trans_brelse(cur->bc_tp, cur->bc_bufs[i]);
 		else if (!error)
 			break;
 	}
@@ -763,22 +763,19 @@ xfs_btree_readahead(
  * Set the buffer for level "lev" in the cursor to bp, releasing
  * any previous buffer.
  */
-void
+STATIC void
 xfs_btree_setbuf(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
 	int			lev,	/* level in btree */
 	xfs_buf_t		*bp)	/* new buffer to set */
 {
 	struct xfs_btree_block	*b;	/* btree block */
-	xfs_buf_t		*obp;	/* old buffer pointer */
 
-	obp = cur->bc_bufs[lev];
-	if (obp)
-		xfs_trans_brelse(cur->bc_tp, obp);
+	if (cur->bc_bufs[lev])
+		xfs_trans_brelse(cur->bc_tp, cur->bc_bufs[lev]);
 	cur->bc_bufs[lev] = bp;
 	cur->bc_ra[lev] = 0;
-	if (!bp)
-		return;
+
 	b = XFS_BUF_TO_BLOCK(bp);
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
 		if (be64_to_cpu(b->bb_u.l.bb_leftsib) == NULLDFSBNO)
@@ -3011,6 +3008,43 @@ out0:
 	return 0;
 }
 
+/*
+ * Kill the current root node, and replace it with it's only child node.
+ */
+STATIC int
+xfs_btree_kill_root(
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
+	/*
+	 * Update the root pointer, decreasing the level by 1 and then
+	 * free the old root.
+	 */
+	cur->bc_ops->set_root(cur, newroot, -1);
+
+	error = cur->bc_ops->free_block(cur, bp);
+	if (error) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+		return error;
+	}
+
+	XFS_BTREE_STATS_INC(cur, free);
+
+	cur->bc_bufs[level] = NULL;
+	cur->bc_ra[level] = 0;
+	cur->bc_nlevels--;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	return 0;
+}
+
 STATIC int
 xfs_btree_dec_cursor(
 	struct xfs_btree_cur	*cur,
@@ -3195,7 +3229,7 @@ xfs_btree_delrec(
 			 * Make it the new root of the btree.
 			 */
 			pp = xfs_btree_ptr_addr(cur, 1, block);
-			error = cur->bc_ops->kill_root(cur, bp, level, pp);
+			error = xfs_btree_kill_root(cur, bp, level, pp);
 			if (error)
 				goto error0;
 		} else if (level > 0) {
Index: xfs/fs/xfs/xfs_btree.h
===================================================================
--- xfs.orig/fs/xfs/xfs_btree.h	2009-09-16 09:36:17.000000000 -0300
+++ xfs/fs/xfs/xfs_btree.h	2010-09-06 18:18:30.499206020 -0300
@@ -152,9 +152,7 @@ struct xfs_btree_ops {
 
 	/* update btree root pointer */
 	void	(*set_root)(struct xfs_btree_cur *cur,
-				union xfs_btree_ptr *nptr, int level_change);
-	int	(*kill_root)(struct xfs_btree_cur *cur, struct xfs_buf *bp,
-				int level, union xfs_btree_ptr *newroot);
+			    union xfs_btree_ptr *nptr, int level_change);
 
 	/* block allocation / freeing */
 	int	(*alloc_block)(struct xfs_btree_cur *cur,
@@ -399,16 +397,6 @@ xfs_btree_reada_bufs(
 	xfs_agblock_t		agbno,	/* allocation group block number */
 	xfs_extlen_t		count);	/* count of filesystem blocks */
 
-/*
- * Set the buffer for level "lev" in the cursor to bp, releasing
- * any previous buffer.
- */
-void
-xfs_btree_setbuf(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			lev,	/* level in btree */
-	struct xfs_buf		*bp);	/* new buffer to set */
-
 
 /*
  * Common btree core entry points.
Index: xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc_btree.c	2010-07-27 12:49:25.060494680 -0300
+++ xfs/fs/xfs/xfs_ialloc_btree.c	2010-09-06 18:18:30.502206020 -0300
@@ -183,38 +183,6 @@ xfs_inobt_key_diff(
 			  cur->bc_rec.i.ir_startino;
 }
 
-STATIC int
-xfs_inobt_kill_root(
-	struct xfs_btree_cur	*cur,
-	struct xfs_buf		*bp,
-	int			level,
-	union xfs_btree_ptr	*newroot)
-{
-	int			error;
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_STATS_INC(cur, killroot);
-
-	/*
-	 * Update the root pointer, decreasing the level by 1 and then
-	 * free the old root.
-	 */
-	xfs_inobt_set_root(cur, newroot, -1);
-	error = xfs_inobt_free_block(cur, bp);
-	if (error) {
-		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
-		return error;
-	}
-
-	XFS_BTREE_STATS_INC(cur, free);
-
-	cur->bc_bufs[level] = NULL;
-	cur->bc_nlevels--;
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
-	return 0;
-}
-
 #ifdef DEBUG
 STATIC int
 xfs_inobt_keys_inorder(
@@ -309,7 +277,6 @@ static const struct xfs_btree_ops xfs_in
 
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_inobt_set_root,
-	.kill_root		= xfs_inobt_kill_root,
 	.alloc_block		= xfs_inobt_alloc_block,
 	.free_block		= xfs_inobt_free_block,
 	.get_minrecs		= xfs_inobt_get_minrecs,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
