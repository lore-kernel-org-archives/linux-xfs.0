Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FBCBC54E8E
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 09:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89EE32082E
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 09:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbgELJ2T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 05:28:19 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:40303 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728990AbgELJ2S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 05:28:18 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 1D1975AAD49
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 19:28:15 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYRCw-0004H8-DW
        for linux-xfs@vger.kernel.org; Tue, 12 May 2020 19:28:14 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jYRCw-007kYg-5L
        for linux-xfs@vger.kernel.org; Tue, 12 May 2020 19:28:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] [RFC] xfs: make CIl busy extent lists per-cpu
Date:   Tue, 12 May 2020 19:28:11 +1000
Message-Id: <20200512092811.1846252-6-david@fromorbit.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9
In-Reply-To: <20200512092811.1846252-1-david@fromorbit.com>
References: <20200512092811.1846252-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=VTcdlksUSm9lYBse5iYA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We use the same percpu list trick with the busy extents as we do
with the CIL lists, and this gets rid of the last use of the
xc_cil_lock in the commit fast path.

As noted in the previous patch, it looked like we were approaching
another bottleneck, and that can be seen by the fact that
performance didn't substantially increase even though there is now
no lock contention in the commit path. The transaction rate
only increases slightly to 1.12M/sec.

Using a 32-way concurrent create/unlink on a 32p/16GB virtual
machine:

	     create time     rate            unlink time
unpatched       1m49s      523k/s+/-14k/s      2m00s
patched         1m48s      535k/s+/-24k/s      1m51s

So variance went back up, and performance improved slightly.
Profiling at this point indicates spinlock contention at the VFS
level (inode_sb_list_add() and dentry cache pathwalking) so
significant further gains will require VFS surgery.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c  | 35 ++++++++++++++++++-----------------
 fs/xfs/xfs_log_priv.h | 12 +++++++++++-
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index af444bc69a7cd..d3a5f8478d64a 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -461,13 +461,9 @@ xlog_cil_insert_items(
 	percpu_counter_add_batch(&cil->xc_curr_res, split_res, 1000 * 1000);
 	percpu_counter_add_batch(&cil->xc_space_used, len, 1000 * 1000);
 
-	spin_lock(&cil->xc_cil_lock);
-
 	/* attach the transaction to the CIL if it has any busy extents */
 	if (!list_empty(&tp->t_busy))
-		list_splice_init(&tp->t_busy, &ctx->busy_extents);
-
-	spin_unlock(&cil->xc_cil_lock);
+		list_splice_tail_init(&tp->t_busy, pcp_busy(cil));
 
 	/*
 	 * Now (re-)position everything modified at the tail of the CIL.
@@ -486,7 +482,7 @@ xlog_cil_insert_items(
 		 */
 		if (!list_empty(&lip->li_cil))
 			continue;
-		list_add_tail(&lip->li_cil, this_cpu_ptr(cil->xc_cil));
+		list_add_tail(&lip->li_cil, pcp_cil(cil));
 	}
 
 	if (tp->t_ticket->t_curr_res < 0)
@@ -733,10 +729,14 @@ xlog_cil_push_work(
 	 * Remove the items from the per-cpu CIL lists and then pull all the
 	 * log vectors off the items. We hold the xc_ctx_lock exclusively here,
 	 * so nothing can be adding or removing from the per-cpu lists here.
+	 *
+	 * Also splice the busy extents onto the context while we are walking
+	 * the percpu structure.
 	 */
 	/* XXX: hotplug! */
 	for_each_online_cpu(cpu) {
-		list_splice_tail_init(per_cpu_ptr(cil->xc_cil, cpu), &cil_items);
+		list_splice_tail_init(pcp_cil_cpu(cil, cpu), &cil_items);
+		list_splice_tail_init(pcp_busy_cpu(cil, cpu), &ctx->busy_extents);
 	}
 
 	lv = NULL;
@@ -933,7 +933,7 @@ xlog_cil_push_background(
 	 * The cil won't be empty because we are called while holding the
 	 * context lock so whatever we added to the CIL will still be there
 	 */
-	ASSERT(space_used != 0);
+	ASSERT(percpu_counter_read(&cil->xc_curr_res) != 0);
 
 	/*
 	 * don't do a background push if we haven't used up all the
@@ -1241,17 +1241,18 @@ xlog_cil_init(
 		goto out_free_cil;
 
 	/* XXX: CPU hotplug!!! */
-	cil->xc_cil = alloc_percpu_gfp(struct list_head, GFP_KERNEL);
-	if (!cil->xc_cil)
+	cil->xc_pcp = alloc_percpu_gfp(struct xfs_cil_pcpu, GFP_KERNEL);
+	if (!cil->xc_pcp)
 		goto out_free_ctx;
 
 	for_each_possible_cpu(cpu) {
-		INIT_LIST_HEAD(per_cpu_ptr(cil->xc_cil, cpu));
+		INIT_LIST_HEAD(pcp_cil_cpu(cil, cpu));
+		INIT_LIST_HEAD(pcp_busy_cpu(cil, cpu));
 	}
 
 	error = percpu_counter_init(&cil->xc_space_used, 0, GFP_KERNEL);
 	if (error)
-		goto out_free_pcp_cil;
+		goto out_free_pcp;
 
 	error = percpu_counter_init(&cil->xc_curr_res, 0, GFP_KERNEL);
 	if (error)
@@ -1259,7 +1260,6 @@ xlog_cil_init(
 
 	INIT_WORK(&cil->xc_push_work, xlog_cil_push_work);
 	INIT_LIST_HEAD(&cil->xc_committing);
-	spin_lock_init(&cil->xc_cil_lock);
 	spin_lock_init(&cil->xc_push_lock);
 	init_rwsem(&cil->xc_ctx_lock);
 	init_waitqueue_head(&cil->xc_commit_wait);
@@ -1278,8 +1278,8 @@ xlog_cil_init(
 
 out_free_space:
 	percpu_counter_destroy(&cil->xc_space_used);
-out_free_pcp_cil:
-	free_percpu(cil->xc_cil);
+out_free_pcp:
+	free_percpu(cil->xc_pcp);
 out_free_ctx:
 	kmem_free(ctx);
 out_free_cil:
@@ -1303,9 +1303,10 @@ xlog_cil_destroy(
 	percpu_counter_destroy(&cil->xc_curr_res);
 
 	for_each_possible_cpu(cpu) {
-		ASSERT(list_empty(per_cpu_ptr(cil->xc_cil, cpu)));
+		ASSERT(list_empty(pcp_cil_cpu(cil, cpu)));
+		ASSERT(list_empty(pcp_busy_cpu(cil, cpu)));
 	}
-	free_percpu(cil->xc_cil);
+	free_percpu(cil->xc_pcp);
 	kmem_free(cil);
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 0bb982920d070..cfc22c9482ea4 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -260,11 +260,16 @@ struct xfs_cil_ctx {
  * the commit LSN to be determined as well. This should make synchronous
  * operations almost as efficient as the old logging methods.
  */
+struct xfs_cil_pcpu {
+	struct list_head	p_cil;
+	struct list_head	p_busy_extents;
+};
+
 struct xfs_cil {
 	struct xlog		*xc_log;
 	struct percpu_counter	xc_space_used;
 	struct percpu_counter	xc_curr_res;
-	struct list_head __percpu *xc_cil;
+	struct xfs_cil_pcpu __percpu *xc_pcp;
 	spinlock_t		xc_cil_lock;
 
 	struct rw_semaphore	xc_ctx_lock ____cacheline_aligned_in_smp;
@@ -278,6 +283,11 @@ struct xfs_cil {
 	struct work_struct	xc_push_work;
 } ____cacheline_aligned_in_smp;
 
+#define pcp_cil(cil)		&(this_cpu_ptr(cil->xc_pcp)->p_cil)
+#define pcp_cil_cpu(cil, cpu)	&(per_cpu_ptr(cil->xc_pcp, cpu)->p_cil)
+#define pcp_busy(cil)		&(this_cpu_ptr(cil->xc_pcp)->p_busy_extents)
+#define pcp_busy_cpu(cil, cpu)	&(per_cpu_ptr(cil->xc_pcp, cpu)->p_busy_extents)
+
 /*
  * The amount of log space we allow the CIL to aggregate is difficult to size.
  * Whatever we choose, we have to make sure we can get a reservation for the
-- 
2.26.1.301.g55bc3eb7cb9

