Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3DDEC6FA8F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240767AbjH2XHU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241191AbjH2XHC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:07:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E2DCC4
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 16:06:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6445060B21
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 23:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF185C433C7;
        Tue, 29 Aug 2023 23:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350418;
        bh=Ogk2uVK/ahlVLPGNdH8i1fN8hG2/yEGI59GZhODlbEo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YIBk2WSPOF1OVObRtXAT0Ijp8nO8mAWRc/gl9HGJhui0K6qUGmmmxkhejWHgzwFbx
         P7TypB3UVp+r5NEMA0ch90lUeFHxDOU5cuVsSsWFgJHn+gar8NkZRSFfXvVrgaYAJz
         Wa+iLFOJsmshpEugBmyGTQzSHZkpMzrsKDVpeQtf3AmPRUvn6r6meDR/yBnnoVEMXb
         ecXn6v/4A19ymoXWCDBf+ghwUEsFpW08EymUr08rLhfuEOsUJo3P+Y8jI33cmnvMHA
         FBOKEysnxk8RASpB6bB5XAm+VBFI7dX87K8GUBTbT1mRAM8R+hkkytfKgyGr73bTPE
         6LwaNR1ZsN0hw==
Subject: [PATCH 2/4] xfs: use per-mount cpumask to track nonempty percpu
 inodegc lists
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@gmail.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        ritesh.list@gmail.com, sandeen@sandeen.net
Date:   Tue, 29 Aug 2023 16:06:58 -0700
Message-ID: <169335041825.3522698.1772829428435743789.stgit@frogsfrogsfrogs>
In-Reply-To: <169335040678.3522698.12786707653439539265.stgit@frogsfrogsfrogs>
References: <169335040678.3522698.12786707653439539265.stgit@frogsfrogsfrogs>
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
 fs/xfs/xfs_icache.c |   78 ++++++++++++++++++---------------------------------
 fs/xfs/xfs_icache.h |    1 -
 fs/xfs/xfs_mount.h  |    6 +++-
 fs/xfs/xfs_super.c  |    4 +--
 4 files changed, 33 insertions(+), 56 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e541f5c0bc25..30d7454a9b93 100644
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
@@ -1845,9 +1845,17 @@ xfs_inodegc_worker(
 						struct xfs_inodegc, work);
 	struct llist_node	*node = llist_del_all(&gc->list);
 	struct xfs_inode	*ip, *n;
+	struct xfs_mount	*mp = gc->mp;
 	unsigned int		nofs_flag;
 
-	ASSERT(gc->cpu == smp_processor_id());
+	/*
+	 * Clear the cpu mask bit and ensure that we have seen the latest
+	 * update of the gc structure associated with this CPU. This matches
+	 * with the release semantics used when setting the cpumask bit in
+	 * xfs_inodegc_queue.
+	 */
+	cpumask_clear_cpu(gc->cpu, &mp->m_inodegc_cpumask);
+	smp_mb__after_atomic();
 
 	WRITE_ONCE(gc->items, 0);
 
@@ -1862,7 +1870,7 @@ xfs_inodegc_worker(
 	nofs_flag = memalloc_nofs_save();
 
 	ip = llist_entry(node, struct xfs_inode, i_gclist);
-	trace_xfs_inodegc_worker(ip->i_mount, READ_ONCE(gc->shrinker_hits));
+	trace_xfs_inodegc_worker(mp, READ_ONCE(gc->shrinker_hits));
 
 	WRITE_ONCE(gc->shrinker_hits, 0);
 	llist_for_each_entry_safe(ip, n, node, i_gclist) {
@@ -2057,6 +2065,7 @@ xfs_inodegc_queue(
 	struct xfs_inodegc	*gc;
 	int			items;
 	unsigned int		shrinker_hits;
+	unsigned int		cpu_nr;
 	unsigned long		queue_delay = 1;
 
 	trace_xfs_inode_set_need_inactive(ip);
@@ -2064,18 +2073,28 @@ xfs_inodegc_queue(
 	ip->i_flags |= XFS_NEED_INACTIVE;
 	spin_unlock(&ip->i_flags_lock);
 
-	gc = get_cpu_ptr(mp->m_inodegc);
+	cpu_nr = get_cpu();
+	gc = this_cpu_ptr(mp->m_inodegc);
 	llist_add(&ip->i_gclist, &gc->list);
 	items = READ_ONCE(gc->items);
 	WRITE_ONCE(gc->items, items + 1);
 	shrinker_hits = READ_ONCE(gc->shrinker_hits);
 
+	/*
+	 * Ensure the list add is always seen by anyone who finds the cpumask
+	 * bit set. This effectively gives the cpumask bit set operation
+	 * release ordering semantics.
+	 */
+	smp_mb__before_atomic();
+	if (!cpumask_test_cpu(cpu_nr, &mp->m_inodegc_cpumask))
+		cpumask_test_and_set_cpu(cpu_nr, &mp->m_inodegc_cpumask);
+
 	/*
 	 * We queue the work while holding the current CPU so that the work
 	 * is scheduled to run on this CPU.
 	 */
 	if (!xfs_is_inodegc_enabled(mp)) {
-		put_cpu_ptr(gc);
+		put_cpu();
 		return;
 	}
 
@@ -2085,7 +2104,7 @@ xfs_inodegc_queue(
 	trace_xfs_inodegc_queue(mp, __return_address);
 	mod_delayed_work_on(current_cpu(), mp->m_inodegc_wq, &gc->work,
 			queue_delay);
-	put_cpu_ptr(gc);
+	put_cpu();
 
 	if (xfs_inodegc_want_flush_work(ip, items, shrinker_hits)) {
 		trace_xfs_inodegc_throttle(mp, __return_address);
@@ -2093,47 +2112,6 @@ xfs_inodegc_queue(
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
@@ -2195,7 +2173,7 @@ xfs_inodegc_shrinker_count(
 	if (!xfs_is_inodegc_enabled(mp))
 		return 0;
 
-	for_each_online_cpu(cpu) {
+	for_each_cpu(cpu, &mp->m_inodegc_cpumask) {
 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
 		if (!llist_empty(&gc->list))
 			return XFS_INODEGC_SHRINKER_COUNT;
@@ -2220,7 +2198,7 @@ xfs_inodegc_shrinker_scan(
 
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

