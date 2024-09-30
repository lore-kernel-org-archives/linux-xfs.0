Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AC3192B66
	for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 16:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727715020; cv=none; b=qwh1HG8ZJ1U+bVr71P96cAgnVFXMfW11R5Su+yb2EUm+yTBzQRxVHrPxe1G4CiUhtSmp9EYTCYuFpGQ6A6ix9X5qbGqo11ePDtQvElS2UtjayFznisemlWjf1vJWnRH8l/ZUJapkY7qtyfDB6Z9VUdy+6pW2Ai78LOdM1PN/Bsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727715020; c=relaxed/simple;
	bh=jOQWBx7LoqDIamIlLKSgjdFAy1Ta57xMXguPvvUk+Ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=opUkj/fxqMrVhhjcE7rI4rLjo6243zuAh7KfrPwZxR3NUAOAQ9CeM+qC4PvErSXfpDcZnaqdmYhtwsnZN3wkvPpKq7GG94NfnYlB8WxBt+/fPrKgWoLuq2MbpjPmoUiHlmV+phg/4Nj3i3m5k3m7UwCHbkjFJCF6YobxgZ8Z9hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WgrYb+3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WgrYb+3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17D6C4CECF;
	Mon, 30 Sep 2024 16:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727715019;
	bh=jOQWBx7LoqDIamIlLKSgjdFAy1Ta57xMXguPvvUk+Ao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WgrYb+3ppBd2AeBsD97EaN+J/qBasorM7LwdE18BFoem2O87+t/ZEjH2LTGuWUEjN
	 gpwzdvhAan4GIAA/kh0Nz2Tyk/C0Wg3SMfuDAAey58MRfs+QHja+F5+kKKXLMM2A3X
	 yYGRGr1KOG3D9+17bc7sx2tIb2dX5HeN3clDivQqXtMGAJMp2B7DjK0M/W9w47gloI
	 wvtnmhuaQLFZHOvuI9Kep68ImHgAWXcVhkJW58pRZKMNqDF3TjqkvhuQNH4/xb73k8
	 MSXgdwHKtidE0aBsNdAvC1xq1ouL/2VjIj9W4eQ9Oi44/zzRk8POABsLxHCxRvLHac
	 NwPBb9/8S856Q==
Date: Mon, 30 Sep 2024 09:50:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: update the file system geometry after
 recoverying superblock buffers
Message-ID: <20240930165019.GS21853@frogsfrogsfrogs>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240930164211.2357358-4-hch@lst.de>

On Mon, Sep 30, 2024 at 06:41:44PM +0200, Christoph Hellwig wrote:
> Primary superblock buffers that change the file system geometry after a
> growfs operation can affect the operation of later CIL checkpoints that
> make use of the newly added space and allocation groups.
> 
> Apply the changes to the in-memory structures as part of recovery pass 2,
> to ensure recovery works fine for such cases.
> 
> In the future we should apply the logic to other updates such as features
> bits as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_log_recover.h |  2 ++
>  fs/xfs/xfs_buf_item_recover.c   | 27 +++++++++++++++++++++++++++
>  fs/xfs/xfs_log_recover.c        | 27 +++++++++++++++++++--------
>  3 files changed, 48 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
> index 521d327e4c89ed..d0e13c84422d0a 100644
> --- a/fs/xfs/libxfs/xfs_log_recover.h
> +++ b/fs/xfs/libxfs/xfs_log_recover.h
> @@ -165,4 +165,6 @@ void xlog_recover_intent_item(struct xlog *log, struct xfs_log_item *lip,
>  int xlog_recover_finish_intent(struct xfs_trans *tp,
>  		struct xfs_defer_pending *dfp);
>  
> +int xlog_recover_update_agcount(struct xfs_mount *mp, struct xfs_dsb *dsb);
> +
>  #endif	/* __XFS_LOG_RECOVER_H__ */
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 09e893cf563cb9..08c129022304a8 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -684,6 +684,28 @@ xlog_recover_do_inode_buffer(
>  	return 0;
>  }
>  
> +static int
> +xlog_recover_do_sb_buffer(
> +	struct xfs_mount		*mp,
> +	struct xlog_recover_item	*item,
> +	struct xfs_buf			*bp,
> +	struct xfs_buf_log_format	*buf_f,
> +	xfs_lsn_t			current_lsn)
> +{
> +	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
> +
> +	/*
> +	 * Update the in-memory superblock and perag structures from the
> +	 * primary SB buffer.
> +	 *
> +	 * This is required because transactions running after growfs may require
> +	 * the updated values to be set in a previous fully commit transaction.
> +	 */
> +	if (xfs_buf_daddr(bp) != 0)
> +		return 0;
> +	return xlog_recover_update_agcount(mp, bp->b_addr);
> +}
> +
>  /*
>   * V5 filesystems know the age of the buffer on disk being recovered. We can
>   * have newer objects on disk than we are replaying, and so for these cases we
> @@ -967,6 +989,11 @@ xlog_recover_buf_commit_pass2(
>  		dirty = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
>  		if (!dirty)
>  			goto out_release;
> +	} else if (xfs_blft_from_flags(buf_f) & XFS_BLFT_SB_BUF) {
> +		error = xlog_recover_do_sb_buffer(mp, item, bp, buf_f,
> +				current_lsn);
> +		if (error)
> +			goto out_release;
>  	} else {
>  		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
>  	}
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 6a165ca55da1a8..03701409c7dcd6 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3334,6 +3334,25 @@ xlog_do_log_recovery(
>  	return error;
>  }
>  
> +int
> +xlog_recover_update_agcount(
> +	struct xfs_mount		*mp,
> +	struct xfs_dsb			*dsb)
> +{
> +	xfs_agnumber_t			old_agcount = mp->m_sb.sb_agcount;
> +	int				error;
> +
> +	xfs_sb_from_disk(&mp->m_sb, dsb);

If I'm understanding this correctly, the incore superblock gets updated
every time recovery finds a logged primary superblock buffer now,
instead of once at the end of log recovery, right?

Shouldn't this conversion be done in the caller?  Some day we're going
to want to do the same with xfs_initialize_rtgroups(), right?

--D

> +	error = xfs_initialize_perag(mp, old_agcount, mp->m_sb.sb_agcount,
> +			mp->m_sb.sb_dblocks, &mp->m_maxagi);
> +	if (error) {
> +		xfs_warn(mp, "Failed recovery per-ag init: %d", error);
> +		return error;
> +	}
> +	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
> +	return 0;
> +}
> +
>  /*
>   * Do the actual recovery
>   */
> @@ -3346,7 +3365,6 @@ xlog_do_recover(
>  	struct xfs_mount	*mp = log->l_mp;
>  	struct xfs_buf		*bp = mp->m_sb_bp;
>  	struct xfs_sb		*sbp = &mp->m_sb;
> -	xfs_agnumber_t		old_agcount = sbp->sb_agcount;
>  	int			error;
>  
>  	trace_xfs_log_recover(log, head_blk, tail_blk);
> @@ -3394,13 +3412,6 @@ xlog_do_recover(
>  	/* re-initialise in-core superblock and geometry structures */
>  	mp->m_features |= xfs_sb_version_to_features(sbp);
>  	xfs_reinit_percpu_counters(mp);
> -	error = xfs_initialize_perag(mp, old_agcount, sbp->sb_agcount,
> -			sbp->sb_dblocks, &mp->m_maxagi);
> -	if (error) {
> -		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
> -		return error;
> -	}
> -	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
>  
>  	/* Normal transactions can now occur */
>  	clear_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
> -- 
> 2.45.2
> 
> 
