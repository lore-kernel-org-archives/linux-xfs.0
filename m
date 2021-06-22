Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D363AC49EA2
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 04:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA64D6100B
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 04:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhFVEI3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Jun 2021 00:08:29 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58288 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229682AbhFVEI1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jun 2021 00:08:27 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 722131044740
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jun 2021 14:06:08 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lvXfr-00FZEt-F9
        for linux-xfs@vger.kernel.org; Tue, 22 Jun 2021 14:06:07 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lvXfr-005PwP-7Q
        for linux-xfs@vger.kernel.org; Tue, 22 Jun 2021 14:06:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: don't nest icloglock inside ic_callback_lock
Date:   Tue, 22 Jun 2021 14:06:01 +1000
Message-Id: <20210622040604.1290539-2-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622040604.1290539-1-david@fromorbit.com>
References: <20210622040604.1290539-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=ebCP089DhnBR_cQ_l5sA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It's completely unnecessary because callbacks are added to iclogs
without holding the icloglock, hence no amount of ordering between
the icloglock and ic_callback_lock will order the removal of
callbacks from the iclog.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index e93cac6b5378..bb4390942275 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2773,11 +2773,8 @@ static void
 xlog_state_do_iclog_callbacks(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog)
-		__releases(&log->l_icloglock)
-		__acquires(&log->l_icloglock)
 {
 	trace_xlog_iclog_callbacks_start(iclog, _RET_IP_);
-	spin_unlock(&log->l_icloglock);
 	spin_lock(&iclog->ic_callback_lock);
 	while (!list_empty(&iclog->ic_callbacks)) {
 		LIST_HEAD(tmp);
@@ -2789,12 +2786,6 @@ xlog_state_do_iclog_callbacks(
 		spin_lock(&iclog->ic_callback_lock);
 	}
 
-	/*
-	 * Pick up the icloglock while still holding the callback lock so we
-	 * serialise against anyone trying to add more callbacks to this iclog
-	 * now we've finished processing.
-	 */
-	spin_lock(&log->l_icloglock);
 	spin_unlock(&iclog->ic_callback_lock);
 	trace_xlog_iclog_callbacks_done(iclog, _RET_IP_);
 }
@@ -2836,13 +2827,12 @@ xlog_state_do_callback(
 				iclog = iclog->ic_next;
 				continue;
 			}
+			spin_unlock(&log->l_icloglock);
 
-			/*
-			 * Running callbacks will drop the icloglock which means
-			 * we'll have to run at least one more complete loop.
-			 */
-			cycled_icloglock = true;
 			xlog_state_do_iclog_callbacks(log, iclog);
+			cycled_icloglock = true;
+
+			spin_lock(&log->l_icloglock);
 			if (XLOG_FORCED_SHUTDOWN(log))
 				wake_up_all(&iclog->ic_force_wait);
 			else
-- 
2.31.1

