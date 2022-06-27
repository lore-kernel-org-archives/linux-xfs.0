Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4594FCCA47E
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 06:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbiF0GIs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jun 2022 02:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbiF0GIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jun 2022 02:08:47 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E07826EF
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 23:08:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7F20310E7894
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 16:08:45 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5hvQ-00BZW7-8h
        for linux-xfs@vger.kernel.org; Mon, 27 Jun 2022 16:08:44 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o5hvQ-0011gi-7d
        for linux-xfs@vger.kernel.org;
        Mon, 27 Jun 2022 16:08:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/6] xfs: lockless buffer lookup
Date:   Mon, 27 Jun 2022 16:08:41 +1000
Message-Id: <20220627060841.244226-7-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627060841.244226-1-david@fromorbit.com>
References: <20220627060841.244226-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62b9496d
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=2c3CLYOzIkqHg1TAEHkA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that we have a standalone fast path for buffer lookup, we can
easily convert it to use rcu lookups. When we continually hammer the
buffer cache with trylock lookups, we end up with a huge amount of
lock contention on the per-ag buffer hash locks:

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
from the same AG, so let's avoid all this by converting the lookup
fast path to leverages the rhashtable's ability to do rcu protected
lookups.

We avoid races with the buffer release path by using
atomic_inc_not_zero() on the buffer hold count. Any buffer that is
in the LRU will have a non-zero count, thereby allowing the lockless
fast path to be taken in most cache hit situations. If the buffer
hold count is zero, then it is likely going through the release path
so in that case we fall back to the existing lookup miss slow path.

The slow path will then do an atomic lookup and insert under the
buffer hash lock and hence serialise correctly against buffer
release freeing the buffer.

The use of rcu protected lookups means that buffer handles now need
to be freed by RCU callbacks (same as inodes). We still free the
buffer pages before the RCU callback - we won't be trying to access
them at all on a buffer that has zero references - but we need the
buffer handle itself to be present for the entire rcu protected read
side to detect a zero hold count correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 22 +++++++++++++++-------
 fs/xfs/xfs_buf.h |  1 +
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 3461ef3ebc1c..14a2d2d6a4e0 100644
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
+	xfs_buf_free_maps(bp);
+	kmem_cache_free(xfs_buf_cache, bp);
+}
+
 static void
 xfs_buf_free(
 	struct xfs_buf		*bp)
@@ -307,8 +317,7 @@ xfs_buf_free(
 	else if (bp->b_flags & _XBF_KMEM)
 		kmem_free(bp->b_addr);
 
-	xfs_buf_free_maps(bp);
-	kmem_cache_free(xfs_buf_cache, bp);
+	call_rcu(&bp->b_rcu, xfs_buf_free_callback);
 }
 
 static int
@@ -567,14 +576,13 @@ xfs_buf_find_fast(
 	struct xfs_buf          *bp;
 	int			error;
 
-	spin_lock(&pag->pag_buf_lock);
+	rcu_read_lock();
 	bp = rhashtable_lookup(&pag->pag_buf_hash, map, xfs_buf_hash_params);
-	if (!bp) {
-		spin_unlock(&pag->pag_buf_lock);
+	if (!bp || !atomic_inc_not_zero(&bp->b_hold)) {
+		rcu_read_unlock();
 		return -ENOENT;
 	}
-	atomic_inc(&bp->b_hold);
-	spin_unlock(&pag->pag_buf_lock);
+	rcu_read_unlock();
 
 	error = xfs_buf_find_lock(bp, flags);
 	if (error) {
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 58e9034d51bd..02b3c1635ec3 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -196,6 +196,7 @@ struct xfs_buf {
 	int			b_last_error;
 
 	const struct xfs_buf_ops	*b_ops;
+	struct rcu_head		b_rcu;
 };
 
 /* Finding and Reading Buffers */
-- 
2.36.1

