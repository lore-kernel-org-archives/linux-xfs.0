Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90F8DC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 486A82224A
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbgJOHW0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:26 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:36906 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729372AbgJOHWU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:20 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9AADF58C4C2
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaH-000hvz-1V
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:57 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qMG-Pt
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 19/27] libxfs: add cache infrastructure to buftarg
Date:   Thu, 15 Oct 2020 18:21:47 +1100
Message-Id: <20201015072155.1631135-20-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=x5wWkfYA1LKM9i2yIWUA:9
        a=x4Xgtp46iP6OM8GB:21 a=gq8mzyBJ9W_4B6FF:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Add a hash cache interface to the libxfs buftarg implementation.
This is a massively cut down version of the existing cache, just
with all the stuff the buftarg will provide chopped out of it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_mount.h  |   3 +
 libxfs/buftarg.c     | 233 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_io.h   |   3 +-
 libxfs/xfs_buftarg.h |  45 +++++++++
 4 files changed, 283 insertions(+), 1 deletion(-)

diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index d78c4cdc4f78..114d9744d114 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -10,6 +10,7 @@
 struct xfs_inode;
 struct xfs_buftarg;
 struct xfs_da_geometry;
+struct btcache;
 
 /*
  * Define a user-level mount structure with all we need
@@ -155,6 +156,8 @@ typedef struct xfs_perag {
 
 	/* reference count */
 	uint8_t		pagf_refcount_level;
+
+	struct btcache	*pag_buf_hash;
 } xfs_perag_t;
 
 static inline struct xfs_ag_resv *
diff --git a/libxfs/buftarg.c b/libxfs/buftarg.c
index 1f6a89d14ec6..4f4254e4fd70 100644
--- a/libxfs/buftarg.c
+++ b/libxfs/buftarg.c
@@ -425,3 +425,236 @@ xfs_buf_associate_memory(
 	bp->b_length = BTOBB(len);
 	return 0;
 }
+
+/*
+ * Buffer cache hash implementation
+ */
+
+struct btcache *
+btc_init(
+	unsigned int	hashsize)
+{
+	struct btcache	*btc;
+	unsigned int	i, maxcount;
+
+	maxcount = hashsize * HASH_CACHE_RATIO;
+
+	btc = malloc(sizeof(struct btcache));
+	if (!btc)
+		return NULL;
+	btc->hash = calloc(hashsize, sizeof(struct btcache_hash));
+	if (!btc->hash) {
+		free(btc);
+		return NULL;
+	}
+
+	atomic_set(&btc->count, 0);
+	btc->max = 0;
+	btc->hits = 0;
+	btc->misses = 0;
+	btc->maxcount = maxcount;
+	btc->hashsize = hashsize;
+	btc->hashshift = libxfs_highbit32(hashsize);
+	pthread_mutex_init(&btc->lock, NULL);
+
+	for (i = 0; i < hashsize; i++) {
+		list_head_init(&btc->hash[i].chain);
+		btc->hash[i].count = 0;
+		pthread_mutex_init(&btc->hash[i].lock, NULL);
+	}
+
+	return btc;
+}
+
+void
+btc_destroy(
+	struct btcache	*btc)
+{
+	unsigned int		i;
+
+	if (!btc)
+		return;
+
+	for (i = 0; i < btc->hashsize; i++) {
+		list_head_destroy(&btc->hash[i].chain);
+		pthread_mutex_destroy(&btc->hash[i].lock);
+	}
+	pthread_mutex_destroy(&btc->lock);
+	free(btc->hash);
+	free(btc);
+}
+
+
+#define	HASH_REPORT	(3 * HASH_CACHE_RATIO)
+void
+btc_report_ag(
+	FILE		*fp,
+	const char	*name,
+	xfs_agnumber_t	agno,
+	struct btcache	*btc)
+{
+	int		i;
+	unsigned long	count, index, total;
+	unsigned long	hash_bucket_lengths[HASH_REPORT + 2];
+
+	if ((btc->hits + btc->misses) == 0)
+		return;
+
+	/* report btc summary */
+	fprintf(fp, "%8u|\t%9u\t%9u\t%8u\t%8u\t%8llu\t%8llu\t%5.2f\n",
+			agno,
+			btc->maxcount,
+			btc->max,
+			atomic_read(&btc->count),
+			btc->hashsize,
+			btc->hits,
+			btc->misses,
+			(double)btc->hits * 100 /
+				(btc->hits + btc->misses)
+	);
+
+	/* report hash bucket lengths */
+	memset(hash_bucket_lengths, 0, sizeof(hash_bucket_lengths));
+
+	for (i = 0; i < btc->hashsize; i++) {
+		count = btc->hash[i].count;
+		if (count > HASH_REPORT)
+			index = HASH_REPORT + 1;
+		else
+			index = count;
+		hash_bucket_lengths[index]++;
+	}
+
+	total = 0;
+	for (i = 0; i < HASH_REPORT + 1; i++) {
+		total += i * hash_bucket_lengths[i];
+		if (hash_bucket_lengths[i] == 0)
+			continue;
+		fprintf(fp, "Hash buckets with  %2d entries %6ld (%3ld%%)\n",
+			i, hash_bucket_lengths[i],
+			(i * hash_bucket_lengths[i] * 100) /
+					atomic_read(&btc->count));
+	}
+	if (hash_bucket_lengths[i])	/* last report bucket is the overflow bucket */
+		fprintf(fp, "Hash buckets with >%2d entries %6ld (%3ld%%)\n",
+			i - 1, hash_bucket_lengths[i],
+			((btc->count - total) * 100) /
+					atomic_read(&btc->count));
+}
+
+void
+btc_report(
+	FILE		*fp,
+	const char	*name,
+	struct xfs_mount *mp)
+{
+	int i;
+
+	if (!mp)
+		return;
+
+	fprintf(fp, "%s: Per-AG summary\n", name);
+	fprintf(fp, "AG\t|\t\tEntries\t\t|\t\tHash Table\n");
+	fprintf(fp, "\t|\tSupported\tUtilised\tActive\tSize\tHits\tMisses\tRatio\n");
+	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+		struct xfs_perag *pag = xfs_perag_get(mp, i);
+
+		btc_report_ag(fp, name, i, pag->pag_buf_hash);
+
+		xfs_perag_put(pag);
+	}
+}
+
+/*  2^63 + 2^61 - 2^57 + 2^54 - 2^51 - 2^18 + 1 */
+#define GOLDEN_RATIO_PRIME	0x9e37fffffffc0001UL
+#define CACHE_LINE_SIZE		64
+static unsigned int
+btchash(xfs_daddr_t blkno, unsigned int hashsize, unsigned int hashshift)
+{
+	uint64_t	hashval = blkno;
+	uint64_t	tmp;
+
+	tmp = hashval ^ (GOLDEN_RATIO_PRIME + hashval) / CACHE_LINE_SIZE;
+	tmp = tmp ^ ((tmp ^ GOLDEN_RATIO_PRIME) >> hashshift);
+	return tmp % hashsize;
+}
+
+struct xfs_buf *
+btc_node_find(
+	struct btcache		*btc,
+	struct xfs_buf_map	*map)
+{
+	struct xfs_buf		*bp = NULL;
+	struct btcache_hash	*hash;
+	struct list_head	*head;
+	unsigned int		hashidx;
+
+
+	hashidx = btchash(map->bm_bn, btc->hashsize, btc->hashshift);
+	hash = btc->hash + hashidx;
+	head = &hash->chain;
+
+	pthread_mutex_lock(&hash->lock);
+	list_for_each_entry(bp, head, b_hash) {
+		if (bp->b_bn != map->bm_bn)
+			continue;
+
+		if (bp->b_length != map->bm_len) {
+			/*
+			 * found a block number match. If the range doesn't
+			 * match, the only way this is allowed is if the buffer
+			 * in the btc is stale and the transaction that made
+			 * it stale has not yet committed. i.e. we are
+			 * reallocating a busy extent. Skip this buffer and
+			 * continue searching for an exact match.
+			 */
+			ASSERT(bp->b_flags & XBF_STALE);
+			continue;
+		}
+		btc->hits++;
+		pthread_mutex_unlock(&hash->lock);
+		return bp;
+
+	}
+	btc->misses++;
+	pthread_mutex_unlock(&hash->lock);
+	return NULL;
+}
+
+void
+btc_node_insert(
+	struct btcache		*btc,
+	struct xfs_buf		*bp)
+{
+	struct btcache_hash	*hash;
+	struct list_head	*head;
+	unsigned int		hashidx;
+
+	hashidx = btchash(bp->b_bn, btc->hashsize, btc->hashshift);
+	hash = btc->hash + hashidx;
+	head = &hash->chain;
+
+	pthread_mutex_lock(&hash->lock);
+	list_add(&bp->b_hash, head);
+	hash->count++;
+	atomic_inc(&btc->count);
+	pthread_mutex_unlock(&hash->lock);
+}
+
+void
+btc_node_remove(
+	struct btcache		*btc,
+	struct xfs_buf		*bp)
+{
+	struct btcache_hash	*hash;
+	unsigned int		hashidx;
+
+	hashidx = btchash(bp->b_bn, btc->hashsize, btc->hashshift);
+	hash = btc->hash + hashidx;
+
+	pthread_mutex_lock(&hash->lock);
+	list_del(&bp->b_hash);
+	hash->count--;
+	atomic_dec(&btc->count);
+	pthread_mutex_unlock(&hash->lock);
+}
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index c17cdc33bf2a..31c21abce8c9 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -44,9 +44,10 @@ struct xfs_buf_ops {
 
 struct xfs_buf {
 	struct cache_node	b_node;
-	unsigned int		b_flags;
+	struct list_head	b_hash;	/* will replace b_node */
 	xfs_daddr_t		b_bn;
 	unsigned int		b_length;
+	unsigned int		b_flags;
 	struct xfs_buftarg	*b_target;
 	pthread_mutex_t		b_lock;
 	pthread_t		b_holder;
diff --git a/libxfs/xfs_buftarg.h b/libxfs/xfs_buftarg.h
index 7d2a7ab29c0f..fee20c60db1c 100644
--- a/libxfs/xfs_buftarg.h
+++ b/libxfs/xfs_buftarg.h
@@ -13,6 +13,10 @@ struct xfs_buf_ops;
 
 #define XFS_BUF_DADDR_NULL ((xfs_daddr_t) (-1LL))
 
+struct xfs_buf;
+struct xfs_buf_map;
+struct xfs_mount;
+
 /*
  * The xfs_buftarg contains 2 notions of "sector size" -
  *
@@ -101,4 +105,45 @@ int xfs_bwrite(struct xfs_buf *bp);
 struct xfs_buf *libxfs_getbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno,
 			int bblen);
 
+/*
+ * Hash cache implementation
+ */
+/*
+ * xfs_db always writes changes immediately, and so we need to purge buffers
+ * when we get a buffer lookup mismatch due to reading the same block with a
+ * different buffer configuration.
+ *
+ * XXX: probably need to re-implement this
+ */
+#define CACHE_MISCOMPARE_PURGE	(1 << 0)
+
+#define	HASH_CACHE_RATIO	8
+
+struct btcache_hash {
+	struct list_head	chain;
+	unsigned int		count;
+	pthread_mutex_t		lock;
+};
+
+struct btcache {
+	int			flags;		/* behavioural flags */
+	unsigned int		maxcount;	/* max cache nodes */
+	atomic_t		count;		/* count of nodes */
+	pthread_mutex_t		lock;		/* node count mutex */
+	unsigned int		hashsize;	/* hash bucket count */
+	unsigned int		hashshift;	/* hash key shift */
+	struct btcache_hash	*hash;		/* hash table buckets */
+	unsigned long long	misses;		/* cache misses */
+	unsigned long long	hits;		/* cache hits */
+	unsigned int		max;		/* max nodes ever used */
+};
+
+struct btcache *btc_init(unsigned int hashsize);
+void btc_destroy(struct btcache *cache);
+
+struct xfs_buf *btc_node_find(struct btcache *cache, struct xfs_buf_map *map);
+void btc_node_insert(struct btcache *cache, struct xfs_buf *bp);
+void btc_node_remove(struct btcache *cache, struct xfs_buf *bp);
+void btc_report(FILE *fp, const char *name, struct xfs_mount *mp);
+
 #endif /* __XFS_BUFTARG_H */
-- 
2.28.0

