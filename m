Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53058 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753951AbcLPIrk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Dec 2016 03:47:40 -0500
Date: Fri, 16 Dec 2016 09:25:44 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/4] xfs: adjust allocation length in
        xfs_alloc_space_available
Message-ID: <20161216082544.GD32288@lst.de>
References: <1481644767-9098-1-git-send-email-hch@lst.de> <1481644767-9098-4-git-send-email-hch@lst.de> <20161216002851.GW4219@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161216002851.GW4219@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Fri, Dec 16, 2016 at 11:28:51AM +1100, Dave Chinner wrote:
> >  	/* do we have enough free space remaining for the allocation? */
> >  	available = (int)(pag->pagf_freeblks + pag->pagf_flcount -
> > -			  reservation - min_free - args->total);
> > +			  reservation - min_free - args->minleft);
> 
> This is fine, but...
> 
> > -	if (available < (int)args->minleft || available <= 0)
> > +	if (available < (int)args->total)
> >  		return false;
> 
> this is where I begin to wonder. The "args->total" logic here just
> doesn't read cleanly to me. xfs_bmapi_write() says:

args->total is a complete mess, but the above just rearranged the
deckchairs by moving it to a different place in the equation without
changing the result..

> So if we are asked to allocate 1 block, but the AG doesn't have 10
> total blocks free, then allocation will fail. What this is used for
> is to chain multiple independent data block allocations together in
> a single transaction to attempt to get them all from the one AG.
> This is used only by the directory/attr code for ensuring all the
> allocations needed to add an entry to the dir/attr tree will succeed.
> It's essentially an "external block reservation" as the AGF will be
> held locked across the multiple allocations once the first
> allocation has been done.

Symlink creation also uses it to cover the blocks for the symlink
body.  And unlike all users it actually seems to get the semantics
right by decrementing the used blocks from args->total after each
allocation..

> The only time "total" is actually meaningful is the first
> allocation in a chain. i.e. when firstblock is null. It's really a
> "free blocks required to proceed" parameter , not a length
> bound for the current allocation.

Yes.

> However, it's impact is to set a maximum length bound on the
> allocation, so I'm left to wonder why this was is being hidden this
> inside xfs_alloc_space_available() rather than dealing with it when
> setting up args->maxlen/minlen/minleft in xfs_bmap_btalloc()?
> 
> i.e args->maxlen must always be less than args->total. And if we are
> using minleft to protect against running out of space for
> bmbt/rmapbt allocation, then I think it should be args->maxlen +
> args->minleft < args->total.
> 
> If this can all be done and enforced in xfs_bmap_btalloc(), then we
> can get rid of args->total from the allocargs completely...

My long terms plan was to kill it of in favour of passing a minleft
parameter that's only set on the first call to xfs_bmapi_write.
But I didn't fancy rewriting hairy parts of the dir code while trying
to get an urgent customer escalation fixed..

> 
> 
> > +	/*
> > +	 * Clamp maxlen to the amount of free space available for the actual
> > +	 * extent allocation.
> > +	 */
> > +	if (available < (int)args->maxlen && !(flags & XFS_ALLOC_FLAG_CHECK)) {
> > +		args->maxlen = available;
> > +		ASSERT(args->maxlen > 0);
> > +	}
> 
> I'd love to get rid of all these (int) casts, too...

The problem here is that we compare 32-bit signed to 32-bit unsigned
variables.  And given that this is ripe for nasty bugs due to the C
type promotion rules I'd rather be extra careful.
