Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 12 May 2007 06:52:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4CDpvfB012422
	for <xfs@oss.sgi.com>; Sat, 12 May 2007 06:51:59 -0700
Date: Sat, 12 May 2007 23:51:43 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an nlink problem?
Message-ID: <20070512135143.GG85884050@sgi.com>
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <46439185.5060207@redhat.com> <464392B4.3070009@goop.org> <464393E1.3050705@redhat.com> <46439491.9010604@goop.org> <Pine.LNX.4.61.0705121323030.9570@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705121323030.9570@yvahk01.tjqt.qr>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Chuck Ebbert <cebbert@redhat.com>, David Chinner <dgc@sgi.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com

On Sat, May 12, 2007 at 01:23:27PM +0200, Jan Engelhardt wrote:
> 
> On May 10 2007 14:54, Jeremy Fitzhardinge wrote:
> >>>> What CPU architecture is this happening on? Not i686 with PAE by
> >>>> any chance?
> >>>>       
> >>> Yes.  Why?
> >>
> >> I have a bug report where NFS files are corrupted only with PAE clients.
> >> Corruption is at the end of the (newly untarred) files. Doesn't happen
> >> without PAE.
> >
> >Hm, suggestive, but I'm not convinced.  Two differences to this situation:
> >
> >   1. Immediately after the clone ("untar"), the contents are completely
> >      OK; it's only after a umount/mount cycle to problems appear
> 
> And if you do a "sync" rather than umount/mount?

I doubt it will matter - I don't think we are marking the inode dirty at
the right point.

The change that was at fault modifies the way we update the file
size on the inode. We added an in-memory copy of the file size to
the in-memory copy of the disk inode's file size that we already
keep. We now only update the disk inode's (in memory copy) file size
on I/O completion. Because the generic code writes the inode out
before waiting for I/O to complete, the old file size gets written
out instead of the new one.

If the write was to extending the file into an existing block there
would be no delalloc transaction to redirty the inode (happens on
log I/O completion). Hence when the I/O completes and the file size
gets updated to the in-core disk inode (which is marked dirty), the
linux inode remains clean. As a result, a sync will never flush the
inode to get the updated file size to disk.

What I don't understand is that on unmount dirty xfs inodes get
written out. Clearly this is not happening - either there's a hole
in the writeback logic (unlikely - it was unchanged) or we've missed
some case where we need to update the filesize and mark the inode
dirty.

Hmmmm - if the write was just a short append to the file, then the
block that was written to should already be mapped. Then we'll just
look up the extent by doing a BMAPI_READ lookup, set the type to
IOMAP_READ and add the block to ioend we are building.

The type IOMAP_READ determines the I/O completion behaviour - in this case
it is xfs_end_bio_read(), which fails to update the file size....

Bingo.

A patch for you to try, Jeremy. I've just started a test run on it...

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
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c	2007-05-12 23:35:42.691464799 +1000
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
