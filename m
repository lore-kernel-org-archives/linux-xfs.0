Return-Path: linux-xfs-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:43310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727391AbfAaSJd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 13:09:33 -0500
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 07/10] xfs: delalloc -> unwritten COW fork allocation can go wrong
Date: Thu, 31 Jan 2019 10:09:16 -0800
Message-Id: <20190131180919.2500-8-mcgrof@kernel.org>
In-Reply-To: <20190131180919.2500-1-mcgrof@kernel.org>
References: <20190131180919.2500-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
To: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com
Cc: amir73il@gmail.com, hch@infradead.org, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>

From: Dave Chinner <dchinner@redhat.com>

Long saga. There have been days spent following this through dead end
after dead end in multi-GB event traces. This morning, after writing
a trace-cmd wrapper that enabled me to be more selective about XFS
trace points, I discovered that I could get just enough essential
tracepoints enabled that there was a 50:50 chance the fsx config
would fail at ~115k ops. If it didn't fail at op 115547, I stopped
fsx at op 115548 anyway.

That gave me two traces - one where the problem manifested, and one
where it didn't. After refining the traces to have the necessary
information, I found that in the failing case there was a real
extent in the COW fork compared to an unwritten extent in the
working case.

Walking back through the two traces to the point where the CWO fork
extents actually diverged, I found that the bad case had an extra
unwritten extent in it. This is likely because the bug it led me to
had triggered multiple times in those 115k ops, leaving stray
COW extents around. What I saw was a COW delalloc conversion to an
unwritten extent (as they should always be through
xfs_iomap_write_allocate()) resulted in a /written extent/:

xfs_writepage:        dev 259:0 ino 0x83 pgoff 0x17000 size 0x79a00 offset 0 length 0
xfs_iext_remove:      dev 259:0 ino 0x83 state RC|LF|RF|COW cur 0xffff888247b899c0/2 offset 32 block 152 count 20 flag 1 caller xfs_bmap_add_extent_delay_real
xfs_bmap_pre_update:  dev 259:0 ino 0x83 state RC|LF|RF|COW cur 0xffff888247b899c0/1 offset 1 block 4503599627239429 count 31 flag 0 caller xfs_bmap_add_extent_delay_real
xfs_bmap_post_update: dev 259:0 ino 0x83 state RC|LF|RF|COW cur 0xffff888247b899c0/1 offset 1 block 121 count 51 flag 0 caller xfs_bmap_add_ex

Basically, Cow fork before:

	0 1            32          52
	+H+DDDDDDDDDDDD+UUUUUUUUUUU+
	   PREV		RIGHT

COW delalloc conversion allocates:

	  1	       32
	  +uuuuuuuuuuuu+
	  NEW

And the result according to the xfs_bmap_post_update trace was:

	0 1            32          52
	+H+wwwwwwwwwwwwwwwwwwwwwwww+
	   PREV

Which is clearly wrong - it should be a merged unwritten extent,
not an unwritten extent.

That lead me to look at the LEFT_FILLING|RIGHT_FILLING|RIGHT_CONTIG
case in xfs_bmap_add_extent_delay_real(), and sure enough, there's
the bug.

It takes the old delalloc extent (PREV) and adds the length of the
RIGHT extent to it, takes the start block from NEW, removes the
RIGHT extent and then updates PREV with the new extent.

What it fails to do is update PREV.br_state. For delalloc, this is
always XFS_EXT_NORM, while in this case we are converting the
delayed allocation to unwritten, so it needs to be updated to
XFS_EXT_UNWRITTEN. This LF|RF|RC case does not do this, and so
the resultant extent is always written.

And that's the bug I've been chasing for a week - a bmap btree bug,
not a reflink/dedupe/copy_file_range bug, but a BMBT bug introduced
with the recent in core extent tree scalability enhancements.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a47670332326..3a496ffe6551 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1683,10 +1683,13 @@ xfs_bmap_add_extent_delay_real(
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
 		/*
 		 * Filling in all of a previously delayed allocation extent.
-		 * The right neighbor is contiguous, the left is not.
+		 * The right neighbor is contiguous, the left is not. Take care
+		 * with delay -> unwritten extent allocation here because the
+		 * delalloc record we are overwriting is always written.
 		 */
 		PREV.br_startblock = new->br_startblock;
 		PREV.br_blockcount += RIGHT.br_blockcount;
+		PREV.br_state = new->br_state;
 
 		xfs_iext_next(ifp, &bma->icur);
 		xfs_iext_remove(bma->ip, &bma->icur, state);
-- 
2.18.0
