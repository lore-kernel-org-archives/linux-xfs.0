Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77832C4338F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 02:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 606B461078
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 02:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238146AbhHECHx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Aug 2021 22:07:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238157AbhHECHx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Aug 2021 22:07:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 277146105A;
        Thu,  5 Aug 2021 02:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628129260;
        bh=FAgU+HEbsXK4K8T8RScmhBbTwiLIfjGq6BN9gfYg3hI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rHK2xhsSc/oDlLVSZ8Ryhbhse8neBsYidP21souchjBdoVnDtCjZzbkNiOsoOv3f3
         Jawle+/lG0GE9bdbyAZm666q/N82v60jb61a0v8f+MxpGpGuMX04En6b+pCxoFmc11
         tUITYajXrqDeaE+bZ7u3IZTv1LgUo3EG/kovf7pdW1jGDvgs0p46toeNjcTKf+UI8v
         PDUzhVBx9f/Hn2rg/C3gNDxMghokw2yrLfRlavjRpnK6LswYUT4BJiV7Qb1DL2ICer
         Wc04mDhNVI7wKEltr9WY5nEw7mU5lIii36j8nhGkyQDGBJ+5y8yokz8EPlPuA3jksS
         /yvEZg+4eF5oA==
Subject: [PATCH 14/14] xfs: throttle inode inactivation queuing on memory
 reclaim
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Wed, 04 Aug 2021 19:07:39 -0700
Message-ID: <162812925986.2589546.10269888087074473602.stgit@magnolia>
In-Reply-To: <162812918259.2589546.16599271324044986858.stgit@magnolia>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we defer inode inactivation, we've decoupled the process of
unlinking or closing an inode from the process of inactivating it.  In
theory this should lead to better throughput since we now inactivate the
queued inodes in batches instead of one at a time.

Unfortunately, one of the primary risks with this decoupling is the loss
of rate control feedback between the frontend and background threads.
In other words, a rm -rf /* thread can run the system out of memory if
it can queue inodes for inactivation and jump to a new CPU faster than
the background threads can actually clear the deferred work.  The
workers can get scheduled off the CPU if they have to do IO, etc.

To solve this problem, we configure a shrinker so that it will activate
the /second/ time the shrinkers are called.  The custom shrinker will
queue all percpu deferred inactivation workers immediately and set a
flag to force frontend callers who are releasing a vfs inode to wait for
the inactivation workers.

On my test VM with 560M of RAM and a 2TB filesystem, this seems to solve
most of the OOMing problem when deleting 10 million inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |  102 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_icache.h |    1 +
 fs/xfs/xfs_mount.c  |    9 ++++-
 fs/xfs/xfs_mount.h  |    3 ++
 fs/xfs/xfs_trace.h  |   37 ++++++++++++++++++-
 5 files changed, 147 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f5a4f4d64c50..6741e27603ad 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1908,8 +1908,9 @@ xfs_inodegc_worker(
 		return;
 
 	ip = llist_entry(node, struct xfs_inode, i_gclist);
-	trace_xfs_inodegc_worker(ip->i_mount, __return_address);
+	trace_xfs_inodegc_worker(ip->i_mount, READ_ONCE(gc->shrinker_hits));
 
+	WRITE_ONCE(gc->shrinker_hits, 0);
 	llist_for_each_entry_safe(ip, n, node, i_gclist) {
 		xfs_iflags_set(ip, XFS_INACTIVATING);
 		xfs_inodegc_inactivate(ip);
@@ -2046,13 +2047,18 @@ xfs_inodegc_want_queue_work(
 /*
  * Make the frontend wait for inactivations when:
  *
+ *  - Memory shrinkers queued the inactivation worker and it hasn't finished.
  *  - The queue depth exceeds the maximum allowable percpu backlog.
  */
 static inline bool
 xfs_inodegc_want_flush_work(
 	struct xfs_inode	*ip,
-	unsigned int		items)
+	unsigned int		items,
+	unsigned int		shrinker_hits)
 {
+	if (shrinker_hits > 0)
+		return true;
+
 	if (items > XFS_INODEGC_MAX_BACKLOG)
 		return true;
 
@@ -2071,6 +2077,7 @@ xfs_inodegc_queue(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_inodegc	*gc;
 	int			items;
+	unsigned int		shrinker_hits;
 
 	trace_xfs_inode_set_need_inactive(ip);
 	spin_lock(&ip->i_flags_lock);
@@ -2081,6 +2088,7 @@ xfs_inodegc_queue(
 	llist_add(&ip->i_gclist, &gc->list);
 	items = READ_ONCE(gc->items);
 	WRITE_ONCE(gc->items, items + 1);
+	shrinker_hits = READ_ONCE(gc->shrinker_hits);
 	put_cpu_ptr(gc);
 
 	if (!xfs_is_inodegc_enabled(mp))
@@ -2091,7 +2099,7 @@ xfs_inodegc_queue(
 		queue_work(mp->m_inodegc_wq, &gc->work);
 	}
 
-	if (xfs_inodegc_want_flush_work(ip, items)) {
+	if (xfs_inodegc_want_flush_work(ip, items, shrinker_hits)) {
 		trace_xfs_inodegc_throttle(mp, __return_address);
 		flush_work(&gc->work);
 	}
@@ -2169,3 +2177,91 @@ xfs_inode_mark_reclaimable(
 	xfs_qm_dqdetach(ip);
 	xfs_inodegc_set_reclaimable(ip);
 }
+
+/*
+ * Register a phony shrinker so that we can run background inodegc sooner when
+ * there's memory pressure.  Inactivation does not itself free any memory but
+ * it does make inodes reclaimable, which eventually frees memory.
+ *
+ * The count function, seek value, and batch value are crafted to trigger the
+ * scan function during the second round of scanning.  Hopefully this means
+ * that we reclaimed enough memory that initiating metadata transactions won't
+ * make things worse.
+ */
+#define XFS_INODEGC_SHRINKER_COUNT	(1UL << DEF_PRIORITY)
+#define XFS_INODEGC_SHRINKER_BATCH	((XFS_INODEGC_SHRINKER_COUNT / 2) + 1)
+
+static unsigned long
+xfs_inodegc_shrinker_count(
+	struct shrinker		*shrink,
+	struct shrink_control	*sc)
+{
+	struct xfs_mount	*mp = container_of(shrink, struct xfs_mount,
+						   m_inodegc_shrinker);
+	struct xfs_inodegc	*gc;
+	int			cpu;
+
+	if (!xfs_is_inodegc_enabled(mp))
+		return 0;
+
+	for_each_online_cpu(cpu) {
+		gc = per_cpu_ptr(mp->m_inodegc, cpu);
+		if (!llist_empty(&gc->list))
+			return XFS_INODEGC_SHRINKER_COUNT;
+	}
+
+	return 0;
+}
+
+static unsigned long
+xfs_inodegc_shrinker_scan(
+	struct shrinker		*shrink,
+	struct shrink_control	*sc)
+{
+	struct xfs_mount	*mp = container_of(shrink, struct xfs_mount,
+						   m_inodegc_shrinker);
+	struct xfs_inodegc	*gc;
+	int			cpu;
+	bool			no_items = true;
+
+	if (!xfs_is_inodegc_enabled(mp))
+		return SHRINK_STOP;
+
+	trace_xfs_inodegc_shrinker_scan(mp, sc, __return_address);
+
+	for_each_online_cpu(cpu) {
+		gc = per_cpu_ptr(mp->m_inodegc, cpu);
+		if (!llist_empty(&gc->list)) {
+			unsigned int	h = READ_ONCE(gc->shrinker_hits);
+
+			WRITE_ONCE(gc->shrinker_hits, h + 1);
+			queue_work_on(cpu, mp->m_inodegc_wq, &gc->work);
+			no_items = false;
+		}
+	}
+
+	/*
+	 * If there are no inodes to inactivate, we don't want the shrinker
+	 * to think there's deferred work to call us back about.
+	 */
+	if (no_items)
+		return LONG_MAX;
+
+	return SHRINK_STOP;
+}
+
+/* Register a shrinker so we can accelerate inodegc and throttle queuing. */
+int
+xfs_inodegc_register_shrinker(
+	struct xfs_mount	*mp)
+{
+	struct shrinker		*shrink = &mp->m_inodegc_shrinker;
+
+	shrink->count_objects = xfs_inodegc_shrinker_count;
+	shrink->scan_objects = xfs_inodegc_shrinker_scan;
+	shrink->seeks = 0;
+	shrink->flags = SHRINKER_NONSLAB;
+	shrink->batch = XFS_INODEGC_SHRINKER_BATCH;
+
+	return register_shrinker(shrink);
+}
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 18c2d224aa78..2e4cfddf8b8e 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -80,5 +80,6 @@ void xfs_inodegc_flush(struct xfs_mount *mp);
 void xfs_inodegc_stop(struct xfs_mount *mp);
 void xfs_inodegc_start(struct xfs_mount *mp);
 void xfs_inodegc_cpu_dead(struct xfs_mount *mp, unsigned int cpu);
+int xfs_inodegc_register_shrinker(struct xfs_mount *mp);
 
 #endif
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b81f2fc734bd..ff08192d8d2a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -769,6 +769,10 @@ xfs_mountfs(
 		goto out_free_perag;
 	}
 
+	error = xfs_inodegc_register_shrinker(mp);
+	if (error)
+		goto out_fail_wait;
+
 	/*
 	 * Log's mount-time initialization. The first part of recovery can place
 	 * some items on the AIL, to be handled when recovery is finished or
@@ -779,7 +783,7 @@ xfs_mountfs(
 			      XFS_FSB_TO_BB(mp, sbp->sb_logblocks));
 	if (error) {
 		xfs_warn(mp, "log mount failed");
-		goto out_fail_wait;
+		goto out_inodegc_shrinker;
 	}
 
 	/* Make sure the summary counts are ok. */
@@ -974,6 +978,8 @@ xfs_mountfs(
 	xfs_unmount_flush_inodes(mp);
  out_log_dealloc:
 	xfs_log_mount_cancel(mp);
+ out_inodegc_shrinker:
+	unregister_shrinker(&mp->m_inodegc_shrinker);
  out_fail_wait:
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_buftarg_drain(mp->m_logdev_targp);
@@ -1054,6 +1060,7 @@ xfs_unmountfs(
 #if defined(DEBUG)
 	xfs_errortag_clearall(mp);
 #endif
+	unregister_shrinker(&mp->m_inodegc_shrinker);
 	xfs_free_perag(mp);
 
 	xfs_errortag_del(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 797b8068dfe6..3eb7b06f2eff 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -63,6 +63,7 @@ struct xfs_inodegc {
 	struct llist_head	list;
 	struct work_struct	work;
 	unsigned int		items;
+	unsigned int		shrinker_hits;
 };
 
 /*
@@ -208,6 +209,8 @@ typedef struct xfs_mount {
 	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
 	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
 
+	/* Memory shrinker to throttle and reprioritize inodegc */
+	struct shrinker		m_inodegc_shrinker;
 	/*
 	 * Workqueue item so that we can coalesce multiple inode flush attempts
 	 * into a single flush.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0a179cfc35c0..90ae884bfee6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -157,6 +157,22 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_put);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_inode_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
 
+TRACE_EVENT(xfs_inodegc_worker,
+	TP_PROTO(struct xfs_mount *mp, unsigned int shrinker_hits),
+	TP_ARGS(mp, shrinker_hits),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, shrinker_hits)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->shrinker_hits = shrinker_hits;
+	),
+	TP_printk("dev %d:%d shrinker_hits %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->shrinker_hits)
+);
+
 #define XFS_STATE_FLAGS \
 	{ (1UL << XFS_STATE_INODEGC_ENABLED),		"inodegc" }, \
 	{ (1UL << XFS_STATE_BLOCKGC_ENABLED),		"blockgc" }
@@ -195,7 +211,6 @@ DEFINE_EVENT(xfs_fs_class, name,					\
 DEFINE_FS_EVENT(xfs_inodegc_flush);
 DEFINE_FS_EVENT(xfs_inodegc_start);
 DEFINE_FS_EVENT(xfs_inodegc_stop);
-DEFINE_FS_EVENT(xfs_inodegc_worker);
 DEFINE_FS_EVENT(xfs_inodegc_queue);
 DEFINE_FS_EVENT(xfs_inodegc_throttle);
 DEFINE_FS_EVENT(xfs_fs_sync_fs);
@@ -204,6 +219,26 @@ DEFINE_FS_EVENT(xfs_blockgc_stop);
 DEFINE_FS_EVENT(xfs_blockgc_worker);
 DEFINE_FS_EVENT(xfs_blockgc_flush_all);
 
+TRACE_EVENT(xfs_inodegc_shrinker_scan,
+	TP_PROTO(struct xfs_mount *mp, struct shrink_control *sc,
+		 void *caller_ip),
+	TP_ARGS(mp, sc, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long, nr_to_scan)
+		__field(void *, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->nr_to_scan = sc->nr_to_scan;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d nr_to_scan %lu caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->nr_to_scan,
+		  __entry->caller_ip)
+);
+
 DECLARE_EVENT_CLASS(xfs_ag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),
 	TP_ARGS(mp, agno),

