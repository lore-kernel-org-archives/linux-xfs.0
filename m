Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3SCSChO232836 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 07:28:12 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4B41154E9C6
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id SowyAAPCZNIuVPGw for
	<xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:16 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O76PA-0000qH-7n
	for xfs@oss.sgi.com; Wed, 28 Apr 2010 12:30:16 +0000
Message-Id: <20100428123016.152412458@bombadil.infradead.org>
Date: Wed, 28 Apr 2010 08:28:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/11] xfs: clean up mapping size calculation in
	__xfs_get_blocks
References: <20100428122850.075189557@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-iomap-cleanup-10
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

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-04-28 12:59:49.296003890 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-04-28 12:59:52.857024355 +0200
@@ -1535,16 +1535,23 @@ __xfs_get_blocks(
 		}
 	}
 
+	/*
+	 * If this is O_DIRECT or the mpage code calling tell them how large
+	 * the mapping is, so that we can avoid repeated get_blocks calls.
+	 */
 	if (direct || size > (1 << inode->i_blkbits)) {
-		struct xfs_mount	*mp = XFS_I(inode)->i_mount;
-		xfs_off_t		iomap_offset = XFS_FSB_TO_B(mp, imap.br_startoff);
-		xfs_off_t		iomap_delta = offset - iomap_offset;
-		xfs_off_t		iomap_bsize = XFS_FSB_TO_B(mp, imap.br_blockcount);
+		xfs_off_t		mapping_size;
 
-		ASSERT(iomap_bsize - iomap_delta > 0);
-		offset = min_t(xfs_off_t,
-				iomap_bsize - iomap_delta, size);
-		bh_result->b_size = (ssize_t)min_t(xfs_off_t, LONG_MAX, offset);
+		mapping_size = imap.br_startoff + imap.br_blockcount - iblock;
+		mapping_size <<= inode->i_blkbits;
+
+		ASSERT(mapping_size > 0);
+		if (mapping_size > size)
+			mapping_size = size;
+		if (mapping_size > LONG_MAX)
+			mapping_size = LONG_MAX;
+
+		bh_result->b_size = mapping_size;
 	}
 
 	return 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
