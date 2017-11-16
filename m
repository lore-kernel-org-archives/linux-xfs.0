Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56546 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759251AbdKPUed (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Nov 2017 15:34:33 -0500
Subject: Re: [PATCH 3/3] xfsprogs: remove useless do_preadv and do_pwritev
 arguments
References: <20171111172155.31941-1-zlang@redhat.com>
 <20171111172155.31941-3-zlang@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <fd7ac10d-22db-30e2-3c91-5e27195db863@sandeen.net>
Date: Thu, 16 Nov 2017 14:34:32 -0600
MIME-Version: 1.0
In-Reply-To: <20171111172155.31941-3-zlang@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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

I'm going to hold off on this one for 4.14; I want to think a bit about
why we have this global in the first place, and if it makes more sense
to eliminate the global and pass the buffer size around properly.

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
