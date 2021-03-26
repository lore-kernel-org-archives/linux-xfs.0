Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C90FDC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94AA6619F8
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhCZAWp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230195AbhCZAWX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:22:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2DE9619D3;
        Fri, 26 Mar 2021 00:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718142;
        bh=MxPRCk18HqArdMOxJzF52+nKgh1EIpQWUT4lp0zmDso=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eJoqzvxarlFFxafc2/ZEQQO69OqDdZcKtBUF/rJDR68Y+T2bzsc0jHmlnMNbswadA
         h9iw/vUtEUoSfROqJ37LVKbiIsDlAzveXJ3ofBwetKpVEklFsf/jNXrjgS1Tha7RNc
         8F6m8aLf3saTC8jTMnt/PYpw3wPUxW8PyEY49Ha1EBm0hvj4mLYrWYLr4ipl5KaVtw
         3QQEmZKcgVJkLh4ZQX4nJMonG+1wH/YwjOSWWc/Mih4PiFq0yI8+jIaTmeamqQ+a5E
         uyrxnMpLMQOgH2xzvWsOHrlzS7e3GhlwJ+DaOKousbBUFvxG2E87LHnh2unDZu2r/1
         aDK5V0MIOIlYw==
Subject: [PATCH 6/9] xfs: parallelize inode inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 25 Mar 2021 17:22:22 -0700
Message-ID: <161671814229.622901.8483806808388153781.stgit@magnolia>
In-Reply-To: <161671810866.622901.16520335819131743716.stgit@magnolia>
References: <161671810866.622901.16520335819131743716.stgit@magnolia>
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
 fs/xfs/xfs_icache.c |   53 +++++++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_mount.c  |    3 +++
 fs/xfs/xfs_mount.h  |    4 +++-
 fs/xfs/xfs_super.c  |    1 -
 4 files changed, 44 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index b0293ab55385..00d614730b2c 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -32,7 +32,7 @@ static int xfs_blockgc_scan_inode(struct xfs_inode *ip,
 static inline void xfs_blockgc_queue(struct xfs_perag *pag);
 static bool xfs_reclaim_inode_grab(struct xfs_inode *ip);
 static void xfs_reclaim_inode(struct xfs_inode *ip, struct xfs_perag *pag);
-static inline void xfs_inodegc_queue(struct xfs_mount *mp);
+static inline void xfs_inodegc_queue(struct xfs_perag *pag);
 static int xfs_inodegc_inactivate(struct xfs_inode *ip, struct xfs_perag *pag,
 		struct xfs_eofblocks *eofb);
 
@@ -202,7 +202,7 @@ xfs_perag_set_ici_tag(
 		xfs_blockgc_queue(pag);
 		break;
 	case XFS_ICI_INODEGC_TAG:
-		xfs_inodegc_queue(mp);
+		xfs_inodegc_queue(pag);
 		break;
 	}
 
@@ -303,14 +303,16 @@ xfs_inodegc_running(struct xfs_mount *mp)
 /* Queue a new inode gc pass if there are inodes needing inactivation. */
 static void
 xfs_inodegc_queue(
-	struct xfs_mount        *mp)
+	struct xfs_perag	*pag)
 {
+	struct xfs_mount	*mp = pag->pag_mount;
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
@@ -1902,28 +1904,38 @@ void
 xfs_inodegc_worker(
 	struct work_struct	*work)
 {
-	struct xfs_mount	*mp = container_of(to_delayed_work(work),
-					struct xfs_mount, m_inodegc_work);
+	struct xfs_perag	*pag = container_of(to_delayed_work(work),
+					struct xfs_perag, pag_inodegc_work);
+	struct xfs_mount	*mp = pag->pag_mount;
 	int			error;
 
-	error = xfs_inodegc_free_space(mp, NULL);
+	error = xfs_inode_walk_ag(pag, XFS_ICI_INODEGC_TAG, NULL);
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
@@ -1931,8 +1943,15 @@ void
 xfs_inodegc_stop(
 	struct xfs_mount	*mp)
 {
+	xfs_agnumber_t		agno;
+
 	clear_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags);
-	cancel_delayed_work_sync(&mp->m_inodegc_work);
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		struct xfs_perag	*pag = xfs_perag_get(mp, agno);
+
+		cancel_delayed_work_sync(&pag->pag_inodegc_work);
+		xfs_perag_put(pag);
+	}
 }
 
 /* Schedule deferred inode inactivation work. */
@@ -1940,6 +1959,10 @@ void
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
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index f95f913bff38..c6af1e848171 100644
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
index 83b8f86448f4..416f308aee52 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -179,7 +179,6 @@ typedef struct xfs_mount {
 	uint64_t		m_resblks_avail;/* available reserved blocks */
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
-	struct delayed_work	m_inodegc_work; /* background inode inactive */
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
 	struct xfs_kobj		m_error_meta_kobj;
@@ -377,6 +376,9 @@ typedef struct xfs_perag {
 	/* background prealloc block trimming */
 	struct delayed_work	pag_blockgc_work;
 
+	/* background inode inactivation */
+	struct delayed_work	pag_inodegc_work;
+
 	/* reference count */
 	uint8_t			pagf_refcount_level;
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b1b01091b673..605af79a3e88 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1923,7 +1923,6 @@ static int xfs_init_fs_context(
 	mutex_init(&mp->m_growlock);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
-	INIT_DELAYED_WORK(&mp->m_inodegc_work, xfs_inodegc_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
 	/*
 	 * We don't create the finobt per-ag space reservation until after log

