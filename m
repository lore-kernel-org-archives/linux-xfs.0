Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF8E3A1D3
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 12:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CtA8odgo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1637C433C8;
	Mon, 18 Dec 2023 12:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702904029;
	bh=T8RHqMMTHdxiRDeZhKcpTEUjL7tMnZmonN5V6+kwfNA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CtA8odgoNqyO5QIMercrTbcY1A6VStD982824IsWA5L5eRAzQORv/oOtbXESYlq30
	 923zqBDsAbK3/3QpAUVERqwWsRMsTHJARcUewdZA+x2x493heEljxmQDrN6r4EmU4s
	 ZEkgpRw07u6MEcXtI9IUFMBZQGiLXV6UMI8V+DymP3dihObx1nvIFksTxVXZidQNZ3
	 Szf1QdO02lm2eFOam8sd1gHLYynQiTa46z0Swv45f+UKlo70BY8+DUPUWWUJitBxMu
	 LLjY//AjFBRwJYd+N0rPg8EEWzU+umXcIEjQa9xuhWXRYhKMlLoTn/uYnq6v55qp47
	 Wmb2v1poArCzA==
Date: Mon, 18 Dec 2023 13:53:45 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/23] libxfs: pass the device fd to discard_blocks
Message-ID: <hjkwlj5pgxeqcs4yydr7vosmon4vhlihmwuef5kuucbcknhjy4@ujh6jiea74ro>
References: <20231211163742.837427-1-hch@lst.de>
 <yUFF-dRzKgf_HkBLpJ7VM7WgqK5u5E0Ivu0bkngihoEji-0gBhFoZPFw7YwKJDVyHSn6Qm965Wn7mQq6NpNWrQ==@protonmail.internalid>
 <20231211163742.837427-21-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-21-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:39PM +0100, Christoph Hellwig wrote:
> No need to do a dev_t to fd lookup when the caller already has the fd.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  mkfs/xfs_mkfs.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index dd5f4c8b6..01c6ce33b 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1325,19 +1325,15 @@ done:
>  }
> 
>  static void
> -discard_blocks(dev_t dev, uint64_t nsectors, int quiet)
> +discard_blocks(int fd, uint64_t nsectors, int quiet)
>  {
> -	int		fd;
>  	uint64_t	offset = 0;
>  	/* Discard the device 2G at a time */
>  	const uint64_t	step = 2ULL << 30;
>  	const uint64_t	count = BBTOB(nsectors);
> 
> -	fd = libxfs_device_to_fd(dev);
> -	if (fd <= 0)
> -		return;
> -
> -	/* The block discarding happens in smaller batches so it can be
> +	/*
> +	 * The block discarding happens in smaller batches so it can be
>  	 * interrupted prematurely
>  	 */
>  	while (offset < count) {
> @@ -2875,11 +2871,11 @@ discard_devices(
>  	 */
> 
>  	if (!xi->disfile)
> -		discard_blocks(xi->ddev, xi->dsize, quiet);
> +		discard_blocks(xi->dfd, xi->dsize, quiet);
>  	if (xi->rtdev && !xi->risfile)
> -		discard_blocks(xi->rtdev, xi->rtsize, quiet);
> +		discard_blocks(xi->rtfd, xi->rtsize, quiet);
>  	if (xi->logdev && xi->logdev != xi->ddev && !xi->lisfile)
> -		discard_blocks(xi->logdev, xi->logBBsize, quiet);
> +		discard_blocks(xi->logfd, xi->logBBsize, quiet);
>  }
> 
>  static void
> --
> 2.39.2
> 
