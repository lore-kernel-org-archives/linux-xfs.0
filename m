Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0D51A8401
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 09:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749546427; cv=none; b=O67k2OOIOJpjNaYH6ElFzJZ+rkV33n7MGHqiGrhcAve+8I3EjBj2cE+n0GJJsAAl5FcckTfAhUghpxnL9tZJr/NDO4X5GjismjArwa+8t0xO+isdxg5YRgWCSuMIhEfPIHUKVA5ib9NlD8Uec4K6F5tRixGzJ18dVpTs83C0H+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749546427; c=relaxed/simple;
	bh=G1xDF5rnWOkCETyraOuXdMqnNLzJbK74JFR5C3xWvEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XvQQuoZV5Dg60Oi1J1ssjNouNjtqcO5+YnU529ZH6nMT6Mb4y4P0fMpdzRIEGzn2q+wUPbZLcfiX9lBqWzf7pEc0NwlFXRe9sKtuPKBEq0O0ROoO5RVqS0S+ju79oovCtU3E0SXkIjkexi+05nGgJZQXA7ovu4BTwvSeKS9VG/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ChDPC2tZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ChDPC2tZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0D8C4CEEF;
	Tue, 10 Jun 2025 09:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749546426;
	bh=G1xDF5rnWOkCETyraOuXdMqnNLzJbK74JFR5C3xWvEM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ChDPC2tZI+asUi1dHGWsVL4whgwMDi1Xd5HTtfsfKyd4JAPjRlcyP8nhlOXEj4DpY
	 ZvFnwcNV4FwDuYxZnrE3FBx72vkZTv5bN0tcmWrgIefo5tr3fcKPmFtlTStP0zfmQj
	 vrdaKTQv2xxV83Ds9mFAujgmZ5PIyNHLH6ZKo/0o+RDQxsZfKZgwTL7mJq7dH3eUDY
	 sr0hYCdrmtjDwgvwlxsHvOky+UDfwcu5cQQTbNEalWi3f9h9giuJI47wAgrZyMizRs
	 W/Pzflcakd64up662/MomERSHZF/wmq4lTy2jBow5pXXvvUW3CgI4lCO12UnIfYQ6N
	 /oUjaOAyCfvtA==
Date: Tue, 10 Jun 2025 11:07:02 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/17] xfs: use better names for size members in
 xfs_log_vec
Message-ID: <u7ihvsg5zffnfdmuzz6564opaimanplhmuqhye44wthpg54ja2@mh4pdrtmlnvj>
References: <20250610051644.2052814-1-hch@lst.de>
 <YdBSqUAcJdfR2oWzZzLXSrapSKX-q1CurAlDrrBUbmd7bXlAO8LqNlCEJQaEZQ2o77r2ajptSKtHDdSn9N1AAQ==@protonmail.internalid>
 <20250610051644.2052814-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250610051644.2052814-4-hch@lst.de>

On Tue, Jun 10, 2025 at 07:15:00AM +0200, Christoph Hellwig wrote:
> The lv_size member counts the size of the entire allocation, rename it
> to lv_alloc_size to make that clear.
> 
> The lv_buf_size member tracks how much of lv_buf has been used up
> to format the log item, rename it to lv_buf_used to make that more

Just a nit. lv_buf_len.  Otherwise looks good to me.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> clear.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c     | 10 +++++-----
>  fs/xfs/xfs_log.h     |  9 +++++----
>  fs/xfs/xfs_log_cil.c | 30 +++++++++++++++---------------
>  3 files changed, 25 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 793468b4d30d..3179923a68d4 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -109,14 +109,14 @@ xlog_prepare_iovec(
>  		vec = &lv->lv_iovecp[0];
>  	}
> 
> -	len = lv->lv_buf_len + sizeof(struct xlog_op_header);
> +	len = lv->lv_buf_used + sizeof(struct xlog_op_header);
>  	if (!IS_ALIGNED(len, sizeof(uint64_t))) {
> -		lv->lv_buf_len = round_up(len, sizeof(uint64_t)) -
> +		lv->lv_buf_used = round_up(len, sizeof(uint64_t)) -
>  					sizeof(struct xlog_op_header);
>  	}
> 
>  	vec->i_type = type;
> -	vec->i_addr = lv->lv_buf + lv->lv_buf_len;
> +	vec->i_addr = lv->lv_buf + lv->lv_buf_used;
> 
>  	oph = vec->i_addr;
>  	oph->oh_clientid = XFS_TRANSACTION;
> @@ -1931,9 +1931,9 @@ xlog_print_trans(
>  		if (!lv)
>  			continue;
>  		xfs_warn(mp, "  niovecs	= %d", lv->lv_niovecs);
> -		xfs_warn(mp, "  size	= %d", lv->lv_size);
> +		xfs_warn(mp, "  alloc_size = %d", lv->lv_alloc_size);
>  		xfs_warn(mp, "  bytes	= %d", lv->lv_bytes);
> -		xfs_warn(mp, "  buf len	= %d", lv->lv_buf_len);
> +		xfs_warn(mp, "  buf used= %d", lv->lv_buf_used);
> 
>  		/* dump each iovec for the log item */
>  		vec = lv->lv_iovecp;
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 13455854365f..f239fce4f260 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -16,8 +16,8 @@ struct xfs_log_vec {
>  	struct xfs_log_item	*lv_item;	/* owner */
>  	char			*lv_buf;	/* formatted buffer */
>  	int			lv_bytes;	/* accounted space in buffer */
> -	int			lv_buf_len;	/* aligned size of buffer */
> -	int			lv_size;	/* size of allocated lv */
> +	int			lv_buf_used;	/* buffer space used so far */
> +	int			lv_alloc_size;	/* size of allocated lv */
>  };
> 
>  #define XFS_LOG_VEC_ORDERED	(-1)
> @@ -64,12 +64,13 @@ xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec,
>  	oph->oh_len = cpu_to_be32(len);
> 
>  	len += sizeof(struct xlog_op_header);
> -	lv->lv_buf_len += len;
> +	lv->lv_buf_used += len;
>  	lv->lv_bytes += len;
>  	vec->i_len = len;
> 
>  	/* Catch buffer overruns */
> -	ASSERT((void *)lv->lv_buf + lv->lv_bytes <= (void *)lv + lv->lv_size);
> +	ASSERT((void *)lv->lv_buf + lv->lv_bytes <=
> +		(void *)lv + lv->lv_alloc_size);
>  }
> 
>  /*
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 81b6780e0afc..985f27a5b4ba 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -275,7 +275,7 @@ xlog_cil_alloc_shadow_bufs(
>  		struct xfs_log_vec *lv;
>  		int	niovecs = 0;
>  		int	nbytes = 0;
> -		int	buf_size;
> +		int	alloc_size;
>  		bool	ordered = false;
> 
>  		/* Skip items which aren't dirty in this transaction. */
> @@ -316,14 +316,14 @@ xlog_cil_alloc_shadow_bufs(
>  		 * that space to ensure we can align it appropriately and not
>  		 * overrun the buffer.
>  		 */
> -		buf_size = nbytes + xlog_cil_iovec_space(niovecs);
> +		alloc_size = nbytes + xlog_cil_iovec_space(niovecs);
> 
>  		/*
>  		 * if we have no shadow buffer, or it is too small, we need to
>  		 * reallocate it.
>  		 */
>  		if (!lip->li_lv_shadow ||
> -		    buf_size > lip->li_lv_shadow->lv_size) {
> +		    alloc_size > lip->li_lv_shadow->lv_alloc_size) {
>  			/*
>  			 * We free and allocate here as a realloc would copy
>  			 * unnecessary data. We don't use kvzalloc() for the
> @@ -332,15 +332,15 @@ xlog_cil_alloc_shadow_bufs(
>  			 * storage.
>  			 */
>  			kvfree(lip->li_lv_shadow);
> -			lv = xlog_kvmalloc(buf_size);
> +			lv = xlog_kvmalloc(alloc_size);
> 
>  			memset(lv, 0, xlog_cil_iovec_space(niovecs));
> 
>  			INIT_LIST_HEAD(&lv->lv_list);
>  			lv->lv_item = lip;
> -			lv->lv_size = buf_size;
> +			lv->lv_alloc_size = alloc_size;
>  			if (ordered)
> -				lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
> +				lv->lv_buf_used = XFS_LOG_VEC_ORDERED;
>  			else
>  				lv->lv_iovecp = (struct xfs_log_iovec *)&lv[1];
>  			lip->li_lv_shadow = lv;
> @@ -348,9 +348,9 @@ xlog_cil_alloc_shadow_bufs(
>  			/* same or smaller, optimise common overwrite case */
>  			lv = lip->li_lv_shadow;
>  			if (ordered)
> -				lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
> +				lv->lv_buf_used = XFS_LOG_VEC_ORDERED;
>  			else
> -				lv->lv_buf_len = 0;
> +				lv->lv_buf_used = 0;
>  			lv->lv_bytes = 0;
>  		}
> 
> @@ -375,7 +375,7 @@ xfs_cil_prepare_item(
>  	int			*diff_len)
>  {
>  	/* Account for the new LV being passed in */
> -	if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
> +	if (lv->lv_buf_used != XFS_LOG_VEC_ORDERED)
>  		*diff_len += lv->lv_bytes;
> 
>  	/*
> @@ -390,7 +390,7 @@ xfs_cil_prepare_item(
>  			lv->lv_item->li_ops->iop_pin(lv->lv_item);
>  		lv->lv_item->li_lv_shadow = NULL;
>  	} else if (lip->li_lv != lv) {
> -		ASSERT(lv->lv_buf_len != XFS_LOG_VEC_ORDERED);
> +		ASSERT(lv->lv_buf_used != XFS_LOG_VEC_ORDERED);
> 
>  		*diff_len -= lip->li_lv->lv_bytes;
>  		lv->lv_item->li_lv_shadow = lip->li_lv;
> @@ -463,12 +463,12 @@ xlog_cil_insert_format_items(
>  		 * The formatting size information is already attached to
>  		 * the shadow lv on the log item.
>  		 */
> -		if (shadow->lv_buf_len == XFS_LOG_VEC_ORDERED) {
> +		if (shadow->lv_buf_used == XFS_LOG_VEC_ORDERED) {
>  			if (!lv) {
>  				lv = shadow;
>  				lv->lv_item = lip;
>  			}
> -			ASSERT(shadow->lv_size == lv->lv_size);
> +			ASSERT(shadow->lv_alloc_size == lv->lv_alloc_size);
>  			xfs_cil_prepare_item(log, lip, lv, diff_len);
>  			continue;
>  		}
> @@ -478,7 +478,7 @@ xlog_cil_insert_format_items(
>  			continue;
> 
>  		/* compare to existing item size */
> -		if (lv && shadow->lv_size <= lv->lv_size) {
> +		if (lv && shadow->lv_alloc_size <= lv->lv_alloc_size) {
>  			/* same or smaller, optimise common overwrite case */
> 
>  			/*
> @@ -491,7 +491,7 @@ xlog_cil_insert_format_items(
>  			lv->lv_niovecs = shadow->lv_niovecs;
> 
>  			/* reset the lv buffer information for new formatting */
> -			lv->lv_buf_len = 0;
> +			lv->lv_buf_used = 0;
>  			lv->lv_bytes = 0;
>  			lv->lv_buf = (char *)lv +
>  					xlog_cil_iovec_space(lv->lv_niovecs);
> @@ -1236,7 +1236,7 @@ xlog_cil_build_lv_chain(
>  		lv->lv_order_id = item->li_order_id;
> 
>  		/* we don't write ordered log vectors */
> -		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
> +		if (lv->lv_buf_used != XFS_LOG_VEC_ORDERED)
>  			*num_bytes += lv->lv_bytes;
>  		*num_iovecs += lv->lv_niovecs;
>  		list_add_tail(&lv->lv_list, &ctx->lv_chain);
> --
> 2.47.2
> 
> 
