Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1K2nulm042721 for <xfs@oss.sgi.com>; Sun, 19 Feb 2012 20:49:56 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	o341nFS6z14jd0Q7 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 19 Feb 2012 18:31:55 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RzJ2g-0005iZ-9i
	for xfs@oss.sgi.com; Mon, 20 Feb 2012 02:31:54 +0000
Message-Id: <20120220023154.252855704@bombadil.infradead.org>
Date: Sun, 19 Feb 2012 21:31:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 12/12] xfs: split and cleanup xfs_log_reserve
References: <20120220023119.435889631@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-split-xfs_log_reserve
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

Split the log regrant case out of xfs_log_reserve into a separate function,
and merge xlog_grant_log_space and xlog_regrant_write_log_space into their
respective callers.  Also replace the XFS_LOG_PERM_RESERV flag, which easily
got misused before the previous cleanups with a simple boolean parameter.

Reviewed-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_log.c   |  198 ++++++++++++++++++++++++-----------------------------
 fs/xfs/xfs_log.h   |    1 
 fs/xfs/xfs_trace.h |    1 
 fs/xfs/xfs_trans.c |   17 +++-
 4 files changed, 103 insertions(+), 114 deletions(-)

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-12-11 12:36:10.395664344 -0800
+++ xfs/fs/xfs/xfs_log.c	2011-12-11 16:43:30.273088234 -0800
@@ -67,15 +67,10 @@ STATIC void xlog_state_switch_iclogs(xlo
 				     int		eventual_size);
 STATIC void xlog_state_want_sync(xlog_t	*log, xlog_in_core_t *iclog);
 
-/* local functions to manipulate grant head */
-STATIC int  xlog_grant_log_space(xlog_t		*log,
-				 xlog_ticket_t	*xtic);
 STATIC void xlog_grant_push_ail(struct log	*log,
 				int		need_bytes);
 STATIC void xlog_regrant_reserve_log_space(xlog_t	 *log,
 					   xlog_ticket_t *ticket);
-STATIC int xlog_regrant_write_log_space(xlog_t		*log,
-					 xlog_ticket_t  *ticket);
 STATIC void xlog_ungrant_log_space(xlog_t	 *log,
 				   xlog_ticket_t *ticket);
 
@@ -324,6 +319,128 @@ xlog_tic_add_region(xlog_ticket_t *tic,
 }
 
 /*
+ * Replenish the byte reservation required by moving the grant write head.
+ */
+int
+xfs_log_regrant(
+	struct xfs_mount	*mp,
+	struct xlog_ticket	*tic)
+{
+	struct log		*log = mp->m_log;
+	int			need_bytes;
+	int			error = 0;
+
+	if (XLOG_FORCED_SHUTDOWN(log))
+		return XFS_ERROR(EIO);
+
+	XFS_STATS_INC(xs_try_logspace);
+
+	/*
+	 * This is a new transaction on the ticket, so we need to change the
+	 * transaction ID so that the next transaction has a different TID in
+	 * the log. Just add one to the existing tid so that we can see chains
+	 * of rolling transactions in the log easily.
+	 */
+	tic->t_tid++;
+
+	xlog_grant_push_ail(log, tic->t_unit_res);
+
+	tic->t_curr_res = tic->t_unit_res;
+	xlog_tic_reset_res(tic);
+
+	if (tic->t_cnt > 0)
+		return 0;
+
+	trace_xfs_log_regrant(log, tic);
+
+	error = xlog_grant_head_check(log, &log->l_write_head, tic,
+				      &need_bytes);
+	if (error)
+		goto out_error;
+
+	xlog_grant_add_space(log, &log->l_write_head.grant, need_bytes);
+	trace_xfs_log_regrant_exit(log, tic);
+	xlog_verify_grant_tail(log);
+	return 0;
+
+out_error:
+	/*
+	 * If we are failing, make sure the ticket doesn't have any current
+	 * reservations.  We don't want to add this back when the ticket/
+	 * transaction gets cancelled.
+	 */
+	tic->t_curr_res = 0;
+	tic->t_cnt = 0;	/* ungrant will give back unit_res * t_cnt. */
+	return error;
+}
+
+/*
+ * Reserve log space and return a ticket corresponding the reservation.
+ *
+ * Each reservation is going to reserve extra space for a log record header.
+ * When writes happen to the on-disk log, we don't subtract the length of the
+ * log record header from any reservation.  By wasting space in each
+ * reservation, we prevent over allocation problems.
+ */
+int
+xfs_log_reserve(
+	struct xfs_mount	*mp,
+	int		 	unit_bytes,
+	int		 	cnt,
+	struct xlog_ticket	**ticp,
+	__uint8_t	 	client,
+	bool			permanent,
+	uint		 	t_type)
+{
+	struct log		*log = mp->m_log;
+	struct xlog_ticket	*tic;
+	int			need_bytes;
+	int			error = 0;
+
+	ASSERT(client == XFS_TRANSACTION || client == XFS_LOG);
+
+	if (XLOG_FORCED_SHUTDOWN(log))
+		return XFS_ERROR(EIO);
+
+	XFS_STATS_INC(xs_try_logspace);
+
+	ASSERT(*ticp == NULL);
+	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent,
+				KM_SLEEP | KM_MAYFAIL);
+	if (!tic)
+		return XFS_ERROR(ENOMEM);
+
+	tic->t_trans_type = t_type;
+	*ticp = tic;
+
+	xlog_grant_push_ail(log, tic->t_unit_res * tic->t_cnt);
+
+	trace_xfs_log_reserve(log, tic);
+
+	error = xlog_grant_head_check(log, &log->l_reserve_head, tic,
+				      &need_bytes);
+	if (error)
+		goto out_error;
+
+	xlog_grant_add_space(log, &log->l_reserve_head.grant, need_bytes);
+	xlog_grant_add_space(log, &log->l_write_head.grant, need_bytes);
+	trace_xfs_log_reserve_exit(log, tic);
+	xlog_verify_grant_tail(log);
+	return 0;
+
+out_error:
+	/*
+	 * If we are failing, make sure the ticket doesn't have any current
+	 * reservations.  We don't want to add this back when the ticket/
+	 * transaction gets cancelled.
+	 */
+	tic->t_curr_res = 0;
+	tic->t_cnt = 0;	/* ungrant will give back unit_res * t_cnt. */
+	return error;
+}
+
+
+/*
  * NOTES:
  *
  *	1. currblock field gets updated at startup and after in-core logs
@@ -433,88 +550,6 @@ xfs_log_release_iclog(
 }
 
 /*
- *  1. Reserve an amount of on-disk log space and return a ticket corresponding
- *	to the reservation.
- *  2. Potentially, push buffers at tail of log to disk.
- *
- * Each reservation is going to reserve extra space for a log record header.
- * When writes happen to the on-disk log, we don't subtract the length of the
- * log record header from any reservation.  By wasting space in each
- * reservation, we prevent over allocation problems.
- */
-int
-xfs_log_reserve(
-	struct xfs_mount	*mp,
-	int		 	unit_bytes,
-	int		 	cnt,
-	struct xlog_ticket	**ticket,
-	__uint8_t	 	client,
-	uint		 	flags,
-	uint		 	t_type)
-{
-	struct log		*log = mp->m_log;
-	struct xlog_ticket	*internal_ticket;
-	int			retval = 0;
-
-	ASSERT(client == XFS_TRANSACTION || client == XFS_LOG);
-
-	if (XLOG_FORCED_SHUTDOWN(log))
-		return XFS_ERROR(EIO);
-
-	XFS_STATS_INC(xs_try_logspace);
-
-
-	if (*ticket != NULL) {
-		ASSERT(flags & XFS_LOG_PERM_RESERV);
-		internal_ticket = *ticket;
-
-		/*
-		 * this is a new transaction on the ticket, so we need to
-		 * change the transaction ID so that the next transaction has a
-		 * different TID in the log. Just add one to the existing tid
-		 * so that we can see chains of rolling transactions in the log
-		 * easily.
-		 */
-		internal_ticket->t_tid++;
-
-		trace_xfs_log_reserve(log, internal_ticket);
-
-		xlog_grant_push_ail(log, internal_ticket->t_unit_res);
-		retval = xlog_regrant_write_log_space(log, internal_ticket);
-	} else {
-		/* may sleep if need to allocate more tickets */
-		internal_ticket = xlog_ticket_alloc(log, unit_bytes, cnt,
-						  client, flags,
-						  KM_SLEEP|KM_MAYFAIL);
-		if (!internal_ticket)
-			return XFS_ERROR(ENOMEM);
-		internal_ticket->t_trans_type = t_type;
-		*ticket = internal_ticket;
-
-		trace_xfs_log_reserve(log, internal_ticket);
-
-		xlog_grant_push_ail(log,
-				    (internal_ticket->t_unit_res *
-				     internal_ticket->t_cnt));
-		retval = xlog_grant_log_space(log, internal_ticket);
-	}
-
-	if (unlikely(retval)) {
-		/*
-		 * If we are failing, make sure the ticket doesn't have any
-		 * current reservations.  We don't want to add this back
-		 * when the ticket/ transaction gets cancelled.
-		 */
-		internal_ticket->t_curr_res = 0;
-		/* ungrant will give back unit_res * t_cnt. */
-		internal_ticket->t_cnt = 0;
-	}
-
-	return retval;
-}
-
-
-/*
  * Mount a log filesystem
  *
  * mp		- ubiquitous xfs mount point structure
@@ -2565,58 +2600,6 @@ restart:
 	return 0;
 }	/* xlog_state_get_iclog_space */
 
-STATIC int
-xlog_grant_log_space(
-	struct log		*log,
-	struct xlog_ticket	*tic)
-{
-	int			need_bytes;
-	int			error = 0;
-
-	trace_xfs_log_grant_enter(log, tic);
-
-	error = xlog_grant_head_check(log, &log->l_reserve_head, tic,
-				      &need_bytes);
-	if (error)
-		return error;
-
-	xlog_grant_add_space(log, &log->l_reserve_head.grant, need_bytes);
-	xlog_grant_add_space(log, &log->l_write_head.grant, need_bytes);
-	trace_xfs_log_grant_exit(log, tic);
-	xlog_verify_grant_tail(log);
-	return 0;
-}
-
-/*
- * Replenish the byte reservation required by moving the grant write head.
- */
-STATIC int
-xlog_regrant_write_log_space(
-	struct log		*log,
-	struct xlog_ticket	*tic)
-{
-	int			need_bytes;
-	int			error = 0;
-
-	tic->t_curr_res = tic->t_unit_res;
-	xlog_tic_reset_res(tic);
-
-	if (tic->t_cnt > 0)
-		return 0;
-
-	trace_xfs_log_regrant_write_enter(log, tic);
-
-	error = xlog_grant_head_check(log, &log->l_write_head, tic,
-				      &need_bytes);
-	if (error)
-		return error;
-
-	xlog_grant_add_space(log, &log->l_write_head.grant, need_bytes);
-	trace_xfs_log_regrant_write_exit(log, tic);
-	xlog_verify_grant_tail(log);
-	return 0;
-}
-
 /* The first cnt-1 times through here we don't need to
  * move the grant write head because the permanent
  * reservation has reserved cnt times the unit amount.
@@ -3156,7 +3139,7 @@ xlog_ticket_alloc(
 	int		unit_bytes,
 	int		cnt,
 	char		client,
-	uint		xflags,
+	bool		permanent,
 	int		alloc_flags)
 {
 	struct xlog_ticket *tic;
@@ -3260,7 +3243,7 @@ xlog_ticket_alloc(
 	tic->t_clientid		= client;
 	tic->t_flags		= XLOG_TIC_INITED;
 	tic->t_trans_type	= 0;
-	if (xflags & XFS_LOG_PERM_RESERV)
+	if (permanent)
 		tic->t_flags |= XLOG_TIC_PERM_RESERV;
 
 	xlog_tic_reset_res(tic);
Index: xfs/fs/xfs/xfs_log.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log.h	2011-12-11 12:24:34.000000000 -0800
+++ xfs/fs/xfs/xfs_log.h	2011-12-11 16:42:12.056845301 -0800
@@ -53,15 +53,6 @@ static inline xfs_lsn_t	_lsn_cmp(xfs_lsn
 #define XFS_LOG_REL_PERM_RESERV	0x1
 
 /*
- * Flags to xfs_log_reserve()
- *
- *	XFS_LOG_PERM_RESERV: Permanent reservation.  When writes are
- *		performed against this type of reservation, the reservation
- *		is not decreased.  Long running transactions should use this.
- */
-#define XFS_LOG_PERM_RESERV	0x2
-
-/*
  * Flags to xfs_log_force()
  *
  *	XFS_LOG_SYNC:	Synchronous force in-core log to disk
@@ -172,8 +163,9 @@ int	  xfs_log_reserve(struct xfs_mount *
 			  int		   count,
 			  struct xlog_ticket **ticket,
 			  __uint8_t	   clientid,
-			  uint		   flags,
+			  bool		   permanent,
 			  uint		   t_type);
+int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
 int	  xfs_log_unmount_write(struct xfs_mount *mp);
 void      xfs_log_unmount(struct xfs_mount *mp);
 int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
Index: xfs/fs/xfs/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trace.h	2011-12-11 12:32:42.000000000 -0800
+++ xfs/fs/xfs/xfs_trace.h	2011-12-11 16:14:57.932364781 -0800
@@ -827,17 +827,14 @@ DEFINE_EVENT(xfs_loggrant_class, name, \
 	TP_ARGS(log, tic))
 DEFINE_LOGGRANT_EVENT(xfs_log_done_nonperm);
 DEFINE_LOGGRANT_EVENT(xfs_log_done_perm);
-DEFINE_LOGGRANT_EVENT(xfs_log_reserve);
 DEFINE_LOGGRANT_EVENT(xfs_log_umount_write);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_enter);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_exit);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_error);
 DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep);
 DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake);
 DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake_up);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_enter);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_exit);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_error);
+DEFINE_LOGGRANT_EVENT(xfs_log_reserve);
+DEFINE_LOGGRANT_EVENT(xfs_log_reserve_exit);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_sub);
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2011-12-11 12:24:34.000000000 -0800
+++ xfs/fs/xfs/xfs_trans.c	2011-12-11 16:43:16.753161478 -0800
@@ -681,7 +681,6 @@ xfs_trans_reserve(
 	uint		flags,
 	uint		logcount)
 {
-	int		log_flags;
 	int		error = 0;
 	int		rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
 
@@ -707,24 +706,32 @@ xfs_trans_reserve(
 	 * Reserve the log space needed for this transaction.
 	 */
 	if (logspace > 0) {
-		ASSERT((tp->t_log_res == 0) || (tp->t_log_res == logspace));
-		ASSERT((tp->t_log_count == 0) ||
-			(tp->t_log_count == logcount));
+		bool	permanent = false;
+
+		ASSERT(tp->t_log_res == 0 || tp->t_log_res == logspace);
+		ASSERT(tp->t_log_count == 0 || tp->t_log_count == logcount);
+
 		if (flags & XFS_TRANS_PERM_LOG_RES) {
-			log_flags = XFS_LOG_PERM_RESERV;
 			tp->t_flags |= XFS_TRANS_PERM_LOG_RES;
+			permanent = true;
 		} else {
 			ASSERT(tp->t_ticket == NULL);
 			ASSERT(!(tp->t_flags & XFS_TRANS_PERM_LOG_RES));
-			log_flags = 0;
 		}
 
-		error = xfs_log_reserve(tp->t_mountp, logspace, logcount,
-					&tp->t_ticket,
-					XFS_TRANSACTION, log_flags, tp->t_type);
-		if (error) {
-			goto undo_blocks;
+		if (tp->t_ticket != NULL) {
+			ASSERT(flags & XFS_TRANS_PERM_LOG_RES);
+			error = xfs_log_regrant(tp->t_mountp, tp->t_ticket);
+		} else {
+			error = xfs_log_reserve(tp->t_mountp, logspace,
+						logcount, &tp->t_ticket,
+						XFS_TRANSACTION, permanent,
+						tp->t_type);
 		}
+
+		if (error)
+			goto undo_blocks;
+
 		tp->t_log_res = logspace;
 		tp->t_log_count = logcount;
 	}
@@ -752,6 +759,8 @@ xfs_trans_reserve(
 	 */
 undo_log:
 	if (logspace > 0) {
+		int		log_flags;
+
 		if (flags & XFS_TRANS_PERM_LOG_RES) {
 			log_flags = XFS_LOG_REL_PERM_RESERV;
 		} else {
Index: xfs/fs/xfs/xfs_log_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log_priv.h	2011-12-11 15:53:25.556032850 -0800
+++ xfs/fs/xfs/xfs_log_priv.h	2011-12-11 16:43:47.969659031 -0800
@@ -552,7 +552,7 @@ extern void	 xlog_pack_data(xlog_t *log,
 
 extern kmem_zone_t *xfs_log_ticket_zone;
 struct xlog_ticket *xlog_ticket_alloc(struct log *log, int unit_bytes,
-				int count, char client, uint xflags,
+				int count, char client, bool permanent,
 				int alloc_flags);
 
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
