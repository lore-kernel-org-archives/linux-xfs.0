Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Sep 2008 23:34:54 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m836YnPM013735
	for <xfs@oss.sgi.com>; Tue, 2 Sep 2008 23:34:49 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id QAA00281 for <xfs@oss.sgi.com>; Wed, 3 Sep 2008 16:36:14 +1000
Date: Wed, 03 Sep 2008 16:38:34 +1000
Subject: REVIEW: Improve caching in libxfs
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.ugv7ekj83jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

An old patch I wrote a while ago which speeds up a libxfs cache
full of referenced blocks when trying to find a free/unused node.

The old/current mechanisms stores all buffers, referenced and
unreferenced in an MRU list.

When a new buffer is needed, and there are a lot of referenced
blocks (multi-threaded AG prefetch with lots of out-of-order
seeks), a lot of CPU time can be spent trying to find a block
(and even failing).

This patch changes the MRU to only store unreferenced blocks
so the searching doesn't scan through referenced blocks.

The buffer priority mechanism has been tweaked too to stop
prefetching jamming with small cache sizes.

---
  xfsprogs/include/cache.h   |    2 -
  xfsprogs/libxfs/cache.c    |   68  
++++++++++++++++++++++-----------------------
  xfsprogs/libxfs/rdwr.c     |    6 +--
  xfsprogs/repair/prefetch.c |   18 +++++------
  4 files changed, 47 insertions(+), 47 deletions(-)

Index: xfs-cmds/xfsprogs/include/cache.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/cache.h
+++ xfs-cmds/xfsprogs/include/cache.h
@@ -95,7 +95,7 @@ void cache_purge(struct cache *);
  void cache_flush(struct cache *);

  int cache_node_get(struct cache *, cache_key_t, struct cache_node **);
-void cache_node_put(struct cache_node *);
+void cache_node_put(struct cache *, struct cache_node *);
  void cache_node_set_priority(struct cache *, struct cache_node *, int);
  int cache_node_get_priority(struct cache_node *);
  int cache_node_purge(struct cache *, cache_key_t, struct cache_node *);
Index: xfs-cmds/xfsprogs/libxfs/cache.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/cache.c
+++ xfs-cmds/xfsprogs/libxfs/cache.c
@@ -201,11 +201,11 @@ cache_shake(
  			continue;

  		hash = cache->c_hash + node->cn_hashidx;
-		if (node->cn_count > 0 ||
-				pthread_mutex_trylock(&hash->ch_mutex) != 0) {
+		if (pthread_mutex_trylock(&hash->ch_mutex) != 0) {
  			pthread_mutex_unlock(&node->cn_mutex);
  			continue;
  		}
+		ASSERT(node->cn_count == 0);
  		ASSERT(node->cn_priority == priority);
  		node->cn_priority = -1;

@@ -264,6 +264,7 @@ cache_node_allocate(
  		return NULL;
  	}
  	pthread_mutex_init(&node->cn_mutex, NULL);
+	list_head_init(&node->cn_mru);
  	node->cn_count = 1;
  	node->cn_priority = 0;
  	return node;
@@ -309,16 +310,21 @@ cache_node_get(
  			if (!cache->compare(node, key))
  				continue;
  			/*
-			* node found, bump node's reference count, move it to the
-			* top of its MRU list, and update stats.
+			* node found, bump node's reference count, remove it
+			* from its MRU list, and update stats.
  			*/
  			pthread_mutex_lock(&node->cn_mutex);
-			node->cn_count++;

-			mru = &cache->c_mrus[node->cn_priority];
-			pthread_mutex_lock(&mru->cm_mutex);
-			list_move(&node->cn_mru, &mru->cm_list);
-			pthread_mutex_unlock(&mru->cm_mutex);
+			if (node->cn_count == 0) {
+				ASSERT(node->cn_priority >= 0);
+				ASSERT(!list_empty(&node->cn_mru));
+				mru = &cache->c_mrus[node->cn_priority];
+				pthread_mutex_lock(&mru->cm_mutex);
+				mru->cm_count--;
+				list_del_init(&node->cn_mru);
+				pthread_mutex_unlock(&mru->cm_mutex);
+			}
+			node->cn_count++;

  			pthread_mutex_unlock(&node->cn_mutex);
  			pthread_mutex_unlock(&hash->ch_mutex);
@@ -342,16 +348,11 @@ cache_node_get(

  	node->cn_hashidx = hashidx;

-	/* add new node to appropriate hash and lowest priority MRU */
-	mru = &cache->c_mrus[0];
-	pthread_mutex_lock(&mru->cm_mutex);
+	/* add new node to appropriate hash */
  	pthread_mutex_lock(&hash->ch_mutex);
  	hash->ch_count++;
-	mru->cm_count++;
  	list_add(&node->cn_hash, &hash->ch_list);
-	list_add(&node->cn_mru, &mru->cm_list);
  	pthread_mutex_unlock(&hash->ch_mutex);
-	pthread_mutex_unlock(&mru->cm_mutex);

  	*nodep = node;
  	return 1;
@@ -359,8 +360,11 @@ cache_node_get(

  void
  cache_node_put(
+	struct cache *		cache,
  	struct cache_node *	node)
  {
+	struct cache_mru *	mru;
+
  	pthread_mutex_lock(&node->cn_mutex);
  #ifdef CACHE_DEBUG
  	if (node->cn_count < 1) {
@@ -368,8 +372,23 @@ cache_node_put(
  				__FUNCTION__, node->cn_count, node);
  		cache_abort();
  	}
+	if (!list_empty(&node->cn_mru)) {
+		fprintf(stderr, "%s: node put on node (%p) in MRU list\n",
+				__FUNCTION__, node);
+		cache_abort();
+	}
  #endif
  	node->cn_count--;
+
+	if (node->cn_count == 0) {
+		/* add unreferenced node to appropriate MRU for shaker */
+		mru = &cache->c_mrus[node->cn_priority];
+		pthread_mutex_lock(&mru->cm_mutex);
+		mru->cm_count++;
+		list_add(&node->cn_mru, &mru->cm_list);
+		pthread_mutex_unlock(&mru->cm_mutex);
+	}
+
  	pthread_mutex_unlock(&node->cn_mutex);
  }

@@ -379,33 +398,14 @@ cache_node_set_priority(
  	struct cache_node *	node,
  	int			priority)
  {
-	struct cache_mru *	mru;
-
  	if (priority < 0)
  		priority = 0;
  	else if (priority > CACHE_MAX_PRIORITY)
  		priority = CACHE_MAX_PRIORITY;

  	pthread_mutex_lock(&node->cn_mutex);
-
  	ASSERT(node->cn_count > 0);
-	if (priority == node->cn_priority) {
-		pthread_mutex_unlock(&node->cn_mutex);
-		return;
-	}
-	mru = &cache->c_mrus[node->cn_priority];
-	pthread_mutex_lock(&mru->cm_mutex);
-	list_del_init(&node->cn_mru);
-	mru->cm_count--;
-	pthread_mutex_unlock(&mru->cm_mutex);
-
-	mru = &cache->c_mrus[priority];
-	pthread_mutex_lock(&mru->cm_mutex);
-	list_add(&node->cn_mru, &mru->cm_list);
  	node->cn_priority = priority;
-	mru->cm_count++;
-	pthread_mutex_unlock(&mru->cm_mutex);
-
  	pthread_mutex_unlock(&node->cn_mutex);
  }

Index: xfs-cmds/xfsprogs/libxfs/rdwr.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/rdwr.c
+++ xfs-cmds/xfsprogs/libxfs/rdwr.c
@@ -393,7 +393,7 @@ libxfs_getbuf(dev_t device, xfs_daddr_t
  		if (use_xfs_buf_lock)
  			pthread_mutex_lock(&bp->b_lock);
  		cache_node_set_priority(libxfs_bcache, (struct cache_node *)bp,
-			cache_node_get_priority((struct cache_node *)bp) - 4);
+			cache_node_get_priority((struct cache_node *)bp) - 8);
  #ifdef XFS_BUF_TRACING
  		pthread_mutex_lock(&libxfs_bcache->c_mutex);
  		lock_buf_count++;
@@ -422,7 +422,7 @@ libxfs_putbuf(xfs_buf_t *bp)
  #endif
  	if (use_xfs_buf_lock)
  		pthread_mutex_unlock(&bp->b_lock);
-	cache_node_put((struct cache_node *)bp);
+	cache_node_put(libxfs_bcache, (struct cache_node *)bp);
  }

  void
@@ -794,7 +794,7 @@ libxfs_iget(xfs_mount_t *mp, xfs_trans_t
  void
  libxfs_iput(xfs_inode_t *ip, uint lock_flags)
  {
-	cache_node_put((struct cache_node *)ip);
+	cache_node_put(libxfs_icache, (struct cache_node *)ip);
  }

  static struct cache_node *
Index: xfs-cmds/xfsprogs/repair/prefetch.c
===================================================================
--- xfs-cmds.orig/xfsprogs/repair/prefetch.c
+++ xfs-cmds/xfsprogs/repair/prefetch.c
@@ -38,16 +38,16 @@ static void		pf_read_inode_dirs(prefetch
  /* buffer priorities for the libxfs cache */

  #define B_DIR_BMAP	15
-#define B_DIR_META_2	13	/* metadata in secondary queue */
-#define B_DIR_META_H	11	/* metadata fetched for PF_META_ONLY */
-#define B_DIR_META_S	9	/* single block of metadata */
-#define B_DIR_META	7
-#define B_DIR_INODE	6
-#define B_BMAP		5
-#define B_INODE		4
+#define B_DIR_META_2	14	/* metadata in secondary queue */
+#define B_DIR_META_H	13	/* metadata fetched for PF_META_ONLY */
+#define B_DIR_META_S	12	/* single block of metadata */
+#define B_DIR_META	11
+#define B_DIR_INODE	10
+#define B_BMAP		9
+#define B_INODE		8

-#define B_IS_INODE(b)	(((b) & 1) == 0)
-#define B_IS_META(b)	(((b) & 1) != 0)
+#define B_IS_INODE(f)	(((f) & 5) == 0)
+#define B_IS_META(f)	(((f) & 5) != 0)

  #define DEF_BATCH_BYTES	0x10000
