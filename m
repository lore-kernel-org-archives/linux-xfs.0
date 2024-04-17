Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E57146D77
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 15:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713367161; cv=none; b=MfChu7ZlD0Vde5LDL0iSs69M7FtLk3SkS+tn0YqO+Na5YFjVUgUjZF2M/N/sVQz2NrvfSPG2vOW/W7YUTZuwYxKSXdffx94zWwH3MWBG7Me2vBPfCxp3AMXooEy0Kx6m3iZ+z8fFATVK14sCDkFJZQoeYh02mVWVsrr7QmIfIjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713367161; c=relaxed/simple;
	bh=OMwEaeXfE3iIenaDz/KaunKi/HIBEEqlFFrdtK9EO2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u8mX78ahkulia7BZeqwalc1w8punSNL4m8AO5rlk0wvQCBvmt/vWoZJxcCjj9DgbRGPydcI2gl3qdKuzHo3BZuiZ8/R7huaGY5E+jsK61uGQYWpppKOgdund14/NVwsWILXhCBHzKDHhH3CAJfAbr5oBkTe+7pX2iGOpp2Vac2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/AA9Cec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/AA9Cec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822C5C32781;
	Wed, 17 Apr 2024 15:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713367160;
	bh=OMwEaeXfE3iIenaDz/KaunKi/HIBEEqlFFrdtK9EO2Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U/AA9Cec7jD2QTAZdHA2u1U6S+SxpB2YBD4SiGTVJa8FJK/LIPkWZjVmG28PfbTuZ
	 Xyetmp94dU6Nf6RjmDwNiwlGOZhOQPo4p4EwDB7FGZwIqh5Sz3d9V3bLkAIGWnTVuL
	 apJLwaaBM98d//LThowRhtDKTnbYhDqA/9usFoL8zjnijLYFRo6wfB6Pfx3OijHtkN
	 fMN5ISbjmKJ74KQVzJmkxed93mlZqzU0L0KKiCM0W98iCpJyEAQncGTTyEqBRtjS7/
	 kzsDHIDKyO/0LmqbvjhM4HD91gk6gXE6QZlJ7y2VnoNDsKgUmLsXTWgIX+na4UCQej
	 /3zJU1btliYYw==
Date: Wed, 17 Apr 2024 08:19:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 4/4] xfs_fsr: convert fsrallfs to use time_t instead
 of int
Message-ID: <20240417151919.GS11948@frogsfrogsfrogs>
References: <20240417125227.916015-2-aalbersh@redhat.com>
 <20240417125227.916015-6-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417125227.916015-6-aalbersh@redhat.com>

On Wed, Apr 17, 2024 at 02:52:28PM +0200, Andrey Albershteyn wrote:
> Convert howlong argument to a time_t as it's truncated to int, but in
> practice this is not an issue as duration will never be this big.
> 
> Add check for howlong to fit into int (printf can use int format
> specifier). Even longer interval doesn't make much sense.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fsr/xfs_fsr.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 3077d8f4ef46..02d61ef9399a 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -72,7 +72,7 @@ static int  packfile(char *fname, char *tname, int fd,
>  static void fsrdir(char *dirname);
>  static int  fsrfs(char *mntdir, xfs_ino_t ino, int targetrange);
>  static void initallfs(char *mtab);
> -static void fsrallfs(char *mtab, int howlong, char *leftofffile);
> +static void fsrallfs(char *mtab, time_t howlong, char *leftofffile);
>  static void fsrall_cleanup(int timeout);
>  static int  getnextents(int);
>  int xfsrtextsize(int fd);
> @@ -165,6 +165,12 @@ main(int argc, char **argv)
>  			break;
>  		case 't':
>  			howlong = atoi(optarg);
> +			if (howlong > INT_MAX) {
> +				fprintf(stderr,
> +				_("%s: the maximum runtime is %d seconds.\n"),
> +					optarg, INT_MAX);
> +				exit(1);
> +			}
>  			break;
>  		case 'f':
>  			leftofffile = optarg;
> @@ -387,7 +393,7 @@ initallfs(char *mtab)
>  }
>  
>  static void
> -fsrallfs(char *mtab, int howlong, char *leftofffile)
> +fsrallfs(char *mtab, time_t howlong, char *leftofffile)
>  {
>  	int fd;
>  	int error;
> -- 
> 2.42.0
> 
> 
