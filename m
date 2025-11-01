Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3048C1684B0
	for <linux-xfs@vger.kernel.org>; Sat,  1 Nov 2025 01:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761959766; cv=none; b=aevRjreM4p8vvPT35/T3660sraWatoINVGqcvSzvL0uJjKFPFWM+ptc+6Syj5rApJDaZRRFSxs4lwp3N8/jYQdhEbuMuUzl70WC6vWmqJSeY2WopTDVqxzA+UHhg7/H1pAfoRxEIx1B9PiX4yaMS12pjenf2gknQVydKfbt0UtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761959766; c=relaxed/simple;
	bh=lMhqYohsL0CstLO66OYFKaK+HdmnttCzsSE9AWR8bIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c4agY+23GStxmKmdASWPA6EPAVWu5li44Bjef3NuZg31fe5xIlA/gdXV1EUbGJVb4CTfUIuaNtwLqglE1kkYR/rY3CbtByvwCe59cB1ScoxGbEAoMYx/6EtPoCv7u2vzJq/ZQ1qxlUKMhc/c7kCekfeprziEbwVY46eCMSKCxVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VQIXdP4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VQIXdP4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A61C4CEE7;
	Sat,  1 Nov 2025 01:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761959765;
	bh=lMhqYohsL0CstLO66OYFKaK+HdmnttCzsSE9AWR8bIg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VQIXdP4b3kJEQexUafFNQRjpBm6tYqSUgDAwLHNuU7j5+bnE6qZfnnu5pTImhkWsn
	 gYpFBAGb/NX0sTiA5bPXOyOi0rz1cpt9XV+dHYv6y/1NYleDl3OEN974raGnQPQdU7
	 rQRNHxzm1SpIpl1Me+09vLvZnx/dx3+YkIj0YzuOozAFFGSLImOhbGXeH7fmVenYh+
	 gm11xYmtzs1MguHWN+SUcKnKjRhAW5Xww89osZL70iAlouxVR/w++eyrmuYK9r+Dgh
	 LsvUbCYfF8e/LgaUV1UdwTbtVH9GJFjqcY8Hnw0VVumAKLCnhd7QSr8a1Mz5HNbPuh
	 ol6D4krbVfXSA==
Date: Fri, 31 Oct 2025 18:16:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: move struct xfs_log_iovec to xfs_log_priv.h
Message-ID: <20251101011605.GT3356773@frogsfrogsfrogs>
References: <20251030144946.1372887-1-hch@lst.de>
 <20251030144946.1372887-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030144946.1372887-5-hch@lst.de>

On Thu, Oct 30, 2025 at 03:49:14PM +0100, Christoph Hellwig wrote:
> This structure is now only used by the core logging and CIL code.
> 
> Also remove the unused typedef.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

wooo, -typedef
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_log_format.h | 7 -------
>  fs/xfs/xfs_log_priv.h          | 6 ++++++
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 908e7060428c..3f5a24dda907 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -184,13 +184,6 @@ struct xlog_rec_header {
>  #define XLOG_REC_SIZE_OTHER	offsetofend(struct xlog_rec_header, h_size)
>  #endif /* __i386__ */
>  
> -/* not an on-disk structure, but needed by log recovery in userspace */
> -struct xfs_log_iovec {
> -	void		*i_addr;	/* beginning address of region */
> -	int		i_len;		/* length in bytes of region */
> -	uint		i_type;		/* type of region */
> -};
> -
>  /*
>   * Transaction Header definitions.
>   *
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index d2410e78b7f5..b7b3f61aa2ae 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -13,6 +13,12 @@ struct xlog;
>  struct xlog_ticket;
>  struct xfs_mount;
>  
> +struct xfs_log_iovec {
> +	void			*i_addr;/* beginning address of region */
> +	int			i_len;	/* length in bytes of region */
> +	uint			i_type;	/* type of region */
> +};
> +
>  /*
>   * get client id from packed copy.
>   *
> -- 
> 2.47.3
> 
> 
