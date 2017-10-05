Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20587 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750746AbdJEFCy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2017 01:02:54 -0400
Date: Wed, 4 Oct 2017 22:02:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 15/25] xfs: scrub refcount btrees
Message-ID: <20171005050250.GD7122@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706334388.19351.17983785124391880595.stgit@magnolia>
 <20171005025937.GL3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171005025937.GL3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 05, 2017 at 01:59:37PM +1100, Dave Chinner wrote:
> On Tue, Oct 03, 2017 at 01:42:23PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > +/* Scrub a refcountbt record. */
> > +STATIC int
> > +xfs_scrub_refcountbt_helper(
> > +	struct xfs_scrub_btree		*bs,
> > +	union xfs_btree_rec		*rec)
> > +{
> > +	struct xfs_mount		*mp = bs->cur->bc_mp;
> > +	struct xfs_agf			*agf;
> > +	struct xfs_refcount_irec	irec;
> > +	unsigned long long		rec_end;
> > +	xfs_agblock_t			eoag;
> > +	bool				has_cowflag;
> > +	int				error = 0;
> > +
> > +	irec.rc_startblock = be32_to_cpu(rec->refc.rc_startblock);
> > +	irec.rc_blockcount = be32_to_cpu(rec->refc.rc_blockcount);
> > +	irec.rc_refcount = be32_to_cpu(rec->refc.rc_refcount);
> > +	agf = XFS_BUF_TO_AGF(bs->sc->sa.agf_bp);
> > +	eoag = be32_to_cpu(agf->agf_length);
> > +
> > +	/* Only CoW records can have refcount == 1. */
> > +	has_cowflag = !!(irec.rc_startblock & XFS_REFC_COW_START);
> > +	if ((irec.rc_refcount == 1 && !has_cowflag) ||
> > +	    (irec.rc_refcount != 1 && has_cowflag))
> > +		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
> > +
> > +	/* Check the extent. */
> > +	irec.rc_startblock &= ~XFS_REFC_COW_START;
> > +	rec_end = (unsigned long long)irec.rc_startblock + irec.rc_blockcount;
> > +	if (irec.rc_startblock >= mp->m_sb.sb_agblocks ||
> > +	    irec.rc_startblock >= eoag ||
> > +	    irec.rc_blockcount == 0 ||
> > +	    rec_end > mp->m_sb.sb_agblocks ||
> > +	    rec_end > eoag ||
> 
> For the (broken) record...

Yup.

> > +	    irec.rc_refcount < 1)
> 
> Unsigned variable, so it seems to me that irec.rc_refcount == 0
> would be a more correct check.

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
