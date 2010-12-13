Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD51bVj160854 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 23:01:37 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5D04143FE50
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 20:46:36 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	z9dljIF2TUYtAksJ for <xfs@oss.sgi.com>;
	Sun, 12 Dec 2010 20:46:36 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	49889413-1927428
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 15:16:35 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PS0Iz-00022c-Dz
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:46:33 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PS0HV-0004mU-9E
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:45:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/12] xfs: use wait queues directly for the log wait queues
Date: Mon, 13 Dec 2010 15:44:36 +1100
Message-Id: <1292215483-18224-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1292215483-18224-1-git-send-email-david@fromorbit.com>
References: <1292215483-18224-1-git-send-email-david@fromorbit.com>
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

The log grant queues are one of the few places left using sv_t
constructs for waiting. Given we are touching this code, we should
convert them to plain wait queues. While there, convert all the
other sv_t users in the log code as well.

Seeing as this removes the last users of the sv_t type, remove the
header file defining the wrapper and the fragments that still
reference it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/sv.h        |   59 --------------------------------------
 fs/xfs/linux-2.6/xfs_linux.h |    1 -
 fs/xfs/quota/xfs_dquot.c     |    1 -
 fs/xfs/xfs_log.c             |   64 ++++++++++++++++++-----------------------
 fs/xfs/xfs_log_cil.c         |    8 ++--
 fs/xfs/xfs_log_priv.h        |   25 +++++++++++++---
 6 files changed, 52 insertions(+), 106 deletions(-)
 delete mode 100644 fs/xfs/linux-2.6/sv.h

diff --git a/fs/xfs/linux-2.6/sv.h b/fs/xfs/linux-2.6/sv.h
deleted file mode 100644
index 4dfc7c3..0000000
--- a/fs/xfs/linux-2.6/sv.h
+++ /dev/null
@@ -1,59 +0,0 @@
-/*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_SUPPORT_SV_H__
-#define __XFS_SUPPORT_SV_H__
-
-#include <linux/wait.h>
-#include <linux/sched.h>
-#include <linux/spinlock.h>
-
-/*
- * Synchronisation variables.
- *
- * (Parameters "pri", "svf" and "rts" are not implemented)
- */
-
-typedef struct sv_s {
-	wait_queue_head_t waiters;
-} sv_t;
-
-static inline void _sv_wait(sv_t *sv, spinlock_t *lock)
-{
-	DECLARE_WAITQUEUE(wait, current);
-
-	add_wait_queue_exclusive(&sv->waiters, &wait);
-	__set_current_state(TASK_UNINTERRUPTIBLE);
-	spin_unlock(lock);
-
-	schedule();
-
-	remove_wait_queue(&sv->waiters, &wait);
-}
-
-#define sv_init(sv,flag,name) \
-	init_waitqueue_head(&(sv)->waiters)
-#define sv_destroy(sv) \
-	/*NOTHING*/
-#define sv_wait(sv, pri, lock, s) \
-	_sv_wait(sv, lock)
-#define sv_signal(sv) \
-	wake_up(&(sv)->waiters)
-#define sv_broadcast(sv) \
-	wake_up_all(&(sv)->waiters)
-
-#endif /* __XFS_SUPPORT_SV_H__ */
diff --git a/fs/xfs/linux-2.6/xfs_linux.h b/fs/xfs/linux-2.6/xfs_linux.h
index 9fa4f2a..ccebd86 100644
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -37,7 +37,6 @@
 
 #include <kmem.h>
 #include <mrlock.h>
-#include <sv.h>
 #include <time.h>
 
 #include <support/debug.h>
diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index faf8e1a..d22aa31 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -149,7 +149,6 @@ xfs_qm_dqdestroy(
 	ASSERT(list_empty(&dqp->q_freelist));
 
 	mutex_destroy(&dqp->q_qlock);
-	sv_destroy(&dqp->q_pinwait);
 	kmem_zone_free(xfs_Gqm->qm_dqzone, dqp);
 
 	atomic_dec(&xfs_Gqm->qm_totaldquots);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3299faa..3656d77 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -547,8 +547,8 @@ xfs_log_unmount_write(xfs_mount_t *mp)
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
@@ -588,8 +588,8 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 			|| iclog->ic_state == XLOG_STATE_DIRTY
 			|| iclog->ic_state == XLOG_STATE_IOERROR) ) {
 
-				sv_wait(&iclog->ic_force_wait, PMEM,
-					&log->l_icloglock, s);
+				xlog_wait(&iclog->ic_force_wait,
+							&log->l_icloglock);
 		} else {
 			spin_unlock(&log->l_icloglock);
 		}
@@ -700,7 +700,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 				break;
 			tail_lsn = 0;
 			free_bytes -= tic->t_unit_res;
-			sv_signal(&tic->t_wait);
+			wake_up(&tic->t_wait);
 		}
 	}
 
@@ -719,7 +719,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 				break;
 			tail_lsn = 0;
 			free_bytes -= need_bytes;
-			sv_signal(&tic->t_wait);
+			wake_up(&tic->t_wait);
 		}
 	}
 	spin_unlock(&log->l_grant_lock);
@@ -1060,7 +1060,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 
 	spin_lock_init(&log->l_icloglock);
 	spin_lock_init(&log->l_grant_lock);
-	sv_init(&log->l_flush_wait, 0, "flush_wait");
+	init_waitqueue_head(&log->l_flush_wait);
 
 	/* log record size must be multiple of BBSIZE; see xlog_rec_header_t */
 	ASSERT((XFS_BUF_SIZE(bp) & BBMASK) == 0);
@@ -1116,8 +1116,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
 
 		ASSERT(XFS_BUF_ISBUSY(iclog->ic_bp));
 		ASSERT(XFS_BUF_VALUSEMA(iclog->ic_bp) <= 0);
-		sv_init(&iclog->ic_force_wait, SV_DEFAULT, "iclog-force");
-		sv_init(&iclog->ic_write_wait, SV_DEFAULT, "iclog-write");
+		init_waitqueue_head(&iclog->ic_force_wait);
+		init_waitqueue_head(&iclog->ic_write_wait);
 
 		iclogp = &iclog->ic_next;
 	}
@@ -1132,11 +1132,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
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
 	spinlock_destroy(&log->l_icloglock);
@@ -1453,8 +1450,6 @@ xlog_dealloc_log(xlog_t *log)
 
 	iclog = log->l_iclog;
 	for (i=0; i<log->l_iclog_bufs; i++) {
-		sv_destroy(&iclog->ic_force_wait);
-		sv_destroy(&iclog->ic_write_wait);
 		xfs_buf_free(iclog->ic_bp);
 		next_iclog = iclog->ic_next;
 		kmem_free(iclog);
@@ -2261,7 +2256,7 @@ xlog_state_do_callback(
 			xlog_state_clean_log(log);
 
 			/* wake up threads waiting in xfs_log_force() */
-			sv_broadcast(&iclog->ic_force_wait);
+			wake_up_all(&iclog->ic_force_wait);
 
 			iclog = iclog->ic_next;
 		} while (first_iclog != iclog);
@@ -2308,7 +2303,7 @@ xlog_state_do_callback(
 	spin_unlock(&log->l_icloglock);
 
 	if (wake)
-		sv_broadcast(&log->l_flush_wait);
+		wake_up_all(&log->l_flush_wait);
 }
 
 
@@ -2359,7 +2354,7 @@ xlog_state_done_syncing(
 	 * iclog buffer, we wake them all, one will get to do the
 	 * I/O, the others get to wait for the result.
 	 */
-	sv_broadcast(&iclog->ic_write_wait);
+	wake_up_all(&iclog->ic_write_wait);
 	spin_unlock(&log->l_icloglock);
 	xlog_state_do_callback(log, aborted, iclog);	/* also cleans log */
 }	/* xlog_state_done_syncing */
@@ -2408,7 +2403,7 @@ restart:
 		XFS_STATS_INC(xs_log_noiclogs);
 
 		/* Wait for log writes to have flushed */
-		sv_wait(&log->l_flush_wait, 0, &log->l_icloglock, 0);
+		xlog_wait(&log->l_flush_wait, &log->l_icloglock);
 		goto restart;
 	}
 
@@ -2523,7 +2518,8 @@ xlog_grant_log_space(xlog_t	   *log,
 			goto error_return;
 
 		XFS_STATS_INC(xs_sleep_logspace);
-		sv_wait(&tic->t_wait, PINOD|PLTWAIT, &log->l_grant_lock, s);
+		xlog_wait(&tic->t_wait, &log->l_grant_lock);
+
 		/*
 		 * If we got an error, and the filesystem is shutting down,
 		 * we'll catch it down below. So just continue...
@@ -2552,7 +2548,7 @@ redo:
 		spin_lock(&log->l_grant_lock);
 
 		XFS_STATS_INC(xs_sleep_logspace);
-		sv_wait(&tic->t_wait, PINOD|PLTWAIT, &log->l_grant_lock, s);
+		xlog_wait(&tic->t_wait, &log->l_grant_lock);
 
 		spin_lock(&log->l_grant_lock);
 		if (XLOG_FORCED_SHUTDOWN(log))
@@ -2635,7 +2631,7 @@ xlog_regrant_write_log_space(xlog_t	   *log,
 			if (free_bytes < ntic->t_unit_res)
 				break;
 			free_bytes -= ntic->t_unit_res;
-			sv_signal(&ntic->t_wait);
+			wake_up(&ntic->t_wait);
 		}
 
 		if (ntic != list_first_entry(&log->l_writeq,
@@ -2650,8 +2646,7 @@ xlog_regrant_write_log_space(xlog_t	   *log,
 			spin_lock(&log->l_grant_lock);
 
 			XFS_STATS_INC(xs_sleep_logspace);
-			sv_wait(&tic->t_wait, PINOD|PLTWAIT,
-				&log->l_grant_lock, s);
+			xlog_wait(&tic->t_wait, &log->l_grant_lock);
 
 			/* If we're shutting down, this tic is already
 			 * off the queue */
@@ -2677,8 +2672,7 @@ redo:
 
 		XFS_STATS_INC(xs_sleep_logspace);
 		trace_xfs_log_regrant_write_sleep2(log, tic);
-
-		sv_wait(&tic->t_wait, PINOD|PLTWAIT, &log->l_grant_lock, s);
+		xlog_wait(&tic->t_wait, &log->l_grant_lock);
 
 		/* If we're shutting down, this tic is already off the queue */
 		spin_lock(&log->l_grant_lock);
@@ -3029,7 +3023,7 @@ maybe_sleep:
 			return XFS_ERROR(EIO);
 		}
 		XFS_STATS_INC(xs_log_force_sleep);
-		sv_wait(&iclog->ic_force_wait, PINOD, &log->l_icloglock, s);
+		xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
 		/*
 		 * No need to grab the log lock here since we're
 		 * only deciding whether or not to return EIO
@@ -3147,8 +3141,8 @@ try_again:
 
 				XFS_STATS_INC(xs_log_force_sleep);
 
-				sv_wait(&iclog->ic_prev->ic_write_wait,
-					PSWP, &log->l_icloglock, s);
+				xlog_wait(&iclog->ic_prev->ic_write_wait,
+							&log->l_icloglock);
 				if (log_flushed)
 					*log_flushed = 1;
 				already_slept = 1;
@@ -3176,7 +3170,7 @@ try_again:
 				return XFS_ERROR(EIO);
 			}
 			XFS_STATS_INC(xs_log_force_sleep);
-			sv_wait(&iclog->ic_force_wait, PSWP, &log->l_icloglock, s);
+			xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
 			/*
 			 * No need to grab the log lock here since we're
 			 * only deciding whether or not to return EIO
@@ -3251,10 +3245,8 @@ xfs_log_ticket_put(
 	xlog_ticket_t	*ticket)
 {
 	ASSERT(atomic_read(&ticket->t_ref) > 0);
-	if (atomic_dec_and_test(&ticket->t_ref)) {
-		sv_destroy(&ticket->t_wait);
+	if (atomic_dec_and_test(&ticket->t_ref))
 		kmem_zone_free(xfs_log_ticket_zone, ticket);
-	}
 }
 
 xlog_ticket_t *
@@ -3387,7 +3379,7 @@ xlog_ticket_alloc(
 	tic->t_trans_type	= 0;
 	if (xflags & XFS_LOG_PERM_RESERV)
 		tic->t_flags |= XLOG_TIC_PERM_RESERV;
-	sv_init(&tic->t_wait, SV_DEFAULT, "logtick");
+	init_waitqueue_head(&tic->t_wait);
 
 	xlog_tic_reset_res(tic);
 
@@ -3719,10 +3711,10 @@ xfs_log_force_umount(
 	 * action is protected by the GRANTLOCK.
 	 */
 	list_for_each_entry(tic, &log->l_reserveq, t_queue)
-		sv_signal(&tic->t_wait);
+		wake_up(&tic->t_wait);
 
 	list_for_each_entry(tic, &log->l_writeq, t_queue)
-		sv_signal(&tic->t_wait);
+		wake_up(&tic->t_wait);
 	spin_unlock(&log->l_grant_lock);
 
 	if (!(log->l_iclog->ic_state & XLOG_STATE_IOERROR)) {
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
index 2fd4819..84c5e79 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -242,7 +242,7 @@ typedef struct xlog_res {
 } xlog_res_t;
 
 typedef struct xlog_ticket {
-	sv_t		   t_wait;	 /* ticket wait queue            : 20 */
+	wait_queue_head_t  t_wait;	 /* ticket wait queue */
 	struct list_head   t_queue;	 /* reserve/write queue */
 	xlog_tid_t	   t_tid;	 /* transaction identifier	 : 4  */
 	atomic_t	   t_ref;	 /* ticket reference count       : 4  */
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
@@ -600,6 +600,21 @@ xlog_cil_force(struct log *log)
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
