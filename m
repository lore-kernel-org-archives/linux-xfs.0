Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3SCULqG233065 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 07:30:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CCB62F9890
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YSQogVz7SQaHMf3T for
	<xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:16 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O76P9-0000p0-RS
	for xfs@oss.sgi.com; Wed, 28 Apr 2010 12:30:15 +0000
Message-Id: <20100428123015.718624323@bombadil.infradead.org>
Date: Wed, 28 Apr 2010 08:28:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/11] xfs: move I/O type flags into xfs_aops.c
References: <20100428122850.075189557@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-iomap-cleanup-7
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

The IOMAP_ flags are now only used inside xfs_aops.c for extent probing
and I/O completion tracking, so more them here, and rename them to IO_*
as there's no mapping involved at all.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-04-27 18:45:11.776004100 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-04-27 20:34:06.333011852 +0200
@@ -44,6 +44,15 @@
 #include <linux/pagevec.h>
 #include <linux/writeback.h>
 
+/*
+ * Types of I/O for bmap clustering and I/O completion tracking.
+ */
+enum {
+	IO_READ,	/* mapping for a read */
+	IO_DELAY,	/* mapping covers delalloc region */
+	IO_UNWRITTEN,	/* mapping covers allocated but uninitialized data */
+	IO_NEW		/* just allocated */
+};
 
 /*
  * Prime number of hash buckets since address is used as the key.
@@ -183,7 +192,7 @@ xfs_setfilesize(
 	xfs_fsize_t		isize;
 
 	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFREG);
-	ASSERT(ioend->io_type != IOMAP_READ);
+	ASSERT(ioend->io_type != IO_READ);
 
 	if (unlikely(ioend->io_error))
 		return 0;
@@ -214,7 +223,7 @@ xfs_finish_ioend(
 	if (atomic_dec_and_test(&ioend->io_remaining)) {
 		struct workqueue_struct *wq;
 
-		wq = (ioend->io_type == IOMAP_UNWRITTEN) ?
+		wq = (ioend->io_type == IO_UNWRITTEN) ?
 			xfsconvertd_workqueue : xfsdatad_workqueue;
 		queue_work(wq, &ioend->io_work);
 		if (wait)
@@ -237,7 +246,7 @@ xfs_end_io(
 	 * For unwritten extents we need to issue transactions to convert a
 	 * range to normal written extens after the data I/O has finished.
 	 */
-	if (ioend->io_type == IOMAP_UNWRITTEN &&
+	if (ioend->io_type == IO_UNWRITTEN &&
 	    likely(!ioend->io_error && !XFS_FORCED_SHUTDOWN(ip->i_mount))) {
 
 		error = xfs_iomap_write_unwritten(ip, ioend->io_offset,
@@ -250,7 +259,7 @@ xfs_end_io(
 	 * We might have to update the on-disk file size after extending
 	 * writes.
 	 */
-	if (ioend->io_type != IOMAP_READ) {
+	if (ioend->io_type != IO_READ) {
 		error = xfs_setfilesize(ioend);
 		ASSERT(!error || error == EAGAIN);
 	}
@@ -723,11 +732,11 @@ xfs_is_delayed_page(
 		bh = head = page_buffers(page);
 		do {
 			if (buffer_unwritten(bh))
-				acceptable = (type == IOMAP_UNWRITTEN);
+				acceptable = (type == IO_UNWRITTEN);
 			else if (buffer_delay(bh))
-				acceptable = (type == IOMAP_DELAY);
+				acceptable = (type == IO_DELAY);
 			else if (buffer_dirty(bh) && buffer_mapped(bh))
-				acceptable = (type == IOMAP_NEW);
+				acceptable = (type == IO_NEW);
 			else
 				break;
 		} while ((bh = bh->b_this_page) != head);
@@ -811,9 +820,9 @@ xfs_convert_page(
 
 		if (buffer_unwritten(bh) || buffer_delay(bh)) {
 			if (buffer_unwritten(bh))
-				type = IOMAP_UNWRITTEN;
+				type = IO_UNWRITTEN;
 			else
-				type = IOMAP_DELAY;
+				type = IO_DELAY;
 
 			if (!xfs_iomap_valid(inode, imap, offset)) {
 				done = 1;
@@ -835,7 +844,7 @@ xfs_convert_page(
 			page_dirty--;
 			count++;
 		} else {
-			type = IOMAP_NEW;
+			type = IO_NEW;
 			if (buffer_mapped(bh) && all_bh && startio) {
 				lock_buffer(bh);
 				xfs_add_to_ioend(inode, bh, offset,
@@ -939,7 +948,7 @@ xfs_aops_discard_page(
 	loff_t			offset = page_offset(page);
 	ssize_t			len = 1 << inode->i_blkbits;
 
-	if (!xfs_is_delayed_page(page, IOMAP_DELAY))
+	if (!xfs_is_delayed_page(page, IO_DELAY))
 		goto out_invalidate;
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
@@ -1106,7 +1115,7 @@ xfs_page_state_convert(
 	bh = head = page_buffers(page);
 	offset = page_offset(page);
 	flags = BMAPI_READ;
-	type = IOMAP_NEW;
+	type = IO_NEW;
 
 	/* TODO: cleanup count and page_dirty */
 
@@ -1149,13 +1158,13 @@ xfs_page_state_convert(
 				iomap_valid = 0;
 
 			if (buffer_unwritten(bh)) {
-				type = IOMAP_UNWRITTEN;
+				type = IO_UNWRITTEN;
 				flags = BMAPI_WRITE | BMAPI_IGNSTATE;
 			} else if (buffer_delay(bh)) {
-				type = IOMAP_DELAY;
+				type = IO_DELAY;
 				flags = BMAPI_ALLOCATE | trylock;
 			} else {
-				type = IOMAP_NEW;
+				type = IO_NEW;
 				flags = BMAPI_WRITE | BMAPI_MMAP;
 			}
 
@@ -1169,7 +1178,7 @@ xfs_page_state_convert(
 				 * for unwritten extent conversion.
 				 */
 				new_ioend = 1;
-				if (type == IOMAP_NEW) {
+				if (type == IO_NEW) {
 					size = xfs_probe_cluster(inode,
 							page, bh, head, 0);
 				} else {
@@ -1214,14 +1223,14 @@ xfs_page_state_convert(
 			}
 
 			/*
-			 * We set the type to IOMAP_NEW in case we are doing a
+			 * We set the type to IO_NEW in case we are doing a
 			 * small write at EOF that is extending the file but
 			 * without needing an allocation. We need to update the
 			 * file size on I/O completion in this case so it is
 			 * the same case as having just allocated a new extent
 			 * that we are writing into for the first time.
 			 */
-			type = IOMAP_NEW;
+			type = IO_NEW;
 			if (trylock_buffer(bh)) {
 				ASSERT(buffer_mapped(bh));
 				if (iomap_valid)
@@ -1593,7 +1602,7 @@ xfs_end_io_direct(
 	 */
 	ioend->io_offset = offset;
 	ioend->io_size = size;
-	if (ioend->io_type == IOMAP_READ) {
+	if (ioend->io_type == IO_READ) {
 		xfs_finish_ioend(ioend, 0);
 	} else if (private && size > 0) {
 		xfs_finish_ioend(ioend, is_sync_kiocb(iocb));
@@ -1604,7 +1613,7 @@ xfs_end_io_direct(
 		 * didn't map an unwritten extent so switch it's completion
 		 * handler.
 		 */
-		ioend->io_type = IOMAP_NEW;
+		ioend->io_type = IO_NEW;
 		xfs_finish_ioend(ioend, 0);
 	}
 
@@ -1632,7 +1641,7 @@ xfs_vm_direct_IO(
 	bdev = xfs_find_bdev_for_inode(inode);
 
 	iocb->private = xfs_alloc_ioend(inode, rw == WRITE ?
-					IOMAP_UNWRITTEN : IOMAP_READ);
+					IO_UNWRITTEN : IO_READ);
 
 	ret = blockdev_direct_IO_no_locking(rw, iocb, inode, bdev, iov,
 					    offset, nr_segs,
Index: xfs/fs/xfs/xfs_iomap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.h	2010-04-27 18:45:11.784022678 +0200
+++ xfs/fs/xfs/xfs_iomap.h	2010-04-27 20:20:17.308010875 +0200
@@ -18,14 +18,6 @@
 #ifndef __XFS_IOMAP_H__
 #define __XFS_IOMAP_H__
 
-typedef enum {				/* iomap_flags values */
-	IOMAP_READ =		0,	/* mapping for a read */
-	IOMAP_DELAY =		0x04,	/* mapping covers delalloc region  */
-	IOMAP_UNWRITTEN =	0x20,	/* mapping covers allocated */
-					/* but uninitialized file data  */
-	IOMAP_NEW =		0x40	/* just allocate */
-} iomap_flags_t;
-
 typedef enum {
 	/* base extent manipulation calls */
 	BMAPI_READ = (1 << 0),		/* read extents */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
