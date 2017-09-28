Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34118 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750775AbdI1Tba (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Sep 2017 15:31:30 -0400
Date: Thu, 28 Sep 2017 12:31:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] Allow partial writes
Message-ID: <20170928193120.GR5020@magnolia>
References: <20170928185426.9070-1-rgoldwyn@suse.de>
 <20170928185426.9070-3-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170928185426.9070-3-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Thu, Sep 28, 2017 at 01:54:26PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Partial writes are performed when there is an error midway
> while performing the I/O. Perform the write exactly once and
> return the number of bytes written.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  io/io.h           |  1 +
>  io/pwrite.c       | 25 ++++++++++++++++++++++++-
>  man/man8/xfs_io.8 |  3 +++
>  3 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/io/io.h b/io/io.h
> index 2bc7ac4a..5875e85a 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -24,6 +24,7 @@
>  #define IO_RANDOM	( 0)
>  #define IO_FORWARD	( 1)
>  #define IO_BACKWARD	(-1)
> +#define IO_PARTIAL	(2)

I would name this CALL_ONCE instead of PARTIAL since we don't know
beforehand that the write will return partial results -- it could
succeed at writing the entire buffer.

--D

>  
>  /*
>   * File descriptor options
> diff --git a/io/pwrite.c b/io/pwrite.c
> index 8289c3ee..40f537b3 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -47,6 +47,7 @@ pwrite_help(void)
>  " -W   -- call fsync(2) at the end (included in timing results)\n"
>  " -B   -- write backwards through the range from offset (backwards N bytes)\n"
>  " -F   -- write forwards through the range of bytes from offset (default)\n"
> +" -P   -- return Partial writes, perform one call and return bytes written\n"
>  " -R   -- write at random offsets in the specified range of bytes\n"
>  " -Z N -- zeed the random number generator (used when writing randomly)\n"
>  "         (heh, zorry, the -s/-S arguments were already in use in pwrite)\n"
> @@ -255,6 +256,22 @@ write_buffer(
>  	return ops;
>  }
>  
> +static int
> +write_partial(
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
> @@ -276,7 +293,7 @@ pwrite_f(
>  	init_cvtnum(&fsblocksize, &fssectsize);
>  	bsize = fsblocksize;
>  
> -	while ((c = getopt(argc, argv, "b:BCdf:Fi:NqRs:S:uV:wWZ:")) != EOF) {
> +	while ((c = getopt(argc, argv, "b:BCdf:Fi:NqRs:PS:uV:wWZ:")) != EOF) {
>  		switch (c) {
>  		case 'b':
>  			tmp = cvtnum(fsblocksize, fssectsize, optarg);
> @@ -298,6 +315,9 @@ pwrite_f(
>  		case 'R':
>  			direction = IO_RANDOM;
>  			break;
> +		case 'P':
> +			direction = IO_PARTIAL;
> +			break;
>  		case 'd':
>  			dflag = 1;
>  			break;
> @@ -389,6 +409,9 @@ pwrite_f(
>  	case IO_BACKWARD:
>  		c = write_backward(offset, &count, &total, pwritev2_flags);
>  		break;
> +	case IO_PARTIAL:
> +		c = write_partial(offset, count, &total, pwritev2_flags);
> +		break;
>  	default:
>  		total = 0;
>  		ASSERT(0);
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index f410ce9a..b21a8145 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -229,6 +229,9 @@ write the buffers in a reserve sequential direction.
>  .B \-R
>  write the buffers in the give range in a random order.
>  .TP
> +.B \-P
> +return Partial writes, perform one call and return the bytes written.
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
