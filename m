Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 May 2007 18:03:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4M13TfB002595
	for <xfs@oss.sgi.com>; Mon, 21 May 2007 18:03:31 -0700
Date: Tue, 22 May 2007 11:03:26 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: ensure EOF writes into existing extents update filesize
Message-ID: <20070522010326.GN85884050@sgi.com>
References: <20070520233417.GA85884050@sgi.com> <738172E9F9634F7FC01B5B3C@timothy-shimmins-power-mac-g5.local> <20070522004414.GL85884050@sgi.com> <1179795779.6273.510.camel@edge>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179795779.6273.510.camel@edge>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: David Chinner <dgc@sgi.com>, Timothy Shimmin <tes@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, May 22, 2007 at 11:02:59AM +1000, Nathan Scott wrote:
> On Tue, 2007-05-22 at 10:44 +1000, David Chinner wrote:
> > On Mon, May 21, 2007 at 04:34:26PM +1000, Timothy Shimmin wrote:
> > I guess I need to ping Christoph and Nathan on this one....
> 
> Could you resend the patch to me please?  I lost the previous copy
> while ruthlessly ploughing through my mail backlog.  ;)

Below.

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
