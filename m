Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2CBEE49A5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238161AbjHXXVo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241313AbjHXXVY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 19:21:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8881E51
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 16:21:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E4C764553
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 23:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FD3C433CA;
        Thu, 24 Aug 2023 23:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692919280;
        bh=JmMz0JJ+IcRHTtCZglX4Ie4ra2fCEx20OW7Dog+N/sE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SWNQN7QgQGFhj0s6XgQTiz1XVUS0aoRulf10cucCE9r3VoZbKHZEkmE+M/eXm8vu3
         zI5Aaqc5XUrZawsjLd59dwNxVyBnsEU2KuSkKsl6Kx0fkXSOAYf1cjyhZSwnwQyE+Z
         J6NBB+cmra7Ro1iku1yOmb5CzxglCDltTC5XdcmQe/e36piXUMKJn8jZS5wFMvNNWN
         gYUf0CkiDXflNFQZXgbf5Or+SiEAJbPE/F3SSE5OFK/IHZuJZoQ3b+hF+PnyZpwm0z
         y96MyZorBl/YdB2BCF0g1EdjYQUuitxhJTq/8Y3nbqZ/PhdA8sgDi6UlBB9qSvq+im
         aNHE+c2ZCeCyw==
Subject: [PATCH 1/3] xfs: fix per-cpu CIL structure aggregation racing with
 dying cpus
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     tglx@linutronix.de, peterz@infradead.org, ritesh.list@gmail.com,
        sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        david@fromorbit.com, ritesh.list@gmail.com, sandeen@sandeen.net
Date:   Thu, 24 Aug 2023 16:21:20 -0700
Message-ID: <169291928016.219974.17814488726880866494.stgit@frogsfrogsfrogs>
In-Reply-To: <169291927442.219974.9654062191833512358.stgit@frogsfrogsfrogs>
References: <169291927442.219974.9654062191833512358.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit 7c8ade2121200 ("xfs: implement percpu cil space used
calculation"), the XFS committed (log) item list code was converted to
use per-cpu lists and space tracking to reduce cpu contention when
multiple threads are modifying different parts of the filesystem and
hence end up contending on the log structures during transaction commit.
Each CPU tracks its own commit items and space usage, and these do not
have to be merged into the main CIL until either someone wants to push
the CIL items, or we run over a soft threshold and switch to slower (but
more accurate) accounting with atomics.

Unfortunately, the for_each_cpu iteration suffers from the same race
with cpu dying problem that was identified in commit 8b57b11cca88f
("pcpcntrs: fix dying cpu summation race") -- CPUs are removed from
cpu_online_mask before the CPUHP_XFS_DEAD callback gets called.  As a
result, both CIL percpu structure aggregation functions fail to collect
the items and accounted space usage at the correct point in time.

If we're lucky, the items that are collected from the online cpus exceed
the space given to those cpus, and the log immediately shuts down in
xlog_cil_insert_items due to the (apparent) log reservation overrun.
This happens periodically with generic/650, which exercises cpu hotplug
vs. the filesystem code:

smpboot: CPU 3 is now offline
XFS (sda3): ctx ticket reservation ran out. Need to up reservation
XFS (sda3): ticket reservation summary:
XFS (sda3):   unit res    = 9268 bytes
XFS (sda3):   current res = -40 bytes
XFS (sda3):   original count  = 1
XFS (sda3):   remaining count = 1
XFS (sda3): Filesystem has been shut down due to log error (0x2).

Applying the same sort of fix from 8b57b11cca88f to the CIL code seems
to make the generic/650 problem go away, but I've been told that tglx
was not happy when he saw:

"...the only thing we actually need to care about is that
percpu_counter_sum() iterates dying CPUs. That's trivial to do, and when
there are no CPUs dying, it has no addition overhead except for a
cpumask_or() operation."

The CPU hotplug code is rather complex and difficult to understand and I
don't want to try to understand the cpu hotplug locking well enough to
use cpu_dying mask.  Furthermore, there's a performance improvement that
could be had here.  Attach a private cpu mask to the CIL structure so
that we can track exactly which cpus have accessed the percpu data at
all.  It doesn't matter if the cpu has since gone offline; log item
aggregation will still find the items.  Better yet, we skip cpus that
have not recently logged anything.

Worse yet, Ritesh Harjani and Eric Sandeen both reported today that CPU
hot remove racing with an xfs mount can crash if the cpu_dead notifier
tries to access the log but the mount hasn't yet set up the log.

Link: https://lore.kernel.org/linux-xfs/ZOLzgBOuyWHapOyZ@dread.disaster.area/T/
Link: https://lore.kernel.org/lkml/877cuj1mt1.ffs@tglx/
Link: https://lore.kernel.org/lkml/20230414162755.281993820@linutronix.de/
Link: https://lore.kernel.org/linux-xfs/ZOVkjxWZq0YmjrJu@dread.disaster.area/T/
Cc: tglx@linutronix.de
Cc: peterz@infradead.org
Reported-by: ritesh.list@gmail.com
Reported-by: sandeen@sandeen.net
Fixes: af1c2146a50b ("xfs: introduce per-cpu CIL tracking structure")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_cil.c  |   50 +++++++++++++++----------------------------------
 fs/xfs/xfs_log_priv.h |   14 ++++++--------
 fs/xfs/xfs_super.c    |    1 -
 3 files changed, 21 insertions(+), 44 deletions(-)


diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index eccbfb99e894..6eb767a49188 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -124,7 +124,7 @@ xlog_cil_push_pcp_aggregate(
 	struct xlog_cil_pcp	*cilpcp;
 	int			cpu;
 
-	for_each_online_cpu(cpu) {
+	for_each_cpu(cpu, &ctx->cil_pcpmask) {
 		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
 
 		ctx->ticket->t_curr_res += cilpcp->space_reserved;
@@ -165,7 +165,13 @@ xlog_cil_insert_pcp_aggregate(
 	if (!test_and_clear_bit(XLOG_CIL_PCP_SPACE, &cil->xc_flags))
 		return;
 
-	for_each_online_cpu(cpu) {
+	/*
+	 * We can race with other cpus setting cil_pcpmask.  However, we've
+	 * atomically cleared PCP_SPACE which forces other threads to add to
+	 * the global space used count.  cil_pcpmask is a superset of cilpcp
+	 * structures that could have a nonzero space_used.
+	 */
+	for_each_cpu(cpu, &ctx->cil_pcpmask) {
 		int	old, prev;
 
 		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
@@ -554,6 +560,7 @@ xlog_cil_insert_items(
 	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
 	int			space_used;
 	int			order;
+	unsigned int		cpu_nr;
 	struct xlog_cil_pcp	*cilpcp;
 
 	ASSERT(tp);
@@ -577,7 +584,12 @@ xlog_cil_insert_items(
 	 * can't be scheduled away between split sample/update operations that
 	 * are done without outside locking to serialise them.
 	 */
-	cilpcp = get_cpu_ptr(cil->xc_pcp);
+	cpu_nr = get_cpu();
+	cilpcp = this_cpu_ptr(cil->xc_pcp);
+
+	/* Tell the future push that there was work added by this CPU. */
+	if (!cpumask_test_cpu(cpu_nr, &ctx->cil_pcpmask))
+		cpumask_test_and_set_cpu(cpu_nr, &ctx->cil_pcpmask);
 
 	/*
 	 * We need to take the CIL checkpoint unit reservation on the first
@@ -1790,38 +1802,6 @@ xlog_cil_force_seq(
 	return 0;
 }
 
-/*
- * Move dead percpu state to the relevant CIL context structures.
- *
- * We have to lock the CIL context here to ensure that nothing is modifying
- * the percpu state, either addition or removal. Both of these are done under
- * the CIL context lock, so grabbing that exclusively here will ensure we can
- * safely drain the cilpcp for the CPU that is dying.
- */
-void
-xlog_cil_pcp_dead(
-	struct xlog		*log,
-	unsigned int		cpu)
-{
-	struct xfs_cil		*cil = log->l_cilp;
-	struct xlog_cil_pcp	*cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
-	struct xfs_cil_ctx	*ctx;
-
-	down_write(&cil->xc_ctx_lock);
-	ctx = cil->xc_ctx;
-	if (ctx->ticket)
-		ctx->ticket->t_curr_res += cilpcp->space_reserved;
-	cilpcp->space_reserved = 0;
-
-	if (!list_empty(&cilpcp->log_items))
-		list_splice_init(&cilpcp->log_items, &ctx->log_items);
-	if (!list_empty(&cilpcp->busy_extents))
-		list_splice_init(&cilpcp->busy_extents, &ctx->busy_extents);
-	atomic_add(cilpcp->space_used, &ctx->space_used);
-	cilpcp->space_used = 0;
-	up_write(&cil->xc_ctx_lock);
-}
-
 /*
  * Perform initial CIL structure initialisation.
  */
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 1bd2963e8fbd..af87648331d5 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -231,6 +231,12 @@ struct xfs_cil_ctx {
 	struct work_struct	discard_endio_work;
 	struct work_struct	push_work;
 	atomic_t		order_id;
+
+	/*
+	 * CPUs that could have added items to the percpu CIL data.  Access is
+	 * coordinated with xc_ctx_lock.
+	 */
+	struct cpumask		cil_pcpmask;
 };
 
 /*
@@ -278,9 +284,6 @@ struct xfs_cil {
 	wait_queue_head_t	xc_push_wait;	/* background push throttle */
 
 	void __percpu		*xc_pcp;	/* percpu CIL structures */
-#ifdef CONFIG_HOTPLUG_CPU
-	struct list_head	xc_pcp_list;
-#endif
 } ____cacheline_aligned_in_smp;
 
 /* xc_flags bit values */
@@ -705,9 +708,4 @@ xlog_kvmalloc(
 	return p;
 }
 
-/*
- * CIL CPU dead notifier
- */
-void xlog_cil_pcp_dead(struct xlog *log, unsigned int cpu);
-
 #endif	/* __XFS_LOG_PRIV_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 09638e8fb4ee..ef7775657ce3 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2313,7 +2313,6 @@ xfs_cpu_dead(
 	list_for_each_entry_safe(mp, n, &xfs_mount_list, m_mount_list) {
 		spin_unlock(&xfs_mount_list_lock);
 		xfs_inodegc_cpu_dead(mp, cpu);
-		xlog_cil_pcp_dead(mp->m_log, cpu);
 		spin_lock(&xfs_mount_list_lock);
 	}
 	spin_unlock(&xfs_mount_list_lock);

