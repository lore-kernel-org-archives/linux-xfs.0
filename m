Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49EDFC433EF
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Apr 2022 12:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235886AbiDCMDb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Apr 2022 08:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357131AbiDCMDa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Apr 2022 08:03:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D6B2E9EA
        for <linux-xfs@vger.kernel.org>; Sun,  3 Apr 2022 05:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=o5MXmB+/7LfzhvblXHV7QLG8u2LnQiJKmhB6d4Q6jNU=; b=yqPF8LCOgLL2xk6AguPKeF5xjo
        PeQg7C28AZN54uA3qGrAkAqNV7cdA6QcI8lOGtt64skgP/FId8QPVQ1i31JqiLTv9guw7/n3mGw1v
        VV0pP3AjH/jUhOzZIgzqt9cA2xIID/K8+hEOrIOkd7qTHzHFN6VOrNx2XXI18nyHanrnIPAh1DBY6
        IDiJ/zRbEinmlxzsCw06KxyWxU8UKLHDnNG4gQMGGoK51bea3ZaD+KODdBe8MmDyVw/zBkod8tcBt
        ExbnU9UGCC9C1CBV9FzaORDN20cW0wE2MGEOFEOcS/XH2sa8SPSml1XqfOrRbQxR5+UHbyMRcctXz
        Q2NI0jVA==;
Received: from [2001:4bb8:184:7553:31f9:976f:c3b1:7920] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nayvI-00BK4M-He; Sun, 03 Apr 2022 12:01:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5/5] xfs: lockless buffer lookup
Date:   Sun,  3 Apr 2022 14:01:19 +0200
Message-Id: <20220403120119.235457-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220403120119.235457-1-hch@lst.de>
References: <20220403120119.235457-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
new buf and tries to insert it, but this time holding the
pag->pag_buf_lock.

The use of rcu protected lookups means that buffer handles now need
to be freed by RCU callbacks (same as inodes). We still free the
buffer pages before the RCU callback - we won't be trying to access
them at all on a buffer that has zero references - but we need the
buffer handle itself to be present for the entire rcu protected read
side to detect a zero hold count correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[hch: rebased and split]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 25 +++++++++++++++++--------
 fs/xfs/xfs_buf.h |  1 +
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index dd68aee52118c2..2d6d57e80f56d5 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -295,6 +295,16 @@ xfs_buf_free_pages(
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
@@ -308,10 +318,10 @@ xfs_buf_free(
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
@@ -612,12 +622,11 @@ xfs_buf_get_map(
 
 	pag = xfs_perag_get(mp, xfs_daddr_to_agno(mp, cmap.bm_bn));
 
-	spin_lock(&pag->pag_buf_lock);
-	bp = rhashtable_lookup_fast(&pag->pag_buf_hash, &cmap,
-				    xfs_buf_hash_params);
-	if (bp)
-		atomic_inc(&bp->b_hold);
-	spin_unlock(&pag->pag_buf_lock);
+	rcu_read_lock();
+	bp = rhashtable_lookup(&pag->pag_buf_hash, &cmap, xfs_buf_hash_params);
+	if (bp && !atomic_inc_not_zero(&bp->b_hold))
+		bp = NULL;
+	rcu_read_unlock();
 
 	if (unlikely(!bp)) {
 		if (flags & XBF_NOALLOC) {
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index a28a2c5a496ab5..b74761a4e83025 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -194,6 +194,7 @@ struct xfs_buf {
 	int			b_last_error;
 
 	const struct xfs_buf_ops	*b_ops;
+	struct rcu_head		b_rcu;
 };
 
 /* Finding and Reading Buffers */
-- 
2.30.2

