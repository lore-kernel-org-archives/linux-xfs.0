Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 May 2007 16:34:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4KNYNfB026748
	for <xfs@oss.sgi.com>; Sun, 20 May 2007 16:34:25 -0700
Date: Mon, 21 May 2007 09:34:17 +1000
From: David Chinner <dgc@sgi.com>
Subject: Review: ensure EOF writes into existing extents update filesize
Message-ID: <20070520233417.GA85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


As reported a coupl eof times on lkml since the 2.6.22 window opened,
XFS is not updating the file size corectly in all cases. This is a
result of the null files fix not updating the file size when the
write extending the file does not need to allocate a block.

In that case, we use a read mapping of the extent, and this also
happens to use the read I/O completion handler instead of the
write I/O completion handle. Hence the file size was not updated
on I/O completion.

Comments?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/linux-2.6/xfs_aops.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-05-11 16:03:59.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c	2007-05-12 23:46:54.379994052 +1000
@@ -973,8 +973,9 @@ xfs_page_state_convert(
 
 	bh = head = page_buffers(page);
 	offset = page_offset(page);
-	flags = -1;
-	type = IOMAP_READ;
+	iomap_valid = 0;
+	flags = BMAPI_READ;
+	type = IOMAP_NEW;
 
 	/* TODO: cleanup count and page_dirty */
 
@@ -1004,14 +1005,14 @@ xfs_page_state_convert(
 		 *
 		 * Third case, an unmapped buffer was found, and we are
 		 * in a path where we need to write the whole page out.
- 		 */
+		 */
 		if (buffer_unwritten(bh) || buffer_delay(bh) ||
 		    ((buffer_uptodate(bh) || PageUptodate(page)) &&
 		     !buffer_mapped(bh) && (unmapped || startio))) {
-		     	/*
+			/*
 			 * Make sure we don't use a read-only iomap
 			 */
-		     	if (flags == BMAPI_READ)
+			if (flags == BMAPI_READ)
 				iomap_valid = 0;
 
 			if (buffer_unwritten(bh)) {
@@ -1060,7 +1061,7 @@ xfs_page_state_convert(
 			 * That means it must already have extents allocated
 			 * underneath it. Map the extent by reading it.
 			 */
-			if (!iomap_valid || type != IOMAP_READ) {
+			if (!iomap_valid || flags != BMAPI_READ) {
 				flags = BMAPI_READ;
 				size = xfs_probe_cluster(inode, page, bh,
 								head, 1);
@@ -1071,7 +1072,15 @@ xfs_page_state_convert(
 				iomap_valid = xfs_iomap_valid(&iomap, offset);
 			}
 
-			type = IOMAP_READ;
+			/*
+			 * We set the type to IOMAP_NEW in case we are doing a
+			 * small write at EOF that is extending the file but
+			 * without needing an allocation. We need to update the
+			 * file size on I/O completion in this case so it is
+			 * the same case as having just allocated a new extent
+			 * that we are writing into for the first time.
+			 */
+			type = IOMAP_NEW;
 			if (!test_and_set_bit(BH_Lock, &bh->b_state)) {
 				ASSERT(buffer_mapped(bh));
 				if (iomap_valid)
