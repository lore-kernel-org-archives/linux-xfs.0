Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27235 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751177AbdJEBNV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Oct 2017 21:13:21 -0400
Date: Wed, 4 Oct 2017 18:13:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/25] xfs: scrub free space btrees
Message-ID: <20171005011317.GB7122@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706332522.19351.3718364611675005450.stgit@magnolia>
 <20171005005943.GI3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171005005943.GI3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 05, 2017 at 11:59:43AM +1100, Dave Chinner wrote:
> On Tue, Oct 03, 2017 at 01:42:05PM -0700, Darrick J. Wong wrote:
> > +
> > +/*
> > + * Set us up to scrub free space btrees.
> > + * Push everything out of the log so that the busy extent list is empty.
> > + */
> > +int
> > +xfs_scrub_setup_ag_allocbt(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_inode		*ip)
> > +{
> > +	return xfs_scrub_setup_ag_btree(sc, ip, sc->try_harder);
> 
> These setup calls are getting deeply nested and intertwined. And
> I really don't know why we pass sc->try_harder as a separate
> parameter when we are already passing sc, especically as
> xfs_scrub_setup_ag_btree() doesn't use it at all...
> 
> > +/* Scrub a bnobt/cntbt record. */
> > +STATIC int
> > +xfs_scrub_allocbt_helper(
> > +	struct xfs_scrub_btree		*bs,
> > +	union xfs_btree_rec		*rec)
> > +{
> > +	struct xfs_mount		*mp = bs->cur->bc_mp;
> > +	struct xfs_agf			*agf;
> > +	unsigned long long		rec_end;
> > +	xfs_agblock_t			bno;
> > +	xfs_extlen_t			len;
> > +	int				error = 0;
> > +
> > +	bno = be32_to_cpu(rec->alloc.ar_startblock);
> > +	len = be32_to_cpu(rec->alloc.ar_blockcount);
> > +	agf = XFS_BUF_TO_AGF(bs->sc->sa.agf_bp);
> > +	rec_end = (unsigned long long)bno + len;
> > +
> > +	if (bno >= mp->m_sb.sb_agblocks ||
> 
> Needs to take into account short last AG, so....
> 
> > +	    bno >= be32_to_cpu(agf->agf_length) ||
> > +	    len == 0 ||
> > +	    rec_end > mp->m_sb.sb_agblocks ||
> > +	    rec_end > be32_to_cpu(agf->agf_length))
> > +		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
> 
> ... it should probably just validate the agbno is good. i.e.
> 
> 	if (!xfs_agbno_verify(bno) || !len ||
> 	    !xfs_agbno_verify(rec_end)) {

Will do.

> .....
> 
> 
> > +xfs_scrub_allocbt(
> > +	struct xfs_scrub_context	*sc,
> > +	xfs_btnum_t			which)
> > +{
> > +	struct xfs_owner_info		oinfo;
> > +	struct xfs_btree_cur		*cur;
> > +
> > +	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
> > +	cur = which == XFS_BTNUM_BNO ? sc->sa.bno_cur : sc->sa.cnt_cur;
> > +	return xfs_scrub_btree(sc, cur, xfs_scrub_allocbt_helper,
> > +			&oinfo, NULL);
> > +}
> 
> I'm assuming the owner info is for later functionality to cross
> check btree blocks against the rmap btree?

Yes.

--D

> 
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
