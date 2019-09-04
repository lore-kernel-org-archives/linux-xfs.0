Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47CFCC3A5A7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:25:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2577C21883
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbfIDEZA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:25:00 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41049 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725877AbfIDEZA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:25:00 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7E7C6361B48
        for <linux-xfs@vger.kernel.org>; Wed,  4 Sep 2019 14:24:54 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5Mqj-0007Oa-2v
        for linux-xfs@vger.kernel.org; Wed, 04 Sep 2019 14:24:53 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5Mqj-0002Ua-1D
        for linux-xfs@vger.kernel.org; Wed, 04 Sep 2019 14:24:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/7] xfs: push iclog state cleaning into xlog_state_clean_log
Date:   Wed,  4 Sep 2019 14:24:50 +1000
Message-Id: <20190904042451.9314-7-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190904042451.9314-1-david@fromorbit.com>
References: <20190904042451.9314-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=J70Eh1EUuV4A:10 a=20KFwNOVAAAA:8
        a=2D6X0XNKtPc4CptNA_0A:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xlog_state_clean_log() is only called from one place, and it occurs
when an iclog is transitioning back to ACTIVE. Prior to calling
xlog_state_clean_log, the iclog we are processing has a hard coded
state check to DIRTY so that xlog_state_clean_log() processes it
correctly. We also have a hard coded wakeup after
xlog_state_clean_log() to enfore log force waiters on that iclog
are woken correctly.

Both of these things are operations required to finish processing an
iclog and return it to the ACTIVE state again, so they make little
sense to be separated from the rest of the clean state transition
code.

Hence push these things inside xlog_state_clean_log(), document the
behaviour and rename it xlog_state_clean_iclog() to indicate that
it's being driven by an iclog state change and does the iclog state
change work itself.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 57 ++++++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c3efece72847..6a59d71d4c60 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2505,21 +2505,35 @@ xlog_write(
  *****************************************************************************
  */
 
-/* Clean iclogs starting from the head.  This ordering must be
- * maintained, so an iclog doesn't become ACTIVE beyond one that
- * is SYNCING.  This is also required to maintain the notion that we use
- * a ordered wait queue to hold off would be writers to the log when every
- * iclog is trying to sync to disk.
+/*
+ * An iclog has just finished it's completion processing, so we need to update
+ * the iclog state and propagate that up into the overall log state. Hence we
+ * prepare the iclog for cleaning, and then clean all the pending dirty iclogs
+ * starting from the head, and then wake up any threads that are waiting for the
+ * iclog to be marked clean.
+ *
+ * The ordering of marking iclogs ACTIVE must be maintained, so an iclog
+ * doesn't become ACTIVE beyond one that is SYNCING.  This is also required to
+ * maintain the notion that we use a ordered wait queue to hold off would be
+ * writers to the log when every iclog is trying to sync to disk.
+ *
+ * Caller must hold the icloglock before calling us.
  *
- * State Change: DIRTY -> ACTIVE
+ * State Change: !IOERROR -> DIRTY -> ACTIVE
  */
 STATIC void
-xlog_state_clean_log(
-	struct xlog *log)
+xlog_state_clean_iclog(
+	struct xlog		*log,
+	struct xlog_in_core	*dirty_iclog)
 {
-	xlog_in_core_t	*iclog;
-	int changed = 0;
+	struct xlog_in_core	*iclog;
+	int			changed = 0;
+
+	/* Prepare the completed iclog. */
+	if (!(dirty_iclog->ic_state & XLOG_STATE_IOERROR))
+		dirty_iclog->ic_state = XLOG_STATE_DIRTY;
 
+	/* Walk all the iclogs to update the ordered active state. */
 	iclog = log->l_iclog;
 	do {
 		if (iclog->ic_state == XLOG_STATE_DIRTY) {
@@ -2557,7 +2571,13 @@ xlog_state_clean_log(
 		iclog = iclog->ic_next;
 	} while (iclog != log->l_iclog);
 
-	/* log is locked when we are called */
+
+	/*
+	 * Wake up threads waiting in xfs_log_force() for the dirty iclog
+	 * to be cleaned.
+	 */
+	wake_up_all(&dirty_iclog->ic_force_wait);
+
 	/*
 	 * Change state for the dummy log recording.
 	 * We usually go to NEED. But we go to NEED2 if the changed indicates
@@ -2591,7 +2611,7 @@ xlog_state_clean_log(
 			ASSERT(0);
 		}
 	}
-}	/* xlog_state_clean_log */
+}
 
 STATIC xfs_lsn_t
 xlog_get_lowest_lsn(
@@ -2835,18 +2855,7 @@ xlog_state_do_callback(
 			if (xlog_state_do_iclog_callbacks(log, iclog, aborted))
 				loopdidcallbacks++;
 
-			if (!(iclog->ic_state & XLOG_STATE_IOERROR))
-				iclog->ic_state = XLOG_STATE_DIRTY;
-
-			/*
-			 * Transition from DIRTY to ACTIVE if applicable.
-			 * NOP if STATE_IOERROR.
-			 */
-			xlog_state_clean_log(log);
-
-			/* wake up threads waiting in xfs_log_force() */
-			wake_up_all(&iclog->ic_force_wait);
-
+			xlog_state_clean_iclog(log, iclog);
 			iclog = iclog->ic_next;
 		} while (first_iclog != iclog);
 
-- 
2.23.0.rc1

