Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34766 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932679AbeEHOxj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 10:53:39 -0400
Date: Tue, 8 May 2018 07:53:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 6/6] xfs: defer agfl frees from directory op
 transactions
Message-ID: <20180508145320.GJ11261@magnolia>
References: <20180418133119.21775-1-bfoster@redhat.com>
 <20180418133119.21775-7-bfoster@redhat.com>
 <20180508011213.GH11261@magnolia>
 <20180508123318.GB4764@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180508123318.GB4764@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 08, 2018 at 08:33:18AM -0400, Brian Foster wrote:
> On Mon, May 07, 2018 at 06:12:13PM -0700, Darrick J. Wong wrote:
> > On Wed, Apr 18, 2018 at 09:31:19AM -0400, Brian Foster wrote:
> > > Directory operations can perform block allocations as entries are
> > > added/removed from directories. Defer AGFL block frees from the
> > > remaining directory operation transactions. This covers the hard
> > > link, remove and rename operations.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_inode.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index 484ebef36fe4..47aa124e4744 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -1452,6 +1452,7 @@ xfs_link(
> > >  	}
> > >  
> > >  	xfs_defer_init(&dfops, &first_block);
> > > +	tp->t_agfl_dfops = &dfops;
> > >  
> > >  	/*
> > >  	 * Handle initial link state of O_TMPFILE inode
> > > @@ -2649,6 +2650,7 @@ xfs_remove(
> > >  		goto out_trans_cancel;
> > >  
> > >  	xfs_defer_init(&dfops, &first_block);
> > > +	tp->t_agfl_dfops = &dfops;
> > >  	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
> > >  					&first_block, &dfops, resblks);
> > >  	if (error) {
> > > @@ -3016,6 +3018,7 @@ xfs_rename(
> > >  	}
> > >  
> > >  	xfs_defer_init(&dfops, &first_block);
> > > +	tp->t_agfl_dfops = &dfops;
> > 
> > Hmm, do you have a reproducer xfstest for any of the last three patches?
> > 
> 
> Unfortunately, no. The only reproducer I've managed so far was a (huge)
> private/customer metadump that consistently reproduced log reservation
> overruns over a long running file removal operation. Even then, that
> particular instance was worked around by the previous reworks of the
> inode transaction reservation calculations.
> 
> While we ended up with a workaround for that problem, it was still known
> that the agfl fixups were unpredictable and we couldn't guarantee
> coverage by the reservation calculations without making them excessively
> large. So this series aims to make the agfl fixup (freeing,
> specifically) behavior itself predictable such that it always fits in an
> allocation log reservation unit.

<nod>

> > Codewise,
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> 
> Thanks.. does this refer to just this patch, btw, or the previous 3?

All three.

--D

> Brian
> 
> > --D
> > 
> > >  
> > >  	/* RENAME_EXCHANGE is unique from here on. */
> > >  	if (flags & RENAME_EXCHANGE)
> > > -- 
> > > 2.13.6
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
