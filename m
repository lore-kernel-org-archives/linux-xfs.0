Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 23:26:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6M6PwKN028523
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 23:26:01 -0700
Message-ID: <48857EFB.3030301@sgi.com>
Date: Tue, 22 Jul 2008 16:32:27 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] Prevent log tail pushing from blocking on buffer locks
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

This changes xfs_inode_item_push() to use XFS_IFLUSH_ASYNC_NOBLOCK when
flushing an inode so the flush wont block on inode cluster buffer lock.
Also change the prototype of the IOP_PUSH operation so that xfsaild_push()
can bump it's stuck count.

This change was prompted by a deadlock that would only occur on a debug
XFS where a thread creating an inode had the buffer locked and was trying
to allocate space for the inode tracing facility.  That recursed back into
the filesystem to flush data which created a transaction and needed log
space which wasn't available.

--- fs/xfs/quota/xfs_dquot_item.c_1.22	2008-07-03 15:37:12.000000000 +1000
+++ fs/xfs/quota/xfs_dquot_item.c	2008-07-03 14:39:12.000000000 +1000
@@ -141,7 +141,7 @@ xfs_qm_dquot_logitem_unpin_remove(
  * we simply get xfs_qm_dqflush() to do the work, and unlock the dquot
  * at the end.
  */
-STATIC void
+STATIC int
 xfs_qm_dquot_logitem_push(
 	xfs_dq_logitem_t	*logitem)
 {
@@ -168,6 +168,8 @@ xfs_qm_dquot_logitem_push(
 			"xfs_qm_dquot_logitem_push: push error %d on dqp %p",
 			error, dqp);
 	xfs_dqunlock(dqp);
+
+	return error;
 }
 
 /*ARGSUSED*/
@@ -417,7 +419,7 @@ static struct xfs_item_ops xfs_dquot_ite
 	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_qm_dquot_logitem_unlock,
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_qm_dquot_logitem_committed,
-	.iop_push	= (void(*)(xfs_log_item_t*))xfs_qm_dquot_logitem_push,
+	.iop_push	= (int(*)(xfs_log_item_t*))xfs_qm_dquot_logitem_push,
 	.iop_pushbuf	= (void(*)(xfs_log_item_t*))
 					xfs_qm_dquot_logitem_pushbuf,
 	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
@@ -554,10 +556,10 @@ xfs_qm_qoff_logitem_committed(xfs_qoff_l
  * stuck waiting for the log to be flushed to disk.
  */
 /*ARGSUSED*/
-STATIC void
+STATIC int
 xfs_qm_qoff_logitem_push(xfs_qoff_logitem_t *qf)
 {
-	return;
+	return 0;
 }
 
 
@@ -622,7 +624,7 @@ static struct xfs_item_ops xfs_qm_qoffen
 	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_unlock,
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_qm_qoffend_logitem_committed,
-	.iop_push	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_push,
+	.iop_push	= (int(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_push,
 	.iop_pushbuf	= NULL,
 	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_qm_qoffend_logitem_committing
@@ -644,7 +646,7 @@ static struct xfs_item_ops xfs_qm_qoff_l
 	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_unlock,
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_qm_qoff_logitem_committed,
-	.iop_push	= (void(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_push,
+	.iop_push	= (int(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_push,
 	.iop_pushbuf	= NULL,
 	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_qm_qoff_logitem_committing
--- fs/xfs/xfs_buf_item.c_1.166	2008-07-03 15:37:14.000000000 +1000
+++ fs/xfs/xfs_buf_item.c	2008-07-03 14:38:17.000000000 +1000
@@ -633,11 +633,12 @@ xfs_buf_item_committed(
  * B_DELWRI set, then get it going out to disk with a call to bawrite().
  * If not, then just release the buffer.
  */
-STATIC void
+STATIC int
 xfs_buf_item_push(
 	xfs_buf_log_item_t	*bip)
 {
 	xfs_buf_t	*bp;
+	int		error = 0;
 
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	xfs_buf_item_trace("PUSH", bip);
@@ -645,7 +646,6 @@ xfs_buf_item_push(
 	bp = bip->bli_buf;
 
 	if (XFS_BUF_ISDELAYWRITE(bp)) {
-		int	error;
 		error = xfs_bawrite(bip->bli_item.li_mountp, bp);
 		if (error)
 			xfs_fs_cmn_err(CE_WARN, bip->bli_item.li_mountp,
@@ -654,6 +654,8 @@ xfs_buf_item_push(
 	} else {
 		xfs_buf_relse(bp);
 	}
+
+	return error;
 }
 
 /* ARGSUSED */
@@ -677,7 +679,7 @@ static struct xfs_item_ops xfs_buf_item_
 	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_buf_item_unlock,
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_buf_item_committed,
-	.iop_push	= (void(*)(xfs_log_item_t*))xfs_buf_item_push,
+	.iop_push	= (int(*)(xfs_log_item_t*))xfs_buf_item_push,
 	.iop_pushbuf	= NULL,
 	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_buf_item_committing
--- fs/xfs/xfs_extfree_item.c_1.69	2008-07-03 15:37:16.000000000 +1000
+++ fs/xfs/xfs_extfree_item.c	2008-07-03 14:38:40.000000000 +1000
@@ -202,10 +202,10 @@ xfs_efi_item_committed(xfs_efi_log_item_
  * committed to disk.
  */
 /*ARGSUSED*/
-STATIC void
+STATIC int
 xfs_efi_item_push(xfs_efi_log_item_t *efip)
 {
-	return;
+	return 0;
 }
 
 /*
@@ -237,7 +237,7 @@ static struct xfs_item_ops xfs_efi_item_
 	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_efi_item_unlock,
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_efi_item_committed,
-	.iop_push	= (void(*)(xfs_log_item_t*))xfs_efi_item_push,
+	.iop_push	= (int(*)(xfs_log_item_t*))xfs_efi_item_push,
 	.iop_pushbuf	= NULL,
 	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_efi_item_committing
@@ -498,10 +498,10 @@ xfs_efd_item_committed(xfs_efd_log_item_
  * stuck waiting for the log to be flushed to disk.
  */
 /*ARGSUSED*/
-STATIC void
+STATIC int
 xfs_efd_item_push(xfs_efd_log_item_t *efdp)
 {
-	return;
+	return 0;
 }
 
 /*
@@ -533,7 +533,7 @@ static struct xfs_item_ops xfs_efd_item_
 	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_efd_item_unlock,
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_efd_item_committed,
-	.iop_push	= (void(*)(xfs_log_item_t*))xfs_efd_item_push,
+	.iop_push	= (int(*)(xfs_log_item_t*))xfs_efd_item_push,
 	.iop_pushbuf	= NULL,
 	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_efd_item_committing
--- fs/xfs/xfs_inode_item.c_1.136	2008-07-03 15:37:18.000000000 +1000
+++ fs/xfs/xfs_inode_item.c	2008-07-03 14:39:33.000000000 +1000
@@ -849,11 +849,12 @@ xfs_inode_item_pushbuf(
  * inode log item out to disk. The inode will already have been locked by
  * a successful call to xfs_inode_item_trylock().
  */
-STATIC void
+STATIC int
 xfs_inode_item_push(
 	xfs_inode_log_item_t	*iip)
 {
 	xfs_inode_t	*ip;
+	int		error;
 
 	ip = iip->ili_inode;
 
@@ -875,10 +876,10 @@ xfs_inode_item_push(
 	 * Write out the inode.  The completion routine ('iflush_done') will
 	 * pull it from the AIL, mark it clean, unlock the flush lock.
 	 */
-	(void) xfs_iflush(ip, XFS_IFLUSH_ASYNC);
+	error = xfs_iflush(ip, XFS_IFLUSH_ASYNC_NOBLOCK);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
-	return;
+	return error;
 }
 
 /*
@@ -910,7 +911,7 @@ static struct xfs_item_ops xfs_inode_ite
 	.iop_unlock	= (void(*)(xfs_log_item_t*))xfs_inode_item_unlock,
 	.iop_committed	= (xfs_lsn_t(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_inode_item_committed,
-	.iop_push	= (void(*)(xfs_log_item_t*))xfs_inode_item_push,
+	.iop_push	= (int(*)(xfs_log_item_t*))xfs_inode_item_push,
 	.iop_pushbuf	= (void(*)(xfs_log_item_t*))xfs_inode_item_pushbuf,
 	.iop_committing = (void(*)(xfs_log_item_t*, xfs_lsn_t))
 					xfs_inode_item_committing
--- fs/xfs/xfs_trans.h_1.149	2008-07-03 15:37:19.000000000 +1000
+++ fs/xfs/xfs_trans.h	2008-07-03 14:33:58.000000000 +1000
@@ -140,7 +140,7 @@ typedef struct xfs_item_ops {
 	uint (*iop_trylock)(xfs_log_item_t *);
 	void (*iop_unlock)(xfs_log_item_t *);
 	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
-	void (*iop_push)(xfs_log_item_t *);
+	int  (*iop_push)(xfs_log_item_t *);
 	void (*iop_pushbuf)(xfs_log_item_t *);
 	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
 } xfs_item_ops_t;
--- fs/xfs/xfs_trans_ail.c_1.87	2008-07-03 15:37:21.000000000 +1000
+++ fs/xfs/xfs_trans_ail.c	2008-07-03 14:40:29.000000000 +1000
@@ -188,7 +188,8 @@ xfsaild_push(
 		switch (lock_result) {
 		case XFS_ITEM_SUCCESS:
 			XFS_STATS_INC(xs_push_ail_success);
-			IOP_PUSH(lip);
+			if (IOP_PUSH(lip))
+				stuck++;
 			last_pushed_lsn = lsn;
 			break;
 
