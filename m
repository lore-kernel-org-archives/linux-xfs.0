Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B941C47082
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 22:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9B6561059
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 22:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhFGW1T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 18:27:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230375AbhFGW1T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Jun 2021 18:27:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4352561040;
        Mon,  7 Jun 2021 22:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623104727;
        bh=zTKbXZcUkNNAFR+MJopBgaDVtydoOKnyU2ohky2EXyQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pp1G69zTc5SmupunFlgjCFutFUIubfCfHpg1PlzMaA8fRHTo8gDgMGIDampvxHb7y
         JoUXho5xksphVF0HP4D3Z+GQ/rGXIKb6zJ/kMK1+pJpe13DT+5pe9hYucNqI4TQdqe
         +maWjfrbNE+p3GCJIliNSS3y5T7q/tA3zj6E4iuVUkWas83G5TS4FfLPPkNocqTvAE
         TCidxgClpYRVpT5qdjo8/UpuayDpsqh9r8FKsgrca7qZORfbv84wk7QLxtTvy7Wq8b
         tNV5KIo5kdeBDm4RFcVsTlPIWuA/JV+96sspZ+aC7pHyMKorQFtfSLNmlSVIPHhFfU
         ZIQz7Zm9voUQA==
Subject: [PATCH 6/9] xfs: parallelize inode inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Mon, 07 Jun 2021 15:25:27 -0700
Message-ID: <162310472693.3465262.1327763454581355758.stgit@locust>
In-Reply-To: <162310469340.3465262.504398465311182657.stgit@locust>
References: <162310469340.3465262.504398465311182657.stgit@locust>
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
 fs/xfs/libxfs/xfs_ag.c |    3 +++
 fs/xfs/libxfs/xfs_ag.h |    3 +++
 fs/xfs/xfs_icache.c    |   48 ++++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_mount.h     |    1 -
 fs/xfs/xfs_super.c     |    1 -
 5 files changed, 40 insertions(+), 16 deletions(-)


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
index d68b56de495a..1408043dce85 100644
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
index 8016e90b7b6d..8574edca6f52 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -240,14 +240,16 @@ xfs_inodegc_running(struct xfs_mount *mp)
 /* Queue a new inode gc pass if there are inodes needing inactivation. */
 static void
 xfs_inodegc_queue(
-	struct xfs_mount        *mp)
+	struct xfs_perag	*pag)
 {
+	struct xfs_mount        *mp = pag->pag_mount;
+
 	if (!xfs_inodegc_running(mp))
 		return;
 
 	rcu_read_lock();
 	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG))
-		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work,
+		queue_delayed_work(mp->m_gc_workqueue, &pag->pag_inodegc_work,
 				msecs_to_jiffies(xfs_inodegc_centisecs * 10));
 	rcu_read_unlock();
 }
@@ -287,7 +289,7 @@ xfs_perag_set_inode_tag(
 		xfs_blockgc_queue(pag);
 		break;
 	case XFS_ICI_INODEGC_TAG:
-		xfs_inodegc_queue(mp);
+		xfs_inodegc_queue(pag);
 		break;
 	}
 
@@ -1915,8 +1917,9 @@ void
 xfs_inodegc_worker(
 	struct work_struct	*work)
 {
-	struct xfs_mount	*mp = container_of(to_delayed_work(work),
-					struct xfs_mount, m_inodegc_work);
+	struct xfs_perag	*pag = container_of(to_delayed_work(work),
+					struct xfs_perag, pag_inodegc_work);
+	struct xfs_mount	*mp = pag->pag_mount;
 	int			error;
 
 	/*
@@ -1927,24 +1930,33 @@ xfs_inodegc_worker(
 	if (!xfs_inodegc_running(mp))
 		return;
 
-	error = xfs_inodegc_free_space(mp, NULL);
+	error = xfs_icwalk_ag(pag, XFS_ICWALK_INODEGC, NULL);
 	if (error && error != -EAGAIN)
 		xfs_err(mp, "inode inactivation failed, error %d", error);
 
-	xfs_inodegc_queue(mp);
+	xfs_inodegc_queue(pag);
 }
 
-/* Force all currently queued inode inactivation work to run immediately. */
+/* Force all queued inode inactivation work to run immediately. */
 void
 xfs_inodegc_flush(
 	struct xfs_mount	*mp)
 {
-	if (!xfs_inodegc_running(mp) ||
-	    !radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG))
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	bool			queued = false;
+
+	if (!xfs_inodegc_running(mp))
+		return;
+
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_INODEGC_TAG) {
+		mod_delayed_work(mp->m_gc_workqueue, &pag->pag_inodegc_work, 0);
+		queued = true;
+	}
+	if (!queued)
 		return;
 
-	mod_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work, 0);
-	flush_delayed_work(&mp->m_inodegc_work);
+	flush_workqueue(mp->m_gc_workqueue);
 }
 
 /* Stop all queued inactivation work. */
@@ -1952,8 +1964,12 @@ void
 xfs_inodegc_stop(
 	struct xfs_mount	*mp)
 {
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
 	clear_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags);
-	cancel_delayed_work_sync(&mp->m_inodegc_work);
+	for_each_perag(mp, agno, pag)
+		cancel_delayed_work_sync(&pag->pag_inodegc_work);
 }
 
 /* Schedule deferred inode inactivation work. */
@@ -1961,8 +1977,12 @@ void
 xfs_inodegc_start(
 	struct xfs_mount	*mp)
 {
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
 	set_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags);
-	xfs_inodegc_queue(mp);
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_INODEGC_TAG)
+		xfs_inodegc_queue(pag);
 }
 
 /* Are there files waiting for inactivation? */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 04a016a46dc8..c2a8f0a550cd 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -186,7 +186,6 @@ typedef struct xfs_mount {
 	uint64_t		m_resblks_avail;/* available reserved blocks */
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
-	struct delayed_work	m_inodegc_work; /* background inode inactive */
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
 	struct xfs_kobj		m_error_meta_kobj;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 120a4426fd64..164626a4232f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1955,7 +1955,6 @@ static int xfs_init_fs_context(
 	mutex_init(&mp->m_growlock);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
-	INIT_DELAYED_WORK(&mp->m_inodegc_work, xfs_inodegc_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
 	/*
 	 * We don't create the finobt per-ag space reservation until after log

