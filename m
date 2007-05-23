Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 May 2007 02:21:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4N9L9Wt030426
	for <xfs@oss.sgi.com>; Wed, 23 May 2007 02:21:12 -0700
Date: Wed, 23 May 2007 19:21:03 +1000
From: David Chinner <dgc@sgi.com>
Subject: Review - writing to multiple non-contiguous unwritten extents within a page is broken.
Message-ID: <20070523092103.GT85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

[Nathan - probably another one for you]

This test run on ia64 (16k page size) on a 4k block size filesystem:

#!/bin/bash

file=$1
rm -f $file

xfs_io -f \
-c "truncate 1048576" \
-c "resvsp 1032192 16384" \
-c "pwrite 1033216 2560" \
-c "pwrite 1040384 8192" \
-c "bmap -vvp" \
-c "fsync" \
-c "bmap -vvp" \
-c "close" \
$file

Which writes 3 unwritten blocks in a page (first block and last 2)
results in a corrupted write.

The problem is that the second block on teh page is uninitialised
and so is skipped by xfs_page_state_convert. The problem is that the
xfs_ioend structures are not getting created correctly.

When we skip the uninitialised block, we add the second unwritten block
we are writing to into the original ioend. While this results in
the correct I/O being sent to disk, it results in a ioend with a
start offset of 0 and a length of 3 blocks. When we do unwritten
extent conversion based on this range, we convert the wrong blocks.

What we need to be doing is creating two xfs_ioend structures, one
for the first block and one for the second set of blocks in the page.
That way we get two separate I/O completion events and convert the
ranges separately and correctly.

I've checked xfs_convert_page(), and I don't think it needs any
fix here - it already appears to force multiple ioends to be used in this
case...

Thoughts?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/linux-2.6/xfs_aops.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-05-23 16:33:04.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c	2007-05-23 17:52:15.540456674 +1000
@@ -1008,6 +1008,8 @@ xfs_page_state_convert(
 		if (buffer_unwritten(bh) || buffer_delay(bh) ||
 		    ((buffer_uptodate(bh) || PageUptodate(page)) &&
 		     !buffer_mapped(bh) && (unmapped || startio))) {
+			int new_ioend = 0;
+
 			/*
 			 * Make sure we don't use a read-only iomap
 			 */
@@ -1026,6 +1028,15 @@ xfs_page_state_convert(
 			}
 
 			if (!iomap_valid) {
+				/*
+				 * if we didn't have a valid mapping then we
+				 * need to ensure that we put the new mapping
+				 * in a new ioend structure. This needs to be
+				 * done to ensure that the ioends correctly
+				 * reflect the block mappings at io completion
+				 * for unwritten extent conversion.
+				 */
+				new_ioend = 1;
 				if (type == IOMAP_NEW) {
 					size = xfs_probe_cluster(inode,
 							page, bh, head, 0);
@@ -1045,7 +1056,7 @@ xfs_page_state_convert(
 				if (startio) {
 					xfs_add_to_ioend(inode, bh, offset,
 							type, &ioend,
-							!iomap_valid);
+							new_ioend);
 				} else {
 					set_buffer_dirty(bh);
 					unlock_buffer(bh);
