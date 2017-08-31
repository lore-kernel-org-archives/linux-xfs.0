Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38255 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751307AbdHaXiR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 19:38:17 -0400
Date: Thu, 31 Aug 2017 16:37:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix compiler warnings
Message-ID: <20170831233746.GS3775@magnolia>
References: <20170831222824.GQ3775@magnolia>
 <20170831230946.GT10621@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170831230946.GT10621@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@infradead.org>

On Fri, Sep 01, 2017 at 09:09:46AM +1000, Dave Chinner wrote:
> On Thu, Aug 31, 2017 at 03:28:24PM -0700, Darrick J. Wong wrote:
> > Fix up all the compiler warnings about unused variables that have crept in.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_inode_fork.c |    9 +++------
> >  fs/xfs/xfs_buf_item.c          |    4 ++++
> >  fs/xfs/xfs_log_recover.c       |    4 ++++
> >  3 files changed, 11 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index fb310d0..31840ca 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -1499,14 +1499,11 @@ xfs_iext_realloc_indirect(
> >  	xfs_ifork_t	*ifp,		/* inode fork pointer */
> >  	int		new_size)	/* new indirection array size */
> >  {
> > -	int		nlists;		/* number of irec's (ex lists) */
> > -	int		size;		/* current indirection array size */
> > -
> >  	ASSERT(ifp->if_flags & XFS_IFEXTIREC);
> > -	nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
> > -	size = nlists * sizeof(xfs_ext_irec_t);
> >  	ASSERT(ifp->if_real_bytes);
> > -	ASSERT((new_size >= 0) && (new_size != size));
> > +	ASSERT((new_size >= 0) &&
> > +	       (new_size != ((ifp->if_real_bytes / XFS_IEXT_BUFSZ) *
> > +			     sizeof(xfs_ext_irec_t))));
> >  	if (new_size == 0) {
> >  		xfs_iext_destroy(ifp);
> >  	} else {
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index f5d25f5..806b17e 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -570,12 +570,16 @@ xfs_buf_item_unlock(
> >  	bool			aborted;
> >  	bool			hold;
> >  	bool			dirty;
> > +#ifdef DEBUG
> >  	bool			ordered;
> > +#endif
> >  
> >  	aborted = !!(lip->li_flags & XFS_LI_ABORTED);
> >  	hold = !!(bip->bli_flags & XFS_BLI_HOLD);
> >  	dirty = !!(bip->bli_flags & XFS_BLI_DIRTY);
> > +#ifdef DEBUG
> >  	ordered = !!(bip->bli_flags & XFS_BLI_ORDERED);
> > +#endif
> 
> I'd revert the last patch that changed this code (because it's
> busted!) and just do this here:
> 
> +#ifdef DEBUG
> 	bool                    ordered = !!(bip->bli_flags & XFS_BLI_ORDERED);
> +#endif
> 
> Also, feel free to rebase for-next to get rid of that last patch -
> just like linux-next, for-next isn't meant to be 100% stable. IMO
> it's better at this point to rebase for-next to remove/correct
> mistakes than to have commits in the tree that don't work....

Ok.  Sorry about the noise, everyone.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
