Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6D0C49EA3
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 08:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF961613FB
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 08:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhFQI2c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 04:28:32 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:37665 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230241AbhFQI2b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 04:28:31 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id A82D980B74C
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 18:26:22 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ltnLx-00DjwN-EE
        for linux-xfs@vger.kernel.org; Thu, 17 Jun 2021 18:26:21 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ltnLx-0044v6-6X
        for linux-xfs@vger.kernel.org; Thu, 17 Jun 2021 18:26:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/8] xfs: don't wait on future iclogs when pushing the CIL
Date:   Thu, 17 Jun 2021 18:26:11 +1000
Message-Id: <20210617082617.971602-3-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210617082617.971602-1-david@fromorbit.com>
References: <20210617082617.971602-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=7yxSLlwqS3lPvJho:21 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8
        a=RZvj3mB4rQ5jD1Y1fNEA:9 a=ryn_BjxYRQEVhTpXJPha:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The iclogbuf ring attached to the struct xlog is circular, hence the
first and last iclogs in the ring can only be determined by
comparing them against the log->l_iclog pointer.

In xfs_cil_push_work(), we want to wait on previous iclogs that were
issued so that we can flush them to stable storage with the commit
record write, and it simply waits on the previous iclog in the ring.
This, however, leads to CIL push hangs in generic/019 like so:

task:kworker/u33:0   state:D stack:12680 pid:    7 ppid:     2 flags:0x00004000
Workqueue: xfs-cil/pmem1 xlog_cil_push_work
Call Trace:
 __schedule+0x30b/0x9f0
 schedule+0x68/0xe0
 xlog_wait_on_iclog+0x121/0x190
 ? wake_up_q+0xa0/0xa0
 xlog_cil_push_work+0x994/0xa10
 ? _raw_spin_lock+0x15/0x20
 ? xfs_swap_extents+0x920/0x920
 process_one_work+0x1ab/0x390
 worker_thread+0x56/0x3d0
 ? rescuer_thread+0x3c0/0x3c0
 kthread+0x14d/0x170
 ? __kthread_bind_mask+0x70/0x70
 ret_from_fork+0x1f/0x30

With other threads blocking in either xlog_state_get_iclog_space()
waiting for iclog space or xlog_grant_head_wait() waiting for log
reservation space.

The problem here is that the previous iclog on the ring might
actually be a future iclog. That is, if log->l_iclog points at
commit_iclog, commit_iclog is the first (oldest) iclog in the ring
and there are no previous iclogs pending as they have all completed
their IO and been activated again. IOWs, commit_iclog->ic_prev
points to an iclog that will be written in the future, not one that
has been written in the past.

Hence, in this case, waiting on the ->ic_prev iclog is incorrect
behaviour, and depending on the state of the future iclog, we can
end up with a circular ABA wait cycle and we hang.

The fix is made more complex by the fact that many iclogs states
cannot be used to determine if the iclog is a past or future iclog.
Hence we have to determine past iclogs by checking the LSN of the
iclog rather than their state. A past ACTIVE iclog will have a LSN
of zero, while a future ACTIVE iclog will have a LSN greater than
the current iclog. We don't wait on either of these cases.

Similarly, a future iclog that hasn't completed IO will have an LSN
greater than the current iclog and so we don't wait on them. A past
iclog that is still undergoing IO completion will have a LSN less
than the current iclog and those are the only iclogs that we need to
wait on.

Hence we can use the iclog LSN to determine what iclogs we need to
wait on here.

Fixes: 5fd9256ce156 ("xfs: separate CIL commit record IO")
Reported-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 51 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 705619e9dab4..2fb0ab02dda3 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1075,15 +1075,54 @@ xlog_cil_push_work(
 	ticket = ctx->ticket;
 
 	/*
-	 * If the checkpoint spans multiple iclogs, wait for all previous
-	 * iclogs to complete before we submit the commit_iclog. In this case,
-	 * the commit_iclog write needs to issue a pre-flush so that the
-	 * ordering is correctly preserved down to stable storage.
+	 * If the checkpoint spans multiple iclogs, wait for all previous iclogs
+	 * to complete before we submit the commit_iclog. We can't use state
+	 * checks for this - ACTIVE can be either a past completed iclog or a
+	 * future iclog being filled, while WANT_SYNC through SYNC_DONE can be a
+	 * past or future iclog awaiting IO or ordered IO completion to be run.
+	 * In the latter case, if it's a future iclog and we wait on it, the we
+	 * will hang because it won't get processed through to ic_force_wait
+	 * wakeup until this commit_iclog is written to disk.  Hence we use the
+	 * iclog header lsn and compare it to the commit lsn to determine if we
+	 * need to wait on iclogs or not.
 	 */
 	spin_lock(&log->l_icloglock);
 	if (ctx->start_lsn != commit_lsn) {
-		xlog_wait_on_iclog(commit_iclog->ic_prev);
-		spin_lock(&log->l_icloglock);
+		struct xlog_in_core	*iclog;
+
+		for (iclog = commit_iclog->ic_prev;
+		     iclog != commit_iclog;
+		     iclog = iclog->ic_prev) {
+			xfs_lsn_t	hlsn;
+
+			/*
+			 * If the LSN of the iclog is zero or in the future it
+			 * means it has passed through IO completion and
+			 * activation and hence all previous iclogs have also
+			 * done so. We do not need to wait at all in this case.
+			 */
+			hlsn = be64_to_cpu(iclog->ic_header.h_lsn);
+			if (!hlsn || XFS_LSN_CMP(hlsn, commit_lsn) > 0)
+				break;
+
+			/*
+			 * If the LSN of the iclog is older than the commit lsn,
+			 * we have to wait on it. Waiting on this via the
+			 * ic_force_wait should also order the completion of all
+			 * older iclogs, too, but we leave checking that to the
+			 * next loop iteration.
+			 */
+			ASSERT(XFS_LSN_CMP(hlsn, commit_lsn) < 0);
+			xlog_wait_on_iclog(iclog);
+			spin_lock(&log->l_icloglock);
+		}
+
+		/*
+		 * Regardless of whether we need to wait or not, the the
+		 * commit_iclog write needs to issue a pre-flush so that the
+		 * ordering for this checkpoint is correctly preserved down to
+		 * stable storage.
+		 */
 		commit_iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
 	}
 
-- 
2.31.1

