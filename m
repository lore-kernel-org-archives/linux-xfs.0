Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9B25C5FE
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 10:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706006315; cv=none; b=Ybdbae2Rg+9gynnf4mH+a/5F/a8z0IGMCwU0qoAoM4HooFRKAv2h0GnR7nJ4qx4QIjFffhxZKcMsJ/vrI2TwgOlN/zg1mJzDfiz5K+OOA7f7lBbTN48wib+kncIB8zugGS0LhMb+4SqJMyNIUS1pH1xTtlz6r7JlItoSKDIaCMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706006315; c=relaxed/simple;
	bh=lVsBKbDDJF3ceXm0FPt8Ck+0PSteaxTqnfYYJdW9a6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iqlt7Y3uNd5MONHidV/GJOpmAR8i0w/BA4Y8AMy9MY7FR4if9RMKuRGvd7IWHUDRMH9mgjSEgwp+1oGkHXa9DNDwMT3U09cGaD6UmRiwUk4/0xkb70zgcnCh996h7bE43HDWzp0DNUrmoOJ+j+0x3uLHYa97bjbij0qszkONsuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hvckNIXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hvckNIXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382D4C433C7;
	Tue, 23 Jan 2024 10:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706006315;
	bh=lVsBKbDDJF3ceXm0FPt8Ck+0PSteaxTqnfYYJdW9a6w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hvckNIXQoQnmXvT3FKkzHQbNBYVhNOGxp1ZWRVK4cfniLbBXxxvRGZE1fXpzGWRb+
	 iTCIuUmor8oJxAaZylWx8wH8whuGwnc1KDLN1SixsrYJarHuhPi7meCVLJ2FB8XFP5
	 jA62WEZWnruNpdkuNjIMAlB4rHoXtcb3FTWicC2iCRe8Fn8st7TGRKztIS3LrB2Iie
	 LntSzTzkVXoyi+Ifzpu97LPA7CYMmW/dEzjUVsppbN60q3Nb2UlHn47L6BlC5NDlpU
	 /z7brn58+v21wDtZzbOiUbit5sSRAdP+S53S+OGFr7c67Ij0+mflViNF/57P9jOves
	 eilibQqRx/gyQ==
Date: Tue, 23 Jan 2024 11:38:31 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_db: don't hardcode 'type data' size at 512b
Message-ID: <yr2rzvhdk7hcrjtsazhopvfx4o3uhscpbmbzi4tyvr32yqs4nr@vnu2wmrmjezw>
References: <XHUtgxly_CH13p8M7H9gfXcYh0jkPKFUt3PdJWiUb0Zd-14mjvJntXzbO99fH1XtOezv0aqG4XSdnTZ06vmgzw==@protonmail.internalid>
 <20240123041044.GD6226@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123041044.GD6226@frogsfrogsfrogs>

On Mon, Jan 22, 2024 at 08:10:44PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On a disk with 4096-byte LBAs, the xfs_db 'type data' subcommand doesn't
> work:
> 
> # xfs_io -c 'sb' -c 'type data' /dev/sda
> xfs_db: read failed: Invalid argument
> no current object
> 
> The cause of this is the hardcoded initialization of bb_count when we're
> setting type data -- it should be the filesystem sector size, not just 1.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good:
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  db/block.c |    7 ++++---
>  db/io.c    |    3 ++-
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/db/block.c b/db/block.c
> index f234fcb4edcb..c847a91dd22f 100644
> --- a/db/block.c
> +++ b/db/block.c
> @@ -149,6 +149,7 @@ daddr_f(
>  	int64_t		d;
>  	char		*p;
>  	int		c;
> +	int		bb_count = BTOBB(mp->m_sb.sb_sectsize);
>  	xfs_rfsblock_t	max_daddrs = mp->m_sb.sb_dblocks;
>  	enum daddr_target tgt = DT_DATA;
> 
> @@ -202,13 +203,13 @@ daddr_f(
>  	ASSERT(typtab[TYP_DATA].typnm == TYP_DATA);
>  	switch (tgt) {
>  	case DT_DATA:
> -		set_cur(&typtab[TYP_DATA], d, 1, DB_RING_ADD, NULL);
> +		set_cur(&typtab[TYP_DATA], d, bb_count, DB_RING_ADD, NULL);
>  		break;
>  	case DT_RT:
> -		set_rt_cur(&typtab[TYP_DATA], d, 1, DB_RING_ADD, NULL);
> +		set_rt_cur(&typtab[TYP_DATA], d, bb_count, DB_RING_ADD, NULL);
>  		break;
>  	case DT_LOG:
> -		set_log_cur(&typtab[TYP_DATA], d, 1, DB_RING_ADD, NULL);
> +		set_log_cur(&typtab[TYP_DATA], d, bb_count, DB_RING_ADD, NULL);
>  		break;
>  	}
>  	return 0;
> diff --git a/db/io.c b/db/io.c
> index 580d34015868..3841c0dcb86e 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -681,7 +681,8 @@ void
>  set_iocur_type(
>  	const typ_t	*type)
>  {
> -	int		bb_count = 1;	/* type's size in basic blocks */
> +	/* type's size in basic blocks */
> +	int		bb_count = BTOBB(mp->m_sb.sb_sectsize);
>  	int		boff = iocur_top->boff;
> 
>  	/*
> 
