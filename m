Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 46BD229DFE
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 17:07:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BDB9CAC006
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 15:07:36 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	v9IdJmCj0AvKP0Cw for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 15:07:34 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRSxa-0000Ed-Bz
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 10:05:10 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRSxa-0004z6-BP
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 10:05:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/7] libxfs: don't discard dirty buffers
Date: Fri,  5 Feb 2016 10:05:05 +1100
Message-Id: <1454627108-19036-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1454627108-19036-1-git-send-email-david@fromorbit.com>
References: <1454627108-19036-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When we release a buffer from the cache, if it is dirty we wite it
to disk then put the buffer on the free list for recycling. However,
if the write fails (e.g. verifier failure due unfixed corruption) we
effectively throw the buffer and it contents away. This causes all
sorts of problems for xfs_repair as it then re-reads the buffer from
disk on the next access and hence loses all the corrections that had
previously been made, resulting in tripping over corruptions in code
that assumes the corruptions have already been fixed/flagged in the
buffer it receives.

TO fix this, we have to make the cache aware that writes can fail,
and keep the buffer in cache when writes fail. Hence we have to add
an explicit error notification to the flush operation, and we need
to do that before we release the buffer to the free list. This also
means that we need to remove the writeback code from the release
mechanisms, instead replacing them with assertions that the buffers
are already clean.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 include/cache.h |  2 +-
 libxfs/cache.c  | 15 ++++++++++++++-
 libxfs/rdwr.c   | 44 +++++++++++++++++++++++++++-----------------
 3 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index 0a84c69..87826be 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -64,7 +64,7 @@ typedef void *cache_key_t;
 
 typedef void (*cache_walk_t)(struct cache_node *);
 typedef struct cache_node * (*cache_node_alloc_t)(cache_key_t);
-typedef void (*cache_node_flush_t)(struct cache_node *);
+typedef int (*cache_node_flush_t)(struct cache_node *);
 typedef void (*cache_node_relse_t)(struct cache_node *);
 typedef unsigned int (*cache_node_hash_t)(cache_key_t, unsigned int,
 					  unsigned int);
diff --git a/libxfs/cache.c b/libxfs/cache.c
index 4753a1d..a48ebd9 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -219,6 +219,12 @@ cache_shake(
 		if (pthread_mutex_trylock(&node->cn_mutex) != 0)
 			continue;
 
+		/* can't release dirty objects */
+		if (cache->flush(node)) {
+			pthread_mutex_unlock(&node->cn_mutex);
+			continue;
+		}
+
 		hash = cache->c_hash + node->cn_hashidx;
 		if (pthread_mutex_trylock(&hash->ch_mutex) != 0) {
 			pthread_mutex_unlock(&node->cn_mutex);
@@ -311,6 +317,13 @@ __cache_node_purge(
 		pthread_mutex_unlock(&node->cn_mutex);
 		return count;
 	}
+
+	/* can't purge dirty objects */
+	if (cache->flush(node)) {
+		pthread_mutex_unlock(&node->cn_mutex);
+		return 1;
+	}
+
 	mru = &cache->c_mrus[node->cn_priority];
 	pthread_mutex_lock(&mru->cm_mutex);
 	list_del_init(&node->cn_mru);
@@ -321,7 +334,7 @@ __cache_node_purge(
 	pthread_mutex_destroy(&node->cn_mutex);
 	list_del_init(&node->cn_hash);
 	cache->relse(node);
-	return count;
+	return 0;
 }
 
 /*
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 7b23394..37162cd 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -659,6 +659,8 @@ __libxfs_getbufr(int blen)
 		bp = kmem_zone_zalloc(xfs_buf_zone, 0);
 	pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
 	bp->b_ops = NULL;
+	if (bp->b_flags & LIBXFS_B_DIRTY)
+		fprintf(stderr, "found dirty buffer (bulk) on free list!");
 
 	return bp;
 }
@@ -1223,23 +1225,26 @@ libxfs_iomove(xfs_buf_t *bp, uint boff, int len, void *data, int flags)
 }
 
 static void
-libxfs_brelse(struct cache_node *node)
+libxfs_brelse(
+	struct cache_node	*node)
 {
-	xfs_buf_t		*bp = (xfs_buf_t *)node;
+	struct xfs_buf		*bp = (struct xfs_buf *)node;
 
-	if (bp != NULL) {
-		if (bp->b_flags & LIBXFS_B_DIRTY)
-			libxfs_writebufr(bp);
-		pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
-		list_add(&bp->b_node.cn_mru, &xfs_buf_freelist.cm_list);
-		pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
-	}
+	if (!bp)
+		return;
+	if (bp->b_flags & LIBXFS_B_DIRTY)
+		fprintf(stderr,
+			"releasing dirty buffer to free list!");
+
+	pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
+	list_add(&bp->b_node.cn_mru, &xfs_buf_freelist.cm_list);
+	pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
 }
 
 static unsigned int
 libxfs_bulkrelse(
-	struct cache 		*cache,
-	struct list_head 	*list)
+	struct cache		*cache,
+	struct list_head	*list)
 {
 	xfs_buf_t		*bp;
 	int			count = 0;
@@ -1249,7 +1254,8 @@ libxfs_bulkrelse(
 
 	list_for_each_entry(bp, list, b_node.cn_mru) {
 		if (bp->b_flags & LIBXFS_B_DIRTY)
-			libxfs_writebufr(bp);
+			fprintf(stderr,
+				"releasing dirty buffer (bulk) to free list!");
 		count++;
 	}
 
@@ -1260,18 +1266,22 @@ libxfs_bulkrelse(
 	return count;
 }
 
-static void
-libxfs_bflush(struct cache_node *node)
+static int
+libxfs_bflush(
+	struct cache_node	*node)
 {
-	xfs_buf_t		*bp = (xfs_buf_t *)node;
+	struct xfs_buf		*bp = (struct xfs_buf *)node;
 
-	if ((bp != NULL) && (bp->b_flags & LIBXFS_B_DIRTY))
-		libxfs_writebufr(bp);
+	if (bp->b_flags & LIBXFS_B_DIRTY)
+		return libxfs_writebufr(bp);
+	return 0;
 }
 
 void
 libxfs_putbufr(xfs_buf_t *bp)
 {
+	if (bp->b_flags & LIBXFS_B_DIRTY)
+		libxfs_writebufr(bp);
 	libxfs_brelse((struct cache_node *)bp);
 }
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
