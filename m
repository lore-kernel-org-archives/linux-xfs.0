Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A8A1EB38
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 23:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705621272; cv=none; b=UDBAptmeUpo6UDLn6RShr6aOmS7IaHi+jnA4lboE42fYJfQLC51U1seSOJJ1so6Tyf4M7UOz437Vrw5ICJ9NDjj41CQIQ/t07gykNdbGF8yw5wSu0v0TZKSioHxIZhMhia2vVb/eqTm6nxVyVm860Un28rn1m0DdkgTKvmDIFmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705621272; c=relaxed/simple;
	bh=HEpCjoKfmS67GJwIshU82X9AJCb9bY8hjiE2OkGJAf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u2xzFeWKolPFK3haDvH4IOzSmF2a7yMSY66O92iwXw/MUeQP5I+XPyTFRVKAf6qUL9AGhobtqwpzItOdqYe7rtm3eAaXq2oQe/mya88KqjfQdqKgfbJqdReiR9sSaNtCf1ODBlRkpn2ukDM7J7E1X2TXWOwrx2ZA9j83BCjdWvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z4GYvx1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z4GYvx1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F243CC433C7;
	Thu, 18 Jan 2024 23:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705621272;
	bh=HEpCjoKfmS67GJwIshU82X9AJCb9bY8hjiE2OkGJAf0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z4GYvx1R++TBTsc2GgqBOCM6fcNOpK3Gqiyafa8JEVYBsB9YPpnsQMUDHa5lFvSsp
	 58bUx1LueM2tBymzv6OXLRHCIBk/5gVO0ESJOTw9rZ999a3labHdbLH2iH2vDGqS7f
	 67Z2dNAIUiTlUWtkfpFQLA8/8vG9EJcdxmSAER2V5Nmlaeu8kBZjSXyehsGxB26V9G
	 Fz0gNKSA6gf0EJxhrfuFYVk9hcKB4arFmnR5cQbLWllJUhtihomoihVe04/b4ybViL
	 WgOY/hp9OU5WNkuvIDJGndOrzpgMtOIVc1EJq2ZLM40qZPJlswaBthJ8iyGlr9uSPH
	 sUFzSMXn5LFUA==
Date: Thu, 18 Jan 2024 15:41:11 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/12] xfs: place the CIL under nofs allocation context
Message-ID: <20240118234111.GM674499@frogsfrogsfrogs>
References: <20240115230113.4080105-1-david@fromorbit.com>
 <20240115230113.4080105-11-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115230113.4080105-11-david@fromorbit.com>

On Tue, Jan 16, 2024 at 09:59:48AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This is core code that needs to run in low memory conditions and
> can be triggered from memory reclaim. While it runs in a workqueue,
> it really shouldn't be recursing back into the filesystem during
> any memory allocation it needs to function.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 815a2181004c..8c3b09777006 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -100,7 +100,7 @@ xlog_cil_ctx_alloc(void)
>  {
>  	struct xfs_cil_ctx	*ctx;
>  
> -	ctx = kzalloc(sizeof(*ctx), GFP_NOFS | __GFP_NOFAIL);
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL | __GFP_NOFAIL);
>  	INIT_LIST_HEAD(&ctx->committing);
>  	INIT_LIST_HEAD(&ctx->busy_extents.extent_list);
>  	INIT_LIST_HEAD(&ctx->log_items);
> @@ -1116,11 +1116,18 @@ xlog_cil_cleanup_whiteouts(
>   * same sequence twice.  If we get a race between multiple pushes for the same
>   * sequence they will block on the first one and then abort, hence avoiding
>   * needless pushes.
> + *
> + * This runs from a workqueue so it does not inherent any specific memory

                                       inherit? ^^^^^^^^

If that change is correct,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> + * allocation context. However, we do not want to block on memory reclaim
> + * recursing back into the filesystem because this push may have been triggered
> + * by memory reclaim itself. Hence we really need to run under full GFP_NOFS
> + * contraints here.
>   */
>  static void
>  xlog_cil_push_work(
>  	struct work_struct	*work)
>  {
> +	unsigned int		nofs_flags = memalloc_nofs_save();
>  	struct xfs_cil_ctx	*ctx =
>  		container_of(work, struct xfs_cil_ctx, push_work);
>  	struct xfs_cil		*cil = ctx->cil;
> @@ -1334,12 +1341,14 @@ xlog_cil_push_work(
>  	spin_unlock(&log->l_icloglock);
>  	xlog_cil_cleanup_whiteouts(&whiteouts);
>  	xfs_log_ticket_ungrant(log, ticket);
> +	memalloc_nofs_restore(nofs_flags);
>  	return;
>  
>  out_skip:
>  	up_write(&cil->xc_ctx_lock);
>  	xfs_log_ticket_put(new_ctx->ticket);
>  	kfree(new_ctx);
> +	memalloc_nofs_restore(nofs_flags);
>  	return;
>  
>  out_abort_free_ticket:
> @@ -1348,6 +1357,7 @@ xlog_cil_push_work(
>  	if (!ctx->commit_iclog) {
>  		xfs_log_ticket_ungrant(log, ctx->ticket);
>  		xlog_cil_committed(ctx);
> +		memalloc_nofs_restore(nofs_flags);
>  		return;
>  	}
>  	spin_lock(&log->l_icloglock);
> @@ -1356,6 +1366,7 @@ xlog_cil_push_work(
>  	/* Not safe to reference ctx now! */
>  	spin_unlock(&log->l_icloglock);
>  	xfs_log_ticket_ungrant(log, ticket);
> +	memalloc_nofs_restore(nofs_flags);
>  }
>  
>  /*
> -- 
> 2.43.0
> 
> 
