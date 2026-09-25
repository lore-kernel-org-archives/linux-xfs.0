Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AE02E7162
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 23:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790378986; cv=none; b=aWhgBH4lhzwI9U1h8c7TmTwRPezv0JvoNFDk/mVvFvl3P1pStfSnNdh7jY/fCWyagli/vOpvaQACEShrciVCRPxjPHAknQlar9uZ/gRa1yc2UVOKo8bl1gpFj/lo9yLuIneLcmUv+bMwGKsSUBJZvyxQXzbMEDOALObfmeZ3WGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790378986; c=relaxed/simple;
	bh=t+Mje5KWxpv/tMuduUlpYvxvpwcOJcQH+jgBQWUQnCk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AVdS2+vwgn5l5HVihqUSgCPu2CkEPjw0jQnBSciWBy82R2/Kyg/Dnd+lEmXtrXLz9oF0h1Fe5HxLj3aw2gwBJCfBad9mX55mJMhXFrQHNAtJVj+OD3MqBAkEaE8jG+KBgvd5IZcKdSOWEXnjlFIcGpTfue+HWfgCRQYj2wN7NYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AwHLdCZd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AwHLdCZd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 090681F000FF;
	Fri, 25 Sep 2026 23:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790378985;
	bh=/3VBd/6JYMYy2/t0P3GYx3Gl8cbuXMlNpRzK834Kul8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AwHLdCZd4tBB7e2wDSB1xmYY6fRoIXdFkmdjdeLnnjaOktpLNU3XH8iXKbhSB8eAI
	 gH2owBQDMP0g+Kp7yw238aIC9IbmC1odJV/OGzCJOjiYXtR9wxC//lbO9Q7ZY5Jl7M
	 cvm9EzwnuGWsIXTe9stvamK2DzSdDJhc9pzuzUaMq9e6MHRHL5rTZTmUCXizDNC8G1
	 U3vpLuKHTJiBwiaVEcVcNY3IymgjeMVqyoHoXGzf62BNVS7EEUs2k+Aj/Zjg4REhtz
	 LFwckzgxSgu8XTD2iqjVbSEyPnWdicgjcz5X0FsWy1EEufmO1zcJ+5J3raWqqF2L9y
	 tEmDDJCkrH2Tg==
Date: Fri, 25 Sep 2026 16:29:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/32] FIXUP
Message-ID: <20260925232944.GK2705364@frogsfrogsfrogs>
References: <20260924100512.2733748-1-hch@lst.de>
 <20260924100512.2733748-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100512.2733748-10-hch@lst.de>

On Thu, Sep 24, 2026 at 12:03:59PM +0200, Christoph Hellwig wrote:
> ---
>  libxfs/libxfs_io.h    | 6 ++++++
>  libxfs/rdwr.c         | 2 --
>  libxfs/xfs_platform.h | 1 -
>  3 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index 5562e2928254..bd0d9ec04bea 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
> @@ -293,4 +293,10 @@ xfs_buftarg_verify_daddr(
>  	return daddr < xfs_buftarg_nr_sectors(btp);
>  }
>  
> +static inline void
> +xfs_buf_set_uptodate(
> +	struct xfs_buf 		*bp)
> +{
> +}

Should this set LIBXFS_B_UPTODATE?

--D

> +
>  #endif	/* __LIBXFS_IO_H__ */
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 90f2d56687ca..9b6cbd4aa158 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -1426,8 +1426,6 @@ __xfs_buf_mark_corrupt(
>  	struct xfs_buf		*bp,
>  	xfs_failaddr_t		fa)
>  {
> -	ASSERT(bp->b_flags & XBF_DONE);
> -
>  	xfs_buf_corruption_error(bp, fa);
>  	xfs_buf_stale(bp);
>  }
> diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
> index 0aeb80fb8244..d9cfcec4c1a0 100644
> --- a/libxfs/xfs_platform.h
> +++ b/libxfs/xfs_platform.h
> @@ -322,7 +322,6 @@ static inline unsigned long long mask64_if_power2(unsigned long b)
>  
>  /* buffer management */
>  #define XBF_TRYLOCK			0
> -#define XBF_DONE			0
>  #define xfs_buf_stale(bp)		((bp)->b_flags |= LIBXFS_B_STALE)
>  #define XFS_BUF_UNDELAYWRITE(bp)	((bp)->b_flags &= ~LIBXFS_B_DIRTY)
>  
> -- 
> 2.53.0
> 
> 
