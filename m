Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:13461 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752045AbeBSCQj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Feb 2018 21:16:39 -0500
Date: Mon, 19 Feb 2018 13:16:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/7] xfs: rework secondary superblock updates in growfs
Message-ID: <20180219021636.GV7000@dastard>
References: <20180201064202.7174-1-david@fromorbit.com>
 <20180201064202.7174-8-david@fromorbit.com>
 <20180209161240.GD21413@bfoster.bfoster>
 <20180215223138.GT7000@dastard>
 <20180216125624.GB53090@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180216125624.GB53090@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 16, 2018 at 07:56:25AM -0500, Brian Foster wrote:
> On Fri, Feb 16, 2018 at 09:31:38AM +1100, Dave Chinner wrote:
> > On Fri, Feb 09, 2018 at 11:12:41AM -0500, Brian Foster wrote:
> > > On Thu, Feb 01, 2018 at 05:42:02PM +1100, Dave Chinner wrote:
> > > > +		bp = xfs_growfs_get_hdr_buf(mp,
> > > > +				XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
> > > > +				XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
> > > 
> > > This all seems fine to me up until the point where we use uncached
> > > buffers for pre-existing secondary superblocks. This may all be fine now
> > > if nothing else happens to access/use secondary supers, but it seems
> > > like this essentially enforces that going forward.
> > > 
> > > Hmm, I see that scrub does appear to look at secondary superblocks via
> > > cached buffers. Shouldn't we expect this path to maintain coherency with
> > > an sb buffer that may have been read/cached from there?
> > 
> > Good catch! I wrote this before scrub started looking at secondary
> > superblocks. As a general rulle, we don't want to cache secondary
> > superblocks as they should never be used by the kernel except in
> > exceptional situations like grow or scrub.
> > 
> > I'll have a look at making this use cached buffers that get freed
> > immediately after we release them (i.e. don't go onto the LRU) and
> > that should solve the problem.
> > 
> 
> Ok. Though that sounds a bit odd. What is the purpose of a cached buffer
> that is not cached?

Serialisation of concurrent access to what is normal a single-use
access code path while it is in memory. i.e. exactly the reason we
have XFS_IGET_DONTCACHE and use it for things like bulkstat lookups.

> Isn't the behavior you're after here (perhaps
> analogous to pagecache coherency management between buffered/direct I/O)
> more cleanly implemented using a cache invalidation mechanism? E.g.,
> invalidate cache, use uncached buffer (then perhaps invalidate again).

Invalidation as a mechanism for non-coherent access sycnhronisation
is completely broken model when it comes to concurrent access. We
explicitly tell app developers not ot mix cached + uncached IO to
the same file for exactly this reason.  Using a cached buffer and
using the existing xfs_buf_find/lock serialisation avoids this
problem, and by freeing them immediately after we've used them we
also minimise the memory footprint of single-use access patterns.

> I guess I'm also a little curious why we couldn't continue to use cached
> buffers here,

As I said, we will continue to use cached buffers here. I'll just
call xfs_buf_set_ref(bp, 0) on them so they are reclaimed when
released. That means concurrent access will serialise correctly
through _xfs_buf_find(), otherwise we won't keep them in memory.

> but it doesn't really matter to me that much so long as
> the metadata ends up coherent between subsystems..

Yup, that's the idea.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
