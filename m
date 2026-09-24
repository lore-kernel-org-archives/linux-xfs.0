Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD113C5DB6
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 20:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790280812; cv=none; b=CxBMxk7qYl3rhZLeOBlxI/5BVtMnqCtGASemcfly+jxmJ1MX446764YrlmQxUhmN53rdvwYTjsgDb3PfkSsUKgtWKmtrf3FXX9vmO30B3StApGDsSaryCcv2PlbdWbEV4rnyzNCemRHDXY48N5kqmOHE58aKQIcKy1r5MsshiYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790280812; c=relaxed/simple;
	bh=y/EOESTLAufXhqSF4FK5jLFdpQmGpAq4MD7tDcHjJfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tIChSJvzae8z6kfdn8j0p6vpgEoSR5sftfjMflYa5E/GIHj/2fgE0Ht+PHbRROtFbMs7+E5qvIciw46SARQF3ssCQggL8W+TgbEoFSoGtaJd8Ru6ObtothjBdUr+D7lffXFjIrf3uP71ozE+7xUfmlfBUHe9AECI+cURzOZAoaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ghPYjd92; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ghPYjd92"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 70EF81F000FF;
	Thu, 24 Sep 2026 20:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790280810;
	bh=x0KYdY6k35qhRqNCDjIlpNnMCBV4UEW6qSjnY1Qej5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ghPYjd92sivIcdIorosJWMyZJn6VxBjpGoHsG9NJ+cj+MoukndkNG0/HBNxiauA4R
	 3/rUdYBZiBYTONZ607WNARX322bENWOJaRJMbMya58O2sd9QU5lMfYbK00hJqRpiOn
	 UsWaaDZxz93KUY9hhX5eEFeskRfx7USB1NOBn8PktFCX4x6yebi525L9k7KGr6cFFO
	 uIWQX15xxipfhtcd783/Hk3f4oa/6DNTFVdcHZO1fhFdFJVX9E8SLgwlj5K+ZorJO+
	 7/nFSQh+LotzyOHRiAbBwpe68Ca268rl76ztqZr2t07rh34mA5Z8dCwdyElezKEpyM
	 uRr2m/53/98+g==
Date: Thu, 24 Sep 2026 13:13:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: add a xfs_rtblock_payload helper
Message-ID: <20260924201329.GS2705364@frogsfrogsfrogs>
References: <20260924095740.2732474-1-hch@lst.de>
 <20260924095740.2732474-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924095740.2732474-4-hch@lst.de>

On Thu, Sep 24, 2026 at 11:57:04AM +0200, Christoph Hellwig wrote:
> Add a helper to calculate the rtblock payload start with or without the
> self-describing metadata header.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice refactoring!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_rtbitmap.c |  9 ++-------
>  fs/xfs/libxfs/xfs_rtbitmap.h | 27 ++++++++++++---------------
>  2 files changed, 14 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 5cadde81b5da..01536f4fb386 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -1411,7 +1411,6 @@ xfs_rtfile_initialize_block(
>  	struct xfs_inode	*ip = rtg->rtg_inodes[type];
>  	struct xfs_trans	*tp;
>  	struct xfs_buf		*bp;
> -	void			*bufdata;
>  	const size_t		copylen = mp->m_blockwsize << XFS_WORDLOG;
>  	int			error;
>  
> @@ -1427,16 +1426,12 @@ xfs_rtfile_initialize_block(
>  		xfs_trans_cancel(tp);
>  		return error;
>  	}
> -	bufdata = bp->b_addr;
>  
>  	xfs_rtfile_initialize_buf(rtg, type, bp, tp);
> -
> -	if (xfs_has_rtgroups(mp))
> -		bufdata += sizeof(struct xfs_rtbuf_blkinfo);
>  	if (data)
> -		memcpy(bufdata, data, copylen);
> +		memcpy(xfs_rtblock_payload(bp), data, copylen);
>  	else
> -		memset(bufdata, 0, copylen);
> +		memset(xfs_rtblock_payload(bp), 0, copylen);
>  	xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
>  	return xfs_trans_commit(tp);
>  }
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
> index 4a87e1fd3e99..750d74fbf4ed 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.h
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.h
> @@ -20,6 +20,16 @@ struct xfs_rtalloc_args {
>  	xfs_fileoff_t		sumoff;	/* summary block number */
>  };
>  
> +/* Return the payload of the buffer after the optional header. */
> +static inline void *
> +xfs_rtblock_payload(
> +	struct xfs_buf		*bp)
> +{
> +	if (!xfs_has_rtgroups(bp->b_mount))
> +		return bp->b_addr;
> +	return bp->b_addr + sizeof(struct xfs_rtbuf_blkinfo);
> +}
> +
>  static inline xfs_rtblock_t
>  xfs_rtx_to_rtb(
>  	struct xfs_rtgroup	*rtg,
> @@ -221,14 +231,7 @@ xfs_rbmblock_wordptr(
>  	struct xfs_rtalloc_args	*args,
>  	unsigned int		index)
>  {
> -	struct xfs_mount	*mp = args->mp;
> -	union xfs_rtword_raw	*words;
> -	struct xfs_rtbuf_blkinfo *hdr = args->rbmbp->b_addr;
> -
> -	if (xfs_has_rtgroups(mp))
> -		words = (union xfs_rtword_raw *)(hdr + 1);
> -	else
> -		words = args->rbmbp->b_addr;
> +	union xfs_rtword_raw	*words = xfs_rtblock_payload(args->rbmbp);
>  
>  	return words + index;
>  }
> @@ -312,13 +315,7 @@ xfs_rsumblock_infoptr(
>  	struct xfs_rtalloc_args	*args,
>  	unsigned int		index)
>  {
> -	union xfs_suminfo_raw	*info;
> -	struct xfs_rtbuf_blkinfo *hdr = args->sumbp->b_addr;
> -
> -	if (xfs_has_rtgroups(args->mp))
> -		info = (union xfs_suminfo_raw *)(hdr + 1);
> -	else
> -		info = args->sumbp->b_addr;
> +	union xfs_suminfo_raw	*info = xfs_rtblock_payload(args->sumbp);
>  
>  	return info + index;
>  }
> -- 
> 2.53.0
> 
> 
