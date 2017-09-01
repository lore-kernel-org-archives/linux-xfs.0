Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38743 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbdIAPi6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 11:38:58 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] xfs: fix incorrect log_flushed on fsync
Date: Fri,  1 Sep 2017 18:39:25 +0300
Message-Id: <1504280365-25354-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>, stable@vger.kernel.org

When calling into _xfs_log_force{,_lsn}() with a pointer
to log_flushed variable, log_flushed will be set to 1 if:
1. xlog_sync() is called to flush the active log buffer
AND/OR
2. xlog_wait() is called to wait on a syncing log buffers

xfs_file_fsync() checks the value of log_flushed after
_xfs_log_force_lsn() call to optimize away an explicit
PREFLUSH request to the data block device after writing
out all the file's pages to disk.

This optimization is incorrect in the following sequence of events:

 Task A                    Task B
 -------------------------------------------------------
 xfs_file_fsync()
   _xfs_log_force_lsn()
     xlog_sync()
        [submit PREFLUSH]
                           xfs_file_fsync()
                             file_write_and_wait_range()
                               [submit WRITE X]
                               [endio  WRITE X]
                             _xfs_log_force_lsn()
                               xlog_wait()
        [endio  PREFLUSH]

The write X is not guarantied to be on persistent storage
when PREFLUSH request in completed, because write A was submitted
after the PREFLUSH request, but xfs_file_fsync() of task A will
be notified of log_flushed=1 and will skip explicit flush.

If the system crashes after fsync of task A, write X may not be
present on disk after reboot.

This bug was discovered and demonstrated using Josef Bacik's
dm-log-writes target, which can be used to record block io operations
and then replay a subset of these operations onto the target device.
The test goes something like this:
- Use fsx to execute ops of a file and record ops on log device
- Every now and then fsync the file, store md5 of file and mark
  the location in the log
- Then replay log onto device for each mark, mount fs and compare
  md5 of file to stored value

Cc: Christoph Hellwig <hch@lst.de>
Cc: Josef Bacik <jbacik@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Christoph,

Here is another, more subtle, version of the fix.
It keeps a lot more use cases optimized (e.g. many threads doing fsync
and setting WANT_SYNC may still be optimized).
It also addresses your concern that xlog_state_release_iclog()
may not actually start the buffer sync.

I tried to keep the logic as simple as possible:
If we see a buffer who is not yet SYNCING and we later
see that l_last_sync_lsn is >= to the lsn of that buffer,
we can safely say log_flushed.

I only tested this patch through a few crash test runs, not even full
xfstests cycle, so I am not sure it is correct, just posting to get
your feedback.

Is it worth something over the simpler v1 patch?
I can't really say.

Amir.

 fs/xfs/xfs_log.c | 76 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 58 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0053bcf2b10a..65e867ec00f9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3246,7 +3246,7 @@ _xfs_log_force(
 {
 	struct xlog		*log = mp->m_log;
 	struct xlog_in_core	*iclog;
-	xfs_lsn_t		lsn;
+	xfs_lsn_t		lsn_flushed = 0;
 
 	XFS_STATS_INC(mp, xs_log_force);
 
@@ -3290,17 +3290,22 @@ _xfs_log_force(
 				 * the previous sync.
 				 */
 				atomic_inc(&iclog->ic_refcnt);
-				lsn = be64_to_cpu(iclog->ic_header.h_lsn);
+				lsn_flushed = be64_to_cpu(iclog->ic_header.h_lsn);
 				xlog_state_switch_iclogs(log, iclog, 0);
 				spin_unlock(&log->l_icloglock);
 
 				if (xlog_state_release_iclog(log, iclog))
 					return -EIO;
 
-				if (log_flushed)
-					*log_flushed = 1;
 				spin_lock(&log->l_icloglock);
-				if (be64_to_cpu(iclog->ic_header.h_lsn) == lsn &&
+				/*
+				 * By the time we come around again, the iclog
+				 * could've been filled which would give it
+				 * another lsn.  If we have a new lsn, just
+				 * return because the relevant data has been
+				 * flushed.
+				 */
+				if (be64_to_cpu(iclog->ic_header.h_lsn) == lsn_flushed &&
 				    iclog->ic_state != XLOG_STATE_DIRTY)
 					goto maybe_sleep;
 				else
@@ -3317,10 +3322,6 @@ _xfs_log_force(
 		}
 	}
 
-	/* By the time we come around again, the iclog could've been filled
-	 * which would give it another lsn.  If we have a new lsn, just
-	 * return because the relevant data has been flushed.
-	 */
 maybe_sleep:
 	if (flags & XFS_LOG_SYNC) {
 		/*
@@ -3333,6 +3334,15 @@ _xfs_log_force(
 			spin_unlock(&log->l_icloglock);
 			return -EIO;
 		}
+		/*
+		 * Snapshot lsn of iclog if there is no risk that flush has been
+		 * issued already for that iclog.
+		 */
+		if (!lsn_flushed &&
+		    !(iclog->ic_state &
+		      (XLOG_STATE_DONE_SYNC | XLOG_STATE_SYNCING)))
+			lsn_flushed = be64_to_cpu(iclog->ic_header.h_lsn);
+
 		XFS_STATS_INC(mp, xs_log_force_sleep);
 		xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
 		/*
@@ -3342,13 +3352,22 @@ _xfs_log_force(
 		 */
 		if (iclog->ic_state & XLOG_STATE_IOERROR)
 			return -EIO;
-		if (log_flushed)
-			*log_flushed = 1;
 	} else {
 
 no_sleep:
 		spin_unlock(&log->l_icloglock);
 	}
+
+	if (log_flushed) {
+		/*
+		 * We only report log_flushed if flush has been issued after
+		 * entering this function (for lsn) and has already completed.
+		 * It could be that we issued the flush or another thread, as
+		 * long as we have seen this lsn in pre SYNCING state.
+		 */
+		if (XFS_LSN_CMP(lsn_flushed, atomic64_read(&log->l_last_sync_lsn)) <= 0)
+			*log_flushed = 1;
+	}
 	return 0;
 }
 
@@ -3391,6 +3410,7 @@ _xfs_log_force_lsn(
 	struct xlog		*log = mp->m_log;
 	struct xlog_in_core	*iclog;
 	int			already_slept = 0;
+	xfs_lsn_t		lsn_flushed = 0;
 
 	ASSERT(lsn != 0);
 
@@ -3445,10 +3465,15 @@ _xfs_log_force_lsn(
 
 				XFS_STATS_INC(mp, xs_log_force_sleep);
 
+				/*
+				 * prev iclog is not SYNCING so flush is going
+				 * to be issued.
+				 */
+				if (iclog->ic_prev->ic_state & XLOG_STATE_WANT_SYNC)
+					lsn_flushed = be64_to_cpu(iclog->ic_prev->ic_header.h_lsn);
+
 				xlog_wait(&iclog->ic_prev->ic_write_wait,
 							&log->l_icloglock);
-				if (log_flushed)
-					*log_flushed = 1;
 				already_slept = 1;
 				goto try_again;
 			}
@@ -3457,8 +3482,6 @@ _xfs_log_force_lsn(
 			spin_unlock(&log->l_icloglock);
 			if (xlog_state_release_iclog(log, iclog))
 				return -EIO;
-			if (log_flushed)
-				*log_flushed = 1;
 			spin_lock(&log->l_icloglock);
 		}
 
@@ -3473,6 +3496,15 @@ _xfs_log_force_lsn(
 				spin_unlock(&log->l_icloglock);
 				return -EIO;
 			}
+			/*
+			 * Snapshot lsn of iclog if there is no risk that flush
+			 * has been issued already for that iclog.
+			 */
+			if (!lsn_flushed &&
+			    !(iclog->ic_state &
+			      (XLOG_STATE_DONE_SYNC | XLOG_STATE_SYNCING)))
+			lsn_flushed = be64_to_cpu(iclog->ic_header.h_lsn);
+
 			XFS_STATS_INC(mp, xs_log_force_sleep);
 			xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
 			/*
@@ -3482,9 +3514,6 @@ _xfs_log_force_lsn(
 			 */
 			if (iclog->ic_state & XLOG_STATE_IOERROR)
 				return -EIO;
-
-			if (log_flushed)
-				*log_flushed = 1;
 		} else {		/* just return */
 			spin_unlock(&log->l_icloglock);
 		}
@@ -3493,6 +3522,17 @@ _xfs_log_force_lsn(
 	} while (iclog != log->l_iclog);
 
 	spin_unlock(&log->l_icloglock);
+
+	if (log_flushed) {
+		/*
+		 * We only report log_flushed if flush has been issued after
+		 * entering this function (for lsn) and has already completed.
+		 * It could be that we issued the flush or another thread, as
+		 * long as we have seen this lsn in pre SYNCING state.
+		 */
+		if (XFS_LSN_CMP(lsn_flushed, atomic64_read(&log->l_last_sync_lsn)) <= 0)
+			*log_flushed = 1;
+	}
 	return 0;
 }
 
-- 
2.7.4

