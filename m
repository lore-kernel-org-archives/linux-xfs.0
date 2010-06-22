Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5MCShE7237996 for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 07:28:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA20B14ACD7D
	for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 05:35:25 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id P52YTNiBwVTaMCg4 for <xfs@oss.sgi.com>;
	Tue, 22 Jun 2010 05:35:25 -0700 (PDT)
Message-Id: <20100622123113.205150586@bombadil.infradead.org>
Date: Tue, 22 Jun 2010 08:21:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] xfs: move aio completion after unwritten extent conversion
References: <20100622122144.302857146@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-unwritten-fix
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
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org

If we write into an unwritten extent using AIO we need to complete the AIO
request after the extent conversion has finished.  Without that a read could
race to see see the extent still unwritten and return zeros.   For synchronous
I/O we already take care of that by flushing the xfsconvertd workqueue (which
might be a bit of overkill).

To do that add iocb and result fields to struct xfs_ioend, so that we can
call aio_complete from xfs_end_io after the extent conversion has happened.
Note that we need a new result field as io_error is used for positive errno
values, while the AIO code can return negative error values and positive
transfer sizes.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-06-22 14:05:02.522005722 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2010-06-22 14:08:30.065006205 +0200
@@ -275,8 +275,11 @@ xfs_end_io(
 		xfs_finish_ioend(ioend, 0);
 		/* ensure we don't spin on blocked ioends */
 		delay(1);
-	} else
+	} else {
+		if (ioend->io_iocb)
+			aio_complete(ioend->io_iocb, ioend->io_result, 0);
 		xfs_destroy_ioend(ioend);
+	}
 }
 
 /*
@@ -309,6 +312,8 @@ xfs_alloc_ioend(
 	atomic_inc(&XFS_I(ioend->io_inode)->i_iocount);
 	ioend->io_offset = 0;
 	ioend->io_size = 0;
+	ioend->io_iocb = NULL;
+	ioend->io_result = 0;
 
 	INIT_WORK(&ioend->io_work, xfs_end_io);
 	return ioend;
@@ -1604,6 +1609,7 @@ xfs_end_io_direct(
 	bool		is_async)
 {
 	xfs_ioend_t	*ioend = iocb->private;
+	bool		complete_aio = is_async;
 
 	/*
 	 * Non-NULL private data means we need to issue a transaction to
@@ -1629,7 +1635,14 @@ xfs_end_io_direct(
 	if (ioend->io_type == IO_READ) {
 		xfs_finish_ioend(ioend, 0);
 	} else if (private && size > 0) {
-		xfs_finish_ioend(ioend, is_sync_kiocb(iocb));
+		if (is_async) {
+			ioend->io_iocb = iocb;
+			ioend->io_result = ret;
+			complete_aio = false;
+			xfs_finish_ioend(ioend, 0);
+		} else {
+			xfs_finish_ioend(ioend, 1);
+		}
 	} else {
 		/*
 		 * A direct I/O write ioend starts it's life in unwritten
@@ -1648,7 +1661,7 @@ xfs_end_io_direct(
 	 */
 	iocb->private = NULL;
 
-	if (is_async)
+	if (complete_aio)
 		aio_complete(iocb, ret, 0);
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
