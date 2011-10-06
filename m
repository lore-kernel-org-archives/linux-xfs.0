Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96L6fml201650 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 16:06:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0DAC11C6F17D
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 14:06:39 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	fnbtijCmL08NIhKc for <xfs@oss.sgi.com>;
	Thu, 06 Oct 2011 14:06:39 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RBv9L-0004EU-Cx
	for xfs@oss.sgi.com; Thu, 06 Oct 2011 21:06:39 +0000
Message-Id: <20111006210639.352441913@bombadil.infradead.org>
Date: Thu, 06 Oct 2011 17:06:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/9] xfs: remove buffers from the delwri list in xfs_buf_stale
References: <20111006210607.175284390@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-buf-stale-delwri-remove
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

For each call to xfs_buf_stale we call xfs_buf_delwri_dequeue either
directly before or after it, or are guaranteed by the surrounding
conditionals that we are never called on delwri buffers.  Simply
this situation by moving the call to xfs_buf_delwri_dequeue into
xfs_buf_stale.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2011-10-06 14:37:11.010920453 -0400
+++ xfs/fs/xfs/xfs_attr.c	2011-10-06 14:37:13.674921044 -0400
@@ -2169,7 +2169,6 @@ xfs_attr_rmtval_remove(xfs_da_args_t *ar
 		bp = xfs_incore(mp->m_ddev_targp, dblkno, blkcnt, XBF_TRYLOCK);
 		if (bp) {
 			xfs_buf_stale(bp);
-			xfs_buf_delwri_dequeue(bp);
 			xfs_buf_relse(bp);
 			bp = NULL;
 		}
Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2011-10-06 14:37:11.014920137 -0400
+++ xfs/fs/xfs/xfs_buf.c	2011-10-06 14:37:13.674921044 -0400
@@ -151,6 +151,7 @@ xfs_buf_stale(
 	struct xfs_buf	*bp)
 {
 	bp->b_flags |= XBF_STALE;
+	xfs_buf_delwri_dequeue(bp);
 	atomic_set(&(bp)->b_lru_ref, 0);
 	if (!list_empty(&bp->b_lru)) {
 		struct xfs_buftarg *btp = bp->b_target;
@@ -1059,7 +1060,6 @@ xfs_bioerror(
 	 * We're calling xfs_buf_ioend, so delete XBF_DONE flag.
 	 */
 	XFS_BUF_UNREAD(bp);
-	xfs_buf_delwri_dequeue(bp);
 	XFS_BUF_UNDONE(bp);
 	xfs_buf_stale(bp);
 
@@ -1088,7 +1088,6 @@ xfs_bioerror_relse(
 	 * change that interface.
 	 */
 	XFS_BUF_UNREAD(bp);
-	xfs_buf_delwri_dequeue(bp);
 	XFS_BUF_DONE(bp);
 	xfs_buf_stale(bp);
 	bp->b_iodone = NULL;
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2011-10-06 14:37:11.014920137 -0400
+++ xfs/fs/xfs/xfs_buf_item.c	2011-10-06 14:37:13.678919098 -0400
@@ -968,7 +968,6 @@ xfs_buf_iodone_callbacks(
 	 */
 	if (XFS_FORCED_SHUTDOWN(mp)) {
 		xfs_buf_stale(bp);
-		xfs_buf_delwri_dequeue(bp);
 		XFS_BUF_DONE(bp);
 		trace_xfs_buf_item_iodone(bp, _RET_IP_);
 		goto do_callbacks;
@@ -1010,7 +1007,6 @@ xfs_buf_iodone_callbacks(
 	 */
 	xfs_buf_stale(bp);
 	XFS_BUF_DONE(bp);
-	xfs_buf_delwri_dequeue(bp);
 
 	trace_xfs_buf_error_relse(bp, _RET_IP_);
 
Index: xfs/fs/xfs/xfs_rw.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rw.c	2011-10-06 14:37:11.030919219 -0400
+++ xfs/fs/xfs/xfs_rw.c	2011-10-06 14:37:13.682917913 -0400
@@ -149,7 +149,6 @@ xfs_read_buf(
 		}
 		if (bp) {
 			XFS_BUF_UNDONE(bp);
-			xfs_buf_delwri_dequeue(bp);
 			xfs_buf_stale(bp);
 			/*
 			 * brelse clears B_ERROR and b_error
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2011-10-06 14:37:11.030919219 -0400
+++ xfs/fs/xfs/xfs_trans_buf.c	2011-10-06 14:37:13.686917964 -0400
@@ -162,7 +162,6 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 		ASSERT(xfs_buf_islocked(bp));
 		if (XFS_FORCED_SHUTDOWN(tp->t_mountp)) {
 			xfs_buf_stale(bp);
-			xfs_buf_delwri_dequeue(bp);
 			XFS_BUF_DONE(bp);
 		}
 
@@ -391,7 +390,6 @@ xfs_trans_read_buf(
 	if (bp->b_error) {
 		error = bp->b_error;
 		xfs_buf_stale(bp);
-		xfs_buf_delwri_dequeue(bp);
 		XFS_BUF_DONE(bp);
 		xfs_ioerror_alert("xfs_trans_read_buf", mp,
 				  bp, blkno);
@@ -744,7 +742,6 @@ xfs_trans_binval(
 	 * We set the stale bit in the buffer as well since we're getting
 	 * rid of it.
 	 */
-	xfs_buf_delwri_dequeue(bp);
 	xfs_buf_stale(bp);
 	bip->bli_flags |= XFS_BLI_STALE;
 	bip->bli_flags &= ~(XFS_BLI_INODE_BUF | XFS_BLI_LOGGED | XFS_BLI_DIRTY);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
