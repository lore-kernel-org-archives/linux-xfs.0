Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8855C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Mar 2022 22:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiC1WQe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Mar 2022 18:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiC1WQZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 18:16:25 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44B32165BA7
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 15:10:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 614A610E50D9
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 08:38:11 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nYx3y-00B3LS-Dp
        for linux-xfs@vger.kernel.org; Tue, 29 Mar 2022 08:38:10 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nYx3y-004van-BP
        for linux-xfs@vger.kernel.org;
        Tue, 29 Mar 2022 08:38:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: lockless buffer lookup
Date:   Tue, 29 Mar 2022 08:38:10 +1100
Message-Id: <20220328213810.1174688-1-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62422ac4
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=zCHahYewfXPSMZKt32gA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Current work to merge the XFS inode life cycle with the VFS indoe
life cycle is finding some interesting issues. If we have a path
that hits buffer trylocks fairly hard (e.g. a non-blocking
background inode freeing function), we end up hitting massive
contention on the buffer cache hash locks:

-   92.71%     0.05%  [kernel]                  [k] xfs_inodegc_worker
   - 92.67% xfs_inodegc_worker
      - 92.13% xfs_inode_unlink
         - 91.52% xfs_inactive_ifree
            - 85.63% xfs_read_agi
               - 85.61% xfs_trans_read_buf_map
                  - 85.59% xfs_buf_read_map
                     - xfs_buf_get_map
                        - 85.55% xfs_buf_find
                           - 72.87% _raw_spin_lock
                              - do_raw_spin_lock
                                   71.86% __pv_queued_spin_lock_slowpath
                           - 8.74% xfs_buf_rele
                              - 7.88% _raw_spin_lock
                                 - 7.88% do_raw_spin_lock
                                      7.63% __pv_queued_spin_lock_slowpath
                           - 1.70% xfs_buf_trylock
                              - 1.68% down_trylock
                                 - 1.41% _raw_spin_lock_irqsave
                                    - 1.39% do_raw_spin_lock
                                         __pv_queued_spin_lock_slowpath
                           - 0.76% _raw_spin_unlock
                                0.75% do_raw_spin_unlock

This is basically hammering the pag->pag_buf_lock from lots of CPUs
doing trylocks at the same time. Most of the buffer trylock
operations ultimately fail after we've done the lookup, so we're
really hammering the buf hash lock whilst making no progress.

We can also see significant spinlock traffic on the same lock just
under normal operation when lots of tasks are accessing metadata
from the same AG, so let's avoid all this by creating a lookup fast
path which leverages the rhashtable's ability to do rcu protected
lookups.

We avoid races with the buffer release path by using
atomic_inc_not_zero() on the buffer hold count. Any buffer that is
in the LRU will have a non-zero count, thereby allowing the lockless
fast path to be taken in most cache hit situations. If the buffer
hold count is zero, then it is likely going through the release path
so in that case we fall back to the existing lookup miss slow path.
i.e. we simply use the fallback path where the caller allocates a
new buf and retries the lookup, but this time holding the
pag->pag_buf_lock.

IOWs, if the caller provides a new buffer we take taht as a sign we
are on the slow path and we use the existing spinlock protected
path. If no buffer is provided, we use the new lockless
atomic_inc_not_zero() path and avoid the pag->pag_buf_lock
altogether.

The use of rcu protected lookups means that buffer handles now need
to be freed by RCU callbacks (same as inodes). We still free the
buffer pages before the RCU callback - we won't be trying to access
them at all on a buffer that has zero references - but we need the
buffer handle itself to be present for the entire rcu protected read
side to detect a zero hold count correctly.

We also avoid an extra atomic operation in the non-trylock case
by only doing a trylock if the XBF_TRYLOCK flag is set. This follows
the pattern in the IO path with NOWAIT semantics where the
"trylock-fail-lock" path showed 5-10% reduced throughput compared
to just using single lock call when not under NOWAIT conditions. SO
we make that same change here, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 57 +++++++++++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_buf.h |  1 +
 2 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 3617d9d2bc73..2073886ede1e 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -294,6 +294,16 @@ xfs_buf_free_pages(
 	bp->b_flags &= ~_XBF_PAGES;
 }
 
+static void
+xfs_buf_free_callback(
+	struct callback_head	*cb)
+{
+	struct xfs_buf		*bp = container_of(cb, struct xfs_buf, b_rcu);
+
+
+	xfs_buf_free_maps(bp);
+	kmem_cache_free(xfs_buf_cache, bp);
+}
 static void
 xfs_buf_free(
 	struct xfs_buf		*bp)
@@ -307,10 +317,10 @@ xfs_buf_free(
 	else if (bp->b_flags & _XBF_KMEM)
 		kmem_free(bp->b_addr);
 
-	xfs_buf_free_maps(bp);
-	kmem_cache_free(xfs_buf_cache, bp);
+	call_rcu(&bp->b_rcu, xfs_buf_free_callback);
 }
 
+
 static int
 xfs_buf_alloc_kmem(
 	struct xfs_buf	*bp,
@@ -521,6 +531,24 @@ xfs_buf_hash_destroy(
  *		- @new_bp if we inserted it into the cache
  *		- the buffer we found and locked.
  */
+
+static struct xfs_buf *
+xfs_buf_find_fast(
+	struct xfs_perag	*pag,
+	struct xfs_buf_map	*map)
+{
+	struct xfs_buf		*bp;
+
+	rcu_read_lock();
+	bp = rhashtable_lookup(&pag->pag_buf_hash, map, xfs_buf_hash_params);
+	if (bp) {
+		if (!atomic_inc_not_zero(&bp->b_hold))
+			bp = NULL;
+	}
+	rcu_read_unlock();
+	return bp;
+}
+
 static int
 xfs_buf_find(
 	struct xfs_buftarg	*btp,
@@ -561,20 +589,23 @@ xfs_buf_find(
 	pag = xfs_perag_get(btp->bt_mount,
 			    xfs_daddr_to_agno(btp->bt_mount, cmap.bm_bn));
 
+	if (!new_bp) {
+		bp = xfs_buf_find_fast(pag, &cmap);
+		if (bp)
+			goto found;
+		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
+		xfs_perag_put(pag);
+		return -ENOENT;
+	}
+
+
 	spin_lock(&pag->pag_buf_lock);
 	bp = rhashtable_lookup_fast(&pag->pag_buf_hash, &cmap,
 				    xfs_buf_hash_params);
 	if (bp) {
 		atomic_inc(&bp->b_hold);
-		goto found;
-	}
-
-	/* No match found */
-	if (!new_bp) {
-		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
 		spin_unlock(&pag->pag_buf_lock);
-		xfs_perag_put(pag);
-		return -ENOENT;
+		goto found;
 	}
 
 	/* the buffer keeps the perag reference until it is freed */
@@ -586,15 +617,15 @@ xfs_buf_find(
 	return 0;
 
 found:
-	spin_unlock(&pag->pag_buf_lock);
 	xfs_perag_put(pag);
 
-	if (!xfs_buf_trylock(bp)) {
-		if (flags & XBF_TRYLOCK) {
+	if (flags & XBF_TRYLOCK) {
+		if (!xfs_buf_trylock(bp)) {
 			xfs_buf_rele(bp);
 			XFS_STATS_INC(btp->bt_mount, xb_busy_locked);
 			return -EAGAIN;
 		}
+	} else {
 		xfs_buf_lock(bp);
 		XFS_STATS_INC(btp->bt_mount, xb_get_locked_waited);
 	}
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index edcb6254fa6a..cc6ba12c8499 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -193,6 +193,7 @@ struct xfs_buf {
 	int			b_last_error;
 
 	const struct xfs_buf_ops	*b_ops;
+	struct rcu_head		b_rcu;
 };
 
 /* Finding and Reading Buffers */
-- 
2.35.1

