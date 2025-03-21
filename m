Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFF478F5B
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 09:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742548416; cv=none; b=YK5yFXPeeHlolt4cIxW5mKPZtqikq4qO623p/EkD+cNa6dY62EInJMNkF56v57sS21zTN/zhJYZEJDXfu7TXyrXtu0grtXuwy1KMK8grJMDxk+SLGso0AOrvgt+nPd1CgYUNhkpG1BDIjWXL3g46n/YG3Rd7VR7MxAklkqHP/yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742548416; c=relaxed/simple;
	bh=z24H9JbHVxNeD1M0CsgYQHGAIk8RDeMoO4eKPM/6ubs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gCsB6B4VXOH60YltaN6I1T3R0iestLRcWmRCxMRqylnItC+a9FycaYz2WnUyWKQ5IvEY6KOoq5GCa+7zMPge2xQ4mp9zxFP7NrtJB3Fjat7QnUvf9AEsHfyPHu1ixF4aBU7nJEMkuIOn0xHiXDpN4u3abpieImzwz+bcBfnjYj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FTihVfp5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FTihVfp5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BAAC4CEE3;
	Fri, 21 Mar 2025 09:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742548415;
	bh=z24H9JbHVxNeD1M0CsgYQHGAIk8RDeMoO4eKPM/6ubs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FTihVfp5N3M6g8lihqDeOClYTLCIJnm/3Uu7f93GegD+1MsVWcqxxSqvLomx+eUPU
	 HCLwrSk26jVKRPd6LJSe64dXon8NaxvFeb/Cm0FJpalXaUDp4GYlHqT6Q8u7HLgABR
	 zK0Tjv9MoWuX+g8IQKx+ix47stwH5YkPKEUv0jNtdiHCGjB7D3/mmC8cS1dJWwH+eU
	 a7Z2+KrWdYPD56y/B+3eigZY5t0N0bF6uWTeL9Vw+2iWRmGMzVygmG3/E7Fg3MuQ+O
	 rttV9hz2E/XlCoUSpLXwxb2GrLK/fo9DyxW+m5WVRpd6eVJxZMM5UC60x99A9QesTQ
	 KprayrLlStx5w==
Date: Fri, 21 Mar 2025 10:13:29 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Dave Chinner <dchinner@redhat.com>, Dan Carpenter <dan.carpenter@linaro.org>, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: remove the leftover xfs_{set,clear}_li_failed
 infrastructure
Message-ID: <3zdtl36y6ck7436iv2yi44i4kvft6iqquqppmfzn5j4ld4i56e@tzgko2wq6fdo>
References: <20250320075221.1505190-1-hch@lst.de>
 <0ixrbDsd6zejOuEKSHHAjv-j9n2Mx6ouY3ub6ecobI5Y-Qp7tr2_xxgeuAHmJivXdlAQwgdbt-EaRzie0k49Gg==@protonmail.internalid>
 <20250320075221.1505190-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250320075221.1505190-2-hch@lst.de>

On Thu, Mar 20, 2025 at 08:52:13AM +0100, Christoph Hellwig wrote:
> Marking a log item as failed kept a buffer reference around for
> resubmission of inode and dquote items.
> 
> For inode items commit 298f7bec503f3 ("xfs: pin inode backing buffer to
> the inode log item") started pinning the inode item buffers
> unconditionally and removed the need for this.  Later commit acc8f8628c37
> ("xfs: attach dquot buffer to dquot log item buffer") did the same for
> dquot items but didn't fully clean up the xfs_clear_li_failed side
> for them.  Stop adding the extra pin for dquot items and remove the
> helpers.
> 
> This happens to fix a call to xfs_buf_free with the AIL lock held,
> which would be incorrect for the unlikely case freeing the buffer
> ends up calling vfree.
> 
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_dquot.c      |  3 +--
>  fs/xfs/xfs_inode_item.c |  6 ------
>  fs/xfs/xfs_trans_ail.c  |  5 ++---
>  fs/xfs/xfs_trans_priv.h | 28 ----------------------------
>  4 files changed, 3 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index edbc521870a1..b4e32f0860b7 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1186,9 +1186,8 @@ xfs_qm_dqflush_done(
>  	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags) &&
>  	    (lip->li_lsn == qlip->qli_flush_lsn ||
>  	     test_bit(XFS_LI_FAILED, &lip->li_flags))) {
> -
>  		spin_lock(&ailp->ail_lock);
> -		xfs_clear_li_failed(lip);
> +		clear_bit(XFS_LI_FAILED, &lip->li_flags);
>  		if (lip->li_lsn == qlip->qli_flush_lsn) {
>  			/* xfs_ail_update_finish() drops the AIL lock */
>  			tail_lsn = xfs_ail_delete_one(ailp, lip);
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 40fc1bf900af..c6cb0b6b9e46 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -1089,13 +1089,7 @@ xfs_iflush_abort(
>  	 * state. Whilst the inode is in the AIL, it should have a valid buffer
>  	 * pointer for push operations to access - it is only safe to remove the
>  	 * inode from the buffer once it has been removed from the AIL.
> -	 *
> -	 * We also clear the failed bit before removing the item from the AIL
> -	 * as xfs_trans_ail_delete()->xfs_clear_li_failed() will release buffer
> -	 * references the inode item owns and needs to hold until we've fully
> -	 * aborted the inode log item and detached it from the buffer.
>  	 */
> -	clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
>  	xfs_trans_ail_delete(&iip->ili_item, 0);
> 
>  	/*
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 0fcb1828e598..85a649fec6ac 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -909,10 +909,9 @@ xfs_trans_ail_delete(
>  		return;
>  	}
> 
> -	/* xfs_ail_update_finish() drops the AIL lock */
> -	xfs_clear_li_failed(lip);
> +	clear_bit(XFS_LI_FAILED, &lip->li_flags);
>  	tail_lsn = xfs_ail_delete_one(ailp, lip);
> -	xfs_ail_update_finish(ailp, tail_lsn);
> +	xfs_ail_update_finish(ailp, tail_lsn);	/* drops the AIL lock */
>  }
> 
>  int
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index bd841df93021..f945f0450b16 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -167,32 +167,4 @@ xfs_trans_ail_copy_lsn(
>  }
>  #endif
> 
> -static inline void
> -xfs_clear_li_failed(
> -	struct xfs_log_item	*lip)
> -{
> -	struct xfs_buf	*bp = lip->li_buf;
> -
> -	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
> -	lockdep_assert_held(&lip->li_ailp->ail_lock);
> -
> -	if (test_and_clear_bit(XFS_LI_FAILED, &lip->li_flags)) {
> -		lip->li_buf = NULL;
> -		xfs_buf_rele(bp);
> -	}
> -}
> -
> -static inline void
> -xfs_set_li_failed(
> -	struct xfs_log_item	*lip,
> -	struct xfs_buf		*bp)
> -{
> -	lockdep_assert_held(&lip->li_ailp->ail_lock);
> -
> -	if (!test_and_set_bit(XFS_LI_FAILED, &lip->li_flags)) {
> -		xfs_buf_hold(bp);
> -		lip->li_buf = bp;
> -	}
> -}
> -
>  #endif	/* __XFS_TRANS_PRIV_H__ */
> --
> 2.45.2
> 
