Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71372DAFA1
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 15:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773414258; cv=none; b=JvIdCJFDHpjj/UXRCIx8hGymWlaUsVRnHHiL+9twegzQ5U5hv/P0hJPqy79vEKIXbDX+XRSDNl34vL/w/27xSy4EeqY0AX5a0RUCtCNdN1tNKXnYBviuou35MKF0uK5i0DU41WibXO4AEaIhsvxU8FsoJTW3nQODHhF4EPC3YXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773414258; c=relaxed/simple;
	bh=Jq+T152RmzLD/ysTvDR/IEY2JzIT1K2ZeymVtEuwpJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=elbqnxLreRCZtUJ1Fxf0phDTVJvnhFjxYIYT/67ltodq48NxV+yLTynCoEwjwMnlBmbZ9rNShSGDMgXuKGI6+k06BcwjS8RLQCKFwo6jpPMBmIMwR7EYjGGvgUUC0zZJ8oSaoxIo71T+vV5IwttTynw/XJlXs/tZohQdx1awS3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oj3ijGvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oj3ijGvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E723C19421;
	Fri, 13 Mar 2026 15:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773414258;
	bh=Jq+T152RmzLD/ysTvDR/IEY2JzIT1K2ZeymVtEuwpJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oj3ijGvDMKIVY2jndrU2KSOlDW7Y615Vo585FqgNMQa40MY+9zpjgj+bP96mgmGXJ
	 3qjK+Y9MA+yH4ieAgWRe72I07JLWeXaL4KOchWvKqU0e1COOCm/Sac1yEjbUfurHtY
	 /OIbhQUDGyfE1BvvlSGhceiWkSfYeaO6p316hhWFI8jziufghtuZ8N9K3DulgIoiDy
	 bBgabAHYlZx0rKcJE6mhZuaA7xSO4L7P/s+CYPvLGbpIThgfwTQw9xxz0gg4hTZ2hw
	 w5Df98LjaKB9N+3W2lf8RKv6nofmc3FLT27IYVy3gtvrJns2GLPuPJ/I1QlW9M+j2Z
	 OgosyTCYUhoKQ==
Date: Fri, 13 Mar 2026 08:04:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH v2 3/4] xfs: factor out xfs_attr3_leaf_init
Message-ID: <20260313150417.GQ1770774@frogsfrogsfrogs>
References: <20260312085800.1213919-1-leo.lilong@huawei.com>
 <20260312085800.1213919-4-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312085800.1213919-4-leo.lilong@huawei.com>

On Thu, Mar 12, 2026 at 04:57:59PM +0800, Long Li wrote:
> Factor out wrapper xfs_attr3_leaf_init function, which exported for
> external use.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 22 ++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.h |  3 +++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 47f48ae555c0..96a65141e812 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1415,6 +1415,28 @@ xfs_attr3_leaf_create(
>  	return 0;
>  }
>  
> +/*
> + * Create and initialize an empty attr leaf block at blkno, and attach the
> + * buffer to tp.

Not sure why we "create and initialize" here -- there's already a block
mapped at @blkno and we're rewriting it with a leaf header, right?

/*
 * Reinitialize an existing attr fork block as an empty leaf, and
 * attach the buffer to tp.
 */

With that changed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> + */
> +int
> +xfs_attr3_leaf_init(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*dp,
> +	xfs_dablk_t		blkno)
> +{
> +	struct xfs_buf		*bp = NULL;
> +	struct xfs_da_args	args = {
> +		.trans		= tp,
> +		.dp		= dp,
> +		.owner		= dp->i_ino,
> +		.geo		= dp->i_mount->m_attr_geo,
> +	};
> +
> +	ASSERT(tp != NULL);
> +
> +	return xfs_attr3_leaf_create(&args, blkno, &bp);
> +}
>  /*
>   * Split the leaf node, rebalance, then add the new entry.
>   *
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index aca46da2bc50..72639efe6ac3 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -87,6 +87,9 @@ int	xfs_attr3_leaf_list_int(struct xfs_buf *bp,
>  /*
>   * Routines used for shrinking the Btree.
>   */
> +
> +int	xfs_attr3_leaf_init(struct xfs_trans *tp, struct xfs_inode *dp,
> +				xfs_dablk_t blkno);
>  int	xfs_attr3_leaf_toosmall(struct xfs_da_state *state, int *retval);
>  void	xfs_attr3_leaf_unbalance(struct xfs_da_state *state,
>  				       struct xfs_da_state_blk *drop_blk,
> -- 
> 2.39.2
> 
> 
