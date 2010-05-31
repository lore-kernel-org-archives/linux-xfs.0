Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VG6Y3X178928 for <xfs@oss.sgi.com>; Mon, 31 May 2010 11:06:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 77A1C387869
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 09:09:01 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 8YIi0Pa2iE8KoNdk for
	<xfs@oss.sgi.com>; Mon, 31 May 2010 09:09:01 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OJ7Xx-00011J-3j
	for xfs@oss.sgi.com; Mon, 31 May 2010 16:09:01 +0000
Message-Id: <20100531160901.036824012@bombadil.infradead.org>
Date: Mon, 31 May 2010 12:07:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/17] xfs: give li_cb callbacks the correct prototype
References: <20100531160727.842750532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-li_cb-types
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

Stop the function pointer casting madness and give all the li_cb instances
correct prototype.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.c	2010-05-29 18:12:09.768255567 +0200
+++ xfs/fs/xfs/quota/xfs_dquot.c	2010-05-29 18:16:52.004003788 +0200
@@ -54,8 +54,6 @@
    flush lock - ditto.
 */
 
-STATIC void		xfs_qm_dqflush_done(xfs_buf_t *, xfs_dq_logitem_t *);
-
 #ifdef DEBUG
 xfs_buftarg_t *xfs_dqerror_target;
 int xfs_do_dqerror;
@@ -1131,6 +1129,46 @@ xfs_qm_dqrele(
 	xfs_qm_dqput(dqp);
 }
 
+/*
+ * This is the dquot flushing I/O completion routine.  It is called
+ * from interrupt level when the buffer containing the dquot is
+ * flushed to disk.  It is responsible for removing the dquot logitem
+ * from the AIL if it has not been re-logged, and unlocking the dquot's
+ * flush lock. This behavior is very similar to that of inodes..
+ */
+STATIC void
+xfs_qm_dqflush_done(
+	struct xfs_buf		*bp,
+	struct xfs_log_item	*lip)
+{
+	xfs_dq_logitem_t	*qip = (struct xfs_dq_logitem *)lip;
+	xfs_dquot_t		*dqp = qip->qli_dquot;
+	struct xfs_ail		*ailp = lip->li_ailp;
+
+	/*
+	 * We only want to pull the item from the AIL if its
+	 * location in the log has not changed since we started the flush.
+	 * Thus, we only bother if the dquot's lsn has
+	 * not changed. First we check the lsn outside the lock
+	 * since it's cheaper, and then we recheck while
+	 * holding the lock before removing the dquot from the AIL.
+	 */
+	if ((lip->li_flags & XFS_LI_IN_AIL) &&
+	    lip->li_lsn == qip->qli_flush_lsn) {
+
+		/* xfs_trans_ail_delete() drops the AIL lock. */
+		spin_lock(&ailp->xa_lock);
+		if (lip->li_lsn == qip->qli_flush_lsn)
+			xfs_trans_ail_delete(ailp, lip);
+		else
+			spin_unlock(&ailp->xa_lock);
+	}
+
+	/*
+	 * Release the dq's flush lock since we're done with it.
+	 */
+	xfs_dqfunlock(dqp);
+}
 
 /*
  * Write a modified dquot to disk.
@@ -1212,8 +1250,9 @@ xfs_qm_dqflush(
 	 * Attach an iodone routine so that we can remove this dquot from the
 	 * AIL and release the flush lock once the dquot is synced to disk.
 	 */
-	xfs_buf_attach_iodone(bp, (void(*)(xfs_buf_t *, xfs_log_item_t *))
-			      xfs_qm_dqflush_done, &(dqp->q_logitem.qli_item));
+	xfs_buf_attach_iodone(bp, xfs_qm_dqflush_done,
+				  &dqp->q_logitem.qli_item);
+
 	/*
 	 * If the buffer is pinned then push on the log so we won't
 	 * get stuck waiting in the write for too long.
@@ -1237,50 +1276,6 @@ xfs_qm_dqflush(
 
 }
 
-/*
- * This is the dquot flushing I/O completion routine.  It is called
- * from interrupt level when the buffer containing the dquot is
- * flushed to disk.  It is responsible for removing the dquot logitem
- * from the AIL if it has not been re-logged, and unlocking the dquot's
- * flush lock. This behavior is very similar to that of inodes..
- */
-/*ARGSUSED*/
-STATIC void
-xfs_qm_dqflush_done(
-	xfs_buf_t		*bp,
-	xfs_dq_logitem_t	*qip)
-{
-	xfs_dquot_t		*dqp;
-	struct xfs_ail		*ailp;
-
-	dqp = qip->qli_dquot;
-	ailp = qip->qli_item.li_ailp;
-
-	/*
-	 * We only want to pull the item from the AIL if its
-	 * location in the log has not changed since we started the flush.
-	 * Thus, we only bother if the dquot's lsn has
-	 * not changed. First we check the lsn outside the lock
-	 * since it's cheaper, and then we recheck while
-	 * holding the lock before removing the dquot from the AIL.
-	 */
-	if ((qip->qli_item.li_flags & XFS_LI_IN_AIL) &&
-	    qip->qli_item.li_lsn == qip->qli_flush_lsn) {
-
-		/* xfs_trans_ail_delete() drops the AIL lock. */
-		spin_lock(&ailp->xa_lock);
-		if (qip->qli_item.li_lsn == qip->qli_flush_lsn)
-			xfs_trans_ail_delete(ailp, (xfs_log_item_t*)qip);
-		else
-			spin_unlock(&ailp->xa_lock);
-	}
-
-	/*
-	 * Release the dq's flush lock since we're done with it.
-	 */
-	xfs_dqfunlock(dqp);
-}
-
 int
 xfs_qm_dqlock_nowait(
 	xfs_dquot_t *dqp)
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2010-05-29 18:14:21.317046949 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2010-05-29 18:17:16.277004555 +0200
@@ -1079,15 +1079,14 @@ xfs_buf_error_relse(
  * It is called by xfs_buf_iodone_callbacks() above which will take
  * care of cleaning up the buffer itself.
  */
-/* ARGSUSED */
 void
 xfs_buf_iodone(
-	xfs_buf_t		*bp,
-	xfs_buf_log_item_t	*bip)
+	struct xfs_buf		*bp,
+	struct xfs_log_item	*lip)
 {
-	struct xfs_ail		*ailp = bip->bli_item.li_ailp;
+	struct xfs_ail		*ailp = lip->li_ailp;
 
-	ASSERT(bip->bli_buf == bp);
+	ASSERT(BUF_ITEM(lip)->bli_buf == bp);
 
 	xfs_buf_rele(bp);
 
@@ -1101,6 +1100,6 @@ xfs_buf_iodone(
 	 * Either way, AIL is useless if we're forcing a shutdown.
 	 */
 	spin_lock(&ailp->xa_lock);
-	xfs_trans_ail_delete(ailp, (xfs_log_item_t *)bip);
-	xfs_buf_item_free(bip);
+	xfs_trans_ail_delete(ailp, lip);
+	xfs_buf_item_free(BUF_ITEM(lip));
 }
Index: xfs/fs/xfs/xfs_buf_item.h
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.h	2010-05-25 13:01:10.104254015 +0200
+++ xfs/fs/xfs/xfs_buf_item.h	2010-05-29 18:17:16.279048625 +0200
@@ -124,7 +124,7 @@ void	xfs_buf_attach_iodone(struct xfs_bu
 			      void(*)(struct xfs_buf *, xfs_log_item_t *),
 			      xfs_log_item_t *);
 void	xfs_buf_iodone_callbacks(struct xfs_buf *);
-void	xfs_buf_iodone(struct xfs_buf *, xfs_buf_log_item_t *);
+void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
 
 #ifdef XFS_TRANS_DEBUG
 void
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2010-05-29 18:17:08.230003507 +0200
+++ xfs/fs/xfs/xfs_inode.c	2010-05-29 18:17:15.205004416 +0200
@@ -1984,7 +1984,7 @@ xfs_ifree_cluster(
 			if (lip->li_type == XFS_LI_INODE) {
 				iip = (xfs_inode_log_item_t *)lip;
 				ASSERT(iip->ili_logged == 1);
-				lip->li_cb = (void(*)(xfs_buf_t*,xfs_log_item_t*)) xfs_istale_done;
+				lip->li_cb = xfs_istale_done;
 				xfs_trans_ail_copy_lsn(mp->m_ail,
 							&iip->ili_flush_lsn,
 							&iip->ili_item.li_lsn);
@@ -2051,9 +2051,8 @@ xfs_ifree_cluster(
 			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
 						&iip->ili_item.li_lsn);
 
-			xfs_buf_attach_iodone(bp,
-				(void(*)(xfs_buf_t*,xfs_log_item_t*))
-				xfs_istale_done, (xfs_log_item_t *)iip);
+			xfs_buf_attach_iodone(bp, xfs_istale_done,
+						  &iip->ili_item);
 
 			if (ip != free_ip)
 				xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -3065,8 +3064,7 @@ xfs_iflush_int(
 		 * and unlock the inode's flush lock when the inode is
 		 * completely written to disk.
 		 */
-		xfs_buf_attach_iodone(bp, (void(*)(xfs_buf_t*,xfs_log_item_t*))
-				      xfs_iflush_done, (xfs_log_item_t *)iip);
+		xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
 
 		ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 		ASSERT(XFS_BUF_IODONE_FUNC(bp) != NULL);
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2010-05-29 18:17:08.236004764 +0200
+++ xfs/fs/xfs/xfs_inode_item.c	2010-05-29 18:17:15.206003508 +0200
@@ -867,14 +867,14 @@ xfs_inode_item_destroy(
  * from the AIL if it has not been re-logged, and unlocking the inode's
  * flush lock.
  */
-/*ARGSUSED*/
 void
 xfs_iflush_done(
-	xfs_buf_t		*bp,
-	xfs_inode_log_item_t	*iip)
+	struct xfs_buf		*bp,
+	struct xfs_log_item	*lip)
 {
+	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	xfs_inode_t		*ip = iip->ili_inode;
-	struct xfs_ail		*ailp = iip->ili_item.li_ailp;
+	struct xfs_ail		*ailp = lip->li_ailp;
 
 	/*
 	 * We only want to pull the item from the AIL if it is
@@ -885,12 +885,11 @@ xfs_iflush_done(
 	 * the lock since it's cheaper, and then we recheck while
 	 * holding the lock before removing the inode from the AIL.
 	 */
-	if (iip->ili_logged &&
-	    (iip->ili_item.li_lsn == iip->ili_flush_lsn)) {
+	if (iip->ili_logged && lip->li_lsn == iip->ili_flush_lsn) {
 		spin_lock(&ailp->xa_lock);
-		if (iip->ili_item.li_lsn == iip->ili_flush_lsn) {
+		if (lip->li_lsn == iip->ili_flush_lsn) {
 			/* xfs_trans_ail_delete() drops the AIL lock. */
-			xfs_trans_ail_delete(ailp, (xfs_log_item_t*)iip);
+			xfs_trans_ail_delete(ailp, lip);
 		} else {
 			spin_unlock(&ailp->xa_lock);
 		}
@@ -908,8 +907,6 @@ xfs_iflush_done(
 	 * Release the inode's flush lock since we're done with it.
 	 */
 	xfs_ifunlock(ip);
-
-	return;
 }
 
 /*
@@ -959,10 +956,10 @@ xfs_iflush_abort(
 
 void
 xfs_istale_done(
-	xfs_buf_t		*bp,
-	xfs_inode_log_item_t	*iip)
+	struct xfs_buf		*bp,
+	struct xfs_log_item	*lip)
 {
-	xfs_iflush_abort(iip->ili_inode);
+	xfs_iflush_abort(INODE_ITEM(lip)->ili_inode);
 }
 
 /*
Index: xfs/fs/xfs/xfs_inode_item.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.h	2010-05-29 18:17:08.256254380 +0200
+++ xfs/fs/xfs/xfs_inode_item.h	2010-05-29 18:17:15.211004626 +0200
@@ -161,8 +161,8 @@ static inline int xfs_inode_clean(xfs_in
 
 extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
 extern void xfs_inode_item_destroy(struct xfs_inode *);
-extern void xfs_iflush_done(struct xfs_buf *, xfs_inode_log_item_t *);
-extern void xfs_istale_done(struct xfs_buf *, xfs_inode_log_item_t *);
+extern void xfs_iflush_done(struct xfs_buf *, struct xfs_log_item *);
+extern void xfs_istale_done(struct xfs_buf *, struct xfs_log_item *);
 extern void xfs_iflush_abort(struct xfs_inode *);
 extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
 					 xfs_inode_log_format_t *);
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2010-05-29 18:12:27.256254730 +0200
+++ xfs/fs/xfs/xfs_trans_buf.c	2010-05-29 18:17:16.285032981 +0200
@@ -658,7 +658,7 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	XFS_BUF_SET_IODONE_FUNC(bp, xfs_buf_iodone_callbacks);
-	bip->bli_item.li_cb = (void(*)(xfs_buf_t*,xfs_log_item_t*))xfs_buf_iodone;
+	bip->bli_item.li_cb = xfs_buf_iodone;
 
 	trace_xfs_trans_log_buf(bip);
 
@@ -815,12 +815,9 @@ xfs_trans_stale_inode_buf(
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_STALE_INODE;
-	bip->bli_item.li_cb = (void(*)(xfs_buf_t*,xfs_log_item_t*))
-		xfs_buf_iodone;
+	bip->bli_item.li_cb = xfs_buf_iodone;
 }
 
-
-
 /*
  * Mark the buffer as being one which contains newly allocated
  * inodes.  We need to make sure that even if this buffer is

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
