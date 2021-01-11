Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D25C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 129AD22D08
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729954AbhALAZ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404104AbhAKXYk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 18:24:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2501C22D2C;
        Mon, 11 Jan 2021 23:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610407439;
        bh=E47XbWT3x62J4HORc6ptEWqOyJkb0lwzFcamWmO4Jgk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eLZtJaMeQV2Ykq8d5FjbkYK4tDaRoT1vSL7N8/hswWQ9DSQYRBO+r6sE3VB5Mp3n8
         iI88BbEVktFkEfBZ35dIoxvfClBJ4tPZi52kr8pqjWWNfNtVpGlvyCShV8IVx/SdVq
         1/CdW0tL1g5q2VEIQYNGe13BXGqCRhAPjmXZDvs/o+ZBxCFfIb0KSV5dYEhrvUjVkM
         DVuq7xvPAGpKMnnKpMG7l6CBTsuqZAPsnCIuu9y0fMck9CB+Wzlr4NhpObQRdgM6MN
         Xy/CmM/3N4GE/wIOELufQERy2MKNtwvobXhC/TC5lekGIQvV5CXaTJMtKOJ14s+uB5
         2EhRruxj6CBhA==
Subject: [PATCH 7/7] xfs: parallelize block preallocation garbage collection
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 11 Jan 2021 15:23:59 -0800
Message-ID: <161040743914.1582286.9059958538368033662.stgit@magnolia>
In-Reply-To: <161040739544.1582286.11068012972712089066.stgit@magnolia>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Split the block preallocation garbage collection work into per-AG work
items so that we can take advantage of parallelization.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   47 +++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_mount.c  |    3 +++
 fs/xfs/xfs_mount.h  |    5 +++--
 fs/xfs/xfs_super.c  |   26 ++++++++++++++++++++++++--
 4 files changed, 63 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d1179f3e9d1f..e78724440d87 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -943,12 +943,12 @@ xfs_inode_walk(
  */
 static void
 xfs_queue_blockgc(
-	struct xfs_mount	*mp)
+	struct xfs_perag	*pag)
 {
 	rcu_read_lock();
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_BLOCK_GC_TAG))
-		queue_delayed_work(mp->m_blockgc_workqueue,
-				   &mp->m_blockgc_work,
+	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCK_GC_TAG))
+		queue_delayed_work(pag->pag_mount->m_blockgc_workqueue,
+				   &pag->pag_blockgc_work,
 				   msecs_to_jiffies(xfs_blockgc_secs * 1000));
 	rcu_read_unlock();
 }
@@ -983,25 +983,40 @@ void
 xfs_blockgc_worker(
 	struct work_struct	*work)
 {
-	struct xfs_mount	*mp = container_of(to_delayed_work(work),
-					struct xfs_mount, m_blockgc_work);
+	struct xfs_perag	*pag = container_of(to_delayed_work(work),
+					struct xfs_perag, pag_blockgc_work);
 	int			error;
 
-	if (!sb_start_write_trylock(mp->m_super))
+	if (!sb_start_write_trylock(pag->pag_mount->m_super))
 		return;
-	error = xfs_blockgc_scan(mp, NULL);
+
+	error = xfs_inode_walk_ag(pag, 0, xfs_blockgc_scan_inode, NULL,
+			XFS_ICI_BLOCK_GC_TAG);
 	if (error)
-		xfs_info(mp, "preallocation gc worker failed, err=%d", error);
-	sb_end_write(mp->m_super);
-	xfs_queue_blockgc(mp);
+		xfs_info(pag->pag_mount,
+				"AG %u preallocation gc worker failed, err=%d",
+				pag->pag_agno, error);
+	sb_end_write(pag->pag_mount->m_super);
+	xfs_queue_blockgc(pag);
 }
 
+#define for_each_perag_tag(mp, next_agno, pag, tag) \
+	for ((next_agno) = 0, (pag) = xfs_perag_get_tag((mp), 0, (tag)); \
+	     (pag) != NULL; \
+	     (next_agno) = (pag)->pag_agno + 1, \
+	     xfs_perag_put(pag), \
+	     (pag) = xfs_perag_get_tag((mp), (next_agno), (tag)))
+
 /* Disable post-EOF and CoW block auto-reclamation. */
 void
 xfs_blockgc_stop(
 	struct xfs_mount	*mp)
 {
-	cancel_delayed_work_sync(&mp->m_blockgc_work);
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCK_GC_TAG)
+		cancel_delayed_work_sync(&pag->pag_blockgc_work);
 }
 
 /* Enable post-EOF and CoW block auto-reclamation. */
@@ -1009,7 +1024,11 @@ void
 xfs_blockgc_start(
 	struct xfs_mount	*mp)
 {
-	xfs_queue_blockgc(mp);
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCK_GC_TAG)
+		xfs_queue_blockgc(pag);
 }
 
 /*
@@ -1546,7 +1565,7 @@ __xfs_inode_set_blocks_tag(
 		spin_unlock(&ip->i_mount->m_perag_lock);
 
 		/* kick off background trimming */
-		xfs_queue_blockgc(ip->i_mount);
+		xfs_queue_blockgc(pag);
 
 		trace_xfs_perag_set_blockgc(ip->i_mount, pag->pag_agno, -1,
 				_RET_IP_);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index c3144cf5febe..ed96b48afb0a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -126,6 +126,7 @@ __xfs_free_perag(
 {
 	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
 
+	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
 	ASSERT(atomic_read(&pag->pag_ref) == 0);
 	kmem_free(pag);
 }
@@ -146,6 +147,7 @@ xfs_free_perag(
 		spin_unlock(&mp->m_perag_lock);
 		ASSERT(pag);
 		ASSERT(atomic_read(&pag->pag_ref) == 0);
+		cancel_delayed_work_sync(&pag->pag_blockgc_work);
 		xfs_iunlink_destroy(pag);
 		xfs_buf_hash_destroy(pag);
 		call_rcu(&pag->rcu_head, __xfs_free_perag);
@@ -201,6 +203,7 @@ xfs_initialize_perag(
 		pag->pag_agno = index;
 		pag->pag_mount = mp;
 		spin_lock_init(&pag->pag_ici_lock);
+		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 
 		error = xfs_buf_hash_init(pag);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index d9f32102514e..2bb2b5704805 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -177,8 +177,6 @@ typedef struct xfs_mount {
 	uint64_t		m_resblks_avail;/* available reserved blocks */
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
-	struct delayed_work	m_blockgc_work; /* background prealloc blocks
-						     trimming */
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
 	struct xfs_kobj		m_error_meta_kobj;
@@ -367,6 +365,9 @@ typedef struct xfs_perag {
 	/* Blocks reserved for the reverse mapping btree. */
 	struct xfs_ag_resv	pag_rmapbt_resv;
 
+	/* background prealloc block trimming */
+	struct delayed_work	pag_blockgc_work;
+
 	/* reference count */
 	uint8_t			pagf_refcount_level;
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f72c1f473025..9624e8a08509 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -516,7 +516,8 @@ xfs_init_mount_workqueues(
 		goto out_destroy_cil;
 
 	mp->m_blockgc_workqueue = alloc_workqueue("xfs-blockgc/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
+			WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_FREEZABLE, 0,
+			mp->m_super->s_id);
 	if (!mp->m_blockgc_workqueue)
 		goto out_destroy_reclaim;
 
@@ -1387,6 +1388,26 @@ xfs_fs_validate_params(
 	return 0;
 }
 
+/*
+ * Constrain the number of threads that we start for background work.  This
+ * is the estimated parallelism of the filesystem capped to the unbound work
+ * queue maximum.
+ *
+ * We can't set this when we allocate the workqueues because the thread count
+ * derives from AG count, and we can't know that until we're far enough through
+ * setup to read the superblock, which requires functioning workqueues.
+ */
+static inline void
+xfs_configure_background_workqueues(
+	struct xfs_mount	*mp)
+{
+	unsigned int		threads = xfs_guess_metadata_threads(mp);
+	unsigned int		max_active;
+
+	max_active = min_t(unsigned int, threads, WQ_UNBOUND_MAX_ACTIVE);
+	workqueue_set_max_active(mp->m_blockgc_workqueue, max_active);
+}
+
 static int
 xfs_fs_fill_super(
 	struct super_block	*sb,
@@ -1452,6 +1473,8 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_free_sb;
 
+	xfs_configure_background_workqueues(mp);
+
 	error = xfs_setup_devices(mp);
 	if (error)
 		goto out_free_sb;
@@ -1872,7 +1895,6 @@ static int xfs_init_fs_context(
 	mutex_init(&mp->m_growlock);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
-	INIT_DELAYED_WORK(&mp->m_blockgc_work, xfs_blockgc_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
 	/*
 	 * We don't create the finobt per-ag space reservation until after log

