Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 963DBC43381
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6887964F65
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbhCRWea (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 18:34:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232613AbhCRWe1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Mar 2021 18:34:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 052D864E89;
        Thu, 18 Mar 2021 22:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616106867;
        bh=X6jKYiim1+dUm82hDi1wjdePpeUs6ZaRsUgdCYeCAYY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AFXzqTD74D8anvvmJrdTKdLV16okUtTq9qU3dA8pA8k6DusAMMGJLUSZ4E69Ha5iN
         9WVrQ3yCtB3BI85DBGskQhSezZGgjqOH4+xqRrOEpKYuSdJy3lJur5SXl090czH606
         mCuVH3u8ksQ+ruayPzdQY1efeKKV5tCgfqAzebfdRPdW8uckUt+NXI8S0jZRYB5hTZ
         A8ICBUzQOrDTsBvKtYEHx55+IgWhQN8sxinED5vAErt4+jt3FmFAKMEfte9RX+/Qbi
         Z9eGmhdK8sugHhVoHmTwj0ymoHyduYG1TlrreMeqsHo86SXrlHrrX3NNt9H6TZJDgb
         bUsZEEpFHnKKg==
Subject: [PATCH 5/7] xfs: parallelize inode inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 18 Mar 2021 15:34:26 -0700
Message-ID: <161610686666.1887744.12957913230179802761.stgit@magnolia>
In-Reply-To: <161610683869.1887744.8863884017621115954.stgit@magnolia>
References: <161610683869.1887744.8863884017621115954.stgit@magnolia>
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
 fs/xfs/xfs_icache.c |   64 +++++++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_mount.c  |    3 ++
 fs/xfs/xfs_mount.h  |    4 ++-
 fs/xfs/xfs_super.c  |    1 -
 4 files changed, 52 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 8c74e6f08d10..29d99e5edbdf 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -249,11 +249,13 @@ xfs_inode_clear_reclaim_tag(
 /* Queue a new inode gc pass if there are inodes needing inactivation. */
 static void
 xfs_inodegc_queue(
-	struct xfs_mount        *mp)
+	struct xfs_perag	*pag)
 {
+	struct xfs_mount	*mp = pag->pag_mount;
+
 	rcu_read_lock();
 	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG))
-		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work,
+		queue_delayed_work(mp->m_gc_workqueue, &pag->pag_inodegc_work,
 				msecs_to_jiffies(xfs_inodegc_centisecs * 10));
 	rcu_read_unlock();
 }
@@ -276,7 +278,7 @@ xfs_perag_set_inactive_tag(
 	spin_unlock(&mp->m_perag_lock);
 
 	/* schedule periodic background inode inactivation */
-	xfs_inodegc_queue(mp);
+	xfs_inodegc_queue(pag);
 
 	trace_xfs_perag_set_inactive(mp, pag->pag_agno, -1, _RET_IP_);
 }
@@ -2072,8 +2074,9 @@ void
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
@@ -2088,21 +2091,20 @@ xfs_inodegc_worker(
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
 
-	error = xfs_inodegc_free_space(mp, NULL);
+	error = xfs_inode_walk_ag(pag, xfs_inodegc_inactivate, NULL);
 	if (error && error != -EAGAIN)
 		xfs_err(mp, "inode inactivation failed, error %d", error);
 
 	sb_end_write(mp->m_super);
-	xfs_inodegc_queue(mp);
+	xfs_inodegc_queue(pag);
 }
 
-/* Force all currently queued inode inactivation work to run immediately. */
-void
-xfs_inodegc_force(
-	struct xfs_mount	*mp)
+/* Force all currently queued AG inode inactivation work to run immediately. */
+static inline void
+xfs_inodegc_force_pag(
+	struct xfs_perag	*pag)
 {
-	if (!radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG))
-		return;
+	struct xfs_mount	*mp = pag->pag_mount;
 
 	/*
 	 * In order to reset the delayed work to run immediately, we have to
@@ -2111,9 +2113,27 @@ xfs_inodegc_force(
 	 * will iterate the radix tree one extra time and find no inodes to
 	 * inactivate.
 	 */
-	cancel_delayed_work(&mp->m_inodegc_work);
-	queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work, 0);
-	flush_delayed_work(&mp->m_inodegc_work);
+	cancel_delayed_work(&pag->pag_inodegc_work);
+	queue_delayed_work(mp->m_gc_workqueue, &pag->pag_inodegc_work, 0);
+}
+
+/* Force all queued inode inactivation work to run immediately. */
+void
+xfs_inodegc_force(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	bool			queued = false;
+
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_INODEGC_TAG) {
+		xfs_inodegc_force_pag(pag);
+		queued = true;
+	}
+	if (!queued)
+		return;
+
+	flush_workqueue(mp->m_gc_workqueue);
 }
 
 /* Stop all queued inactivation work. */
@@ -2121,7 +2141,11 @@ void
 xfs_inodegc_stop(
 	struct xfs_mount	*mp)
 {
-	cancel_delayed_work_sync(&mp->m_inodegc_work);
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_INODEGC_TAG)
+		cancel_delayed_work_sync(&pag->pag_inodegc_work);
 }
 
 /* Schedule deferred inode inactivation work. */
@@ -2129,5 +2153,9 @@ void
 xfs_inodegc_start(
 	struct xfs_mount	*mp)
 {
-	xfs_inodegc_queue(mp);
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_INODEGC_TAG)
+		xfs_inodegc_queue(pag);
 }
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index cd015e3d72fc..a5963061485c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -127,6 +127,7 @@ __xfs_free_perag(
 	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
 
 	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
+	ASSERT(!delayed_work_pending(&pag->pag_inodegc_work));
 	ASSERT(atomic_read(&pag->pag_ref) == 0);
 	kmem_free(pag);
 }
@@ -148,6 +149,7 @@ xfs_free_perag(
 		ASSERT(pag);
 		ASSERT(atomic_read(&pag->pag_ref) == 0);
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
+		cancel_delayed_work_sync(&pag->pag_inodegc_work);
 		xfs_iunlink_destroy(pag);
 		xfs_buf_hash_destroy(pag);
 		call_rcu(&pag->rcu_head, __xfs_free_perag);
@@ -204,6 +206,7 @@ xfs_initialize_perag(
 		pag->pag_mount = mp;
 		spin_lock_init(&pag->pag_ici_lock);
 		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
+		INIT_DELAYED_WORK(&pag->pag_inodegc_work, xfs_inodegc_worker);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 
 		error = xfs_buf_hash_init(pag);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 987bb3cca9a7..ff765c73a542 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -177,7 +177,6 @@ typedef struct xfs_mount {
 	uint64_t		m_resblks_avail;/* available reserved blocks */
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
-	struct delayed_work	m_inodegc_work; /* background inode inactive */
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
 	struct xfs_kobj		m_error_meta_kobj;
@@ -370,6 +369,9 @@ typedef struct xfs_perag {
 	/* background prealloc block trimming */
 	struct delayed_work	pag_blockgc_work;
 
+	/* background inode inactivation */
+	struct delayed_work	pag_inodegc_work;
+
 	/* reference count */
 	uint8_t			pagf_refcount_level;
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8d0142487fc7..566e5657c1b0 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1879,7 +1879,6 @@ static int xfs_init_fs_context(
 	mutex_init(&mp->m_growlock);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
-	INIT_DELAYED_WORK(&mp->m_inodegc_work, xfs_inodegc_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
 	/*
 	 * We don't create the finobt per-ag space reservation until after log

