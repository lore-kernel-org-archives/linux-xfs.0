Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7N8TFCF164705 for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 03:29:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9DE7AFFF90
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 01:29:13 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	K07dcgKlBMkRYehk for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 01:29:13 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QvmMD-000636-49
	for xfs@oss.sgi.com; Tue, 23 Aug 2011 08:29:13 +0000
Message-Id: <20110823082913.085652089@bombadil.infradead.org>
Date: Tue, 23 Aug 2011 04:28:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/11] xfs: remove dead ENODEV handling in xfs_destroy_ioend
References: <20110823082802.335389799@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-remove-dead-ENODEV-handling
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

No driver returns ENODEV from it bio completion handler, not has this
ever been documented.  Remove the dead code dealing with it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_aops.c	2011-07-28 17:22:27.277106627 +0200
+++ xfs/fs/xfs/xfs_aops.c	2011-07-28 17:24:19.016501283 +0200
@@ -122,17 +122,6 @@ xfs_destroy_ioend(
 		bh->b_end_io(bh, !ioend->io_error);
 	}
 
-	/*
-	 * Volume managers supporting multiple paths can send back ENODEV
-	 * when the final path disappears.  In this case continuing to fill
-	 * the page cache with dirty data which cannot be written out is
-	 * evil, so prevent that.
-	 */
-	if (unlikely(ioend->io_error == -ENODEV)) {
-		xfs_do_force_shutdown(ip->i_mount, SHUTDOWN_DEVICE_REQ,
-				      __FILE__, __LINE__);
-	}
-
 	xfs_ioend_wake(ip);
 	mempool_free(ioend, xfs_ioend_pool);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
