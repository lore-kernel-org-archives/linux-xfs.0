Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Oct 2008 18:16:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9V1FYQH001255
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 18:15:34 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 10711562F66
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 18:15:33 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id HwmLHi9pWankgWJr for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 18:15:33 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1Kvibp-0007qJ-8G
	for xfs@oss.sgi.com; Fri, 31 Oct 2008 12:15:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/5] XFS: Fix double free of log tickets
Date: Fri, 31 Oct 2008 12:15:26 +1100
Message-Id: <1225415729-26514-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1225415729-26514-1-git-send-email-david@fromorbit.com>
References: <1225415729-26514-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

When an I/O error occurs during an intermediate commit on a rolling
transaction, xfs_trans_commit() will free the transaction structure
and the related ticket. However, the duplicate transaction that
gets used as the transaction continues still contains a pointer
to the ticket. Hence when the duplicate transaction is cancelled
and freed, we free the ticket a second time.

Add reference counting to the ticket so that we hold an extra
reference to the ticket over the transaction commit. We drop the
extra reference once we have checked that the transaction commit
did not return an error, thus avoiding a double free on commit
error.

Credit to Nick Piggin for tripping over the problem.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_bmap.c     |   10 ++++++++--
 fs/xfs/xfs_inode.c    |   10 ++++++++--
 fs/xfs/xfs_log.c      |   39 +++++++++++++++++++++++++--------------
 fs/xfs/xfs_log.h      |    4 ++++
 fs/xfs/xfs_log_priv.h |    1 +
 fs/xfs/xfs_trans.c    |    9 ++++++++-
 fs/xfs/xfs_utils.c    |    6 ++++++
 fs/xfs/xfs_vnodeops.c |    6 ++++++
 8 files changed, 66 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index db28905..c391221 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -4292,9 +4292,15 @@ xfs_bmap_finish(
 	 * We have a new transaction, so we should return committed=1,
 	 * even though we're returning an error.
 	 */
-	if (error) {
+	if (error)
 		return error;
-	}
+
+	/*
+	 * transaction commit worked ok so we can drop the extra ticket
+	 * reference that we gained in xfs_trans_dup()
+	 */
+	xfs_log_ticket_put(ntp->t_ticket);
+
 	if ((error = xfs_trans_reserve(ntp, 0, logres, 0, XFS_TRANS_PERM_LOG_RES,
 			logcount)))
 		return error;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index cd52282..b977100 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1782,8 +1782,14 @@ xfs_itruncate_finish(
 		xfs_trans_ijoin(ntp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 		xfs_trans_ihold(ntp, ip);
 
-		if (!error)
-			error = xfs_trans_reserve(ntp, 0,
+		if (error)
+			return error;
+		/*
+		 * transaction commit worked ok so we can drop the extra ticket
+		 * reference that we gained in xfs_trans_dup()
+		 */
+		xfs_log_ticket_put(ntp->t_ticket);
+		error = xfs_trans_reserve(ntp, 0,
 					XFS_ITRUNCATE_LOG_RES(mp), 0,
 					XFS_TRANS_PERM_LOG_RES,
 					XFS_ITRUNCATE_LOG_COUNT);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index cc1e789..9aecefd 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -100,12 +100,11 @@ STATIC void xlog_ungrant_log_space(xlog_t	 *log,
 
 
 /* local ticket functions */
-STATIC xlog_ticket_t	*xlog_ticket_get(xlog_t *log,
+STATIC xlog_ticket_t	*xlog_ticket_alloc(xlog_t *log,
 					 int	unit_bytes,
 					 int	count,
 					 char	clientid,
 					 uint	flags);
-STATIC void		xlog_ticket_put(xlog_t *log, xlog_ticket_t *ticket);
 
 #if defined(DEBUG)
 STATIC void	xlog_verify_dest_ptr(xlog_t *log, __psint_t ptr);
@@ -360,7 +359,7 @@ xfs_log_done(xfs_mount_t	*mp,
 		 */
 		xlog_trace_loggrant(log, ticket, "xfs_log_done: (non-permanent)");
 		xlog_ungrant_log_space(log, ticket);
-		xlog_ticket_put(log, ticket);
+		xfs_log_ticket_put(ticket);
 	} else {
 		xlog_trace_loggrant(log, ticket, "xfs_log_done: (permanent)");
 		xlog_regrant_reserve_log_space(log, ticket);
@@ -514,7 +513,7 @@ xfs_log_reserve(xfs_mount_t	 *mp,
 		retval = xlog_regrant_write_log_space(log, internal_ticket);
 	} else {
 		/* may sleep if need to allocate more tickets */
-		internal_ticket = xlog_ticket_get(log, unit_bytes, cnt,
+		internal_ticket = xlog_ticket_alloc(log, unit_bytes, cnt,
 						  client, flags);
 		if (!internal_ticket)
 			return XFS_ERROR(ENOMEM);
@@ -749,7 +748,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 		if (tic) {
 			xlog_trace_loggrant(log, tic, "unmount rec");
 			xlog_ungrant_log_space(log, tic);
-			xlog_ticket_put(log, tic);
+			xfs_log_ticket_put(tic);
 		}
 	} else {
 		/*
@@ -3223,22 +3222,33 @@ xlog_state_want_sync(xlog_t *log, xlog_in_core_t *iclog)
  */
 
 /*
- * Free a used ticket.
+ * Free a used ticket when it's refcount falls to zero.
  */
-STATIC void
-xlog_ticket_put(xlog_t		*log,
-		xlog_ticket_t	*ticket)
+void
+xfs_log_ticket_put(
+	xlog_ticket_t	*ticket)
 {
-	sv_destroy(&ticket->t_wait);
-	kmem_zone_free(xfs_log_ticket_zone, ticket);
-}	/* xlog_ticket_put */
+	ASSERT(atomic_read(&ticket->t_ref) > 0);
+	if (atomic_dec_and_test(&ticket->t_ref)) {
+		sv_destroy(&ticket->t_wait);
+		kmem_zone_free(xfs_log_ticket_zone, ticket);
+	}
+}
 
+xlog_ticket_t *
+xfs_log_ticket_get(
+	xlog_ticket_t	*ticket)
+{
+	ASSERT(atomic_read(&ticket->t_ref) > 0);
+	atomic_inc(&ticket->t_ref);
+	return ticket;
+}
 
 /*
  * Allocate and initialise a new log ticket.
  */
 STATIC xlog_ticket_t *
-xlog_ticket_get(xlog_t		*log,
+xlog_ticket_alloc(xlog_t		*log,
 		int		unit_bytes,
 		int		cnt,
 		char		client,
@@ -3309,6 +3319,7 @@ xlog_ticket_get(xlog_t		*log,
 		unit_bytes += 2*BBSIZE;
         }
 
+	atomic_set(&tic->t_ref, 1);
 	tic->t_unit_res		= unit_bytes;
 	tic->t_curr_res		= unit_bytes;
 	tic->t_cnt		= cnt;
@@ -3324,7 +3335,7 @@ xlog_ticket_get(xlog_t		*log,
 	xlog_tic_reset_res(tic);
 
 	return tic;
-}	/* xlog_ticket_get */
+}
 
 
 /******************************************************************************
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index d47b91f..8a3e84e 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -134,6 +134,7 @@ typedef struct xfs_log_callback {
 #ifdef __KERNEL__
 /* Log manager interfaces */
 struct xfs_mount;
+struct xlog_ticket;
 xfs_lsn_t xfs_log_done(struct xfs_mount *mp,
 		       xfs_log_ticket_t ticket,
 		       void		**iclog,
@@ -177,6 +178,9 @@ int	  xfs_log_need_covered(struct xfs_mount *mp);
 
 void	  xlog_iodone(struct xfs_buf *);
 
+struct xlog_ticket * xfs_log_ticket_get(struct xlog_ticket *ticket);
+void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
+
 #endif
 
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index de7ef6c..b39a198 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -245,6 +245,7 @@ typedef struct xlog_ticket {
 	struct xlog_ticket *t_next;	 /*			         :4|8 */
 	struct xlog_ticket *t_prev;	 /*				 :4|8 */
 	xlog_tid_t	   t_tid;	 /* transaction identifier	 : 4  */
+	atomic_t	   t_ref;	 /* ticket reference count       : 4  */
 	int		   t_curr_res;	 /* current reservation in bytes : 4  */
 	int		   t_unit_res;	 /* unit reservation in bytes    : 4  */
 	char		   t_ocnt;	 /* original count		 : 1  */
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index ad137ef..8570b82 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -290,7 +290,7 @@ xfs_trans_dup(
 	ASSERT(tp->t_ticket != NULL);
 
 	ntp->t_flags = XFS_TRANS_PERM_LOG_RES | (tp->t_flags & XFS_TRANS_RESERVE);
-	ntp->t_ticket = tp->t_ticket;
+	ntp->t_ticket = xfs_log_ticket_get(tp->t_ticket);
 	ntp->t_blk_res = tp->t_blk_res - tp->t_blk_res_used;
 	tp->t_blk_res = tp->t_blk_res_used;
 	ntp->t_rtx_res = tp->t_rtx_res - tp->t_rtx_res_used;
@@ -1260,6 +1260,13 @@ xfs_trans_roll(
 	trans = *tpp;
 
 	/*
+	 * transaction commit worked ok so we can drop the extra ticket
+	 * reference that we gained in xfs_trans_dup()
+	 */
+	xfs_log_ticket_put(trans->t_ticket);
+
+
+	/*
 	 * Reserve space in the log for th next transaction.
 	 * This also pushes items in the "AIL", the list of logged items,
 	 * out to disk if they are taking up space at the tail of the log
diff --git a/fs/xfs/xfs_utils.c b/fs/xfs/xfs_utils.c
index 35d4d41..7711449 100644
--- a/fs/xfs/xfs_utils.c
+++ b/fs/xfs/xfs_utils.c
@@ -172,6 +172,12 @@ xfs_dir_ialloc(
 			*ipp = NULL;
 			return code;
 		}
+
+		/*
+		 * transaction commit worked ok so we can drop the extra ticket
+		 * reference that we gained in xfs_trans_dup()
+		 */
+		xfs_log_ticket_put(tp->t_ticket);
 		code = xfs_trans_reserve(tp, 0, log_res, 0,
 					 XFS_TRANS_PERM_LOG_RES, log_count);
 		/*
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 5809c42..f7eea70 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1029,6 +1029,12 @@ xfs_inactive_symlink_rmt(
 		goto error0;
 	}
 	/*
+	 * transaction commit worked ok so we can drop the extra ticket
+	 * reference that we gained in xfs_trans_dup()
+	 */
+	xfs_log_ticket_put(tp->t_ticket);
+
+	/*
 	 * Remove the memory for extent descriptions (just bookkeeping).
 	 */
 	if (ip->i_df.if_bytes)
-- 
1.5.6.5
