Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67B6kG9159993 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 06:06:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1BE2015ECD5A
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 04:06:45 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	5G6BcNIBHQptOO5m for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 04:06:45 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QemPt-00041b-9E
	for xfs@oss.sgi.com; Thu, 07 Jul 2011 11:06:45 +0000
Message-Id: <20110707110645.250743525@bombadil.infradead.org>
Date: Thu, 07 Jul 2011 07:05:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 24/28] xfs: remove the unused xfs_bufhash structure
References: <20110707110535.205001532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-remove-bufhash
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2011-06-29 11:26:14.542550346 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2011-06-29 13:50:40.648935352 +0200
@@ -91,11 +91,6 @@ typedef enum {
 	XBT_FORCE_FLUSH = 1,
 } xfs_buftarg_flags_t;
 
-typedef struct xfs_bufhash {
-	struct list_head	bh_list;
-	spinlock_t		bh_lock;
-} xfs_bufhash_t;
-
 typedef struct xfs_buftarg {
 	dev_t			bt_dev;
 	struct block_device	*bt_bdev;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
