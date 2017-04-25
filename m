Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:32880 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1175902AbdDYHaO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 03:30:14 -0400
Date: Tue, 25 Apr 2017 09:30:07 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 04/10] xfs: remove an unsafe retry in
        xfs_bmbt_alloc_block
Message-ID: <20170425073007.GA26944@lst.de>
References: <20170413080517.12564-1-hch@lst.de> <20170413080517.12564-5-hch@lst.de> <20170413183006.GD25915@bfoster.bfoster> <20170414074658.GA24766@lst.de> <20170417141923.GB41659@bfoster.bfoster> <20170418075455.GA23085@lst.de> <20170418141819.GB46764@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170418141819.GB46764@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Apr 18, 2017 at 10:18:19AM -0400, Brian Foster wrote:
> > minleft must be in the same AG because we can't allocate from another
> > AG in the same transaction.  If we didn't respect this our whole allocator
> > would break apart..
> > 
> 
> I'm confused. Didn't we just confirm in the previous email (the part you
> trimmed) that multiple AG locking/allocation is safe, so long as locking
> occurs in ascending AG order..?

Its is.  But we have no way to account for space available in AG N or
higher, so we have to lock us into the same AG.

> > > Not all bmbt block allocations are tied to extent allocations. This is
> > > the firstblock == NULLFSBLOCK case after all, which I take it means an
> > > allocation hasn't yet occurred. IOW, what about other potentially
> > > record-inserting operations like hole punch, extent conversion, etc.?
> > 
> > Yes, for other ops we might not have allocated anything yet, but we
> > might have to do more operations later and thus respect the minleft
> > later.  This is especially bad for directory operations that do
> > multiple calls to xfs_bmapi_write in the same transaction.
> 
> Fair point. I don't discount that dropping minleft here might be
> inappropriate or even harmful for some contexts (that's what I meant by
> not having audited all possible codepaths). Rather, my point is that we
> apparently do also have some contexts where the minleft retry is
> important. E.g., the hole punch example may have successfully allocated
> a transaction, reserved a number of blocks that could be across any
> number of AGs, dirtied the transaction, and then got here attempting to
> allocate blocks only to now fail due to the more restrictive allocation
> logic and ultimately shutdown the fs.

I don't think it's important there, it's just as harmful as everywhere
else.  Say we have a xfs_unmap_extent that requires allocating more than
one new btree block.  If our allocation for the first one goes through due
to the minleft retry only we'll successfully do the first split, and then
fail the second one at which point the transaction is dirty.
If we do however properly respect minleft we'll fail the first allocation
in this case and are better off in the end.  The only downside is that
we might get ENOSPC a little earlier when we might not use up the full
reservation, but at least we never get it with a dirty transaction.

> IOWs, it sounds like we're potentially playing whack a mole with
> allocation failure here, improving likelihood of success in one context
> while reducing it in another. Is there something we can do to
> conditionally use the retry (perhaps check if the tp is dirty, since at
> that point shutdown is inevitable?) rather than remove it, or am I
> missing something else as to why this shouldn't be a problem for
> contexts that might not have called into the allocator before bmbt block
> allocation?

It's not a problem because now all our allocator calls set the right
minleft / total value to make sure subsequent allocations go through.
For BESTEFFORT allocations we calculate minleft on demand for the max
btree allocations, and for all others the caller passes a total value
that is respected by every allocation.
