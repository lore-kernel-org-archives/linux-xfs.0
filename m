Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q62A0d9p201591 for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 05:00:39 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	vm8EAdAXvnxZMC6E (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jul 2012 03:00:35 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SldQo-0005Zb-Om
	for xfs@oss.sgi.com; Mon, 02 Jul 2012 10:00:34 +0000
Message-Id: <20120702100034.627510436@bombadil.infradead.org>
Date: Mon, 02 Jul 2012 06:00:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/2] xfs: prevent recursion in xfs_buf_iorequest
References: <20120702100003.960640484@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-io-error-recursion
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

If the b_iodone handler is run in calling context in xfs_buf_iorequest we
can run into a recursion where xfs_buf_iodone_callbacks keeps calling back
into xfs_buf_iorequest because an I/O error happened, which keeps calling
back into xfs_buf_iorequest.  This chain will usually not take long
because the filesystem gets shut down because of log I/O errors, but even
over a short time it can cause stack overflows if run on the same context.

As a short term workaround make sure we always call the iodone handler in
workqueue context.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_buf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2012-06-26 23:20:22.369740722 +0200
+++ xfs/fs/xfs/xfs_buf.c	2012-06-26 23:20:23.686407379 +0200
@@ -1243,7 +1243,7 @@ xfs_buf_iorequest(
 	 */
 	atomic_set(&bp->b_io_remaining, 1);
 	_xfs_buf_ioapply(bp);
-	_xfs_buf_ioend(bp, 0);
+	_xfs_buf_ioend(bp, 1);
 
 	xfs_buf_rele(bp);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
