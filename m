Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46973C432BE
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:44:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B87660F5C
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhG2SoT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:44:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhG2SoT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 14:44:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F245560249;
        Thu, 29 Jul 2021 18:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627584256;
        bh=3q7S9MY4ENDpwWwusOYdSBRN+bhuVerwrc+Eb7qr5bo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e7iLNa3A0VbsEkCvfl+V7qmsSsy5kLa0vzyPh7O9NfjVH07lnUrMs3svlJovGY9Dv
         8P2g/Vo4xF6x2VooBqZdHfv+XCs8lGXOmvyELzKGr6nHzI8CzhEe15szvqgFIlVwlc
         bL5vHZcVA7SjHMu3xnjAFQACDzUNEoSJ6Z5GjANmTRaQIkoFvp0dkj93T1Riif3Jej
         4ckL7M30xhreQs6lwmZUpEZ9099TPX73MAbE2sPSGL0ugPjgOiO9N6zwcWZdoFhu13
         CBPKp/IoRokt+qZiom3V4RQegfPa7YyOcI0E2eL19M6/LbcuQDBTgqBWAZWdLDY2Ny
         n+F9u6OOdCujQ==
Subject: [PATCH 04/20] xfs: throttle inode inactivation queuing on memory
 reclaim
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 29 Jul 2021 11:44:15 -0700
Message-ID: <162758425567.332903.11405524237817456079.stgit@magnolia>
In-Reply-To: <162758423315.332903.16799817941903734904.stgit@magnolia>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
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
queued inodes in disk order.

Unfortunately, one of the primary risks with this decoupling is the loss
of rate control feedback between the frontend and background threads.
In other words, if a rm -rf /* thread can load inodes into cache and
schedule them for inactivation faster than we can inactivate them, we
can easily OOM the system.  Currently, we throttle frontend processes
by forcing them to flush_work the background processes.

However, this leaves plenty of performance on the table if we have
enough memory to allow for some caching of inodes.  We can relax the
coupling by only throttling processes that are trying to queue inodes
for inactivation if the system is under memory pressure.  This makes
inactivation more bursty on my system, but raises throughput.

To make this work smoothly, we register a new faux shrinker, and
configure it carefully such that the scan function will turn on and
throttle the /second/ time the shrinker gets called by reclaim and there
are inodes queued for inactivation.

On my test VM with 960M of RAM and a 2TB filesystem, the time to delete
10 million inodes decreases from ~28 minutes to ~23 minutes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |  105 ++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_icache.h |    1 
 fs/xfs/xfs_mount.c  |    9 ++++
 fs/xfs/xfs_mount.h  |    7 +++
 fs/xfs/xfs_super.c  |    1 
 fs/xfs/xfs_trace.h  |   35 +++++++++++++++++
 6 files changed, 150 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e97404d2f63a..3e2302a44c69 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -344,6 +344,26 @@ xfs_check_delalloc(
 #define xfs_check_delalloc(ip, whichfork)	do { } while (0)
 #endif
 
+/*
+ * Decide if we're going to throttle frontend threads that are inactivating
+ * inodes so that we don't overwhelm the background workers with inodes and OOM
+ * the machine.
+ */
+static inline bool
+xfs_inodegc_want_throttle(
+	struct xfs_perag	*pag)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	/* Throttle if memory reclaim anywhere has triggered us. */
+	if (atomic_read(&mp->m_inodegc_reclaim) > 0) {
+		trace_xfs_inodegc_throttle_mempressure(mp);
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * We set the inode flag atomically with the radix tree tag.
  * Once we get tag lookups on the radix tree, this inode flag
@@ -357,6 +377,7 @@ xfs_inode_mark_reclaimable(
 	struct xfs_perag	*pag;
 	unsigned int		tag;
 	bool			need_inactive;
+	bool			flush_inodegc = false;
 
 	need_inactive = xfs_inode_needs_inactive(ip);
 	if (!need_inactive) {
@@ -392,6 +413,7 @@ xfs_inode_mark_reclaimable(
 		trace_xfs_inode_set_need_inactive(ip);
 		ip->i_flags |= XFS_NEED_INACTIVE;
 		tag = XFS_ICI_INODEGC_TAG;
+		flush_inodegc = xfs_inodegc_want_throttle(pag);
 	} else {
 		trace_xfs_inode_set_reclaimable(ip);
 		ip->i_flags |= XFS_IRECLAIMABLE;
@@ -404,13 +426,7 @@ xfs_inode_mark_reclaimable(
 	spin_unlock(&pag->pag_ici_lock);
 	xfs_perag_put(pag);
 
-	/*
-	 * Wait for the background inodegc worker if it's running so that the
-	 * frontend can't overwhelm the background workers with inodes and OOM
-	 * the machine.  We'll improve this with feedback from the rest of the
-	 * system in subsequent patches.
-	 */
-	if (need_inactive && flush_work(&mp->m_inodegc_work.work))
+	if (flush_inodegc && flush_work(&mp->m_inodegc_work.work))
 		trace_xfs_inodegc_throttled(mp, __return_address);
 }
 
@@ -1796,6 +1812,12 @@ xfs_inodegc_worker(
 		trace_xfs_inodegc_worker(mp, __return_address);
 		xfs_icwalk(mp, XFS_ICWALK_INODEGC, NULL);
 	}
+
+	/*
+	 * We inactivated all the inodes we could, so disable the throttling
+	 * of new inactivations that happens when memory gets tight.
+	 */
+	atomic_set(&mp->m_inodegc_reclaim, 0);
 }
 
 /*
@@ -1837,6 +1859,75 @@ xfs_inodegc_start(
 	xfs_inodegc_queue(mp);
 }
 
+/*
+ * Register a phony shrinker so that we can speed up background inodegc and
+ * throttle new inodegc queuing when there's memory pressure.  Inactivation
+ * does not itself free any memory but it does make inodes reclaimable, which
+ * eventually frees memory.  The count function, seek value, and batch value
+ * are crafted to trigger the scan function any time the shrinker is not being
+ * called from a background idle scan (i.e. the second time).
+ */
+#define XFS_INODEGC_SHRINK_COUNT	(1UL << DEF_PRIORITY)
+#define XFS_INODEGC_SHRINK_BATCH	(LONG_MAX)
+
+static unsigned long
+xfs_inodegc_shrink_count(
+	struct shrinker		*shrink,
+	struct shrink_control	*sc)
+{
+	struct xfs_mount	*mp;
+
+	mp = container_of(shrink, struct xfs_mount, m_inodegc_shrink);
+
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG))
+		return XFS_INODEGC_SHRINK_COUNT;
+
+	return 0;
+}
+
+static unsigned long
+xfs_inodegc_shrink_scan(
+	struct shrinker		*shrink,
+	struct shrink_control	*sc)
+{
+	struct xfs_mount	*mp;
+
+	/*
+	 * Inode inactivation work requires NOFS allocations, so don't make
+	 * things worse if the caller wanted a NOFS allocation.
+	 */
+	if (!(sc->gfp_mask & __GFP_FS))
+		return SHRINK_STOP;
+
+	mp = container_of(shrink, struct xfs_mount, m_inodegc_shrink);
+
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG)) {
+		trace_xfs_inodegc_requeue_mempressure(mp, sc->nr_to_scan,
+				__return_address);
+
+		atomic_inc(&mp->m_inodegc_reclaim);
+		mod_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work, 0);
+	}
+
+	return 0;
+}
+
+/* Register a shrinker so we can accelerate inodegc and throttle queuing. */
+int
+xfs_inodegc_register_shrinker(
+	struct xfs_mount	*mp)
+{
+	struct shrinker		*shrink = &mp->m_inodegc_shrink;
+
+	shrink->count_objects = xfs_inodegc_shrink_count;
+	shrink->scan_objects = xfs_inodegc_shrink_scan;
+	shrink->seeks = 0;
+	shrink->flags = SHRINKER_NONSLAB;
+	shrink->batch = XFS_INODEGC_SHRINK_BATCH;
+
+	return register_shrinker(shrink);
+}
+
 /* XFS Inode Cache Walking Code */
 
 /*
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index c1dfc909a5b0..e38c8bc5461f 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -78,5 +78,6 @@ void xfs_inodegc_worker(struct work_struct *work);
 void xfs_inodegc_flush(struct xfs_mount *mp);
 void xfs_inodegc_stop(struct xfs_mount *mp);
 void xfs_inodegc_start(struct xfs_mount *mp);
+int xfs_inodegc_register_shrinker(struct xfs_mount *mp);
 
 #endif
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 1f7e9a608f38..ac953c486b9f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -766,6 +766,10 @@ xfs_mountfs(
 		goto out_free_perag;
 	}
 
+	error = xfs_inodegc_register_shrinker(mp);
+	if (error)
+		goto out_fail_wait;
+
 	/*
 	 * Log's mount-time initialization. The first part of recovery can place
 	 * some items on the AIL, to be handled when recovery is finished or
@@ -776,7 +780,7 @@ xfs_mountfs(
 			      XFS_FSB_TO_BB(mp, sbp->sb_logblocks));
 	if (error) {
 		xfs_warn(mp, "log mount failed");
-		goto out_fail_wait;
+		goto out_inodegc_shrink;
 	}
 
 	/* Make sure the summary counts are ok. */
@@ -970,6 +974,8 @@ xfs_mountfs(
 	xfs_unmount_flush_inodes(mp);
  out_log_dealloc:
 	xfs_log_mount_cancel(mp);
+ out_inodegc_shrink:
+	unregister_shrinker(&mp->m_inodegc_shrink);
  out_fail_wait:
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_buftarg_drain(mp->m_logdev_targp);
@@ -1050,6 +1056,7 @@ xfs_unmountfs(
 #if defined(DEBUG)
 	xfs_errortag_clearall(mp);
 #endif
+	unregister_shrinker(&mp->m_inodegc_shrink);
 	xfs_free_perag(mp);
 
 	xfs_errortag_del(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index dc906b78e24c..7844b44d45ea 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -192,6 +192,7 @@ typedef struct xfs_mount {
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
 	struct delayed_work	m_inodegc_work; /* background inode inactive */
+	struct shrinker		m_inodegc_shrink;
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
 	struct xfs_kobj		m_error_meta_kobj;
@@ -219,6 +220,12 @@ typedef struct xfs_mount {
 	uint32_t		m_generation;
 	struct mutex		m_growlock;	/* growfs mutex */
 
+	/*
+	 * How many times has the memory shrinker poked us since the last time
+	 * inodegc was queued?
+	 */
+	atomic_t		m_inodegc_reclaim;
+
 #ifdef DEBUG
 	/*
 	 * Frequency with which errors are injected.  Replaces xfs_etest; the
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f8f05d1037d2..c8207da0bb38 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1847,6 +1847,7 @@ static int xfs_init_fs_context(
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	INIT_DELAYED_WORK(&mp->m_inodegc_work, xfs_inodegc_worker);
+	atomic_set(&mp->m_inodegc_reclaim, 0);
 	mp->m_kobj.kobject.kset = xfs_kset;
 	/*
 	 * We don't create the finobt per-ag space reservation until after log
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 12ce47aebaef..eaebb070d859 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -193,6 +193,25 @@ DEFINE_FS_EVENT(xfs_inodegc_worker);
 DEFINE_FS_EVENT(xfs_inodegc_throttled);
 DEFINE_FS_EVENT(xfs_fs_sync_fs);
 
+TRACE_EVENT(xfs_inodegc_requeue_mempressure,
+	TP_PROTO(struct xfs_mount *mp, unsigned long nr, void *caller_ip),
+	TP_ARGS(mp, nr, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long, nr)
+		__field(void *, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->nr = nr;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d nr_to_scan %lu caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->nr,
+		  __entry->caller_ip)
+);
+
 DECLARE_EVENT_CLASS(xfs_gc_queue_class,
 	TP_PROTO(struct xfs_mount *mp, unsigned int delay_ms),
 	TP_ARGS(mp, delay_ms),
@@ -214,6 +233,22 @@ DEFINE_EVENT(xfs_gc_queue_class, name,	\
 	TP_ARGS(mp, delay_ms))
 DEFINE_GC_QUEUE_EVENT(xfs_inodegc_queue);
 
+TRACE_EVENT(xfs_inodegc_throttle_mempressure,
+	TP_PROTO(struct xfs_mount *mp),
+	TP_ARGS(mp),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int, votes)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->votes = atomic_read(&mp->m_inodegc_reclaim);
+	),
+	TP_printk("dev %d:%d votes %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->votes)
+);
+
 DECLARE_EVENT_CLASS(xfs_ag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),
 	TP_ARGS(mp, agno),

