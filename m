Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78110C2B9F4
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 04:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 595306101D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 04:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhFVEI1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Jun 2021 00:08:27 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:46443 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229452AbhFVEI0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jun 2021 00:08:26 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 736411B08A2
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jun 2021 14:06:08 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lvXfr-00FZEv-Fw
        for linux-xfs@vger.kernel.org; Tue, 22 Jun 2021 14:06:07 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lvXfr-005PwS-8V
        for linux-xfs@vger.kernel.org; Tue, 22 Jun 2021 14:06:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] xfs: remove callback dequeue loop from xlog_state_do_iclog_callbacks
Date:   Tue, 22 Jun 2021 14:06:02 +1000
Message-Id: <20210622040604.1290539-3-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622040604.1290539-1-david@fromorbit.com>
References: <20210622040604.1290539-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=62U3oB1cbkqZUD_uJlgA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

If we are processing callbacks on an iclog, nothing can be
concurrently adding callbacks to the loop. We only add callbacks to
the iclog when they are in ACTIVE or WANT_SYNC state, and we
explicitly do not add callbacks if the iclog is already in IOERROR
state.

The only way to have a dequeue racing with an enqueue is to be
processing a shutdown without a direct reference to an iclog in
ACTIVE or WANT_SYNC state. As the enqueue avoids this race
condition, we only ever need a single dequeue operation in
xlog_state_do_iclog_callbacks(). Hence we can remove the loop.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index bb4390942275..05b00fa4d661 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2774,19 +2774,15 @@ xlog_state_do_iclog_callbacks(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog)
 {
-	trace_xlog_iclog_callbacks_start(iclog, _RET_IP_);
-	spin_lock(&iclog->ic_callback_lock);
-	while (!list_empty(&iclog->ic_callbacks)) {
-		LIST_HEAD(tmp);
+	LIST_HEAD(tmp);
 
-		list_splice_init(&iclog->ic_callbacks, &tmp);
-
-		spin_unlock(&iclog->ic_callback_lock);
-		xlog_cil_process_committed(&tmp);
-		spin_lock(&iclog->ic_callback_lock);
-	}
+	trace_xlog_iclog_callbacks_start(iclog, _RET_IP_);
 
+	spin_lock(&iclog->ic_callback_lock);
+	list_splice_init(&iclog->ic_callbacks, &tmp);
 	spin_unlock(&iclog->ic_callback_lock);
+
+	xlog_cil_process_committed(&tmp);
 	trace_xlog_iclog_callbacks_done(iclog, _RET_IP_);
 }
 
-- 
2.31.1

