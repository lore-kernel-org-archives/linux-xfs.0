Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B6E2DA74C;
	Tue,  2 Jun 2026 05:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780377286; cv=none; b=DdnCaZkmLfZkU2sxmfg9aKcdZuM7MeOYHdkuzMJyUufx6SJz3ITNEBreloPjnYWxsr2xHrNTnJvFFI23YeETG5h+JgKb6e/3o9s2sYBHDYreBqW2I6FiN8jHdrgmIk0boH6Ljgo3aTaeNzMx5/75GNNue0+55asD3vjxEKV/RUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780377286; c=relaxed/simple;
	bh=KtK8JEJskfiX8a7BFzhLXGtYeauqPna7pIVnZviTDQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uY/Nby8IdaOXPZt+bn1+2xajXorXQ1VPbvznDZM2W4lObBNwInRxjg+uGzdaB7EFw6yMjmkZzRAXYyjh+TqsHTJNDvdALeQ4HRMgdJOTWfSM60VtG83RT5VguIQed6ZR3WvHmsOkw5iK+W0dRu+qs7kxWvi13uZoj+THjaAr8zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TRkj2rZz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TRkj2rZz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C00591F00898;
	Tue,  2 Jun 2026 05:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780377284;
	bh=kS5fsvYjml1+e9wMSFvYCzlXUWwFcYXZRh8jYuW6b8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TRkj2rZzvX18AJbsl+7Vsl9s+f4IGbBrKBW5gEAuus/pXQqi7v+GTYr4gpERICUEF
	 IOPf5xVDDhvYS/KYGiJcmYUiy1JWUwkkAQlUjDzr8el947B3+FpKqio3FSrc+eVW77
	 Dr9mPlHzEr2NhQOanIuOVWmTUUozYai2+T4xCnAIcjVO3vNw3T04uL+RVS6J9p03Vf
	 tUltRlut6crr7JOT+CCoIkeM2RhgGN+UiZnqjQtTTUFhHK7XtZHF+sVSFkfagjTxmv
	 bR6N3GNcHHQKqC6NKq2ZAKNpGeE4Z3yJEow8+g1RYRe5WRZ40l06E1YnA1VMbCQiPm
	 j4liFjdAQqLYA==
Date: Mon, 1 Jun 2026 22:14:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: William Theesfeld <william@theesfeld.net>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: convert dquot iterator map allocation to
 kmalloc_array()
Message-ID: <20260602051444.GU6078@frogsfrogsfrogs>
References: <20260601191858.608270-1-william@theesfeld.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601191858.608270-1-william@theesfeld.net>

On Mon, Jun 01, 2026 at 03:18:57PM -0400, William Theesfeld wrote:
> Convert the open-coded kmalloc(n * sizeof(*p), ...) pattern in
> xfs_qm_dqiterate() to kmalloc_array(n, sizeof(*p), ...).  This matches
> the convention adopted across fs/xfs/ in commit 910bbdf2f4dXX ("xfs:
> convert buf_cancel_table allocation to kmalloc_array") and is the only
> remaining instance of the old pattern in fs/xfs/.
> 
> No functional change.  XFS_DQITER_MAP_SIZE is a compile-time constant
> (10) so the runtime overflow check added by kmalloc_array() folds away;
> the conversion is for consistency and to keep fs/xfs/ free of the
> deprecated form.
> 
> Signed-off-by: William Theesfeld <william@theesfeld.net>

Macros these days...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_qm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 7bd15d9e7..eebdeb181 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1170,7 +1170,7 @@ xfs_qm_reset_dqcounts_buf(
>  	if (qip->i_nblocks == 0)
>  		return 0;
>  
> -	map = kmalloc(XFS_DQITER_MAP_SIZE * sizeof(*map),
> +	map = kmalloc_array(XFS_DQITER_MAP_SIZE, sizeof(*map),
>  			GFP_KERNEL | __GFP_NOFAIL);
>  
>  	lblkno = 0;
> -- 
> 2.54.0
> 
> 
