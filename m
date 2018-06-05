Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:47095 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752365AbeFEXAK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 19:00:10 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fQKvv-00036J-Tp
        for linux-xfs@vger.kernel.org; Wed, 06 Jun 2018 09:00:08 +1000
Date: Wed, 6 Jun 2018 09:00:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6 v2] xfs: validate btree records on retreival
Message-ID: <20180605230007.GK10363@dastard>
References: <20180605062423.4877-1-david@fromorbit.com>
 <20180605062423.4877-5-david@fromorbit.com>
 <20180605064043.GH10363@dastard>
 <20180605104207.3qlaudozsmjrize7@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180605104207.3qlaudozsmjrize7@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Tue, Jun 05, 2018 at 12:42:07PM +0200, Carlos Maiolino wrote:
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
> > -	return error;
> > +
> > +	/* check for valid extent range, including overflow */
> > +	if (!xfs_verify_agbno(mp, agno, realstart))
> > +		goto out_bad_rec;
> > +	if (realstart > realstart + irec->rc_blockcount)
> 
> I am not sure if I'm right, but I thought this ought to be ">="?

We've already caught zero length and block count greater than
2^32-1, so if the above is true we've wrapped through zero during
the addition. But we can never add 0 or 2^32 to realstart here, so
the "==" condition will not occur and we don't need to check for
it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
