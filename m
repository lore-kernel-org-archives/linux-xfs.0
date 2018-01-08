Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50296 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756223AbeAHWUZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jan 2018 17:20:25 -0500
Date: Mon, 8 Jan 2018 14:20:18 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: clarify units in the failed metadata io message
Message-ID: <20180108222018.GY5602@magnolia>
References: <20180108194015.GT5602@magnolia>
 <20180108213235.GW5602@magnolia>
 <20180108220817.GC16421@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180108220817.GC16421@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Tue, Jan 09, 2018 at 09:08:17AM +1100, Dave Chinner wrote:
> On Mon, Jan 08, 2018 at 01:32:35PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If a metadata IO error happens, we report the location of the failed IO
> > request in units of daddrs.  However, the printk message misleads people
> > into thinking that the units are fs blocks, so fix the reported units.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: fix more messages
> 
> A useful cleanup...
> 
> > ---
> >  fs/xfs/xfs_buf.c |   13 +++++++------
> >  1 file changed, 7 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 1981ef7..641b823 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -585,8 +585,8 @@ _xfs_buf_find(
> >  		 * returning a specific error on buffer lookup failures.
> >  		 */
> >  		xfs_alert(btp->bt_mount,
> > -			  "%s: Block out of range: block 0x%llx, EOFS 0x%llx ",
> > -			  __func__, cmap.bm_bn, eofs);
> > +			  "%pS: daddr 0x%llx out of range, EOFS 0x%llx",
> > +			  __return_address, cmap.bm_bn, eofs);
> 
> That return address won't tell us anything useful - it'll almost
> always be xfs_buf_get_map(). That's why I used __func__ originally
> here, and the code hasn't really changed since I did that....

<nod>

> >  		WARN_ON(1);
> >  		return NULL;
> >  	}
> > @@ -1196,8 +1196,9 @@ xfs_buf_ioerror_alert(
> >  	const char		*func)
> >  {
> >  	xfs_alert(bp->b_target->bt_mount,
> > -"metadata I/O error: block 0x%llx (\"%s\") error %d numblks %d",
> > -		(uint64_t)XFS_BUF_ADDR(bp), func, -bp->b_error, bp->b_length);
> > +"metadata I/O error in %pS (\"%s\") at daddr 0x%llx len %d error %d",
> > +			__return_address, func, (uint64_t)XFS_BUF_ADDR(bp),
> > +			bp->b_length, -bp->b_error);
> >  }
> 
> Same here - the return address is basically going to tell us exactly
> the same information as the func parameter that is passed in.

I was making a follow-on patch that removes the func argument entirely,
but eh, maybe I'll stick to strictly cleaning up units and reporting
formats here.

--D

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
