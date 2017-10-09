Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18020 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754224AbdJIRUC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2017 13:20:02 -0400
Date: Mon, 9 Oct 2017 10:19:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 2/3] xfs_io: Add RWF_NOWAIT to pwritev2()
Message-ID: <20171009171953.GR7122@magnolia>
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
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

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

Separate these two? i.e.

#ifdef HAVE_PWRITEV
" -V N..."
#endif
#ifdef HAVE_PWRITEV2
" -N ..."
#endif

They're tested separately in configure, so the ifdefs needn't be nested.

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
> +			break;

Needs #ifdef HAVE_PWRITEV2.

If you feel the need to be extra cautious, you could also put:

#ifndef HAVE_PWRITEV2
	assert(pwritev2_flags == 0);
#endif

...just after the getopt parsing to make sure that we never silently
drop RWF_* flags due to code bugs.

--D

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
