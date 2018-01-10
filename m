Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36018 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750861AbeAJTMF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jan 2018 14:12:05 -0500
Date: Wed, 10 Jan 2018 11:08:23 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH RFC 2/4] xfs: defer agfl block frees when dfops is
 available
Message-ID: <20180110190823.GR5602@magnolia>
References: <20171207185810.48757-1-bfoster@redhat.com>
 <20171207185810.48757-3-bfoster@redhat.com>
 <20171207224126.GJ4094@dastard>
 <20171208141629.GB55826@bfoster.bfoster>
 <20180108215602.GA43411@bfoster.bfoster>
 <20180109204315.GA1168@magnolia>
 <20180110125858.GB17232@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180110125858.GB17232@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Wed, Jan 10, 2018 at 07:58:59AM -0500, Brian Foster wrote:
> On Tue, Jan 09, 2018 at 12:43:15PM -0800, Darrick J. Wong wrote:
> > On Mon, Jan 08, 2018 at 04:56:03PM -0500, Brian Foster wrote:
> > > cc Darrick
> > > 
> > > On Fri, Dec 08, 2017 at 09:16:30AM -0500, Brian Foster wrote:
> > > > On Fri, Dec 08, 2017 at 09:41:26AM +1100, Dave Chinner wrote:
> > > > > On Thu, Dec 07, 2017 at 01:58:08PM -0500, Brian Foster wrote:
> > > ...
> > > > > 
> > > > > Ok, so it uses the EFI/EFD to make sure that the block freeing is
> > > > > logged and replayed. So my question is:
> > > > > 
> > > > > > +/*
> > > > > > + * AGFL blocks are accounted differently in the reserve pools and are not
> > > > > > + * inserted into the busy extent list.
> > > > > > + */
> > > > > > +STATIC int
> > > > > > +xfs_agfl_free_finish_item(
> > > > > > +	struct xfs_trans		*tp,
> > > > > > +	struct xfs_defer_ops		*dop,
> > > > > > +	struct list_head		*item,
> > > > > > +	void				*done_item,
> > > > > > +	void				**state)
> > > > > > +{
> > > > > 
> > > > > How does this function get called by log recovery when processing
> > > > > the EFI as there is no flag in the EFI that says this was a AGFL
> > > > > block?
> > > > > 
> > > > 
> > > > It doesn't...
> > > > 
> > > > > That said, I haven't traced through whether this matters or not,
> > > > > but I suspect it does because freelist frees use XFS_AG_RESV_AGFL
> > > > > and that avoids accounting the free to the superblock counters
> > > > > because the block is already accounted as free space....
> > > > > 
> > > > 
> > > > I don't think it does matter. I actually tested log recovery precisely
> > > > for this question, to see whether the traditional EFI recovery path
> > > > would disrupt accounting or anything and I didn't reproduce any problems
> > > > (well, except for that rmap record cleanup failure thing).
> > > > 
> > > > However, I do still need to trace through and understand why that is, to
> > > > know for sure that there aren't any problems lurking here (and if not, I
> > > > should probably document it), but I suspect the reason is that the
> > > > differences between how agfl and regular blocks are handled here only
> > > > affect in-core state of the AG reservation pools. These are all
> > > > reinitialized from zero on a subsequent mount based on the on-disk state
> > > > (... but good point, and I will try to confirm that before posting a
> > > > non-RFC variant).
> > > > 
> > > 
> > > After catching back up with this and taking a closer look at the code, I
> > > can confirm that generic EFI recovery works fine for deferred AGFL block
> > > frees. What happens is essentially that the slot is freed and the block
> > > free is deferred in a particular tx. If we crash before that tx commits,
> > > then obviously nothing changes and we're fine. If we crash after that tx
> > > commits, EFI recovery frees the block and the AGFL reserve pool
> > > adjustment is irrelevant as the in-core res counters are initialized
> > > from the current state of the fs after log recovery has completed (so
> > > even if we knew this was an agfl block, attempting reservation
> > > adjustments at recovery time would probably be wrong).
> > > 
> > > That aside, looking through the perag res code had me a bit curious
> > > about why we reserve all agfl blocks in the first place. IIUC, the AGFL
> > > reserve pool actually serves the rmapbt, since that (and that alone) is
> > > what the mount time reservation is based on. AGFL blocks can be used for
> > > other purposes, however, and the current runtime reservation is adjusted
> > > based on all AGFL activity. Is there a reason this reserve pool does not
> > > specifically target rmapbt allocations? Doesn't not doing so allow some
> > > percentage of the rmapbt reserved blocks to be consumed by other
> > > structures (alloc btrees) until/unless the fs is remounted? I'm
> > > wondering if specifically there's a risk of something like the
> > > following:
> > > 
> > > - mount fs with some number N of AGFL reserved blocks based on current
> > >   rmapbt state. Suppose the size of the rmapbt is R.
> > > - A bunch of agfl blocks are used over time (U). Suppose 50% of those go
> > >   to the rmapbt and the other 50% to alloc btrees and whatnot.
> > >   ar_reserved is reduced by U, but R only increases by U/2.
> > > - a bunch more unrelated physical allocations occur and consume all
> > >   non-reserved space
> > > - the fs unmounts/mounts and the perag code looks for the remaining U/2
> > >   blocks to reserve for the rmapbt, but not all of those blocks are
> > >   available because we depleted the reserved pool faster than the rmapbt
> > >   grew.
> > > 
> > > Darrick, hm? FWIW, a quick test to allocate 100% of an AG to a file,
> > > punch out every other block for a few minutes and then remount kind of
> > > shows what I'm wondering about:
> > > 
> > >  mount-3215  [002] ...1  1642.401846: xfs_ag_resv_init: dev 253:3 agno 0 resv 2 freeblks 259564 flcount 6 resv 3193 ask 3194 len 3194
> > > ...
> > >  <...>-28260 [000] ...1  1974.946866: xfs_ag_resv_alloc_extent: dev 253:3 agno 0 resv 2 freeblks 36317 flcount 9 resv 2936 ask 3194 len 1
> > >  <...>-28428 [002] ...1  1976.371830: xfs_ag_resv_alloc_extent: dev 253:3 agno 0 resv 2 freeblks 36483 flcount 9 resv 2935 ask 3194 len 1
> > >  <...>-28490 [002] ...1  1976.898147: xfs_ag_resv_alloc_extent: dev 253:3 agno 0 resv 2 freeblks 36544 flcount 9 resv 2934 ask 3194 len 1
> > >  <...>-28491 [002] ...1  1976.907967: xfs_ag_resv_alloc_extent: dev 253:3 agno 0 resv 2 freeblks 36544 flcount 9 resv 2933 ask 3194 len 1
> > > umount-28664 [002] ...1  1983.335444: xfs_ag_resv_free: dev 253:3 agno 0 resv 2 freeblks 36643 flcount 10 resv 2932 ask 3194 len 0
> > >  mount-28671 [000] ...1  1991.396640: xfs_ag_resv_init: dev 253:3 agno 0 resv 2 freeblks 36643 flcount 10 resv 3038 ask 3194 len 3194
> > 
> > Yep, that's a bug.  Our current agfl doesn't have much of a way to
> > signal to the perag reservation code that it's using blocks for the
> > rmapbt vs. any other use, so we use up the reservation and then pull
> > from the non-reserved free space after that, with the result that
> > sometimes we can blow the assert in xfs_ag_resv_init.  I've not been
> > able to come up with a convincing way to fix this problem, largely
> > because of:
> > 
> 
> Ok..
> 
> > > We consume the res as we go, unmount with some held reservation value,
> > > immediately remount and the associated reservation has jumped by 100
> > > blocks or so. (Granted, whether this can manifest into a tangible
> > > problem may be another story altogether.).
> > 
> > It's theoretically possible -- even with the perag reservation
> > functioning perfectly we still can run the ag totally out of blocks if
> > the rmap expands beyond our assumed max rmapbt size of max(1 record per
> > block, 1% of the ag).
> > 
> > Say you have agblocks = 11000, allocate 50% of the AG to a file, then
> > reflink that extent into 10000 other files.  Then dirty every other
> > block in each of the 10000 reflink copies.  Even if all the dirtied
> > blocks end up in some other AG, we've still expanded the number of rmap
> > records from 10001 to 5000 * 10000 == 50,000,000, which is much bigger
> > than our original estimation.
> > 
> 
> Yeah, though I think the effectiveness of the maximum sized rmapbt
> estimation is a separate issue from the accuracy of the reservation
> accounting system. The latter makes me worry that certain, sustained
> workloads could amplify the divergence between runtime accounting and
> reality such that the reservation system is ineffective even in cases
> that don't test the worst case estimation. That may be less likely in
> the current situation where the AGFL consumers are semi-related, but
> it's hard to characterize.

Agreed, on both points.

> > Unfortunately the options here aren't good -- we can't reserve enough
> > blocks to cover the maximal rmapbt when reflink is enabled, so the best
> > we could do is fail write_begin with ENOSPC if the shared extent's AG is
> > critically low on reservation, but that kinda sucks because at that
> > point the CoW /should/ be moving blocks (and therefore mappings) away
> > from the full AG.
> > 
> 
> Two potential options came to mind when reading the code:
> 
> - Factor all possible AGFL consumers into the perag AGFL reservation
>   calculation to address the impedence mismatch between the calculation
>   and runtime accounting.
> - Refactor the RESV_AGFL reservation into an RESV_RMAPBT reservation
>   that sits on top of the AGFL rather than behind it.
> 
> ... neither of which is fully thought out from a sanity perspective.
> 
> The former strikes me as significantly more complicated as it would
> require the reservation calculation (and estimation) to account for all
> possible consumers of the AGFL. That comes along with all the expected
> future maintenance cost for future AGFL consumers. Add to that the fact
> that the reservation is really only needed for the rmapbt at this point
> in time and this seems like an undesirable option.

<nod>  I also don't know that we're not going to someday add another
consumer of agfl blocks that also needs its own perag reservation, in
which case we'd have to have more accounting.  Or...

> The latter more simply moves the accounting to where rmapbt blocks are
> consumed/freed, irrespective of where the blocks are allocated from. I
> _think_ that should allow for accurate reservation accounting without
> losing any major capability (i.e., the reservation value is still an
> estimation in the end), but I could be missing something in the bowels
> of the res. code. I do wonder a bit about the reservation
> over-protecting blocks in the free space btrees based on the current
> AGFL population, but it's not immediately clear to me if or how much
> that matters (and perhaps is something that could be addressed,
> anyways). Thoughts?

Hmmm.  Right now the perag code reserves some number of blocks for
future use by the rmapbt.  The agfl (via fix_freelist) refreshes from
the perag pool; and the bnobt/rmapbt get blocks from the agfl.  IOWs, we
use the agfl reservation (sloppily) as a backstop for the agfl, and
RESV_AGFL gets charged for any agfl allocation, even if it ultimately
goes to something that isn't the rmapbt, even though the rmapbt code put
that reservation there for its own use.

You propose moving the xfs_ag_resv_{alloc,free}_extent accounting bits
to xfs_rmapbt_{alloc,free}_block so that only rmapbt allocations can
drain from RESV_AGFL (or put back to the pool).  This fixes the
accounting problem, since only those who set up RESV_AGFL reservations
actually get to account from them, i.e. we no longer lose RESV_AGFL
blocks to the bnobt.  Therefore, fix_freelist is no longer responsible
for passing RESV_AGFL into the extent allocation/free routines ... but
does the rmapbt directly allocate its own blocks now?  (I don't think
this is possible, because we'd then have to create an OWN_FS rmap record
for the new rmapbt blocks.)  Or does it still draw from the agfl, in
which case we have to figure out how to get reserved blocks to the
rmapbt if the agfl can't supply any blocks?

--D

> Brian
> 
> > (We already cut off reflinking when the perag reservations are
> > critically low, but that's only because we assume the caller will fall
> > back to a physical copy and that the physical copy will land in some
> > other AG.)
> > 
> > --D
> > 
> > > 
> > > Brian
> > > 
> > > > Brian
> > > > 
> > > > > Cheers,
> > > > > 
> > > > > Dave.
> > > > > -- 
> > > > > Dave Chinner
> > > > > david@fromorbit.com
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
