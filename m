Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9916C2D0A4
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 702732224E
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbgJOHWM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:12 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60707 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728392AbgJOHWM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:12 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7ED133AB16A
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaH-000hw3-2O
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:57 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qMJ-Qy
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 20/27] libxfs: add internal lru to btcache
Date:   Thu, 15 Oct 2020 18:21:48 +1100
Message-Id: <20201015072155.1631135-21-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=qzw9SnwTI2Poselfcp0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

THis tracks all the buffers in a given btcache, hence allowing us to
purge all the buffers from a cache without having to walk the global
buffer cache LRU list.

This will useful for per-AG scan operations, allowing us to purge
the cache when we've completed processing on specific AGs and don't
need the cache anymore.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/buftarg.c     | 63 +++++++++++++++++++++++++++++++++++++++++++-
 libxfs/libxfs_io.h   |  8 ++++++
 libxfs/rdwr.c        |  4 +--
 libxfs/xfs_buftarg.h |  2 ++
 4 files changed, 73 insertions(+), 4 deletions(-)

diff --git a/libxfs/buftarg.c b/libxfs/buftarg.c
index 4f4254e4fd70..dbecab833cb2 100644
--- a/libxfs/buftarg.c
+++ b/libxfs/buftarg.c
@@ -428,8 +428,16 @@ xfs_buf_associate_memory(
 
 /*
  * Buffer cache hash implementation
+*
+ * Lock orders:
+ *
+ * hash->lock		cache hash chain lock
+ *  btc->lock		cache lock
+ *
+ * btc->lock		cache lock
+ *  bp->b_lock		buffer state lock
+ *
  */
-
 struct btcache *
 btc_init(
 	unsigned int	hashsize)
@@ -456,6 +464,7 @@ btc_init(
 	btc->hashsize = hashsize;
 	btc->hashshift = libxfs_highbit32(hashsize);
 	pthread_mutex_init(&btc->lock, NULL);
+	list_head_init(&btc->lru);
 
 	for (i = 0; i < hashsize; i++) {
 		list_head_init(&btc->hash[i].chain);
@@ -475,6 +484,7 @@ btc_destroy(
 	if (!btc)
 		return;
 
+	list_head_destroy(&btc->lru);
 	for (i = 0; i < btc->hashsize; i++) {
 		list_head_destroy(&btc->hash[i].chain);
 		pthread_mutex_destroy(&btc->hash[i].lock);
@@ -635,6 +645,10 @@ btc_node_insert(
 	head = &hash->chain;
 
 	pthread_mutex_lock(&hash->lock);
+	pthread_mutex_lock(&btc->lock);
+	list_add(&bp->b_btc_list, &btc->lru);
+	pthread_mutex_unlock(&btc->lock);
+
 	list_add(&bp->b_hash, head);
 	hash->count++;
 	atomic_inc(&btc->count);
@@ -653,8 +667,55 @@ btc_node_remove(
 	hash = btc->hash + hashidx;
 
 	pthread_mutex_lock(&hash->lock);
+	pthread_mutex_lock(&btc->lock);
+	list_del(&bp->b_btc_list);
+	pthread_mutex_unlock(&btc->lock);
+
 	list_del(&bp->b_hash);
 	hash->count--;
 	atomic_dec(&btc->count);
 	pthread_mutex_unlock(&hash->lock);
 }
+
+/*
+ * Purge the buffers from the cache list.
+ *
+ * This is nasty - it steals the buffer cache LRU reference and drops it,
+ * using the dispose flag to indicate it's about to go away.
+ */
+static void
+btc_purge_buffers(
+	struct btcache		*btc)
+{
+	struct xfs_buf          *bp, *n;
+	LIST_HEAD               (dispose);
+
+	pthread_mutex_lock(&btc->lock);
+	list_for_each_entry_safe(bp, n, &btc->lru, b_btc_list) {
+		if (bp->b_state & XFS_BSTATE_DISPOSE)
+			continue;
+		spin_lock(&bp->b_lock);
+		atomic_set(&bp->b_lru_ref, 0);
+		bp->b_state |= XFS_BSTATE_DISPOSE;
+		list_move(&bp->b_btc_list, &dispose);
+		spin_unlock(&bp->b_lock);
+	}
+	pthread_mutex_unlock(&btc->lock);
+
+	while (!list_empty(&dispose)) {
+		bp = list_first_entry(&dispose, struct xfs_buf, b_btc_list);
+		list_del_init(&bp->b_btc_list);
+		libxfs_brelse(&bp->b_node);
+	}
+}
+
+void
+xfs_buftarg_purge_ag(
+	struct xfs_buftarg	*btp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_perag	*pag = xfs_perag_get(btp->bt_mount, agno);
+
+	btc_purge_buffers(pag->pag_buf_hash);
+	xfs_perag_put(pag);
+}
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 31c21abce8c9..2e7c943d8978 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -42,6 +42,8 @@ struct xfs_buf_ops {
 	xfs_failaddr_t (*verify_struct)(struct xfs_buf *);
 };
 
+#define XFS_BSTATE_DISPOSE       (1 << 0)       /* buffer being discarded */
+
 struct xfs_buf {
 	struct cache_node	b_node;
 	struct list_head	b_hash;	/* will replace b_node */
@@ -66,6 +68,10 @@ struct xfs_buf {
 	int			b_io_remaining;
 	int			b_io_error;
 	struct list_head	b_list;
+
+	struct list_head	b_btc_list;
+	unsigned int		b_state;
+	atomic_t		b_lru_ref;
 };
 
 bool xfs_verify_magic(struct xfs_buf *bp, __be32 dmagic);
@@ -98,6 +104,8 @@ int libxfs_buf_priority(struct xfs_buf *bp);
 
 extern struct cache	*libxfs_bcache;
 extern struct cache_operations	libxfs_bcache_operations;
+void libxfs_brelse(struct cache_node *node);
+
 
 #define LIBXFS_GETBUF_TRYLOCK	(1 << 0)
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 371a6d221bb2..fcc4ff9b394e 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -21,8 +21,6 @@
 
 #include "libxfs.h"
 
-static void libxfs_brelse(struct cache_node *node);
-
 /*
  * Important design/architecture note:
  *
@@ -740,7 +738,7 @@ libxfs_whine_dirty_buf(
 	bp->b_target->flags |= XFS_BUFTARG_LOST_WRITE;
 }
 
-static void
+void
 libxfs_brelse(
 	struct cache_node	*node)
 {
diff --git a/libxfs/xfs_buftarg.h b/libxfs/xfs_buftarg.h
index fee20c60db1c..129b43e037ad 100644
--- a/libxfs/xfs_buftarg.h
+++ b/libxfs/xfs_buftarg.h
@@ -55,6 +55,7 @@ struct xfs_buftarg *xfs_buftarg_alloc(struct xfs_mount *mp, dev_t bdev);
 void xfs_buftarg_free(struct xfs_buftarg *target);
 void xfs_buftarg_wait(struct xfs_buftarg *target);
 int xfs_buftarg_setsize(struct xfs_buftarg *target, unsigned int size);
+void xfs_buftarg_purge_ag(struct xfs_buftarg *btp, xfs_agnumber_t agno);
 
 #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
 
@@ -136,6 +137,7 @@ struct btcache {
 	unsigned long long	misses;		/* cache misses */
 	unsigned long long	hits;		/* cache hits */
 	unsigned int		max;		/* max nodes ever used */
+	struct list_head	lru;		/* list of all items in cache */
 };
 
 struct btcache *btc_init(unsigned int hashsize);
-- 
2.28.0

