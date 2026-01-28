Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1D019CD1B
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 01:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564126; cv=none; b=t573FvLHv5BTvWVwoQXQkefzqSV1CsjI2PPk2K+PpZIdC2RWLJ4LDS2SRa02CVBVlBvl0msosFJejHTV5HvT7nAgcpXbgnEO3PNPg+dNuwsO5ESseVziUO7F04Q9Qtc68ib7aejJFlW3bQW8vEc6l9ICpVw0Dftknx5c9vu1EEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564126; c=relaxed/simple;
	bh=kzGuKe86SRtAuuhiXBvVjISp+EJK4M4UKDTzYAijrdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UySebDlIhIF5tg78Dkrv3DXYKC2S9GqzlW23uNrRiTipTmEqkSHl/FzxUnd8XMFQrsgNElhDL1LZVIg26JxsMaiVxVhTrHe6JtyWBzDtpBlmXngeqtBJA9WzxmXf2hno2U7NhulSWx3SwWwDsjbtkiL0kbCXc4qOh5cSYR6jYuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sTEOH633; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sTEOH633"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E4DC116D0;
	Wed, 28 Jan 2026 01:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769564126;
	bh=kzGuKe86SRtAuuhiXBvVjISp+EJK4M4UKDTzYAijrdY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sTEOH633dmrLPVZSWBpDd/kQBUrP5Dj6zUbwDHzuvK2Q11MNFDdhPYq8qkGp6HS+1
	 m336uxPx23JlnMn/VbWvBiOYFMxaGVivLqpD6zpR5RDY9EqbT+AzD6GNabTj2IO7Ze
	 SFLaZSTTg9ZEqo+tR4pd4Ym6CYS+tE3ooAmcVO+e8nxUg7X4Fud0w3GbAE6mxH9bCy
	 55MGjxt1pyyKN6D1b/sFT3opTOpMZ6QaQr90fziXVxHlWG0rAznjH0E8oFbrlSD1qq
	 R/b4lBFnJoY41qiAppoXTzn4FOktV4yAD+Z64iSEVieNaPAQZGGVKyfbTJmq3uUwX8
	 d3x8vvx4gu8WQ==
Date: Tue, 27 Jan 2026 17:35:25 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: move the guts of XFS_ERRORTAG_DELAY out of
 line
Message-ID: <20260128013525.GD5945@frogsfrogsfrogs>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127160619.330250-5-hch@lst.de>

On Tue, Jan 27, 2026 at 05:05:44PM +0100, Christoph Hellwig wrote:
> Mirror what is done for the more common XFS_ERRORTAG_TEST version,
> and also only look at the error tag value once now that we can
> easily have a local variable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_error.c | 21 +++++++++++++++++++++
>  fs/xfs/xfs_error.h | 15 +++------------
>  2 files changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 52a1d51126e3..a6f160a4d0e9 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -144,6 +144,27 @@ xfs_errortag_test(
>  	return true;
>  }
>  
> +void
> +xfs_errortag_delay(
> +	struct xfs_mount	*mp,
> +	const char		*file,
> +	int			line,
> +	unsigned int		error_tag)
> +{
> +	unsigned int		delay = mp->m_errortag[error_tag];
> +
> +	might_sleep();
> +
> +	if (!delay)
> +		return;
> +
> +	xfs_warn_ratelimited(mp,
> +"Injecting %ums delay at file %s, line %d, on filesystem \"%s\"",
> +		delay, file, line,
> +		mp->m_super->s_id);

Hrm.  This changes the logging ratelimiting from per-injection-site to
global for the whole kernel.  I'm mostly ok with that since I rarely
read dmesg, but does anyone else care?

If not, then
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +	mdelay(delay);
> +}
> +
>  int
>  xfs_errortag_add(
>  	struct xfs_mount	*mp,
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index ec22546a8ca8..b40e7c671d2a 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -40,19 +40,10 @@ bool xfs_errortag_test(struct xfs_mount *mp, const char *file, int line,
>  		unsigned int error_tag);
>  #define XFS_TEST_ERROR(mp, tag)		\
>  	xfs_errortag_test((mp), __FILE__, __LINE__, (tag))
> -bool xfs_errortag_enabled(struct xfs_mount *mp, unsigned int tag);
> +void xfs_errortag_delay(struct xfs_mount *mp, const char *file, int line,
> +		unsigned int error_tag);
>  #define XFS_ERRORTAG_DELAY(mp, tag)		\
> -	do { \
> -		might_sleep(); \
> -		if (!mp->m_errortag[tag]) \
> -			break; \
> -		xfs_warn_ratelimited((mp), \
> -"Injecting %ums delay at file %s, line %d, on filesystem \"%s\"", \
> -				(mp)->m_errortag[(tag)], __FILE__, __LINE__, \
> -				(mp)->m_super->s_id); \
> -		mdelay((mp)->m_errortag[(tag)]); \
> -	} while (0)
> -
> +	xfs_errortag_delay((mp), __FILE__, __LINE__, (tag))
>  int xfs_errortag_add(struct xfs_mount *mp, unsigned int error_tag);
>  int xfs_errortag_clearall(struct xfs_mount *mp);
>  #else
> -- 
> 2.47.3
> 
> 
