Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E00A87F4E
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2014 20:47:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C7D148F8039
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2014 18:47:39 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	itmsjHbhcKAv7Hkn for <xfs@oss.sgi.com>;
	Sun, 14 Sep 2014 18:47:09 -0700 (PDT)
Date: Mon, 15 Sep 2014 11:46:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/5] clean up collapse range and handle post-eof
	delalloc
Message-ID: <20140915014654.GD4267@dastard>
References: <1410355231-50495-1-git-send-email-bfoster@redhat.com>
	<20140911044243.GA10111@dastard>
	<20140911152012.GB54638@bfoster.bfoster>
	<20140911211915.GA4322@dastard>
	<20140912195128.GA42029@bfoster.bfoster>
	<20140912200536.GB42029@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140912200536.GB42029@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Sep 12, 2014 at 04:05:36PM -0400, Brian Foster wrote:
> On Fri, Sep 12, 2014 at 03:51:29PM -0400, Brian Foster wrote:
> > On Fri, Sep 12, 2014 at 07:19:15AM +1000, Dave Chinner wrote:
> > > On Thu, Sep 11, 2014 at 11:20:13AM -0400, Brian Foster wrote:
> > > > On Thu, Sep 11, 2014 at 02:42:43PM +1000, Dave Chinner wrote:
> > > > > On Wed, Sep 10, 2014 at 09:20:26AM -0400, Brian Foster wrote:
> > > > > > Hi all,
> > > > > > 
> > > > > > Here's v2 of the collapse clean up. We refactor a bit more via the
> > > > > > insertion of patch 3, otherwise it's similar to v1. This will see some
> > > > > > continued testing, but it survived ~500m fsx operations overnight.
> > > > > > 
> > > > > > Brian
> > > > > 
> > > > > I'm not sure about the invalidation patch now. On a 1k block size
> > > > > filesystem, generic/127 fails with:
> > > > > 
> > > > >     +ltp/fsx -q -l 262144 -o 65536 -S 191110531 -N 100000 -R -W fsx_std_nommap
> > > > >     +collapse range: 1000 to 3000
> > > > >     +do_collapse_range: fallocate: Device or resource busy
> > > > > 
> > > > > which indicates we had an invalidation failure. This is probably
> > > > > exposing some other bug, but I haven't had time to look into it yet
> > > > > so I don't know.

....

> > > It's likely that it is leaving a dirty buffer on the page beyond EOF
> > > as a result of the truncate zeroing the remainder of the page in
> > > memory.
.....

> ... and it just hit me that truncate dirties the buffer. ;)

Exactly. ;)

> So I'm
> wondering if we have something like the following sequence of events for
> this particular page:
> 
> - first pwrite writes to complete page
> - first collapse:

xfs_collapse_file_space: dev 7:0 ino 0x43

> 	- flush

xfs_map_blocks_alloc: dev 7:0 ino 0x43 size 0x0 offset 0x2d000 count 1024 type  startoff 0xb4 startblock 32 blockcount 0x38
xfs_extlist:          dev 7:0 ino 0x43 state  idx 0 offset 180 block 32 count 56 flag 0 caller xfs_iextents_copy

> 	- invalidate

xfs_releasepage:      dev 7:0 ino 0x43 pgoff 0x2d000 size 0x3adc0 offset 0 length 0 delalloc 0 unwritten 0
....
xfs_releasepage:      dev 7:0 ino 0x43 pgoff 0x3a000 size 0x3adc0 offset 0 length 0 delalloc 0 unwritten 0

> 	- truncate -> dirty last buffer of page

xfs_setattr:          dev 7:0 ino 0x43
....
xfs_invalidatepage:   dev 7:0 ino 0x43 pgoff 0x30000 size 0x30dc0 offset dc0 length 240 delalloc 0 unwritten 0
....
xfs_itruncate_extents_start: dev 7:0 ino 0x43 size 0x30dc0 new_size 0x30dc0
xfs_extlist:          dev 7:0 ino 0x43 state  idx 0 offset 140 block 32 count 56 flag 0 caller xfs_iextents_copy

And so we have truncate dirtying the last buffer in the page (the
offset/len indicated by the xfs_invalidatepage tracepoint).

> - second pwrite writes to first buffer in page (dirty first buffer)
> 	- flush
> 		- xfs_convert_page() hits the first buffer, breaks out
> 		  and causes the last buffer to be passed over due to
> 		  the issue below
> 	- invalidate
> 		- finds dirty buffer, error!
> 
> Brian
> 
> > Brian
> > 
> > P.S., As a datapoint from experimentation, this problem doesn't occur if
> > I ensure that writepage() handles this particular page rather than
> > xfs_convert_page(). I can do that by either jumping out of
> > xfs_convert_page() sooner, before the page is set for writeback, or
> > hacking xfs_start_page_writeback() to use __test_set_page_writeback()
> > and keep the write tag such that write_cache_pages() can still find the
> > page.

writepage is still supposed to find the page again, because we
haven't fully cleaned it. Indeed, the code used to come back and
write this page because it was still dirty and the
write_cache_pages() iteration would then see it and write it again
because it is dirty.

> > This calls out an interesting bit of behavior in
> > xfs_convert_page() since commit a49935f2: if we handle a part of a
> > page, break and mark the page for writeback without handling the rest,
> > we'll still clear the PAGECACHE_TAG_TOWRITE tag and writeback won't
> > finish off the page during the current iteration (for WB_SYNC_ALL).

Right, commit a49935f2 made the assumption that the page being left
dirty was sufficient to have the page written as the current
writeback sweep went past it. That *used* to be the way the generic
writeback code worked.

And this is instructive: this same assumption was found in ext4 back
in May i.e. commit 1c8349a ("ext4: fix data integrity sync in
ordered mode") and that introduced the new functions like
__test_set_page_writeback(). That fix wasn't cc'd to linux-fsdevel
which might have got our attention and so noticed the bug earlier...

> > It's not clear to me if this is contributing to the problem in this
> > particular case, but it seems like an independent bug at the very
> > least. Thoughts?

We definitely need to use set_page_writeback_keepwrite() for partial
page writes that leave the page dirty. Patch below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: ensure WB_SYNC_ALL writeback handles partial pages correctly

From: Dave Chinner <dchinner@redhat.com>

XFS has been having trouble with stray delayed allocation extents
beyond EOF for a long time. Recent changes to the collapse range
code has triggered erroneous EBUSY errors on page invalidtion for
block size smaller than page size filesystems. These
have been caused by dirty buffers beyond EOF on a partial page which
do not get written to disk during a sync.

The issue is that write-ahead in xfs_cluster_write() finds such a
partial page and handles it by leaving the page dirty but pushing it
into a writeback state. This used to work just fine, as the
write_cache_pages() code would then find the dirty partial page in
the next mapping tree lookup as the dirty tag is still set.

Unfortunately, when we moved to a mark and sweep approach to
writeback to fix other writeback sync issues, we broken this. THe
act of marking the page as under writeback now clears the TOWRITE
tag in the radix tree, even though the page is still dirty. This
causes the TOWRITE tag to be cleared, and hence the next lookup on
the mapping tree does not find the dirty partial page and so doesn't
try to write it again.

This same writeback bug was found recently in ext4 and fixed in
commit 1c8349a ("ext4: fix data integrity sync in ordered mode")
without communication to the wider filesystem community. We can use
exactly the same fix here so the TOWRITE flag is not cleared on
partial page writes.

cc: stable@vger.kernel.org # dependent on 1c8349a17137b93f0a83f276c764a6df1b9a116e
Root-cause-found-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index b984647..2f50253 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -434,10 +434,22 @@ xfs_start_page_writeback(
 {
 	ASSERT(PageLocked(page));
 	ASSERT(!PageWriteback(page));
-	if (clear_dirty)
+
+	/*
+	 * if the page was not fully cleaned, we need to ensure that the higher
+	 * layers come back to it correctly. That means we need to keep the page
+	 * dirty, and for WB_SYNC_ALL writeback we need to ensure the
+	 * PAGECACHE_TAG_TOWRITE index mark is not removed so another attempt to
+	 * write this page in this writeback sweep will be made.
+	 */
+	if (clear_dirty) {
 		clear_page_dirty_for_io(page);
-	set_page_writeback(page);
+		set_page_writeback(page);
+	} else
+		set_page_writeback_keepwrite(page);
+
 	unlock_page(page);
+
 	/* If no buffers on the page are to be written, finish it here */
 	if (!buffers)
 		end_page_writeback(page);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
