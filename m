Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 201847F5F
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 10:39:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CD62E304059
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 08:39:45 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	AG3UC1ckw4G7fj6s for <xfs@oss.sgi.com>;
	Mon, 09 Sep 2013 08:39:43 -0700 (PDT)
Date: Tue, 10 Sep 2013 01:39:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] xfs: lookaside cache for xfs_buf_find
Message-ID: <20130909153939.GU12779@dastard>
References: <1378690396-15792-1-git-send-email-david@fromorbit.com>
	<522DE684.4000903@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <522DE684.4000903@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Sep 09, 2013 at 10:17:24AM -0500, Mark Tinguely wrote:
> On 09/08/13 20:33, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >CPU overhead of buffer lookups dominate most metadata intensive
> >workloads. The thing is, most such workloads are hitting a
> >relatively small number of buffers repeatedly, and so caching
> >recently hit buffers is a good idea.
> >
> >Add a hashed lookaside buffer that records the recent buffer
> >lookup successes and is searched first before doing a rb-tree
> >lookup. If we get a hit, we avoid the expensive rbtree lookup and
> >greatly reduce the overhead of the lookup. If we get a cache miss,
> >then we've added an extra CPU cacheline miss into the lookup.
> 
> Interesting. The last allocated xfs_buf is placed into the hash.
> 
> Might be interesting to know the hit-miss ratio on a real workload.

Of course. Didn't you notice that data in the next patch I sent? ;)

Anyway, here's one I prepared earlier.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


[RFC v2] xfs: lookaside cache for xfs_buf_find

From: Dave Chinner <dchinner@redhat.com>

CPU overhead of buffer lookups dominate most metadata intensive
workloads. The thing is, most such workloads are hitting a
relatively small number of buffers repeatedly, and so caching
recently hit buffers is a good idea.

Add a hashed lookaside buffer that records the recent buffer
lookup successes and is searched first before doing a rb-tree
lookup. If we get a hit, we avoid the expensive rbtree lookup and
greatly reduce the overhead of the lookup. If we get a cache miss,
then we've added an extra CPU cacheline miss into the lookup.

In cold cache lookup cases, this extra cache line miss is irrelevant
as we need to read or allocate the buffer anyway, and the etup time
for that dwarfs the cost of the miss.

In the case that we miss the lookaside cache and find the buffer in
the rbtree, the cache line miss overhead will be noticable only if
we don't see any lookaside cache misses at all in subsequent
lookups. We don't tend to do random cache walks in perfomrance
critical paths, so the net result is that the extra CPU cacheline
miss will be lost in the reduction of misses due to cache hits. This
hit/miss case is what we'll see with file removal operations.

A simple prime number hash was chosen for the cache (i.e. modulo 37)
because it is fast, simple, and works really well with block numbers
that tend to be aligned to a multiple of 8. No attempt to optimise
this has been made - it's just a number I picked out of thin air
given that most repetitive workloads have a working set of buffers
that is significantly smaller than 37 per AG and should hold most of
the AG header buffers permanently in the lookaside cache.

The result is that on a typical concurrent create fsmark benchmark I
run, the profile of CPU usage went from having _xfs_buf_find() as
teh number one CPU consumer:

   6.55%  [kernel]  [k] _xfs_buf_find
   4.94%  [kernel]  [k] xfs_dir3_free_hdr_from_disk
   4.77%  [kernel]  [k] native_read_tsc
   4.67%  [kernel]  [k] __ticket_spin_trylock

to this, at about #8 and #30 in the profile:

   2.56%  [kernel]  [k] _xfs_buf_find
....
   0.55%  [kernel]  [k] _xfs_buf_find_lookaside

So the lookaside cache has halved the CPU overhead of looking up
buffers for this workload.

On a buffer hit/miss workload like the followup concurrent removes,
_xfs_buf_find() went from #1 in the profile again at:

   9.13%  [kernel]  [k] _xfs_buf_find

to #6 and #23 repesctively:

   2.82%  [kernel]  [k] _xfs_buf_find
....
   0.78%  [kernel]  [k] _xfs_buf_find_lookaside

IOWs, on most workloads - even read only workloads - there is still
a significant benefit to this simple lookaside cache.

More analysis, using -m crc=1,finobt=1:

Lookaside cache hit rates vs size:

		    cache size
cache size	7	37	73
create		0.4	0.76	0.88
bulkstat	0.64	0.88	0.93
find+stat	0.45	0.68	0.73
ls -R		0.06	0.10	0.14
unlink		0.43	0.75	0.89

As expected, the larger the cache, the higher the hit rate.

Wall time vs cache size:

			cache size
		none	7	37	73
create		256s	240s	235s	238s
bulkstat	153s	154s	163s	161s
find+stat	210s	204s	205s	206s
ls -R		 31s	 31s	 31s	32s
unlink		381s	362s	356s	360s

Higher hit rates don't necessarily translate into higher
performance, however.

System time vs cache size:

			cache size
		none	7	37	73
create		2851s	2681s	2637s	2607s
bulkstat	2357s	2342s	2497s	2473s
find+stat	1743s	1704s	1681s	1667s
ls -R		 22s	  21s	  20s	  21s
unlink		3409s	3313s	3216s	3168s

All looks as expected here given the cache hit rate numbers, except
for the bulkstat numbers. I'm not sure why the system time goes up
given the cache hit rates being so high - perf shows the CPU in
xfs_buf_find() going down....

So, performance is best at a cache size of 37 entries, though cache
hit rates and system time is better with 73 entries. Not immediately
obvious why, but it tends to indicate the initial swag at a cache of
37 entries gives a pretty good tradeoff between size, CPU usage
reduction and overall performance improvement.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c   | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_buf.h   |  6 +++++
 fs/xfs/xfs_mount.h |  4 +++-
 fs/xfs/xfs_stats.h |  8 ++++++-
 4 files changed, 79 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ee85f29..bcceb81 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -470,6 +470,49 @@ _xfs_buf_map_pages(
  */
 
 /*
+ * Lookaside cache check
+ */
+STATIC struct xfs_buf *
+_xfs_buf_find_lookaside(
+	struct xfs_perag	*pag,
+	xfs_daddr_t		bn,
+	int			numblks)
+{
+	struct xfs_buf	*bp;
+
+	ASSERT(spin_is_locked(&pag->pag_buf_lock));
+	bp = pag->pag_buf_cache[XBF_HASH(bn)];
+	if (!bp)
+		return NULL;
+	if (bp->b_bn != bn || bp->b_length != numblks)
+		return NULL;
+	return bp;
+}
+
+static __inline__ void
+_xfs_buf_find_lookaside_insert(
+	struct xfs_perag	*pag,
+	struct xfs_buf		*bp,
+	xfs_daddr_t		bn)
+{
+	ASSERT(spin_is_locked(&pag->pag_buf_lock));
+	XFS_STATS_INC(xb_lookaside_insert);
+	pag->pag_buf_cache[XBF_HASH(bn)] = bp;
+}
+
+static __inline__ void
+_xfs_buf_find_lookaside_remove(
+	struct xfs_perag	*pag,
+	struct xfs_buf		*bp)
+{
+	ASSERT(spin_is_locked(&pag->pag_buf_lock));
+	if (pag->pag_buf_cache[XBF_HASH(bp->b_bn)] == bp) {
+		XFS_STATS_INC(xb_lookaside_remove);
+		pag->pag_buf_cache[XBF_HASH(bp->b_bn)] = NULL;
+	}
+}
+
+/*
  *	Look up, and creates if absent, a lockable buffer for
  *	a given range of an inode.  The buffer is returned
  *	locked.	No I/O is implied by this call.
@@ -492,6 +535,13 @@ _xfs_buf_find(
 	int			numblks = 0;
 	int			i;
 
+	/* get tree root */
+	pag = xfs_perag_get(btp->bt_mount,
+				xfs_daddr_to_agno(btp->bt_mount, blkno));
+	prefetch(&pag->pag_buf_lock);
+	prefetch(&pag->pag_buf_cache[XBF_HASH(blkno)]);
+	prefetch(&pag->pag_buf_tree);
+
 	for (i = 0; i < nmaps; i++)
 		numblks += map[i].bm_len;
 	numbytes = BBTOB(numblks);
@@ -515,15 +565,20 @@ _xfs_buf_find(
 			  "%s: Block out of range: block 0x%llx, EOFS 0x%llx ",
 			  __func__, blkno, eofs);
 		WARN_ON(1);
+		xfs_perag_put(pag);
 		return NULL;
 	}
 
-	/* get tree root */
-	pag = xfs_perag_get(btp->bt_mount,
-				xfs_daddr_to_agno(btp->bt_mount, blkno));
 
-	/* walk tree */
+	/* First check the lookaside cache for a hit, otherwise walk the tree */
 	spin_lock(&pag->pag_buf_lock);
+	bp = _xfs_buf_find_lookaside(pag, blkno, numblks);
+	if (bp) {
+		XFS_STATS_INC(xb_lookaside_hit);
+		goto found;
+	}
+
+	XFS_STATS_INC(xb_lookaside_miss);
 	rbp = &pag->pag_buf_tree.rb_node;
 	parent = NULL;
 	bp = NULL;
@@ -549,7 +604,7 @@ _xfs_buf_find(
 				rbp = &(*rbp)->rb_right;
 				continue;
 			}
-			atomic_inc(&bp->b_hold);
+			_xfs_buf_find_lookaside_insert(pag, bp, blkno);
 			goto found;
 		}
 	}
@@ -560,6 +615,7 @@ _xfs_buf_find(
 		rb_insert_color(&new_bp->b_rbnode, &pag->pag_buf_tree);
 		/* the buffer keeps the perag reference until it is freed */
 		new_bp->b_pag = pag;
+		_xfs_buf_find_lookaside_insert(pag, bp, blkno);
 		spin_unlock(&pag->pag_buf_lock);
 	} else {
 		XFS_STATS_INC(xb_miss_locked);
@@ -569,6 +625,7 @@ _xfs_buf_find(
 	return new_bp;
 
 found:
+	atomic_inc(&bp->b_hold);
 	spin_unlock(&pag->pag_buf_lock);
 	xfs_perag_put(pag);
 
@@ -924,6 +981,7 @@ xfs_buf_rele(
 		} else {
 			xfs_buf_lru_del(bp);
 			ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
+			_xfs_buf_find_lookaside_remove(pag, bp);
 			rb_erase(&bp->b_rbnode, &pag->pag_buf_tree);
 			spin_unlock(&pag->pag_buf_lock);
 			xfs_perag_put(pag);
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 433a12e..658f746 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -166,6 +166,12 @@ typedef struct xfs_buf {
 #endif
 } xfs_buf_t;
 
+/*
+ * lookaside cache definitions
+ */
+#define XBF_HASH_SIZE		37
+#define XBF_HASH(bn)		(bn % XBF_HASH_SIZE)
+
 /* Finding and Reading Buffers */
 struct xfs_buf *_xfs_buf_find(struct xfs_buftarg *target,
 			      struct xfs_buf_map *map, int nmaps,
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 1fa0584..2a997dc 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -364,7 +364,9 @@ typedef struct xfs_perag {
 	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
 
 	/* buffer cache index */
-	spinlock_t	pag_buf_lock;	/* lock for pag_buf_tree */
+	spinlock_t	pag_buf_lock ____cacheline_aligned_in_smp;
+					/* lock for pag_buf_tree */
+	struct xfs_buf	*pag_buf_cache[XBF_HASH_SIZE];
 	struct rb_root	pag_buf_tree;	/* ordered tree of active buffers */
 
 	/* for rcu-safe freeing */
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index c8f238b..c1f98cb 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -108,7 +108,7 @@ struct xfsstats {
 	__uint32_t		vn_reclaim;	/* # times vn_reclaim called */
 	__uint32_t		vn_remove;	/* # times vn_remove called */
 	__uint32_t		vn_free;	/* # times vn_free called */
-#define XFSSTAT_END_BUF			(XFSSTAT_END_VNODE_OPS+9)
+#define XFSSTAT_END_BUF			(XFSSTAT_END_VNODE_OPS+13)
 	__uint32_t		xb_get;
 	__uint32_t		xb_create;
 	__uint32_t		xb_get_locked;
@@ -118,6 +118,12 @@ struct xfsstats {
 	__uint32_t		xb_page_retries;
 	__uint32_t		xb_page_found;
 	__uint32_t		xb_get_read;
+	/* XXX: can we extend like this? */
+	__uint32_t		xb_lookaside_hit;
+	__uint32_t		xb_lookaside_miss;
+	__uint32_t		xb_lookaside_insert;
+	__uint32_t		xb_lookaside_remove;
+
 /* Version 2 btree counters */
 #define XFSSTAT_END_ABTB_V2		(XFSSTAT_END_BUF+15)
 	__uint32_t		xs_abtb_2_lookup;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
