Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:43858 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbeJAEoA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 00:44:00 -0400
Date: Mon, 1 Oct 2018 08:09:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix error handling in  xfs_bmap_extents_to_btree
Message-ID: <20180930220915.GL31060@dastard>
References: <20180930061807.3320-1-david@fromorbit.com>
 <20180930153444.GA5872@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180930153444.GA5872@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Sep 30, 2018 at 08:34:44AM -0700, Darrick J. Wong wrote:
> On Sun, Sep 30, 2018 at 04:18:07PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Commit 01239d77b9dd ("xfs: fix a null pointer dereference in
> > xfs_bmap_extents_to_btree") attempted to fix a null pointer
> > dreference when a fuzzing corruption of some kind was found.
> > This fix was flawed, resulting in assert failures like:
.....
> > @@ -732,9 +732,10 @@ xfs_bmap_extents_to_btree(
> >  	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
> >  	abp = xfs_btree_get_bufl(mp, tp, args.fsbno, 0);
> >  	if (!abp) {
> 
> This reminds me to ask, has anyone made progress converting the
> {get,read}_buf functions (and associated callers) to return error codes?

Not me. I had a brief thought about this when looking at this,
but I think we really need to start from the bottom up (i.e. from
the xfs_buf_* functions first) before moving to the higher level
code.

> (I wasn't expecting that as a part of this fix; I'm simply recollecting
> my marbles.)
> 
> Anyway, this looks ok to me.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks Darrick, I'll add it to the fixes branch (it's been on top of
the merged tree I've been testing over the weekend) and get it out.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
