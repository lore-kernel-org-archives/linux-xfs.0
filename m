Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p619k8bk056116 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 04:46:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F52B4669F
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 02:46:07 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	HM09kqnQxcgxdNRo for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2011 02:46:07 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QcaIY-00021Q-Vy
	for xfs@oss.sgi.com; Fri, 01 Jul 2011 09:46:07 +0000
Message-Id: <20110701094606.955329993@bombadil.infradead.org>
Date: Fri, 01 Jul 2011 05:43:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 23/27] xfs: remove the unused xfs_bufhash structure
References: <20110701094321.936534538@bombadil.infradead.org>
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
