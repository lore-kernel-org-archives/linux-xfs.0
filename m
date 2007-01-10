Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 09 Jan 2007 16:35:01 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0A0Yqqw015502
	for <xfs@oss.sgi.com>; Tue, 9 Jan 2007 16:34:54 -0800
Date: Wed, 10 Jan 2007 11:33:54 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 1 of 2]: Make BH_Unwritten a first class bufferhead flag V2
Message-ID: <20070110003354.GN44411608@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Version 2:

- separate buffer_delay in generic code into buffer_delay
  and buffer_unwritten
- include XFS changes as a second patch:
  - remove XFS use of buffer_delay to indicate buffer_unwritten
  - remove XFS hack to silently clear "lost" unwritten flags

Version 1:

Currently, XFS uses BH_PrivateStart for flagging unwritten
extent state in a bufferhead. Recently, i found the long standing
mmap/unwritten extent conversion bug, and it was to do with
partial page invalidation not clearing the unwritten flag from
bufferheads attached to the page but beyond EOF. See here
for a full explaination:

http://oss.sgi.com/archives/xfs/2006-12/msg00196.html

The solution I have checked into the XFS dev tree involves
duplicating code from block_invalidatepage to clear the
unwritten flag from the bufferhead(s), and then calling
block_invalidatepage() to do the rest.

Christoph suggested that this would be better solved by
pushing the unwritten flag into the common buffer head flags
and just adding the call to discard_buffer():

http://oss.sgi.com/archives/xfs/2006-12/msg00239.html

The following patch makes BH_Unwritten a first class citizen.
Patch against 2.6.20-rc3.

Signed-Off-By: Dave Chinner <dgc@sgi.com>

---
 fs/buffer.c                  |    4 +++-
 fs/xfs/linux-2.6/xfs_linux.h |   10 ----------
 include/linux/buffer_head.h  |    2 ++
 3 files changed, 5 insertions(+), 11 deletions(-)

Index: 2.6.x-xfs-new/fs/buffer.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/buffer.c	2007-01-08 14:32:39.688130559 +1100
+++ 2.6.x-xfs-new/fs/buffer.c	2007-01-09 11:00:02.659186970 +1100
@@ -1437,6 +1437,7 @@ static void discard_buffer(struct buffer
 	clear_buffer_req(bh);
 	clear_buffer_new(bh);
 	clear_buffer_delay(bh);
+	clear_buffer_unwritten(bh);
 	unlock_buffer(bh);
 }
 
@@ -1820,6 +1821,7 @@ static int __block_prepare_write(struct 
 			continue; 
 		}
 		if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
+		    !buffer_unwritten(bh) &&
 		     (block_start < from || block_end > to)) {
 			ll_rw_block(READ, 1, &bh);
 			*wait_bh++=bh;
@@ -2541,7 +2543,7 @@ int block_truncate_page(struct address_s
 	if (PageUptodate(page))
 		set_buffer_uptodate(bh);
 
-	if (!buffer_uptodate(bh) && !buffer_delay(bh)) {
+	if (!buffer_uptodate(bh) && !buffer_delay(bh) && !buffer_unwritten(bh)) {
 		err = -EIO;
 		ll_rw_block(READ, 1, &bh);
 		wait_on_buffer(bh);
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_linux.h	2006-12-12 12:05:17.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_linux.h	2007-01-09 10:58:30.459212715 +1100
@@ -109,16 +109,6 @@
 #undef  HAVE_PERCPU_SB	/* per cpu superblock counters are a 2.6 feature */
 #endif
 
-/*
- * State flag for unwritten extent buffers.
- *
- * We need to be able to distinguish between these and delayed
- * allocate buffers within XFS.  The generic IO path code does
- * not need to distinguish - we use the BH_Delay flag for both
- * delalloc and these ondisk-uninitialised buffers.
- */
-BUFFER_FNS(PrivateStart, unwritten);
-
 #define restricted_chown	xfs_params.restrict_chown.val
 #define irix_sgid_inherit	xfs_params.sgid_inherit.val
 #define irix_symlink_mode	xfs_params.symlink_mode.val
Index: 2.6.x-xfs-new/include/linux/buffer_head.h
===================================================================
--- 2.6.x-xfs-new.orig/include/linux/buffer_head.h	2006-12-12 12:06:29.000000000 +1100
+++ 2.6.x-xfs-new/include/linux/buffer_head.h	2007-01-09 10:58:30.535202804 +1100
@@ -34,6 +34,7 @@ enum bh_state_bits {
 	BH_Write_EIO,	/* I/O error on write */
 	BH_Ordered,	/* ordered write */
 	BH_Eopnotsupp,	/* operation not supported (barrier) */
+	BH_Unwritten,	/* Buffer is allocated on disk but not written */
 
 	BH_PrivateStart,/* not a state bit, but the first bit available
 			 * for private allocation by other entities
@@ -126,6 +127,7 @@ BUFFER_FNS(Boundary, boundary)
 BUFFER_FNS(Write_EIO, write_io_error)
 BUFFER_FNS(Ordered, ordered)
 BUFFER_FNS(Eopnotsupp, eopnotsupp)
+BUFFER_FNS(Unwritten, unwritten)
 
 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
 #define touch_buffer(bh)	mark_page_accessed(bh->b_page)
