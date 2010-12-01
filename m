Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB1M5RAC236334 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 16:05:29 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9F824F05FE
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 14:07:11 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id UinowJwox2Ql2NWa for
	<xfs@oss.sgi.com>; Wed, 01 Dec 2010 14:07:11 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PNupS-0007mj-2r
	for xfs@oss.sgi.com; Wed, 01 Dec 2010 22:07:10 +0000
Message-Id: <20101201220710.042656730@bombadil.infradead.org>
Date: Wed, 01 Dec 2010 17:06:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/4] xfs: remove leftovers of old buffer log items in recovery
	code
References: <20101201220620.340188389@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-remove-blf_type-switches
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

XFS used to support different types of buffer log items long time ago.
Remove the switch statements checking the log item type in various
buffer recovery helpers that were left over from those days and the
rather useless xlog_recover_do_buffer_pass2 wrapper.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2010-11-29 15:06:43.921010269 +0100
+++ xfs/fs/xfs/xfs_log_recover.c	2010-11-29 16:33:20.495004054 +0100
@@ -1614,22 +1614,13 @@ xlog_recover_do_buffer_pass1(
 	xfs_buf_cancel_t	*nextp;
 	xfs_buf_cancel_t	*prevp;
 	xfs_buf_cancel_t	**bucket;
-	xfs_daddr_t		blkno = 0;
-	uint			len = 0;
-	ushort			flags = 0;
-
-	switch (buf_f->blf_type) {
-	case XFS_LI_BUF:
-		blkno = buf_f->blf_blkno;
-		len = buf_f->blf_len;
-		flags = buf_f->blf_flags;
-		break;
-	}
+	xfs_daddr_t		blkno = buf_f->blf_blkno;
+	uint			len = buf_f->blf_len;
 
 	/*
 	 * If this isn't a cancel buffer item, then just return.
 	 */
-	if (!(flags & XFS_BLF_CANCEL)) {
+	if (!(buf_f->blf_flags & XFS_BLF_CANCEL)) {
 		trace_xfs_log_recover_buf_not_cancel(log, buf_f);
 		return;
 	}
@@ -1767,77 +1758,38 @@ xlog_check_buffer_cancelled(
 	return 0;
 }
 
-STATIC int
-xlog_recover_do_buffer_pass2(
-	xlog_t			*log,
-	xfs_buf_log_format_t	*buf_f)
-{
-	xfs_daddr_t		blkno = 0;
-	ushort			flags = 0;
-	uint			len = 0;
-
-	switch (buf_f->blf_type) {
-	case XFS_LI_BUF:
-		blkno = buf_f->blf_blkno;
-		flags = buf_f->blf_flags;
-		len = buf_f->blf_len;
-		break;
-	}
-
-	return xlog_check_buffer_cancelled(log, blkno, len, flags);
-}
-
 /*
- * Perform recovery for a buffer full of inodes.  In these buffers,
- * the only data which should be recovered is that which corresponds
- * to the di_next_unlinked pointers in the on disk inode structures.
- * The rest of the data for the inodes is always logged through the
- * inodes themselves rather than the inode buffer and is recovered
- * in xlog_recover_do_inode_trans().
+ * Perform recovery for a buffer full of inodes.  In these buffers, the only
+ * data which should be recovered is that which corresponds to the
+ * di_next_unlinked pointers in the on disk inode structures.  The rest of the
+ * data for the inodes is always logged through the inodes themselves rather
+ * than the inode buffer and is recovered in xlog_recover_inode_pass2().
  *
- * The only time when buffers full of inodes are fully recovered is
- * when the buffer is full of newly allocated inodes.  In this case
- * the buffer will not be marked as an inode buffer and so will be
- * sent to xlog_recover_do_reg_buffer() below during recovery.
+ * The only time when buffers full of inodes are fully recovered is when the
+ * buffer is full of newly allocated inodes.  In this case the buffer will
+ * not be marked as an inode buffer and so will be sent to
+ * xlog_recover_do_reg_buffer() below during recovery.
  */
 STATIC int
 xlog_recover_do_inode_buffer(
-	xfs_mount_t		*mp,
+	struct xfs_mount	*mp,
 	xlog_recover_item_t	*item,
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	xfs_buf_log_format_t	*buf_f)
 {
 	int			i;
-	int			item_index;
-	int			bit;
-	int			nbits;
-	int			reg_buf_offset;
-	int			reg_buf_bytes;
+	int			item_index = 0;
+	int			bit = 0;
+	int			nbits = 0;
+	int			reg_buf_offset = 0;
+	int			reg_buf_bytes = 0;
 	int			next_unlinked_offset;
 	int			inodes_per_buf;
 	xfs_agino_t		*logged_nextp;
 	xfs_agino_t		*buffer_nextp;
-	unsigned int		*data_map = NULL;
-	unsigned int		map_size = 0;
 
 	trace_xfs_log_recover_buf_inode_buf(mp->m_log, buf_f);
 
-	switch (buf_f->blf_type) {
-	case XFS_LI_BUF:
-		data_map = buf_f->blf_data_map;
-		map_size = buf_f->blf_map_size;
-		break;
-	}
-	/*
-	 * Set the variables corresponding to the current region to
-	 * 0 so that we'll initialize them on the first pass through
-	 * the loop.
-	 */
-	reg_buf_offset = 0;
-	reg_buf_bytes = 0;
-	bit = 0;
-	nbits = 0;
-	item_index = 0;
 	inodes_per_buf = XFS_BUF_COUNT(bp) >> mp->m_sb.sb_inodelog;
 	for (i = 0; i < inodes_per_buf; i++) {
 		next_unlinked_offset = (i * mp->m_sb.sb_inodesize) +
@@ -1852,18 +1804,18 @@ xlog_recover_do_inode_buffer(
 			 * the current di_next_unlinked field.
 			 */
 			bit += nbits;
-			bit = xfs_next_bit(data_map, map_size, bit);
+			bit = xfs_next_bit(buf_f->blf_data_map,
+					   buf_f->blf_map_size, bit);
 
 			/*
 			 * If there are no more logged regions in the
 			 * buffer, then we're done.
 			 */
-			if (bit == -1) {
+			if (bit == -1)
 				return 0;
-			}
 
-			nbits = xfs_contig_bits(data_map, map_size,
-							 bit);
+			nbits = xfs_contig_bits(buf_f->blf_data_map,
+						buf_f->blf_map_size, bit);
 			ASSERT(nbits > 0);
 			reg_buf_offset = bit << XFS_BLF_SHIFT;
 			reg_buf_bytes = nbits << XFS_BLF_SHIFT;
@@ -1875,9 +1827,8 @@ xlog_recover_do_inode_buffer(
 		 * di_next_unlinked field, then move on to the next
 		 * di_next_unlinked field.
 		 */
-		if (next_unlinked_offset < reg_buf_offset) {
+		if (next_unlinked_offset < reg_buf_offset)
 			continue;
-		}
 
 		ASSERT(item->ri_buf[item_index].i_addr != NULL);
 		ASSERT((item->ri_buf[item_index].i_len % XFS_BLF_CHUNK) == 0);
@@ -1913,36 +1864,29 @@ xlog_recover_do_inode_buffer(
  * given buffer.  The bitmap in the buf log format structure indicates
  * where to place the logged data.
  */
-/*ARGSUSED*/
 STATIC void
 xlog_recover_do_reg_buffer(
 	struct xfs_mount	*mp,
 	xlog_recover_item_t	*item,
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	xfs_buf_log_format_t	*buf_f)
 {
 	int			i;
 	int			bit;
 	int			nbits;
-	unsigned int		*data_map = NULL;
-	unsigned int		map_size = 0;
 	int                     error;
 
 	trace_xfs_log_recover_buf_reg_buf(mp->m_log, buf_f);
 
-	switch (buf_f->blf_type) {
-	case XFS_LI_BUF:
-		data_map = buf_f->blf_data_map;
-		map_size = buf_f->blf_map_size;
-		break;
-	}
 	bit = 0;
 	i = 1;  /* 0 is the buf format structure */
 	while (1) {
-		bit = xfs_next_bit(data_map, map_size, bit);
+		bit = xfs_next_bit(buf_f->blf_data_map,
+				   buf_f->blf_map_size, bit);
 		if (bit == -1)
 			break;
-		nbits = xfs_contig_bits(data_map, map_size, bit);
+		nbits = xfs_contig_bits(buf_f->blf_data_map,
+					buf_f->blf_map_size, bit);
 		ASSERT(nbits > 0);
 		ASSERT(item->ri_buf[i].i_addr != NULL);
 		ASSERT(item->ri_buf[i].i_len % XFS_BLF_CHUNK == 0);
@@ -2182,13 +2126,9 @@ xlog_recover_do_buffer_trans(
 	int			pass)
 {
 	xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
-	xfs_mount_t		*mp;
+	xfs_mount_t		*mp = log->l_mp;
 	xfs_buf_t		*bp;
 	int			error;
-	int			cancel;
-	xfs_daddr_t		blkno;
-	int			len;
-	ushort			flags;
 	uint			buf_flags;
 
 	if (pass == XLOG_RECOVER_PASS1) {
@@ -2206,47 +2146,32 @@ xlog_recover_do_buffer_trans(
 		 * we call here will tell us whether or not to
 		 * continue with the replay of this buffer.
 		 */
-		cancel = xlog_recover_do_buffer_pass2(log, buf_f);
-		if (cancel) {
+		if (xlog_check_buffer_cancelled(log, buf_f->blf_blkno,
+				buf_f->blf_len, buf_f->blf_flags)) {
 			trace_xfs_log_recover_buf_cancel(log, buf_f);
 			return 0;
 		}
 	}
 	trace_xfs_log_recover_buf_recover(log, buf_f);
-	switch (buf_f->blf_type) {
-	case XFS_LI_BUF:
-		blkno = buf_f->blf_blkno;
-		len = buf_f->blf_len;
-		flags = buf_f->blf_flags;
-		break;
-	default:
-		xfs_fs_cmn_err(CE_ALERT, log->l_mp,
-			"xfs_log_recover: unknown buffer type 0x%x, logdev %s",
-			buf_f->blf_type, log->l_mp->m_logname ?
-			log->l_mp->m_logname : "internal");
-		XFS_ERROR_REPORT("xlog_recover_do_buffer_trans",
-				 XFS_ERRLEVEL_LOW, log->l_mp);
-		return XFS_ERROR(EFSCORRUPTED);
-	}
 
-	mp = log->l_mp;
 	buf_flags = XBF_LOCK;
-	if (!(flags & XFS_BLF_INODE_BUF))
+	if (!(buf_f->blf_flags & XFS_BLF_INODE_BUF))
 		buf_flags |= XBF_MAPPED;
 
-	bp = xfs_buf_read(mp->m_ddev_targp, blkno, len, buf_flags);
+	bp = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
+			  buf_flags);
 	if (XFS_BUF_ISERROR(bp)) {
-		xfs_ioerror_alert("xlog_recover_do..(read#1)", log->l_mp,
-				  bp, blkno);
+		xfs_ioerror_alert("xlog_recover_do..(read#1)", mp,
+				  bp, buf_f->blf_blkno);
 		error = XFS_BUF_GETERROR(bp);
 		xfs_buf_relse(bp);
 		return error;
 	}
 
 	error = 0;
-	if (flags & XFS_BLF_INODE_BUF) {
+	if (buf_f->blf_flags & XFS_BLF_INODE_BUF) {
 		error = xlog_recover_do_inode_buffer(mp, item, bp, buf_f);
-	} else if (flags &
+	} else if (buf_f->blf_flags &
 		  (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
 		xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
 	} else {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
