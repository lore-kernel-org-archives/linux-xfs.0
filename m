Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 02:04:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3U94KoG023006
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 02:04:26 -0700
Received: from mail.parisc-linux.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68A74160C447
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 02:05:04 -0700 (PDT)
Received: from mail.parisc-linux.org (palinux.external.hp.com [192.25.206.14]) by cuda.sgi.com with ESMTP id freYBHni3bDc7RcJ for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 02:05:04 -0700 (PDT)
Date: Wed, 30 Apr 2008 03:05:03 -0600
From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Remove l_flushsema
Message-ID: <20080430090502.GH14976@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org


The l_flushsema doesn't exactly have completion semantics, nor mutex
semantics.  It's used as a list of tasks which are waiting to be notified
that a flush has completed.  It was also being used in a way that was
potentially racy, depending on the semaphore implementation.

By using a waitqueue instead of a semaphore we avoid the need for a
separate counter, since we know we just need to wake everything on the
queue.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

-- 

I've only given this light testing, it could use some more.

 fs/xfs/xfs_log.c             |   19 +++++++------------
 fs/xfs/xfs_log_priv.h        |    6 ++----
 2 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index afaee30..d2e3092 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1228,7 +1228,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 
 	spin_lock_init(&log->l_icloglock);
 	spin_lock_init(&log->l_grant_lock);
-	initnsema(&log->l_flushsema, 0, "ic-flush");
+	init_waitqueue_head(&log->l_flush_wq);
 
 	/* log record size must be multiple of BBSIZE; see xlog_rec_header_t */
 	ASSERT((XFS_BUF_SIZE(bp) & BBMASK) == 0);
@@ -1573,7 +1573,6 @@ xlog_dealloc_log(xlog_t *log)
 		kmem_free(iclog, sizeof(xlog_in_core_t));
 		iclog = next_iclog;
 	}
-	freesema(&log->l_flushsema);
 	spinlock_destroy(&log->l_icloglock);
 	spinlock_destroy(&log->l_grant_lock);
 
@@ -2278,14 +2277,9 @@ xlog_state_do_callback(
 	}
 #endif
 
-	flushcnt = 0;
-	if (log->l_iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_IOERROR)) {
-		flushcnt = log->l_flushcnt;
-		log->l_flushcnt = 0;
-	}
+	if (log->l_iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_IOERROR)) 
+		wake_up_all(&log->l_flush_wq);
 	spin_unlock(&log->l_icloglock);
-	while (flushcnt--)
-		vsema(&log->l_flushsema);
 }	/* xlog_state_do_callback */
 
 
@@ -2385,12 +2379,13 @@ restart:
 
 	iclog = log->l_iclog;
 	if (! (iclog->ic_state == XLOG_STATE_ACTIVE)) {
-		log->l_flushcnt++;
+		DEFINE_WAIT(wait);
+		prepare_to_wait(&log->l_flush_wq, &wait, TASK_UNINTERRUPTIBLE);
 		spin_unlock(&log->l_icloglock);
 		xlog_trace_iclog(iclog, XLOG_TRACE_SLEEP_FLUSH);
 		XFS_STATS_INC(xs_log_noiclogs);
-		/* Ensure that log writes happen */
-		psema(&log->l_flushsema, PINOD);
+		/* Wait for log writes to have flushed */
+		schedule();
 		goto restart;
 	}
 	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 8952a39..a6dff16 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -423,10 +423,8 @@ typedef struct log {
 	int			l_logBBsize;    /* size of log in BB chunks */
 
 	/* The following block of fields are changed while holding icloglock */
-	sema_t			l_flushsema ____cacheline_aligned_in_smp;
-						/* iclog flushing semaphore */
-	int			l_flushcnt;	/* # of procs waiting on this
-						 * sema */
+	wait_queue_head_t	l_flush_wq ____cacheline_aligned_in_smp;
+						/* waiting for iclog flush */
 	int			l_covered_state;/* state of "covering disk
 						 * log entries" */
 	xlog_in_core_t		*l_iclog;       /* head log queue	*/

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
