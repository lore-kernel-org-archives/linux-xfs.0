Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB6AC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 01:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241547AbiC3BMl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 21:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241549AbiC3BMk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Mar 2022 21:12:40 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6372BB7179
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 18:10:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8CB42534107
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 12:10:51 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nZMrK-00BVQL-FB
        for linux-xfs@vger.kernel.org; Wed, 30 Mar 2022 12:10:50 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nZMrK-005VFQ-EG
        for linux-xfs@vger.kernel.org;
        Wed, 30 Mar 2022 12:10:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] xfs: xfs_trans_commit() path must check for log shutdown
Date:   Wed, 30 Mar 2022 12:10:46 +1100
Message-Id: <20220330011048.1311625-7-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220330011048.1311625-1-david@fromorbit.com>
References: <20220330011048.1311625-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6243ae1b
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=Kk2NOthOEprIJjCpsQ0A:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

If a shut races with xfs_trans_commit() and we have shut down the
filesystem but not the log, we will still cancel the transaction.
This can result in aborting dirty log items instead of committing and
pinning them whilst the log is still running. Hence we can end up
with dirty, unlogged metadata that isn't in the AIL in memory that
can be flushed to disk via writeback clustering.

This was discovered from a g/388 trace where an inode log item was
having IO completed on it and it wasn't in the AIL, hence tripping
asserts xfs_ail_check(). Inode cluster writeback started long after
the filesystem shutdown started, and long after the transaction
containing the dirty inode was aborted and the log item marked
XFS_LI_ABORTED. The inode was seen as dirty and unpinned, so it
was flushed. IO completion tried to remove the inode from the AIL,
at which point stuff went bad:

 XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xa3/0xf0 (fs/xfs/xfs_fsops.c:500).  Shutting down filesystem.
 XFS: Assertion failed: in_ail, file: fs/xfs/xfs_trans_ail.c, line: 67
 XFS (pmem1): Please unmount the filesystem and rectify the problem(s)
 Workqueue: xfs-buf/pmem1 xfs_buf_ioend_work
 RIP: 0010:assfail+0x27/0x2d
 Call Trace:
  <TASK>
  xfs_ail_check+0xa8/0x180
  xfs_ail_delete_one+0x3b/0xf0
  xfs_buf_inode_iodone+0x329/0x3f0
  xfs_buf_ioend+0x1f8/0x530
  xfs_buf_ioend_work+0x15/0x20
  process_one_work+0x1ac/0x390
  worker_thread+0x56/0x3c0
  kthread+0xf6/0x120
  ret_from_fork+0x1f/0x30
  </TASK>

xfs_trans_commit() needs to check log state for shutdown, not mount
state. It cannot abort dirty log items while the log is still
running as dirty items must remained pinned in memory until they are
either committed to the journal or the log has shut down and they
can be safely tossed away. Hence if the log has not shut down, the
xfs_trans_commit() path must allow completed transactions to commit
to the CIL and pin the dirty items even if a mount shutdown has
started.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trans.c | 48 +++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 917a69f0a6ff..0ac717aad380 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -836,6 +836,7 @@ __xfs_trans_commit(
 	bool			regrant)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
+	struct xlog		*log = mp->m_log;
 	xfs_csn_t		commit_seq = 0;
 	int			error = 0;
 	int			sync = tp->t_flags & XFS_TRANS_SYNC;
@@ -864,7 +865,13 @@ __xfs_trans_commit(
 	if (!(tp->t_flags & XFS_TRANS_DIRTY))
 		goto out_unreserve;
 
-	if (xfs_is_shutdown(mp)) {
+	/*
+	 * We must check against log shutdown here because we cannot abort log
+	 * items and leave them dirty, inconsistent and unpinned in memory while
+	 * the log is active. This leaves them open to being written back to
+	 * disk, and that will lead to on-disk corruption.
+	 */
+	if (xlog_is_shutdown(log)) {
 		error = -EIO;
 		goto out_unreserve;
 	}
@@ -878,7 +885,7 @@ __xfs_trans_commit(
 		xfs_trans_apply_sb_deltas(tp);
 	xfs_trans_apply_dquot_deltas(tp);
 
-	xlog_cil_commit(mp->m_log, tp, &commit_seq, regrant);
+	xlog_cil_commit(log, tp, &commit_seq, regrant);
 
 	xfs_trans_free(tp);
 
@@ -905,10 +912,10 @@ __xfs_trans_commit(
 	 */
 	xfs_trans_unreserve_and_mod_dquots(tp);
 	if (tp->t_ticket) {
-		if (regrant && !xlog_is_shutdown(mp->m_log))
-			xfs_log_ticket_regrant(mp->m_log, tp->t_ticket);
+		if (regrant && !xlog_is_shutdown(log))
+			xfs_log_ticket_regrant(log, tp->t_ticket);
 		else
-			xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
+			xfs_log_ticket_ungrant(log, tp->t_ticket);
 		tp->t_ticket = NULL;
 	}
 	xfs_trans_free_items(tp, !!error);
@@ -926,18 +933,27 @@ xfs_trans_commit(
 }
 
 /*
- * Unlock all of the transaction's items and free the transaction.
- * The transaction must not have modified any of its items, because
- * there is no way to restore them to their previous state.
+ * Unlock all of the transaction's items and free the transaction.  If the
+ * transaction is dirty, we must shut down the filesystem because there is no
+ * way to restore them to their previous state.
  *
- * If the transaction has made a log reservation, make sure to release
- * it as well.
+ * If the transaction has made a log reservation, make sure to release it as
+ * well.
+ *
+ * This is a high level function (equivalent to xfs_trans_commit()) and so can
+ * be called after the transaction has effectively been aborted due to the mount
+ * being shut down. However, if the mount has not been shut down and the
+ * transaction is dirty we will shut the mount down and, in doing so, that
+ * guarantees that the log is shut down, too. Hence we don't need to be as
+ * careful with shutdown state and dirty items here as we need to be in
+ * xfs_trans_commit().
  */
 void
 xfs_trans_cancel(
 	struct xfs_trans	*tp)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
+	struct xlog		*log = mp->m_log;
 	bool			dirty = (tp->t_flags & XFS_TRANS_DIRTY);
 
 	trace_xfs_trans_cancel(tp, _RET_IP_);
@@ -955,16 +971,18 @@ xfs_trans_cancel(
 	}
 
 	/*
-	 * See if the caller is relying on us to shut down the
-	 * filesystem.  This happens in paths where we detect
-	 * corruption and decide to give up.
+	 * See if the caller is relying on us to shut down the filesystem. We
+	 * only want an error report if there isn't already a shutdown in
+	 * progress, so we only need to check against the mount shutdown state
+	 * here.
 	 */
 	if (dirty && !xfs_is_shutdown(mp)) {
 		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, mp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	}
 #ifdef DEBUG
-	if (!dirty && !xfs_is_shutdown(mp)) {
+	/* Log items need to be consistent until the log is shut down. */
+	if (!dirty && !xlog_is_shutdown(log)) {
 		struct xfs_log_item *lip;
 
 		list_for_each_entry(lip, &tp->t_items, li_trans)
@@ -975,7 +993,7 @@ xfs_trans_cancel(
 	xfs_trans_unreserve_and_mod_dquots(tp);
 
 	if (tp->t_ticket) {
-		xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
+		xfs_log_ticket_ungrant(log, tp->t_ticket);
 		tp->t_ticket = NULL;
 	}
 
-- 
2.35.1

