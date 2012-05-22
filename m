Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4MKuOXZ252663 for <xfs@oss.sgi.com>; Tue, 22 May 2012 15:56:24 -0500
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 243A530404E
	for <xfs@oss.sgi.com>; Tue, 22 May 2012 13:56:21 -0700 (PDT)
Date: Tue, 22 May 2012 15:56:21 -0500
From: Alain Renaud <arenaud@sgi.com>
Subject: [PATCH] Prefix IO_XX flags with XFS_IO_XX to avoid namespace colision.
Message-ID: <4fbbfd75.nYwhMRRjLSAq0x8u%arenaud@sgi.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


 This mod simply add a XFS_ prefix to IO_DIRECT,XFS_IO_DELALLOC,
XFS_IO_UNWRITTEN and XFS_IO_OVERWRITE. This to avoid namespace conflict
with other modules.

Signed-off-by: Alain Renaud <arenaud@sgi.com>

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index ae31c31..7d3f6ab 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -179,7 +179,7 @@ xfs_finish_ioend(
 	if (atomic_dec_and_test(&ioend->io_remaining)) {
 		struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
 
-		if (ioend->io_type == IO_UNWRITTEN)
+		if (ioend->io_type == XFS_IO_UNWRITTEN)
 			queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
 		else if (ioend->io_append_trans)
 			queue_work(mp->m_data_workqueue, &ioend->io_work);
@@ -210,7 +210,7 @@ xfs_end_io(
 	 * For unwritten extents we need to issue transactions to convert a
 	 * range to normal written extens after the data I/O has finished.
 	 */
-	if (ioend->io_type == IO_UNWRITTEN) {
+	if (ioend->io_type == XFS_IO_UNWRITTEN) {
 		/*
 		 * For buffered I/O we never preallocate a transaction when
 		 * doing the unwritten extent conversion, but for direct I/O
@@ -312,7 +312,7 @@ xfs_map_blocks(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -XFS_ERROR(EIO);
 
-	if (type == IO_UNWRITTEN)
+	if (type == XFS_IO_UNWRITTEN)
 		bmapi_flags |= XFS_BMAPI_IGSTATE;
 
 	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
@@ -336,7 +336,7 @@ xfs_map_blocks(
 	if (error)
 		return -XFS_ERROR(error);
 
-	if (type == IO_DELALLOC &&
+	if (type == XFS_IO_DELALLOC &&
 	    (!nimaps || isnullstartblock(imap->br_startblock))) {
 		error = xfs_iomap_write_allocate(ip, offset, count, imap);
 		if (!error)
@@ -345,7 +345,7 @@ xfs_map_blocks(
 	}
 
 #ifdef DEBUG
-	if (type == IO_UNWRITTEN) {
+	if (type == XFS_IO_UNWRITTEN) {
 		ASSERT(nimaps);
 		ASSERT(imap->br_startblock != HOLESTARTBLOCK);
 		ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
@@ -634,11 +634,11 @@ xfs_check_page_type(
 		bh = head = page_buffers(page);
 		do {
 			if (buffer_unwritten(bh))
-				acceptable += (type == IO_UNWRITTEN);
+				acceptable += (type == XFS_IO_UNWRITTEN);
 			else if (buffer_delay(bh))
-				acceptable += (type == IO_DELALLOC);
+				acceptable += (type == XFS_IO_DELALLOC);
 			else if (buffer_dirty(bh) && buffer_mapped(bh))
-				acceptable += (type == IO_OVERWRITE);
+				acceptable += (type == XFS_IO_OVERWRITE);
 			else
 				break;
 		} while ((bh = bh->b_this_page) != head);
@@ -721,11 +721,11 @@ xfs_convert_page(
 		if (buffer_unwritten(bh) || buffer_delay(bh) ||
 		    buffer_mapped(bh)) {
 			if (buffer_unwritten(bh))
-				type = IO_UNWRITTEN;
+				type = XFS_IO_UNWRITTEN;
 			else if (buffer_delay(bh))
-				type = IO_DELALLOC;
+				type = XFS_IO_DELALLOC;
 			else
-				type = IO_OVERWRITE;
+				type = XFS_IO_OVERWRITE;
 
 			if (!xfs_imap_valid(inode, imap, offset)) {
 				done = 1;
@@ -733,7 +733,7 @@ xfs_convert_page(
 			}
 
 			lock_buffer(bh);
-			if (type != IO_OVERWRITE)
+			if (type != XFS_IO_OVERWRITE)
 				xfs_map_at_offset(inode, bh, imap, offset);
 			xfs_add_to_ioend(inode, bh, offset, type,
 					 ioendp, done);
@@ -831,7 +831,7 @@ xfs_aops_discard_page(
 	struct buffer_head	*bh, *head;
 	loff_t			offset = page_offset(page);
 
-	if (!xfs_check_page_type(page, IO_DELALLOC))
+	if (!xfs_check_page_type(page, XFS_IO_DELALLOC))
 		goto out_invalidate;
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
@@ -941,7 +941,7 @@ xfs_vm_writepage(
 
 	bh = head = page_buffers(page);
 	offset = page_offset(page);
-	type = IO_OVERWRITE;
+	type = XFS_IO_OVERWRITE;
 
 	if (wbc->sync_mode == WB_SYNC_NONE)
 		nonblocking = 1;
@@ -966,18 +966,18 @@ xfs_vm_writepage(
 		}
 
 		if (buffer_unwritten(bh)) {
-			if (type != IO_UNWRITTEN) {
-				type = IO_UNWRITTEN;
+			if (type != XFS_IO_UNWRITTEN) {
+				type = XFS_IO_UNWRITTEN;
 				imap_valid = 0;
 			}
 		} else if (buffer_delay(bh)) {
-			if (type != IO_DELALLOC) {
-				type = IO_DELALLOC;
+			if (type != XFS_IO_DELALLOC) {
+				type = XFS_IO_DELALLOC;
 				imap_valid = 0;
 			}
 		} else if (buffer_uptodate(bh)) {
-			if (type != IO_OVERWRITE) {
-				type = IO_OVERWRITE;
+			if (type != XFS_IO_OVERWRITE) {
+				type = XFS_IO_OVERWRITE;
 				imap_valid = 0;
 			}
 		} else {
@@ -1008,7 +1008,7 @@ xfs_vm_writepage(
 		}
 		if (imap_valid) {
 			lock_buffer(bh);
-			if (type != IO_OVERWRITE)
+			if (type != XFS_IO_OVERWRITE)
 				xfs_map_at_offset(inode, bh, &imap, offset);
 			xfs_add_to_ioend(inode, bh, offset, type, &ioend,
 					 new_ioend);
@@ -1049,7 +1049,7 @@ xfs_vm_writepage(
 		 * Reserve log space if we might write beyond the on-disk
 		 * inode size.
 		 */
-		if (ioend->io_type != IO_UNWRITTEN &&
+		if (ioend->io_type != XFS_IO_UNWRITTEN &&
 		    xfs_ioend_is_append(ioend)) {
 			err = xfs_setfilesize_trans_alloc(ioend);
 			if (err)
@@ -1346,7 +1346,7 @@ xfs_end_io_direct_write(
 	ioend->io_iocb = iocb;
 	ioend->io_result = ret;
 	if (private && size > 0)
-		ioend->io_type = IO_UNWRITTEN;
+		ioend->io_type = XFS_IO_UNWRITTEN;
 
 	if (is_async) {
 		ioend->io_isasync = 1;
@@ -1378,7 +1378,7 @@ xfs_vm_direct_IO(
 		 * and converts at least on unwritten extent we will cancel
 		 * the still clean transaction after the I/O has finished.
 		 */
-		iocb->private = ioend = xfs_alloc_ioend(inode, IO_DIRECT);
+		iocb->private = ioend = xfs_alloc_ioend(inode, XFS_IO_DIRECT);
 		if (offset + size > XFS_I(inode)->i_d.di_size) {
 			ret = xfs_setfilesize_trans_alloc(ioend);
 			if (ret)
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 84eafbc..c325abb 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -24,17 +24,17 @@ extern mempool_t *xfs_ioend_pool;
  * Types of I/O for bmap clustering and I/O completion tracking.
  */
 enum {
-	IO_DIRECT = 0,	/* special case for direct I/O ioends */
-	IO_DELALLOC,	/* mapping covers delalloc region */
-	IO_UNWRITTEN,	/* mapping covers allocated but uninitialized data */
-	IO_OVERWRITE,	/* mapping covers already allocated extent */
+	XFS_IO_DIRECT = 0,	/* special case for direct I/O ioends */
+	XFS_IO_DELALLOC,	/* covers delalloc region */
+	XFS_IO_UNWRITTEN,	/* covers allocated but uninitialized data */
+	XFS_IO_OVERWRITE,	/* covers already allocated extent */
 };
 
 #define XFS_IO_TYPES \
 	{ 0,			"" }, \
-	{ IO_DELALLOC,		"delalloc" }, \
-	{ IO_UNWRITTEN,		"unwritten" }, \
-	{ IO_OVERWRITE,		"overwrite" }
+	{ XFS_IO_DELALLOC,		"delalloc" }, \
+	{ XFS_IO_UNWRITTEN,		"unwritten" }, \
+	{ XFS_IO_OVERWRITE,		"overwrite" }
 
 /*
  * xfs_ioend struct manages large extent writes for XFS.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
