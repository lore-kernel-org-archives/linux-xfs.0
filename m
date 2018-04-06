Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59424 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbeDFRbu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Apr 2018 13:31:50 -0400
Date: Fri, 6 Apr 2018 10:31:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/21] xfs: make xfs_bmapi_remapi work with attribute
 forks
Message-ID: <20180406173146.GK7500@magnolia>
References: <152269897182.16346.1710955088267364781.stgit@magnolia>
 <152269901338.16346.3950698529446189331.stgit@magnolia>
 <20180405231223.GK23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180405231223.GK23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 06, 2018 at 09:12:23AM +1000, Dave Chinner wrote:
> On Mon, Apr 02, 2018 at 12:56:53PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a new flags argument to xfs_bmapi_remapi so that we can pass BMAPI
> > flags into the function.  This enables us to pass in BMAPI_ATTRFORK so
> > that we can remap things into the attribute fork.  Eventually the
> > online repair code will use this to rebuild attribute forks, so make it
> > non-static.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c |   36 +++++++++++++++++++++++-------------
> >  fs/xfs/libxfs/xfs_bmap.h |    4 ++++
> >  2 files changed, 27 insertions(+), 13 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 519ef9c..c676d5c 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -4512,30 +4512,37 @@ xfs_bmapi_write(
> >  	return error;
> >  }
> >  
> > -static int
> > +int
> >  xfs_bmapi_remap(
> >  	struct xfs_trans	*tp,
> >  	struct xfs_inode	*ip,
> >  	xfs_fileoff_t		bno,
> >  	xfs_filblks_t		len,
> >  	xfs_fsblock_t		startblock,
> > -	struct xfs_defer_ops	*dfops)
> > +	struct xfs_defer_ops	*dfops,
> > +	int			flags)
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> > -	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> > +	struct xfs_ifork	*ifp;
> >  	struct xfs_btree_cur	*cur = NULL;
> >  	xfs_fsblock_t		firstblock = NULLFSBLOCK;
> >  	struct xfs_bmbt_irec	got;
> >  	struct xfs_iext_cursor	icur;
> > +	int			whichfork = xfs_bmapi_whichfork(flags);
> >  	int			logflags = 0, error;
> >  
> > +	ifp = XFS_IFORK_PTR(ip, whichfork);
> >  	ASSERT(len > 0);
> >  	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
> >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> > +	ASSERT(!(flags & (XFS_BMAPI_DELALLOC | XFS_BMAPI_COWFORK |
> > +			  XFS_BMAPI_ZERO | XFS_BMAPI_CONVERT |
> > +			  XFS_BMAPI_IGSTATE | XFS_BMAPI_METADATA |
> > +			  XFS_BMAPI_ENTIRE | XFS_BMAPI_CONVERT_ONLY)));
> 
> Wouldn't it be better just to assert it's a flag that is supported?
> i.e.
> 
> 	ASSERT(!flags || (flags & XFS_BMAPI_ATTRFORK));

Yes... but I want to allow XFS_BMAPI_PREALLOC too.

Ugh, that's a gross mess.

ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC)));

covers all four cases, I think.  Granted it probably needs a further
test to screen out (ATTRFORK | PREALLOC)...

> > @@ -4569,18 +4576,21 @@ xfs_bmapi_remap(
> >  	got.br_startoff = bno;
> >  	got.br_startblock = startblock;
> >  	got.br_blockcount = len;
> > -	got.br_state = XFS_EXT_NORM;
> > +	if (flags & XFS_BMAPI_PREALLOC)
> > +		got.br_state = XFS_EXT_UNWRITTEN;
> > +	else
> > +		got.br_state = XFS_EXT_NORM;
> 
> This seems unrelated to the attr fork support change?

Oops, yeah.  Will split this out into a separate patch.

--D

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
