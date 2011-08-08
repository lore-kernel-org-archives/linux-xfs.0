Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p786pQGd020212 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 01:51:27 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 296291EF844B
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2011 23:51:25 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Hzc3xm7VZygE7bsT for <xfs@oss.sgi.com>;
	Sun, 07 Aug 2011 23:51:25 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1QqJgA-00028Y-8w
	for xfs@oss.sgi.com; Mon, 08 Aug 2011 16:51:14 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1QqJgA-0002qD-1J
	for xfs@oss.sgi.com; Mon, 08 Aug 2011 16:51:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: Don't allocate new buffers on every call to
	_xfs_buf_find
Date: Mon,  8 Aug 2011 16:51:10 +1000
Message-Id: <1312786271-10871-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1312786271-10871-1-git-send-email-david@fromorbit.com>
References: <1312786271-10871-1-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/linux-2.6/xfs_buf.c |   34 ++++++++++++++++++++--------------
 1 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index c57836d..56c685c 100644
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
@@ -529,30 +527,38 @@ found:
  *	Storage in memory for all portions of the buffer will be allocated,
  *	although backing storage may not be.
  */
-xfs_buf_t *
+struct xfs_buf *
 xfs_buf_get(
-	xfs_buftarg_t		*target,/* target for buffer		*/
+	struct xfs_buftarg	*target,/* target for buffer		*/
 	xfs_off_t		ioff,	/* starting offset of range	*/
 	size_t			isize,	/* length of range		*/
 	xfs_buf_flags_t		flags)
 {
-	xfs_buf_t		*bp, *new_bp;
+	struct xfs_buf		*bp;
+	struct xfs_buf		*new_bp = NULL;
 	int			error = 0;
 
-	new_bp = xfs_buf_allocate(flags);
-	if (unlikely(!new_bp))
-		return NULL;
-
+again:
 	bp = _xfs_buf_find(target, ioff, isize, flags, new_bp);
-	if (bp == new_bp) {
+	if (!(bp || new_bp)) {
+		new_bp = xfs_buf_allocate(flags);
+		if (unlikely(!new_bp))
+			return NULL;
+
+		_xfs_buf_initialize(new_bp, target, ioff << BBSHIFT,
+				isize << BBSHIFT, flags);
+		goto again;
+	}
+
+	if (!bp) {
+		xfs_buf_deallocate(new_bp);
+		return NULL;
+	} else if (bp == new_bp) {
 		error = xfs_buf_allocate_memory(bp, flags);
 		if (error)
 			goto no_buffer;
-	} else {
+	} else if (new_bp)
 		xfs_buf_deallocate(new_bp);
-		if (unlikely(bp == NULL))
-			return NULL;
-	}
 
 	if (!(bp->b_flags & XBF_MAPPED)) {
 		error = _xfs_buf_map_pages(bp, flags);
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
