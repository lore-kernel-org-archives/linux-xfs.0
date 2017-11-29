Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57174 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752250AbdK2UgI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Nov 2017 15:36:08 -0500
Date: Wed, 29 Nov 2017 15:36:06 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs: amortize agfl block frees across multiple
 transactions
Message-ID: <20171129203605.GA25833@bfoster.bfoster>
References: <20171127202434.43125-1-bfoster@redhat.com>
 <20171127202434.43125-4-bfoster@redhat.com>
 <20171127230734.GB5858@dastard>
 <20171128135748.GC45759@bfoster.bfoster>
 <20171128220919.GF5858@dastard>
 <20171129182453.GA24696@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171129182453.GA24696@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 29, 2017 at 01:24:53PM -0500, Brian Foster wrote:
> On Wed, Nov 29, 2017 at 09:09:19AM +1100, Dave Chinner wrote:
> > On Tue, Nov 28, 2017 at 08:57:48AM -0500, Brian Foster wrote:
> > > On Tue, Nov 28, 2017 at 10:07:34AM +1100, Dave Chinner wrote:
> > > > On Mon, Nov 27, 2017 at 03:24:33PM -0500, Brian Foster wrote:
...
> > > This sounds to me like an
> > > unconditional side effect of the fact that freeing an agfl block can
> > > indirectly affect the agfl via the btree operations. IOW, freeing a
> > > single extra block could require consuming one or more and trigger the
> > > need for an allocation. I suspect the allocation could then very well
> > > cause a join on the other tree and put more than one block back onto the
> > > agfl.
> > 
> > Yes, it could do that too. Remove a single block from an existing
> > free extent, no change to the by-block btree. by-cnt now requires a
> > record delete (full height join) followed by record insert elsewhere
> > in the tree (full height split). So the attempt to add a block to
> > the AGFL can actually shorten it if the by-cnt tree splits on
> > insert. It can grow if the by-block or by-cnt tree joins on record
> > removal.
> > 
> > Either way, we've got the same problem of using the entire log
> > reservation for AGFL modification when growing the AGFL as we do
> > when trying to shrink the AGFL down.
> > 
> > That's my point here - just hacking a limit into the shrink case
> > doesn't address the problem at all - it just papers over one of the
> > visible symptoms....
> > 
> 
> Yes, it's clear that the current code allows for all sorts of
> theoretical avenues to transaction overrun. Hence my previous idea to
> roll the transaction once an AGFL fixup triggers a join or split. Even
> that may not be sufficient in certain scenarios.
> 

Random thought from this afternoon...

What do you think about unconditionally removing surplus agfl blocks as
we do today, but defer them rather than free them immediately? We'd free
up the agfl slots as needed so the allocation can proceed, but we'd
eliminate the behavior where agfl frees recursively affect the agfl. The
broader idea is that in the event where 2+ agfl frees are required,
they'd now execute in a context where can enforce deterministic log
consumption per tx (by also implementing the 2 frees per EFD idea, for
example) until the agfl is rectified.

I'd have to think a little more about whether the idea is sane.. It
looks like we'd have to plumb dfops in through xfs_alloc_arg for
starters. We could do the defer conditionally based on whether the
caller passes dfops to facilitate incremental conversions. We also may
be able to consider optimizations like putting deferred agfl blocks
right back onto the agfl if there's a deficit by the time we get around
to freeing them (rather than doing an agfl alloc only to free up
deferred agfl blocks), but that's probably getting too far ahead for
now.

This also doesn't help with extending the agfl, but I think that path is
already more deterministic since we attempt to fill the deficit in as
few allocs as possible. Thoughts?

Brian

> Moving on from that, this patch is a variant of your suggestion to allow
> leaving surplus blocks on the agfl up to a certain limit. It is
> intentionally a more isolated fix for the specific issue of performing
> too many independent allocations (frees) per transaction in this
> context.
> 
> One approach doesn't have to preclude the other. I'm not aware of any
> pattern of overrun problems with this code over the however many years
> it has been in place, other than this one, however. Given that, I think
> it's perfectly reasonable to consider a shorter term solution so long as
> we're confident it doesn't introduce other problems.
> 
> > > > IMO, there's a lot more to be concerned about here than just trying
> > > > to work around the specific symptom observed in the given test case.
> > > > This code is, unfortunately, really tricky and intricate and history
> > > > tells us that the risk of unexpected regressions is extremely high,
> > > > especially around ENOSPC related issues. Of all the patches in this
> > > > series, this is the most dangerous and "iffy" of them and the
> > > > one we should be most concerned and conservative about....
> > > > 
> > > 
> > > Agreed. The impact is something that also has to be evaluated over a
> > > sequence of transactions along with the more obvious impact on a single
> > > transaction.
> > 
> > The impact has to be measured over a far longer time frame than a
> > few transactions. The fact it has impact on freespace reformation
> > means it'll need accelerated aging tests done on it so we can be
> > reasonably certain that it isn't going to bite us in extended
> > production environments...
> > 
> 
> That's exactly what I mean by a sequence. E.g., the effect on the agfl
> over time. Clearly, the longer the sequence, the more robust the
> results. I'm not sure where the idea that a few transactions would
> provide anything useful comes from. This probably needs to be evaluated
> over many cycles of fully depopulating and repopulating the space btrees
> in different ways.
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
