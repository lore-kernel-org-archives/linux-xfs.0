Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A3AC4320A
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8631A6101D
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236743AbhHJFS4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:18:56 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:47923 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237236AbhHJFSz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Aug 2021 01:18:55 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 5EA6084596
        for <linux-xfs@vger.kernel.org>; Tue, 10 Aug 2021 15:18:32 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mDK9l-00GZZ8-3P
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:18:29 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mDK9k-000Ac3-Rz
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:18:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 8/9] xfs: don't run shutdown callbacks on active iclogs
Date:   Tue, 10 Aug 2021 15:18:24 +1000
Message-Id: <20210810051825.40715-9-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810051825.40715-1-david@fromorbit.com>
References: <20210810051825.40715-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=TwccxBiVExJpV-d7L8IA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When the log is shutdown, it currently walks all the iclogs and runs
callbacks that are attached to the iclogs, regardless of whether the
iclog is queued for IO completion or not. This creates a problem for
contexts attaching callbacks to iclogs in that a racing shutdown can
run the callbacks even before the attaching context has finished
processing the iclog and releasing it for IO submission.

If the callback processing of the iclog frees the structure that is
attached to the iclog, then this leads to an UAF scenario that can
only be protected against by holding the icloglock from the point
callbacks are attached through to the release of the iclog. While we
currently do this, it is not practical or sustainable.

Hence we need to make shutdown processing the responsibility of the
context that holds active references to the iclog. We know that the
contexts attaching callbacks to the iclog must have active
references to the iclog, and that means they must be in either
ACTIVE or WANT_SYNC states. xlog_state_do_callback() will skip over
iclogs in these states -except- when the log is shut down.

xlog_state_do_callback() checks the state of the iclogs while
holding the icloglock, therefore the reference count/state change
that occurs in xlog_state_release_iclog() after the callbacks are
atomic w.r.t. shutdown processing.

We can't push the responsibility of callback cleanup onto the CIL
context because we can have ACTIVE iclogs that have callbacks
attached that have already been released. Hence we really need to
internalise the cleanup of callbacks into xlog_state_release_iclog()
processing.

Indeed, we already have that internalisation via:

xlog_state_release_iclog
  drop last reference
    ->SYNCING
  xlog_sync
    xlog_write_iclog
      if (log_is_shutdown)
        xlog_state_done_syncing()
	  xlog_state_do_callback()
	    <process shutdown on iclog that is now in SYNCING state>

The problem is that xlog_state_release_iclog() aborts before doing
anything if the log is already shut down. It assumes that the
callbacks have already been cleaned up, and it doesn't need to do
any cleanup.

Hence the fix is to remove the xlog_is_shutdown() check from
xlog_state_release_iclog() so that reference counts are correctly
released from the iclogs, and when the reference count is zero we
always transition to SYNCING if the log is shut down. Hence we'll
always enter the xlog_sync() path in a shutdown and eventually end
up erroring out the iclog IO and running xlog_state_do_callback() to
process the callbacks attached to the iclog.

This allows us to stop processing referenced ACTIVE/WANT_SYNC iclogs
directly in the shutdown code, and in doing so gets rid of the UAF
vector that currently exists. This then decouples the adding of
callbacks to the iclogs from xlog_state_release_iclog() as we
guarantee that xlog_state_release_iclog() will process the callbacks
if the log has been shut down before xlog_state_release_iclog() has
been called.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c     | 35 +++++++++++++++++++++++++++++++----
 fs/xfs/xfs_log_cil.c | 15 +++++++--------
 2 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 38add7bb64e3..a4ec23b5c459 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -41,6 +41,8 @@ xlog_dealloc_log(
 /* local state machine functions */
 STATIC void xlog_state_done_syncing(
 	struct xlog_in_core	*iclog);
+STATIC void xlog_state_do_callback(
+	struct xlog		*log);
 STATIC int
 xlog_state_get_iclog_space(
 	struct xlog		*log,
@@ -491,6 +493,11 @@ xfs_log_reserve(
  * space waiters so they can process the newly set shutdown state. We really
  * don't care what order we process callbacks here because the log is shut down
  * and so state cannot change on disk anymore.
+ *
+ * We avoid processing actively referenced iclogs so that we don't run callbacks
+ * while the iclog owner might still be preparing the iclog for IO submssion.
+ * These will be caught by xlog_state_iclog_release() and call this function
+ * again to process any callbacks that may have been added to that iclog.
  */
 static void
 xlog_state_shutdown_callbacks(
@@ -502,7 +509,12 @@ xlog_state_shutdown_callbacks(
 	spin_lock(&log->l_icloglock);
 	iclog = log->l_iclog;
 	do {
+		if (atomic_read(&iclog->ic_refcnt)) {
+			/* Reference holder will re-run iclog callbacks. */
+			continue;
+		}
 		list_splice_init(&iclog->ic_callbacks, &cb_list);
+		wake_up_all(&iclog->ic_write_wait);
 		wake_up_all(&iclog->ic_force_wait);
 	} while ((iclog = iclog->ic_next) != log->l_iclog);
 
@@ -546,12 +558,11 @@ xlog_state_release_iclog(
 	xfs_lsn_t		old_tail_lsn)
 {
 	xfs_lsn_t		tail_lsn;
+	bool			last_ref;
+
 	lockdep_assert_held(&log->l_icloglock);
 
 	trace_xlog_iclog_release(iclog, _RET_IP_);
-	if (xlog_is_shutdown(log))
-		return -EIO;
-
 	/*
 	 * Grabbing the current log tail needs to be atomic w.r.t. the writing
 	 * of the tail LSN into the iclog so we guarantee that the log tail does
@@ -569,7 +580,23 @@ xlog_state_release_iclog(
 			iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
 	}
 
-	if (!atomic_dec_and_test(&iclog->ic_refcnt))
+	last_ref = atomic_dec_and_test(&iclog->ic_refcnt);
+
+	if (xlog_is_shutdown(log)) {
+		/*
+		 * If there are no more references to this iclog, process the
+		 * pending iclog callbacks that were waiting on the release of
+		 * this iclog.
+		 */
+		if (last_ref) {
+			spin_unlock(&log->l_icloglock);
+			xlog_state_shutdown_callbacks(log);
+			spin_lock(&log->l_icloglock);
+		}
+		return -EIO;
+	}
+
+	if (!last_ref)
 		return 0;
 
 	if (iclog->ic_state != XLOG_STATE_WANT_SYNC) {
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index cd7b58f7f13e..e18b539d26fb 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -891,11 +891,10 @@ xlog_cil_push_work(
 	xfs_log_ticket_ungrant(log, tic);
 
 	/*
-	 * Once we attach the ctx to the iclog, a shutdown can process the
-	 * iclog, run the callbacks and free the ctx. The only thing preventing
-	 * this potential UAF situation here is that we are holding the
-	 * icloglock. Hence we cannot access the ctx once we have attached the
-	 * callbacks and dropped the icloglock.
+	 * Once we attach the ctx to the iclog, it is effectively owned by the
+	 * iclog and we can only use it while we still have an active reference
+	 * to the iclog. i.e. once we call xlog_state_release_iclog() we can no
+	 * longer safely reference the ctx.
 	 */
 	spin_lock(&log->l_icloglock);
 	if (xlog_is_shutdown(log)) {
@@ -927,9 +926,6 @@ xlog_cil_push_work(
 	 * wakeup until this commit_iclog is written to disk.  Hence we use the
 	 * iclog header lsn and compare it to the commit lsn to determine if we
 	 * need to wait on iclogs or not.
-	 *
-	 * NOTE: It is not safe to reference the ctx after this check as we drop
-	 * the icloglock if we have to wait for completion of other iclogs.
 	 */
 	if (ctx->start_lsn != commit_lsn) {
 		xfs_lsn_t	plsn;
@@ -959,6 +955,9 @@ xlog_cil_push_work(
 	 */
 	commit_iclog->ic_flags |= XLOG_ICL_NEED_FUA;
 	xlog_state_release_iclog(log, commit_iclog, preflush_tail_lsn);
+
+	/* Not safe to reference ctx now! */
+
 	spin_unlock(&log->l_icloglock);
 	return;
 
-- 
2.31.1

