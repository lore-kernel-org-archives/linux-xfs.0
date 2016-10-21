Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933052AbcJUOlf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Oct 2016 10:41:35 -0400
Date: Fri, 21 Oct 2016 10:41:33 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: fix the AG loop in xfs_alloc_vextent for busy
 extents
Message-ID: <20161021144133.GA54851@bfoster.bfoster>
References: <1476735753-5861-1-git-send-email-hch@lst.de>
 <1476735753-5861-2-git-send-email-hch@lst.de>
 <20161019134806.GB28993@bfoster.bfoster>
 <20161021124824.GA17667@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161021124824.GA17667@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, michaelcallahan@fb.com

On Fri, Oct 21, 2016 at 02:48:24PM +0200, Christoph Hellwig wrote:
> On Wed, Oct 19, 2016 at 09:48:08AM -0400, Brian Foster wrote:
> > >  			if (args->agbp) {
> > > -				if ((error = xfs_alloc_ag_vextent(args)))
> > > +				error = xfs_alloc_ag_vextent(args);
> > > +				if (error)
> > >  					goto error0;
> > > -				break;
> > > +				if (args->agbno != NULLAGBLOCK)
> > > +					break;
> > > +				xfs_trans_brelse(args->tp, args->agbp);
> > 
> > How is this safe with respect to xfs_alloc_fix_freelist() potentially
> > dirtying the agf? Haven't we had deadlock and/or other problems due to
> > xfs_alloc_fix_freelist() succeeding when an allocation ultimately fails,
> > and subsequently rotating to a potentially lower agno?
> 
> We've had the case where the allocation would fail despite
> xfs_alloc_fix_freelist succeeding forever, it's just that with
> discard in general and async discard in particular we can hit it
> much more easily.
> 

Perhaps, but I think that is beside the point. IME, any time that has
resulted in such a deadlock, we attribute it to the fact that
xfs_alloc_fix_freelist() succeeded in a case where it shouldn't have. I
don't think we should introduce more of such cases if we can help it.

> The only way to make the allocation no fail if xfs_alloc_fix_freelist
> succeeded would be to force out any busy extents at the low level
> if we are tigh on space, I'll have to see how doable that would be.
> 
> The other option would be to roll around the transaction when switching
> to a different AG so that we can release the locks.  That sounds a lot
> easier, and also less fragile in the long run.

That sounds reasonable provided we don't have any partial modifications
or whatnot in the transaction. Another angle might be to find a way to
take the busy extents into consideration before xfs_alloc_fix_freelist()
actually makes any changes, but I also don't know how straightforward
that might be either.

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
