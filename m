Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94F3C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8484B22D57
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbhAWSyd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:54:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:35770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbhAWSy2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:54:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B89D22D50;
        Sat, 23 Jan 2021 18:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611428050;
        bh=iCK8RwchSHsQwmLCEyJ5t0KdZy3KAhmwbhPloaCLB7s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=psjoyUR0JbzSMJWMMmwsM2N1QF/YvhEuEN2k5bjM5N0BxVEnhfmRJNJ2CK2Wwlgl4
         oHjXmgrC1aeiOjkyn9MkNqP3JSvi68qhinbgoyFuaNoiJqPJLG8U/ViRBOvrg7KwN/
         yubIg8MFW+KoJgNf6yBXZjPgijwRmztwIeDUy1cQXtxR9sdiEEK2F1wqKfs9cyW5cO
         Psuf26fv6TERfrrrlawK2pR7qX4eWkpn1q7j0Wc4vib9aeyAmsGJ5r2+GZIv1TICZl
         tjEOWG+5pqlPA+gyk+vEByi/GJpJzzOmsRVY5qTHpJnJcvqYSf9f3uk2gx4Ri4EjVJ
         ggCZ6jrUg8+OQ==
Subject: [PATCH 9/9] xfs: parallelize block preallocation garbage collection
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:54:12 -0800
Message-ID: <161142805211.2173480.18150564632716126076.stgit@magnolia>
In-Reply-To: <161142800187.2173480.17415824680111946713.stgit@magnolia>
References: <161142800187.2173480.17415824680111946713.stgit@magnolia>
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
 fs/xfs/xfs_super.c  |    6 +++---
 4 files changed, 39 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 34cee5fc2d95..f23e90fea12c 100644
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
index be9ce114527f..52370d0a3f43 100644
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
index 316e0d79cc40..659ad95fe3e0 100644
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
index 40bfb7074e50..c4ed1cb54d4e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -35,6 +35,7 @@
 #include "xfs_refcount_item.h"
 #include "xfs_bmap_item.h"
 #include "xfs_reflink.h"
+#include "xfs_pwork.h"
 
 #include <linux/magic.h>
 #include <linux/fs_context.h>
@@ -519,8 +520,8 @@ xfs_init_mount_workqueues(
 		goto out_destroy_cil;
 
 	mp->m_blockgc_workqueue = alloc_workqueue("xfs-blockgc/%s",
-			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_FREEZABLE, 0,
-			mp->m_super->s_id);
+			WQ_UNBOUND | WQ_SYSFS | WQ_MEM_RECLAIM | WQ_FREEZABLE,
+			0, mp->m_super->s_id);
 	if (!mp->m_blockgc_workqueue)
 		goto out_destroy_reclaim;
 
@@ -1842,7 +1843,6 @@ static int xfs_init_fs_context(
 	mutex_init(&mp->m_growlock);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
-	INIT_DELAYED_WORK(&mp->m_blockgc_work, xfs_blockgc_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
 	/*
 	 * We don't create the finobt per-ag space reservation until after log

