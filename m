Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Aug 2006 21:13:29 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k754D0DW012359
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 21:13:06 -0700
Received: from [10.0.0.4] (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 40FA218068C57
	for <xfs@oss.sgi.com>; Fri,  4 Aug 2006 23:12:32 -0500 (CDT)
Message-ID: <44D41AB0.3050808@sandeen.net>
Date: Fri, 04 Aug 2006 23:12:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] kill iop_abort item_op
Content-Type: multipart/mixed;
 boundary="------------040504040207000401090700"
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------040504040207000401090700
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

It doesn't look like this is ever used for anything...?

  quota/xfs_dquot_item.c |   26 ------------------
  xfs_buf_item.c         |   20 --------------
  xfs_extfree_item.c     |   69 +------------------------------------------------
  xfs_inode_item.c       |   16 -----------
  xfs_trans.h            |    2 -
  5 files changed, 2 insertions(+), 131 deletions(-)

-Eric

--------------040504040207000401090700
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="kill-iop_abort"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kill-iop_abort"

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: xfs-linux/quota/xfs_dquot_item.c
===================================================================
--- xfs-linux.orig/quota/xfs_dquot_item.c
+++ xfs-linux/quota/xfs_dquot_item.c
@@ -382,18 +382,6 @@ xfs_qm_dquot_logitem_unlock(
 
 
 /*
- * The transaction with the dquot locked has aborted.  The dquot
- * must not be dirty within the transaction.  We simply unlock just
- * as if the transaction had been cancelled.
- */
-STATIC void
-xfs_qm_dquot_logitem_abort(
-	xfs_dq_logitem_t    *ql)
-{
-	xfs_qm_dquot_logitem_unlock(ql);
-}
-
-/*
  * this needs to stamp an lsn into the dquot, I think.
  * rpc's that look at user dquot's would then have to
  * push on the dependency recorded in the dquot
@@ -426,7 +414,6 @@ STATIC struct xfs_item_ops xfs_dquot_ite
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_qm_dquot_logitem_committed,
 	.iop_push	= (void(*)(xfs_log_item_t*))xfs_qm_dquot_logitem_push,
-	.iop_abort	= (void(*)(xfs_log_item_t*))xfs_qm_dquot_logitem_abort,
 	.iop_pushbuf	= (void(*)(xfs_log_item_t*))
 					xfs_qm_dquot_logitem_pushbuf,
 	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
@@ -559,17 +546,6 @@ xfs_qm_qoff_logitem_committed(xfs_qoff_l
 }
 
 /*
- * The transaction of which this QUOTAOFF is a part has been aborted.
- * Just clean up after ourselves.
- * Shouldn't this never happen in the case of qoffend logitems? XXX
- */
-STATIC void
-xfs_qm_qoff_logitem_abort(xfs_qoff_logitem_t *qf)
-{
-	kmem_free(qf, sizeof(xfs_qoff_logitem_t));
-}
-
-/*
  * There isn't much you can do to push on an quotaoff item.  It is simply
  * stuck waiting for the log to be flushed to disk.
  */
@@ -644,7 +620,6 @@ STATIC struct xfs_item_ops xfs_qm_qoffen
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_qm_qoffend_logitem_committed,
 	.iop_push	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_push,
-	.iop_abort	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_abort,
 	.iop_pushbuf	= NULL,
 	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_qm_qoffend_logitem_committing
@@ -667,7 +642,6 @@ STATIC struct xfs_item_ops xfs_qm_qoff_l
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_qm_qoff_logitem_committed,
 	.iop_push	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_push,
-	.iop_abort	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_abort,
 	.iop_pushbuf	= NULL,
 	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_qm_qoff_logitem_committing
Index: xfs-linux/xfs_buf_item.c
===================================================================
--- xfs-linux.orig/xfs_buf_item.c
+++ xfs-linux/xfs_buf_item.c
@@ -628,25 +628,6 @@ xfs_buf_item_committed(
 }
 
 /*
- * This is called when the transaction holding the buffer is aborted.
- * Just behave as if the transaction had been cancelled. If we're shutting down
- * and have aborted this transaction, we'll trap this buffer when it tries to
- * get written out.
- */
-STATIC void
-xfs_buf_item_abort(
-	xfs_buf_log_item_t	*bip)
-{
-	xfs_buf_t	*bp;
-
-	bp = bip->bli_buf;
-	xfs_buftrace("XFS_ABORT", bp);
-	XFS_BUF_SUPER_STALE(bp);
-	xfs_buf_item_unlock(bip);
-	return;
-}
-
-/*
  * This is called to asynchronously write the buffer associated with this
  * buf log item out to disk. The buffer will already have been locked by
  * a successful call to xfs_buf_item_trylock().  If the buffer still has
@@ -693,7 +674,6 @@ STATIC struct xfs_item_ops xfs_buf_item_
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_buf_item_committed,
 	.iop_push	= (void(*)(xfs_log_item_t*))xfs_buf_item_push,
-	.iop_abort	= (void(*)(xfs_log_item_t*))xfs_buf_item_abort,
 	.iop_pushbuf	= NULL,
 	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_buf_item_committing
Index: xfs-linux/xfs_extfree_item.c
===================================================================
--- xfs-linux.orig/xfs_extfree_item.c
+++ xfs-linux/xfs_extfree_item.c
@@ -33,9 +33,6 @@ kmem_zone_t	*xfs_efi_zone;
 kmem_zone_t	*xfs_efd_zone;
 
 STATIC void	xfs_efi_item_unlock(xfs_efi_log_item_t *);
-STATIC void	xfs_efi_item_abort(xfs_efi_log_item_t *);
-STATIC void	xfs_efd_item_abort(xfs_efd_log_item_t *);
-
 
 void
 xfs_efi_item_free(xfs_efi_log_item_t *efip)
@@ -184,7 +181,7 @@ STATIC void
 xfs_efi_item_unlock(xfs_efi_log_item_t *efip)
 {
 	if (efip->efi_item.li_flags & XFS_LI_ABORTED)
-		xfs_efi_item_abort(efip);
+		xfs_efi_item_free(efip);
 	return;
 }
 
@@ -202,18 +199,6 @@ xfs_efi_item_committed(xfs_efi_log_item_
 }
 
 /*
- * This is called when the transaction logging the EFI is aborted.
- * Free up the EFI and return.  No need to clean up the slot for
- * the item in the transaction.  That was done by the unpin code
- * which is called prior to this routine in the abort/fs-shutdown path.
- */
-STATIC void
-xfs_efi_item_abort(xfs_efi_log_item_t *efip)
-{
-	xfs_efi_item_free(efip);
-}
-
-/*
  * There isn't much you can do to push on an efi item.  It is simply
  * stuck waiting for all of its corresponding efd items to be
  * committed to disk.
@@ -255,7 +240,6 @@ STATIC struct xfs_item_ops xfs_efi_item_
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_efi_item_committed,
 	.iop_push	= (void(*)(xfs_log_item_t*))xfs_efi_item_push,
-	.iop_abort	= (void(*)(xfs_log_item_t*))xfs_efi_item_abort,
 	.iop_pushbuf	= NULL,
 	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_efi_item_committing
@@ -386,33 +370,6 @@ xfs_efi_release(xfs_efi_log_item_t	*efip
 	}
 }
 
-/*
- * This is called when the transaction that should be committing the
- * EFD corresponding to the given EFI is aborted.  The committed and
- * canceled flags are used to coordinate the freeing of the EFI and
- * the references by the transaction that committed it.
- */
-STATIC void
-xfs_efi_cancel(
-	xfs_efi_log_item_t	*efip)
-{
-	xfs_mount_t	*mp;
-	SPLDECL(s);
-
-	mp = efip->efi_item.li_mountp;
-	AIL_LOCK(mp, s);
-	if (efip->efi_flags & XFS_EFI_COMMITTED) {
-		/*
-		 * xfs_trans_delete_ail() drops the AIL lock.
-		 */
-		xfs_trans_delete_ail(mp, (xfs_log_item_t *)efip, s);
-		xfs_efi_item_free(efip);
-	} else {
-		efip->efi_flags |= XFS_EFI_CANCELED;
-		AIL_UNLOCK(mp, s);
-	}
-}
-
 STATIC void
 xfs_efd_item_free(xfs_efd_log_item_t *efdp)
 {
@@ -514,7 +471,7 @@ STATIC void
 xfs_efd_item_unlock(xfs_efd_log_item_t *efdp)
 {
 	if (efdp->efd_item.li_flags & XFS_LI_ABORTED)
-		xfs_efd_item_abort(efdp);
+		xfs_efd_item_free(efdp);
 	return;
 }
 
@@ -541,27 +498,6 @@ xfs_efd_item_committed(xfs_efd_log_item_
 }
 
 /*
- * The transaction of which this EFD is a part has been aborted.
- * Inform its companion EFI of this fact and then clean up after
- * ourselves.  No need to clean up the slot for the item in the
- * transaction.  That was done by the unpin code which is called
- * prior to this routine in the abort/fs-shutdown path.
- */
-STATIC void
-xfs_efd_item_abort(xfs_efd_log_item_t *efdp)
-{
-	/*
-	 * If we got a log I/O error, it's always the case that the LR with the
-	 * EFI got unpinned and freed before the EFD got aborted. So don't
-	 * reference the EFI at all in that case.
-	 */
-	if ((efdp->efd_item.li_flags & XFS_LI_ABORTED) == 0)
-		xfs_efi_cancel(efdp->efd_efip);
-
-	xfs_efd_item_free(efdp);
-}
-
-/*
  * There isn't much you can do to push on an efd item.  It is simply
  * stuck waiting for the log to be flushed to disk.
  */
@@ -602,7 +538,6 @@ STATIC struct xfs_item_ops xfs_efd_item_
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_efd_item_committed,
 	.iop_push	= (void(*)(xfs_log_item_t*))xfs_efd_item_push,
-	.iop_abort	= (void(*)(xfs_log_item_t*))xfs_efd_item_abort,
 	.iop_pushbuf	= NULL,
 	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_efd_item_committing
Index: xfs-linux/xfs_inode_item.c
===================================================================
--- xfs-linux.orig/xfs_inode_item.c
+++ xfs-linux/xfs_inode_item.c
@@ -743,21 +743,6 @@ xfs_inode_item_committed(
 }
 
 /*
- * The transaction with the inode locked has aborted.  The inode
- * must not be dirty within the transaction (unless we're forcibly
- * shutting down).  We simply unlock just as if the transaction
- * had been cancelled.
- */
-STATIC void
-xfs_inode_item_abort(
-	xfs_inode_log_item_t	*iip)
-{
-	xfs_inode_item_unlock(iip);
-	return;
-}
-
-
-/*
  * This gets called by xfs_trans_push_ail(), when IOP_TRYLOCK
  * failed to get the inode flush lock but did get the inode locked SHARED.
  * Here we're trying to see if the inode buffer is incore, and if so whether it's
@@ -915,7 +900,6 @@ STATIC struct xfs_item_ops xfs_inode_ite
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_inode_item_committed,
 	.iop_push	= (void(*)(xfs_log_item_t*))xfs_inode_item_push,
-	.iop_abort	= (void(*)(xfs_log_item_t*))xfs_inode_item_abort,
 	.iop_pushbuf	= (void(*)(xfs_log_item_t*))xfs_inode_item_pushbuf,
 	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_inode_item_committing
Index: xfs-linux/xfs_trans.h
===================================================================
--- xfs-linux.orig/xfs_trans.h
+++ xfs-linux/xfs_trans.h
@@ -149,7 +149,6 @@ typedef struct xfs_item_ops {
 	void (*iop_unlock)(xfs_log_item_t *);
 	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
 	void (*iop_push)(xfs_log_item_t *);
-	void (*iop_abort)(xfs_log_item_t *);
 	void (*iop_pushbuf)(xfs_log_item_t *);
 	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
 } xfs_item_ops_t;
@@ -163,7 +162,6 @@ typedef struct xfs_item_ops {
 #define IOP_UNLOCK(ip)		(*(ip)->li_ops->iop_unlock)(ip)
 #define IOP_COMMITTED(ip, lsn)	(*(ip)->li_ops->iop_committed)(ip, lsn)
 #define IOP_PUSH(ip)		(*(ip)->li_ops->iop_push)(ip)
-#define IOP_ABORT(ip)		(*(ip)->li_ops->iop_abort)(ip)
 #define IOP_PUSHBUF(ip)		(*(ip)->li_ops->iop_pushbuf)(ip)
 #define IOP_COMMITTING(ip, lsn) (*(ip)->li_ops->iop_committing)(ip, lsn)
 

--------------040504040207000401090700--
