Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:31417 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727018AbfAQWVW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 17:21:22 -0500
Date: Fri, 18 Jan 2019 09:21:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/12] xfs: wait for deferred inactivation when
 destroying unlinked inodes
Message-ID: <20190117222117.GF6173@dastard>
References: <154630901076.16693.13111277988041606505.stgit@magnolia>
 <154630908468.16693.4548983851684057794.stgit@magnolia>
 <20190103124644.GN4205@dastard>
 <20190117184158.GE4424@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117184158.GE4424@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 17, 2019 at 10:41:58AM -0800, Darrick J. Wong wrote:
> On Thu, Jan 03, 2019 at 11:46:44PM +1100, Dave Chinner wrote:
> > On Mon, Dec 31, 2018 at 06:18:04PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Now that we've constructed a mechanism to batch background inode
> > > inactivation work, we actually want in some cases to throttle the amount
> > > of backlog work that the frontend can generate.  We do this by making
> > > destroy_inode wait for inactivation when we're deleting things, assuming
> > > that deleted inodes are dropped and destroyed in process context and not
> > > from fs reclaim.
> > 
> > This would kills performance of highly concurrent unlink
> > workloads.
> > 
> > That said, the current unlink code needs severe throttling because
> > the unlinked inode list management does not scale at all well - get
> > more than a a couple of hundred inodes into the AGI unlinked lists,
> > and xfs_iunlink_remove burns huge amounts of CPU.
> > 
> > So if it isn't throttled, it'll be just as slow, but burn huge
> > amounts amounts of extra CPU walking the unlinked lists.....
> 
> ...so I've refactored the iunlink code to record "who points to this
> inode?" references, which speeds up iunlink_remove substantially.  I'll
> put that series out for review after letting it run on some real
> workloads.
> 
> I've also dropped this patch from the series entirely, just to see what
> happens.  The tradeoff here is that allocations see increased latency
> upon hitting ENOSPC because we now force inactivation to see if we can
> clean things out, but OTOH if we never hit ENOSPC then the rest of the
> fs runs considerably faster.

I think that's a valid trade-off - we make it in several other
places, so we expect things to slow down near/at ENOSPC.

> > > +/*
> > > + * Decide if this inode is a candidate for unlinked inactivation throttling.
> > > + * We have to decide this prior to setting the NEED_INACTIVE iflag because
> > > + * once we flag the inode for inactivation we can't access it any more.
> > > + */
> > > +enum xfs_iwait
> > > +xfs_iwait_check(
> > > +	struct xfs_inode	*ip)
> > > +{
> > > +	struct xfs_mount	*mp = ip->i_mount;
> > > +	unsigned long long	x;
> > > +	unsigned long long	y;
> > > +	bool			rt = XFS_IS_REALTIME_INODE(ip);
> > > +
> > > +	/*
> > > +	 * Don't wait unless we're doing a deletion inactivation.  We assume
> > > +	 * that unlinked inodes that lose all their refcount are dropped,
> > > +	 * evicted, and destroyed immediately in the context of the unlink()ing
> > > +	 * process.
> > > +	 */
> > 
> > I think this is wrong - we want to push unlinked inode processing
> > into the background so we don't have to wait on it, not force
> > inactivation of unlinked inodes to wait for other inodes to be
> > inactivated.
> 
> The original idea behind most of this was that we'd try to slow down a
> rm -rf so that the fs doesn't find itself facing a gigantic flood of
> inactivation work, particularly if there were a lot of extents to free
> or a lot of inodes to free.  Under this scheme we don't ever wait for
> inactivation if we're just closing a linked file, but we could do so for
> deletions.
> 
> However, it is difficult to quantify what "gigantic" means here.  The
> situation I was trying to avoid is where the system gets bogged down
> with background processing work for a long time after the userspace
> process terminates, but perhaps it's better not to bother. :)

Multi-processor systems are ubiquitous now. If we can move things to
the background and burn otherwise idle CPU to do the work so that
users/apps don't have to wait on it, then I think that's fine. IMO,
the more work we can push into async background processing the
better we can optimise it (e.g. start batching or using bulk
operations rather than one-at-a-time).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
