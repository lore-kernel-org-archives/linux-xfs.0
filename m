Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBA8fE6N205197 for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 02:41:14 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DB91160F98F
	for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 00:43:04 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Ro4r6ARB8ko6TmeQ for
	<xfs@oss.sgi.com>; Fri, 10 Dec 2010 00:43:04 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PQyZD-0006Rw-Ia
	for xfs@oss.sgi.com; Fri, 10 Dec 2010 08:43:03 +0000
Message-Id: <20101210084303.537974157@bombadil.infradead.org>
Date: Fri, 10 Dec 2010 03:42:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/10] xfs: simplify xfs_map_at_offset
References: <20101210084215.259628825@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-simplify-xfs_map_at_offset
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

Move the buffer locking into the callers as they need to do it wether they
call xfs_map_at_offset or not.  Remove the b_bdev assignment, which is
already done by get_blocks.  Remove the duplicate extent type asserts in
xfs_convert_page just before calling xfs_map_at_offset.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-12-09 15:52:23.144273297 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-12-09 15:52:41.846254159 +0100
@@ -626,9 +626,7 @@ xfs_map_at_offset(
 	ASSERT(imap->br_startblock != HOLESTARTBLOCK);
 	ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
 
-	lock_buffer(bh);
 	xfs_map_buffer(inode, bh, imap, offset);
-	bh->b_bdev = xfs_find_bdev_for_inode(inode);
 	set_buffer_mapped(bh);
 	clear_buffer_delay(bh);
 	clear_buffer_unwritten(bh);
@@ -751,12 +749,8 @@ xfs_convert_page(
 				continue;
 			}
 
-			ASSERT(imap->br_startblock != HOLESTARTBLOCK);
-			ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
-
-			if (type == IO_OVERWRITE)
-				lock_buffer(bh);
-			else
+			lock_buffer(bh);
+			if (type != IO_OVERWRITE)
 				xfs_map_at_offset(inode, bh, imap, offset);
 			xfs_add_to_ioend(inode, bh, offset, type,
 					 ioendp, done);
@@ -1041,9 +1035,8 @@ xfs_vm_writepage(
 			imap_valid = xfs_imap_valid(inode, &imap, offset);
 		}
 		if (imap_valid) {
-			if (type == IO_OVERWRITE)
-				lock_buffer(bh);
-			else
+			lock_buffer(bh);
+			if (type != IO_OVERWRITE)
 				xfs_map_at_offset(inode, bh, &imap, offset);
 			xfs_add_to_ioend(inode, bh, offset, type, &ioend,
 					 new_ioend);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
