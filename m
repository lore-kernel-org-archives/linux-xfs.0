Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7N8TFEw164704 for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 03:29:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BC29139230D
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 01:31:53 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Lcb1DWkpbHEkFvgB for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 01:31:53 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QvmMD-00063c-A1
	for xfs@oss.sgi.com; Tue, 23 Aug 2011 08:29:13 +0000
Message-Id: <20110823082913.270459702@bombadil.infradead.org>
Date: Tue, 23 Aug 2011 04:28:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/11] xfs: defer AIO/DIO completions
References: <20110823082802.335389799@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-aio-completions
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

We really shouldn't complete AIO or DIO requests until we have finished
the unwritten extent conversion and size update.  This means fsync never
has to pick up any ioends as all work has been completed when signalling
I/O completion.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_aops.c	2011-08-23 04:39:29.027667347 +0200
+++ xfs/fs/xfs/xfs_aops.c	2011-08-23 04:39:56.914196267 +0200
@@ -122,6 +122,11 @@ xfs_destroy_ioend(
 		bh->b_end_io(bh, !ioend->io_error);
 	}
 
+	if (ioend->io_iocb) {
+		if (ioend->io_isasync)
+			aio_complete(ioend->io_iocb, ioend->io_result, 0);
+		inode_dio_done(ioend->io_inode);
+	}
 	xfs_ioend_wake(ip);
 	mempool_free(ioend, xfs_ioend_pool);
 }
@@ -236,8 +241,6 @@ xfs_end_io(
 		/* ensure we don't spin on blocked ioends */
 		delay(1);
 	} else {
-		if (ioend->io_iocb)
-			aio_complete(ioend->io_iocb, ioend->io_result, 0);
 		xfs_destroy_ioend(ioend);
 	}
 }
@@ -274,6 +277,7 @@ xfs_alloc_ioend(
 	 * all the I/O from calling the completion routine too early.
 	 */
 	atomic_set(&ioend->io_remaining, 1);
+	ioend->io_isasync = 0;
 	ioend->io_error = 0;
 	ioend->io_list = NULL;
 	ioend->io_type = type;
@@ -1299,28 +1303,17 @@ xfs_end_io_direct_write(
 
 	ioend->io_offset = offset;
 	ioend->io_size = size;
+	ioend->io_iocb = iocb;
+	ioend->io_result = ret;
 	if (private && size > 0)
 		ioend->io_type = IO_UNWRITTEN;
 
 	if (is_async) {
-		/*
-		 * If we are converting an unwritten extent we need to delay
-		 * the AIO completion until after the unwrittent extent
-		 * conversion has completed, otherwise do it ASAP.
-		 */
-		if (ioend->io_type == IO_UNWRITTEN) {
-			ioend->io_iocb = iocb;
-			ioend->io_result = ret;
-		} else {
-			aio_complete(iocb, ret, 0);
-		}
+		ioend->io_isasync = 1;
 		xfs_finish_ioend(ioend);
 	} else {
 		xfs_finish_ioend_sync(ioend);
 	}
-
-	/* XXX: probably should move into the real I/O completion handler */
-	inode_dio_done(ioend->io_inode);
 }
 
 STATIC ssize_t
Index: xfs/fs/xfs/xfs_aops.h
===================================================================
--- xfs.orig/fs/xfs/xfs_aops.h	2011-08-23 04:39:24.057694271 +0200
+++ xfs/fs/xfs/xfs_aops.h	2011-08-23 04:39:29.900995938 +0200
@@ -47,6 +47,7 @@ typedef struct xfs_ioend {
 	unsigned int		io_type;	/* delalloc / unwritten */
 	int			io_error;	/* I/O error code */
 	atomic_t		io_remaining;	/* hold count */
+	unsigned int		io_isasync : 1;	/* needs aio_complete */
 	struct inode		*io_inode;	/* file being written to */
 	struct buffer_head	*io_buffer_head;/* buffer linked list head */
 	struct buffer_head	*io_buffer_tail;/* buffer linked list tail */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
