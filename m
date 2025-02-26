Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C4A18DB2E
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 17:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740591572; cv=none; b=ZvRM1InCLMLIbOS4wsqjHMclH/RRaYM9n9zD2XCFzDPnfa+MOowEqm/RQUmG6faRQor8/qPsyZiv2bur4RlqOJY90px5xTcX1mm3HUZtRv4ROa5zqlOftCRRwo2+9EzfHfhY+ekjhpIoMc2NtOMd9MlBUm1LvOYxMfhTI1bVPuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740591572; c=relaxed/simple;
	bh=+nHahfbYuWnISdYcVKRqcKG9t9HmE4WjXMvZk9Tcp6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TeLJOZTj+IvycE65zr5PAOqa3yTVAxBbZwU8iKiDxc7Lx6W8je0cO15EljzyZsYNEcfwFT0q0bmXMoCG+7nIPJaVloIuH3gUW2GBnb6vMjvQ1r2baPOLcJcIJnQ+5exXQqGnBJVf+LtOV5haMXUuWslJ1QOYMsThiI8Wynztb7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GLvbVEgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GLvbVEgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0F9C4CED6;
	Wed, 26 Feb 2025 17:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740591572;
	bh=+nHahfbYuWnISdYcVKRqcKG9t9HmE4WjXMvZk9Tcp6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GLvbVEgp6dSZEr3FzKT9wxkLkk+SUqqpRikgHVSeemiFLeVuadp0nO+hF+L5GNfZ/
	 K6RUn7duLHqmHEFTcLIIbyroTOxketmJKeghezWY9YFLLKGXlbcFgYgqSY0B/7h3IK
	 cP8sc0MMed4tLeoQmwcGNc9MPptaZPxb97Lm/+QemcAT4rHIjjuo1fJFDcXhGM6pRE
	 JDLA0qrNw01BotwxB9icvrfKUo5GKywAKcBGbD+7BfaGfBQF186DBplnIUkaBQzqEo
	 nCYvyeReCJd0yB60pxI/K6xZ6PRS3UejWeKeh8/KPwd3r69L6PV3FiLT+Q27RNHPxp
	 t2MZrzulJzsAg==
Date: Wed, 26 Feb 2025 09:39:31 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs: cleanup mapping tmpfs folios into the buffer
 cache
Message-ID: <20250226173931.GS6242@frogsfrogsfrogs>
References: <20250226155245.513494-1-hch@lst.de>
 <20250226155245.513494-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226155245.513494-12-hch@lst.de>

On Wed, Feb 26, 2025 at 07:51:39AM -0800, Christoph Hellwig wrote:
> Directly assign b_addr based on the tmpfs folios without a detour
> through pages, reuse the folio_put path used for non-tmpfs buffers
> and replace all references to pages in comments with folios.
> 
> Partially based on a patch from Dave Chinner <dchinner@redhat.com>.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c     |  6 ++----
>  fs/xfs/xfs_buf_mem.c | 34 ++++++++++------------------------
>  fs/xfs/xfs_buf_mem.h |  6 ++----
>  3 files changed, 14 insertions(+), 32 deletions(-)
> 

<snip>

> diff --git a/fs/xfs/xfs_buf_mem.h b/fs/xfs/xfs_buf_mem.h
> index eed4a7b63232..67d525cc1513 100644
> --- a/fs/xfs/xfs_buf_mem.h
> +++ b/fs/xfs/xfs_buf_mem.h
> @@ -19,16 +19,14 @@ int xmbuf_alloc(struct xfs_mount *mp, const char *descr,
>  		struct xfs_buftarg **btpp);
>  void xmbuf_free(struct xfs_buftarg *btp);
>  
> -int xmbuf_map_page(struct xfs_buf *bp);
> -void xmbuf_unmap_page(struct xfs_buf *bp);
>  bool xmbuf_verify_daddr(struct xfs_buftarg *btp, xfs_daddr_t daddr);
>  void xmbuf_trans_bdetach(struct xfs_trans *tp, struct xfs_buf *bp);
>  int xmbuf_finalize(struct xfs_buf *bp);
>  #else
>  # define xfs_buftarg_is_mem(...)	(false)
> -# define xmbuf_map_page(...)		(-ENOMEM)
> -# define xmbuf_unmap_page(...)		((void)0)
>  # define xmbuf_verify_daddr(...)	(false)
>  #endif /* CONFIG_XFS_MEMORY_BUFS */
>  
> +int xmbuf_map_backing_mem(struct xfs_buf *bp);

Does this actually work if CONFIG_XFS_MEMORY_BUFS=n ?  I guess the
compiler will see:

	if (false)
		return xmbuf_map_backing_mem(bp);

and optimize it out, right?  But these subtleties make my eyes twitch.

--D

> +
>  #endif /* __XFS_BUF_MEM_H__ */
> -- 
> 2.45.2
> 
> 
