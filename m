Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B41FD7FAA
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 18:36:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7D3248F8050
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 16:36:36 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZrdZ24F9PtQWRSMK for <xfs@oss.sgi.com>;
	Thu, 14 Mar 2013 16:36:34 -0700 (PDT)
Date: Fri, 15 Mar 2013 10:36:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Pathological allocation pattern with direct IO
Message-ID: <20130314233631.GB21651@dastard>
References: <20130306202210.GA1318@quack.suse.cz>
	<20130307050325.GS23616@dastard>
	<20130307102406.GA6723@quack.suse.cz>
	<20130308013525.GZ23616@dastard>
	<20130312110100.GC13152@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130312110100.GC13152@quack.suse.cz>
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
Cc: xfs@oss.sgi.com

On Tue, Mar 12, 2013 at 12:01:00PM +0100, Jan Kara wrote:
> On Fri 08-03-13 12:35:25, Dave Chinner wrote:
> > On Thu, Mar 07, 2013 at 11:24:06AM +0100, Jan Kara wrote:
> > > But really I was wondering about usefulness of XFS_ALLOCTYPE_NEAR_BNO
> > > heuristic. Sure the seek time depends on the distance so if we are speaking
> > > about allocating single extent then XFS_ALLOCTYPE_NEAR_BNO is useful but
> > > once that strategy would allocate two or three consecutive extents you've
> > > lost all the benefit and you would be better off if you started allocating
> > > from the start of the free space.
>   <snip>
> > Hence repeated backwards allocation is, in many cases, desirable
> > behaviour, and in others it doesn't make any difference. And with it
> > being easy to work around for the few cases where it is tripped over
> > on aging filesystems, there hasn't been a great deal of need to
> > change the behaviour.
>   Thanks for explanation!

No problems - there's a lot of stuff in my head that simply isn't
documented anywhere, and it would take months of work to document
it so I've never written it down...

> > I suspect we don't even need to detect the backwards allocation
> > pattern at all - if we are falling back from an
> > XFS_ALLOCTYPE_THIS_BNO allocation, we know that the target cannot be
> > allocated and so we *might* end up doing a backwards allocation.
> > Hence I don't think it will not hurt at all to simply say "select
> > the start of the next candidate free extent" for a file data
> > allocations in this case. That would completely avoid needing to
> > detect repeated backwards allocations and ensure that subsequent
> > allocations after the backwards jump to the start of the large free
> > extent then go forwards as intended...
>   Yes, I was wondering about whether this strategy won't be good enough as
> well. But there's one case I'm afraid of: Suppose you have a small file so
> that it gets written out in one request and fits in a single extent of
> blocks. Then it is somewhat advantageous to allocate from the end of the
> free extent because that is closer to the inode and thus reduces
> inode-to-data seek time. That's why I was suggesting maybe we could use
> this logic only for larger files or something like that. Hum, maybe if we
> didn't use this strategy for initial file extent, it would be enough.
> That's already handled specially in the allocator so it shouldn't be a
> problem to detect. What do you think?

It took me a couple of readings to work out what you meant here.
You are wondering if selecting the start of a free extent for the
initial data for small files is the right thing to do as it may not
be "closest", right?

The thing is, we don't know if the inode is going to be written to
again, and so there is no context to be able to determine if we need
to be able to do a subsequent THIS_BNO exact allocation in
subsequent allocations. Because XFS is designed for large files and
high bandwidth IO, it is assumed that contiguous allocation is the
most important factor in determining where to allocate a block.
Hence even for a small allocation, the assumption is that there will
be another contiguous allocation request and another and another....

Hence XFS always tries to place new files at the start of a large
freespace extent, not at the end, because it is assumed that files
will always grow in the short term.  The thing is, this is all
*very* complicated, and there's a lot of context that needs to be
understood that, as I said above, isn't really documented anywhere.
So, more context:

We are searching left/right because the extent size we want to
allocate resulted in a by-size btree lookup returning a btree block
that is not at the end of the tree. i.e. we've hit a btree block
that contains free space extents of roughly the same size as the
extent we want to allocate rather than free space extents mcuh
larger than the size we need.

If we hit the last block - we have large contiguous free space
extents and so we do a linear search to select the freespace extent
that is *closest* to the target block, and allocate from the front
of it. Hence subsequent THIS_BNO allocations will work just fine as
there's plenty of contiguous free space at the end of the
allocation.

However, if we don't hit the last block it means there is some
amount of free space fragmentation present in the filesystem. This
means we can't use a by-size lookup to determine the closest free
extent that would fit the allocation. If freespace fragementation is
bad, there might be tens of thousands of free extents of that size
in the tree, and selecting the closest would require a linear search
through all the blocks. It's prohibitively expensive from both a CPU
and Io point of view, so that isn't done.

[ Freespace fragmentation of this style will occur from having an
application that does concurrent, identically sized allocations that
are small compared to the eventual file size.  e.g. using direct IO
in 16MB chunks to write files that are tens of GB in length. Over
time, extents will get interleaved and then when you remove some
files you end up with smaller freespace extents, which then get
interleaved into more files, and when some of them get removed you
get even smaller freespace extents. ]

It is when we see this sort of freespace fragmentation that the
NEAR_BNO allocation falls back to the second algorithm and search
left and right from the target block in the by-block freespace tree.
This *may* find a large extent that is in the last block of by-size
tree and this is the trigger for backwards allocation to occur. If
we were to have found the last by-size btree block in the initial
by-size lookup, this is the extent that would have been selected by
that algorithm, and we would have selected the front of the
freespace extent, not the end of it.

So for data allocation, it is quite clear that there is a
significant difference between the way the free space extent is
treated when we carve a chunk out of it when we compare the two
algorithms.  Hence if we simply change the way we select the best
part of the extent to use for data allocation to match the method
used when we select a large free space from the by-size tree, we'll
stop this repeated backwards allocation problem from occurring and
have similar extent selection behaviour for data allocation not
matter which algorithm finds a the closest large freespace
extent....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
