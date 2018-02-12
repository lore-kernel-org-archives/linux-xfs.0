Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51194 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932259AbeBLApZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Feb 2018 19:45:25 -0500
Date: Sun, 11 Feb 2018 16:45:16 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/7] xfs: factor ag btree reoot block initialisation
Message-ID: <20180212004516.GA5217@magnolia>
References: <20180201064202.7174-1-david@fromorbit.com>
 <20180201064202.7174-4-david@fromorbit.com>
 <20180208185402.GC15342@bfoster.bfoster>
 <20180208200007.GL5433@magnolia>
 <20180209131009.GA20748@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180209131009.GA20748@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Fri, Feb 09, 2018 at 08:10:10AM -0500, Brian Foster wrote:
> On Thu, Feb 08, 2018 at 12:00:07PM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 08, 2018 at 01:54:03PM -0500, Brian Foster wrote:
> > > On Thu, Feb 01, 2018 at 05:41:58PM +1100, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Cookie cutter code, easily factored.
> > > > 
> > > > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > 
> > > Seems sane, a couple factoring nits..
> > > 
> > > >  fs/xfs/xfs_fsops.c | 493 +++++++++++++++++++++++++++++------------------------
> > > >  1 file changed, 271 insertions(+), 222 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > > > index d9e08d8cf9ac..44eac79e0b49 100644
> > > > --- a/fs/xfs/xfs_fsops.c
> > > > +++ b/fs/xfs/xfs_fsops.c
> > > > @@ -71,46 +71,146 @@ xfs_growfs_get_hdr_buf(
> > > >  	return bp;
> > > >  }
> > > >  
> > > ...
> > > > +/*
> > > > + * Alloc btree root block init functions
> > > > + */
> > > > +static void
> > > > +xfs_bnoroot_init(
> > > > +	struct xfs_mount	*mp,
> > > > +	struct xfs_buf		*bp,
> > > > +	struct aghdr_init_data	*id)
> > > >  {
> > > > -	struct xfs_agf		*agf;
> > > > -	struct xfs_agi		*agi;
> > > > -	struct xfs_agfl		*agfl;
> > > > -	__be32			*agfl_bno;
> > > >  	xfs_alloc_rec_t		*arec;
> > > 
> > > A couple more typedef instances to kill (here and cntroot_init() below).
> > > 
> > > > -	struct xfs_buf		*bp;
> > > > -	int			bucket;
> > > > -	xfs_extlen_t		tmpsize;
> > > > -	int			error = 0;
> > > > +
> > > > +	xfs_btree_init_block(mp, bp, id->type, 0, id->numrecs, id->agno, 0);
> > > > +	arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
> > > > +	arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
> > > > +	arec->ar_blockcount = cpu_to_be32(id->agsize -
> > > > +					  be32_to_cpu(arec->ar_startblock));
> > > > +}
> > > > +
> > > > +static void
> > > > +xfs_cntroot_init(
> > > > +	struct xfs_mount	*mp,
> > > > +	struct xfs_buf		*bp,
> > > > +	struct aghdr_init_data	*id)
> > > > +{
> > > > +	xfs_alloc_rec_t		*arec;
> > > > +
> > > > +	xfs_btree_init_block(mp, bp, id->type, 0, id->numrecs, id->agno, 0);
> > > > +	arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
> > > > +	arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
> > > > +	arec->ar_blockcount = cpu_to_be32(id->agsize -
> > > > +					  be32_to_cpu(arec->ar_startblock));
> > > > +	id->nfree += be32_to_cpu(arec->ar_blockcount);
> > > 
> > > This seems unrelated to the cntbt. Perhaps move it to the parent
> > > function? It looks like all we need are mp->m_ag_prealloc_blocks and
> > > id->agsize, after all.
> > > 
> > > That also looks like the only difference between xfs_bnoroot_init() and
> > > xfs_cntroot_init(), fwiw, so we could condense those as well.
> > > 
> > > > +}
> > > > +
> > > ...
> > > > +/*
> > > > + * Write new AG headers to disk. Non-transactional, but written
> > > > + * synchronously so they are completed prior to the growfs transaction
> > > > + * being logged.
> > > > + */
> > > > +static int
> > > > +xfs_grow_ag_headers(
> > > > +	struct xfs_mount	*mp,
> > > > +	struct aghdr_init_data	*id)
> > > >  
> > > > -	arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
> > > > -	arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
> > > > -	arec->ar_blockcount = cpu_to_be32(
> > > > -		agsize - be32_to_cpu(arec->ar_startblock));
> > > > -	*nfree += be32_to_cpu(arec->ar_blockcount);
> > > > +{
> > > > +	int			error = 0;
> > > >  
> > > ...
> > > > +	/* BNO btree root block */
> > > > +	id->daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_BNO_BLOCK(mp));
> > > > +	id->numblks = BTOBB(mp->m_sb.sb_blocksize);
> > > > +	id->type = XFS_BTNUM_BNO;
> > > > +	id->numrecs = 1;
> > > 
> > > Do we really need to set numrecs for all of these calls? It looks out of
> > > place/context and inconsistently used to me. Case in point: we pass 1 to
> > > the space btree init functions which add a single record, but pass 0 to
> > > the rmapbt init function which actually adds up to 5 records (and
> > > increments the initial numrecs count).
> > 
> > I would've (will?) refactor all this to look like:
> > 
> > struct xfs_rmap_li {
> > 	struct list_head	list;
> > 	struct xfs_rmap_irec	rmap;
> > };
> > 
> > int
> > xfs_rmapbt_initialize(
> > 	struct xfs_mount	*mp,
> > 	struct xfs_buf		*agf_bp,
> > 	struct xfs_buf		*root_bp,
> > 	struct list_head	*rmaps)
> > {
> > 	struct xfs_agf		*agf = XFS_AGF_BUF(agf_bp);
> > 	struct xfs_rmap_li	*li;
> > 	struct xfs_rmap_rec	*disk_rec;
> > 	struct xfs_btree_headr	*rmap_hdr;
> > 
> > 	agf->rmaproot = be32_to_cpu(...);
> > 	agf->rmaplevel = 1;
> > 
> > 	disk_rec = xfs_get_rmap_entries(root_bp);
> > 	rmap_hdr = root_bp->b_addr;
> > 	list_for_each_entry(li, ..., rmaps) {
> > 		xfs_rmap_irec_to_disk(disk_rec, &li->rmap);
> > 		disk_rec++;
> > 		rmap_hdr->numrecs++; /* yeah yeah be32 */
> > 	}
> > 
> > 	/* mark agf dirty, mark rootbp dirty */
> > 	return 0;
> > }
> > 
> > So then you can call it via:
> > 
> > INIT_LIST_HEAD(&rec_list);
> > /* construct rec_list of records */
> > agf_bp = xfs_alloc_read_agf(...);
> > root_bp = xfs_buf_get(..., XFS_RMAP_BLOCK(mp));
> > error = xfs_rmapbt_initialize(mp, agf_bp, root_bp, &rec_list);
> > 
> > But I haven't had time to look through this in enough detail to figure
> > out how to merge it with the online repair stuff.  Maybe it doesn't even
> > make sense to merge them just to shave a few lines of header
> > initialization.
> > 
> 
> Hm, that looks like it has the potential to change this a decent amount.
> It's not clear to me how it would affect the growfs init function
> interface. From the perspective of the original comment
> (aghdr_init_data->numrecs), ISTM you'd still expect it to be zero in
> this example, regardless of whether the init function hardcodes
> insertion of a fixed number of entries or dynamically adds those (likely
> the same number of in the growfs case) entries.
> 
> So what is the status of this series then? Is it being tossed in favor
> of something else that is pending?

I plan to take a closer look at whether or not it makes sense to try to
share initialization code between growfs and onlinerepair and then
decide what to do.  I'd probably just pull this as is and then take a
look at what I'd have to change to make it work with repair code.  It
may very well turn out that it's not worth sharing for two rather
different use cases.

--D

> Brian
> 
> > --D
> > 
> > > AFAICT, each initialization function knows how many records it's going
> > > to add. I don't see why that information needs to leak outside of init
> > > function context..?
> > > 
> > > Brian
> > > 
> > > > +	error = xfs_growfs_init_aghdr(mp, id, xfs_bnoroot_init,
> > > > +				   &xfs_allocbt_buf_ops);
> > > > +	if (error)
> > > > +		goto out_error;
> > > >  
> > > > -		/* account inode btree root blocks */
> > > > -		rrec = XFS_RMAP_REC_ADDR(block, 3);
> > > > -		rrec->rm_startblock = cpu_to_be32(XFS_IBT_BLOCK(mp));
> > > > -		rrec->rm_blockcount = cpu_to_be32(XFS_RMAP_BLOCK(mp) -
> > > > -						XFS_IBT_BLOCK(mp));
> > > > -		rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_INOBT);
> > > > -		rrec->rm_offset = 0;
> > > > -		be16_add_cpu(&block->bb_numrecs, 1);
> > > >  
> > > > -		/* account for rmap btree root */
> > > > -		rrec = XFS_RMAP_REC_ADDR(block, 4);
> > > > -		rrec->rm_startblock = cpu_to_be32(XFS_RMAP_BLOCK(mp));
> > > > -		rrec->rm_blockcount = cpu_to_be32(1);
> > > > -		rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
> > > > -		rrec->rm_offset = 0;
> > > > -		be16_add_cpu(&block->bb_numrecs, 1);
> > > > +	/* CNT btree root block */
> > > > +	id->daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_CNT_BLOCK(mp));
> > > > +	id->numblks = BTOBB(mp->m_sb.sb_blocksize);
> > > > +	id->type = XFS_BTNUM_CNT;
> > > > +	id->numrecs = 1;
> > > > +	error = xfs_growfs_init_aghdr(mp, id, xfs_cntroot_init,
> > > > +				   &xfs_allocbt_buf_ops);
> > > > +	if (error)
> > > > +		goto out_error;
> > > >  
> > > > -		/* account for refc btree root */
> > > > -		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> > > > -			rrec = XFS_RMAP_REC_ADDR(block, 5);
> > > > -			rrec->rm_startblock = cpu_to_be32(xfs_refc_block(mp));
> > > > -			rrec->rm_blockcount = cpu_to_be32(1);
> > > > -			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_REFC);
> > > > -			rrec->rm_offset = 0;
> > > > -			be16_add_cpu(&block->bb_numrecs, 1);
> > > > -		}
> > > > +	/* RMAP btree root block */
> > > > +	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> > > > +		id->daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_RMAP_BLOCK(mp));
> > > > +		id->numblks = BTOBB(mp->m_sb.sb_blocksize);
> > > > +		id->type = XFS_BTNUM_RMAP;
> > > > +		id->numrecs = 0;
> > > > +		error = xfs_growfs_init_aghdr(mp, id, xfs_rmaproot_init,
> > > > +					   &xfs_rmapbt_buf_ops);
> > > > +		if (error)
> > > > +			goto out_error;
> > > >  
> > > > -		xfs_buf_delwri_queue(bp, buffer_list);
> > > > -		xfs_buf_relse(bp);
> > > >  	}
> > > >  
> > > > -	/*
> > > > -	 * INO btree root block
> > > > -	 */
> > > > -	bp = xfs_growfs_get_hdr_buf(mp,
> > > > -			XFS_AGB_TO_DADDR(mp, agno, XFS_IBT_BLOCK(mp)),
> > > > -			BTOBB(mp->m_sb.sb_blocksize), 0,
> > > > -			&xfs_inobt_buf_ops);
> > > > -	if (!bp) {
> > > > -		error = -ENOMEM;
> > > > +	/* INO btree root block */
> > > > +	id->daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_IBT_BLOCK(mp));
> > > > +	id->numblks = BTOBB(mp->m_sb.sb_blocksize);
> > > > +	id->type = XFS_BTNUM_INO;
> > > > +	id->numrecs = 0;
> > > > +	error = xfs_growfs_init_aghdr(mp, id, xfs_btroot_init,
> > > > +				   &xfs_inobt_buf_ops);
> > > > +	if (error)
> > > >  		goto out_error;
> > > > -	}
> > > >  
> > > > -	xfs_btree_init_block(mp, bp, XFS_BTNUM_INO , 0, 0, agno, 0);
> > > > -	xfs_buf_delwri_queue(bp, buffer_list);
> > > > -	xfs_buf_relse(bp);
> > > >  
> > > >  	/*
> > > >  	 * FINO btree root block
> > > >  	 */
> > > >  	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
> > > > -		bp = xfs_growfs_get_hdr_buf(mp,
> > > > -			XFS_AGB_TO_DADDR(mp, agno, XFS_FIBT_BLOCK(mp)),
> > > > -			BTOBB(mp->m_sb.sb_blocksize), 0,
> > > > -			&xfs_inobt_buf_ops);
> > > > -		if (!bp) {
> > > > -			error = -ENOMEM;
> > > > +		id->daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_FIBT_BLOCK(mp));
> > > > +		id->numblks = BTOBB(mp->m_sb.sb_blocksize);
> > > > +		id->type = XFS_BTNUM_FINO;
> > > > +		id->numrecs = 0;
> > > > +		error = xfs_growfs_init_aghdr(mp, id, xfs_btroot_init,
> > > > +					   &xfs_inobt_buf_ops);
> > > > +		if (error)
> > > >  			goto out_error;
> > > > -		}
> > > > -
> > > > -		xfs_btree_init_block(mp, bp, XFS_BTNUM_FINO, 0, 0, agno, 0);
> > > > -		xfs_buf_delwri_queue(bp, buffer_list);
> > > > -		xfs_buf_relse(bp);
> > > >  	}
> > > >  
> > > >  	/*
> > > >  	 * refcount btree root block
> > > >  	 */
> > > >  	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> > > > -		bp = xfs_growfs_get_hdr_buf(mp,
> > > > -			XFS_AGB_TO_DADDR(mp, agno, xfs_refc_block(mp)),
> > > > -			BTOBB(mp->m_sb.sb_blocksize), 0,
> > > > -			&xfs_refcountbt_buf_ops);
> > > > -		if (!bp) {
> > > > -			error = -ENOMEM;
> > > > +		id->daddr = XFS_AGB_TO_DADDR(mp, id->agno, xfs_refc_block(mp));
> > > > +		id->numblks = BTOBB(mp->m_sb.sb_blocksize);
> > > > +		id->type = XFS_BTNUM_REFC;
> > > > +		id->numrecs = 0;
> > > > +		error = xfs_growfs_init_aghdr(mp, id, xfs_btroot_init,
> > > > +					   &xfs_refcountbt_buf_ops);
> > > > +		if (error)
> > > >  			goto out_error;
> > > > -		}
> > > > -
> > > > -		xfs_btree_init_block(mp, bp, XFS_BTNUM_REFC, 0, 0, agno, 0);
> > > > -		xfs_buf_delwri_queue(bp, buffer_list);
> > > > -		xfs_buf_relse(bp);
> > > >  	}
> > > >  
> > > >  out_error:
> > > > @@ -384,7 +433,6 @@ xfs_growfs_data_private(
> > > >  	xfs_agf_t		*agf;
> > > >  	xfs_agi_t		*agi;
> > > >  	xfs_agnumber_t		agno;
> > > > -	xfs_extlen_t		agsize;
> > > >  	xfs_buf_t		*bp;
> > > >  	int			dpct;
> > > >  	int			error, saved_error = 0;
> > > > @@ -392,11 +440,11 @@ xfs_growfs_data_private(
> > > >  	xfs_agnumber_t		nagimax = 0;
> > > >  	xfs_rfsblock_t		nb, nb_mod;
> > > >  	xfs_rfsblock_t		new;
> > > > -	xfs_rfsblock_t		nfree;
> > > >  	xfs_agnumber_t		oagcount;
> > > >  	int			pct;
> > > >  	xfs_trans_t		*tp;
> > > >  	LIST_HEAD		(buffer_list);
> > > > +	struct aghdr_init_data	id = {};
> > > >  
> > > >  	nb = in->newblocks;
> > > >  	pct = in->imaxpct;
> > > > @@ -448,27 +496,28 @@ xfs_growfs_data_private(
> > > >  	 * list to write, we can cancel the entire list without having written
> > > >  	 * anything.
> > > >  	 */
> > > > -	nfree = 0;
> > > > -	for (agno = nagcount - 1; agno >= oagcount; agno--, new -= agsize) {
> > > > -
> > > > -		if (agno == nagcount - 1)
> > > > -			agsize = nb -
> > > > -				(agno * (xfs_rfsblock_t)mp->m_sb.sb_agblocks);
> > > > +	INIT_LIST_HEAD(&id.buffer_list);
> > > > +	for (id.agno = nagcount - 1;
> > > > +	     id.agno >= oagcount;
> > > > +	     id.agno--, new -= id.agsize) {
> > > > +
> > > > +		if (id.agno == nagcount - 1)
> > > > +			id.agsize = nb -
> > > > +				(id.agno * (xfs_rfsblock_t)mp->m_sb.sb_agblocks);
> > > >  		else
> > > > -			agsize = mp->m_sb.sb_agblocks;
> > > > +			id.agsize = mp->m_sb.sb_agblocks;
> > > >  
> > > > -		error = xfs_grow_ag_headers(mp, agno, agsize, &nfree,
> > > > -					    &buffer_list);
> > > > +		error = xfs_grow_ag_headers(mp, &id);
> > > >  		if (error) {
> > > > -			xfs_buf_delwri_cancel(&buffer_list);
> > > > +			xfs_buf_delwri_cancel(&id.buffer_list);
> > > >  			goto error0;
> > > >  		}
> > > >  	}
> > > > -	error = xfs_buf_delwri_submit(&buffer_list);
> > > > +	error = xfs_buf_delwri_submit(&id.buffer_list);
> > > >  	if (error)
> > > >  		goto error0;
> > > >  
> > > > -	xfs_trans_agblocks_delta(tp, nfree);
> > > > +	xfs_trans_agblocks_delta(tp, id.nfree);
> > > >  
> > > >  	/*
> > > >  	 * There are new blocks in the old last a.g.
> > > > @@ -479,7 +528,7 @@ xfs_growfs_data_private(
> > > >  		/*
> > > >  		 * Change the agi length.
> > > >  		 */
> > > > -		error = xfs_ialloc_read_agi(mp, tp, agno, &bp);
> > > > +		error = xfs_ialloc_read_agi(mp, tp, id.agno, &bp);
> > > >  		if (error) {
> > > >  			goto error0;
> > > >  		}
> > > > @@ -492,7 +541,7 @@ xfs_growfs_data_private(
> > > >  		/*
> > > >  		 * Change agf length.
> > > >  		 */
> > > > -		error = xfs_alloc_read_agf(mp, tp, agno, 0, &bp);
> > > > +		error = xfs_alloc_read_agf(mp, tp, id.agno, 0, &bp);
> > > >  		if (error) {
> > > >  			goto error0;
> > > >  		}
> > > > @@ -511,13 +560,13 @@ xfs_growfs_data_private(
> > > >  		 * this doesn't actually exist in the rmap btree.
> > > >  		 */
> > > >  		xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_NULL);
> > > > -		error = xfs_rmap_free(tp, bp, agno,
> > > > +		error = xfs_rmap_free(tp, bp, id.agno,
> > > >  				be32_to_cpu(agf->agf_length) - new,
> > > >  				new, &oinfo);
> > > >  		if (error)
> > > >  			goto error0;
> > > >  		error = xfs_free_extent(tp,
> > > > -				XFS_AGB_TO_FSB(mp, agno,
> > > > +				XFS_AGB_TO_FSB(mp, id.agno,
> > > >  					be32_to_cpu(agf->agf_length) - new),
> > > >  				new, &oinfo, XFS_AG_RESV_NONE);
> > > >  		if (error)
> > > > @@ -534,8 +583,8 @@ xfs_growfs_data_private(
> > > >  	if (nb > mp->m_sb.sb_dblocks)
> > > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
> > > >  				 nb - mp->m_sb.sb_dblocks);
> > > > -	if (nfree)
> > > > -		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, nfree);
> > > > +	if (id.nfree)
> > > > +		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> > > >  	if (dpct)
> > > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IMAXPCT, dpct);
> > > >  	xfs_trans_set_sync(tp);
> > > > @@ -562,7 +611,7 @@ xfs_growfs_data_private(
> > > >  	if (new) {
> > > >  		struct xfs_perag	*pag;
> > > >  
> > > > -		pag = xfs_perag_get(mp, agno);
> > > > +		pag = xfs_perag_get(mp, id.agno);
> > > >  		error = xfs_ag_resv_free(pag);
> > > >  		xfs_perag_put(pag);
> > > >  		if (error)
> > > > -- 
> > > > 2.15.1
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
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
