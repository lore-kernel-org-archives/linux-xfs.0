Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42228 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756254AbdJJNl6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Oct 2017 09:41:58 -0400
Date: Tue, 10 Oct 2017 09:41:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 2/3] xfs_io: Add RWF_NOWAIT to pwritev2()
Message-ID: <20171010134156.GB24506@bfoster.bfoster>
References: <20171010105802.31353-1-rgoldwyn@suse.de>
 <20171010105802.31353-2-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171010105802.31353-2-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Tue, Oct 10, 2017 at 05:58:01AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> This allows to make pwritev2() calls with RWF_NOWAIT,
> which would fail in case the call blocks.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Changes since v2:
> 	- ifdef around -N which set RWF_NOWAIT
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  io/pwrite.c       | 10 +++++++++-
>  man/man8/xfs_io.8 |  6 ++++++
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/io/pwrite.c b/io/pwrite.c
> index 5ceb26c7..e06dfb46 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -53,6 +53,9 @@ pwrite_help(void)
>  #ifdef HAVE_PWRITEV
>  " -V N -- use vectored IO with N iovecs of blocksize each (pwritev)\n"
>  #endif
> +#ifdef HAVE_PWRITEV2
> +" -N   -- Perform the pwritev2() with RWF_NOWAIT\n"
> +#endif
>  "\n"));
>  }
>  
> @@ -279,7 +282,7 @@ pwrite_f(
>  	init_cvtnum(&fsblocksize, &fssectsize);
>  	bsize = fsblocksize;
>  
> -	while ((c = getopt(argc, argv, "b:BCdf:Fi:qRs:S:uV:wWZ:")) != EOF) {
> +	while ((c = getopt(argc, argv, "b:BCdf:Fi:NqRs:S:uV:wWZ:")) != EOF) {
>  		switch (c) {
>  		case 'b':
>  			tmp = cvtnum(fsblocksize, fssectsize, optarg);
> @@ -308,6 +311,11 @@ pwrite_f(
>  		case 'i':
>  			infile = optarg;
>  			break;
> +#ifdef HAVE_PWRITEV2
> +		case 'N':
> +			pwritev2_flags |= RWF_NOWAIT;
> +			break;
> +#endif
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
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
