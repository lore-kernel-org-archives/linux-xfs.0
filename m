Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53652D5C73;
	Wed,  2 Jul 2025 14:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751467398; cv=none; b=eBOp77BWsfPUefNg7lCRaJ4cUwGmogASUL8Rh+/oEQRaTaz9qfPQkfl2WkbwFJ36s8ZdPRsPcCwkCNfalEz6TSAjddVKFJjGhky8fmhrktC6L2WQQisFBh/J4IlwWIzPl/CbYJJ64P3remOfNmuticMPxQlG8/kIWA39nXPWfG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751467398; c=relaxed/simple;
	bh=FB8noNZwJPcaZSUUsSezeKLPzsPLDkdKDVUkz/TTaDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hBoxFyNndCIGyOUgZEBKaxkA7aywHvl+wo8v3hrCKmTflq1a157JWvSoWdRT7gGxETqLOzMmN4X6LrGCkilGobNIM6BuDOJt5flj0Bf2PEq/JSwAidHIa/nsUczscxN1/0wQAxYxv7NAyGyedp5nbvxprm5XaWJMEMWWYFE5mx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TA9+JaPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TA9+JaPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A8EC4CEE7;
	Wed,  2 Jul 2025 14:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751467398;
	bh=FB8noNZwJPcaZSUUsSezeKLPzsPLDkdKDVUkz/TTaDc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TA9+JaPnzXZgfqUtR2Kp6fenYBoQJtSEbVeBT90BZuos1svfviGrYk4TdqPlpCCOq
	 xq99+BMr+RJs6EGHp1RjkrAc4HuRk2tlzD8twaw1TuklOZCUJEEjmegu0UKW8Tz5aU
	 LAbqwW0PPHsSTvaRn42uNzo06GNIurD3904Lj/kZjUQlA6dzoYmUIjf1HqlI3b1GdD
	 mpjJD/pfmIO1SzFyHBBCL8IIFpvPKRjuckirst/YUfMRuwd/d8jHAfhehBZ1lhDgK0
	 utDIrwHN2wezGSFb982Mzj6UUoght24ZJIObSGyf29CoGCIqY8uNnp+CBj6gCqXGqe
	 ROBn5PcGJOPlQ==
Date: Wed, 2 Jul 2025 07:43:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: Re: [PATCH v2 6/6] xfs: refactor xfs_btree_diff_two_ptrs() to take
 advantage of cmp_int()
Message-ID: <20250702144317.GT10009@frogsfrogsfrogs>
References: <20250702093935.123798-1-pchelkin@ispras.ru>
 <20250702093935.123798-7-pchelkin@ispras.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250702093935.123798-7-pchelkin@ispras.ru>

On Wed, Jul 02, 2025 at 12:39:33PM +0300, Fedor Pchelkin wrote:
> Use cmp_int() to yield the result of a three-way-comparison instead of
> performing subtractions with extra casts. Thus also rename the function
> to make its name clearer in purpose.
> 
> Found by Linux Verification Center (linuxtesting.org).
> 
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> ---
> 
> v2: rename the "diff_two_ptrs" part (Darrick)

Looks good now, thanks for the cmp_int cleanups!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
>  fs/xfs/libxfs/xfs_btree.c | 8 ++++----
>  fs/xfs/libxfs/xfs_btree.h | 6 +++---
>  fs/xfs/scrub/btree.c      | 2 +-
>  3 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index d3591728998e..a61211d253f1 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -5353,15 +5353,15 @@ xfs_btree_count_blocks(
>  }
>  
>  /* Compare two btree pointers. */
> -int64_t
> -xfs_btree_diff_two_ptrs(
> +int
> +xfs_btree_cmp_two_ptrs(
>  	struct xfs_btree_cur		*cur,
>  	const union xfs_btree_ptr	*a,
>  	const union xfs_btree_ptr	*b)
>  {
>  	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
> -		return (int64_t)be64_to_cpu(a->l) - be64_to_cpu(b->l);
> -	return (int64_t)be32_to_cpu(a->s) - be32_to_cpu(b->s);
> +		return cmp_int(be64_to_cpu(a->l), be64_to_cpu(b->l));
> +	return cmp_int(be32_to_cpu(a->s), be32_to_cpu(b->s));
>  }
>  
>  struct xfs_btree_has_records {
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 1bf20d509ac9..60e78572e725 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -519,9 +519,9 @@ struct xfs_btree_block *xfs_btree_get_block(struct xfs_btree_cur *cur,
>  		int level, struct xfs_buf **bpp);
>  bool xfs_btree_ptr_is_null(struct xfs_btree_cur *cur,
>  		const union xfs_btree_ptr *ptr);
> -int64_t xfs_btree_diff_two_ptrs(struct xfs_btree_cur *cur,
> -				const union xfs_btree_ptr *a,
> -				const union xfs_btree_ptr *b);
> +int xfs_btree_cmp_two_ptrs(struct xfs_btree_cur *cur,
> +			   const union xfs_btree_ptr *a,
> +			   const union xfs_btree_ptr *b);
>  void xfs_btree_get_sibling(struct xfs_btree_cur *cur,
>  			   struct xfs_btree_block *block,
>  			   union xfs_btree_ptr *ptr, int lr);
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index fe678a0438bc..cd6f0ff382a7 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -306,7 +306,7 @@ xchk_btree_block_check_sibling(
>  	if (pbp)
>  		xchk_buffer_recheck(bs->sc, pbp);
>  
> -	if (xfs_btree_diff_two_ptrs(cur, pp, sibling))
> +	if (xfs_btree_cmp_two_ptrs(cur, pp, sibling))
>  		xchk_btree_set_corrupt(bs->sc, cur, level);
>  out:
>  	xfs_btree_del_cursor(ncur, XFS_BTREE_ERROR);
> -- 
> 2.50.0
> 
> 
