Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E81C3A5A8
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1484921883
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbfIDEY5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:24:57 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40651 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725877AbfIDEY5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:24:57 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E85E136128F
        for <linux-xfs@vger.kernel.org>; Wed,  4 Sep 2019 14:24:53 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5Mqi-0007OR-VW
        for linux-xfs@vger.kernel.org; Wed, 04 Sep 2019 14:24:52 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5Mqi-0002UO-Tt
        for linux-xfs@vger.kernel.org; Wed, 04 Sep 2019 14:24:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/7] xfs: factor debug code out of xlog_state_do_callback()
Date:   Wed,  4 Sep 2019 14:24:47 +1000
Message-Id: <20190904042451.9314-4-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190904042451.9314-1-david@fromorbit.com>
References: <20190904042451.9314-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=J70Eh1EUuV4A:10 a=20KFwNOVAAAA:8
        a=hUrIRvtVvqYdoKubQJkA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Start making this function readable by lifting the debug code into
a conditional function.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 83 ++++++++++++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6f494f6369e8..b3d8dbb3b956 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2612,6 +2612,53 @@ xlog_get_lowest_lsn(
 	return lowest_lsn;
 }
 
+#ifdef DEBUG
+/*
+ * Make one last gasp attempt to see if iclogs are being left in limbo.  If the
+ * above loop finds an iclog earlier than the current iclog and in one of the
+ * syncing states, the current iclog is put into DO_CALLBACK and the callbacks
+ * are deferred to the completion of the earlier iclog. Walk the iclogs in order
+ * and make sure that no iclog is in DO_CALLBACK unless an earlier iclog is in
+ * one of the syncing states.
+ *
+ * Note that SYNCING|IOABORT is a valid state so we cannot just check for
+ * ic_state == SYNCING.
+ */
+static void
+xlog_state_callback_check_state(
+	struct xlog		*log,
+	int			did_callbacks)
+{
+	struct xlog_in_core	*iclog;
+	struct xlog_in_core	*first_iclog;
+
+	if (!did_callbacks)
+		return;
+
+	first_iclog = iclog = log->l_iclog;
+	do {
+		ASSERT(iclog->ic_state != XLOG_STATE_DO_CALLBACK);
+		/*
+		 * Terminate the loop if iclogs are found in states
+		 * which will cause other threads to clean up iclogs.
+		 *
+		 * SYNCING - i/o completion will go through logs
+		 * DONE_SYNC - interrupt thread should be waiting for
+		 *              l_icloglock
+		 * IOERROR - give up hope all ye who enter here
+		 */
+		if (iclog->ic_state == XLOG_STATE_WANT_SYNC ||
+		    iclog->ic_state & XLOG_STATE_SYNCING ||
+		    iclog->ic_state == XLOG_STATE_DONE_SYNC ||
+		    iclog->ic_state == XLOG_STATE_IOERROR )
+			break;
+		iclog = iclog->ic_next;
+	} while (first_iclog != iclog);
+}
+#else
+#define xlog_state_callback_check_state(l,d)	((void)0)
+#endif
+
 STATIC void
 xlog_state_do_callback(
 	struct xlog		*log,
@@ -2786,41 +2833,7 @@ xlog_state_do_callback(
 		}
 	} while (!ioerrors && loopdidcallbacks);
 
-#ifdef DEBUG
-	/*
-	 * Make one last gasp attempt to see if iclogs are being left in limbo.
-	 * If the above loop finds an iclog earlier than the current iclog and
-	 * in one of the syncing states, the current iclog is put into
-	 * DO_CALLBACK and the callbacks are deferred to the completion of the
-	 * earlier iclog. Walk the iclogs in order and make sure that no iclog
-	 * is in DO_CALLBACK unless an earlier iclog is in one of the syncing
-	 * states.
-	 *
-	 * Note that SYNCING|IOABORT is a valid state so we cannot just check
-	 * for ic_state == SYNCING.
-	 */
-	if (funcdidcallbacks) {
-		first_iclog = iclog = log->l_iclog;
-		do {
-			ASSERT(iclog->ic_state != XLOG_STATE_DO_CALLBACK);
-			/*
-			 * Terminate the loop if iclogs are found in states
-			 * which will cause other threads to clean up iclogs.
-			 *
-			 * SYNCING - i/o completion will go through logs
-			 * DONE_SYNC - interrupt thread should be waiting for
-			 *              l_icloglock
-			 * IOERROR - give up hope all ye who enter here
-			 */
-			if (iclog->ic_state == XLOG_STATE_WANT_SYNC ||
-			    iclog->ic_state & XLOG_STATE_SYNCING ||
-			    iclog->ic_state == XLOG_STATE_DONE_SYNC ||
-			    iclog->ic_state == XLOG_STATE_IOERROR )
-				break;
-			iclog = iclog->ic_next;
-		} while (first_iclog != iclog);
-	}
-#endif
+	xlog_state_callback_check_state(log, funcdidcallbacks);
 
 	if (log->l_iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_IOERROR))
 		wake_up_all(&log->l_flush_wait);
-- 
2.23.0.rc1

