Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5771D13F
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 12:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MPKOXLPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66728C433C7;
	Mon, 18 Dec 2023 12:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702904008;
	bh=VtQbpXrZURsv0G7Y3wiiS+QnOuIG1bCcr9Sqc9xGd0A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MPKOXLPATX82tspwT1G9M1eS56wfduvQPxcHU5suWsMinjl4ZFdi6hNjMdLZNzZJ/
	 9Vth3fQdaxf5uqksn+yWgjAShS0z85MAZEbVo+GZ4lONh3gT+R3qbWI+p+cL+/4kY5
	 tXud6+Sb1PknTTDgy+/rfDXa8RZN9d0sJ349YnueIls74EAKo/hha6LM5uDuR4eRXX
	 /+aFpgeQHi16cUBvMYG9K/u8hYlssflB8l5jrE4QkInTjntG1JKL3nOuZe8vq4WhHn
	 1FZrmqXjL0rzJ2awhfaem+zxJ9vdfuy+DqBads4Yh8sD+jIMY5avfOhM/m2et7QO5g
	 5Y8ecxUuQNNuA==
Date: Mon, 18 Dec 2023 13:53:24 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/23] libxfs: return the opened fd from
 libxfs_device_open
Message-ID: <ofg4na3mpfdmudwfnxxh5rh5wbi6q2gkvhzfh54geezvvva25p@el3jjxedzebd>
References: <20231211163742.837427-1-hch@lst.de>
 <EVlzBLTsSW6Vo6yxjkW4mCj8H152JSFTk4URDO2fedQx6FSeBeylm9GXCaj9HjGSnnJSPowH47iqHFj8NIf8qw==@protonmail.internalid>
 <20231211163742.837427-20-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-20-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:38PM +0100, Christoph Hellwig wrote:
> So that the caller can stash it away without having to call
> xfs_device_to_fd.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  libxfs/init.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 13ad7899c..866e5f425 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -93,7 +93,7 @@ libxfs_device_to_fd(dev_t device)
>   *     open a device and return its device number
>   */
>  static dev_t
> -libxfs_device_open(char *path, int creat, int xflags, int setblksize)
> +libxfs_device_open(char *path, int creat, int xflags, int setblksize, int *fdp)
>  {
>  	dev_t		dev;
>  	int		fd, d, flags;
> @@ -151,6 +151,7 @@ retry:
>  		if (!dev_map[d].dev) {
>  			dev_map[d].dev = dev;
>  			dev_map[d].fd = fd;
> +			*fdp = fd;
> 
>  			return dev;
>  		}
> @@ -307,16 +308,14 @@ libxfs_init(struct libxfs_init *a)
>  		if (!a->disfile && !check_open(dname, a->flags))
>  			goto done;
>  		a->ddev = libxfs_device_open(dname, a->dcreat, a->flags,
> -				a->setblksize);
> -		a->dfd = libxfs_device_to_fd(a->ddev);
> +				a->setblksize, &a->dfd);
>  		platform_findsizes(dname, a->dfd, &a->dsize, &a->dbsize);
>  	}
>  	if (logname) {
>  		if (!a->lisfile && !check_open(logname, a->flags))
>  			goto done;
>  		a->logdev = libxfs_device_open(logname, a->lcreat, a->flags,
> -				a->setblksize);
> -		a->logfd = libxfs_device_to_fd(a->logdev);
> +				a->setblksize, &a->logfd);
>  		platform_findsizes(logname, a->logfd, &a->logBBsize,
>  				&a->lbsize);
>  	}
> @@ -324,8 +323,7 @@ libxfs_init(struct libxfs_init *a)
>  		if (a->risfile && !check_open(rtname, a->flags))
>  			goto done;
>  		a->rtdev = libxfs_device_open(rtname, a->rcreat, a->flags,
> -				a->setblksize);
> -		a->rtfd = libxfs_device_to_fd(a->rtdev);
> +				a->setblksize, &a->rtfd);
>  		platform_findsizes(dname, a->rtfd, &a->rtsize, &a->rtbsize);
>  	}
> 
> --
> 2.39.2
> 
> 
