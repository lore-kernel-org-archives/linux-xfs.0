Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD4tJIH160430 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 22:55:19 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37B511C2522A
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 20:46:25 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	HfqGIl9U0saSOyuk for <xfs@oss.sgi.com>;
	Sun, 12 Dec 2010 20:46:25 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	49485026-1927428
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 15:16:24 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PS0Ip-00022P-9J
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:46:23 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PS0HL-0004mH-4X
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:44:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/12] xfs: fact out common grant head/log tail verification
	code
Date: Mon, 13 Dec 2010 15:44:33 +1100
Message-Id: <1292215483-18224-3-git-send-email-david@fromorbit.com>
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

Factor repeated debug code out of grant head manipulation functions into a
separate function. This removes ifdef DEBUG spagetti from the code and makes
the code easier to follow.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c |   51 ++++++++++++++++++++++-----------------------------
 1 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 1b82735..99c6285 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -82,6 +82,7 @@ STATIC void xlog_ungrant_log_space(xlog_t	 *log,
 #if defined(DEBUG)
 STATIC void	xlog_verify_dest_ptr(xlog_t *log, char *ptr);
 STATIC void	xlog_verify_grant_head(xlog_t *log, int equals);
+STATIC void	xlog_verify_grant_tail(struct log *log);
 STATIC void	xlog_verify_iclog(xlog_t *log, xlog_in_core_t *iclog,
 				  int count, boolean_t syncing);
 STATIC void	xlog_verify_tail_lsn(xlog_t *log, xlog_in_core_t *iclog,
@@ -89,6 +90,7 @@ STATIC void	xlog_verify_tail_lsn(xlog_t *log, xlog_in_core_t *iclog,
 #else
 #define xlog_verify_dest_ptr(a,b)
 #define xlog_verify_grant_head(a,b)
+#define xlog_verify_grant_tail(a)
 #define xlog_verify_iclog(a,b,c,d)
 #define xlog_verify_tail_lsn(a,b,c)
 #endif
@@ -2503,10 +2505,6 @@ xlog_grant_log_space(xlog_t	   *log,
 {
 	int		 free_bytes;
 	int		 need_bytes;
-#ifdef DEBUG
-	xfs_lsn_t	 tail_lsn;
-#endif
-
 
 #ifdef DEBUG
 	if (log->l_flags & XLOG_ACTIVE_RECOVERY)
@@ -2577,21 +2575,9 @@ redo:
 
 	/* we've got enough space */
 	xlog_grant_add_space(log, need_bytes);
-#ifdef DEBUG
-	tail_lsn = log->l_tail_lsn;
-	/*
-	 * Check to make sure the grant write head didn't just over lap the
-	 * tail.  If the cycles are the same, we can't be overlapping.
-	 * Otherwise, make sure that the cycles differ by exactly one and
-	 * check the byte count.
-	 */
-	if (CYCLE_LSN(tail_lsn) != log->l_grant_write_cycle) {
-		ASSERT(log->l_grant_write_cycle-1 == CYCLE_LSN(tail_lsn));
-		ASSERT(log->l_grant_write_bytes <= BBTOB(BLOCK_LSN(tail_lsn)));
-	}
-#endif
 	trace_xfs_log_grant_exit(log, tic);
 	xlog_verify_grant_head(log, 1);
+	xlog_verify_grant_tail(log);
 	spin_unlock(&log->l_grant_lock);
 	return 0;
 
@@ -2621,9 +2607,6 @@ xlog_regrant_write_log_space(xlog_t	   *log,
 			     xlog_ticket_t *tic)
 {
 	int		free_bytes, need_bytes;
-#ifdef DEBUG
-	xfs_lsn_t	tail_lsn;
-#endif
 
 	tic->t_curr_res = tic->t_unit_res;
 	xlog_tic_reset_res(tic);
@@ -2719,17 +2702,9 @@ redo:
 
 	/* we've got enough space */
 	xlog_grant_add_space_write(log, need_bytes);
-#ifdef DEBUG
-	tail_lsn = log->l_tail_lsn;
-	if (CYCLE_LSN(tail_lsn) != log->l_grant_write_cycle) {
-		ASSERT(log->l_grant_write_cycle-1 == CYCLE_LSN(tail_lsn));
-		ASSERT(log->l_grant_write_bytes <= BBTOB(BLOCK_LSN(tail_lsn)));
-	}
-#endif
-
 	trace_xfs_log_regrant_write_exit(log, tic);
-
 	xlog_verify_grant_head(log, 1);
+	xlog_verify_grant_tail(log);
 	spin_unlock(&log->l_grant_lock);
 	return 0;
 
@@ -3465,6 +3440,24 @@ xlog_verify_grant_head(xlog_t *log, int equals)
     }
 }	/* xlog_verify_grant_head */
 
+STATIC void
+xlog_verify_grant_tail(
+	struct log	*log)
+{
+	xfs_lsn_t	tail_lsn = log->l_tail_lsn;
+
+	/*
+	 * Check to make sure the grant write head didn't just over lap the
+	 * tail.  If the cycles are the same, we can't be overlapping.
+	 * Otherwise, make sure that the cycles differ by exactly one and
+	 * check the byte count.
+	 */
+	if (CYCLE_LSN(tail_lsn) != log->l_grant_write_cycle) {
+		ASSERT(log->l_grant_write_cycle - 1 == CYCLE_LSN(tail_lsn));
+		ASSERT(log->l_grant_write_bytes <= BBTOB(BLOCK_LSN(tail_lsn)));
+	}
+}
+
 /* check if it will fit */
 STATIC void
 xlog_verify_tail_lsn(xlog_t	    *log,
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
