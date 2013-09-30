Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A90DC7F85
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:15:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6152C8F8035
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:15:55 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	HjgoRoU7FTeSdlFI for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:15:53 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTxa-0006Pb-Cc
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:46 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTxa-0002HG-Bs
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 28/32] xfs_db: avoid libxfs buffer lookup warnings
Date: Mon, 30 Sep 2013 13:15:40 +1000
Message-Id: <1380510944-8571-29-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510944-8571-1-git-send-email-david@fromorbit.com>
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
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

When we mount the filesystem inside xfs_db, libxfs is tasked with
reading some information from disk, such as root inodes. Because
libxfs does this inode reading, it uses inode cluster buffers to
read the inodes. xfs_db, OTOH, just uses FSB sized buffers to read
inodes, and hence xfs_db throws a warning when reading the root
inode block like so:

$ sudo xfs_db -c "sb 0" -c "p rootino" -c "inode 32" /dev/vda
Version 5 superblock detected. xfsprogs has EXPERIMENTAL support enabled!
Use of these features is at your own risk!
rootino = 32
7f59f20e6740: Badness in key lookup (length)
bp=(bno 0x20, len 8192 bytes) key=(bno 0x20, len 1024 bytes)
$

There is another way this can happen, and that is dumping raw data
from disk using either the "fsb NNN" or "daddr MMM" commands to dump
untyped information. This is always read in sector or filesystem
block units, and so will cause similar badness warnings.

xfs_db is unique in the way it can read the same blocks with
different lengths, so we really need a way to avoid having duplicate
buffers in the cache. To handle this in a generic way, introduce a
"purge on compare failure" feature to libxfs.

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
 db/inode.c          | 33 +++++++++++++++++++--
 db/io.c             |  4 ++-
 include/cache.h     | 22 +++++++++++++-
 include/libxfs.h    |  2 ++
 libxfs/cache.c      | 83 +++++++++++++++++++++++++++++++++++++++--------------
 libxfs/init.c       |  6 ++--
 libxfs/rdwr.c       | 30 ++++++++++---------
 repair/xfs_repair.c |  4 +--
 9 files changed, 143 insertions(+), 42 deletions(-)

diff --git a/db/init.c b/db/init.c
index a9b357b..2b643f9 100644
--- a/db/init.c
+++ b/db/init.c
@@ -109,6 +109,7 @@ init(
 	else
 		x.dname = fsdevice;
 
+	x.bcache_flags = CACHE_MISCOMPARE_PURGE;
 	if (!libxfs_init(&x)) {
 		fputs(_("\nfatal error -- couldn't initialize XFS library\n"),
 			stderr);
diff --git a/db/inode.c b/db/inode.c
index 4090855..24170ba 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -623,6 +623,14 @@ inode_u_symlink_count(
 		(int)be64_to_cpu(dip->di_size) : 0;
 }
 
+/*
+ * We are now using libxfs for our IO backend, so we should always try to use
+ * inode cluster buffers rather than filesystem block sized buffers for reading
+ * inodes. This means that we always use the same buffers as libxfs operations
+ * does, and that avoids buffer cache issues caused by overlapping buffers. This
+ * can be seen clearly when trying to read the root inode. Much of this logic is
+ * similar to libxfs_imap().
+ */
 void
 set_cur_inode(
 	xfs_ino_t	ino)
@@ -632,6 +640,9 @@ set_cur_inode(
 	xfs_agnumber_t	agno;
 	xfs_dinode_t	*dip;
 	int		offset;
+	int		numblks = blkbb;
+	xfs_agblock_t	cluster_agbno;
+
 
 	agno = XFS_INO_TO_AGNO(mp, ino);
 	agino = XFS_INO_TO_AGINO(mp, ino);
@@ -644,6 +655,24 @@ set_cur_inode(
 		return;
 	}
 	cur_agno = agno;
+
+	if (mp->m_inode_cluster_size > mp->m_sb.sb_blocksize &&
+	    mp->m_inoalign_mask) {
+		xfs_agblock_t	chunk_agbno;
+		xfs_agblock_t	offset_agbno;
+		int		blks_per_cluster;
+
+		blks_per_cluster = mp->m_inode_cluster_size >>
+							mp->m_sb.sb_blocklog;
+		offset_agbno = agbno & mp->m_inoalign_mask;
+		chunk_agbno = agbno - offset_agbno;
+		cluster_agbno = chunk_agbno +
+			((offset_agbno / blks_per_cluster) * blks_per_cluster);
+		offset += ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock);
+		numblks = XFS_FSB_TO_BB(mp, blks_per_cluster);
+	} else
+		cluster_agbno = agbno;
+
 	/*
 	 * First set_cur to the block with the inode
 	 * then use off_cur to get the right part of the buffer.
@@ -651,8 +680,8 @@ set_cur_inode(
 	ASSERT(typtab[TYP_INODE].typnm == TYP_INODE);
 
 	/* ingore ring update here, do it explicitly below */
-	set_cur(&typtab[TYP_INODE], XFS_AGB_TO_DADDR(mp, agno, agbno),
-		blkbb, DB_RING_IGN, NULL);
+	set_cur(&typtab[TYP_INODE], XFS_AGB_TO_DADDR(mp, agno, cluster_agbno),
+		numblks, DB_RING_IGN, NULL);
 	off_cur(offset << mp->m_sb.sb_inodelog, mp->m_sb.sb_inodesize);
 	dip = iocur_top->data;
 	iocur_top->ino_crc_ok = libxfs_dinode_verify(mp, ino, dip);
diff --git a/db/io.c b/db/io.c
index 7281148..123214d 100644
--- a/db/io.c
+++ b/db/io.c
@@ -104,8 +104,10 @@ pop_cur(void)
 		dbprintf(_("can't pop anything from I/O stack\n"));
 		return;
 	}
-	if (iocur_top->bp)
+	if (iocur_top->bp) {
 		libxfs_putbuf(iocur_top->bp);
+		iocur_top->bp = NULL;
+	}
 	if (iocur_top->bbmap) {
 		free(iocur_top->bbmap);
 		iocur_top->bbmap = NULL;
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
index d28ac48..049b217 100644
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
index 229aa50..637f29e 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -337,10 +337,12 @@ libxfs_init(libxfs_init_t *a)
 		chdir(curdir);
 	if (!libxfs_ihash_size)
 		libxfs_ihash_size = LIBXFS_IHASHSIZE(sbp);
-	libxfs_icache = cache_init(libxfs_ihash_size, &libxfs_icache_operations);
+	libxfs_icache = cache_init(a->icache_flags, libxfs_ihash_size,
+				   &libxfs_icache_operations);
 	if (!libxfs_bhash_size)
 		libxfs_bhash_size = LIBXFS_BHASHSIZE(sbp);
-	libxfs_bcache = cache_init(libxfs_bhash_size, &libxfs_bcache_operations);
+	libxfs_bcache = cache_init(a->bcache_flags, libxfs_bhash_size,
+				   &libxfs_bcache_operations);
 	use_xfs_buf_lock = a->usebuflock;
 	manage_zones(0);
 	rval = 1;
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 8d8bcfc..6d6a915 100644
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
@@ -1029,7 +1033,7 @@ libxfs_icompare(struct cache_node *node, cache_key_t key)
 {
 	xfs_inode_t	*ip = (xfs_inode_t *)node;
 
-	return (ip->i_ino == *(xfs_ino_t *)key);
+	return (ip->i_ino == *(xfs_ino_t *)key) ? CACHE_HIT : CACHE_MISS;
 }
 
 int
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 820e7a2..55a451b 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -712,9 +712,9 @@ main(int argc, char **argv)
 		if (!ihash_option_used)
 			libxfs_ihash_size = libxfs_bhash_size;
 
-		libxfs_icache = cache_init(libxfs_ihash_size,
+		libxfs_icache = cache_init(0, libxfs_ihash_size,
 						&libxfs_icache_operations);
-		libxfs_bcache = cache_init(libxfs_bhash_size,
+		libxfs_bcache = cache_init(0, libxfs_bhash_size,
 						&libxfs_bcache_operations);
 	}
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
