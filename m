Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TCONiM092103 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 07:24:23 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	gcwjdBvkM7mL9MxH for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 05:24:21 -0700 (PDT)
Received: from [192.168.1.2] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SDEOj-0003fH-KG
	for xfs@oss.sgi.com; Thu, 29 Mar 2012 23:24:13 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SDEOT-0003Nb-Mn
	for xfs@oss.sgi.com; Thu, 29 Mar 2012 23:23:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/8] xfs: clean up buffer get/read call API
Date: Thu, 29 Mar 2012 23:23:51 +1100
Message-Id: <1333023835-12856-5-git-send-email-david@fromorbit.com>
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

The xfs_buf_get/read API is not consistent in the units it uses, and
does not use appropriate or consistent units/types for the
variables.

Convert the API to use disk addresses and block counts for all
buffer get and read calls. Use consistent naming for all the
functions and their declarations, and convert the internal functions
to use disk addresses and block counts to avoid need to convert them
from one type to another and back again.

Fix all the callers to use disk addresses and block counts. In many
cases, this removes an additional conversion from the function call
as the callers already have a block count.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c         |   86 ++++++++++++++++++++++++---------------------
 fs/xfs/xfs_buf.h         |   38 +++++++++++---------
 fs/xfs/xfs_fsops.c       |    4 +-
 fs/xfs/xfs_log.c         |    6 ++--
 fs/xfs/xfs_log_recover.c |    2 +-
 fs/xfs/xfs_mount.c       |   12 +++---
 fs/xfs/xfs_rtalloc.c     |    8 ++--
 fs/xfs/xfs_vnodeops.c    |    2 +-
 8 files changed, 84 insertions(+), 74 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d1ba21d..5a61ddc 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -166,8 +166,8 @@ xfs_buf_stale(
 struct xfs_buf *
 xfs_buf_alloc(
 	struct xfs_buftarg	*target,
-	xfs_off_t		range_base,
-	size_t			range_length,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
 	xfs_buf_flags_t		flags)
 {
 	struct xfs_buf		*bp;
@@ -190,14 +190,21 @@ xfs_buf_alloc(
 	sema_init(&bp->b_sema, 0); /* held, no waiters */
 	XB_SET_OWNER(bp);
 	bp->b_target = target;
-	bp->b_file_offset = range_base;
+	bp->b_file_offset = blkno << BBSHIFT;
 	/*
 	 * Set buffer_length and count_desired to the same value initially.
 	 * I/O routines should use count_desired, which will be the same in
 	 * most cases but may be reset (e.g. XFS recovery).
 	 */
-	bp->b_buffer_length = bp->b_count_desired = range_length;
+	bp->b_buffer_length = bp->b_count_desired = numblks << BBSHIFT;
 	bp->b_flags = flags;
+
+	/*
+	 * We do not set the block number here in the buffer because we have not
+	 * finished initialising the buffer. We insert the buffer into the cache
+	 * in this state, so this ensures that we are unable to do IO on a
+	 * buffer that hasn't been fully initialised.
+	 */
 	bp->b_bn = XFS_BUF_DADDR_NULL;
 	atomic_set(&bp->b_pin_count, 0);
 	init_waitqueue_head(&bp->b_waiters);
@@ -420,30 +427,30 @@ _xfs_buf_map_pages(
  */
 xfs_buf_t *
 _xfs_buf_find(
-	xfs_buftarg_t		*btp,	/* block device target		*/
-	xfs_off_t		ioff,	/* starting offset of range	*/
-	size_t			isize,	/* length of range		*/
+	struct xfs_buftarg	*btp,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
 	xfs_buf_flags_t		flags,
 	xfs_buf_t		*new_bp)
 {
-	xfs_off_t		range_base;
-	size_t			range_length;
+	xfs_off_t		offset;
+	size_t			numbytes;
 	struct xfs_perag	*pag;
 	struct rb_node		**rbp;
 	struct rb_node		*parent;
 	xfs_buf_t		*bp;
 
-	range_base = (ioff << BBSHIFT);
-	range_length = (isize << BBSHIFT);
+	offset = blkno << BBSHIFT;
+	numbytes = numblks << BBSHIFT;
 
 	/* Check for IOs smaller than the sector size / not sector aligned */
-	ASSERT(!(range_length < (1 << btp->bt_sshift)));
-	ASSERT(!(range_base & (xfs_off_t)btp->bt_smask));
+	ASSERT(!(numbytes < (1 << btp->bt_sshift)));
+	ASSERT(!(offset & (xfs_off_t)btp->bt_smask));
 
 	/* get tree root */
 lookup_again:
 	pag = xfs_perag_get(btp->bt_mount,
-				xfs_daddr_to_agno(btp->bt_mount, ioff));
+				xfs_daddr_to_agno(btp->bt_mount, blkno));
 
 	/* walk tree */
 	spin_lock(&pag->pag_buf_lock);
@@ -454,9 +461,9 @@ lookup_again:
 		parent = *rbp;
 		bp = rb_entry(parent, struct xfs_buf, b_rbnode);
 
-		if (range_base < bp->b_file_offset)
+		if (offset < bp->b_file_offset)
 			rbp = &(*rbp)->rb_left;
-		else if (range_base > bp->b_file_offset)
+		else if (offset > bp->b_file_offset)
 			rbp = &(*rbp)->rb_right;
 		else {
 			/*
@@ -467,7 +474,7 @@ lookup_again:
 			 * reallocating a busy extent. Skip this buffer and
 			 * continue searching to the right for an exact match.
 			 */
-			if (bp->b_buffer_length != range_length) {
+			if (bp->b_buffer_length != numbytes) {
 				ASSERT(bp->b_flags & XBF_STALE);
 				rbp = &(*rbp)->rb_right;
 				continue;
@@ -545,25 +552,24 @@ found:
  */
 struct xfs_buf *
 xfs_buf_get(
-	xfs_buftarg_t		*target,/* target for buffer		*/
-	xfs_off_t		ioff,	/* starting offset of range	*/
-	size_t			isize,	/* length of range		*/
+	xfs_buftarg_t		*target,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
 	xfs_buf_flags_t		flags)
 {
 	struct xfs_buf		*bp;
 	struct xfs_buf		*new_bp;
 	int			error = 0;
 
-	bp = _xfs_buf_find(target, ioff, isize, flags, NULL);
+	bp = _xfs_buf_find(target, blkno, numblks, flags, NULL);
 	if (likely(bp))
 		goto found;
 
-	new_bp = xfs_buf_alloc(target, ioff << BBSHIFT, isize << BBSHIFT,
-			       flags);
+	new_bp = xfs_buf_alloc(target, blkno, numblks, flags);
 	if (unlikely(!new_bp))
 		return NULL;
 
-	bp = _xfs_buf_find(target, ioff, isize, flags, new_bp);
+	bp = _xfs_buf_find(target, blkno, numblks, flags, new_bp);
 	if (!bp) {
 		kmem_zone_free(xfs_buf_zone, new_bp);
 		return NULL;
@@ -592,7 +598,7 @@ xfs_buf_get(
 	 * Now we have a workable buffer, fill in the block number so
 	 * that we can do IO on it.
 	 */
-	bp->b_bn = ioff;
+	bp->b_bn = blkno;
 	bp->b_count_desired = bp->b_buffer_length;
 
 found:
@@ -636,15 +642,15 @@ _xfs_buf_read(
 xfs_buf_t *
 xfs_buf_read(
 	xfs_buftarg_t		*target,
-	xfs_off_t		ioff,
-	size_t			isize,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
 	xfs_buf_flags_t		flags)
 {
 	xfs_buf_t		*bp;
 
 	flags |= XBF_READ;
 
-	bp = xfs_buf_get(target, ioff, isize, flags);
+	bp = xfs_buf_get(target, blkno, numblks, flags);
 	if (bp) {
 		trace_xfs_buf_read(bp, flags, _RET_IP_);
 
@@ -679,13 +685,13 @@ xfs_buf_read(
 void
 xfs_buf_readahead(
 	xfs_buftarg_t		*target,
-	xfs_off_t		ioff,
-	size_t			isize)
+	xfs_daddr_t		blkno,
+	size_t			numblks)
 {
 	if (bdi_read_congested(target->bt_bdi))
 		return;
 
-	xfs_buf_read(target, ioff, isize,
+	xfs_buf_read(target, blkno, numblks,
 		     XBF_TRYLOCK|XBF_ASYNC|XBF_READ_AHEAD|XBF_DONT_BLOCK);
 }
 
@@ -695,16 +701,15 @@ xfs_buf_readahead(
  */
 struct xfs_buf *
 xfs_buf_read_uncached(
-	struct xfs_mount	*mp,
 	struct xfs_buftarg	*target,
 	xfs_daddr_t		daddr,
-	size_t			length,
+	size_t			numblks,
 	int			flags)
 {
 	xfs_buf_t		*bp;
 	int			error;
 
-	bp = xfs_buf_get_uncached(target, length, flags);
+	bp = xfs_buf_get_uncached(target, numblks, flags);
 	if (!bp)
 		return NULL;
 
@@ -712,7 +717,7 @@ xfs_buf_read_uncached(
 	XFS_BUF_SET_ADDR(bp, daddr);
 	XFS_BUF_READ(bp);
 
-	xfsbdstrat(mp, bp);
+	xfsbdstrat(target->bt_mount, bp);
 	error = xfs_buf_iowait(bp);
 	if (error) {
 		xfs_buf_relse(bp);
@@ -728,7 +733,7 @@ xfs_buf_read_uncached(
 void
 xfs_buf_set_empty(
 	struct xfs_buf		*bp,
-	size_t			len)
+	size_t			numblks)
 {
 	if (bp->b_pages)
 		_xfs_buf_free_pages(bp);
@@ -737,7 +742,7 @@ xfs_buf_set_empty(
 	bp->b_page_count = 0;
 	bp->b_addr = NULL;
 	bp->b_file_offset = 0;
-	bp->b_buffer_length = bp->b_count_desired = len;
+	bp->b_buffer_length = bp->b_count_desired = numblks << BBSHIFT;
 	bp->b_bn = XFS_BUF_DADDR_NULL;
 	bp->b_flags &= ~XBF_MAPPED;
 }
@@ -799,17 +804,18 @@ xfs_buf_associate_memory(
 xfs_buf_t *
 xfs_buf_get_uncached(
 	struct xfs_buftarg	*target,
-	size_t			len,
+	size_t			numblks,
 	int			flags)
 {
-	unsigned long		page_count = PAGE_ALIGN(len) >> PAGE_SHIFT;
+	unsigned long		page_count;
 	int			error, i;
 	xfs_buf_t		*bp;
 
-	bp = xfs_buf_alloc(target, 0, len, 0);
+	bp = xfs_buf_alloc(target, 0, numblks, 0);
 	if (unlikely(bp == NULL))
 		goto fail;
 
+	page_count = PAGE_ALIGN(numblks << BBSHIFT) >> PAGE_SHIFT;
 	error = _xfs_buf_get_pages(bp, page_count, 0);
 	if (error)
 		goto fail_free_buf;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 664fb4e..43163bf 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -152,26 +152,30 @@ typedef struct xfs_buf {
 
 
 /* Finding and Reading Buffers */
-extern xfs_buf_t *_xfs_buf_find(xfs_buftarg_t *, xfs_off_t, size_t,
-				xfs_buf_flags_t, xfs_buf_t *);
+struct xfs_buf *_xfs_buf_find(struct xfs_buftarg *target, xfs_daddr_t blkno,
+				size_t numblks, xfs_buf_flags_t flags,
+				struct xfs_buf *new_bp);
 #define xfs_incore(buftarg,blkno,len,lockit) \
 	_xfs_buf_find(buftarg, blkno ,len, lockit, NULL)
 
-extern xfs_buf_t *xfs_buf_get(xfs_buftarg_t *, xfs_off_t, size_t,
-				xfs_buf_flags_t);
-extern xfs_buf_t *xfs_buf_read(xfs_buftarg_t *, xfs_off_t, size_t,
-				xfs_buf_flags_t);
-
-struct xfs_buf *xfs_buf_alloc(struct xfs_buftarg *, xfs_off_t, size_t,
-			      xfs_buf_flags_t);
-extern void xfs_buf_set_empty(struct xfs_buf *bp, size_t len);
-extern xfs_buf_t *xfs_buf_get_uncached(struct xfs_buftarg *, size_t, int);
-extern int xfs_buf_associate_memory(xfs_buf_t *, void *, size_t);
-extern void xfs_buf_hold(xfs_buf_t *);
-extern void xfs_buf_readahead(xfs_buftarg_t *, xfs_off_t, size_t);
-struct xfs_buf *xfs_buf_read_uncached(struct xfs_mount *mp,
-				struct xfs_buftarg *target,
-				xfs_daddr_t daddr, size_t length, int flags);
+struct xfs_buf *xfs_buf_get(struct xfs_buftarg *target, xfs_daddr_t blkno,
+				size_t numblks, xfs_buf_flags_t flags);
+struct xfs_buf *xfs_buf_read(struct xfs_buftarg *target, xfs_daddr_t blkno,
+				size_t numblks, xfs_buf_flags_t flags);
+void xfs_buf_readahead(struct xfs_buftarg *target, xfs_daddr_t blkno,
+				size_t numblks);
+
+struct xfs_buf *xfs_buf_get_empty(struct xfs_buftarg *target, size_t numblks);
+struct xfs_buf *xfs_buf_alloc(struct xfs_buftarg *target, xfs_daddr_t blkno,
+				size_t numblks, xfs_buf_flags_t flags);
+void xfs_buf_set_empty(struct xfs_buf *bp, size_t numblks);
+int xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t length);
+
+struct xfs_buf *xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
+				int flags);
+struct xfs_buf *xfs_buf_read_uncached(struct xfs_buftarg *target,
+				xfs_daddr_t daddr, size_t numblks, int flags);
+void xfs_buf_hold(struct xfs_buf *bp);
 
 /* Releasing Buffers */
 extern void xfs_buf_free(xfs_buf_t *);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 1c6fdeb..019ba5c 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -147,9 +147,9 @@ xfs_growfs_data_private(
 	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
 		return error;
 	dpct = pct - mp->m_sb.sb_imax_pct;
-	bp = xfs_buf_read_uncached(mp, mp->m_ddev_targp,
+	bp = xfs_buf_read_uncached(mp->m_ddev_targp,
 				XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
-				BBTOB(XFS_FSS_TO_BB(mp, 1)), 0);
+				XFS_FSS_TO_BB(mp, 1), 0);
 	if (!bp)
 		return EIO;
 	xfs_buf_relse(bp);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 418d5d7..8990012 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1187,7 +1187,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	xlog_get_iclog_buffer_size(mp, log);
 
 	error = ENOMEM;
-	bp = xfs_buf_alloc(mp->m_logdev_targp, 0, log->l_iclog_size, 0);
+	bp = xfs_buf_alloc(mp->m_logdev_targp, 0, BTOBB(log->l_iclog_size), 0);
 	if (!bp)
 		goto out_free_log;
 	bp->b_iodone = xlog_iodone;
@@ -1219,7 +1219,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		prev_iclog = iclog;
 
 		bp = xfs_buf_get_uncached(mp->m_logdev_targp,
-						log->l_iclog_size, 0);
+						BTOBB(log->l_iclog_size), 0);
 		if (!bp)
 			goto out_free_iclog;
 
@@ -1588,7 +1588,7 @@ xlog_dealloc_log(xlog_t *log)
 	 * always need to ensure that the extra buffer does not point to memory
 	 * owned by another log buffer before we free it.
 	 */
-	xfs_buf_set_empty(log->l_xbuf, log->l_iclog_size);
+	xfs_buf_set_empty(log->l_xbuf, BTOBB(log->l_iclog_size));
 	xfs_buf_free(log->l_xbuf);
 
 	iclog = log->l_iclog;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 64ed6ff..d94ed40 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -120,7 +120,7 @@ xlog_get_bp(
 		nbblks += log->l_sectBBsize;
 	nbblks = round_up(nbblks, log->l_sectBBsize);
 
-	bp = xfs_buf_get_uncached(log->l_mp->m_logdev_targp, BBTOB(nbblks), 0);
+	bp = xfs_buf_get_uncached(log->l_mp->m_logdev_targp, nbblks, 0);
 	if (bp)
 		xfs_buf_unlock(bp);
 	return bp;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 385a3b1..89be5ff 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -684,8 +684,8 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 	sector_size = xfs_getsize_buftarg(mp->m_ddev_targp);
 
 reread:
-	bp = xfs_buf_read_uncached(mp, mp->m_ddev_targp,
-					XFS_SB_DADDR, sector_size, 0);
+	bp = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
+					BTOBB(sector_size), 0);
 	if (!bp) {
 		if (loud)
 			xfs_warn(mp, "SB buffer read failed");
@@ -1033,9 +1033,9 @@ xfs_check_sizes(xfs_mount_t *mp)
 		xfs_warn(mp, "filesystem size mismatch detected");
 		return XFS_ERROR(EFBIG);
 	}
-	bp = xfs_buf_read_uncached(mp, mp->m_ddev_targp,
+	bp = xfs_buf_read_uncached(mp->m_ddev_targp,
 					d - XFS_FSS_TO_BB(mp, 1),
-					BBTOB(XFS_FSS_TO_BB(mp, 1)), 0);
+					XFS_FSS_TO_BB(mp, 1), 0);
 	if (!bp) {
 		xfs_warn(mp, "last sector read failed");
 		return EIO;
@@ -1048,9 +1048,9 @@ xfs_check_sizes(xfs_mount_t *mp)
 			xfs_warn(mp, "log size mismatch detected");
 			return XFS_ERROR(EFBIG);
 		}
-		bp = xfs_buf_read_uncached(mp, mp->m_logdev_targp,
+		bp = xfs_buf_read_uncached(mp->m_logdev_targp,
 					d - XFS_FSB_TO_BB(mp, 1),
-					XFS_FSB_TO_B(mp, 1), 0);
+					XFS_FSB_TO_BB(mp, 1), 0);
 		if (!bp) {
 			xfs_warn(mp, "log device read failed");
 			return EIO;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index ca4f315..7434d3f 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1872,9 +1872,9 @@ xfs_growfs_rt(
 	/*
 	 * Read in the last block of the device, make sure it exists.
 	 */
-	bp = xfs_buf_read_uncached(mp, mp->m_rtdev_targp,
+	bp = xfs_buf_read_uncached(mp->m_rtdev_targp,
 				XFS_FSB_TO_BB(mp, nrblocks - 1),
-				XFS_FSB_TO_B(mp, 1), 0);
+				XFS_FSB_TO_BB(mp, 1), 0);
 	if (!bp)
 		return EIO;
 	xfs_buf_relse(bp);
@@ -2219,9 +2219,9 @@ xfs_rtmount_init(
 			(unsigned long long) mp->m_sb.sb_rblocks);
 		return XFS_ERROR(EFBIG);
 	}
-	bp = xfs_buf_read_uncached(mp, mp->m_rtdev_targp,
+	bp = xfs_buf_read_uncached(mp->m_rtdev_targp,
 					d - XFS_FSB_TO_BB(mp, 1),
-					XFS_FSB_TO_B(mp, 1), 0);
+					XFS_FSB_TO_BB(mp, 1), 0);
 	if (!bp) {
 		xfs_warn(mp, "realtime device size check failed");
 		return EIO;
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 64981d7..445c224 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1966,7 +1966,7 @@ xfs_zero_remaining_bytes(
 
 	bp = xfs_buf_get_uncached(XFS_IS_REALTIME_INODE(ip) ?
 					mp->m_rtdev_targp : mp->m_ddev_targp,
-				mp->m_sb.sb_blocksize, XBF_DONT_BLOCK);
+				BTOBB(mp->m_sb.sb_blocksize), XBF_DONT_BLOCK);
 	if (!bp)
 		return XFS_ERROR(ENOMEM);
 
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
