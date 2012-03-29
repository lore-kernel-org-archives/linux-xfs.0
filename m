Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TCOSPa092207 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 07:24:28 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	19t7hJufEPpnG40C for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 05:24:25 -0700 (PDT)
Received: from [192.168.1.2] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SDEOt-0003fZ-Mn
	for xfs@oss.sgi.com; Thu, 29 Mar 2012 23:24:23 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SDEOd-0003Ng-OG
	for xfs@oss.sgi.com; Thu, 29 Mar 2012 23:24:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/8] xfs: use blocks for counting length of buffers
Date: Thu, 29 Mar 2012 23:23:53 +1100
Message-Id: <1333023835-12856-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1333023835-12856-1-git-send-email-david@fromorbit.com>
References: <1333023835-12856-1-git-send-email-david@fromorbit.com>
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

Now that we pass block counts everywhere, and index buffers by block
number, track the length of the buffer in units of blocks rather
than bytes. Convert the code to use block counts, and those that
need byte counts get converted at the time of use.

Also, remove the XFS_BUF_{SET_}SIZE() macros that are just wrappers
around the buffer length. They onyl serve to make the code shouty
loud and don't actually add any real value.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr.c        |   15 +++++++++------
 fs/xfs/xfs_buf.c         |   22 ++++++++++++----------
 fs/xfs/xfs_buf.h         |    4 +---
 fs/xfs/xfs_log.c         |    5 +----
 fs/xfs/xfs_log_recover.c |    8 ++++----
 fs/xfs/xfs_trace.h       |   14 +++++++-------
 6 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 65d61b9..6e9bd7e 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -1993,8 +1993,7 @@ xfs_attr_rmtval_get(xfs_da_args_t *args)
 			if (error)
 				return(error);
 
-			tmp = (valuelen < XFS_BUF_SIZE(bp))
-				? valuelen : XFS_BUF_SIZE(bp);
+			tmp = min_t(int, valuelen, BBTOB(bp->b_length));
 			xfs_buf_iomove(bp, 0, tmp, dst, XBRW_READ);
 			xfs_buf_relse(bp);
 			dst += tmp;
@@ -2097,6 +2096,8 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 	lblkno = args->rmtblkno;
 	valuelen = args->valuelen;
 	while (valuelen > 0) {
+		int buflen;
+
 		/*
 		 * Try to remember where we decided to put the value.
 		 */
@@ -2118,11 +2119,13 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 				 XBF_LOCK | XBF_DONT_BLOCK);
 		if (!bp)
 			return ENOMEM;
-		tmp = (valuelen < XFS_BUF_SIZE(bp)) ? valuelen :
-							XFS_BUF_SIZE(bp);
+
+		buflen = BBTOB(bp->b_length);
+		tmp = min_t(int, valuelen, buflen);
 		xfs_buf_iomove(bp, 0, tmp, src, XBRW_WRITE);
-		if (tmp < XFS_BUF_SIZE(bp))
-			xfs_buf_zero(bp, tmp, XFS_BUF_SIZE(bp) - tmp);
+		if (tmp < buflen)
+			xfs_buf_zero(bp, tmp, buflen - tmp);
+
 		error = xfs_bwrite(bp);	/* GROT: NOTE: synchronous write */
 		xfs_buf_relse(bp);
 		if (error)
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 19266cf..e128575 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -192,11 +192,12 @@ xfs_buf_alloc(
 	bp->b_target = target;
 
 	/*
-	 * Set buffer_length and count_desired to the same value initially.
+	 * Set length and count_desired to the same value initially.
 	 * I/O routines should use count_desired, which will be the same in
 	 * most cases but may be reset (e.g. XFS recovery).
 	 */
-	bp->b_buffer_length = bp->b_count_desired = numblks << BBSHIFT;
+	bp->b_length = numblks;
+	bp->b_count_desired = numblks << BBSHIFT;
 	bp->b_flags = flags;
 
 	/*
@@ -307,14 +308,14 @@ xfs_buf_allocate_memory(
 	 * the memory from the heap - there's no need for the complexity of
 	 * page arrays to keep allocation down to order 0.
 	 */
-	if (bp->b_buffer_length < PAGE_SIZE) {
-		bp->b_addr = kmem_alloc(bp->b_buffer_length, xb_to_km(flags));
+	if (bp->b_length < BTOBB(PAGE_SIZE)) {
+		bp->b_addr = kmem_alloc(BBTOB(bp->b_length), xb_to_km(flags));
 		if (!bp->b_addr) {
 			/* low memory - use alloc_page loop instead */
 			goto use_alloc_page;
 		}
 
-		if (((unsigned long)(bp->b_addr + bp->b_buffer_length - 1) &
+		if (((unsigned long)(bp->b_addr + BBTOB(bp->b_length) - 1) &
 								PAGE_MASK) !=
 		    ((unsigned long)bp->b_addr & PAGE_MASK)) {
 			/* b_addr spans two pages - use alloc_page instead */
@@ -331,7 +332,7 @@ xfs_buf_allocate_memory(
 	}
 
 use_alloc_page:
-	end = BBTOB(bp->b_bn) + bp->b_buffer_length;
+	end = BBTOB(bp->b_bn + bp->b_length);
 	page_count = xfs_buf_btoc(end) - xfs_buf_btoct(BBTOB(bp->b_bn));
 	error = _xfs_buf_get_pages(bp, page_count, flags);
 	if (unlikely(error))
@@ -472,7 +473,7 @@ lookup_again:
 			 * reallocating a busy extent. Skip this buffer and
 			 * continue searching to the right for an exact match.
 			 */
-			if (bp->b_buffer_length != numbytes) {
+			if (bp->b_length != numblks) {
 				ASSERT(bp->b_flags & XBF_STALE);
 				rbp = &(*rbp)->rb_right;
 				continue;
@@ -597,7 +598,7 @@ xfs_buf_get(
 	 * that we can do IO on it.
 	 */
 	bp->b_bn = blkno;
-	bp->b_count_desired = bp->b_buffer_length;
+	bp->b_count_desired = BBTOB(bp->b_length);
 
 found:
 	if (!(bp->b_flags & XBF_MAPPED)) {
@@ -739,7 +740,8 @@ xfs_buf_set_empty(
 	bp->b_pages = NULL;
 	bp->b_page_count = 0;
 	bp->b_addr = NULL;
-	bp->b_buffer_length = bp->b_count_desired = numblks << BBSHIFT;
+	bp->b_length = numblks;
+	bp->b_count_desired = numblks << BBSHIFT;
 	bp->b_bn = XFS_BUF_DADDR_NULL;
 	bp->b_flags &= ~XBF_MAPPED;
 }
@@ -792,7 +794,7 @@ xfs_buf_associate_memory(
 	}
 
 	bp->b_count_desired = len;
-	bp->b_buffer_length = buflen;
+	bp->b_length = BTOBB(buflen);
 	bp->b_flags |= XBF_MAPPED;
 
 	return 0;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 4cda900..df1814c 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -119,7 +119,7 @@ typedef struct xfs_buf {
 	 */
 	struct rb_node		b_rbnode;	/* rbtree node */
 	xfs_daddr_t		b_bn;		/* block number for I/O */
-	size_t			b_buffer_length;/* size of buffer in bytes */
+	int			b_length;	/* size of buffer in BBs */
 	atomic_t		b_hold;		/* reference count */
 	atomic_t		b_lru_ref;	/* lru reclaim ref count */
 	xfs_buf_flags_t		b_flags;	/* status flags */
@@ -248,8 +248,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_bn = (xfs_daddr_t)(bno))
 #define XFS_BUF_COUNT(bp)		((bp)->b_count_desired)
 #define XFS_BUF_SET_COUNT(bp, cnt)	((bp)->b_count_desired = (cnt))
-#define XFS_BUF_SIZE(bp)		((bp)->b_buffer_length)
-#define XFS_BUF_SET_SIZE(bp, cnt)	((bp)->b_buffer_length = (cnt))
 
 static inline void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
 {
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 8990012..f9d8355 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1197,9 +1197,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	spin_lock_init(&log->l_icloglock);
 	init_waitqueue_head(&log->l_flush_wait);
 
-	/* log record size must be multiple of BBSIZE; see xlog_rec_header_t */
-	ASSERT((XFS_BUF_SIZE(bp) & BBMASK) == 0);
-
 	iclogp = &log->l_iclog;
 	/*
 	 * The amount of memory to allocate for the iclog structure is
@@ -1239,7 +1236,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		head->h_fmt = cpu_to_be32(XLOG_FMT);
 		memcpy(&head->h_fs_uuid, &mp->m_sb.sb_uuid, sizeof(uuid_t));
 
-		iclog->ic_size = XFS_BUF_SIZE(bp) - log->l_iclog_hsize;
+		iclog->ic_size = BBTOB(bp->b_length) - log->l_iclog_hsize;
 		iclog->ic_state = XLOG_STATE_ACTIVE;
 		iclog->ic_log = log;
 		atomic_set(&iclog->ic_refcnt, 0);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d94ed40..15b7470 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -146,7 +146,7 @@ xlog_align(
 {
 	xfs_daddr_t	offset = blk_no & ((xfs_daddr_t)log->l_sectBBsize - 1);
 
-	ASSERT(BBTOB(offset + nbblks) <= XFS_BUF_SIZE(bp));
+	ASSERT(offset + nbblks <= bp->b_length);
 	return bp->b_addr + BBTOB(offset);
 }
 
@@ -174,7 +174,7 @@ xlog_bread_noalign(
 	nbblks = round_up(nbblks, log->l_sectBBsize);
 
 	ASSERT(nbblks > 0);
-	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
+	ASSERT(nbblks <= bp->b_length);
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	XFS_BUF_READ(bp);
@@ -219,7 +219,7 @@ xlog_bread_offset(
 	xfs_caddr_t	offset)
 {
 	xfs_caddr_t	orig_offset = bp->b_addr;
-	int		orig_len = bp->b_buffer_length;
+	int		orig_len = BBTOB(bp->b_length);
 	int		error, error2;
 
 	error = xfs_buf_associate_memory(bp, offset, BBTOB(nbblks));
@@ -260,7 +260,7 @@ xlog_bwrite(
 	nbblks = round_up(nbblks, log->l_sectBBsize);
 
 	ASSERT(nbblks > 0);
-	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
+	ASSERT(nbblks <= bp->b_length);
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	XFS_BUF_ZEROFLAGS(bp);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7d37440..895e0ff 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -281,7 +281,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_daddr_t, bno)
-		__field(size_t, buffer_length)
+		__field(int, nblks)
 		__field(int, hold)
 		__field(int, pincount)
 		__field(unsigned, lockval)
@@ -291,18 +291,18 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 	TP_fast_assign(
 		__entry->dev = bp->b_target->bt_dev;
 		__entry->bno = bp->b_bn;
-		__entry->buffer_length = bp->b_buffer_length;
+		__entry->nblks = bp->b_length;
 		__entry->hold = atomic_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
 		__entry->lockval = bp->b_sema.count;
 		__entry->flags = bp->b_flags;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
+	TP_printk("dev %d:%d bno 0x%llx nblks 0x%x hold %d pincount %d "
 		  "lock %d flags %s caller %pf",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
-		  __entry->buffer_length,
+		  __entry->nblks,
 		  __entry->hold,
 		  __entry->pincount,
 		  __entry->lockval,
@@ -362,7 +362,7 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
 	TP_fast_assign(
 		__entry->dev = bp->b_target->bt_dev;
 		__entry->bno = bp->b_bn;
-		__entry->buffer_length = bp->b_buffer_length;
+		__entry->buffer_length = BBTOB(bp->b_length);
 		__entry->flags = flags;
 		__entry->hold = atomic_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
@@ -408,7 +408,7 @@ TRACE_EVENT(xfs_buf_ioerror,
 	TP_fast_assign(
 		__entry->dev = bp->b_target->bt_dev;
 		__entry->bno = bp->b_bn;
-		__entry->buffer_length = bp->b_buffer_length;
+		__entry->buffer_length = BBTOB(bp->b_length);
 		__entry->hold = atomic_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
 		__entry->lockval = bp->b_sema.count;
@@ -452,7 +452,7 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
 		__entry->bli_recur = bip->bli_recur;
 		__entry->bli_refcount = atomic_read(&bip->bli_refcount);
 		__entry->buf_bno = bip->bli_buf->b_bn;
-		__entry->buf_len = bip->bli_buf->b_buffer_length;
+		__entry->buf_len = BBTOB(bip->bli_buf->b_length);
 		__entry->buf_flags = bip->bli_buf->b_flags;
 		__entry->buf_hold = atomic_read(&bip->bli_buf->b_hold);
 		__entry->buf_pincount = atomic_read(&bip->bli_buf->b_pin_count);
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
