Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49496 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751456AbdDROSk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Apr 2017 10:18:40 -0400
Date: Tue, 18 Apr 2017 10:18:19 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 04/10] xfs: remove an unsafe retry in xfs_bmbt_alloc_block
Message-ID: <20170418141819.GB46764@bfoster.bfoster>
References: <20170413080517.12564-1-hch@lst.de>
 <20170413080517.12564-5-hch@lst.de>
 <20170413183006.GD25915@bfoster.bfoster>
 <20170414074658.GA24766@lst.de>
 <20170417141923.GB41659@bfoster.bfoster>
 <20170418075455.GA23085@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170418075455.GA23085@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 18, 2017 at 09:54:55AM +0200, Christoph Hellwig wrote:
> On Mon, Apr 17, 2017 at 10:19:23AM -0400, Brian Foster wrote:
> > I don't see anything about setting minleft here that says the allocation
> > is required to come from one AG as opposed to that simply being
> > preferred.
> 
> minleft must be in the same AG because we can't allocate from another
> AG in the same transaction.  If we didn't respect this our whole allocator
> would break apart..
> 

I'm confused. Didn't we just confirm in the previous email (the part you
trimmed) that multiple AG locking/allocation is safe, so long as locking
occurs in ascending AG order..?

> > Not all bmbt block allocations are tied to extent allocations. This is
> > the firstblock == NULLFSBLOCK case after all, which I take it means an
> > allocation hasn't yet occurred. IOW, what about other potentially
> > record-inserting operations like hole punch, extent conversion, etc.?
> 
> Yes, for other ops we might not have allocated anything yet, but we
> might have to do more operations later and thus respect the minleft
> later.  This is especially bad for directory operations that do
> multiple calls to xfs_bmapi_write in the same transaction.

Fair point. I don't discount that dropping minleft here might be
inappropriate or even harmful for some contexts (that's what I meant by
not having audited all possible codepaths). Rather, my point is that we
apparently do also have some contexts where the minleft retry is
important. E.g., the hole punch example may have successfully allocated
a transaction, reserved a number of blocks that could be across any
number of AGs, dirtied the transaction, and then got here attempting to
allocate blocks only to now fail due to the more restrictive allocation
logic and ultimately shutdown the fs.

IOWs, it sounds like we're potentially playing whack a mole with
allocation failure here, improving likelihood of success in one context
while reducing it in another. Is there something we can do to
conditionally use the retry (perhaps check if the tp is dirty, since at
that point shutdown is inevitable?) rather than remove it, or am I
missing something else as to why this shouldn't be a problem for
contexts that might not have called into the allocator before bmbt block
allocation?

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
