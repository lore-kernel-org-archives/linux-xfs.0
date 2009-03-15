Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FBfJNc007742 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 06:41:39 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B30371C43931
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:40:56 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail11.adl2.internode.on.net
	[203.16.214.75]) by cuda.sgi.com with ESMTP id OnG0a6GuzlawkmNS
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:40:56 -0700 (PDT)
Received: from destruction.internal (unverified [203.206.165.193])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	46133687-1927428
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 22:10:54 +1030 (CDT)
Received: from dave by destruction.internal with local (Exim 4.69)
	(envelope-from <dave@destruction>) id 1Liohw-0006l3-0l
	for xfs@oss.sgi.com; Sun, 15 Mar 2009 22:40:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] XFS: Inform the xfsaild of the push target before sleeping
Date: Sun, 15 Mar 2009 22:40:43 +1100
Message-Id: <1237117243-25940-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1237117243-25940-1-git-send-email-david@fromorbit.com>
References: <1237117243-25940-1-git-send-email-david@fromorbit.com>
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

When trying to reserve log space, we find the amount of space
we need, then go to sleep waiting for space. When we are
woken, we try to push the tail of the log forward to make
sure we have space available.

Unfortunately, this means that if there is not space available, and
everyone who needs space goes to sleep there is no-one left to push
the tail of the log to make space available. Once we have a thread
waiting for space to become available, the others queue up behind
it in a FIFO, and none of them push the tail of the log.

This can result in everyone going to sleep in xlog_grant_log_space()
if the first sleeper races with the last I/O that moves the tail
of the log forward. With no further I/O tomove the tail of the log,
there is nothing to wake the sleepers and hence all transactions
just stop.

Fix this by making sure the xfsaild will create enough space for the
transaction that is about to sleep by moving the push target far
enough forwards to ensure that that the curent proceeees will have
enough space available when it is woken. That is, we push the
AIL before we go to sleep.

Because we've inserted the log ticket into the queue before we've
pushed and gone to sleep, subsequent transactions will wait behind
this one. Hence we are guaranteed to have space available when we
are woken.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_log.c |   37 +++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 60e6e63..278960c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2573,18 +2573,19 @@ redo:
 			xlog_ins_ticketq(&log->l_reserve_headq, tic);
 		xlog_trace_loggrant(log, tic,
 				    "xlog_grant_log_space: sleep 2");
+		spin_unlock(&log->l_grant_lock);
+		xlog_grant_push_ail(log->l_mp, need_bytes);
+		spin_lock(&log->l_grant_lock);
+
 		XFS_STATS_INC(xs_sleep_logspace);
 		sv_wait(&tic->t_wait, PINOD|PLTWAIT, &log->l_grant_lock, s);
 
-		if (XLOG_FORCED_SHUTDOWN(log)) {
-			spin_lock(&log->l_grant_lock);
+		spin_lock(&log->l_grant_lock);
+		if (XLOG_FORCED_SHUTDOWN(log))
 			goto error_return;
-		}
 
 		xlog_trace_loggrant(log, tic,
 				    "xlog_grant_log_space: wake 2");
-		xlog_grant_push_ail(log->l_mp, need_bytes);
-		spin_lock(&log->l_grant_lock);
 		goto redo;
 	} else if (tic->t_flags & XLOG_TIC_IN_Q)
 		xlog_del_ticketq(&log->l_reserve_headq, tic);
@@ -2663,7 +2664,7 @@ xlog_regrant_write_log_space(xlog_t	   *log,
 	 * for more free space, otherwise try to get some space for
 	 * this transaction.
 	 */
-
+	need_bytes = tic->t_unit_res;
 	if ((ntic = log->l_write_headq)) {
 		free_bytes = xlog_space_left(log, log->l_grant_write_cycle,
 					     log->l_grant_write_bytes);
@@ -2683,26 +2684,25 @@ xlog_regrant_write_log_space(xlog_t	   *log,
 
 			xlog_trace_loggrant(log, tic,
 				    "xlog_regrant_write_log_space: sleep 1");
+			spin_unlock(&log->l_grant_lock);
+			xlog_grant_push_ail(log->l_mp, need_bytes);
+			spin_lock(&log->l_grant_lock);
+
 			XFS_STATS_INC(xs_sleep_logspace);
 			sv_wait(&tic->t_wait, PINOD|PLTWAIT,
 				&log->l_grant_lock, s);
 
 			/* If we're shutting down, this tic is already
 			 * off the queue */
-			if (XLOG_FORCED_SHUTDOWN(log)) {
-				spin_lock(&log->l_grant_lock);
+			spin_lock(&log->l_grant_lock);
+			if (XLOG_FORCED_SHUTDOWN(log))
 				goto error_return;
-			}
 
 			xlog_trace_loggrant(log, tic,
 				    "xlog_regrant_write_log_space: wake 1");
-			xlog_grant_push_ail(log->l_mp, tic->t_unit_res);
-			spin_lock(&log->l_grant_lock);
 		}
 	}
 
-	need_bytes = tic->t_unit_res;
-
 redo:
 	if (XLOG_FORCED_SHUTDOWN(log))
 		goto error_return;
@@ -2712,19 +2712,20 @@ redo:
 	if (free_bytes < need_bytes) {
 		if ((tic->t_flags & XLOG_TIC_IN_Q) == 0)
 			xlog_ins_ticketq(&log->l_write_headq, tic);
+		spin_unlock(&log->l_grant_lock);
+		xlog_grant_push_ail(log->l_mp, need_bytes);
+		spin_lock(&log->l_grant_lock);
+
 		XFS_STATS_INC(xs_sleep_logspace);
 		sv_wait(&tic->t_wait, PINOD|PLTWAIT, &log->l_grant_lock, s);
 
 		/* If we're shutting down, this tic is already off the queue */
-		if (XLOG_FORCED_SHUTDOWN(log)) {
-			spin_lock(&log->l_grant_lock);
+		spin_lock(&log->l_grant_lock);
+		if (XLOG_FORCED_SHUTDOWN(log))
 			goto error_return;
-		}
 
 		xlog_trace_loggrant(log, tic,
 				    "xlog_regrant_write_log_space: wake 2");
-		xlog_grant_push_ail(log->l_mp, need_bytes);
-		spin_lock(&log->l_grant_lock);
 		goto redo;
 	} else if (tic->t_flags & XLOG_TIC_IN_Q)
 		xlog_del_ticketq(&log->l_write_headq, tic);
-- 
1.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
