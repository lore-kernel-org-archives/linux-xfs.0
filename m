Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4094DCCA486
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jul 2022 01:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236179AbiGHB4H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 21:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236202AbiGHB4G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 21:56:06 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C5869735B8
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 18:56:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3B33510E7C47
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 11:56:03 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o9dDs-00FqlP-Ff
        for linux-xfs@vger.kernel.org; Fri, 08 Jul 2022 11:56:00 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o9dDs-004lDf-Eu
        for linux-xfs@vger.kernel.org;
        Fri, 08 Jul 2022 11:56:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/8] xfs: ensure log tail is always up to date
Date:   Fri,  8 Jul 2022 11:55:53 +1000
Message-Id: <20220708015558.1134330-4-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708015558.1134330-1-david@fromorbit.com>
References: <20220708015558.1134330-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62c78eb3
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=RgO8CyIxsXoA:10 a=20KFwNOVAAAA:8 a=BwP8emcNuNAxXH7P94YA:9
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
 fs/xfs/xfs_log.c       |  3 +--
 fs/xfs/xfs_trans_ail.c | 16 ++++++++++++++--
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 72bedcf9eefb..bef3c0fda5ff 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -529,7 +529,6 @@ xlog_state_release_iclog(
 	struct xlog_in_core	*iclog,
 	struct xlog_ticket	*ticket)
 {
-	xfs_lsn_t		tail_lsn;
 	bool			last_ref;
 
 	lockdep_assert_held(&log->l_icloglock);
@@ -544,7 +543,7 @@ xlog_state_release_iclog(
 	if ((iclog->ic_state == XLOG_STATE_WANT_SYNC ||
 	     (iclog->ic_flags & XLOG_ICL_NEED_FUA)) &&
 	    !iclog->ic_header.h_tail_lsn) {
-		tail_lsn = xlog_assign_tail_lsn(log->l_mp);
+		xfs_lsn_t tail_lsn = atomic64_read(&log->l_tail_lsn);
 		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
 	}
 
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index e41951894b96..b123e8dec76c 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -712,6 +712,12 @@ xfs_ail_push_all_sync(
 	finish_wait(&ailp->ail_empty, &wait);
 }
 
+/*
+ * Callers should pass the the original tail lsn so that we can detect if the
+ * tail has moved as a result of the operation that was performed. If the caller
+ * needs to force a tail LSN update, it should pass NULLCOMMITLSN to bypass the
+ * "did the tail LSN change?" checks.
+ */
 void
 xfs_ail_update_finish(
 	struct xfs_ail		*ailp,
@@ -796,10 +802,16 @@ xfs_trans_ail_update_bulk(
 
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

