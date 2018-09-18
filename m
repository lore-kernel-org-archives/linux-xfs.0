Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:53358 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725778AbeISEft (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Sep 2018 00:35:49 -0400
Date: Wed, 19 Sep 2018 09:00:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: delalloc and reflink fixes & tweaks
Message-ID: <20180918230057.GK27618@dastard>
References: <20180917205354.15401-1-hch@lst.de>
 <20180917212323.GF16550@dastard>
 <20180918181728.GA7171@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180918181728.GA7171@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Sep 18, 2018 at 08:17:28PM +0200, Christoph Hellwig wrote:
> On Tue, Sep 18, 2018 at 07:23:23AM +1000, Dave Chinner wrote:
> > Do you have any numbers that demonstrate the performance impact of
> > the preallocation change? We've always intended to fix this exposure
> > issue as you've done, I'm just interested in the sort of impact it
> > has (if any).
> 
> For the absolute worst case - completely random 4k writes to a sparse
> file I see a slowdown of about 3%.  Which is less than the improvement
> that we saw from removing buffer heads.

Nice! I didn't expect a huge hit, and this is right in the ballpark
of what I was expecting. I think we can live with this.

> > Also, with this change to use unwritten extents for all delalloc
> > extents, we can start doing speculative preallocation for writes
> > into holes inside EOF without leaving uninitialised/unzeroed blocks
> > laying around.
> 
> Careful.  We already have issues because delalloc blocks before EOF don't
> ever get reclaimed.  This triggers up on xfs/442 with 1k blocksize for
> me.  I actually have a fix for that now, but that will require dropping
> one of the cleanup patches from this series, so expect a respin.

Yeah, I didn't say everything already worked, just that using
preallocation for delalloc gets rid of the stale data exposure
problem that has prevented us from doing this in the past.

(Technically speaking, it has already been done in the past - ~1999,
IIRC - but that got yanked pretty quickly when the stale data
exposure problems were reported ;)

> If we want to more generic preallocation I guess we should follow the
> example of the COW direct I/O path and mark all preallocated extents
> as unwritten - that way we know delalloc extents that have the unwritten
> bit set can be safely reclaimed.  But that is more work than I want
> to do for this merge window at least.

That's sounds like a good idea, and a good direction to head
towards. No immediate hurry, just trying to understand where you
might be going with these changes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
