Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DD010A1D
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 08:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oZ0YrTkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E3CC433C9;
	Mon, 18 Dec 2023 08:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702888719;
	bh=emymtLVD45sULq+YHZ+dSgDQKA137EXdpistC0GlmBE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oZ0YrTkDjuAFMCEMh7KAikYWftIHCzD5w+fjBAMa0q+oexuDySiVOWLLggj1wBCzi
	 Y+I8UBDrSiePbPZuo/Zz1RjXvI3AMiX9vjN1ozgta1M3IT6+7IFFu+MuLCUtVBV/iW
	 TEv2NQlt9OfHhZ2+bgK7D8tGki+uxpL0+Y6hFV7+5w/YKJ4r/3PjVEB7ap/ymfg1cK
	 koizZNbmt5oi3aBwbk8viuJ4D0Emmkd/G6rf6gXHPSfH4AfZEWq8bzmmlJEcW6CGBm
	 CDpFTqKYsGE/YwhEn2e/tJ7725v9KDhGpbJ+Fqx6MWUQ6UkqhyEfCGZws3gdQsTWcS
	 zom1+jsdKhh8w==
Date: Mon, 18 Dec 2023 09:38:35 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/23] libxfs: remove the dead {d,log,rt}path variables
 in libxfs_init
Message-ID: <vkhpny2eh6tcgt5docznyvg56eyxarilvhdtofv4kwc3zzl6no@ix2dmfhght25>
References: <20231211163742.837427-1-hch@lst.de>
 <giQxL3ym3IVQ5WiqK6_xUv_HV1Fx8Umlo_D74RRi3XOLkbGE38JomWwaqcF6DdTTur1ikXzjnRwhReIRGtX4jQ==@protonmail.internalid>
 <20231211163742.837427-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-3-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:21PM +0100, Christoph Hellwig wrote:
> These variables are only initialized, and then unlink is called if they
> were changed from the initial value, which can't happen.  Remove the
> variables and the conditional unlink calls.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  libxfs/init.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index ce6e62cde..a8603e2fb 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -307,17 +307,13 @@ libxfs_init(libxfs_init_t *a)
>  {
>  	char		*blockfile;
>  	char		*dname;
> -	char		dpath[25];
>  	int		fd;
>  	char		*logname;
> -	char		logpath[25];
>  	char		*rawfile;
>  	char		*rtname;
> -	char		rtpath[25];
>  	int		rval = 0;
>  	int		flags;
> 
> -	dpath[0] = logpath[0] = rtpath[0] = '\0';
>  	dname = a->dname;
>  	logname = a->logname;
>  	rtname = a->rtname;
> @@ -418,12 +414,6 @@ libxfs_init(libxfs_init_t *a)
>  	init_caches();
>  	rval = 1;
>  done:
> -	if (dpath[0])
> -		unlink(dpath);
> -	if (logpath[0])
> -		unlink(logpath);
> -	if (rtpath[0])
> -		unlink(rtpath);
>  	if (fd >= 0)
>  		close(fd);
>  	if (!rval) {
> --
> 2.39.2
> 
