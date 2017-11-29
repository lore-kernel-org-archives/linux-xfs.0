Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42576 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752180AbdK2SY4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Nov 2017 13:24:56 -0500
Date: Wed, 29 Nov 2017 13:24:53 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs: amortize agfl block frees across multiple
 transactions
Message-ID: <20171129182453.GA24696@bfoster.bfoster>
References: <20171127202434.43125-1-bfoster@redhat.com>
 <20171127202434.43125-4-bfoster@redhat.com>
 <20171127230734.GB5858@dastard>
 <20171128135748.GC45759@bfoster.bfoster>
 <20171128220919.GF5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171128220919.GF5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 29, 2017 at 09:09:19AM +1100, Dave Chinner wrote:
> On Tue, Nov 28, 2017 at 08:57:48AM -0500, Brian Foster wrote:
> > On Tue, Nov 28, 2017 at 10:07:34AM +1100, Dave Chinner wrote:
> > > On Mon, Nov 27, 2017 at 03:24:33PM -0500, Brian Foster wrote:
...
> > > 
> > > In /theory/, this /should/ work. However, as the comment you removed
> > > implies, there are likely to be issues with this as we get near
> > > ENOSPC. We know that if we don't trim the AGFL right down to the
> > > minimum requested as we approach ENOSPC we can get premature ENOSPC
> > > events being reported that lead to filesystem shutdowns.  (e.g. need
> > > the very last free block for a BMBT block to complete a data extent
> > > allocation).  Hence I'd suggest that this needs to be aware of the
> > > low space allocation algorithm (i.e. dfops->dop_low is true) to trim
> > > the agfl right back when we are really short of space
> > > 
> > 
> > Hmm, shouldn't the worst case bmbt requirements be satisfied by the
> > block reservation of the transaction that maps the extent (or stored as
> > indirect reservation if delalloc)?
> 
> That's checked against global free space when we do the initial
> reservation. It's not checked against AG free space until we make
> the allocation attempt.
> 
> The problem here is that if we don't leave enough space for the BMBT
> block in the same AG as the data extent was allocated we can end up
> with an ENOSPC on the BMBT block allocation because, say, AGF
> locking order and all the higher AGFs are already ENOSPC. That's a
> fatal ENOSPC error as the transaction is already dirty and will
> shutdown the filesystem on transaction cancel.
> 

I thought Christoph already addressed that problem in commit 255c516278
("xfs: fix bogus minleft manipulations").

If not, that sounds like something that would need to be fixed
independent from whether the associated AGFL happens to hold surplus
blocks. AFAICT that problem could occur whether blocks sit on the AGFL
as a surplus, legitimately sit on the AGFL or are simply allocated for
some other purpose.

> > I'm less concerned with premature
> > ENOSPC from contexts where it's not fatal..
> 
> The definition of "premature ENOSPC" is "unexpected ENOSPC that
> causes a filesystem shutdown" :/
> 

That's a bit pedantic. We've had plenty of discussions on the list using
"premature ENOSPC" to describe errors that aren't necessarily fatal for
the fs. Eofblocks trimming, sparse inodes and the broader work the
minleft fix referenced above was part of are just a few obvious
examples of context.

> >
> > IIRC, I think we've already
> > incorporated changes (Christoph's minfree stuff rings a bell) into the
> > allocator that explicitly prefer premature ENOSPC over potentially fatal
> > conditions, but I could be mistaken.
> 
> Yes, but that doesn't take into account all the crazy AGFL
> manipulations that could occur as a result of trimming/extending the
> AGFL. We /assume/ that we don't need signification reservations to
> extend/trim the AGFL to what is required for the transaction. If we
> now how to free 50 blocks from the AGFL back to the freespace tree
> before we start the allocation/free operation, that's going to
> have some impact on the reservations we have.
> 

How does this patch exacerbate that problem? The current code performs N
agfl frees per fixup* to drop below a dynamic watermark
(xfs_alloc_min_freelist()). The patch changes that behavior to perform 1
agfl free per fixup unless we're over a fixed watermark (1/2 agfl size).
ISTM that how far we can exceed that watermark in a given fixup (to be
rectified by the next) is on a similar order in either case (and if
anything, it seems like we factor out the case of recursively populating
the AGFL and shrinking the watermark at the same time).

* By fixup, I'm referring to one pass through xfs_alloc_fix_freelist().

> And think about 4k sector filesystems - there's close on 1000
> entries in the AGFL - this means we could have 500 blocks floating
> on the AGFL that would otherwise be in the freespace tree. IOWs,
> this change could have significant impact on freespace
> fragmentation because blocks aren't getting returned to the
> freespace tree where they merge with other small freespace extents
> to reform larger extents.
> 

Good point. I'm a little curious how we'd really end up with that many
blocks on the agfl. The max requirement for the bnobt and cntbt is 4
each for a 1TB AG. The rmapbt adds another optional dependency, but IIRC
that only adds another 4 or 5 more blocks. I suppose this might require
some kind of sequence where consecutive agfl fixups end up freeing a
block that results in one or more full tree joins, and thus we populate
the agfl much faster than we shrink it (since we'd remove 1 block at a
time) for some period of time.

With regard to the impact on free space fragmentation.. I suppose we
could mitigate that by setting the surplus limit to some multiple of the
max possible agfl requirement instead of 1/2 the physical size of the
agfl.

We could also consider doing things like fixing up AGFL surpluses in a
more safe contexts (i.e., in response to -ENOSPC on write where we also
trim eofblocks, free up indlen reservations, etc.) or allowing a surplus
block to be used in that BMBT block allocation failure scenario as a
last resort to fs shutdown (and if there isn't a surplus block, then
we'd be shutting down anyways). Note that I'm not currently convinced
either of these are necessary, I'm just thinking out loud about how to
deal with some of these potential hazards if they prove legitimate.

> It's these sorts of issues (i.e. filesystem aging) that might not
> show up for months of production use that we need to think about. It
> may be that a larger AGFL helps here because it keeps a working
> set of freespace tree blocks on the AGFL rather than having to
> go back to the freespace trees all the time, but this is something
> we need to measure, analyse and characterise before changing a
> critical piece of the allocation architecture....
> 

I agree. I'm going to drop this patch from v2 for now because I don't
want to hold up the other more straightforward transaction reservation
fixes while we work out how best to fix this problem.

> > We're also only talking about 256k
> > or so for half of the AGFL, less than that if we assume that some of
> > those blocks are actually required by the agfl and not slated to be
> > lazily freed. We could also think about explicitly fixing up agfl
> > surplus from other contexts (background, write -ENOSPC handling, etc.)
> > if it became that much of a problem.
> > 
> > I do think it's semi-reasonable from a conservative standpoint to
> > further restrict this behavior to !dop_low conditions, but I'm a little
> > concerned about creating an "open the floodgates" type situation when
> > the agfl is allowed to carry extra blocks and then all of a sudden the
> > free space state changes and one transaction is allowed to free a bunch
> > of blocks. Thoughts?
> 
> That's exactly the sort of problem we need to measure, analyse
> and characterise before making this sort of change :/
> 
> > I suppose we could incorporate logic that frees until/unless a join
> > occurs (i.e., the last free did not drop flcount), the latter being an
> > indication that we've probably logged as much as we should for agfl
> > fixups in the transaction. But that's also something we could just do
> > unconditionally as opposed to only under dop_low conditions. That might
> > be less aggressive of a change from current behavior.
> 
> Heuristics will still need to be analysed and tested :/
> 
> The complexity of doing this is why I left a small comment rather
> than actually making the change....
> 
> > > I'm also concerned that it doesn't take into account that freeing
> > > a block from the AGFL could cause a freespace tree split to occur,
> > > thereby emptying the AGFL whilst consuming the entire log
> > > reservation for tree modifications. This leaves nothing in the log
> > > reservation for re-growing the AGFL to the minimum required, which
> > > we /must do/ before returning and could cause more splits/joins to
> > > occur.
> > > 
> > 
> > How is this different from the current code?
> 
> It's not. I'm pointing out that while you're focussed on the
> problems with shortening the AGFL, the same problem exists with
> /extending the AGFL/.
> 
> > This sounds to me like an
> > unconditional side effect of the fact that freeing an agfl block can
> > indirectly affect the agfl via the btree operations. IOW, freeing a
> > single extra block could require consuming one or more and trigger the
> > need for an allocation. I suspect the allocation could then very well
> > cause a join on the other tree and put more than one block back onto the
> > agfl.
> 
> Yes, it could do that too. Remove a single block from an existing
> free extent, no change to the by-block btree. by-cnt now requires a
> record delete (full height join) followed by record insert elsewhere
> in the tree (full height split). So the attempt to add a block to
> the AGFL can actually shorten it if the by-cnt tree splits on
> insert. It can grow if the by-block or by-cnt tree joins on record
> removal.
> 
> Either way, we've got the same problem of using the entire log
> reservation for AGFL modification when growing the AGFL as we do
> when trying to shrink the AGFL down.
> 
> That's my point here - just hacking a limit into the shrink case
> doesn't address the problem at all - it just papers over one of the
> visible symptoms....
> 

Yes, it's clear that the current code allows for all sorts of
theoretical avenues to transaction overrun. Hence my previous idea to
roll the transaction once an AGFL fixup triggers a join or split. Even
that may not be sufficient in certain scenarios.

Moving on from that, this patch is a variant of your suggestion to allow
leaving surplus blocks on the agfl up to a certain limit. It is
intentionally a more isolated fix for the specific issue of performing
too many independent allocations (frees) per transaction in this
context.

One approach doesn't have to preclude the other. I'm not aware of any
pattern of overrun problems with this code over the however many years
it has been in place, other than this one, however. Given that, I think
it's perfectly reasonable to consider a shorter term solution so long as
we're confident it doesn't introduce other problems.

> > > IMO, there's a lot more to be concerned about here than just trying
> > > to work around the specific symptom observed in the given test case.
> > > This code is, unfortunately, really tricky and intricate and history
> > > tells us that the risk of unexpected regressions is extremely high,
> > > especially around ENOSPC related issues. Of all the patches in this
> > > series, this is the most dangerous and "iffy" of them and the
> > > one we should be most concerned and conservative about....
> > > 
> > 
> > Agreed. The impact is something that also has to be evaluated over a
> > sequence of transactions along with the more obvious impact on a single
> > transaction.
> 
> The impact has to be measured over a far longer time frame than a
> few transactions. The fact it has impact on freespace reformation
> means it'll need accelerated aging tests done on it so we can be
> reasonably certain that it isn't going to bite us in extended
> production environments...
> 

That's exactly what I mean by a sequence. E.g., the effect on the agfl
over time. Clearly, the longer the sequence, the more robust the
results. I'm not sure where the idea that a few transactions would
provide anything useful comes from. This probably needs to be evaluated
over many cycles of fully depopulating and repopulating the space btrees
in different ways.

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
