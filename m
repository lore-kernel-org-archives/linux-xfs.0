Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17768 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750759AbdI1T3o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Sep 2017 15:29:44 -0400
Date: Thu, 28 Sep 2017 12:29:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] io/pwrite: Add RWF_NOWAIT to pwritev2()
Message-ID: <20170928192930.GQ5020@magnolia>
References: <20170928185426.9070-1-rgoldwyn@suse.de>
 <20170928185426.9070-2-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170928185426.9070-2-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Thu, Sep 28, 2017 at 01:54:25PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> This allows to make pwritev2() calls with RWF_NOWAIT,
> which would fail in case the call blocks.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  io/pwrite.c       | 8 +++++++-
>  man/man8/xfs_io.8 | 6 ++++++
>  2 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/io/pwrite.c b/io/pwrite.c
> index 82eaf827..8289c3ee 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -52,6 +52,9 @@ pwrite_help(void)
>  "         (heh, zorry, the -s/-S arguments were already in use in pwrite)\n"
>  #ifdef HAVE_PWRITEV
>  " -V N -- use vectored IO with N iovecs of blocksize each (pwritev)\n"
> +#ifdef HAVE_PWRITEV2
> +" -N   -- Perform the pwritev2() with RWF_NOWAIT\n"
> +#endif
>  #endif
>  "\n"));
>  }
> @@ -273,7 +276,7 @@ pwrite_f(
>  	init_cvtnum(&fsblocksize, &fssectsize);
>  	bsize = fsblocksize;
>  
> -	while ((c = getopt(argc, argv, "b:BCdf:Fi:qRs:S:uV:wWZ:")) != EOF) {
> +	while ((c = getopt(argc, argv, "b:BCdf:Fi:NqRs:S:uV:wWZ:")) != EOF) {
>  		switch (c) {
>  		case 'b':
>  			tmp = cvtnum(fsblocksize, fssectsize, optarg);
> @@ -302,6 +305,9 @@ pwrite_f(
>  		case 'i':
>  			infile = optarg;
>  			break;
> +		case 'N':
> +			pwritev2_flags |= RWF_NOWAIT;
> +			break;
>  		case 's':
>  			skip = cvtnum(fsblocksize, fssectsize, optarg);
>  			if (skip < 0) {
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 2c56f092..f410ce9a 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -248,6 +248,12 @@ Use the vectored IO write syscall
>  with a number of blocksize length iovecs. The number of iovecs is set by the
>  .I vectors
>  parameter.
> +.TP
> +.B \-N
> +Perform the
> +.BR pwritev2 (2)
> +call with
> +.I RWF_NOWAIT. 

Trailing space?

Otherwise looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

>  .RE
>  .PD
>  .TP
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
