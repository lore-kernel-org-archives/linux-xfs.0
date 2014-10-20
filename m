Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 15F6E7F4E
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2014 20:25:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E75AC8F8039
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2014 18:25:27 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Du8etysLx1sui1aB for <xfs@oss.sgi.com>;
	Sun, 19 Oct 2014 18:25:25 -0700 (PDT)
Date: Mon, 20 Oct 2014 12:25:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4] xfs: rework zero range to prevent invalid i_size
	updates
Message-ID: <20141020012516.GK7169@dastard>
References: <1413220285-24886-1-git-send-email-bfoster@redhat.com>
	<20141017202019.GA3393@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141017202019.GA3393@laptop.bfoster>
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

On Fri, Oct 17, 2014 at 04:20:20PM -0400, Brian Foster wrote:
> It appears that the tp->t_blk_res overrun assert is also related to
> delalloc punching. I'm basically seeing a writepage attempted for a page
> over a delalloc extent (imap in writepage reflects this), but at some
> point before we get into the allocation (I suspect between where we
> release and reacquire ilock in xfs_map_blocks() to
> iomap_write_allocate()) the delalloc blocks that relate this particular
> page to the extent disappear. An in-core extent dump after doing the
> allocation but before inserting into the extent tree shows the range to
> be allocated as a hole. Indeed, the allocator saw a hole (wasdel == 0)
> and ended up doing the full allocation while the transaction had a
> reservation for a delalloc conversion, which we end up overrunning.
> 
> It's not quite clear to me how this is happening. I would expect
> truncate_pagecache_range() to serialize against writeback via page lock.

It does. But the problem won't be truncate_pagecache_range(), it will be
that punching delalloc blocks doesn't serialise against the page
lock.

i.e. we run truncate_pagecache_range/truncate_setsize without
holding inode locks, and they serialise against writeback via page
locks. However, we run xfs_bmap_punch_delalloc_range() holding inode
locks, but no page locks. Hence both can serialise against
writeback, but not against each other. therefore:

	writeback			zero range

	page_lock
	page is delalloc
	XFS_ILOCK_SHARED		XFS_ILOCK_EXCL
	map delalloc			<blocks>
	xfs_iunlock
					punch delalloc range
					xfs_iunlock
	XFS_ILOCK_EXCL			pagecache_truncate_range
	allocate HOLE!!!!		page_lock
	xfs_iunlock			<blocks>
	starts page writeback
	unlocks page
					waits on writeback
					removes page from cache

Basically, we back to the fundamental problem that we can't
manipulate extent state directly if there are *unlocked* pages in
the page cache over that range because we hold meaningful writeback
state on the page.

> Regardless, the scenario of writing back pages into unallocated space
> that writeback thinks is covered by delayed allocation suggests
> something racing with delalloc punching. The problem seems to disappear
> if I comment it out from zero range, so we might want to kill the above
> hunk entirely for the time being.

Yes, but I think I see the way forward now. xfs_vm_writepage() needs
to unconditionally map the page it is being passed rather than
relying on the state of bufferheads attached to the buffer. We can't
serialise the page cache state against direct extent manipulations,
therefore we have to make all decisions based on one set of state we
can serialise access to sanely.

The issue is that we can't currently serialise extent manipulations
against writeback easily, but I think I see a neat and easy way to
do this, and it mirrors a technique we already use(*): add a cursor
to track the active map we are operating on so that we know if we
are about to modify and extent we are currently writing to.

Actually, a cursor solves a couple of other problems in this
mapping code - see the big comment in xfs_iomap_write_allocate()
about using a single map to avoid lookup/unlock/lock/allocate race
conditions with truncate/hole-punch.

So I think I have a solution that moves us towards the goal of "die,
bufferheads, die" and solves these writeback vs page cache vs extent
manipulation issues - let me do a bit more thinking about it and
I'll write something up.

Cheers,

Dave.

(*) we use a cursor for a similar purpose during AIL traversal: to
detect item deletion while the AIL lock was dropped that would cause
us to follow an invalid list pointer.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
