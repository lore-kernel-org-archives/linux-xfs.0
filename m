Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E89192B94
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jan 2025 16:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737736741; cv=none; b=KLW1rIIIvXrQOmt9nckf+4m1hmQqECD7FUGQtAXko29cb/56gjU5+X674TO425o70DeEawFHcr0SESdZqBYA1oikuEy9zs2uFdIlg42GxMcFs5Ohko3TwaAhDNYP5dCfQFiGlKmFzlq0HCjWgJnZ4896nUsnw8XwDPj8uTSo7cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737736741; c=relaxed/simple;
	bh=vrL1feqAzMfboazFwLVKaMu3Ow8k40j9dMpR8nfBRkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cWYih0Qkdf15lTsziFgByWPyr/V7jMf/KilaKU+qxeEJqqNkfWumRvTXCLXbTxP1fJEEcvSVcx/6taSJWMD1c21Vu7VFOEO6ADl6fBK1FbgsQQUrMR0GhOowuCInIXh+mw++q7YuaTtpa7Z0pQHHTUQLJFMLfTOp4RpM5dPLV9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RAD3P76L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RAD3P76L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68798C4CED2;
	Fri, 24 Jan 2025 16:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737736740;
	bh=vrL1feqAzMfboazFwLVKaMu3Ow8k40j9dMpR8nfBRkE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RAD3P76LDLbFNw4AiDUAEK8wA0grEY6QN6xDuL1I99IfTv5oTWKbWobN8hBPneZFZ
	 CivxGEOecqNY1Fel9c7MAVtpQ/7uQgxMDBlfZWGYaWMCxLer7RcaK/39hUdRiPPhDa
	 44UzKLWkT3y06gbSJ1qLTOWiICxZuu5oGsEFJqdQGKob39wr3zhIjgMLjHZrjq54Oe
	 ccKRRQEjG6IdEy4nfGVdLxvp0i5dkVZDZRT/j7bPMNGjCx/Mi3Jq0AvDGPNXrtaytq
	 X/F68oxepbgoW7/LQXaRuMPfMSqmg/O3t05IgW724EyAHmWFIq7TOdfFfp41GNM7MH
	 pjirXEk80el6w==
Date: Fri, 24 Jan 2025 08:38:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: liuhuan01@kylinos.cn
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] mkfs: fix the issue of maxpct set to 0 not taking
 effect
Message-ID: <20250124163859.GH1611770@frogsfrogsfrogs>
References: <20250124065510.11574-1-liuhuan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250124065510.11574-1-liuhuan01@kylinos.cn>

On Fri, Jan 24, 2025 at 02:55:10PM +0800, liuhuan01@kylinos.cn wrote:
> From: liuh <liuhuan01@kylinos.cn>
> 
> It does not take effect when maxpct is specified as 0.

Style note: Please don't start the first sentence of the first paragraph
with "It".  Introduce what you're talking about, e.g.

"If a filesystem has the sb_imax_pct field set to zero, there is no
limit to the number of inode blocks in the filesystem."

> Firstly, the man mkfs.xfs shows that setting maxpct to 0 means that all of the filesystem can become inode blocks.
> However, when using mkfs.xfs and specifying maxpct = 0, the result is not as expected.
>         [root@fs ~]# mkfs.xfs -f -i maxpct=0 xfs.img
>         data     =                       bsize=4096   blocks=262144, imaxpct=25
>                  =                       sunit=0      swidth=0 blks
> 
> The reason is that the judging condition will never succeed when specifying maxpct = 0. As a result, the default algorithm was applied.
>     cfg->imaxpct = cli->imaxpct;
>     if (cfg->imaxpct)
>         return;
> It's important that maxpct can be set to 0 within the kernel xfs code.
> 
> The result with patch:
>         [root@fs ~]# mkfs.xfs -f -i maxpct=0 xfs.img
>         data     =                       bsize=4096   blocks=262144, imaxpct=0
>                  =                       sunit=0      swidth=0 blks
> 
>         [root@fs ~]# mkfs.xfs -f xfs.img
>         data     =                       bsize=4096   blocks=262144, imaxpct=25
>                  =                       sunit=0      swidth=0 blks
> 
> Signed-off-by: liuh <liuhuan01@kylinos.cn>

Bugfixes really ought to have a fixes tag, even for xfsprogs.

> ---
>  mkfs/xfs_mkfs.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 956cc295..f4216000 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1034,13 +1034,13 @@ struct cli_params {
>  	int	proto_slashes_are_spaces;
>  	int	data_concurrency;
>  	int	log_concurrency;
> +	int	imaxpct;
>  
>  	/* parameters where 0 is not a valid value */
>  	int64_t	agcount;
>  	int64_t	rgcount;
>  	int	inodesize;
>  	int	inopblock;
> -	int	imaxpct;
>  	int	lsectorsize;
>  	uuid_t	uuid;
>  
> @@ -3834,9 +3834,10 @@ calculate_imaxpct(
>  	struct mkfs_params	*cfg,
>  	struct cli_params	*cli)
>  {
> -	cfg->imaxpct = cli->imaxpct;
> -	if (cfg->imaxpct)
> +	if (cli->imaxpct >= 0) {
> +		cfg->imaxpct = cli->imaxpct;
>  		return;
> +	}
>  
>  	/*
>  	 * This returns the % of the disk space that is used for
> @@ -4891,6 +4892,7 @@ main(
>  		.data_concurrency = -1, /* auto detect non-mechanical storage */
>  		.log_concurrency = -1, /* auto detect non-mechanical ddev */
>  		.autofsck = FSPROP_AUTOFSCK_UNSET,
> +		.imaxpct = -1,

Might want to leave a comment about what -1 means?

		.imaxpct = -1, /* set sb_imax_pct automatically */

With those bits cleaned up and this added:

Cc: <linux-xfs@vger.kernel.org> # v4.15.0
Fixes: d7240c965389e1 ("mkfs: rework imaxpct calculation")

You can add:
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


>  	};
>  	struct mkfs_params	cfg = {};
>  
> -- 
> 2.43.0
> 
> 
