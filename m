Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5034137932
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 16:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737046730; cv=none; b=XxBZ5qb0GNYBlqfuCa2WyQBBv7nugbEeZG7aecgJQGAfLGouAc8huUTnEK5U6dAV44HQF6mPk02c5P2fzs7nB4lkVszrx8H5ijL95986ZSzL4TL2qZtl/4GeJn3vqdPMLcDF8oeMExSmdCDQdFyLjv23qTdH3AnZ4Uh+FOO3nvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737046730; c=relaxed/simple;
	bh=Tkfr5HgW6x+wUwjWTuUi4SgqdN3nXXsOoRmJnf+5euY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O6TzUaA6KJeLSIFb6pmx9Nbj2QQzMcbBsX3cILOHj47qYogs8OKfODVOkUH0OfbRCA9VX0ApY9NMqm9fDtO4qtvNIDf5k5tWCcsMMtY8MB4uPSYUCcpjZsfWlPspf8y30Kt5RQNK4GfkA4Ps7jY3r1FNpT6juolFbEmvhYSnjlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HDY5jqga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HDY5jqga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BCAC4CED6;
	Thu, 16 Jan 2025 16:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737046730;
	bh=Tkfr5HgW6x+wUwjWTuUi4SgqdN3nXXsOoRmJnf+5euY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HDY5jqga0eJQccjq1jNpLYr+ZHMUbnk/WTJR8IC/K01PElSXtwETgqud88zJym+qo
	 4X6yMAqj8kyhB7k00kbyPu0cJbMjX4LrSlokkuVIZcAlVJYANA9PzQlveRgCtIyl6H
	 DnUZDJkohmkXvjwC2czSUQY3M3e29Cc1DfxOd+KviXk9ZhJYxVxfWyapldesyGOoB8
	 uFDT8icv2eiO+RF5KpYJoCzIA02zSHzKc7kPmJ313HWsNMQHFxVEI/4D+zMyuPeoT1
	 W7NtsXK453m/nXJToo1k+YYD1Zxi+FAPr6tzvuSE7Ru6euiCTBV8QEfO6sDKKfAu9k
	 naZHhXmt0Z1EA==
Date: Thu, 16 Jan 2025 08:58:49 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove an out of data comment in _xfs_buf_alloc
Message-ID: <20250116165849.GH3566461@frogsfrogsfrogs>
References: <20250116060335.87426-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250116060335.87426-1-hch@lst.de>

On Thu, Jan 16, 2025 at 07:03:35AM +0100, Christoph Hellwig wrote:
> There hasn't been anything like an io_length for a long time.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yep, that old comment doesn't make much sense anymore
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index dc219678003c..af3945bf7d94 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -241,11 +241,6 @@ _xfs_buf_alloc(
>  	bp->b_mount = target->bt_mount;
>  	bp->b_flags = flags;
>  
> -	/*
> -	 * Set length and io_length to the same value initially.
> -	 * I/O routines should use io_length, which will be the same in
> -	 * most cases but may be reset (e.g. XFS recovery).
> -	 */
>  	error = xfs_buf_get_maps(bp, nmaps);
>  	if (error)  {
>  		kmem_cache_free(xfs_buf_cache, bp);
> -- 
> 2.45.2
> 
> 
