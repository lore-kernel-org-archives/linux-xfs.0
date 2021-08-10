Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B9FC43216
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8E6960551
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237174AbhHJFSz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:18:55 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:44998 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236743AbhHJFSx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Aug 2021 01:18:53 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 6143E80BC1E
        for <linux-xfs@vger.kernel.org>; Tue, 10 Aug 2021 15:18:30 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mDK9k-00GZYt-Vs
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:18:28 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mDK9k-000Abr-OC
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:18:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/9] xfs: convert log flags to an operational state field
Date:   Tue, 10 Aug 2021 15:18:20 +1000
Message-Id: <20210810051825.40715-5-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810051825.40715-1-david@fromorbit.com>
References: <20210810051825.40715-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=Klpj2nW2cWQEV4EXp2IA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

log->l_flags doesn't actually contain "flags" as such, it contains
operational state information that can change at runtime. For the
shutdown state, this at least should be an atomic bit because
it is read without holding locks in many places and so using atomic
bitops for the state field modifications makes sense.

This allows us to use things like test_and_set_bit() on state
changes (e.g. setting XLOG_TAIL_WARN) to avoid races in setting the
state when we aren't holding locks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c         | 58 ++++++++++++++++------------------------
 fs/xfs/xfs_log.h         |  1 -
 fs/xfs/xfs_log_priv.h    | 34 +++++++++++++++--------
 fs/xfs/xfs_log_recover.c |  6 ++---
 fs/xfs/xfs_super.c       |  2 +-
 5 files changed, 50 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 8edfd35317d1..548e823dcd03 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -298,7 +298,7 @@ xlog_grant_head_check(
 	int			free_bytes;
 	int			error = 0;
 
-	ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
+	ASSERT(!xlog_in_recovery(log));
 
 	/*
 	 * If there are other waiters on the queue then give them a chance at
@@ -580,6 +580,7 @@ xfs_log_mount(
 	xfs_daddr_t	blk_offset,
 	int		num_bblks)
 {
+	struct xlog	*log;
 	bool		fatal = xfs_sb_version_hascrc(&mp->m_sb);
 	int		error = 0;
 	int		min_logfsbs;
@@ -594,11 +595,12 @@ xfs_log_mount(
 		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
 	}
 
-	mp->m_log = xlog_alloc_log(mp, log_target, blk_offset, num_bblks);
-	if (IS_ERR(mp->m_log)) {
-		error = PTR_ERR(mp->m_log);
+	log = xlog_alloc_log(mp, log_target, blk_offset, num_bblks);
+	if (IS_ERR(log)) {
+		error = PTR_ERR(log);
 		goto out;
 	}
+	mp->m_log = log;
 
 	/*
 	 * Validate the given log space and drop a critical message via syslog
@@ -663,7 +665,7 @@ xfs_log_mount(
 		xfs_warn(mp, "AIL initialisation failed: error %d", error);
 		goto out_free_log;
 	}
-	mp->m_log->l_ailp = mp->m_ail;
+	log->l_ailp = mp->m_ail;
 
 	/*
 	 * skip log recovery on a norecovery mount.  pretend it all
@@ -675,39 +677,39 @@ xfs_log_mount(
 		if (readonly)
 			mp->m_flags &= ~XFS_MOUNT_RDONLY;
 
-		error = xlog_recover(mp->m_log);
+		error = xlog_recover(log);
 
 		if (readonly)
 			mp->m_flags |= XFS_MOUNT_RDONLY;
 		if (error) {
 			xfs_warn(mp, "log mount/recovery failed: error %d",
 				error);
-			xlog_recover_cancel(mp->m_log);
+			xlog_recover_cancel(log);
 			goto out_destroy_ail;
 		}
 	}
 
-	error = xfs_sysfs_init(&mp->m_log->l_kobj, &xfs_log_ktype, &mp->m_kobj,
+	error = xfs_sysfs_init(&log->l_kobj, &xfs_log_ktype, &mp->m_kobj,
 			       "log");
 	if (error)
 		goto out_destroy_ail;
 
 	/* Normal transactions can now occur */
-	mp->m_log->l_flags &= ~XLOG_ACTIVE_RECOVERY;
+	clear_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
 
 	/*
 	 * Now the log has been fully initialised and we know were our
 	 * space grant counters are, we can initialise the permanent ticket
 	 * needed for delayed logging to work.
 	 */
-	xlog_cil_init_post_recovery(mp->m_log);
+	xlog_cil_init_post_recovery(log);
 
 	return 0;
 
 out_destroy_ail:
 	xfs_trans_ail_destroy(mp);
 out_free_log:
-	xlog_dealloc_log(mp->m_log);
+	xlog_dealloc_log(log);
 out:
 	return error;
 }
@@ -759,7 +761,7 @@ xfs_log_mount_finish(
 	 * mount failure occurs.
 	 */
 	mp->m_super->s_flags |= SB_ACTIVE;
-	if (log->l_flags & XLOG_RECOVERY_NEEDED)
+	if (xlog_recovery_needed(log))
 		error = xlog_recover_finish(log);
 	if (!error)
 		xfs_log_work_queue(mp);
@@ -775,7 +777,7 @@ xfs_log_mount_finish(
 	 * Don't push in the error case because the AIL may have pending intents
 	 * that aren't removed until recovery is cancelled.
 	 */
-	if (log->l_flags & XLOG_RECOVERY_NEEDED) {
+	if (xlog_recovery_needed(log)) {
 		if (!error) {
 			xfs_log_force(mp, XFS_LOG_SYNC);
 			xfs_ail_push_all_sync(mp->m_ail);
@@ -787,7 +789,7 @@ xfs_log_mount_finish(
 	}
 	xfs_buftarg_drain(mp->m_ddev_targp);
 
-	log->l_flags &= ~XLOG_RECOVERY_NEEDED;
+	clear_bit(XLOG_RECOVERY_NEEDED, &log->l_opstate);
 	if (readonly)
 		mp->m_flags |= XFS_MOUNT_RDONLY;
 
@@ -1075,7 +1077,7 @@ xfs_log_space_wake(
 		return;
 
 	if (!list_empty_careful(&log->l_write_head.waiters)) {
-		ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
+		ASSERT(!xlog_in_recovery(log));
 
 		spin_lock(&log->l_write_head.lock);
 		free_bytes = xlog_space_left(log, &log->l_write_head.grant);
@@ -1084,7 +1086,7 @@ xfs_log_space_wake(
 	}
 
 	if (!list_empty_careful(&log->l_reserve_head.waiters)) {
-		ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
+		ASSERT(!xlog_in_recovery(log));
 
 		spin_lock(&log->l_reserve_head.lock);
 		free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
@@ -1466,7 +1468,7 @@ xlog_alloc_log(
 	log->l_logBBstart  = blk_offset;
 	log->l_logBBsize   = num_bblks;
 	log->l_covered_state = XLOG_STATE_COVER_IDLE;
-	log->l_flags	   |= XLOG_ACTIVE_RECOVERY;
+	set_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
 	INIT_DELAYED_WORK(&log->l_work, xfs_log_worker);
 
 	log->l_prev_block  = -1;
@@ -3648,17 +3650,15 @@ xlog_verify_grant_tail(
 	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_blocks);
 	if (tail_cycle != cycle) {
 		if (cycle - 1 != tail_cycle &&
-		    !(log->l_flags & XLOG_TAIL_WARN)) {
+		    !test_and_set_bit(XLOG_TAIL_WARN, &log->l_opstate)) {
 			xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
 				"%s: cycle - 1 != tail_cycle", __func__);
-			log->l_flags |= XLOG_TAIL_WARN;
 		}
 
 		if (space > BBTOB(tail_blocks) &&
-		    !(log->l_flags & XLOG_TAIL_WARN)) {
+		    !test_and_set_bit(XLOG_TAIL_WARN, &log->l_opstate)) {
 			xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
 				"%s: space > BBTOB(tail_blocks)", __func__);
-			log->l_flags |= XLOG_TAIL_WARN;
 		}
 	}
 }
@@ -3825,8 +3825,7 @@ xfs_log_force_umount(
 	 * If this happens during log recovery, don't worry about
 	 * locking; the log isn't open for business yet.
 	 */
-	if (!log ||
-	    log->l_flags & XLOG_ACTIVE_RECOVERY) {
+	if (!log || xlog_in_recovery(log)) {
 		mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
 		if (mp->m_sb_bp)
 			mp->m_sb_bp->b_flags |= XBF_DONE;
@@ -3863,10 +3862,8 @@ xfs_log_force_umount(
 	 * Mark the log and the iclogs with IO error flags to prevent any
 	 * further log IO from being issued or completed.
 	 */
-	if (!(log->l_flags & XLOG_IO_ERROR)) {
-		log->l_flags |= XLOG_IO_ERROR;
+	if (!test_and_set_bit(XLOG_IO_ERROR, &log->l_opstate))
 		retval = 1;
-	}
 	spin_unlock(&log->l_icloglock);
 
 	/*
@@ -3954,15 +3951,6 @@ xfs_log_check_lsn(
 	return valid;
 }
 
-bool
-xfs_log_in_recovery(
-	struct xfs_mount	*mp)
-{
-	struct xlog		*log = mp->m_log;
-
-	return log->l_flags & XLOG_ACTIVE_RECOVERY;
-}
-
 /*
  * Notify the log that we're about to start using a feature that is protected
  * by a log incompat feature flag.  This will prevent log covering from
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index b274fb9dcd8d..d1235f5073fe 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -138,7 +138,6 @@ void	xfs_log_work_queue(struct xfs_mount *mp);
 int	xfs_log_quiesce(struct xfs_mount *mp);
 void	xfs_log_clean(struct xfs_mount *mp);
 bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
-bool	xfs_log_in_recovery(struct xfs_mount *);
 
 xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 88b1136e475e..86ddd0f9cecf 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -11,15 +11,6 @@ struct xlog;
 struct xlog_ticket;
 struct xfs_mount;
 
-/*
- * Flags for log structure
- */
-#define XLOG_ACTIVE_RECOVERY	0x2	/* in the middle of recovery */
-#define	XLOG_RECOVERY_NEEDED	0x4	/* log was recovered */
-#define XLOG_IO_ERROR		0x8	/* log hit an I/O error, and being
-					   shutdown */
-#define XLOG_TAIL_WARN		0x10	/* log tail verify warning issued */
-
 /*
  * get client id from packed copy.
  *
@@ -405,7 +396,7 @@ struct xlog {
 	struct xfs_buftarg	*l_targ;        /* buftarg of log */
 	struct workqueue_struct	*l_ioend_workqueue; /* for I/O completions */
 	struct delayed_work	l_work;		/* background flush work */
-	uint			l_flags;
+	long			l_opstate;	/* operational state */
 	uint			l_quotaoffs_flag; /* XFS_DQ_*, for QUOTAOFFs */
 	struct list_head	*l_buf_cancel_table;
 	int			l_iclog_hsize;  /* size of iclog header */
@@ -462,10 +453,31 @@ struct xlog {
 #define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
 	((log)->l_buf_cancel_table + ((uint64_t)blkno % XLOG_BC_TABLE_SIZE))
 
+/*
+ * Bits for operational state
+ */
+#define XLOG_ACTIVE_RECOVERY	0	/* in the middle of recovery */
+#define XLOG_RECOVERY_NEEDED	1	/* log was recovered */
+#define XLOG_IO_ERROR		2	/* log hit an I/O error, and being
+				   shutdown */
+#define XLOG_TAIL_WARN		3	/* log tail verify warning issued */
+
+static inline bool
+xlog_recovery_needed(struct xlog *log)
+{
+	return test_bit(XLOG_RECOVERY_NEEDED, &log->l_opstate);
+}
+
+static inline bool
+xlog_in_recovery(struct xlog *log)
+{
+	return test_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
+}
+
 static inline bool
 xlog_is_shutdown(struct xlog *log)
 {
-	return (log->l_flags & XLOG_IO_ERROR);
+	return test_bit(XLOG_IO_ERROR, &log->l_opstate);
 }
 
 /* common routines */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 53006e923a8c..71dd1bbd93de 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3359,7 +3359,7 @@ xlog_do_recover(
 	xlog_recover_check_summary(log);
 
 	/* Normal transactions can now occur */
-	log->l_flags &= ~XLOG_ACTIVE_RECOVERY;
+	clear_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
 	return 0;
 }
 
@@ -3443,7 +3443,7 @@ xlog_recover(
 						     : "internal");
 
 		error = xlog_do_recover(log, head_blk, tail_blk);
-		log->l_flags |= XLOG_RECOVERY_NEEDED;
+		set_bit(XLOG_RECOVERY_NEEDED, &log->l_opstate);
 	}
 	return error;
 }
@@ -3508,7 +3508,7 @@ void
 xlog_recover_cancel(
 	struct xlog	*log)
 {
-	if (log->l_flags & XLOG_RECOVERY_NEEDED)
+	if (xlog_recovery_needed(log))
 		xlog_recover_cancel_intents(log);
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 16a3ea6eae13..53ce25008948 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -710,7 +710,7 @@ xfs_fs_drop_inode(
 	 * that.  See the comment for this inode flag.
 	 */
 	if (ip->i_flags & XFS_IRECOVERY) {
-		ASSERT(ip->i_mount->m_log->l_flags & XLOG_RECOVERY_NEEDED);
+		ASSERT(xlog_recovery_needed(ip->i_mount->m_log));
 		return 0;
 	}
 
-- 
2.31.1

