Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45540 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753927AbdBURWu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Feb 2017 12:22:50 -0500
Date: Tue, 21 Feb 2017 09:22:44 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/8] xfs: plumb in needed functions for range querying of
 the freespace btrees
Message-ID: <20170221172244.GE5846@birch.djwong.org>
References: <148738063792.29384.10681837280402457846.stgit@birch.djwong.org>
 <148738065038.29384.2269477924958641169.stgit@birch.djwong.org>
 <20170221143504.GB3207@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170221143504.GB3207@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Feb 21, 2017 at 09:35:04AM -0500, Brian Foster wrote:
> On Fri, Feb 17, 2017 at 05:17:30PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Plumb in the pieces (init_high_key, diff_two_keys) necessary to call
> > query_range on the free space btrees.  Remove the debugging asserts
> > so that we can make queries starting from block 0.
> > 
> > While we're at it, merge the redundant "if (btnum ==" hunks.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc_btree.c |  162 +++++++++++++++++++++++++++++----------
> >  1 file changed, 119 insertions(+), 43 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> > index efb467b..ba3ec9c 100644
> > --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> ...
> > @@ -346,44 +388,78 @@ const struct xfs_buf_ops xfs_allocbt_buf_ops = {
> ...
> > -static const struct xfs_btree_ops xfs_allocbt_ops = {
> > +static const struct xfs_btree_ops xfs_cntbt_ops = {
> >  	.rec_len		= sizeof(xfs_alloc_rec_t),
> >  	.key_len		= sizeof(xfs_alloc_key_t),
> >  
> > @@ -397,11 +473,12 @@ static const struct xfs_btree_ops xfs_allocbt_ops = {
> >  	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
> >  	.init_rec_from_cur	= xfs_allocbt_init_rec_from_cur,
> >  	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
> > -	.key_diff		= xfs_allocbt_key_diff,
> > +	.key_diff		= xfs_cntbt_key_diff,
> >  	.buf_ops		= &xfs_allocbt_buf_ops,
> > +	.diff_two_keys		= xfs_cntbt_diff_two_keys,
> 
> Any reason we add diff_two_keys() but not init_high_key_from_rec() for
> the cntbt? If so.. could you note the different requirements in the
> commit log?

Come to think of it, the cntbt isn't overlapped and nothing ever calls
query_range on it, so we don't need xfs_cntbt_diff_two_keys at all.

That said, between getfsmap and the scrub patches we eventually make all
the other btree types query_range-able, so there's no reason to leave
this subtle logic bomb in libxfs for someone else to trip over later.

Thanks for the review!

--D

> 
> Brian
> 
> >  #if defined(DEBUG) || defined(XFS_WARN)
> > -	.keys_inorder		= xfs_allocbt_keys_inorder,
> > -	.recs_inorder		= xfs_allocbt_recs_inorder,
> > +	.keys_inorder		= xfs_cntbt_keys_inorder,
> > +	.recs_inorder		= xfs_cntbt_recs_inorder,
> >  #endif
> >  };
> >  
> > @@ -427,16 +504,15 @@ xfs_allocbt_init_cursor(
> >  	cur->bc_mp = mp;
> >  	cur->bc_btnum = btnum;
> >  	cur->bc_blocklog = mp->m_sb.sb_blocklog;
> > -	cur->bc_ops = &xfs_allocbt_ops;
> > -	if (btnum == XFS_BTNUM_BNO)
> > -		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
> > -	else
> > -		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
> >  
> >  	if (btnum == XFS_BTNUM_CNT) {
> > +		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
> > +		cur->bc_ops = &xfs_cntbt_ops;
> >  		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
> >  		cur->bc_flags = XFS_BTREE_LASTREC_UPDATE;
> >  	} else {
> > +		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
> > +		cur->bc_ops = &xfs_bnobt_ops;
> >  		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
> >  	}
> >  
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
