Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96L6fU3201684 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 16:06:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA9A61C6F183
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 14:06:40 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Jvlz5AXUXOfM0wAR for <xfs@oss.sgi.com>;
	Thu, 06 Oct 2011 14:06:40 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RBv9M-0004GZ-4B
	for xfs@oss.sgi.com; Thu, 06 Oct 2011 21:06:40 +0000
Message-Id: <20111006210640.089607475@bombadil.infradead.org>
Date: Thu, 06 Oct 2011 17:06:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 9/9] xfs: remove xfs_buf_target_name
References: <20111006210607.175284390@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-xfs_buf_target_name
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

The calling convention that returns a pointer to a static buffer is
fairly nasty, so just opencode it in the only caller that is left.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2011-10-06 14:37:16.142921041 -0400
+++ xfs/fs/xfs/xfs_buf.c	2011-10-06 14:37:17.846921461 -0400
@@ -1457,9 +1457,13 @@ xfs_setsize_buftarg_flags(
 	btp->bt_smask = sectorsize - 1;
 
 	if (set_blocksize(btp->bt_bdev, sectorsize)) {
+		static char name[BDEVNAME_SIZE];
+
+		bdevname(btp->bt_bdev, name);
+
 		xfs_warn(btp->bt_mount,
 			"Cannot set_blocksize to %u on device %s\n",
-			sectorsize, xfs_buf_target_name(btp));
+			sectorsize, name);
 		return EINVAL;
 	}
 
Index: xfs/fs/xfs/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.h	2011-10-06 14:37:16.142921041 -0400
+++ xfs/fs/xfs/xfs_buf.h	2011-10-06 14:37:17.850917164 -0400
@@ -230,15 +230,6 @@ extern void xfs_buf_delwri_promote(struc
 extern int xfs_buf_init(void);
 extern void xfs_buf_terminate(void);
 
-static inline const char *
-xfs_buf_target_name(struct xfs_buftarg *target)
-{
-	static char __b[BDEVNAME_SIZE];
-
-	return bdevname(target->bt_bdev, __b);
-}
-
-
 #define XFS_BUF_ZEROFLAGS(bp) \
 	((bp)->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI| \
 			    XBF_SYNCIO|XBF_FUA|XBF_FLUSH))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
