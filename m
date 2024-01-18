Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581AB1EB36
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 23:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705621310; cv=none; b=N72zsu3+tpi4+tTz+od5xZz17eFYaN0XsZy+Q0CLxtIjAvnzznUMrTwUUdYcAKJHrGjJ8I+DypP7h3ZJOAzjs/q6JPcMJWHuC1RBQbAyk4e2DXJGFCz8WE7H8D3N5Uv+/UPirIY86/bwHdKpe3O/LxSMjZEFg0M4E2N4aOHaGzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705621310; c=relaxed/simple;
	bh=vo8aTkMp0KITMxB2WdEq74+s6IXX1f9jXCxVNisE3fQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oTH34SUzmMfvk+y/XFoOkgPXNugIFU3Wrrjd2yJv7dZLP5dJFMaMml8GaGG5cPRvl7D8qXWUNtW9t/byEKbdnl5AGdgXTs/I6MHZ6hgr1MGbZFB5swoDzgvxKkVof4zyHayL1KXq0r30GqAiMY/V9RM8DabYMRsU44nT3osPgy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZHUxZh0+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHUxZh0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACDEC433C7;
	Thu, 18 Jan 2024 23:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705621309;
	bh=vo8aTkMp0KITMxB2WdEq74+s6IXX1f9jXCxVNisE3fQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZHUxZh0+IAoSd2ycAGDwxNMlRK3FYNOJPLZtWp18ZN/LsIeQt6lY5utv+3WZ5TcUL
	 SZjqpJve/V53IV1YmxVOuHgZZ6I1oeHFRFsxc7NxSUsPLLOMFyMaL8U7g6O657oj5Y
	 OFjtRPf+aYWrDKG+5jkZmYy2ZwmwP0OH8yFUfv7S3sBwBF/XTs0Q3d0kGY326dRN0J
	 mk+gBzId/WBdqPzmx/MYVCEXvWj2yLbf5vq5gXk0lRlDqxOBCIhHqZxNb0UafaRKvN
	 KtNWlt6gqDk5k/vljVgWE+YZP21ceknYRRzMBR+evn3tsXeQpy8hYw3LW+cjP9kPaY
	 zoQId2lsRNpNA==
Date: Thu, 18 Jan 2024 15:41:49 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 12/12] xfs: use xfs_defer_alloc a bit more
Message-ID: <20240118234149.GN674499@frogsfrogsfrogs>
References: <20240115230113.4080105-1-david@fromorbit.com>
 <20240115230113.4080105-13-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115230113.4080105-13-david@fromorbit.com>

On Tue, Jan 16, 2024 at 09:59:50AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Noticed by inspection, simple factoring allows the same allocation
> routine to be used for both transaction and recovery contexts.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_defer.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 8ae4401f6810..6ed3a5fda081 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -819,7 +819,7 @@ xfs_defer_can_append(
>  /* Create a new pending item at the end of the transaction list. */
>  static inline struct xfs_defer_pending *
>  xfs_defer_alloc(
> -	struct xfs_trans		*tp,
> +	struct list_head		*dfops,
>  	const struct xfs_defer_op_type	*ops)
>  {
>  	struct xfs_defer_pending	*dfp;
> @@ -828,7 +828,7 @@ xfs_defer_alloc(
>  			GFP_KERNEL | __GFP_NOFAIL);
>  	dfp->dfp_ops = ops;
>  	INIT_LIST_HEAD(&dfp->dfp_work);
> -	list_add_tail(&dfp->dfp_list, &tp->t_dfops);
> +	list_add_tail(&dfp->dfp_list, dfops);
>  
>  	return dfp;
>  }
> @@ -846,7 +846,7 @@ xfs_defer_add(
>  
>  	dfp = xfs_defer_find_last(tp, ops);
>  	if (!dfp || !xfs_defer_can_append(dfp, ops))
> -		dfp = xfs_defer_alloc(tp, ops);
> +		dfp = xfs_defer_alloc(&tp->t_dfops, ops);
>  
>  	xfs_defer_add_item(dfp, li);
>  	trace_xfs_defer_add_item(tp->t_mountp, dfp, li);
> @@ -870,7 +870,7 @@ xfs_defer_add_barrier(
>  	if (dfp)
>  		return;
>  
> -	xfs_defer_alloc(tp, &xfs_barrier_defer_type);
> +	xfs_defer_alloc(&tp->t_dfops, &xfs_barrier_defer_type);
>  
>  	trace_xfs_defer_add_item(tp->t_mountp, dfp, NULL);
>  }
> @@ -885,14 +885,9 @@ xfs_defer_start_recovery(
>  	struct list_head		*r_dfops,
>  	const struct xfs_defer_op_type	*ops)
>  {
> -	struct xfs_defer_pending	*dfp;
> +	struct xfs_defer_pending	*dfp = xfs_defer_alloc(r_dfops, ops);
>  
> -	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
> -			GFP_KERNEL | __GFP_NOFAIL);
> -	dfp->dfp_ops = ops;
>  	dfp->dfp_intent = lip;
> -	INIT_LIST_HEAD(&dfp->dfp_work);
> -	list_add_tail(&dfp->dfp_list, r_dfops);
>  }
>  
>  /*
> -- 
> 2.43.0
> 
> 
