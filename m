Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8EC37894
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 12:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l9uT7ZpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D956C433C8;
	Mon, 18 Dec 2023 12:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702903944;
	bh=eqmKnTcNJeUB4UlG3p9FZiBTq/FV/beXXrh6s4X1tYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l9uT7ZpFldevzEZGrqF6mnHyejkRPPquidTa61kSLEfDMwTKz00UItkNgPNQWRCpp
	 jU/KX3n8TymI3Rk3IYi3lRaqy6gglPkP+spxzjdXvRfk/VNn+mmPgnRsSJAl5hxJZH
	 tMGMUn/QTm6VadyxWyOlSEWFiHTSr95pE7ykA4FmrrSmNE3RIT0Kcl24CL/SqOh1zy
	 5qd1tdTzpXumQsbe0oBvKLbTnEuZO8NWMnfjiBSHDZh5y9EtmE4qYEpKf48iHuinYH
	 dkWoVhmVPTd9m45HNanM5N2mLVHMA0rktbgqXKO2asNH4/YF1fO0uHtqfD8zCVA1Zl
	 kq4kDm9nlxssQ==
Date: Mon, 18 Dec 2023 13:52:20 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/23] libxfs: mark libxfs_device_{open,close} static
Message-ID: <rf5eteahl4x24zhgnltelvhusw2samainxnuawb5mrn4guchb6@cexvymyt64qn>
References: <20231211163742.837427-1-hch@lst.de>
 <uk6RE2HgpKji-4fhCLxm0xL4wk5ul5CwevDvRG3-65Vl57PJs6EnRhx3bGdAkw8owY6uW3NSLLrbB2GPUMahEQ==@protonmail.internalid>
 <20231211163742.837427-19-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-19-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:37PM +0100, Christoph Hellwig wrote:
> libxfs_device_open and libxfs_device_close are only used in init.c.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  include/libxfs.h | 2 --
>  libxfs/init.c    | 4 ++--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/include/libxfs.h b/include/libxfs.h
> index 9ee3dd979..68efe9caa 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -148,8 +148,6 @@ int		libxfs_init(struct libxfs_init *);
>  void		libxfs_destroy(struct libxfs_init *li);
> 
>  extern int	libxfs_device_to_fd (dev_t);
> -extern dev_t	libxfs_device_open (char *, int, int, int);
> -extern void	libxfs_device_close (dev_t);
>  extern int	libxfs_device_alignment (void);
>  extern void	libxfs_report(FILE *);
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 87193c3a6..13ad7899c 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -92,7 +92,7 @@ libxfs_device_to_fd(dev_t device)
>  /* libxfs_device_open:
>   *     open a device and return its device number
>   */
> -dev_t
> +static dev_t
>  libxfs_device_open(char *path, int creat, int xflags, int setblksize)
>  {
>  	dev_t		dev;
> @@ -161,7 +161,7 @@ retry:
>  	/* NOTREACHED */
>  }
> 
> -void
> +static void
>  libxfs_device_close(dev_t dev)
>  {
>  	int	d;
> --
> 2.39.2
> 
