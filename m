Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674BC2E54B0
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 22:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760479929; cv=none; b=Vsimh1fAyWa0hkOuoB8zkiZ7uvGC2yXUYtnOnpj1sGBs3/BsHXrClvpapyE73luSdJImgLoafnhAX2tks3qAp4d1T+3LKTeX9RaKhK8+iYv3FvYFVtovbXDo54VcM+FzBZtsBjaSAj8EEEH7ohlz0eVJoL0G+0mszBANYmeeDdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760479929; c=relaxed/simple;
	bh=VYJOgUTIm5qATiWe4/QRvuFI3QRKu1pcY9/0nf6QHYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AlCtWscC5yveAKV/ICychZZf+Jo3aKRkELm6doGfYwym0p+1IwlPLnk3cQ5whUUm86syW9h+PINkFQS/wzABT5HwcMP1P7V5xSdw0iXFnV8q0+tMUh/ZzNmkAlqlH8dQgjNmr7nEG6W7xaWyU57fM8CmK1OdSKgwU8hVbbOO8Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=te2BvMll; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="te2BvMll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDC1C4CEE7;
	Tue, 14 Oct 2025 22:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760479927;
	bh=VYJOgUTIm5qATiWe4/QRvuFI3QRKu1pcY9/0nf6QHYc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=te2BvMllnT8+lK/bBmBpnjTOlm+RWbFX5nbUUx9fGhhUt+vi2jQKsJWr4aavA2G2g
	 OiuJWQuLbnb5e95TA1UpqNOJCtqTNalJpSI41iC6ldl62Br2xEF/zgR+zB+qqpeIU4
	 KD8zo+QO8OXlqV9dpBfEZhwsJi6ggxK3SH0o2iAS/0ioXpRRTPg0F09FiOEwHqEPAN
	 om6xLEszfMI1TxwZHGGpCBPbWRkyQSU9s+H7x+czybj+W2Q17quo8Di6C1mWuO/uUk
	 IqHSIMnQXHkycDxCxdaExZ8PNOGV65+qmM3claoMAyD3OiGTbLuOSf1cafJixWEPyX
	 yI5G4JO4CATtg==
Date: Tue, 14 Oct 2025 15:12:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: remove l_iclog_heads
Message-ID: <20251014221207.GN6188@frogsfrogsfrogs>
References: <20251013024228.4109032-1-hch@lst.de>
 <20251013024228.4109032-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024228.4109032-9-hch@lst.de>

On Mon, Oct 13, 2025 at 11:42:12AM +0900, Christoph Hellwig wrote:
> l_iclog_heads is only used in one place and can be trivially derived
> from l_iclog_hsize by a single shift operation.  Remove it, and switch
> the initialization of l_iclog_hsize to use struct_size so that it is
> directly derived from the on-disk format definition.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c      | 11 ++++++-----
>  fs/xfs/xfs_log_priv.h |  1 -
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 8b3b79699596..47a8e74c8c5c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1279,11 +1279,12 @@ xlog_get_iclog_buffer_size(
>  	log->l_iclog_size = mp->m_logbsize;
>  
>  	/*
> -	 * # headers = size / 32k - one header holds cycles from 32k of data.
> +	 * Combined size of the log record headers.  The first 32k cycles
> +	 * are stored directly in the xlog_rec_header, the rest in the
> +	 * variable number of xlog_rec_ext_headers at its end.
>  	 */
> -	log->l_iclog_heads =
> -		DIV_ROUND_UP(mp->m_logbsize, XLOG_HEADER_CYCLE_SIZE);
> -	log->l_iclog_hsize = log->l_iclog_heads << BBSHIFT;
> +	log->l_iclog_hsize = struct_size(log->l_iclog->ic_header, h_ext,
> +		DIV_ROUND_UP(mp->m_logbsize, XLOG_HEADER_CYCLE_SIZE) - 1);

Hrm.  offsetof(xlog_rec_header::h_ext) == 512 and
sizeof(xlog_rec_ext_header) == 512, so I think this computation still
yields the same results.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  }
>  
>  void
> @@ -1526,7 +1527,7 @@ xlog_pack_data(
>  		dp += BBSIZE;
>  	}
>  
> -	for (i = 0; i < log->l_iclog_heads - 1; i++)
> +	for (i = 0; i < (log->l_iclog_hsize >> BBSHIFT) - 1; i++)
>  		rhead->h_ext[i].xh_cycle = cycle_lsn;
>  }
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index ac98ac71152d..17733ba7f251 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -406,7 +406,6 @@ struct xlog {
>  	struct list_head	*l_buf_cancel_table;
>  	struct list_head	r_dfops;	/* recovered log intent items */
>  	int			l_iclog_hsize;  /* size of iclog header */
> -	int			l_iclog_heads;  /* # of iclog header sectors */
>  	uint			l_sectBBsize;   /* sector size in BBs (2^n) */
>  	int			l_iclog_size;	/* size of log in bytes */
>  	int			l_iclog_bufs;	/* number of iclog buffers */
> -- 
> 2.47.3
> 
> 
