Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DED10A3A
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 08:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oYlQYoZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87490C433CB;
	Mon, 18 Dec 2023 08:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702888905;
	bh=QgME7xKrdIFRzeEfrdTtXULyjsqi1lxVuhEyTV2t2do=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oYlQYoZjavylAltv6vCJ9KRjf2q0K521X1Bs7uTEu3L1J0h3uhtKO6nJo9MKHA1+a
	 14/f175zxidgyA0YUcjyb2P+RRnaParNZSIJZ7JiVf6tW0k/sIje7/SsjY39arLLSL
	 w//n4x4/OczFEbiKumt8BGnw924PD+fm9E5+KWuHyj0HfMuFeJEz/CLiJwaPK6TLzT
	 YCY07SivzZHsNYK364qCGJzGTtirOD0wMUJjX77iRmq1ltjhlZDRVxg0Uc8DN5n0UC
	 Ors1Ga0MG6tPDU/3q3Bccot0wcXLOc1IfDfJ944Bx3BMrV7a5QM2is3/IjiYr4p3yd
	 rkG8mTWWuGh/A==
Date: Mon, 18 Dec 2023 09:41:41 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/23] libxfs/frog: remove latform_find{raw,block}path
Message-ID: <fwo5bpqxdwig4k7swa5c2r6ka36sg57dm5pfjbijtt7hcs6vyp@7te4gzdalu4w>
References: <20231211163742.837427-1-hch@lst.de>
 <3Qcy31OH7KZKB01YPy-YRb9cOTxIFGLftF1BXJvj2BK4-cBnNBj6pnIrG1Hjyx6T9ADLepl1QClmtUPAh1Knqg==@protonmail.internalid>
 <20231211163742.837427-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-4-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:22PM +0100, Christoph Hellwig wrote:
> Stop pretending we try to distinguish between the legacy Unix raw and
> block devices nodes.  Linux as the only currently support platform never
> had them, but other modern Unix variants like FreeBSD also got rid of
> this distinction years ago.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  libfrog/linux.c    | 12 ------------
>  libfrog/platform.h |  2 --
>  libxfs/init.c      | 42 ++++++++++++++----------------------------
>  3 files changed, 14 insertions(+), 42 deletions(-)
> 
> diff --git a/libfrog/linux.c b/libfrog/linux.c
> index 0d9bd355f..2e4fd316e 100644
> --- a/libfrog/linux.c
> +++ b/libfrog/linux.c
> @@ -232,18 +232,6 @@ platform_findsizes(char *path, int fd, long long *sz, int *bsz)
>  		max_block_alignment = *bsz;
>  }
> 
> -char *
> -platform_findrawpath(char *path)
> -{
> -	return path;
> -}
> -
> -char *
> -platform_findblockpath(char *path)
> -{
> -	return path;
> -}
> -
>  int
>  platform_direct_blockdev(void)
>  {
> diff --git a/libfrog/platform.h b/libfrog/platform.h
> index 0aef318a8..e3e6b7c71 100644
> --- a/libfrog/platform.h
> +++ b/libfrog/platform.h
> @@ -13,8 +13,6 @@ int platform_check_iswritable(char *path, char *block, struct stat *sptr);
>  int platform_set_blocksize(int fd, char *path, dev_t device, int bsz,
>  		int fatal);
>  int platform_flush_device(int fd, dev_t device);
> -char *platform_findrawpath(char *path);
> -char *platform_findblockpath(char *path);
>  int platform_direct_blockdev(void);
>  int platform_align_blockdev(void);
>  unsigned long platform_physmem(void);	/* in kilobytes */
> diff --git a/libxfs/init.c b/libxfs/init.c
> index a8603e2fb..9cfd20e3f 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -197,7 +197,7 @@ libxfs_device_close(dev_t dev)
>  }
> 
>  static int
> -check_open(char *path, int flags, char **rawfile, char **blockfile)
> +check_open(char *path, int flags)
>  {
>  	int readonly = (flags & LIBXFS_ISREADONLY);
>  	int inactive = (flags & LIBXFS_ISINACTIVE);
> @@ -208,22 +208,10 @@ check_open(char *path, int flags, char **rawfile, char **blockfile)
>  		perror(path);
>  		return 0;
>  	}
> -	if (!(*rawfile = platform_findrawpath(path))) {
> -		fprintf(stderr, _("%s: "
> -				  "can't find a character device matching %s\n"),
> -			progname, path);
> -		return 0;
> -	}
> -	if (!(*blockfile = platform_findblockpath(path))) {
> -		fprintf(stderr, _("%s: "
> -				  "can't find a block device matching %s\n"),
> -			progname, path);
> -		return 0;
> -	}
> -	if (!readonly && !inactive && platform_check_ismounted(path, *blockfile, NULL, 1))
> +	if (!readonly && !inactive && platform_check_ismounted(path, path, NULL, 1))
>  		return 0;
> 
> -	if (inactive && check_isactive(path, *blockfile, ((readonly|dangerously)?1:0)))
> +	if (inactive && check_isactive(path, path, ((readonly|dangerously)?1:0)))
>  		return 0;
> 
>  	return 1;
> @@ -305,11 +293,9 @@ libxfs_close_devices(
>  int
>  libxfs_init(libxfs_init_t *a)
>  {
> -	char		*blockfile;
>  	char		*dname;
>  	int		fd;
>  	char		*logname;
> -	char		*rawfile;
>  	char		*rtname;
>  	int		rval = 0;
>  	int		flags;
> @@ -330,9 +316,9 @@ libxfs_init(libxfs_init_t *a)
>  	radix_tree_init();
> 
>  	if (a->volname) {
> -		if(!check_open(a->volname,flags,&rawfile,&blockfile))
> +		if (!check_open(a->volname, flags))
>  			goto done;
> -		fd = open(rawfile, O_RDONLY);
> +		fd = open(a->volname, O_RDONLY);
>  		dname = a->dname = a->volname;
>  		a->volname = NULL;
>  	}
> @@ -344,12 +330,12 @@ libxfs_init(libxfs_init_t *a)
>  			platform_findsizes(dname, a->dfd, &a->dsize,
>  					   &a->dbsize);
>  		} else {
> -			if (!check_open(dname, flags, &rawfile, &blockfile))
> +			if (!check_open(dname, flags))
>  				goto done;
> -			a->ddev = libxfs_device_open(rawfile,
> +			a->ddev = libxfs_device_open(dname,
>  					a->dcreat, flags, a->setblksize);
>  			a->dfd = libxfs_device_to_fd(a->ddev);
> -			platform_findsizes(rawfile, a->dfd,
> +			platform_findsizes(dname, a->dfd,
>  					   &a->dsize, &a->dbsize);
>  		}
>  	} else
> @@ -362,12 +348,12 @@ libxfs_init(libxfs_init_t *a)
>  			platform_findsizes(dname, a->logfd, &a->logBBsize,
>  					   &a->lbsize);
>  		} else {
> -			if (!check_open(logname, flags, &rawfile, &blockfile))
> +			if (!check_open(logname, flags))
>  				goto done;
> -			a->logdev = libxfs_device_open(rawfile,
> +			a->logdev = libxfs_device_open(logname,
>  					a->lcreat, flags, a->setblksize);
>  			a->logfd = libxfs_device_to_fd(a->logdev);
> -			platform_findsizes(rawfile, a->logfd,
> +			platform_findsizes(logname, a->logfd,
>  					   &a->logBBsize, &a->lbsize);
>  		}
>  	} else
> @@ -380,12 +366,12 @@ libxfs_init(libxfs_init_t *a)
>  			platform_findsizes(dname, a->rtfd, &a->rtsize,
>  					   &a->rtbsize);
>  		} else {
> -			if (!check_open(rtname, flags, &rawfile, &blockfile))
> +			if (!check_open(rtname, flags))
>  				goto done;
> -			a->rtdev = libxfs_device_open(rawfile,
> +			a->rtdev = libxfs_device_open(rtname,
>  					a->rcreat, flags, a->setblksize);
>  			a->rtfd = libxfs_device_to_fd(a->rtdev);
> -			platform_findsizes(rawfile, a->rtfd,
> +			platform_findsizes(rtname, a->rtfd,
>  					   &a->rtsize, &a->rtbsize);
>  		}
>  	} else
> --
> 2.39.2
> 
> 
