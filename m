Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49587 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbfEMPpr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 May 2019 11:45:47 -0400
Date: Mon, 13 May 2019 11:45:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/6] xfs: use locality optimized cntbt lookups for near
 mode allocations
Message-ID: <20190513154544.GE61135@bfoster>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-4-bfoster@redhat.com>
 <20190510173110.GC18992@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510173110.GC18992@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, May 10, 2019 at 10:31:10AM -0700, Christoph Hellwig wrote:
> Still digesting the algorithmic changes, but a few nitpicks below:
> 

Ok. FWIW, note that this patch contains the core algorithm changes
(associated with NEAR alloc mode) and core factoring changes. The
remaining modes are intended to be refactors that for the most part
preserve the current algorithms.

> >  /*
> > + * BLock allocation algorithm and data structures.
> 
> I think the upper case L is a typo.
> 

Yep.

> > +struct xfs_alloc_btree_cur {
> > +	struct xfs_btree_cur	*cur;		/* cursor */
> > +	bool			active;		/* cursor active flag */
> > +};
> 
> Can't we move the active flag inside the btree_cur, more specically
> into enum xfs_btree_cur_private?
> 

Hmm, I had attempted some tighter integration with the xfs_btree_cur on
a previous variant and ran into some roadblocks, the details of which I
don't recall. That said, I may have tried to include more than just this
active state, ran into header issues, and then never really stepped back
from that to explore more incremental changes.

I think extending the priv union with something for the allocation code
to use makes sense. Your suggestion has me wondering if down the road we
could genericize this further to a bc_valid state or some such that
quickly indicates whether a cursor points at a valid record or off into
space. That's a matter for another series however..

> Or maybe we should byte the bullet and make xfs_btree_cur a structure
> embedded into the type specific structures and use container_of.
> But I certainly don't want to burden that on you and this series..

You mean to create tree specific cursor structures of which
xfs_btree_cur is a member, then the tree specific logic uses
container_of() to pull out whatever it needs from cur..? I'd need to
think more about that one, but indeed that is beyond the scope of this
work.

I do intend to take a closer look at what further cleanups this rework
might facilitate once finalized, but in my mind the initial target are
allocation bits like xfs_alloc_arg and replacing/condensing some of that
with the xfs_alloc_cur structure introduced here. I don't want to get
too far into that until the functional and factoring bits are settled
some, however..

Brian
