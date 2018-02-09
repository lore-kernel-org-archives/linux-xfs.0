Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36888 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750924AbeBINh3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Feb 2018 08:37:29 -0500
Date: Fri, 9 Feb 2018 08:37:21 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/4] xfs: account only rmapbt-used blocks against rmapbt
 perag res
Message-ID: <20180209133721.GB20748@bfoster.bfoster>
References: <20180205174601.51574-1-bfoster@redhat.com>
 <20180205174601.51574-5-bfoster@redhat.com>
 <20180207000350.GO4849@magnolia>
 <20180207144934.GB9789@bfoster.bfoster>
 <20180208022037.GF5433@magnolia>
 <20180208131938.GC13929@bfoster.bfoster>
 <20180208224930.GG20266@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180208224930.GG20266@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Feb 09, 2018 at 09:49:30AM +1100, Dave Chinner wrote:
> On Thu, Feb 08, 2018 at 08:19:38AM -0500, Brian Foster wrote:
> > On Wed, Feb 07, 2018 at 06:20:37PM -0800, Darrick J. Wong wrote:
> > > On Wed, Feb 07, 2018 at 09:49:35AM -0500, Brian Foster wrote:
> > > > On Tue, Feb 06, 2018 at 04:03:50PM -0800, Darrick J. Wong wrote:
> > > > We've since applied it to things like the finobt (which I'm still not
> > > > totally convinced was the right thing to do based on the vague
> > > > justification for it), which kind of blurs the line between where it's
> > > > a requirement vs. nice-to-have/band-aid for me.
> > > 
> > > I think the finobt reservation is required: Suppose you have a
> > > filesystem with a lot of empty files, a lot of single-block files, and a
> > > lot of big files such that there's no free space anywhere.  Suppose
> > > further that there's an AG where every finobt block is exactly full,
> > > there's an inode chunk with exactly 64 inodes in use, and every block in
> > > that AG is in use (meaning zero AGFL blocks).  Now find one of the empty
> > > inodes in that totally-full chunk and try to free it.  Truncation
> > > doesn't free up any blocks, but we have to expand the finobt to add the
> > > record for the chunk.  We can't find any blocks in that AG so we shut
> > > down.
> > > 
> > 
> > Yes, I suppose the problem makes sense (I wish the original commit had
> > such an explanation :/). We do have the transaction block reservation in
> > the !perag res case, but I suppose we're susceptible to the same global
> > reservation problem as above.
> > 
> > Have we considered a per-ag + per-transaction mechanism at any point
> > through all of this?
> 
> That's kind of what I was suggesting to Darrick on IRC a while back.
> i.e. the per-ag reservation of at least 4-8MB of space similar to
> the global reservation pool we have, and when it dips below that
> threshold we reserve more free space.
> 

I see. FWIW, that's not exactly what I was thinking, but I suspect it's
a very similar idea in terms of just trying to provide a "good enough"
solution (IOW, we may just be quibbling on implementation details here).

Is this new block pool essentially just a low-end pool to be used in
certain, fixed contexts that are at risk of catastrophic failure in
event of ENOSPC? Essentially a backup plan to cover the case where: a
transaction reserves N global blocks, the operation results in some
refcountbt operations, AG is out of blocks so allocations fail, dip into
special AG reserve pool so we don't explode.

That sounds plausible to me, almost like a high level AGFL for
particular operations.

> But yeah, it doesn't completely solve the finobt growth at ENOSPC
> problem, but then again the global reservation pool doesn't
> completely solve the "run out of free space for IO completion
> processing at ENOSPC" problem either. That mechanism is just a
> simple solution that is good enough for 99.99% of XFS users, and if
> you are outside this there's a way to increase the pool size to make
> it more robust (e.g. for those 4096 CPU MPI jobs all doing
> concurrent DIO writeback at ENOSPC).
> 

Yeah. I'm wondering if just refactoring the existing global reservation
pool into something that is AG granular would be a reasonable approach.
E.g., rather than reserve N blocks out of the filesystem that as far as
we know could all source from the same AG, implement a reservation that
reserves roughly N/agcount number of blocks from each AG.

> So the question I'm asking here is this: do we need a "perfect
> solution" or does a simple, small, dynamic reservation pool provide
> "good enough protection" for the vast majority of our users?
> 

I'm all for simple + good enough. :) That's primarily been my concern
from the perag + finobt angle... that a full worst-case tree reservation
is overkill when it might just be sufficient to return -ENOSPC in the
nebulous case that motivated it in the first place. IOW, do we really
need these worst case reservations or to worry about how big a reserve
pool needs to be if we can implement a reliable enough mechanism to
reserve blocks for a particular operation to either proceed or fail
gracefully?

Thinking out loud a bit... the idea that popped in my mind was slightly
different in that I was thinking about a per-transaction AG blocks
reservation. E.g., for the purpose of discussion, consider an
xfs_trans_reserve_agblocks() function that reserved N blocks out of a
particular AG for a given tx. This of course requires knowing what AG to
reserve from, so is limited to certain operations, but I think that
should be doable for inode operations. This also requires knowing what
allocations shall be accounted against such tx reservation, so we'd have
to somehow flag/tag inode chunks, inobt blocks, etc. as being AG
reserved allocations (perhaps similar to how delalloc blocks are already
reserved for bmaps).

I was originally thinking more about inode processing so it's not clear
to me if/how useful this would be for something like reflink. Scanning
through that code a bit, I guess we have to worry about copy-on-write at
writeback time so a transaction is not terribly useful here. What we'd
want is a tx-less reservation at write() time that guarantees we'd have
enough blocks for refcount updates based on the underlying shared
extents that may need to split, etc., right?

Hmm, I'm not sure what the right answer is there. I can certainly see
how a fixed size pool would make this easier, I just wonder if that
could blow up just the same as without it because we're back to just
guessing/hoping it's enough. I think an underlying AG block reservation
mechanism is still potentially useful here, the question is just where
to store/track blocks that would be reserved at cow write() time and
consumed (and/or released) at writeback time? (Then again, I suppose the
same underlying reservation mechanism could be shared to feed tx AG
reservations _and_ a special pool for reflink handling.)

I suppose we could try to design a structure that tracked reservations
associated with a cow fork or something, but that could get hairy
because IIUC the shared extents in the data fork for a particular write
could span multiple AGs (and thus require multiple reservations). It
would be nice if we could define a reservation relative to each extent
or some such that was fixed across this whole cow extent lifecycle and
thus easy to track, consume or release, but the simplest things that
come to mind (e.g., a refcount btree split reservation per shared block)
are too excessive to be realistic. I'd have to think about that some
more... thoughts on any of this?

> > I ask because something that has been in the back
> > of my mind (which I think was an idea from Dave originally) for a while
> > is to simply queue inactive inode processing when it can't run at a
> > particular point in time, but that depends on actually knowing whether
> > we can proceed to inactivate an inode or not.
> 
> Essentially defer the xfs_ifree() processing step from
> xfs_inactive(), right? i.e. leave the inode on the unlinked list
> until we've got space to free it? This could be determined by a
> simple AG space/resv space check before removign the inode from
> the unlinked list...
> 

Yeah, that's essentially what I'm after. A mechanism to tell us reliably
whether an operation will suceed or not is sufficient here so long as we
support the ability to defer freeing unlinked inodes until it is safe to
do so. I don't think the reservation is that difficult for inactive
operations because we 1.) have a transaction to track actual block
consumption and 2.) have a deterministic worst case reservation
requirement.

> FWIW, if we keep a list of inactivated but not yet freed inodes for
> background processing, we could allocate inodes from that list, too,
> simply by removing them from the unlinked list...
> 

Yep. A neat enhancement, indeed.

Brian

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
