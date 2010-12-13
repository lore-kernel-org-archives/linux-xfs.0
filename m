Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD4tH1h160413 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 22:55:17 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7284EA3B5B
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 20:46:45 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	4c0GGsK7Wt60B3TD for <xfs@oss.sgi.com>;
	Sun, 12 Dec 2010 20:46:45 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	49126895-1927428
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 15:16:44 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PS0Iz-00022a-At
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:46:33 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PS0HV-0004mK-5I
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:45:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/12] xfs: rework log grant space calculations
Date: Mon, 13 Dec 2010 15:44:34 +1100
Message-Id: <1292215483-18224-4-git-send-email-david@fromorbit.com>
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

The log grant space calculations are repeated for both write and
reserve grant heads. To make it simpler to convert the calculations
toa different algorithm, factor them so both the gratn heads use the
same calculation functions. Once this is done we can drop the
wrappers that are used in only a couple of place to update both
grant heads at once as they don't provide any particular value.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c |   95 +++++++++++++++++++++++++++--------------------------
 1 files changed, 48 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 99c6285..9a4b9ed 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -98,53 +98,34 @@ STATIC void	xlog_verify_tail_lsn(xlog_t *log, xlog_in_core_t *iclog,
 STATIC int	xlog_iclogs_empty(xlog_t *log);
 
 static void
-xlog_grant_sub_space(struct log *log, int bytes)
-{
-	log->l_grant_write_bytes -= bytes;
-	if (log->l_grant_write_bytes < 0) {
-		log->l_grant_write_bytes += log->l_logsize;
-		log->l_grant_write_cycle--;
-	}
-
-	log->l_grant_reserve_bytes -= bytes;
-	if ((log)->l_grant_reserve_bytes < 0) {
-		log->l_grant_reserve_bytes += log->l_logsize;
-		log->l_grant_reserve_cycle--;
-	}
-
-}
-
-static void
-xlog_grant_add_space_write(struct log *log, int bytes)
+xlog_grant_sub_space(
+	struct log	*log,
+	int		*cycle,
+	int		*space,
+	int		bytes)
 {
-	int tmp = log->l_logsize - log->l_grant_write_bytes;
-	if (tmp > bytes)
-		log->l_grant_write_bytes += bytes;
-	else {
-		log->l_grant_write_cycle++;
-		log->l_grant_write_bytes = bytes - tmp;
+	*space -= bytes;
+	if (*space < 0) {
+		*space += log->l_logsize;
+		(*cycle)--;
 	}
 }
 
 static void
-xlog_grant_add_space_reserve(struct log *log, int bytes)
+xlog_grant_add_space(
+	struct log	*log,
+	int		*cycle,
+	int		*space,
+	int		bytes)
 {
-	int tmp = log->l_logsize - log->l_grant_reserve_bytes;
+	int tmp = log->l_logsize - *space;
 	if (tmp > bytes)
-		log->l_grant_reserve_bytes += bytes;
+		*space += bytes;
 	else {
-		log->l_grant_reserve_cycle++;
-		log->l_grant_reserve_bytes = bytes - tmp;
+		*space = bytes - tmp;
+		(*cycle)++;
 	}
 }
-
-static inline void
-xlog_grant_add_space(struct log *log, int bytes)
-{
-	xlog_grant_add_space_write(log, bytes);
-	xlog_grant_add_space_reserve(log, bytes);
-}
-
 static void
 xlog_tic_reset_res(xlog_ticket_t *tic)
 {
@@ -1344,7 +1325,10 @@ xlog_sync(xlog_t		*log,
 
 	/* move grant heads by roundoff in sync */
 	spin_lock(&log->l_grant_lock);
-	xlog_grant_add_space(log, roundoff);
+	xlog_grant_add_space(log, &log->l_grant_reserve_cycle,
+				&log->l_grant_reserve_bytes, roundoff);
+	xlog_grant_add_space(log, &log->l_grant_write_cycle,
+				&log->l_grant_write_bytes, roundoff);
 	spin_unlock(&log->l_grant_lock);
 
 	/* put cycle number in every block */
@@ -2574,7 +2558,10 @@ redo:
 	list_del_init(&tic->t_queue);
 
 	/* we've got enough space */
-	xlog_grant_add_space(log, need_bytes);
+	xlog_grant_add_space(log, &log->l_grant_reserve_cycle,
+				&log->l_grant_reserve_bytes, need_bytes);
+	xlog_grant_add_space(log, &log->l_grant_write_cycle,
+				&log->l_grant_write_bytes, need_bytes);
 	trace_xfs_log_grant_exit(log, tic);
 	xlog_verify_grant_head(log, 1);
 	xlog_verify_grant_tail(log);
@@ -2701,7 +2688,8 @@ redo:
 	list_del_init(&tic->t_queue);
 
 	/* we've got enough space */
-	xlog_grant_add_space_write(log, need_bytes);
+	xlog_grant_add_space(log, &log->l_grant_write_cycle,
+				&log->l_grant_write_bytes, need_bytes);
 	trace_xfs_log_regrant_write_exit(log, tic);
 	xlog_verify_grant_head(log, 1);
 	xlog_verify_grant_tail(log);
@@ -2742,7 +2730,12 @@ xlog_regrant_reserve_log_space(xlog_t	     *log,
 		ticket->t_cnt--;
 
 	spin_lock(&log->l_grant_lock);
-	xlog_grant_sub_space(log, ticket->t_curr_res);
+	xlog_grant_sub_space(log, &log->l_grant_reserve_cycle,
+				&log->l_grant_reserve_bytes,
+				ticket->t_curr_res);
+	xlog_grant_sub_space(log, &log->l_grant_write_cycle,
+				&log->l_grant_write_bytes,
+				ticket->t_curr_res);
 	ticket->t_curr_res = ticket->t_unit_res;
 	xlog_tic_reset_res(ticket);
 
@@ -2756,7 +2749,9 @@ xlog_regrant_reserve_log_space(xlog_t	     *log,
 		return;
 	}
 
-	xlog_grant_add_space_reserve(log, ticket->t_unit_res);
+	xlog_grant_add_space(log, &log->l_grant_reserve_cycle,
+				&log->l_grant_reserve_bytes,
+				ticket->t_unit_res);
 
 	trace_xfs_log_regrant_reserve_exit(log, ticket);
 
@@ -2785,24 +2780,30 @@ STATIC void
 xlog_ungrant_log_space(xlog_t	     *log,
 		       xlog_ticket_t *ticket)
 {
+	int	bytes;
+
 	if (ticket->t_cnt > 0)
 		ticket->t_cnt--;
 
 	spin_lock(&log->l_grant_lock);
 	trace_xfs_log_ungrant_enter(log, ticket);
-
-	xlog_grant_sub_space(log, ticket->t_curr_res);
-
 	trace_xfs_log_ungrant_sub(log, ticket);
 
-	/* If this is a permanent reservation ticket, we may be able to free
+	/*
+	 * If this is a permanent reservation ticket, we may be able to free
 	 * up more space based on the remaining count.
 	 */
+	bytes = ticket->t_curr_res;
 	if (ticket->t_cnt > 0) {
 		ASSERT(ticket->t_flags & XLOG_TIC_PERM_RESERV);
-		xlog_grant_sub_space(log, ticket->t_unit_res*ticket->t_cnt);
+		bytes += ticket->t_unit_res*ticket->t_cnt;
 	}
 
+	xlog_grant_sub_space(log, &log->l_grant_reserve_cycle,
+				&log->l_grant_reserve_bytes, bytes);
+	xlog_grant_sub_space(log, &log->l_grant_write_cycle,
+				&log->l_grant_write_bytes, bytes);
+
 	trace_xfs_log_ungrant_exit(log, ticket);
 
 	xlog_verify_grant_head(log, 1);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
