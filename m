Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:45629 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753085AbeBIXOQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Feb 2018 18:14:16 -0500
Date: Sat, 10 Feb 2018 10:10:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_buf_lock vs aio
Message-ID: <20180209231015.GI20266@dastard>
References: <a0531d16-d872-548d-4821-273c072973e6@scylladb.com>
 <20180207233320.GB20367@dastard>
 <ed83833b-5024-40f2-b335-2dcab7fddf0e@scylladb.com>
 <20180208221153.GF20266@dastard>
 <30274e7a-4029-73b8-0d8b-cdfda450e3bc@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30274e7a-4029-73b8-0d8b-cdfda450e3bc@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 09, 2018 at 02:11:58PM +0200, Avi Kivity wrote:
> On 02/09/2018 12:11 AM, Dave Chinner wrote:
> >On Thu, Feb 08, 2018 at 10:24:11AM +0200, Avi Kivity wrote:
> >>On 02/08/2018 01:33 AM, Dave Chinner wrote:
> >>>On Wed, Feb 07, 2018 at 07:20:17PM +0200, Avi Kivity wrote:
> >>>>As usual, I'm having my lovely io_submit()s sleeping. This time some
> >>>>detailed traces. 4.14.15.
> >[....]
> >
> >>>>Forcing the log, so sleeping with ILOCK taken.
> >>>Because it's trying to reallocate an extent that is pinned in the
> >>>log and is marked stale. i.e. we are reallocating a recently freed
> >>>metadata extent that hasn't been committed to disk yet. IOWs, it's
> >>>the metadata form of the "log force to clear a busy extent so we can
> >>>re-use it" condition....
> >>>
> >>>There's nothing you can do to reliably avoid this - it's a sign that
> >>>you're running low on free space in an AG because it's recycling
> >>>recently freed space faster than the CIL is being committed to disk.
> >>>
> >>>You could speed up background journal syncs to try to reduce the
> >>>async checkpoint latency that allows busy extents to build up
> >>>(/proc/sys/fs/xfs/xfssyncd_centisecs) but that also impacts on
> >>>journal overhead and IO latency, etc.
> >>Perhaps xfs should auto-tune this variable.
> >That's not a fix. That's a nasty hack that attempts to hide the
> >underlying problem of selecting AGs and/or free space that requires
> >a log force to be used instead of finding other, un-encumbered
> >freespace present in the filesystem.
> 
> Isn't the underlying problem that you have a foreground process
> depending on the progress of a background process?

At a very, very basic level.

> i.e., no matter
> how AG and free space selection improves, you can always find a
> workload that consumes extents faster than they can be laundered?

Sure, but that doesn't mean we have to fall back to a synchronous
alogrithm to handle collisions. It's that synchronous behaviour that
is the root cause of the long lock stalls you are seeing.

> I'm not saying that free extent selection can't or shouldn't be
> improved, just that it can never completely fix the problem on its
> own.

Righto, if you say so.

After all, what do I know about the subject at hand? I'm just the
poor dumb guy who wrote the current busy extent list handling
algorithm years ago.  Perhaps you'd like to read the commit message
(below), because it explains these sycnhronous slow paths and why
they exist. I'll quote the part relevant to the discussion here,
though:

	    Ideally we should not reallocate busy extents. That is a
	    much more complex fix to the problem as it involves
	    direct intervention in the allocation btree searches in
	    many places. This is left to a future set of
	    modifications.

Christoph has already mentioned in these busy extent blocking
threads that we need to do to avoid the synchronous blocking
problems you are seeing. We knew about this blocking problem more
than *15 years ago*, but we didn't need to solve it 8 years ago
because we it was not necessary to solve the "array overrun causes
log forces" problem people were reporting when they had heaps of
free space available in each AG.

Since then we haven't had a user report a workload that needed
anything more than what we currently do. You have a workload where
this is now important, and so we now need to revisit the issues we
laid out some 8 years ago and work from there.

> >>If we could pass the iocb to file_update_time() then
> >>xfs_vn_update_time, then it could perform a _nowait acquisition of
> >>ILOCK. Otherwise, we can just check if ILOCK is acquirable in
> >>xfs_file_aio_write_checks(). That's racy, but better than nothing.
> >Sure, but that's not the issue with such suggestions. I'm not about
> >to propose a patch to hack an iocb through generic infrastructure
> >that doesn't need an iocb. Doing stuff like that will only get me
> >shouted at because it's a massive layering violation and I should
> >(and do!) know better....
> 
> If updating the time is part of an asynchronous operation, then it
> should fit with the rest of the async framework, no?
> 
> Perhaps a variant file_update_time_async() (which would be called by
> file_update_time).

This doesn't fix the problem you've reported.

We've got to run a transaction to update timestamps. That means
memory allocation (which can block on IO) and transaction
reservations need to be made (which can block on IO) *before* we
even attempt to take the ilock.  That means there's a huge TOCTOU
race window in any "optimisitic" check we'd do here.

IOWs,  a non-blocking timestamp update API is still racy. It /might/
make blocking in timestamp updates less common, but it will not
improve the worst case long-tail latencies that are causing you
problems. And that means it doesn't fix your problem.

> Well, I don't like it very much either. But I do need some fix.

We are well aware of that. And we are also well aware of just how
complex and difficult it is to solve properly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

commit ed3b4d6cdc81e8feefdbfa3c584614be301b6d39
Author: Dave Chinner <david@fromorbit.com>
Date:   Fri May 21 12:07:08 2010 +1000

    xfs: Improve scalability of busy extent tracking
    
    When we free a metadata extent, we record it in the per-AG busy
    extent array so that it is not re-used before the freeing
    transaction hits the disk. This array is fixed size, so when it
    overflows we make further allocation transactions synchronous
    because we cannot track more freed extents until those transactions
    hit the disk and are completed. Under heavy mixed allocation and
    freeing workloads with large log buffers, we can overflow this array
    quite easily.
    
    Further, the array is sparsely populated, which means that inserts
    need to search for a free slot, and array searches often have to
    search many more slots that are actually used to check all the
    busy extents. Quite inefficient, really.
    
    To enable this aspect of extent freeing to scale better, we need
    a structure that can grow dynamically. While in other areas of
    XFS we have used radix trees, the extents being freed are at random
    locations on disk so are better suited to being indexed by an rbtree.
    
    So, use a per-AG rbtree indexed by block number to track busy
    extents.  This incures a memory allocation when marking an extent
    busy, but should not occur too often in low memory situations. This
    should scale to an arbitrary number of extents so should not be a
    limitation for features such as in-memory aggregation of
    transactions.
    
    However, there are still situations where we can't avoid allocating
    busy extents (such as allocation from the AGFL). To minimise the
    overhead of such occurences, we need to avoid doing a synchronous
    log force while holding the AGF locked to ensure that the previous
    transactions are safely on disk before we use the extent. We can do
    this by marking the transaction doing the allocation as synchronous
    rather issuing a log force.
    
    Because of the locking involved and the ordering of transactions,
    the synchronous transaction provides the same guarantees as a
    synchronous log force because it ensures that all the prior
    transactions are already on disk when the synchronous transaction
    hits the disk. i.e. it preserves the free->allocate order of the
    extent correctly in recovery.
    
    By doing this, we avoid holding the AGF locked while log writes are
    in progress, hence reducing the length of time the lock is held and
    therefore we increase the rate at which we can allocate and free
    from the allocation group, thereby increasing overall throughput.
    
    The only problem with this approach is that when a metadata buffer is
    marked stale (e.g. a directory block is removed), then buffer remains
    pinned and locked until the log goes to disk. The issue here is that
    if that stale buffer is reallocated in a subsequent transaction, the
    attempt to lock that buffer in the transaction will hang waiting
    the log to go to disk to unlock and unpin the buffer. Hence if
    someone tries to lock a pinned, stale, locked buffer we need to
    push on the log to get it unlocked ASAP. Effectively we are trading
    off a guaranteed log force for a much less common trigger for log
    force to occur.
    
    Ideally we should not reallocate busy extents. That is a much more
    complex fix to the problem as it involves direct intervention in the
    allocation btree searches in many places. This is left to a future
    set of modifications.
    
    Finally, now that we track busy extents in allocated memory, we
    don't need the descriptors in the transaction structure to point to
    them. We can replace the complex busy chunk infrastructure with a
    simple linked list of busy extents. This allows us to remove a large
    chunk of code, making the overall change a net reduction in code
    size.
    
    Signed-off-by: Dave Chinner <david@fromorbit.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Alex Elder <aelder@sgi.com>

