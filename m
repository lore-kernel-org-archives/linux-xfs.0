Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940E2C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C8E421883
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbfIDEY7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:24:59 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40869 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725938AbfIDEY6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:24:58 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 00622361996
        for <linux-xfs@vger.kernel.org>; Wed,  4 Sep 2019 14:24:53 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5Mqj-0007OX-1T
        for linux-xfs@vger.kernel.org; Wed, 04 Sep 2019 14:24:53 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5Mqi-0002UX-W1
        for linux-xfs@vger.kernel.org; Wed, 04 Sep 2019 14:24:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/7] xfs: factor iclog state processing out of xlog_state_do_callback()
Date:   Wed,  4 Sep 2019 14:24:49 +1000
Message-Id: <20190904042451.9314-6-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190904042451.9314-1-david@fromorbit.com>
References: <20190904042451.9314-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=J70Eh1EUuV4A:10 a=20KFwNOVAAAA:8
        a=T-GVzMzSLi8Sjll_dAQA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The iclog IO completion state processing is somewhat complex, and
because it's inside two nested loops it is highly indented and very
hard to read. Factor it out, flatten the logic flow and clean up the
comments so that it much easier to see what the code is doing both
in processing the individual iclogs and in the over
xlog_state_do_callback() operation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 199 ++++++++++++++++++++++++-----------------------
 1 file changed, 103 insertions(+), 96 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c3a43fe023ea..c3efece72847 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2612,6 +2612,87 @@ xlog_get_lowest_lsn(
 	return lowest_lsn;
 }
 
+/*
+ * Return true if we need to stop processing, false to continue to the next
+ * iclog. The caller will need to run callbacks if the iclog is returned in the
+ * XLOG_STATE_CALLBACK state.
+ */
+static bool
+xlog_state_iodone_process_iclog(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog,
+	struct xlog_in_core	*completed_iclog)
+{
+	xfs_lsn_t		lowest_lsn;
+
+	/* Skip all iclogs in the ACTIVE & DIRTY states */
+	if (iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_DIRTY))
+		return false;
+
+	/*
+	 * Between marking a filesystem SHUTDOWN and stopping the log, we do
+	 * flush all iclogs to disk (if there wasn't a log I/O error). So, we do
+	 * want things to go smoothly in case of just a SHUTDOWN  w/o a
+	 * LOG_IO_ERROR.
+	 */
+	if (iclog->ic_state & XLOG_STATE_IOERROR)
+		return false;
+
+	/*
+	 * Can only perform callbacks in order.  Since this iclog is not in the
+	 * DONE_SYNC/ DO_CALLBACK state, we skip the rest and just try to clean
+	 * up.  If we set our iclog to DO_CALLBACK, we will not process it when
+	 * we retry since a previous iclog is in the CALLBACK and the state
+	 * cannot change since we are holding the l_icloglock.
+	 */
+	if (!(iclog->ic_state &
+			(XLOG_STATE_DONE_SYNC | XLOG_STATE_DO_CALLBACK))) {
+		if (completed_iclog &&
+		    (completed_iclog->ic_state == XLOG_STATE_DONE_SYNC)) {
+			completed_iclog->ic_state = XLOG_STATE_DO_CALLBACK;
+		}
+		return true;
+	}
+
+	/*
+	 * We now have an iclog that is in either the DO_CALLBACK or DONE_SYNC
+	 * states. The other states (WANT_SYNC, SYNCING, or CALLBACK were caught
+	 * by the above if and are going to clean (i.e. we aren't doing their
+	 * callbacks) see the above if.
+	 *
+	 * We will do one more check here to see if we have chased our tail
+	 * around.
+	 */
+	lowest_lsn = xlog_get_lowest_lsn(log);
+	if (lowest_lsn &&
+	    XFS_LSN_CMP(lowest_lsn, be64_to_cpu(iclog->ic_header.h_lsn)) < 0)
+		return false; /* Leave this iclog for another thread */
+
+	iclog->ic_state = XLOG_STATE_CALLBACK;
+
+	/*
+	 * Completion of a iclog IO does not imply that a transaction has
+	 * completed, as transactions can be large enough to span many iclogs.
+	 * We cannot change the tail of the log half way through a transaction
+	 * as this may be the only transaction in the log and moving th etail to
+	 * point to the middle of it will prevent recovery from finding the
+	 * start of the transaction.  Hence we should only update the
+	 * last_sync_lsn if this iclog contains transaction completion callbacks
+	 * on it.
+	 *
+	 * We have to do this before we drop the icloglock to ensure we are the
+	 * only one that can update it.
+	 */
+	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
+			be64_to_cpu(iclog->ic_header.h_lsn)) <= 0);
+	if (!list_empty_careful(&iclog->ic_callbacks))
+		atomic64_set(&log->l_last_sync_lsn,
+			be64_to_cpu(iclog->ic_header.h_lsn));
+
+	return false;
+
+}
+
 /*
  * Keep processing entries in the iclog callback list until we come around and
  * it is empty.  We need to atomically see that the list is empty and change the
@@ -2706,22 +2787,16 @@ xlog_state_do_callback(
 	bool			aborted,
 	struct xlog_in_core	*ciclog)
 {
-	xlog_in_core_t	   *iclog;
-	xlog_in_core_t	   *first_iclog;	/* used to know when we've
-						 * processed all iclogs once */
-	int		   flushcnt = 0;
-	xfs_lsn_t	   lowest_lsn;
-	int		   ioerrors;	/* counter: iclogs with errors */
-	int		   loopdidcallbacks; /* flag: inner loop did callbacks*/
-	int		   funcdidcallbacks; /* flag: function did callbacks */
-	int		   repeats;	/* for issuing console warnings if
-					 * looping too many times */
+	struct xlog_in_core	*iclog;
+	struct xlog_in_core	*first_iclog;
+	int			flushcnt = 0;
+	int			ioerrors = 0;
+	int			funcdidcallbacks = 0;
+	int			loopdidcallbacks;
+	int			repeats = 0;
+	int			ret;
 
 	spin_lock(&log->l_icloglock);
-	first_iclog = iclog = log->l_iclog;
-	ioerrors = 0;
-	funcdidcallbacks = 0;
-	repeats = 0;
 
 	do {
 		/*
@@ -2738,92 +2813,24 @@ xlog_state_do_callback(
 		repeats++;
 
 		do {
-
-			/* skip all iclogs in the ACTIVE & DIRTY states */
-			if (iclog->ic_state &
-			    (XLOG_STATE_ACTIVE|XLOG_STATE_DIRTY)) {
-				iclog = iclog->ic_next;
-				continue;
-			}
-
 			/*
-			 * Between marking a filesystem SHUTDOWN and stopping
-			 * the log, we do flush all iclogs to disk (if there
-			 * wasn't a log I/O error). So, we do want things to
-			 * go smoothly in case of just a SHUTDOWN  w/o a
-			 * LOG_IO_ERROR.
+			 * We have to process iclogs marked with errors at
+			 * least once, so we count errors rather than terminate
+			 * the inner loop here.
 			 */
-			if (!(iclog->ic_state & XLOG_STATE_IOERROR)) {
-				/*
-				 * Can only perform callbacks in order.  Since
-				 * this iclog is not in the DONE_SYNC/
-				 * DO_CALLBACK state, we skip the rest and
-				 * just try to clean up.  If we set our iclog
-				 * to DO_CALLBACK, we will not process it when
-				 * we retry since a previous iclog is in the
-				 * CALLBACK and the state cannot change since
-				 * we are holding the l_icloglock.
-				 */
-				if (!(iclog->ic_state &
-					(XLOG_STATE_DONE_SYNC |
-						 XLOG_STATE_DO_CALLBACK))) {
-					if (ciclog && (ciclog->ic_state ==
-							XLOG_STATE_DONE_SYNC)) {
-						ciclog->ic_state = XLOG_STATE_DO_CALLBACK;
-					}
-					break;
-				}
-				/*
-				 * We now have an iclog that is in either the
-				 * DO_CALLBACK or DONE_SYNC states. The other
-				 * states (WANT_SYNC, SYNCING, or CALLBACK were
-				 * caught by the above if and are going to
-				 * clean (i.e. we aren't doing their callbacks)
-				 * see the above if.
-				 */
-
-				/*
-				 * We will do one more check here to see if we
-				 * have chased our tail around.
-				 */
-
-				lowest_lsn = xlog_get_lowest_lsn(log);
-				if (lowest_lsn &&
-				    XFS_LSN_CMP(lowest_lsn,
-						be64_to_cpu(iclog->ic_header.h_lsn)) < 0) {
-					iclog = iclog->ic_next;
-					continue; /* Leave this iclog for
-						   * another thread */
-				}
-
-				iclog->ic_state = XLOG_STATE_CALLBACK;
-
+			if (iclog->ic_state & XLOG_STATE_IOERROR)
+				ioerrors++;
 
-				/*
-				 * Completion of a iclog IO does not imply that
-				 * a transaction has completed, as transactions
-				 * can be large enough to span many iclogs. We
-				 * cannot change the tail of the log half way
-				 * through a transaction as this may be the only
-				 * transaction in the log and moving th etail to
-				 * point to the middle of it will prevent
-				 * recovery from finding the start of the
-				 * transaction. Hence we should only update the
-				 * last_sync_lsn if this iclog contains
-				 * transaction completion callbacks on it.
-				 *
-				 * We have to do this before we drop the
-				 * icloglock to ensure we are the only one that
-				 * can update it.
-				 */
-				ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
-					be64_to_cpu(iclog->ic_header.h_lsn)) <= 0);
-				if (!list_empty_careful(&iclog->ic_callbacks))
-					atomic64_set(&log->l_last_sync_lsn,
-						be64_to_cpu(iclog->ic_header.h_lsn));
+			ret = xlog_state_iodone_process_iclog(log, iclog,
+								ciclog);
+			if (ret)
+				break;
 
-			} else
-				ioerrors++;
+			if (!(iclog->ic_state &
+			      (XLOG_STATE_CALLBACK | XLOG_STATE_IOERROR))) {
+				iclog = iclog->ic_next;
+				continue;
+			}
 
 			if (xlog_state_do_iclog_callbacks(log, iclog, aborted))
 				loopdidcallbacks++;
-- 
2.23.0.rc1

