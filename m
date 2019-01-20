Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56698 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730536AbfATMpF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 20 Jan 2019 07:45:05 -0500
Date: Sun, 20 Jan 2019 07:45:02 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 5/5] xfs: revalidate imap properly before writeback
 delalloc conversion
Message-ID: <20190120124502.GA65044@bfoster>
References: <20190117192004.49346-1-bfoster@redhat.com>
 <20190117192004.49346-6-bfoster@redhat.com>
 <20190118115937.GD7807@infradead.org>
 <20190118163132.GA6318@infradead.org>
 <20190118183915.GB53532@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190118183915.GB53532@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 18, 2019 at 01:39:15PM -0500, Brian Foster wrote:
> On Fri, Jan 18, 2019 at 08:31:32AM -0800, Christoph Hellwig wrote:
> > On Fri, Jan 18, 2019 at 03:59:37AM -0800, Christoph Hellwig wrote:
> > > xfs_bmapi_write will always do a xfs_iext_lookup_extent for the
> > > passed in blocks anyway.  So this trimming logic should move into
> > > xfs_bmapi_write to ensure it does the right thing, instead of papering
> > > over the logic in xfs_bmapi_write in the caller with another lookup.
> > > 
> > > I think the improved XFS_BMAPI_DELALLOC handling in this patch:
> > > 
> > >    http://git.infradead.org/users/hch/xfs.git/commitdiff/553fed9ce7695df081779c6a9a205af4142b2a06
> > > 
> > > is the right answer, as writeback really should only ever convert
> > > existing delalloc extents, and I'd much rather rely on that rather than
> > > piling hacks of hacks to feed the right range into a function that must
> > > do a lookup in the extent tree anyway.
> > 
> > FYI, here is a tree that rebases my patches on top of your (minus this
> > one) and also drops the internal i_size checks, although it still keeps
> > the initial one for the truncate fast path.  Testing is still ongoing,
> > and for the writeback issue you probably only need the first three
> > of my patches:
> > 
> > 	http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-mapping-validation
> 
> This doesn't really seem all that different to me. Rather than firm up
> the range in the caller, we turn XFS_BMAPI_DELALLOC into something that
> seemingly behaves a bit more like CONVERT_ONLY.
> 
> A few notes/thoughts:
> 
> 1. What's the purpose of the nimaps == 0 check in
> xfs_iomap_write_allocate()? If we got to this point with the page lock
> held, shouldn't we always expect to find something backing the current
> page?
> 
> 2. If so, then it also seems that the whole "eof:" thing in
> xfs_map_blocks() should never happen for data forks. If that's the case,
> the use of the eof label there seems gratuitous.
> 
> 3. If the starting bno param to xfs_bmapi_write() lands in a hole (due
> to racing with a hole punch for example) and it finds some subsequent
> delalloc extent to convert in the requested range, the arithmetic in
> xfs_bmapi_trim_map() actually fabricates physical blocks for the hole
> portion of the range relative to the startblock of the converted
> delalloc extent. I don't think that causes a problem with the writeback
> code because the fabricated blocks are before the page offset, but those
> semantics are insane. I think you need to do something like fix up
> xfs_bmapi_write() to return the actual converted mapping and make sure
> xfs_iomap_write_allocate() handles that it might start beyond
> map_start_fsb.
> 

A couple more thoughts now that I've had more time to think about this:

4. Kind of a nit, but the comment update in xfs_bmapi_write() that
describes the ilock and associated race window and whatnot should really
be split between there and xfs_iomap_write_allocate(). The former should
just explain what exactly XFS_BMAPI_DELALLOC does (i.e., skip holes,
real extents, over a range..). The latter should explain how
the use of XFS_BMAPI_DELALLOC helps us deal with the race window in the
writeback code.

5. A more serious point.. with this approach, what prevents writeback
from thrashing with buffered writes in the event of the hole punch race
scenario I mentioned previously? One of the things I explicitly wanted
to avoid in this patch is the potential to bounce back and forth between
writes and writeback over extent updates. There is the performance
aspect of that, which is what I was initially concerned about, but your
patch introduces a functional aspect of that we need to consider as
well.

For (the extreme/worst case) example, suppose again we're at writeback
in the middle of a fairly large delalloc extent. Somehow or another we
race and lose a good portion at the start of the currently cached extent
and then see a buffered write at the start offset of the (now invalid)
cached extent. The now invalid range is passed to xfs_bmapi_write(),
which finds and allocates that first block in the range, commits the
transaction and cycles the ilock. If we now contend with another
buffered write at the next offset in the original extent range,
writeback finds and allocates at that offset next and the cycle repeats
until we finally allocate an extent that backs our current page.

Unless I'm missing something here, there's not only opportunity to spend
an awkward amount of time processing unrelated delalloc extents for a
single page, there's potential to allocate bits of what should be a
large contiguous delalloc extent a block at a time, which can defeat the
purpose of delayed allocation (assuming the block allocator doesn't save
our ass).

Hmm, I'm not totally sure what the right answer to that is. On one hand,
I think the approach of using XFS_BMAPI_DELALLOC is fairly elegant. On
the other, I don't think a solution open to this behavior is robust
enough.

One option that comes to mind is to perhaps split off XFS_BMAPI_DELALLOC
from xfs_bmapi_write() into a new xfs_bmapi_delalloc() function that
facilitates new semantics (I'm not terribly comfortable with overloading
the semantics of xfs_bmapi_write()). Instead of passing a range to
xfs_bmapi_delalloc(), just pass the offset we care about and expect that
this function will attempt to allocate the entire extent currently
backing offset. (Alternatively, we could perhaps pass a range by value
and allow xfs_bmapi_delalloc() to update the range in the event of
delalloc discontiguity.) Either way, the extent returned may not cover
the offset (due to fragmentation, as today) and thus the caller needs to
iterate until that happens. The larger point is that we'd lookup the
current extent _at offset_ on each iteration and thus shouldn't ever
contend with new delalloc reservations. Thoughts?

Brian

> Brian
