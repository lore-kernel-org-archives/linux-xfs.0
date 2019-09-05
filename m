Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02EDDC3A5AB
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 08:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D81902070C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 08:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732495AbfIEIr0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 04:47:26 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41089 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732041AbfIEIrZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 04:47:25 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E43EC363097
        for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2019 18:47:19 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5nQF-0004Cm-0W
        for linux-xfs@vger.kernel.org; Thu, 05 Sep 2019 18:47:19 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5nQE-0007y2-Uk
        for linux-xfs@vger.kernel.org; Thu, 05 Sep 2019 18:47:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] xfs: factor iclog state processing out of xlog_state_do_callback()
Date:   Thu,  5 Sep 2019 18:47:15 +1000
Message-Id: <20190905084717.30308-7-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190905084717.30308-1-david@fromorbit.com>
References: <20190905084717.30308-1-david@fromorbit.com>
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
 fs/xfs/xfs_log.c | 195 ++++++++++++++++++++++++-----------------------
 1 file changed, 98 insertions(+), 97 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 73aa8e152c83..356204ddf865 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2628,6 +2628,90 @@ xlog_get_lowest_lsn(
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
+	struct xlog_in_core	*completed_iclog,
+	bool			*ioerror)
+{
+	xfs_lsn_t		lowest_lsn;
+
+	/* Skip all iclogs in the ACTIVE & DIRTY states */
+	if (iclog->ic_state & (XLOG_STATE_ACTIVE | XLOG_STATE_DIRTY))
+		return false;
+
+	/*
+	 * Between marking a filesystem SHUTDOWN and stopping the log, we do
+	 * flush all iclogs to disk (if there wasn't a log I/O error). So, we do
+	 * want things to go smoothly in case of just a SHUTDOWN  w/o a
+	 * LOG_IO_ERROR.
+	 */
+	if (iclog->ic_state & XLOG_STATE_IOERROR) {
+		*ioerror = true;
+		return false;
+	}
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
@@ -2712,22 +2796,15 @@ xlog_state_do_callback(
 	bool			aborted,
 	struct xlog_in_core	*ciclog)
 {
-	xlog_in_core_t	   *iclog;
-	xlog_in_core_t	   *first_iclog;	/* used to know when we've
-						 * processed all iclogs once */
-	int		   flushcnt = 0;
-	xfs_lsn_t	   lowest_lsn;
-	int		   ioerrors;	/* counter: iclogs with errors */
-	bool		   cycled_icloglock;
-	int		   funcdidcallbacks; /* flag: function did callbacks */
-	int		   repeats;	/* for issuing console warnings if
-					 * looping too many times */
+	struct xlog_in_core	*iclog;
+	struct xlog_in_core	*first_iclog;
+	int			flushcnt = 0;
+	int			funcdidcallbacks = 0;
+	bool			cycled_icloglock;
+	bool			ioerror;
+	int			repeats = 0;
 
 	spin_lock(&log->l_icloglock);
-	first_iclog = iclog = log->l_iclog;
-	ioerrors = 0;
-	funcdidcallbacks = 0;
-	repeats = 0;
 
 	do {
 		/*
@@ -2741,96 +2818,20 @@ xlog_state_do_callback(
 		first_iclog = log->l_iclog;
 		iclog = log->l_iclog;
 		cycled_icloglock = false;
+		ioerror = false;
 		repeats++;
 
 		do {
+			if (xlog_state_iodone_process_iclog(log, iclog,
+							ciclog, &ioerror))
+				break;
 
-			/* skip all iclogs in the ACTIVE & DIRTY states */
-			if (iclog->ic_state &
-			    (XLOG_STATE_ACTIVE|XLOG_STATE_DIRTY)) {
+			if (!(iclog->ic_state &
+			      (XLOG_STATE_CALLBACK | XLOG_STATE_IOERROR))) {
 				iclog = iclog->ic_next;
 				continue;
 			}
 
-			/*
-			 * Between marking a filesystem SHUTDOWN and stopping
-			 * the log, we do flush all iclogs to disk (if there
-			 * wasn't a log I/O error). So, we do want things to
-			 * go smoothly in case of just a SHUTDOWN  w/o a
-			 * LOG_IO_ERROR.
-			 */
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
-
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
-
-			} else
-				ioerrors++;
-
 			/*
 			 * Running callbacks will drop the icloglock which means
 			 * we'll have to run at least one more complete loop.
@@ -2862,7 +2863,7 @@ xlog_state_do_callback(
 				"%s: possible infinite loop (%d iterations)",
 				__func__, flushcnt);
 		}
-	} while (!ioerrors && cycled_icloglock);
+	} while (!ioerror && cycled_icloglock);
 
 	if (funcdidcallbacks)
 		xlog_state_callback_check_state(log);
-- 
2.23.0.rc1

