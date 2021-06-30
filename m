Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B015C11F68
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 06:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2494A61D0B
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 06:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhF3Gkr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Jun 2021 02:40:47 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:36717 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232409AbhF3Gkq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jun 2021 02:40:46 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id A1CD61B0D3A
        for <linux-xfs@vger.kernel.org>; Wed, 30 Jun 2021 16:38:16 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lyTrU-0012kM-1l
        for linux-xfs@vger.kernel.org; Wed, 30 Jun 2021 16:38:16 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lyTrT-007LlG-QG
        for linux-xfs@vger.kernel.org; Wed, 30 Jun 2021 16:38:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/9] xfs: convert log flags to an operational state field
Date:   Wed, 30 Jun 2021 16:38:08 +1000
Message-Id: <20210630063813.1751007-5-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210630063813.1751007-1-david@fromorbit.com>
References: <20210630063813.1751007-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=Klpj2nW2cWQEV4EXp2IA:9
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
---
 fs/xfs/xfs_log.c         | 60 ++++++++++++++++------------------------
 fs/xfs/xfs_log.h         |  1 -
 fs/xfs/xfs_log_priv.h    | 34 +++++++++++++++--------
 fs/xfs/xfs_log_recover.c |  6 ++--
 fs/xfs/xfs_super.c       |  2 +-
 5 files changed, 51 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6e6f490a8ab5..049d6ac9cb4d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -299,7 +299,7 @@ xlog_grant_head_check(
 	int			free_bytes;
 	int			error = 0;
 
-	ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
+	ASSERT(!xlog_in_recovery(log));
 
 	/*
 	 * If there are other waiters on the queue then give them a chance at
@@ -552,6 +552,7 @@ xfs_log_mount(
 	xfs_daddr_t	blk_offset,
 	int		num_bblks)
 {
+	struct xlog	*log;
 	bool		fatal = xfs_sb_version_hascrc(&mp->m_sb);
 	int		error = 0;
 	int		min_logfsbs;
@@ -566,11 +567,12 @@ xfs_log_mount(
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
@@ -635,7 +637,7 @@ xfs_log_mount(
 		xfs_warn(mp, "AIL initialisation failed: error %d", error);
 		goto out_free_log;
 	}
-	mp->m_log->l_ailp = mp->m_ail;
+	log->l_ailp = mp->m_ail;
 
 	/*
 	 * skip log recovery on a norecovery mount.  pretend it all
@@ -647,39 +649,39 @@ xfs_log_mount(
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
@@ -731,7 +733,7 @@ xfs_log_mount_finish(
 	 * mount failure occurs.
 	 */
 	mp->m_super->s_flags |= SB_ACTIVE;
-	if (log->l_flags & XLOG_RECOVERY_NEEDED)
+	if (xlog_recovery_needed(log))
 		error = xlog_recover_finish(log);
 	if (!error)
 		xfs_log_work_queue(mp);
@@ -747,7 +749,7 @@ xfs_log_mount_finish(
 	 * Don't push in the error case because the AIL may have pending intents
 	 * that aren't removed until recovery is cancelled.
 	 */
-	if (log->l_flags & XLOG_RECOVERY_NEEDED) {
+	if (xlog_recovery_needed(log)) {
 		if (!error) {
 			xfs_log_force(mp, XFS_LOG_SYNC);
 			xfs_ail_push_all_sync(mp->m_ail);
@@ -759,12 +761,12 @@ xfs_log_mount_finish(
 	}
 	xfs_buftarg_drain(mp->m_ddev_targp);
 
-	log->l_flags &= ~XLOG_RECOVERY_NEEDED;
+	clear_bit(XLOG_RECOVERY_NEEDED, &log->l_opstate);
 	if (readonly)
 		mp->m_flags |= XFS_MOUNT_RDONLY;
 
 	/* Make sure the log is dead if we're returning failure. */
-	ASSERT(!error || (log->l_flags & XLOG_IO_ERROR));
+	ASSERT(!error || xlog_is_shutdown(log));
 
 	return error;
 }
@@ -1036,7 +1038,7 @@ xfs_log_space_wake(
 		return;
 
 	if (!list_empty_careful(&log->l_write_head.waiters)) {
-		ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
+		ASSERT(!xlog_in_recovery(log));
 
 		spin_lock(&log->l_write_head.lock);
 		free_bytes = xlog_space_left(log, &log->l_write_head.grant);
@@ -1045,7 +1047,7 @@ xfs_log_space_wake(
 	}
 
 	if (!list_empty_careful(&log->l_reserve_head.waiters)) {
-		ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
+		ASSERT(!xlog_in_recovery(log));
 
 		spin_lock(&log->l_reserve_head.lock);
 		free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
@@ -1400,7 +1402,7 @@ xlog_alloc_log(
 	log->l_logBBstart  = blk_offset;
 	log->l_logBBsize   = num_bblks;
 	log->l_covered_state = XLOG_STATE_COVER_IDLE;
-	log->l_flags	   |= XLOG_ACTIVE_RECOVERY;
+	set_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
 	INIT_DELAYED_WORK(&log->l_work, xfs_log_worker);
 
 	log->l_prev_block  = -1;
@@ -3527,17 +3529,15 @@ xlog_verify_grant_tail(
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
@@ -3704,8 +3704,7 @@ xfs_log_force_umount(
 	 * If this happens during log recovery, don't worry about
 	 * locking; the log isn't open for business yet.
 	 */
-	if (!log ||
-	    log->l_flags & XLOG_ACTIVE_RECOVERY) {
+	if (!log || xlog_in_recovery(log)) {
 		mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
 		if (mp->m_sb_bp)
 			mp->m_sb_bp->b_flags |= XBF_DONE;
@@ -3742,10 +3741,8 @@ xfs_log_force_umount(
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
@@ -3832,12 +3829,3 @@ xfs_log_check_lsn(
 
 	return valid;
 }
-
-bool
-xfs_log_in_recovery(
-	struct xfs_mount	*mp)
-{
-	struct xlog		*log = mp->m_log;
-
-	return log->l_flags & XLOG_ACTIVE_RECOVERY;
-}
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 813b972e9788..4c5c8a7db1d9 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -138,7 +138,6 @@ void	xfs_log_work_queue(struct xfs_mount *mp);
 int	xfs_log_quiesce(struct xfs_mount *mp);
 void	xfs_log_clean(struct xfs_mount *mp);
 bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
-bool	xfs_log_in_recovery(struct xfs_mount *);
 
 xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index bf05763ba8df..6c2f88e06ac3 100644
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
@@ -397,7 +388,7 @@ struct xlog {
 	struct xfs_buftarg	*l_targ;        /* buftarg of log */
 	struct workqueue_struct	*l_ioend_workqueue; /* for I/O completions */
 	struct delayed_work	l_work;		/* background flush work */
-	uint			l_flags;
+	long			l_opstate;	/* operational state */
 	uint			l_quotaoffs_flag; /* XFS_DQ_*, for QUOTAOFFs */
 	struct list_head	*l_buf_cancel_table;
 	int			l_iclog_hsize;  /* size of iclog header */
@@ -451,10 +442,31 @@ struct xlog {
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
index aeaf4e7fc447..078b3f8bea84 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3324,7 +3324,7 @@ xlog_do_recover(
 	xlog_recover_check_summary(log);
 
 	/* Normal transactions can now occur */
-	log->l_flags &= ~XLOG_ACTIVE_RECOVERY;
+	clear_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
 	return 0;
 }
 
@@ -3408,7 +3408,7 @@ xlog_recover(
 						     : "internal");
 
 		error = xlog_do_recover(log, head_blk, tail_blk);
-		log->l_flags |= XLOG_RECOVERY_NEEDED;
+		set_bit(XLOG_RECOVERY_NEEDED, &log->l_opstate);
 	}
 	return error;
 }
@@ -3458,7 +3458,7 @@ void
 xlog_recover_cancel(
 	struct xlog	*log)
 {
-	if (log->l_flags & XLOG_RECOVERY_NEEDED)
+	if (xlog_recovery_needed(log))
 		xlog_recover_cancel_intents(log);
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2c9e26a44546..29bec1f6476e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -734,7 +734,7 @@ xfs_fs_drop_inode(
 	 * that.  See the comment for this inode flag.
 	 */
 	if (ip->i_flags & XFS_IRECOVERY) {
-		ASSERT(ip->i_mount->m_log->l_flags & XLOG_RECOVERY_NEEDED);
+		ASSERT(xlog_recovery_needed(ip->i_mount->m_log));
 		return 0;
 	}
 
-- 
2.31.1

