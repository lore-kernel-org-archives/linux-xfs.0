Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5B8270553
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 21:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760477238; cv=none; b=k+d/zQ9/cwEvH+FZ2NdTW7qSLtefckWVTYAXV4wxV3WbTCh1ut51YUIV+QvGuW6BGqmPwCmT1j3JD/vvISmaOPE8JC3lIpmlXzmGdkZiVZ/kPHI3192Zwhs4Ktj3A25dwt1cvDmQX/efaWV8JY+IFwZbyy7vma180S29f7aZJww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760477238; c=relaxed/simple;
	bh=xV4l4pjOp2NuDSkAueqnmkv1Ipjwa+LUkNX4b9CPlxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z8vTvUfILcMCeHDbyIpEJcAoCvVM1xnRlJPraHMLcPudHDWnuvOsdu3hSi1Yd+WRxDq9ZV/QOvwXng7SmbIWqiPEqbt794iXCrvqe0DbIfh+tiVDUHYcppA9mVtfuSLYPdBHsacqBTFvNDLxp8i4p1mWnJWCRecVk10LJ/AzmfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jgLZdDtf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jgLZdDtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5101AC4CEE7;
	Tue, 14 Oct 2025 21:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760477238;
	bh=xV4l4pjOp2NuDSkAueqnmkv1Ipjwa+LUkNX4b9CPlxY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jgLZdDtfKWpoSKsBJf3bTm+tGqLPXgAdn3QHD+f9jmJKAzOLNBPHa3CKog6zpOiML
	 zMSiL+ehIbxFD8J2K+FJcfa5OvFzlaXuMRcXFudq6os2rAPpEDtumX2tLkbw7G/OaI
	 yDacqDnhnHojRIYQjVPmkX8ltYAqzVVbF8wJjeN76m6UVTdpOCvoH0+MwlPlWnwQsb
	 ecGAlG6kbyOLMs2RFZqMtIBLBz3Tbt4TVvEPH1VhdF3Q4FIBHlOCnxMN2lVI9ZJAKh
	 XbqLbpxwj6uR/UXbfVzmzQ+pcWbr2dGykTw5smfpCgeimAn3mHbsMYI5hMRqPUHbPJ
	 /dvHGnUQVP4Nw==
Date: Tue, 14 Oct 2025 14:27:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: add a on-disk log header cycle array accessor
Message-ID: <20251014212717.GH6188@frogsfrogsfrogs>
References: <20251013024228.4109032-1-hch@lst.de>
 <20251013024228.4109032-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024228.4109032-3-hch@lst.de>

On Mon, Oct 13, 2025 at 11:42:06AM +0900, Christoph Hellwig wrote:
> Accessing the cycle arrays in the original log record header vs the
> extended header is messy and duplicated in multiple places.
> 
> Add a xlog_cycle_data helper to abstract it out.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
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

Just to orient myself -- this is the code that stamps (swazzled) LSN
cycle numbers into the log headers, right?

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

Does this need a xfs_has_logv2() check?  The old callsites all seem to
have them.

What should happen if i >= XLOG_CYCLE_DATA_SIZE && !logv2 ?  Should
this helper return NULL so that callers can return EFSCORRUPTED or
something like that?

--D

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
> 
