Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3N5xqZ0127727 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 00:59:52 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	QsVokDqBAD15Jdze for <xfs@oss.sgi.com>;
	Sun, 22 Apr 2012 22:59:50 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMCJP-0001bg-B6
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:47 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMCJP-0004ZE-85
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 37/37] xfs: make XBF_MAPPED the default behaviour
Date: Mon, 23 Apr 2012 15:59:07 +1000
Message-Id: <1335160747-17254-38-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-1-git-send-email-david@fromorbit.com>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
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

Rather than specifying XBF_MAPPED for almost all buffers, introduce
XBF_UNMAPPED for the couple of users that use unmapped buffers.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c         |   28 +++++++++++++---------------
 fs/xfs/xfs_buf.h         |    4 ++--
 fs/xfs/xfs_fsops.c       |   10 +++++-----
 fs/xfs/xfs_inode.c       |    1 +
 fs/xfs/xfs_log_recover.c |    4 ++--
 fs/xfs/xfs_trans_buf.c   |    6 ------
 fs/xfs/xfs_vnodeops.c    |    3 +--
 7 files changed, 24 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index b2795ba..172d3cc 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -65,11 +65,11 @@ xfs_buf_is_vmapped(
 	/*
 	 * Return true if the buffer is vmapped.
 	 *
-	 * The XBF_MAPPED flag is set if the buffer should be mapped, but the
-	 * code is clever enough to know it doesn't have to map a single page,
-	 * so the check has to be both for XBF_MAPPED and bp->b_page_count > 1.
+	 * b_addr is null if the buffer is not mapped, but the code is clever
+	 * enough to know it doesn't have to map a single page, so the check has
+	 * to be both for b_addr and bp->b_page_count > 1.
 	 */
-	return (bp->b_flags & XBF_MAPPED) && bp->b_page_count > 1;
+	return bp->b_addr && bp->b_page_count > 1;
 }
 
 static inline int
@@ -181,7 +181,7 @@ xfs_buf_alloc(
 	 * We don't want certain flags to appear in b_flags unless they are
 	 * specifically set by later operations on the buffer.
 	 */
-	flags &= ~(XBF_MAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
+	flags &= ~(XBF_UNMAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
 
 	atomic_set(&bp->b_hold, 1);
 	atomic_set(&bp->b_lru_ref, 1);
@@ -329,7 +329,7 @@ xfs_buf_allocate_memory(
 		bp->b_pages = bp->b_page_array;
 		bp->b_pages[0] = virt_to_page(bp->b_addr);
 		bp->b_page_count = 1;
-		bp->b_flags |= XBF_MAPPED | _XBF_KMEM;
+		bp->b_flags |= _XBF_KMEM;
 		return 0;
 	}
 
@@ -399,8 +399,9 @@ _xfs_buf_map_pages(
 	if (bp->b_page_count == 1) {
 		/* A single page buffer is always mappable */
 		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
-		bp->b_flags |= XBF_MAPPED;
-	} else if (flags & XBF_MAPPED) {
+	} else if (flags & XBF_UNMAPPED) {
+		bp->b_addr = NULL;
+	} else {
 		int retried = 0;
 
 		do {
@@ -414,7 +415,6 @@ _xfs_buf_map_pages(
 		if (!bp->b_addr)
 			return -ENOMEM;
 		bp->b_addr += bp->b_offset;
-		bp->b_flags |= XBF_MAPPED;
 	}
 
 	return 0;
@@ -520,7 +520,7 @@ found:
 	 */
 	if (bp->b_flags & XBF_STALE) {
 		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
-		bp->b_flags &= XBF_MAPPED | _XBF_KMEM | _XBF_PAGES;
+		bp->b_flags &= _XBF_KMEM | _XBF_PAGES;
 	}
 
 	trace_xfs_buf_find(bp, flags, _RET_IP_);
@@ -575,7 +575,7 @@ xfs_buf_get(
 	bp->b_io_length = bp->b_length;
 
 found:
-	if (!(bp->b_flags & XBF_MAPPED)) {
+	if (!bp->b_addr) {
 		error = _xfs_buf_map_pages(bp, flags);
 		if (unlikely(error)) {
 			xfs_warn(target->bt_mount,
@@ -707,7 +707,6 @@ xfs_buf_set_empty(
 	bp->b_length = numblks;
 	bp->b_io_length = numblks;
 	bp->b_bn = XFS_BUF_DADDR_NULL;
-	bp->b_flags &= ~XBF_MAPPED;
 }
 
 static inline struct page *
@@ -759,7 +758,6 @@ xfs_buf_associate_memory(
 
 	bp->b_io_length = BTOBB(len);
 	bp->b_length = BTOBB(buflen);
-	bp->b_flags |= XBF_MAPPED;
 
 	return 0;
 }
@@ -790,7 +788,7 @@ xfs_buf_get_uncached(
 	}
 	bp->b_flags |= _XBF_PAGES;
 
-	error = _xfs_buf_map_pages(bp, XBF_MAPPED);
+	error = _xfs_buf_map_pages(bp, 0);
 	if (unlikely(error)) {
 		xfs_warn(target->bt_mount,
 			"%s: failed to map pages\n", __func__);
@@ -1287,7 +1285,7 @@ xfs_buf_offset(
 {
 	struct page		*page;
 
-	if (bp->b_flags & XBF_MAPPED)
+	if (bp->b_addr)
 		return bp->b_addr + offset;
 
 	offset += bp->b_offset;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 846dee3..7f1d139 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -41,7 +41,6 @@ typedef enum {
 #define XBF_READ	(1 << 0) /* buffer intended for reading from device */
 #define XBF_WRITE	(1 << 1) /* buffer intended for writing to device */
 #define XBF_READ_AHEAD	(1 << 2) /* asynchronous read-ahead */
-#define XBF_MAPPED	(1 << 3) /* buffer mapped (b_addr valid) */
 #define XBF_ASYNC	(1 << 4) /* initiator will not wait for completion */
 #define XBF_DONE	(1 << 5) /* all pages in the buffer uptodate */
 #define XBF_STALE	(1 << 6) /* buffer has been staled, do not find it */
@@ -53,6 +52,7 @@ typedef enum {
 
 /* flags used only as arguments to access routines */
 #define XBF_TRYLOCK	(1 << 16)/* lock requested, but do not wait */
+#define XBF_UNMAPPED	(1 << 17)/* do not map the buffer */
 
 /* flags used only internally */
 #define _XBF_PAGES	(1 << 20)/* backed by refcounted pages */
@@ -65,7 +65,6 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_READ,		"READ" }, \
 	{ XBF_WRITE,		"WRITE" }, \
 	{ XBF_READ_AHEAD,	"READ_AHEAD" }, \
-	{ XBF_MAPPED,		"MAPPED" }, \
 	{ XBF_ASYNC,		"ASYNC" }, \
 	{ XBF_DONE,		"DONE" }, \
 	{ XBF_STALE,		"STALE" }, \
@@ -73,6 +72,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_FUA,		"FUA" }, \
 	{ XBF_FLUSH,		"FLUSH" }, \
 	{ XBF_TRYLOCK,		"TRYLOCK" }, 	/* should never be set */\
+	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 75593d9..c25b094 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -190,7 +190,7 @@ xfs_growfs_data_private(
 		 */
 		bp = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-				 XFS_FSS_TO_BB(mp, 1), XBF_MAPPED);
+				 XFS_FSS_TO_BB(mp, 1), 0);
 		if (!bp) {
 			error = ENOMEM;
 			goto error0;
@@ -227,7 +227,7 @@ xfs_growfs_data_private(
 		 */
 		bp = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-				 XFS_FSS_TO_BB(mp, 1), XBF_MAPPED);
+				 XFS_FSS_TO_BB(mp, 1), 0);
 		if (!bp) {
 			error = ENOMEM;
 			goto error0;
@@ -256,7 +256,7 @@ xfs_growfs_data_private(
 		 */
 		bp = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AGB_TO_DADDR(mp, agno, XFS_BNO_BLOCK(mp)),
-				 BTOBB(mp->m_sb.sb_blocksize), XBF_MAPPED);
+				 BTOBB(mp->m_sb.sb_blocksize), 0);
 		if (!bp) {
 			error = ENOMEM;
 			goto error0;
@@ -282,7 +282,7 @@ xfs_growfs_data_private(
 		 */
 		bp = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AGB_TO_DADDR(mp, agno, XFS_CNT_BLOCK(mp)),
-				 BTOBB(mp->m_sb.sb_blocksize), XBF_MAPPED);
+				 BTOBB(mp->m_sb.sb_blocksize), 0);
 		if (!bp) {
 			error = ENOMEM;
 			goto error0;
@@ -309,7 +309,7 @@ xfs_growfs_data_private(
 		 */
 		bp = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AGB_TO_DADDR(mp, agno, XFS_IBT_BLOCK(mp)),
-				 BTOBB(mp->m_sb.sb_blocksize), XBF_MAPPED);
+				 BTOBB(mp->m_sb.sb_blocksize), 0);
 		if (!bp) {
 			error = ENOMEM;
 			goto error0;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 72ec1a4..a59eea0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -150,6 +150,7 @@ xfs_imap_to_bp(
 	int		ni;
 	xfs_buf_t	*bp;
 
+	buf_flags |= XBF_UNMAPPED;
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
 				   (int)imap->im_len, buf_flags, &bp);
 	if (error) {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 574e2e9..d7abe5f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2127,8 +2127,8 @@ xlog_recover_buffer_pass2(
 	trace_xfs_log_recover_buf_recover(log, buf_f);
 
 	buf_flags = 0;
-	if (!(buf_f->blf_flags & XFS_BLF_INODE_BUF))
-		buf_flags |= XBF_MAPPED;
+	if (buf_f->blf_flags & XFS_BLF_INODE_BUF)
+		buf_flags |= XBF_UNMAPPED;
 
 	bp = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
 			  buf_flags);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index d250afa..21c5a5e 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -138,9 +138,6 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 	xfs_buf_t		*bp;
 	xfs_buf_log_item_t	*bip;
 
-	if (flags == 0)
-		flags = XBF_MAPPED;
-
 	/*
 	 * Default to a normal get_buf() call if the tp is NULL.
 	 */
@@ -264,9 +261,6 @@ xfs_trans_read_buf(
 
 	*bpp = NULL;
 
-	if (flags == 0)
-		flags = XBF_MAPPED;
-
 	/*
 	 * Default to a normal get_buf() call if the tp is NULL.
 	 */
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 5b3f5b1..82b000f 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -79,8 +79,7 @@ xfs_readlink_bmap(
 		d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
 		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
 
-		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt),
-				  XBF_MAPPED);
+		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0);
 		if (!bp)
 			return XFS_ERROR(ENOMEM);
 		error = bp->b_error;
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
