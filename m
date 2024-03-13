Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D013210A35
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 07:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710315444; cv=none; b=u4b6RncugoalwIQumg3n5F+bCye0FRQomlWAPSDPNsKLM+q2jVMV8L9iFEbZS9C7BiS5jE3OjIxnuRzeahGmcZm4qvxIGjRYWgWHbYmnyRI3Sz6xJfjc8eMa6qhtOFuLM4uU47n8tfY+3XcAO53O8T57TxmBWTNnUc8YgyfBgaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710315444; c=relaxed/simple;
	bh=A73/2/q3jU5qXhxdYyhd2BLwqsO3nK8ORWRv5/PFRRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fYSO9yPJDt7M64ls98GPYRdoKydyp0i9oM0uvxFU5DGetofVnb3ZihOg2HduJsQNvTX4rEvhnfqwR8k0DofRUh+33MjdXgGXk1L8LlO+MKnyK/fO3Jdm6cmZGR1T8E+m3NAJGybJ4PWgOHAk0ZVLhKxjJONvQWGgz85lMQ2X62g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N6NmlL9R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N6NmlL9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B835FC433F1;
	Wed, 13 Mar 2024 07:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710315444;
	bh=A73/2/q3jU5qXhxdYyhd2BLwqsO3nK8ORWRv5/PFRRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N6NmlL9RZHpNh2ZZxs0B1BSa1KIVV6g53lYUrnhDUhEMpwBQ69g6kXD3inRImkxTV
	 yMacVceKoJIt2mhqxwIWYD04K0XTvn1pRYpbbY++Y2szEfBOif1SXYHKrJX13N6aKG
	 dqFuQCv5rNGKSEkxcefxldy5PqfKoXhDurZeZ6yK4KxXi4Hnd6s4CJpniCqCnnITNV
	 yvejfk/fwQ+bclPthQ5vtYwClC04yCk/8E1Y3cf90V8cg6VhfwX3XmqD8uUw4joq6T
	 GpVXKNSskz59pOlMHk5I6K1JNYT1YGE3yLcaBE2iB2HW65fMCW2xEVeCMehrJrNGaK
	 H1Spz2sVslitQ==
Date: Wed, 13 Mar 2024 08:37:20 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/26] repair: refactor the BLKMAP_NEXTS_MAX check
Message-ID: <nhtnskhiqnpmf64fxyphlfqqs2kkg3amaadie7amjmsalvyyuq@ygrsdii6vdl6>
References: <20240215065424.2193735-1-hch@lst.de>
 <AUl5IUN9heHDAy28s3Z7vBxxP-X8DI45Un6AvNrtDwh_4xFsVUKlPxpFtV5Go_nupyXhEbmwa21f1AA1jh2EMg==@protonmail.internalid>
 <20240215065424.2193735-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240215065424.2193735-4-hch@lst.de>

On Thu, Feb 15, 2024 at 07:54:01AM +0100, Christoph Hellwig wrote:
> Check the 32-bit limits using sizeof instead of cpp ifdefs so that we
> can get rid of BITS_PER_LONG.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  repair/bmap.c | 23 +++++++++++++++--------
>  repair/bmap.h | 13 -------------
>  2 files changed, 15 insertions(+), 21 deletions(-)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> diff --git a/repair/bmap.c b/repair/bmap.c
> index cd1a8b07b..7e32fff33 100644
> --- a/repair/bmap.c
> +++ b/repair/bmap.c
> @@ -22,6 +22,15 @@
>  pthread_key_t	dblkmap_key;
>  pthread_key_t	ablkmap_key;
> 
> +/*
> + * For 32 bit platforms, we are limited to extent arrays of 2^31 bytes, which
> + * limits the number of extents in an inode we can check. If we don't limit the
> + * valid range, we can overflow the BLKMAP_SIZE() calculation and allocate less
> + * memory than we think we needed, and hence walk off the end of the array and
> + * corrupt memory.
> + */
> +#define BLKMAP_NEXTS32_MAX	((INT_MAX / sizeof(bmap_ext_t)) - 1)
> +
>  blkmap_t *
>  blkmap_alloc(
>  	xfs_extnum_t	nex,
> @@ -35,8 +44,7 @@ blkmap_alloc(
>  	if (nex < 1)
>  		nex = 1;
> 
> -#if (BITS_PER_LONG == 32)	/* on 64-bit platforms this is never true */
> -	if (nex > BLKMAP_NEXTS_MAX) {
> +	if (sizeof(long) == 4 && nex > BLKMAP_NEXTS32_MAX) {
>  		do_warn(
>  	_("Number of extents requested in blkmap_alloc (%llu) overflows 32 bits.\n"
>  	  "If this is not a corruption, then you will need a 64 bit system\n"
> @@ -44,7 +52,6 @@ blkmap_alloc(
>  			(unsigned long long)nex);
>  		return NULL;
>  	}
> -#endif
> 
>  	key = whichfork ? ablkmap_key : dblkmap_key;
>  	blkmap = pthread_getspecific(key);
> @@ -278,20 +285,20 @@ blkmap_grow(
>  		ASSERT(pthread_getspecific(key) == blkmap);
>  	}
> 
> -#if (BITS_PER_LONG == 32)	/* on 64-bit platforms this is never true */
> -	if (new_naexts > BLKMAP_NEXTS_MAX) {
> +	if (sizeof(long) == 4 && new_naexts > BLKMAP_NEXTS32_MAX) {
>  		do_error(
>  	_("Number of extents requested in blkmap_grow (%d) overflows 32 bits.\n"
>  	  "You need a 64 bit system to repair this filesystem.\n"),
>  			new_naexts);
>  		return NULL;
>  	}
> -#endif
> +
>  	if (new_naexts <= 0) {
>  		do_error(
>  	_("Number of extents requested in blkmap_grow (%d) overflowed the\n"
> -	  "maximum number of supported extents (%d).\n"),
> -			new_naexts, BLKMAP_NEXTS_MAX);
> +	  "maximum number of supported extents (%ld).\n"),
> +			new_naexts,
> +			sizeof(long) == 4 ? BLKMAP_NEXTS32_MAX : INT_MAX);
>  		return NULL;
>  	}
> 
> diff --git a/repair/bmap.h b/repair/bmap.h
> index 4b588df8c..df9602b31 100644
> --- a/repair/bmap.h
> +++ b/repair/bmap.h
> @@ -28,19 +28,6 @@ typedef	struct blkmap {
>  #define	BLKMAP_SIZE(n)	\
>  	(offsetof(blkmap_t, exts) + (sizeof(bmap_ext_t) * (n)))
> 
> -/*
> - * For 32 bit platforms, we are limited to extent arrays of 2^31 bytes, which
> - * limits the number of extents in an inode we can check. If we don't limit the
> - * valid range, we can overflow the BLKMAP_SIZE() calculation and allocate less
> - * memory than we think we needed, and hence walk off the end of the array and
> - * corrupt memory.
> - */
> -#if BITS_PER_LONG == 32
> -#define BLKMAP_NEXTS_MAX	((INT_MAX / sizeof(bmap_ext_t)) - 1)
> -#else
> -#define BLKMAP_NEXTS_MAX	INT_MAX
> -#endif
> -
>  extern pthread_key_t dblkmap_key;
>  extern pthread_key_t ablkmap_key;
> 
> --
> 2.39.2
> 
