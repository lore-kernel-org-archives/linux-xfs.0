Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E42E219FD
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 11:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gEZKfIoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86D5C433C7;
	Mon, 11 Dec 2023 11:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702293051;
	bh=i3i6/bK/IEDxwQw3ve0UhrqSPMR+yzTlKkPzuV1lAWI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gEZKfIoSAL1T4o4i8WXdqnZXf6O6a3BX+MRiREo0rYU31B3pBnbZLC5g7DWiFfvmT
	 t6DLCj7Xxrrc6ljjeu5RgprXNm+psyroUEBTbwJptIiBYERtps4JaS+zbEarVPMg1a
	 gX/m98GFxtXpkkQoZIfWIA+9JqarT3HnfkoOn1h5+iVuqlt/HQDlmuFCITSTykpINX
	 RnFj3jbY/Pb1LYJYfu2Mg0oBR+0pCM6u2L7Vo+P8tHM0MGuMjXJcKKwSNN5ntVVJZ8
	 WD4LOoT9IaV7Xdu9l+MoaDAv9Isg77XRlhKe0i1A5K7WSXW9+/RVcOlsiZmZv7Hmqf
	 dIFiFQecKJUxg==
Date: Mon, 11 Dec 2023 12:10:47 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "wuyifeng (C)" <wuyifeng10@huawei.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
	louhongxiang@huawei.com
Subject: Re: [PATCH] xfs_grow: Remove xflag and iflag to reduce redundant
 temporary variables.
Message-ID: <gklh6fus77l3qwv4xh7gwrkqbnyvbati2edxsjjoaxwpfssaxe@dd4nld6j7zn3>
References: <0e5P5B3pK_KjP_PgdGLjztYkfjNvEPuXovv9Fz2xm1gNnC0r5NfQf7wOK3OQNZ0GN0yqrL2qgeQpFuZfFv61og==@protonmail.internalid>
 <619020bd-800a-431a-bb1d-937ad1cdc270@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <619020bd-800a-431a-bb1d-937ad1cdc270@huawei.com>

On Thu, Dec 07, 2023 at 04:39:04PM +0800, wuyifeng (C) wrote:
> I found that iflag and xflag can be combined with lflag to reduce the
> number of redundant local variables, which is a refactoring to improve
> code readability.Signed-off-by: Wu YiFeng <wuyifeng10@huawei.com>
> 
> Please help me review, thanks.

Patches should be inlined not submitted as an attachment, please, submit it
correctly, so people will actually look into it.

Same kernel rules apply here:
https://www.kernel.org/doc/html/latest/process/submitting-patches.html#no-mime-no-links-no-compression-no-attachments-just-plain-text

Thanks

Carlos

> 
> ---
>   growfs/xfs_growfs.c | 22 +++++++++++-----------
>   1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> index 683961f6..5fb1a9d2 100644
> --- a/growfs/xfs_growfs.c
> +++ b/growfs/xfs_growfs.c
> @@ -8,6 +8,10 @@
>   #include "libfrog/paths.h"
>   #include "libfrog/fsgeom.h"
> 
> +#define LOG_GROW    (1<<0)    /* -l flag: grow log section */
> +#define LOG_EXT2INT    (1<<1)    /* -i flag: convert log from external
> to internal format */
> +#define LOG_INT2EXT    (1<<2)    /* -x flag: convert log from internal
> to external format */
> +
>   static void
>   usage(void)
>   {
> @@ -45,7 +49,6 @@ main(int argc, char **argv)
>       long            esize;    /* new rt extent size */
>       int            ffd;    /* mount point file descriptor */
>       struct xfs_fsop_geom    geo;    /* current fs geometry */
> -    int            iflag;    /* -i flag */
>       int            isint;    /* log is currently internal */
>       int            lflag;    /* -l flag */
>       long long        lsize;    /* new log size in fs blocks */
> @@ -55,7 +58,6 @@ main(int argc, char **argv)
>       struct xfs_fsop_geom    ngeo;    /* new fs geometry */
>       int            rflag;    /* -r flag */
>       long long        rsize;    /* new rt size in fs blocks */
> -    int            xflag;    /* -x flag */
>       char            *fname;    /* mount point name */
>       char            *datadev; /* data device name */
>       char            *logdev;  /*  log device name */
> @@ -72,7 +74,7 @@ main(int argc, char **argv)
> 
>       maxpct = esize = 0;
>       dsize = lsize = rsize = 0LL;
> -    aflag = dflag = iflag = lflag = mflag = nflag = rflag = xflag = 0;
> +    aflag = dflag = lflag = mflag = nflag = rflag = 0;
> 
>       while ((c = getopt(argc, argv, "dD:e:ilL:m:np:rR:t:xV")) != EOF) {
>           switch (c) {
> @@ -87,13 +89,13 @@ main(int argc, char **argv)
>               rflag = 1;
>               break;
>           case 'i':
> -            lflag = iflag = 1;
> +            lflag |= LOG_EXT2INT;
>               break;
>           case 'L':
>               lsize = strtoll(optarg, NULL, 10);
>               fallthrough;
>           case 'l':
> -            lflag = 1;
> +            lflag |= LOG_GROW;
>               break;
>           case 'm':
>               mflag = 1;
> @@ -115,7 +117,7 @@ main(int argc, char **argv)
>               mtab_file = optarg;
>               break;
>           case 'x':
> -            lflag = xflag = 1;
> +            lflag |= LOG_INT2EXT;
>               break;
>           case 'V':
>               printf(_("%s version %s\n"), progname, VERSION);
> @@ -124,9 +126,7 @@ main(int argc, char **argv)
>               usage();
>           }
>       }
> -    if (argc - optind != 1)
> -        usage();
> -    if (iflag && xflag)
> +    if (argc - optind != 1 || ((lflag & LOG_EXT2INT) && (lflag &
> LOG_INT2EXT)))
>           usage();
>       if (dflag + lflag + rflag + mflag == 0)
>           aflag = 1;
> @@ -323,9 +323,9 @@ _("[EXPERIMENTAL] try to shrink unused space %lld,
> old size is %lld\n"),
> 
>           if (!lsize)
>               lsize = dlsize / (geo.blocksize / BBSIZE);
> -        if (iflag)
> +        if (lflag & LOG_EXT2INT)
>               in.isint = 1;
> -        else if (xflag)
> +        else if (lflag & LOG_INT2EXT)
>               in.isint = 0;
>           else
>               in.isint = xi.logBBsize == 0;
> --
> 2.33.0
> 

> From 74c9fe3337a302385999b57ceb819b3439cdbd9c Mon Sep 17 00:00:00 2001
> From: Wu YiFeng <wuyifeng10@huawei.com>
> Date: Thu, 7 Dec 2023 15:47:08 +0800
> Subject: [PATCH] xfs_grow: Remove xflag and iflag to reduce redundant
>  temporary variables.
> 
> Both xflag and iflag are log flags. We can use the bits of lflag to
> indicate all log flags, which is a small code reconstruction.
> 
> Signed-off-by: Wu YiFeng <wuyifeng10@huawei.com>
> ---
>  growfs/xfs_growfs.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> index 683961f6..5fb1a9d2 100644
> --- a/growfs/xfs_growfs.c
> +++ b/growfs/xfs_growfs.c
> @@ -8,6 +8,10 @@
>  #include "libfrog/paths.h"
>  #include "libfrog/fsgeom.h"
>  
> +#define LOG_GROW	(1<<0)	/* -l flag: grow log section */
> +#define LOG_EXT2INT	(1<<1)	/* -i flag: convert log from external to internal format */
> +#define LOG_INT2EXT	(1<<2)	/* -x flag: convert log from internal to external format */
> +
>  static void
>  usage(void)
>  {
> @@ -45,7 +49,6 @@ main(int argc, char **argv)
>  	long			esize;	/* new rt extent size */
>  	int			ffd;	/* mount point file descriptor */
>  	struct xfs_fsop_geom	geo;	/* current fs geometry */
> -	int			iflag;	/* -i flag */
>  	int			isint;	/* log is currently internal */
>  	int			lflag;	/* -l flag */
>  	long long		lsize;	/* new log size in fs blocks */
> @@ -55,7 +58,6 @@ main(int argc, char **argv)
>  	struct xfs_fsop_geom	ngeo;	/* new fs geometry */
>  	int			rflag;	/* -r flag */
>  	long long		rsize;	/* new rt size in fs blocks */
> -	int			xflag;	/* -x flag */
>  	char			*fname;	/* mount point name */
>  	char			*datadev; /* data device name */
>  	char			*logdev;  /*  log device name */
> @@ -72,7 +74,7 @@ main(int argc, char **argv)
>  
>  	maxpct = esize = 0;
>  	dsize = lsize = rsize = 0LL;
> -	aflag = dflag = iflag = lflag = mflag = nflag = rflag = xflag = 0;
> +	aflag = dflag = lflag = mflag = nflag = rflag = 0;
>  
>  	while ((c = getopt(argc, argv, "dD:e:ilL:m:np:rR:t:xV")) != EOF) {
>  		switch (c) {
> @@ -87,13 +89,13 @@ main(int argc, char **argv)
>  			rflag = 1;
>  			break;
>  		case 'i':
> -			lflag = iflag = 1;
> +			lflag |= LOG_EXT2INT;
>  			break;
>  		case 'L':
>  			lsize = strtoll(optarg, NULL, 10);
>  			fallthrough;
>  		case 'l':
> -			lflag = 1;
> +			lflag |= LOG_GROW;
>  			break;
>  		case 'm':
>  			mflag = 1;
> @@ -115,7 +117,7 @@ main(int argc, char **argv)
>  			mtab_file = optarg;
>  			break;
>  		case 'x':
> -			lflag = xflag = 1;
> +			lflag |= LOG_INT2EXT;
>  			break;
>  		case 'V':
>  			printf(_("%s version %s\n"), progname, VERSION);
> @@ -124,9 +126,7 @@ main(int argc, char **argv)
>  			usage();
>  		}
>  	}
> -	if (argc - optind != 1)
> -		usage();
> -	if (iflag && xflag)
> +	if (argc - optind != 1 || ((lflag & LOG_EXT2INT) && (lflag & LOG_INT2EXT)))
>  		usage();
>  	if (dflag + lflag + rflag + mflag == 0)
>  		aflag = 1;
> @@ -323,9 +323,9 @@ _("[EXPERIMENTAL] try to shrink unused space %lld, old size is %lld\n"),
>  
>  		if (!lsize)
>  			lsize = dlsize / (geo.blocksize / BBSIZE);
> -		if (iflag)
> +		if (lflag & LOG_EXT2INT)
>  			in.isint = 1;
> -		else if (xflag)
> +		else if (lflag & LOG_INT2EXT)
>  			in.isint = 0;
>  		else
>  			in.isint = xi.logBBsize == 0;
> -- 
> 2.33.0
> 

