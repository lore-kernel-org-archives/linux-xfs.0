Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383311D12C
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 12:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/aa/i7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453E7C433C7;
	Mon, 18 Dec 2023 12:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702903691;
	bh=H9g8enkC+GXd8kK46WYCZmjU2uumTx2L40ui8Hchrzg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U/aa/i7xmx3wEDhRqtYvnGv7e1GJ56wI1QZw/QjCN5IrLIZ2iy2Ol5bwceN/A15ru
	 bwkyIhkb20ZcfnxgJEzOXhetiyU3O5O3V7b5IZkE9rqXruu+V1QIZoRpvIeEMVWA1N
	 5CH0hKKP5CuLk78z8Q+6J87rqW/qJkH8IQa8KbmIvfLIi03fKaZWqmexnTNTHKci80
	 mPotz+JY5B7nGNfU/idKV2vXbMOByOi8D62xlYVarRg9Hcyks0Cydw1WHMAqR6tAw6
	 9s7UAHQTDr9+/rRE2lgQSb7wvnxG/Xg2IJJdc6FsCDriHfyFfr43zVuV37nX0pH+Xk
	 8z2c4BE14SNBg==
Date: Mon, 18 Dec 2023 13:48:07 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/23] libfrog: make platform_set_blocksize exit on fatal
 failure
Message-ID: <xgnqhuamlycbtwpnmw7yuxvrzi4yuivxhlkbr7qnydrb56p6lk@sangukez4vqy>
References: <20231211163742.837427-1-hch@lst.de>
 <8xGUsGkf53UXt77fpq4y28jacxGH2IhipHOYbsadaE8TJy2UDJR1Dr-b5Hk9h1lW2HKCmqnqesLyR_GJ7LV1Lw==@protonmail.internalid>
 <20231211163742.837427-17-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-17-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:35PM +0100, Christoph Hellwig wrote:
> platform_set_blocksize has a fatal argument that is currently only
> used to change the printed message.  Make it actually fatal similar to
> other libfrog platform helpers to simplify the caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  libfrog/linux.c    | 27 +++++++++++++++------------
>  libfrog/platform.h |  4 ++--
>  libxfs/init.c      | 15 ++++++---------
>  3 files changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/libfrog/linux.c b/libfrog/linux.c
> index 2e4fd316e..46a5ff39e 100644
> --- a/libfrog/linux.c
> +++ b/libfrog/linux.c
> @@ -127,20 +127,23 @@ platform_check_iswritable(char *name, char *block, struct stat *s)
>  	return platform_check_mount(name, block, s, flags);
>  }
> 
> -int
> -platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fatal)
> +void
> +platform_set_blocksize(int fd, char *path, dev_t device, int blocksize,
> +		bool fatal)
>  {
> -	int error = 0;
> -
> -	if (major(device) != RAMDISK_MAJOR) {
> -		if ((error = ioctl(fd, BLKBSZSET, &blocksize)) < 0) {
> -			fprintf(stderr, _("%s: %s - cannot set blocksize "
> -					"%d on block device %s: %s\n"),
> -				progname, fatal ? "error": "warning",
> -				blocksize, path, strerror(errno));
> -		}
> +	int error;
> +
> +	if (major(device) == RAMDISK_MAJOR)
> +		return;
> +	error = ioctl(fd, BLKBSZSET, &blocksize);
> +	if (error < 0) {
> +		fprintf(stderr, _("%s: %s - cannot set blocksize "
> +				"%d on block device %s: %s\n"),
> +			progname, fatal ? "error": "warning",
> +			blocksize, path, strerror(errno));
> +		if (fatal)
> +			exit(1);
>  	}
> -	return error;
>  }
> 
>  /*
> diff --git a/libfrog/platform.h b/libfrog/platform.h
> index e3e6b7c71..20f9bdf5c 100644
> --- a/libfrog/platform.h
> +++ b/libfrog/platform.h
> @@ -10,8 +10,8 @@
>  int platform_check_ismounted(char *path, char *block, struct stat *sptr,
>  		int verbose);
>  int platform_check_iswritable(char *path, char *block, struct stat *sptr);
> -int platform_set_blocksize(int fd, char *path, dev_t device, int bsz,
> -		int fatal);
> +void platform_set_blocksize(int fd, char *path, dev_t device, int bsz,
> +		bool fatal);
>  int platform_flush_device(int fd, dev_t device);
>  int platform_direct_blockdev(void);
>  int platform_align_blockdev(void);
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 6570c595a..5be6f8cf1 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -125,15 +125,12 @@ retry:
>  	}
> 
>  	if (!readonly && setblksize && (statb.st_mode & S_IFMT) == S_IFBLK) {
> -		if (dio) {
> -			/* try to use the given explicit blocksize */
> -			(void)platform_set_blocksize(fd, path, statb.st_rdev,
> -					setblksize, 0);
> -		} else {
> -			/* given an explicit blocksize to use */
> -			if (platform_set_blocksize(fd, path, statb.st_rdev, setblksize, 1))
> -			    exit(1);
> -		}
> +		/*
> +		 * Try to use the given explicit blocksize.  Failure to set the
> +		 * block size is only fatal for direct I/O.
> +		 */
> +		platform_set_blocksize(fd, path, statb.st_rdev, setblksize,
> +				dio);
>  	}
> 
>  	/*
> --
> 2.39.2
> 
