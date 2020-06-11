Return-Path: <SRS0=ihlG=7Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 503F3C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Jun 2020 02:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 309562078D
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Jun 2020 02:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgFKCpM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Jun 2020 22:45:12 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:49777 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726279AbgFKCpM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jun 2020 22:45:12 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 5EC80D79956;
        Thu, 11 Jun 2020 12:45:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jjDDD-0002Sa-48; Thu, 11 Jun 2020 12:45:03 +1000
Date:   Thu, 11 Jun 2020 12:45:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Yu Kuai <yukuai3@huawei.com>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Subject: [PATCH] xfs: fix use-after-free on CIL context on shutdown
Message-ID: <20200611024503.GR2040@dread.disaster.area>
References: <20200611013952.2589997-1-yukuai3@huawei.com>
 <20200611022848.GQ2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611022848.GQ2040@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=i0EeH86SAAAA:8
        a=83KKqrmkPyvGHRv_7b8A:9 a=CjuIK1q_8ugA:10 a=pHzHmUro8NiASowvMSCR:22
        a=n87TN5wuljxrRezIQYnT:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


From: Dave Chinner <dchinner@redhat.com>

xlog_wait() on the CIL context can reference a freed context if the
waiter doesn't get scheduled before the CIL context is freed. This
can happen when a task is on the hard throttle and the CIL push
aborts due to a shutdown. This was detected by generic/019:

thread 1			thread 2

__xfs_trans_commit
 xfs_log_commit_cil
  <CIL size over hard throttle limit>
  xlog_wait
   schedule
				xlog_cil_push_work
				wake_up_all
				<shutdown aborts commit>
				xlog_cil_committed
				kmem_free

   remove_wait_queue
    spin_lock_irqsave --> UAF

Fix it by moving the wait queue to the CIL rather than keeping it in
in the CIL context that gets freed on push completion. Because the
wait queue is now independent of the CIL context and we might have
multiple contexts in flight at once, only wake the waiters on the
push throttle when the context we are pushing is over the hard
throttle size threshold.

Fixes: 0e7ab7efe7745 ("xfs: Throttle commits on delayed background CIL push")
Reported-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c  | 10 +++++-----
 fs/xfs/xfs_log_priv.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b43f0e8f43f2e..9ed90368ab311 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -671,7 +671,8 @@ xlog_cil_push_work(
 	/*
 	 * Wake up any background push waiters now this context is being pushed.
 	 */
-	wake_up_all(&ctx->push_wait);
+	if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))
+		wake_up_all(&cil->xc_push_wait);
 
 	/*
 	 * Check if we've anything to push. If there is nothing, then we don't
@@ -743,13 +744,12 @@ xlog_cil_push_work(
 
 	/*
 	 * initialise the new context and attach it to the CIL. Then attach
-	 * the current context to the CIL committing lsit so it can be found
+	 * the current context to the CIL committing list so it can be found
 	 * during log forces to extract the commit lsn of the sequence that
 	 * needs to be forced.
 	 */
 	INIT_LIST_HEAD(&new_ctx->committing);
 	INIT_LIST_HEAD(&new_ctx->busy_extents);
-	init_waitqueue_head(&new_ctx->push_wait);
 	new_ctx->sequence = ctx->sequence + 1;
 	new_ctx->cil = cil;
 	cil->xc_ctx = new_ctx;
@@ -937,7 +937,7 @@ xlog_cil_push_background(
 	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
 		trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
 		ASSERT(cil->xc_ctx->space_used < log->l_logsize);
-		xlog_wait(&cil->xc_ctx->push_wait, &cil->xc_push_lock);
+		xlog_wait(&cil->xc_push_wait, &cil->xc_push_lock);
 		return;
 	}
 
@@ -1216,12 +1216,12 @@ xlog_cil_init(
 	INIT_LIST_HEAD(&cil->xc_committing);
 	spin_lock_init(&cil->xc_cil_lock);
 	spin_lock_init(&cil->xc_push_lock);
+	init_waitqueue_head(&cil->xc_push_wait);
 	init_rwsem(&cil->xc_ctx_lock);
 	init_waitqueue_head(&cil->xc_commit_wait);
 
 	INIT_LIST_HEAD(&ctx->committing);
 	INIT_LIST_HEAD(&ctx->busy_extents);
-	init_waitqueue_head(&ctx->push_wait);
 	ctx->sequence = 1;
 	ctx->cil = cil;
 	cil->xc_ctx = ctx;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index ec22c7a3867f1..75a62870b63af 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -240,7 +240,6 @@ struct xfs_cil_ctx {
 	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
 	struct list_head	iclog_entry;
 	struct list_head	committing;	/* ctx committing list */
-	wait_queue_head_t	push_wait;	/* background push throttle */
 	struct work_struct	discard_endio_work;
 };
 
@@ -274,6 +273,7 @@ struct xfs_cil {
 	wait_queue_head_t	xc_commit_wait;
 	xfs_lsn_t		xc_current_sequence;
 	struct work_struct	xc_push_work;
+	wait_queue_head_t	xc_push_wait;	/* background push throttle */
 } ____cacheline_aligned_in_smp;
 
 /*
