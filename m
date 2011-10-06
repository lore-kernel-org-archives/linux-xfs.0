Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96L6ftC201679 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 16:06:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E7651C6F182
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 14:06:40 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	WomSaW5Ht4WHjHm9 for <xfs@oss.sgi.com>;
	Thu, 06 Oct 2011 14:06:40 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RBv9L-0004G3-UY
	for xfs@oss.sgi.com; Thu, 06 Oct 2011 21:06:39 +0000
Message-Id: <20111006210639.904713322@bombadil.infradead.org>
Date: Thu, 06 Oct 2011 17:06:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 8/9] xfs: use xfs_ioerror_alert in xfs_buf_iodone_callbacks
References: <20111006210607.175284390@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xfs_buf_iodone_callbacks
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

Use xfs_ioerror_alert instead of opencoding a very similar error
message.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2011-10-06 16:56:55.324148672 -0400
+++ xfs/fs/xfs/xfs_buf_item.c	2011-10-06 16:57:04.444144227 -0400
@@ -976,9 +976,7 @@ xfs_buf_iodone_callbacks(
 	if (bp->b_target != lasttarg ||
 	    time_after(jiffies, (lasttime + 5*HZ))) {
 		lasttime = jiffies;
-		xfs_alert(mp, "Device %s: metadata write error block 0x%llx",
-			xfs_buf_target_name(bp->b_target),
-		      (__uint64_t)XFS_BUF_ADDR(bp));
+		xfs_ioerror_alert(bp, "xfs_buf_iodone_callbacks");
 	}
 	lasttarg = bp->b_target;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
