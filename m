Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 21:23:24 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L5NHLP016266
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 21:23:21 -0800
Date: Mon, 21 Jan 2008 16:23:30 +1100
From: David Chinner <dgc@sgi.com>
Subject: [patch] Prevent AIL lock contention during transaction completion
Message-ID: <20080121052330.GG155259@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

When hundreds of processors attempt to commit
transactions at the same time, they can contend on the AIL
lock when updating the tail LSN held in the in-core log
structure.

At the moment, the tail LSN is only needed when actually writing
out an iclog, so it really does not need to be updated on every
single transaction completion - only those that result in switching
iclogs and flushing them to disk.

The result is that we reduce the number oftimes we need to grab the
AIL lock and the log grant lock by up to two orders of magnitude
on large processor count machines. The problem has previously been
hidden by AIL lock contention walking the AIL list, which has
recently been solved.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_log.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2008-01-21 16:06:27.187549816 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2008-01-21 16:16:51.804146394 +1100
@@ -2815,15 +2815,13 @@ xlog_state_put_ticket(xlog_t	    *log,
  *
  */
 STATIC int
-xlog_state_release_iclog(xlog_t		*log,
-			 xlog_in_core_t	*iclog)
+xlog_state_release_iclog(
+	xlog_t		*log,
+	xlog_in_core_t	*iclog)
 {
 	int		sync = 0;	/* do we sync? */
 
-	xlog_assign_tail_lsn(log->l_mp);
-
 	spin_lock(&log->l_icloglock);
-
 	if (iclog->ic_state & XLOG_STATE_IOERROR) {
 		spin_unlock(&log->l_icloglock);
 		return XFS_ERROR(EIO);
@@ -2835,13 +2833,14 @@ xlog_state_release_iclog(xlog_t		*log,
 
 	if (--iclog->ic_refcnt == 0 &&
 	    iclog->ic_state == XLOG_STATE_WANT_SYNC) {
+		/* update tail before writing to iclog */
+		xlog_assign_tail_lsn(log->l_mp);
 		sync++;
 		iclog->ic_state = XLOG_STATE_SYNCING;
 		iclog->ic_header.h_tail_lsn = cpu_to_be64(log->l_tail_lsn);
 		xlog_verify_tail_lsn(log, iclog, log->l_tail_lsn);
 		/* cycle incremented when incrementing curr_block */
 	}
-
 	spin_unlock(&log->l_icloglock);
 
 	/*
@@ -2851,11 +2850,9 @@ xlog_state_release_iclog(xlog_t		*log,
 	 * this iclog has consistent data, so we ignore IOERROR
 	 * flags after this point.
 	 */
-	if (sync) {
+	if (sync)
 		return xlog_sync(log, iclog);
-	}
 	return 0;
-
 }	/* xlog_state_release_iclog */
 
 
