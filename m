Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C7A3C3A5A7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BF4021883
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbfIDEYz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:24:55 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40635 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725864AbfIDEYz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:24:55 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CE72C36148E
        for <linux-xfs@vger.kernel.org>; Wed,  4 Sep 2019 14:24:53 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5Mqi-0007OL-TK
        for linux-xfs@vger.kernel.org; Wed, 04 Sep 2019 14:24:52 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5Mqi-0002UI-RW
        for linux-xfs@vger.kernel.org; Wed, 04 Sep 2019 14:24:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/7] xfs: push the AIL in xlog_grant_head_wake
Date:   Wed,  4 Sep 2019 14:24:45 +1000
Message-Id: <20190904042451.9314-2-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190904042451.9314-1-david@fromorbit.com>
References: <20190904042451.9314-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=J70Eh1EUuV4A:10 a=20KFwNOVAAAA:8
        a=iJFTkyUmMBOPLpsSiA4A:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

In the situation where the log is full and the CIL has not recently
flushed, the AIL push threshold is throttled back to the where the
last write of the head of the log was completed. This is stored in
log->l_last_sync_lsn. Hence if the CIL holds > 25% of the log space
pinned by flushes and/or aggregation in progress, we can get the
situation where the head of the log lags a long way behind the
reservation grant head.

When this happens, the AIL push target is trimmed back from where
the reservation grant head wants to push the log tail to, back to
where the head of the log currently is. This means the push target
doesn't reach far enough into the log to actually move the tail
before the transaction reservation goes to sleep.

When the CIL push completes, it moves the log head forward such that
the AIL push target can now be moved, but that has no mechanism for
puhsing the log tail. Further, if the next tail movement of the log
is not large enough wake the waiter (i.e. still not enough space for
it to have a reservation granted), we don't wake anything up, and
hence we do not update the AIL push target to take into account the
head of the log moving and allowing the push target to be moved
forwards.

To avoid this particular condition, if we fail to wake the first
waiter on the grant head because we don't have enough space,
push on the AIL again. This will pick up any movement of the log
head and allow the push target to move forward due to completion of
CIL pushing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b159a9e9fef0..941f10ff99d9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -214,15 +214,20 @@ xlog_grant_head_wake(
 {
 	struct xlog_ticket	*tic;
 	int			need_bytes;
+	bool			woken_task = false;
 
 	list_for_each_entry(tic, &head->waiters, t_queue) {
 		need_bytes = xlog_ticket_reservation(log, head, tic);
-		if (*free_bytes < need_bytes)
+		if (*free_bytes < need_bytes) {
+			if (!woken_task)
+				xlog_grant_push_ail(log, need_bytes);
 			return false;
+		}
 
 		*free_bytes -= need_bytes;
 		trace_xfs_log_grant_wake_up(log, tic);
 		wake_up_process(tic->t_task);
+		woken_task = true;
 	}
 
 	return true;
-- 
2.23.0.rc1

