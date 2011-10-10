Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AGrTvb189854 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 11:53:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66CD44EF9B9
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 09:53:28 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	u987BrVi6GLIP0yF for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 09:53:28 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RDJ6V-0008Gr-Tj
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 16:53:27 +0000
Message-Id: <20111010165327.877026051@bombadil.infradead.org>
Date: Mon, 10 Oct 2011 12:52:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/11] xfs: use xfs_ioerror_alert in xfs_buf_iodone_callbacks
References: <20111010165242.656850411@bombadil.infradead.org>
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
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2011-10-07 10:20:39.638016942 -0400
+++ xfs/fs/xfs/xfs_buf_item.c	2011-10-07 10:29:05.816517834 -0400
@@ -976,9 +976,7 @@ xfs_buf_iodone_callbacks(
 	if (bp->b_target != lasttarg ||
 	    time_after(jiffies, (lasttime + 5*HZ))) {
 		lasttime = jiffies;
-		xfs_alert(mp, "Device %s: metadata write error block 0x%llx",
-			xfs_buf_target_name(bp->b_target),
-		      (__uint64_t)XFS_BUF_ADDR(bp));
+		xfs_buf_ioerror_alert(bp, __func__);
 	}
 	lasttarg = bp->b_target;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
