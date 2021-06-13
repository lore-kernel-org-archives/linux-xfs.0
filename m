Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E43C48BDF
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFE1E61284
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbhFMRXF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 13 Jun 2021 13:23:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232014AbhFMRXE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 13 Jun 2021 13:23:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EBD861078;
        Sun, 13 Jun 2021 17:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623604863;
        bh=BFcTqCUkWD1n32IJELtkpAAXqLSVBcbxtyyzsG9A/Y0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WdtjKn26970pqVlbHCzddlwXUm5gHr3SSGo+k2CoA6CZ+FbAoFE7rNv92TTeUqHcY
         Fqa2jFUGsfILMDgeqB6r3SSCqqF0v8UFR/M6BpR61JVNAPapcM4kws6gAomuWhNmaH
         8wZ50JBK5OHfP1fwMsbk4PtFWA7Br7lyDkhuEZd3T5yO6dW0BZ0wu5iHbzgTsZekGC
         4tTOrDjdyxE56O0Xls68ZB3w7gFMGs/DX4GKjosUDrhmCvCxSXBm5xgL2szZawIDrH
         dxU1q7X1BzxzlwyjScoqEzvQZjMP2rjjPjY2+XLK2LYLd8MN5MrrTpLbcs2t4A5Q6A
         0Dm/r7kBYEwtg==
Subject: [PATCH 12/16] xfs: parallelize inode inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        bfoster@redhat.com
Date:   Sun, 13 Jun 2021 10:21:02 -0700
Message-ID: <162360486288.1530792.18351614470122965770.stgit@locust>
In-Reply-To: <162360479631.1530792.17147217854887531696.stgit@locust>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
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
 fs/xfs/libxfs/xfs_ag.c |    3 +
 fs/xfs/libxfs/xfs_ag.h |    3 +
 fs/xfs/xfs_icache.c    |  101 ++++++++++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_mount.c     |   11 +++--
 fs/xfs/xfs_mount.h     |    2 -
 fs/xfs/xfs_super.c     |    1 
 fs/xfs/xfs_trace.h     |    8 ++--
 7 files changed, 97 insertions(+), 32 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 0765a0ba30e1..7652d90d7d0d 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -173,6 +173,7 @@ __xfs_free_perag(
 	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
 
 	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
+	ASSERT(!delayed_work_pending(&pag->pag_inodegc_work));
 	ASSERT(atomic_read(&pag->pag_ref) == 0);
 	kmem_free(pag);
 }
@@ -195,6 +196,7 @@ xfs_free_perag(
 		ASSERT(atomic_read(&pag->pag_ref) == 0);
 
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
+		cancel_delayed_work_sync(&pag->pag_inodegc_work);
 		xfs_iunlink_destroy(pag);
 		xfs_buf_hash_destroy(pag);
 
@@ -253,6 +255,7 @@ xfs_initialize_perag(
 		spin_lock_init(&pag->pagb_lock);
 		spin_lock_init(&pag->pag_state_lock);
 		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
+		INIT_DELAYED_WORK(&pag->pag_inodegc_work, xfs_inodegc_worker);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 		init_waitqueue_head(&pag->pagb_wait);
 		pag->pagb_count = 0;
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 4c6f9045baca..3929ea35b0d4 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -96,6 +96,9 @@ struct xfs_perag {
 	/* background prealloc block trimming */
 	struct delayed_work	pag_blockgc_work;
 
+	/* background inode inactivation */
+	struct delayed_work	pag_inodegc_work;
+
 	/*
 	 * Unlinked inode information.  This incore information reflects
 	 * data stored in the AGI, so callers must hold the AGI buffer lock
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 210a9e3cd19e..f58d0455e38f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -299,6 +299,43 @@ xfs_worker_delay_freesp(
 	return delay_ms >> shift;
 }
 
+/*
+ * Scale down the background work delay if we're low on free space in this AG.
+ * Similar to the way that we throttle preallocations, we halve the delay time
+ * for every low free space threshold that isn't met.  Return value is in ms.
+ */
+static inline unsigned int
+xfs_work_delay_perag(
+	struct xfs_perag	*pag,
+	unsigned int		delay_ms)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+	xfs_extlen_t		freesp;
+	unsigned int		shift = 0;
+
+	if (!pag->pagf_init)
+		return delay_ms;
+
+	/* Free space in this AG that can be allocated to file data */
+	freesp = pag->pagf_freeblks + pag->pagf_flcount;
+	freesp -= (pag->pag_meta_resv.ar_reserved +
+		   pag->pag_rmapbt_resv.ar_reserved);
+
+	if (freesp < mp->m_ag_low_space[XFS_LOWSP_5_PCNT]) {
+		shift = 2;
+		if (freesp < mp->m_ag_low_space[XFS_LOWSP_4_PCNT])
+			shift++;
+		if (freesp < mp->m_ag_low_space[XFS_LOWSP_3_PCNT])
+			shift++;
+		if (freesp < mp->m_ag_low_space[XFS_LOWSP_2_PCNT])
+			shift++;
+		if (freesp < mp->m_ag_low_space[XFS_LOWSP_1_PCNT])
+			shift++;
+	}
+
+	return delay_ms >> shift;
+}
+
 /*
  * Compute the lag between scheduling and executing background work based on
  * free space in the filesystem.  If an inode is passed in, its dquots will
@@ -306,18 +343,20 @@ xfs_worker_delay_freesp(
  */
 static inline unsigned int
 xfs_worker_delay_ms(
-	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
 	struct xfs_inode	*ip,
 	unsigned int		default_ms)
 {
-	unsigned int		udelay, gdelay, pdelay, fdelay;
+	struct xfs_mount	*mp = pag->pag_mount;
+	unsigned int		udelay, gdelay, pdelay, fdelay, adelay;
 
 	udelay = xfs_worker_delay_dquot(ip, XFS_DQTYPE_USER, default_ms);
 	gdelay = xfs_worker_delay_dquot(ip, XFS_DQTYPE_GROUP, default_ms);
 	pdelay = xfs_worker_delay_dquot(ip, XFS_DQTYPE_PROJ, default_ms);
 	fdelay = xfs_worker_delay_freesp(mp, default_ms);
+	adelay = xfs_work_delay_perag(pag, default_ms);
 
-	return min(min(udelay, gdelay), min(pdelay, fdelay));
+	return min(adelay, min(min(udelay, gdelay), min(pdelay, fdelay)));
 }
 
 /*
@@ -343,9 +382,11 @@ xfs_blockgc_queue(
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
 
@@ -353,9 +394,9 @@ xfs_inodegc_queue(
 	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG)) {
 		unsigned int	delay;
 
-		delay = xfs_worker_delay_ms(mp, ip, xfs_inodegc_ms);
-		trace_xfs_inodegc_queue(mp, delay, _RET_IP_);
-		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work,
+		delay = xfs_worker_delay_ms(pag, ip, xfs_inodegc_ms);
+		trace_xfs_inodegc_queue(mp, pag->pag_agno, delay, _RET_IP_);
+		queue_delayed_work(mp->m_gc_workqueue, &pag->pag_inodegc_work,
 				msecs_to_jiffies(delay));
 	}
 	rcu_read_unlock();
@@ -367,11 +408,13 @@ xfs_inodegc_queue(
  */
 static void
 xfs_inodegc_queue_sooner(
-	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
 	struct xfs_inode	*ip)
 {
+	struct xfs_mount	*mp = pag->pag_mount;
+
 	if (!XFS_IS_QUOTA_ON(mp) ||
-	    !delayed_work_pending(&mp->m_inodegc_work) ||
+	    !delayed_work_pending(&pag->pag_inodegc_work) ||
 	    !test_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
 		return;
 
@@ -379,11 +422,11 @@ xfs_inodegc_queue_sooner(
 	if (!radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG))
 		goto unlock;
 
-	if (xfs_worker_delay_ms(mp, ip, xfs_inodegc_ms) == xfs_inodegc_ms)
+	if (xfs_worker_delay_ms(pag, ip, xfs_inodegc_ms) == xfs_inodegc_ms)
 		goto unlock;
 
-	trace_xfs_inodegc_queue(mp, 0, _RET_IP_);
-	queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work, 0);
+	trace_xfs_inodegc_queue(mp, pag->pag_agno, 0, _RET_IP_);
+	mod_delayed_work(mp->m_gc_workqueue, &pag->pag_inodegc_work, 0);
 unlock:
 	rcu_read_unlock();
 }
@@ -427,7 +470,7 @@ xfs_perag_set_inode_tag(
 		xfs_blockgc_queue(pag);
 		break;
 	case XFS_ICI_INODEGC_TAG:
-		xfs_inodegc_queue(mp, ip);
+		xfs_inodegc_queue(pag, ip);
 		break;
 	}
 
@@ -561,7 +604,7 @@ xfs_inode_mark_reclaimable(
 	spin_unlock(&pag->pag_ici_lock);
 
 	if (need_inactive && already_queued)
-		xfs_inodegc_queue_sooner(mp, ip);
+		xfs_inodegc_queue_sooner(pag, ip);
 
 	xfs_perag_put(pag);
 }
@@ -2058,16 +2101,17 @@ void
 xfs_inodegc_worker(
 	struct work_struct	*work)
 {
-	struct xfs_mount	*mp = container_of(to_delayed_work(work),
-					struct xfs_mount, m_inodegc_work);
+	struct xfs_perag	*pag = container_of(to_delayed_work(work),
+					struct xfs_perag, pag_inodegc_work);
+	struct xfs_mount	*mp = pag->pag_mount;
 
 	/*
 	 * Inactivation never returns error codes and never fails to push a
 	 * tagged inode to reclaim.  Loop until there there's nothing left.
 	 */
-	while (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG)) {
-		trace_xfs_inodegc_worker(mp, 0, _RET_IP_);
-		xfs_icwalk(mp, XFS_ICWALK_INODEGC, NULL);
+	while (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_INODEGC_TAG)) {
+		trace_xfs_inodegc_worker(mp, pag->pag_agno, 0, _RET_IP_);
+		xfs_icwalk_ag(pag, XFS_ICWALK_INODEGC, NULL);
 	}
 }
 
@@ -2079,8 +2123,13 @@ void
 xfs_inodegc_flush(
 	struct xfs_mount	*mp)
 {
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
 	trace_xfs_inodegc_flush(mp, 0, _RET_IP_);
-	flush_delayed_work(&mp->m_inodegc_work);
+
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_INODEGC_TAG)
+		flush_delayed_work(&pag->pag_inodegc_work);
 }
 
 /* Disable the inode inactivation background worker and wait for it to stop. */
@@ -2088,10 +2137,14 @@ void
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
 	trace_xfs_inodegc_stop(mp, 0, _RET_IP_);
 }
 
@@ -2103,11 +2156,15 @@ void
 xfs_inodegc_start(
 	struct xfs_mount	*mp)
 {
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
 	if (test_and_set_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
 		return;
 
 	trace_xfs_inodegc_start(mp, 0, _RET_IP_);
-	xfs_inodegc_queue(mp, NULL);
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_INODEGC_TAG)
+		xfs_inodegc_queue(pag, NULL);
 }
 
 /* XFS Inode Cache Walking Code */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ab65a14e51e6..eff375f92005 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -365,13 +365,16 @@ void
 xfs_set_low_space_thresholds(
 	struct xfs_mount	*mp)
 {
-	int i;
+	uint64_t		space = mp->m_sb.sb_dblocks;
+	uint32_t		ag_space = mp->m_sb.sb_agblocks;
+	int			i;
+
+	do_div(space, 100);
+	do_div(ag_space, 100);
 
 	for (i = 0; i < XFS_LOWSP_MAX; i++) {
-		uint64_t space = mp->m_sb.sb_dblocks;
-
-		do_div(space, 100);
 		mp->m_low_space[i] = space * (i + 1);
+		mp->m_ag_low_space[i] = ag_space * (i + 1);
 	}
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index dc906b78e24c..154aa95d968c 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -131,6 +131,7 @@ typedef struct xfs_mount {
 	uint			m_rsumsize;	/* size of rt summary, bytes */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
 	uint			m_qflags;	/* quota status flags */
+	int32_t			m_ag_low_space[XFS_LOWSP_MAX];
 	uint64_t		m_flags;	/* global mount flags */
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
@@ -191,7 +192,6 @@ typedef struct xfs_mount {
 	uint64_t		m_resblks_avail;/* available reserved blocks */
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
-	struct delayed_work	m_inodegc_work; /* background inode inactive */
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
 	struct xfs_kobj		m_error_meta_kobj;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 45ef63b5b2f0..66b61d38f401 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1865,7 +1865,6 @@ static int xfs_init_fs_context(
 	mutex_init(&mp->m_growlock);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
-	INIT_DELAYED_WORK(&mp->m_inodegc_work, xfs_inodegc_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
 	/*
 	 * We don't create the finobt per-ag space reservation until after log
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ca9bfbd28886..404f2f32002f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -122,7 +122,7 @@ TRACE_EVENT(xlog_intent_recovery_failed,
 		  __entry->error, __entry->function)
 );
 
-DECLARE_EVENT_CLASS(xfs_perag_class,
+DECLARE_EVENT_CLASS(xfs_perag_ref_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,
 		 unsigned long caller_ip),
 	TP_ARGS(mp, agno, refcount, caller_ip),
@@ -146,7 +146,7 @@ DECLARE_EVENT_CLASS(xfs_perag_class,
 );
 
 #define DEFINE_PERAG_REF_EVENT(name)	\
-DEFINE_EVENT(xfs_perag_class, name,	\
+DEFINE_EVENT(xfs_perag_ref_class, name,	\
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,	\
 		 unsigned long caller_ip),					\
 	TP_ARGS(mp, agno, refcount, caller_ip))
@@ -155,6 +155,8 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_put);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_inode_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
+DEFINE_PERAG_REF_EVENT(xfs_inodegc_queue);
+DEFINE_PERAG_REF_EVENT(xfs_inodegc_worker);
 
 DECLARE_EVENT_CLASS(xfs_fs_class,
 	TP_PROTO(struct xfs_mount *mp, int data, unsigned long caller_ip),
@@ -191,8 +193,6 @@ DEFINE_EVENT(xfs_fs_class, name,					\
 DEFINE_FS_EVENT(xfs_inodegc_flush);
 DEFINE_FS_EVENT(xfs_inodegc_start);
 DEFINE_FS_EVENT(xfs_inodegc_stop);
-DEFINE_FS_EVENT(xfs_inodegc_queue);
-DEFINE_FS_EVENT(xfs_inodegc_worker);
 DEFINE_FS_EVENT(xfs_fs_sync_fs);
 
 DECLARE_EVENT_CLASS(xfs_ag_class,

