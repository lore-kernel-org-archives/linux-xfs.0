Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o261oNr8041873 for <xfs@oss.sgi.com>; Fri, 5 Mar 2010 19:50:23 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 524ED1D1A7F3
	for <xfs@oss.sgi.com>; Fri,  5 Mar 2010 17:51:51 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	AGpVeTnglABv51s6 for <xfs@oss.sgi.com>;
	Fri, 05 Mar 2010 17:51:51 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	16043133-1927428
	for <xfs@oss.sgi.com>; Sat, 06 Mar 2010 12:21:50 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NnjBD-0007SC-V2
	for xfs@oss.sgi.com; Sat, 06 Mar 2010 12:51:47 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NnjAv-0001Ee-Eo
	for xfs@oss.sgi.com; Sat, 06 Mar 2010 12:51:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/9] xfs: introduce new internal log vector structure
Date: Sat,  6 Mar 2010 12:51:23 +1100
Message-Id: <1267840284-4652-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1267840284-4652-1-git-send-email-david@fromorbit.com>
References: <1267840284-4652-1-git-send-email-david@fromorbit.com>
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

The current log IO vector structure is a flat array and not
extensible. To make it possible to keep separate log IO vectors for
individual log items, we need a method of chaining log IO vectors
together.

Introduce a new log vector type that can be used to wrap the
existing log IO vectors on use that internally to the log. This
means that the existing external interface (xfs_log_write) does not
change and hence no changes to the transaction commit code are
required.

This initial use of the new log vectors does not use the chaining
capability of the new log vector structure - it is not needed to
implement the flat vector array the current transaction commit path
creates.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c |  106 +++++++++++++++++++++++++++++++-----------------------
 fs/xfs/xfs_log.h |    6 +++
 2 files changed, 67 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7c6b0cd..afb27cf 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -50,7 +50,7 @@ kmem_zone_t	*xfs_log_ticket_zone;
 	  (off) += (bytes);}
 
 /* Local miscellaneous function prototypes */
-STATIC int	 xlog_commit_record(xfs_mount_t *mp, xlog_ticket_t *ticket,
+STATIC int	 xlog_commit_record(struct log *log, struct xlog_ticket *ticket,
 				    xlog_in_core_t **, xfs_lsn_t *);
 STATIC xlog_t *  xlog_alloc_log(xfs_mount_t	*mp,
 				xfs_buftarg_t	*log_target,
@@ -59,11 +59,9 @@ STATIC xlog_t *  xlog_alloc_log(xfs_mount_t	*mp,
 STATIC int	 xlog_space_left(xlog_t *log, int cycle, int bytes);
 STATIC int	 xlog_sync(xlog_t *log, xlog_in_core_t *iclog);
 STATIC void	 xlog_dealloc_log(xlog_t *log);
-STATIC int	 xlog_write(xfs_mount_t *mp, xfs_log_iovec_t region[],
-			    int nentries, struct xlog_ticket *tic,
-			    xfs_lsn_t *start_lsn,
-			    xlog_in_core_t **commit_iclog,
-			    uint flags);
+STATIC int	 xlog_write(struct log *log, struct xfs_log_vec *log_vector,
+			    struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
+			    xlog_in_core_t **commit_iclog, uint flags);
 
 /* local state machine functions */
 STATIC void xlog_state_done_syncing(xlog_in_core_t *iclog, int);
@@ -258,7 +256,7 @@ xfs_log_done(
 	     * If we get an error, just continue and give back the log ticket.
 	     */
 	    (((ticket->t_flags & XLOG_TIC_INITED) == 0) &&
-	     (xlog_commit_record(mp, ticket, iclog, &lsn)))) {
+	     (xlog_commit_record(log, ticket, iclog, &lsn)))) {
 		lsn = (xfs_lsn_t) -1;
 		if (ticket->t_flags & XLOG_TIC_PERM_RESERV) {
 			flags |= XFS_LOG_REL_PERM_RESERV;
@@ -516,18 +514,10 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 #ifdef DEBUG
 	xlog_in_core_t	 *first_iclog;
 #endif
-	xfs_log_iovec_t  reg[1];
 	xlog_ticket_t	*tic = NULL;
 	xfs_lsn_t	 lsn;
 	int		 error;
 
-	/* the data section must be 32 bit size aligned */
-	struct {
-	    __uint16_t magic;
-	    __uint16_t pad1;
-	    __uint32_t pad2; /* may as well make it 64 bits */
-	} magic = { XLOG_UNMOUNT_TYPE, 0, 0 };
-
 	/*
 	 * Don't write out unmount record on read-only mounts.
 	 * Or, if we are doing a forced umount (typically because of IO errors).
@@ -549,16 +539,31 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 	} while (iclog != first_iclog);
 #endif
 	if (! (XLOG_FORCED_SHUTDOWN(log))) {
-		reg[0].i_addr = (void*)&magic;
-		reg[0].i_len  = sizeof(magic);
-		reg[0].i_type = XLOG_REG_TYPE_UNMOUNT;
-
 		error = xfs_log_reserve(mp, 600, 1, &tic,
 					XFS_LOG, 0, XLOG_UNMOUNT_REC_TYPE);
 		if (!error) {
+			/* the data section must be 32 bit size aligned */
+			struct {
+			    __uint16_t magic;
+			    __uint16_t pad1;
+			    __uint32_t pad2; /* may as well make it 64 bits */
+			} magic = {
+				.magic = XLOG_UNMOUNT_TYPE,
+			};
+			struct xfs_log_iovec reg = {
+				.i_addr = (void *)&magic,
+				.i_len = sizeof(magic),
+				.i_type = XLOG_REG_TYPE_UNMOUNT,
+			};
+			struct xfs_log_vec vec = {
+				.lv_niovecs = 1,
+			};
+			/* sigh. c99 initialisers don't work on anon unions */
+			vec.lv_iovecp = &reg;
+
 			/* remove inited flag */
-			((xlog_ticket_t *)tic)->t_flags = 0;
-			error = xlog_write(mp, reg, 1, tic, &lsn,
+			tic->t_flags = 0;
+			error = xlog_write(log, &vec, tic, &lsn,
 					   NULL, XLOG_UNMOUNT_TRANS);
 			/*
 			 * At this point, we're umounting anyway,
@@ -679,11 +684,16 @@ xfs_log_write(
 {
 	struct log		*log = mp->m_log;
 	int			error;
+	struct xfs_log_vec	vec = {
+		.lv_niovecs = nentries,
+	};
+	/* sigh. c99 initialisers don't work on anon unions */
+	vec.lv_iovecp = reg;
 
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return XFS_ERROR(EIO);
 
-	error = xlog_write(mp, reg, nentries, tic, start_lsn, NULL, 0);
+	error = xlog_write(log, &vec, tic, start_lsn, NULL, 0);
 	if (error)
 		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
 	return error;
@@ -1176,26 +1186,32 @@ out:
  * ticket.  Return the lsn of the commit record.
  */
 STATIC int
-xlog_commit_record(xfs_mount_t  *mp,
-		   xlog_ticket_t *ticket,
-		   xlog_in_core_t **iclog,
-		   xfs_lsn_t	*commitlsnp)
+xlog_commit_record(
+	struct log		*log,
+	struct xlog_ticket	*ticket,
+	struct xlog_in_core	**iclog,
+	xfs_lsn_t		*commitlsnp)
 {
-	int		error;
-	xfs_log_iovec_t	reg[1];
-
-	reg[0].i_addr = NULL;
-	reg[0].i_len = 0;
-	reg[0].i_type = XLOG_REG_TYPE_COMMIT;
+	struct xfs_mount *mp = log->l_mp;
+	int	error;
+	struct xfs_log_iovec reg = {
+		.i_addr = NULL,
+		.i_len = 0,
+		.i_type = XLOG_REG_TYPE_COMMIT,
+	};
+	struct xfs_log_vec vec = {
+		.lv_niovecs = 1,
+	};
+	/* sigh. c99 initialisers don't work on anon unions */
+	vec.lv_iovecp = &reg;
 
 	ASSERT_ALWAYS(iclog);
-	if ((error = xlog_write(mp, reg, 1, ticket, commitlsnp,
-			       iclog, XLOG_COMMIT_TRANS))) {
+	error = xlog_write(log, &vec, ticket, commitlsnp, iclog,
+					XLOG_COMMIT_TRANS);
+	if (error)
 		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
-	}
 	return error;
-}	/* xlog_commit_record */
-
+}
 
 /*
  * Push on the buffer cache code if we ever use more than 75% of the on-disk
@@ -1657,15 +1673,13 @@ xlog_print_tic_res(xfs_mount_t *mp, xlog_ticket_t *ticket)
  */
 STATIC int
 xlog_write(
-	struct xfs_mount	*mp,
-	struct xfs_log_iovec	reg[],
-	int			nentries,
+	struct log		*log,
+	struct xfs_log_vec	*log_vector,
 	struct xlog_ticket	*ticket,
 	xfs_lsn_t		*start_lsn,
 	struct xlog_in_core	**commit_iclog,
 	uint			flags)
 {
-    xlog_t	     *log = mp->m_log;
     xlog_in_core_t   *iclog = NULL;  /* ptr to current in-core log */
     xlog_op_header_t *logop_head;    /* ptr to log operation header */
     __psint_t	     ptr;	     /* copy address into data region */
@@ -1681,6 +1695,8 @@ xlog_write(
     int		     contwr;	     /* continued write of in-core log? */
     int		     error;
     int		     record_cnt = 0, data_cnt = 0;
+    struct xfs_log_iovec *reg = log_vector->lv_iovecp;
+    int		     nentries = log_vector->lv_niovecs;
 
     partial_copy_len = partial_copy = 0;
 
@@ -1702,16 +1718,16 @@ xlog_write(
     contwr = *start_lsn = 0;
 
     if (ticket->t_curr_res < len) {
-	xlog_print_tic_res(mp, ticket);
+	xlog_print_tic_res(log->l_mp, ticket);
 #ifdef DEBUG
 	xlog_panic(
 		"xfs_log_write: reservation ran out. Need to up reservation");
 #else
 	/* Customer configurable panic */
-	xfs_cmn_err(XFS_PTAG_LOGRES, CE_ALERT, mp,
+	xfs_cmn_err(XFS_PTAG_LOGRES, CE_ALERT, log->l_mp,
 		"xfs_log_write: reservation ran out. Need to up reservation");
 	/* If we did not panic, shutdown the filesystem */
-	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	xfs_force_shutdown(log->l_mp, SHUTDOWN_CORRUPT_INCORE);
 #endif
     } else
 	ticket->t_curr_res -= len;
@@ -1777,7 +1793,7 @@ xlog_write(
 	    case XFS_LOG:
 		break;
 	    default:
-		xfs_fs_cmn_err(CE_WARN, mp,
+		xfs_fs_cmn_err(CE_WARN, log->l_mp,
 		    "Bad XFS transaction clientid 0x%x in ticket 0x%p",
 		    logop_head->oh_clientid, ticket);
 		return XFS_ERROR(EIO);
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index f3a564d..229d1f3 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -110,6 +110,12 @@ typedef struct xfs_log_iovec {
 	uint		i_type;		/* type of region */
 } xfs_log_iovec_t;
 
+struct xfs_log_vec {
+	struct xfs_log_vec	*lv_next;	/* next lv in build list */
+	int			lv_niovecs;	/* number of iovecs in lv */
+	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
+};
+
 /*
  * Structure used to pass callback function and the function's argument
  * to the log manager.
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
