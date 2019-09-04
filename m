Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4027C3A5A4
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5BFF21883
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfIDEY7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:24:59 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40867 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725945AbfIDEY6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:24:58 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E9A9A3617E2
        for <linux-xfs@vger.kernel.org>; Wed,  4 Sep 2019 14:24:53 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5Mqj-0007OT-08
        for linux-xfs@vger.kernel.org; Wed, 04 Sep 2019 14:24:53 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5Mqi-0002UU-Up
        for linux-xfs@vger.kernel.org; Wed, 04 Sep 2019 14:24:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/7] xfs: factor callbacks out of xlog_state_do_callback()
Date:   Wed,  4 Sep 2019 14:24:48 +1000
Message-Id: <20190904042451.9314-5-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190904042451.9314-1-david@fromorbit.com>
References: <20190904042451.9314-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=J70Eh1EUuV4A:10 a=20KFwNOVAAAA:8
        a=lng_JIwEjGLabVi12EoA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Simplify the code flow by lifting the iclog callback work out of
the main iclog iteration loop. This isolates the log juggling and
callbacks from the iclog state change logic in the loop.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 69 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b3d8dbb3b956..c3a43fe023ea 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2612,6 +2612,47 @@ xlog_get_lowest_lsn(
 	return lowest_lsn;
 }
 
+/*
+ * Keep processing entries in the iclog callback list until we come around and
+ * it is empty.  We need to atomically see that the list is empty and change the
+ * state to DIRTY so that we don't miss any more callbacks being added.
+ *
+ * This function is called with the icloglock held and returns with it held. We
+ * drop it while running callbacks, however, as holding it over thousands of
+ * callbacks is unnecessary and causes excessive contention if we do.
+ */
+static bool
+xlog_state_do_iclog_callbacks(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog,
+	bool			aborted)
+{
+	bool			ret = false;
+
+	spin_unlock(&log->l_icloglock);
+
+	spin_lock(&iclog->ic_callback_lock);
+	while (!list_empty(&iclog->ic_callbacks)) {
+		LIST_HEAD(tmp);
+
+		list_splice_init(&iclog->ic_callbacks, &tmp);
+
+		spin_unlock(&iclog->ic_callback_lock);
+		xlog_cil_process_committed(&tmp, aborted);
+		spin_lock(&iclog->ic_callback_lock);
+		ret = true;
+	}
+
+	/*
+	 * Pick up the icloglock while still holding the callback lock so we
+	 * serialise against anyone trying to add more callbacks to this iclog
+	 * now we've finished processing.
+	 */
+	spin_lock(&log->l_icloglock);
+	spin_unlock(&iclog->ic_callback_lock);
+	return ret;
+}
+
 #ifdef DEBUG
 /*
  * Make one last gasp attempt to see if iclogs are being left in limbo.  If the
@@ -2784,31 +2825,9 @@ xlog_state_do_callback(
 			} else
 				ioerrors++;
 
-			spin_unlock(&log->l_icloglock);
+			if (xlog_state_do_iclog_callbacks(log, iclog, aborted))
+				loopdidcallbacks++;
 
-			/*
-			 * Keep processing entries in the callback list until
-			 * we come around and it is empty.  We need to
-			 * atomically see that the list is empty and change the
-			 * state to DIRTY so that we don't miss any more
-			 * callbacks being added.
-			 */
-			spin_lock(&iclog->ic_callback_lock);
-			while (!list_empty(&iclog->ic_callbacks)) {
-				LIST_HEAD(tmp);
-
-				list_splice_init(&iclog->ic_callbacks, &tmp);
-
-				spin_unlock(&iclog->ic_callback_lock);
-				xlog_cil_process_committed(&tmp, aborted);
-				spin_lock(&iclog->ic_callback_lock);
-			}
-
-			loopdidcallbacks++;
-			funcdidcallbacks++;
-
-			spin_lock(&log->l_icloglock);
-			spin_unlock(&iclog->ic_callback_lock);
 			if (!(iclog->ic_state & XLOG_STATE_IOERROR))
 				iclog->ic_state = XLOG_STATE_DIRTY;
 
@@ -2824,6 +2843,8 @@ xlog_state_do_callback(
 			iclog = iclog->ic_next;
 		} while (first_iclog != iclog);
 
+		funcdidcallbacks += loopdidcallbacks;
+
 		if (repeats > 5000) {
 			flushcnt += repeats;
 			repeats = 0;
-- 
2.23.0.rc1

