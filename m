Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E914457A6
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788434046; cv=none; b=eJyf28B81FcFXbkeu78ud3Jt5Zp6fuSVEe5aeK/VOdxmhZNRNSRIVVu7FLkszoewwa8Wd3JWh/UDAzNTOkdYtWrYSxfDME50dS+/AHu4tbVsaV6uKqidEpdLR70gUVOI0vN8T5BI1R9gw9JaviqeGFazCVy+tiQXp6z+OIp39Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788434046; c=relaxed/simple;
	bh=gT36V3j6KEKJk8QgSLYqjSbRO/avz8Sspf5lphiYTW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=opv8lCBDU2EsHyvkG0jpSE8oZU4FXFPYj6upuczriFYhwgPf7NvGmufcU9isXhbGZhylQI2qb4NEkxri+o59m43Oo0ciME0VmmOkmrRe9sp3n6BHl9bQlWdFs/CwYIe7Kgyov8Zpj26LG9Kz0pr2cIWtwbpyx3+lhHPEVR8aGx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iA7i8FI9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iA7i8FI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7D91F000E9;
	Thu,  3 Sep 2026 11:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788434044;
	bh=TV8SRXyskbnkI72ncZcBuSOW6UvlJpOnZrLYMO33sVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iA7i8FI9qdR6iVcHuSJNgBeE/hQ5OP/QVwe994UEHZ8MelzhutQUk+IkVQImFGHhk
	 BRhDvAHkuGlsTEOon7VQg+p2oGhR4aNcmC8UtbqRc93EGfttvrVr5w0RpK8KlEwbFd
	 1yvtRN/xblPnl3zAnqGUBt3afHb6c/6cz7Oawy2R9rliQdOhXRYaJvjQFoEbfRMIUD
	 iNd8B/1mAK42b2LTFPq0XVAEsKxe5L0jTnvd8KS/lYaAgbbd+gokHHWBptcR8iy8xD
	 r7BWGQ1i1b7WHrNa8E8AYtqkmH/4/gu7YF4/f9TgXIAhmavHkcNK9df6sfhYHEil92
	 UYsbQR38xXMZg==
Date: Thu, 3 Sep 2026 13:14:01 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] mkfs: print config file for a given mkfs
 configuration
Message-ID: <aplVuRd-qsqVFW0Q@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178821870568.2381199.9038448943413709082.stgit@frogsfrogsfrogs>
 <178821870627.2381199.2536649416350488195.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178821870627.2381199.2536649416350488195.stgit@frogsfrogsfrogs>

On 2026-08-31 16:27:05, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a -c makecfg= switch to mkfs to emit a mkfs.xfs configuration file
> documenting the user-visible filesystem featuresets of the configured
> filesystem.  This can be used to emit default configuration files as we
> do once a year for each LTS.
> 
> Note that geometry information is not written to the configuration file.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  libfrog/fsgeom.h       |    3 
>  libfrog/fsgeom.c       |  376 ++++++++++++++++++++++++++++++++++++++++++++++++
>  man/man8/mkfs.xfs.8.in |    6 +
>  mkfs/xfs_mkfs.c        |   44 +++++-
>  4 files changed, 428 insertions(+), 1 deletion(-)
> 
> ...
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 74bbb677eee2b6..212e17a354d8be 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -61,6 +61,7 @@ enum {
>  
>  enum {
>  	C_OPTFILE = 0,
> +	C_MAKECFG,
>  	C_MAX_OPTS,
>  };
>  
> @@ -312,6 +313,7 @@ static struct opt_params copts = {
>  	.name = 'c',
>  	.subopts = {
>  		[C_OPTFILE] = "options",
> +		[C_MAKECFG] = "makecfg",
>  		[C_MAX_OPTS] = NULL,
>  	},
>  	.subopt_params = {
> @@ -319,6 +321,10 @@ static struct opt_params copts = {
>  		  .conflicts = { { NULL, LAST_CONFLICT } },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
> +		{ .index = C_MAKECFG,
> +		  .conflicts = { { NULL, LAST_CONFLICT } },
> +		  .defaultval = 1,
> +		},
>  	},
>  };
>  
> @@ -1072,6 +1078,7 @@ struct cli_params {
>  
>  	char	*cfgfile;
>  	char	*protofile;
> +	char	*makecfg;
>  
>  	enum fsprop_autofsck autofsck;
>  
> @@ -1207,7 +1214,7 @@ usage( void )
>  {
>  	fprintf(stderr, _("Usage: %s\n\
>  /* blocksize */		[-b size=num]\n\
> -/* config file */	[-c options=xxx]\n\
> +/* config file */	[-c options=xxx,makecfg=0|1]\n\

Shouldn't this be makecfg=xxx?

Otherwise, looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
