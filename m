Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9JIOMBT206085 for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 13:24:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9A0AE1DBFD1
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 11:24:21 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	WcOGwAfEAxfCEGNK for <xfs@oss.sgi.com>;
	Wed, 19 Oct 2011 11:24:21 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RGaoO-0002pi-OS
	for xfs@oss.sgi.com; Wed, 19 Oct 2011 18:24:20 +0000
Message-Id: <20111019182420.712347469@bombadil.infradead.org>
Date: Wed, 19 Oct 2011 14:23:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/4] xfs: make i_flags and unsigned long
References: <20111019182343.762985925@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-use-i_flags
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

To be used for bit wakeup i_flags needs to be an unsigned long or we'll
run into trouble on big endian systems.  Beause of the 1-byte i_update
field right after it this actually causes a fairly large size increase
on its own (4 or 8 bytes), but that increase will be more than offset
by the next two patches.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2011-08-24 06:02:01.913971548 +0200
+++ xfs/fs/xfs/xfs_inode.h	2011-08-24 06:02:17.287221597 +0200
@@ -249,7 +249,7 @@ typedef struct xfs_inode {
 	wait_queue_head_t	i_ipin_wait;	/* inode pinning wait queue */
 	spinlock_t		i_flags_lock;	/* inode i_flags lock */
 	/* Miscellaneous state. */
-	unsigned short		i_flags;	/* see defined flags below */
+	unsigned long		i_flags;	/* see defined flags below */
 	unsigned char		i_update_core;	/* timestamps/size is dirty */
 	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
