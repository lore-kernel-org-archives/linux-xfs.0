Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5940FC433E9
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 19:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F5EB22A84
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 19:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390658AbhAKTHx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 14:07:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390773AbhAKTHx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 14:07:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4E7822A84;
        Mon, 11 Jan 2021 19:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610392030;
        bh=mDHkawVCU9NAUxDEsLuXPt9WmgoGEqvbPp35BuMxBUY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fyvZroJ7fPMVn3tV+2PNnYkDvM+wkPgFp3yRZSlFaclIXkUKzLzYUmij4mHLH7RYG
         ioxwvCUTxD4sYhTqHzV+LJswP5VkYMAxHG+Gk80KJYRY/UB7+n7V7Reg6Q1DrvBlVz
         3jRs3HhOXvJeN/nocwWMZp0wQm+1FpgctqlBxEVrsBNA0lMtpK0lx3NDxDmfpsshSL
         U9KA5xe1lzMZgKSLMHeWnUFhRwtf2EEuG/JzLLlwKkTmGR3LLS9b0WhntrbDZF6DQx
         JffwH1SNBDv2P2RSJF/RIGeQC4kmuCj6gr0p5UUgqa6SxJpS7ZYez+/IaY9wEDqTFf
         zU24HjVwvkLww==
Date:   Mon, 11 Jan 2021 11:07:10 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 4/4] xfs: support shrinking unused space in the last AG
Message-ID: <20210111190710.GD1164246@magnolia>
References: <20210111132243.1180013-1-hsiangkao@redhat.com>
 <20210111132243.1180013-5-hsiangkao@redhat.com>
 <20210111181753.GC1164246@magnolia>
 <20210111184835.GC1213845@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111184835.GC1213845@xiangao.remote.csb>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 12, 2021 at 02:48:35AM +0800, Gao Xiang wrote:
> Hi Darrick,
> 
> On Mon, Jan 11, 2021 at 10:17:53AM -0800, Darrick J. Wong wrote:
> > On Mon, Jan 11, 2021 at 09:22:43PM +0800, Gao Xiang wrote:
> 
> ...
> 
> > > +int
> > > +xfs_ag_shrink_space(
> > > +	struct xfs_mount	*mp,
> > > +	struct xfs_trans	*tp,
> > > +	struct aghdr_init_data	*id,
> > > +	xfs_extlen_t		len)
> > > +{
> > > +	struct xfs_buf		*agibp, *agfbp;
> > > +	struct xfs_agi		*agi;
> > > +	struct xfs_agf		*agf;
> > > +	int			error, err2;
> > > +	struct xfs_alloc_arg	args = {
> > > +		.tp	= tp,
> > > +		.mp	= mp,
> > > +		.type	= XFS_ALLOCTYPE_THIS_BNO,
> > > +		.minlen = len,
> > > +		.maxlen = len,
> > > +		.oinfo	= XFS_RMAP_OINFO_SKIP_UPDATE,
> > > +		.resv	= XFS_AG_RESV_NONE,
> > > +		.prod	= 1
> > > +	};
> > 
> > Dumb style note: I usually put onstack structs at the top of the
> > variable declaration list so that the variables are sorted in order of
> > decreasing size.
> 
> Thanks for your detailed review!
> 
> Ok, will move upwards in the next version.
> 
> > 
> > > +
> > > +	ASSERT(id->agno == mp->m_sb.sb_agcount - 1);
> > > +	error = xfs_ialloc_read_agi(mp, tp, id->agno, &agibp);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	agi = agibp->b_addr;
> > > +
> > > +	error = xfs_alloc_read_agf(mp, tp, id->agno, 0, &agfbp);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	args.fsbno = XFS_AGB_TO_FSB(mp, id->agno,
> > > +				    be32_to_cpu(agi->agi_length) - len);
> > > +
> > > +	/* remove the preallocations before allocation and re-establish then */
> > > +	error = xfs_ag_resv_free(agibp->b_pag);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	/* internal log shouldn't also show up in the free space btrees */
> > > +	error = xfs_alloc_vextent(&args);
> > > +	if (error)
> > > +		goto out;
> > > +
> > > +	if (args.agbno == NULLAGBLOCK) {
> > > +		error = -ENOSPC;
> > > +		goto out;
> > > +	}
> > 
> > Hmm.  So if the allocation above takes the last free space in the AG, we
> > won't be able to satisfy the new per-AG allocation below, which could
> > lead to a fs shutdown later (and even after subsequent mount attempts)
> > until enough space gets freed.  That's not good.
> > 
> > I think we should update the length fields in agibp and agfbp, and then
> > try to re-initialize the per-ag reservation.  If that succeeds, we can
> > log the agi and agf and return.  If the reinitialization returns a
> > non-ENOSPC error code then we of course just return the error code and
> > let the fs shut down.
> > 
> > However, if the reinit returns ENOSPC, then we have to back out
> > everything we've changed so far.  That means restore the old values of
> > the agibp/agfbp lengths, log an EFI to free the space we just allocated,
> > and return.  The caller then has to be smart enough to commit the
> > transaction before passing the ENOSPC back to its own caller.
> > 
> 
> I think I get the point. I might need to reconfirm such case first to
> verify new modification. (Although I think new reserve sizes could have
> some way to be calculated in advance, yet after having seen that, I
> might not want to touch such logic, so will try the way you mentioned...
> Thanks!)
> 
> > > +
> > > +	/* Change the agi length */
> > > +	be32_add_cpu(&agi->agi_length, -len);
> > > +	xfs_ialloc_log_agi(tp, agibp, XFS_AGI_LENGTH);
> > > +
> > > +	/* Change agf length */
> > > +	agf = agfbp->b_addr;
> > > +	be32_add_cpu(&agf->agf_length, -len);
> > > +	ASSERT(agf->agf_length == agi->agi_length);
> > 
> > Maybe we should check that these two lengths are the same right after we
> > grab the AG[IF] buffers and return EFSCORRUPTED?
> 
> Honestly, the original purpose of this wasn't for sanity check.. So I only
> left an ASSERT here...
> 
> If formal sanity check is needed, I will update this...

Well, it's ondisk metadata, so it's perfectly valid to do a formal
sanity check and bail out if things don't look right. :)

--D

> > 
> > > +	xfs_alloc_log_agf(tp, agfbp, XFS_AGF_LENGTH);
> > > +
> > > +out:
> > > +	err2 = xfs_ag_resv_init(agibp->b_pag, tp);
> > > +	if (err2 && err2 != -ENOSPC) {
> > 
> > I think we need to warn if err2 is ENOSPC here, since we're now running
> > with a (slightly) compromised filesystem.
> 
> Ok, will update.
> 
> > 
> > > +		xfs_warn(mp,
> > > +"Error %d reserving per-AG metadata reserve pool.", err2);
> > > +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > > +		return err2;
> > > +	}
> > > +	return error;
> > > +}
> > > +
> > >  /*
> > >   * Extent the AG indicated by the @id by the length passed in
> > >   */
> > > diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> > > index 5166322807e7..f3b5bbfeadce 100644
> > > --- a/fs/xfs/libxfs/xfs_ag.h
> > > +++ b/fs/xfs/libxfs/xfs_ag.h
> > > @@ -24,6 +24,8 @@ struct aghdr_init_data {
> > >  };
> > >  
> > >  int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
> > > +int xfs_ag_shrink_space(struct xfs_mount *mp, struct xfs_trans *tp,
> > > +			struct aghdr_init_data *id, xfs_extlen_t len);
> > >  int xfs_ag_extend_space(struct xfs_mount *mp, struct xfs_trans *tp,
> > >  			struct aghdr_init_data *id, xfs_extlen_t len);
> > >  int xfs_ag_get_geometry(struct xfs_mount *mp, xfs_agnumber_t agno,
> > > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > > index 8fde7a2989ce..6ee9ea4d5a67 100644
> > > --- a/fs/xfs/xfs_fsops.c
> > > +++ b/fs/xfs/xfs_fsops.c
> > > @@ -26,7 +26,7 @@ xfs_resizefs_init_new_ags(
> > >  	struct aghdr_init_data	*id,
> > >  	xfs_agnumber_t		oagcount,
> > >  	xfs_agnumber_t		nagcount,
> > > -	xfs_rfsblock_t		*delta)
> > > +	int64_t			*delta)
> > >  {
> > >  	xfs_rfsblock_t		nb = mp->m_sb.sb_dblocks + *delta;
> > >  	int			error;
> > > @@ -76,22 +76,28 @@ xfs_growfs_data_private(
> > >  	xfs_agnumber_t		nagcount;
> > >  	xfs_agnumber_t		nagimax = 0;
> > >  	xfs_rfsblock_t		nb, nb_div, nb_mod;
> > > -	xfs_rfsblock_t		delta;
> > > +	int64_t			delta;
> > >  	xfs_agnumber_t		oagcount;
> > >  	struct xfs_trans	*tp;
> > > +	bool			extend;
> > >  	struct aghdr_init_data	id = {};
> > >  
> > >  	nb = in->newblocks;
> > > -	if (nb < mp->m_sb.sb_dblocks)
> > > -		return -EINVAL;
> > > -	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
> > > +	if (nb == mp->m_sb.sb_dblocks)
> > > +		return 0;
> > > +
> > > +	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb);
> > > +	if (error)
> > >  		return error;
> > > -	error = xfs_buf_read_uncached(mp->m_ddev_targp,
> > > +
> > > +	if (nb > mp->m_sb.sb_dblocks) {
> > > +		error = xfs_buf_read_uncached(mp->m_ddev_targp,
> > >  				XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
> > >  				XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
> > > -	if (error)
> > > -		return error;
> > > -	xfs_buf_relse(bp);
> > > +		if (error)
> > > +			return error;
> > > +		xfs_buf_relse(bp);
> > > +	}
> > >  
> > >  	nb_div = nb;
> > >  	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
> > > @@ -99,10 +105,12 @@ xfs_growfs_data_private(
> > >  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
> > >  		nagcount--;
> > >  		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> > > -		if (nb < mp->m_sb.sb_dblocks)
> > > +		if (nagcount < 2)
> > >  			return -EINVAL;
> > >  	}
> > > +
> > >  	delta = nb - mp->m_sb.sb_dblocks;
> > > +	extend = (delta > 0);
> > >  	oagcount = mp->m_sb.sb_agcount;
> > >  
> > >  	/* allocate the new per-ag structures */
> > > @@ -110,22 +118,34 @@ xfs_growfs_data_private(
> > >  		error = xfs_initialize_perag(mp, nagcount, &nagimax);
> > >  		if (error)
> > >  			return error;
> > > +	} else if (nagcount != oagcount) {
> > > +		/* TODO: shrinking the entire AGs hasn't yet completed */
> > > +		return -EINVAL;
> > >  	}
> > >  
> > >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> > > -			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
> > > +			(extend ? XFS_GROWFS_SPACE_RES(mp) : -delta), 0,
> > > +			XFS_TRANS_RESERVE, &tp);
> > >  	if (error)
> > >  		return error;
> > >  
> > > -	error = xfs_resizefs_init_new_ags(mp, &id, oagcount, nagcount, &delta);
> > > -	if (error)
> > > -		goto out_trans_cancel;
> > > -
> > > +	if (extend) {
> > > +		error = xfs_resizefs_init_new_ags(mp, &id, oagcount,
> > > +						  nagcount, &delta);
> > > +		if (error)
> > > +			goto out_trans_cancel;
> > > +	}
> > >  	xfs_trans_agblocks_delta(tp, id.nfree);
> > >  
> > > -	/* If there are new blocks in the old last AG, extend it. */
> > > +	/* If there are some blocks in the last AG, resize it. */
> > >  	if (delta) {
> > > -		error = xfs_ag_extend_space(mp, tp, &id, delta);
> > > +		if (extend) {
> > > +			error = xfs_ag_extend_space(mp, tp, &id, delta);
> > > +		} else {
> > > +			id.agno = nagcount - 1;
> > > +			error = xfs_ag_shrink_space(mp, tp, &id, -delta);
> > > +		}
> > > +
> > >  		if (error)
> > >  			goto out_trans_cancel;
> > >  	}
> > > @@ -137,11 +157,19 @@ xfs_growfs_data_private(
> > >  	 */
> > >  	if (nagcount > oagcount)
> > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> > > -	if (nb > mp->m_sb.sb_dblocks)
> > > +	if (nb != mp->m_sb.sb_dblocks)
> > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
> > >  				 nb - mp->m_sb.sb_dblocks);
> > >  	if (id.nfree)
> > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> > > +
> > > +	/*
> > > +	 * update in-core counters (especially sb_fdblocks) now
> > > +	 * so xfs_validate_sb_write() can pass.
> > > +	 */
> > > +	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> > > +		xfs_log_sb(tp);
> > > +
> > >  	xfs_trans_set_sync(tp);
> > >  	error = xfs_trans_commit(tp);
> > >  	if (error)
> > > @@ -157,7 +185,7 @@ xfs_growfs_data_private(
> > >  	 * If we expanded the last AG, free the per-AG reservation
> > >  	 * so we can reinitialize it with the new size.
> > >  	 */
> > > -	if (delta) {
> > > +	if (delta > 0) {
> > >  		struct xfs_perag	*pag;
> > >  
> > >  		pag = xfs_perag_get(mp, id.agno);
> > > @@ -178,6 +206,10 @@ xfs_growfs_data_private(
> > >  	return error;
> > >  
> > >  out_trans_cancel:
> > > +	if (!extend && (tp->t_flags & XFS_TRANS_DIRTY)) {
> > 
> > If you're going to have a conditional commit in what looks like the
> > error return cleanup path, it would be a good idea to leave a comment
> > here explaining when we can end up in this condition.
> 
> Ok, Will add some words as well.
> 
> Thanks,
> Gao Xiang
> 
> > 
> > --D
> > 
> > > +		xfs_trans_commit(tp);
> > > +		return error;
> > > +	}
> > >  	xfs_trans_cancel(tp);
> > >  	return error;
> > >  }
> > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > index e72730f85af1..fd2cbf414b80 100644
> > > --- a/fs/xfs/xfs_trans.c
> > > +++ b/fs/xfs/xfs_trans.c
> > > @@ -419,7 +419,6 @@ xfs_trans_mod_sb(
> > >  		tp->t_res_frextents_delta += delta;
> > >  		break;
> > >  	case XFS_TRANS_SB_DBLOCKS:
> > > -		ASSERT(delta > 0);
> > >  		tp->t_dblocks_delta += delta;
> > >  		break;
> > >  	case XFS_TRANS_SB_AGCOUNT:
> > > -- 
> > > 2.27.0
> > > 
> > 
> 
