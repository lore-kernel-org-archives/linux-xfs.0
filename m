Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26674383C80
	for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2026 15:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775489189; cv=none; b=FqcsdKMHndsGQtAOI4/cNzkVDUM9MftR0A/JcjmqNNrDoZDTHmuqBqQBNBqSS4iyEOAI2HvEF/7P+ls0z7oBxAlwxskiQ1Z8GrJWY4sOyvuNxe/JUudjhsS123abrcSxFfdtAmGsNzZJSyb1TcL6hzj4bkd9T5YGKYzsih0q3yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775489189; c=relaxed/simple;
	bh=aQx8DD6bLa6F9GeiKVhyE8ZjI7HQUxoQsN1NhWezOQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hmazEdDvlyZkSA5j1v7zq1fCI93+4aLQ5VlSGu5+IM/TxOuBsca5omF0L1PNzzFRTczywdjdo8lyG2G5d4M+ElDZiKJXcvnQlso78pdz4573+59A6uMbs28x6P8LkOMyvP+XhnNZ3LkXibKtdBabFohBa+qXEooxswTmGm0bgKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M9UkzeKg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M9UkzeKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AA7C4CEF7;
	Mon,  6 Apr 2026 15:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775489188;
	bh=aQx8DD6bLa6F9GeiKVhyE8ZjI7HQUxoQsN1NhWezOQM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M9UkzeKgfu5a5WhpbNNeTKamLRzxU6z+IhumpcQkjqz31mpfYPVex4qbpe/F6Wy4I
	 ZHYejqkHK5gqL8TGFjCFUQYlgFMqCYWrju9WD1jl53vyru6d/nxKtIUQcAOHOSnSgx
	 Au/KjnnnFs1vIi37yt0e4DArAUabrTlDxhkbWU22qXDqiO+Z4HibDgJrKHKuZAflsq
	 p8GO1MzhGWn34yRc1+m2e/6AQ/AJIO8AfTBGPwFM3TvSTyX+2pl8kPep9Vl7vgP2xf
	 Ao8qrSr4mCzMaiffuUSBVf/TSbadBKwfHUxjw4pbRJiSZoC7X/4XBEub/Q+7O/60eP
	 nOxPLzBkhe+Og==
Date: Mon, 6 Apr 2026 08:26:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/2] mkfs: fix assertion failure on empty data file
Message-ID: <20260406152628.GC1048989@frogsfrogsfrogs>
References: <20260404163640.1013997-1-zlang@kernel.org>
 <20260404163640.1013997-2-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260404163640.1013997-2-zlang@kernel.org>

On Sun, Apr 05, 2026 at 12:36:39AM +0800, Zorro Lang wrote:
> mkfs.xfs triggers an assertion failure, when it trys to make a xfs
> on an empty file:
>   # echo > emptyfile
>   # mkfs.xfs emptyfile
>   mkfs.xfs: xfs_mkfs.c:3852: validate_datadev: Assertion `cfg->dblocks' failed.
>   Aborted                    (core dumped) mkfs.xfs emptyfile
> 
> This shouldn't be an assertion, but a warning.
> 
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
>  mkfs/xfs_mkfs.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 527a662f..9a93330f 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3848,8 +3848,13 @@ validate_datadev(
>  		if (!xi->data.isfile) {
>  			fprintf(stderr, _("can't get size of data subvolume\n"));
>  			usage();
> +		} else {
> +			if (!cli->dsize) {
> +				fprintf(stderr,
> +_("Warning: Empty file needs a data subvolume size by -d size=<value> option\n"));

I'm not sure why "Warning" is appropriate here -- this error is fatal to
the program, and most fatal mkfs error messages don't have a prefix.

Other than that, the logic is sound that we need a softer landing for
this scenario.

--D

> +				usage();
> +			}
>  		}
> -		ASSERT(cfg->dblocks);
>  	} else if (cfg->dblocks) {
>  		/* check the size fits into the underlying device */
>  		if (cfg->dblocks > DTOBT(xi->data.size, cfg->blocklog)) {
> -- 
> 2.52.0
> 
> 
