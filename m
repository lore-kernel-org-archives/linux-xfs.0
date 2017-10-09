Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51599 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754198AbdJIRQe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2017 13:16:34 -0400
Date: Mon, 9 Oct 2017 10:15:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 3/3] xfs_io: Allow partial writes
Message-ID: <20171009171530.GQ7122@magnolia>
References: <20170929130035.24760-1-rgoldwyn@suse.de>
 <20170929130035.24760-3-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170929130035.24760-3-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Fri, Sep 29, 2017 at 08:00:35AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Partial writes are performed when there is an error midway
> while performing the I/O. Perform the write exactly once and
> return the number of bytes written so far, until the error.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  io/io.h           |  1 +
>  io/pwrite.c       | 25 ++++++++++++++++++++++++-
>  man/man8/xfs_io.8 |  3 +++
>  3 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/io/io.h b/io/io.h
> index 6a0fe657..3862985f 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -25,6 +25,7 @@
>  #define IO_RANDOM	( 0)
>  #define IO_FORWARD	( 1)
>  #define IO_BACKWARD	(-1)
> +#define IO_ONCE		( 2)
>  
>  /*
>   * File descriptor options
> diff --git a/io/pwrite.c b/io/pwrite.c
> index 2b85a528..dcf130d6 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -47,6 +47,7 @@ pwrite_help(void)
>  " -W   -- call fsync(2) at the end (included in timing results)\n"
>  " -B   -- write backwards through the range from offset (backwards N bytes)\n"
>  " -F   -- write forwards through the range of bytes from offset (default)\n"
> +" -O   -- perform pwrite call once and return (maybe partial) bytes written\n"
>  " -R   -- write at random offsets in the specified range of bytes\n"
>  " -Z N -- zeed the random number generator (used when writing randomly)\n"
>  "         (heh, zorry, the -s/-S arguments were already in use in pwrite)\n"
> @@ -258,6 +259,22 @@ write_buffer(
>  	return ops;
>  }
>  
> +static int
> +write_once(
> +	off64_t		offset,
> +	long long	count,
> +	long long	*total,
> +	int		pwritev2_flags)
> +{
> +	size_t bytes;
> +	bytes = do_pwrite(file->fd, offset, count, count, pwritev2_flags);
> +	if (bytes < 0)
> +		return -1;
> +	*total = bytes;
> +	return 1;
> +}
> +
> +
>  static int
>  pwrite_f(
>  	int		argc,
> @@ -279,7 +296,7 @@ pwrite_f(
>  	init_cvtnum(&fsblocksize, &fssectsize);
>  	bsize = fsblocksize;
>  
> -	while ((c = getopt(argc, argv, "b:BCdf:Fi:NqRs:S:uV:wWZ:")) != EOF) {
> +	while ((c = getopt(argc, argv, "b:BCdf:Fi:NqRs:OS:uV:wWZ:")) != EOF) {
>  		switch (c) {
>  		case 'b':
>  			tmp = cvtnum(fsblocksize, fssectsize, optarg);
> @@ -301,6 +318,9 @@ pwrite_f(
>  		case 'R':
>  			direction = IO_RANDOM;
>  			break;
> +		case 'O':
> +			direction = IO_ONCE;
> +			break;
>  		case 'd':
>  			dflag = 1;
>  			break;
> @@ -392,6 +412,9 @@ pwrite_f(
>  	case IO_BACKWARD:
>  		c = write_backward(offset, &count, &total, pwritev2_flags);
>  		break;
> +	case IO_ONCE:
> +		c = write_once(offset, count, &total, pwritev2_flags);
> +		break;
>  	default:
>  		total = 0;
>  		ASSERT(0);
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 9c58914f..b7c0f099 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -263,6 +263,9 @@ write the buffers in a reserve sequential direction.
>  .B \-R
>  write the buffers in the give range in a random order.
>  .TP
> +.B \-O
> +perform pwrite once and return the (maybe partial) bytes written.
> +.TP
>  .B \-Z seed
>  specify the random number seed used for random write
>  .TP
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
