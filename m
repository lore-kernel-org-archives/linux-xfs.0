Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Jun 2007 00:33:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l587XkWt007805
	for <xfs@oss.sgi.com>; Fri, 8 Jun 2007 00:33:48 -0700
Date: Fri, 8 Jun 2007 17:33:42 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: Be smarter about handling ENOSPC during writeback
Message-ID: <20070608073342.GW85884050@sgi.com>
References: <20070604045219.GG86004887@sgi.com> <E436D9833B42EFAE6C2CE987@timothy-shimmins-power-mac-g5.local> <F80A059A828DE0E57A655471@boing.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F80A059A828DE0E57A655471@boing.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jun 08, 2007 at 03:28:14PM +1000, Timothy Shimmin wrote:
> Hi Dave,
> 
> Putting the xfs_reserve_blocks discussion to the side....
> (discussed separately)

*nod*

BTW, did you try that patch I sent?

> > fs/xfs/xfs_fsops.c |   10 +++++++---
> 
> * allow xfs_reserve_blocks() to handle a null outval so that
>  we can call xfs_reserve_blocks other than thru ioctl,
>  where we don't care about outval
> * xfs_growfs_data_private() or's in XFS_TRANS_RESERVE like we do for root 
> EAs
>  -> allow growfs transaction to dip in to reserve space

Yes, and so now you can grow a completely full filesystem :)

> > fs/xfs/xfs_mount.c |   37 +++++++++++++++++++++++++++++++++++--
> 
> * xfs_mountfs(): cleanup - restrict a variable (ret64) to the block its 
> used in
> * xfs_mountfs(): do our xfs_reserve_blocks() for what we think we'll need
>  - pass NULL for 2nd param to it as we don't care (why we changed 
>  xfs_fsops.c)
>  - defaults to min(1024 FSBs, 5% dblocks)
>    -> not sure how one would choose this but it sounds big enough

It's a SWAG. I think it's sufficient to begin with. If it proves to
be a problem, then we can change it later....

> * xfs_unmountfs(): xfs_reserve_blocks of zero and so restoring the sb free 
> counter
> 
> Q: so I guess, for DMF systems which presumably turn this stuff on using 
> the ioctl;

yeah - the rope is long enough ;)

>   we should tell them to stop doing this - they could stuff us up by 
>   overriding it
>   maybe and they don't need to.

All they need to do is check first before setting a new value...

> > fs/xfs/xfs_iomap.c |   22 ++++++++--------------
> 
> * some whitespace cleanup
> xfs_iomap_write_allocate():
> * delalloc extent conversion - mark transaction for reserved blocks space
> * don't handle ENOSPC here, as we shouldn't get it now I presume

We still can, just much more unlikely. I need to do another set of
patches for ENOSPC notification but I haven't had a chance yet.

> xfs_iomap_write_unwritten
> * unwritten extent conversion - mark trans for reserved blocks

Ditto.

> Seems simple enough :)

It's just one of a few to begin with?

> Will we get questions from people about reduced space from df? :)

If we do, I think you just volunteered to write the FAQ entry ;)

Thanks for the review.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
