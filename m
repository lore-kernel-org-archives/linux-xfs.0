Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36374 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752666AbeBSNVF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Feb 2018 08:21:05 -0500
Date: Mon, 19 Feb 2018 08:21:04 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 7/7] xfs: rework secondary superblock updates in growfs
Message-ID: <20180219132103.GA65426@bfoster.bfoster>
References: <20180201064202.7174-1-david@fromorbit.com>
 <20180201064202.7174-8-david@fromorbit.com>
 <20180209161240.GD21413@bfoster.bfoster>
 <20180215223138.GT7000@dastard>
 <20180216125624.GB53090@bfoster.bfoster>
 <20180219021636.GV7000@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180219021636.GV7000@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 19, 2018 at 01:16:36PM +1100, Dave Chinner wrote:
> On Fri, Feb 16, 2018 at 07:56:25AM -0500, Brian Foster wrote:
> > On Fri, Feb 16, 2018 at 09:31:38AM +1100, Dave Chinner wrote:
> > > On Fri, Feb 09, 2018 at 11:12:41AM -0500, Brian Foster wrote:
> > > > On Thu, Feb 01, 2018 at 05:42:02PM +1100, Dave Chinner wrote:
> > > > > +		bp = xfs_growfs_get_hdr_buf(mp,
> > > > > +				XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
> > > > > +				XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
> > > > 
> > > > This all seems fine to me up until the point where we use uncached
> > > > buffers for pre-existing secondary superblocks. This may all be fine now
> > > > if nothing else happens to access/use secondary supers, but it seems
> > > > like this essentially enforces that going forward.
> > > > 
> > > > Hmm, I see that scrub does appear to look at secondary superblocks via
> > > > cached buffers. Shouldn't we expect this path to maintain coherency with
> > > > an sb buffer that may have been read/cached from there?
> > > 
> > > Good catch! I wrote this before scrub started looking at secondary
> > > superblocks. As a general rulle, we don't want to cache secondary
> > > superblocks as they should never be used by the kernel except in
> > > exceptional situations like grow or scrub.
> > > 
> > > I'll have a look at making this use cached buffers that get freed
> > > immediately after we release them (i.e. don't go onto the LRU) and
> > > that should solve the problem.
> > > 
> > 
> > Ok. Though that sounds a bit odd. What is the purpose of a cached buffer
> > that is not cached?
> 
> Serialisation of concurrent access to what is normal a single-use
> access code path while it is in memory. i.e. exactly the reason we
> have XFS_IGET_DONTCACHE and use it for things like bulkstat lookups.
> 

Well, that's the purpose of looking up a cached instance of an uncached
buffer. That makes sense, but that's only half the question...

> > Isn't the behavior you're after here (perhaps
> > analogous to pagecache coherency management between buffered/direct I/O)
> > more cleanly implemented using a cache invalidation mechanism? E.g.,
> > invalidate cache, use uncached buffer (then perhaps invalidate again).
> 
> Invalidation as a mechanism for non-coherent access sycnhronisation
> is completely broken model when it comes to concurrent access. We
> explicitly tell app developers not ot mix cached + uncached IO to
> the same file for exactly this reason.  Using a cached buffer and
> using the existing xfs_buf_find/lock serialisation avoids this
> problem, and by freeing them immediately after we've used them we
> also minimise the memory footprint of single-use access patterns.
> 

Ok..

> > I guess I'm also a little curious why we couldn't continue to use cached
> > buffers here,
> 
> As I said, we will continue to use cached buffers here. I'll just
> call xfs_buf_set_ref(bp, 0) on them so they are reclaimed when
> released. That means concurrent access will serialise correctly
> through _xfs_buf_find(), otherwise we won't keep them in memory.
> 

Ok, but what's the purpose/motivation for doing that here? Purely to
save on memory? Is that really an impactful enough change in behavior
for (pre-existing) secondary superblocks? This seems a clear enough
decision when growfs was the only consumer of these buffers, but having
another cached accessor kind of clouds the logic.

E.g., if task A reads a set of buffers cached, it's made a decision that
it's potentially beneficial to leave them around. Now we have task B
that has decided it doesn't want to cache the buffers, but what bearing
does that have on task A? It certainly makes sense for task B to drop
any buffer that wasn't already cached, but for already cached buffers it
doesn't really make sense for task B to decide there is no further
advantage to caching for task A.

FWIW, I think this is how IGET_DONTCACHE works: don't cache the inode
unless it was actually found in cache. I presume that is so a bulkstat
or whatever doesn't toss the existing cached inode working set. It also
looks like an intermediate xfs_iget_cache_hit() actually clears the
pending 'don't cache' state (which makes me wonder what happens when
simultaneous 'don't cache' lookups occur; afaict we'd end up with a
cached inode :/). Bugs aside, perhaps that is a better approach here
rather than stomping on the lru reference count?

Brian

P.S., Another factor to consider is I think this may have potential for
unintended side effect without one of the previously suggested changes
to not call into the growfs internals code on pure imaxpct changes
(which I think you indicated you were going to fix, I just haven't
looked back).

> > but it doesn't really matter to me that much so long as
> > the metadata ends up coherent between subsystems..
> 
> Yup, that's the idea.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
