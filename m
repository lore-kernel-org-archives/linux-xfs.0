Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT1bZDh082261 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 19:37:35 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A643013F660D
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 17:39:15 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	d8aE3fnAqwJTX1xF for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 17:39:15 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	2744521-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 12:09:14 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMsi0-0000eH-1v
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:39:12 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMsha-0005cs-Fz
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:38:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/14] xfs: replace use of sv_t with waitqueues in the log
Date: Mon, 29 Nov 2010 12:38:31 +1100
Message-Id: <1290994712-21376-14-git-send-email-david@fromorbit.com>
In-Reply-To: <1290994712-21376-1-git-send-email-david@fromorbit.com>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Only the log still uses the old Irix wait queue interface. The log
grant lock scaling series killed one of the users, so convert
the remaining users of sv_t to plain wait queues so the sv_t wrapper can
be removed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      |   51 +++++++++++++++++-------------------------------
 fs/xfs/xfs_log_cil.c  |    8 +++---
 fs/xfs/xfs_log_priv.h |   23 ++++++++++++++++++---
 3 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 5c455cb..abdcbd0 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -613,8 +613,8 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 		if (!(iclog->ic_state == XLOG_STATE_ACTIVE ||
 		      iclog->ic_state == XLOG_STATE_DIRTY)) {
 			if (!XLOG_FORCED_SHUTDOWN(log)) {
-				sv_wait(&iclog->ic_force_wait, PMEM,
-					&log->l_icloglock, s);
+				xlog_wait(&iclog->ic_force_wait,
+							&log->l_icloglock);
 			} else {
 				spin_unlock(&log->l_icloglock);
 			}
@@ -654,8 +654,8 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 			|| iclog->ic_state == XLOG_STATE_DIRTY
 			|| iclog->ic_state == XLOG_STATE_IOERROR) ) {
 
-				sv_wait(&iclog->ic_force_wait, PMEM,
-					&log->l_icloglock, s);
+				xlog_wait(&iclog->ic_force_wait,
+							&log->l_icloglock);
 		} else {
 			spin_unlock(&log->l_icloglock);
 		}
@@ -1118,7 +1118,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	log->l_xbuf = bp;
 
 	spin_lock_init(&log->l_icloglock);
-	sv_init(&log->l_flush_wait, 0, "flush_wait");
+	init_waitqueue_head(&log->l_flush_wait);
 
 	/* log record size must be multiple of BBSIZE; see xlog_rec_header_t */
 	ASSERT((XFS_BUF_SIZE(bp) & BBMASK) == 0);
@@ -1174,8 +1174,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
 
 		ASSERT(XFS_BUF_ISBUSY(iclog->ic_bp));
 		ASSERT(XFS_BUF_VALUSEMA(iclog->ic_bp) <= 0);
-		sv_init(&iclog->ic_force_wait, SV_DEFAULT, "iclog-force");
-		sv_init(&iclog->ic_write_wait, SV_DEFAULT, "iclog-write");
+		init_waitqueue_head(&iclog->ic_force_wait);
+		init_waitqueue_head(&iclog->ic_write_wait);
 
 		iclogp = &iclog->ic_next;
 	}
@@ -1190,11 +1190,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
 out_free_iclog:
 	for (iclog = log->l_iclog; iclog; iclog = prev_iclog) {
 		prev_iclog = iclog->ic_next;
-		if (iclog->ic_bp) {
-			sv_destroy(&iclog->ic_force_wait);
-			sv_destroy(&iclog->ic_write_wait);
+		if (iclog->ic_bp)
 			xfs_buf_free(iclog->ic_bp);
-		}
 		kmem_free(iclog);
 	}
 	xfs_buf_free(log->l_xbuf);
@@ -1505,8 +1502,6 @@ xlog_dealloc_log(xlog_t *log)
 
 	iclog = log->l_iclog;
 	for (i=0; i<log->l_iclog_bufs; i++) {
-		sv_destroy(&iclog->ic_force_wait);
-		sv_destroy(&iclog->ic_write_wait);
 		xfs_buf_free(iclog->ic_bp);
 		next_iclog = iclog->ic_next;
 		kmem_free(iclog);
@@ -2309,7 +2304,7 @@ xlog_state_do_callback(
 			xlog_state_clean_log(log);
 
 			/* wake up threads waiting in xfs_log_force() */
-			sv_broadcast(&iclog->ic_force_wait);
+			wake_up_all(&iclog->ic_force_wait);
 
 			iclog = iclog->ic_next;
 		} while (first_iclog != iclog);
@@ -2356,7 +2351,7 @@ xlog_state_do_callback(
 	spin_unlock(&log->l_icloglock);
 
 	if (wake)
-		sv_broadcast(&log->l_flush_wait);
+		wake_up_all(&log->l_flush_wait);
 }
 
 
@@ -2407,7 +2402,7 @@ xlog_state_done_syncing(
 	 * iclog buffer, we wake them all, one will get to do the
 	 * I/O, the others get to wait for the result.
 	 */
-	sv_broadcast(&iclog->ic_write_wait);
+	wake_up_all(&iclog->ic_write_wait);
 	spin_unlock(&log->l_icloglock);
 	xlog_state_do_callback(log, aborted, iclog);	/* also cleans log */
 }	/* xlog_state_done_syncing */
@@ -2456,7 +2451,7 @@ restart:
 		XFS_STATS_INC(xs_log_noiclogs);
 
 		/* Wait for log writes to have flushed */
-		sv_wait(&log->l_flush_wait, 0, &log->l_icloglock, 0);
+		xlog_wait(&log->l_flush_wait, &log->l_icloglock);
 		goto restart;
 	}
 
@@ -2559,7 +2554,6 @@ xlog_grant_log_space(
 {
 	int			 free_bytes;
 	int			 need_bytes;
-	DECLARE_WAITQUEUE(wait, current);
 
 #ifdef DEBUG
 	if (log->l_flags & XLOG_ACTIVE_RECOVERY)
@@ -2611,12 +2605,8 @@ redo:
 			spin_unlock(&log->l_grant_reserve_lock);
 			goto error_return;
 		}
-		add_wait_queue_exclusive(&tic->t_wait, &wait);
-		__set_current_state(TASK_UNINTERRUPTIBLE);
-		spin_unlock(&log->l_grant_reserve_lock);
-		schedule();
-		remove_wait_queue(&tic->t_wait, &wait);
 
+		xlog_wait(&tic->t_wait, &log->l_grant_reserve_lock);
 		trace_xfs_log_grant_wake(log, tic);
 		goto redo;
 	}
@@ -2665,7 +2655,6 @@ xlog_regrant_write_log_space(
 {
 	int			free_bytes;
 	int			need_bytes;
-	DECLARE_WAITQUEUE(wait, current);
 
 	tic->t_curr_res = tic->t_unit_res;
 	xlog_tic_reset_res(tic);
@@ -2743,12 +2732,8 @@ redo:
 			spin_unlock(&log->l_grant_write_lock);
 			goto error_return;
 		}
-		add_wait_queue_exclusive(&tic->t_wait, &wait);
-		__set_current_state(TASK_UNINTERRUPTIBLE);
-		spin_unlock(&log->l_grant_write_lock);
-		schedule();
-		remove_wait_queue(&tic->t_wait, &wait);
 
+		xlog_wait(&tic->t_wait, &log->l_grant_write_lock);
 		trace_xfs_log_regrant_write_wake(log, tic);
 		goto redo;
 	}
@@ -3086,7 +3071,7 @@ maybe_sleep:
 			return XFS_ERROR(EIO);
 		}
 		XFS_STATS_INC(xs_log_force_sleep);
-		sv_wait(&iclog->ic_force_wait, PINOD, &log->l_icloglock, s);
+		xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
 		/*
 		 * No need to grab the log lock here since we're
 		 * only deciding whether or not to return EIO
@@ -3204,8 +3189,8 @@ try_again:
 
 				XFS_STATS_INC(xs_log_force_sleep);
 
-				sv_wait(&iclog->ic_prev->ic_write_wait,
-					PSWP, &log->l_icloglock, s);
+				xlog_wait(&iclog->ic_prev->ic_write_wait,
+							&log->l_icloglock);
 				if (log_flushed)
 					*log_flushed = 1;
 				already_slept = 1;
@@ -3233,7 +3218,7 @@ try_again:
 				return XFS_ERROR(EIO);
 			}
 			XFS_STATS_INC(xs_log_force_sleep);
-			sv_wait(&iclog->ic_force_wait, PSWP, &log->l_icloglock, s);
+			xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
 			/*
 			 * No need to grab the log lock here since we're
 			 * only deciding whether or not to return EIO
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f36f1a2..9dc8125 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -61,7 +61,7 @@ xlog_cil_init(
 	INIT_LIST_HEAD(&cil->xc_committing);
 	spin_lock_init(&cil->xc_cil_lock);
 	init_rwsem(&cil->xc_ctx_lock);
-	sv_init(&cil->xc_commit_wait, SV_DEFAULT, "cilwait");
+	init_waitqueue_head(&cil->xc_commit_wait);
 
 	INIT_LIST_HEAD(&ctx->committing);
 	INIT_LIST_HEAD(&ctx->busy_extents);
@@ -563,7 +563,7 @@ restart:
 			 * It is still being pushed! Wait for the push to
 			 * complete, then start again from the beginning.
 			 */
-			sv_wait(&cil->xc_commit_wait, 0, &cil->xc_cil_lock, 0);
+			xlog_wait(&cil->xc_commit_wait, &cil->xc_cil_lock);
 			goto restart;
 		}
 	}
@@ -587,7 +587,7 @@ restart:
 	 */
 	spin_lock(&cil->xc_cil_lock);
 	ctx->commit_lsn = commit_lsn;
-	sv_broadcast(&cil->xc_commit_wait);
+	wake_up_all(&cil->xc_commit_wait);
 	spin_unlock(&cil->xc_cil_lock);
 
 	/* release the hounds! */
@@ -752,7 +752,7 @@ restart:
 			 * It is still being pushed! Wait for the push to
 			 * complete, then start again from the beginning.
 			 */
-			sv_wait(&cil->xc_commit_wait, 0, &cil->xc_cil_lock, 0);
+			xlog_wait(&cil->xc_commit_wait, &cil->xc_cil_lock);
 			goto restart;
 		}
 		if (ctx->sequence != sequence)
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index cd62400..230d5ce 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -350,8 +350,8 @@ typedef union xlog_in_core2 {
  * and move everything else out to subsequent cachelines.
  */
 typedef struct xlog_in_core {
-	sv_t			ic_force_wait;
-	sv_t			ic_write_wait;
+	wait_queue_head_t	ic_force_wait;
+	wait_queue_head_t	ic_write_wait;
 	struct xlog_in_core	*ic_next;
 	struct xlog_in_core	*ic_prev;
 	struct xfs_buf		*ic_bp;
@@ -418,7 +418,7 @@ struct xfs_cil {
 	struct xfs_cil_ctx	*xc_ctx;
 	struct rw_semaphore	xc_ctx_lock;
 	struct list_head	xc_committing;
-	sv_t			xc_commit_wait;
+	wait_queue_head_t	xc_commit_wait;
 	xfs_lsn_t		xc_current_sequence;
 };
 
@@ -500,7 +500,7 @@ typedef struct log {
 	int			l_logBBsize;    /* size of log in BB chunks */
 
 	/* The following block of fields are changed while holding icloglock */
-	sv_t			l_flush_wait ____cacheline_aligned_in_smp;
+	wait_queue_head_t	l_flush_wait ____cacheline_aligned_in_smp;
 						/* waiting for iclog flush */
 	int			l_covered_state;/* state of "covering disk
 						 * log entries" */
@@ -593,6 +593,21 @@ xlog_cil_force(struct log *log)
  */
 #define XLOG_UNMOUNT_REC_TYPE	(-1U)
 
+/*
+ * Wrapper function for waiting on a wait queue serialised against wakeups
+ * by a spinlock. This matches the semantics of all the wait queues used in the
+ * log code.
+ */
+static inline void xlog_wait(wait_queue_head_t *wq, spinlock_t *lock)
+{
+	DECLARE_WAITQUEUE(wait, current);
+
+	add_wait_queue_exclusive(wq, &wait);
+	__set_current_state(TASK_UNINTERRUPTIBLE);
+	spin_unlock(lock);
+	schedule();
+	remove_wait_queue(wq, &wait);
+}
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_LOG_PRIV_H__ */
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
