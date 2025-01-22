Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3035914F9F9
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 06:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737529193; cv=none; b=IispzM9QhsshLXgtiQIP6obA3hdJC6F15bEQQ62ClWXkjGPaYRvuCgEccXM/LG9AUUhYiuJQMfz3CcJTFxEVPNSjSwSB++cXsnHX7rzRW9931oIlB/FNd0+J2pjezK3A+d2aqDERWSVK8yzilOD1R4ajhx82Xc+LUbqB/ukqjCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737529193; c=relaxed/simple;
	bh=mKQF16JI5f0bk/OQVRBD165B8T4LCdYYdfUIkdl5VmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oKLGnNhiqTkD89MVH9+CY76pRUBRNeVYv1QSbwLKAXFGx0B4XVl8UK5IqWhQQEvdAGm3LpJkfIf9KrcuzmCKObV7WRQ0tKiy63gsjgGBojsepskhYmo/C3CkUGQEPcQ2e56baQBwCS81kdA1d6V50oWq9UMBUYXfGd/cMV99SBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SHfDVHE2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SHfDVHE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE49C4CEE2;
	Wed, 22 Jan 2025 06:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737529192;
	bh=mKQF16JI5f0bk/OQVRBD165B8T4LCdYYdfUIkdl5VmQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SHfDVHE2gO6FoqDR2g4gfg/0EMtcH+IxMctumRzAoClixb92lgFtHV3mJKBE1KcZ7
	 nCdcVmIefu7T/6QMIsVrZP5ug+crp7SaTIwkxfOmUcY2dO66QMeV+uXJvrglBVyk8p
	 Cd8o1j+MWDWwwEDOyN1LWsK/7ZMpdCTbaRbjKtapJlyK0Xk4NcVO1B56UBVBlpVAkP
	 NS7O8vpWYCmQ0E2uCnYrLCWJi4PJJstMnCImZEXkk2UphrznkYACA2SYtKzW0NwS6b
	 y+r1D/E87VhgTRT0hdYiksxJ4MyYzXYk0oZCHIENcRVwtnxOybBbY+14/EFJw0ToSr
	 OCHp04zF9bs3A==
Date: Tue, 21 Jan 2025 22:59:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: liuhuan01@kylinos.cn
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1] mkfs: fix the issue of maxpct set to 0 not taking
 effect
Message-ID: <20250122065951.GB1611770@frogsfrogsfrogs>
References: <20250122053505.156729-1-liuhuan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122053505.156729-1-liuhuan01@kylinos.cn>

On Wed, Jan 22, 2025 at 01:35:05PM +0800, liuhuan01@kylinos.cn wrote:
> From: liuh <liuhuan01@kylinos.cn>
> 
> It does not take effect when maxpct is specified as 0.
> 
> Firstly, the man mkfs.xfs shows that setting maxpct to 0 means that all of the filesystem can become inode blocks.
> However, when using mkfs.xfs and specifying maxpct = 0, the result is not as expected.
> 	[root@fs ~]# mkfs.xfs -f -i maxpct=0 xfs.img
> 	data     =                       bsize=4096   blocks=262144, imaxpct=25
>         	 =                       sunit=0      swidth=0 blks
> 
> The reason is that the judging condition will never succeed when specifying maxpct = 0. As a result, the default algorithm was applied.
>     cfg->imaxpct = cli->imaxpct;
>     if (cfg->imaxpct)
>         return;
> It's important that maxpct can be set to 0 within the kernel xfs code.
> 
> The result with patch:
> 	[root@fs ~]# mkfs.xfs -f -i maxpct=0 xfs.img
> 	data     =                       bsize=4096   blocks=262144, imaxpct=0
>         	 =                       sunit=0      swidth=0 blks
> 
> Signed-off-by: liuh <liuhuan01@kylinos.cn>
> ---
>  mkfs/xfs_mkfs.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 956cc295..6f0275d2 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1034,13 +1034,14 @@ struct cli_params {
>  	int	proto_slashes_are_spaces;
>  	int	data_concurrency;
>  	int	log_concurrency;
> +	int	imaxpct;
> +	int	imaxpct_using_default;
>  
>  	/* parameters where 0 is not a valid value */
>  	int64_t	agcount;
>  	int64_t	rgcount;
>  	int	inodesize;
>  	int	inopblock;
> -	int	imaxpct;

Why not set imaxpct to -1 when we initialize cfg in main() and then do
something like this in calculate_imaxpct():

	if (cli->imaxpct >= 0) {
		cfg->imaxpct = cli->imaxpct;
		return;
	}

	/* existing 5% - 25% default calculation */

Instead of declaring extra variables?

Also, regression test needed here...

--D

>  	int	lsectorsize;
>  	uuid_t	uuid;
>  
> @@ -1826,6 +1827,7 @@ inode_opts_parser(
>  		break;
>  	case I_MAXPCT:
>  		cli->imaxpct = getnum(value, opts, subopt);
> +		cli->imaxpct_using_default = false;
>  		break;
>  	case I_PERBLOCK:
>  		cli->inopblock = getnum(value, opts, subopt);
> @@ -3835,7 +3837,7 @@ calculate_imaxpct(
>  	struct cli_params	*cli)
>  {
>  	cfg->imaxpct = cli->imaxpct;
> -	if (cfg->imaxpct)
> +	if (!cli->imaxpct_using_default)
>  		return;
>  
>  	/*
> @@ -4891,6 +4893,7 @@ main(
>  		.data_concurrency = -1, /* auto detect non-mechanical storage */
>  		.log_concurrency = -1, /* auto detect non-mechanical ddev */
>  		.autofsck = FSPROP_AUTOFSCK_UNSET,
> +		.imaxpct_using_default = true,
>  	};
>  	struct mkfs_params	cfg = {};
>  
> -- 
> 2.43.0
> 
> 
