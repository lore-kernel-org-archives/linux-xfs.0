Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44322 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756366AbdJJNlz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Oct 2017 09:41:55 -0400
Date: Tue, 10 Oct 2017 09:41:53 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 1/3] xfs_io: Add support for pwritev2()
Message-ID: <20171010134153.GA24506@bfoster.bfoster>
References: <20171010105802.31353-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171010105802.31353-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Tue, Oct 10, 2017 at 05:58:00AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> ---
>  configure.ac          |  1 +
>  include/builddefs.in  |  1 +
>  io/Makefile           |  4 ++++
>  io/pwrite.c           | 43 ++++++++++++++++++++++++++++++-------------
>  m4/package_libcdev.m4 | 16 ++++++++++++++++
>  5 files changed, 52 insertions(+), 13 deletions(-)
> 

Looks Ok to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> diff --git a/configure.ac b/configure.ac
> index 4161c3b4..2320e3e3 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -132,6 +132,7 @@ AC_HAVE_GETMNTENT
>  AC_HAVE_GETMNTINFO
>  AC_HAVE_FALLOCATE
>  AC_HAVE_FIEMAP
> +AC_HAVE_PWRITEV2
>  AC_HAVE_PREADV
>  AC_HAVE_COPY_FILE_RANGE
>  AC_HAVE_SYNC_FILE_RANGE
> diff --git a/include/builddefs.in b/include/builddefs.in
> index ec630bd9..cd58ea8e 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -103,6 +103,7 @@ HAVE_GETMNTINFO = @have_getmntinfo@
>  HAVE_FALLOCATE = @have_fallocate@
>  HAVE_FIEMAP = @have_fiemap@
>  HAVE_PREADV = @have_preadv@
> +HAVE_PWRITEV2 = @have_pwritev2@
>  HAVE_COPY_FILE_RANGE = @have_copy_file_range@
>  HAVE_SYNC_FILE_RANGE = @have_sync_file_range@
>  HAVE_SYNCFS = @have_syncfs@
> diff --git a/io/Makefile b/io/Makefile
> index 47b0a669..050d6bd0 100644
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -90,6 +90,10 @@ ifeq ($(HAVE_PREADV),yes)
>  LCFLAGS += -DHAVE_PREADV -DHAVE_PWRITEV
>  endif
>  
> +ifeq ($(HAVE_PWRITEV2),yes)
> +LCFLAGS += -DHAVE_PWRITEV2
> +endif
> +
>  ifeq ($(HAVE_READDIR),yes)
>  CFILES += readdir.c
>  LCFLAGS += -DHAVE_READDIR
> diff --git a/io/pwrite.c b/io/pwrite.c
> index 1c5dfca1..5ceb26c7 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -62,7 +62,8 @@ do_pwritev(
>  	int		fd,
>  	off64_t		offset,
>  	ssize_t		count,
> -	ssize_t		buffer_size)
> +	ssize_t		buffer_size,
> +	int 		pwritev2_flags)
>  {
>  	int vecs = 0;
>  	ssize_t oldlen = 0;
> @@ -81,7 +82,14 @@ do_pwritev(
>  	} else {
>  		vecs = vectors;
>  	}
> +#ifdef HAVE_PWRITEV2
> +	if (pwritev2_flags)
> +		bytes = pwritev2(fd, iov, vectors, offset, pwritev2_flags);
> +	else
> +		bytes = pwritev(fd, iov, vectors, offset);
> +#else
>  	bytes = pwritev(fd, iov, vectors, offset);
> +#endif
>  
>  	/* restore trimmed iov */
>  	if (oldlen)
> @@ -98,12 +106,13 @@ do_pwrite(
>  	int		fd,
>  	off64_t		offset,
>  	ssize_t		count,
> -	ssize_t		buffer_size)
> +	ssize_t		buffer_size,
> +	int		pwritev2_flags)
>  {
>  	if (!vectors)
>  		return pwrite(fd, buffer, min(count, buffer_size), offset);
>  
> -	return do_pwritev(fd, offset, count, buffer_size);
> +	return do_pwritev(fd, offset, count, buffer_size, pwritev2_flags);
>  }
>  
>  static int
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
> @@ -133,7 +143,8 @@ write_random(
>  				buffersize;
>  		else
>  			off = offset;
> -		bytes = do_pwrite(file->fd, off, buffersize, buffersize);
> +		bytes = do_pwrite(file->fd, off, buffersize, buffersize,
> +				pwritev2_flags);
>  		if (bytes == 0)
>  			break;
>  		if (bytes < 0) {
> @@ -153,7 +164,8 @@ static int
>  write_backward(
>  	off64_t		offset,
>  	long long	*count,
> -	long long	*total)
> +	long long	*total,
> +	int		pwritev2_flags)
>  {
>  	off64_t		end, off = offset;
>  	ssize_t		bytes = 0, bytes_requested;
> @@ -171,7 +183,8 @@ write_backward(
>  	if ((bytes_requested = (off % buffersize))) {
>  		bytes_requested = min(cnt, bytes_requested);
>  		off -= bytes_requested;
> -		bytes = do_pwrite(file->fd, off, bytes_requested, buffersize);
> +		bytes = do_pwrite(file->fd, off, bytes_requested, buffersize,
> +				pwritev2_flags);
>  		if (bytes == 0)
>  			return ops;
>  		if (bytes < 0) {
> @@ -189,7 +202,8 @@ write_backward(
>  	while (cnt > end) {
>  		bytes_requested = min(cnt, buffersize);
>  		off -= bytes_requested;
> -		bytes = do_pwrite(file->fd, off, cnt, buffersize);
> +		bytes = do_pwrite(file->fd, off, cnt, buffersize,
> +				pwritev2_flags);
>  		if (bytes == 0)
>  			break;
>  		if (bytes < 0) {
> @@ -212,7 +226,8 @@ write_buffer(
>  	size_t		bs,
>  	int		fd,
>  	off64_t		skip,
> -	long long	*total)
> +	long long	*total,
> +	int		pwritev2_flags)
>  {
>  	ssize_t		bytes;
>  	long long	bar = min(bs, count);
> @@ -224,7 +239,7 @@ write_buffer(
>  			if (read_buffer(fd, skip + *total, bs, &bar, 0, 1) < 0)
>  				break;
>  		}
> -		bytes = do_pwrite(file->fd, offset, count, bar);
> +		bytes = do_pwrite(file->fd, offset, count, bar, pwritev2_flags);
>  		if (bytes == 0)
>  			break;
>  		if (bytes < 0) {
> @@ -258,6 +273,7 @@ pwrite_f(
>  	int		Cflag, qflag, uflag, dflag, wflag, Wflag;
>  	int		direction = IO_FORWARD;
>  	int		c, fd = -1;
> +	int		pwritev2_flags = 0;
>  
>  	Cflag = qflag = uflag = dflag = wflag = Wflag = 0;
>  	init_cvtnum(&fsblocksize, &fssectsize);
> @@ -365,13 +381,14 @@ pwrite_f(
>  	case IO_RANDOM:
>  		if (!zeed)	/* srandom seed */
>  			zeed = time(NULL);
> -		c = write_random(offset, count, zeed, &total);
> +		c = write_random(offset, count, zeed, &total, pwritev2_flags);
>  		break;
>  	case IO_FORWARD:
> -		c = write_buffer(offset, count, bsize, fd, skip, &total);
> +		c = write_buffer(offset, count, bsize, fd, skip, &total,
> +				pwritev2_flags);
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
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
