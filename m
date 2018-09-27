Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60034 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727320AbeI1A6G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Sep 2018 20:58:06 -0400
Subject: Re: [PATCH 3/3] xfsprogs: remove useless do_preadv and do_pwritev
 arguments
References: <20171111172155.31941-1-zlang@redhat.com>
 <20171111172155.31941-3-zlang@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4bd7efb7-627a-ead5-083c-55a168631a72@sandeen.net>
Date: Thu, 27 Sep 2018 13:38:30 -0500
MIME-Version: 1.0
In-Reply-To: <20171111172155.31941-3-zlang@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org

On 11/11/17 11:21 AM, Zorro Lang wrote:
> do_preadv and do_pwritev all have a 'buffer_size' argument, but they
> never used it. Instead of it, they use global 'buffersize' variable,
> which is initialized in alloc_buffer(). As the 'buffer_size' is
> useless, so remove it for clear code.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

Hi Zorro, going through old patches and remembered that I never came
back to this one, sorry.

I think that just removing it is ok.  do_preadv & do_pwritev
both use iov and buffersize, each is a global variable; there is no
need to pass in buffer size any more than there is a need to
pass in the iov itself.  I'll go ahead & merge this as is.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric

> ---
>  io/pread.c  | 7 +++----
>  io/pwrite.c | 5 ++---
>  2 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/io/pread.c b/io/pread.c
> index 60650aa3..98e992b0 100644
> --- a/io/pread.c
> +++ b/io/pread.c
> @@ -176,8 +176,7 @@ static ssize_t
>  do_preadv(
>  	int		fd,
>  	off64_t		offset,
> -	size_t		count,
> -	size_t		buffer_size)
> +	size_t		count)
>  {
>  	int		vecs = 0;
>  	ssize_t		oldlen = 0;
> @@ -205,7 +204,7 @@ do_preadv(
>  	return bytes;
>  }
>  #else
> -#define do_preadv(fd, offset, count, buffer_size) (0)
> +#define do_preadv(fd, offset, count) (0)
>  #endif
>  
>  static ssize_t
> @@ -218,7 +217,7 @@ do_pread(
>  	if (!vectors)
>  		return pread(fd, buffer, min(count, buffer_size), offset);
>  
> -	return do_preadv(fd, offset, count, buffer_size);
> +	return do_preadv(fd, offset, count);
>  }
>  
>  static int
> diff --git a/io/pwrite.c b/io/pwrite.c
> index a89edfd0..f75c6164 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -66,7 +66,6 @@ do_pwritev(
>  	int		fd,
>  	off64_t		offset,
>  	size_t		count,
> -	size_t		buffer_size,
>  	int 		pwritev2_flags)
>  {
>  	int vecs = 0;
> @@ -102,7 +101,7 @@ do_pwritev(
>  	return bytes;
>  }
>  #else
> -#define do_pwritev(fd, offset, count, buffer_size, pwritev2_flags) (0)
> +#define do_pwritev(fd, offset, count, pwritev2_flags) (0)
>  #endif
>  
>  static ssize_t
> @@ -116,7 +115,7 @@ do_pwrite(
>  	if (!vectors)
>  		return pwrite(fd, buffer, min(count, buffer_size), offset);
>  
> -	return do_pwritev(fd, offset, count, buffer_size, pwritev2_flags);
> +	return do_pwritev(fd, offset, count, pwritev2_flags);
>  }
>  
>  static int
> 
