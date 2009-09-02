Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82HviEZ034373 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 12:58:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9CCE615B1A26
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 10:58:40 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Wrw9h84qUWDPZ2qY for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 10:58:40 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Miu6S-0006Tn-9v
	for xfs@oss.sgi.com; Wed, 02 Sep 2009 17:58:40 +0000
Message-Id: <20090902175840.224768080@bombadil.infradead.org>
Date: Wed, 02 Sep 2009 13:55:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/14] repair: kill B_IS_META flag
References: <20090902175531.469184575@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-kill-B_IS_META
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

B_IS_META is the inverse flag of B_IS_INODE which is not really obvious
from it's use.  So just use !B_IS_INODE to make it more clear.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/prefetch.c
===================================================================
--- xfsprogs-dev.orig/repair/prefetch.c	2009-08-20 00:02:25.000000000 +0000
+++ xfsprogs-dev/repair/prefetch.c	2009-08-20 00:05:36.000000000 +0000
@@ -64,7 +64,6 @@
  * the buffer is for an inode or other metadata.
  */
 #define B_IS_INODE(f)	(((f) & 5) == 0)
-#define B_IS_META(f)	(((f) & 5) != 0)
 
 #define DEF_BATCH_BYTES	0x10000
 
@@ -131,7 +130,7 @@
 
 	if (fsbno > args->last_bno_read) {
 		radix_tree_insert(&args->primary_io_queue, fsbno, bp);
-		if (B_IS_META(flag))
+		if (!B_IS_INODE(flag))
 			radix_tree_tag_set(&args->primary_io_queue, fsbno, 0);
 		else {
 			args->inode_bufs_queued++;
@@ -153,7 +152,7 @@
 			(long long)XFS_BUF_ADDR(bp), args->agno, fsbno,
 			args->last_bno_read);
 #endif
-		ASSERT(B_IS_META(flag));
+		ASSERT(!B_IS_INODE(flag));
 		XFS_BUF_SET_PRIORITY(bp, B_DIR_META_2);
 		radix_tree_insert(&args->secondary_io_queue, fsbno, bp);
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
