Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60789 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751277AbdINNXu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Sep 2017 09:23:50 -0400
Date: Thu, 14 Sep 2017 15:23:49 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/17] xfs: refactor xfs_bmap_add_extent_delay_real
Message-ID: <20170914132348.GA25202@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170908171855.GA905@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Sep 08, 2017 at 01:18:56PM -0400, Brian Foster wrote:
> > -		xfs_bmbt_set_startblock(ep, new->br_startblock);
> > -		xfs_bmbt_set_blockcount(ep,
> > -			PREV.br_blockcount + RIGHT.br_blockcount);
> > +		PREV.br_startblock = new->br_startblock;
> > +		PREV.br_blockcount += RIGHT.br_blockcount;
> > +		xfs_iext_update_extent(ifp, bma->idx, &PREV);
> 
> I think using PREV without setting the state here is a bit of a landmine
> because the contiguity checking logic above only verifies that the new
> extent state matches the associated neighbors. This is not really a
> problem introduced by the patch, nor something that is likely to result
> in a real problem due to context, but it would be nice to fix up since
> the overall pattern of this function seems to be copied around a bit
> more nowadays.

The caller gurantees that PREV is delayed allocation - it's keyed
off the bma->wasdel that is only set in this case.

I can add an assert like this, though:

	ASSERT(isnullstartblock(PREV.br_startblock));

> It looks like this was shuffled around to do the updates within the
> appropriate pre/post tracepoints. Any reason not to continue to keep the
> in-core extent list update before the on-disk update as before, however?
> (Same question for some of the hunks below as well).

For a the BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG I could move it up,
but in many cases we rely on bma->cur->bc_private.b.allocated to
calculate the indirect block reservation, so setting the startblock val
needs to be after ةodifying the on-disk btree.  That's also the reason
why the old code was written in an odd way where some fields where update
before, but the rest only after the on-disk update.

> >  		if (bma->cur == NULL)
> >  			rval = XFS_ILOG_DEXT;
> >  		else {
> > @@ -1943,18 +1943,20 @@ xfs_bmap_add_extent_delay_real(
> >  				goto done;
> >  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> >  			error = xfs_bmbt_update(bma->cur, new->br_startoff,
> > -					new->br_startblock,
> > -					new->br_blockcount +
> > -					RIGHT.br_blockcount,
> > -					RIGHT.br_state);
> > +					new->br_startblock, new->br_blockcount,
> > +					new->br_state);
> 
> The immediately previous code (not shown) looks up RIGHT, which has
> already been updated above to cover (new + RIGHT) and so does not exist
> in the bmapbt. This code now attempts to update that extent to new,
> which hasn't been updated to cover RIGHT.

Yes, that change is incorrect and should use the "old" copy like
in other places.  Looks like nothing in xfstests hits this case,
which seems odd.

> The use of temp seems unnecessary (perhaps not just here), particularly
> since you could modify PREV.br_blockcount as this patch has been doing
> elsewhere.

I think it keeps things a little cleaner - we calculate temp and
da_new first, and then set each field of the extent structure,  But
it could work either way.

> > @@ -2078,12 +2084,16 @@ xfs_bmap_add_extent_delay_real(
> >  				goto done;
> >  		}
> >  
> > -		ep = xfs_iext_get_ext(ifp, bma->idx);
> > -		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
> > +		trace_xfs_bmap_pre_update(bma->ip, bma->idx, 0, _THIS_IP_);
> > +		PREV.br_startblock = nullstartblock(temp);
> > +		PREV.br_blockcount = temp;	/* truncate PREV */
> > +		xfs_iext_update_extent(ifp, bma->idx, &PREV);
> >  		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
> > +
> > +		/* update to the final reservation: */
> >  		trace_xfs_bmap_pre_update(bma->ip, bma->idx + 2, state, _THIS_IP_);
> > -		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, bma->idx + 2),
> > -			nullstartblock((int)temp2));
> > +		RIGHT.br_startblock = nullstartblock(temp2);
> > +		xfs_iext_update_extent(ifp, bma->idx + 2, &RIGHT);
> 
> I'm wondering if this last hunk can be removed. Has RIGHT.br_startblock
> actually changed since set above?

Looks like it hasn't and it should be safe to remove.
