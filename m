Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13F81684B0
	for <linux-xfs@vger.kernel.org>; Sat,  1 Nov 2025 01:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761959788; cv=none; b=VLCK6DS/jyujWZtM1XaDUn+3CX420noBfdrXcXPvQZi467oglPXU5kAD0m/40W/oC2CqFiI8EGjelkkRX2ZNzU/wi/mpL2wVnhqlKjug64Ky7Um7amxnS9gfY9ato7X/xkkCxRb8chPmbG1886AdkXebHg46A7tQwF6AtqibdfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761959788; c=relaxed/simple;
	bh=SpjCTo4V3cwRFlR6/uqMvdO42nijz4yXRa+5t6nV6iA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gHFb1x831d0ACLwmSQQCunMB7n5LPx0aj6oo7jRJ26MzhLCrPylyRx2HK19x1ZyrrviW4mIi4hmhWs8/b8HB3kZdQWoXqmJAUmE4AVshCOFXa/rXInhxe/Jgb2avzUn2UITPehNW9bZjbEKOID2+AFgnXytVXM3TJFfC2SuFZYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=btE9dMvA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="btE9dMvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5632DC4CEE7;
	Sat,  1 Nov 2025 01:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761959788;
	bh=SpjCTo4V3cwRFlR6/uqMvdO42nijz4yXRa+5t6nV6iA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=btE9dMvAlQah+nWJPN5C38ADchGKDSpyx6RfScs3EOizuXRSZaFlOVbKefSfBdTJj
	 aZVIsCm4ndXhSex5DHnnKF6zMXrxp0+r94JfJiYyzjOCjSWB/2jsfB7Y1r/xfs/zhO
	 JJDI8A+Na4T2LLABJJw9HJ1UzvJwggTiHy0/OoewOO/IMBUrY96fQck6hJXYJTEiAw
	 lzOoMXzSuliD1i6RD/fEit2ySue5A/FD1uPuwSylt1Ce+Z+Ym1u8lq+uZ9QTbptxu+
	 8SFIVh7wyYjJapSEbRiD13QZzSQ+uu0uTdW9bx7ms2Q8ppraUa7HuyWXdNBxmL5b49
	 IwTTtkwK0Z0ng==
Date: Fri, 31 Oct 2025 18:16:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs: move struct xfs_log_vec to xfs_log_priv.h
Message-ID: <20251101011627.GU3356773@frogsfrogsfrogs>
References: <20251030144946.1372887-1-hch@lst.de>
 <20251030144946.1372887-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030144946.1372887-6-hch@lst.de>

On Thu, Oct 30, 2025 at 03:49:15PM +0100, Christoph Hellwig wrote:
> The log_vec is a private type for the log/CIL code and should not be
> exposed to anything else.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.h      | 12 ------------
>  fs/xfs/xfs_log_priv.h | 12 ++++++++++++
>  2 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index c4930e925fed..0f23812b0b31 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -9,18 +9,6 @@
>  struct xlog_format_buf;
>  struct xfs_cil_ctx;
>  
> -struct xfs_log_vec {
> -	struct list_head	lv_list;	/* CIL lv chain ptrs */
> -	uint32_t		lv_order_id;	/* chain ordering info */
> -	int			lv_niovecs;	/* number of iovecs in lv */
> -	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
> -	struct xfs_log_item	*lv_item;	/* owner */
> -	char			*lv_buf;	/* formatted buffer */
> -	int			lv_bytes;	/* accounted space in buffer */
> -	int			lv_buf_used;	/* buffer space used so far */
> -	int			lv_alloc_size;	/* size of allocated lv */
> -};
> -
>  /* Region types for iovec's i_type */
>  #define XLOG_REG_TYPE_BFORMAT		1
>  #define XLOG_REG_TYPE_BCHUNK		2
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index b7b3f61aa2ae..cf1e4ce61a8c 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -19,6 +19,18 @@ struct xfs_log_iovec {
>  	uint			i_type;	/* type of region */
>  };
>  
> +struct xfs_log_vec {
> +	struct list_head	lv_list;	/* CIL lv chain ptrs */
> +	uint32_t		lv_order_id;	/* chain ordering info */
> +	int			lv_niovecs;	/* number of iovecs in lv */
> +	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
> +	struct xfs_log_item	*lv_item;	/* owner */
> +	char			*lv_buf;	/* formatted buffer */
> +	int			lv_bytes;	/* accounted space in buffer */
> +	int			lv_buf_used;	/* buffer space used so far */
> +	int			lv_alloc_size;	/* size of allocated lv */
> +};
> +
>  /*
>   * get client id from packed copy.
>   *
> -- 
> 2.47.3
> 
> 
