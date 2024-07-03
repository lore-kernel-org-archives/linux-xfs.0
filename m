Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE70183077
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 20:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720040076; cv=none; b=gXnwFUnekAbCRWNm5YnjTUvpyGJtXfSmeDngE92vcZ7wEdRTGKK1GqOP7ynLnAKXHHgsbrFTY5/o2P3Edl/MpQb4OutzV1j8gREgiaO+BKyP7CTQGEWCyCv/kgNYhaBbB3wS9z0k7aFbrSJuVSj4uoqDvZ1qpGbdaEomjTiP53M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720040076; c=relaxed/simple;
	bh=7tlW23wwkvpaczJoLIQzxGYk3Kb4uXSxtIIwUcmM/uc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GmPkhB/b2q+mdi3SH6Iqk0rxRm5DtNQyewxuIKm4Y35zwmKSDWUpzV35cK+4AGjqzY1T6EExh8/P9wELjN3tbxIXM8nT7B7dZpZ9cB+ASwfb2Mwv5HHJt+sbl2z5CJFsKbW9rBHKUgrtWb1S+UTG8GmBrhdqEJJWadXupNLUChM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DQqtgeJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DQqtgeJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69259C2BD10;
	Wed,  3 Jul 2024 20:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720040075;
	bh=7tlW23wwkvpaczJoLIQzxGYk3Kb4uXSxtIIwUcmM/uc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DQqtgeJAcsmyx9VPIQ+bF60IzAaTicSJqrSKp3kkToBu9H+ZfuAPAVBVSU1FGi0Qr
	 VTRr7NjdaB4gxwNUuEnONYncFg3llnnfHNHd0MG7rTCfHfGxm0tYw6LRCdkveUX4lY
	 0umwy50TtiFvKE+3YBPMx6kP/jUJNH4ocKgU3mAGHd/UsvR6ZesZQRhwxHHaW80JYt
	 zk5vb7RbhgnkHB+sn8voNLu+b35IHq1rxWC7aiZVJzCV1HAe8oIml+edMINmodBd+D
	 mAAAYCrxoI4TNRmgm6csgBtnjDH3DRtpPHDxfX2ZeoyIvmY5rOXDrX8xjSikYK9bpQ
	 Ara53sm7kp/ng==
Date: Wed, 3 Jul 2024 13:54:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2] xfs: get rid of xfs_ag_resv_rmapbt_alloc
Message-ID: <20240703205434.GI612460@frogsfrogsfrogs>
References: <20240703064226.229599-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703064226.229599-1-leo.lilong@huawei.com>

On Wed, Jul 03, 2024 at 02:42:26PM +0800, Long Li wrote:
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

Looks good to me now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ag_resv.h    | 19 -------------------
>  fs/xfs/libxfs/xfs_rmap_btree.c |  7 ++++++-
>  2 files changed, 6 insertions(+), 20 deletions(-)
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
> index 9e759efa81cc..56fd6c4bd8b4 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -88,6 +88,7 @@ xfs_rmapbt_alloc_block(
>  	struct xfs_buf		*agbp = cur->bc_ag.agbp;
>  	struct xfs_agf		*agf = agbp->b_addr;
>  	struct xfs_perag	*pag = cur->bc_ag.pag;
> +	struct xfs_alloc_arg    args = { .len = 1 };
>  	int			error;
>  	xfs_agblock_t		bno;
>  
> @@ -107,7 +108,11 @@ xfs_rmapbt_alloc_block(
>  	be32_add_cpu(&agf->agf_rmap_blocks, 1);
>  	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
>  
> -	xfs_ag_resv_rmapbt_alloc(cur->bc_mp, pag->pag_agno);
> +	/*
> +	 * Since rmapbt blocks are sourced from the AGFL, they are allocated one
> +	 * at a time and the reservation updates don't require a transaction.
> +	 */
> +	xfs_ag_resv_alloc_extent(pag, XFS_AG_RESV_RMAPBT, &args);
>  
>  	*stat = 1;
>  	return 0;
> -- 
> 2.39.2
> 
> 
