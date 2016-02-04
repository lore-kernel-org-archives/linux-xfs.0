Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D238829DFE
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 17:07:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4FA06AC001
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 15:07:39 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	nN0ygS2TqFhIUG58 for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 15:07:36 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRSxa-0000Ef-Cf
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 10:05:10 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRSxa-0004zG-CD
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 10:05:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/7] libxfs: keep unflushable buffers off the cache MRUs
Date: Fri,  5 Feb 2016 10:05:07 +1100
Message-Id: <1454627108-19036-7-git-send-email-david@fromorbit.com>
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

There's no point trying to free buffers that are dirty and return
errors on flush as we have to keep them around until the corruption
is fixed. Hence if we fail to flush an inode during a cache shake,
move the buffer to a special dirty MRU list that the cache does not
shake. This prevents memory pressure from seeing these buffers, but
allows subsequent cache lookups to still find them through the hash.
This ensures we don't waste huge amounts of CPU trying to flush and
reclaim buffers that canot be flushed or reclaimed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/cache.h |  3 ++-
 libxfs/cache.c  | 78 ++++++++++++++++++++++++++++++++++++++++++---------------
 2 files changed, 60 insertions(+), 21 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index 87826be..55761d3 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -51,6 +51,7 @@ enum {
 #define CACHE_BASE_PRIORITY	0
 #define CACHE_PREFETCH_PRIORITY	8
 #define CACHE_MAX_PRIORITY	15
+#define CACHE_DIRTY_PRIORITY	(CACHE_MAX_PRIORITY + 1)
 
 /*
  * Simple, generic implementation of a cache (arbitrary data).
@@ -115,7 +116,7 @@ struct cache {
 	unsigned int		c_hashsize;	/* hash bucket count */
 	unsigned int		c_hashshift;	/* hash key shift */
 	struct cache_hash	*c_hash;	/* hash table buckets */
-	struct cache_mru	c_mrus[CACHE_MAX_PRIORITY + 1];
+	struct cache_mru	c_mrus[CACHE_DIRTY_PRIORITY + 1];
 	unsigned long long	c_misses;	/* cache misses */
 	unsigned long long	c_hits;		/* cache hits */
 	unsigned int 		c_max;		/* max nodes ever used */
diff --git a/libxfs/cache.c b/libxfs/cache.c
index a48ebd9..d4b4a4e 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -81,7 +81,7 @@ cache_init(
 		pthread_mutex_init(&cache->c_hash[i].ch_mutex, NULL);
 	}
 
-	for (i = 0; i <= CACHE_MAX_PRIORITY; i++) {
+	for (i = 0; i <= CACHE_DIRTY_PRIORITY; i++) {
 		list_head_init(&cache->c_mrus[i].cm_list);
 		cache->c_mrus[i].cm_count = 0;
 		pthread_mutex_init(&cache->c_mrus[i].cm_mutex, NULL);
@@ -154,7 +154,7 @@ cache_destroy(
 		list_head_destroy(&cache->c_hash[i].ch_list);
 		pthread_mutex_destroy(&cache->c_hash[i].ch_mutex);
 	}
-	for (i = 0; i <= CACHE_MAX_PRIORITY; i++) {
+	for (i = 0; i <= CACHE_DIRTY_PRIORITY; i++) {
 		list_head_destroy(&cache->c_mrus[i].cm_list);
 		pthread_mutex_destroy(&cache->c_mrus[i].cm_mutex);
 	}
@@ -183,15 +183,45 @@ cache_generic_bulkrelse(
 }
 
 /*
- * We've hit the limit on cache size, so we need to start reclaiming
- * nodes we've used. The MRU specified by the priority is shaken.
- * Returns new priority at end of the call (in case we call again).
+ * Park unflushable nodes on their own special MRU so that cache_shake() doesn't
+ * end up repeatedly scanning them in the futile attempt to clean them before
+ * reclaim.
+ */
+static void
+cache_move_to_dirty_mru(
+	struct cache		*cache,
+	struct cache_node	*node)
+{
+	struct cache_mru	*mru;
+
+	mru = &cache->c_mrus[CACHE_DIRTY_PRIORITY];
+
+	pthread_mutex_lock(&mru->cm_mutex);
+	node->cn_priority = CACHE_DIRTY_PRIORITY;
+	list_move(&node->cn_mru, &mru->cm_list);
+	mru->cm_count++;
+	pthread_mutex_unlock(&mru->cm_mutex);
+}
+
+/*
+ * We've hit the limit on cache size, so we need to start reclaiming nodes we've
+ * used. The MRU specified by the priority is shaken.  Returns new priority at
+ * end of the call (in case we call again). We are not allowed to reclaim dirty
+ * objects, so we have to flush them first. If flushing fails, we move them to
+ * the "dirty, unreclaimable" list.
+ *
+ * Hence we skip priorities > CACHE_MAX_PRIORITY unless "purge" is set as we
+ * park unflushable (and hence unreclaimable) buffers at these priorities.
+ * Trying to shake unreclaimable buffer lists whent here is memory pressure is a
+ * waste of time and CPU and greatly slows down cache node recycling operations.
+ * Hence we only try to free them if we are being asked to purge the cache of
+ * all entries.
  */
 static unsigned int
 cache_shake(
 	struct cache *		cache,
 	unsigned int		priority,
-	int			all)
+	bool			purge)
 {
 	struct cache_mru	*mru;
 	struct cache_hash *	hash;
@@ -202,10 +232,11 @@ cache_shake(
 	struct cache_node *	node;
 	unsigned int		count;
 
-	ASSERT(priority <= CACHE_MAX_PRIORITY);
-	if (priority > CACHE_MAX_PRIORITY)
+	ASSERT(priority <= CACHE_DIRTY_PRIORITY);
+	if (priority > CACHE_MAX_PRIORITY && !purge)
 		priority = 0;
 
+
 	mru = &cache->c_mrus[priority];
 	count = 0;
 	list_head_init(&temp);
@@ -219,8 +250,10 @@ cache_shake(
 		if (pthread_mutex_trylock(&node->cn_mutex) != 0)
 			continue;
 
-		/* can't release dirty objects */
-		if (cache->flush(node)) {
+		/* memory pressure is not allowed to release dirty objects */
+		if (cache->flush(node) && !purge) {
+			cache_move_to_dirty_mru(cache, node);
+			mru->cm_count--;
 			pthread_mutex_unlock(&node->cn_mutex);
 			continue;
 		}
@@ -242,7 +275,7 @@ cache_shake(
 		pthread_mutex_unlock(&node->cn_mutex);
 
 		count++;
-		if (!all && count == CACHE_SHAKE_COUNT)
+		if (!purge && count == CACHE_SHAKE_COUNT)
 			break;
 	}
 	pthread_mutex_unlock(&mru->cm_mutex);
@@ -423,7 +456,7 @@ next_object:
 		node = cache_node_allocate(cache, key);
 		if (node)
 			break;
-		priority = cache_shake(cache, priority, 0);
+		priority = cache_shake(cache, priority, false);
 		/*
 		 * We start at 0; if we free CACHE_SHAKE_COUNT we get
 		 * back the same priority, if not we get back priority+1.
@@ -578,8 +611,8 @@ cache_purge(
 {
 	int			i;
 
-	for (i = 0; i <= CACHE_MAX_PRIORITY; i++)
-		cache_shake(cache, i, 1);
+	for (i = 0; i <= CACHE_DIRTY_PRIORITY; i++)
+		cache_shake(cache, i, true);
 
 #ifdef CACHE_DEBUG
 	if (cache->c_count != 0) {
@@ -626,13 +659,13 @@ cache_flush(
 #define	HASH_REPORT	(3 * HASH_CACHE_RATIO)
 void
 cache_report(
-	FILE 			*fp,
-	const char 		*name,
-	struct cache 		*cache)
+	FILE		*fp,
+	const char	*name,
+	struct cache	*cache)
 {
-	int 			i;
-	unsigned long 		count, index, total;
-	unsigned long 		hash_bucket_lengths[HASH_REPORT + 2];
+	int		i;
+	unsigned long	count, index, total;
+	unsigned long	hash_bucket_lengths[HASH_REPORT + 2];
 
 	if ((cache->c_hits + cache->c_misses) == 0)
 		return;
@@ -662,6 +695,11 @@ cache_report(
 			i, cache->c_mrus[i].cm_count,
 			cache->c_mrus[i].cm_count * 100 / cache->c_count);
 
+	i = CACHE_DIRTY_PRIORITY;
+	fprintf(fp, "Dirty MRU %d entries = %6u (%3u%%)\n",
+		i, cache->c_mrus[i].cm_count,
+		cache->c_mrus[i].cm_count * 100 / cache->c_count);
+
 	/* report hash bucket lengths */
 	bzero(hash_bucket_lengths, sizeof(hash_bucket_lengths));
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
