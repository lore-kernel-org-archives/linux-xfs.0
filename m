Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3SCSADL232803 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 07:28:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9CE18154E9C0
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id E4eFGo6ir66UWYEP for
	<xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:15 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O76P9-0000mJ-1S
	for xfs@oss.sgi.com; Wed, 28 Apr 2010 12:30:15 +0000
Message-Id: <20100428123014.934037854@bombadil.infradead.org>
Date: Wed, 28 Apr 2010 08:28:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/11] xfs: remove iomap_delta
References: <20100428122850.075189557@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-iomap-cleanup-3
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

The iomap_delta field in struct xfs_iomap just contains the difference
between the offset passed to xfs_iomap and the iomap_offset.  Just calculate
it in the only caller that cares.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-04-28 14:14:43.975254833 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-04-28 14:14:47.332253927 +0200
@@ -1511,9 +1511,11 @@ __xfs_get_blocks(
 	}
 
 	if (direct || size > (1 << inode->i_blkbits)) {
-		ASSERT(iomap.iomap_bsize - iomap.iomap_delta > 0);
+		xfs_off_t iomap_delta = offset - iomap.iomap_offset;
+
+		ASSERT(iomap.iomap_bsize - iomap_delta > 0);
 		offset = min_t(xfs_off_t,
-				iomap.iomap_bsize - iomap.iomap_delta, size);
+				iomap.iomap_bsize - iomap_delta, size);
 		bh_result->b_size = (ssize_t)min_t(xfs_off_t, LONG_MAX, offset);
 	}
 
Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2010-04-28 14:14:43.976254414 +0200
+++ xfs/fs/xfs/xfs_iomap.c	2010-04-28 14:14:47.333254206 +0200
@@ -68,7 +68,6 @@ xfs_imap_to_bmap(
 	xfs_fsblock_t	start_block;
 
 	iomapp->iomap_offset = XFS_FSB_TO_B(mp, imap->br_startoff);
-	iomapp->iomap_delta = offset - iomapp->iomap_offset;
 	iomapp->iomap_bsize = XFS_FSB_TO_B(mp, imap->br_blockcount);
 	iomapp->iomap_flags = flags;
 
Index: xfs/fs/xfs/xfs_iomap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.h	2010-04-28 14:14:43.982253995 +0200
+++ xfs/fs/xfs/xfs_iomap.h	2010-04-28 14:14:47.337253577 +0200
@@ -72,7 +72,6 @@ typedef struct xfs_iomap {
 	xfs_daddr_t		iomap_bn;	/* first 512B blk of mapping */
 	xfs_off_t		iomap_offset;	/* offset of mapping, bytes */
 	xfs_off_t		iomap_bsize;	/* size of mapping, bytes */
-	xfs_off_t		iomap_delta;	/* offset into mapping, bytes */
 	iomap_flags_t		iomap_flags;
 } xfs_iomap_t;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
