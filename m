Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AACBC29DFE
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 15:37:34 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5593CAC004
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 13:37:34 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	TbCC22T7X4BmjFyz for <xfs@oss.sgi.com>;
	Mon, 21 Dec 2015 13:37:32 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aB88m-0000hx-FP
	for xfs@oss.sgi.com; Tue, 22 Dec 2015 08:37:12 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aB88m-0002li-EZ
	for xfs@oss.sgi.com; Tue, 22 Dec 2015 08:37:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 9/9] libxfs: keep unflushable buffers off the cache MRUs
Date: Tue, 22 Dec 2015 08:37:09 +1100
Message-Id: <1450733829-9319-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1450733829-9319-1-git-send-email-david@fromorbit.com>
References: <1450733829-9319-1-git-send-email-david@fromorbit.com>
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
 libxfs/cache.c  | 34 +++++++++++++++++++++++++++++-----
 2 files changed, 31 insertions(+), 6 deletions(-)

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
index a48ebd9..d5ea461 100644
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
@@ -183,6 +183,27 @@ cache_generic_bulkrelse(
 }
 
 /*
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
  * We've hit the limit on cache size, so we need to start reclaiming
  * nodes we've used. The MRU specified by the priority is shaken.
  * Returns new priority at end of the call (in case we call again).
@@ -202,10 +223,11 @@ cache_shake(
 	struct cache_node *	node;
 	unsigned int		count;
 
-	ASSERT(priority <= CACHE_MAX_PRIORITY);
-	if (priority > CACHE_MAX_PRIORITY)
+	ASSERT(priority <= CACHE_DIRTY_PRIORITY);
+	if (priority > CACHE_MAX_PRIORITY && !all)
 		priority = 0;
 
+
 	mru = &cache->c_mrus[priority];
 	count = 0;
 	list_head_init(&temp);
@@ -221,6 +243,8 @@ cache_shake(
 
 		/* can't release dirty objects */
 		if (cache->flush(node)) {
+			cache_move_to_dirty_mru(cache, node);
+			mru->cm_count--;
 			pthread_mutex_unlock(&node->cn_mutex);
 			continue;
 		}
@@ -578,7 +602,7 @@ cache_purge(
 {
 	int			i;
 
-	for (i = 0; i <= CACHE_MAX_PRIORITY; i++)
+	for (i = 0; i <= CACHE_DIRTY_PRIORITY; i++)
 		cache_shake(cache, i, 1);
 
 #ifdef CACHE_DEBUG
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
