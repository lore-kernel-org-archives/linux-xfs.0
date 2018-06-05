Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:38122 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932092AbeFEXDZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 19:03:25 -0400
Date: Wed, 6 Jun 2018 09:02:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6 v2] xfs: validate btree records on retreival
Message-ID: <20180605230246.GL10363@dastard>
References: <20180605062423.4877-1-david@fromorbit.com>
 <20180605062423.4877-5-david@fromorbit.com>
 <20180605064043.GH10363@dastard>
 <20180605174716.GM9437@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180605174716.GM9437@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 05, 2018 at 10:47:16AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 05, 2018 at 04:40:43PM +1000, Dave Chinner wrote:
> > @@ -111,16 +111,51 @@ xfs_refcount_get_rec(
> >  	struct xfs_refcount_irec	*irec,
> >  	int				*stat)
> >  {
> > +	struct xfs_mount		*mp = cur->bc_mp;
> > +	xfs_agnumber_t			agno = cur->bc_private.a.agno;
> >  	union xfs_btree_rec		*rec;
> >  	int				error;
> > +	xfs_agblock_t			realstart;
> >  
> >  	error = xfs_btree_get_rec(cur, &rec, stat);
> > -	if (!error && *stat == 1) {
> > -		xfs_refcount_btrec_to_irec(rec, irec);
> > -		trace_xfs_refcount_get(cur->bc_mp, cur->bc_private.a.agno,
> > -				irec);
> > +	if (error || !*stat)
> > +		return error;
> > +
> > +	xfs_refcount_btrec_to_irec(rec, irec);
> > +
> > +	agno = cur->bc_private.a.agno;
> > +	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
> > +		goto out_bad_rec;
> > +
> > +	/* handle special COW-staging state */
> > +	realstart = irec->rc_startblock;
> > +	if (realstart & XFS_REFC_COW_START) {
> > +		if (irec->rc_refcount != 1)
> > +			goto out_bad_rec;
> > +		realstart &= ~XFS_REFC_COW_START;
> >  	}
> 
> If the record does not have the cow "flag" set then the refcount cannot
> be 1, so this needs an else clause:
> 
> } else {
> 	if (irec->rc_refcount == 1)
> 		goto out_bad_rec;
> }

Ah, yes, that is true, though it should be refcount < 2 because a
zero value is invalid, too.

> > +	if (irec->rm_owner == 0)
> > +		goto out_bad_rec;
> > +	if (irec->rm_owner > XFS_MAXINUMBER &&
> > +	    irec->rm_owner <= XFS_RMAP_OWN_MIN)
> 
> rm_owner should be (between XFS_RMAP_OWN_FS and XFS_RMAP_OWN_MIN) or
> (pass xfs_verify_fsino()) since we cannot have inodes between EOFS and
> MAXINUMBER.

Yes, that is better. I should have noticed xfs_verify_fsino() - my
bad.
>
> > +		goto out_bad_rec;
> > +
> 
> Should we check the rmap flags here?

They are checked in xfs_refcount_btrec_to_irec(), and it returns
-EFSCORRUPTED if invalid flags are set.

> > +	return 0;
> > +out_bad_rec:
> > +	xfs_warn(mp,
> > +		"RMAP BTree record corruption in AG %d detected!", agno);
> 
> "RMap" ?  Or "Reverse Mapping"?
> 
> (Consistent capitalization blah blah...)

I'll use the latter.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
