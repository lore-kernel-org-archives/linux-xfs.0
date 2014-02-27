Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 794987F56
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 03:51:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 67711304051
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 01:51:38 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	KZRYYtKd7szN8SOa for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 01:51:36 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WIxcb-0007bk-8f
	for xfs@oss.sgi.com; Thu, 27 Feb 2014 20:51:17 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WIxcb-0007s2-7e
	for xfs@oss.sgi.com; Thu, 27 Feb 2014 20:51:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/10] libxfs: buffer cache hashing is suboptimal
Date: Thu, 27 Feb 2014 20:51:08 +1100
Message-Id: <1393494675-30194-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1393494675-30194-1-git-send-email-david@fromorbit.com>
References: <1393494675-30194-1-git-send-email-david@fromorbit.com>
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

The hashkey calculation is very simplistic,and throws away an amount
of entropy that should be folded into the hash. The result is
sub-optimal distribution across the hash tables. For example, with a
default 512 entry table, phase 2 results in this:

Max supported entries = 4096
Max utilized entries = 3970
Active entries = 3970
Hash table size = 512
Hits = 0
Misses = 3970
Hit ratio =  0.00
Hash buckets with   0 entries     12 (  0%)
Hash buckets with   1 entries      3 (  0%)
Hash buckets with   2 entries     10 (  0%)
Hash buckets with   3 entries      2 (  0%)
Hash buckets with   4 entries    129 ( 12%)
Hash buckets with   5 entries     20 (  2%)
Hash buckets with   6 entries     54 (  8%)
Hash buckets with   7 entries     22 (  3%)
Hash buckets with   8 entries    150 ( 30%)
Hash buckets with   9 entries     14 (  3%)
Hash buckets with  10 entries     16 (  4%)
Hash buckets with  11 entries      7 (  1%)
Hash buckets with  12 entries     38 ( 11%)
Hash buckets with  13 entries      5 (  1%)
Hash buckets with  14 entries      4 (  1%)
Hash buckets with  17 entries      1 (  0%)
Hash buckets with  19 entries      1 (  0%)
Hash buckets with  23 entries      1 (  0%)
Hash buckets with >24 entries     23 ( 16%)

Now, given a perfect distribution, we shoul dhave 8 entries per
chain. What we end up with is nothing like that.

Unfortunately, for phase 3/4 and others, the number of cached
objects results in the cache being expanded to 256k entries, and
so the stats just give this;

Hits = 262276
Misses = 8130393
Hit ratio =  3.13
Hash buckets with >24 entries    512 (100%)

We can't evaluate the efficiency of the hashing algorithm here.
Let's increase the size of the hash table to 32768 entries and go
from there:

Phase 2:

Hash buckets with   0 entries  31884 (  0%)
Hash buckets with   1 entries     35 (  0%)
Hash buckets with   2 entries     78 (  3%)
Hash buckets with   3 entries     30 (  2%)
Hash buckets with   4 entries    649 ( 65%)
Hash buckets with   5 entries     12 (  1%)
Hash buckets with   6 entries     13 (  1%)
Hash buckets with   8 entries     40 (  8%)
Hash buckets with   9 entries      1 (  0%)
Hash buckets with  13 entries      1 (  0%)
Hash buckets with  15 entries      1 (  0%)
Hash buckets with  22 entries      1 (  0%)
Hash buckets with  24 entries     17 ( 10%)
Hash buckets with >24 entries      6 (  4%)

There's a significant number of collisions given the population is
only 15% of the size of the table itself....

Phase 3:

Max supported entries = 262144
Max utilized entries = 262144
Active entries = 262090
Hash table size = 32768
Hits = 530844
Misses = 7164575
Hit ratio =  6.90
Hash buckets with   0 entries  11898 (  0%)
....
Hash buckets with  12 entries   5513 ( 25%)
Hash buckets with  13 entries   4188 ( 20%)
Hash buckets with  14 entries   2073 ( 11%)
Hash buckets with  15 entries   1811 ( 10%)
Hash buckets with  16 entries   1994 ( 12%)
....
Hash buckets with >24 entries    339 (  4%)

So, a third of the hash table does not even has any entries in them,
despite having more than 7.5 million entries run through the cache.
Median chain lengths are 12-16 entries, ideal is 8. And lots of
collisions on the longer than 24 entrie chains...

Phase 6:

Hash buckets with   0 entries  14573 (  0%)
....
Hash buckets with >24 entries   2291 ( 36%)

Ouch. Not a good distribution at all.

Overall runtime:

Phase           Start           End             Duration
Phase 1:        12/06 11:35:04  12/06 11:35:04
Phase 2:        12/06 11:35:04  12/06 11:35:07  3 seconds
Phase 3:        12/06 11:35:07  12/06 11:38:27  3 minutes, 20 seconds
Phase 4:        12/06 11:38:27  12/06 11:41:32  3 minutes, 5 seconds
Phase 5:        12/06 11:41:32  12/06 11:41:32
Phase 6:        12/06 11:41:32  12/06 11:42:29  57 seconds
Phase 7:        12/06 11:42:29  12/06 11:42:30  1 second

Total run time: 7 minutes, 26 seconds

Modify the hash to be something more workable - steal the linux
kernel inode hash calculation and try that:

phase 2:

Max supported entries = 262144
Max utilized entries = 3970
Active entries = 3970
Hash table size = 32768
Hits = 0
Misses = 3972
Hit ratio =  0.00
Hash buckets with   0 entries  29055 (  0%)
Hash buckets with   1 entries   3464 ( 87%)
Hash buckets with   2 entries    241 ( 12%)
Hash buckets with   3 entries      8 (  0%)

Close to perfect.

Phase 3:

Max supported entries = 262144
Max utilized entries = 262144
Active entries = 262118
Hash table size = 32768
Hits = 567900
Misses = 7118749
Hit ratio =  7.39
Hash buckets with   5 entries   1572 (  2%)
Hash buckets with   6 entries   2186 (  5%)
Hash buckets with   7 entries   9217 ( 24%)
Hash buckets with   8 entries   8757 ( 26%)
Hash buckets with   9 entries   6135 ( 21%)
Hash buckets with  10 entries   3166 ( 12%)
Hash buckets with  11 entries   1257 (  5%)
Hash buckets with  12 entries    364 (  1%)
Hash buckets with  13 entries     94 (  0%)
Hash buckets with  14 entries     14 (  0%)
Hash buckets with  15 entries      5 (  0%)

A near-perfect bell curve centered on the optimal distribution
number of 8 entries per chain.

Phase 6:

Hash buckets with   0 entries     24 (  0%)
Hash buckets with   1 entries    190 (  0%)
Hash buckets with   2 entries    571 (  0%)
Hash buckets with   3 entries   1263 (  1%)
Hash buckets with   4 entries   2465 (  3%)
Hash buckets with   5 entries   3399 (  6%)
Hash buckets with   6 entries   4002 (  9%)
Hash buckets with   7 entries   4186 ( 11%)
Hash buckets with   8 entries   3773 ( 11%)
Hash buckets with   9 entries   3240 ( 11%)
Hash buckets with  10 entries   2523 (  9%)
Hash buckets with  11 entries   2074 (  8%)
Hash buckets with  12 entries   1582 (  7%)
Hash buckets with  13 entries   1206 (  5%)
Hash buckets with  14 entries    863 (  4%)
Hash buckets with  15 entries    601 (  3%)
Hash buckets with  16 entries    386 (  2%)
Hash buckets with  17 entries    205 (  1%)
Hash buckets with  18 entries    122 (  0%)
Hash buckets with  19 entries     48 (  0%)
Hash buckets with  20 entries     24 (  0%)
Hash buckets with  21 entries     13 (  0%)
Hash buckets with  22 entries      8 (  0%)

A much wider bell curve than phase 3, but still centered around the
optimal value and far, far better than the distribution of the
current hash calculation. Runtime:

Phase           Start           End             Duration
Phase 1:        12/06 11:47:21  12/06 11:47:21
Phase 2:        12/06 11:47:21  12/06 11:47:23  2 seconds
Phase 3:        12/06 11:47:23  12/06 11:50:50  3 minutes, 27 seconds
Phase 4:        12/06 11:50:50  12/06 11:53:57  3 minutes, 7 seconds
Phase 5:        12/06 11:53:57  12/06 11:53:58  1 second
Phase 6:        12/06 11:53:58  12/06 11:54:51  53 seconds
Phase 7:        12/06 11:54:51  12/06 11:54:52  1 second

Total run time: 7 minutes, 31 seconds

Essentially unchanged - this is somewhat of a "swings and
roundabouts" test here because what it is testing is the cache-miss
overhead.

FWIW, the comparison here shows a pretty good case for the existing
hash calculation. On a less populated filesystem (5m inodes rather
than 50m inodes) the typical hash distribution was:

Max supported entries = 262144
Max utilized entries = 262144
Active entries = 262094
Hash table size = 32768
Hits = 626228
Misses = 800166
Hit ratio = 43.90
Hash buckets with   0 entries  29274 (  0%)
Hash buckets with   3 entries      1 (  0%)
Hash buckets with   4 entries      1 (  0%)
Hash buckets with   7 entries      1 (  0%)
Hash buckets with   8 entries      1 (  0%)
Hash buckets with   9 entries      1 (  0%)
Hash buckets with  12 entries      1 (  0%)
Hash buckets with  13 entries      1 (  0%)
Hash buckets with  16 entries      2 (  0%)
Hash buckets with  18 entries      1 (  0%)
Hash buckets with  22 entries      1 (  0%)
Hash buckets with >24 entries   3483 ( 99%)

Total and utter crap. Same filesystem, new hash function:

Max supported entries = 262144
Max utilized entries = 262144
Active entries = 262103
Hash table size = 32768
Hits = 673208
Misses = 838265
Hit ratio = 44.54
Hash buckets with   3 entries    558 (  0%)
Hash buckets with   4 entries   1126 (  1%)
Hash buckets with   5 entries   2440 (  4%)
Hash buckets with   6 entries   4249 (  9%)
Hash buckets with   7 entries   5280 ( 14%)
Hash buckets with   8 entries   5598 ( 17%)
Hash buckets with   9 entries   5446 ( 18%)
Hash buckets with  10 entries   3879 ( 14%)
Hash buckets with  11 entries   2405 ( 10%)
Hash buckets with  12 entries   1187 (  5%)
Hash buckets with  13 entries    447 (  2%)
Hash buckets with  14 entries    125 (  0%)
Hash buckets with  15 entries     25 (  0%)
Hash buckets with  16 entries      3 (  0%)

Kinda says it all, really...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 include/cache.h |  4 +++-
 libxfs/cache.c  |  7 +++++--
 libxfs/rdwr.c   | 12 ++++++++++--
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index 76cb234..0a84c69 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -66,7 +66,8 @@ typedef void (*cache_walk_t)(struct cache_node *);
 typedef struct cache_node * (*cache_node_alloc_t)(cache_key_t);
 typedef void (*cache_node_flush_t)(struct cache_node *);
 typedef void (*cache_node_relse_t)(struct cache_node *);
-typedef unsigned int (*cache_node_hash_t)(cache_key_t, unsigned int);
+typedef unsigned int (*cache_node_hash_t)(cache_key_t, unsigned int,
+					  unsigned int);
 typedef int (*cache_node_compare_t)(struct cache_node *, cache_key_t);
 typedef unsigned int (*cache_bulk_relse_t)(struct cache *, struct list_head *);
 
@@ -112,6 +113,7 @@ struct cache {
 	cache_node_compare_t	compare;	/* comparison routine */
 	cache_bulk_relse_t	bulkrelse;	/* bulk release routine */
 	unsigned int		c_hashsize;	/* hash bucket count */
+	unsigned int		c_hashshift;	/* hash key shift */
 	struct cache_hash	*c_hash;	/* hash table buckets */
 	struct cache_mru	c_mrus[CACHE_MAX_PRIORITY + 1];
 	unsigned long long	c_misses;	/* cache misses */
diff --git a/libxfs/cache.c b/libxfs/cache.c
index 84d2860..dc69689 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -25,6 +25,7 @@
 #include <xfs/platform_defs.h>
 #include <xfs/list.h>
 #include <xfs/cache.h>
+#include <xfs/libxfs.h>
 
 #define CACHE_DEBUG 1
 #undef CACHE_DEBUG
@@ -61,6 +62,7 @@ cache_init(
 	cache->c_misses = 0;
 	cache->c_maxcount = maxcount;
 	cache->c_hashsize = hashsize;
+	cache->c_hashshift = libxfs_highbit32(hashsize);
 	cache->hash = cache_operations->hash;
 	cache->alloc = cache_operations->alloc;
 	cache->flush = cache_operations->flush;
@@ -343,7 +345,7 @@ cache_node_get(
 	int			priority = 0;
 	int			purged = 0;
 
-	hashidx = cache->hash(key, cache->c_hashsize);
+	hashidx = cache->hash(key, cache->c_hashsize, cache->c_hashshift);
 	hash = cache->c_hash + hashidx;
 	head = &hash->ch_list;
 
@@ -515,7 +517,8 @@ cache_node_purge(
 	struct cache_hash *	hash;
 	int			count = -1;
 
-	hash = cache->c_hash + cache->hash(key, cache->c_hashsize);
+	hash = cache->c_hash + cache->hash(key, cache->c_hashsize,
+					   cache->c_hashshift);
 	head = &hash->ch_list;
 	pthread_mutex_lock(&hash->ch_mutex);
 	for (pos = head->next, n = pos->next; pos != head;
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index d0ff15b..1b691fb 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -313,10 +313,18 @@ struct xfs_bufkey {
 	int			nmaps;
 };
 
+/*  2^63 + 2^61 - 2^57 + 2^54 - 2^51 - 2^18 + 1 */
+#define GOLDEN_RATIO_PRIME	0x9e37fffffffc0001UL
+#define CACHE_LINE_SIZE		64
 static unsigned int
-libxfs_bhash(cache_key_t key, unsigned int hashsize)
+libxfs_bhash(cache_key_t key, unsigned int hashsize, unsigned int hashshift)
 {
-	return (((unsigned int)((struct xfs_bufkey *)key)->blkno) >> 5) % hashsize;
+	uint64_t	hashval = ((struct xfs_bufkey *)key)->blkno;
+	uint64_t	tmp;
+
+	tmp = hashval ^ (GOLDEN_RATIO_PRIME + hashval) / CACHE_LINE_SIZE;
+	tmp = tmp ^ ((tmp ^ GOLDEN_RATIO_PRIME) >> hashshift);
+	return tmp % hashsize;
 }
 
 static int
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
