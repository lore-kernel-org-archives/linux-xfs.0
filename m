Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TCOQVl092200 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 07:24:26 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Qs5yCFIDcLvvMIqN for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 05:24:24 -0700 (PDT)
Received: from [192.168.1.2] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SDEOt-0003fa-O8
	for xfs@oss.sgi.com; Thu, 29 Mar 2012 23:24:23 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SDEOd-0003Nn-Qk
	for xfs@oss.sgi.com; Thu, 29 Mar 2012 23:24:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/8] xfs: kill xfs_buf_btoc
Date: Thu, 29 Mar 2012 23:23:55 +1100
Message-Id: <1333023835-12856-9-git-send-email-david@fromorbit.com>
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

xfs_buf_btoc and friends are simple macros that do basic block
to page index conversion and vice versa. These aren't widely used,
and we use open coded masking and shifting everywhere else. Hence
remove themacros and open code the work they do.

Also, use of PAGE_CACHE_{SIZE|SHIFT|MASK} for these macros is now
incorrect - we are using pages directly and not the page cache, so
use PAGE_{SIZE|MASK|SHIFT} instead.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c |   39 +++++++++++++++++++++------------------
 fs/xfs/xfs_buf.h |    5 -----
 2 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index aad217c..3dd0f4e 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -300,7 +300,7 @@ xfs_buf_allocate_memory(
 	size_t			nbytes, offset;
 	gfp_t			gfp_mask = xb_to_gfp(flags);
 	unsigned short		page_count, i;
-	xfs_off_t		end;
+	xfs_off_t		start, end;
 	int			error;
 
 	/*
@@ -308,15 +308,15 @@ xfs_buf_allocate_memory(
 	 * the memory from the heap - there's no need for the complexity of
 	 * page arrays to keep allocation down to order 0.
 	 */
-	if (bp->b_length < BTOBB(PAGE_SIZE)) {
-		bp->b_addr = kmem_alloc(BBTOB(bp->b_length), xb_to_km(flags));
+	size = BBTOB(bp->b_length);
+	if (size < PAGE_SIZE) {
+		bp->b_addr = kmem_alloc(size, xb_to_km(flags));
 		if (!bp->b_addr) {
 			/* low memory - use alloc_page loop instead */
 			goto use_alloc_page;
 		}
 
-		if (((unsigned long)(bp->b_addr + BBTOB(bp->b_length) - 1) &
-								PAGE_MASK) !=
+		if (((unsigned long)(bp->b_addr + size - 1) & PAGE_MASK) !=
 		    ((unsigned long)bp->b_addr & PAGE_MASK)) {
 			/* b_addr spans two pages - use alloc_page instead */
 			kmem_free(bp->b_addr);
@@ -332,14 +332,14 @@ xfs_buf_allocate_memory(
 	}
 
 use_alloc_page:
-	end = BBTOB(bp->b_bn + bp->b_length);
-	page_count = xfs_buf_btoc(end) - xfs_buf_btoct(BBTOB(bp->b_bn));
+	start = BBTOB(bp->b_bn) >> PAGE_SHIFT;
+	end = (BBTOB(bp->b_bn + bp->b_length) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	page_count = end - start;
 	error = _xfs_buf_get_pages(bp, page_count, flags);
 	if (unlikely(error))
 		return error;
 
 	offset = bp->b_offset;
-	size = BBTOB(bp->b_length);
 	bp->b_flags |= _XBF_PAGES;
 
 	for (i = 0; i < bp->b_page_count; i++) {
@@ -1343,27 +1343,30 @@ xfs_buf_iomove(
 	void			*data,	/* data address			*/
 	xfs_buf_rw_t		mode)	/* read/write/zero flag		*/
 {
-	size_t			bend, cpoff, csize;
-	struct page		*page;
+	size_t			bend;
 
 	bend = boff + bsize;
 	while (boff < bend) {
-		page = bp->b_pages[xfs_buf_btoct(boff + bp->b_offset)];
-		cpoff = xfs_buf_poff(boff + bp->b_offset);
-		csize = min_t(size_t,
-			      PAGE_SIZE - cpoff, BBTOB(bp->b_io_length) - boff);
+		struct page	*page;
+		int		page_index, page_offset, csize;
+
+		page_index = (boff + bp->b_offset) >> PAGE_SHIFT;
+		page_offset = (boff + bp->b_offset) & ~PAGE_MASK;
+		page = bp->b_pages[page_index];
+		csize = min_t(size_t, PAGE_SIZE - page_offset,
+				      BBTOB(bp->b_io_length) - boff);
 
-		ASSERT(((csize + cpoff) <= PAGE_SIZE));
+		ASSERT((csize + page_offset) <= PAGE_SIZE);
 
 		switch (mode) {
 		case XBRW_ZERO:
-			memset(page_address(page) + cpoff, 0, csize);
+			memset(page_address(page) + page_offset, 0, csize);
 			break;
 		case XBRW_READ:
-			memcpy(data, page_address(page) + cpoff, csize);
+			memcpy(data, page_address(page) + page_offset, csize);
 			break;
 		case XBRW_WRITE:
-			memcpy(page_address(page) + cpoff, data, csize);
+			memcpy(page_address(page) + page_offset, data, csize);
 		}
 
 		boff += csize;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 57d3e7a..a99d2c9 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -32,11 +32,6 @@
 
 #define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
 
-#define xfs_buf_ctob(pp)	((pp) * PAGE_CACHE_SIZE)
-#define xfs_buf_btoc(dd)	(((dd) + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT)
-#define xfs_buf_btoct(dd)	((dd) >> PAGE_CACHE_SHIFT)
-#define xfs_buf_poff(aa)	((aa) & ~PAGE_CACHE_MASK)
-
 typedef enum {
 	XBRW_READ = 1,			/* transfer into target memory */
 	XBRW_WRITE = 2,			/* transfer from target memory */
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
