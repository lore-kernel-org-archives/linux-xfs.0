Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754227AbdJIPC4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Oct 2017 11:02:56 -0400
Date: Mon, 9 Oct 2017 11:02:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 2/3] xfs_io: Add RWF_NOWAIT to pwritev2()
Message-ID: <20171009150254.GB19322@bfoster.bfoster>
References: <20170929130035.24760-1-rgoldwyn@suse.de>
 <20170929130035.24760-2-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170929130035.24760-2-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Fri, Sep 29, 2017 at 08:00:34AM -0500, Goldwyn Rodrigues wrote:
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
> index e7d411bb..2b85a528 100644
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
> @@ -276,7 +279,7 @@ pwrite_f(
>  	init_cvtnum(&fsblocksize, &fssectsize);
>  	bsize = fsblocksize;
>  
> -	while ((c = getopt(argc, argv, "b:BCdf:Fi:qRs:S:uV:wWZ:")) != EOF) {
> +	while ((c = getopt(argc, argv, "b:BCdf:Fi:NqRs:S:uV:wWZ:")) != EOF) {
>  		switch (c) {
>  		case 'b':
>  			tmp = cvtnum(fsblocksize, fssectsize, optarg);
> @@ -305,6 +308,9 @@ pwrite_f(
>  		case 'i':
>  			infile = optarg;
>  			break;
> +		case 'N':
> +			pwritev2_flags |= RWF_NOWAIT;

This causes a build failure on my local machine due to lack of
RWF_NOWAIT. #ifdef HAVE_PWRITEV2 around this case? Otherwise the code
looks Ok.

Brian

> +			break;
>  		case 's':
>  			skip = cvtnum(fsblocksize, fssectsize, optarg);
>  			if (skip < 0) {
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 0fd9b951..9c58914f 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -282,6 +282,12 @@ Use the vectored IO write syscall
>  with a number of blocksize length iovecs. The number of iovecs is set by the
>  .I vectors
>  parameter.
> +.TP
> +.B \-N
> +Perform the
> +.BR pwritev2 (2)
> +call with
> +.I RWF_NOWAIT.
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
