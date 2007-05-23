Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 May 2007 17:02:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4N02HWt029771
	for <xfs@oss.sgi.com>; Tue, 22 May 2007 17:02:19 -0700
Date: Wed, 23 May 2007 10:02:13 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: ensure EOF writes into existing extents update filesize
Message-ID: <20070523000213.GS86004887@sgi.com>
References: <20070520233417.GA85884050@sgi.com> <738172E9F9634F7FC01B5B3C@timothy-shimmins-power-mac-g5.local> <20070522004414.GL85884050@sgi.com> <1179795779.6273.510.camel@edge> <20070522010326.GN85884050@sgi.com> <1179807014.6273.519.camel@edge> <20070522060559.GI86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522060559.GI86004887@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Nathan Scott <nscott@aconex.com>, Timothy Shimmin <tes@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, May 22, 2007 at 04:05:59PM +1000, David Chinner wrote:
> On Tue, May 22, 2007 at 02:10:14PM +1000, Nathan Scott wrote:
> > On Tue, 2007-05-22 at 11:03 +1000, David Chinner wrote:
> > > On Tue, May 22, 2007 at 11:02:59AM +1000, Nathan Scott wrote:
> > > > On Tue, 2007-05-22 at 10:44 +1000, David Chinner wrote:
> > > > > On Mon, May 21, 2007 at 04:34:26PM +1000, Timothy Shimmin wrote:
> > > > > I guess I need to ping Christoph and Nathan on this one....
> > > > 
> > > > Could you resend the patch to me please?  I lost the previous copy
> > > > while ruthlessly ploughing through my mail backlog.  ;)
> > > 
> > > Below.
> > 
> > Looks pretty good to me - xfs_convert_page has been overlooked, I
> > think - attached patch fixes that.
....
> I'll make the change anyway to be safe, but I'm still perplexed
> as to why it doesn't seem necessary....
> 
> Ah - there it is - xfs_is_delayed_page():
> 
>     699                         if (buffer_unwritten(bh))
>     700                                 acceptable = (type == IOMAP_UNWRITTEN);
>     701                         else if (buffer_delay(bh))
>     702                                 acceptable = (type == IOMAP_DELAY);
>     703                         else if (buffer_dirty(bh) && buffer_mapped(bh))
>     704     >>>>>>>>>>>                 acceptable = (type == 0);
>     705                         else
>     706                                 break;
> 
> The ioend we started with now has type = IOMAP_NEW = 0x40 which 
> means xfs_convert_page() aborts clustering this case immediately.
> IOWs, we are never getting to this xfs_convert_page() case and
> we are only passing through xfs_page_state_convert for mapped
> pages.
> 
> > You also initialise iomap_valid
> > twice inside xfs_page_state_convert now ... I reverted that to just
> > the once.
> 
> I'll fold these changes in and fixup xfs_is_delayed_page() to look
> for type == IOMAP_NEW and send out a new patch. Thanks, Nathan.

Patch below, Nathan. It's passed my point tests and XFSQA...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/linux-2.6/xfs_aops.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-05-21 17:49:01.603432320 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c	2007-05-22 16:07:36.787017461 +1000
@@ -706,7 +706,7 @@ xfs_is_delayed_page(
 			else if (buffer_delay(bh))
 				acceptable = (type == IOMAP_DELAY);
 			else if (buffer_dirty(bh) && buffer_mapped(bh))
-				acceptable = (type == 0);
+				acceptable = (type == IOMAP_NEW);
 			else
 				break;
 		} while ((bh = bh->b_this_page) != head);
@@ -815,7 +815,7 @@ xfs_convert_page(
 			page_dirty--;
 			count++;
 		} else {
-			type = 0;
+			type = IOMAP_NEW;
 			if (buffer_mapped(bh) && all_bh && startio) {
 				lock_buffer(bh);
 				xfs_add_to_ioend(inode, bh, offset,
@@ -973,8 +973,8 @@ xfs_page_state_convert(
 
 	bh = head = page_buffers(page);
 	offset = page_offset(page);
-	flags = -1;
-	type = IOMAP_READ;
+	flags = BMAPI_READ;
+	type = IOMAP_NEW;
 
 	/* TODO: cleanup count and page_dirty */
 
@@ -1004,14 +1004,14 @@ xfs_page_state_convert(
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
@@ -1060,7 +1060,7 @@ xfs_page_state_convert(
 			 * That means it must already have extents allocated
 			 * underneath it. Map the extent by reading it.
 			 */
-			if (!iomap_valid || type != IOMAP_READ) {
+			if (!iomap_valid || flags != BMAPI_READ) {
 				flags = BMAPI_READ;
 				size = xfs_probe_cluster(inode, page, bh,
 								head, 1);
@@ -1071,7 +1071,15 @@ xfs_page_state_convert(
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
