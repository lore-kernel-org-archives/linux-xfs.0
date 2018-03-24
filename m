Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35258 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751903AbeCXAhp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Mar 2018 20:37:45 -0400
Date: Fri, 23 Mar 2018 17:37:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 7/7] xfs: rework secondary superblock updates in growfs
Message-ID: <20180324003738.GL4818@magnolia>
References: <20180201064202.7174-1-david@fromorbit.com>
 <20180201064202.7174-8-david@fromorbit.com>
 <20180209161240.GD21413@bfoster.bfoster>
 <20180215223138.GT7000@dastard>
 <20180216125624.GB53090@bfoster.bfoster>
 <20180219021636.GV7000@dastard>
 <20180219132103.GA65426@bfoster.bfoster>
 <20180219221404.GZ7000@dastard>
 <20180220124439.GA3409@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180220124439.GA3409@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

Drat, this fell off my radar...

On Tue, Feb 20, 2018 at 07:44:39AM -0500, Brian Foster wrote:
> On Tue, Feb 20, 2018 at 09:14:04AM +1100, Dave Chinner wrote:
> > On Mon, Feb 19, 2018 at 08:21:04AM -0500, Brian Foster wrote:
> > > On Mon, Feb 19, 2018 at 01:16:36PM +1100, Dave Chinner wrote:
> > > > On Fri, Feb 16, 2018 at 07:56:25AM -0500, Brian Foster wrote:
> > > > > On Fri, Feb 16, 2018 at 09:31:38AM +1100, Dave Chinner wrote:
> > > > > > On Fri, Feb 09, 2018 at 11:12:41AM -0500, Brian Foster wrote:
> > > > > > > On Thu, Feb 01, 2018 at 05:42:02PM +1100, Dave Chinner wrote:
> > > > > > > > +		bp = xfs_growfs_get_hdr_buf(mp,
> > > > > > > > +				XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
> > > > > > > > +				XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
> > > > > > > 
> > > > > > > This all seems fine to me up until the point where we use uncached
> > > > > > > buffers for pre-existing secondary superblocks. This may all be fine now
> > > > > > > if nothing else happens to access/use secondary supers, but it seems
> > > > > > > like this essentially enforces that going forward.
> > > > > > > 
> > > > > > > Hmm, I see that scrub does appear to look at secondary superblocks via
> > > > > > > cached buffers. Shouldn't we expect this path to maintain coherency with
> > > > > > > an sb buffer that may have been read/cached from there?
> > > > > > 
> > > > > > Good catch! I wrote this before scrub started looking at secondary
> > > > > > superblocks. As a general rulle, we don't want to cache secondary
> > > > > > superblocks as they should never be used by the kernel except in
> > > > > > exceptional situations like grow or scrub.
> > > > > > 
> > > > > > I'll have a look at making this use cached buffers that get freed
> > > > > > immediately after we release them (i.e. don't go onto the LRU) and
> > > > > > that should solve the problem.
> > > > > > 
> > > > > 
> > > > > Ok. Though that sounds a bit odd. What is the purpose of a cached buffer
> > > > > that is not cached?
> > > > 
> > > > Serialisation of concurrent access to what is normal a single-use
> > > > access code path while it is in memory. i.e. exactly the reason we
> > > > have XFS_IGET_DONTCACHE and use it for things like bulkstat lookups.
> > > > 
> > > 
> > > Well, that's the purpose of looking up a cached instance of an uncached
> > > buffer. That makes sense, but that's only half the question...
> > > 
> > > > > Isn't the behavior you're after here (perhaps
> > > > > analogous to pagecache coherency management between buffered/direct I/O)
> > > > > more cleanly implemented using a cache invalidation mechanism? E.g.,
> > > > > invalidate cache, use uncached buffer (then perhaps invalidate again).
> > > > 
> > > > Invalidation as a mechanism for non-coherent access sycnhronisation
> > > > is completely broken model when it comes to concurrent access. We
> > > > explicitly tell app developers not ot mix cached + uncached IO to
> > > > the same file for exactly this reason.  Using a cached buffer and
> > > > using the existing xfs_buf_find/lock serialisation avoids this
> > > > problem, and by freeing them immediately after we've used them we
> > > > also minimise the memory footprint of single-use access patterns.
> > > > 
> > > 
> > > Ok..
> > > 
> > > > > I guess I'm also a little curious why we couldn't continue to use cached
> > > > > buffers here,
> > > > 
> > > > As I said, we will continue to use cached buffers here. I'll just
> > > > call xfs_buf_set_ref(bp, 0) on them so they are reclaimed when
> > > > released. That means concurrent access will serialise correctly
> > > > through _xfs_buf_find(), otherwise we won't keep them in memory.
> > > > 
> > > 
> > > Ok, but what's the purpose/motivation for doing that here? Purely to
> > > save on memory?
> > 
> > Partly, but mainly because they are single use buffers and accesses
> > are so rare that it's a waste of resources to cache them because
> > they'll be reclaimed long before they are ever accessed again.
> > 
> > > Is that really an impactful enough change in behavior
> > > for (pre-existing) secondary superblocks?
> > 
> > Yes. We know that there are people out there doing "create tiny,
> > deploy, grow to thousands of AGs" as part of their crazy, screwed up
> > container deployment scripts. THat's thousands of secondary
> > superblocks that will be cached and generate unnecessary memory
> > pressure when cached,
> > 
> > > This seems a clear enough
> > > decision when growfs was the only consumer of these buffers, but having
> > > another cached accessor kind of clouds the logic.
> > 
> > Scrub is not something that runs often enough we should be trying to
> > cache it's metadata to speed up the next run. The whole point of
> > scrub is that it reads metadata that hasn't been accessed in a long
> > time to verify it hasn't degraded. Caching secondary superblocks for
> > either growfs or scrub makes no sense. However, we have to make sure
> > if the two occur at the same time, their actions are coherent and
> > correctly serialised.
> > 
> 
> Ok, so then the right thing to do (as Darrick posited earlier) is also
> tweak scrub to effectively not cache buffers from that path. That seems
> perfectly reasonable to me.

Yes. :)

> > > E.g., if task A reads a set of buffers cached, it's made a decision that
> > > it's potentially beneficial to leave them around. Now we have task B
> > > that has decided it doesn't want to cache the buffers, but what bearing
> > > does that have on task A? It certainly makes sense for task B to drop
> > > any buffer that wasn't already cached, but for already cached buffers it
> > > doesn't really make sense for task B to decide there is no further
> > > advantage to caching for task A.
> > > 
> > > FWIW, I think this is how IGET_DONTCACHE works: don't cache the inode
> > > unless it was actually found in cache. I presume that is so a bulkstat
> > > or whatever doesn't toss the existing cached inode working set.
> > 
> > Yes, precisely the point of this inode cache behaviour. However,
> > that's not a concern for secondary superblocks because they are
> > never part of the working set of metadata ongoing user workloads
> > require to be cached. They only get brought into memory as a result
> > of admin operations, and those are very, very rare.
> > 
> 
> I'm not concerned about trashing a working set of secondary superblocks
> in practice... Darrick has already suggested that it's probably not
> critical for scrub and I think your reasoning also makes sense. I'm just
> pointing out that we have a similar interface/control in place for
> another cached object, and that is how it happens to work.
> 
> With that in mind, I am still interested in having sane/consistent and
> predictable behavior here. Having two user driven operations A and B
> where path A caches buffers and path B effectively invalidates that
> cache (for the purpose of saving memory) doesn't make a lot of sense to
> me. However, having two paths that both use "don't cache" references is
> clean, predictable and provides the necessary coherency between them.
> 
> So to be more specific, all I'm really suggesting here is something like
> an xfs_read_secondary_sb() helper that calls xfs_buf_set_ref(bp,
> XFS_SSB_REF) on the buffer, and to use that in both places so it's clear
> that we expect to handle such buffers in a certain way going forward. It
> might also be worth factoring into a separate patch since this is
> technically a change in behavior (growfs currently uses cached buffers)
> worthy of an independent commit log (IMO), but not a huge deal if that
> is too much churn.

Agree.  If such a helper were added as part of this patchset, I'd patch
up the corresponding part of scrub to use it.

Dave, will you be reposting this series soon?  I've decided against
trying to combine this with repair, so (afaict) once Brian's review
comments are addressed I think this one is in relatively good shape.

--D

> 
> Brian
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
