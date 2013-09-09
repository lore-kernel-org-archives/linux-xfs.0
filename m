Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0BCDB7F55
	for <xfs@oss.sgi.com>; Sun,  8 Sep 2013 20:33:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ACDAAAC003
	for <xfs@oss.sgi.com>; Sun,  8 Sep 2013 18:33:25 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	l9pUglKwOzaqrijS for <xfs@oss.sgi.com>;
	Sun, 08 Sep 2013 18:33:20 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VIqLs-0001ZD-38
	for xfs@oss.sgi.com; Mon, 09 Sep 2013 11:33:16 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VIqLs-00047I-2B
	for xfs@oss.sgi.com; Mon, 09 Sep 2013 11:33:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] [RFC] xfs: lookaside cache for xfs_buf_find
Date: Mon,  9 Sep 2013 11:33:16 +1000
Message-Id: <1378690396-15792-1-git-send-email-david@fromorbit.com>
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

Which is also a significant reduction in CPU overhead for buffer
lookups, and shows the benefit on mixed cold/hot cache lookup
workloads.

Performance differential, as measured with -m crc=1,finobt=1:

		   create		remove
		time    rate		time
xfsdev		4m16s	221k/s		6m18s
patched		3m59s	236k/s		5m56s

So less CPU time spent on lookups translates directly to better
metadata performance.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c   | 51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_buf.h   |  6 ++++++
 fs/xfs/xfs_mount.h |  1 +
 3 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ee85f29..e382b80 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -470,6 +470,46 @@ _xfs_buf_map_pages(
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
+	pag->pag_buf_cache[XBF_HASH(bn)] = bp;
+}
+
+static __inline__ void
+_xfs_buf_find_lookaside_remove(
+	struct xfs_perag	*pag,
+	struct xfs_buf		*bp)
+{
+	ASSERT(spin_is_locked(&pag->pag_buf_lock));
+	if (pag->pag_buf_cache[XBF_HASH(bp->b_bn)] == bp)
+		pag->pag_buf_cache[XBF_HASH(bp->b_bn)] = NULL;
+}
+
+/*
  *	Look up, and creates if absent, a lockable buffer for
  *	a given range of an inode.  The buffer is returned
  *	locked.	No I/O is implied by this call.
@@ -522,8 +562,12 @@ _xfs_buf_find(
 	pag = xfs_perag_get(btp->bt_mount,
 				xfs_daddr_to_agno(btp->bt_mount, blkno));
 
-	/* walk tree */
+	/* First check the lookaside cache for a hit, otherwise walk the tree */
 	spin_lock(&pag->pag_buf_lock);
+	bp = _xfs_buf_find_lookaside(pag, blkno, numblks);
+	if (bp)
+		goto found;
+
 	rbp = &pag->pag_buf_tree.rb_node;
 	parent = NULL;
 	bp = NULL;
@@ -549,7 +593,7 @@ _xfs_buf_find(
 				rbp = &(*rbp)->rb_right;
 				continue;
 			}
-			atomic_inc(&bp->b_hold);
+			_xfs_buf_find_lookaside_insert(pag, bp, blkno);
 			goto found;
 		}
 	}
@@ -560,6 +604,7 @@ _xfs_buf_find(
 		rb_insert_color(&new_bp->b_rbnode, &pag->pag_buf_tree);
 		/* the buffer keeps the perag reference until it is freed */
 		new_bp->b_pag = pag;
+		_xfs_buf_find_lookaside_insert(pag, bp, blkno);
 		spin_unlock(&pag->pag_buf_lock);
 	} else {
 		XFS_STATS_INC(xb_miss_locked);
@@ -569,6 +614,7 @@ _xfs_buf_find(
 	return new_bp;
 
 found:
+	atomic_inc(&bp->b_hold);
 	spin_unlock(&pag->pag_buf_lock);
 	xfs_perag_put(pag);
 
@@ -924,6 +970,7 @@ xfs_buf_rele(
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
index 1fa0584..b8bfabc 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -366,6 +366,7 @@ typedef struct xfs_perag {
 	/* buffer cache index */
 	spinlock_t	pag_buf_lock;	/* lock for pag_buf_tree */
 	struct rb_root	pag_buf_tree;	/* ordered tree of active buffers */
+	struct xfs_buf	*pag_buf_cache[XBF_HASH_SIZE];
 
 	/* for rcu-safe freeing */
 	struct rcu_head	rcu_head;
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
