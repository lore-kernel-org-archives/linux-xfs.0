Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27EDBC4332D
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 19:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E622123440
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 19:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391903AbhATT0O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 14:26:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:60486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392402AbhATTZu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Jan 2021 14:25:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DE29233EB;
        Wed, 20 Jan 2021 19:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611170707;
        bh=ktZFbA+Qy46WJj+3mhjYgcFBAAsTG0qwL3XNqsxPcqw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y6KVoJ8/PaM/0M5L30kwHPjxzifbQu7sm8MUyfWx9HSbqkbN+BRF+M2B/6EqG8E9C
         +dfPrSoTikgdZq2H6YNi6XnlizJkgparpMe24s4ozWNHXvnMJqzWbdyKv3pwUQ78p1
         PnowFXgOyNzES87pH4iDn2cvDwRitxMkQyueRNnXRxW1WqrcAQMDG3YyuEKVL2yYna
         vVyD8RKddZjLsLY1dtvvKyfQSu5r25KPXSwJXBHQj/r4JLbr41y3yQVizTzHlZemsW
         iZSNPHHTf4OC0/IolznRCmWj2/8VOp3MeXNAzlekZRp35IefdhOu6HjZJHykesXo/x
         H+AUZNS6eF71Q==
Date:   Wed, 20 Jan 2021 11:25:06 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 4/5] xfs: support shrinking unused space in the last AG
Message-ID: <20210120192506.GL3134581@magnolia>
References: <20210118083700.2384277-1-hsiangkao@redhat.com>
 <20210118083700.2384277-5-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118083700.2384277-5-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 04:36:59PM +0800, Gao Xiang wrote:
> As the first step of shrinking, this attempts to enable shrinking
> unused space in the last allocation group by fixing up freespace
> btree, agi, agf and adjusting super block and introduce a helper
> xfs_ag_shrink_space() to fixup the last AG.
> 
> This can be all done in one transaction for now, so I think no
> additional protection is needed.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag.c | 88 ++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ag.h |  2 +
>  fs/xfs/xfs_fsops.c     | 77 ++++++++++++++++++++++++++----------
>  fs/xfs/xfs_trans.c     |  1 -
>  4 files changed, 146 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 9331f3516afa..04a7c9b20470 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -22,6 +22,8 @@
>  #include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  #include "xfs_health.h"
> +#include "xfs_error.h"
> +#include "xfs_bmap.h"
>  
>  static int
>  xfs_get_aghdr_buf(
> @@ -485,6 +487,92 @@ xfs_ag_init_headers(
>  	return error;
>  }
>  
> +int
> +xfs_ag_shrink_space(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	struct aghdr_init_data	*id,
> +	xfs_extlen_t		len)
> +{
> +	struct xfs_alloc_arg	args = {
> +		.tp	= tp,
> +		.mp	= mp,
> +		.type	= XFS_ALLOCTYPE_THIS_BNO,
> +		.minlen = len,
> +		.maxlen = len,
> +		.oinfo	= XFS_RMAP_OINFO_SKIP_UPDATE,
> +		.resv	= XFS_AG_RESV_NONE,
> +		.prod	= 1
> +	};
> +	struct xfs_buf		*agibp, *agfbp;
> +	struct xfs_agi		*agi;
> +	struct xfs_agf		*agf;
> +	int			error, err2;
> +
> +	ASSERT(id->agno == mp->m_sb.sb_agcount - 1);
> +	error = xfs_ialloc_read_agi(mp, tp, id->agno, &agibp);
> +	if (error)
> +		return error;
> +
> +	agi = agibp->b_addr;
> +
> +	error = xfs_alloc_read_agf(mp, tp, id->agno, 0, &agfbp);
> +	if (error)
> +		return error;
> +
> +	agf = agfbp->b_addr;
> +	if (XFS_IS_CORRUPT(mp, agf->agf_length != agi->agi_length))
> +		return -EFSCORRUPTED;
> +
> +	args.fsbno = XFS_AGB_TO_FSB(mp, id->agno,
> +				    be32_to_cpu(agi->agi_length) - len);
> +
> +	/* remove the preallocations before allocation and re-establish then */
> +	error = xfs_ag_resv_free(agibp->b_pag);
> +	if (error)
> +		return error;
> +
> +	/* internal log shouldn't also show up in the free space btrees */
> +	error = xfs_alloc_vextent(&args);
> +	if (!error && args.agbno == NULLAGBLOCK)
> +		error = -ENOSPC;
> +
> +	if (error) {

Aha, now I see why this bit:

	if (!extend && ((tp->t_flags & XFS_TRANS_DIRTY) ||
			!list_empty(&tp->t_dfops)))
		xfs_trans_commit(tp);

is needed below -- we could have refilled the AGFL here but failed the
allocation.  At this point we have a dirty transaction /and/ an error
code.  We need to commit the AGFL refill changes and return to userspace
with that error code, but calling xfs_trans_cancel on the dirty
transaction causes an (unnecessary) shutdown.

What if you rolled the transaction here and passed the new tp and the
error code back to the caller?  The new transaction is clean so it will
cancel without any side effects, and then you can send the ENOSPC up to
userspace.

Granted, you could just as easily commit the transaction here and make
the caller smart enough to know that it no longer has a transaction.  I
wonder if the transaction allocation and disposal ought to be part of
the _ag_grow_space and _ag_shrink_space functions.

Also fwiw I would make sure the transaction is clean before I tried to
re-initialize the per-ag reservation.

> +		err2 = xfs_ag_resv_init(agibp->b_pag, tp);
> +		if (err2)
> +			goto resv_err;
> +		return error;
> +	}
> +
> +	/*
> +	 * if successfully deleted from freespace btrees, need to confirm
> +	 * per-AG reservation works as expected.
> +	 */
> +	be32_add_cpu(&agi->agi_length, -len);
> +	be32_add_cpu(&agf->agf_length, -len);
> +
> +	err2 = xfs_ag_resv_init(agibp->b_pag, tp);
> +	if (err2) {
> +		be32_add_cpu(&agi->agi_length, len);
> +		be32_add_cpu(&agf->agf_length, len);
> +		if (err2 != -ENOSPC)
> +			goto resv_err;

If we've just undone reducing ag[if]_length, don't we need to call
xfs_ag_resv_init here to (try to) recreate the former per-ag
reservations?

Also, the comment above about cleaning the transaction before trying to
reinit the per-ag reservation and returning ENOSPC applies here.

> +
> +		__xfs_bmap_add_free(tp, args.fsbno, len,
> +				    &XFS_RMAP_OINFO_SKIP_UPDATE, true);
> +		return err2;
> +	}
> +	xfs_ialloc_log_agi(tp, agibp, XFS_AGI_LENGTH);
> +	xfs_alloc_log_agf(tp, agfbp, XFS_AGF_LENGTH);
> +	return 0;
> +
> +resv_err:
> +	xfs_warn(mp,
> +"Error %d reserving per-AG metadata reserve pool.", err2);
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +	return err2;
> +}
> +
>  /*
>   * Extent the AG indicated by the @id by the length passed in
>   */
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 5166322807e7..f3b5bbfeadce 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -24,6 +24,8 @@ struct aghdr_init_data {
>  };
>  
>  int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
> +int xfs_ag_shrink_space(struct xfs_mount *mp, struct xfs_trans *tp,
> +			struct aghdr_init_data *id, xfs_extlen_t len);
>  int xfs_ag_extend_space(struct xfs_mount *mp, struct xfs_trans *tp,
>  			struct aghdr_init_data *id, xfs_extlen_t len);
>  int xfs_ag_get_geometry(struct xfs_mount *mp, xfs_agnumber_t agno,
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index db6ed354c465..2ae4f33b42c9 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -38,7 +38,7 @@ xfs_resizefs_init_new_ags(
>  	struct aghdr_init_data	*id,
>  	xfs_agnumber_t		oagcount,
>  	xfs_agnumber_t		nagcount,
> -	xfs_rfsblock_t		*delta)
> +	int64_t			*delta)
>  {
>  	xfs_rfsblock_t		nb = mp->m_sb.sb_dblocks + *delta;
>  	int			error;
> @@ -76,33 +76,41 @@ xfs_growfs_data_private(
>  	xfs_agnumber_t		nagcount;
>  	xfs_agnumber_t		nagimax = 0;
>  	xfs_rfsblock_t		nb, nb_div, nb_mod;
> -	xfs_rfsblock_t		delta;
> +	int64_t			delta;
>  	xfs_agnumber_t		oagcount;
>  	struct xfs_trans	*tp;
> +	bool			extend;
>  	struct aghdr_init_data	id = {};
>  
>  	nb = in->newblocks;
> -	if (nb < mp->m_sb.sb_dblocks)
> -		return -EINVAL;
> -	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
> +	if (nb == mp->m_sb.sb_dblocks)
> +		return 0;
> +
> +	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb);
> +	if (error)
>  		return error;
> -	error = xfs_buf_read_uncached(mp->m_ddev_targp,
> +
> +	if (nb > mp->m_sb.sb_dblocks) {
> +		error = xfs_buf_read_uncached(mp->m_ddev_targp,
>  				XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
>  				XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
> -	if (error)
> -		return error;
> -	xfs_buf_relse(bp);
> +		if (error)
> +			return error;
> +		xfs_buf_relse(bp);
> +	}
>  
>  	nb_div = nb;
>  	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
>  	nagcount = nb_div + (nb_mod != 0);
>  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
>  		nagcount--;
> -		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> -		if (nb < mp->m_sb.sb_dblocks)
> +		if (nagcount < 2)
>  			return -EINVAL;
> +		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
>  	}
> +
>  	delta = nb - mp->m_sb.sb_dblocks;
> +	extend = (delta > 0);
>  	oagcount = mp->m_sb.sb_agcount;
>  
>  	/* allocate the new per-ag structures */
> @@ -110,22 +118,34 @@ xfs_growfs_data_private(
>  		error = xfs_initialize_perag(mp, nagcount, &nagimax);
>  		if (error)
>  			return error;
> +	} else if (nagcount != oagcount) {

Nit: nagcount < oagcount ?

> +		/* TODO: shrinking the entire AGs hasn't yet completed */
> +		return -EINVAL;
>  	}
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> -			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
> +			(extend ? XFS_GROWFS_SPACE_RES(mp) : -delta), 0,
> +			XFS_TRANS_RESERVE, &tp);
>  	if (error)
>  		return error;
>  
> -	error = xfs_resizefs_init_new_ags(mp, &id, oagcount, nagcount, &delta);
> -	if (error)
> -		goto out_trans_cancel;
> -
> +	if (extend) {
> +		error = xfs_resizefs_init_new_ags(mp, &id, oagcount,
> +						  nagcount, &delta);
> +		if (error)
> +			goto out_trans_cancel;
> +	}
>  	xfs_trans_agblocks_delta(tp, id.nfree);
>  
> -	/* If there are new blocks in the old last AG, extend it. */
> +	/* If there are some blocks in the last AG, resize it. */
>  	if (delta) {
> -		error = xfs_ag_extend_space(mp, tp, &id, delta);
> +		if (extend) {
> +			error = xfs_ag_extend_space(mp, tp, &id, delta);
> +		} else {
> +			id.agno = nagcount - 1;
> +			error = xfs_ag_shrink_space(mp, tp, &id, -delta);

This is a little nitpicky, but I wonder if the reorganization of
xfs_growfs_data_private ought to be in a separate preparation patch,
wherein you'd define xfs_ag_shrink_space as a stub that returns
EOPNOSUPP, and make all the necessary adjustments to the caller.

That way, this second patch would concentrate on replacing the
shrink_space stub an actual implementation.

> +		}
> +
>  		if (error)
>  			goto out_trans_cancel;
>  	}
> @@ -137,11 +157,19 @@ xfs_growfs_data_private(
>  	 */
>  	if (nagcount > oagcount)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> -	if (nb > mp->m_sb.sb_dblocks)
> +	if (nb != mp->m_sb.sb_dblocks)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
>  				 nb - mp->m_sb.sb_dblocks);
>  	if (id.nfree)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> +
> +	/*
> +	 * update in-core counters (especially sb_fdblocks) now
> +	 * so xfs_validate_sb_write() can pass.
> +	 */
> +	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> +		xfs_log_sb(tp);

How do we get a failure in xfs_validate_sb_write?  We're changing
fdblocks and dblocks in the same transaction, which means that both
counters should have changed by the number of blocks we took out of
the filesystem, right?

Is the problem that the TRANS_SB_DBLOCKS change above makes the primary
super's sb_dblocks decrease immediately, but since we're in lazycounters
mode we defer updating sb_fdblocks until unmount, so in the meantime
we fail the sb write verifier because fdblocks > dblocks?

Or: is it the general case that we ought to be forcing fdblocks to get
logged here even for fs grow operations?  In which case this (minor)
behavior change probably should go in a separate patch.

--D

> +
>  	xfs_trans_set_sync(tp);
>  	error = xfs_trans_commit(tp);
>  	if (error)
> @@ -157,7 +185,7 @@ xfs_growfs_data_private(
>  	 * If we expanded the last AG, free the per-AG reservation
>  	 * so we can reinitialize it with the new size.
>  	 */
> -	if (delta) {
> +	if (delta > 0) {
>  		struct xfs_perag	*pag;
>  
>  		pag = xfs_perag_get(mp, id.agno);
> @@ -178,7 +206,14 @@ xfs_growfs_data_private(
>  	return error;
>  
>  out_trans_cancel:
> -	xfs_trans_cancel(tp);
> +	/*
> +	 * AGFL fixup can dirty the transaction, so it needs committing anyway.
> +	 */
> +	if (!extend && ((tp->t_flags & XFS_TRANS_DIRTY) ||
> +			!list_empty(&tp->t_dfops)))
> +		xfs_trans_commit(tp);
> +	else
> +		xfs_trans_cancel(tp);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index e72730f85af1..fd2cbf414b80 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -419,7 +419,6 @@ xfs_trans_mod_sb(
>  		tp->t_res_frextents_delta += delta;
>  		break;
>  	case XFS_TRANS_SB_DBLOCKS:
> -		ASSERT(delta > 0);
>  		tp->t_dblocks_delta += delta;
>  		break;
>  	case XFS_TRANS_SB_AGCOUNT:
> -- 
> 2.27.0
> 
