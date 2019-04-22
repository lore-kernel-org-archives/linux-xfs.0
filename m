Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38506 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbfDVVfe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Apr 2019 17:35:34 -0400
Date: Mon, 22 Apr 2019 14:35:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/10] libxfs: refactor buffer item release code
Message-ID: <20190422213529.GD4676@magnolia>
References: <155594788997.115924.16224143537288136652.stgit@magnolia>
 <155594793429.115924.9115512760848857551.stgit@magnolia>
 <e964dcb8-5a9d-26bf-e5ac-7489c9f259a1@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e964dcb8-5a9d-26bf-e5ac-7489c9f259a1@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 22, 2019 at 04:26:58PM -0500, Eric Sandeen wrote:
> On 4/22/19 10:45 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor the buffer item release code into a helper, which we will use
> > in subsequent patches to make the buffer log item lifetime match the
> > kernel equivalents.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  libxfs/trans.c |   14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/libxfs/trans.c b/libxfs/trans.c
> > index 9de77c8b..629501f8 100644
> > --- a/libxfs/trans.c
> > +++ b/libxfs/trans.c
> > @@ -505,6 +505,16 @@ libxfs_trans_ordered_buf(
> >  	return ret;
> >  }
> >  
> > +static void
> > +xfs_buf_item_put(
> > +	struct xfs_buf_log_item	*bip)
> > +{
> > +	struct xfs_buf		*bp = bip->bli_buf;
> > +
> > +	bp->b_log_item = NULL;
> > +	kmem_zone_free(xfs_buf_item_zone, bip);
> > +}
> > +
> >  void
> >  libxfs_trans_brelse(
> >  	xfs_trans_t		*tp,
> > @@ -846,7 +856,6 @@ buf_item_done(
> >  
> >  	bp = bip->bli_buf;
> >  	ASSERT(bp != NULL);
> > -	bp->b_log_item = NULL;			/* remove log item */
> >  	bp->b_transp = NULL;			/* remove xact ptr */
> >  
> >  	hold = (bip->bli_flags & XFS_BLI_HOLD);
> > @@ -861,8 +870,7 @@ buf_item_done(
> >  		bip->bli_flags &= ~XFS_BLI_HOLD;
> >  	else
> >  		libxfs_putbuf(bp);
> > -	/* release the buf item */
> > -	kmem_zone_free(xfs_buf_item_zone, bip);
> > +	xfs_buf_item_put(bip);
> 
> In xfs_buf_item_put(), we reach back up from bip to bip->bli_buf, which is
> the bp.  This is after we did a libxfs_putbuf(bp) on that bp.  Is there not
> a chance of use after free here?  Enough puts and a shaker can run, right?

I think you're right, the xfs_buf_item_put should come before the
libxfs_putbuf.

--D

> >  }
> >  
> >  static void
> > 
