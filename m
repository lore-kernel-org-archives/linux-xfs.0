Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5491519F40B
	for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 14:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747146993; cv=none; b=jr4jVj8AOvqlVj8aA/3J+sKnZ6NoHr/peetdJmK0uUUsUnBoST/Ew2S2YdirrAW4cdduVmVQXxZvU4AwyWBqoz77/a4m5AdUIV3QOtq3tCNdfUFh7S+aERfKEfpWLW2efKyOffL4H+S3MabUywBoJ9I0SiXYxMdHmKCHqQq6VZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747146993; c=relaxed/simple;
	bh=H82GnFOwdwXGMOY+9Ng8qcLgxB75DsQlP1wFuP6YCts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pj4pHBijMnAYy4GHWgPJMyWjQsFEFDFPv6gqVNLvTdexAW4bEMOjsEJm7Vx2ktnY8E86eCqxVCPnAhKbhrWjb+gDCg8jivZpLj0f72fo839/mmWOJxrwhShR0143uJrGuM2+bk9MTamWTpyi9GuTog/UH4WaSV2Jmmb3FM3RCJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DxmoLekB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DxmoLekB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA254C4CEE9;
	Tue, 13 May 2025 14:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747146992;
	bh=H82GnFOwdwXGMOY+9Ng8qcLgxB75DsQlP1wFuP6YCts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DxmoLekBjQWooxgaS8KboMOCiMbwKGwkt0swGnhnzF9D61E+h0r94XIRuu3UMX7/y
	 c+THfShBcV360tiaRc6CA3PEmeRQDSwBEHyvFnk+1c4hfjRA3xKXtlXs57ycQeCmHS
	 ZPXzTJYVw+pju4bvT7e0w2k9ZGzK/AdG8HwV+3HuociPdmBE9WGLIP38x8OaWxiZiP
	 Blbb4DXb963qnnJd94kitY0CLVamB4I7Q0mY9L9Fb5ehE5cCRrh27AEbbFh6YP9ce0
	 rAyxNDT2z8tKTEQdoafz59GlBFfnPzoDOpPBkqZFuNyak1gHYRjeXZLOjmYjdiy4JL
	 0kbdbeh5ACy3Q==
Date: Tue, 13 May 2025 07:36:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the EXPERIMENTAL warning for pNFS
Message-ID: <20250513143632.GJ2701446@frogsfrogsfrogs>
References: <20250513053102.757788-1-hch@lst.de>
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

Looks fine, but you ought to remove XFS_OPSTATE_WARNED_PNFS from
xfs_mount.h as I forgot to do in my patch. :(

--D

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
