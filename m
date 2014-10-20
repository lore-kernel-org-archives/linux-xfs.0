Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 549017F4E
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2014 07:43:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 431C3304048
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2014 05:43:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4GlmQ5zgYkI7ygvx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Oct 2014 05:42:59 -0700 (PDT)
Date: Mon, 20 Oct 2014 08:42:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v4] xfs: rework zero range to prevent invalid i_size
	updates
Message-ID: <20141020124248.GA30254@bfoster.bfoster>
References: <1413220285-24886-1-git-send-email-bfoster@redhat.com>
	<20141017202019.GA3393@laptop.bfoster>
	<20141020012516.GK7169@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141020012516.GK7169@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 20, 2014 at 12:25:16PM +1100, Dave Chinner wrote:
> On Fri, Oct 17, 2014 at 04:20:20PM -0400, Brian Foster wrote:
> > It appears that the tp->t_blk_res overrun assert is also related to
> > delalloc punching. I'm basically seeing a writepage attempted for a page
> > over a delalloc extent (imap in writepage reflects this), but at some
> > point before we get into the allocation (I suspect between where we
> > release and reacquire ilock in xfs_map_blocks() to
> > iomap_write_allocate()) the delalloc blocks that relate this particular
> > page to the extent disappear. An in-core extent dump after doing the
> > allocation but before inserting into the extent tree shows the range to
> > be allocated as a hole. Indeed, the allocator saw a hole (wasdel == 0)
> > and ended up doing the full allocation while the transaction had a
> > reservation for a delalloc conversion, which we end up overrunning.
> > 
> > It's not quite clear to me how this is happening. I would expect
> > truncate_pagecache_range() to serialize against writeback via page lock.
> 
> It does. But the problem won't be truncate_pagecache_range(), it will be
> that punching delalloc blocks doesn't serialise against the page
> lock.
> 

Ok...

> i.e. we run truncate_pagecache_range/truncate_setsize without
> holding inode locks, and they serialise against writeback via page
> locks. However, we run xfs_bmap_punch_delalloc_range() holding inode
> locks, but no page locks. Hence both can serialise against
> writeback, but not against each other. therefore:
> 
> 	writeback			zero range
> 
> 	page_lock
> 	page is delalloc
> 	XFS_ILOCK_SHARED		XFS_ILOCK_EXCL
> 	map delalloc			<blocks>
> 	xfs_iunlock

This pretty much maps the observed behavior and what I suspect is
happening on a basic level (e.g., this ilock cycle opens a race window).
What still isn't clear is how this gets past the pagecache truncate in
such a state. The zero range path truncates pagecache before the
delalloc punch, which does serialize on the page lock. If it gets the
lock it completely tosses the page, which it looks like the mapping
checks in writepage should handle. If it doesn't get the lock or the
page is writeback, it looks like it waits on writeback.

This is an fsx workload so it is single threaded I/O. I'm not quite
seeing how we get through the writeback/pagecache truncate in a state
with a delalloc page.

> 					punch delalloc range
> 					xfs_iunlock
> 	XFS_ILOCK_EXCL			pagecache_truncate_range
> 	allocate HOLE!!!!		page_lock
> 	xfs_iunlock			<blocks>

Ah, so this makes sense according to the code as it is today because we
punch delalloc blocks and then truncate pagecache. Note that this zero
range rework does the pagecache truncate first, then punches out the
delalloc blocks. Hence my expectation of either seeing the page tossed
or the extent converted before getting to the delalloc punch.

> 	starts page writeback
> 	unlocks page
> 					waits on writeback
> 					removes page from cache
> 
> Basically, we back to the fundamental problem that we can't
> manipulate extent state directly if there are *unlocked* pages in
> the page cache over that range because we hold meaningful writeback
> state on the page.
> 
> > Regardless, the scenario of writing back pages into unallocated space
> > that writeback thinks is covered by delayed allocation suggests
> > something racing with delalloc punching. The problem seems to disappear
> > if I comment it out from zero range, so we might want to kill the above
> > hunk entirely for the time being.
> 
> Yes, but I think I see the way forward now. xfs_vm_writepage() needs
> to unconditionally map the page it is being passed rather than
> relying on the state of bufferheads attached to the buffer. We can't
> serialise the page cache state against direct extent manipulations,
> therefore we have to make all decisions based on one set of state we
> can serialise access to sanely.
> 

Sounds interesting. I'm all for condensing our page state management
towards killing buffer_head. Tracking down some of these issues has
helped clarify the general problem for me and also shows that instances
are quite difficult to root cause. This one in particular is a zero
range operation that presumably works (no fsx failures), only to cause
an implicit error in an asynchronous path (writeback) sometime later.
That makes it difficult to detect and equally difficult to try and
narrow down.

> The issue is that we can't currently serialise extent manipulations
> against writeback easily, but I think I see a neat and easy way to
> do this, and it mirrors a technique we already use(*): add a cursor
> to track the active map we are operating on so that we know if we
> are about to modify and extent we are currently writing to.
> 

Ok, so I take it this would allow us to mark an extent as "under
modification" or "in-use" in the sense of its state is significant for a
code sequence larger than an ilock critical section (i.e., an imap,
extent-conversion, writeback sequence). Therefore, one side can
invalidate another if a modification is made, or conversely the other
side could simply block on the operation if that is more appropriate. I
_think_ I get where you're going there, but I await more details. ;)

I'll post a new version of this patch regardless because as mentioned
previously, I'd like to get some kind of checkpoint into the tree that
works correctly (no asserts), even if the implementation is not ideal.
I've not been able to reproduce any asserts so far without the delalloc
punch, but I'd also like to see if any of your subsequent testing
uncovers anything else.

Brian

> Actually, a cursor solves a couple of other problems in this
> mapping code - see the big comment in xfs_iomap_write_allocate()
> about using a single map to avoid lookup/unlock/lock/allocate race
> conditions with truncate/hole-punch.
> 
> So I think I have a solution that moves us towards the goal of "die,
> bufferheads, die" and solves these writeback vs page cache vs extent
> manipulation issues - let me do a bit more thinking about it and
> I'll write something up.
> 
> Cheers,
> 
> Dave.
> 
> (*) we use a cursor for a similar purpose during AIL traversal: to
> detect item deletion while the AIL lock was dropped that would cause
> us to follow an invalid list pointer.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
