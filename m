Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F30B34D3A5
	for <linux-xfs@vger.kernel.org>; Sat,  1 Nov 2025 03:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761967631; cv=none; b=oKsr7WT15W+7qS32dl++ICWuA6MxNedEVzoiTwK8s1JOnTXfpq5R6XBpsXqEtu/YO+EJsIClc6EnDFf3NXgoPvEINEq7MgmDZ+QvCApCBeZ+C7IA885Xz1SdxZNKxITFrKLnynQ7JpP1Z6RrBHk3XSYZuWBFhkhXH4I46Vo8h2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761967631; c=relaxed/simple;
	bh=CNyg9iluovGqdXR9OU3/p2AmSy0ChXLr117hciMhcJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QoDyzX+3YaJHSOE3tcvGArfNu+24m28XfJKPMlP4ugtNknMFCUV6P5uf3iFjfyqYRf1fssTgvyCnWyRK0a8Nwb9GOCnkLnbJfG7Nv0X850mLkIvjcRPbcEUd+r4UWL9keNkI/ChBIWcMfQYJHUQ0FsYq8RP7dh0VLOtJm74GHYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fza84BqQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fza84BqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98820C4CEF7;
	Sat,  1 Nov 2025 03:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761967630;
	bh=CNyg9iluovGqdXR9OU3/p2AmSy0ChXLr117hciMhcJA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fza84BqQqw7gRMtuqc/OkGkj6vDLeHpYZ9niZRmVT6y8zcpbQukMonhieNhEFl2nW
	 8A7XdTYOCacRcW7djbJHwUz+p088Hg1bmol/NCtPpggEDorcqzQmGt21g17oo3/z1F
	 oNajaKqyFBPyVG+30+XalSYEGWVF76v8g7HQwZ5e7faCV10AhYABcby+wNGZL0ulIg
	 zULcjdJyoClKY07l/TBDAo23bxSItJuwQe+DkYjFmxOKo1nTwPuCcg+kneX1xlG1wA
	 QZE0tDb4xVt+Jh2dE2DEAwcA+LwdZZOkaEEm/U7mQwhFhKpOvn33yRebMxjfLFbEeI
	 hZvA4AVeWdgjA==
Date: Fri, 31 Oct 2025 20:27:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/10] xfs: add a xlog_write_space_left helper
Message-ID: <20251101032710.GW3356773@frogsfrogsfrogs>
References: <20251030144946.1372887-1-hch@lst.de>
 <20251030144946.1372887-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030144946.1372887-9-hch@lst.de>

On Thu, Oct 30, 2025 at 03:49:18PM +0100, Christoph Hellwig wrote:
> Various places check how much space is left in the current iclog,
> add a helper for that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 2b1744af8a67..7c751665bc44 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1878,13 +1878,18 @@ xlog_print_trans(
>  	}
>  }
>  
> +static inline uint32_t xlog_write_space_left(struct xlog_write_data *data)
> +{
> +	return data->iclog->ic_size - data->log_offset;
> +}
> +
>  static inline void
>  xlog_write_iovec(
>  	struct xlog_write_data	*data,
>  	void			*buf,
>  	uint32_t		buf_len)
>  {
> -	ASSERT(data->log_offset < data->iclog->ic_log->l_iclog_size);
> +	ASSERT(xlog_write_space_left(data) > 0);
>  	ASSERT(data->log_offset % sizeof(int32_t) == 0);
>  	ASSERT(buf_len % sizeof(int32_t) == 0);
>  
> @@ -1906,7 +1911,7 @@ xlog_write_full(
>  {
>  	int			index;
>  
> -	ASSERT(data->log_offset + data->bytes_left <= data->iclog->ic_size ||
> +	ASSERT(data->bytes_left <= xlog_write_space_left(data) ||
>  		data->iclog->ic_state == XLOG_STATE_WANT_SYNC);
>  
>  	/*
> @@ -1978,7 +1983,7 @@ xlog_write_partial(
>  		 * Hence if there isn't space for region data after the
>  		 * opheader, then we need to start afresh with a new iclog.
>  		 */
> -		if (data->iclog->ic_size - data->log_offset <=
> +		if (xlog_write_space_left(data) <=
>  					sizeof(struct xlog_op_header)) {
>  			error = xlog_write_get_more_iclog_space(data);
>  			if (error)
> @@ -1986,8 +1991,7 @@ xlog_write_partial(
>  		}
>  
>  		ophdr = reg->i_addr;
> -		rlen = min_t(uint32_t, reg->i_len,
> -			data->iclog->ic_size - data->log_offset);
> +		rlen = min_t(uint32_t, reg->i_len, xlog_write_space_left(data));
>  
>  		ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
>  		ophdr->oh_len = cpu_to_be32(rlen - sizeof(struct xlog_op_header));
> @@ -2052,13 +2056,13 @@ xlog_write_partial(
>  			 */
>  			reg_offset += rlen;
>  			rlen = reg->i_len - reg_offset;
> -			if (rlen <= data->iclog->ic_size - data->log_offset)
> +			if (rlen <= xlog_write_space_left(data))
>  				ophdr->oh_flags |= XLOG_END_TRANS;
>  			else
>  				ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
>  
>  			rlen = min_t(uint32_t, rlen,
> -				data->iclog->ic_size - data->log_offset);
> +					xlog_write_space_left(data));
>  			ophdr->oh_len = cpu_to_be32(rlen);
>  
>  			xlog_write_iovec(data, reg->i_addr + reg_offset, rlen);
> @@ -2135,7 +2139,7 @@ xlog_write(
>  	if (error)
>  		return error;
>  
> -	ASSERT(data.log_offset <= data.iclog->ic_size - 1);
> +	ASSERT(xlog_write_space_left(&data) > 0);
>  
>  	/*
>  	 * If we have a context pointer, pass it the first iclog we are
> @@ -2151,7 +2155,7 @@ xlog_write(
>  		 * the partial copy loop which can handle this case.
>  		 */
>  		if (lv->lv_niovecs &&
> -		    lv->lv_bytes > data.iclog->ic_size - data.log_offset) {
> +		    lv->lv_bytes > xlog_write_space_left(&data)) {
>  			error = xlog_write_partial(lv, &data);
>  			if (error) {
>  				/*
> -- 
> 2.47.3
> 
> 
