Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N52gWc134604 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:02:42 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	QpbjG76RzAbrxjEl for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:27 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PZk-0003Ef-Vv
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:25 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZf-0003c8-SJ
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 012/102] xfs: Don't allocate new buffers on every call to
	_xfs_buf_find
Date: Thu, 23 Aug 2012 15:01:30 +1000
Message-Id: <1345698180-13612-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Upstream commit: 3815832a2aa4df9815d15dac05227e0c8551833f

Stats show that for an 8-way unlink @ ~80,000 unlinks/s we are doing
~1 million cache hit lookups to ~3000 buffer creates. That's almost
3 orders of magnitude more cahce hits than misses, so optimising for
cache hits is quite important. In the cache hit case, we do not need
to allocate a new buffer in case of a cache miss, so we are
effectively hitting the allocator for no good reason for vast the
majority of calls to _xfs_buf_find. 8-way create workloads are
showing similar cache hit/miss ratios.

The result is profiles that look like this:

     samples  pcnt function                        DSO
     _______ _____ _______________________________ _________________

     1036.00 10.0% _xfs_buf_find                   [kernel.kallsyms]
      582.00  5.6% kmem_cache_alloc                [kernel.kallsyms]
      519.00  5.0% __memcpy                        [kernel.kallsyms]
      468.00  4.5% __ticket_spin_lock              [kernel.kallsyms]
      388.00  3.7% kmem_cache_free                 [kernel.kallsyms]
      331.00  3.2% xfs_log_commit_cil              [kernel.kallsyms]


Further, there is a fair bit of work involved in initialising a new
buffer once a cache miss has occurred and we currently do that under
the rbtree spinlock. That increases spinlock hold time on what are
heavily used trees.

To fix this, remove the initialisation of the buffer from
_xfs_buf_find() and only allocate the new buffer once we've had a
cache miss. Initialise the buffer immediately after allocating it in
xfs_buf_get, too, so that is it ready for insert if we get another
cache miss after allocation. This minimises lock hold time and
avoids unnecessary allocator churn. The resulting profiles look
like:

     samples  pcnt function                    DSO
     _______ _____ ___________________________ _________________

     8111.00  9.1% _xfs_buf_find               [kernel.kallsyms]
     4380.00  4.9% __memcpy                    [kernel.kallsyms]
     4341.00  4.8% __ticket_spin_lock          [kernel.kallsyms]
     3401.00  3.8% kmem_cache_alloc            [kernel.kallsyms]
     2856.00  3.2% xfs_log_commit_cil          [kernel.kallsyms]
     2625.00  2.9% __kmalloc                   [kernel.kallsyms]
     2380.00  2.7% kfree                       [kernel.kallsyms]
     2016.00  2.3% kmem_cache_free             [kernel.kallsyms]

Showing a significant reduction in time spent doing allocation and
freeing from slabs (kmem_cache_alloc and kmem_cache_free).

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   48 ++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 5e68099..6a2ab95 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -481,8 +481,6 @@ _xfs_buf_find(
 
 	/* No match found */
 	if (new_bp) {
-		_xfs_buf_initialize(new_bp, btp, range_base,
-				range_length, flags);
 		rb_link_node(&new_bp->b_rbnode, parent, rbp);
 		rb_insert_color(&new_bp->b_rbnode, &pag->pag_buf_tree);
 		/* the buffer keeps the perag reference until it is freed */
@@ -527,35 +525,53 @@ found:
 }
 
 /*
- *	Assembles a buffer covering the specified range.
- *	Storage in memory for all portions of the buffer will be allocated,
- *	although backing storage may not be.
+ * Assembles a buffer covering the specified range. The code is optimised for
+ * cache hits, as metadata intensive workloads will see 3 orders of magnitude
+ * more hits than misses.
  */
-xfs_buf_t *
+struct xfs_buf *
 xfs_buf_get(
 	xfs_buftarg_t		*target,/* target for buffer		*/
 	xfs_off_t		ioff,	/* starting offset of range	*/
 	size_t			isize,	/* length of range		*/
 	xfs_buf_flags_t		flags)
 {
-	xfs_buf_t		*bp, *new_bp;
+	struct xfs_buf		*bp;
+	struct xfs_buf		*new_bp;
 	int			error = 0;
 
+	bp = _xfs_buf_find(target, ioff, isize, flags, NULL);
+	if (likely(bp))
+		goto found;
+
 	new_bp = xfs_buf_allocate(flags);
 	if (unlikely(!new_bp))
 		return NULL;
 
+	_xfs_buf_initialize(new_bp, target,
+			    ioff << BBSHIFT, isize << BBSHIFT, flags);
+
 	bp = _xfs_buf_find(target, ioff, isize, flags, new_bp);
+	if (!bp) {
+		xfs_buf_deallocate(new_bp);
+		return NULL;
+	}
+
 	if (bp == new_bp) {
 		error = xfs_buf_allocate_memory(bp, flags);
 		if (error)
 			goto no_buffer;
-	} else {
+	} else
 		xfs_buf_deallocate(new_bp);
-		if (unlikely(bp == NULL))
-			return NULL;
-	}
 
+	/*
+	 * Now we have a workable buffer, fill in the block number so
+	 * that we can do IO on it.
+	 */
+	bp->b_bn = ioff;
+	bp->b_count_desired = bp->b_buffer_length;
+
+found:
 	if (!(bp->b_flags & XBF_MAPPED)) {
 		error = _xfs_buf_map_pages(bp, flags);
 		if (unlikely(error)) {
@@ -566,18 +582,10 @@ xfs_buf_get(
 	}
 
 	XFS_STATS_INC(xb_get);
-
-	/*
-	 * Always fill in the block number now, the mapped cases can do
-	 * their own overlay of this later.
-	 */
-	bp->b_bn = ioff;
-	bp->b_count_desired = bp->b_buffer_length;
-
 	trace_xfs_buf_get(bp, flags, _RET_IP_);
 	return bp;
 
- no_buffer:
+no_buffer:
 	if (flags & (XBF_LOCK | XBF_TRYLOCK))
 		xfs_buf_unlock(bp);
 	xfs_buf_rele(bp);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
