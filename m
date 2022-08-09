Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F60C25B0E
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 23:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiHIXEE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 19:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiHIXEA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 19:04:00 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 215C16AA0C
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 16:03:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-193-158.pa.nsw.optusnet.com.au [49.181.193.158])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D0D0910E85FC
        for <linux-xfs@vger.kernel.org>; Wed, 10 Aug 2022 09:03:56 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oLYGR-00BDI2-C5
        for linux-xfs@vger.kernel.org; Wed, 10 Aug 2022 09:03:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1oLYGR-00E4WH-Au
        for linux-xfs@vger.kernel.org;
        Wed, 10 Aug 2022 09:03:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/9] xfs: ensure log tail is always up to date
Date:   Wed, 10 Aug 2022 09:03:48 +1000
Message-Id: <20220809230353.3353059-5-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220809230353.3353059-1-david@fromorbit.com>
References: <20220809230353.3353059-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62f2e7dd
        a=SeswVvpAPK2RnNNwqI8AaA==:117 a=SeswVvpAPK2RnNNwqI8AaA==:17
        a=biHskzXt2R4A:10 a=20KFwNOVAAAA:8 a=bOy8r0XuC6DwKxpJzocA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Whenever we write an iclog, we call xlog_assign_tail_lsn() to update
the current tail before we write it into the iclog header. This
means we have to take the AIL lock on every iclog write just to
check if the tail of the log has moved.

This doesn't avoid races with log tail updates - the log tail could
move immediately after we assign the tail to the iclog header and
hence by the time the iclog reaches stable storage the tail LSN has
moved forward in memory. Hence the log tail LSN in the iclog header
is really just a point in time snapshot of the current state of the
AIL.

With this in mind, if we simply update the in memory log->l_tail_lsn
every time it changes in the AIL, there is no need to update the in
memory value when we are writing it into an iclog - it will already
be up-to-date in memory and checking the AIL again will not change
this. Hence xlog_state_release_iclog() does not need to check the
AIL to update the tail lsn and can just sample it directly without
needing to take the AIL lock.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c       |  5 ++---
 fs/xfs/xfs_trans_ail.c | 17 +++++++++++++++--
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c609c188bd8a..042744fe37b7 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -530,7 +530,6 @@ xlog_state_release_iclog(
 	struct xlog_in_core	*iclog,
 	struct xlog_ticket	*ticket)
 {
-	xfs_lsn_t		tail_lsn;
 	bool			last_ref;
 
 	lockdep_assert_held(&log->l_icloglock);
@@ -545,8 +544,8 @@ xlog_state_release_iclog(
 	if ((iclog->ic_state == XLOG_STATE_WANT_SYNC ||
 	     (iclog->ic_flags & XLOG_ICL_NEED_FUA)) &&
 	    !iclog->ic_header.h_tail_lsn) {
-		tail_lsn = xlog_assign_tail_lsn(log->l_mp);
-		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
+		iclog->ic_header.h_tail_lsn =
+				cpu_to_be64(atomic64_read(&log->l_tail_lsn));
 	}
 
 	last_ref = atomic_dec_and_test(&iclog->ic_refcnt);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index d3dcb4942d6a..5f40509877f7 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -715,6 +715,13 @@ xfs_ail_push_all_sync(
 	finish_wait(&ailp->ail_empty, &wait);
 }
 
+/*
+ * Callers should pass the the original tail lsn so that we can detect if the
+ * tail has moved as a result of the operation that was performed. If the caller
+ * needs to force a tail LSN update, it should pass NULLCOMMITLSN to bypass the
+ * "did the tail LSN change?" checks. If the caller wants to avoid a tail update
+ * (e.g. it knows the tail did not change) it should pass an @old_lsn of 0.
+ */
 void
 xfs_ail_update_finish(
 	struct xfs_ail		*ailp,
@@ -799,10 +806,16 @@ xfs_trans_ail_update_bulk(
 
 	/*
 	 * If this is the first insert, wake up the push daemon so it can
-	 * actively scan for items to push.
+	 * actively scan for items to push. We also need to do a log tail
+	 * LSN update to ensure that it is correctly tracked by the log, so
+	 * set the tail_lsn to NULLCOMMITLSN so that xfs_ail_update_finish()
+	 * will see that the tail lsn has changed and will update the tail
+	 * appropriately.
 	 */
-	if (!mlip)
+	if (!mlip) {
 		wake_up_process(ailp->ail_task);
+		tail_lsn = NULLCOMMITLSN;
+	}
 
 	xfs_ail_update_finish(ailp, tail_lsn);
 }
-- 
2.36.1

