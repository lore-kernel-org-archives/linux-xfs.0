Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32639C433E6
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08A2A64E59
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355037AbhCDASP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:18:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:38166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236240AbhCCShZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 13:37:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A6AC64EE9;
        Wed,  3 Mar 2021 18:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614795928;
        bh=a9pH2sGFy/oBoT70SXP5ylcVXmKF85XhtExIrvRv+Qc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L+PLa+y72duqShxGLwTHQFNMpN/nQGz/9NXWmqlQ4Nk1I61J+IzHvqCT5iiOQsmrC
         n4NURnVYXUMdyON+gL8gDQo7IZUg62ZRhOVtV9gH5TLZHkezEG/39fXjGS0PQ7zCKY
         26mgDko1TCj6M5NCDMG9EDwO9BLuBsX7W98pouw2QVJMY7mbc66qkFH1nKQVa7zQ1U
         gWkbMcqXqHpEyJ5nPZ4v5DKio/8czybSPfb47Vg7Hn5odKRR2QYlo+GajXgfU4rTRd
         jLTahmCo3KnncaS31foLMdyDMHmLH0LbkhkntOMu0Y+Lv3U4EdBd/hlphaMbdQX/ZR
         ruAu60rfIDmPg==
Date:   Wed, 3 Mar 2021 10:25:27 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v7 4/5] xfs: support shrinking unused space in the last AG
Message-ID: <20210303182527.GC3419940@magnolia>
References: <20210302024816.2525095-1-hsiangkao@redhat.com>
 <20210302024816.2525095-5-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302024816.2525095-5-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 10:48:15AM +0800, Gao Xiang wrote:
> As the first step of shrinking, this attempts to enable shrinking
> unused space in the last allocation group by fixing up freespace
> btree, agi, agf and adjusting super block and use a helper
> xfs_ag_shrink_space() to fixup the last AG.
> 
> This can be all done in one transaction for now, so I think no
> additional protection is needed.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/xfs_fsops.c | 90 ++++++++++++++++++++++++++++------------------
>  fs/xfs/xfs_trans.c |  1 -
>  2 files changed, 55 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 494f9354e3fb..204c96d0010f 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -90,23 +90,29 @@ xfs_growfs_data_private(
>  	int			error;
>  	xfs_agnumber_t		nagcount;
>  	xfs_agnumber_t		nagimax = 0;
> -	xfs_rfsblock_t		nb, nb_div, nb_mod, delta;
> +	xfs_rfsblock_t		nb, nb_div, nb_mod;
> +	int64_t			delta;
>  	bool			lastag_resetagres;
>  	xfs_agnumber_t		oagcount;
>  	struct xfs_trans	*tp;
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
> @@ -114,10 +120,15 @@ xfs_growfs_data_private(
>  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
>  		nagcount--;
>  		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> -		if (nb < mp->m_sb.sb_dblocks)
> -			return -EINVAL;
>  	}
>  	delta = nb - mp->m_sb.sb_dblocks;
> +	/*
> +	 * XFS doesn't really support single-AG filesystems, so do not
> +	 * permit callers to remove the filesystem's second and last AG.
> +	 */
> +	if (delta < 0 && nagcount < 2)
> +		return -EINVAL;
> +
>  	oagcount = mp->m_sb.sb_agcount;
>  
>  	/* allocate the new per-ag structures */
> @@ -125,15 +136,23 @@ xfs_growfs_data_private(
>  		error = xfs_initialize_perag(mp, nagcount, &nagimax);
>  		if (error)
>  			return error;
> +	} else if (nagcount < oagcount) {
> +		/* TODO: shrinking the entire AGs hasn't yet completed */
> +		return -EINVAL;
>  	}
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> -			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
> +			(delta > 0 ? XFS_GROWFS_SPACE_RES(mp) : -delta), 0,
> +			XFS_TRANS_RESERVE, &tp);
>  	if (error)
>  		return error;
>  
> -	error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
> -					  delta, &lastag_resetagres);
> +	if (delta > 0)
> +		error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
> +						  delta, &lastag_resetagres);
> +	else
> +		error = xfs_ag_shrink_space(mp, &tp, nagcount - 1, -delta);

Hm, looking back at the previous patch, I think the last argument to
this function should be named "shrink_len" (or maybe just delta?) so
that future readers don't confuse it for the new (shorter) AG length.

> +

Nit: no blank line needed here.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -144,7 +163,7 @@ xfs_growfs_data_private(
>  	 */
>  	if (nagcount > oagcount)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> -	if (delta > 0)
> +	if (delta)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);
>  	if (id.nfree)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> @@ -168,28 +187,29 @@ xfs_growfs_data_private(
>  	xfs_set_low_space_thresholds(mp);
>  	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
>  
> -	/*
> -	 * If we expanded the last AG, free the per-AG reservation
> -	 * so we can reinitialize it with the new size.
> -	 */
> -	if (lastag_resetagres) {
> -		struct xfs_perag	*pag;
> -
> -		pag = xfs_perag_get(mp, id.agno);
> -		error = xfs_ag_resv_free(pag);
> -		xfs_perag_put(pag);
> -		if (error)
> -			return error;
> +	if (delta > 0) {
> +		/*
> +		 * If we expanded the last AG, free the per-AG reservation
> +		 * so we can reinitialize it with the new size.
> +		 */
> +		if (lastag_resetagres) {
> +			struct xfs_perag	*pag;
> +
> +			pag = xfs_perag_get(mp, id.agno);
> +			error = xfs_ag_resv_free(pag);
> +			xfs_perag_put(pag);
> +			if (error)
> +				return error;
> +		}
> +		/*
> +		 * Reserve AG metadata blocks. ENOSPC here does not mean there
> +		 * was a growfs failure, just that there still isn't space for
> +		 * new user data after the grow has been run.
> +		 */
> +		error = xfs_fs_reserve_ag_blocks(mp);
> +		if (error == -ENOSPC)
> +			error = 0;
>  	}
> -
> -	/*
> -	 * Reserve AG metadata blocks. ENOSPC here does not mean there was a
> -	 * growfs failure, just that there still isn't space for new user data
> -	 * after the grow has been run.
> -	 */
> -	error = xfs_fs_reserve_ag_blocks(mp);
> -	if (error == -ENOSPC)
> -		error = 0;
>  	return error;
>  
>  out_trans_cancel:
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 44f72c09c203..d047f5f26cc0 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -434,7 +434,6 @@ xfs_trans_mod_sb(
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
