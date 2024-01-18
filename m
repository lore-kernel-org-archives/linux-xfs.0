Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D2F1DDF6
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 23:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705621153; cv=none; b=ivn4oQO4nim73Hks9T+J7xr8w+twaLt5nZ5vRnmmeZlR4bjr4OiOxVFSDX9mRia+JOPPkjtKs/74BlOvurPORAmuLp0wnLddTU9YygR+WgGPgYfx9PtlnY+gIFHSer8Z73yyIDmCG7loatFOcmnFPcP9DFB/iZTNNBqmJs7F2T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705621153; c=relaxed/simple;
	bh=kBi8sr7d6KMQKJ8NlGPfcvv71UswaZSW8Fst7sMA0XY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kynjj7dtfIriyZvUoxC9eN061DLnNe9r/6XB6BkAYTWqJSboMLw6ZkbFEAG4uN+IIQZ0wjjuQ8kus/YqceUwRdl42bvDOuX1Hrc40rP2AYSdx5hO36tqg2P/Dnv48KAaS6gRBYrwbY2+Qps808jJiUvhNGNv4Fa5RYgxsNzAZpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qa/pYQZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qa/pYQZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A0EC433C7;
	Thu, 18 Jan 2024 23:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705621153;
	bh=kBi8sr7d6KMQKJ8NlGPfcvv71UswaZSW8Fst7sMA0XY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qa/pYQZKCap9UNr96UVdEaAmO8UW/fk4HZ/ZHED47IJBRPO2EzC44+HuJz8G56uKU
	 kTmkwY1Y6s0fkNJ6r3i2OyJS/OzYoA8AyL65EdHRdWCrsgiWDPx4ML4kcL1wMT8ny7
	 AYyIDi1krn808alqxYfqAhcer2cJ425f60qrfi0xYJj63H9Xag+JEOhMoBBOnjKS/q
	 hafbfhlvBIixrmIVhGbYvgCCi5zKDEdaKC9Uas7i7+6+KC8rRt6WaoCCuDaotSe2Yh
	 tL7Kk4mjeUiMppHHTogqWam6HAm8KJjuypjGUcQZTVi5xN32KuwAK5TJTjRqEY0JpM
	 P5ATEoTEDfRHQ==
Date: Thu, 18 Jan 2024 15:39:12 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 09/12] xfs: place intent recovery under NOFS allocation
 context
Message-ID: <20240118233912.GL674499@frogsfrogsfrogs>
References: <20240115230113.4080105-1-david@fromorbit.com>
 <20240115230113.4080105-10-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115230113.4080105-10-david@fromorbit.com>

On Tue, Jan 16, 2024 at 09:59:47AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When recovery starts processing intents, all of the initial intent
> allocations are done outside of transaction contexts. That means
> they need to specifically use GFP_NOFS as we do not want memory
> reclaim to attempt to run direct reclaim of filesystem objects while
> we have lots of objects added into deferred operations.
> 
> Rather than use GFP_NOFS for these specific allocations, just place
> the entire intent recovery process under NOFS context and we can
> then just use GFP_KERNEL for these allocations.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Hooray!  This finally goes away...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_attr_item.c     |  2 +-
>  fs/xfs/xfs_bmap_item.c     |  3 ++-
>  fs/xfs/xfs_log_recover.c   | 18 ++++++++++++++----
>  fs/xfs/xfs_refcount_item.c |  2 +-
>  fs/xfs/xfs_rmap_item.c     |  2 +-
>  5 files changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 0bf25a2ba3b6..e14e229fc712 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -513,7 +513,7 @@ xfs_attri_recover_work(
>  		return ERR_PTR(error);
>  
>  	attr = kzalloc(sizeof(struct xfs_attr_intent) +
> -			sizeof(struct xfs_da_args), GFP_NOFS | __GFP_NOFAIL);
> +			sizeof(struct xfs_da_args), GFP_KERNEL | __GFP_NOFAIL);
>  	args = (struct xfs_da_args *)(attr + 1);
>  
>  	attr->xattri_da_args = args;
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 029a6a8d0efd..e3c58090e976 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -445,7 +445,8 @@ xfs_bui_recover_work(
>  	if (error)
>  		return ERR_PTR(error);
>  
> -	bi = kmem_cache_zalloc(xfs_bmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
> +	bi = kmem_cache_zalloc(xfs_bmap_intent_cache,
> +			GFP_KERNEL | __GFP_NOFAIL);
>  	bi->bi_whichfork = (map->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
>  			XFS_ATTR_FORK : XFS_DATA_FORK;
>  	bi->bi_type = map->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index e9ed43a833af..8c1d260bb9e1 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3443,12 +3443,19 @@ xlog_recover(
>   * part of recovery so that the root and real-time bitmap inodes can be read in
>   * from disk in between the two stages.  This is necessary so that we can free
>   * space in the real-time portion of the file system.
> + *
> + * We run this whole process under GFP_NOFS allocation context. We do a
> + * combination of non-transactional and transactional work, yet we really don't
> + * want to recurse into the filesystem from direct reclaim during any of this
> + * processing. This allows all the recovery code run here not to care about the
> + * memory allocation context it is running in.
>   */
>  int
>  xlog_recover_finish(
>  	struct xlog	*log)
>  {
> -	int	error;
> +	unsigned int	nofs_flags = memalloc_nofs_save();
> +	int		error;
>  
>  	error = xlog_recover_process_intents(log);
>  	if (error) {
> @@ -3462,7 +3469,7 @@ xlog_recover_finish(
>  		xlog_recover_cancel_intents(log);
>  		xfs_alert(log->l_mp, "Failed to recover intents");
>  		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
> -		return error;
> +		goto out_error;
>  	}
>  
>  	/*
> @@ -3483,7 +3490,7 @@ xlog_recover_finish(
>  		if (error < 0) {
>  			xfs_alert(log->l_mp,
>  	"Failed to clear log incompat features on recovery");
> -			return error;
> +			goto out_error;
>  		}
>  	}
>  
> @@ -3508,9 +3515,12 @@ xlog_recover_finish(
>  		 * and AIL.
>  		 */
>  		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
> +		goto out_error;
>  	}
>  
> -	return 0;
> +out_error:
> +	memalloc_nofs_restore(nofs_flags);
> +	return error;
>  }
>  
>  void
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index d850b9685f7f..14919b33e4fe 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -425,7 +425,7 @@ xfs_cui_recover_work(
>  	struct xfs_refcount_intent	*ri;
>  
>  	ri = kmem_cache_alloc(xfs_refcount_intent_cache,
> -			GFP_NOFS | __GFP_NOFAIL);
> +			GFP_KERNEL | __GFP_NOFAIL);
>  	ri->ri_type = pmap->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK;
>  	ri->ri_startblock = pmap->pe_startblock;
>  	ri->ri_blockcount = pmap->pe_len;
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index a40b92ac81e8..e473124e29cc 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -455,7 +455,7 @@ xfs_rui_recover_work(
>  {
>  	struct xfs_rmap_intent		*ri;
>  
> -	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
> +	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_KERNEL | __GFP_NOFAIL);
>  
>  	switch (map->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
>  	case XFS_RMAP_EXTENT_MAP:
> -- 
> 2.43.0
> 
> 
