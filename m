Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 04:15:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3UBEcTR001047
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 04:14:43 -0700
Date: Wed, 30 Apr 2008 07:15:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Remove l_flushsema
Message-ID: <20080430111521.GA16571@infradead.org>
References: <20080430090502.GH14976@parisc-linux.org> <20080430104125.GM108924158@sgi.com> <20080430105832.GA20442@infradead.org> <20080430111154.GO108924158@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430111154.GO108924158@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, xfs@oss.sgi.com

On Wed, Apr 30, 2008 at 09:11:54PM +1000, David Chinner wrote:
> > waitqueues are loked internally and don't need synchronization.  With
> > a little bit of re-arranging the code the wake_up could probably be
> > moved out of the critical section.
> 
> Yeah, I just realised that myself and was about to reply as such....
> 
> I'll move the wakeup outside the lock.

Below is the version I have now.  One of the rare cases where using
sv_t actually cleans up the code (althoug the whole sv_ family should
probably loose some arguments).

Index: linux-2.6-xfs/fs/xfs/xfs_log.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log.c	2008-04-25 20:11:58.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log.c	2008-04-30 13:13:48.000000000 +0200
@@ -1228,7 +1228,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 
 	spin_lock_init(&log->l_icloglock);
 	spin_lock_init(&log->l_grant_lock);
-	initnsema(&log->l_flushsema, 0, "ic-flush");
+	sv_init(&log->l_flush_wait, 0, "flush_wait");
 
 	/* log record size must be multiple of BBSIZE; see xlog_rec_header_t */
 	ASSERT((XFS_BUF_SIZE(bp) & BBMASK) == 0);
@@ -1573,7 +1573,6 @@ xlog_dealloc_log(xlog_t *log)
 		kmem_free(iclog, sizeof(xlog_in_core_t));
 		iclog = next_iclog;
 	}
-	freesema(&log->l_flushsema);
 	spinlock_destroy(&log->l_icloglock);
 	spinlock_destroy(&log->l_grant_lock);
 
@@ -2097,6 +2096,7 @@ xlog_state_do_callback(
 	int		   funcdidcallbacks; /* flag: function did callbacks */
 	int		   repeats;	/* for issuing console warnings if
 					 * looping too many times */
+	int		   wake = 0;
 
 	spin_lock(&log->l_icloglock);
 	first_iclog = iclog = log->l_iclog;
@@ -2278,15 +2278,13 @@ xlog_state_do_callback(
 	}
 #endif
 
-	flushcnt = 0;
-	if (log->l_iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_IOERROR)) {
-		flushcnt = log->l_flushcnt;
-		log->l_flushcnt = 0;
-	}
+	if (log->l_iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_IOERROR))
+		wake = 1;
 	spin_unlock(&log->l_icloglock);
-	while (flushcnt--)
-		vsema(&log->l_flushsema);
-}	/* xlog_state_do_callback */
+
+	if (wake)
+		sv_broadcast(&log->l_flush_wait);
+}
 
 
 /*
@@ -2384,16 +2382,15 @@ restart:
 	}
 
 	iclog = log->l_iclog;
-	if (! (iclog->ic_state == XLOG_STATE_ACTIVE)) {
-		log->l_flushcnt++;
-		spin_unlock(&log->l_icloglock);
+	if (iclog->ic_state != XLOG_STATE_ACTIVE) {
 		xlog_trace_iclog(iclog, XLOG_TRACE_SLEEP_FLUSH);
 		XFS_STATS_INC(xs_log_noiclogs);
-		/* Ensure that log writes happen */
-		psema(&log->l_flushsema, PINOD);
+
+		/* Wait for log writes to have flushed */
+		sv_wait(&log->l_flush_wait, 0, &log->l_icloglock, 0);
 		goto restart;
 	}
-	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
+
 	head = &iclog->ic_header;
 
 	atomic_inc(&iclog->ic_refcnt);	/* prevents sync */
Index: linux-2.6-xfs/fs/xfs/xfs_log_priv.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_priv.h	2008-04-25 20:11:58.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_priv.h	2008-04-30 13:09:33.000000000 +0200
@@ -423,10 +423,8 @@ typedef struct log {
 	int			l_logBBsize;    /* size of log in BB chunks */
 
 	/* The following block of fields are changed while holding icloglock */
-	sema_t			l_flushsema ____cacheline_aligned_in_smp;
-						/* iclog flushing semaphore */
-	int			l_flushcnt;	/* # of procs waiting on this
-						 * sema */
+	sv_t			l_flush_wait ____cacheline_aligned_in_smp;
+						/* waiting for iclog flush */
 	int			l_covered_state;/* state of "covering disk
 						 * log entries" */
 	xlog_in_core_t		*l_iclog;       /* head log queue	*/
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-04-30 13:09:58.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-04-30 13:10:26.000000000 +0200
@@ -5829,8 +5829,8 @@ xfsidbg_xlog(xlog_t *log)
 	};
 
 	kdb_printf("xlog at 0x%p\n", log);
-	kdb_printf("&flushsm: 0x%p  flushcnt: %d  ICLOG: 0x%p  \n",
-		&log->l_flushsema, log->l_flushcnt, log->l_iclog);
+	kdb_printf("&flush_wait: 0x%p  ICLOG: 0x%p  \n",
+		&log->l_flush_wait, log->l_iclog);
 	kdb_printf("&icloglock: 0x%p  tail_lsn: %s  last_sync_lsn: %s \n",
 		&log->l_icloglock, xfs_fmtlsn(&log->l_tail_lsn),
 		xfs_fmtlsn(&log->l_last_sync_lsn));
