Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A711E258EC1
	for <linux-xfs@vger.kernel.org>; Fri, 31 Oct 2025 23:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761955190; cv=none; b=SkHTELHIKcIN5Wb76CLwmMyvdqM9dZ/wDYOdP0+jPR8B8m6gZyVJaZiYE9X1tUA9zqO6bJEIFYBYbs38Y7A+PCAdHzUlqPqdNo1x0JzbG4LYpWTpIZIp5lxU4K/W+CpXWW+VfNL20kgN34EDxBLDVMsoyAbm08r3jSZG/HJYF2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761955190; c=relaxed/simple;
	bh=bC3yLRiojk/UwJbTaWadD6GJUTE+EGwVU+0sPCzW9oc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fQg8QXIIR/Dg9cmMxKNvDWFVIvRZq1Vi7l/QQfdlgY1NXEUC/VYvDYgd5JoZLEKp+CjHMi1xmUMlnxxvz3uF7rfVuxQX5dcg4s9G4L258X5BQxbfbdT+jH2KQa7zQ+SrDHnwZ3joDuC5XNtf+BY3FdqQRFAUTdBVyfoNHOKAuvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z0KBNYnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z0KBNYnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27602C4CEE7;
	Fri, 31 Oct 2025 23:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761955190;
	bh=bC3yLRiojk/UwJbTaWadD6GJUTE+EGwVU+0sPCzW9oc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z0KBNYnBbfSMvd5pAzXipu+shy2m1eTE/5HNFrx7iNCZ7TbVOCijSN2x7GZpE3Kxl
	 +/6v43JrjVbG4KhgG+CwWkr3kbHNLmRGis719XR/ZR1/jZyfKkF5wuQ4nWu79gzvXV
	 CgF7dEAJ2jU4tQH89Z/CaC0crtWVd3QWaOUQa55HpU3uGb66mRWM7S/BgG9lhWlouu
	 tbYzNBaSMkDdh+pirhaSeFdE6jfdBkuDvWoDY1e76QTy5v9dgMGcxjkmP4Pi1FAsa0
	 2+OaEYXMXWz85uK7TmvzFAP/90ScapHMoU1WOCwdR+BprQhNetbvaSg+U8idkedAtw
	 X4ByvCETRkfZA==
Date: Fri, 31 Oct 2025 16:59:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/10] xfs: add a xlog_write_one_vec helper
Message-ID: <20251031235949.GQ3356773@frogsfrogsfrogs>
References: <20251030144946.1372887-1-hch@lst.de>
 <20251030144946.1372887-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030144946.1372887-2-hch@lst.de>

On Thu, Oct 30, 2025 at 03:49:11PM +0100, Christoph Hellwig wrote:
> Add a wrapper for xlog_write for the two callers who need to build a
> log_vec and add it to a single-entry chain instead of duplicating the
> code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This looks like a pretty simple hoist...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c      | 35 +++++++++++++++++++++--------------
>  fs/xfs/xfs_log_cil.c  | 11 +----------
>  fs/xfs/xfs_log_priv.h |  2 ++
>  3 files changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index a311385b23d8..ed83a0e3578e 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -848,6 +848,26 @@ xlog_wait_on_iclog(
>  	return 0;
>  }
>  
> +int
> +xlog_write_one_vec(
> +	struct xlog		*log,
> +	struct xfs_cil_ctx	*ctx,
> +	struct xfs_log_iovec	*reg,
> +	struct xlog_ticket	*ticket)
> +{
> +	struct xfs_log_vec	lv = {
> +		.lv_niovecs	= 1,
> +		.lv_iovecp	= reg,
> +	};
> +	LIST_HEAD		(lv_chain);
> +
> +	/* account for space used by record data */
> +	ticket->t_curr_res -= reg->i_len;
> +
> +	list_add(&lv.lv_list, &lv_chain);
> +	return xlog_write(log, ctx, &lv_chain, ticket, reg->i_len);
> +}
> +
>  /*
>   * Write out an unmount record using the ticket provided. We have to account for
>   * the data space used in the unmount ticket as this write is not done from a
> @@ -876,21 +896,8 @@ xlog_write_unmount_record(
>  		.i_len = sizeof(unmount_rec),
>  		.i_type = XLOG_REG_TYPE_UNMOUNT,
>  	};
> -	struct xfs_log_vec vec = {
> -		.lv_niovecs = 1,
> -		.lv_iovecp = &reg,
> -	};
> -	LIST_HEAD(lv_chain);
> -	list_add(&vec.lv_list, &lv_chain);
> -
> -	BUILD_BUG_ON((sizeof(struct xlog_op_header) +
> -		      sizeof(struct xfs_unmount_log_format)) !=
> -							sizeof(unmount_rec));
> -
> -	/* account for space used by record data */
> -	ticket->t_curr_res -= sizeof(unmount_rec);
>  
> -	return xlog_write(log, NULL, &lv_chain, ticket, reg.i_len);
> +	return xlog_write_one_vec(log, NULL, &reg, ticket);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 778ac47adb8c..83aa06e19cfb 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1098,13 +1098,7 @@ xlog_cil_write_commit_record(
>  		.i_len = sizeof(struct xlog_op_header),
>  		.i_type = XLOG_REG_TYPE_COMMIT,
>  	};
> -	struct xfs_log_vec	vec = {
> -		.lv_niovecs = 1,
> -		.lv_iovecp = &reg,
> -	};
>  	int			error;
> -	LIST_HEAD(lv_chain);
> -	list_add(&vec.lv_list, &lv_chain);
>  
>  	if (xlog_is_shutdown(log))
>  		return -EIO;
> @@ -1112,10 +1106,7 @@ xlog_cil_write_commit_record(
>  	error = xlog_cil_order_write(ctx->cil, ctx->sequence, _COMMIT_RECORD);
>  	if (error)
>  		return error;
> -
> -	/* account for space used by record data */
> -	ctx->ticket->t_curr_res -= reg.i_len;
> -	error = xlog_write(log, ctx, &lv_chain, ctx->ticket, reg.i_len);
> +	error = xlog_write_one_vec(log, ctx, &reg, ctx->ticket);
>  	if (error)
>  		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
>  	return error;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 0fe59f0525aa..d2410e78b7f5 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -507,6 +507,8 @@ void	xlog_print_trans(struct xfs_trans *);
>  int	xlog_write(struct xlog *log, struct xfs_cil_ctx *ctx,
>  		struct list_head *lv_chain, struct xlog_ticket *tic,
>  		uint32_t len);
> +int	xlog_write_one_vec(struct xlog *log, struct xfs_cil_ctx *ctx,
> +		struct xfs_log_iovec *reg, struct xlog_ticket *ticket);
>  void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
>  void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
>  
> -- 
> 2.47.3
> 
> 
