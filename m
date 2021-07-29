Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38801C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16D8A60F5C
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhG2SpO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhG2SpO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 14:45:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 076F160249;
        Thu, 29 Jul 2021 18:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627584311;
        bh=RuIiXyjkUnxWfY69ZW9hO0HXPRt1JXLmp/IftYBwH+s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LylovqAt/DZhKrsG8+3pUJy+/1TdxULJZhQ4i3imTltSryvunGidykdmO2/e9KB1h
         xO0rz7B6APBYOyGlztFacL0YwutAY8c08K+fyVU65czbuf3TM2XgrDf3Y0tDSn5BCC
         lydWCypyUcJK7sdZ1DGFlz3KMfgk/Whq7IMTJXjjTmmwuM8eJ7CQMn9OqAeunzCIHw
         NvxkskbCPnU0sIn1TzE/T2c6Wcqb8rbrlsUybnPzfN6bWEy/+SoomXQF2C1p3kX3uS
         Npbv9IEP34OhWhXPh6PBX55sahpPT+GjpZQEpVSdWo0GQO8TQw+Q11JupZQlhKPPuV
         ZRzB/c3ZaxtuA==
Subject: [PATCH 14/20] xfs: parallelize inode inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 29 Jul 2021 11:45:10 -0700
Message-ID: <162758431072.332903.17159226037941080971.stgit@magnolia>
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

Split the inode inactivation work into per-AG work items so that we can
take advantage of parallelization.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |   12 ++++++-
 fs/xfs/libxfs/xfs_ag.h |   10 +++++
 fs/xfs/xfs_icache.c    |   88 ++++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_icache.h    |    2 +
 fs/xfs/xfs_mount.c     |    9 +----
 fs/xfs/xfs_mount.h     |    8 ----
 fs/xfs/xfs_super.c     |    2 -
 fs/xfs/xfs_trace.h     |   82 ++++++++++++++++++++++++++++++++-------------
 8 files changed, 134 insertions(+), 79 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 125a4b1f5be5..f000644e5da3 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -173,6 +173,7 @@ __xfs_free_perag(
 	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
 
 	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
+	ASSERT(!delayed_work_pending(&pag->pag_inodegc_work));
 	ASSERT(atomic_read(&pag->pag_ref) == 0);
 	kmem_free(pag);
 }
@@ -195,7 +196,9 @@ xfs_free_perag(
 		ASSERT(atomic_read(&pag->pag_ref) == 0);
 		ASSERT(pag->pag_ici_needs_inactive == 0);
 
+		unregister_shrinker(&pag->pag_inodegc_shrink);
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
+		cancel_delayed_work_sync(&pag->pag_inodegc_work);
 		xfs_iunlink_destroy(pag);
 		xfs_buf_hash_destroy(pag);
 
@@ -254,15 +257,20 @@ xfs_initialize_perag(
 		spin_lock_init(&pag->pagb_lock);
 		spin_lock_init(&pag->pag_state_lock);
 		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
+		INIT_DELAYED_WORK(&pag->pag_inodegc_work, xfs_inodegc_worker);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 		init_waitqueue_head(&pag->pagb_wait);
 		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
 
-		error = xfs_buf_hash_init(pag);
+		error = xfs_inodegc_register_shrinker(pag);
 		if (error)
 			goto out_remove_pag;
 
+		error = xfs_buf_hash_init(pag);
+		if (error)
+			goto out_inodegc_shrink;
+
 		error = xfs_iunlink_init(pag);
 		if (error)
 			goto out_hash_destroy;
@@ -282,6 +290,8 @@ xfs_initialize_perag(
 
 out_hash_destroy:
 	xfs_buf_hash_destroy(pag);
+out_inodegc_shrink:
+	unregister_shrinker(&pag->pag_inodegc_shrink);
 out_remove_pag:
 	radix_tree_delete(&mp->m_perag_tree, index);
 out_free_pag:
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index ad0d3480a4a2..28db7fc4ebc0 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -81,6 +81,12 @@ struct xfs_perag {
 
 	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
 
+	/*
+	 * How many times has the memory shrinker poked us since the last time
+	 * inodegc was queued?
+	 */
+	atomic_t	pag_inodegc_reclaim;
+
 	spinlock_t	pag_ici_lock;	/* incore inode cache lock */
 	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
 	unsigned int	pag_ici_needs_inactive;	/* inodes queued for inactivation */
@@ -97,6 +103,10 @@ struct xfs_perag {
 	/* background prealloc block trimming */
 	struct delayed_work	pag_blockgc_work;
 
+	/* background inode inactivation */
+	struct delayed_work	pag_inodegc_work;
+	struct shrinker		pag_inodegc_shrink;
+
 	/*
 	 * Unlinked inode information.  This incore information reflects
 	 * data stored in the AGI, so callers must hold the AGI buffer lock
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 3501f04d0914..6e9ca483c100 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -420,9 +420,11 @@ xfs_blockgc_queue(
  */
 static void
 xfs_inodegc_queue(
-	struct xfs_mount        *mp,
+	struct xfs_perag	*pag,
 	struct xfs_inode	*ip)
 {
+	struct xfs_mount        *mp = pag->pag_mount;
+
 	if (!test_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
 		return;
 
@@ -431,8 +433,8 @@ xfs_inodegc_queue(
 		unsigned int	delay;
 
 		delay = xfs_gc_delay_ms(mp, ip, XFS_ICI_INODEGC_TAG);
-		trace_xfs_inodegc_queue(mp, delay);
-		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work,
+		trace_xfs_inodegc_queue(pag, delay);
+		queue_delayed_work(mp->m_gc_workqueue, &pag->pag_inodegc_work,
 				msecs_to_jiffies(delay));
 	}
 	rcu_read_unlock();
@@ -444,17 +446,18 @@ xfs_inodegc_queue(
  */
 static void
 xfs_gc_requeue_now(
-	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
 	struct xfs_inode	*ip,
 	unsigned int		tag)
 {
 	struct delayed_work	*dwork;
+	struct xfs_mount	*mp = pag->pag_mount;
 	unsigned int		opflag_bit;
 	unsigned int		default_ms;
 
 	switch (tag) {
 	case XFS_ICI_INODEGC_TAG:
-		dwork = &mp->m_inodegc_work;
+		dwork = &pag->pag_inodegc_work;
 		default_ms = xfs_inodegc_ms;
 		opflag_bit = XFS_OPFLAG_INODEGC_RUNNING_BIT;
 		break;
@@ -473,7 +476,7 @@ xfs_gc_requeue_now(
 	if (xfs_gc_delay_ms(mp, ip, tag) == default_ms)
 		goto unlock;
 
-	trace_xfs_gc_requeue_now(mp, tag);
+	trace_xfs_gc_requeue_now(pag, tag);
 	queue_delayed_work(mp->m_gc_workqueue, dwork, 0);
 unlock:
 	rcu_read_unlock();
@@ -501,7 +504,7 @@ xfs_perag_set_inode_tag(
 		pag->pag_ici_needs_inactive++;
 
 	if (was_tagged) {
-		xfs_gc_requeue_now(mp, ip, tag);
+		xfs_gc_requeue_now(pag, ip, tag);
 		return;
 	}
 
@@ -519,7 +522,7 @@ xfs_perag_set_inode_tag(
 		xfs_blockgc_queue(pag);
 		break;
 	case XFS_ICI_INODEGC_TAG:
-		xfs_inodegc_queue(mp, ip);
+		xfs_inodegc_queue(pag, ip);
 		break;
 	}
 
@@ -597,8 +600,6 @@ static inline bool
 xfs_inodegc_want_throttle(
 	struct xfs_perag	*pag)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
-
 	/*
 	 * If we're in memory reclaim context, we don't want to wait for inode
 	 * inactivation to finish because it can take a very long time to
@@ -615,8 +616,8 @@ xfs_inodegc_want_throttle(
 	}
 
 	/* Throttle if memory reclaim anywhere has triggered us. */
-	if (atomic_read(&mp->m_inodegc_reclaim) > 0) {
-		trace_xfs_inodegc_throttle_mempressure(mp);
+	if (atomic_read(&pag->pag_inodegc_reclaim) > 0) {
+		trace_xfs_inodegc_throttle_mempressure(pag);
 		return true;
 	}
 
@@ -683,10 +684,11 @@ xfs_inode_mark_reclaimable(
 
 	spin_unlock(&ip->i_flags_lock);
 	spin_unlock(&pag->pag_ici_lock);
+
+	if (flush_inodegc && flush_work(&pag->pag_inodegc_work.work))
+		trace_xfs_inodegc_throttled(pag, __return_address);
+
 	xfs_perag_put(pag);
-
-	if (flush_inodegc && flush_work(&mp->m_inodegc_work.work))
-		trace_xfs_inodegc_throttled(mp, __return_address);
 }
 
 static inline void
@@ -2066,23 +2068,23 @@ void
 xfs_inodegc_worker(
 	struct work_struct	*work)
 {
-	struct xfs_mount	*mp = container_of(to_delayed_work(work),
-					struct xfs_mount, m_inodegc_work);
+	struct xfs_perag	*pag = container_of(to_delayed_work(work),
+					struct xfs_perag, pag_inodegc_work);
 
 	/*
 	 * Inactivation never returns error codes and never fails to push a
 	 * tagged inode to reclaim.  Loop until there there's nothing left.
 	 */
-	while (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG)) {
-		trace_xfs_inodegc_worker(mp, __return_address);
-		xfs_icwalk(mp, XFS_ICWALK_INODEGC, NULL);
+	while (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_INODEGC_TAG)) {
+		trace_xfs_inodegc_worker(pag, __return_address);
+		xfs_icwalk_ag(pag, XFS_ICWALK_INODEGC, NULL);
 	}
 
 	/*
 	 * We inactivated all the inodes we could, so disable the throttling
 	 * of new inactivations that happens when memory gets tight.
 	 */
-	atomic_set(&mp->m_inodegc_reclaim, 0);
+	atomic_set(&pag->pag_inodegc_reclaim, 0);
 }
 
 /*
@@ -2093,8 +2095,13 @@ void
 xfs_inodegc_flush(
 	struct xfs_mount	*mp)
 {
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
 	trace_xfs_inodegc_flush(mp, __return_address);
-	flush_delayed_work(&mp->m_inodegc_work);
+
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_INODEGC_TAG)
+		flush_delayed_work(&pag->pag_inodegc_work);
 }
 
 /* Disable the inode inactivation background worker and wait for it to stop. */
@@ -2102,10 +2109,14 @@ void
 xfs_inodegc_stop(
 	struct xfs_mount	*mp)
 {
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
 	if (!test_and_clear_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
 		return;
 
-	cancel_delayed_work_sync(&mp->m_inodegc_work);
+	for_each_perag(mp, agno, pag)
+		cancel_delayed_work_sync(&pag->pag_inodegc_work);
 	trace_xfs_inodegc_stop(mp, __return_address);
 }
 
@@ -2117,11 +2128,15 @@ void
 xfs_inodegc_start(
 	struct xfs_mount	*mp)
 {
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
 	if (test_and_set_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
 		return;
 
 	trace_xfs_inodegc_start(mp, __return_address);
-	xfs_inodegc_queue(mp, NULL);
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_INODEGC_TAG)
+		xfs_inodegc_queue(pag, NULL);
 }
 
 /*
@@ -2140,11 +2155,11 @@ xfs_inodegc_shrink_count(
 	struct shrinker		*shrink,
 	struct shrink_control	*sc)
 {
-	struct xfs_mount	*mp;
+	struct xfs_perag	*pag;
 
-	mp = container_of(shrink, struct xfs_mount, m_inodegc_shrink);
+	pag = container_of(shrink, struct xfs_perag, pag_inodegc_shrink);
 
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG))
+	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_INODEGC_TAG))
 		return XFS_INODEGC_SHRINK_COUNT;
 
 	return 0;
@@ -2155,7 +2170,7 @@ xfs_inodegc_shrink_scan(
 	struct shrinker		*shrink,
 	struct shrink_control	*sc)
 {
-	struct xfs_mount	*mp;
+	struct xfs_perag	*pag;
 
 	/*
 	 * Inode inactivation work requires NOFS allocations, so don't make
@@ -2164,14 +2179,15 @@ xfs_inodegc_shrink_scan(
 	if (!(sc->gfp_mask & __GFP_FS))
 		return SHRINK_STOP;
 
-	mp = container_of(shrink, struct xfs_mount, m_inodegc_shrink);
+	pag = container_of(shrink, struct xfs_perag, pag_inodegc_shrink);
 
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG)) {
-		trace_xfs_inodegc_requeue_mempressure(mp, sc->nr_to_scan,
+	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_INODEGC_TAG)) {
+		struct xfs_mount *mp = pag->pag_mount;
+
+		trace_xfs_inodegc_requeue_mempressure(pag, sc->nr_to_scan,
 				__return_address);
-
-		atomic_inc(&mp->m_inodegc_reclaim);
-		mod_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work, 0);
+		atomic_inc(&pag->pag_inodegc_reclaim);
+		mod_delayed_work(mp->m_gc_workqueue, &pag->pag_inodegc_work, 0);
 	}
 
 	return 0;
@@ -2180,9 +2196,9 @@ xfs_inodegc_shrink_scan(
 /* Register a shrinker so we can accelerate inodegc and throttle queuing. */
 int
 xfs_inodegc_register_shrinker(
-	struct xfs_mount	*mp)
+	struct xfs_perag	*pag)
 {
-	struct shrinker		*shrink = &mp->m_inodegc_shrink;
+	struct shrinker		*shrink = &pag->pag_inodegc_shrink;
 
 	shrink->count_objects = xfs_inodegc_shrink_count;
 	shrink->scan_objects = xfs_inodegc_shrink_scan;
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index e38c8bc5461f..7622efe6fd58 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -78,6 +78,6 @@ void xfs_inodegc_worker(struct work_struct *work);
 void xfs_inodegc_flush(struct xfs_mount *mp);
 void xfs_inodegc_stop(struct xfs_mount *mp);
 void xfs_inodegc_start(struct xfs_mount *mp);
-int xfs_inodegc_register_shrinker(struct xfs_mount *mp);
+int xfs_inodegc_register_shrinker(struct xfs_perag *pag);
 
 #endif
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 32b46593a169..37afb0e0d879 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -769,10 +769,6 @@ xfs_mountfs(
 		goto out_free_perag;
 	}
 
-	error = xfs_inodegc_register_shrinker(mp);
-	if (error)
-		goto out_fail_wait;
-
 	/*
 	 * Log's mount-time initialization. The first part of recovery can place
 	 * some items on the AIL, to be handled when recovery is finished or
@@ -783,7 +779,7 @@ xfs_mountfs(
 			      XFS_FSB_TO_BB(mp, sbp->sb_logblocks));
 	if (error) {
 		xfs_warn(mp, "log mount failed");
-		goto out_inodegc_shrink;
+		goto out_fail_wait;
 	}
 
 	/* Make sure the summary counts are ok. */
@@ -977,8 +973,6 @@ xfs_mountfs(
 	xfs_unmount_flush_inodes(mp);
  out_log_dealloc:
 	xfs_log_mount_cancel(mp);
- out_inodegc_shrink:
-	unregister_shrinker(&mp->m_inodegc_shrink);
  out_fail_wait:
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_buftarg_drain(mp->m_logdev_targp);
@@ -1059,7 +1053,6 @@ xfs_unmountfs(
 #if defined(DEBUG)
 	xfs_errortag_clearall(mp);
 #endif
-	unregister_shrinker(&mp->m_inodegc_shrink);
 	xfs_free_perag(mp);
 
 	xfs_errortag_del(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 225b3d289336..edd5c4fd6533 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -192,8 +192,6 @@ typedef struct xfs_mount {
 	uint64_t		m_resblks_avail;/* available reserved blocks */
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
-	struct delayed_work	m_inodegc_work; /* background inode inactive */
-	struct shrinker		m_inodegc_shrink;
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
 	struct xfs_kobj		m_error_meta_kobj;
@@ -221,12 +219,6 @@ typedef struct xfs_mount {
 	uint32_t		m_generation;
 	struct mutex		m_growlock;	/* growfs mutex */
 
-	/*
-	 * How many times has the memory shrinker poked us since the last time
-	 * inodegc was queued?
-	 */
-	atomic_t		m_inodegc_reclaim;
-
 #ifdef DEBUG
 	/*
 	 * Frequency with which errors are injected.  Replaces xfs_etest; the
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 1f82726d6265..2451f6d1690f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1849,8 +1849,6 @@ static int xfs_init_fs_context(
 	mutex_init(&mp->m_growlock);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
-	INIT_DELAYED_WORK(&mp->m_inodegc_work, xfs_inodegc_worker);
-	atomic_set(&mp->m_inodegc_reclaim, 0);
 	mp->m_kobj.kobject.kset = xfs_kset;
 	/*
 	 * We don't create the finobt per-ag space reservation until after log
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0579775e1e15..2c504c3e63e6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -123,7 +123,7 @@ TRACE_EVENT(xlog_intent_recovery_failed,
 		  __entry->error, __entry->function)
 );
 
-DECLARE_EVENT_CLASS(xfs_perag_class,
+DECLARE_EVENT_CLASS(xfs_perag_ref_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,
 		 unsigned long caller_ip),
 	TP_ARGS(mp, agno, refcount, caller_ip),
@@ -147,7 +147,7 @@ DECLARE_EVENT_CLASS(xfs_perag_class,
 );
 
 #define DEFINE_PERAG_REF_EVENT(name)	\
-DEFINE_EVENT(xfs_perag_class, name,	\
+DEFINE_EVENT(xfs_perag_ref_class, name,	\
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,	\
 		 unsigned long caller_ip),					\
 	TP_ARGS(mp, agno, refcount, caller_ip))
@@ -189,30 +189,57 @@ DEFINE_EVENT(xfs_fs_class, name,					\
 DEFINE_FS_EVENT(xfs_inodegc_flush);
 DEFINE_FS_EVENT(xfs_inodegc_start);
 DEFINE_FS_EVENT(xfs_inodegc_stop);
-DEFINE_FS_EVENT(xfs_inodegc_worker);
-DEFINE_FS_EVENT(xfs_inodegc_throttled);
 DEFINE_FS_EVENT(xfs_fs_sync_fs);
 DEFINE_FS_EVENT(xfs_inodegc_delay_mempressure);
 
 TRACE_EVENT(xfs_inodegc_requeue_mempressure,
-	TP_PROTO(struct xfs_mount *mp, unsigned long nr, void *caller_ip),
-	TP_ARGS(mp, nr, caller_ip),
+	TP_PROTO(struct xfs_perag *pag, unsigned long nr, void *caller_ip),
+	TP_ARGS(pag, nr, caller_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
 		__field(unsigned long, nr)
 		__field(void *, caller_ip)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->nr = nr;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d nr_to_scan %lu caller %pS",
+	TP_printk("dev %d:%d agno %u nr_to_scan %lu caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
 		  __entry->nr,
 		  __entry->caller_ip)
 );
 
+DECLARE_EVENT_CLASS(xfs_perag_class,
+	TP_PROTO(struct xfs_perag *pag, void *caller_ip),
+	TP_ARGS(pag, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(void *, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d agno %u caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->caller_ip)
+);
+
+#define DEFINE_PERAG_EVENT(name)	\
+DEFINE_EVENT(xfs_perag_class, name,					\
+	TP_PROTO(struct xfs_perag *pag, void *caller_ip), \
+	TP_ARGS(pag, caller_ip))
+DEFINE_PERAG_EVENT(xfs_inodegc_throttled);
+DEFINE_PERAG_EVENT(xfs_inodegc_worker);
+
 TRACE_EVENT(xfs_gc_delay_dquot,
 	TP_PROTO(struct xfs_dquot *dqp, unsigned int tag, unsigned int shift),
 	TP_ARGS(dqp, tag, shift),
@@ -292,55 +319,64 @@ TRACE_EVENT(xfs_gc_delay_frextents,
 );
 
 DECLARE_EVENT_CLASS(xfs_gc_queue_class,
-	TP_PROTO(struct xfs_mount *mp, unsigned int delay_ms),
-	TP_ARGS(mp, delay_ms),
+	TP_PROTO(struct xfs_perag *pag, unsigned int delay_ms),
+	TP_ARGS(pag, delay_ms),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
 		__field(unsigned int, delay_ms)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->delay_ms = delay_ms;
 	),
-	TP_printk("dev %d:%d delay_ms %u",
+	TP_printk("dev %d:%d agno %u delay_ms %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
 		  __entry->delay_ms)
 );
 #define DEFINE_GC_QUEUE_EVENT(name)	\
 DEFINE_EVENT(xfs_gc_queue_class, name,	\
-	TP_PROTO(struct xfs_mount *mp, unsigned int delay_ms),	\
-	TP_ARGS(mp, delay_ms))
+	TP_PROTO(struct xfs_perag *pag, unsigned int delay_ms),	\
+	TP_ARGS(pag, delay_ms))
 DEFINE_GC_QUEUE_EVENT(xfs_inodegc_queue);
 
 TRACE_EVENT(xfs_gc_requeue_now,
-	TP_PROTO(struct xfs_mount *mp, unsigned int tag),
-	TP_ARGS(mp, tag),
+	TP_PROTO(struct xfs_perag *pag, unsigned int tag),
+	TP_ARGS(pag, tag),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
 		__field(unsigned int, tag)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->tag = tag;
 	),
-	TP_printk("dev %d:%d tag %u",
+	TP_printk("dev %d:%d agno %u tag %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
 		  __entry->tag)
 );
 
 TRACE_EVENT(xfs_inodegc_throttle_mempressure,
-	TP_PROTO(struct xfs_mount *mp),
-	TP_ARGS(mp),
+	TP_PROTO(struct xfs_perag *pag),
+	TP_ARGS(pag),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
 		__field(int, votes)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->votes = atomic_read(&mp->m_inodegc_reclaim);
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->votes = atomic_read(&pag->pag_inodegc_reclaim);
 	),
-	TP_printk("dev %d:%d votes %d",
+	TP_printk("dev %d:%d agno %u votes %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
 		  __entry->votes)
 );
 

