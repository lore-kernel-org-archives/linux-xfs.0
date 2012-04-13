Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DCBJGK037900 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 07:11:19 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	EG7GWWGYHUdQ7D7u for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 05:11:17 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SIfLE-00030x-8a
	for xfs@oss.sgi.com; Fri, 13 Apr 2012 22:11:04 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SIfLE-0003OQ-5h
	for xfs@oss.sgi.com; Fri, 13 Apr 2012 22:11:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/18] xfs: use blocks for storing the desired IO size
Date: Fri, 13 Apr 2012 22:10:56 +1000
Message-Id: <1334319061-12968-14-git-send-email-david@fromorbit.com>
In-Reply-To: <1334319061-12968-1-git-send-email-david@fromorbit.com>
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
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

Now that we pass block counts everywhere, and index buffers by block
number and length in units of blocks, convert the desired IO size
into block counts rather than bytes. Convert the code to use block
counts, and those that need byte counts get converted at the time of
use.

Rename the b_desired_count variable to something closer to it's
purpose - b_io_length - as it is only used to specify the length of
an IO for a subset of the buffer.  The only time this is used is for
log IO - both writing iclogs and during log recovery. In all other
cases, the b_io_length matches b_length, and hence a lot of code
confuses the two. e.g. the buf item code uses the io count
exclusively when it should be using the buffer length. Fix these
apprpriately as they are found.

Also, remove the XFS_BUF_{SET_}COUNT() macros that are just wrappers
around the desired IO length. They only serve to make the code
shouty loud, don't actually add any real value, and are often used
incorrectly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_buf.c         |   26 +++++++++++++-------------
 fs/xfs/xfs_buf.h         |    4 +---
 fs/xfs/xfs_buf_item.c    |   15 ++++++++-------
 fs/xfs/xfs_da_btree.c    |   16 ++++++++--------
 fs/xfs/xfs_log.c         |    2 +-
 fs/xfs/xfs_log_recover.c |   15 ++++++++-------
 fs/xfs/xfs_trans_buf.c   |    4 ++--
 7 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 088b4f0..b508eaf 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -192,12 +192,12 @@ xfs_buf_alloc(
 	bp->b_target = target;
 
 	/*
-	 * Set length and count_desired to the same value initially.
-	 * I/O routines should use count_desired, which will be the same in
+	 * Set length and io_length to the same value initially.
+	 * I/O routines should use io_length, which will be the same in
 	 * most cases but may be reset (e.g. XFS recovery).
 	 */
 	bp->b_length = numblks;
-	bp->b_count_desired = numblks << BBSHIFT;
+	bp->b_io_length = numblks;
 	bp->b_flags = flags;
 
 	/*
@@ -296,7 +296,7 @@ xfs_buf_allocate_memory(
 	xfs_buf_t		*bp,
 	uint			flags)
 {
-	size_t			size = bp->b_count_desired;
+	size_t			size;
 	size_t			nbytes, offset;
 	gfp_t			gfp_mask = xb_to_gfp(flags);
 	unsigned short		page_count, i;
@@ -339,6 +339,7 @@ use_alloc_page:
 		return error;
 
 	offset = bp->b_offset;
+	size = BBTOB(bp->b_length);
 	bp->b_flags |= _XBF_PAGES;
 
 	for (i = 0; i < bp->b_page_count; i++) {
@@ -569,7 +570,7 @@ xfs_buf_get(
 	 * that we can do IO on it.
 	 */
 	bp->b_bn = blkno;
-	bp->b_count_desired = BBTOB(bp->b_length);
+	bp->b_io_length = bp->b_length;
 
 found:
 	if (!(bp->b_flags & XBF_MAPPED)) {
@@ -712,7 +713,7 @@ xfs_buf_set_empty(
 	bp->b_page_count = 0;
 	bp->b_addr = NULL;
 	bp->b_length = numblks;
-	bp->b_count_desired = numblks << BBSHIFT;
+	bp->b_io_length = numblks;
 	bp->b_bn = XFS_BUF_DADDR_NULL;
 	bp->b_flags &= ~XBF_MAPPED;
 }
@@ -764,7 +765,7 @@ xfs_buf_associate_memory(
 		pageaddr += PAGE_SIZE;
 	}
 
-	bp->b_count_desired = len;
+	bp->b_io_length = BTOBB(len);
 	bp->b_length = BTOBB(buflen);
 	bp->b_flags |= XBF_MAPPED;
 
@@ -1006,9 +1007,8 @@ xfs_buf_ioerror_alert(
 	const char		*func)
 {
 	xfs_alert(bp->b_target->bt_mount,
-"metadata I/O error: block 0x%llx (\"%s\") error %d buf count %zd",
-		(__uint64_t)XFS_BUF_ADDR(bp), func,
-		bp->b_error, XFS_BUF_COUNT(bp));
+"metadata I/O error: block 0x%llx (\"%s\") error %d numblks %d",
+		(__uint64_t)XFS_BUF_ADDR(bp), func, bp->b_error, bp->b_length);
 }
 
 int
@@ -1180,7 +1180,7 @@ _xfs_buf_ioapply(
 	int			rw, map_i, total_nr_pages, nr_pages;
 	struct bio		*bio;
 	int			offset = bp->b_offset;
-	int			size = bp->b_count_desired;
+	int			size = BBTOB(bp->b_io_length);
 	sector_t		sector = bp->b_bn;
 
 	total_nr_pages = bp->b_page_count;
@@ -1228,7 +1228,7 @@ next_chunk:
 			break;
 
 		offset = 0;
-		sector += nbytes >> BBSHIFT;
+		sector += BTOBB(nbytes);
 		size -= nbytes;
 		total_nr_pages--;
 	}
@@ -1322,7 +1322,7 @@ xfs_buf_iomove(
 		page = bp->b_pages[xfs_buf_btoct(boff + bp->b_offset)];
 		cpoff = xfs_buf_poff(boff + bp->b_offset);
 		csize = min_t(size_t,
-			      PAGE_SIZE-cpoff, bp->b_count_desired-boff);
+			      PAGE_SIZE - cpoff, BBTOB(bp->b_io_length) - boff);
 
 		ASSERT(((csize + cpoff) <= PAGE_SIZE));
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 3dab208..9787645 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -128,7 +128,6 @@ typedef struct xfs_buf {
 	struct list_head	b_list;
 	struct xfs_perag	*b_pag;		/* contains rbtree root */
 	xfs_buftarg_t		*b_target;	/* buffer target (device) */
-	size_t			b_count_desired;/* desired transfer size */
 	void			*b_addr;	/* virtual address of buffer */
 	struct work_struct	b_iodone_work;
 	xfs_buf_iodone_t	b_iodone;	/* I/O completion function */
@@ -137,6 +136,7 @@ typedef struct xfs_buf {
 	struct xfs_trans	*b_transp;
 	struct page		**b_pages;	/* array of page pointers */
 	struct page		*b_page_array[XB_PAGES]; /* inline pages */
+	int			b_io_length;	/* IO size in BBs */
 	atomic_t		b_pin_count;	/* pin count */
 	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
 	unsigned int		b_page_count;	/* size of page array */
@@ -244,8 +244,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 
 #define XFS_BUF_ADDR(bp)		((bp)->b_bn)
 #define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_bn = (xfs_daddr_t)(bno))
-#define XFS_BUF_COUNT(bp)		((bp)->b_count_desired)
-#define XFS_BUF_SET_COUNT(bp, cnt)	((bp)->b_count_desired = (cnt))
 
 static inline void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
 {
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 7f0abea..a25206c 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -123,11 +123,11 @@ xfs_buf_item_log_check(
 	ASSERT(bip->bli_logged != NULL);
 
 	bp = bip->bli_buf;
-	ASSERT(XFS_BUF_COUNT(bp) > 0);
+	ASSERT(bp->b_length > 0);
 	ASSERT(bp->b_addr != NULL);
 	orig = bip->bli_orig;
 	buffer = bp->b_addr;
-	for (x = 0; x < XFS_BUF_COUNT(bp); x++) {
+	for (x = 0; x < BBTOB(bp->b_length); x++) {
 		if (orig[x] != buffer[x] && !btst(bip->bli_logged, x)) {
 			xfs_emerg(bp->b_mount,
 				"%s: bip %x buffer %x orig %x index %d",
@@ -657,7 +657,8 @@ xfs_buf_item_init(
 	 * truncate any pieces.  map_size is the size of the
 	 * bitmap needed to describe the chunks of the buffer.
 	 */
-	chunks = (int)((XFS_BUF_COUNT(bp) + (XFS_BLF_CHUNK - 1)) >> XFS_BLF_SHIFT);
+	chunks = (int)((BBTOB(bp->b_length) + (XFS_BLF_CHUNK - 1)) >>
+								XFS_BLF_SHIFT);
 	map_size = (int)((chunks + NBWORD) >> BIT_TO_WORD_SHIFT);
 
 	bip = (xfs_buf_log_item_t*)kmem_zone_zalloc(xfs_buf_item_zone,
@@ -667,7 +668,7 @@ xfs_buf_item_init(
 	xfs_buf_hold(bp);
 	bip->bli_format.blf_type = XFS_LI_BUF;
 	bip->bli_format.blf_blkno = (__int64_t)XFS_BUF_ADDR(bp);
-	bip->bli_format.blf_len = (ushort)BTOBB(XFS_BUF_COUNT(bp));
+	bip->bli_format.blf_len = (ushort)bp->b_length;
 	bip->bli_format.blf_map_size = map_size;
 
 #ifdef XFS_TRANS_DEBUG
@@ -679,9 +680,9 @@ xfs_buf_item_init(
 	 * the buffer to indicate which bytes the callers have asked
 	 * to have logged.
 	 */
-	bip->bli_orig = (char *)kmem_alloc(XFS_BUF_COUNT(bp), KM_SLEEP);
-	memcpy(bip->bli_orig, bp->b_addr, XFS_BUF_COUNT(bp));
-	bip->bli_logged = (char *)kmem_zalloc(XFS_BUF_COUNT(bp) / NBBY, KM_SLEEP);
+	bip->bli_orig = kmem_alloc(BBTOB(bp->b_length), KM_SLEEP);
+	memcpy(bip->bli_orig, bp->b_addr, BBTOB(bp->b_length));
+	bip->bli_logged = kmem_zalloc(BBTOB(bp->b_length) / NBBY, KM_SLEEP);
 #endif
 
 	/*
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 7f1a6f5..b8adc79 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -2277,20 +2277,20 @@ xfs_da_buf_make(int nbuf, xfs_buf_t **bps)
 	if (nbuf == 1) {
 		dabuf->nbuf = 1;
 		bp = bps[0];
-		dabuf->bbcount = (short)BTOBB(XFS_BUF_COUNT(bp));
+		dabuf->bbcount = bp->b_length;
 		dabuf->data = bp->b_addr;
 		dabuf->bps[0] = bp;
 	} else {
 		dabuf->nbuf = nbuf;
 		for (i = 0, dabuf->bbcount = 0; i < nbuf; i++) {
 			dabuf->bps[i] = bp = bps[i];
-			dabuf->bbcount += BTOBB(XFS_BUF_COUNT(bp));
+			dabuf->bbcount += bp->b_length;
 		}
 		dabuf->data = kmem_alloc(BBTOB(dabuf->bbcount), KM_SLEEP);
-		for (i = off = 0; i < nbuf; i++, off += XFS_BUF_COUNT(bp)) {
+		for (i = off = 0; i < nbuf; i++, off += BBTOB(bp->b_length)) {
 			bp = bps[i];
 			memcpy((char *)dabuf->data + off, bp->b_addr,
-				XFS_BUF_COUNT(bp));
+				BBTOB(bp->b_length));
 		}
 	}
 	return dabuf;
@@ -2310,10 +2310,10 @@ xfs_da_buf_clean(xfs_dabuf_t *dabuf)
 		ASSERT(dabuf->nbuf > 1);
 		dabuf->dirty = 0;
 		for (i = off = 0; i < dabuf->nbuf;
-				i++, off += XFS_BUF_COUNT(bp)) {
+				i++, off += BBTOB(bp->b_length)) {
 			bp = dabuf->bps[i];
 			memcpy(bp->b_addr, dabuf->data + off,
-						XFS_BUF_COUNT(bp));
+						BBTOB(bp->b_length));
 		}
 	}
 }
@@ -2356,10 +2356,10 @@ xfs_da_log_buf(xfs_trans_t *tp, xfs_dabuf_t *dabuf, uint first, uint last)
 	}
 	dabuf->dirty = 1;
 	ASSERT(first <= last);
-	for (i = off = 0; i < dabuf->nbuf; i++, off += XFS_BUF_COUNT(bp)) {
+	for (i = off = 0; i < dabuf->nbuf; i++, off += BBTOB(bp->b_length)) {
 		bp = dabuf->bps[i];
 		f = off;
-		l = f + XFS_BUF_COUNT(bp) - 1;
+		l = f + BBTOB(bp->b_length) - 1;
 		if (f < first)
 			f = first;
 		if (l > last)
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f9d8355..5e2aa52 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1487,7 +1487,7 @@ xlog_sync(xlog_t		*log,
 	} else {
 		iclog->ic_bwritecnt = 1;
 	}
-	XFS_BUF_SET_COUNT(bp, count);
+	bp->b_io_length = BTOBB(count);
 	bp->b_fspriv = iclog;
 	XFS_BUF_ZEROFLAGS(bp);
 	XFS_BUF_ASYNC(bp);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 15b7470..0872d71 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -178,7 +178,7 @@ xlog_bread_noalign(
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	XFS_BUF_READ(bp);
-	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
+	bp->b_io_length = nbblks;
 	bp->b_error = 0;
 
 	xfsbdstrat(log->l_mp, bp);
@@ -266,7 +266,7 @@ xlog_bwrite(
 	XFS_BUF_ZEROFLAGS(bp);
 	xfs_buf_hold(bp);
 	xfs_buf_lock(bp);
-	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
+	bp->b_io_length = nbblks;
 	bp->b_error = 0;
 
 	error = xfs_bwrite(bp);
@@ -1774,7 +1774,7 @@ xlog_recover_do_inode_buffer(
 
 	trace_xfs_log_recover_buf_inode_buf(mp->m_log, buf_f);
 
-	inodes_per_buf = XFS_BUF_COUNT(bp) >> mp->m_sb.sb_inodelog;
+	inodes_per_buf = BBTOB(bp->b_io_length) >> mp->m_sb.sb_inodelog;
 	for (i = 0; i < inodes_per_buf; i++) {
 		next_unlinked_offset = (i * mp->m_sb.sb_inodesize) +
 			offsetof(xfs_dinode_t, di_next_unlinked);
@@ -1816,7 +1816,8 @@ xlog_recover_do_inode_buffer(
 
 		ASSERT(item->ri_buf[item_index].i_addr != NULL);
 		ASSERT((item->ri_buf[item_index].i_len % XFS_BLF_CHUNK) == 0);
-		ASSERT((reg_buf_offset + reg_buf_bytes) <= XFS_BUF_COUNT(bp));
+		ASSERT((reg_buf_offset + reg_buf_bytes) <=
+							BBTOB(bp->b_io_length));
 
 		/*
 		 * The current logged region contains a copy of the
@@ -1875,8 +1876,8 @@ xlog_recover_do_reg_buffer(
 		ASSERT(nbits > 0);
 		ASSERT(item->ri_buf[i].i_addr != NULL);
 		ASSERT(item->ri_buf[i].i_len % XFS_BLF_CHUNK == 0);
-		ASSERT(XFS_BUF_COUNT(bp) >=
-		       ((uint)bit << XFS_BLF_SHIFT)+(nbits<<XFS_BLF_SHIFT));
+		ASSERT(BBTOB(bp->b_io_length) >=
+		       ((uint)bit << XFS_BLF_SHIFT) + (nbits << XFS_BLF_SHIFT));
 
 		/*
 		 * Do a sanity check if this is a dquot buffer. Just checking
@@ -2169,7 +2170,7 @@ xlog_recover_buffer_pass2(
 	 */
 	if (XFS_DINODE_MAGIC ==
 	    be16_to_cpu(*((__be16 *)xfs_buf_offset(bp, 0))) &&
-	    (XFS_BUF_COUNT(bp) != MAX(log->l_mp->m_sb.sb_blocksize,
+	    (BBTOB(bp->b_io_length) != MAX(log->l_mp->m_sb.sb_blocksize,
 			(__uint32_t)XFS_INODE_CLUSTER_SIZE(log->l_mp)))) {
 		xfs_buf_stale(bp);
 		error = xfs_bwrite(bp);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 9132d16..2ec196b 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -56,7 +56,7 @@ xfs_trans_buf_item_match(
 		if (blip->bli_item.li_type == XFS_LI_BUF &&
 		    blip->bli_buf->b_target == target &&
 		    XFS_BUF_ADDR(blip->bli_buf) == blkno &&
-		    XFS_BUF_COUNT(blip->bli_buf) == len)
+		    BBTOB(blip->bli_buf->b_length) == len)
 			return blip->bli_buf;
 	}
 
@@ -585,7 +585,7 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
-	ASSERT((first <= last) && (last < XFS_BUF_COUNT(bp)));
+	ASSERT(first <= last && last < BBTOB(bp->b_length));
 	ASSERT(bp->b_iodone == NULL ||
 	       bp->b_iodone == xfs_buf_iodone_callbacks);
 
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
