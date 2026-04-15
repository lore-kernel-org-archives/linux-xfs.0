Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4BB625;
	Wed, 15 Apr 2026 00:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776211404; cv=none; b=okQm8jFlnv92gC96lgek4TejvSoKQDhInemH13Ez0WvCSvNC10GEeL+dRdOqp7nqt9m5VCWj1E77IZTrFH8sKm1jABT365U1nvLVZDK8xbnMin/tZ3MxFw9najkG41ggyhDlWp0rGciPfXse70AOURF2DZCM9VFp2uwpzSE/yiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776211404; c=relaxed/simple;
	bh=Ev//JqfFMRG9+0PqDd9D5jkfoTKGA5K4YfBNRfYha34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uVbkQXZUAaL5mZiR1mCIzNjFuPcPVlVMLgxLncS8BuTQt7ZPKodxeFjYcUbjnayHXLnKS6VyBMSiRblRndk0G//BrxskRRZ6GQ7VHEptCKpgPivhw6XJ8uh8O5wPGeYfCwt+0cpEyed1QiraNVsOCBb/4bNwu2uaFsM7vAstxTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JjPHU9PB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JjPHU9PB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF809C19425;
	Wed, 15 Apr 2026 00:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776211404;
	bh=Ev//JqfFMRG9+0PqDd9D5jkfoTKGA5K4YfBNRfYha34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JjPHU9PB21L2GB27Vdkr4ORuAK0mgeOuaKe3zXochL/RdhCtKMSkuaGVVKT5WQ2rI
	 3Udzl4Dm8gPbEuOjfCspl2lfG4VoD7g9y/JxfCLU24NBd3kLa01lb6WpuXfi2zs97G
	 HHB4n2DjTSnUr/k0qwaUMEe+IxZmZpcNk0NhPmU1RWhGt1ROtYaAvVedslN1RPs1x/
	 bg7UPIEPvPzAqFhzZFfkrdKcGQ0gjniTtFCzmqr1EPZT37LpnMmUMD24njszCRBpCk
	 Knd3x2dsiWsGP/BrpB4ZxkJ5U4xKfPQtJSMTm6Vke1xuuC4ilIMzf/C3k0AyRFcAaJ
	 qb+FksEcvg1bQ==
Date: Tue, 14 Apr 2026 17:03:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>, stable@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2] xfs: fix memory leak on error in xfs_alloc_zone_info()
Message-ID: <20260415000323.GC150005@frogsfrogsfrogs>
References: <20260414234513.1457961-2-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414234513.1457961-2-wilfred.opensource@gmail.com>

On Wed, Apr 15, 2026 at 09:45:14AM +1000, Wilfred Mallawa wrote:
> From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> 
> Currently, the 0th index of the zi_used_bucket_bitmap array is not freed
> on error due to the pre-decrement then evaluate semantic of the while
> loop used in xfs_alloc_zone_info(). Fix it by allowing for the i == 0
> case to be covered.
> 
> Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
> Cc: stable@vger.kernel.org

Cc: <stable@vger.kernel.org> # v6.15

(autobackport plz, I need all the help I can get)

> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> ---
>  fs/xfs/xfs_zone_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index a851b98143c0..c64f9ab743a6 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -1217,7 +1217,7 @@ xfs_alloc_zone_info(
>  	return zi;
>  
>  out_free_bitmaps:
> -	while (--i > 0)
> +	while (--i >= 0)

With the git trailer amended,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  		kvfree(zi->zi_used_bucket_bitmap[i]);
>  	kfree(zi);
>  	return NULL;
> -- 
> 2.53.0
> 
> 
