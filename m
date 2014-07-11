Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D7FC57F47
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 16:57:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A63D5304039
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 14:57:24 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	zzxYZbcAQS0BtEOA for <xfs@oss.sgi.com>;
	Fri, 11 Jul 2014 14:57:22 -0700 (PDT)
Date: Sat, 12 Jul 2014 07:57:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: refine the allocation stack switch
Message-ID: <20140711215719.GQ4453@dastard>
References: <1405034779-2028-1-git-send-email-david@fromorbit.com>
	<1405034779-2028-3-git-send-email-david@fromorbit.com>
	<20140711123352.GB3077@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140711123352.GB3077@laptop.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 11, 2014 at 08:33:53AM -0400, Brian Foster wrote:
> On Fri, Jul 11, 2014 at 09:26:18AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> ...
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_bmap.c      |  4 +--
> >  fs/xfs/xfs_bmap_util.c | 43 --------------------------
> >  fs/xfs/xfs_bmap_util.h | 15 +++++----
> >  fs/xfs/xfs_btree.c     | 84 ++++++++++++++++++++++++++++++++++++++++++++++++--
> >  4 files changed, 91 insertions(+), 55 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> > index 935ed2b..91df8e9 100644
> > --- a/fs/xfs/xfs_bmap_util.h
> > +++ b/fs/xfs/xfs_bmap_util.h
> > @@ -50,12 +50,13 @@ struct xfs_bmalloca {
> >  	xfs_extlen_t		total;	/* total blocks needed for xaction */
> >  	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */
> >  	xfs_extlen_t		minleft; /* amount must be left after alloc */
> > -	char			eof;	/* set if allocating past last extent */
> > -	char			wasdel;	/* replacing a delayed allocation */
> > -	char			userdata;/* set if is user data */
> > -	char			aeof;	/* allocated space at eof */
> > -	char			conv;	/* overwriting unwritten extents */
> > -	char			stack_switch;
> > +	bool			eof;	/* set if allocating past last extent */
> > +	bool			wasdel;	/* replacing a delayed allocation */
> > +	bool			userdata;/* set if is user data */
> > +	bool			aeof;	/* allocated space at eof */
> > +	bool			conv;	/* overwriting unwritten extents */
> > +	bool			stack_switch;
> > +	bool			kswapd;	/* work being done for kswapd */
> 
> Neither stack_switch nor kswapd are used any longer. Removal of
> stack_switch means that the XFS_BMAPI_STACK_SWITCH flag can go away as
> well.

Yup, I'll fix that.

> > -STATIC int					/* error */
> > -xfs_btree_split(
> > +int					/* error */
> > +__xfs_btree_split(
> 
> Looks like this can remain static. The rest looks Ok to me, but I'll run
> some tests too.

I'll fix that too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
