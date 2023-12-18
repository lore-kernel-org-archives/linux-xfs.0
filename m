Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED6010A29
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 08:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qbHbeG61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6ACC433C9;
	Mon, 18 Dec 2023 08:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702889523;
	bh=gy5AntsS1NPd0btSWcfubEewBbFaq8QYt5brmh4t7eg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qbHbeG61CtLRErzb+xPngUN7nSlZbzZB8WfdtGZPqAkZowcMr6dcRJtD4TQPYuq2R
	 bByKiw1+IeoQSPSIfTEgZHDIt3CKspkIC2TSKGJcev+3oTHZbuvEqcxyWYoxW8uzPp
	 KONGkpSRA9ykXfEZlbfzjlml+UpVW7C5v8XnxXhg4wWDh4W7xB8DvRrv/VGIRN09G6
	 sUtvHrT58FyNfaCz6ONkROemhCDHmxE0B+j9yrZ5xH2OCLZ3kw+9Mrgumpbmqkb84M
	 cnDHlM2vdkL/DtU7GOT3mwPsDSoA0RX1kywtlBUok3RbEMLDOIZ4oHWpoDTqMreo6n
	 U2WAdxhMriwrQ==
Date: Mon, 18 Dec 2023 09:51:59 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/23] xfs_logprint: move all code to set up the fake
 xlog into logstat()
Message-ID: <ptqfxts3up3y5qbbiamhm24sk6sbqkypcpggkurkht42dki32z@xo2fggjvwo5k>
References: <20231211163742.837427-1-hch@lst.de>
 <oXuNPqfQN-TO9QcGngVU-K5iWanq8hXu01OmO6JPHE4c7glEUoLsv1Hk7Ly6saw6hhHLXbjqKks2Y0HRdux5CA==@protonmail.internalid>
 <20231211163742.837427-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-6-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:24PM +0100, Christoph Hellwig wrote:
> Isolate the code that sets up the fake xlog into the logstat() helper to
> prepare for upcoming changes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  logprint/logprint.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/logprint/logprint.c b/logprint/logprint.c
> index 9a8811f46..7d51cdd91 100644
> --- a/logprint/logprint.c
> +++ b/logprint/logprint.c
> @@ -52,7 +52,9 @@ Options:\n\
>  }
> 
>  static int
> -logstat(xfs_mount_t *mp)
> +logstat(
> +	struct xfs_mount	*mp,
> +	struct xlog		*log)
>  {
>  	int		fd;
>  	char		buf[BBSIZE];
> @@ -103,6 +105,11 @@ logstat(xfs_mount_t *mp)
>  		x.lbsize = BBSIZE;
>  	}
> 
> +	log->l_dev = mp->m_logdev_targp;
> +	log->l_logBBstart = x.logBBstart;
> +	log->l_logBBsize = x.logBBsize;
> +	log->l_sectBBsize = BTOBB(x.lbsize);
> +	log->l_mp = mp;
> 
>  	if (x.logname && *x.logname) {    /* External log */
>  		if ((fd = open(x.logname, O_RDONLY)) == -1) {
> @@ -212,8 +219,8 @@ main(int argc, char **argv)
>  	if (!libxfs_init(&x))
>  		exit(1);
> 
> -	logstat(&mount);
>  	libxfs_buftarg_init(&mount, x.ddev, x.logdev, x.rtdev);
> +	logstat(&mount, &log);
> 
>  	logfd = (x.logfd < 0) ? x.dfd : x.logfd;
> 
> @@ -226,15 +233,9 @@ main(int argc, char **argv)
>  	}
> 
>  	printf(_("daddr: %lld length: %lld\n\n"),
> -		(long long)x.logBBstart, (long long)x.logBBsize);
> +		(long long)log.l_logBBstart, (long long)log.l_logBBsize);
> 
> -	ASSERT(x.logBBsize <= INT_MAX);
> -
> -	log.l_dev = mount.m_logdev_targp;
> -	log.l_logBBstart  = x.logBBstart;
> -	log.l_logBBsize   = x.logBBsize;
> -	log.l_sectBBsize  = BTOBB(x.lbsize);
> -	log.l_mp          = &mount;
> +	ASSERT(log.l_logBBsize <= INT_MAX);
> 
>  	switch (print_operation) {
>  	case OP_PRINT:
> --
> 2.39.2
> 
