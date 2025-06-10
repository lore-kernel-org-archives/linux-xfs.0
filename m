Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A1A27E7F4
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 07:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749540012; cv=none; b=ntE5o+sn+K8HDI6yf8xDrVWK0knl1fqjvQfuvhF3WDEq3yoeJdaBqP0ubDCiS1bU+MLmvrorXgUGlzSJTxUmOR5Yz6e5/cN6Zb+Lg0KYxBY+RopmlG/I8cbdMRcqxT552w4DTB3R13cN62niA+zcUieWzPXFSX+26TiAttdC1zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749540012; c=relaxed/simple;
	bh=XV3vSdHrhZ4+3EWaIoY9KzHEFVXalWvwbY77MOSZ/U4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EAR/+vAghmf00cw5FBSZOOZ2wJOb+mS+Er6J8dZf0xJMuKzjbIrX/plM27QID/7DjSiXPQlOUu69sppdiBvX1hKjXoJ0wuGAW8uTrn/MMRY6b5tzbPiX/iI5pZ5AXOCdfqSDqn+TM9I1wFEuDvcMwPYNXQkTjKICe0sxHt/g22E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c/cZxlbm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c/cZxlbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E6EC4CEEF;
	Tue, 10 Jun 2025 07:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749540010;
	bh=XV3vSdHrhZ4+3EWaIoY9KzHEFVXalWvwbY77MOSZ/U4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c/cZxlbmRq/McuROLgOaj8oEr9rVHXD7znAACiA8Rg5kSQ/Wry7NHUeGWlkg06EM8
	 7XU4fUmDKnnkC3Sefo/uqq3aST4sNRa1xTqr1KTGF60Vj3td/7ZvncW05pC4kSUyPG
	 msgD4tFgqQBOISlq0PPBuP9lbhal96s/CoErSJa6cHwY+BJKeBgyJkPqHsCzFb5l77
	 FRT7yXZv6IKW30UVeeUtVWw6Ez4KsCNcCbch2pBLZL0JmTP9AvTjvUF03zJxE2aRKf
	 T+0u6DmdkJXJjL6oKGKyHMVKseFLGIVhkVphrVZOybQFzSU0QPRONbQiCPBuh2xJOt
	 iHFK0Cg31CvIQ==
Date: Tue, 10 Jun 2025 09:20:07 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/17] xfs: don't pass the old lv to xfs_cil_prepare_item
Message-ID: <6j6fpxfzty3hwq3kxj7ib4uqdnunk2hnokptf5durft7mpqbjc@ec75y6trwvd6>
References: <20250610051644.2052814-1-hch@lst.de>
 <6MfYDBpwBNiJoKgC6LwyzIPvcmH_RiHLAEFCq7xdhqiMoAYVb1aPtSIYYqblBQnLEEPHpnDWPwMUUV1hl5ThAA==@protonmail.internalid>
 <20250610051644.2052814-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250610051644.2052814-2-hch@lst.de>

On Tue, Jun 10, 2025 at 07:14:58AM +0200, Christoph Hellwig wrote:
> By the time xfs_cil_prepare_item is called, the old lv is still pointed
> to by the log item.  Take it from there instead of spreading the old lv
> logic over xlog_cil_insert_format_items and xfs_cil_prepare_item.

Looks Ok.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log_cil.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index f66d2d430e4f..c3db01b2ea47 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -370,8 +370,8 @@ xlog_cil_alloc_shadow_bufs(
>  STATIC void
>  xfs_cil_prepare_item(
>  	struct xlog		*log,
> +	struct xfs_log_item	*lip,
>  	struct xfs_log_vec	*lv,
> -	struct xfs_log_vec	*old_lv,
>  	int			*diff_len)
>  {
>  	/* Account for the new LV being passed in */
> @@ -381,19 +381,19 @@ xfs_cil_prepare_item(
>  	/*
>  	 * If there is no old LV, this is the first time we've seen the item in
>  	 * this CIL context and so we need to pin it. If we are replacing the
> -	 * old_lv, then remove the space it accounts for and make it the shadow
> +	 * old lv, then remove the space it accounts for and make it the shadow
>  	 * buffer for later freeing. In both cases we are now switching to the
>  	 * shadow buffer, so update the pointer to it appropriately.
>  	 */
> -	if (!old_lv) {
> +	if (!lip->li_lv) {
>  		if (lv->lv_item->li_ops->iop_pin)
>  			lv->lv_item->li_ops->iop_pin(lv->lv_item);
>  		lv->lv_item->li_lv_shadow = NULL;
> -	} else if (old_lv != lv) {
> +	} else if (lip->li_lv != lv) {
>  		ASSERT(lv->lv_buf_len != XFS_LOG_VEC_ORDERED);
> 
> -		*diff_len -= old_lv->lv_bytes;
> -		lv->lv_item->li_lv_shadow = old_lv;
> +		*diff_len -= lip->li_lv->lv_bytes;
> +		lv->lv_item->li_lv_shadow = lip->li_lv;
>  	}
> 
>  	/* attach new log vector to log item */
> @@ -453,7 +453,6 @@ xlog_cil_insert_format_items(
> 
>  	list_for_each_entry(lip, &tp->t_items, li_trans) {
>  		struct xfs_log_vec *lv;
> -		struct xfs_log_vec *old_lv = NULL;
>  		struct xfs_log_vec *shadow;
>  		bool	ordered = false;
> 
> @@ -474,7 +473,6 @@ xlog_cil_insert_format_items(
>  			continue;
> 
>  		/* compare to existing item size */
> -		old_lv = lip->li_lv;
>  		if (lip->li_lv && shadow->lv_size <= lip->li_lv->lv_size) {
>  			/* same or smaller, optimise common overwrite case */
>  			lv = lip->li_lv;
> @@ -510,7 +508,7 @@ xlog_cil_insert_format_items(
>  		ASSERT(IS_ALIGNED((unsigned long)lv->lv_buf, sizeof(uint64_t)));
>  		lip->li_ops->iop_format(lip, lv);
>  insert:
> -		xfs_cil_prepare_item(log, lv, old_lv, diff_len);
> +		xfs_cil_prepare_item(log, lip, lv, diff_len);
>  	}
>  }
> 
> --
> 2.47.2
> 
> 
