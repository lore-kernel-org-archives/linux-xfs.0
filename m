Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBL7SMhC244804 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 01:28:22 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8337221202B
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 23:30:18 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	yZq6tYkBMFaR2Zuk for <xfs@oss.sgi.com>;
	Mon, 20 Dec 2010 23:30:18 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	50071198-1927428
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 18:00:17 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PUwfn-0001Ds-G6
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:30:15 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PUwfS-0006Zm-3V
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:29:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 23/34] xfs: convert log grant ticket queues to list heads
Date: Tue, 21 Dec 2010 18:29:19 +1100
Message-Id: <1292916570-25015-24-git-send-email-david@fromorbit.com>
In-Reply-To: <1292916570-25015-1-git-send-email-david@fromorbit.com>
References: <1292916570-25015-1-git-send-email-david@fromorbit.com>
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

The grant write and reserve queues use a roll-your-own double linked
list, so convert it to a standard list_head structure and convert
all the list traversals to use list_for_each_entry(). We can also
get rid of the XLOG_TIC_IN_Q flag as we can use the list_empty()
check to tell if the ticket is in a list or not.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_trace.h |   16 +++---
 fs/xfs/xfs_log.c             |  123 ++++++++++++++----------------------------
 fs/xfs/xfs_log_priv.h        |   11 ++---
 3 files changed, 53 insertions(+), 97 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 83e8760..69b9e1f 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -766,8 +766,8 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		__field(int, curr_res)
 		__field(int, unit_res)
 		__field(unsigned int, flags)
-		__field(void *, reserve_headq)
-		__field(void *, write_headq)
+		__field(int, reserveq)
+		__field(int, writeq)
 		__field(int, grant_reserve_cycle)
 		__field(int, grant_reserve_bytes)
 		__field(int, grant_write_cycle)
@@ -784,8 +784,8 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		__entry->curr_res = tic->t_curr_res;
 		__entry->unit_res = tic->t_unit_res;
 		__entry->flags = tic->t_flags;
-		__entry->reserve_headq = log->l_reserve_headq;
-		__entry->write_headq = log->l_write_headq;
+		__entry->reserveq = list_empty(&log->l_reserveq);
+		__entry->writeq = list_empty(&log->l_writeq);
 		__entry->grant_reserve_cycle = log->l_grant_reserve_cycle;
 		__entry->grant_reserve_bytes = log->l_grant_reserve_bytes;
 		__entry->grant_write_cycle = log->l_grant_write_cycle;
@@ -795,8 +795,8 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		__entry->tail_lsn = log->l_tail_lsn;
 	),
 	TP_printk("dev %d:%d type %s t_ocnt %u t_cnt %u t_curr_res %u "
-		  "t_unit_res %u t_flags %s reserve_headq 0x%p "
-		  "write_headq 0x%p grant_reserve_cycle %d "
+		  "t_unit_res %u t_flags %s reserveq %s "
+		  "writeq %s grant_reserve_cycle %d "
 		  "grant_reserve_bytes %d grant_write_cycle %d "
 		  "grant_write_bytes %d curr_cycle %d curr_block %d "
 		  "tail_cycle %d tail_block %d",
@@ -807,8 +807,8 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		  __entry->curr_res,
 		  __entry->unit_res,
 		  __print_flags(__entry->flags, "|", XLOG_TIC_FLAGS),
-		  __entry->reserve_headq,
-		  __entry->write_headq,
+		  __entry->reserveq ? "empty" : "active",
+		  __entry->writeq ? "empty" : "active",
 		  __entry->grant_reserve_cycle,
 		  __entry->grant_reserve_bytes,
 		  __entry->grant_write_cycle,
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index cee4ab9..1b82735 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -95,38 +95,6 @@ STATIC void	xlog_verify_tail_lsn(xlog_t *log, xlog_in_core_t *iclog,
 
 STATIC int	xlog_iclogs_empty(xlog_t *log);
 
-
-static void
-xlog_ins_ticketq(struct xlog_ticket **qp, struct xlog_ticket *tic)
-{
-	if (*qp) {
-		tic->t_next	    = (*qp);
-		tic->t_prev	    = (*qp)->t_prev;
-		(*qp)->t_prev->t_next = tic;
-		(*qp)->t_prev	    = tic;
-	} else {
-		tic->t_prev = tic->t_next = tic;
-		*qp = tic;
-	}
-
-	tic->t_flags |= XLOG_TIC_IN_Q;
-}
-
-static void
-xlog_del_ticketq(struct xlog_ticket **qp, struct xlog_ticket *tic)
-{
-	if (tic == tic->t_next) {
-		*qp = NULL;
-	} else {
-		*qp = tic->t_next;
-		tic->t_next->t_prev = tic->t_prev;
-		tic->t_prev->t_next = tic->t_next;
-	}
-
-	tic->t_next = tic->t_prev = NULL;
-	tic->t_flags &= ~XLOG_TIC_IN_Q;
-}
-
 static void
 xlog_grant_sub_space(struct log *log, int bytes)
 {
@@ -724,7 +692,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 		log->l_tail_lsn = tail_lsn;
 	}
 
-	if ((tic = log->l_write_headq)) {
+	if (!list_empty(&log->l_writeq)) {
 #ifdef DEBUG
 		if (log->l_flags & XLOG_ACTIVE_RECOVERY)
 			panic("Recovery problem");
@@ -732,7 +700,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 		cycle = log->l_grant_write_cycle;
 		bytes = log->l_grant_write_bytes;
 		free_bytes = xlog_space_left(log, cycle, bytes);
-		do {
+		list_for_each_entry(tic, &log->l_writeq, t_queue) {
 			ASSERT(tic->t_flags & XLOG_TIC_PERM_RESERV);
 
 			if (free_bytes < tic->t_unit_res && tail_lsn != 1)
@@ -740,10 +708,10 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 			tail_lsn = 0;
 			free_bytes -= tic->t_unit_res;
 			sv_signal(&tic->t_wait);
-			tic = tic->t_next;
-		} while (tic != log->l_write_headq);
+		}
 	}
-	if ((tic = log->l_reserve_headq)) {
+
+	if (!list_empty(&log->l_reserveq)) {
 #ifdef DEBUG
 		if (log->l_flags & XLOG_ACTIVE_RECOVERY)
 			panic("Recovery problem");
@@ -751,7 +719,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 		cycle = log->l_grant_reserve_cycle;
 		bytes = log->l_grant_reserve_bytes;
 		free_bytes = xlog_space_left(log, cycle, bytes);
-		do {
+		list_for_each_entry(tic, &log->l_reserveq, t_queue) {
 			if (tic->t_flags & XLOG_TIC_PERM_RESERV)
 				need_bytes = tic->t_unit_res*tic->t_cnt;
 			else
@@ -761,8 +729,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 			tail_lsn = 0;
 			free_bytes -= need_bytes;
 			sv_signal(&tic->t_wait);
-			tic = tic->t_next;
-		} while (tic != log->l_reserve_headq);
+		}
 	}
 	spin_unlock(&log->l_grant_lock);
 }	/* xfs_log_move_tail */
@@ -1053,6 +1020,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
 	log->l_grant_reserve_cycle = 1;
 	log->l_grant_write_cycle = 1;
+	INIT_LIST_HEAD(&log->l_reserveq);
+	INIT_LIST_HEAD(&log->l_writeq);
 
 	error = EFSCORRUPTED;
 	if (xfs_sb_version_hassector(&mp->m_sb)) {
@@ -2550,8 +2519,8 @@ xlog_grant_log_space(xlog_t	   *log,
 	trace_xfs_log_grant_enter(log, tic);
 
 	/* something is already sleeping; insert new transaction at end */
-	if (log->l_reserve_headq) {
-		xlog_ins_ticketq(&log->l_reserve_headq, tic);
+	if (!list_empty(&log->l_reserveq)) {
+		list_add_tail(&tic->t_queue, &log->l_reserveq);
 
 		trace_xfs_log_grant_sleep1(log, tic);
 
@@ -2583,8 +2552,8 @@ redo:
 	free_bytes = xlog_space_left(log, log->l_grant_reserve_cycle,
 				     log->l_grant_reserve_bytes);
 	if (free_bytes < need_bytes) {
-		if ((tic->t_flags & XLOG_TIC_IN_Q) == 0)
-			xlog_ins_ticketq(&log->l_reserve_headq, tic);
+		if (list_empty(&tic->t_queue))
+			list_add_tail(&tic->t_queue, &log->l_reserveq);
 
 		trace_xfs_log_grant_sleep2(log, tic);
 
@@ -2602,8 +2571,9 @@ redo:
 		trace_xfs_log_grant_wake2(log, tic);
 
 		goto redo;
-	} else if (tic->t_flags & XLOG_TIC_IN_Q)
-		xlog_del_ticketq(&log->l_reserve_headq, tic);
+	}
+
+	list_del_init(&tic->t_queue);
 
 	/* we've got enough space */
 	xlog_grant_add_space(log, need_bytes);
@@ -2626,9 +2596,7 @@ redo:
 	return 0;
 
  error_return:
-	if (tic->t_flags & XLOG_TIC_IN_Q)
-		xlog_del_ticketq(&log->l_reserve_headq, tic);
-
+	list_del_init(&tic->t_queue);
 	trace_xfs_log_grant_error(log, tic);
 
 	/*
@@ -2653,7 +2621,6 @@ xlog_regrant_write_log_space(xlog_t	   *log,
 			     xlog_ticket_t *tic)
 {
 	int		free_bytes, need_bytes;
-	xlog_ticket_t	*ntic;
 #ifdef DEBUG
 	xfs_lsn_t	tail_lsn;
 #endif
@@ -2683,22 +2650,23 @@ xlog_regrant_write_log_space(xlog_t	   *log,
 	 * this transaction.
 	 */
 	need_bytes = tic->t_unit_res;
-	if ((ntic = log->l_write_headq)) {
+	if (!list_empty(&log->l_writeq)) {
+		struct xlog_ticket *ntic;
 		free_bytes = xlog_space_left(log, log->l_grant_write_cycle,
 					     log->l_grant_write_bytes);
-		do {
+		list_for_each_entry(ntic, &log->l_writeq, t_queue) {
 			ASSERT(ntic->t_flags & XLOG_TIC_PERM_RESERV);
 
 			if (free_bytes < ntic->t_unit_res)
 				break;
 			free_bytes -= ntic->t_unit_res;
 			sv_signal(&ntic->t_wait);
-			ntic = ntic->t_next;
-		} while (ntic != log->l_write_headq);
+		}
 
-		if (ntic != log->l_write_headq) {
-			if ((tic->t_flags & XLOG_TIC_IN_Q) == 0)
-				xlog_ins_ticketq(&log->l_write_headq, tic);
+		if (ntic != list_first_entry(&log->l_writeq,
+						struct xlog_ticket, t_queue)) {
+			if (list_empty(&tic->t_queue))
+				list_add_tail(&tic->t_queue, &log->l_writeq);
 
 			trace_xfs_log_regrant_write_sleep1(log, tic);
 
@@ -2727,8 +2695,8 @@ redo:
 	free_bytes = xlog_space_left(log, log->l_grant_write_cycle,
 				     log->l_grant_write_bytes);
 	if (free_bytes < need_bytes) {
-		if ((tic->t_flags & XLOG_TIC_IN_Q) == 0)
-			xlog_ins_ticketq(&log->l_write_headq, tic);
+		if (list_empty(&tic->t_queue))
+			list_add_tail(&tic->t_queue, &log->l_writeq);
 		spin_unlock(&log->l_grant_lock);
 		xlog_grant_push_ail(log->l_mp, need_bytes);
 		spin_lock(&log->l_grant_lock);
@@ -2745,8 +2713,9 @@ redo:
 
 		trace_xfs_log_regrant_write_wake2(log, tic);
 		goto redo;
-	} else if (tic->t_flags & XLOG_TIC_IN_Q)
-		xlog_del_ticketq(&log->l_write_headq, tic);
+	}
+
+	list_del_init(&tic->t_queue);
 
 	/* we've got enough space */
 	xlog_grant_add_space_write(log, need_bytes);
@@ -2766,9 +2735,7 @@ redo:
 
 
  error_return:
-	if (tic->t_flags & XLOG_TIC_IN_Q)
-		xlog_del_ticketq(&log->l_reserve_headq, tic);
-
+	list_del_init(&tic->t_queue);
 	trace_xfs_log_regrant_write_error(log, tic);
 
 	/*
@@ -3435,6 +3402,7 @@ xlog_ticket_alloc(
         }
 
 	atomic_set(&tic->t_ref, 1);
+	INIT_LIST_HEAD(&tic->t_queue);
 	tic->t_unit_res		= unit_bytes;
 	tic->t_curr_res		= unit_bytes;
 	tic->t_cnt		= cnt;
@@ -3742,26 +3710,17 @@ xfs_log_force_umount(
 	spin_unlock(&log->l_icloglock);
 
 	/*
-	 * We don't want anybody waiting for log reservations
-	 * after this. That means we have to wake up everybody
-	 * queued up on reserve_headq as well as write_headq.
-	 * In addition, we make sure in xlog_{re}grant_log_space
-	 * that we don't enqueue anything once the SHUTDOWN flag
-	 * is set, and this action is protected by the GRANTLOCK.
+	 * We don't want anybody waiting for log reservations after this. That
+	 * means we have to wake up everybody queued up on reserveq as well as
+	 * writeq.  In addition, we make sure in xlog_{re}grant_log_space that
+	 * we don't enqueue anything once the SHUTDOWN flag is set, and this
+	 * action is protected by the GRANTLOCK.
 	 */
-	if ((tic = log->l_reserve_headq)) {
-		do {
-			sv_signal(&tic->t_wait);
-			tic = tic->t_next;
-		} while (tic != log->l_reserve_headq);
-	}
+	list_for_each_entry(tic, &log->l_reserveq, t_queue)
+		sv_signal(&tic->t_wait);
 
-	if ((tic = log->l_write_headq)) {
-		do {
-			sv_signal(&tic->t_wait);
-			tic = tic->t_next;
-		} while (tic != log->l_write_headq);
-	}
+	list_for_each_entry(tic, &log->l_writeq, t_queue)
+		sv_signal(&tic->t_wait);
 	spin_unlock(&log->l_grant_lock);
 
 	if (!(log->l_iclog->ic_state & XLOG_STATE_IOERROR)) {
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index c1ce505..a5b3c02 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -132,12 +132,10 @@ static inline uint xlog_get_client_id(__be32 i)
  */
 #define XLOG_TIC_INITED		0x1	/* has been initialized */
 #define XLOG_TIC_PERM_RESERV	0x2	/* permanent reservation */
-#define XLOG_TIC_IN_Q		0x4
 
 #define XLOG_TIC_FLAGS \
 	{ XLOG_TIC_INITED,	"XLOG_TIC_INITED" }, \
-	{ XLOG_TIC_PERM_RESERV,	"XLOG_TIC_PERM_RESERV" }, \
-	{ XLOG_TIC_IN_Q,	"XLOG_TIC_IN_Q" }
+	{ XLOG_TIC_PERM_RESERV,	"XLOG_TIC_PERM_RESERV" }
 
 #endif	/* __KERNEL__ */
 
@@ -244,8 +242,7 @@ typedef struct xlog_res {
 
 typedef struct xlog_ticket {
 	sv_t		   t_wait;	 /* ticket wait queue            : 20 */
-	struct xlog_ticket *t_next;	 /*			         :4|8 */
-	struct xlog_ticket *t_prev;	 /*				 :4|8 */
+	struct list_head   t_queue;	 /* reserve/write queue */
 	xlog_tid_t	   t_tid;	 /* transaction identifier	 : 4  */
 	atomic_t	   t_ref;	 /* ticket reference count       : 4  */
 	int		   t_curr_res;	 /* current reservation in bytes : 4  */
@@ -519,8 +516,8 @@ typedef struct log {
 
 	/* The following block of fields are changed while holding grant_lock */
 	spinlock_t		l_grant_lock ____cacheline_aligned_in_smp;
-	xlog_ticket_t		*l_reserve_headq;
-	xlog_ticket_t		*l_write_headq;
+	struct list_head	l_reserveq;
+	struct list_head	l_writeq;
 	int			l_grant_reserve_cycle;
 	int			l_grant_reserve_bytes;
 	int			l_grant_write_cycle;
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
