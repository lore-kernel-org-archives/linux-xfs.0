Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:24023 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751924AbdK2BDE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 20:03:04 -0500
Date: Wed, 29 Nov 2017 12:02:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 01/17] Add helper functions xfs_attr_set_args and
 xfs_attr_remove_args
Message-ID: <20171129010233.GI5858@dastard>
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
 <1510942905-12897-2-git-send-email-allison.henderson@oracle.com>
 <20171128195421.GY21412@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171128195421.GY21412@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Nov 28, 2017 at 11:54:21AM -0800, Darrick J. Wong wrote:
> On Fri, Nov 17, 2017 at 11:21:29AM -0700, Allison Henderson wrote:
> > These sub-routines set or remove the attributes specified in
> > @args. We will use this later for setting parent pointers as a
> > deferred attribute operation.
> > 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c | 335 ++++++++++++++++++++++++++++-------------------
> >  fs/xfs/libxfs/xfs_bmap.c |  55 ++++----
> >  fs/xfs/libxfs/xfs_bmap.h |   1 +
> >  fs/xfs/xfs_attr.h        |   2 +
> >  4 files changed, 236 insertions(+), 157 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 6249c92..e5f2960 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -168,6 +168,195 @@ xfs_attr_get(
> >  }
> >  
> >  /*
> > + * Set the attribute specified in @args. In the case of the parent attribute
> > + * being set, we do not want to roll the transaction on shortform-to-leaf
> > + * conversion, as the attribute must be added in the same transaction as the
> > + * parent directory modifications. Hence @roll_trans needs to be set
> > + * appropriately to control whether the transaction is committed during this
> > + * function.
> 
> We have sufficient space in the single transaction case to do both, right?
> 
> > + */
> > +int
> > +xfs_attr_set_args(
> > +	struct xfs_da_args	*args,
> > +	int			flags,
> > +	bool			roll_trans)
> > +{
> > +	struct xfs_inode	*dp = args->dp;
> > +	struct xfs_mount        *mp = dp->i_mount;
> > +	struct xfs_trans_res    tres;
> > +	int			rsvd = 0;
> > +	int			error = 0;
> > +	int			sf_size;
> > +
> > +	/*
> > +	 * New inodes setting the parent pointer attr will
> > +	 * not have an attribute fork yet. So set the attribute
> > +	 * fork appropriately
> > +	 */
> > +	if (XFS_IFORK_Q((args->dp)) == 0) {
> > +		sf_size = sizeof(struct xfs_attr_sf_hdr) +
> > +		     XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
> > +		xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
> > +		args->dp->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
> > +		args->dp->i_afp->if_flags = XFS_IFEXTENTS;
> > +	}
> > +
> > +	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> > +			 M_RES(mp)->tr_attrsetrt.tr_logres * args->total;
> > +	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
> > +	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> 
> /me raises eyebrows about declaring our own tres here, though it came
> from the original code so I gues I can't complain too loudly.

Well, it takes into account the fact we don't log remote
attributes. Hence for inline attributes we need to include their
length in the log reservation, but we don't know what the length is
until we are actually adding the attribute to the block...

> (Primarily because we use the transaction reservations to calculate the
> minimum log size, so I would think we'd want this one included in those
> calculations...)

We do take that into account in xfs_log_calc_max_attrsetm_res().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
