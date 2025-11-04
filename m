Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9712EACE9
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 23:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762299972; cv=none; b=Ji/bfQJcCmbbXc0lm+jbFyBuhBTEypWh5g9xqvUMxbr/hbCN0zNQ3+53UWFWeAm/pAqkBolhBTrWbqS6eWqACeAKSvELZjt5g/s2/LXLjI7ygOCDwtRzD1wUe+KH1XMTCpfSsNBHmusOt5vjEeWvOerdwgH8jlBrL+zllA8KkSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762299972; c=relaxed/simple;
	bh=xhDWivY2kWgeOSbbLlH5rjwQrw5qh1eOVjIUiEJUsYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=teJDknwjkyBDk3Ic8lkSE+LTRPXl7YNumcNxtCboHElfMG/mOBkCgd93k252YXUbtuof45c5tD8mWua+NVXEBGQxtpR9GaFWp0PppEyGSzOTiwsEkQ/FqlYfhIvg7x6EJUBz1ANcsITowdJtcEInlnycHRyalljVnxS9/Cmqyrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZESiIYCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZESiIYCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F92C4CEF7;
	Tue,  4 Nov 2025 23:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762299971;
	bh=xhDWivY2kWgeOSbbLlH5rjwQrw5qh1eOVjIUiEJUsYQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZESiIYCcCi2MNec3/SLFML8/zx3q2Hg6lwm26zw/Uv0RmPEB80F6oTuC5dzJTMbyD
	 kr8y1BBqWuW136xqM8eEC/5fSfIa+LEATsGq8fjvJXtlWKViUPe5qCYPaTyFmt1Qor
	 dgso/dhYPxPj1aDCN9HNY14N9W97N4fzVf/87fWa0Ikin0Bx9UvLInYPfFKP3lWMAs
	 +Zqqq6x/sBdPsIvvQ/vjFUmVJXKxKZ7rH/ChmpieLiSNp7kGZzhQgvRLF6rEObRs8I
	 JOxtoQl7cNqaQCu9aa2/0eQTMLGtwrxALoEPPCnSJjmZh3eaBLAto0kq68cf/Sz9P1
	 tDzP1mex9NsRA==
Date: Tue, 4 Nov 2025 15:46:11 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs: factor out a xlog_write_space_advance helper
Message-ID: <20251104234611.GS196370@frogsfrogsfrogs>
References: <20251030144946.1372887-1-hch@lst.de>
 <20251030144946.1372887-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030144946.1372887-11-hch@lst.de>

On Thu, Oct 30, 2025 at 03:49:20PM +0100, Christoph Hellwig wrote:
> Add a new xlog_write_space_advance that returns the current place in the
> iclog that data is written to, and advances the various counters by the
> amount taken from xlog_write_iovec, and also use it xlog_write_partial,
> which open codes the counter adjustments, but misses the asserts.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks decent,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 32 ++++++++++++++++++++------------
>  1 file changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 8b8fdef6414d..511756429336 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1883,21 +1883,31 @@ static inline uint32_t xlog_write_space_left(struct xlog_write_data *data)
>  	return data->iclog->ic_size - data->log_offset;
>  }
>  
> +static void *
> +xlog_write_space_advance(
> +	struct xlog_write_data	*data,
> +	unsigned int		len)
> +{
> +	void			*p = data->iclog->ic_datap + data->log_offset;
> +
> +	ASSERT(xlog_write_space_left(data) >= len);
> +	ASSERT(data->log_offset % sizeof(int32_t) == 0);
> +	ASSERT(len % sizeof(int32_t) == 0);
> +
> +	data->data_cnt += len;
> +	data->log_offset += len;
> +	data->bytes_left -= len;
> +	return p;
> +}
> +
>  static inline void
>  xlog_write_iovec(
>  	struct xlog_write_data	*data,
>  	void			*buf,
>  	uint32_t		buf_len)
>  {
> -	ASSERT(xlog_write_space_left(data) >= buf_len);
> -	ASSERT(data->log_offset % sizeof(int32_t) == 0);
> -	ASSERT(buf_len % sizeof(int32_t) == 0);
> -
> -	memcpy(data->iclog->ic_datap + data->log_offset, buf, buf_len);
> -	data->log_offset += buf_len;
> -	data->bytes_left -= buf_len;
> +	memcpy(xlog_write_space_advance(data, buf_len), buf, buf_len);
>  	data->record_cnt++;
> -	data->data_cnt += buf_len;
>  }
>  
>  /*
> @@ -2038,7 +2048,8 @@ xlog_write_partial(
>  			if (error)
>  				return error;
>  
> -			ophdr = data->iclog->ic_datap + data->log_offset;
> +			ophdr = xlog_write_space_advance(data,
> +					sizeof(struct xlog_op_header));
>  			ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
>  			ophdr->oh_clientid = XFS_TRANSACTION;
>  			ophdr->oh_res2 = 0;
> @@ -2046,9 +2057,6 @@ xlog_write_partial(
>  
>  			data->ticket->t_curr_res -=
>  				sizeof(struct xlog_op_header);
> -			data->log_offset += sizeof(struct xlog_op_header);
> -			data->data_cnt += sizeof(struct xlog_op_header);
> -			data->bytes_left -= sizeof(struct xlog_op_header);
>  
>  			/*
>  			 * If rlen fits in the iclog, then end the region
> -- 
> 2.47.3
> 
> 
