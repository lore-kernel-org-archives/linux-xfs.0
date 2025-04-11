Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA6F214228
	for <linux-xfs@vger.kernel.org>; Fri, 11 Apr 2025 15:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744385993; cv=none; b=W/xdEnXrJtajQcVRn/HySSsMEXDupIas8W6iiTvIETpwRt508ELfrZKr0xx0h3dvWWd/uAkl1Jq2Cyb/ms7afyCR9YpASS0IUUow6UK53WVN+u7IqOw2nJa+35jsPtaHnjMbTob1FBmV/azaxkKmZIMeOYXFHAkM6cJK/cMUSDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744385993; c=relaxed/simple;
	bh=Qn+LjOX2vTnM4oxZQ4rRHSYl5bCMu4NyMcmUj6w2XEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ul5/cJVoLSYmpbE+wJJybCVNGgqnpuXL8XVzaVVIILnpyll9GzJqNSjNXy1NWnghGZOVQoZOBegg/UlBHhjvJlh9nCSE3ubTzNwI+qqJ6cMWSOLrKvgtb0aMs9RCbfR6roUDn/cJhZXynlRUrnVzUMpqeSrhnpB8Ns13dSzhdFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TpPG6/QN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TpPG6/QN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B3FC4CEE7;
	Fri, 11 Apr 2025 15:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744385993;
	bh=Qn+LjOX2vTnM4oxZQ4rRHSYl5bCMu4NyMcmUj6w2XEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TpPG6/QNNJ2imGQsKL+ObujcfyeusauJpuh9t639kPbomGdGdMEODReF1dqWiZ2R/
	 LuEyh+wApdWEi0iHjBBy5EmKqPGmtZlK+fAsdWxBUqYnylFCSb222lovJsC2Qq7Y+e
	 y6+l6q/KBPfU4yiOFS2tFbTdEvJjcucrf2+fTfeMr8LiRT4WufJvJqTtNL0dwHkMwb
	 27gn6RS8MyCAzE9jMRwaN44PJMW/PtF45gELgeQIEjhgcpLLpOJZFeKTcowNcz6rGA
	 TcXgqu9Ov5JUakdj5kur6C9xHVyWzl0Uj4yxCmqflT8/n0kQ77mER1rRyMyTFHCZ3q
	 PxuU6EqaheFkw==
Date: Fri, 11 Apr 2025 08:39:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: liuhuan01@kylinos.cn
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] mkfs: fix the issue of maxpct set to 0 not taking
 effect
Message-ID: <20250411153952.GW6307@frogsfrogsfrogs>
References: <20250411071203.10598-1-liuhuan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250411071203.10598-1-liuhuan01@kylinos.cn>

On Fri, Apr 11, 2025 at 03:12:03PM +0800, liuhuan01@kylinos.cn wrote:
> From: liuh <liuhuan01@kylinos.cn>
> 
> If a filesystem has the sb_imax_pct field set to zero, there is no limit to the number of inode blocks in the filesystem.
> 
> However, when using mkfs.xfs and specifying maxpct = 0, the result is not as expected.
> 	[root@fs ~]# mkfs.xfs -f -i maxpct=0 xfs.img
> 	data     =               bsize=4096   blocks=262144, imaxpct=25
> 	         =               sunit=0      swidth=0 blks
> 
> The reason is that the condition will never succeed when specifying maxpct = 0. As a result, the default algorithm was applied.
> 	cfg->imaxpct = cli->imaxpct;
> 	if (cfg->imaxpct)
> 		return;
> 
> The result with patch:
> 	[root@fs ~]# mkfs.xfs -f -i maxpct=0 xfs.img
> 	data     =               bsize=4096   blocks=262144, imaxpct=0
> 	         =               sunit=0      swidth=0 blks
> 
> 	[root@fs ~]# mkfs.xfs -f xfs.img
> 	data     =               bsize=4096   blocks=262144, imaxpct=25
> 	         =               sunit=0      swidth=0 blks
> 
> Cc: <linux-xfs@vger.kernel.org> # v4.15.0
> Fixes: d7240c965389e1 ("mkfs: rework imaxpct calculation")
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: liuh <liuhuan01@kylinos.cn>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  mkfs/xfs_mkfs.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 3f4455d4..25bed4eb 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1048,13 +1048,13 @@ struct cli_params {
>  	int	data_concurrency;
>  	int	log_concurrency;
>  	int	rtvol_concurrency;
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
> @@ -4048,9 +4048,10 @@ calculate_imaxpct(
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
> @@ -5181,6 +5182,7 @@ main(
>  		.log_concurrency = -1, /* auto detect non-mechanical ddev */
>  		.rtvol_concurrency = -1, /* auto detect non-mechanical rtdev */
>  		.autofsck = FSPROP_AUTOFSCK_UNSET,
> +		.imaxpct = -1, /* set sb_imax_pct automatically */
>  	};
>  	struct mkfs_params	cfg = {};
>  
> -- 
> 2.43.0
> 
