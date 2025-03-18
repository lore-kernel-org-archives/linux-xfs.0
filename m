Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A919420C48D
	for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 12:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742302545; cv=none; b=OOToqpPBQWNX/oPcP29G3NY7wt/qDeM4oxkzlqQg6YV7Q8bfFq/HSOXgvKDHuqthFkDFpnzrFdaw6I3kie72pceoHLj74lJuOv/BF2pk8X+qQkBRDSxQ5R97NI5YdtXohDFEx1MdM/HNsxZtS9FcYstZIzdgrSm46THzDztGGXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742302545; c=relaxed/simple;
	bh=SAx5ywDynSc//ZOStepeyHhs7kiZ2N+3jBJJGnx6168=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tITX/Y1gMqKmNSgfzVgp3ZIMU00rcQXJNTKWx3Ua2PVtA8w9QKbonF9d94+KJPXj04SmI7Ez5co+jDNTkME98GBx8eajKuoLP88zeJlkvCa4D2JMpGwohHdcGwQWjLhoz+JsW1xfHrx77whd65zSU9P6iSl8CCLR8Kihi6Vx0vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qeww2bI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qeww2bI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D80C4CEE3;
	Tue, 18 Mar 2025 12:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742302544;
	bh=SAx5ywDynSc//ZOStepeyHhs7kiZ2N+3jBJJGnx6168=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qeww2bI1zI0wUw/JAUMGP92WSvw71xWjZ6YGu9HQrvYA4eNa9pB3Y0wWj+Kiko9tm
	 aHQPFeQa2uux0vP5B8RBOanosBFxthdEH3b3D7muiNF59lQv4WAsYXv0Vr+NKnO7rP
	 1iDqWqzKZ3yu4zyfrY3PTMBcZENR7jvSfLvf4das+R9ht68lVRa48EQp0ESXqnOjTq
	 tXW7G0DX0XBIFcUL/g9VFmy+fA8sjlytPeSjirDN1xubOSN+7hKUlrVOdryeXf7KCC
	 vS9iLvmw144gGjSgQt+spjMZerrEHCmZlZchVss4B1Bxa4gppQIydfpOevno5uPnKK
	 ci3plBXXq6rXg==
Date: Tue, 18 Mar 2025 13:54:48 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: remove the flags argument to
 xfs_buf_get_uncached
Message-ID: <wog6repjzjmxfrejmip3cbz2g47bwyfab53knom5h26t5ejanl@b2sjpdvf47om>
References: <20250317054850.1132557-1-hch@lst.de>
 <VLqi9FTlcCv7tbkLpdOtzT58RKZzY6Dc4HjlvUMvWPebiwk_Sz7LqZjLIIWAj-UOQMdAOB3HqEnAoZ8pI7lTvw==@protonmail.internalid>
 <20250317054850.1132557-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250317054850.1132557-6-hch@lst.de>

On Mon, Mar 17, 2025 at 06:48:36AM +0100, Christoph Hellwig wrote:
> No callers passes flags to xfs_buf_get_uncached, which makes sense
> given that the flags apply to behavior not used for uncached buffers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_ag.c | 2 +-
>  fs/xfs/xfs_buf.c       | 5 ++---
>  fs/xfs/xfs_buf.h       | 2 +-
>  fs/xfs/xfs_rtalloc.c   | 2 +-
>  4 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index b59cb461e096..e6ba914f6d06 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -301,7 +301,7 @@ xfs_get_aghdr_buf(
>  	struct xfs_buf		*bp;
>  	int			error;
> 
> -	error = xfs_buf_get_uncached(mp->m_ddev_targp, numblks, 0, &bp);
> +	error = xfs_buf_get_uncached(mp->m_ddev_targp, numblks, &bp);
>  	if (error)
>  		return error;
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 6469a69b18fe..8e7f1b324b3b 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -810,7 +810,7 @@ xfs_buf_read_uncached(
> 
>  	*bpp = NULL;
> 
> -	error = xfs_buf_get_uncached(target, numblks, 0, &bp);
> +	error = xfs_buf_get_uncached(target, numblks, &bp);
>  	if (error)
>  		return error;
> 
> @@ -836,13 +836,12 @@ int
>  xfs_buf_get_uncached(
>  	struct xfs_buftarg	*target,
>  	size_t			numblks,
> -	xfs_buf_flags_t		flags,
>  	struct xfs_buf		**bpp)
>  {
>  	int			error;
>  	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
> 
> -	error = xfs_buf_alloc(target, &map, 1, flags, bpp);
> +	error = xfs_buf_alloc(target, &map, 1, 0, bpp);
>  	if (!error)
>  		trace_xfs_buf_get_uncached(*bpp, _RET_IP_);
>  	return error;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 6a426a8d6197..d0b065a9a9f0 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -273,7 +273,7 @@ xfs_buf_readahead(
>  }
> 
>  int xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
> -		xfs_buf_flags_t flags, struct xfs_buf **bpp);
> +		struct xfs_buf **bpp);
>  int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
>  		size_t numblks, struct xfs_buf **bpp,
>  		const struct xfs_buf_ops *ops);
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index e35c728f222e..6484c596ecea 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -839,7 +839,7 @@ xfs_growfs_rt_init_rtsb(
>  		return 0;
> 
>  	error = xfs_buf_get_uncached(mp->m_rtdev_targp, XFS_FSB_TO_BB(mp, 1),
> -			0, &rtsb_bp);
> +			&rtsb_bp);
>  	if (error)
>  		return error;
> 
> --
> 2.45.2
> 
> 
