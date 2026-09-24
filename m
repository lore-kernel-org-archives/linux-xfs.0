Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7435490C13
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 20:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790281131; cv=none; b=h+TyZrkMuy+ekRNbaNiz3JJOReEgpjpyUAXy7zSuC39r9duV9w43xhbE+u5vbyQaNQRFI6jrYXIJJRtU46xRplnHeyZb9hI+dnKsQnOkizP0YIZPIPyHIh8AhMw/wNaSLT/2rcBPlTLpuFP+O8r/tC/lrQ+gIsjuvcOUAeSfUQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790281131; c=relaxed/simple;
	bh=YsNG7nqHFq/qKMw270YELh01dfiRpsvU0DiwP1MoAgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eX0QQYrzIFO1vXXB57H8dAPUqC9vhVL6Uv/mIm/QaBS9xPgYw71P0oO6OxCMKBs4AxjfcfPZdC/9MiTVFQPWULUOiSLAKsfDq0yyVxxpChfFsvSi7ksxpvnWxoRTc6LhAK+E5ATKgTMWzG7+Efg6AEb5nX5YAyg01FMsdJC/IIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BFoBOpub; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BFoBOpub"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3A16F1F00899;
	Thu, 24 Sep 2026 20:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790281129;
	bh=mfH1FWxNcwMgOa5P/qUYEuc2mMUXdPXu61ar4hwV8A4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BFoBOpubla4lWvoPirHEWWPPsET0ME5BjjZfIjxmgWcfHD91ltbe9nhM9Pzx2WuUm
	 1bpe7EEga0TIlkUhQtdujzLU/FVdM4zbK5omf/BVSlmIAxKuNHXTV5StRrkA4VFdYQ
	 Sp6C9hD1wNfBn5vzkaX9papC9R9gmqtskmjrUkscVKWXwPKYioNYwUikaVNSLR2zw4
	 t2MHuyZmJgGthyHL6rSl0KCDzqs8USfEV3dR8/FsmjQxUHTmBsy4X43b4bOdmq/z9c
	 ZMwjiI0eGMxGJYblxPSlYiFtPACcc7OBgC1F9Df8XMqsDST0EnibilAQ3aadWVGuy/
	 o+7IoWGRLLTlw==
Date: Thu, 24 Sep 2026 13:18:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: lift setting the NOFS context to xfs_end_io
Message-ID: <20260924201848.GV2705364@frogsfrogsfrogs>
References: <20260924095740.2732474-1-hch@lst.de>
 <20260924095740.2732474-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924095740.2732474-7-hch@lst.de>

On Thu, Sep 24, 2026 at 11:57:07AM +0200, Christoph Hellwig wrote:
> No point in clearing and restoring it for every processed bio.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Agreed.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_ioend.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
> index e70be5b86f0b..258c6130bee8 100644
> --- a/fs/xfs/xfs_ioend.c
> +++ b/fs/xfs/xfs_ioend.c
> @@ -175,16 +175,8 @@ xfs_end_ioend_write(
>  	bool			is_zoned = xfs_is_zoned_inode(ip);
>  	xfs_off_t		offset = ioend->io_offset;
>  	size_t			size = ioend->io_size;
> -	unsigned int		nofs_flag;
>  	int			error;
>  
> -	/*
> -	 * We can allocate memory here while doing writeback on behalf of
> -	 * memory reclaim.  To avoid memory allocation deadlocks set the
> -	 * task-wide nofs context for the following operations.
> -	 */
> -	nofs_flag = memalloc_nofs_save();
> -
>  	/*
>  	 * Just clean up the in-memory structures if the fs has been shut down.
>  	 */
> @@ -241,7 +233,6 @@ xfs_end_ioend_write(
>  	if (is_zoned)
>  		xfs_ioend_put_open_zones(ioend);
>  	iomap_finish_ioends(ioend, error);
> -	memalloc_nofs_restore(nofs_flag);
>  }
>  
>  /*
> @@ -266,6 +257,7 @@ xfs_end_io(
>  		container_of(work, struct xfs_inode, i_ioend_work);
>  	struct iomap_ioend	*ioend;
>  	struct list_head	tmp;
> +	unsigned int		nofs_flag;
>  	unsigned long		flags;
>  
>  	spin_lock_irqsave(&ip->i_ioend_lock, flags);
> @@ -273,6 +265,13 @@ xfs_end_io(
>  	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
>  
>  	iomap_sort_ioends(&tmp);
> +
> +	/*
> +	 * We can allocate memory here while doing writeback on behalf of
> +	 * memory reclaim.  To avoid memory allocation deadlocks set the
> +	 * task-wide nofs context for the following operations.
> +	 */
> +	nofs_flag = memalloc_nofs_save();
>  	while ((ioend = list_first_entry_or_null(&tmp, struct iomap_ioend,
>  			io_list))) {
>  		list_del_init(&ioend->io_list);
> @@ -280,6 +279,7 @@ xfs_end_io(
>  		xfs_end_ioend_write(ioend);
>  		cond_resched();
>  	}
> +	memalloc_nofs_restore(nofs_flag);
>  }
>  
>  void
> -- 
> 2.53.0
> 
> 
