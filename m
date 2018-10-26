Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:10987 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726275AbeJZTfV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Oct 2018 15:35:21 -0400
Date: Fri, 26 Oct 2018 21:58:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: speed up directory bestfree block scanning
Message-ID: <20181026105842.GG19305@dastard>
References: <20181024225716.19459-1-david@fromorbit.com>
 <20181024225716.19459-5-david@fromorbit.com>
 <20181026102424.GC29302@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181026102424.GC29302@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 26, 2018 at 03:24:24AM -0700, Christoph Hellwig wrote:
> > @@ -1767,11 +1767,10 @@ xfs_dir2_node_find_freeblk(
> >  		fbp = fblk->bp;
> >  		free = fbp->b_addr;
> >  		findex = fblk->index;
> > +		bests = dp->d_ops->free_bests_p(free);
> > +		dp->d_ops->free_hdr_from_disk(&freehdr, free);
> >  		if (findex >= 0) {
> >  			/* caller already found the freespace for us. */
> > -			bests = dp->d_ops->free_bests_p(free);
> > -			dp->d_ops->free_hdr_from_disk(&freehdr, free);
> > -
> 
> This hunk just undoes a move in the previous patch, might be better
> idea to just keep it as before there.
> 
> > +	for ( ; fbno < lastfbno; fbno++) {
> > +		/* If we don't have a freeblock in hand, get the next one. */
> >  		if (fbp == NULL) {
> > +			/* If it's ifbno we already looked at it. */
> > +			if (fbno == ifbno)
> > +				continue;
> > +
> 
> The only case where we have a fbp here is if we had a fblk passed in,
> but it it did have the index set to -1.  But as far as I can tell
> searching that again doesn't make any sense at all, so I'd apply
> something like this in top of your patch (some of this also seems
> to be in your next patch, so independent of the logic change might
> be worth moving over here):

So you've done a bunch of the rework that already in the next patch
in the series, plus a "fbno = fblk->blkno + 1;" logic change. 

Perhaps put this logic change at end of the series, rather than in
the middle where it breaks the rest of the changes?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
