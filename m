Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01584DA04
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 05:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719983687; cv=none; b=frCTXeBJF30oCiqOClsvWMjrLIG/VWr3KBbzzojrsgrC9mkLKare6hTL9RfJWCgIm9SMOIgpcuJhfFL5mxLiJfL3gBiyZ6g2fB7RWYWR3es2cR+HXTUX4bhvv0lbKozG9oi0ERUdglt+7DZApQEW75pn7JPEm5RDM49/0T74L2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719983687; c=relaxed/simple;
	bh=hwKjen5PnWjFe1C0oSmUP3tb84AGHOTSBC8DbFTGGbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aDYdH9sibEQ2krKxX243ON7m/hUAqmgQdxnfZb7nK/snKna0nO9wapP2mfSrg2O1tZIszx1aohkm5SFigpPpLJCCOa6izncMkV8cfYcW27if0LeUY8pSm39NUFYfIslrDcZxlybP0joqMaJOOHUeHcDoecGdHHpyXeA7b0TwCGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nsmc6Quz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nsmc6Quz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBC6C32781;
	Wed,  3 Jul 2024 05:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719983686;
	bh=hwKjen5PnWjFe1C0oSmUP3tb84AGHOTSBC8DbFTGGbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nsmc6QuzN3AXyT1in4KyjOfiQ2TkDAlLeIfstfzLJkyh6X5i3wLOXsvPjcEXUQhCy
	 EPDrIY/XEXogcJhzTxWhRTWaFInxKLIXvunxXTj0QjGmnUf4Z2H1ScvWMgIEvR5TiH
	 pxmICiyQSDvctBnGgU33jt3F8ZRh6+tK8R7LsI9p28AQX9fAp8ppP5XOXItY/U6Y10
	 KkSM7g2srliYzuj41F40sKwoKwFblP7SIO7N1ngSoZMT/U5tfHfxMrvM/rEA32h1Uu
	 WsU08olA+i2iejfUTPR3DbAxM/twh6VGx4/WNY5dmoR7+n6wkNgj/bj5/OCt/mmETc
	 q0VUZkVYXUvGA==
Date: Tue, 2 Jul 2024 22:14:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH] xfs: get rid of xfs_ag_resv_rmapbt_alloc
Message-ID: <20240703051446.GF612460@frogsfrogsfrogs>
References: <20240702134851.2654558-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702134851.2654558-1-leo.lilong@huawei.com>

On Tue, Jul 02, 2024 at 09:48:51PM +0800, Long Li wrote:
> The pag in xfs_ag_resv_rmapbt_alloc() is already held when the struct
> xfs_btree_cur is initialized in xfs_rmapbt_init_cursor(), so there is no
> need to get pag again.
> 
> On the other hand, in xfs_rmapbt_free_block(), the similar function
> xfs_ag_resv_rmapbt_free() was removed in commit 92a005448f6f ("xfs: get
> rid of unnecessary xfs_perag_{get,put} pairs"), xfs_ag_resv_rmapbt_alloc()
> was left because scrub used it, but now scrub has removed it. Therefore,
> we could get rid of xfs_ag_resv_rmapbt_alloc() just like the rmap free
> block, make the code cleaner.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_ag_resv.h    | 19 -------------------
>  fs/xfs/libxfs/xfs_rmap_btree.c |  8 +++++++-
>  2 files changed, 7 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
> index ff20ed93de77..f247eeff7358 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.h
> +++ b/fs/xfs/libxfs/xfs_ag_resv.h
> @@ -33,23 +33,4 @@ xfs_perag_resv(
>  	}
>  }
>  
> -/*
> - * RMAPBT reservation accounting wrappers. Since rmapbt blocks are sourced from
> - * the AGFL, they are allocated one at a time and the reservation updates don't
> - * require a transaction.
> - */
> -static inline void
> -xfs_ag_resv_rmapbt_alloc(
> -	struct xfs_mount	*mp,
> -	xfs_agnumber_t		agno)
> -{
> -	struct xfs_alloc_arg	args = { NULL };
> -	struct xfs_perag	*pag;
> -
> -	args.len = 1;
> -	pag = xfs_perag_get(mp, agno);
> -	xfs_ag_resv_alloc_extent(pag, XFS_AG_RESV_RMAPBT, &args);
> -	xfs_perag_put(pag);
> -}
> -
>  #endif	/* __XFS_AG_RESV_H__ */
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index 9e759efa81cc..aa1d29814b74 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -88,6 +88,7 @@ xfs_rmapbt_alloc_block(
>  	struct xfs_buf		*agbp = cur->bc_ag.agbp;
>  	struct xfs_agf		*agf = agbp->b_addr;
>  	struct xfs_perag	*pag = cur->bc_ag.pag;
> +	struct xfs_alloc_arg    args = { NULL };

You could make this even more compact with

	struct xfs_alloc_arg	args = { .len = 1 };

Otherwise this looks ok to me as a cleanup.

--D

>  	int			error;
>  	xfs_agblock_t		bno;
>  
> @@ -107,7 +108,12 @@ xfs_rmapbt_alloc_block(
>  	be32_add_cpu(&agf->agf_rmap_blocks, 1);
>  	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
>  
> -	xfs_ag_resv_rmapbt_alloc(cur->bc_mp, pag->pag_agno);
> +	/*
> +	 * Since rmapbt blocks are sourced from the AGFL, they are allocated one
> +	 * at a time and the reservation updates don't require a transaction.
> +	 */
> +	args.len = 1;
> +	xfs_ag_resv_alloc_extent(pag, XFS_AG_RESV_RMAPBT, &args);
>  
>  	*stat = 1;
>  	return 0;
> -- 
> 2.39.2
> 
> 
