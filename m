Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37906 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751089AbeDFQlr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Apr 2018 12:41:47 -0400
Date: Fri, 6 Apr 2018 09:41:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/21] xfs: add BMAPI_NORMAP flag to perform block
 remapping without updating rmapbt
Message-ID: <20180406164142.GJ7500@magnolia>
References: <152269897182.16346.1710955088267364781.stgit@magnolia>
 <152269900729.16346.3322708934701882860.stgit@magnolia>
 <20180405230722.GJ23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180405230722.GJ23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 06, 2018 at 09:07:22AM +1000, Dave Chinner wrote:
> On Mon, Apr 02, 2018 at 12:56:47PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a new flag, XFS_BMAPI_NORMAP, which will perform file block
> > remapping without updating the rmapbt.  This will be used by the repair
> > code to reconstruct bmbts from the rmapbt, in which case we don't want
> > the rmapbt update.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c |   25 ++++++++++++++++---------
> >  fs/xfs/libxfs/xfs_bmap.h |    6 +++++-
> >  2 files changed, 21 insertions(+), 10 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 3b03d88..519ef9c 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -1998,9 +1998,12 @@ xfs_bmap_add_extent_delay_real(
> >  	}
> >  
> >  	/* add reverse mapping */
> > -	error = xfs_rmap_map_extent(mp, bma->dfops, bma->ip, whichfork, new);
> > -	if (error)
> > -		goto done;
> > +	if (!(bma->flags & XFS_BMAPI_NORMAP)) {
> > +		error = xfs_rmap_map_extent(mp, bma->dfops, bma->ip,
> > +				whichfork, new);
> > +		if (error)
> > +			goto done;
> > +	}
> 
> Double negatives are a bit hard to parse (not NORMAP) but I don't
> have a better idea for this.

Yeah.  I'll update the comment to read:

/* add reverse mapping unless caller opted out */

to hammer on the point that updating rmap is the default, and callers
have to explicitly turn that off.

> 
> ....
> 
> > @@ -4119,7 +4125,8 @@ xfs_bmapi_allocate(
> >  	else
> >  		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip,
> >  				whichfork, &bma->icur, &bma->cur, &bma->got,
> > -				bma->firstblock, bma->dfops, &bma->logflags);
> > +				bma->firstblock, bma->dfops, &bma->logflags,
> > +				bma->flags);
> 
> Ob: The number of function parameters is starting to get out of hand
> again :/

I'd noticed.  TBH I've wondered why not just move whichfork into struct
xfs_bmalloca and then we can get rid of a lot of parameters and
whichfork passing?  Oh, right, because xfs_bmalloca.flags already has
XFS_BMAPI_{ATTR,COW}FORK so even that's unnecessary.

On the other hand bmapi_remap also calls _add_extent_hole_real, and it
(currently) doesn't create a xfs_bmalloca and maybe it's silly to make
it do that?

But that can be a cleanup patch for 4.18...

--D

> Regardless,
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
