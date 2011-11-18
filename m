Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAIJL28g197994 for <xfs@oss.sgi.com>; Fri, 18 Nov 2011 13:21:04 -0600
Received: from e7.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C7FA2628A5
	for <xfs@oss.sgi.com>; Fri, 18 Nov 2011 11:21:02 -0800 (PST)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id VEYqxko0YVJjSaBM for
	<xfs@oss.sgi.com>; Fri, 18 Nov 2011 11:21:02 -0800 (PST)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 18 Nov 2011 14:21:01 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	pAIJKtnj278740 for <xfs@oss.sgi.com>; Fri, 18 Nov 2011 14:20:56 -0500
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id pAIJKtc5015647
	for <xfs@oss.sgi.com>; Fri, 18 Nov 2011 12:20:55 -0700
Received: from [9.53.40.164] (chandra-lucid.austin.ibm.com [9.53.40.164])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	pAIJKsuK015633 for <xfs@oss.sgi.com>; Fri, 18 Nov 2011 12:20:55 -0700
Subject: [PATCH] xfs: Remove the entries from the queue while waking them up.
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 18 Nov 2011 13:20:54 -0600
Message-ID: <1321644054.2201.80.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: XFS Mailing List <xfs@oss.sgi.com>

l_reserveq and l_writeq maintains a list of processes waiting to get log
space. Processes are supposed to get in the list when the amount of free
space available in the log is less than what they need.

When space becomes available current code, wakes up the processes, but
expect the processes to remove themselves from the queue.

Since the lock protecting the list is only acquired later by the woken
up process, there is a window of time were a new process that is looking
for space can wrongly get into the queue while there is enough space
available. 

Since there is enough space available, this process can never be woken
up, which leads to the hang of the process.

This was originally reported by Alex Elder <aelder@sgi.com> as hang seen
in xfstests #234.

With log of log activities, this problem may not be seen, as some
process will be pushing the processes along. But, 234 does lot of quota
operations only, hence the problem was noticed in that test.

This patch fixes the problem by removing the element from the queue
(safely) when the process was woken up.

Reported-by: Alex elder <aelder@sgi.com>
Signed-Off-by: Chandra Seethraman <sekharan@us.ibm.com>

---
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a14cd89..9941fcb 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -674,7 +674,7 @@ void
 xfs_log_move_tail(xfs_mount_t	*mp,
 		  xfs_lsn_t	tail_lsn)
 {
-	xlog_ticket_t	*tic;
+	xlog_ticket_t	*tic, *tmp;
 	xlog_t		*log = mp->m_log;
 	int		need_bytes, free_bytes;
 
@@ -695,7 +695,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 #endif
 		spin_lock(&log->l_grant_write_lock);
 		free_bytes = xlog_space_left(log, &log->l_grant_write_head);
-		list_for_each_entry(tic, &log->l_writeq, t_queue) {
+		list_for_each_entry_safe(tic, tmp, &log->l_writeq, t_queue) {
 			ASSERT(tic->t_flags & XLOG_TIC_PERM_RESERV);
 
 			if (free_bytes < tic->t_unit_res && tail_lsn != 1)
@@ -703,6 +703,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 			tail_lsn = 0;
 			free_bytes -= tic->t_unit_res;
 			trace_xfs_log_regrant_write_wake_up(log, tic);
+			list_del_init(&tic->t_queue);
 			wake_up(&tic->t_wait);
 		}
 		spin_unlock(&log->l_grant_write_lock);
@@ -715,7 +716,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 #endif
 		spin_lock(&log->l_grant_reserve_lock);
 		free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
-		list_for_each_entry(tic, &log->l_reserveq, t_queue) {
+		list_for_each_entry_safe(tic, tmp, &log->l_reserveq, t_queue) {
 			if (tic->t_flags & XLOG_TIC_PERM_RESERV)
 				need_bytes = tic->t_unit_res*tic->t_cnt;
 			else
@@ -725,6 +726,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 			tail_lsn = 0;
 			free_bytes -= need_bytes;
 			trace_xfs_log_grant_wake_up(log, tic);
+			list_del_init(&tic->t_queue);
 			wake_up(&tic->t_wait);
 		}
 		spin_unlock(&log->l_grant_reserve_lock);
@@ -2550,8 +2552,7 @@ redo:
 	free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
 	if (free_bytes < need_bytes) {
 		spin_lock(&log->l_grant_reserve_lock);
-		if (list_empty(&tic->t_queue))
-			list_add_tail(&tic->t_queue, &log->l_reserveq);
+		list_add_tail(&tic->t_queue, &log->l_reserveq);
 
 		trace_xfs_log_grant_sleep2(log, tic);
 
@@ -2567,12 +2568,6 @@ redo:
 		goto redo;
 	}
 
-	if (!list_empty(&tic->t_queue)) {
-		spin_lock(&log->l_grant_reserve_lock);
-		list_del_init(&tic->t_queue);
-		spin_unlock(&log->l_grant_reserve_lock);
-	}
-
 	/* we've got enough space */
 	xlog_grant_add_space(log, &log->l_grant_reserve_head, need_bytes);
 	xlog_grant_add_space(log, &log->l_grant_write_head, need_bytes);
@@ -2626,30 +2621,28 @@ xlog_regrant_write_log_space(xlog_t	   *log,
 		goto error_return_unlocked;
 
 	/* If there are other waiters on the queue then give them a
-	 * chance at logspace before us. Wake up the first waiters,
-	 * if we do not wake up all the waiters then go to sleep waiting
-	 * for more free space, otherwise try to get some space for
-	 * this transaction.
+	 * chance at logspace before us. If we do not wake up all
+	 * the waiters then go to sleep waiting for more free space,
+	 * otherwise try to get some space for this transaction.
 	 */
 	need_bytes = tic->t_unit_res;
 	if (!list_empty_careful(&log->l_writeq)) {
-		struct xlog_ticket *ntic;
+		struct xlog_ticket *ntic, *tmp;
 
 		spin_lock(&log->l_grant_write_lock);
 		free_bytes = xlog_space_left(log, &log->l_grant_write_head);
-		list_for_each_entry(ntic, &log->l_writeq, t_queue) {
+		list_for_each_entry_safe(ntic, tmp, &log->l_writeq, t_queue) {
 			ASSERT(ntic->t_flags & XLOG_TIC_PERM_RESERV);
 
 			if (free_bytes < ntic->t_unit_res)
 				break;
 			free_bytes -= ntic->t_unit_res;
+			list_del_init(&ntic->t_queue);
 			wake_up(&ntic->t_wait);
 		}
 
-		if (ntic != list_first_entry(&log->l_writeq,
-						struct xlog_ticket, t_queue)) {
-			if (list_empty(&tic->t_queue))
-				list_add_tail(&tic->t_queue, &log->l_writeq);
+		if (!list_empty(&log->l_writeq)) {
+			list_add_tail(&tic->t_queue, &log->l_writeq);
 			trace_xfs_log_regrant_write_sleep1(log, tic);
 
 			xlog_grant_push_ail(log, need_bytes);
@@ -2668,8 +2661,7 @@ redo:
 	free_bytes = xlog_space_left(log, &log->l_grant_write_head);
 	if (free_bytes < need_bytes) {
 		spin_lock(&log->l_grant_write_lock);
-		if (list_empty(&tic->t_queue))
-			list_add_tail(&tic->t_queue, &log->l_writeq);
+		list_add_tail(&tic->t_queue, &log->l_writeq);
 
 		if (XLOG_FORCED_SHUTDOWN(log))
 			goto error_return;
@@ -2684,12 +2676,6 @@ redo:
 		goto redo;
 	}
 
-	if (!list_empty(&tic->t_queue)) {
-		spin_lock(&log->l_grant_write_lock);
-		list_del_init(&tic->t_queue);
-		spin_unlock(&log->l_grant_write_lock);
-	}
-
 	/* we've got enough space */
 	xlog_grant_add_space(log, &log->l_grant_write_head, need_bytes);
 	trace_xfs_log_regrant_write_exit(log, tic);
@@ -3621,7 +3607,7 @@ xfs_log_force_umount(
 	struct xfs_mount	*mp,
 	int			logerror)
 {
-	xlog_ticket_t	*tic;
+	xlog_ticket_t	*tic, *tmp;
 	xlog_t		*log;
 	int		retval;
 
@@ -3690,13 +3676,17 @@ xfs_log_force_umount(
 	 * action is protected by the grant locks.
 	 */
 	spin_lock(&log->l_grant_reserve_lock);
-	list_for_each_entry(tic, &log->l_reserveq, t_queue)
+	list_for_each_entry_safe(tic, tmp, &log->l_reserveq, t_queue) {
+		list_del_init(&tic->t_queue);
 		wake_up(&tic->t_wait);
+	}
 	spin_unlock(&log->l_grant_reserve_lock);
 
 	spin_lock(&log->l_grant_write_lock);
-	list_for_each_entry(tic, &log->l_writeq, t_queue)
+	list_for_each_entry_safe(tic, tmp, &log->l_writeq, t_queue) {
+		list_del_init(&tic->t_queue);
 		wake_up(&tic->t_wait);
+	}
 	spin_unlock(&log->l_grant_write_lock);
 
 	if (!(log->l_iclog->ic_state & XLOG_STATE_IOERROR)) {


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
