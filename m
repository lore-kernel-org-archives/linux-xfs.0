Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J9tuaC182597 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 03:55:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4500C124D00C
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:56:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id XwUomllColD3cXNy for
	<xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:56:55 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NXApT-0001H6-Hb
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 09:56:55 +0000
Message-Id: <20100119095655.363711060@bombadil.infradead.org>
Date: Tue, 19 Jan 2010 04:56:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] xfs: cleanup up xfs_log_force calling conventions
References: <20100119095643.378866749@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xfs_log_force
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

Remove the XFS_LOG_FORCE argument which was always set, and the XFS_LOG_URGE
define, which was never used.

Split xfs_log_force into a two helpers - xfs_log_force which forces the
whole log, and xfs_log_force_lsn which forces up to the specified LSN.
The underlying implementations already were entirely separate, as were
the users.

Also re-indent the new _xfs_log_force/_xfs_log_force which previously had
a weird coding style.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2010-01-19 10:49:11.258004245 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2010-01-19 10:49:33.500272635 +0100
@@ -296,10 +296,7 @@ xfs_sync_data(
 	if (error)
 		return XFS_ERROR(error);
 
-	xfs_log_force(mp, 0,
-		      (flags & SYNC_WAIT) ?
-		       XFS_LOG_FORCE | XFS_LOG_SYNC :
-		       XFS_LOG_FORCE);
+	xfs_log_force(mp, (flags & SYNC_WAIT) ? XFS_LOG_SYNC : 0);
 	return 0;
 }
 
@@ -325,10 +322,6 @@ xfs_commit_dummy_trans(
 	struct xfs_inode	*ip = mp->m_rootip;
 	struct xfs_trans	*tp;
 	int			error;
-	int			log_flags = XFS_LOG_FORCE;
-
-	if (flags & SYNC_WAIT)
-		log_flags |= XFS_LOG_SYNC;
 
 	/*
 	 * Put a dummy transaction in the log to tell recovery
@@ -350,7 +343,7 @@ xfs_commit_dummy_trans(
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	/* the log force ensures this transaction is pushed to disk */
-	xfs_log_force(mp, 0, log_flags);
+	xfs_log_force(mp, (flags & SYNC_WAIT) ? XFS_LOG_SYNC : 0);
 	return error;
 }
 
@@ -390,7 +383,7 @@ xfs_sync_fsdata(
 		 * become pinned in between there and here.
 		 */
 		if (XFS_BUF_ISPINNED(bp))
-			xfs_log_force(mp, 0, XFS_LOG_FORCE);
+			xfs_log_force(mp, 0);
 	}
 
 
@@ -575,7 +568,7 @@ xfs_flush_inodes(
 	igrab(inode);
 	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_inodes_work, &completion);
 	wait_for_completion(&completion);
-	xfs_log_force(ip->i_mount, (xfs_lsn_t)0, XFS_LOG_FORCE|XFS_LOG_SYNC);
+	xfs_log_force(ip->i_mount, XFS_LOG_SYNC);
 }
 
 /*
@@ -591,7 +584,7 @@ xfs_sync_worker(
 	int		error;
 
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
-		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
+		xfs_log_force(mp, 0);
 		xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
 		/* dgc: errors ignored here */
 		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
Index: xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.c	2010-01-19 10:49:11.259003604 +0100
+++ xfs/fs/xfs/quota/xfs_dquot.c	2010-01-19 10:49:33.501273601 +0100
@@ -1248,7 +1248,7 @@ xfs_qm_dqflush(
 	 */
 	if (XFS_BUF_ISPINNED(bp)) {
 		trace_xfs_dqflush_force(dqp);
-		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
+		xfs_log_force(mp, 0);
 	}
 
 	if (flags & XFS_QMOPT_DELWRI) {
@@ -1531,11 +1531,9 @@ xfs_qm_dqflock_pushbuf_wait(
 	if (bp != NULL) {
 		if (XFS_BUF_ISDELAYWRITE(bp)) {
 			int	error;
-			if (XFS_BUF_ISPINNED(bp)) {
-				xfs_log_force(dqp->q_mount,
-					      (xfs_lsn_t)0,
-					      XFS_LOG_FORCE);
-			}
+
+			if (XFS_BUF_ISPINNED(bp))
+				xfs_log_force(dqp->q_mount, 0);
 			error = xfs_bawrite(dqp->q_mount, bp);
 			if (error)
 				xfs_fs_cmn_err(CE_WARN, dqp->q_mount,
Index: xfs/fs/xfs/quota/xfs_dquot_item.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot_item.c	2010-01-19 10:49:18.096003841 +0100
+++ xfs/fs/xfs/quota/xfs_dquot_item.c	2010-01-19 10:49:33.502274007 +0100
@@ -190,7 +190,7 @@ xfs_qm_dqunpin_wait(
 	/*
 	 * Give the log a push so we don't wait here too long.
 	 */
-	xfs_log_force(dqp->q_mount, (xfs_lsn_t)0, XFS_LOG_FORCE);
+	xfs_log_force(dqp->q_mount, 0);
 	wait_event(dqp->q_pinwait, (atomic_read(&dqp->q_pincount) == 0));
 }
 
@@ -245,10 +245,9 @@ xfs_qm_dquot_logitem_pushbuf(
 			qip->qli_pushbuf_flag = 0;
 			xfs_dqunlock(dqp);
 
-			if (XFS_BUF_ISPINNED(bp)) {
-				xfs_log_force(mp, (xfs_lsn_t)0,
-					      XFS_LOG_FORCE);
-			}
+			if (XFS_BUF_ISPINNED(bp))
+				xfs_log_force(mp, 0);
+
 			if (dopush) {
 				int	error;
 #ifdef XFSRACEDEBUG
Index: xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2010-01-17 23:33:04.517003350 +0100
+++ xfs/fs/xfs/quota/xfs_qm_syscalls.c	2010-01-19 10:49:33.503004548 +0100
@@ -1192,9 +1192,9 @@ xfs_qm_internalqcheck(
 	if (! XFS_IS_QUOTA_ON(mp))
 		return XFS_ERROR(ESRCH);
 
-	xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE | XFS_LOG_SYNC);
+	xfs_log_force(mp, XFS_LOG_SYNC);
 	XFS_bflush(mp->m_ddev_targp);
-	xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE | XFS_LOG_SYNC);
+	xfs_log_force(mp, XFS_LOG_SYNC);
 	XFS_bflush(mp->m_ddev_targp);
 
 	mutex_lock(&qcheck_lock);
Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2010-01-19 10:49:11.262004266 +0100
+++ xfs/fs/xfs/xfs_alloc.c	2010-01-19 10:49:33.504003976 +0100
@@ -2601,5 +2601,5 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 	 * transaction that freed the block
 	 */
 	if (lsn)
-		xfs_log_force(tp->t_mountp, lsn, XFS_LOG_FORCE|XFS_LOG_SYNC);
+		xfs_log_force_lsn(tp->t_mountp, lsn, XFS_LOG_SYNC);
 }
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2010-01-19 10:49:11.270004307 +0100
+++ xfs/fs/xfs/xfs_inode.c	2010-01-19 10:49:33.506010936 +0100
@@ -2484,8 +2484,11 @@ __xfs_iunpin_wait(
 		return;
 
 	/* Give the log a push to start the unpinning I/O */
-	xfs_log_force(ip->i_mount, (iip && iip->ili_last_lsn) ?
-				iip->ili_last_lsn : 0, XFS_LOG_FORCE);
+	if (iip && iip->ili_last_lsn)
+		xfs_log_force_lsn(ip->i_mount, iip->ili_last_lsn, 0);
+	else
+		xfs_log_force(ip->i_mount, 0);
+
 	if (wait)
 		wait_event(ip->i_ipin_wait, (atomic_read(&ip->i_pincount) == 0));
 }
@@ -2970,7 +2973,7 @@ xfs_iflush(
 	 * get stuck waiting in the write for too long.
 	 */
 	if (XFS_BUF_ISPINNED(bp))
-		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
+		xfs_log_force(mp, 0);
 
 	/*
 	 * inode clustering:
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2010-01-19 10:49:18.098003398 +0100
+++ xfs/fs/xfs/xfs_inode_item.c	2010-01-19 10:49:33.507004429 +0100
@@ -804,10 +804,9 @@ xfs_inode_item_pushbuf(
 
 			trace_xfs_inode_item_push(bp, _RET_IP_);
 
-			if (XFS_BUF_ISPINNED(bp)) {
-				xfs_log_force(mp, (xfs_lsn_t)0,
-					      XFS_LOG_FORCE);
-			}
+			if (XFS_BUF_ISPINNED(bp))
+				xfs_log_force(mp, 0);
+
 			if (dopush) {
 				int	error;
 				error = xfs_bawrite(mp, bp);
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2010-01-19 10:49:18.100003304 +0100
+++ xfs/fs/xfs/xfs_log.c	2010-01-19 10:49:33.510003623 +0100
@@ -79,11 +79,6 @@ STATIC int  xlog_state_release_iclog(xlo
 STATIC void xlog_state_switch_iclogs(xlog_t		*log,
 				     xlog_in_core_t *iclog,
 				     int		eventual_size);
-STATIC int  xlog_state_sync(xlog_t			*log,
-			    xfs_lsn_t 			lsn,
-			    uint			flags,
-			    int				*log_flushed);
-STATIC int  xlog_state_sync_all(xlog_t *log, uint flags, int *log_flushed);
 STATIC void xlog_state_want_sync(xlog_t	*log, xlog_in_core_t *iclog);
 
 /* local functions to manipulate grant head */
@@ -296,65 +291,6 @@ xfs_log_done(xfs_mount_t	*mp,
 	return lsn;
 }	/* xfs_log_done */
 
-
-/*
- * Force the in-core log to disk.  If flags == XFS_LOG_SYNC,
- *	the force is done synchronously.
- *
- * Asynchronous forces are implemented by setting the WANT_SYNC
- * bit in the appropriate in-core log and then returning.
- *
- * Synchronous forces are implemented with a signal variable. All callers
- * to force a given lsn to disk will wait on a the sv attached to the
- * specific in-core log.  When given in-core log finally completes its
- * write to disk, that thread will wake up all threads waiting on the
- * sv.
- */
-int
-_xfs_log_force(
-	xfs_mount_t	*mp,
-	xfs_lsn_t	lsn,
-	uint		flags,
-	int		*log_flushed)
-{
-	xlog_t		*log = mp->m_log;
-	int		dummy;
-
-	if (!log_flushed)
-		log_flushed = &dummy;
-
-	ASSERT(flags & XFS_LOG_FORCE);
-
-	XFS_STATS_INC(xs_log_force);
-
-	if (log->l_flags & XLOG_IO_ERROR)
-		return XFS_ERROR(EIO);
-	if (lsn == 0)
-		return xlog_state_sync_all(log, flags, log_flushed);
-	else
-		return xlog_state_sync(log, lsn, flags, log_flushed);
-}	/* _xfs_log_force */
-
-/*
- * Wrapper for _xfs_log_force(), to be used when caller doesn't care
- * about errors or whether the log was flushed or not. This is the normal
- * interface to use when trying to unpin items or move the log forward.
- */
-void
-xfs_log_force(
-	xfs_mount_t	*mp,
-	xfs_lsn_t	lsn,
-	uint		flags)
-{
-	int	error;
-	error = _xfs_log_force(mp, lsn, flags, NULL);
-	if (error) {
-		xfs_fs_cmn_err(CE_WARN, mp, "xfs_log_force: "
-			"error %d returned.", error);
-	}
-}
-
-
 /*
  * Attaches a new iclog I/O completion callback routine during
  * transaction commit.  If the log is in error state, a non-zero
@@ -601,7 +537,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return 0;
 
-	error = _xfs_log_force(mp, 0, XFS_LOG_FORCE|XFS_LOG_SYNC, NULL);
+	error = _xfs_log_force(mp, XFS_LOG_SYNC, NULL);
 	ASSERT(error || !(XLOG_FORCED_SHUTDOWN(log)));
 
 #ifdef DEBUG
@@ -2853,7 +2789,6 @@ xlog_state_switch_iclogs(xlog_t		*log,
 	log->l_iclog = iclog->ic_next;
 }	/* xlog_state_switch_iclogs */
 
-
 /*
  * Write out all data in the in-core log as of this exact moment in time.
  *
@@ -2881,11 +2816,17 @@ xlog_state_switch_iclogs(xlog_t		*log,
  *	   b) when we return from flushing out this iclog, it is still
  *		not in the active nor dirty state.
  */
-STATIC int
-xlog_state_sync_all(xlog_t *log, uint flags, int *log_flushed)
+int
+_xfs_log_force(
+	struct xfs_mount	*mp,
+	uint			flags,
+	int			*log_flushed)
 {
-	xlog_in_core_t	*iclog;
-	xfs_lsn_t	lsn;
+	struct log		*log = mp->m_log;
+	struct xlog_in_core	*iclog;
+	xfs_lsn_t		lsn;
+
+	XFS_STATS_INC(xs_log_force);
 
 	spin_lock(&log->l_icloglock);
 
@@ -2931,7 +2872,9 @@ xlog_state_sync_all(xlog_t *log, uint fl
 
 				if (xlog_state_release_iclog(log, iclog))
 					return XFS_ERROR(EIO);
-				*log_flushed = 1;
+
+				if (log_flushed)
+					*log_flushed = 1;
 				spin_lock(&log->l_icloglock);
 				if (be64_to_cpu(iclog->ic_header.h_lsn) == lsn &&
 				    iclog->ic_state != XLOG_STATE_DIRTY)
@@ -2975,19 +2918,37 @@ maybe_sleep:
 		 */
 		if (iclog->ic_state & XLOG_STATE_IOERROR)
 			return XFS_ERROR(EIO);
-		*log_flushed = 1;
-
+		if (log_flushed)
+			*log_flushed = 1;
 	} else {
 
 no_sleep:
 		spin_unlock(&log->l_icloglock);
 	}
 	return 0;
-}	/* xlog_state_sync_all */
+}
 
+/*
+ * Wrapper for _xfs_log_force(), to be used when caller doesn't care
+ * about errors or whether the log was flushed or not. This is the normal
+ * interface to use when trying to unpin items or move the log forward.
+ */
+void
+xfs_log_force(
+	xfs_mount_t	*mp,
+	uint		flags)
+{
+	int	error;
+
+	error = _xfs_log_force(mp, flags, NULL);
+	if (error) {
+		xfs_fs_cmn_err(CE_WARN, mp, "xfs_log_force: "
+			"error %d returned.", error);
+	}
+}
 
 /*
- * Used by code which implements synchronous log forces.
+ * Force the in-core log to disk for a specific LSN.
  *
  * Find in-core log with lsn.
  *	If it is in the DIRTY state, just return.
@@ -2995,109 +2956,142 @@ no_sleep:
  *		state and go to sleep or return.
  *	If it is in any other state, go to sleep or return.
  *
- * If filesystem activity goes to zero, the iclog will get flushed only by
- * bdflush().
+ * Synchronous forces are implemented with a signal variable. All callers
+ * to force a given lsn to disk will wait on a the sv attached to the
+ * specific in-core log.  When given in-core log finally completes its
+ * write to disk, that thread will wake up all threads waiting on the
+ * sv.
  */
-STATIC int
-xlog_state_sync(xlog_t	  *log,
-		xfs_lsn_t lsn,
-		uint	  flags,
-		int	  *log_flushed)
+int
+_xfs_log_force_lsn(
+	struct xfs_mount	*mp,
+	xfs_lsn_t		lsn,
+	uint			flags,
+	int			*log_flushed)
 {
-    xlog_in_core_t	*iclog;
-    int			already_slept = 0;
-
-try_again:
-    spin_lock(&log->l_icloglock);
-    iclog = log->l_iclog;
+	struct log		*log = mp->m_log;
+	struct xlog_in_core	*iclog;
+	int			already_slept = 0;
 
-    if (iclog->ic_state & XLOG_STATE_IOERROR) {
-	    spin_unlock(&log->l_icloglock);
-	    return XFS_ERROR(EIO);
-    }
+	ASSERT(lsn != 0);
 
-    do {
-	if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn) {
-		iclog = iclog->ic_next;
-		continue;
-	}
+	XFS_STATS_INC(xs_log_force);
 
-	if (iclog->ic_state == XLOG_STATE_DIRTY) {
+try_again:
+	spin_lock(&log->l_icloglock);
+	iclog = log->l_iclog;
+	if (iclog->ic_state & XLOG_STATE_IOERROR) {
 		spin_unlock(&log->l_icloglock);
-		return 0;
+		return XFS_ERROR(EIO);
 	}
 
-	if (iclog->ic_state == XLOG_STATE_ACTIVE) {
-		/*
-		 * We sleep here if we haven't already slept (e.g.
-		 * this is the first time we've looked at the correct
-		 * iclog buf) and the buffer before us is going to
-		 * be sync'ed. The reason for this is that if we
-		 * are doing sync transactions here, by waiting for
-		 * the previous I/O to complete, we can allow a few
-		 * more transactions into this iclog before we close
-		 * it down.
-		 *
-		 * Otherwise, we mark the buffer WANT_SYNC, and bump
-		 * up the refcnt so we can release the log (which drops
-		 * the ref count).  The state switch keeps new transaction
-		 * commits from using this buffer.  When the current commits
-		 * finish writing into the buffer, the refcount will drop to
-		 * zero and the buffer will go out then.
-		 */
-		if (!already_slept &&
-		    (iclog->ic_prev->ic_state & (XLOG_STATE_WANT_SYNC |
-						 XLOG_STATE_SYNCING))) {
-			ASSERT(!(iclog->ic_state & XLOG_STATE_IOERROR));
-			XFS_STATS_INC(xs_log_force_sleep);
-			sv_wait(&iclog->ic_prev->ic_write_wait, PSWP,
-				&log->l_icloglock, s);
-			*log_flushed = 1;
-			already_slept = 1;
-			goto try_again;
-		} else {
+	do {
+		if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn) {
+			iclog = iclog->ic_next;
+			continue;
+		}
+
+		if (iclog->ic_state == XLOG_STATE_DIRTY) {
+			spin_unlock(&log->l_icloglock);
+			return 0;
+		}
+
+		if (iclog->ic_state == XLOG_STATE_ACTIVE) {
+			/*
+			 * We sleep here if we haven't already slept (e.g.
+			 * this is the first time we've looked at the correct
+			 * iclog buf) and the buffer before us is going to
+			 * be sync'ed. The reason for this is that if we
+			 * are doing sync transactions here, by waiting for
+			 * the previous I/O to complete, we can allow a few
+			 * more transactions into this iclog before we close
+			 * it down.
+			 *
+			 * Otherwise, we mark the buffer WANT_SYNC, and bump
+			 * up the refcnt so we can release the log (which
+			 * drops the ref count).  The state switch keeps new
+			 * transaction commits from using this buffer.  When
+			 * the current commits finish writing into the buffer,
+			 * the refcount will drop to zero and the buffer will
+			 * go out then.
+			 */
+			if (!already_slept &&
+			    (iclog->ic_prev->ic_state &
+			     (XLOG_STATE_WANT_SYNC | XLOG_STATE_SYNCING))) {
+				ASSERT(!(iclog->ic_state & XLOG_STATE_IOERROR));
+
+				XFS_STATS_INC(xs_log_force_sleep);
+
+				sv_wait(&iclog->ic_prev->ic_write_wait,
+					PSWP, &log->l_icloglock, s);
+				if (log_flushed)
+					*log_flushed = 1;
+				already_slept = 1;
+				goto try_again;
+			}
 			atomic_inc(&iclog->ic_refcnt);
 			xlog_state_switch_iclogs(log, iclog, 0);
 			spin_unlock(&log->l_icloglock);
 			if (xlog_state_release_iclog(log, iclog))
 				return XFS_ERROR(EIO);
-			*log_flushed = 1;
+			if (log_flushed)
+				*log_flushed = 1;
 			spin_lock(&log->l_icloglock);
 		}
-	}
 
-	if ((flags & XFS_LOG_SYNC) && /* sleep */
-	    !(iclog->ic_state & (XLOG_STATE_ACTIVE | XLOG_STATE_DIRTY))) {
+		if ((flags & XFS_LOG_SYNC) && /* sleep */
+	    	    !(iclog->ic_state &
+		      (XLOG_STATE_ACTIVE | XLOG_STATE_DIRTY))) {
+			/*
+			 * Don't wait on completion if we know that we've
+			 * gotten a log write error.
+			 */
+			if (iclog->ic_state & XLOG_STATE_IOERROR) {
+				spin_unlock(&log->l_icloglock);
+				return XFS_ERROR(EIO);
+			}
+			XFS_STATS_INC(xs_log_force_sleep);
+			sv_wait(&iclog->ic_force_wait, PSWP, &log->l_icloglock, s);
+			/*
+			 * No need to grab the log lock here since we're
+			 * only deciding whether or not to return EIO
+			 * and the memory read should be atomic.
+			 */
+			if (iclog->ic_state & XLOG_STATE_IOERROR)
+				return XFS_ERROR(EIO);
 
-		/*
-		 * Don't wait on completion if we know that we've
-		 * gotten a log write error.
-		 */
-		if (iclog->ic_state & XLOG_STATE_IOERROR) {
+			if (log_flushed)
+				*log_flushed = 1;
+		} else {		/* just return */
 			spin_unlock(&log->l_icloglock);
-			return XFS_ERROR(EIO);
 		}
-		XFS_STATS_INC(xs_log_force_sleep);
-		sv_wait(&iclog->ic_force_wait, PSWP, &log->l_icloglock, s);
-		/*
-		 * No need to grab the log lock here since we're
-		 * only deciding whether or not to return EIO
-		 * and the memory read should be atomic.
-		 */
-		if (iclog->ic_state & XLOG_STATE_IOERROR)
-			return XFS_ERROR(EIO);
-		*log_flushed = 1;
-	} else {		/* just return */
-		spin_unlock(&log->l_icloglock);
-	}
-	return 0;
 
-    } while (iclog != log->l_iclog);
+		return 0;
+	} while (iclog != log->l_iclog);
 
-    spin_unlock(&log->l_icloglock);
-    return 0;
-}	/* xlog_state_sync */
+	spin_unlock(&log->l_icloglock);
+	return 0;
+}
+
+/*
+ * Wrapper for _xfs_log_force_lsn(), to be used when caller doesn't care
+ * about errors or whether the log was flushed or not. This is the normal
+ * interface to use when trying to unpin items or move the log forward.
+ */
+void
+xfs_log_force_lsn(
+	xfs_mount_t	*mp,
+	xfs_lsn_t	lsn,
+	uint		flags)
+{
+	int	error;
 
+	error = _xfs_log_force_lsn(mp, lsn, flags, NULL);
+	if (error) {
+		xfs_fs_cmn_err(CE_WARN, mp, "xfs_log_force: "
+			"error %d returned.", error);
+	}
+}
 
 /*
  * Called when we want to mark the current iclog as being ready to sync to
@@ -3462,7 +3456,6 @@ xfs_log_force_umount(
 	xlog_ticket_t	*tic;
 	xlog_t		*log;
 	int		retval;
-	int		dummy;
 
 	log = mp->m_log;
 
@@ -3536,13 +3529,14 @@ xfs_log_force_umount(
 	}
 	spin_unlock(&log->l_grant_lock);
 
-	if (! (log->l_iclog->ic_state & XLOG_STATE_IOERROR)) {
+	if (!(log->l_iclog->ic_state & XLOG_STATE_IOERROR)) {
 		ASSERT(!logerror);
 		/*
 		 * Force the incore logs to disk before shutting the
 		 * log down completely.
 		 */
-		xlog_state_sync_all(log, XFS_LOG_FORCE|XFS_LOG_SYNC, &dummy);
+		_xfs_log_force(mp, XFS_LOG_SYNC, NULL);
+
 		spin_lock(&log->l_icloglock);
 		retval = xlog_state_ioerror(log);
 		spin_unlock(&log->l_icloglock);
Index: xfs/fs/xfs/xfs_log.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log.h	2010-01-19 10:49:18.100003304 +0100
+++ xfs/fs/xfs/xfs_log.h	2010-01-19 10:49:33.511025262 +0100
@@ -70,14 +70,8 @@ static inline xfs_lsn_t	_lsn_cmp(xfs_lsn
  * Flags to xfs_log_force()
  *
  *	XFS_LOG_SYNC:	Synchronous force in-core log to disk
- *	XFS_LOG_FORCE:	Start in-core log write now.
- *	XFS_LOG_URGE:	Start write within some window of time.
- *
- * Note: Either XFS_LOG_FORCE or XFS_LOG_URGE must be set.
  */
 #define XFS_LOG_SYNC		0x1
-#define XFS_LOG_FORCE		0x2
-#define XFS_LOG_URGE		0x4
 
 #endif	/* __KERNEL__ */
 
@@ -138,12 +132,17 @@ xfs_lsn_t xfs_log_done(struct xfs_mount 
 		       void		**iclog,
 		       uint		flags);
 int	  _xfs_log_force(struct xfs_mount *mp,
-			 xfs_lsn_t	lsn,
 			 uint		flags,
 			 int		*log_forced);
 void	  xfs_log_force(struct xfs_mount	*mp,
-			xfs_lsn_t		lsn,
 			uint			flags);
+int	  _xfs_log_force_lsn(struct xfs_mount *mp,
+			     xfs_lsn_t		lsn,
+			     uint		flags,
+			     int		*log_forced);
+void	  xfs_log_force_lsn(struct xfs_mount	*mp,
+			    xfs_lsn_t		lsn,
+			    uint		flags);
 int	  xfs_log_mount(struct xfs_mount	*mp,
 			struct xfs_buftarg	*log_target,
 			xfs_daddr_t		start_block,
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2010-01-19 10:49:11.274010893 +0100
+++ xfs/fs/xfs/xfs_log_recover.c	2010-01-19 10:49:33.513003936 +0100
@@ -3913,8 +3913,7 @@ xlog_recover_finish(
 		 * case the unlink transactions would have problems
 		 * pushing the EFIs out of the way.
 		 */
-		xfs_log_force(log->l_mp, (xfs_lsn_t)0,
-			      (XFS_LOG_FORCE | XFS_LOG_SYNC));
+		xfs_log_force(log->l_mp, XFS_LOG_SYNC);
 
 		xlog_recover_process_iunlinks(log);
 
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2010-01-19 10:49:11.275004245 +0100
+++ xfs/fs/xfs/xfs_mount.c	2010-01-19 10:49:33.515003771 +0100
@@ -1455,7 +1455,7 @@ xfs_unmountfs(
 	 * push out the iclog we will never get that unlocked. hence we
 	 * need to force the log first.
 	 */
-	xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE | XFS_LOG_SYNC);
+	xfs_log_force(mp, XFS_LOG_SYNC);
 	xfs_reclaim_inodes(mp, XFS_IFLUSH_ASYNC);
 
 	xfs_qm_unmount(mp);
@@ -1465,7 +1465,7 @@ xfs_unmountfs(
 	 * that nothing is pinned.  This is important because bflush()
 	 * will skip pinned buffers.
 	 */
-	xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE | XFS_LOG_SYNC);
+	xfs_log_force(mp, XFS_LOG_SYNC);
 
 	xfs_binval(mp->m_ddev_targp);
 	if (mp->m_rtdev_targp) {
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2010-01-19 10:49:18.101004269 +0100
+++ xfs/fs/xfs/xfs_trans.c	2010-01-19 10:49:33.515003771 +0100
@@ -981,9 +981,8 @@ shut_us_down:
 	 */
 	if (sync) {
 		if (!error) {
-			error = _xfs_log_force(mp, commit_lsn,
-				      XFS_LOG_FORCE | XFS_LOG_SYNC,
-				      log_flushed);
+			error = _xfs_log_force_lsn(mp, commit_lsn,
+				      XFS_LOG_SYNC, log_flushed);
 		}
 		XFS_STATS_INC(xs_trans_sync);
 	} else {
Index: xfs/fs/xfs/xfs_trans_ail.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_ail.c	2010-01-17 23:33:04.576253340 +0100
+++ xfs/fs/xfs/xfs_trans_ail.c	2010-01-19 10:49:33.516004248 +0100
@@ -371,7 +371,7 @@ xfsaild_push(
 		 * move forward in the AIL.
 		 */
 		XFS_STATS_INC(xs_push_ail_flush);
-		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
+		xfs_log_force(mp, 0);
 	}
 
 	if (!count) {
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2010-01-19 10:49:11.278003231 +0100
+++ xfs/fs/xfs/xfs_vnodeops.c	2010-01-19 10:49:33.518003874 +0100
@@ -631,9 +631,8 @@ xfs_fsync(
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 		if (xfs_ipincount(ip)) {
-			error = _xfs_log_force(ip->i_mount, (xfs_lsn_t)0,
-				      XFS_LOG_FORCE | XFS_LOG_SYNC,
-				      &log_flushed);
+			error = _xfs_log_force(ip->i_mount, XFS_LOG_SYNC,
+					       &log_flushed);
 		} else {
 			/*
 			 * If the inode is not pinned and nothing has changed

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
