Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6311C3A5AA
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 08:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 882C62070C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 08:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731557AbfIEIrX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 04:47:23 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43795 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731412AbfIEIrX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 04:47:23 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4389843DD49
        for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2019 18:47:20 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5nQE-0004Ck-VO
        for linux-xfs@vger.kernel.org; Thu, 05 Sep 2019 18:47:18 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5nQE-0007xz-Tc
        for linux-xfs@vger.kernel.org; Thu, 05 Sep 2019 18:47:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/8] xfs: factor callbacks out of xlog_state_do_callback()
Date:   Thu,  5 Sep 2019 18:47:14 +1000
Message-Id: <20190905084717.30308-6-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190905084717.30308-1-david@fromorbit.com>
References: <20190905084717.30308-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=J70Eh1EUuV4A:10 a=20KFwNOVAAAA:8
        a=1nV49z84FmvGlTHZwfMA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Simplify the code flow by lifting the iclog callback work out of
the main iclog iteration loop. This isolates the log juggling and
callbacks from the iclog state change logic in the loop.

Note that the loopdidcallbacks variable is not actually tracking
whether callbacks are actually run - it is tracking whether the
icloglock was dropped during the loop and so determines if we
completed the entire iclog scan loop atomically. Hence we know for
certain there are either no more ordered completions to run or
that the next completion will run the remaining ordered iclog
completions. Hence rename that variable appropriately for it's
function.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 70 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2904bf0d17f3..73aa8e152c83 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2628,6 +2628,42 @@ xlog_get_lowest_lsn(
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
+static void
+xlog_state_do_iclog_callbacks(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog,
+	bool			aborted)
+{
+	spin_unlock(&log->l_icloglock);
+	spin_lock(&iclog->ic_callback_lock);
+	while (!list_empty(&iclog->ic_callbacks)) {
+		LIST_HEAD(tmp);
+
+		list_splice_init(&iclog->ic_callbacks, &tmp);
+
+		spin_unlock(&iclog->ic_callback_lock);
+		xlog_cil_process_committed(&tmp, aborted);
+		spin_lock(&iclog->ic_callback_lock);
+	}
+
+	/*
+	 * Pick up the icloglock while still holding the callback lock so we
+	 * serialise against anyone trying to add more callbacks to this iclog
+	 * now we've finished processing.
+	 */
+	spin_lock(&log->l_icloglock);
+	spin_unlock(&iclog->ic_callback_lock);
+}
+
 #ifdef DEBUG
 /*
  * Make one last gasp attempt to see if iclogs are being left in limbo.  If the
@@ -2682,7 +2718,7 @@ xlog_state_do_callback(
 	int		   flushcnt = 0;
 	xfs_lsn_t	   lowest_lsn;
 	int		   ioerrors;	/* counter: iclogs with errors */
-	int		   loopdidcallbacks; /* flag: inner loop did callbacks*/
+	bool		   cycled_icloglock;
 	int		   funcdidcallbacks; /* flag: function did callbacks */
 	int		   repeats;	/* for issuing console warnings if
 					 * looping too many times */
@@ -2704,7 +2740,7 @@ xlog_state_do_callback(
 		 */
 		first_iclog = log->l_iclog;
 		iclog = log->l_iclog;
-		loopdidcallbacks = 0;
+		cycled_icloglock = false;
 		repeats++;
 
 		do {
@@ -2795,31 +2831,13 @@ xlog_state_do_callback(
 			} else
 				ioerrors++;
 
-			spin_unlock(&log->l_icloglock);
-
 			/*
-			 * Keep processing entries in the callback list until
-			 * we come around and it is empty.  We need to
-			 * atomically see that the list is empty and change the
-			 * state to DIRTY so that we don't miss any more
-			 * callbacks being added.
+			 * Running callbacks will drop the icloglock which means
+			 * we'll have to run at least one more complete loop.
 			 */
-			spin_lock(&iclog->ic_callback_lock);
-			while (!list_empty(&iclog->ic_callbacks)) {
-				LIST_HEAD(tmp);
+			cycled_icloglock = true;
+			xlog_state_do_iclog_callbacks(log, iclog, aborted);
 
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
 
@@ -2835,6 +2853,8 @@ xlog_state_do_callback(
 			iclog = iclog->ic_next;
 		} while (first_iclog != iclog);
 
+		funcdidcallbacks += cycled_icloglock;
+
 		if (repeats > 5000) {
 			flushcnt += repeats;
 			repeats = 0;
@@ -2842,7 +2862,7 @@ xlog_state_do_callback(
 				"%s: possible infinite loop (%d iterations)",
 				__func__, flushcnt);
 		}
-	} while (!ioerrors && loopdidcallbacks);
+	} while (!ioerrors && cycled_icloglock);
 
 	if (funcdidcallbacks)
 		xlog_state_callback_check_state(log);
-- 
2.23.0.rc1

