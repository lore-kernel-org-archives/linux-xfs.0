Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 14:48:11 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0NMm4qw029046
	for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 14:48:06 -0800
Date: Wed, 24 Jan 2007 09:47:04 +1100
From: David Chinner <dgc@sgi.com>
Subject: Review: Fix sub-page zeroing for buffered writes into unwritten extents
Message-ID: <20070123224704.GH33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com

Simple test case:

prealloc large file
write 3000 bytes to the middle of the file
read back file

The data in the block where the 3000 bytes was written has
non-zero garbage around it both in memory and on disk.

The problem is a buffer mapping problem. When we copy data
into an unwritten buffer, we have the create flag set which
means we map the buffer. We then mark the buffer as unwritten,
and do some more checks. Because the buffer is mapped, we do
not set the buffer_new() flag on the buffer, which means when
we return to the generic code, it does not do sub-block zeroing
of the unwritten areas of the block.

The following patch fixes the problem. Comments?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/linux-2.6/xfs_aops.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-01-23 18:40:45.255241599 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c	2007-01-23 18:49:13.345681246 +1100
@@ -1282,13 +1282,18 @@ __xfs_get_blocks(
 	bh_result->b_bdev = iomap.iomap_target->bt_bdev;
 
 	/*
-	 * If we previously allocated a block out beyond eof and we are
-	 * now coming back to use it then we will need to flag it as new
-	 * even if it has a disk address.
+	 * If we previously allocated a block out beyond eof and we are now
+	 * coming back to use it then we will need to flag it as new even if it
+	 * has a disk address.
+	 *
+	 * With sub-block writes into unwritten extents we also need to mark
+	 * the buffer as new so that the unwritten parts of the buffer gets
+	 * correctly zeroed.
 	 */
 	if (create &&
 	    ((!buffer_mapped(bh_result) && !buffer_uptodate(bh_result)) ||
-	     (offset >= i_size_read(inode)) || (iomap.iomap_flags & IOMAP_NEW)))
+	     (offset >= i_size_read(inode)) ||
+	     (iomap.iomap_flags & (IOMAP_NEW|IOMAP_UNWRITTEN))))
 		set_buffer_new(bh_result);
 
 	if (iomap.iomap_flags & IOMAP_DELAY) {
