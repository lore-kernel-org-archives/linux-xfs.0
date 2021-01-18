Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F8DC432C3
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F90320707
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388462AbhARWOk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 17:14:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387793AbhARWOi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 17:14:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B09BC22EBD;
        Mon, 18 Jan 2021 22:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611008036;
        bh=n4OwloJGZ1nS2yzNTawhnP/bwcMy6M0d/H8jesy2om4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=U0v/9TdhNXY7e7voEdaKrk3vfbRNLVTSTZ5qJXiWD52JT/OgUR/8GKj0DVGhNXHg+
         MEAIb0O1TDhRZfSXdfozrXB0ihrsVzdzIWj/zcIna0UOSkzb1iUfJO+bpUDN9tLo07
         y/pXjU5HRLwfSePI3rM00quk6dr4YgebxEgr8m58um+dAvjvM3/apBZTRUBV65n+vo
         My6yfvca5wnFg7Tb40cMg0d1YAqZm4VJvA5k1hdi8MtC5bt7dsjqjXNYHqDgXi5mA6
         xZ63+Sd5ihKd8ppQG59UeghiW9Km/wstMFbhzsVLS/G4JSGt7DjuV9bwGAxFiTsp3Y
         cGsvOOVx15T3w==
Subject: [PATCH 10/10] xfs: parallelize block preallocation garbage collection
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 18 Jan 2021 14:13:56 -0800
Message-ID: <161100803639.90204.8660617758360952350.stgit@magnolia>
In-Reply-To: <161100798100.90204.7839064495063223590.stgit@magnolia>
References: <161100798100.90204.7839064495063223590.stgit@magnolia>
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

Note that sysadmins /can/ tweak the max concurrency level of the blockgc
workqueue via /sys/bus/workqueue/devices/xfs-conv!${device}/max_active.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c |   42 ++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_mount.c  |    3 +++
 fs/xfs/xfs_mount.h  |    5 +++--
 fs/xfs/xfs_super.c  |   32 ++++++++++++++++++++++++++++++--
 4 files changed, 66 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 8ef90091ed7d..d548a14d0301 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1333,12 +1333,12 @@ xfs_inode_free_eofblocks(
  */
 static inline void
 xfs_blockgc_queue(
-	struct xfs_mount	*mp)
+	struct xfs_perag	*pag)
 {
 	rcu_read_lock();
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_BLOCKGC_TAG))
-		queue_delayed_work(mp->m_blockgc_workqueue,
-				   &mp->m_blockgc_work,
+	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCKGC_TAG))
+		queue_delayed_work(pag->pag_mount->m_blockgc_workqueue,
+				   &pag->pag_blockgc_work,
 				   msecs_to_jiffies(xfs_blockgc_secs * 1000));
 	rcu_read_unlock();
 }
@@ -1380,7 +1380,7 @@ xfs_blockgc_set_iflag(
 		spin_unlock(&ip->i_mount->m_perag_lock);
 
 		/* kick off background trimming */
-		xfs_blockgc_queue(ip->i_mount);
+		xfs_blockgc_queue(pag);
 
 		trace_xfs_perag_set_blockgc(ip->i_mount, pag->pag_agno, -1,
 				_RET_IP_);
@@ -1555,12 +1555,24 @@ xfs_inode_clear_cowblocks_tag(
 	return xfs_blockgc_clear_iflag(ip, XFS_ICOWBLOCKS);
 }
 
+#define for_each_perag_tag(mp, next_agno, pag, tag) \
+	for ((next_agno) = 0, (pag) = xfs_perag_get_tag((mp), 0, (tag)); \
+		(pag) != NULL; \
+		(next_agno) = (pag)->pag_agno + 1, \
+		xfs_perag_put(pag), \
+		(pag) = xfs_perag_get_tag((mp), (next_agno), (tag)))
+
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
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
+		cancel_delayed_work_sync(&pag->pag_blockgc_work);
 }
 
 /* Enable post-EOF and CoW block auto-reclamation. */
@@ -1568,7 +1580,11 @@ void
 xfs_blockgc_start(
 	struct xfs_mount	*mp)
 {
-	xfs_blockgc_queue(mp);
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
+		xfs_blockgc_queue(pag);
 }
 
 /* Scan one incore inode for block preallocations that we can remove. */
@@ -1595,18 +1611,20 @@ void
 xfs_blockgc_worker(
 	struct work_struct	*work)
 {
-	struct xfs_mount	*mp = container_of(to_delayed_work(work),
-					struct xfs_mount, m_blockgc_work);
+	struct xfs_perag	*pag = container_of(to_delayed_work(work),
+					struct xfs_perag, pag_blockgc_work);
+	struct xfs_mount	*mp = pag->pag_mount;
 	int			error;
 
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
-	error = xfs_inode_walk(mp, 0, xfs_blockgc_scan_inode, NULL,
+	error = xfs_inode_walk_ag(pag, 0, xfs_blockgc_scan_inode, NULL,
 			XFS_ICI_BLOCKGC_TAG);
 	if (error)
-		xfs_info(mp, "preallocation gc worker failed, err=%d", error);
+		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
+				pag->pag_agno, error);
 	sb_end_write(mp->m_super);
-	xfs_blockgc_queue(mp);
+	xfs_blockgc_queue(pag);
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ffafe7f4acaf..5b56c149e650 100644
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
index e625bece169b..d8fcd7fc2216 100644
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
index 83f79ff41114..fe4b9a924c6a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -35,6 +35,7 @@
 #include "xfs_refcount_item.h"
 #include "xfs_bmap_item.h"
 #include "xfs_reflink.h"
+#include "xfs_pwork.h"
 
 #include <linux/magic.h>
 #include <linux/fs_context.h>
@@ -516,7 +517,8 @@ xfs_init_mount_workqueues(
 		goto out_destroy_cil;
 
 	mp->m_blockgc_workqueue = alloc_workqueue("xfs-blockgc/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
+			WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_SYSFS,
+			0, mp->m_super->s_id);
 	if (!mp->m_blockgc_workqueue)
 		goto out_destroy_reclaim;
 
@@ -1387,6 +1389,31 @@ xfs_fs_validate_params(
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
+	unsigned int		threads = xfs_pwork_guess_metadata_threads(mp);
+	unsigned int		max_active;
+
+	/*
+	 * Background garbage collection of speculative preallocations are done
+	 * per-AG, so don't allow more threads than the AG count, the number of
+	 * CPUs, and the estimated parallelism of the storage device.
+	 */
+	max_active = min_t(unsigned int, threads, WQ_UNBOUND_MAX_ACTIVE);
+	workqueue_set_max_active(mp->m_blockgc_workqueue, max_active);
+}
+
 static int
 xfs_fs_fill_super(
 	struct super_block	*sb,
@@ -1452,6 +1479,8 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_free_sb;
 
+	xfs_configure_background_workqueues(mp);
+
 	error = xfs_setup_devices(mp);
 	if (error)
 		goto out_free_sb;
@@ -1872,7 +1901,6 @@ static int xfs_init_fs_context(
 	mutex_init(&mp->m_growlock);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
-	INIT_DELAYED_WORK(&mp->m_blockgc_work, xfs_blockgc_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
 	/*
 	 * We don't create the finobt per-ag space reservation until after log

