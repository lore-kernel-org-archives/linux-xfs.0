Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472FD25EFBB
	for <linux-xfs@vger.kernel.org>; Fri, 31 Oct 2025 14:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761920158; cv=none; b=fBfWs4El2icMdsO2nbxjo7uHfHUk4YNXl+lu1OxKl905bxGABCAENV88YxecK1KLdGCcdzaFDHPMKGmtDJ3y07hJoxsNyTEwpj9YB5wiwH1m25M2D3DkZaj0V5s+Lagqwo71APAwOuTUeVis/KNSiQ9J5jxJyNpD5zhlM1ylFmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761920158; c=relaxed/simple;
	bh=Lcqh0dqddtauNle369ugQEZH7dnwRH0Z6QBY0r4NTeI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ULWestcPOPsQQuiyu1bSOzvMQxMhSrsAV2vqpXLCntTADdABGFqqbuw8ug8sMiT2i30UJeLvlqUjuqL1ZwN48gq5ZSQqLN6peKDPBSCmk3xPZHVno3f9pNuUjrQ1ZiirZEYtoIRJnWZhnwh+pFWMYcPe32wikjcAxkSNcr5ROsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U+DZugYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U+DZugYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF995C4CEE7;
	Fri, 31 Oct 2025 14:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761920157;
	bh=Lcqh0dqddtauNle369ugQEZH7dnwRH0Z6QBY0r4NTeI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U+DZugYWjGkkxkXNpns7EJTvk8sBamTj/+UN3l82ld4Tv/X/FZzMr5ZQjk40ZkvKD
	 HapUwDQmlqovMNXGoXNpiqUUol5x5vASxMS3jfjF1Vy5ITfPb2Es2PHwv35kSt7YJW
	 G+QaTRqMt0gZD0XAF7GMNhKfxim5ZavGQzGqq2xGc/reAbn8JeuHdTbDwySbXZ/Vft
	 V6oiZs+RW8fJhA9bmmMY3MVFsEVnioKdlw/KQKyYe9QsOWUqga3csQlt2PMT1U2p4p
	 0ZWFNMv2VYBLYtdMRCgQoPLUa7FQZ00xJkCiHZLJxu4c0iP5XW1qldAfKPCkRswnLY
	 W95x3daZnToxw==
Date: Fri, 31 Oct 2025 15:15:53 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 8/9] xfs: remove l_iclog_heads
Message-ID: <bvwghphau2lj2en67eq37ohjhmr4y54m2d44dow4bx2g6y6ogw@fhqkiug274gw>
References: <20251027070610.729960-1-hch@lst.de>
 <1Q5eU4tly0eluT2cLwoAdoupjBi5iceq4Y_Tz4Vwo5WeFX7ivsJfxAgrtfhDD8V5rom6ZS98ziA8YRxYMUJf4Q==@protonmail.internalid>
 <20251027070610.729960-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027070610.729960-9-hch@lst.de>

On Mon, Oct 27, 2025 at 08:05:55AM +0100, Christoph Hellwig wrote:
> l_iclog_heads is only used in one place and can be trivially derived
> from l_iclog_hsize by a single shift operation.  Remove it, and switch
> the initialization of l_iclog_hsize to use struct_size so that it is
> directly derived from the on-disk format definition.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

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
