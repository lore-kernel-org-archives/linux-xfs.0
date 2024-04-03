Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E9A2374D
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 03:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712116440; cv=none; b=IxCcQJT0/gUxYB+pBYzzqu3Bmv1hqXR6MTkXdtV+MsD2uw8Vn7a/mXuZNkfocx/c6dBlWHhQudJOsKaFGEX9pli7TteafDblwD2i0gOiHvz7CSitT+ph/LCgYRJ/NVs96yjsMN1/UFkz04chI1Tm2OQm6sUpnENpEKpkYgdWRhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712116440; c=relaxed/simple;
	bh=qYBC1tZ9JRv066yji13l73QPCcbF+xGH/kRoMTH7OSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CaGT72fWrHNFNwlipZEaaEZFgoQQWCMeQUKsfeAHB5/Jozp4+/nX+9dtqX2HIOFGdejctgej+3FuR2fLV8KghOyCsab8GvQGjCEIcIfLjSrXzH9WleEdnGql+a8FeDG3j2rI1cTk/82Y/jt4gSa+1MxqLwPMe7jXPU9DoXJInoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LwPDM57W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LwPDM57W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C2DC433F1;
	Wed,  3 Apr 2024 03:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712116440;
	bh=qYBC1tZ9JRv066yji13l73QPCcbF+xGH/kRoMTH7OSQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LwPDM57WoaVspOj+4nYX64Y53xnLzb+/adxy6F5YJyWp4W7VjLe2s3/QSb3qUyYZ0
	 HrnilT6ZIKE7lErhT9XySz3mG7erk5aRCwGHbmeXQheUJicfR+88K5AJ0tZZYY5jz6
	 vg8rNXB60nk18JfSNuqSiRA5V2ENlt7qQgYdWVFAt/tPbi5Y5b0L+1pWHtpn/Xdmki
	 edJ8GPtV7AXPvGP0jUBEXpH21zAjjPFzDWVXzZvJc32LW3cZg8i6RLbZL45ehnyaH2
	 JJbS5EiTdVXYJl4yiYKDYZUkJCs2V3PoHedFxPqT0iyMh6mMkzG5ohZViLLvzNHXrT
	 oAuXgfoT85iDA==
Date: Tue, 2 Apr 2024 20:53:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: fix sparse warnings about unused interval tree
 functions
Message-ID: <20240403035359.GM6390@frogsfrogsfrogs>
References: <20240402213541.1199959-1-david@fromorbit.com>
 <20240402213541.1199959-6-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402213541.1199959-6-david@fromorbit.com>

On Wed, Apr 03, 2024 at 08:28:32AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Sparse throws warnings about the interval tree functions that are
> defined and then not used in the scrub bitmap code:
> 
> fs/xfs/scrub/bitmap.c:57:1: warning: unused function 'xbitmap64_tree_iter_next' [-Wunused-function]
> INTERVAL_TREE_DEFINE(struct xbitmap64_node, bn_rbnode, uint64_t,
> ^
> ./include/linux/interval_tree_generic.h:151:33: note: expanded from macro 'INTERVAL_TREE_DEFINE'
> ITSTATIC ITSTRUCT *                                                           \
>                                                                               ^
> <scratch space>:3:1: note: expanded from here
> xbitmap64_tree_iter_next
> ^
> fs/xfs/scrub/bitmap.c:331:1: warning: unused function 'xbitmap32_tree_iter_next' [-Wunused-function]
> INTERVAL_TREE_DEFINE(struct xbitmap32_node, bn_rbnode, uint32_t,
> ^
> ./include/linux/interval_tree_generic.h:151:33: note: expanded from macro 'INTERVAL_TREE_DEFINE'
> ITSTATIC ITSTRUCT *                                                           \
>                                                                               ^
> <scratch space>:59:1: note: expanded from here
> xbitmap32_tree_iter_next
> 
> Fix these by marking the functions created by the interval tree
> creation macro as __maybe_unused to suppress this warning.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Much better than the hatchet job sent in by the last person...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/bitmap.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
> index 0cb8d43912a8..7ba35a7a7920 100644
> --- a/fs/xfs/scrub/bitmap.c
> +++ b/fs/xfs/scrub/bitmap.c
> @@ -40,22 +40,23 @@ struct xbitmap64_node {
>   * These functions are defined by the INTERVAL_TREE_DEFINE macro, but we'll
>   * forward-declare them anyway for clarity.
>   */
> -static inline void
> +static inline __maybe_unused void
>  xbitmap64_tree_insert(struct xbitmap64_node *node, struct rb_root_cached *root);
>  
> -static inline void
> +static inline __maybe_unused void
>  xbitmap64_tree_remove(struct xbitmap64_node *node, struct rb_root_cached *root);
>  
> -static inline struct xbitmap64_node *
> +static inline __maybe_unused struct xbitmap64_node *
>  xbitmap64_tree_iter_first(struct rb_root_cached *root, uint64_t start,
>  			uint64_t last);
>  
> -static inline struct xbitmap64_node *
> +static inline __maybe_unused struct xbitmap64_node *
>  xbitmap64_tree_iter_next(struct xbitmap64_node *node, uint64_t start,
>  		       uint64_t last);
>  
>  INTERVAL_TREE_DEFINE(struct xbitmap64_node, bn_rbnode, uint64_t,
> -		__bn_subtree_last, START, LAST, static inline, xbitmap64_tree)
> +		__bn_subtree_last, START, LAST, static inline __maybe_unused,
> +		xbitmap64_tree)
>  
>  /* Iterate each interval of a bitmap.  Do not change the bitmap. */
>  #define for_each_xbitmap64_extent(bn, bitmap) \
> @@ -314,22 +315,23 @@ struct xbitmap32_node {
>   * These functions are defined by the INTERVAL_TREE_DEFINE macro, but we'll
>   * forward-declare them anyway for clarity.
>   */
> -static inline void
> +static inline __maybe_unused void
>  xbitmap32_tree_insert(struct xbitmap32_node *node, struct rb_root_cached *root);
>  
> -static inline void
> +static inline __maybe_unused void
>  xbitmap32_tree_remove(struct xbitmap32_node *node, struct rb_root_cached *root);
>  
> -static inline struct xbitmap32_node *
> +static inline __maybe_unused struct xbitmap32_node *
>  xbitmap32_tree_iter_first(struct rb_root_cached *root, uint32_t start,
>  			  uint32_t last);
>  
> -static inline struct xbitmap32_node *
> +static inline __maybe_unused struct xbitmap32_node *
>  xbitmap32_tree_iter_next(struct xbitmap32_node *node, uint32_t start,
>  			 uint32_t last);
>  
>  INTERVAL_TREE_DEFINE(struct xbitmap32_node, bn_rbnode, uint32_t,
> -		__bn_subtree_last, START, LAST, static inline, xbitmap32_tree)
> +		__bn_subtree_last, START, LAST, static inline __maybe_unused,
> +		xbitmap32_tree)
>  
>  /* Iterate each interval of a bitmap.  Do not change the bitmap. */
>  #define for_each_xbitmap32_extent(bn, bitmap) \
> -- 
> 2.43.0
> 
> 
