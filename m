Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 495C47F51
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 17:33:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BD3DCAC002
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 15:33:38 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	GvtenVvhjB46lvgF for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 15:33:35 -0700 (PDT)
Date: Fri, 22 Aug 2014 08:33:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] xfs: mmap write/read leaves bad state on pages
Message-ID: <20140821223332.GO26465@dastard>
References: <1408597754-13526-1-git-send-email-david@fromorbit.com>
	<1408597754-13526-2-git-send-email-david@fromorbit.com>
	<20140821195632.GA10335@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140821195632.GA10335@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: clm@fb.com, xfs@oss.sgi.com

On Thu, Aug 21, 2014 at 09:56:32PM +0200, Jan Kara wrote:
> On Thu 21-08-14 15:09:09, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > generic/263 is failing fsx at this point with a page spanning
> > EOF that cannot be invalidated. The operations are:
> > 
> > 1190 mapwrite   0x52c00 thru    0x5e569 (0xb96a bytes)
> > 1191 mapread    0x5c000 thru    0x5d636 (0x1637 bytes)
> > 1192 write      0x5b600 thru    0x771ff (0x1bc00 bytes)
> > 
> > where 1190 extents EOF from 0x54000 to 0x5e569. When the direct IO
> > write attempts to invalidate the cached page over this range, it
> > fails with -EBUSY and so we fire this assert:
> > 
> > XFS: Assertion failed: ret < 0 || ret == count, file: fs/xfs/xfs_file.c, line: 676
> > 
> > because the kernel is trying to fall back to buffered IO on the
> > direct IO path (which XFS does not do).
> > 
> > The real question is this: Why can't that page be invalidated after
> > it has been written to disk an cleaned?
> > 
> > Well, there's data on the first two buffers in the page (1k block
> > size, 4k page), but the third buffer on the page (i.e. beyond EOF)
> > is failing drop_buffers because it's bh->b_state == 0x3, which is
> > BH_Uptodate | BH_Dirty.  IOWs, there's dirty buffers beyond EOF. Say
> > what?
> > 
> > OK, set_buffer_dirty() is called on all buffers from
> > __set_page_buffers_dirty(), regardless of whether the buffer is
> > beyond EOF or not, which means that when we get to ->writepage,
> > we have buffers marked dirty beyond EOF that we need to clean.
> > So, we need to implement our own .set_page_dirty method that
> > doesn't dirty buffers beyond EOF.
> > 
> > This is messy because the buffer code is not meant to be shared
> > and it has interesting locking issues on the buffer dirty bits.
> > So just copy and paste it and then modify it to suit what we need.
>   Well, I'm not sure this is the cleanest way to fix your problem. The
> thing is that inode size can change (decrease) after set_page_dirty() has
> run and writeback can find the page before truncate_inode_pages() calls
> do_invalidatepage() on the last partial page.  Now I agree that given
> truncate and direct IO are both synchronized using IOLOCK, this change
> still fixes your problem. I just wanted to point out that your change
> doesn't really make sure won't see dirty buffers in a tail page beyond
> i_size.

Truncate is not the problem.  The issue is that we can't
*invalidate* pages that have dirty buffers, and I soon realised that
we don't see this problem with truncate because *truncate ignores
invalidation failures*. So now I went looking for how other code
handled this.

> As Anton has pointed out other filesystems solve the same issue by clearing
> the dirty bits beyond EOF in their writepage() function. Also since we
> zero-out the tail of the page in writepage() (even in XFS as I checked),
> this kind of makes sense to me and has smaller overhead than special
> set_page_dirty()...

Yes, and that's where I started - block_write_full_page and so
I ended up with this first:

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 2a316ad..a9d6afc 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1057,8 +1073,24 @@ xfs_vm_writepage(
 	do {
 		int new_ioend = 0;
 
-		if (offset >= end_offset)
+		/*
+		 * If the buffer is fully beyond EOF, we need to mark it clean
+		 * otherwise we'll leave stale dirty buffers in memory. See the
+		 * comment above in the EOF handling about Charlie Foxtrots.
+		 */
+		if (offset >= end_offset) {
+			clear_buffer_dirty(bh);
+			ASSERT(!buffer_delay(bh));
+			ASSERT(!buffer_mapped(bh));
+
+			/*
+			 * Page is not uptodate until buffers under IO have been
+			 * fully processed.
+			 */
+			uptodate = 0;
+			continue;
-			break;
+		}
+
 		if (!buffer_uptodate(bh))
 			uptodate = 0;
 

But this doesn't solve the invalidation failures - it merely covers
up a symptom of the underlying problem. i.e. fsx went from
failing invalidate on the EOF page at operation #1192 to failing
invalidate on the EOF page at operation #9378.

The I realised that flush/wait/invalidate is actually racy against
mmap, so writepage clearing dirty buffer flags on buffers beyond EOF
is not a solution to the problem - it can still occur. So I added
this check to releasepage() to catch stale dirty buffers beyond EOF
preventing invalidation from succeeding:

@@ -1209,9 +1245,16 @@ xfs_vm_writepages(
 
 /*
  * Called to move a page into cleanable state - and from there
- * to be released. The page should already be clean. We always
+ * to be released. We always
  * have buffer heads in this call.
  *
+ * The page should already be clean, except in the case where EOF falls within
+ * the page and then we can have dirty buffers beyond EOF that nobody can
+ * actually clean. These dirty buffers will cause invalidation failures, but
+ * because they can't be written the should not prevent us from tossing the page
+ * out of cache. Hence if we span EOF, walk the buffers on the page and make
+ * sure they are in a state where try_to_free_buffers() will succeed.
+ *
  * Returns 1 if the page is ok to release, 0 otherwise.
  */
 STATIC int
@@ -1219,7 +1262,10 @@ xfs_vm_releasepage(
 	struct page		*page,
 	gfp_t			gfp_mask)
 {
+	struct inode		*inode = page->mapping->host;
 	int			delalloc, unwritten;
+	loff_t			end_offset, offset;
+	pgoff_t                 end_index;
 
 	trace_xfs_releasepage(page->mapping->host, page, 0, 0);
 
@@ -1230,5 +1276,21 @@ xfs_vm_releasepage(
 	if (WARN_ON_ONCE(unwritten))
 		return 0;
 
+	end_offset = i_size_read(inode);
+	end_index = end_offset >> PAGE_CACHE_SHIFT;
+	if (page->index >= end_index) {
+		struct buffer_head *head = page_buffers(page);
+		struct buffer_head *bh;
+
+		offset = end_index << PAGE_CACHE_SHIFT;
+		bh = head;
+		do {
+			if (offset > end_offset)
+				clear_buffer_dirty(bh);
+			bh = bh->b_this_page;
+			offset += 1 << inode->i_blkbits;
+		} while (bh != head);
+	}
+
 	return try_to_free_buffers(page);
 }

Which then moved the fsx invalidation failure out to somewhere
around 105,000 operations.

At which point I realised that I'm playing whack-a-mole with a
fundamental problem: buffers beyond EOF cannot be written, so
dirtying them in the first place is just fundamentally wrong. In XFS we'll
zero them on disk during an extend operation (either in write,
truncate or prealloc), so we're not going to leaak stale data by not
marking them dirty.  They may not even be allocated, so we can't
assume that we can write them. So, rather than trying to handle this
dirty-buffers-beyond-EOF case in every situation where we might trip
over it, let's just prevent it from happening in the first place.

That's where the .set_page_dirty() method came about. The "mmap
dirties buffers beyond the EOF" problem is gone. Now, truncate might
have a similar problem with leaving dirty buffers beyond EOF as you
suggest, but I just can't seem to trip over that problem and it
hasn't shown up in the ~500 million fsx ops and ~30 hours of
fsstress that I've run in the past few days. So without being able
to reproduce a problem, I'm extremely wary of trying to "fix" it.

Quite frankly, preventing data corruption is far, far more important
than optimisation and efficiency....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
