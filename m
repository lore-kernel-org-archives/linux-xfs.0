Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 816C3C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 17:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5835161A0A
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 17:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237436AbhCXRfK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 13:35:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237215AbhCXRej (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 13:34:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BEF1619EC;
        Wed, 24 Mar 2021 17:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616607279;
        bh=5KIOrkNKhQ9RzXpxzPRBbWInNGG2LxVDrNk9EgQZhrg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p9powOt99kV1hHWk4uYDM+i6umTDFaJ8rCCCJHAbJ/QLXCAx4/+jvqqpkXnOXoIGK
         x3zhBj+BZvYsxQGnwLffGcoG1QhNn7DGEhstpJNfgWVrBA1lm5YN/felZCnD6WXJYB
         y+enUQ+f64v9baEpBUKmypVLxRAjHtIBRpUVeSsYIdzf5vTVILycQD7+wFRQ7EsrA/
         PLHb8+9Xdvo8jLA4YiJPFmMpkDWq1JlmLUPKs3HUqN0xOMexE/b9aXiuxtnserH6Ch
         tevL4Z5UtSMG7wSv6B8awaafFUs3CFnEW1X+HubYu/MVBcmELtN77DqiO8s1cEqdmF
         bhCxcnEJXWX0A==
Date:   Wed, 24 Mar 2021 10:34:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v9 4/5] xfs: support shrinking unused space in the last AG
Message-ID: <20210324173438.GV22100@magnolia>
References: <20210324010621.2244671-1-hsiangkao@redhat.com>
 <20210324010621.2244671-5-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324010621.2244671-5-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 09:06:20AM +0800, Gao Xiang wrote:
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
>  fs/xfs/xfs_fsops.c | 84 +++++++++++++++++++++++++++-------------------
>  fs/xfs/xfs_trans.c |  1 -
>  2 files changed, 50 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index d1ba04124c28..9457b0691ece 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -91,23 +91,25 @@ xfs_growfs_data_private(
>  	xfs_agnumber_t		nagcount;
>  	xfs_agnumber_t		nagimax = 0;
>  	xfs_rfsblock_t		nb, nb_div, nb_mod;
> -	xfs_rfsblock_t		delta;
> +	int64_t			delta;
>  	bool			lastag_extended;
>  	xfs_agnumber_t		oagcount;
>  	struct xfs_trans	*tp;
>  	struct aghdr_init_data	id = {};
>  
>  	nb = in->newblocks;
> -	if (nb < mp->m_sb.sb_dblocks)
> -		return -EINVAL;
> -	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
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
> @@ -115,10 +117,16 @@ xfs_growfs_data_private(
>  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
>  		nagcount--;
>  		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> -		if (nb < mp->m_sb.sb_dblocks)
> -			return -EINVAL;
>  	}
>  	delta = nb - mp->m_sb.sb_dblocks;
> +	/*
> +	 * Reject filesystems with a single AG because they are not
> +	 * supported, and reject a shrink operation that would cause a
> +	 * filesystem to become unsupported.
> +	 */
> +	if (delta < 0 && nagcount < 2)
> +		return -EINVAL;
> +
>  	oagcount = mp->m_sb.sb_agcount;
>  
>  	/* allocate the new per-ag structures */
> @@ -126,15 +134,22 @@ xfs_growfs_data_private(
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
> -					  delta, &lastag_extended);
> +	if (delta > 0)
> +		error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
> +						  delta, &lastag_extended);
> +	else
> +		error = xfs_ag_shrink_space(mp, &tp, nagcount - 1, -delta);

Assuming I don't hear anyone yelling NAK in the next day or so, I think
I'll stage this for 5.13 with the following change to warn that the
shrink feature is still EXPERIMENTAL:

By the way, are you going to send a patch to shrink the realtime device
too?

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 9457b0691ece..b33c894b6cf3 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -145,11 +145,20 @@ xfs_growfs_data_private(
 	if (error)
 		return error;
 
-	if (delta > 0)
+	if (delta > 0) {
 		error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
 						  delta, &lastag_extended);
-	else
+	} else {
+		static struct ratelimit_state shrink_warning = \
+			RATELIMIT_STATE_INIT("shrink_warning", 86400 * HZ, 1);
+		ratelimit_set_flags(&shrink_warning, RATELIMIT_MSG_ON_RELEASE);
+
+		if (__ratelimit(&shrink_warning))
+			xfs_alert(mp,
+	"EXPERIMENTAL online shrink feature in use. Use at your own risk!");
+
 		error = xfs_ag_shrink_space(mp, &tp, nagcount - 1, -delta);
+	}
 	if (error)
 		goto out_trans_cancel;
 
--D

>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -169,28 +184,29 @@ xfs_growfs_data_private(
>  	xfs_set_low_space_thresholds(mp);
>  	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
>  
> -	/*
> -	 * If we expanded the last AG, free the per-AG reservation
> -	 * so we can reinitialize it with the new size.
> -	 */
> -	if (lastag_extended) {
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
> +		if (lastag_extended) {
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
> index b22a09e9daee..052274321993 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -436,7 +436,6 @@ xfs_trans_mod_sb(
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
