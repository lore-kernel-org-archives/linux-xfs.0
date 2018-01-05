Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50499 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751250AbeAECxY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jan 2018 21:53:24 -0500
Date: Thu, 4 Jan 2018 18:53:20 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/21] xfs: check btree block ownership with bnobt/rmapbt
 when scrubbing btree
Message-ID: <20180105025320.GE5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398984612.18741.15845883360126485561.stgit@magnolia>
 <20180105022436.GA30682@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180105022436.GA30682@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 05, 2018 at 01:24:36PM +1100, Dave Chinner wrote:
> On Fri, Dec 22, 2017 at 04:44:06PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When scanning a metadata btree block, cross-reference the block location
> > with the free space btree and the reverse mapping btree to ensure that
> > the rmapbt knows about the block and the bnobt does not.  Add a
> > mechanism to defer checks when we happen to be scanning the bnobt/rmapbt
> > itself because it's less efficient to repeatedly clone and destroy the
> > cursor.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/btree.c |   92 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 92 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> > index 36cff8f..9151499 100644
> > --- a/fs/xfs/scrub/btree.c
> > +++ b/fs/xfs/scrub/btree.c
> > @@ -362,6 +362,80 @@ xfs_scrub_btree_block_check_siblings(
> >  	return error;
> >  }
> >  
> > +struct check_owner {
> > +	struct list_head	list;
> > +	xfs_daddr_t		daddr;
> > +	int			level;
> > +};
> > +
> > +/*
> > + * Make sure this btree block isn't in the free list and that there's
> > + * an rmap record for it.
> > + */
> > +STATIC int
> > +xfs_scrub_btree_check_block_owner(
> > +	struct xfs_scrub_btree		*bs,
> > +	int				level,
> > +	xfs_daddr_t			daddr)
> > +{
> > +	struct xfs_scrub_ag		sa = { 0 };
> > +	struct xfs_scrub_ag		*psa;
> > +	xfs_agnumber_t			agno;
> > +	int				error = 0;
> > +
> > +	agno = xfs_daddr_to_agno(bs->cur->bc_mp, daddr);
> > +
> > +	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> > +		error = xfs_scrub_ag_init(bs->sc, agno, &sa);
> > +		if (!xfs_scrub_btree_xref_process_error(bs->sc, bs->cur,
> > +				level, &error))
> > +			return error;
> > +		psa = &sa;
> > +	} else {
> > +		psa = &bs->sc->sa;
> > +	}
> > +
> > +	if (psa == &sa)
> > +		xfs_scrub_ag_free(bs->sc, &sa);
> > +
> > +	return error;
> > +}
> 
> I'm missing something here - where's the owner check?

"xfs: cross-reference with the bnobt" and "xfs: cross-reference with the
rmapbt" add the actual meat of checking the owner.  Both of those
patches create helpers to deal with checking the owner and recording
error statuses and uses them, so this patch only provides the shell of
the btree block checking apparatus.

Will update the commit message to say that this is only the framework.

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
