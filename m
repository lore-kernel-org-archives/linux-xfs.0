Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8DMQ1xH094519 for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 17:26:02 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 12D1415C5FF
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 15:26:00 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	pEsvUAvRJxkPPZhe for <xfs@oss.sgi.com>;
	Tue, 13 Sep 2011 15:26:00 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R3bQW-0006wZ-7h
	for xfs@oss.sgi.com; Tue, 13 Sep 2011 22:26:00 +0000
Date: Tue, 13 Sep 2011 18:26:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: xfs: fix a use after free in xfs_end_io_direct_write
Message-ID: <20110913222600.GA26677@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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

There is a window in which the ioend that we call inode_dio_wake on
in xfs_end_io_direct_write is already free.  Fix this by storing
the inode pointer in a local variable.

This is a fix for the regression introduced in 3.1-rc by
"fs: move inode_dio_done to the end_io handler".

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_aops.c	2011-09-13 16:38:47.141089046 -0400
+++ linux-2.6/fs/xfs/xfs_aops.c	2011-09-13 16:39:09.991647077 -0400
@@ -1300,6 +1300,7 @@ xfs_end_io_direct_write(
 	bool			is_async)
 {
 	struct xfs_ioend	*ioend = iocb->private;
+	struct inode		*inode = ioend->io_inode;
 
 	/*
 	 * blockdev_direct_IO can return an error even after the I/O
@@ -1331,7 +1332,7 @@ xfs_end_io_direct_write(
 	}
 
 	/* XXX: probably should move into the real I/O completion handler */
-	inode_dio_done(ioend->io_inode);
+	inode_dio_done(inode);
 }
 
 STATIC ssize_t

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
