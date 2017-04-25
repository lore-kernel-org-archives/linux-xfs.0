Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51560 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1176515AbdDYMLd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 08:11:33 -0400
Date: Tue, 25 Apr 2017 08:11:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 04/10] xfs: remove an unsafe retry in xfs_bmbt_alloc_block
Message-ID: <20170425121131.GA16228@bfoster.bfoster>
References: <20170413080517.12564-1-hch@lst.de>
 <20170413080517.12564-5-hch@lst.de>
 <20170413183006.GD25915@bfoster.bfoster>
 <20170414074658.GA24766@lst.de>
 <20170417141923.GB41659@bfoster.bfoster>
 <20170418075455.GA23085@lst.de>
 <20170418141819.GB46764@bfoster.bfoster>
 <20170425073007.GA26944@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170425073007.GA26944@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 25, 2017 at 09:30:07AM +0200, Christoph Hellwig wrote:
> On Tue, Apr 18, 2017 at 10:18:19AM -0400, Brian Foster wrote:
> > > minleft must be in the same AG because we can't allocate from another
> > > AG in the same transaction.  If we didn't respect this our whole allocator
> > > would break apart..
> > > 
> > 
> > I'm confused. Didn't we just confirm in the previous email (the part you
> > trimmed) that multiple AG locking/allocation is safe, so long as locking
> > occurs in ascending AG order..?
> 
> Its is.  But we have no way to account for space available in AG N or
> higher, so we have to lock us into the same AG.
> 

It may be true that we don't know whether space is available in higher
AGs. My point is that it seems like we can get here with a dirty
transaction without any assurance that any one AG can satisfy minleft.
Therefore, it appears that the purpose of the low free space allocator
is to try _really hard_ to allocate a block in a context where not doing
so is a catastrophic error for the filesystem.

The logic used above sounds like you are saying that the low free space
allocator can't guarantee an allocation, so we can't use it. I agree
that it may not guarantee an allocation. I'm contending that the low
free space allocator serves a purpose by facilitating allocations in
cases where nothing else ensures a single AG can satisfy minleft from
this context and thus that any allocation failure (even when firstblock
== NULLFSBLOCK) may result in shutdown.

> > > > Not all bmbt block allocations are tied to extent allocations. This is
> > > > the firstblock == NULLFSBLOCK case after all, which I take it means an
> > > > allocation hasn't yet occurred. IOW, what about other potentially
> > > > record-inserting operations like hole punch, extent conversion, etc.?
> > > 
> > > Yes, for other ops we might not have allocated anything yet, but we
> > > might have to do more operations later and thus respect the minleft
> > > later.  This is especially bad for directory operations that do
> > > multiple calls to xfs_bmapi_write in the same transaction.
> > 
> > Fair point. I don't discount that dropping minleft here might be
> > inappropriate or even harmful for some contexts (that's what I meant by
> > not having audited all possible codepaths). Rather, my point is that we
> > apparently do also have some contexts where the minleft retry is
> > important. E.g., the hole punch example may have successfully allocated
> > a transaction, reserved a number of blocks that could be across any
> > number of AGs, dirtied the transaction, and then got here attempting to
> > allocate blocks only to now fail due to the more restrictive allocation
> > logic and ultimately shutdown the fs.
> 
> I don't think it's important there, it's just as harmful as everywhere
> else.  Say we have a xfs_unmap_extent that requires allocating more than
> one new btree block.  If our allocation for the first one goes through due
> to the minleft retry only we'll successfully do the first split, and then
> fail the second one at which point the transaction is dirty.

I understand this case and I don't disagree at all with the principle to
fail early and cleanly rather than risk fs shutdown.

> If we do however properly respect minleft we'll fail the first allocation
> in this case and are better off in the end.  The only downside is that
> we might get ENOSPC a little earlier when we might not use up the full
> reservation, but at least we never get it with a dirty transaction.
> 

As noted in my last email, I don't think it's true that you always fail
here without a dirty transaction. I used the hole punch example because
I observed initial allocations from this context with a dirty
transaction. This is also why I suggested the possibility of restricting
the retry based on the transaction dirty state rather than ripping it
out entirely. Despite the ugliness, do you see a problem with doing
something like that?

> > IOWs, it sounds like we're potentially playing whack a mole with
> > allocation failure here, improving likelihood of success in one context
> > while reducing it in another. Is there something we can do to
> > conditionally use the retry (perhaps check if the tp is dirty, since at
> > that point shutdown is inevitable?) rather than remove it, or am I
> > missing something else as to why this shouldn't be a problem for
> > contexts that might not have called into the allocator before bmbt block
> > allocation?
> 
> It's not a problem because now all our allocator calls set the right
> minleft / total value to make sure subsequent allocations go through.
> For BESTEFFORT allocations we calculate minleft on demand for the max
> btree allocations, and for all others the caller passes a total value
> that is respected by every allocation.

I think I'm not being quite clear and we're arguing past eachother a bit
here. I do not disagree at all that the fail early behavior you describe
above is an ideal tradeoff for not allowing the use of every last block
in the fs before ENOSPC, and in general that is a fine direction to move
in.

Rather, what I'm arguing here is that it is not safe to remove the low
free space allocator until we've dealt with all possible cases where it
could prevent shutdown. AFAICT, it is still possible to get to bmbt
allocation context with something like the following general sequence of
events:

	- filesystem is near full
	- allocate a transaction and reserve N blocks
		- block reservation succeeds, but no single AG has N
		  free blocks (the N reserved blocks are spread out
		  across the fs)
	- start executing a hole punch operation
	- dirty the transaction
	- bmbt block allocation occurs - set minleft = N
		 - allocation fails because no single AG satisfies the N
		   blocks from the tx
	- retry bmbt block allocation - reset minleft and use _FIRST_AG
		- i.e., allocate from any AG starting from AG 0 and
		  activate the low space allocator for any subsequent
		  bmbt allocs
	- subsequent bmbt alklocs should (in theory)[1] succeed because
	  we've reserved N blocks out the fs, and we can allocate one at
	  a time starting from where the previous alloc left off

... and therefore it is not quite safe to rip out the low free space
allocator from this particular context. Note that the transaction is
dirty before we ever attempt the first allocation, so failing the
allocation with minleft = N is not safe.

Also note that I'm not claiming we always get here with a dirty
transaction, only that we can in some cases and in those particular
cases, we may still need the low space allocator to prevent shutdown. It
may be fine to skip the retry and return ENOSPC, as you suggest, if the
transaction is clean.

Brian

[1] I'm not totally confident that a reservation of N blocks means we
can actually allocate N blocks across the entire set of AGs, but that's
not really the point here. The transaction probably overreserves and in
practice we should be able to complete an associated operation when the
reservation succeeds.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
