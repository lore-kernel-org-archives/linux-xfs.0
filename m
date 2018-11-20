Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:3432 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725977AbeKUHlK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Nov 2018 02:41:10 -0500
Date: Wed, 21 Nov 2018 08:08:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/7] xfs: delalloc -> unwritten COW fork allocation can
 go wrong
Message-ID: <20181120210844.GQ19305@dastard>
References: <20181119210459.8506-1-david@fromorbit.com>
 <20181120063605.GN19305@dastard>
 <20181120134537.GB47711@bfoster>
 <20181120163349.GB7805@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181120163349.GB7805@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Nov 20, 2018 at 08:33:49AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 20, 2018 at 08:45:38AM -0500, Brian Foster wrote:
> > >  		 * Filling in all of a previously delayed allocation extent.
> > > -		 * The right neighbor is contiguous, the left is not.
> > > +		 * The right neighbor is contiguous, the left is not. Take care
> > > +		 * with delay -> unwritten extent allocation here because the
> > > +		 * delalloc record we are overwriting is always written.
> > >  		 */
> > >  		PREV.br_startblock = new->br_startblock;
> > >  		PREV.br_blockcount += RIGHT.br_blockcount;
> > > +		PREV.br_state = new->br_state;
> > >  
> > >  		xfs_iext_next(ifp, &bma->icur);
> > >  		xfs_iext_remove(bma->ip, &bma->icur, state);
> > 
> > Fix looks sane to me, though I'm a little curious why this doesn't
> > follow the "contiguous extent extension" pattern that most of the other
> > contig cases seem to follow. For example, something like the following
> > for the right contig case:
> > 
> >                 old = RIGHT;
> >                 RIGHT.br_startoff = new->br_startoff;
> >                 RIGHT.br_startblock = new->br_startblock;
> >                 RIGHT.br_blockcount += new.br_blockcount;
> > 
> >                 xfs_iext_remove(bma->ip, &bma->icur, state); /* PREV */
> >                 xfs_iext_next(ifp, &bma->icur);
> >                 xfs_iext_update_extent(bma->ip, state, &bma->icur, &RIGHT);
> > 
> > ... and change the subsequent btree update to use old/RIGHT. Maybe
> > Christoph has thoughts on that.
> 
> Not sure the above looks much better.  If I had to do something
> different I'd apply something like this (untested) on top of Daves patch:
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 91b94c5c0cae..efe9e554fd0d 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1698,14 +1698,12 @@ xfs_bmap_add_extent_delay_real(
>  		 * with delay -> unwritten extent allocation here because the
>  		 * delalloc record we are overwriting is always written.
>  		 */
> -		PREV.br_startblock = new->br_startblock;
> -		PREV.br_blockcount += RIGHT.br_blockcount;
> -		PREV.br_state = new->br_state;
> +		new->br_blockcount += RIGHT.br_blockcount;
>  
>  		xfs_iext_next(ifp, &bma->icur);
>  		xfs_iext_remove(bma->ip, &bma->icur, state);
>  		xfs_iext_prev(ifp, &bma->icur);
> -		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
> +		xfs_iext_update_extent(bma->ip, state, &bma->icur, new);
>  
>  		if (bma->cur == NULL)
>  			rval = XFS_ILOG_DEXT;

And that's buggy because it doesn't update the BMBT record
correctly - it uses PREV to overwrite RIGHT, and so this will write
the delalloc record into the BMBT, not the new merged unwritten
extent...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
