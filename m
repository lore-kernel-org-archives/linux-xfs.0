Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CEA6C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 779A064DAD
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhCKDHH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 22:07:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230116AbhCKDGh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 22:06:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0E1064FC4;
        Thu, 11 Mar 2021 03:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615431996;
        bh=BotaVq+EBr871yYHRbgnBTb2osg7CS9jK6S8330/ZzU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PJq0kr9rbU5F75MBbZoqyz+kkrbDw32Is+cbrMFFQ+XZo0R43KI4TqkxT099GMyhZ
         mJN0oNcM8YI9MGINTNbANpYvD2/XDOaSxl0k9Dbgr7TX2Wc3IsH8bevJQq5QfPjr+f
         JVe37hxuS0YTt8k6gg/vxan9m4LB7QqbuwlHP63QxS5ZPK1AGlqwRtTJgV2ewao/aT
         RyD2+oWUm72oHm5Hm37qjcYpE962ffzjF1ddDZoBptOYLD9vSYVl9D4BjJ/e5nu+6a
         4nzH2U1MKNip2OXMiImXVFrHMyNLJ1xRY4C7bVczQ4latJLZ4LN87IUa1CD5Xq4WEx
         ZVvcnzaSatVig==
Subject: [PATCH 10/11] xfs: parallelize inode inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 10 Mar 2021 19:06:36 -0800
Message-ID: <161543199635.1947934.2885924822578773349.stgit@magnolia>
In-Reply-To: <161543194009.1947934.9910987247994410125.stgit@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
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
 fs/xfs/xfs_icache.c |   62 ++++++++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_mount.c  |    3 ++
 fs/xfs/xfs_mount.h  |    4 ++-
 fs/xfs/xfs_super.c  |    1 -
 4 files changed, 52 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 594d340bbe37..d5f580b92e48 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -245,11 +245,13 @@ xfs_inode_clear_reclaim_tag(
 /* Queue a new inode gc pass if there are inodes needing inactivation. */
 static void
 xfs_inodegc_queue(
-	struct xfs_mount        *mp)
+	struct xfs_perag	*pag)
 {
+	struct xfs_mount	*mp = pag->pag_mount;
+
 	rcu_read_lock();
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INACTIVE_TAG))
-		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work,
+	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_INACTIVE_TAG))
+		queue_delayed_work(mp->m_gc_workqueue, &pag->pag_inodegc_work,
 				msecs_to_jiffies(xfs_inodegc_centisecs * 10));
 	rcu_read_unlock();
 }
@@ -272,7 +274,7 @@ xfs_perag_set_inactive_tag(
 	spin_unlock(&mp->m_perag_lock);
 
 	/* schedule periodic background inode inactivation */
-	xfs_inodegc_queue(mp);
+	xfs_inodegc_queue(pag);
 
 	trace_xfs_perag_set_inactive(mp, pag->pag_agno, -1, _RET_IP_);
 }
@@ -2074,8 +2076,9 @@ void
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
@@ -2095,25 +2098,44 @@ xfs_inodegc_worker(
 		xfs_err(mp, "inode inactivation failed, error %d", error);
 
 	sb_end_write(mp->m_super);
-	xfs_inodegc_queue(mp);
+	xfs_inodegc_queue(pag);
 }
 
-/* Force all queued inode inactivation work to run immediately. */
-void
-xfs_inodegc_force(
-	struct xfs_mount	*mp)
+/* Garbage collect all inactive inodes in an AG immediately. */
+static inline bool
+xfs_inodegc_force_pag(
+	struct xfs_perag	*pag)
 {
+	struct xfs_mount	*mp = pag->pag_mount;
+
 	/*
 	 * In order to reset the delay timer to run immediately, we have to
 	 * cancel the work item and requeue it with a zero timer value.  We
 	 * don't care if the worker races with our requeue, because at worst
 	 * we iterate the radix tree and find no inodes to inactivate.
 	 */
-	if (!cancel_delayed_work(&mp->m_inodegc_work))
+	if (!cancel_delayed_work(&pag->pag_inodegc_work))
+		return false;
+
+	queue_delayed_work(mp->m_gc_workqueue, &pag->pag_inodegc_work, 0);
+	return true;
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
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_INACTIVE_TAG)
+		queued |= xfs_inodegc_force_pag(pag);
+	if (!queued)
 		return;
 
-	queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work, 0);
-	flush_delayed_work(&mp->m_inodegc_work);
+	flush_workqueue(mp->m_gc_workqueue);
 }
 
 /* Stop all queued inactivation work. */
@@ -2121,7 +2143,11 @@ void
 xfs_inodegc_stop(
 	struct xfs_mount	*mp)
 {
-	cancel_delayed_work_sync(&mp->m_inodegc_work);
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_INACTIVE_TAG)
+		cancel_delayed_work_sync(&pag->pag_inodegc_work);
 }
 
 /* Schedule deferred inode inactivation work. */
@@ -2129,5 +2155,9 @@ void
 xfs_inodegc_start(
 	struct xfs_mount	*mp)
 {
-	xfs_inodegc_queue(mp);
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_INACTIVE_TAG)
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
index ce00ad47b8ea..835c07d00cd7 100644
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

