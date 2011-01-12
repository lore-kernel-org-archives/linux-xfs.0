Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0C0Y8ea123998 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 18:34:09 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1987F1D2641A
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 16:36:18 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	UMgQTqhUWuHB2IX5 for <xfs@oss.sgi.com>;
	Tue, 11 Jan 2011 16:36:18 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	52533577-1927428
	for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 11:06:16 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PcohC-0000UT-6A
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:36:14 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Pcogu-0002G9-NR
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:35:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/12] xfs: Convert xlog_warn to new logging interface
Date: Wed, 12 Jan 2011 11:35:45 +1100
Message-Id: <1294792553-8378-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1294792553-8378-1-git-send-email-david@fromorbit.com>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
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

Convert the xfs log operations to use the new error logging
interfaces. This removes the xlog_{warn,panic} wrappers and makes
almost all errors emit the device they belong to instead of just
refering to "XFS".

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/quota/xfs_dquot.c |   10 ++-
 fs/xfs/quota/xfs_qm.c    |    2 +-
 fs/xfs/xfs_log.c         |  124 ++++++++++++-------------
 fs/xfs/xfs_log_priv.h    |    4 -
 fs/xfs/xfs_log_recover.c |  223 ++++++++++++++++++++++-----------------------
 fs/xfs/xfs_quota.h       |    3 +-
 6 files changed, 177 insertions(+), 189 deletions(-)

diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index d22aa31..773adc8 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -544,9 +544,10 @@ xfs_qm_dqtobp(
 	/*
 	 * A simple sanity check in case we got a corrupted dquot...
 	 */
-	if (xfs_qm_dqcheck(ddq, id, dqp->dq_flags & XFS_DQ_ALLTYPES,
+	error = xfs_qm_dqcheck(mp, ddq, id, dqp->dq_flags & XFS_DQ_ALLTYPES,
 			   flags & (XFS_QMOPT_DQREPAIR|XFS_QMOPT_DOWARN),
-			   "dqtobp")) {
+			   "dqtobp");
+	if (error) {
 		if (!(flags & XFS_QMOPT_DQREPAIR)) {
 			xfs_trans_brelse(tp, bp);
 			return XFS_ERROR(EIO);
@@ -1207,8 +1208,9 @@ xfs_qm_dqflush(
 	/*
 	 * A simple sanity check in case we got a corrupted dquot..
 	 */
-	if (xfs_qm_dqcheck(&dqp->q_core, be32_to_cpu(ddqp->d_id), 0,
-			   XFS_QMOPT_DOWARN, "dqflush (incore copy)")) {
+	error = xfs_qm_dqcheck(mp, &dqp->q_core, be32_to_cpu(ddqp->d_id), 0,
+			   XFS_QMOPT_DOWARN, "dqflush (incore copy)");
+	if (error) {
 		xfs_buf_relse(bp);
 		xfs_dqfunlock(dqp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index f8e854b..d87c4a3 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -1299,7 +1299,7 @@ xfs_qm_reset_dqcounts(
 		 * output any warnings because it's perfectly possible to
 		 * find uninitialised dquot blks. See comment in xfs_qm_dqcheck.
 		 */
-		(void) xfs_qm_dqcheck(ddq, id+j, type, XFS_QMOPT_DQREPAIR,
+		(void) xfs_qm_dqcheck(mp, ddq, id+j, type, XFS_QMOPT_DQREPAIR,
 				      "xfs_quotacheck");
 		ddq->d_bcount = 0;
 		ddq->d_icount = 0;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ae6fef1..d645f09 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -374,11 +374,10 @@ xfs_log_mount(
 	int		error;
 
 	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY))
-		cmn_err(CE_NOTE, "XFS mounting filesystem %s", mp->m_fsname);
+		xfs_notice(mp, "Mounting Filesystem");
 	else {
-		cmn_err(CE_NOTE,
-			"Mounting filesystem \"%s\" in no-recovery mode.  Filesystem will be inconsistent.",
-			mp->m_fsname);
+		xfs_notice(mp,
+"Mounting filesystem in no-recovery mode.  Filesystem will be inconsistent.");
 		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
 	}
 
@@ -393,7 +392,7 @@ xfs_log_mount(
 	 */
 	error = xfs_trans_ail_init(mp);
 	if (error) {
-		cmn_err(CE_WARN, "XFS: AIL initialisation failed: error %d", error);
+		xfs_warn(mp, "AIL initialisation failed: error %d", error);
 		goto out_free_log;
 	}
 	mp->m_log->l_ailp = mp->m_ail;
@@ -413,7 +412,8 @@ xfs_log_mount(
 		if (readonly)
 			mp->m_flags |= XFS_MOUNT_RDONLY;
 		if (error) {
-			cmn_err(CE_WARN, "XFS: log mount/recovery failed: error %d", error);
+			xfs_warn(mp, "log mount/recovery failed: error %d",
+				error);
 			goto out_destroy_ail;
 		}
 	}
@@ -542,10 +542,8 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 			 */
 		}
 
-		if (error) {
-			xfs_fs_cmn_err(CE_ALERT, mp,
-				"xfs_log_unmount: unmount record failed");
-		}
+		if (error)
+			xfs_alert(mp, "%s: unmount record failed", __func__);
 
 
 		spin_lock(&log->l_icloglock);
@@ -852,7 +850,7 @@ xlog_space_left(
 		 * In this case we just want to return the size of the
 		 * log as the amount of space left.
 		 */
-		xfs_fs_cmn_err(CE_ALERT, log->l_mp,
+		xfs_alert(log->l_mp,
 			"xlog_space_left: head behind tail\n"
 			"  tail_cycle = %d, tail_bytes = %d\n"
 			"  GH   cycle = %d, GH   bytes = %d",
@@ -1001,7 +999,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 
 	log = kmem_zalloc(sizeof(xlog_t), KM_MAYFAIL);
 	if (!log) {
-		xlog_warn("XFS: Log allocation failed: No memory!");
+		xfs_warn(mp, "Log allocation failed: No memory!");
 		goto out;
 	}
 
@@ -1029,24 +1027,24 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	if (xfs_sb_version_hassector(&mp->m_sb)) {
 	        log2_size = mp->m_sb.sb_logsectlog;
 		if (log2_size < BBSHIFT) {
-			xlog_warn("XFS: Log sector size too small "
-				"(0x%x < 0x%x)", log2_size, BBSHIFT);
+			xfs_warn(mp, "Log sector size too small (0x%x < 0x%x)",
+				log2_size, BBSHIFT);
 			goto out_free_log;
 		}
 
 	        log2_size -= BBSHIFT;
 		if (log2_size > mp->m_sectbb_log) {
-			xlog_warn("XFS: Log sector size too large "
-				"(0x%x > 0x%x)", log2_size, mp->m_sectbb_log);
+			xfs_warn(mp, "Log sector size too large (0x%x > 0x%x)",
+				log2_size, mp->m_sectbb_log);
 			goto out_free_log;
 		}
 
 		/* for larger sector sizes, must have v2 or external log */
 		if (log2_size && log->l_logBBstart > 0 &&
 			    !xfs_sb_version_haslogv2(&mp->m_sb)) {
-
-			xlog_warn("XFS: log sector size (0x%x) invalid "
-				  "for configuration.", log2_size);
+			xfs_warn(mp,
+		"log sector size (0x%x) invalid for configuration.",
+				log2_size);
 			goto out_free_log;
 		}
 	}
@@ -1563,38 +1561,36 @@ xlog_print_tic_res(
 	    "SWAPEXT"
 	};
 
-	xfs_fs_cmn_err(CE_WARN, mp,
-			"xfs_log_write: reservation summary:\n"
-			"  trans type  = %s (%u)\n"
-			"  unit res    = %d bytes\n"
-			"  current res = %d bytes\n"
-			"  total reg   = %u bytes (o/flow = %u bytes)\n"
-			"  ophdrs      = %u (ophdr space = %u bytes)\n"
-			"  ophdr + reg = %u bytes\n"
-			"  num regions = %u\n",
-			((ticket->t_trans_type <= 0 ||
-			  ticket->t_trans_type > XFS_TRANS_TYPE_MAX) ?
-			  "bad-trans-type" : trans_type_str[ticket->t_trans_type-1]),
-			ticket->t_trans_type,
-			ticket->t_unit_res,
-			ticket->t_curr_res,
-			ticket->t_res_arr_sum, ticket->t_res_o_flow,
-			ticket->t_res_num_ophdrs, ophdr_spc,
-			ticket->t_res_arr_sum + 
-			ticket->t_res_o_flow + ophdr_spc,
-			ticket->t_res_num);
+	xfs_alert(mp,
+		"xfs_log_write: reservation summary:\n"
+		"  trans type  = %s (%u)\n"
+		"  unit res    = %d bytes\n"
+		"  current res = %d bytes\n"
+		"  total reg   = %u bytes (o/flow = %u bytes)\n"
+		"  ophdrs      = %u (ophdr space = %u bytes)\n"
+		"  ophdr + reg = %u bytes\n"
+		"  num regions = %u\n",
+		((ticket->t_trans_type <= 0 ||
+		  ticket->t_trans_type > XFS_TRANS_TYPE_MAX) ?
+		  "bad-trans-type" : trans_type_str[ticket->t_trans_type-1]),
+		ticket->t_trans_type,
+		ticket->t_unit_res,
+		ticket->t_curr_res,
+		ticket->t_res_arr_sum, ticket->t_res_o_flow,
+		ticket->t_res_num_ophdrs, ophdr_spc,
+		ticket->t_res_arr_sum +
+		ticket->t_res_o_flow + ophdr_spc,
+		ticket->t_res_num);
 
 	for (i = 0; i < ticket->t_res_num; i++) {
-		uint r_type = ticket->t_res_arr[i].r_type; 
-		cmn_err(CE_WARN,
-			    "region[%u]: %s - %u bytes\n",
-			    i, 
+		uint r_type = ticket->t_res_arr[i].r_type;
+		xfs_warn(mp, "region[%u]: %s - %u bytes\n", i,
 			    ((r_type <= 0 || r_type > XLOG_REG_TYPE_MAX) ?
 			    "bad-rtype" : res_type_str[r_type-1]),
 			    ticket->t_res_arr[i].r_len);
 	}
 
-	xfs_cmn_err(XFS_PTAG_LOGRES, CE_ALERT, mp,
+	xfs_alert_tag(mp, XFS_PTAG_LOGRES,
 		"xfs_log_write: reservation ran out. Need to up reservation");
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 }
@@ -1682,7 +1678,7 @@ xlog_write_setup_ophdr(
 	case XFS_LOG:
 		break;
 	default:
-		xfs_fs_cmn_err(CE_WARN, log->l_mp,
+		xfs_warn(log->l_mp,
 			"Bad XFS transaction clientid 0x%x in ticket 0x%p",
 			ophdr->oh_clientid, ticket);
 		return NULL;
@@ -2264,7 +2260,7 @@ xlog_state_do_callback(
 		if (repeats > 5000) {
 			flushcnt += repeats;
 			repeats = 0;
-			xfs_fs_cmn_err(CE_WARN, log->l_mp,
+			xfs_warn(log->l_mp,
 				"%s: possible infinite loop (%d iterations)",
 				__func__, flushcnt);
 		}
@@ -3052,10 +3048,8 @@ xfs_log_force(
 	int	error;
 
 	error = _xfs_log_force(mp, flags, NULL);
-	if (error) {
-		xfs_fs_cmn_err(CE_WARN, mp, "xfs_log_force: "
-			"error %d returned.", error);
-	}
+	if (error)
+		xfs_warn(mp, "%s: error %d returned.", __func__, error);
 }
 
 /*
@@ -3204,10 +3198,8 @@ xfs_log_force_lsn(
 	int	error;
 
 	error = _xfs_log_force_lsn(mp, lsn, flags, NULL);
-	if (error) {
-		xfs_fs_cmn_err(CE_WARN, mp, "xfs_log_force: "
-			"error %d returned.", error);
-	}
+	if (error)
+		xfs_warn(mp, "%s: error %d returned.", __func__, error);
 }
 
 /*
@@ -3412,7 +3404,7 @@ xlog_verify_dest_ptr(
 	}
 
 	if (!good_ptr)
-		xlog_panic("xlog_verify_dest_ptr: invalid ptr");
+		xfs_emerg(log->l_mp, "%s: invalid ptr", __func__);
 }
 
 STATIC void
@@ -3448,16 +3440,16 @@ xlog_verify_tail_lsn(xlog_t	    *log,
 	blocks =
 	    log->l_logBBsize - (log->l_prev_block - BLOCK_LSN(tail_lsn));
 	if (blocks < BTOBB(iclog->ic_offset)+BTOBB(log->l_iclog_hsize))
-	    xlog_panic("xlog_verify_tail_lsn: ran out of log space");
+		xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
     } else {
 	ASSERT(CYCLE_LSN(tail_lsn)+1 == log->l_prev_cycle);
 
 	if (BLOCK_LSN(tail_lsn) == log->l_prev_block)
-	    xlog_panic("xlog_verify_tail_lsn: tail wrapped");
+		xfs_emerg(log->l_mp, "%s: tail wrapped", __func__);
 
 	blocks = BLOCK_LSN(tail_lsn) - log->l_prev_block;
 	if (blocks < BTOBB(iclog->ic_offset) + 1)
-	    xlog_panic("xlog_verify_tail_lsn: ran out of log space");
+		xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
     }
 }	/* xlog_verify_tail_lsn */
 
@@ -3497,22 +3489,23 @@ xlog_verify_iclog(xlog_t	 *log,
 	icptr = log->l_iclog;
 	for (i=0; i < log->l_iclog_bufs; i++) {
 		if (icptr == NULL)
-			xlog_panic("xlog_verify_iclog: invalid ptr");
+			xfs_emerg(log->l_mp, "%s: invalid ptr", __func__);
 		icptr = icptr->ic_next;
 	}
 	if (icptr != log->l_iclog)
-		xlog_panic("xlog_verify_iclog: corrupt iclog ring");
+		xfs_emerg(log->l_mp, "%s: corrupt iclog ring", __func__);
 	spin_unlock(&log->l_icloglock);
 
 	/* check log magic numbers */
 	if (be32_to_cpu(iclog->ic_header.h_magicno) != XLOG_HEADER_MAGIC_NUM)
-		xlog_panic("xlog_verify_iclog: invalid magic num");
+		xfs_emerg(log->l_mp, "%s: invalid magic num", __func__);
 
 	ptr = (xfs_caddr_t) &iclog->ic_header;
 	for (ptr += BBSIZE; ptr < ((xfs_caddr_t)&iclog->ic_header) + count;
 	     ptr += BBSIZE) {
 		if (be32_to_cpu(*(__be32 *)ptr) == XLOG_HEADER_MAGIC_NUM)
-			xlog_panic("xlog_verify_iclog: unexpected magic num");
+			xfs_emerg(log->l_mp, "%s: unexpected magic num",
+				__func__);
 	}
 
 	/* check fields */
@@ -3542,9 +3535,10 @@ xlog_verify_iclog(xlog_t	 *log,
 			}
 		}
 		if (clientid != XFS_TRANSACTION && clientid != XFS_LOG)
-			cmn_err(CE_WARN, "xlog_verify_iclog: "
-				"invalid clientid %d op 0x%p offset 0x%lx",
-				clientid, ophead, (unsigned long)field_offset);
+			xfs_warn(log->l_mp,
+				"%s: invalid clientid %d op 0x%p offset 0x%lx",
+				__func__, clientid, ophead,
+				(unsigned long)field_offset);
 
 		/* check length */
 		field_offset = (__psint_t)
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index d5f8be8..15dbf1f 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -87,10 +87,6 @@ static inline uint xlog_get_client_id(__be32 i)
 	return be32_to_cpu(i) >> 24;
 }
 
-#define xlog_panic(args...)	cmn_err(CE_PANIC, ## args)
-#define xlog_exit(args...)	cmn_err(CE_PANIC, ## args)
-#define xlog_warn(args...)	cmn_err(CE_WARN, ## args)
-
 /*
  * In core log state
  */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index aa0ebb7..0c4a561 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -92,7 +92,7 @@ xlog_get_bp(
 	int		nbblks)
 {
 	if (!xlog_buf_bbcount_valid(log, nbblks)) {
-		xlog_warn("XFS: Invalid block length (0x%x) given for buffer",
+		xfs_warn(log->l_mp, "Invalid block length (0x%x) for buffer",
 			nbblks);
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_HIGH, log->l_mp);
 		return NULL;
@@ -160,7 +160,7 @@ xlog_bread_noalign(
 	int		error;
 
 	if (!xlog_buf_bbcount_valid(log, nbblks)) {
-		xlog_warn("XFS: Invalid block length (0x%x) given for buffer",
+		xfs_warn(log->l_mp, "Invalid block length (0x%x) for buffer",
 			nbblks);
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_HIGH, log->l_mp);
 		return EFSCORRUPTED;
@@ -219,7 +219,7 @@ xlog_bwrite(
 	int		error;
 
 	if (!xlog_buf_bbcount_valid(log, nbblks)) {
-		xlog_warn("XFS: Invalid block length (0x%x) given for buffer",
+		xfs_warn(log->l_mp, "Invalid block length (0x%x) for buffer",
 			nbblks);
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_HIGH, log->l_mp);
 		return EFSCORRUPTED;
@@ -254,9 +254,9 @@ xlog_header_check_dump(
 	xfs_mount_t		*mp,
 	xlog_rec_header_t	*head)
 {
-	cmn_err(CE_DEBUG, "%s:  SB : uuid = %pU, fmt = %d\n",
+	xfs_debug(mp, "%s:  SB : uuid = %pU, fmt = %d\n",
 		__func__, &mp->m_sb.sb_uuid, XLOG_FMT);
-	cmn_err(CE_DEBUG, "    log : uuid = %pU, fmt = %d\n",
+	xfs_debug(mp, "    log : uuid = %pU, fmt = %d\n",
 		&head->h_fs_uuid, be32_to_cpu(head->h_fmt));
 }
 #else
@@ -279,15 +279,15 @@ xlog_header_check_recover(
 	 * a dirty log created in IRIX.
 	 */
 	if (unlikely(be32_to_cpu(head->h_fmt) != XLOG_FMT)) {
-		xlog_warn(
-	"XFS: dirty log written in incompatible format - can't recover");
+		xfs_warn(mp,
+	"dirty log written in incompatible format - can't recover");
 		xlog_header_check_dump(mp, head);
 		XFS_ERROR_REPORT("xlog_header_check_recover(1)",
 				 XFS_ERRLEVEL_HIGH, mp);
 		return XFS_ERROR(EFSCORRUPTED);
 	} else if (unlikely(!uuid_equal(&mp->m_sb.sb_uuid, &head->h_fs_uuid))) {
-		xlog_warn(
-	"XFS: dirty log entry has mismatched uuid - can't recover");
+		xfs_warn(mp,
+	"dirty log entry has mismatched uuid - can't recover");
 		xlog_header_check_dump(mp, head);
 		XFS_ERROR_REPORT("xlog_header_check_recover(2)",
 				 XFS_ERRLEVEL_HIGH, mp);
@@ -312,9 +312,9 @@ xlog_header_check_mount(
 		 * h_fs_uuid is nil, we assume this log was last mounted
 		 * by IRIX and continue.
 		 */
-		xlog_warn("XFS: nil uuid in log - IRIX style log");
+		xfs_warn(mp, "nil uuid in log - IRIX style log");
 	} else if (unlikely(!uuid_equal(&mp->m_sb.sb_uuid, &head->h_fs_uuid))) {
-		xlog_warn("XFS: log has mismatched uuid - can't recover");
+		xfs_warn(mp, "log has mismatched uuid - can't recover");
 		xlog_header_check_dump(mp, head);
 		XFS_ERROR_REPORT("xlog_header_check_mount",
 				 XFS_ERRLEVEL_HIGH, mp);
@@ -490,8 +490,8 @@ xlog_find_verify_log_record(
 	for (i = (*last_blk) - 1; i >= 0; i--) {
 		if (i < start_blk) {
 			/* valid log record not found */
-			xlog_warn(
-		"XFS: Log inconsistent (didn't find previous header)");
+			xfs_warn(log->l_mp,
+		"Log inconsistent (didn't find previous header)");
 			ASSERT(0);
 			error = XFS_ERROR(EIO);
 			goto out;
@@ -591,12 +591,12 @@ xlog_find_head(
 			 * mkfs etc write a dummy unmount record to a fresh
 			 * log so we can store the uuid in there
 			 */
-			xlog_warn("XFS: totally zeroed log");
+			xfs_warn(log->l_mp, "totally zeroed log");
 		}
 
 		return 0;
 	} else if (error) {
-		xlog_warn("XFS: empty log check failed");
+		xfs_warn(log->l_mp, "empty log check failed");
 		return error;
 	}
 
@@ -819,7 +819,7 @@ validate_head:
 	xlog_put_bp(bp);
 
 	if (error)
-	    xlog_warn("XFS: failed to find log head");
+		xfs_warn(log->l_mp, "failed to find log head");
 	return error;
 }
 
@@ -912,7 +912,7 @@ xlog_find_tail(
 		}
 	}
 	if (!found) {
-		xlog_warn("XFS: xlog_find_tail: couldn't find sync record");
+		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
 		ASSERT(0);
 		return XFS_ERROR(EIO);
 	}
@@ -1028,7 +1028,7 @@ done:
 	xlog_put_bp(bp);
 
 	if (error)
-		xlog_warn("XFS: failed to locate log tail");
+		xfs_warn(log->l_mp, "failed to locate log tail");
 	return error;
 }
 
@@ -1092,7 +1092,8 @@ xlog_find_zeroed(
 		 * the first block must be 1. If it's not, maybe we're
 		 * not looking at a log... Bail out.
 		 */
-		xlog_warn("XFS: Log inconsistent or not a log (last==0, first!=1)");
+		xfs_warn(log->l_mp,
+			"Log inconsistent or not a log (last==0, first!=1)");
 		return XFS_ERROR(EINVAL);
 	}
 
@@ -1506,8 +1507,8 @@ xlog_recover_add_to_trans(
 	if (list_empty(&trans->r_itemq)) {
 		/* we need to catch log corruptions here */
 		if (*(uint *)dp != XFS_TRANS_HEADER_MAGIC) {
-			xlog_warn("XFS: xlog_recover_add_to_trans: "
-				  "bad header magic number");
+			xfs_warn(log->l_mp, "%s: bad header magic number",
+				__func__);
 			ASSERT(0);
 			return XFS_ERROR(EIO);
 		}
@@ -1534,8 +1535,8 @@ xlog_recover_add_to_trans(
 	if (item->ri_total == 0) {		/* first region to be added */
 		if (in_f->ilf_size == 0 ||
 		    in_f->ilf_size > XLOG_MAX_REGIONS_IN_ITEM) {
-			xlog_warn(
-	"XFS: bad number of regions (%d) in inode log format",
+			xfs_warn(log->l_mp,
+		"bad number of regions (%d) in inode log format",
 				  in_f->ilf_size);
 			ASSERT(0);
 			return XFS_ERROR(EIO);
@@ -1592,8 +1593,9 @@ xlog_recover_reorder_trans(
 			list_move_tail(&item->ri_list, &trans->r_itemq);
 			break;
 		default:
-			xlog_warn(
-	"XFS: xlog_recover_reorder_trans: unrecognized type of log operation");
+			xfs_warn(log->l_mp,
+				"%s: unrecognized type of log operation",
+				__func__);
 			ASSERT(0);
 			return XFS_ERROR(EIO);
 		}
@@ -1803,8 +1805,9 @@ xlog_recover_do_inode_buffer(
 		logged_nextp = item->ri_buf[item_index].i_addr +
 				next_unlinked_offset - reg_buf_offset;
 		if (unlikely(*logged_nextp == 0)) {
-			xfs_fs_cmn_err(CE_ALERT, mp,
-				"bad inode buffer log record (ptr = 0x%p, bp = 0x%p).  XFS trying to replay bad (0) inode di_next_unlinked field",
+			xfs_alert(mp,
+		"Bad inode buffer log record (ptr = 0x%p, bp = 0x%p). "
+		"Trying to replay bad (0) inode di_next_unlinked field.",
 				item, bp);
 			XFS_ERROR_REPORT("xlog_recover_do_inode_buf",
 					 XFS_ERRLEVEL_LOW, mp);
@@ -1863,17 +1866,17 @@ xlog_recover_do_reg_buffer(
 		if (buf_f->blf_flags &
 		   (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
 			if (item->ri_buf[i].i_addr == NULL) {
-				cmn_err(CE_ALERT,
+				xfs_alert(mp,
 					"XFS: NULL dquot in %s.", __func__);
 				goto next;
 			}
 			if (item->ri_buf[i].i_len < sizeof(xfs_disk_dquot_t)) {
-				cmn_err(CE_ALERT,
+				xfs_alert(mp,
 					"XFS: dquot too small (%d) in %s.",
 					item->ri_buf[i].i_len, __func__);
 				goto next;
 			}
-			error = xfs_qm_dqcheck(item->ri_buf[i].i_addr,
+			error = xfs_qm_dqcheck(mp, item->ri_buf[i].i_addr,
 					       -1, 0, XFS_QMOPT_DOWARN,
 					       "dquot_buf_recover");
 			if (error)
@@ -1898,6 +1901,7 @@ xlog_recover_do_reg_buffer(
  */
 int
 xfs_qm_dqcheck(
+	struct xfs_mount *mp,
 	xfs_disk_dquot_t *ddq,
 	xfs_dqid_t	 id,
 	uint		 type,	  /* used only when IO_dorepair is true */
@@ -1924,14 +1928,14 @@ xfs_qm_dqcheck(
 	 */
 	if (be16_to_cpu(ddq->d_magic) != XFS_DQUOT_MAGIC) {
 		if (flags & XFS_QMOPT_DOWARN)
-			cmn_err(CE_ALERT,
+			xfs_alert(mp,
 			"%s : XFS dquot ID 0x%x, magic 0x%x != 0x%x",
 			str, id, be16_to_cpu(ddq->d_magic), XFS_DQUOT_MAGIC);
 		errs++;
 	}
 	if (ddq->d_version != XFS_DQUOT_VERSION) {
 		if (flags & XFS_QMOPT_DOWARN)
-			cmn_err(CE_ALERT,
+			xfs_alert(mp,
 			"%s : XFS dquot ID 0x%x, version 0x%x != 0x%x",
 			str, id, ddq->d_version, XFS_DQUOT_VERSION);
 		errs++;
@@ -1941,7 +1945,7 @@ xfs_qm_dqcheck(
 	    ddq->d_flags != XFS_DQ_PROJ &&
 	    ddq->d_flags != XFS_DQ_GROUP) {
 		if (flags & XFS_QMOPT_DOWARN)
-			cmn_err(CE_ALERT,
+			xfs_alert(mp,
 			"%s : XFS dquot ID 0x%x, unknown flags 0x%x",
 			str, id, ddq->d_flags);
 		errs++;
@@ -1949,7 +1953,7 @@ xfs_qm_dqcheck(
 
 	if (id != -1 && id != be32_to_cpu(ddq->d_id)) {
 		if (flags & XFS_QMOPT_DOWARN)
-			cmn_err(CE_ALERT,
+			xfs_alert(mp,
 			"%s : ondisk-dquot 0x%p, ID mismatch: "
 			"0x%x expected, found id 0x%x",
 			str, ddq, id, be32_to_cpu(ddq->d_id));
@@ -1962,9 +1966,8 @@ xfs_qm_dqcheck(
 				be64_to_cpu(ddq->d_blk_softlimit)) {
 			if (!ddq->d_btimer) {
 				if (flags & XFS_QMOPT_DOWARN)
-					cmn_err(CE_ALERT,
-					"%s : Dquot ID 0x%x (0x%p) "
-					"BLK TIMER NOT STARTED",
+					xfs_alert(mp,
+			"%s : Dquot ID 0x%x (0x%p) BLK TIMER NOT STARTED",
 					str, (int)be32_to_cpu(ddq->d_id), ddq);
 				errs++;
 			}
@@ -1974,9 +1977,8 @@ xfs_qm_dqcheck(
 				be64_to_cpu(ddq->d_ino_softlimit)) {
 			if (!ddq->d_itimer) {
 				if (flags & XFS_QMOPT_DOWARN)
-					cmn_err(CE_ALERT,
-					"%s : Dquot ID 0x%x (0x%p) "
-					"INODE TIMER NOT STARTED",
+					xfs_alert(mp,
+			"%s : Dquot ID 0x%x (0x%p) INODE TIMER NOT STARTED",
 					str, (int)be32_to_cpu(ddq->d_id), ddq);
 				errs++;
 			}
@@ -1986,9 +1988,8 @@ xfs_qm_dqcheck(
 				be64_to_cpu(ddq->d_rtb_softlimit)) {
 			if (!ddq->d_rtbtimer) {
 				if (flags & XFS_QMOPT_DOWARN)
-					cmn_err(CE_ALERT,
-					"%s : Dquot ID 0x%x (0x%p) "
-					"RTBLK TIMER NOT STARTED",
+					xfs_alert(mp,
+			"%s : Dquot ID 0x%x (0x%p) RTBLK TIMER NOT STARTED",
 					str, (int)be32_to_cpu(ddq->d_id), ddq);
 				errs++;
 			}
@@ -1999,7 +2000,7 @@ xfs_qm_dqcheck(
 		return errs;
 
 	if (flags & XFS_QMOPT_DOWARN)
-		cmn_err(CE_NOTE, "Re-initializing dquot ID 0x%x", id);
+		xfs_notice(mp, "Re-initializing dquot ID 0x%x", id);
 
 	/*
 	 * Typically, a repair is only requested by quotacheck.
@@ -2218,9 +2219,9 @@ xlog_recover_inode_pass2(
 	 */
 	if (unlikely(be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC)) {
 		xfs_buf_relse(bp);
-		xfs_fs_cmn_err(CE_ALERT, mp,
-			"xfs_inode_recover: Bad inode magic number, dino ptr = 0x%p, dino bp = 0x%p, ino = %Ld",
-			dip, bp, in_f->ilf_ino);
+		xfs_alert(mp,
+	"%s: Bad inode magic number, dip = 0x%p, dino bp = 0x%p, ino = %Ld",
+			__func__, dip, bp, in_f->ilf_ino);
 		XFS_ERROR_REPORT("xlog_recover_inode_pass2(1)",
 				 XFS_ERRLEVEL_LOW, mp);
 		error = EFSCORRUPTED;
@@ -2229,9 +2230,9 @@ xlog_recover_inode_pass2(
 	dicp = item->ri_buf[1].i_addr;
 	if (unlikely(dicp->di_magic != XFS_DINODE_MAGIC)) {
 		xfs_buf_relse(bp);
-		xfs_fs_cmn_err(CE_ALERT, mp,
-			"xfs_inode_recover: Bad inode log record, rec ptr 0x%p, ino %Ld",
-			item, in_f->ilf_ino);
+		xfs_alert(mp,
+			"%s: Bad inode log record, rec ptr 0x%p, ino %Ld",
+			__func__, item, in_f->ilf_ino);
 		XFS_ERROR_REPORT("xlog_recover_inode_pass2(2)",
 				 XFS_ERRLEVEL_LOW, mp);
 		error = EFSCORRUPTED;
@@ -2263,9 +2264,10 @@ xlog_recover_inode_pass2(
 			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(3)",
 					 XFS_ERRLEVEL_LOW, mp, dicp);
 			xfs_buf_relse(bp);
-			xfs_fs_cmn_err(CE_ALERT, mp,
-				"xfs_inode_recover: Bad regular inode log record, rec ptr 0x%p, ino ptr = 0x%p, ino bp = 0x%p, ino %Ld",
-				item, dip, bp, in_f->ilf_ino);
+			xfs_alert(mp,
+		"%s: Bad regular inode log record, rec ptr 0x%p, "
+		"ino ptr = 0x%p, ino bp = 0x%p, ino %Ld",
+				__func__, item, dip, bp, in_f->ilf_ino);
 			error = EFSCORRUPTED;
 			goto error;
 		}
@@ -2276,9 +2278,10 @@ xlog_recover_inode_pass2(
 			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(4)",
 					     XFS_ERRLEVEL_LOW, mp, dicp);
 			xfs_buf_relse(bp);
-			xfs_fs_cmn_err(CE_ALERT, mp,
-				"xfs_inode_recover: Bad dir inode log record, rec ptr 0x%p, ino ptr = 0x%p, ino bp = 0x%p, ino %Ld",
-				item, dip, bp, in_f->ilf_ino);
+			xfs_alert(mp,
+		"%s: Bad dir inode log record, rec ptr 0x%p, "
+		"ino ptr = 0x%p, ino bp = 0x%p, ino %Ld",
+				__func__, item, dip, bp, in_f->ilf_ino);
 			error = EFSCORRUPTED;
 			goto error;
 		}
@@ -2287,9 +2290,10 @@ xlog_recover_inode_pass2(
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
 				     XFS_ERRLEVEL_LOW, mp, dicp);
 		xfs_buf_relse(bp);
-		xfs_fs_cmn_err(CE_ALERT, mp,
-			"xfs_inode_recover: Bad inode log record, rec ptr 0x%p, dino ptr 0x%p, dino bp 0x%p, ino %Ld, total extents = %d, nblocks = %Ld",
-			item, dip, bp, in_f->ilf_ino,
+		xfs_alert(mp,
+	"%s: Bad inode log record, rec ptr 0x%p, dino ptr 0x%p, "
+	"dino bp 0x%p, ino %Ld, total extents = %d, nblocks = %Ld",
+			__func__, item, dip, bp, in_f->ilf_ino,
 			dicp->di_nextents + dicp->di_anextents,
 			dicp->di_nblocks);
 		error = EFSCORRUPTED;
@@ -2299,8 +2303,9 @@ xlog_recover_inode_pass2(
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
 				     XFS_ERRLEVEL_LOW, mp, dicp);
 		xfs_buf_relse(bp);
-		xfs_fs_cmn_err(CE_ALERT, mp,
-			"xfs_inode_recover: Bad inode log rec ptr 0x%p, dino ptr 0x%p, dino bp 0x%p, ino %Ld, forkoff 0x%x",
+		xfs_alert(mp,
+	"%s: Bad inode log record, rec ptr 0x%p, dino ptr 0x%p, "
+	"dino bp 0x%p, ino %Ld, forkoff 0x%x", __func__,
 			item, dip, bp, in_f->ilf_ino, dicp->di_forkoff);
 		error = EFSCORRUPTED;
 		goto error;
@@ -2309,9 +2314,9 @@ xlog_recover_inode_pass2(
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
 				     XFS_ERRLEVEL_LOW, mp, dicp);
 		xfs_buf_relse(bp);
-		xfs_fs_cmn_err(CE_ALERT, mp,
-			"xfs_inode_recover: Bad inode log record length %d, rec ptr 0x%p",
-			item->ri_buf[1].i_len, item);
+		xfs_alert(mp,
+			"%s: Bad inode log record length %d, rec ptr 0x%p",
+			__func__, item->ri_buf[1].i_len, item);
 		error = EFSCORRUPTED;
 		goto error;
 	}
@@ -2398,7 +2403,7 @@ xlog_recover_inode_pass2(
 			break;
 
 		default:
-			xlog_warn("XFS: xlog_recover_inode_pass2: Invalid flag");
+			xfs_warn(log->l_mp, "%s: Invalid flag", __func__);
 			ASSERT(0);
 			xfs_buf_relse(bp);
 			error = EIO;
@@ -2467,13 +2472,11 @@ xlog_recover_dquot_pass2(
 
 	recddq = item->ri_buf[1].i_addr;
 	if (recddq == NULL) {
-		cmn_err(CE_ALERT,
-			"XFS: NULL dquot in %s.", __func__);
+		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
 		return XFS_ERROR(EIO);
 	}
 	if (item->ri_buf[1].i_len < sizeof(xfs_disk_dquot_t)) {
-		cmn_err(CE_ALERT,
-			"XFS: dquot too small (%d) in %s.",
+		xfs_alert(log->l_mp, "dquot too small (%d) in %s.",
 			item->ri_buf[1].i_len, __func__);
 		return XFS_ERROR(EIO);
 	}
@@ -2498,12 +2501,10 @@ xlog_recover_dquot_pass2(
 	 */
 	dq_f = item->ri_buf[0].i_addr;
 	ASSERT(dq_f);
-	if ((error = xfs_qm_dqcheck(recddq,
-			   dq_f->qlf_id,
-			   0, XFS_QMOPT_DOWARN,
-			   "xlog_recover_dquot_pass2 (log copy)"))) {
+	error = xfs_qm_dqcheck(mp, recddq, dq_f->qlf_id, 0, XFS_QMOPT_DOWARN,
+			   "xlog_recover_dquot_pass2 (log copy)");
+	if (error)
 		return XFS_ERROR(EIO);
-	}
 	ASSERT(dq_f->qlf_len == 1);
 
 	error = xfs_read_buf(mp, mp->m_ddev_targp,
@@ -2523,8 +2524,9 @@ xlog_recover_dquot_pass2(
 	 * was among a chunk of dquots created earlier, and we did some
 	 * minimal initialization then.
 	 */
-	if (xfs_qm_dqcheck(ddq, dq_f->qlf_id, 0, XFS_QMOPT_DOWARN,
-			   "xlog_recover_dquot_pass2")) {
+	error = xfs_qm_dqcheck(mp, ddq, dq_f->qlf_id, 0, XFS_QMOPT_DOWARN,
+			   "xlog_recover_dquot_pass2");
+	if (error) {
 		xfs_buf_relse(bp);
 		return XFS_ERROR(EIO);
 	}
@@ -2676,9 +2678,8 @@ xlog_recover_commit_pass1(
 		/* nothing to do in pass 1 */
 		return 0;
 	default:
-		xlog_warn(
-	"XFS: invalid item type (%d) xlog_recover_commit_pass1",
-			ITEM_TYPE(item));
+		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
+			__func__, ITEM_TYPE(item));
 		ASSERT(0);
 		return XFS_ERROR(EIO);
 	}
@@ -2707,9 +2708,8 @@ xlog_recover_commit_pass2(
 		/* nothing to do in pass2 */
 		return 0;
 	default:
-		xlog_warn(
-	"XFS: invalid item type (%d) xlog_recover_commit_pass2",
-			ITEM_TYPE(item));
+		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
+			__func__, ITEM_TYPE(item));
 		ASSERT(0);
 		return XFS_ERROR(EIO);
 	}
@@ -2751,10 +2751,11 @@ xlog_recover_commit_trans(
 
 STATIC int
 xlog_recover_unmount_trans(
+	struct log		*log,
 	xlog_recover_t		*trans)
 {
 	/* Do nothing now */
-	xlog_warn("XFS: xlog_recover_unmount_trans: Unmount LR");
+	xfs_warn(log->l_mp, "%s: Unmount LR", __func__);
 	return 0;
 }
 
@@ -2797,8 +2798,8 @@ xlog_recover_process_data(
 		dp += sizeof(xlog_op_header_t);
 		if (ohead->oh_clientid != XFS_TRANSACTION &&
 		    ohead->oh_clientid != XFS_LOG) {
-			xlog_warn(
-		"XFS: xlog_recover_process_data: bad clientid");
+			xfs_warn(log->l_mp, "%s: bad clientid 0x%x",
+					__func__, ohead->oh_clientid);
 			ASSERT(0);
 			return (XFS_ERROR(EIO));
 		}
@@ -2811,8 +2812,8 @@ xlog_recover_process_data(
 					be64_to_cpu(rhead->h_lsn));
 		} else {
 			if (dp + be32_to_cpu(ohead->oh_len) > lp) {
-				xlog_warn(
-			"XFS: xlog_recover_process_data: bad length");
+				xfs_warn(log->l_mp, "%s: bad length 0x%x",
+					__func__, be32_to_cpu(ohead->oh_len));
 				WARN_ON(1);
 				return (XFS_ERROR(EIO));
 			}
@@ -2825,7 +2826,7 @@ xlog_recover_process_data(
 								trans, pass);
 				break;
 			case XLOG_UNMOUNT_TRANS:
-				error = xlog_recover_unmount_trans(trans);
+				error = xlog_recover_unmount_trans(log, trans);
 				break;
 			case XLOG_WAS_CONT_TRANS:
 				error = xlog_recover_add_to_cont_trans(log,
@@ -2833,8 +2834,8 @@ xlog_recover_process_data(
 						be32_to_cpu(ohead->oh_len));
 				break;
 			case XLOG_START_TRANS:
-				xlog_warn(
-			"XFS: xlog_recover_process_data: bad transaction");
+				xfs_warn(log->l_mp, "%s: bad transaction",
+					__func__);
 				ASSERT(0);
 				error = XFS_ERROR(EIO);
 				break;
@@ -2844,8 +2845,8 @@ xlog_recover_process_data(
 						dp, be32_to_cpu(ohead->oh_len));
 				break;
 			default:
-				xlog_warn(
-			"XFS: xlog_recover_process_data: bad flag");
+				xfs_warn(log->l_mp, "%s: bad flag 0x%x",
+					__func__, flags);
 				ASSERT(0);
 				error = XFS_ERROR(EIO);
 				break;
@@ -3030,8 +3031,7 @@ xlog_recover_clear_agi_bucket(
 out_abort:
 	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
 out_error:
-	xfs_fs_cmn_err(CE_WARN, mp, "xlog_recover_clear_agi_bucket: "
-			"failed to clear agi %d. Continuing.", agno);
+	xfs_warn(mp, "%s: failed to clear agi %d. Continuing.", __func__, agno);
 	return;
 }
 
@@ -3282,7 +3282,7 @@ xlog_valid_rec_header(
 	if (unlikely(
 	    (!rhead->h_version ||
 	    (be32_to_cpu(rhead->h_version) & (~XLOG_VERSION_OKBITS))))) {
-		xlog_warn("XFS: %s: unrecognised log version (%d).",
+		xfs_warn(log->l_mp, "%s: unrecognised log version (%d).",
 			__func__, be32_to_cpu(rhead->h_version));
 		return XFS_ERROR(EIO);
 	}
@@ -3740,10 +3740,9 @@ xlog_recover(
 			return error;
 		}
 
-		cmn_err(CE_NOTE,
-			"Starting XFS recovery on filesystem: %s (logdev: %s)",
-			log->l_mp->m_fsname, log->l_mp->m_logname ?
-			log->l_mp->m_logname : "internal");
+		xfs_notice(log->l_mp, "Starting recovery (logdev: %s)",
+				log->l_mp->m_logname ? log->l_mp->m_logname
+						     : "internal");
 
 		error = xlog_do_recover(log, head_blk, tail_blk);
 		log->l_flags |= XLOG_RECOVERY_NEEDED;
@@ -3776,9 +3775,7 @@ xlog_recover_finish(
 		int	error;
 		error = xlog_recover_process_efis(log);
 		if (error) {
-			cmn_err(CE_ALERT,
-				"Failed to recover EFIs on filesystem: %s",
-				log->l_mp->m_fsname);
+			xfs_alert(log->l_mp, "Failed to recover EFIs");
 			return error;
 		}
 		/*
@@ -3793,15 +3790,12 @@ xlog_recover_finish(
 
 		xlog_recover_check_summary(log);
 
-		cmn_err(CE_NOTE,
-			"Ending XFS recovery on filesystem: %s (logdev: %s)",
-			log->l_mp->m_fsname, log->l_mp->m_logname ?
-			log->l_mp->m_logname : "internal");
+		xfs_notice(log->l_mp, "Ending recovery (logdev: %s)",
+				log->l_mp->m_logname ? log->l_mp->m_logname
+						     : "internal");
 		log->l_flags &= ~XLOG_RECOVERY_NEEDED;
 	} else {
-		cmn_err(CE_DEBUG,
-			"Ending clean XFS mount for filesystem: %s\n",
-			log->l_mp->m_fsname);
+		xfs_info(log->l_mp, "Ending clean mount");
 	}
 	return 0;
 }
@@ -3834,10 +3828,8 @@ xlog_recover_check_summary(
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
 		error = xfs_read_agf(mp, NULL, agno, 0, &agfbp);
 		if (error) {
-			xfs_fs_cmn_err(CE_ALERT, mp,
-					"xlog_recover_check_summary(agf)"
-					"agf read failed agno %d error %d",
-							agno, error);
+			xfs_alert(mp, "%s agf read failed agno %d error %d",
+						__func__, agno, error);
 		} else {
 			agfp = XFS_BUF_TO_AGF(agfbp);
 			freeblks += be32_to_cpu(agfp->agf_freeblks) +
@@ -3846,7 +3838,10 @@ xlog_recover_check_summary(
 		}
 
 		error = xfs_read_agi(mp, NULL, agno, &agibp);
-		if (!error) {
+		if (error) {
+			xfs_alert(mp, "%s agi read failed agno %d error %d",
+						__func__, agno, error);
+		} else {
 			struct xfs_agi	*agi = XFS_BUF_TO_AGI(agibp);
 
 			itotal += be32_to_cpu(agi->agi_count);
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 9bb6eda..a595f29 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -382,7 +382,8 @@ static inline int xfs_qm_sync(struct xfs_mount *mp, int flags)
 	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, nb, ni, \
 				f | XFS_QMOPT_RES_REGBLKS)
 
-extern int xfs_qm_dqcheck(xfs_disk_dquot_t *, xfs_dqid_t, uint, uint, char *);
+extern int xfs_qm_dqcheck(struct xfs_mount *, xfs_disk_dquot_t *,
+				xfs_dqid_t, uint, uint, char *);
 extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
 
 #endif	/* __KERNEL__ */
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
