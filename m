Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830DF1DC9BB
	for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 08:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747126243; cv=none; b=Zab6Bq0At2e5JIaGiQQgNT7VJRtW9JakPHwuBJBmzbHIj6ZNvEYoyZkMVFejceniAcyF8Hj59gO7/HxtiCmsIoh3HiChheNF6eS4zPgff1KyjfTj8geKTtdsLYlhPzm3ahzqfbPf3pZ2HSayaQGkRqT2Jr16Ly1t/HijKFqGdaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747126243; c=relaxed/simple;
	bh=KsfXXz6PUgHqrPMPzvXLGrvEJsCalrZYq4XBNqAMBvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RtSRzZVP9JCdjmGCVKGUKLTE+uH1o7fZxgeFxxpc0wGzrIn7qSRxczQfgU7yccTz3OyF+5Cf0NYxIR4zkTYj6/HPx/Vz9Pj/Ymw29Brgs2GobGPIYFX21V3CjmhHr+F90lT12rsQiQJyQORQ8ir7MJVW8eKzxU8mpJ9h3tfp0Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VWM24W8p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VWM24W8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389B9C4CEE4;
	Tue, 13 May 2025 08:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747126243;
	bh=KsfXXz6PUgHqrPMPzvXLGrvEJsCalrZYq4XBNqAMBvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VWM24W8pGGInPRxEO5mAK4mn7TTyhUE/oIXW8TA/GnfsE3WC4dTPXBPWKE2AJ7Twe
	 C5WEDYTWgOnrvuIUc+Lxl7fAiHYL1A6s9WL8UKt4MiY2ymT/DjmifDXgFVwYvGlJ9j
	 BJCh2TvzG1AgYpMAh1bdD0pdTsahGiUbH2Jqww9HPr2xL39fNfOjjvbo3Ka88UK5nI
	 G5dEbX4If6HZCdGfKkgrfxcKFmaWUvTEet4Yd2TuHpkaeOgY/vTOOiop1LxDfUJAG/
	 ebaDYhJW0bAR9Hi45Yh+PuKS3VT1xB8t6se8saH6FgcP0bsbOpIfjq33LlQEV+qFq5
	 9wnureQupXRgQ==
Date: Tue, 13 May 2025 10:50:37 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the EXPERIMENTAL warning for pNFS
Message-ID: <vaindfvrgb46yyfvegv54xwostcgshkdhsyy7yeokzj5d4ncp3@by56pjnvontu>
References: <ameUfBEEyURNYSQYgyjG-wGKYZUzJ1k2wPEZcnDB5ONjpQoDTTLROlafcZbTzuQyBGclnKN-bPmGKpwL4SwGrg==@protonmail.internalid>
 <20250513053102.757788-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513053102.757788-1-hch@lst.de>

On Tue, May 13, 2025 at 07:30:33AM +0200, Christoph Hellwig wrote:
> The pNFS layout support has been around for 10 years without major
> issues, drop the EXPERIMENTAL warning.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

10 years is fair enough :)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
> 
> This is ontop of "xfs: remove some EXPERIMENTAL warnings" from Darrick.
> 
>  fs/xfs/xfs_message.c | 4 ----
>  fs/xfs/xfs_message.h | 1 -
>  fs/xfs/xfs_pnfs.c    | 2 --
>  3 files changed, 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> index 54fc5ada519c..19aba2c3d525 100644
> --- a/fs/xfs/xfs_message.c
> +++ b/fs/xfs/xfs_message.c
> @@ -141,10 +141,6 @@ xfs_warn_experimental(
>  		const char		*name;
>  		long			opstate;
>  	} features[] = {
> -		[XFS_EXPERIMENTAL_PNFS] = {
> -			.opstate	= XFS_OPSTATE_WARNED_PNFS,
> -			.name		= "pNFS",
> -		},
>  		[XFS_EXPERIMENTAL_SHRINK] = {
>  			.opstate	= XFS_OPSTATE_WARNED_SHRINK,
>  			.name		= "online shrink",
> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> index bce9942f394a..d68e72379f9d 100644
> --- a/fs/xfs/xfs_message.h
> +++ b/fs/xfs/xfs_message.h
> @@ -91,7 +91,6 @@ void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
>  			       const char *fmt, ...);
> 
>  enum xfs_experimental_feat {
> -	XFS_EXPERIMENTAL_PNFS,
>  	XFS_EXPERIMENTAL_SHRINK,
>  	XFS_EXPERIMENTAL_LARP,
>  	XFS_EXPERIMENTAL_LBS,
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index 6f4479deac6d..afe7497012d4 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -58,8 +58,6 @@ xfs_fs_get_uuid(
>  {
>  	struct xfs_mount	*mp = XFS_M(sb);
> 
> -	xfs_warn_experimental(mp, XFS_EXPERIMENTAL_PNFS);
> -
>  	if (*len < sizeof(uuid_t))
>  		return -EINVAL;
> 
> --
> 2.47.2
> 
> 
