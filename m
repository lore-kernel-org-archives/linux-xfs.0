Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:32966 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732675AbeHAArQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 20:47:16 -0400
Date: Tue, 31 Jul 2018 16:04:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: check da node magic in _node_lookup_int
Message-ID: <20180731230435.GZ30972@magnolia>
References: <20180731200356.GX30972@magnolia>
 <20180731223112.GG2234@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180731223112.GG2234@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, Aug 01, 2018 at 08:31:12AM +1000, Dave Chinner wrote:
> On Tue, Jul 31, 2018 at 01:03:56PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Before we start processing what we /think/ is a da3 node block, actually
> > check the magic to make sure that we're looking at a node block.  This
> > way we won't blow the asserts in _node_hdr_from_disk on corrupted
> > metadata.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_da_btree.c |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> > index 9efbd2038ffb..70e7da634f3e 100644
> > --- a/fs/xfs/libxfs/xfs_da_btree.c
> > +++ b/fs/xfs/libxfs/xfs_da_btree.c
> > @@ -1522,8 +1522,11 @@ xfs_da3_node_lookup_int(
> >  			break;
> >  		}
> >  
> > -		blk->magic = XFS_DA_NODE_MAGIC;
> > +		if (blk->magic != XFS_DA_NODE_MAGIC &&
> > +		    blk->magic != XFS_DA3_NODE_MAGIC)
> > +			return -EFSCORRUPTED;
> >  
> > +		blk->magic = XFS_DA_NODE_MAGIC;
> 
> Can we please use a temporary variable for the on-disk magic number
> checks, then? blk->magic isn't supposed to hold the on disk format
> magic number - it's just an indication of the format the current
> state block points at - so using it to temporarily store the on disk
> magic number for checks like this is just wrong....

Ok.

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
