Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7EMPL3x008586 for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 17:25:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 91F02DAEB7
	for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 15:25:18 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	jzGUHtVtBfR0rKfg for <xfs@oss.sgi.com>;
	Sun, 14 Aug 2011 15:25:18 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qsj7N-00076D-RS
	for xfs@oss.sgi.com; Sun, 14 Aug 2011 22:25:17 +0000
Message-Id: <20110814222517.807217901@bombadil.infradead.org>
Date: Sun, 14 Aug 2011 18:24:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/5] xfs: defer AIO/DIO completions
References: <20110814222412.359079843@bombadil.infradead.org>
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
--- xfs.orig/fs/xfs/xfs_aops.c	2011-08-13 06:54:41.188441655 -0700
+++ xfs/fs/xfs/xfs_aops.c	2011-08-13 10:56:13.109932177 -0700
@@ -122,6 +122,11 @@ xfs_destroy_ioend(
 		bh->b_end_io(bh, !ioend->io_error);
 	}
 
+	if (ioend->io_iocb) {
+		if (ioend->io_buffer_tail == (struct buffer_head *)1)
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
@@ -1299,28 +1302,24 @@ xfs_end_io_direct_write(
 
 	ioend->io_offset = offset;
 	ioend->io_size = size;
+	ioend->io_iocb = iocb;
+	ioend->io_result = ret;
 	if (private && size > 0)
 		ioend->io_type = IO_UNWRITTEN;
 
 	if (is_async) {
 		/*
-		 * If we are converting an unwritten extent we need to delay
-		 * the AIO completion until after the unwrittent extent
-		 * conversion has completed, otherwise do it ASAP.
+		 * Abuse a field not use for direct I/O as an indicator that
+		 * we have to call aio_complete.  Unfortunatly an
+		 * is_sync_kiocb check is not enough for that as some
+		 * various aio-submitted iocbs may be treated as synchronous
+		 * I/O in the end.
 		 */
-		if (ioend->io_type == IO_UNWRITTEN) {
-			ioend->io_iocb = iocb;
-			ioend->io_result = ret;
-		} else {
-			aio_complete(iocb, ret, 0);
-		}
+		ioend->io_buffer_tail = (struct buffer_head *)1;
 		xfs_finish_ioend(ioend);
 	} else {
 		xfs_finish_ioend_sync(ioend);
 	}
-
-	/* XXX: probably should move into the real I/O completion handler */
-	inode_dio_done(ioend->io_inode);
 }
 
 STATIC ssize_t

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
