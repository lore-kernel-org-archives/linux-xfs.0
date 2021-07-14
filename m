Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E2CC11F66
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 03:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB0A6613AB
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 03:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237722AbhGNDWz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Jul 2021 23:22:55 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:43647 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237503AbhGNDWz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jul 2021 23:22:55 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id D0F266BAB5
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 13:20:01 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3VRJ-006IJp-7F
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 13:20:01 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m3VRI-00Ay8z-Vl
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 13:20:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/9] xfs: move recovery needed state updates to xfs_log_mount_finish
Date:   Wed, 14 Jul 2021 13:19:52 +1000
Message-Id: <20210714031958.2614411-4-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714031958.2614411-1-david@fromorbit.com>
References: <20210714031958.2614411-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=MU6oyeIEaMzVx_n5NM0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_log_mount_finish() needs to know if recovery is needed or not to
make descisions on whether to flush the log and AIL.  Move the
handling of the NEED_RECOVERY state out to this function rather than
needing a temporary variable to store this state over the call to
xlog_recover_finish().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c         | 24 ++++++++-----
 fs/xfs/xfs_log_recover.c | 73 +++++++++++++++-------------------------
 2 files changed, 43 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 75cc487da578..6760608642cc 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -698,9 +698,9 @@ int
 xfs_log_mount_finish(
 	struct xfs_mount	*mp)
 {
-	int	error = 0;
-	bool	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
-	bool	recovered = mp->m_log->l_flags & XLOG_RECOVERY_NEEDED;
+	struct xlog		*log = mp->m_log;
+	bool			readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
+	int			error = 0;
 
 	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
 		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
@@ -731,7 +731,8 @@ xfs_log_mount_finish(
 	 * mount failure occurs.
 	 */
 	mp->m_super->s_flags |= SB_ACTIVE;
-	error = xlog_recover_finish(mp->m_log);
+	if (log->l_flags & XLOG_RECOVERY_NEEDED)
+		error = xlog_recover_finish(log);
 	if (!error)
 		xfs_log_work_queue(mp);
 	mp->m_super->s_flags &= ~SB_ACTIVE;
@@ -746,17 +747,24 @@ xfs_log_mount_finish(
 	 * Don't push in the error case because the AIL may have pending intents
 	 * that aren't removed until recovery is cancelled.
 	 */
-	if (!error && recovered) {
-		xfs_log_force(mp, XFS_LOG_SYNC);
-		xfs_ail_push_all_sync(mp->m_ail);
+	if (log->l_flags & XLOG_RECOVERY_NEEDED) {
+		if (!error) {
+			xfs_log_force(mp, XFS_LOG_SYNC);
+			xfs_ail_push_all_sync(mp->m_ail);
+		}
+		xfs_notice(mp, "Ending recovery (logdev: %s)",
+				mp->m_logname ? mp->m_logname : "internal");
+	} else {
+		xfs_info(mp, "Ending clean mount");
 	}
 	xfs_buftarg_drain(mp->m_ddev_targp);
 
+	log->l_flags &= ~XLOG_RECOVERY_NEEDED;
 	if (readonly)
 		mp->m_flags |= XFS_MOUNT_RDONLY;
 
 	/* Make sure the log is dead if we're returning failure. */
-	ASSERT(!error || (mp->m_log->l_flags & XLOG_IO_ERROR));
+	ASSERT(!error || xlog_is_shutdown(log));
 
 	return error;
 }
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 37296f87a435..c384ecdd6389 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3416,62 +3416,43 @@ xlog_recover(
 }
 
 /*
- * In the first part of recovery we replay inodes and buffers and build
- * up the list of extent free items which need to be processed.  Here
- * we process the extent free items and clean up the on disk unlinked
- * inode lists.  This is separated from the first part of recovery so
- * that the root and real-time bitmap inodes can be read in from disk in
- * between the two stages.  This is necessary so that we can free space
- * in the real-time portion of the file system.
+ * In the first part of recovery we replay inodes and buffers and build up the
+ * list of intents which need to be processed.  Here we process the intents  and
+ * clean up the on disk unlinked inode lists.  This is separated from the first
+ * part of recovery so that the root and real-time bitmap inodes can be read in
+ * from disk in between the two stages.  This is necessary so that we can free
+ * space in the real-time portion of the file system.
  */
 int
 xlog_recover_finish(
 	struct xlog	*log)
 {
-	/*
-	 * Now we're ready to do the transactions needed for the
-	 * rest of recovery.  Start with completing all the extent
-	 * free intent records and then process the unlinked inode
-	 * lists.  At this point, we essentially run in normal mode
-	 * except that we're still performing recovery actions
-	 * rather than accepting new requests.
-	 */
-	if (log->l_flags & XLOG_RECOVERY_NEEDED) {
-		int	error;
-		error = xlog_recover_process_intents(log);
-		if (error) {
-			/*
-			 * Cancel all the unprocessed intent items now so that
-			 * we don't leave them pinned in the AIL.  This can
-			 * cause the AIL to livelock on the pinned item if
-			 * anyone tries to push the AIL (inode reclaim does
-			 * this) before we get around to xfs_log_mount_cancel.
-			 */
-			xlog_recover_cancel_intents(log);
-			xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
-			xfs_alert(log->l_mp, "Failed to recover intents");
-			return error;
-		}
+	int	error;
 
+	error = xlog_recover_process_intents(log);
+	if (error) {
 		/*
-		 * Sync the log to get all the intents out of the AIL.
-		 * This isn't absolutely necessary, but it helps in
-		 * case the unlink transactions would have problems
-		 * pushing the intents out of the way.
+		 * Cancel all the unprocessed intent items now so that we don't
+		 * leave them pinned in the AIL.  This can cause the AIL to
+		 * livelock on the pinned item if anyone tries to push the AIL
+		 * (inode reclaim does this) before we get around to
+		 * xfs_log_mount_cancel.
 		 */
-		xfs_log_force(log->l_mp, XFS_LOG_SYNC);
-
-		xlog_recover_process_iunlinks(log);
+		xlog_recover_cancel_intents(log);
+		xfs_alert(log->l_mp, "Failed to recover intents");
+		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
+		return error;
+	}
 
-		xlog_recover_check_summary(log);
+	/*
+	 * Sync the log to get all the intents out of the AIL.  This isn't
+	 * absolutely necessary, but it helps in case the unlink transactions
+	 * would have problems pushing the intents out of the way.
+	 */
+	xfs_log_force(log->l_mp, XFS_LOG_SYNC);
+	xlog_recover_process_iunlinks(log);
 
-		xfs_notice(log->l_mp, "Ending recovery (logdev: %s)",
-				log->l_mp->m_logname ? log->l_mp->m_logname
-						     : "internal");
-		log->l_flags &= ~XLOG_RECOVERY_NEEDED;
-	} else {
-		xfs_info(log->l_mp, "Ending clean mount");
-	}
+	xlog_recover_check_summary(log);
 	return 0;
 }
 
-- 
2.31.1

