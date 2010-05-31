Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VG6YsW178925 for <xfs@oss.sgi.com>; Mon, 31 May 2010 11:06:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A26314678DF
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 09:09:01 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Oa2oaO228A8JzcNb for
	<xfs@oss.sgi.com>; Mon, 31 May 2010 09:09:01 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OJ7Xw-00010c-Tl
	for xfs@oss.sgi.com; Mon, 31 May 2010 16:09:00 +0000
Message-Id: <20100531160900.816713118@bombadil.infradead.org>
Date: Mon, 31 May 2010 12:07:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/17] xfs: give xfs_item_ops methods the correct prototypes
References: <20100531160727.842750532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-iop-prototype-cleanup
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

Stop the function pointer casting madness and give all the xfs_item_ops the
correct prototypes.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_dquot_item.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot_item.c	2010-05-29 18:12:37.757004346 +0200
+++ xfs/fs/xfs/quota/xfs_dquot_item.c	2010-05-29 18:14:21.307004136 +0200
@@ -37,18 +37,22 @@
 #include "xfs_trans_priv.h"
 #include "xfs_qm.h"
 
+static inline struct xfs_dq_logitem *DQUOT_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_dq_logitem, qli_item);
+}
+
 /*
  * returns the number of iovecs needed to log the given dquot item.
  */
-/* ARGSUSED */
 STATIC uint
 xfs_qm_dquot_logitem_size(
-	xfs_dq_logitem_t	*logitem)
+	struct xfs_log_item	*lip)
 {
 	/*
 	 * we need only two iovecs, one for the format, one for the real thing
 	 */
-	return (2);
+	return 2;
 }
 
 /*
@@ -56,22 +60,21 @@ xfs_qm_dquot_logitem_size(
  */
 STATIC void
 xfs_qm_dquot_logitem_format(
-	xfs_dq_logitem_t	*logitem,
-	xfs_log_iovec_t		*logvec)
+	struct xfs_log_item	*lip,
+	struct xfs_log_iovec	*logvec)
 {
-	ASSERT(logitem);
-	ASSERT(logitem->qli_dquot);
+	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
 
-	logvec->i_addr = (xfs_caddr_t)&logitem->qli_format;
+	logvec->i_addr = (xfs_caddr_t)&qlip->qli_format;
 	logvec->i_len  = sizeof(xfs_dq_logformat_t);
 	logvec->i_type = XLOG_REG_TYPE_QFORMAT;
 	logvec++;
-	logvec->i_addr = (xfs_caddr_t)&logitem->qli_dquot->q_core;
+	logvec->i_addr = (xfs_caddr_t)&qlip->qli_dquot->q_core;
 	logvec->i_len  = sizeof(xfs_disk_dquot_t);
 	logvec->i_type = XLOG_REG_TYPE_DQUOT;
 
-	ASSERT(2 == logitem->qli_item.li_desc->lid_size);
-	logitem->qli_format.qlf_size = 2;
+	ASSERT(2 == lip->li_desc->lid_size);
+	qlip->qli_format.qlf_size = 2;
 
 }
 
@@ -80,9 +83,9 @@ xfs_qm_dquot_logitem_format(
  */
 STATIC void
 xfs_qm_dquot_logitem_pin(
-	xfs_dq_logitem_t *logitem)
+	struct xfs_log_item	*lip)
 {
-	xfs_dquot_t *dqp = logitem->qli_dquot;
+	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
 
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 	atomic_inc(&dqp->q_pincount);
@@ -94,13 +97,12 @@ xfs_qm_dquot_logitem_pin(
  * dquot must have been previously pinned with a call to
  * xfs_qm_dquot_logitem_pin().
  */
-/* ARGSUSED */
 STATIC void
 xfs_qm_dquot_logitem_unpin(
-	xfs_dq_logitem_t	*logitem,
+	struct xfs_log_item	*lip,
 	int			remove)
 {
-	xfs_dquot_t *dqp = logitem->qli_dquot;
+	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
 
 	ASSERT(atomic_read(&dqp->q_pincount) > 0);
 	if (atomic_dec_and_test(&dqp->q_pincount))
@@ -115,12 +117,10 @@ xfs_qm_dquot_logitem_unpin(
  */
 STATIC void
 xfs_qm_dquot_logitem_push(
-	xfs_dq_logitem_t	*logitem)
+	struct xfs_log_item	*lip)
 {
-	xfs_dquot_t	*dqp;
-	int		error;
-
-	dqp = logitem->qli_dquot;
+	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
+	int			error;
 
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 	ASSERT(!completion_done(&dqp->q_flush));
@@ -142,27 +142,25 @@ xfs_qm_dquot_logitem_push(
 	xfs_dqunlock(dqp);
 }
 
-/*ARGSUSED*/
 STATIC xfs_lsn_t
 xfs_qm_dquot_logitem_committed(
-	xfs_dq_logitem_t	*l,
+	struct xfs_log_item	*lip,
 	xfs_lsn_t		lsn)
 {
 	/*
 	 * We always re-log the entire dquot when it becomes dirty,
 	 * so, the latest copy _is_ the only one that matters.
 	 */
-	return (lsn);
+	return lsn;
 }
 
-
 /*
  * This is called to wait for the given dquot to be unpinned.
  * Most of these pin/unpin routines are plagiarized from inode code.
  */
 void
 xfs_qm_dqunpin_wait(
-	xfs_dquot_t	*dqp)
+	struct xfs_dquot	*dqp)
 {
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 	if (atomic_read(&dqp->q_pincount) == 0)
@@ -188,13 +186,12 @@ xfs_qm_dqunpin_wait(
  */
 STATIC void
 xfs_qm_dquot_logitem_pushbuf(
-	xfs_dq_logitem_t    *qip)
+	struct xfs_log_item	*lip)
 {
-	xfs_dquot_t	*dqp;
-	xfs_mount_t	*mp;
-	xfs_buf_t	*bp;
+	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
+	struct xfs_dquot	*dqp = qlip->qli_dquot;
+	struct xfs_buf		*bp;
 
-	dqp = qip->qli_dquot;
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 
 	/*
@@ -202,22 +199,20 @@ xfs_qm_dquot_logitem_pushbuf(
 	 * inode flush completed and the inode was taken off the AIL.
 	 * So, just get out.
 	 */
-	if (completion_done(&dqp->q_flush)  ||
-	    ((qip->qli_item.li_flags & XFS_LI_IN_AIL) == 0)) {
+	if (completion_done(&dqp->q_flush) ||
+	    !(lip->li_flags & XFS_LI_IN_AIL)) {
 		xfs_dqunlock(dqp);
 		return;
 	}
-	mp = dqp->q_mount;
-	bp = xfs_incore(mp->m_ddev_targp, qip->qli_format.qlf_blkno,
-			mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK);
+
+	bp = xfs_incore(dqp->q_mount->m_ddev_targp, qlip->qli_format.qlf_blkno,
+			dqp->q_mount->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK);
 	xfs_dqunlock(dqp);
 	if (!bp)
 		return;
 	if (XFS_BUF_ISDELAYWRITE(bp))
 		xfs_buf_delwri_promote(bp);
 	xfs_buf_relse(bp);
-	return;
-
 }
 
 /*
@@ -232,15 +227,14 @@ xfs_qm_dquot_logitem_pushbuf(
  */
 STATIC uint
 xfs_qm_dquot_logitem_trylock(
-	xfs_dq_logitem_t	*qip)
+	struct xfs_log_item	*lip)
 {
-	xfs_dquot_t		*dqp;
+	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
 
-	dqp = qip->qli_dquot;
 	if (atomic_read(&dqp->q_pincount) > 0)
 		return XFS_ITEM_PINNED;
 
-	if (! xfs_qm_dqlock_nowait(dqp))
+	if (!xfs_qm_dqlock_nowait(dqp))
 		return XFS_ITEM_LOCKED;
 
 	if (!xfs_dqflock_nowait(dqp)) {
@@ -251,11 +245,10 @@ xfs_qm_dquot_logitem_trylock(
 		return XFS_ITEM_PUSHBUF;
 	}
 
-	ASSERT(qip->qli_item.li_flags & XFS_LI_IN_AIL);
+	ASSERT(lip->li_flags & XFS_LI_IN_AIL);
 	return XFS_ITEM_SUCCESS;
 }
 
-
 /*
  * Unlock the dquot associated with the log item.
  * Clear the fields of the dquot and dquot log item that
@@ -264,12 +257,10 @@ xfs_qm_dquot_logitem_trylock(
  */
 STATIC void
 xfs_qm_dquot_logitem_unlock(
-	xfs_dq_logitem_t    *ql)
+	struct xfs_log_item	*lip)
 {
-	xfs_dquot_t	*dqp;
+	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
 
-	ASSERT(ql != NULL);
-	dqp = ql->qli_dquot;
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 
 	/*
@@ -286,41 +277,32 @@ xfs_qm_dquot_logitem_unlock(
 	xfs_dqunlock(dqp);
 }
 
-
 /*
  * this needs to stamp an lsn into the dquot, I think.
  * rpc's that look at user dquot's would then have to
  * push on the dependency recorded in the dquot
  */
-/* ARGSUSED */
 STATIC void
 xfs_qm_dquot_logitem_committing(
-	xfs_dq_logitem_t	*l,
+	struct xfs_log_item	*lip,
 	xfs_lsn_t		lsn)
 {
-	return;
 }
 
-
 /*
  * This is the ops vector for dquots
  */
 static struct xfs_item_ops xfs_dquot_item_ops = {
-	.iop_size	= (uint(*)(xfs_log_item_t*))xfs_qm_dquot_logitem_size,
-	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
-					xfs_qm_dquot_logitem_format,
-	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_qm_dquot_logitem_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t*, int))xfs_qm_dquot_logitem_unpin,
-	.iop_trylock	= (uint(*)(xfs_log_item_t*))
-					xfs_qm_dquot_logitem_trylock,
-	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_qm_dquot_logitem_unlock,
-	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
-					xfs_qm_dquot_logitem_committed,
-	.iop_push	= (void(*)(xfs_log_item_t*))xfs_qm_dquot_logitem_push,
-	.iop_pushbuf	= (void(*)(xfs_log_item_t*))
-					xfs_qm_dquot_logitem_pushbuf,
-	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
-					xfs_qm_dquot_logitem_committing
+	.iop_size	= xfs_qm_dquot_logitem_size,
+	.iop_format	= xfs_qm_dquot_logitem_format,
+	.iop_pin	= xfs_qm_dquot_logitem_pin,
+	.iop_unpin	= xfs_qm_dquot_logitem_unpin,
+	.iop_trylock	= xfs_qm_dquot_logitem_trylock,
+	.iop_unlock	= xfs_qm_dquot_logitem_unlock,
+	.iop_committed	= xfs_qm_dquot_logitem_committed,
+	.iop_push	= xfs_qm_dquot_logitem_push,
+	.iop_pushbuf	= xfs_qm_dquot_logitem_pushbuf,
+	.iop_committing = xfs_qm_dquot_logitem_committing
 };
 
 /*
@@ -330,10 +312,9 @@ static struct xfs_item_ops xfs_dquot_ite
  */
 void
 xfs_qm_dquot_logitem_init(
-	struct xfs_dquot *dqp)
+	struct xfs_dquot	*dqp)
 {
-	xfs_dq_logitem_t  *lp;
-	lp = &dqp->q_logitem;
+	struct xfs_dq_logitem	*lp = &dqp->q_logitem;
 
 	xfs_log_item_init(dqp->q_mount, &lp->qli_item, XFS_LI_DQUOT,
 					&xfs_dquot_item_ops);
@@ -354,16 +335,22 @@ xfs_qm_dquot_logitem_init(
 
 /*------------------  QUOTAOFF LOG ITEMS  -------------------*/
 
+static inline struct xfs_qoff_logitem *QOFF_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_qoff_logitem, qql_item);
+}
+
+
 /*
  * This returns the number of iovecs needed to log the given quotaoff item.
  * We only need 1 iovec for an quotaoff item.  It just logs the
  * quotaoff_log_format structure.
  */
-/*ARGSUSED*/
 STATIC uint
-xfs_qm_qoff_logitem_size(xfs_qoff_logitem_t *qf)
+xfs_qm_qoff_logitem_size(
+	struct xfs_log_item	*lip)
 {
-	return (1);
+	return 1;
 }
 
 /*
@@ -374,46 +361,46 @@ xfs_qm_qoff_logitem_size(xfs_qoff_logite
  * slots in the quotaoff item have been filled.
  */
 STATIC void
-xfs_qm_qoff_logitem_format(xfs_qoff_logitem_t	*qf,
-			   xfs_log_iovec_t	*log_vector)
+xfs_qm_qoff_logitem_format(
+	struct xfs_log_item	*lip,
+	struct xfs_log_iovec	*log_vector)
 {
-	ASSERT(qf->qql_format.qf_type == XFS_LI_QUOTAOFF);
+	struct xfs_qoff_logitem	*qflip = QOFF_ITEM(lip);
 
-	log_vector->i_addr = (xfs_caddr_t)&(qf->qql_format);
+	ASSERT(qflip->qql_format.qf_type == XFS_LI_QUOTAOFF);
+
+	log_vector->i_addr = (xfs_caddr_t)&(qflip->qql_format);
 	log_vector->i_len = sizeof(xfs_qoff_logitem_t);
 	log_vector->i_type = XLOG_REG_TYPE_QUOTAOFF;
-	qf->qql_format.qf_size = 1;
+	qflip->qql_format.qf_size = 1;
 }
 
-
 /*
  * Pinning has no meaning for an quotaoff item, so just return.
  */
-/*ARGSUSED*/
 STATIC void
-xfs_qm_qoff_logitem_pin(xfs_qoff_logitem_t *qf)
+xfs_qm_qoff_logitem_pin(
+	struct xfs_log_item	*lip)
 {
-	return;
 }
 
-
 /*
  * Since pinning has no meaning for an quotaoff item, unpinning does
  * not either.
  */
-/*ARGSUSED*/
 STATIC void
-xfs_qm_qoff_logitem_unpin(xfs_qoff_logitem_t *qf, int remove)
+xfs_qm_qoff_logitem_unpin(
+	struct xfs_log_item	*lip,
+	int			remove)
 {
-	return;
 }
 
 /*
  * Quotaoff items have no locking, so just return success.
  */
-/*ARGSUSED*/
 STATIC uint
-xfs_qm_qoff_logitem_trylock(xfs_qoff_logitem_t *qf)
+xfs_qm_qoff_logitem_trylock(
+	struct xfs_log_item	*lip)
 {
 	return XFS_ITEM_LOCKED;
 }
@@ -422,53 +409,51 @@ xfs_qm_qoff_logitem_trylock(xfs_qoff_log
  * Quotaoff items have no locking or pushing, so return failure
  * so that the caller doesn't bother with us.
  */
-/*ARGSUSED*/
 STATIC void
-xfs_qm_qoff_logitem_unlock(xfs_qoff_logitem_t *qf)
+xfs_qm_qoff_logitem_unlock(
+	struct xfs_log_item	*lip)
 {
-	return;
 }
 
 /*
  * The quotaoff-start-item is logged only once and cannot be moved in the log,
  * so simply return the lsn at which it's been logged.
  */
-/*ARGSUSED*/
 STATIC xfs_lsn_t
-xfs_qm_qoff_logitem_committed(xfs_qoff_logitem_t *qf, xfs_lsn_t lsn)
+xfs_qm_qoff_logitem_committed(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
 {
-	return (lsn);
+	return lsn;
 }
 
 /*
  * There isn't much you can do to push on an quotaoff item.  It is simply
  * stuck waiting for the log to be flushed to disk.
  */
-/*ARGSUSED*/
 STATIC void
-xfs_qm_qoff_logitem_push(xfs_qoff_logitem_t *qf)
+xfs_qm_qoff_logitem_push(
+	struct xfs_log_item	*lip)
 {
-	return;
 }
 
 
-/*ARGSUSED*/
 STATIC xfs_lsn_t
 xfs_qm_qoffend_logitem_committed(
-	xfs_qoff_logitem_t *qfe,
-	xfs_lsn_t lsn)
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
 {
-	xfs_qoff_logitem_t	*qfs;
-	struct xfs_ail		*ailp;
+	struct xfs_qoff_logitem	*qfe = QOFF_ITEM(lip);
+	struct xfs_qoff_logitem	*qfs = qfe->qql_start_lip;
+	struct xfs_ail		*ailp = qfs->qql_item.li_ailp;
 
-	qfs = qfe->qql_start_lip;
-	ailp = qfs->qql_item.li_ailp;
-	spin_lock(&ailp->xa_lock);
 	/*
 	 * Delete the qoff-start logitem from the AIL.
 	 * xfs_trans_ail_delete() drops the AIL lock.
 	 */
+	spin_lock(&ailp->xa_lock);
 	xfs_trans_ail_delete(ailp, (xfs_log_item_t *)qfs);
+
 	kmem_free(qfs);
 	kmem_free(qfe);
 	return (xfs_lsn_t)-1;
@@ -488,67 +473,52 @@ xfs_qm_qoffend_logitem_committed(
  * (truly makes the quotaoff irrevocable).  If we do something else,
  * then maybe we don't need two.
  */
-/* ARGSUSED */
-STATIC void
-xfs_qm_qoff_logitem_committing(xfs_qoff_logitem_t *qip, xfs_lsn_t commit_lsn)
-{
-	return;
-}
-
-/* ARGSUSED */
 STATIC void
-xfs_qm_qoffend_logitem_committing(xfs_qoff_logitem_t *qip, xfs_lsn_t commit_lsn)
+xfs_qm_qoff_logitem_committing(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		commit_lsn)
 {
-	return;
 }
 
 static struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
-	.iop_size	= (uint(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_size,
-	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
-					xfs_qm_qoff_logitem_format,
-	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t*, int))xfs_qm_qoff_logitem_unpin,
-	.iop_trylock	= (uint(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_trylock,
-	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_unlock,
-	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
-					xfs_qm_qoffend_logitem_committed,
-	.iop_push	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_push,
-	.iop_pushbuf	= NULL,
-	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
-					xfs_qm_qoffend_logitem_committing
+	.iop_size	= xfs_qm_qoff_logitem_size,
+	.iop_format	= xfs_qm_qoff_logitem_format,
+	.iop_pin	= xfs_qm_qoff_logitem_pin,
+	.iop_unpin	= xfs_qm_qoff_logitem_unpin,
+	.iop_trylock	= xfs_qm_qoff_logitem_trylock,
+	.iop_unlock	= xfs_qm_qoff_logitem_unlock,
+	.iop_committed	= xfs_qm_qoffend_logitem_committed,
+	.iop_push	= xfs_qm_qoff_logitem_push,
+	.iop_committing = xfs_qm_qoff_logitem_committing
 };
 
 /*
  * This is the ops vector shared by all quotaoff-start log items.
  */
 static struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
-	.iop_size	= (uint(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_size,
-	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
-					xfs_qm_qoff_logitem_format,
-	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t*, int))xfs_qm_qoff_logitem_unpin,
-	.iop_trylock	= (uint(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_trylock,
-	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_unlock,
-	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
-					xfs_qm_qoff_logitem_committed,
-	.iop_push	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_push,
-	.iop_pushbuf	= NULL,
-	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
-					xfs_qm_qoff_logitem_committing
+	.iop_size	= xfs_qm_qoff_logitem_size,
+	.iop_format	= xfs_qm_qoff_logitem_format,
+	.iop_pin	= xfs_qm_qoff_logitem_pin,
+	.iop_unpin	= xfs_qm_qoff_logitem_unpin,
+	.iop_trylock	= xfs_qm_qoff_logitem_trylock,
+	.iop_unlock	= xfs_qm_qoff_logitem_unlock,
+	.iop_committed	= xfs_qm_qoff_logitem_committed,
+	.iop_push	= xfs_qm_qoff_logitem_push,
+	.iop_committing = xfs_qm_qoff_logitem_committing
 };
 
 /*
  * Allocate and initialize an quotaoff item of the correct quota type(s).
  */
-xfs_qoff_logitem_t *
+struct xfs_qoff_logitem *
 xfs_qm_qoff_logitem_init(
-	struct xfs_mount *mp,
-	xfs_qoff_logitem_t *start,
-	uint flags)
+	struct xfs_mount	*mp,
+	struct xfs_qoff_logitem	*start,
+	uint			flags)
 {
-	xfs_qoff_logitem_t	*qf;
+	struct xfs_qoff_logitem	*qf;
 
-	qf = (xfs_qoff_logitem_t*) kmem_zalloc(sizeof(xfs_qoff_logitem_t), KM_SLEEP);
+	qf = kmem_zalloc(sizeof(struct xfs_qoff_logitem), KM_SLEEP);
 
 	xfs_log_item_init(mp, &qf->qql_item, XFS_LI_QUOTAOFF, start ?
 			&xfs_qm_qoffend_logitem_ops : &xfs_qm_qoff_logitem_ops);
@@ -556,5 +526,5 @@ xfs_qm_qoff_logitem_init(
 	qf->qql_format.qf_type = XFS_LI_QUOTAOFF;
 	qf->qql_format.qf_flags = flags;
 	qf->qql_start_lip = start;
-	return (qf);
+	return qf;
 }
Index: xfs/fs/xfs/xfs_extfree_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_extfree_item.c	2010-05-29 18:12:37.767005742 +0200
+++ xfs/fs/xfs/xfs_extfree_item.c	2010-05-29 18:14:21.308004066 +0200
@@ -32,18 +32,19 @@
 kmem_zone_t	*xfs_efi_zone;
 kmem_zone_t	*xfs_efd_zone;
 
-STATIC void	xfs_efi_item_unlock(xfs_efi_log_item_t *);
+static inline struct xfs_efi_log_item *EFI_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_efi_log_item, efi_item);
+}
 
 void
-xfs_efi_item_free(xfs_efi_log_item_t *efip)
+xfs_efi_item_free(
+	struct xfs_efi_log_item	*efip)
 {
-	int nexts = efip->efi_format.efi_nextents;
-
-	if (nexts > XFS_EFI_MAX_FAST_EXTENTS) {
+	if (efip->efi_format.efi_nextents > XFS_EFI_MAX_FAST_EXTENTS)
 		kmem_free(efip);
-	} else {
+	else
 		kmem_zone_free(xfs_efi_zone, efip);
-	}
 }
 
 /*
@@ -51,9 +52,9 @@ xfs_efi_item_free(xfs_efi_log_item_t *ef
  * We only need 1 iovec for an efi item.  It just logs the efi_log_format
  * structure.
  */
-/*ARGSUSED*/
 STATIC uint
-xfs_efi_item_size(xfs_efi_log_item_t *efip)
+xfs_efi_item_size(
+	struct xfs_log_item	*lip)
 {
 	return 1;
 }
@@ -66,10 +67,12 @@ xfs_efi_item_size(xfs_efi_log_item_t *ef
  * slots in the efi item have been filled.
  */
 STATIC void
-xfs_efi_item_format(xfs_efi_log_item_t	*efip,
-		    xfs_log_iovec_t	*log_vector)
+xfs_efi_item_format(
+	struct xfs_log_item	*lip,
+	struct xfs_log_iovec	*log_vector)
 {
-	uint	size;
+	struct xfs_efi_log_item	*efip = EFI_ITEM(lip);
+	uint			size;
 
 	ASSERT(efip->efi_next_extent == efip->efi_format.efi_nextents);
 
@@ -79,7 +82,7 @@ xfs_efi_item_format(xfs_efi_log_item_t	*
 	size += (efip->efi_format.efi_nextents - 1) * sizeof(xfs_extent_t);
 	efip->efi_format.efi_size = 1;
 
-	log_vector->i_addr = (xfs_caddr_t)&(efip->efi_format);
+	log_vector->i_addr = (xfs_caddr_t)&efip->efi_format;
 	log_vector->i_len = size;
 	log_vector->i_type = XLOG_REG_TYPE_EFI_FORMAT;
 	ASSERT(size >= sizeof(xfs_efi_log_format_t));
@@ -89,14 +92,12 @@ xfs_efi_item_format(xfs_efi_log_item_t	*
 /*
  * Pinning has no meaning for an efi item, so just return.
  */
-/*ARGSUSED*/
 STATIC void
-xfs_efi_item_pin(xfs_efi_log_item_t *efip)
+xfs_efi_item_pin(
+	struct xfs_log_item	*lip)
 {
-	return;
 }
 
-
 /*
  * While EFIs cannot really be pinned, the unpin operation is the
  * last place at which the EFI is manipulated during a transaction.
@@ -104,14 +105,15 @@ xfs_efi_item_pin(xfs_efi_log_item_t *efi
  * free the EFI.
  */
 STATIC void
-xfs_efi_item_unpin(xfs_efi_log_item_t *efip, int remove)
+xfs_efi_item_unpin(
+	struct xfs_log_item	*lip,
+	int			remove)
 {
-	struct xfs_ail		*ailp = efip->efi_item.li_ailp;
+	struct xfs_efi_log_item	*efip = EFI_ITEM(lip);
+	struct xfs_ail		*ailp = lip->li_ailp;
 
 	spin_lock(&ailp->xa_lock);
 	if (efip->efi_flags & XFS_EFI_CANCELED) {
-		struct xfs_log_item	*lip = &efip->efi_item;
-
 		if (remove)
 			xfs_trans_del_item(lip);
 
@@ -131,9 +133,9 @@ xfs_efi_item_unpin(xfs_efi_log_item_t *e
  * XFS_ITEM_PINNED so that the caller will eventually flush the log.
  * This should help in getting the EFI out of the AIL.
  */
-/*ARGSUSED*/
 STATIC uint
-xfs_efi_item_trylock(xfs_efi_log_item_t *efip)
+xfs_efi_item_trylock(
+	struct xfs_log_item	*lip)
 {
 	return XFS_ITEM_PINNED;
 }
@@ -141,13 +143,12 @@ xfs_efi_item_trylock(xfs_efi_log_item_t
 /*
  * Efi items have no locking, so just return.
  */
-/*ARGSUSED*/
 STATIC void
-xfs_efi_item_unlock(xfs_efi_log_item_t *efip)
+xfs_efi_item_unlock(
+	struct xfs_log_item	*lip)
 {
-	if (efip->efi_item.li_flags & XFS_LI_ABORTED)
-		xfs_efi_item_free(efip);
-	return;
+	if (lip->li_flags & XFS_LI_ABORTED)
+		xfs_efi_item_free(EFI_ITEM(lip));
 }
 
 /*
@@ -156,9 +157,10 @@ xfs_efi_item_unlock(xfs_efi_log_item_t *
  * flag is not paid any attention here.  Checking for that is delayed
  * until the EFI is unpinned.
  */
-/*ARGSUSED*/
 STATIC xfs_lsn_t
-xfs_efi_item_committed(xfs_efi_log_item_t *efip, xfs_lsn_t lsn)
+xfs_efi_item_committed(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
 {
 	return lsn;
 }
@@ -168,11 +170,10 @@ xfs_efi_item_committed(xfs_efi_log_item_
  * stuck waiting for all of its corresponding efd items to be
  * committed to disk.
  */
-/*ARGSUSED*/
 STATIC void
-xfs_efi_item_push(xfs_efi_log_item_t *efip)
+xfs_efi_item_push(
+	struct xfs_log_item	*lip)
 {
-	return;
 }
 
 /*
@@ -182,59 +183,55 @@ xfs_efi_item_push(xfs_efi_log_item_t *ef
  * example, for inodes, the inode is locked throughout the extent freeing
  * so the dependency should be recorded there.
  */
-/*ARGSUSED*/
 STATIC void
-xfs_efi_item_committing(xfs_efi_log_item_t *efip, xfs_lsn_t lsn)
+xfs_efi_item_committing(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
 {
-	return;
 }
 
 /*
  * This is the ops vector shared by all efi log items.
  */
 static struct xfs_item_ops xfs_efi_item_ops = {
-	.iop_size	= (uint(*)(xfs_log_item_t*))xfs_efi_item_size,
-	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
-					xfs_efi_item_format,
-	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_efi_item_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t*, int))xfs_efi_item_unpin,
-	.iop_trylock	= (uint(*)(xfs_log_item_t*))xfs_efi_item_trylock,
-	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_efi_item_unlock,
-	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
-					xfs_efi_item_committed,
-	.iop_push	= (void(*)(xfs_log_item_t*))xfs_efi_item_push,
-	.iop_pushbuf	= NULL,
-	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
-					xfs_efi_item_committing
+	.iop_size	= xfs_efi_item_size,
+	.iop_format	= xfs_efi_item_format,
+	.iop_pin	= xfs_efi_item_pin,
+	.iop_unpin	= xfs_efi_item_unpin,
+	.iop_trylock	= xfs_efi_item_trylock,
+	.iop_unlock	= xfs_efi_item_unlock,
+	.iop_committed	= xfs_efi_item_committed,
+	.iop_push	= xfs_efi_item_push,
+	.iop_committing = xfs_efi_item_committing
 };
 
 
 /*
  * Allocate and initialize an efi item with the given number of extents.
  */
-xfs_efi_log_item_t *
-xfs_efi_init(xfs_mount_t	*mp,
-	     uint		nextents)
+struct xfs_efi_log_item *
+xfs_efi_init(
+	struct xfs_mount	*mp,
+	uint			nextents)
 
 {
-	xfs_efi_log_item_t	*efip;
+	struct xfs_efi_log_item	*efip;
 	uint			size;
 
 	ASSERT(nextents > 0);
 	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
 		size = (uint)(sizeof(xfs_efi_log_item_t) +
 			((nextents - 1) * sizeof(xfs_extent_t)));
-		efip = (xfs_efi_log_item_t*)kmem_zalloc(size, KM_SLEEP);
+		efip = kmem_zalloc(size, KM_SLEEP);
 	} else {
-		efip = (xfs_efi_log_item_t*)kmem_zone_zalloc(xfs_efi_zone,
-							     KM_SLEEP);
+		efip = kmem_zone_zalloc(xfs_efi_zone, KM_SLEEP);
 	}
 
 	xfs_log_item_init(mp, &efip->efi_item, XFS_LI_EFI, &xfs_efi_item_ops);
 	efip->efi_format.efi_nextents = nextents;
 	efip->efi_format.efi_id = (__psint_t)(void*)efip;
 
-	return (efip);
+	return efip;
 }
 
 /*
@@ -327,16 +324,18 @@ xfs_efi_release(xfs_efi_log_item_t	*efip
 	}
 }
 
-STATIC void
-xfs_efd_item_free(xfs_efd_log_item_t *efdp)
+static inline struct xfs_efd_log_item *EFD_ITEM(struct xfs_log_item *lip)
 {
-	int nexts = efdp->efd_format.efd_nextents;
+	return container_of(lip, struct xfs_efd_log_item, efd_item);
+}
 
-	if (nexts > XFS_EFD_MAX_FAST_EXTENTS) {
+STATIC void
+xfs_efd_item_free(struct xfs_efd_log_item *efdp)
+{
+	if (efdp->efd_format.efd_nextents > XFS_EFD_MAX_FAST_EXTENTS)
 		kmem_free(efdp);
-	} else {
+	else
 		kmem_zone_free(xfs_efd_zone, efdp);
-	}
 }
 
 /*
@@ -344,9 +343,9 @@ xfs_efd_item_free(xfs_efd_log_item_t *ef
  * We only need 1 iovec for an efd item.  It just logs the efd_log_format
  * structure.
  */
-/*ARGSUSED*/
 STATIC uint
-xfs_efd_item_size(xfs_efd_log_item_t *efdp)
+xfs_efd_item_size(
+	struct xfs_log_item	*lip)
 {
 	return 1;
 }
@@ -359,10 +358,12 @@ xfs_efd_item_size(xfs_efd_log_item_t *ef
  * slots in the efd item have been filled.
  */
 STATIC void
-xfs_efd_item_format(xfs_efd_log_item_t	*efdp,
-		    xfs_log_iovec_t	*log_vector)
+xfs_efd_item_format(
+	struct xfs_log_item	*lip,
+	struct xfs_log_iovec	*log_vector)
 {
-	uint	size;
+	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
+	uint			size;
 
 	ASSERT(efdp->efd_next_extent == efdp->efd_format.efd_nextents);
 
@@ -372,41 +373,38 @@ xfs_efd_item_format(xfs_efd_log_item_t	*
 	size += (efdp->efd_format.efd_nextents - 1) * sizeof(xfs_extent_t);
 	efdp->efd_format.efd_size = 1;
 
-	log_vector->i_addr = (xfs_caddr_t)&(efdp->efd_format);
+	log_vector->i_addr = (xfs_caddr_t)&efdp->efd_format;
 	log_vector->i_len = size;
 	log_vector->i_type = XLOG_REG_TYPE_EFD_FORMAT;
 	ASSERT(size >= sizeof(xfs_efd_log_format_t));
 }
 
-
 /*
  * Pinning has no meaning for an efd item, so just return.
  */
-/*ARGSUSED*/
 STATIC void
-xfs_efd_item_pin(xfs_efd_log_item_t *efdp)
+xfs_efd_item_pin(
+	struct xfs_log_item	*lip)
 {
-	return;
 }
 
-
 /*
  * Since pinning has no meaning for an efd item, unpinning does
  * not either.
  */
-/*ARGSUSED*/
 STATIC void
-xfs_efd_item_unpin(xfs_efd_log_item_t *efdp, int remove)
+xfs_efd_item_unpin(
+	struct xfs_log_item	*lip,
+	int			remove)
 {
-	return;
 }
 
 /*
  * Efd items have no locking, so just return success.
  */
-/*ARGSUSED*/
 STATIC uint
-xfs_efd_item_trylock(xfs_efd_log_item_t *efdp)
+xfs_efd_item_trylock(
+	struct xfs_log_item	*lip)
 {
 	return XFS_ITEM_LOCKED;
 }
@@ -415,13 +413,12 @@ xfs_efd_item_trylock(xfs_efd_log_item_t
  * Efd items have no locking or pushing, so return failure
  * so that the caller doesn't bother with us.
  */
-/*ARGSUSED*/
 STATIC void
-xfs_efd_item_unlock(xfs_efd_log_item_t *efdp)
+xfs_efd_item_unlock(
+	struct xfs_log_item	*lip)
 {
-	if (efdp->efd_item.li_flags & XFS_LI_ABORTED)
-		xfs_efd_item_free(efdp);
-	return;
+	if (lip->li_flags & XFS_LI_ABORTED)
+		xfs_efd_item_free(EFD_ITEM(lip));
 }
 
 /*
@@ -431,15 +428,18 @@ xfs_efd_item_unlock(xfs_efd_log_item_t *
  * return -1 to keep the transaction code from further referencing
  * this item.
  */
-/*ARGSUSED*/
 STATIC xfs_lsn_t
-xfs_efd_item_committed(xfs_efd_log_item_t *efdp, xfs_lsn_t lsn)
+xfs_efd_item_committed(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
 {
+	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
+
 	/*
 	 * If we got a log I/O error, it's always the case that the LR with the
 	 * EFI got unpinned and freed before the EFD got aborted.
 	 */
-	if ((efdp->efd_item.li_flags & XFS_LI_ABORTED) == 0)
+	if (!(lip->li_flags & XFS_LI_ABORTED))
 		xfs_efi_release(efdp->efd_efip, efdp->efd_format.efd_nextents);
 
 	xfs_efd_item_free(efdp);
@@ -450,11 +450,10 @@ xfs_efd_item_committed(xfs_efd_log_item_
  * There isn't much you can do to push on an efd item.  It is simply
  * stuck waiting for the log to be flushed to disk.
  */
-/*ARGSUSED*/
 STATIC void
-xfs_efd_item_push(xfs_efd_log_item_t *efdp)
+xfs_efd_item_push(
+	struct xfs_log_item	*lip)
 {
-	return;
 }
 
 /*
@@ -464,53 +463,48 @@ xfs_efd_item_push(xfs_efd_log_item_t *ef
  * example, for inodes, the inode is locked throughout the extent freeing
  * so the dependency should be recorded there.
  */
-/*ARGSUSED*/
 STATIC void
-xfs_efd_item_committing(xfs_efd_log_item_t *efip, xfs_lsn_t lsn)
+xfs_efd_item_committing(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn)
 {
-	return;
 }
 
 /*
  * This is the ops vector shared by all efd log items.
  */
 static struct xfs_item_ops xfs_efd_item_ops = {
-	.iop_size	= (uint(*)(xfs_log_item_t*))xfs_efd_item_size,
-	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
-					xfs_efd_item_format,
-	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_efd_item_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t*, int))xfs_efd_item_unpin,
-	.iop_trylock	= (uint(*)(xfs_log_item_t*))xfs_efd_item_trylock,
-	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_efd_item_unlock,
-	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
-					xfs_efd_item_committed,
-	.iop_push	= (void(*)(xfs_log_item_t*))xfs_efd_item_push,
-	.iop_pushbuf	= NULL,
-	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
-					xfs_efd_item_committing
+	.iop_size	= xfs_efd_item_size,
+	.iop_format	= xfs_efd_item_format,
+	.iop_pin	= xfs_efd_item_pin,
+	.iop_unpin	= xfs_efd_item_unpin,
+	.iop_trylock	= xfs_efd_item_trylock,
+	.iop_unlock	= xfs_efd_item_unlock,
+	.iop_committed	= xfs_efd_item_committed,
+	.iop_push	= xfs_efd_item_push,
+	.iop_committing = xfs_efd_item_committing
 };
 
-
 /*
  * Allocate and initialize an efd item with the given number of extents.
  */
-xfs_efd_log_item_t *
-xfs_efd_init(xfs_mount_t	*mp,
-	     xfs_efi_log_item_t	*efip,
-	     uint		nextents)
+struct xfs_efd_log_item *
+xfs_efd_init(
+	struct xfs_mount	*mp,
+	struct xfs_efi_log_item	*efip,
+	uint			nextents)
 
 {
-	xfs_efd_log_item_t	*efdp;
+	struct xfs_efd_log_item	*efdp;
 	uint			size;
 
 	ASSERT(nextents > 0);
 	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
 		size = (uint)(sizeof(xfs_efd_log_item_t) +
 			((nextents - 1) * sizeof(xfs_extent_t)));
-		efdp = (xfs_efd_log_item_t*)kmem_zalloc(size, KM_SLEEP);
+		efdp = kmem_zalloc(size, KM_SLEEP);
 	} else {
-		efdp = (xfs_efd_log_item_t*)kmem_zone_zalloc(xfs_efd_zone,
-							     KM_SLEEP);
+		efdp = kmem_zone_zalloc(xfs_efd_zone, KM_SLEEP);
 	}
 
 	xfs_log_item_init(mp, &efdp->efd_item, XFS_LI_EFD, &xfs_efd_item_ops);
@@ -518,5 +512,5 @@ xfs_efd_init(xfs_mount_t	*mp,
 	efdp->efd_format.efd_nextents = nextents;
 	efdp->efd_format.efd_efi_id = efip->efi_format.efi_id;
 
-	return (efdp);
+	return efdp;
 }
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2010-05-29 18:12:37.772005254 +0200
+++ xfs/fs/xfs/xfs_inode_item.c	2010-05-29 18:14:21.313003857 +0200
@@ -36,6 +36,12 @@
 
 kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
 
+static inline struct xfs_inode_log_item *INODE_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_inode_log_item, ili_item);
+}
+
+
 /*
  * This returns the number of iovecs needed to log the given inode item.
  *
@@ -45,13 +51,11 @@ kmem_zone_t	*xfs_ili_zone;		/* inode log
  */
 STATIC uint
 xfs_inode_item_size(
-	xfs_inode_log_item_t	*iip)
+	struct xfs_log_item	*lip)
 {
-	uint		nvecs;
-	xfs_inode_t	*ip;
-
-	ip = iip->ili_inode;
-	nvecs = 2;
+	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+	struct xfs_inode	*ip = iip->ili_inode;
+	uint			nvecs = 2;
 
 	/*
 	 * Only log the data/extents/b-tree root if there is something
@@ -202,20 +206,17 @@ xfs_inode_item_size(
  */
 STATIC void
 xfs_inode_item_format(
-	xfs_inode_log_item_t	*iip,
-	xfs_log_iovec_t		*log_vector)
+	struct xfs_log_item	*lip,
+	struct xfs_log_iovec	*vecp)
 {
+	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+	struct xfs_inode	*ip = iip->ili_inode;
 	uint			nvecs;
-	xfs_log_iovec_t		*vecp;
-	xfs_inode_t		*ip;
 	size_t			data_bytes;
 	xfs_bmbt_rec_t		*ext_buffer;
 	int			nrecs;
 	xfs_mount_t		*mp;
 
-	ip = iip->ili_inode;
-	vecp = log_vector;
-
 	vecp->i_addr = (xfs_caddr_t)&iip->ili_format;
 	vecp->i_len  = sizeof(xfs_inode_log_format_t);
 	vecp->i_type = XLOG_REG_TYPE_IFORMAT;
@@ -427,7 +428,7 @@ xfs_inode_item_format(
 	 * Assert that no attribute-related log flags are set.
 	 */
 	if (!XFS_IFORK_Q(ip)) {
-		ASSERT(nvecs == iip->ili_item.li_desc->lid_size);
+		ASSERT(nvecs == lip->li_desc->lid_size);
 		iip->ili_format.ilf_size = nvecs;
 		ASSERT(!(iip->ili_format.ilf_fields &
 			 (XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AEXT)));
@@ -518,7 +519,7 @@ xfs_inode_item_format(
 		break;
 	}
 
-	ASSERT(nvecs == iip->ili_item.li_desc->lid_size);
+	ASSERT(nvecs == lip->li_desc->lid_size);
 	iip->ili_format.ilf_size = nvecs;
 }
 
@@ -529,12 +530,14 @@ xfs_inode_item_format(
  */
 STATIC void
 xfs_inode_item_pin(
-	xfs_inode_log_item_t	*iip)
+	struct xfs_log_item	*lip)
 {
-	ASSERT(xfs_isilocked(iip->ili_inode, XFS_ILOCK_EXCL));
+	struct xfs_inode	*ip = INODE_ITEM(lip)->ili_inode;
 
-	trace_xfs_inode_pin(iip->ili_inode, _RET_IP_);
-	atomic_inc(&iip->ili_inode->i_pincount);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	trace_xfs_inode_pin(ip, _RET_IP_);
+	atomic_inc(&ip->i_pincount);
 }
 
 
@@ -546,10 +549,10 @@ xfs_inode_item_pin(
  */
 STATIC void
 xfs_inode_item_unpin(
-	xfs_inode_log_item_t	*iip,
+	struct xfs_log_item	*lip,
 	int			remove)
 {
-	struct xfs_inode	*ip = iip->ili_inode;
+	struct xfs_inode	*ip = INODE_ITEM(lip)->ili_inode;
 
 	trace_xfs_inode_unpin(ip, _RET_IP_);
 	ASSERT(atomic_read(&ip->i_pincount) > 0);
@@ -572,19 +575,16 @@ xfs_inode_item_unpin(
  */
 STATIC uint
 xfs_inode_item_trylock(
-	xfs_inode_log_item_t	*iip)
+	struct xfs_log_item	*lip)
 {
-	register xfs_inode_t	*ip;
-
-	ip = iip->ili_inode;
+	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+	struct xfs_inode	*ip = iip->ili_inode;
 
-	if (xfs_ipincount(ip) > 0) {
+	if (xfs_ipincount(ip) > 0)
 		return XFS_ITEM_PINNED;
-	}
 
-	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
+	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
 		return XFS_ITEM_LOCKED;
-	}
 
 	if (!xfs_iflock_nowait(ip)) {
 		/*
@@ -610,7 +610,7 @@ xfs_inode_item_trylock(
 	if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		ASSERT(iip->ili_format.ilf_fields != 0);
 		ASSERT(iip->ili_logged == 0);
-		ASSERT(iip->ili_item.li_flags & XFS_LI_IN_AIL);
+		ASSERT(lip->li_flags & XFS_LI_IN_AIL);
 	}
 #endif
 	return XFS_ITEM_SUCCESS;
@@ -624,12 +624,13 @@ xfs_inode_item_trylock(
  */
 STATIC void
 xfs_inode_item_unlock(
-	xfs_inode_log_item_t	*iip)
+	struct xfs_log_item	*lip)
 {
-	uint		hold;
-	uint		iolocked;
-	uint		lock_flags;
-	xfs_inode_t	*ip;
+	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+	struct xfs_inode	*ip = iip->ili_inode;
+	uint			hold;
+	uint			iolocked;
+	uint			lock_flags;
 
 	ASSERT(iip != NULL);
 	ASSERT(iip->ili_inode->i_itemp != NULL);
@@ -640,10 +641,10 @@ xfs_inode_item_unlock(
 	ASSERT((!(iip->ili_inode->i_itemp->ili_flags &
 		  XFS_ILI_IOLOCKED_SHARED)) ||
 	       xfs_isilocked(iip->ili_inode, XFS_IOLOCK_SHARED));
+
 	/*
 	 * Clear the transaction pointer in the inode.
 	 */
-	ip = iip->ili_inode;
 	ip->i_transp = NULL;
 
 	/*
@@ -706,13 +707,12 @@ xfs_inode_item_unlock(
  * is the only one that matters.  Therefore, simply return the
  * given lsn.
  */
-/*ARGSUSED*/
 STATIC xfs_lsn_t
 xfs_inode_item_committed(
-	xfs_inode_log_item_t	*iip,
+	struct xfs_log_item	*lip,
 	xfs_lsn_t		lsn)
 {
-	return (lsn);
+	return lsn;
 }
 
 /*
@@ -724,13 +724,12 @@ xfs_inode_item_committed(
  */
 STATIC void
 xfs_inode_item_pushbuf(
-	xfs_inode_log_item_t	*iip)
+	struct xfs_log_item	*lip)
 {
-	xfs_inode_t	*ip;
-	xfs_mount_t	*mp;
-	xfs_buf_t	*bp;
+	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+	struct xfs_inode	*ip = iip->ili_inode;
+	struct xfs_buf		*bp;
 
-	ip = iip->ili_inode;
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED));
 
 	/*
@@ -738,14 +737,13 @@ xfs_inode_item_pushbuf(
 	 * inode was taken off the AIL. So, just get out.
 	 */
 	if (completion_done(&ip->i_flush) ||
-	    ((iip->ili_item.li_flags & XFS_LI_IN_AIL) == 0)) {
+	    !(lip->li_flags & XFS_LI_IN_AIL)) {
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 		return;
 	}
 
-	mp = ip->i_mount;
-	bp = xfs_incore(mp->m_ddev_targp, iip->ili_format.ilf_blkno,
-		    iip->ili_format.ilf_len, XBF_TRYLOCK);
+	bp = xfs_incore(ip->i_mount->m_ddev_targp, iip->ili_format.ilf_blkno,
+			iip->ili_format.ilf_len, XBF_TRYLOCK);
 
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	if (!bp)
@@ -753,10 +751,8 @@ xfs_inode_item_pushbuf(
 	if (XFS_BUF_ISDELAYWRITE(bp))
 		xfs_buf_delwri_promote(bp);
 	xfs_buf_relse(bp);
-	return;
 }
 
-
 /*
  * This is called to asynchronously write the inode associated with this
  * inode log item out to disk. The inode will already have been locked by
@@ -764,14 +760,14 @@ xfs_inode_item_pushbuf(
  */
 STATIC void
 xfs_inode_item_push(
-	xfs_inode_log_item_t	*iip)
+	struct xfs_log_item	*lip)
 {
-	xfs_inode_t	*ip;
-
-	ip = iip->ili_inode;
+	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+	struct xfs_inode	*ip = iip->ili_inode;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED));
 	ASSERT(!completion_done(&ip->i_flush));
+
 	/*
 	 * Since we were able to lock the inode's flush lock and
 	 * we found it on the AIL, the inode must be dirty.  This
@@ -794,41 +790,34 @@ xfs_inode_item_push(
 	 */
 	(void) xfs_iflush(ip, 0);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-	return;
 }
 
 /*
  * XXX rcc - this one really has to do something.  Probably needs
  * to stamp in a new field in the incore inode.
  */
-/* ARGSUSED */
 STATIC void
 xfs_inode_item_committing(
-	xfs_inode_log_item_t	*iip,
+	struct xfs_log_item	*lip,
 	xfs_lsn_t		lsn)
 {
-	iip->ili_last_lsn = lsn;
-	return;
+	INODE_ITEM(lip)->ili_last_lsn = lsn;
 }
 
 /*
  * This is the ops vector shared by all buf log items.
  */
 static struct xfs_item_ops xfs_inode_item_ops = {
-	.iop_size	= (uint(*)(xfs_log_item_t*))xfs_inode_item_size,
-	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
-					xfs_inode_item_format,
-	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_inode_item_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t*, int))xfs_inode_item_unpin,
-	.iop_trylock	= (uint(*)(xfs_log_item_t*))xfs_inode_item_trylock,
-	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_inode_item_unlock,
-	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
-					xfs_inode_item_committed,
-	.iop_push	= (void(*)(xfs_log_item_t*))xfs_inode_item_push,
-	.iop_pushbuf	= (void(*)(xfs_log_item_t*))xfs_inode_item_pushbuf,
-	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
-					xfs_inode_item_committing
+	.iop_size	= xfs_inode_item_size,
+	.iop_format	= xfs_inode_item_format,
+	.iop_pin	= xfs_inode_item_pin,
+	.iop_unpin	= xfs_inode_item_unpin,
+	.iop_trylock	= xfs_inode_item_trylock,
+	.iop_unlock	= xfs_inode_item_unlock,
+	.iop_committed	= xfs_inode_item_committed,
+	.iop_push	= xfs_inode_item_push,
+	.iop_pushbuf	= xfs_inode_item_pushbuf,
+	.iop_committing = xfs_inode_item_committing
 };
 
 
@@ -837,10 +826,10 @@ static struct xfs_item_ops xfs_inode_ite
  */
 void
 xfs_inode_item_init(
-	xfs_inode_t	*ip,
-	xfs_mount_t	*mp)
+	struct xfs_inode	*ip,
+	struct xfs_mount	*mp)
 {
-	xfs_inode_log_item_t	*iip;
+	struct xfs_inode_log_item *iip;
 
 	ASSERT(ip->i_itemp == NULL);
 	iip = ip->i_itemp = kmem_zone_zalloc(xfs_ili_zone, KM_SLEEP);
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2010-05-29 18:12:37.760004276 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2010-05-29 18:14:21.317046949 +0200
@@ -33,6 +33,12 @@
 
 kmem_zone_t	*xfs_buf_item_zone;
 
+static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_buf_log_item, bli_item);
+}
+
+
 #ifdef XFS_TRANS_DEBUG
 /*
  * This function uses an alternate strategy for tracking the bytes
@@ -150,12 +156,13 @@ STATIC void	xfs_buf_do_callbacks(xfs_buf
  */
 STATIC uint
 xfs_buf_item_size(
-	xfs_buf_log_item_t	*bip)
+	struct xfs_log_item	*lip)
 {
-	uint		nvecs;
-	int		next_bit;
-	int		last_bit;
-	xfs_buf_t	*bp;
+	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
+	struct xfs_buf		*bp = bip->bli_buf;
+	uint			nvecs;
+	int			next_bit;
+	int			last_bit;
 
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	if (bip->bli_flags & XFS_BLI_STALE) {
@@ -169,7 +176,6 @@ xfs_buf_item_size(
 		return 1;
 	}
 
-	bp = bip->bli_buf;
 	ASSERT(bip->bli_flags & XFS_BLI_LOGGED);
 	nvecs = 1;
 	last_bit = xfs_next_bit(bip->bli_format.blf_data_map,
@@ -218,13 +224,13 @@ xfs_buf_item_size(
  */
 STATIC void
 xfs_buf_item_format(
-	xfs_buf_log_item_t	*bip,
-	xfs_log_iovec_t		*log_vector)
+	struct xfs_log_item	*lip,
+	struct xfs_log_iovec	*vecp)
 {
+	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
+	struct xfs_buf	*bp = bip->bli_buf;
 	uint		base_size;
 	uint		nvecs;
-	xfs_log_iovec_t	*vecp;
-	xfs_buf_t	*bp;
 	int		first_bit;
 	int		last_bit;
 	int		next_bit;
@@ -234,8 +240,6 @@ xfs_buf_item_format(
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
 	       (bip->bli_flags & XFS_BLI_STALE));
-	bp = bip->bli_buf;
-	vecp = log_vector;
 
 	/*
 	 * The size of the base structure is the size of the
@@ -262,7 +266,7 @@ xfs_buf_item_format(
 	 */
 	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
 		if (!((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
-		      xfs_log_item_in_current_chkpt(&bip->bli_item)))
+		      xfs_log_item_in_current_chkpt(lip)))
 			bip->bli_format.blf_flags |= XFS_BLF_INODE_BUF;
 		bip->bli_flags &= ~XFS_BLI_INODE_BUF;
 	}
@@ -365,21 +369,20 @@ xfs_buf_item_format(
 
 STATIC void
 xfs_buf_item_pin(
-	xfs_buf_log_item_t	*bip)
+	struct xfs_log_item	*lip)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 
-	bp = bip->bli_buf;
-	ASSERT(XFS_BUF_ISBUSY(bp));
+	ASSERT(XFS_BUF_ISBUSY(bip->bli_buf));
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
 	       (bip->bli_flags & XFS_BLI_STALE));
+
 	atomic_inc(&bip->bli_refcount);
 	trace_xfs_buf_item_pin(bip);
-	xfs_bpin(bp);
+	xfs_bpin(bip->bli_buf);
 }
 
-
 /*
  * This is called to unpin the buffer associated with the buf log
  * item which was previously pinned with a call to xfs_buf_item_pin().
@@ -396,13 +399,14 @@ xfs_buf_item_pin(
  */
 STATIC void
 xfs_buf_item_unpin(
-	xfs_buf_log_item_t	*bip,
+	struct xfs_log_item	*lip,
 	int			remove)
 {
-	struct xfs_ail	*ailp;
+	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	xfs_buf_t	*bp = bip->bli_buf;
-	int		freed;
+	struct xfs_ail	*ailp = lip->li_ailp;
 	int		stale = bip->bli_flags & XFS_BLI_STALE;
+	int		freed;
 
 	ASSERT(XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *) == bip);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
@@ -410,8 +414,8 @@ xfs_buf_item_unpin(
 	trace_xfs_buf_item_unpin(bip);
 
 	freed = atomic_dec_and_test(&bip->bli_refcount);
-	ailp = bip->bli_item.li_ailp;
 	xfs_bunpin(bp);
+
 	if (freed && stale) {
 		ASSERT(bip->bli_flags & XFS_BLI_STALE);
 		ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
@@ -429,7 +433,7 @@ xfs_buf_item_unpin(
 			 * in xfs_trans_uncommit() will ry to reference the
 			 * buffer which we no longer have a hold on.
 			 */
-			xfs_trans_del_item(&bip->bli_item);
+			xfs_trans_del_item(lip);
 
 			/*
 			 * Since the transaction no longer refers to the buffer,
@@ -468,11 +472,11 @@ xfs_buf_item_unpin(
  */
 STATIC uint
 xfs_buf_item_trylock(
-	xfs_buf_log_item_t	*bip)
+	struct xfs_log_item	*lip)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
+	struct xfs_buf		*bp = bip->bli_buf;
 
-	bp = bip->bli_buf;
 	if (XFS_BUF_ISPINNED(bp))
 		return XFS_ITEM_PINNED;
 	if (!XFS_BUF_CPSEMA(bp))
@@ -509,13 +513,12 @@ xfs_buf_item_trylock(
  */
 STATIC void
 xfs_buf_item_unlock(
-	xfs_buf_log_item_t	*bip)
+	struct xfs_log_item	*lip)
 {
-	int		aborted;
-	xfs_buf_t	*bp;
-	uint		hold;
-
-	bp = bip->bli_buf;
+	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
+	struct xfs_buf		*bp = bip->bli_buf;
+	int			aborted;
+	uint			hold;
 
 	/* Clear the buffer's association with this transaction. */
 	XFS_BUF_SET_FSPRIVATE2(bp, NULL);
@@ -526,7 +529,7 @@ xfs_buf_item_unlock(
 	 * (cancelled) buffers at unpin time, but we'll never go through the
 	 * pin/unpin cycle if we abort inside commit.
 	 */
-	aborted = (bip->bli_item.li_flags & XFS_LI_ABORTED) != 0;
+	aborted = (lip->li_flags & XFS_LI_ABORTED) != 0;
 
 	/*
 	 * Before possibly freeing the buf item, determine if we should
@@ -587,16 +590,16 @@ xfs_buf_item_unlock(
  */
 STATIC xfs_lsn_t
 xfs_buf_item_committed(
-	xfs_buf_log_item_t	*bip,
+	struct xfs_log_item	*lip,
 	xfs_lsn_t		lsn)
 {
+	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
+
 	trace_xfs_buf_item_committed(bip);
 
-	if ((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
-	    (bip->bli_item.li_lsn != 0)) {
-		return bip->bli_item.li_lsn;
-	}
-	return (lsn);
+	if ((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) && lip->li_lsn != 0)
+		return lip->li_lsn;
+	return lsn;
 }
 
 /*
@@ -606,15 +609,16 @@ xfs_buf_item_committed(
  */
 STATIC void
 xfs_buf_item_push(
-	xfs_buf_log_item_t	*bip)
+	struct xfs_log_item	*lip)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
+	struct xfs_buf		*bp = bip->bli_buf;
 
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
+	ASSERT(!XFS_BUF_ISDELAYWRITE(bp));
+
 	trace_xfs_buf_item_push(bip);
 
-	bp = bip->bli_buf;
-	ASSERT(!XFS_BUF_ISDELAYWRITE(bp));
 	xfs_buf_relse(bp);
 }
 
@@ -626,22 +630,24 @@ xfs_buf_item_push(
  */
 STATIC void
 xfs_buf_item_pushbuf(
-	xfs_buf_log_item_t	*bip)
+	struct xfs_log_item	*lip)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
+	struct xfs_buf		*bp = bip->bli_buf;
 
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
+	ASSERT(XFS_BUF_ISDELAYWRITE(bp));
+
 	trace_xfs_buf_item_pushbuf(bip);
 
-	bp = bip->bli_buf;
-	ASSERT(XFS_BUF_ISDELAYWRITE(bp));
 	xfs_buf_delwri_promote(bp);
 	xfs_buf_relse(bp);
 }
 
-/* ARGSUSED */
 STATIC void
-xfs_buf_item_committing(xfs_buf_log_item_t *bip, xfs_lsn_t commit_lsn)
+xfs_buf_item_committing(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		commit_lsn)
 {
 }
 
@@ -649,19 +655,16 @@ xfs_buf_item_committing(xfs_buf_log_item
  * This is the ops vector shared by all buf log items.
  */
 static struct xfs_item_ops xfs_buf_item_ops = {
-	.iop_size	= (uint(*)(xfs_log_item_t*))xfs_buf_item_size,
-	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
-					xfs_buf_item_format,
-	.iop_pin	= (void(*)(xfs_log_item_t*))xfs_buf_item_pin,
-	.iop_unpin	= (void(*)(xfs_log_item_t*, int))xfs_buf_item_unpin,
-	.iop_trylock	= (uint(*)(xfs_log_item_t*))xfs_buf_item_trylock,
-	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_buf_item_unlock,
-	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
-					xfs_buf_item_committed,
-	.iop_push	= (void(*)(xfs_log_item_t*))xfs_buf_item_push,
-	.iop_pushbuf	= (void(*)(xfs_log_item_t*))xfs_buf_item_pushbuf,
-	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
-					xfs_buf_item_committing
+	.iop_size	= xfs_buf_item_size,
+	.iop_format	= xfs_buf_item_format,
+	.iop_pin	= xfs_buf_item_pin,
+	.iop_unpin	= xfs_buf_item_unpin,
+	.iop_trylock	= xfs_buf_item_trylock,
+	.iop_unlock	= xfs_buf_item_unlock,
+	.iop_committed	= xfs_buf_item_committed,
+	.iop_push	= xfs_buf_item_push,
+	.iop_pushbuf	= xfs_buf_item_pushbuf,
+	.iop_committing = xfs_buf_item_committing
 };
 
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
