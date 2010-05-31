Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VG6YdU178922 for <xfs@oss.sgi.com>; Mon, 31 May 2010 11:06:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B8D514678DD
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 09:09:00 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id MaX0K9vJDRI3TBsI for
	<xfs@oss.sgi.com>; Mon, 31 May 2010 09:09:00 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OJ7Xw-0000z3-NL
	for xfs@oss.sgi.com; Mon, 31 May 2010 16:09:00 +0000
Message-Id: <20100531160900.602159529@bombadil.infradead.org>
Date: Mon, 31 May 2010 12:07:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/17] xfs: merge iop_unpin_remove into iop_unpin
References: <20100531160727.842750532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-merge-IOP-remove
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

The unpin_remove item operation instances always share most of the
implementation with the respective unpin implementation.  So instead
of keeping two different entry points add a remove flag to the unpin
operation and share the code more easily.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_dquot_item.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot_item.c	2010-05-25 11:40:59.115285445 +0200
+++ xfs/fs/xfs/quota/xfs_dquot_item.c	2010-05-25 12:45:02.895004400 +0200
@@ -97,7 +97,8 @@ xfs_qm_dquot_logitem_pin(
 /* ARGSUSED */
 STATIC void
 xfs_qm_dquot_logitem_unpin(
-	xfs_dq_logitem_t *logitem)
+	xfs_dq_logitem_t	*logitem,
+	int			remove)
 {
 	xfs_dquot_t *dqp = logitem->qli_dquot;
 
@@ -106,15 +107,6 @@ xfs_qm_dquot_logitem_unpin(
 		wake_up(&dqp->q_pinwait);
 }
 
-/* ARGSUSED */
-STATIC void
-xfs_qm_dquot_logitem_unpin_remove(
-	xfs_dq_logitem_t *logitem,
-	xfs_trans_t	 *tp)
-{
-	xfs_qm_dquot_logitem_unpin(logitem);
-}
-
 /*
  * Given the logitem, this writes the corresponding dquot entry to disk
  * asynchronously. This is called with the dquot entry securely locked;
@@ -318,9 +310,7 @@ static struct xfs_item_ops xfs_dquot_ite
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_qm_dquot_logitem_format,
 	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_qm_dquot_logitem_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t*))xfs_qm_dquot_logitem_unpin,
-	.iop_unpin_remove = (void(*)(xfs_log_item_t*, xfs_trans_t*))
-					xfs_qm_dquot_logitem_unpin_remove,
+	.iop_unpin	= (void(*)(xfs_log_item_t*, int))xfs_qm_dquot_logitem_unpin,
 	.iop_trylock	= (uint(*)(xfs_log_item_t*))
 					xfs_qm_dquot_logitem_trylock,
 	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_qm_dquot_logitem_unlock,
@@ -413,14 +403,7 @@ xfs_qm_qoff_logitem_pin(xfs_qoff_logitem
  */
 /*ARGSUSED*/
 STATIC void
-xfs_qm_qoff_logitem_unpin(xfs_qoff_logitem_t *qf)
-{
-	return;
-}
-
-/*ARGSUSED*/
-STATIC void
-xfs_qm_qoff_logitem_unpin_remove(xfs_qoff_logitem_t *qf, xfs_trans_t *tp)
+xfs_qm_qoff_logitem_unpin(xfs_qoff_logitem_t *qf, int remove)
 {
 	return;
 }
@@ -524,9 +507,7 @@ static struct xfs_item_ops xfs_qm_qoffen
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_qm_qoff_logitem_format,
 	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_unpin,
-	.iop_unpin_remove = (void(*)(xfs_log_item_t*,xfs_trans_t*))
-					xfs_qm_qoff_logitem_unpin_remove,
+	.iop_unpin	= (void(*)(xfs_log_item_t*, int))xfs_qm_qoff_logitem_unpin,
 	.iop_trylock	= (uint(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_trylock,
 	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_unlock,
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
@@ -545,9 +526,7 @@ static struct xfs_item_ops xfs_qm_qoff_l
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_qm_qoff_logitem_format,
 	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_unpin,
-	.iop_unpin_remove = (void(*)(xfs_log_item_t*,xfs_trans_t*))
-					xfs_qm_qoff_logitem_unpin_remove,
+	.iop_unpin	= (void(*)(xfs_log_item_t*, int))xfs_qm_qoff_logitem_unpin,
 	.iop_trylock	= (uint(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_trylock,
 	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_unlock,
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2010-05-25 12:43:47.926004470 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2010-05-25 12:45:02.901022489 +0200
@@ -388,20 +388,25 @@ xfs_buf_item_pin(
  * Also drop the reference to the buf item for the current transaction.
  * If the XFS_BLI_STALE flag is set and we are the last reference,
  * then free up the buf log item and unlock the buffer.
+ *
+ * If the remove flag is set we are called from uncommit in the
+ * forced-shutdown path.  If that is true and the reference count on
+ * the log item is going to drop to zero we need to free the item's
+ * descriptor in the transaction.
  */
 STATIC void
 xfs_buf_item_unpin(
-	xfs_buf_log_item_t	*bip)
+	xfs_buf_log_item_t	*bip,
+	int			remove)
 {
 	struct xfs_ail	*ailp;
-	xfs_buf_t	*bp;
+	xfs_buf_t	*bp = bip->bli_buf;
 	int		freed;
 	int		stale = bip->bli_flags & XFS_BLI_STALE;
 
-	bp = bip->bli_buf;
-	ASSERT(bp != NULL);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *) == bip);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+
 	trace_xfs_buf_item_unpin(bip);
 
 	freed = atomic_dec_and_test(&bip->bli_refcount);
@@ -413,8 +418,26 @@ xfs_buf_item_unpin(
 		ASSERT(!(XFS_BUF_ISDELAYWRITE(bp)));
 		ASSERT(XFS_BUF_ISSTALE(bp));
 		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
+
 		trace_xfs_buf_item_unpin_stale(bip);
 
+		if (remove) {
+			/*
+			 * We have to remove the log item from the transaction
+			 * as we are about to release our reference to the
+			 * buffer.  If we don't, the unlock that occurs later
+			 * in xfs_trans_uncommit() will ry to reference the
+			 * buffer which we no longer have a hold on.
+			 */
+			xfs_trans_del_item(&bip->bli_item);
+
+			/*
+			 * Since the transaction no longer refers to the buffer,
+			 * the buffer should no longer refer to the transaction.
+			 */
+			XFS_BUF_SET_FSPRIVATE2(bp, NULL);
+		}
+
 		/*
 		 * If we get called here because of an IO error, we may
 		 * or may not have the item on the AIL. xfs_trans_ail_delete()
@@ -436,45 +459,6 @@ xfs_buf_item_unpin(
 }
 
 /*
- * this is called from uncommit in the forced-shutdown path.
- * we need to check to see if the reference count on the log item
- * is going to drop to zero.  If so, unpin will free the log item
- * so we need to free the item's descriptor (that points to the item)
- * in the transaction.
- */
-STATIC void
-xfs_buf_item_unpin_remove(
-	xfs_buf_log_item_t	*bip,
-	xfs_trans_t		*tp)
-{
-	/* will xfs_buf_item_unpin() call xfs_buf_item_relse()? */
-	if ((atomic_read(&bip->bli_refcount) == 1) &&
-	    (bip->bli_flags & XFS_BLI_STALE)) {
-		/*
-		 * yes -- We can safely do some work here and then call
-		 * buf_item_unpin to do the rest because we are
-		 * are holding the buffer locked so no one else will be
-		 * able to bump up the refcount. We have to remove the
-		 * log item from the transaction as we are about to release
-		 * our reference to the buffer. If we don't, the unlock that
-		 * occurs later in the xfs_trans_uncommit() will try to
-		 * reference the buffer which we no longer have a hold on.
-		 */
-		ASSERT(XFS_BUF_VALUSEMA(bip->bli_buf) <= 0);
-		trace_xfs_buf_item_unpin_stale(bip);
-
-		xfs_trans_del_item(&bip->bli_item);
-
-		/*
-		 * Since the transaction no longer refers to the buffer, the
-		 * buffer should no longer refer to the transaction.
-		 */
-		XFS_BUF_SET_FSPRIVATE2(bip->bli_buf, NULL);
-	}
-	xfs_buf_item_unpin(bip);
-}
-
-/*
  * This is called to attempt to lock the buffer associated with this
  * buf log item.  Don't sleep on the buffer lock.  If we can't get
  * the lock right away, return 0.  If we can get the lock, take a
@@ -669,9 +653,7 @@ static struct xfs_item_ops xfs_buf_item_
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_buf_item_format,
 	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_buf_item_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t*))xfs_buf_item_unpin,
-	.iop_unpin_remove = (void(*)(xfs_log_item_t*, xfs_trans_t *))
-					xfs_buf_item_unpin_remove,
+	.iop_unpin	= (void(*)(xfs_log_item_t*, int))xfs_buf_item_unpin,
 	.iop_trylock	= (uint(*)(xfs_log_item_t*))xfs_buf_item_trylock,
 	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_buf_item_unlock,
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
Index: xfs/fs/xfs/xfs_extfree_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_extfree_item.c	2010-05-25 12:43:47.938004470 +0200
+++ xfs/fs/xfs/xfs_extfree_item.c	2010-05-25 12:45:02.903023258 +0200
@@ -103,32 +103,8 @@ xfs_efi_item_pin(xfs_efi_log_item_t *efi
  * Here we coordinate with xfs_efi_cancel() to determine who gets to
  * free the EFI.
  */
-/*ARGSUSED*/
-STATIC void
-xfs_efi_item_unpin(xfs_efi_log_item_t *efip)
-{
-	struct xfs_ail		*ailp = efip->efi_item.li_ailp;
-
-	spin_lock(&ailp->xa_lock);
-	if (efip->efi_flags & XFS_EFI_CANCELED) {
-		/* xfs_trans_ail_delete() drops the AIL lock. */
-		xfs_trans_ail_delete(ailp, (xfs_log_item_t *)efip);
-		xfs_efi_item_free(efip);
-	} else {
-		efip->efi_flags |= XFS_EFI_COMMITTED;
-		spin_unlock(&ailp->xa_lock);
-	}
-}
-
-/*
- * like unpin only we have to also clear the xaction descriptor
- * pointing the log item if we free the item.  This routine duplicates
- * unpin because efi_flags is protected by the AIL lock.  Freeing
- * the descriptor and then calling unpin would force us to drop the AIL
- * lock which would open up a race condition.
- */
 STATIC void
-xfs_efi_item_unpin_remove(xfs_efi_log_item_t *efip, xfs_trans_t *tp)
+xfs_efi_item_unpin(xfs_efi_log_item_t *efip, int remove)
 {
 	struct xfs_ail		*ailp = efip->efi_item.li_ailp;
 
@@ -136,10 +112,8 @@ xfs_efi_item_unpin_remove(xfs_efi_log_it
 	if (efip->efi_flags & XFS_EFI_CANCELED) {
 		struct xfs_log_item	*lip = &efip->efi_item;
 
-		/*
-		 * free the xaction descriptor pointing to this item
-		 */
-		xfs_trans_del_item(lip);
+		if (remove)
+			xfs_trans_del_item(lip);
 
 		/* xfs_trans_ail_delete() drops the AIL lock. */
 		xfs_trans_ail_delete(ailp, lip);
@@ -223,9 +197,7 @@ static struct xfs_item_ops xfs_efi_item_
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_efi_item_format,
 	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_efi_item_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t*))xfs_efi_item_unpin,
-	.iop_unpin_remove = (void(*)(xfs_log_item_t*, xfs_trans_t *))
-					xfs_efi_item_unpin_remove,
+	.iop_unpin	= (void(*)(xfs_log_item_t*, int))xfs_efi_item_unpin,
 	.iop_trylock	= (uint(*)(xfs_log_item_t*))xfs_efi_item_trylock,
 	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_efi_item_unlock,
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
@@ -424,14 +396,7 @@ xfs_efd_item_pin(xfs_efd_log_item_t *efd
  */
 /*ARGSUSED*/
 STATIC void
-xfs_efd_item_unpin(xfs_efd_log_item_t *efdp)
-{
-	return;
-}
-
-/*ARGSUSED*/
-STATIC void
-xfs_efd_item_unpin_remove(xfs_efd_log_item_t *efdp, xfs_trans_t *tp)
+xfs_efd_item_unpin(xfs_efd_log_item_t *efdp, int remove)
 {
 	return;
 }
@@ -514,9 +479,7 @@ static struct xfs_item_ops xfs_efd_item_
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_efd_item_format,
 	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_efd_item_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t*))xfs_efd_item_unpin,
-	.iop_unpin_remove = (void(*)(xfs_log_item_t*, xfs_trans_t*))
-					xfs_efd_item_unpin_remove,
+	.iop_unpin	= (void(*)(xfs_log_item_t*, int))xfs_efd_item_unpin,
 	.iop_trylock	= (uint(*)(xfs_log_item_t*))xfs_efd_item_trylock,
 	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_efd_item_unlock,
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2010-05-25 11:40:59.225034362 +0200
+++ xfs/fs/xfs/xfs_inode_item.c	2010-05-25 12:45:02.915017599 +0200
@@ -544,10 +544,10 @@ xfs_inode_item_pin(
  *
  * Also wake up anyone in xfs_iunpin_wait() if the count goes to 0.
  */
-/* ARGSUSED */
 STATIC void
 xfs_inode_item_unpin(
-	xfs_inode_log_item_t	*iip)
+	xfs_inode_log_item_t	*iip,
+	int			remove)
 {
 	struct xfs_inode	*ip = iip->ili_inode;
 
@@ -557,15 +557,6 @@ xfs_inode_item_unpin(
 		wake_up(&ip->i_ipin_wait);
 }
 
-/* ARGSUSED */
-STATIC void
-xfs_inode_item_unpin_remove(
-	xfs_inode_log_item_t	*iip,
-	xfs_trans_t		*tp)
-{
-	xfs_inode_item_unpin(iip);
-}
-
 /*
  * This is called to attempt to lock the inode associated with this
  * inode log item, in preparation for the push routine which does the actual
@@ -829,9 +820,7 @@ static struct xfs_item_ops xfs_inode_ite
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_inode_item_format,
 	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_inode_item_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t*))xfs_inode_item_unpin,
-	.iop_unpin_remove = (void(*)(xfs_log_item_t*, xfs_trans_t*))
-					xfs_inode_item_unpin_remove,
+	.iop_unpin	= (void(*)(xfs_log_item_t*, int))xfs_inode_item_unpin,
 	.iop_trylock	= (uint(*)(xfs_log_item_t*))xfs_inode_item_trylock,
 	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_inode_item_unlock,
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2010-05-25 12:43:47.977004330 +0200
+++ xfs/fs/xfs/xfs_trans.c	2010-05-25 12:45:02.918006215 +0200
@@ -1375,7 +1375,7 @@ xfs_trans_item_committed(
 	 * log item flags, if anyone else stales the buffer we do not want to
 	 * pay any attention to it.
 	 */
-	IOP_UNPIN(lip);
+	IOP_UNPIN(lip, 0);
 }
 
 /*
@@ -1422,7 +1422,7 @@ xfs_trans_uncommit(
 		 * Unpin all but those that aren't dirty.
 		 */
 		if (lidp->lid_flags & XFS_LID_DIRTY)
-			IOP_UNPIN_REMOVE(lidp->lid_item, tp);
+			IOP_UNPIN(lidp->lid_item, 1);
 	}
 
 	xfs_trans_unreserve_and_mod_sb(tp);
Index: xfs/fs/xfs/xfs_trans.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.h	2010-05-25 12:43:47.986004051 +0200
+++ xfs/fs/xfs/xfs_trans.h	2010-05-25 12:45:02.942046166 +0200
@@ -347,8 +347,7 @@ typedef struct xfs_item_ops {
 	uint (*iop_size)(xfs_log_item_t *);
 	void (*iop_format)(xfs_log_item_t *, struct xfs_log_iovec *);
 	void (*iop_pin)(xfs_log_item_t *);
-	void (*iop_unpin)(xfs_log_item_t *);
-	void (*iop_unpin_remove)(xfs_log_item_t *, struct xfs_trans *);
+	void (*iop_unpin)(xfs_log_item_t *, int remove);
 	uint (*iop_trylock)(xfs_log_item_t *);
 	void (*iop_unlock)(xfs_log_item_t *);
 	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
@@ -360,8 +359,7 @@ typedef struct xfs_item_ops {
 #define IOP_SIZE(ip)		(*(ip)->li_ops->iop_size)(ip)
 #define IOP_FORMAT(ip,vp)	(*(ip)->li_ops->iop_format)(ip, vp)
 #define IOP_PIN(ip)		(*(ip)->li_ops->iop_pin)(ip)
-#define IOP_UNPIN(ip)		(*(ip)->li_ops->iop_unpin)(ip)
-#define IOP_UNPIN_REMOVE(ip,tp) (*(ip)->li_ops->iop_unpin_remove)(ip, tp)
+#define IOP_UNPIN(ip, remove)	(*(ip)->li_ops->iop_unpin)(ip, remove)
 #define IOP_TRYLOCK(ip)		(*(ip)->li_ops->iop_trylock)(ip)
 #define IOP_UNLOCK(ip)		(*(ip)->li_ops->iop_unlock)(ip)
 #define IOP_COMMITTED(ip, lsn)	(*(ip)->li_ops->iop_committed)(ip, lsn)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
