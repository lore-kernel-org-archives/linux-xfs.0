Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB902343C2;
	Tue, 10 Jun 2025 14:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749567543; cv=none; b=pj2DF+f7B4A5d6BQG+h9faflKBWpzOzEb8fuLtzwjafCz1HV+e5yT5Rs6vp1CurchFmySoPjfgdmJM+m327j2lh917fd9f+/mNkJs07fgwVlKefsn1WWLX8pBbZe5l8tUsnrIdYl8UscSd+YYEFpcZm5IcOMnXLi+RV2o+atLXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749567543; c=relaxed/simple;
	bh=RtVMpaUvCCDkSrVf1BrG11vGSltOr69qaJgSRF/MXio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ds1V7kL2tUtSrAQjfXHb0PwDg5WlTnTEeuOxz/SNNV8BjBBd/oDsF91kpLtlRerP+oXIVI705UuGWunJh05Qtp+9ugp81Icm/QDBhzEqG0Bmp+a5AcC9Y1zJR/ArJKkCga7RU2hJsSTOQZXSwWS95YupL3IX1QBk5/N4CvMAg9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LITIp3qv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LITIp3qv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25471C4CEED;
	Tue, 10 Jun 2025 14:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749567543;
	bh=RtVMpaUvCCDkSrVf1BrG11vGSltOr69qaJgSRF/MXio=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LITIp3qvzL8m0QdLoolqhHcelMwyTqQnkbG9PcEs/aKIoNNu64Pjr+LiGHBgiIDOD
	 324u6yPGBr5F/FEAbun7j9udzD7fPRmhORGZlNqjItLEQmFLZMiSAnqwhTuvBJkRgl
	 4T6c53TXBaOmwHdY64/aBi9n/a7wJNp2Oo1ruka1o3wqMsyDGg5N9r5cUVhTTeqC7k
	 lhqi1QfzYGFIDdMyPVUvsS5snkFgMhZK5wxAyWtFx5RDjZsRPAT5+xBJ8h937zYgoD
	 msh9994HtRGDAZmxTA/J8T6a2xWvhQsrHVaJt/99FJhfpxA4NC8BHzPiGDU7pRi2Pl
	 3s2/ofmJFZklA==
Date: Tue, 10 Jun 2025 07:59:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH] xfs: Improve error handling in xfs_mru_cache_create()
Message-ID: <20250610145902.GN6156@frogsfrogsfrogs>
References: <b182b740-e68d-4466-a10d-bcb8afb2453a@web.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b182b740-e68d-4466-a10d-bcb8afb2453a@web.de>

On Tue, Jun 10, 2025 at 03:00:27PM +0200, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 10 Jun 2025 14:50:07 +0200
> 
> Simplify error handling in this function implementation.
> 
> * Delete unnecessary pointer checks and variable assignments.
> 
> * Omit a redundant function call.
> 
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_mru_cache.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
> index 08443ceec329..2ed679a52e41 100644
> --- a/fs/xfs/xfs_mru_cache.c
> +++ b/fs/xfs/xfs_mru_cache.c
> @@ -320,7 +320,7 @@ xfs_mru_cache_create(
>  	xfs_mru_cache_free_func_t free_func)
>  {
>  	struct xfs_mru_cache	*mru = NULL;
> -	int			err = 0, grp;
> +	int			grp;
>  	unsigned int		grp_time;
>  
>  	if (mrup)
> @@ -341,8 +341,8 @@ xfs_mru_cache_create(
>  	mru->lists = kzalloc(mru->grp_count * sizeof(*mru->lists),
>  				GFP_KERNEL | __GFP_NOFAIL);
>  	if (!mru->lists) {
> -		err = -ENOMEM;
> -		goto exit;
> +		kfree(mru);
> +		return -ENOMEM;
>  	}
>  
>  	for (grp = 0; grp < mru->grp_count; grp++)
> @@ -361,14 +361,7 @@ xfs_mru_cache_create(
>  	mru->free_func = free_func;
>  	mru->data = data;
>  	*mrup = mru;
> -
> -exit:
> -	if (err && mru && mru->lists)
> -		kfree(mru->lists);
> -	if (err && mru)
> -		kfree(mru);
> -
> -	return err;
> +	return 0;
>  }
>  
>  /*
> -- 
> 2.49.0
> 
> 
