Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2EE3C88CB2
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244024AbjHXXVr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244039AbjHXXV3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 19:21:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E50DE59
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 16:21:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D4FB64B19
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 23:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6393CC433C9;
        Thu, 24 Aug 2023 23:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692919286;
        bh=LxVktdgTRhetM6D25+6aFGSUb4HeBBWzyEUbAWMLKs4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MMV7iLlRhoJgxcb5wQ6fNZ5Xnqx2JwqxB7sfC2GmuK15+sdRmQrZ/u+H68Pg6ihSq
         ndttJ5GCQKeB/iAyI087yaeZUBWTVviFjOZOySMjA32KxKvZZY0tdA5qv2gGy6ZxdW
         nWL52UeCr7JGGBTBjD0DPI/XWd6mxLnDuSI8bjQwSa84uCIFN040XNGquSTL9CTzKr
         2GNToIUUyg+dxUhvhERmEStOqpcfdpQfHUEPTgckr+PdrAFq4XCVo4mO9Il7CzYlty
         aUus35GH4u1FZcYLq90x+zb3zzBQ2fypuSxr5WYAtC6sdsbPyKpcAfew/SqjpowTQS
         PMxc08lWT0lyA==
Subject: [PATCH 2/3] xfs: use per-mount cpumask to track nonempty percpu
 inodegc lists
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        ritesh.list@gmail.com, sandeen@sandeen.net
Date:   Thu, 24 Aug 2023 16:21:25 -0700
Message-ID: <169291928586.219974.10915745531517859853.stgit@frogsfrogsfrogs>
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

Directly track which CPUs have contributed to the inodegc percpu lists
instead of trusting the cpu online mask.  This eliminates a theoretical
problem where the inodegc flush functions might fail to flush a CPU's
inodes if that CPU happened to be dying at exactly the same time.  Most
likely nobody's noticed this because the CPU dead hook moves the percpu
inodegc list to another CPU and schedules that worker immediately.  But
it's quite possible that this is a subtle race leading to UAF if the
inodegc flush were part of an unmount.

Further benefits: This reduces the overhead of the inodegc flush code
slightly by allowing us to ignore CPUs that have empty lists.  Better
yet, it reduces our dependence on the cpu online masks, which have been
the cause of confusion and drama lately.

Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   60 +++++++++++----------------------------------------
 fs/xfs/xfs_icache.h |    1 -
 fs/xfs/xfs_mount.h  |    6 +++--
 fs/xfs/xfs_super.c  |    4 +--
 4 files changed, 18 insertions(+), 53 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e541f5c0bc25..7fd876e94ecb 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -443,7 +443,7 @@ xfs_inodegc_queue_all(
 	int			cpu;
 	bool			ret = false;
 
-	for_each_online_cpu(cpu) {
+	for_each_cpu(cpu, &mp->m_inodegc_cpumask) {
 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
 		if (!llist_empty(&gc->list)) {
 			mod_delayed_work_on(cpu, mp->m_inodegc_wq, &gc->work, 0);
@@ -463,7 +463,7 @@ xfs_inodegc_wait_all(
 	int			error = 0;
 
 	flush_workqueue(mp->m_inodegc_wq);
-	for_each_online_cpu(cpu) {
+	for_each_cpu(cpu, &mp->m_inodegc_cpumask) {
 		struct xfs_inodegc	*gc;
 
 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
@@ -1845,10 +1845,12 @@ xfs_inodegc_worker(
 						struct xfs_inodegc, work);
 	struct llist_node	*node = llist_del_all(&gc->list);
 	struct xfs_inode	*ip, *n;
+	struct xfs_mount	*mp = gc->mp;
 	unsigned int		nofs_flag;
 
 	ASSERT(gc->cpu == smp_processor_id());
 
+	cpumask_test_and_clear_cpu(gc->cpu, &mp->m_inodegc_cpumask);
 	WRITE_ONCE(gc->items, 0);
 
 	if (!node)
@@ -1862,7 +1864,7 @@ xfs_inodegc_worker(
 	nofs_flag = memalloc_nofs_save();
 
 	ip = llist_entry(node, struct xfs_inode, i_gclist);
-	trace_xfs_inodegc_worker(ip->i_mount, READ_ONCE(gc->shrinker_hits));
+	trace_xfs_inodegc_worker(mp, READ_ONCE(gc->shrinker_hits));
 
 	WRITE_ONCE(gc->shrinker_hits, 0);
 	llist_for_each_entry_safe(ip, n, node, i_gclist) {
@@ -2057,6 +2059,7 @@ xfs_inodegc_queue(
 	struct xfs_inodegc	*gc;
 	int			items;
 	unsigned int		shrinker_hits;
+	unsigned int		cpu_nr;
 	unsigned long		queue_delay = 1;
 
 	trace_xfs_inode_set_need_inactive(ip);
@@ -2064,12 +2067,16 @@ xfs_inodegc_queue(
 	ip->i_flags |= XFS_NEED_INACTIVE;
 	spin_unlock(&ip->i_flags_lock);
 
-	gc = get_cpu_ptr(mp->m_inodegc);
+	cpu_nr = get_cpu();
+	gc = this_cpu_ptr(mp->m_inodegc);
 	llist_add(&ip->i_gclist, &gc->list);
 	items = READ_ONCE(gc->items);
 	WRITE_ONCE(gc->items, items + 1);
 	shrinker_hits = READ_ONCE(gc->shrinker_hits);
 
+	if (!cpumask_test_cpu(cpu_nr, &mp->m_inodegc_cpumask))
+		cpumask_test_and_set_cpu(cpu_nr, &mp->m_inodegc_cpumask);
+
 	/*
 	 * We queue the work while holding the current CPU so that the work
 	 * is scheduled to run on this CPU.
@@ -2093,47 +2100,6 @@ xfs_inodegc_queue(
 	}
 }
 
-/*
- * Fold the dead CPU inodegc queue into the current CPUs queue.
- */
-void
-xfs_inodegc_cpu_dead(
-	struct xfs_mount	*mp,
-	unsigned int		dead_cpu)
-{
-	struct xfs_inodegc	*dead_gc, *gc;
-	struct llist_node	*first, *last;
-	unsigned int		count = 0;
-
-	dead_gc = per_cpu_ptr(mp->m_inodegc, dead_cpu);
-	cancel_delayed_work_sync(&dead_gc->work);
-
-	if (llist_empty(&dead_gc->list))
-		return;
-
-	first = dead_gc->list.first;
-	last = first;
-	while (last->next) {
-		last = last->next;
-		count++;
-	}
-	dead_gc->list.first = NULL;
-	dead_gc->items = 0;
-
-	/* Add pending work to current CPU */
-	gc = get_cpu_ptr(mp->m_inodegc);
-	llist_add_batch(first, last, &gc->list);
-	count += READ_ONCE(gc->items);
-	WRITE_ONCE(gc->items, count);
-
-	if (xfs_is_inodegc_enabled(mp)) {
-		trace_xfs_inodegc_queue(mp, __return_address);
-		mod_delayed_work_on(current_cpu(), mp->m_inodegc_wq, &gc->work,
-				0);
-	}
-	put_cpu_ptr(gc);
-}
-
 /*
  * We set the inode flag atomically with the radix tree tag.  Once we get tag
  * lookups on the radix tree, this inode flag can go away.
@@ -2195,7 +2161,7 @@ xfs_inodegc_shrinker_count(
 	if (!xfs_is_inodegc_enabled(mp))
 		return 0;
 
-	for_each_online_cpu(cpu) {
+	for_each_cpu(cpu, &mp->m_inodegc_cpumask) {
 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
 		if (!llist_empty(&gc->list))
 			return XFS_INODEGC_SHRINKER_COUNT;
@@ -2220,7 +2186,7 @@ xfs_inodegc_shrinker_scan(
 
 	trace_xfs_inodegc_shrinker_scan(mp, sc, __return_address);
 
-	for_each_online_cpu(cpu) {
+	for_each_cpu(cpu, &mp->m_inodegc_cpumask) {
 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
 		if (!llist_empty(&gc->list)) {
 			unsigned int	h = READ_ONCE(gc->shrinker_hits);
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 2fa6f2e09d07..905944dafbe5 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -79,7 +79,6 @@ void xfs_inodegc_push(struct xfs_mount *mp);
 int xfs_inodegc_flush(struct xfs_mount *mp);
 void xfs_inodegc_stop(struct xfs_mount *mp);
 void xfs_inodegc_start(struct xfs_mount *mp);
-void xfs_inodegc_cpu_dead(struct xfs_mount *mp, unsigned int cpu);
 int xfs_inodegc_register_shrinker(struct xfs_mount *mp);
 
 #endif
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a25eece3be2b..f4a8879ba0e9 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -60,6 +60,7 @@ struct xfs_error_cfg {
  * Per-cpu deferred inode inactivation GC lists.
  */
 struct xfs_inodegc {
+	struct xfs_mount	*mp;
 	struct llist_head	list;
 	struct delayed_work	work;
 	int			error;
@@ -67,9 +68,7 @@ struct xfs_inodegc {
 	/* approximate count of inodes in the list */
 	unsigned int		items;
 	unsigned int		shrinker_hits;
-#if defined(DEBUG) || defined(XFS_WARN)
 	unsigned int		cpu;
-#endif
 };
 
 /*
@@ -249,6 +248,9 @@ typedef struct xfs_mount {
 	unsigned int		*m_errortag;
 	struct xfs_kobj		m_errortag_kobj;
 #endif
+
+	/* cpus that have inodes queued for inactivation */
+	struct cpumask		m_inodegc_cpumask;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ef7775657ce3..6a4f8b2f6159 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1110,9 +1110,8 @@ xfs_inodegc_init_percpu(
 
 	for_each_possible_cpu(cpu) {
 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
-#if defined(DEBUG) || defined(XFS_WARN)
 		gc->cpu = cpu;
-#endif
+		gc->mp = mp;
 		init_llist_head(&gc->list);
 		gc->items = 0;
 		gc->error = 0;
@@ -2312,7 +2311,6 @@ xfs_cpu_dead(
 	spin_lock(&xfs_mount_list_lock);
 	list_for_each_entry_safe(mp, n, &xfs_mount_list, m_mount_list) {
 		spin_unlock(&xfs_mount_list_lock);
-		xfs_inodegc_cpu_dead(mp, cpu);
 		spin_lock(&xfs_mount_list_lock);
 	}
 	spin_unlock(&xfs_mount_list_lock);

