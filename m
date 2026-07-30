Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF59E43C04B;
	Thu, 30 Jul 2026 15:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426687; cv=none; b=XUCQIrIVjgwx2F0bx3Yz6BnJVu6NVWXFEEDjWqVGFoNUOhJQMJTPBJRnTtdBoimnyZU/UGzuWOsvHEn/tO7M7A19wfkG5yrwzbYJjtNQafWwK7RR6RWp0r1wFwXqg6lO+Y0emD0hhaGhTiaXq4bhCjSE4KUM8lTiQxnfP/5Vuns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426687; c=relaxed/simple;
	bh=i5SxLcGX370H8rMqdiNzVshT5WOmwPZiEWHQSCCHLvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sg9tutknfZmGO4PREq9LuwVJWUA83Pp59em7TTmR4X/Lyb1VRfg0yqEDRr3VRL1m3XSY5F11ZCS+dOpg2XWTwtLBWTCEWbSV7p4S1eiSlAGarXw4sj9R5lXoEqpwqN1RUHOrzq86Zlj0RvZJA2YtC2KNKn+w2O+Q0e/YoubtJE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DTCaQh8w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DTCaQh8w"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BA48D1F000E9;
	Thu, 30 Jul 2026 15:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785426685;
	bh=VCJsv9KC5Ka+Fy2imKetC9rTxJ6152x6+usqg3nFdwM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DTCaQh8wYnPqtVoYbJB8i/07Pc9wzs8CFUJFjDIctQiZD8AxRbKcDZ3wQmoVSO0k+
	 t0o643KOE//42eQ36RIkntKWXcXa5mfrIkng9XmsNrc5K+pY6VXQFZlICBrgyQvCUK
	 5Swx6a9yLVML0ihBdjW3X+e4/GEq1v00miM6xWRgjwrVwKnPO8z1VcrQhqGwLMR3Q6
	 uQpbp8GUSLwxaVvJPJVqpjCGVMri3duYw4M9jLMx8akq7gjgMLIkjRZlbL8xdNISpo
	 l/KKSSOm22ed8bQhlFJ7gbLFF1dAi6NF/KkqBScSVwUeNudNVig3ArD+K2znv5OLXy
	 tE3vC9Jss44kg==
Date: Thu, 30 Jul 2026 08:51:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] xfs: restore nofs context unconditionally in
 xfs_trans_roll
Message-ID: <20260730155125.GE3556460@frogsfrogsfrogs>
References: <20260730093002.1034320-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730093002.1034320-1-yun.zhou@windriver.com>

On Thu, Jul 30, 2026 at 05:30:02PM +0800, Yun Zhou wrote:
> When __xfs_trans_commit() fails in xfs_trans_roll(), the NOFS context
> is cleared but only restored in the success path.  This leaves the
> error path without nofs protection, causing a circular lock dependency
> between xfs_nondir_ilock_class and fs_reclaim:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&xfs_nondir_ilock_class);
>                                lock(fs_reclaim);
>                                lock(&xfs_nondir_ilock_class);
>   lock(fs_reclaim);
> 
> Fix this by moving xfs_trans_set_context() before the error check so
> that nofs context is always restored on the new transaction.
> 
> Reported-by: syzbot+59178abfeb0ea3f0ab20@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=59178abfeb0ea3f0ab20
> Fixes: a1ca658d649a ("xfs: fix incorrect context handling in xfs_trans_roll")
> Cc: stable@vger.kernel.org
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> v3:
>   - Change back to v1
> 
> v2:
>   - Instead of moving xfs_trans_set_context() before the error check,
>     transfer the nofs context in xfs_trans_dup() via a new
>     memalloc_flags_move() helper, as suggested by Darrick.
>   - Change t_pflags from unsigned long to unsigned int to match mm API.
> 
> v1: https://lore.kernel.org/all/20260713035505.1635191-1-yun.zhou@windriver.com/T/
> 
>  fs/xfs/xfs_trans.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 7bfbd9f6f0df..1b36cf12d4e3 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1029,6 +1029,15 @@ xfs_trans_roll(
>  	 * duplicate transaction that gets returned.
>  	 */
>  	error = __xfs_trans_commit(tp, true);
> +
> +	tp = *tpp;
> +	/*
> +	 * __xfs_trans_commit cleared the NOFS flag by calling into
> +	 * xfs_trans_free.  Set it again here before doing memory
> +	 * allocations.
> +	 */
> +	xfs_trans_set_context(tp);
> +
>  	if (error)
>  		return error;
>  
> @@ -1040,13 +1049,6 @@ xfs_trans_roll(
>  	 * either nothing be locked across this call, or that anything that is
>  	 * locked be logged in the prior and the next transactions.
>  	 */
> -	tp = *tpp;
> -	/*
> -	 * __xfs_trans_commit cleared the NOFS flag by calling into
> -	 * xfs_trans_free.  Set it again here before doing memory
> -	 * allocations.
> -	 */
> -	xfs_trans_set_context(tp);
>  	error = xfs_log_regrant(tp->t_mountp, tp->t_ticket);
>  	if (error)
>  		return error;
> -- 
> 2.43.0
> 
> 
