Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Jun 2007 06:37:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5RDbRtL004756
	for <xfs@oss.sgi.com>; Wed, 27 Jun 2007 06:37:30 -0700
Date: Wed, 27 Jun 2007 23:36:57 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070627133657.GQ989688@sgi.com>
References: <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626231431.GO31489@sgi.com> <20070627034915.GR6652@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627034915.GR6652@schatzie.adilger.int>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com

On Tue, Jun 26, 2007 at 11:49:15PM -0400, Andreas Dilger wrote:
> On Jun 27, 2007  09:14 +1000, David Chinner wrote:
> > Someone on the XFs list had an interesting request - preallocated
> > swap files. You can't use unwritten extents for this because
> > of sys_swapon()s use of bmap() (XFS returns holes for reading
> > unwritten extents), so we need a method of preallocating that does
> > not zero or mark the extent unread. i.e. FA_MKSWAP.
> 
> Is there a reason why unwritten extents return 0 to bmap()?

It's a fallout of xfs_get_blocks not mapping unwritten extents
on read because we want do_mpage_readpage() to treat them
as a hole. i.e. zero fill them instead of doing I/O. This is
the way XFS was shoehorned into the generic read path :/

> This
> would seem to be the only impediment from using fallocated files
> for swap files.  Maybe if FIEMAP was used by mkswap to get an
> "UNWRITTEN" flag back instead of "HOLE" it wouldn't be a problem.

Probably. If we taught do_mpage_readpage() about unwritten mappings,
then would could map them on read if and then sys_swapon can remain
blissfully unaware of unwritten extents.

I think this is pretty much all I need to do to acheive that is
(untested):

---

Teach do_mpage_readpage() about unwritten extents so we can
always map them in get_blocks rather than they are are holes on
read. Allows setup_swap_extents() to use preallocated files on XFS
filesystems for swap files without ever needing to convert them.

Signed-Off-By: Dave Chinner <dgc@sgi.com>

---
 fs/mpage.c                  |    5 +++--
 fs/xfs/linux-2.6/xfs_aops.c |   13 +++----------
 2 files changed, 6 insertions(+), 12 deletions(-)

Index: 2.6.x-xfs-new/fs/mpage.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/mpage.c	2007-05-29 16:17:59.000000000 +1000
+++ 2.6.x-xfs-new/fs/mpage.c	2007-06-27 22:39:35.568852270 +1000
@@ -207,7 +207,8 @@ do_mpage_readpage(struct bio *bio, struc
 	 * Map blocks using the result from the previous get_blocks call first.
 	 */
 	nblocks = map_bh->b_size >> blkbits;
-	if (buffer_mapped(map_bh) && block_in_file > *first_logical_block &&
+	if (buffer_mapped(map_bh) && !buffer_unwritten(map_bh) &&
+			block_in_file > *first_logical_block &&
 			block_in_file < (*first_logical_block + nblocks)) {
 		unsigned map_offset = block_in_file - *first_logical_block;
 		unsigned last = nblocks - map_offset;
@@ -242,7 +243,7 @@ do_mpage_readpage(struct bio *bio, struc
 			*first_logical_block = block_in_file;
 		}
 
-		if (!buffer_mapped(map_bh)) {
+		if (!buffer_mapped(map_bh) || buffer_unwritten(map_bh)) {
 			fully_mapped = 0;
 			if (first_hole == blocks_per_page)
 				first_hole = page_block;
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-06-05 22:14:39.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c	2007-06-27 22:39:29.545636749 +1000
@@ -1340,16 +1340,9 @@ __xfs_get_blocks(
 		return 0;
 
 	if (iomap.iomap_bn != IOMAP_DADDR_NULL) {
-		/*
-		 * For unwritten extents do not report a disk address on
-		 * the read case (treat as if we're reading into a hole).
-		 */
-		if (create || !(iomap.iomap_flags & IOMAP_UNWRITTEN)) {
-			xfs_map_buffer(bh_result, &iomap, offset,
-				       inode->i_blkbits);
-		}
-		if (create && (iomap.iomap_flags & IOMAP_UNWRITTEN)) {
-			if (direct)
+		xfs_map_buffer(bh_result, &iomap, offset, inode->i_blkbits);
+		if (iomap.iomap_flags & IOMAP_UNWRITTEN) {
+			if (create && direct)
 				bh_result->b_private = inode;
 			set_buffer_unwritten(bh_result);
 		}


Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
