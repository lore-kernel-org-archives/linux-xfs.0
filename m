Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CF13629E2A
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 19:07:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5267DAC002
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 17:07:50 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	7gZvwUvUWXJ9YClQ for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 17:07:48 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vdrak-0003Om-H2
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vdrak-0008WF-GW
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 29/37] xfs_db: avoid libxfs buffer lookup warnings
Date: Wed,  6 Nov 2013 12:07:15 +1100
Message-Id: <1383700043-32305-30-git-send-email-david@fromorbit.com>
In-Reply-To: <1383700043-32305-1-git-send-email-david@fromorbit.com>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
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

xfs_db is unique in the way it can read the same blocks with
different lengths from disk, so we really need a way to avoid having
duplicate buffers in the cache. To handle this in a generic way,
introduce a "purge on compare failure" feature to libxfs.

What this feature does is instead of throwing a warning when a
buffer miscompare occurs (e.g. due to a length mismatch), it purges
the buffer that is in cache from the cache. We can do this safely in
the context of xfs_db because it always writes back changes made to
buffers before it releases the reference to the buffer. Hence we can
purge buffers directly from the lookup code without having to worry
about whether they are dirty or not.

Doing this purge on miscompare operation avoids the
problem that libxfs is currently warning about, and hence if the
feature flag is set then we don't need to warn about miscompares any
more. Hence the whole problem goes away entirely for xfs_db, without
affecting any of the other users of libxfs based IO.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/init.c           |  1 +
 include/cache.h     | 22 +++++++++++++-
 include/libxfs.h    |  2 ++
 libxfs/cache.c      | 83 +++++++++++++++++++++++++++++++++++++++--------------
 libxfs/init.c       |  3 +-
 libxfs/rdwr.c       | 28 ++++++++++--------
 repair/xfs_repair.c |  2 +-
 7 files changed, 105 insertions(+), 36 deletions(-)

diff --git a/db/init.c b/db/init.c
index 838ea3c..4bc048a 100644
--- a/db/init.c
+++ b/db/init.c
@@ -109,6 +109,7 @@ init(
 	else
 		x.dname = fsdevice;
 
+	x.bcache_flags = CACHE_MISCOMPARE_PURGE;
 	if (!libxfs_init(&x)) {
 		fputs(_("\nfatal error -- couldn't initialize XFS library\n"),
 			stderr);
diff --git a/include/cache.h b/include/cache.h
index 0c0a1c5..c5757d0 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -18,6 +18,25 @@
 #ifndef __CACHE_H__
 #define __CACHE_H__
 
+/*
+ * initialisation flags
+ */
+/*
+ * xfs_db always writes changes immediately, and so we need to purge buffers
+ * when we get a buffer lookup mismatch due to readin the same block with a
+ * different buffer configuration.
+ */
+#define CACHE_MISCOMPARE_PURGE	(1 << 0)
+
+/*
+ * cache object campare return values
+ */
+enum {
+	CACHE_HIT,
+	CACHE_MISS,
+	CACHE_PURGE,
+};
+
 #define	HASH_CACHE_RATIO	8
 
 /*
@@ -82,6 +101,7 @@ struct cache_node {
 };
 
 struct cache {
+	int			c_flags;	/* behavioural flags */
 	unsigned int		c_maxcount;	/* max cache nodes */
 	unsigned int		c_count;	/* count of nodes */
 	pthread_mutex_t		c_mutex;	/* node count mutex */
@@ -99,7 +119,7 @@ struct cache {
 	unsigned int 		c_max;		/* max nodes ever used */
 };
 
-struct cache *cache_init(unsigned int, struct cache_operations *);
+struct cache *cache_init(int, unsigned int, struct cache_operations *);
 void cache_destroy(struct cache *);
 void cache_walk(struct cache *, cache_walk_t);
 void cache_purge(struct cache *);
diff --git a/include/libxfs.h b/include/libxfs.h
index cbb5757..40a950e 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -110,6 +110,8 @@ typedef struct {
 	int             dfd;            /* data subvolume file descriptor */
 	int             logfd;          /* log subvolume file descriptor */
 	int             rtfd;           /* realtime subvolume file descriptor */
+	int		icache_flags;	/* cache init flags */
+	int		bcache_flags;	/* cache init flags */
 } libxfs_init_t;
 
 #define LIBXFS_EXIT_ON_FAILURE	0x0001	/* exit the program if a call fails */
diff --git a/libxfs/cache.c b/libxfs/cache.c
index 56b24e7..84d2860 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -38,6 +38,7 @@ static unsigned int cache_generic_bulkrelse(struct cache *, struct list_head *);
 
 struct cache *
 cache_init(
+	int			flags,
 	unsigned int		hashsize,
 	struct cache_operations	*cache_operations)
 {
@@ -53,6 +54,7 @@ cache_init(
 		return NULL;
 	}
 
+	cache->c_flags = flags;
 	cache->c_count = 0;
 	cache->c_max = 0;
 	cache->c_hits = 0;
@@ -289,6 +291,34 @@ cache_overflowed(
 	return (cache->c_maxcount == cache->c_max);
 }
 
+
+static int
+__cache_node_purge(
+	struct cache *		cache,
+	struct cache_node *	node)
+{
+	int			count;
+	struct cache_mru *	mru;
+
+	pthread_mutex_lock(&node->cn_mutex);
+	count = node->cn_count;
+	if (count != 0) {
+		pthread_mutex_unlock(&node->cn_mutex);
+		return count;
+	}
+	mru = &cache->c_mrus[node->cn_priority];
+	pthread_mutex_lock(&mru->cm_mutex);
+	list_del_init(&node->cn_mru);
+	mru->cm_count--;
+	pthread_mutex_unlock(&mru->cm_mutex);
+
+	pthread_mutex_unlock(&node->cn_mutex);
+	pthread_mutex_destroy(&node->cn_mutex);
+	list_del_init(&node->cn_hash);
+	cache->relse(node);
+	return count;
+}
+
 /*
  * Lookup in the cache hash table.  With any luck we'll get a cache
  * hit, in which case this will all be over quickly and painlessly.
@@ -308,8 +338,10 @@ cache_node_get(
 	struct cache_mru *	mru;
 	struct list_head *	head;
 	struct list_head *	pos;
+	struct list_head *	n;
 	unsigned int		hashidx;
 	int			priority = 0;
+	int			purged = 0;
 
 	hashidx = cache->hash(key, cache->c_hashsize);
 	hash = cache->c_hash + hashidx;
@@ -317,10 +349,26 @@ cache_node_get(
 
 	for (;;) {
 		pthread_mutex_lock(&hash->ch_mutex);
-		for (pos = head->next; pos != head; pos = pos->next) {
+		for (pos = head->next, n = pos->next; pos != head;
+						pos = n, n = pos->next) {
+			int result;
+
 			node = list_entry(pos, struct cache_node, cn_hash);
-			if (!cache->compare(node, key))
-				continue;
+			result = cache->compare(node, key);
+			switch (result) {
+			case CACHE_HIT:
+				break;
+			case CACHE_PURGE:
+				if ((cache->c_flags & CACHE_MISCOMPARE_PURGE) &&
+				    !__cache_node_purge(cache, node)) {
+					purged++;
+					hash->ch_count--;
+				}
+				/* FALL THROUGH */
+			case CACHE_MISS:
+				goto next_object;
+			}
+
 			/*
 			 * node found, bump node's reference count, remove it
 			 * from its MRU list, and update stats.
@@ -347,6 +395,8 @@ cache_node_get(
 
 			*nodep = node;
 			return 0;
+next_object:
+			continue;	/* what the hell, gcc? */
 		}
 		pthread_mutex_unlock(&hash->ch_mutex);
 		/*
@@ -375,6 +425,12 @@ cache_node_get(
 	list_add(&node->cn_hash, &hash->ch_list);
 	pthread_mutex_unlock(&hash->ch_mutex);
 
+	if (purged) {
+		pthread_mutex_lock(&cache->c_mutex);
+		cache->c_count -= purged;
+		pthread_mutex_unlock(&cache->c_mutex);
+	}
+
 	*nodep = node;
 	return 1;
 }
@@ -457,7 +513,6 @@ cache_node_purge(
 	struct list_head *	pos;
 	struct list_head *	n;
 	struct cache_hash *	hash;
-	struct cache_mru *	mru;
 	int			count = -1;
 
 	hash = cache->c_hash + cache->hash(key, cache->c_hashsize);
@@ -468,23 +523,9 @@ cache_node_purge(
 		if ((struct cache_node *)pos != node)
 			continue;
 
-		pthread_mutex_lock(&node->cn_mutex);
-		count = node->cn_count;
-		if (count != 0) {
-			pthread_mutex_unlock(&node->cn_mutex);
-			break;
-		}
-		mru = &cache->c_mrus[node->cn_priority];
-		pthread_mutex_lock(&mru->cm_mutex);
-		list_del_init(&node->cn_mru);
-		mru->cm_count--;
-		pthread_mutex_unlock(&mru->cm_mutex);
-
-		pthread_mutex_unlock(&node->cn_mutex);
-		pthread_mutex_destroy(&node->cn_mutex);
-		list_del_init(&node->cn_hash);
-		hash->ch_count--;
-		cache->relse(node);
+		count = __cache_node_purge(cache, node);
+		if (!count)
+			hash->ch_count--;
 		break;
 	}
 	pthread_mutex_unlock(&hash->ch_mutex);
diff --git a/libxfs/init.c b/libxfs/init.c
index abe3316..5ba4fe6 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -334,7 +334,8 @@ libxfs_init(libxfs_init_t *a)
 		chdir(curdir);
 	if (!libxfs_bhash_size)
 		libxfs_bhash_size = LIBXFS_BHASHSIZE(sbp);
-	libxfs_bcache = cache_init(libxfs_bhash_size, &libxfs_bcache_operations);
+	libxfs_bcache = cache_init(a->bcache_flags, libxfs_bhash_size,
+				   &libxfs_bcache_operations);
 	use_xfs_buf_lock = a->usebuflock;
 	manage_zones(0);
 	rval = 1;
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 7eaea0a..0aa2eba 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -323,20 +323,24 @@ libxfs_bcompare(struct cache_node *node, cache_key_t key)
 	struct xfs_buf	*bp = (struct xfs_buf *)node;
 	struct xfs_bufkey *bkey = (struct xfs_bufkey *)key;
 
-#ifdef IO_BCOMPARE_CHECK
 	if (bp->b_target->dev == bkey->buftarg->dev &&
-	    bp->b_bn == bkey->blkno &&
-	    bp->b_bcount != BBTOB(bkey->bblen))
-		fprintf(stderr, "%lx: Badness in key lookup (length)\n"
-			"bp=(bno 0x%llx, len %u bytes) key=(bno 0x%llx, len %u bytes)\n",
-			pthread_self(),
-			(unsigned long long)bp->b_bn, (int)bp->b_bcount,
-			(unsigned long long)bkey->blkno, BBTOB(bkey->bblen));
+	    bp->b_bn == bkey->blkno) {
+		if (bp->b_bcount == BBTOB(bkey->bblen))
+			return CACHE_HIT;
+#ifdef IO_BCOMPARE_CHECK
+		if (!(libxfs_bcache->c_flags & CACHE_MISCOMPARE_PURGE)) {
+			fprintf(stderr,
+	"%lx: Badness in key lookup (length)\n"
+	"bp=(bno 0x%llx, len %u bytes) key=(bno 0x%llx, len %u bytes)\n",
+				pthread_self(),
+				(unsigned long long)bp->b_bn, (int)bp->b_bcount,
+				(unsigned long long)bkey->blkno,
+				BBTOB(bkey->bblen));
+		}
 #endif
-
-	return (bp->b_target->dev == bkey->buftarg->dev &&
-		bp->b_bn == bkey->blkno &&
-		bp->b_bcount == BBTOB(bkey->bblen));
+		return CACHE_PURGE;
+	}
+	return CACHE_MISS;
 }
 
 void
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 214b7fa..77a040e 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -706,7 +706,7 @@ main(int argc, char **argv)
 			do_log(_("        - block cache size set to %d entries\n"),
 				libxfs_bhash_size * HASH_CACHE_RATIO);
 
-		libxfs_bcache = cache_init(libxfs_bhash_size,
+		libxfs_bcache = cache_init(0, libxfs_bhash_size,
 						&libxfs_bcache_operations);
 	}
 
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
