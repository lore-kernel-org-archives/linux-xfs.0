Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA88tIAC089721 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 02:55:18 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67C441398EEE
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 00:56:41 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	gmuQZUc1qKVZNXp7 for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 00:56:41 -0800 (PST)
Received: from dastard (unverified [121.44.100.105])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	46083260-1927428
	for <xfs@oss.sgi.com>; Mon, 08 Nov 2010 19:26:39 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PFNWd-0001DL-6t
	for xfs@oss.sgi.com; Mon, 08 Nov 2010 19:56:27 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PFNVv-0004o2-Bx
	for xfs@oss.sgi.com; Mon, 08 Nov 2010 19:55:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 16/16] xfs: make xlog_space_left() independent of the grant
	lock
Date: Mon,  8 Nov 2010 19:55:19 +1100
Message-Id: <1289206519-18377-17-git-send-email-david@fromorbit.com>
In-Reply-To: <1289206519-18377-1-git-send-email-david@fromorbit.com>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
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

Convert the xlog_space_left() calculation to take the tail_lsn as a
parameter.  This allows the function to be called with fixed values
rather than sampling the tail_lsn during the call and hence
requiring it to be called under the log grant lock.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

Header from folded patch 'xfs-log-ail-push-tail-unlocked':

xfs: make AIL tail pushing independent of the grant lock

Convert the xlog_grant_push_ail() calculation to take the tail_lsn
and the last_sync_lsn as parameters.  This allows the function to be
called with fixed values rather than sampling variables protected by
the grant lock.  This allows us to move the grant lock outside the
push function which immediately reduces unnecessary grant lock
traffic, but also allows use to split the function away from the
grant lock in future.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

Header from folded patch 'xfs-log-ticket-queue-list-head':

xfs: Convert the log space ticket queue to use list_heads

The current code uses a roll-your-own double linked list, so convert
it to a standard list_head structure and convert all the list
traversals to use list_for_each_entry(). We can also get rid of the
XLOG_TIC_IN_Q flag as we can use the list_empty() check to tell if
the ticket is in a list or not.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |   36 +--
 fs/xfs/xfs_log.c             |  678 ++++++++++++++++++++++--------------------
 fs/xfs/xfs_log_priv.h        |   40 ++-
 fs/xfs/xfs_log_recover.c     |   23 +-
 4 files changed, 409 insertions(+), 368 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index acef2e9..1a029bd 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -766,12 +766,10 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		__field(int, curr_res)
 		__field(int, unit_res)
 		__field(unsigned int, flags)
-		__field(void *, reserve_headq)
-		__field(void *, write_headq)
-		__field(int, grant_reserve_cycle)
-		__field(int, grant_reserve_bytes)
-		__field(int, grant_write_cycle)
-		__field(int, grant_write_bytes)
+		__field(void *, reserveq)
+		__field(void *, writeq)
+		__field(xfs_lsn_t, grant_reserve_lsn)
+		__field(xfs_lsn_t, grant_write_lsn)
 		__field(int, curr_cycle)
 		__field(int, curr_block)
 		__field(xfs_lsn_t, tail_lsn)
@@ -784,15 +782,15 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		__entry->curr_res = tic->t_curr_res;
 		__entry->unit_res = tic->t_unit_res;
 		__entry->flags = tic->t_flags;
-		__entry->reserve_headq = log->l_reserve_headq;
-		__entry->write_headq = log->l_write_headq;
-		__entry->grant_reserve_cycle = log->l_grant_reserve_cycle;
-		__entry->grant_reserve_bytes = log->l_grant_reserve_bytes;
-		__entry->grant_write_cycle = log->l_grant_write_cycle;
-		__entry->grant_write_bytes = log->l_grant_write_bytes;
+		__entry->reserveq = log->l_reserveq.next;
+		__entry->writeq = log->l_writeq.next;
+		__entry->grant_reserve_lsn =
+				atomic64_read(&log->l_grant_reserve_lsn);
+		__entry->grant_write_lsn =
+				atomic64_read(&log->l_grant_write_lsn);
 		__entry->curr_cycle = log->l_curr_cycle;
 		__entry->curr_block = log->l_curr_block;
-		__entry->tail_lsn = log->l_tail_lsn;
+		__entry->tail_lsn = atomic64_read(&log->l_tail_lsn);
 	),
 	TP_printk("dev %d:%d type %s t_ocnt %u t_cnt %u t_curr_res %u "
 		  "t_unit_res %u t_flags %s reserve_headq 0x%p "
@@ -807,12 +805,12 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		  __entry->curr_res,
 		  __entry->unit_res,
 		  __print_flags(__entry->flags, "|", XLOG_TIC_FLAGS),
-		  __entry->reserve_headq,
-		  __entry->write_headq,
-		  __entry->grant_reserve_cycle,
-		  __entry->grant_reserve_bytes,
-		  __entry->grant_write_cycle,
-		  __entry->grant_write_bytes,
+		  __entry->reserveq,
+		  __entry->writeq,
+		  CYCLE_LSN(__entry->grant_reserve_lsn),
+		  BLOCK_LSN(__entry->grant_reserve_lsn),
+		  CYCLE_LSN(__entry->grant_write_lsn),
+		  BLOCK_LSN(__entry->grant_write_lsn),
 		  __entry->curr_cycle,
 		  __entry->curr_block,
 		  CYCLE_LSN(__entry->tail_lsn),
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index cee4ab9..12c726b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -47,7 +47,8 @@ STATIC xlog_t *  xlog_alloc_log(xfs_mount_t	*mp,
 				xfs_buftarg_t	*log_target,
 				xfs_daddr_t	blk_offset,
 				int		num_bblks);
-STATIC int	 xlog_space_left(xlog_t *log, int cycle, int bytes);
+STATIC int	 xlog_space_left(xfs_lsn_t tail_lsn, int log_size,
+				xfs_lsn_t marker);
 STATIC int	 xlog_sync(xlog_t *log, xlog_in_core_t *iclog);
 STATIC void	 xlog_dealloc_log(xlog_t *log);
 
@@ -70,8 +71,8 @@ STATIC void xlog_state_want_sync(xlog_t	*log, xlog_in_core_t *iclog);
 /* local functions to manipulate grant head */
 STATIC int  xlog_grant_log_space(xlog_t		*log,
 				 xlog_ticket_t	*xtic);
-STATIC void xlog_grant_push_ail(xfs_mount_t	*mp,
-				int		need_bytes);
+STATIC void xlog_grant_push_ail(struct log *log, xfs_lsn_t tail_lsn,
+				xfs_lsn_t last_sync_lsn, int need_bytes);
 STATIC void xlog_regrant_reserve_log_space(xlog_t	 *log,
 					   xlog_ticket_t *ticket);
 STATIC int xlog_regrant_write_log_space(xlog_t		*log,
@@ -81,7 +82,8 @@ STATIC void xlog_ungrant_log_space(xlog_t	 *log,
 
 #if defined(DEBUG)
 STATIC void	xlog_verify_dest_ptr(xlog_t *log, char *ptr);
-STATIC void	xlog_verify_grant_head(xlog_t *log, int equals);
+STATIC void	xlog_verify_grant_head(struct log *log, int equals);
+STATIC void	xlog_verify_grant_tail(struct log *log);
 STATIC void	xlog_verify_iclog(xlog_t *log, xlog_in_core_t *iclog,
 				  int count, boolean_t syncing);
 STATIC void	xlog_verify_tail_lsn(xlog_t *log, xlog_in_core_t *iclog,
@@ -89,90 +91,85 @@ STATIC void	xlog_verify_tail_lsn(xlog_t *log, xlog_in_core_t *iclog,
 #else
 #define xlog_verify_dest_ptr(a,b)
 #define xlog_verify_grant_head(a,b)
+#define xlog_verify_grant_tail(a)
 #define xlog_verify_iclog(a,b,c,d)
 #define xlog_verify_tail_lsn(a,b,c)
 #endif
 
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
+/*
+ * Grant space calculations use 64 bit atomic variables to store the current reserve
+ * and write grant markers. However, these are really two 32 bit numbers which
+ * need to be cracked out of the 64 bit variable, modified, recombined and then
+ * written back into the 64 bit atomic variable. And it has to be done
+ * atomically (i.e. without locks).
+ *
+ * The upper 32 bits is the log cycle, just like a xfs_lsn_t. The lower 32 bits
+ * is the byte offset into the log for the marker. Unlike the xfs_lsn_t, this
+ * is held in bytes rather than basic blocks, even though it uses the
+ * BLOCK_LSN() macro to extract it.
+ *
+ * Essentially, we use an compare and exchange algorithm to atomically update
+ * the markers. That is, we sample the current marker, crack it, perform the
+ * calculation, recombine it into a new value, and then conditionally set the
+ * value back into the atomic variable only if it hasn't changed since we first
+ * sampled it. This provides atomic updates of the marker, even though we do
+ * non-atomic, multi-step calculation on the value.
+ */
+static inline void
+xlog_grant_sub_space(
+	struct log	*log,
+	int		space,
+	atomic64_t	*val)
 {
-	if (tic == tic->t_next) {
-		*qp = NULL;
-	} else {
-		*qp = tic->t_next;
-		tic->t_next->t_prev = tic->t_prev;
-		tic->t_prev->t_next = tic->t_next;
-	}
+	xfs_lsn_t	last, old, new;
 
-	tic->t_next = tic->t_prev = NULL;
-	tic->t_flags &= ~XLOG_TIC_IN_Q;
-}
-
-static void
-xlog_grant_sub_space(struct log *log, int bytes)
-{
-	log->l_grant_write_bytes -= bytes;
-	if (log->l_grant_write_bytes < 0) {
-		log->l_grant_write_bytes += log->l_logsize;
-		log->l_grant_write_cycle--;
-	}
+	last = atomic64_read(val);
+	do {
+		int	cycle, bytes;
 
-	log->l_grant_reserve_bytes -= bytes;
-	if ((log)->l_grant_reserve_bytes < 0) {
-		log->l_grant_reserve_bytes += log->l_logsize;
-		log->l_grant_reserve_cycle--;
-	}
+		old = last;
+		cycle = CYCLE_LSN(old);
+		bytes = BLOCK_LSN(old);
 
+		bytes -= space;
+		if (bytes < 0) {
+			bytes += log->l_logsize;
+			cycle--;
+		}
+		new = xlog_assign_lsn(cycle, bytes);
+		last = atomic64_cmpxchg(val, old, new);
+	} while (last != old);
 }
 
 static void
-xlog_grant_add_space_write(struct log *log, int bytes)
+xlog_grant_add_space(
+	struct log	*log,
+	int		space,
+	atomic64_t	*val)
 {
-	int tmp = log->l_logsize - log->l_grant_write_bytes;
-	if (tmp > bytes)
-		log->l_grant_write_bytes += bytes;
-	else {
-		log->l_grant_write_cycle++;
-		log->l_grant_write_bytes = bytes - tmp;
-	}
-}
+	xfs_lsn_t	last, old, new;
 
-static void
-xlog_grant_add_space_reserve(struct log *log, int bytes)
-{
-	int tmp = log->l_logsize - log->l_grant_reserve_bytes;
-	if (tmp > bytes)
-		log->l_grant_reserve_bytes += bytes;
-	else {
-		log->l_grant_reserve_cycle++;
-		log->l_grant_reserve_bytes = bytes - tmp;
-	}
-}
+	last = atomic64_read(val);
+	do {
+		int	cycle, bytes, available;
+
+		old = last;
+		cycle = CYCLE_LSN(old);
+		bytes = BLOCK_LSN(old);
+		available = log->l_logsize - bytes;
+
+		if (available > space)
+			bytes += space;
+		else {
+			cycle++;
+			bytes = space - available;
+		}
 
-static inline void
-xlog_grant_add_space(struct log *log, int bytes)
-{
-	xlog_grant_add_space_write(log, bytes);
-	xlog_grant_add_space_reserve(log, bytes);
+		new = xlog_assign_lsn(cycle, bytes);
+		last = atomic64_cmpxchg(val, old, new);
+	} while (last != old);
 }
 
 static void
@@ -321,12 +318,12 @@ xfs_log_release_iclog(
 int
 xfs_log_reserve(
 	struct xfs_mount	*mp,
-	int		 	unit_bytes,
-	int		 	cnt,
+	int			unit_bytes,
+	int			cnt,
 	struct xlog_ticket	**ticket,
-	__uint8_t	 	client,
-	uint		 	flags,
-	uint		 	t_type)
+	__uint8_t		client,
+	uint			flags,
+	uint			t_type)
 {
 	struct log		*log = mp->m_log;
 	struct xlog_ticket	*internal_ticket;
@@ -339,7 +336,6 @@ xfs_log_reserve(
 
 	XFS_STATS_INC(xs_try_logspace);
 
-
 	if (*ticket != NULL) {
 		ASSERT(flags & XFS_LOG_PERM_RESERV);
 		internal_ticket = *ticket;
@@ -355,7 +351,9 @@ xfs_log_reserve(
 
 		trace_xfs_log_reserve(log, internal_ticket);
 
-		xlog_grant_push_ail(mp, internal_ticket->t_unit_res);
+		xlog_grant_push_ail(log, atomic64_read(&log->l_tail_lsn),
+				    atomic64_read(&log->l_last_sync_lsn),
+				    internal_ticket->t_unit_res);
 		retval = xlog_regrant_write_log_space(log, internal_ticket);
 	} else {
 		/* may sleep if need to allocate more tickets */
@@ -369,14 +367,15 @@ xfs_log_reserve(
 
 		trace_xfs_log_reserve(log, internal_ticket);
 
-		xlog_grant_push_ail(mp,
+		xlog_grant_push_ail(log, atomic64_read(&log->l_tail_lsn),
+				    atomic64_read(&log->l_last_sync_lsn),
 				    (internal_ticket->t_unit_res *
 				     internal_ticket->t_cnt));
 		retval = xlog_grant_log_space(log, internal_ticket);
 	}
 
 	return retval;
-}	/* xfs_log_reserve */
+}
 
 
 /*
@@ -699,73 +698,80 @@ xfs_log_write(
 
 void
 xfs_log_move_tail(xfs_mount_t	*mp,
-		  xfs_lsn_t	tail_lsn)
+		  xfs_lsn_t	new_tail_lsn)
 {
 	xlog_ticket_t	*tic;
 	xlog_t		*log = mp->m_log;
-	int		need_bytes, free_bytes, cycle, bytes;
+	int		need_bytes, free_bytes;
 
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return;
 
-	if (tail_lsn == 0) {
-		/* needed since sync_lsn is 64 bits */
-		spin_lock(&log->l_icloglock);
-		tail_lsn = log->l_last_sync_lsn;
-		spin_unlock(&log->l_icloglock);
-	}
-
-	spin_lock(&log->l_grant_lock);
-
-	/* Also an invalid lsn.  1 implies that we aren't passing in a valid
-	 * tail_lsn.
+	/*
+	 * new_tail_lsn == 1 implies that we aren't passing in a valid
+	 * tail_lsn, so don't set the tail.
 	 */
-	if (tail_lsn != 1) {
-		log->l_tail_lsn = tail_lsn;
+	switch (new_tail_lsn) {
+	case 0:
+		/* AIL is empty, so tail is what was last written to disk */
+		atomic64_set(&log->l_tail_lsn,
+				atomic64_read(&log->l_last_sync_lsn));
+		break;
+	case 1:
+		/* Current tail is unknown, so just use the existing one */
+		break;
+	default:
+		/* update the tail with the new lsn. */
+		atomic64_set(&log->l_tail_lsn, new_tail_lsn);
+		break;
 	}
 
-	if ((tic = log->l_write_headq)) {
+	if (!list_empty(&log->l_writeq)) {
 #ifdef DEBUG
 		if (log->l_flags & XLOG_ACTIVE_RECOVERY)
 			panic("Recovery problem");
 #endif
-		cycle = log->l_grant_write_cycle;
-		bytes = log->l_grant_write_bytes;
-		free_bytes = xlog_space_left(log, cycle, bytes);
-		do {
+		spin_lock(&log->l_grant_write_lock);
+		free_bytes = xlog_space_left(atomic64_read(&log->l_tail_lsn),
+				log->l_logsize,
+				atomic64_read(&log->l_grant_write_lsn));
+
+		list_for_each_entry(tic, &log->l_writeq, t_queue) {
 			ASSERT(tic->t_flags & XLOG_TIC_PERM_RESERV);
 
-			if (free_bytes < tic->t_unit_res && tail_lsn != 1)
+			if (free_bytes < tic->t_unit_res && new_tail_lsn != 1)
 				break;
-			tail_lsn = 0;
+			new_tail_lsn = 0;
 			free_bytes -= tic->t_unit_res;
 			sv_signal(&tic->t_wait);
-			tic = tic->t_next;
-		} while (tic != log->l_write_headq);
+		}
+		spin_unlock(&log->l_grant_write_lock);
 	}
-	if ((tic = log->l_reserve_headq)) {
+
+	if (!list_empty(&log->l_reserveq)) {
 #ifdef DEBUG
 		if (log->l_flags & XLOG_ACTIVE_RECOVERY)
 			panic("Recovery problem");
 #endif
-		cycle = log->l_grant_reserve_cycle;
-		bytes = log->l_grant_reserve_bytes;
-		free_bytes = xlog_space_left(log, cycle, bytes);
-		do {
+		spin_lock(&log->l_grant_reserve_lock);
+		free_bytes = xlog_space_left(atomic64_read(&log->l_tail_lsn),
+				log->l_logsize,
+				atomic64_read(&log->l_grant_reserve_lsn));
+
+		list_for_each_entry(tic, &log->l_reserveq, t_queue) {
 			if (tic->t_flags & XLOG_TIC_PERM_RESERV)
 				need_bytes = tic->t_unit_res*tic->t_cnt;
 			else
 				need_bytes = tic->t_unit_res;
-			if (free_bytes < need_bytes && tail_lsn != 1)
+			if (free_bytes < need_bytes && new_tail_lsn != 1)
 				break;
-			tail_lsn = 0;
+			new_tail_lsn = 0;
 			free_bytes -= need_bytes;
 			sv_signal(&tic->t_wait);
-			tic = tic->t_next;
-		} while (tic != log->l_reserve_headq);
+		}
+		spin_unlock(&log->l_grant_reserve_lock);
 	}
-	spin_unlock(&log->l_grant_lock);
-}	/* xfs_log_move_tail */
+}
 
 /*
  * Determine if we have a transaction that has gone to disk
@@ -837,16 +843,13 @@ xlog_assign_tail_lsn(xfs_mount_t *mp)
 	xlog_t	  *log = mp->m_log;
 
 	tail_lsn = xfs_trans_ail_tail(mp->m_ail);
-	spin_lock(&log->l_grant_lock);
-	if (tail_lsn != 0) {
-		log->l_tail_lsn = tail_lsn;
-	} else {
-		tail_lsn = log->l_tail_lsn = log->l_last_sync_lsn;
+	if (tail_lsn) {
+		atomic64_set(&log->l_tail_lsn, tail_lsn);
+		return tail_lsn;
 	}
-	spin_unlock(&log->l_grant_lock);
-
-	return tail_lsn;
-}	/* xlog_assign_tail_lsn */
+	atomic64_set(&log->l_tail_lsn, atomic64_read(&log->l_last_sync_lsn));
+	return atomic64_read(&log->l_tail_lsn);
+}
 
 
 /*
@@ -864,16 +867,21 @@ xlog_assign_tail_lsn(xfs_mount_t *mp)
  * result is that we return the size of the log as the amount of space left.
  */
 STATIC int
-xlog_space_left(xlog_t *log, int cycle, int bytes)
+xlog_space_left(
+	xfs_lsn_t	tail_lsn,
+	int		log_size,
+	xfs_lsn_t	head)
 {
 	int free_bytes;
-	int tail_bytes;
-	int tail_cycle;
+	int tail_bytes = BBTOB(BLOCK_LSN(tail_lsn));
+	int tail_cycle = CYCLE_LSN(tail_lsn);
+	int cycle = CYCLE_LSN(head);
+	int bytes = BLOCK_LSN(head);
 
-	tail_bytes = BBTOB(BLOCK_LSN(log->l_tail_lsn));
-	tail_cycle = CYCLE_LSN(log->l_tail_lsn);
+	tail_bytes = BBTOB(BLOCK_LSN(tail_lsn));
+	tail_cycle = CYCLE_LSN(tail_lsn);
 	if ((tail_cycle == cycle) && (bytes >= tail_bytes)) {
-		free_bytes = log->l_logsize - (bytes - tail_bytes);
+		free_bytes = log_size - (bytes - tail_bytes);
 	} else if ((tail_cycle + 1) < cycle) {
 		return 0;
 	} else if (tail_cycle < cycle) {
@@ -885,13 +893,13 @@ xlog_space_left(xlog_t *log, int cycle, int bytes)
 		 * In this case we just want to return the size of the
 		 * log as the amount of space left.
 		 */
-		xfs_fs_cmn_err(CE_ALERT, log->l_mp,
+		cmn_err(CE_ALERT,
 			"xlog_space_left: head behind tail\n"
 			"  tail_cycle = %d, tail_bytes = %d\n"
 			"  GH   cycle = %d, GH   bytes = %d",
 			tail_cycle, tail_bytes, cycle, bytes);
 		ASSERT(0);
-		free_bytes = log->l_logsize;
+		free_bytes = log_size;
 	}
 	return free_bytes;
 }	/* xlog_space_left */
@@ -1047,12 +1055,17 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	log->l_flags	   |= XLOG_ACTIVE_RECOVERY;
 
 	log->l_prev_block  = -1;
-	log->l_tail_lsn	   = xlog_assign_lsn(1, 0);
 	/* log->l_tail_lsn = 0x100000000LL; cycle = 1; current block = 0 */
-	log->l_last_sync_lsn = log->l_tail_lsn;
 	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
-	log->l_grant_reserve_cycle = 1;
-	log->l_grant_write_cycle = 1;
+	atomic64_set(&log->l_tail_lsn, xlog_assign_lsn(log->l_curr_cycle, 0));
+	atomic64_set(&log->l_last_sync_lsn, atomic64_read(&log->l_tail_lsn));
+	atomic64_set(&log->l_grant_reserve_lsn, atomic64_read(&log->l_tail_lsn));
+	atomic64_set(&log->l_grant_write_lsn, atomic64_read(&log->l_tail_lsn));
+
+	spin_lock_init(&log->l_grant_reserve_lock);
+	INIT_LIST_HEAD(&log->l_reserveq);
+	spin_lock_init(&log->l_grant_write_lock);
+	INIT_LIST_HEAD(&log->l_writeq);
 
 	error = EFSCORRUPTED;
 	if (xfs_sb_version_hassector(&mp->m_sb)) {
@@ -1094,7 +1107,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	log->l_xbuf = bp;
 
 	spin_lock_init(&log->l_icloglock);
-	spin_lock_init(&log->l_grant_lock);
 	sv_init(&log->l_flush_wait, 0, "flush_wait");
 
 	/* log record size must be multiple of BBSIZE; see xlog_rec_header_t */
@@ -1175,7 +1187,6 @@ out_free_iclog:
 		kmem_free(iclog);
 	}
 	spinlock_destroy(&log->l_icloglock);
-	spinlock_destroy(&log->l_grant_lock);
 	xfs_buf_free(log->l_xbuf);
 out_free_log:
 	kmem_free(log);
@@ -1223,11 +1234,12 @@ xlog_commit_record(
  * water mark.  In this manner, we would be creating a low water mark.
  */
 STATIC void
-xlog_grant_push_ail(xfs_mount_t	*mp,
-		    int		need_bytes)
+xlog_grant_push_ail(
+	struct log	*log,
+	xfs_lsn_t	tail_lsn,
+	xfs_lsn_t	last_sync_lsn,
+	int		need_bytes)
 {
-    xlog_t	*log = mp->m_log;	/* pointer to the log */
-    xfs_lsn_t	tail_lsn;		/* lsn of the log tail */
     xfs_lsn_t	threshold_lsn = 0;	/* lsn we'd like to be at */
     int		free_blocks;		/* free blocks left to write to */
     int		free_bytes;		/* free bytes left to write to */
@@ -1237,11 +1249,8 @@ xlog_grant_push_ail(xfs_mount_t	*mp,
 
     ASSERT(BTOBB(need_bytes) < log->l_logBBsize);
 
-    spin_lock(&log->l_grant_lock);
-    free_bytes = xlog_space_left(log,
-				 log->l_grant_reserve_cycle,
-				 log->l_grant_reserve_bytes);
-    tail_lsn = log->l_tail_lsn;
+    free_bytes = xlog_space_left(tail_lsn, log->l_logsize,
+				atomic64_read(&log->l_grant_reserve_lsn));
     free_blocks = BTOBBT(free_bytes);
 
     /*
@@ -1264,10 +1273,9 @@ xlog_grant_push_ail(xfs_mount_t	*mp,
 	/* Don't pass in an lsn greater than the lsn of the last
 	 * log record known to be on disk.
 	 */
-	if (XFS_LSN_CMP(threshold_lsn, log->l_last_sync_lsn) > 0)
-	    threshold_lsn = log->l_last_sync_lsn;
+	if (XFS_LSN_CMP(threshold_lsn, last_sync_lsn) > 0)
+	    threshold_lsn = last_sync_lsn;
     }
-    spin_unlock(&log->l_grant_lock);
 
     /*
      * Get the transaction layer to kick the dirty buffers out to
@@ -1277,7 +1285,7 @@ xlog_grant_push_ail(xfs_mount_t	*mp,
     if (threshold_lsn &&
 	!XLOG_FORCED_SHUTDOWN(log))
 	    xfs_trans_ail_push(log->l_ailp, threshold_lsn);
-}	/* xlog_grant_push_ail */
+}
 
 /*
  * The bdstrat callback function for log bufs. This gives us a central
@@ -1365,19 +1373,17 @@ xlog_sync(xlog_t		*log,
 	}
 	roundoff = count - count_init;
 	ASSERT(roundoff >= 0);
-	ASSERT((v2 && log->l_mp->m_sb.sb_logsunit > 1 && 
-                roundoff < log->l_mp->m_sb.sb_logsunit)
-		|| 
-		(log->l_mp->m_sb.sb_logsunit <= 1 && 
+	ASSERT((v2 && log->l_mp->m_sb.sb_logsunit > 1 &&
+                roundoff < log->l_mp->m_sb.sb_logsunit) ||
+		(log->l_mp->m_sb.sb_logsunit <= 1 &&
 		 roundoff < BBTOB(1)));
 
 	/* move grant heads by roundoff in sync */
-	spin_lock(&log->l_grant_lock);
-	xlog_grant_add_space(log, roundoff);
-	spin_unlock(&log->l_grant_lock);
+	xlog_grant_add_space(log, roundoff, &log->l_grant_reserve_lsn);
+	xlog_grant_add_space(log, roundoff, &log->l_grant_write_lsn);
 
 	/* put cycle number in every block */
-	xlog_pack_data(log, iclog, roundoff); 
+	xlog_pack_data(log, iclog, roundoff);
 
 	/* real byte length */
 	if (v2) {
@@ -1497,7 +1503,6 @@ xlog_dealloc_log(xlog_t *log)
 		iclog = next_iclog;
 	}
 	spinlock_destroy(&log->l_icloglock);
-	spinlock_destroy(&log->l_grant_lock);
 
 	xfs_buf_free(log->l_xbuf);
 	log->l_mp->m_log = NULL;
@@ -2240,19 +2245,14 @@ xlog_state_do_callback(
 
 				iclog->ic_state = XLOG_STATE_CALLBACK;
 
-				spin_unlock(&log->l_icloglock);
-
-				/* l_last_sync_lsn field protected by
-				 * l_grant_lock. Don't worry about iclog's lsn.
-				 * No one else can be here except us.
-				 */
-				spin_lock(&log->l_grant_lock);
-				ASSERT(XFS_LSN_CMP(log->l_last_sync_lsn,
+				ASSERT(XFS_LSN_CMP(
+				       atomic64_read(&log->l_last_sync_lsn),
 				       be64_to_cpu(iclog->ic_header.h_lsn)) <= 0);
-				log->l_last_sync_lsn =
-					be64_to_cpu(iclog->ic_header.h_lsn);
-				spin_unlock(&log->l_grant_lock);
 
+				atomic64_set(&log->l_last_sync_lsn,
+					be64_to_cpu(iclog->ic_header.h_lsn));
+
+				spin_unlock(&log->l_icloglock);
 			} else {
 				spin_unlock(&log->l_icloglock);
 				ioerrors++;
@@ -2527,6 +2527,18 @@ restart:
  *
  * Once a ticket gets put onto the reserveq, it will only return after
  * the needed reservation is satisfied.
+ *
+ * This function is structured so that it has a lock free fast path. This is
+ * necessary because every new transaction reservation will come through this
+ * path. Hence any lock will be globally hot if we take it unconditionally on
+ * every pass.
+ *
+ * As tickets are only ever moved on and off the reserveq under the
+ * l_grant_reserve_lock, we only need to take that lock if we are going
+ * to add the ticket to the queue and sleep. We can avoid taking the lock if the
+ * ticket was never added to the reserveq because the t_queue list head will be
+ * empty and we hold the only reference to it so it can safely be checked
+ * unlocked.
  */
 STATIC int
 xlog_grant_log_space(xlog_t	   *log,
@@ -2534,24 +2546,27 @@ xlog_grant_log_space(xlog_t	   *log,
 {
 	int		 free_bytes;
 	int		 need_bytes;
-#ifdef DEBUG
-	xfs_lsn_t	 tail_lsn;
-#endif
-
 
 #ifdef DEBUG
 	if (log->l_flags & XLOG_ACTIVE_RECOVERY)
 		panic("grant Recovery problem");
 #endif
 
-	/* Is there space or do we need to sleep? */
-	spin_lock(&log->l_grant_lock);
-
 	trace_xfs_log_grant_enter(log, tic);
 
+	need_bytes = tic->t_unit_res;
+	if (tic->t_flags & XFS_LOG_PERM_RESERV)
+		need_bytes *= tic->t_ocnt;
+
 	/* something is already sleeping; insert new transaction at end */
-	if (log->l_reserve_headq) {
-		xlog_ins_ticketq(&log->l_reserve_headq, tic);
+	if (!list_empty(&log->l_reserveq)) {
+		spin_lock(&log->l_grant_reserve_lock);
+		if (list_empty(&log->l_reserveq)) {
+			spin_unlock(&log->l_grant_reserve_lock);
+			goto redo;
+		}
+
+		list_add_tail(&tic->t_queue, &log->l_reserveq);
 
 		trace_xfs_log_grant_sleep1(log, tic);
 
@@ -2563,71 +2578,64 @@ xlog_grant_log_space(xlog_t	   *log,
 			goto error_return;
 
 		XFS_STATS_INC(xs_sleep_logspace);
-		sv_wait(&tic->t_wait, PINOD|PLTWAIT, &log->l_grant_lock, s);
+		sv_wait(&tic->t_wait, PINOD|PLTWAIT,
+			&log->l_grant_reserve_lock, s);
 		/*
 		 * If we got an error, and the filesystem is shutting down,
 		 * we'll catch it down below. So just continue...
 		 */
 		trace_xfs_log_grant_wake1(log, tic);
-		spin_lock(&log->l_grant_lock);
 	}
-	if (tic->t_flags & XFS_LOG_PERM_RESERV)
-		need_bytes = tic->t_unit_res*tic->t_ocnt;
-	else
-		need_bytes = tic->t_unit_res;
 
 redo:
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (XLOG_FORCED_SHUTDOWN(log)) {
+		spin_lock(&log->l_grant_reserve_lock);
 		goto error_return;
+	}
 
-	free_bytes = xlog_space_left(log, log->l_grant_reserve_cycle,
-				     log->l_grant_reserve_bytes);
+	free_bytes = xlog_space_left(atomic64_read(&log->l_tail_lsn),
+				log->l_logsize,
+				atomic64_read(&log->l_grant_reserve_lsn));
 	if (free_bytes < need_bytes) {
-		if ((tic->t_flags & XLOG_TIC_IN_Q) == 0)
-			xlog_ins_ticketq(&log->l_reserve_headq, tic);
+		spin_lock(&log->l_grant_reserve_lock);
+		if (list_empty(&tic->t_queue))
+			list_add_tail(&tic->t_queue, &log->l_reserveq);
 
-		trace_xfs_log_grant_sleep2(log, tic);
-
-		spin_unlock(&log->l_grant_lock);
-		xlog_grant_push_ail(log->l_mp, need_bytes);
-		spin_lock(&log->l_grant_lock);
+		xlog_grant_push_ail(log, atomic64_read(&log->l_tail_lsn),
+				    atomic64_read(&log->l_last_sync_lsn),
+				    need_bytes);
 
-		XFS_STATS_INC(xs_sleep_logspace);
-		sv_wait(&tic->t_wait, PINOD|PLTWAIT, &log->l_grant_lock, s);
+		trace_xfs_log_grant_sleep2(log, tic);
 
-		spin_lock(&log->l_grant_lock);
 		if (XLOG_FORCED_SHUTDOWN(log))
 			goto error_return;
 
+		XFS_STATS_INC(xs_sleep_logspace);
+		sv_wait(&tic->t_wait, PINOD|PLTWAIT,
+			&log->l_grant_reserve_lock, s);
+
 		trace_xfs_log_grant_wake2(log, tic);
 
 		goto redo;
-	} else if (tic->t_flags & XLOG_TIC_IN_Q)
-		xlog_del_ticketq(&log->l_reserve_headq, tic);
+	}
 
 	/* we've got enough space */
-	xlog_grant_add_space(log, need_bytes);
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
+	if (!list_empty(&tic->t_queue)) {
+		spin_lock(&log->l_grant_reserve_lock);
+		list_del_init(&tic->t_queue);
+		spin_unlock(&log->l_grant_reserve_lock);
 	}
-#endif
+	xlog_grant_add_space(log, need_bytes, &log->l_grant_reserve_lsn);
+	xlog_grant_add_space(log, need_bytes, &log->l_grant_write_lsn);
+
 	trace_xfs_log_grant_exit(log, tic);
+	xlog_verify_grant_tail(log);
 	xlog_verify_grant_head(log, 1);
-	spin_unlock(&log->l_grant_lock);
 	return 0;
 
  error_return:
-	if (tic->t_flags & XLOG_TIC_IN_Q)
-		xlog_del_ticketq(&log->l_reserve_headq, tic);
+	list_del_init(&tic->t_queue);
+	spin_unlock(&log->l_grant_reserve_lock);
 
 	trace_xfs_log_grant_error(log, tic);
 
@@ -2638,25 +2646,23 @@ redo:
 	 */
 	tic->t_curr_res = 0;
 	tic->t_cnt = 0; /* ungrant will give back unit_res * t_cnt. */
-	spin_unlock(&log->l_grant_lock);
 	return XFS_ERROR(EIO);
-}	/* xlog_grant_log_space */
+}
 
 
 /*
  * Replenish the byte reservation required by moving the grant write head.
  *
- *
+ * Regranting log space is not a particularly hot path, so not real effort has
+ * been made to make the fast path lock free. If contention on the
+ * l_grant_write_lock becomes evident, it shoul dbe easy to apply the same
+ * modifications made to xlog_grant_log_space to this function.
  */
 STATIC int
 xlog_regrant_write_log_space(xlog_t	   *log,
 			     xlog_ticket_t *tic)
 {
 	int		free_bytes, need_bytes;
-	xlog_ticket_t	*ntic;
-#ifdef DEBUG
-	xfs_lsn_t	tail_lsn;
-#endif
 
 	tic->t_curr_res = tic->t_unit_res;
 	xlog_tic_reset_res(tic);
@@ -2669,10 +2675,9 @@ xlog_regrant_write_log_space(xlog_t	   *log,
 		panic("regrant Recovery problem");
 #endif
 
-	spin_lock(&log->l_grant_lock);
-
 	trace_xfs_log_regrant_write_enter(log, tic);
 
+	spin_lock(&log->l_grant_write_lock);
 	if (XLOG_FORCED_SHUTDOWN(log))
 		goto error_return;
 
@@ -2683,36 +2688,43 @@ xlog_regrant_write_log_space(xlog_t	   *log,
 	 * this transaction.
 	 */
 	need_bytes = tic->t_unit_res;
-	if ((ntic = log->l_write_headq)) {
-		free_bytes = xlog_space_left(log, log->l_grant_write_cycle,
-					     log->l_grant_write_bytes);
-		do {
+	if (!list_empty(&log->l_writeq)) {
+		struct xlog_ticket *ntic;
+		free_bytes = xlog_space_left(atomic64_read(&log->l_tail_lsn),
+				log->l_logsize,
+				atomic64_read(&log->l_grant_write_lsn));
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
 
-			spin_unlock(&log->l_grant_lock);
-			xlog_grant_push_ail(log->l_mp, need_bytes);
-			spin_lock(&log->l_grant_lock);
+			spin_unlock(&log->l_grant_write_lock);
+
+			xlog_grant_push_ail(log,
+					atomic64_read(&log->l_tail_lsn),
+					atomic64_read(&log->l_last_sync_lsn),
+					need_bytes);
+
+			spin_lock(&log->l_grant_write_lock);
 
 			XFS_STATS_INC(xs_sleep_logspace);
 			sv_wait(&tic->t_wait, PINOD|PLTWAIT,
-				&log->l_grant_lock, s);
+				&log->l_grant_write_lock, s);
 
 			/* If we're shutting down, this tic is already
 			 * off the queue */
-			spin_lock(&log->l_grant_lock);
+			spin_lock(&log->l_grant_write_lock);
 			if (XLOG_FORCED_SHUTDOWN(log))
 				goto error_return;
 
@@ -2724,50 +2736,48 @@ redo:
 	if (XLOG_FORCED_SHUTDOWN(log))
 		goto error_return;
 
-	free_bytes = xlog_space_left(log, log->l_grant_write_cycle,
-				     log->l_grant_write_bytes);
+	free_bytes = xlog_space_left(atomic64_read(&log->l_tail_lsn),
+				log->l_logsize,
+				atomic64_read(&log->l_grant_write_lsn));
 	if (free_bytes < need_bytes) {
-		if ((tic->t_flags & XLOG_TIC_IN_Q) == 0)
-			xlog_ins_ticketq(&log->l_write_headq, tic);
-		spin_unlock(&log->l_grant_lock);
-		xlog_grant_push_ail(log->l_mp, need_bytes);
-		spin_lock(&log->l_grant_lock);
+		if (list_empty(&tic->t_queue))
+			list_add_tail(&tic->t_queue, &log->l_writeq);
 
+		spin_unlock(&log->l_grant_write_lock);
+
+		xlog_grant_push_ail(log, atomic64_read(&log->l_tail_lsn),
+					atomic64_read(&log->l_last_sync_lsn),
+					need_bytes);
+
+		spin_lock(&log->l_grant_write_lock);
 		XFS_STATS_INC(xs_sleep_logspace);
 		trace_xfs_log_regrant_write_sleep2(log, tic);
-
-		sv_wait(&tic->t_wait, PINOD|PLTWAIT, &log->l_grant_lock, s);
+		sv_wait(&tic->t_wait, PINOD|PLTWAIT,
+			&log->l_grant_write_lock, s);
 
 		/* If we're shutting down, this tic is already off the queue */
-		spin_lock(&log->l_grant_lock);
+		spin_lock(&log->l_grant_write_lock);
 		if (XLOG_FORCED_SHUTDOWN(log))
 			goto error_return;
 
 		trace_xfs_log_regrant_write_wake2(log, tic);
 		goto redo;
-	} else if (tic->t_flags & XLOG_TIC_IN_Q)
-		xlog_del_ticketq(&log->l_write_headq, tic);
+	}
 
 	/* we've got enough space */
-	xlog_grant_add_space_write(log, need_bytes);
-#ifdef DEBUG
-	tail_lsn = log->l_tail_lsn;
-	if (CYCLE_LSN(tail_lsn) != log->l_grant_write_cycle) {
-		ASSERT(log->l_grant_write_cycle-1 == CYCLE_LSN(tail_lsn));
-		ASSERT(log->l_grant_write_bytes <= BBTOB(BLOCK_LSN(tail_lsn)));
-	}
-#endif
+	list_del_init(&tic->t_queue);
+	spin_unlock(&log->l_grant_write_lock);
+	xlog_grant_add_space(log, need_bytes, &log->l_grant_write_lsn);
 
 	trace_xfs_log_regrant_write_exit(log, tic);
-
+	xlog_verify_grant_tail(log);
 	xlog_verify_grant_head(log, 1);
-	spin_unlock(&log->l_grant_lock);
 	return 0;
 
 
  error_return:
-	if (tic->t_flags & XLOG_TIC_IN_Q)
-		xlog_del_ticketq(&log->l_reserve_headq, tic);
+	list_del_init(&tic->t_queue);
+	spin_unlock(&log->l_grant_write_lock);
 
 	trace_xfs_log_regrant_write_error(log, tic);
 
@@ -2778,9 +2788,8 @@ redo:
 	 */
 	tic->t_curr_res = 0;
 	tic->t_cnt = 0; /* ungrant will give back unit_res * t_cnt. */
-	spin_unlock(&log->l_grant_lock);
 	return XFS_ERROR(EIO);
-}	/* xlog_regrant_write_log_space */
+}
 
 
 /* The first cnt-1 times through here we don't need to
@@ -2799,30 +2808,27 @@ xlog_regrant_reserve_log_space(xlog_t	     *log,
 	if (ticket->t_cnt > 0)
 		ticket->t_cnt--;
 
-	spin_lock(&log->l_grant_lock);
-	xlog_grant_sub_space(log, ticket->t_curr_res);
+	xlog_grant_sub_space(log, ticket->t_curr_res, &log->l_grant_write_lsn);
+	xlog_grant_sub_space(log, ticket->t_curr_res, &log->l_grant_reserve_lsn);
+
 	ticket->t_curr_res = ticket->t_unit_res;
 	xlog_tic_reset_res(ticket);
 
 	trace_xfs_log_regrant_reserve_sub(log, ticket);
-
 	xlog_verify_grant_head(log, 1);
 
 	/* just return if we still have some of the pre-reserved space */
-	if (ticket->t_cnt > 0) {
-		spin_unlock(&log->l_grant_lock);
+	if (ticket->t_cnt > 0)
 		return;
-	}
 
-	xlog_grant_add_space_reserve(log, ticket->t_unit_res);
+	xlog_grant_add_space(log, ticket->t_unit_res, &log->l_grant_reserve_lsn);
 
 	trace_xfs_log_regrant_reserve_exit(log, ticket);
-
 	xlog_verify_grant_head(log, 0);
-	spin_unlock(&log->l_grant_lock);
+
 	ticket->t_curr_res = ticket->t_unit_res;
 	xlog_tic_reset_res(ticket);
-}	/* xlog_regrant_reserve_log_space */
+}
 
 
 /*
@@ -2843,28 +2849,31 @@ STATIC void
 xlog_ungrant_log_space(xlog_t	     *log,
 		       xlog_ticket_t *ticket)
 {
-	if (ticket->t_cnt > 0)
-		ticket->t_cnt--;
+	int	space;
 
-	spin_lock(&log->l_grant_lock);
 	trace_xfs_log_ungrant_enter(log, ticket);
 
-	xlog_grant_sub_space(log, ticket->t_curr_res);
-
-	trace_xfs_log_ungrant_sub(log, ticket);
+	if (ticket->t_cnt > 0)
+		ticket->t_cnt--;
 
-	/* If this is a permanent reservation ticket, we may be able to free
+	/*
+	 * If this is a permanent reservation ticket, we may be able to free
 	 * up more space based on the remaining count.
 	 */
+	space = ticket->t_curr_res;
 	if (ticket->t_cnt > 0) {
 		ASSERT(ticket->t_flags & XLOG_TIC_PERM_RESERV);
-		xlog_grant_sub_space(log, ticket->t_unit_res*ticket->t_cnt);
+		space += ticket->t_unit_res * ticket->t_cnt;
 	}
 
-	trace_xfs_log_ungrant_exit(log, ticket);
+	trace_xfs_log_ungrant_sub(log, ticket);
+
+	xlog_grant_sub_space(log, space, &log->l_grant_write_lsn);
+	xlog_grant_sub_space(log, space, &log->l_grant_reserve_lsn);
 
+	trace_xfs_log_ungrant_exit(log, ticket);
 	xlog_verify_grant_head(log, 1);
-	spin_unlock(&log->l_grant_lock);
+
 	xfs_log_move_tail(log->l_mp, 1);
 }	/* xlog_ungrant_log_space */
 
@@ -2901,11 +2910,12 @@ xlog_state_release_iclog(
 
 	if (iclog->ic_state == XLOG_STATE_WANT_SYNC) {
 		/* update tail before writing to iclog */
-		xlog_assign_tail_lsn(log->l_mp);
+		xfs_lsn_t tail_lsn = xlog_assign_tail_lsn(log->l_mp);
+
 		sync++;
 		iclog->ic_state = XLOG_STATE_SYNCING;
-		iclog->ic_header.h_tail_lsn = cpu_to_be64(log->l_tail_lsn);
-		xlog_verify_tail_lsn(log, iclog, log->l_tail_lsn);
+		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
+		xlog_verify_tail_lsn(log, iclog, tail_lsn);
 		/* cycle incremented when incrementing curr_block */
 	}
 	spin_unlock(&log->l_icloglock);
@@ -3435,6 +3445,7 @@ xlog_ticket_alloc(
         }
 
 	atomic_set(&tic->t_ref, 1);
+	INIT_LIST_HEAD(&tic->t_queue);
 	tic->t_unit_res		= unit_bytes;
 	tic->t_curr_res		= unit_bytes;
 	tic->t_cnt		= cnt;
@@ -3484,18 +3495,48 @@ xlog_verify_dest_ptr(
 }
 
 STATIC void
-xlog_verify_grant_head(xlog_t *log, int equals)
+xlog_verify_grant_head(
+	struct log	*log,
+	int		equals)
 {
-    if (log->l_grant_reserve_cycle == log->l_grant_write_cycle) {
-	if (equals)
-	    ASSERT(log->l_grant_reserve_bytes >= log->l_grant_write_bytes);
-	else
-	    ASSERT(log->l_grant_reserve_bytes > log->l_grant_write_bytes);
-    } else {
-	ASSERT(log->l_grant_reserve_cycle-1 == log->l_grant_write_cycle);
-	ASSERT(log->l_grant_write_bytes >= log->l_grant_reserve_bytes);
-    }
-}	/* xlog_verify_grant_head */
+/* this is racy under work under concurrent modifications */
+#if 0
+	xfs_lsn_t reserve = atomic64_read(&log->l_grant_reserve_lsn);
+	xfs_lsn_t write = atomic64_read(&log->l_grant_write_lsn);
+
+	if (CYCLE_LSN(reserve) == CYCLE_LSN(write)) {
+		if (equals)
+			ASSERT(BLOCK_LSN(reserve) >= BLOCK_LSN(write));
+		else
+			ASSERT(BLOCK_LSN(reserve) > BLOCK_LSN(write));
+	} else {
+		ASSERT(CYCLE_LSN(reserve) - 1 == CYCLE_LSN(write));
+		ASSERT(BLOCK_LSN(write) >= BLOCK_LSN(reserve));
+	}
+#endif
+}
+
+STATIC void
+xlog_verify_grant_tail(
+	struct log	*log)
+{
+	xfs_lsn_t	 tail_lsn;
+	xfs_lsn_t	 write_lsn;
+
+	tail_lsn = atomic64_read(&log->l_tail_lsn);
+	write_lsn = atomic64_read(&log->l_grant_write_lsn);
+
+	/*
+	 * Check to make sure the grant write head didn't just over lap the
+	 * tail.  If the cycles are the same, we can't be overlapping.
+	 * Otherwise, make sure that the cycles differ by exactly one and
+	 * check the byte count.
+	 */
+	if (CYCLE_LSN(tail_lsn) != CYCLE_LSN(write_lsn)) {
+		ASSERT(CYCLE_LSN(write_lsn) - 1 == CYCLE_LSN(tail_lsn));
+		ASSERT(BLOCK_LSN(write_lsn) <= BBTOB(BLOCK_LSN(tail_lsn)));
+	}
+}
 
 /* check if it will fit */
 STATIC void
@@ -3721,7 +3762,6 @@ xfs_log_force_umount(
 	 * everybody up to tell the bad news.
 	 */
 	spin_lock(&log->l_icloglock);
-	spin_lock(&log->l_grant_lock);
 	mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
 	if (mp->m_sb_bp)
 		XFS_BUF_DONE(mp->m_sb_bp);
@@ -3742,27 +3782,21 @@ xfs_log_force_umount(
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
+	 * action is protected by the grant locks.
 	 */
-	if ((tic = log->l_reserve_headq)) {
-		do {
-			sv_signal(&tic->t_wait);
-			tic = tic->t_next;
-		} while (tic != log->l_reserve_headq);
-	}
-
-	if ((tic = log->l_write_headq)) {
-		do {
-			sv_signal(&tic->t_wait);
-			tic = tic->t_next;
-		} while (tic != log->l_write_headq);
-	}
-	spin_unlock(&log->l_grant_lock);
+	spin_lock(&log->l_grant_reserve_lock);
+	list_for_each_entry(tic, &log->l_reserveq, t_queue)
+		sv_signal(&tic->t_wait);
+	spin_unlock(&log->l_grant_reserve_lock);
+
+	spin_lock(&log->l_grant_write_lock);
+	list_for_each_entry(tic, &log->l_writeq, t_queue)
+		sv_signal(&tic->t_wait);
+	spin_unlock(&log->l_grant_write_lock);
 
 	if (!(log->l_iclog->ic_state & XLOG_STATE_IOERROR)) {
 		ASSERT(!logerror);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index edcdfe0..4d6bf38 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -133,12 +133,10 @@ static inline uint xlog_get_client_id(__be32 i)
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
 
@@ -245,8 +243,7 @@ typedef struct xlog_res {
 
 typedef struct xlog_ticket {
 	sv_t		   t_wait;	 /* ticket wait queue            : 20 */
-	struct xlog_ticket *t_next;	 /*			         :4|8 */
-	struct xlog_ticket *t_prev;	 /*				 :4|8 */
+	struct list_head   t_queue;	 /* reserve/write queue */
 	xlog_tid_t	   t_tid;	 /* transaction identifier	 : 4  */
 	atomic_t	   t_ref;	 /* ticket reference count       : 4  */
 	int		   t_curr_res;	 /* current reservation in bytes : 4  */
@@ -509,23 +506,34 @@ typedef struct log {
 						 * log entries" */
 	xlog_in_core_t		*l_iclog;       /* head log queue	*/
 	spinlock_t		l_icloglock;    /* grab to change iclog state */
-	xfs_lsn_t		l_tail_lsn;     /* lsn of 1st LR with unflushed
-						 * buffers */
-	xfs_lsn_t		l_last_sync_lsn;/* lsn of last LR on disk */
 	int			l_curr_cycle;   /* Cycle number of log writes */
 	int			l_prev_cycle;   /* Cycle number before last
 						 * block increment */
 	int			l_curr_block;   /* current logical log block */
 	int			l_prev_block;   /* previous logical log block */
 
-	/* The following block of fields are changed while holding grant_lock */
-	spinlock_t		l_grant_lock ____cacheline_aligned_in_smp;
-	xlog_ticket_t		*l_reserve_headq;
-	xlog_ticket_t		*l_write_headq;
-	int			l_grant_reserve_cycle;
-	int			l_grant_reserve_bytes;
-	int			l_grant_write_cycle;
-	int			l_grant_write_bytes;
+	/*
+	 * The l_tail_lsn and l_last_sync_lsn variables are set up as atomic
+	 * variables so they can be safely set and read without locking. While
+	 * they are often read together, they are updated differently with the
+	 * l_tail_lsn being quite hot, so place them on spearate cachelines.
+	 */
+	/* lsn of 1st LR with unflushed buffers */
+	atomic64_t		l_tail_lsn ____cacheline_aligned_in_smp;
+	/* lsn of last LR on disk */
+	atomic64_t		l_last_sync_lsn ____cacheline_aligned_in_smp;
+
+	/*
+	 * ticket grant locks, queues and accounting have their own cachlines
+	 * as these are quite hot and can be operated on concurrently.
+	 */
+	spinlock_t		l_grant_reserve_lock ____cacheline_aligned_in_smp;
+	struct list_head	l_reserveq;
+	atomic64_t		l_grant_reserve_lsn;
+
+	spinlock_t		l_grant_write_lock ____cacheline_aligned_in_smp;
+	struct list_head	l_writeq;
+	atomic64_t		l_grant_write_lsn;
 
 	/* The following field are used for debugging; need to hold icloglock */
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index baad94a..f73a215 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -925,12 +925,13 @@ xlog_find_tail(
 	log->l_curr_cycle = be32_to_cpu(rhead->h_cycle);
 	if (found == 2)
 		log->l_curr_cycle++;
-	log->l_tail_lsn = be64_to_cpu(rhead->h_tail_lsn);
-	log->l_last_sync_lsn = be64_to_cpu(rhead->h_lsn);
-	log->l_grant_reserve_cycle = log->l_curr_cycle;
-	log->l_grant_reserve_bytes = BBTOB(log->l_curr_block);
-	log->l_grant_write_cycle = log->l_curr_cycle;
-	log->l_grant_write_bytes = BBTOB(log->l_curr_block);
+	atomic64_set(&log->l_tail_lsn, be64_to_cpu(rhead->h_tail_lsn));
+	atomic64_set(&log->l_last_sync_lsn, be64_to_cpu(rhead->h_lsn));
+
+	atomic64_set(&log->l_grant_reserve_lsn,
+		xlog_assign_lsn(log->l_curr_cycle, BBTOB(log->l_curr_block)));
+	atomic64_set(&log->l_grant_write_lsn,
+		xlog_assign_lsn(log->l_curr_cycle, BBTOB(log->l_curr_block)));
 
 	/*
 	 * Look for unmount record.  If we find it, then we know there
@@ -960,7 +961,7 @@ xlog_find_tail(
 	}
 	after_umount_blk = (i + hblks + (int)
 		BTOBB(be32_to_cpu(rhead->h_len))) % log->l_logBBsize;
-	tail_lsn = log->l_tail_lsn;
+	tail_lsn = atomic64_read(&log->l_tail_lsn);
 	if (*head_blk == after_umount_blk &&
 	    be32_to_cpu(rhead->h_num_logops) == 1) {
 		umount_data_blk = (i + hblks) % log->l_logBBsize;
@@ -975,12 +976,12 @@ xlog_find_tail(
 			 * log records will point recovery to after the
 			 * current unmount record.
 			 */
-			log->l_tail_lsn =
+			atomic64_set(&log->l_tail_lsn,
 				xlog_assign_lsn(log->l_curr_cycle,
-						after_umount_blk);
-			log->l_last_sync_lsn =
+						after_umount_blk));
+			atomic64_set(&log->l_last_sync_lsn,
 				xlog_assign_lsn(log->l_curr_cycle,
-						after_umount_blk);
+						after_umount_blk));
 			*tail_blk = after_umount_blk;
 
 			/*
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
