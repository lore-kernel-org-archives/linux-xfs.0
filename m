Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7Q6ptgx043582 for <xfs@oss.sgi.com>; Fri, 26 Aug 2011 01:51:55 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A6FD13A1100
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 23:54:48 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	LMgvCaFj6Jqbu7rc for <xfs@oss.sgi.com>;
	Thu, 25 Aug 2011 23:54:48 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1QwqGc-0006jq-LC
	for xfs@oss.sgi.com; Fri, 26 Aug 2011 16:51:50 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1QwqGS-0006EJ-Gs
	for xfs@oss.sgi.com; Fri, 26 Aug 2011 16:51:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] xfs: Don't allocate new buffers on every call to
	_xfs_buf_find
Date: Fri, 26 Aug 2011 16:51:34 +1000
Message-Id: <1314341497-23910-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1314341497-23910-1-git-send-email-david@fromorbit.com>
References: <1314341497-23910-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_buf.c |   89 +++++++++++++++++++++++++++++++-----------------------
 1 files changed, 51 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index c57836d..594cea5 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -171,10 +171,16 @@ STATIC void
 _xfs_buf_initialize(
 	xfs_buf_t		*bp,
 	xfs_buftarg_t		*target,
-	xfs_off_t		range_base,
-	size_t			range_length,
+	xfs_off_t		bno,
+	size_t			num_blocks,
 	xfs_buf_flags_t		flags)
 {
+	xfs_off_t		range_base;
+	size_t			range_length;
+
+	range_base = BBTOB(bno);
+	range_length = BBTOB(num_blocks);
+
 	/*
 	 * We don't want certain flags to appear in b_flags.
 	 */
@@ -423,9 +429,9 @@ _xfs_buf_map_pages(
  */
 xfs_buf_t *
 _xfs_buf_find(
-	xfs_buftarg_t		*btp,	/* block device target		*/
-	xfs_off_t		ioff,	/* starting offset of range	*/
-	size_t			isize,	/* length of range		*/
+	xfs_buftarg_t		*btp,
+	xfs_off_t		bno,
+	size_t			num_blocks,
 	xfs_buf_flags_t		flags,
 	xfs_buf_t		*new_bp)
 {
@@ -436,8 +442,8 @@ _xfs_buf_find(
 	struct rb_node		*parent;
 	xfs_buf_t		*bp;
 
-	range_base = (ioff << BBSHIFT);
-	range_length = (isize << BBSHIFT);
+	range_base = BBTOB(bno);
+	range_length = BBTOB(num_blocks);
 
 	/* Check for IOs smaller than the sector size / not sector aligned */
 	ASSERT(!(range_length < (1 << btp->bt_sshift)));
@@ -445,7 +451,7 @@ _xfs_buf_find(
 
 	/* get tree root */
 	pag = xfs_perag_get(btp->bt_mount,
-				xfs_daddr_to_agno(btp->bt_mount, ioff));
+				xfs_daddr_to_agno(btp->bt_mount, bno));
 
 	/* walk tree */
 	spin_lock(&pag->pag_buf_lock);
@@ -481,8 +487,6 @@ _xfs_buf_find(
 
 	/* No match found */
 	if (new_bp) {
-		_xfs_buf_initialize(new_bp, btp, range_base,
-				range_length, flags);
 		rb_link_node(&new_bp->b_rbnode, parent, rbp);
 		rb_insert_color(&new_bp->b_rbnode, &pag->pag_buf_tree);
 		/* the buffer keeps the perag reference until it is freed */
@@ -525,34 +529,43 @@ found:
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
-	xfs_buftarg_t		*target,/* target for buffer		*/
-	xfs_off_t		ioff,	/* starting offset of range	*/
-	size_t			isize,	/* length of range		*/
+	struct xfs_buftarg	*target,
+	xfs_off_t		bno,
+	size_t			num_blocks,
 	xfs_buf_flags_t		flags)
 {
-	xfs_buf_t		*bp, *new_bp;
+	struct xfs_buf		*bp;
+	struct xfs_buf		*new_bp;
 	int			error = 0;
 
+	bp = _xfs_buf_find(target, bno, num_blocks, flags, NULL);
+	if (likely(bp))
+		goto found;
+
 	new_bp = xfs_buf_allocate(flags);
 	if (unlikely(!new_bp))
 		return NULL;
 
-	bp = _xfs_buf_find(target, ioff, isize, flags, new_bp);
+	_xfs_buf_initialize(new_bp, target, bno, num_blocks, flags);
+
+	bp = _xfs_buf_find(target, bno, num_blocks, flags, new_bp);
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
 
 	if (!(bp->b_flags & XBF_MAPPED)) {
 		error = _xfs_buf_map_pages(bp, flags);
@@ -563,19 +576,19 @@ xfs_buf_get(
 		}
 	}
 
-	XFS_STATS_INC(xb_get);
-
 	/*
-	 * Always fill in the block number now, the mapped cases can do
-	 * their own overlay of this later.
+	 * Now we have a workable buffer, fill in the block number so
+	 * that we can do IO on it.
 	 */
-	bp->b_bn = ioff;
-	bp->b_count_desired = bp->b_buffer_length;
+	bp->b_bn = bno;
 
+found:
+	ASSERT(bp->b_flags & XBF_MAPPED);
+	XFS_STATS_INC(xb_get);
 	trace_xfs_buf_get(bp, flags, _RET_IP_);
 	return bp;
 
- no_buffer:
+no_buffer:
 	if (flags & (XBF_LOCK | XBF_TRYLOCK))
 		xfs_buf_unlock(bp);
 	xfs_buf_rele(bp);
@@ -604,15 +617,15 @@ _xfs_buf_read(
 xfs_buf_t *
 xfs_buf_read(
 	xfs_buftarg_t		*target,
-	xfs_off_t		ioff,
-	size_t			isize,
+	xfs_off_t		bno,
+	size_t			num_blocks,
 	xfs_buf_flags_t		flags)
 {
 	xfs_buf_t		*bp;
 
 	flags |= XBF_READ;
 
-	bp = xfs_buf_get(target, ioff, isize, flags);
+	bp = xfs_buf_get(target, bno, num_blocks, flags);
 	if (bp) {
 		trace_xfs_buf_read(bp, flags, _RET_IP_);
 
@@ -647,13 +660,13 @@ xfs_buf_read(
 void
 xfs_buf_readahead(
 	xfs_buftarg_t		*target,
-	xfs_off_t		ioff,
-	size_t			isize)
+	xfs_off_t		bno,
+	size_t			num_blocks)
 {
 	if (bdi_read_congested(target->bt_bdi))
 		return;
 
-	xfs_buf_read(target, ioff, isize,
+	xfs_buf_read(target, bno, num_blocks,
 		     XBF_TRYLOCK|XBF_ASYNC|XBF_READ_AHEAD|XBF_DONT_BLOCK);
 }
 
@@ -698,7 +711,7 @@ xfs_buf_get_empty(
 
 	bp = xfs_buf_allocate(0);
 	if (bp)
-		_xfs_buf_initialize(bp, target, 0, len, 0);
+		_xfs_buf_initialize(bp, target, 0, BTOBB(len), 0);
 	return bp;
 }
 
@@ -790,7 +803,7 @@ xfs_buf_get_uncached(
 	bp = xfs_buf_allocate(0);
 	if (unlikely(bp == NULL))
 		goto fail;
-	_xfs_buf_initialize(bp, target, 0, len, 0);
+	_xfs_buf_initialize(bp, target, 0, BTOBB(len), 0);
 
 	error = _xfs_buf_get_pages(bp, page_count, 0);
 	if (error)
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
