Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7EHGrfU248846 for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 12:16:53 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87865DAE2A
	for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 10:16:52 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	cGSOYV5PBCWEmR7N for <xfs@oss.sgi.com>;
	Sun, 14 Aug 2011 10:16:52 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QseIt-0007oA-OE
	for xfs@oss.sgi.com; Sun, 14 Aug 2011 17:16:51 +0000
Message-Id: <20110814171651.707270455@bombadil.infradead.org>
Date: Sun, 14 Aug 2011 13:15:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/6] xfs: remove delwri buffer handling from xfs_buf_iorequest
References: <20110814171517.174040686@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-simplify-xfs_buf_iorequest
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

We cannot ever reach xfs_buf_iorequest for a buffer with XBF_DELWRI set,
given that all write handlers make sure that the buffer is remove from
the delwri queue before, and we never do reads with the XBF_DELWRI flag
set (which the code would not handle correctly anyway).

Signed-off-by: Christoph Hellwig <hch@lst.de>

--- xfs.orig/fs/xfs_buf.c	2011-08-10 10:33:22.758525637 +0200
+++ xfs/fs/xfs/xfs_buf.c	2011-08-11 22:24:09.236752446 +0200
@@ -1275,15 +1276,10 @@ xfs_buf_iorequest(
 {
 	trace_xfs_buf_iorequest(bp, _RET_IP_);
 
-	if (bp->b_flags & XBF_DELWRI) {
-		xfs_buf_delwri_queue(bp, 1);
-		return 0;
-	}
+	ASSERT(!(bp->b_flags & XBF_DELWRI));
 
-	if (bp->b_flags & XBF_WRITE) {
+	if (bp->b_flags & XBF_WRITE)
 		xfs_buf_wait_unpin(bp);
-	}
-
 	xfs_buf_hold(bp);
 
 	/* Set the count to 1 initially, this will stop an I/O

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
