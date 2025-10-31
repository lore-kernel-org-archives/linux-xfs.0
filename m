Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CE2221540
	for <linux-xfs@vger.kernel.org>; Fri, 31 Oct 2025 13:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761917931; cv=none; b=HRrC6LT3dleIZp2oHOGXDUewTz8nJSaZoHTrnyLmpiP2A7SRNQB9BWF9qURLq9plgmS5NriK+tIkr7SBOE9JXvoxMYoExZWh8ER2EN496ge/PLR1iSYsiUDULWLla+BdQ9pjUyKjS/y2b2hTU4O5lsip4eUP/xnArvYxSh9zscs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761917931; c=relaxed/simple;
	bh=UO9owQj5HFeDcRxvwB8sr9EVRtUeOdsE0xeK2snWZ5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8dW1wXXWQNGhVXfFlNBjc3plp1LJPXRJsYliD7fWqWe24d6caTz8sZeCFHL01KgFMK1CW9sgaM7OUgKnXIxBfxm+pdbUN3CHHSx5uvd0EhHc+9y9PFLShYYRbKPlhqKq2ufaKKKjN04cF8X1WWe+JpZjpK6WszzaFKSdAoGiXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=id8L2TlF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="id8L2TlF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C0FC4CEF8;
	Fri, 31 Oct 2025 13:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761917930;
	bh=UO9owQj5HFeDcRxvwB8sr9EVRtUeOdsE0xeK2snWZ5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=id8L2TlFU5iwQTrCsg3o7zIOQqUkwlVtkXXC85BZebMgJjxki6kprxT1U/x+eJQUB
	 D81MH7OSJmIhSmrFSiIkS2yKMM9no2WOKQ/+na1n23FrdibUOUz9wtRMtjbkt8LdLT
	 A903+vavfsD+Xc6h4bnOPTlAjAEnZ5iDzX8aqz4PzOEG1cTgiNqLV9TPUsyOtb0FA2
	 qpXQkYWmpncJAdxFIP6Is5MVJ1VIT+tXbKMPBfYlh19/Z2Ik/HTWQzZzq7+RBHKrPR
	 WVJV823Ejl7NicaFpRfrgRjhzhTPGu9ld3o4GBjZVwTvEdNHlAR4gd1tX9t5yRS1dd
	 AHqjfrzA9J2fg==
Date: Fri, 31 Oct 2025 14:38:46 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 2/9] xfs: add a on-disk log header cycle array accessor
Message-ID: <o5dzveclritedtdivt7r6wh5yov3c3aqqq5ebteprlo7x2mxzh@dqysnnqp2jxe>
References: <20251027070610.729960-1-hch@lst.de>
 <rKr1TvH8C_ToMnya7XWYDoF5eKfaiFKgLBUuWld9IHLY-sLlbONURSEilCdODioKv41fZ642Gv82F9mukIsVLQ==@protonmail.internalid>
 <20251027070610.729960-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027070610.729960-3-hch@lst.de>

On Mon, Oct 27, 2025 at 08:05:49AM +0100, Christoph Hellwig wrote:
> Accessing the cycle arrays in the original log record header vs the
> extended header is messy and duplicated in multiple places.
> 
> Add a xlog_cycle_data helper to abstract it out.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_log.c         | 63 ++++++++++------------------------------
>  fs/xfs/xfs_log_priv.h    | 18 ++++++++++++
>  fs/xfs/xfs_log_recover.c | 17 ++---------
>  3 files changed, 37 insertions(+), 61 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index e09e5f71ed8c..a569a4320a3a 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1524,18 +1524,13 @@ xlog_pack_data(
>  	struct xlog_in_core	*iclog,
>  	int			roundoff)
>  {
> -	int			i, j, k;
> -	int			size = iclog->ic_offset + roundoff;
> -	__be32			cycle_lsn;
> -	char			*dp;
> -
> -	cycle_lsn = CYCLE_LSN_DISK(iclog->ic_header.h_lsn);
> +	struct xlog_rec_header	*rhead = &iclog->ic_header;
> +	__be32			cycle_lsn = CYCLE_LSN_DISK(rhead->h_lsn);
> +	char			*dp = iclog->ic_datap;
> +	int			i;
> 
> -	dp = iclog->ic_datap;
> -	for (i = 0; i < BTOBB(size); i++) {
> -		if (i >= XLOG_CYCLE_DATA_SIZE)
> -			break;
> -		iclog->ic_header.h_cycle_data[i] = *(__be32 *)dp;
> +	for (i = 0; i < BTOBB(iclog->ic_offset + roundoff); i++) {
> +		*xlog_cycle_data(rhead, i) = *(__be32 *)dp;
>  		*(__be32 *)dp = cycle_lsn;
>  		dp += BBSIZE;
>  	}
> @@ -1543,14 +1538,6 @@ xlog_pack_data(
>  	if (xfs_has_logv2(log->l_mp)) {
>  		xlog_in_core_2_t *xhdr = iclog->ic_data;
> 
> -		for ( ; i < BTOBB(size); i++) {
> -			j = i / XLOG_CYCLE_DATA_SIZE;
> -			k = i % XLOG_CYCLE_DATA_SIZE;
> -			xhdr[j].hic_xheader.xh_cycle_data[k] = *(__be32 *)dp;
> -			*(__be32 *)dp = cycle_lsn;
> -			dp += BBSIZE;
> -		}
> -
>  		for (i = 1; i < log->l_iclog_heads; i++)
>  			xhdr[i].hic_xheader.xh_cycle = cycle_lsn;
>  	}
> @@ -3322,13 +3309,12 @@ xlog_verify_iclog(
>  	struct xlog_in_core	*iclog,
>  	int			count)
>  {
> -	struct xlog_op_header	*ophead;
> +	struct xlog_rec_header	*rhead = &iclog->ic_header;
>  	xlog_in_core_t		*icptr;
> -	xlog_in_core_2_t	*xhdr;
> -	void			*base_ptr, *ptr, *p;
> +	void			*base_ptr, *ptr;
>  	ptrdiff_t		field_offset;
>  	uint8_t			clientid;
> -	int			len, i, j, k, op_len;
> +	int			len, i, op_len;
>  	int			idx;
> 
>  	/* check validity of iclog pointers */
> @@ -3342,11 +3328,10 @@ xlog_verify_iclog(
>  	spin_unlock(&log->l_icloglock);
> 
>  	/* check log magic numbers */
> -	if (iclog->ic_header.h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM))
> +	if (rhead->h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM))
>  		xfs_emerg(log->l_mp, "%s: invalid magic num", __func__);
> 
> -	base_ptr = ptr = &iclog->ic_header;
> -	p = &iclog->ic_header;
> +	base_ptr = ptr = rhead;
>  	for (ptr += BBSIZE; ptr < base_ptr + count; ptr += BBSIZE) {
>  		if (*(__be32 *)ptr == cpu_to_be32(XLOG_HEADER_MAGIC_NUM))
>  			xfs_emerg(log->l_mp, "%s: unexpected magic num",
> @@ -3354,29 +3339,19 @@ xlog_verify_iclog(
>  	}
> 
>  	/* check fields */
> -	len = be32_to_cpu(iclog->ic_header.h_num_logops);
> +	len = be32_to_cpu(rhead->h_num_logops);
>  	base_ptr = ptr = iclog->ic_datap;
> -	ophead = ptr;
> -	xhdr = iclog->ic_data;
>  	for (i = 0; i < len; i++) {
> -		ophead = ptr;
> +		struct xlog_op_header	*ophead = ptr;
> +		void			*p = &ophead->oh_clientid;
> 
>  		/* clientid is only 1 byte */
> -		p = &ophead->oh_clientid;
>  		field_offset = p - base_ptr;
>  		if (field_offset & 0x1ff) {
>  			clientid = ophead->oh_clientid;
>  		} else {
>  			idx = BTOBBT((void *)&ophead->oh_clientid - iclog->ic_datap);
> -			if (idx >= XLOG_CYCLE_DATA_SIZE) {
> -				j = idx / XLOG_CYCLE_DATA_SIZE;
> -				k = idx % XLOG_CYCLE_DATA_SIZE;
> -				clientid = xlog_get_client_id(
> -					xhdr[j].hic_xheader.xh_cycle_data[k]);
> -			} else {
> -				clientid = xlog_get_client_id(
> -					iclog->ic_header.h_cycle_data[idx]);
> -			}
> +			clientid = xlog_get_client_id(*xlog_cycle_data(rhead, idx));
>  		}
>  		if (clientid != XFS_TRANSACTION && clientid != XFS_LOG) {
>  			xfs_warn(log->l_mp,
> @@ -3392,13 +3367,7 @@ xlog_verify_iclog(
>  			op_len = be32_to_cpu(ophead->oh_len);
>  		} else {
>  			idx = BTOBBT((void *)&ophead->oh_len - iclog->ic_datap);
> -			if (idx >= XLOG_CYCLE_DATA_SIZE) {
> -				j = idx / XLOG_CYCLE_DATA_SIZE;
> -				k = idx % XLOG_CYCLE_DATA_SIZE;
> -				op_len = be32_to_cpu(xhdr[j].hic_xheader.xh_cycle_data[k]);
> -			} else {
> -				op_len = be32_to_cpu(iclog->ic_header.h_cycle_data[idx]);
> -			}
> +			op_len = be32_to_cpu(*xlog_cycle_data(rhead, idx));
>  		}
>  		ptr += sizeof(struct xlog_op_header) + op_len;
>  	}
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 0cfc654d8e87..d2f17691ecca 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -711,4 +711,22 @@ xlog_item_space(
>  	return round_up(nbytes, sizeof(uint64_t));
>  }
> 
> +/*
> + * Cycles over XLOG_CYCLE_DATA_SIZE overflow into the extended header that was
> + * added for v2 logs.  Addressing for the cycles array there is off by one,
> + * because the first batch of cycles is in the original header.
> + */
> +static inline __be32 *xlog_cycle_data(struct xlog_rec_header *rhead, unsigned i)
> +{
> +	if (i >= XLOG_CYCLE_DATA_SIZE) {
> +		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
> +		unsigned	j = i / XLOG_CYCLE_DATA_SIZE;
> +		unsigned	k = i % XLOG_CYCLE_DATA_SIZE;
> +
> +		return &xhdr[j].hic_xheader.xh_cycle_data[k];
> +	}
> +
> +	return &rhead->h_cycle_data[i];
> +}
> +
>  #endif	/* __XFS_LOG_PRIV_H__ */
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index bb2b3f976deb..ef0f6efc4381 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2863,23 +2863,12 @@ xlog_unpack_data(
>  	char			*dp,
>  	struct xlog		*log)
>  {
> -	int			i, j, k;
> +	int			i;
> 
> -	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)) &&
> -		  i < XLOG_CYCLE_DATA_SIZE; i++) {
> -		*(__be32 *)dp = *(__be32 *)&rhead->h_cycle_data[i];
> +	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
> +		*(__be32 *)dp = *xlog_cycle_data(rhead, i);
>  		dp += BBSIZE;
>  	}
> -
> -	if (xfs_has_logv2(log->l_mp)) {
> -		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
> -		for ( ; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
> -			j = i / XLOG_CYCLE_DATA_SIZE;
> -			k = i % XLOG_CYCLE_DATA_SIZE;
> -			*(__be32 *)dp = xhdr[j].hic_xheader.xh_cycle_data[k];
> -			dp += BBSIZE;
> -		}
> -	}
>  }
> 
>  /*
> --
> 2.47.3
> 
