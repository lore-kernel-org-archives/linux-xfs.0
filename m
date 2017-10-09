Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6254 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754084AbdJIPCV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Oct 2017 11:02:21 -0400
Date: Mon, 9 Oct 2017 11:02:19 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 1/3] xfs_io: Add support for pwritev2()
Message-ID: <20171009150219.GA19322@bfoster.bfoster>
References: <20170929130035.24760-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170929130035.24760-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Fri, Sep 29, 2017 at 08:00:33AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  configure.ac          |  1 +
>  include/builddefs.in  |  1 +
>  io/Makefile           |  4 ++++
>  io/pwrite.c           | 39 ++++++++++++++++++++++++++-------------
>  m4/package_libcdev.m4 | 16 ++++++++++++++++
>  5 files changed, 48 insertions(+), 13 deletions(-)
> 
...
> diff --git a/io/pwrite.c b/io/pwrite.c
> index 1c5dfca1..e7d411bb 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
...
> @@ -111,7 +120,8 @@ write_random(
>  	off64_t		offset,
>  	long long	count,
>  	unsigned int	seed,
> -	long long	*total)
> +	long long	*total,
> +	int 		pwritev2_flags)
>  {
>  	off64_t		off, range;
>  	ssize_t		bytes;
> @@ -133,7 +143,7 @@ write_random(
>  				buffersize;
>  		else
>  			off = offset;
> -		bytes = do_pwrite(file->fd, off, buffersize, buffersize);
> +		bytes = do_pwrite(file->fd, off, buffersize, buffersize, pwritev2_flags);

Looks like a couple or so long lines here and below. We usually wrap
lines at 80 chars. Otherwise this seems fine to me.

Brian

>  		if (bytes == 0)
>  			break;
>  		if (bytes < 0) {
> @@ -153,7 +163,8 @@ static int
>  write_backward(
>  	off64_t		offset,
>  	long long	*count,
> -	long long	*total)
> +	long long	*total,
> +	int		pwritev2_flags)
>  {
>  	off64_t		end, off = offset;
>  	ssize_t		bytes = 0, bytes_requested;
> @@ -171,7 +182,7 @@ write_backward(
>  	if ((bytes_requested = (off % buffersize))) {
>  		bytes_requested = min(cnt, bytes_requested);
>  		off -= bytes_requested;
> -		bytes = do_pwrite(file->fd, off, bytes_requested, buffersize);
> +		bytes = do_pwrite(file->fd, off, bytes_requested, buffersize, pwritev2_flags);
>  		if (bytes == 0)
>  			return ops;
>  		if (bytes < 0) {
> @@ -189,7 +200,7 @@ write_backward(
>  	while (cnt > end) {
>  		bytes_requested = min(cnt, buffersize);
>  		off -= bytes_requested;
> -		bytes = do_pwrite(file->fd, off, cnt, buffersize);
> +		bytes = do_pwrite(file->fd, off, cnt, buffersize, pwritev2_flags);
>  		if (bytes == 0)
>  			break;
>  		if (bytes < 0) {
> @@ -212,7 +223,8 @@ write_buffer(
>  	size_t		bs,
>  	int		fd,
>  	off64_t		skip,
> -	long long	*total)
> +	long long	*total,
> +	int		pwritev2_flags)
>  {
>  	ssize_t		bytes;
>  	long long	bar = min(bs, count);
> @@ -224,7 +236,7 @@ write_buffer(
>  			if (read_buffer(fd, skip + *total, bs, &bar, 0, 1) < 0)
>  				break;
>  		}
> -		bytes = do_pwrite(file->fd, offset, count, bar);
> +		bytes = do_pwrite(file->fd, offset, count, bar, pwritev2_flags);
>  		if (bytes == 0)
>  			break;
>  		if (bytes < 0) {
> @@ -258,6 +270,7 @@ pwrite_f(
>  	int		Cflag, qflag, uflag, dflag, wflag, Wflag;
>  	int		direction = IO_FORWARD;
>  	int		c, fd = -1;
> +	int		pwritev2_flags = 0;
>  
>  	Cflag = qflag = uflag = dflag = wflag = Wflag = 0;
>  	init_cvtnum(&fsblocksize, &fssectsize);
> @@ -365,13 +378,13 @@ pwrite_f(
>  	case IO_RANDOM:
>  		if (!zeed)	/* srandom seed */
>  			zeed = time(NULL);
> -		c = write_random(offset, count, zeed, &total);
> +		c = write_random(offset, count, zeed, &total, pwritev2_flags);
>  		break;
>  	case IO_FORWARD:
> -		c = write_buffer(offset, count, bsize, fd, skip, &total);
> +		c = write_buffer(offset, count, bsize, fd, skip, &total, pwritev2_flags);
>  		break;
>  	case IO_BACKWARD:
> -		c = write_backward(offset, &count, &total);
> +		c = write_backward(offset, &count, &total, pwritev2_flags);
>  		break;
>  	default:
>  		total = 0;
> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index fa5b6397..48da0783 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -146,6 +146,22 @@ AC_DEFUN([AC_HAVE_PREADV],
>      AC_SUBST(have_preadv)
>    ])
>  
> +#
> +# Check if we have a pwritev2 libc call (Linux)
> +#
> +AC_DEFUN([AC_HAVE_PWRITEV2],
> +  [ AC_MSG_CHECKING([for pwritev2])
> +    AC_TRY_LINK([
> +#define _BSD_SOURCE
> +#include <sys/uio.h>
> +    ], [
> +         pwritev2(0, 0, 0, 0, 0);
> +    ], have_pwritev2=yes
> +       AC_MSG_RESULT(yes),
> +       AC_MSG_RESULT(no))
> +    AC_SUBST(have_pwritev2)
> +  ])
> +
>  #
>  # Check if we have a copy_file_range system call (Linux)
>  #
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
