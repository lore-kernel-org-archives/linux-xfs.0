Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54714 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752066AbdKAMGt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Nov 2017 08:06:49 -0400
Date: Wed, 1 Nov 2017 20:06:47 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfs: flush the range before zero partial block range on
 truncate down
Message-ID: <20171101120647.GR17339@eguan.usersys.redhat.com>
References: <20171027125328.25001-1-eguan@redhat.com>
 <20171031225804.GF5858@dastard>
 <20171101034639.GP17339@eguan.usersys.redhat.com>
 <20171101044451.GO5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171101044451.GO5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 01, 2017 at 03:44:51PM +1100, Dave Chinner wrote:
> On Wed, Nov 01, 2017 at 11:46:39AM +0800, Eryu Guan wrote:
> > On Wed, Nov 01, 2017 at 09:58:04AM +1100, Dave Chinner wrote:
> > > On Fri, Oct 27, 2017 at 08:53:28PM +0800, Eryu Guan wrote:
> > > > On truncate down, if new size is not block size aligned, we zero the
> > > > rest of block via iomap_truncate_page() to avoid exposing stale data
> > > > to user, and iomap_truncate_page() skips zeroing if the range is
> > > > already in unwritten status or a hole.
> > > 
> > > Unless the page is in the page cache already, and then it gets
> > > zeroed in memory as part of truncate_setsize() call.
> > > 
> > > > But it's possible that a buffer write overwrites the unwritten
> > > > extent, which won't be converted to a normal extent until I/O
> > > > completion, and iomap_truncate_page() skips zeroing wrongly because
> > > > of the not-converted unwritten extent. This would cause a subsequent
> > > > mmap read sees non-zeros beyond EOF.
> > > 
> > > Yes, it should skip the zeroing on disk. The page in the page cache
> > > over the unwritten extent will be zeroed on read.
> > > 
> > > The real question is this: where are the zeros in the page that fsx
> > > is complaining about?
> > 
> > The partial block that iomap_truncate_page() skipped zeroing was latter
> > written back to disk, and the punch_hole before mmap read invalidated
> > the page cache so mmap read from disk and saw non-zeros.  This is a
> > hard-to-hit sequence, it took me almost 2000 iterations of generic/112
> > runs to hit one failure. I'll provide more details below.
> 
> Oh, ok, so they weren't close together operations but far apart in
> the trace. I usually indicate that by showing [....] lines between
> the operations if there's stuff that occurred between them.

They are not strictly one-by-one operations in the original fsxops log,
but are close enough. Then I tailored the ops into a minimal
step-by-step reproducer.

> 
> > > > simplified fsx operation sequence is like (assuming 4k block size
> > > > xfs):
> > > 
> > > What should have is:
> > > 
> > > >   fallocate 0x0 0x1000 0x0 keep_size
> > > 
> > > Unwritten, no data.
> > 
> > Yes, assuming 4k block size and 4k page size, unwritten extent with 1
> > block allocated, i_size stays 0.
> > 
> > > 
> > > >   write 0x0 0x1000 0x0
> > > 
> > > Unwritten, contains data in page cache.
> > 
> > Exactly, and in-core i_size is 4k now, but on-disk di_size is still 0.
> > 
> > > 
> > > >   truncate 0x0 0x800 0x1000
> > > 
> > > Unwritten, page contains data 0-0x800, zeros 0x800-0x1000
> > 
> > Yes, the page cache after truncate is correct. But before we zero the
> > page cache (in truncate_setsize()), we skipped zeroing the partial block
> > range 0x800-0x1000 and then triggered a writeback on range
> > [di_size, newsize], which was 0-0x800, and 0x800-0x1000 was written back
> > to disk too, which contained non-zeros.
> > 
> > (newsize(2k) > di_size(0) && oldsize(4k) != di_size(0)) was true.
> > 
> >         if (did_zeroing ||
> >             (newsize > ip->i_d.di_size && oldsize != ip->i_d.di_size)) {
> >                 error = filemap_write_and_wait_range(mapping, ip->i_d.di_size,
> >                                                         newsize - 1);
> >                 if (error)
> >                         return error;
> >         }
> 
> Ok, so we're writing data between di_size and newsize before
> removing the page cache beyond newsize. As such, the page of data
> that newsize lies in has not been zeroed by page cache invalidation
> before it is written.
> 
> Ok, that explains why the EOF page zeroing in xfs_do_writepage()
> isn't catching this - we haven't updated the inode size yet.
> 
> IOWs, the /three places/ where we normally catch this and zero the
> partial tail page beyond EOF are not doing it because:
> 
> 	1. iomap_truncate_page() sees unwritten and skips.
> 	2. truncate_setsize() has not yet been called so can't
> 	   zero the tail of the page.
> 	3. we haven't changed where EOF is yet, so
> 	   xfs_do_writepage() hasn't triggered it's "zero data
> 	   beyond EOF" case before it sends the page to disk. 
> 
> So, we have three options here:
> 
> 	1. iomap_truncate_page() always zeros
> 	2. update inode size before writeback after zeroing so the
> 	   xfs_do_writepage() zeros the tail page, or
> 	3. move truncate_setsize() to before writeback so the page
> 	   cache invalidation zeros the part page at the new EOF.

This really helps summarize the problem and solution, thanks!

Yeah, I started to realize moving the order of writeback vs setsize
around might be a fix when I was writing my last reply - explaining the
problem to someone else really helps understand the problem itself :)

> 
> I think 1) is a no-go for performance reasons. 2) is better, but
> I don't like the idea of separating the page cache invalidation
> from the size truncation. That leaves 3) - moving
> truncate_setsize().
> 
> I think I prefer 3) because it triggers multiple layers of defense
> against writing stale data past EOF, and from an crash behaviour
> point of view it makes no difference whether we truncate the page
> cache before or after triggering writeback because it will just make
> the result the same as if we were zeroing a written extent....

I'm testing an updated patch based on option 3 now, the finished tests
look good. I'll send the new version out for review soon. Thanks a lot
for the suggestion and review!

Eryu
