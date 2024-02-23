Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3C95D750
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 16:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708705761; cv=none; b=q402AQnSCjs2173lPg0VZZpv1ZjKFSWILVjj2lodP0+hRGEBr9lgVPqwg/Tug0kCDxBdlX9EsjeUf+RzWtl5AowH3yXxgjtmA9wH/L5VIxAYS3ePYl7fNxvkHp3fe2M/ez2GG0wvTyiX9NhJ84I+aMl8jN/aNCuVgLfe4NQuJfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708705761; c=relaxed/simple;
	bh=FpaVeYTGGk6oOrmmTqOF59bz8TxP+I2MHmdslXL9qpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hoT+n95sZmdBRB3lwrMwPJGNgNZHbM1npt8dT8wuGZiFLZPpyNxmFfphdS4lw+ge3eHOtjMUOstC/4HWgxIk+v1NIpB2tgKUVD6dILDupwm6lHt0LIsQNYxYaTa78SohwYc8PaothLOA5blBL4Ji/wL5l0Jd0ngT0/vZo92pGNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sGxwck/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sGxwck/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5E5C433C7;
	Fri, 23 Feb 2024 16:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708705760;
	bh=FpaVeYTGGk6oOrmmTqOF59bz8TxP+I2MHmdslXL9qpw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sGxwck/ZeCfyIznQgZxqJILR1dc+BZfFWS/LHYQkYzDotaLY5vhsbzG/2IN1e6Wyo
	 DHhBivVXS9+Aor4FfuAa5jwg6qSQkjOAEisV59h2D1lRKeO4XqbTYxv7HQAakIKSx0
	 u3oOIfhSxJheDj5GhSevRkYRiPF7SvIvwGrzqsYevvwagJUEePlk3slOTy9RUG5fK8
	 VgAs1l4Oow5X6RWW5qMhQx2VTRq49ekF3QX2MLEaFeKPTnjsvcVx6po+sjtQOS8SCc
	 EAaifWMtyOuK0S3eAecgi7nTnB3r8c9U9GF1i8+9Z5gg/g1fPBnwUSnC8lDxRdqomU
	 X7SrG001LYvzw==
Date: Fri, 23 Feb 2024 08:29:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/10] xfs: make XFS_TRANS_LOWMODE match the other
 XFS_TRANS_ definitions
Message-ID: <20240223162920.GM616564@frogsfrogsfrogs>
References: <20240223071506.3968029-1-hch@lst.de>
 <20240223071506.3968029-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223071506.3968029-2-hch@lst.de>

On Fri, Feb 23, 2024 at 08:14:57AM +0100, Christoph Hellwig wrote:
> Commit bb7b1c9c5dd3 ("xfs: tag transactions that contain intent done
> items") switched the XFS_TRANS_ definitions to be bit based, and using
> comments above the definitions.  As XFS_TRANS_LOWMODE was last and has
> a big fat comment it was missed.  Switch it to the same style.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_shared.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index 4220d3584c1b0b..6f1cedb850eb39 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -70,7 +70,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
>  #define XFS_TRANS_RES_FDBLKS		(1u << 6)
>  /* Transaction contains an intent done log item */
>  #define XFS_TRANS_HAS_INTENT_DONE	(1u << 7)
> -
>  /*
>   * LOWMODE is used by the allocator to activate the lowspace algorithm - when
>   * free space is running low the extent allocator may choose to allocate an
> @@ -82,7 +81,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
>   * for free space from AG 0. If the correct transaction reservations have been
>   * made then this algorithm will eventually find all the space it needs.
>   */
> -#define XFS_TRANS_LOWMODE	0x100	/* allocate in low space mode */
> +#define XFS_TRANS_LOWMODE		(1u << 8)
>  
>  /*
>   * Field values for xfs_trans_mod_sb.
> -- 
> 2.39.2
> 
> 
