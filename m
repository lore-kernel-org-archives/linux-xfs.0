Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF7AC43140
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 00:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E23C92082C
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 00:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389126AbfIFAF7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 20:05:59 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37816 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730718AbfIFAF7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 20:05:59 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E23FD43D423
        for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2019 10:05:55 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i61lD-0003ZS-Gw
        for linux-xfs@vger.kernel.org; Fri, 06 Sep 2019 10:05:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i61lD-0001mX-F4
        for linux-xfs@vger.kernel.org; Fri, 06 Sep 2019 10:05:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/8] xfs: prevent CIL push holdoff in log recovery
Date:   Fri,  6 Sep 2019 10:05:48 +1000
Message-Id: <20190906000553.6740-4-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190906000553.6740-1-david@fromorbit.com>
References: <20190906000553.6740-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=J70Eh1EUuV4A:10 a=20KFwNOVAAAA:8
        a=t6etOladE1_Vxw6LjJkA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

generic/530 on a machine with enough ram and a non-preemptible
kernel can run the AGI processing phase of log recovery enitrely out
of cache. This means it never blocks on locks, never waits for IO
and runs entirely through the unlinked lists until it either
completes or blocks and hangs because it has run out of log space.

It runs out of log space because the background CIL push is
scheduled but never runs. queue_work() queues the CIL work on the
current CPU that is busy, and the workqueue code will not run it on
any other CPU. Hence if the unlinked list processing never yields
the CPU voluntarily, the push work is delayed indefinitely. This
results in the CIL aggregating changes until all the log space is
consumed.

When the log recoveyr processing evenutally blocks, the CIL flushes
but because the last iclog isn't submitted for IO because it isn't
full, the CIL flush never completes and nothing ever moves the log
head forwards, or indeed inserts anything into the tail of the log,
and hence nothing is able to get the log moving again and recovery
hangs.

There are several problems here, but the two obvious ones from
the trace are that:
	a) log recovery does not yield the CPU for over 4 seconds,
	b) binding CIL pushes to a single CPU is a really bad idea.

This patch addresses just these two aspects of the problem, and are
suitable for backporting to work around any issues in older kernels.
The more fundamental problem of preventing the CIL from consuming
more than 50% of the log without committing will take more invasive
and complex work, so will be done as followup work.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 1 +
 fs/xfs/xfs_super.c       | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index f05c6c99c4f3..c9665455431e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5080,6 +5080,7 @@ xlog_recover_process_iunlinks(
 			while (agino != NULLAGINO) {
 				agino = xlog_recover_process_one_iunlink(mp,
 							agno, agino, bucket);
+				cond_resched();
 			}
 		}
 		xfs_buf_rele(agibp);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f9450235533c..391b4748cae3 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -818,7 +818,8 @@ xfs_init_mount_workqueues(
 		goto out_destroy_buf;
 
 	mp->m_cil_workqueue = alloc_workqueue("xfs-cil/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
+			WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND,
+			0, mp->m_fsname);
 	if (!mp->m_cil_workqueue)
 		goto out_destroy_unwritten;
 
-- 
2.23.0.rc1

