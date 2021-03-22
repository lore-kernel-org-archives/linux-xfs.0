Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C15C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 11:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58B6C619A0
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 11:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhCVLbK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 07:31:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25961 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230050AbhCVLau (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 07:30:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616412649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q8xjjsvlA5bupUPYqMtM+Z8Wp88WAUw0BnReF1e7pbc=;
        b=IkcGMtIJL8TKHCTy6sKHXpWhaJD8ee+BuNM8TgZhEFXMUASsMjuYULUZYh/HEr2/Fyv45l
        esV5+ysOqoyp9OY1zhu7bv9578pBj1qiGpB1IaqkA1yArowEobAACHrX/ePmb3H0E3917o
        Xyq46GcZ1+o+wroDaL5/GYeL5AXTx88=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-ykJRpT0tPm2ZACR6RGguDQ-1; Mon, 22 Mar 2021 07:30:47 -0400
X-MC-Unique: ykJRpT0tPm2ZACR6RGguDQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 850EB87A82A;
        Mon, 22 Mar 2021 11:30:46 +0000 (UTC)
Received: from bfoster (ovpn-112-29.rdu2.redhat.com [10.10.112.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B7F0709A9;
        Mon, 22 Mar 2021 11:30:42 +0000 (UTC)
Date:   Mon, 22 Mar 2021 07:30:40 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v8 4/5] xfs: support shrinking unused space in the last AG
Message-ID: <YFh/4A/9OPzHJ2pi@bfoster>
References: <20210305025703.3069469-1-hsiangkao@redhat.com>
 <20210305025703.3069469-5-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305025703.3069469-5-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 10:57:02AM +0800, Gao Xiang wrote:
> As the first step of shrinking, this attempts to enable shrinking
> unused space in the last allocation group by fixing up freespace
> btree, agi, agf and adjusting super block and use a helper
> xfs_ag_shrink_space() to fixup the last AG.
> 
> This can be all done in one transaction for now, so I think no
> additional protection is needed.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/xfs_fsops.c | 88 ++++++++++++++++++++++++++++------------------
>  fs/xfs/xfs_trans.c |  1 -
>  2 files changed, 53 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index fc9e799b2ae3..71cba61a451c 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -91,23 +91,28 @@ xfs_growfs_data_private(
>  	xfs_agnumber_t		nagcount;
>  	xfs_agnumber_t		nagimax = 0;
>  	xfs_rfsblock_t		nb, nb_div, nb_mod;
> -	xfs_rfsblock_t		delta;
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

It looks like the caller already does this check.

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
> @@ -115,10 +120,15 @@ xfs_growfs_data_private(
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

What if the filesystem is already single AG? Unless I'm missing
something, we already have a check a bit further down that prevents
removal of AGs in the first place.

Otherwise looks reasonable..

Brian

>  	oagcount = mp->m_sb.sb_agcount;
>  
>  	/* allocate the new per-ag structures */
> @@ -126,15 +136,22 @@ xfs_growfs_data_private(
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
>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -145,7 +162,7 @@ xfs_growfs_data_private(
>  	 */
>  	if (nagcount > oagcount)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> -	if (delta > 0)
> +	if (delta)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);
>  	if (id.nfree)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> @@ -169,28 +186,29 @@ xfs_growfs_data_private(
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

