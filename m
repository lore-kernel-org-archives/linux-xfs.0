Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 221867F57
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 15:51:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AF280AC011
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 13:51:09 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	uc8jABbO7YcCs0Bu for <xfs@oss.sgi.com>;
	Mon, 01 Dec 2014 13:51:07 -0800 (PST)
Date: Tue, 2 Dec 2014 08:51:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix premature enospc on inode allocation
Message-ID: <20141201215104.GN16151@dastard>
References: <1417393928-30497-1-git-send-email-david@fromorbit.com>
	<20141201184000.GD23055@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141201184000.GD23055@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Dec 01, 2014 at 01:40:00PM -0500, Brian Foster wrote:
> On Mon, Dec 01, 2014 at 11:32:08AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > =

> > After growing a filesystem, XFS can fail to allocate inodes even
> > though there is a large amount of space available in the filesystem
> > for inodes. The issue is caused by a nearly full allocation group
> > having enough free space in it to be considered for inode
> > allocation, but not enough contiguous free space to actually
> > allocation inodes.  This situation results in successful selection
> > of the AG for allocation, then failure of the allocation resulting
> > in ENOSPC being reported to the caller.
> > =

> > It is caused by two possible issues. Firstly, we only consider the
> > lognest free extent and whether it would fit an inode chunk. If the
> > extent is not correctly aligned, then we can't allocate an inode
> > chunk in it regardless of the fact that it is large enough. This
> > tends to be a permanent error until space in the AG is freed.
> > =

> > The second issue is that we don't actually lock the AGI or AGF when
> > we are doing these checks, and so by the time we get to actually
> > allocating the inode chunk the space we thought we had in the AG may
> > have been allocated. This tends to be a spurious error as it
> > requires a race to trigger. Hence this case is ignored in this patch
> > as the reported problem is for permanent errors.
> > =

> > The first issue could be addressed by simply taking into account the
> > alignment when checking the longest extent. This, however, would
> > prevent allocation in AGs that have aligned, exact sized extents
> > free. However, this case should be fairly rare compared to the
> > number of allocations that occur near ENOSPC that would trigger this
> > condition.
> > =

> =

> I think the allocation of aligned and exact size extents is already
> prevented in the inode chunk allocation code (where it sets the
> alignment requirement of the alloc.) and the associated checks in
> xfs_alloc_fix_freelist() (in particular, the couple bits of logic there
> that consider args->alignment and args->minalignslop).

Right.

> This is an interesting observation made from early tests of the sparse
> inode chunk work. At the point where an AG no longer satisfies inode
> chunk allocations, the sparse chunk mechanism actually leads to behavior
> where full inode chunks are allocated a sparse chunk at a time in
> regions of free space that were technically capable of supporting inode
> chunks before resorting to sparse allocs, but that the pre-allocation
> checks were not granular enough to allow to proceed. Note that this
> behavior assumes a workload that sequentially allocates inodes so as to
> not compete with allocations for other purposes, of course.

Yeah, sparse inode chunks change this logic because we can do single
block allocation for a partial inode chunk. However, for all the
existing filesystems that can't do partial inode chunks we still
need to handle this problem case.

> This patch seems to make the higher level AG selection more consistent
> with the lower level allocation attempt, which seems reasonable to me
> because it shouldn't introduce any allocation failures that aren't going
> to end up as failures anyways.

That's pretty much the conclusion I came to - I thought about trying
to combine the selection and allocation loops, but that's a lot more
work than is needed to fix the extent size requirements between the
two loops.

> > Hence, when selecting the inode AG, take into account the inode
> > cluster alignment when checking the lognest free extent in the AG.
> > If we can't find any AGs with a contiguous free space large
> > enough to be aligned, drop the alignment addition and just try for
> > an AG that has enough contiguous free space available for an inode
> > chunk. This won't prevent issues from occurring, but should avoid
> > situations where other AGs have lots of free space but the selected
> > AG can't allocate due to alignment constraints.
> > =

> > Reported-by: Arkadiusz Mi=BFkiewicz <arekm@maven.pl>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> =

> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks!

> (minor comment nit in the last hunk)

Fixed.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
