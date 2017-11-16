Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56438 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759164AbdKPUdX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Nov 2017 15:33:23 -0500
Subject: Re: [PATCH 1/3] xfsprogs: fix wrong variable type in write_once
 function
References: <20171111172155.31941-1-zlang@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <643a10c5-6987-4870-bd61-932ccdc1fe69@sandeen.net>
Date: Thu, 16 Nov 2017 14:33:22 -0600
MIME-Version: 1.0
In-Reply-To: <20171111172155.31941-1-zlang@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org

On 11/11/17 11:21 AM, Zorro Lang wrote:
> The 'Coverity Scan' found a problem in new write_once() function:
> 
> 272             size_t bytes;
> 273             bytes = do_pwrite(file->fd, offset, count, count, pwritev2_flags);
>>>>     CID 1420710:  Control flow issues  (NO_EFFECT)
>>>>     This less-than-zero comparison of an unsigned value is never true. "bytes < 0UL".
> 274             if (bytes < 0)
> 275                     return -1;
> 
> That's unreasonable. do_pwrite return 'ssize_t' type value, which can
> be less than zero, but we use a 'size_t' to get the return value. So
> change the size_t to ssize_t for it can store the return value
> correctly.
> 
> By the chance, correct all 'ssize_t' type problems in pwrite/pread
> related functions.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

I may rewrite the changelog a bit because this now touches much
more than write_once, but the content seems fine:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> 
> Actrually, this's V3. V3 did more changes in io/pread.c, fix 'ssize_t'
> problem in io/pread.c (V2 only did in io/pwrite.c).
> 
> Thanks,
> Zorro
> 
>  io/pread.c  | 12 ++++++------
>  io/pwrite.c | 14 +++++++-------
>  2 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/io/pread.c b/io/pread.c
> index 7591276d..60650aa3 100644
> --- a/io/pread.c
> +++ b/io/pread.c
> @@ -172,12 +172,12 @@ dump_buffer(
>  }
>  
>  #ifdef HAVE_PREADV
> -static int
> +static ssize_t
>  do_preadv(
>  	int		fd,
>  	off64_t		offset,
> -	ssize_t		count,
> -	ssize_t		buffer_size)
> +	size_t		count,
> +	size_t		buffer_size)
>  {
>  	int		vecs = 0;
>  	ssize_t		oldlen = 0;
> @@ -208,12 +208,12 @@ do_preadv(
>  #define do_preadv(fd, offset, count, buffer_size) (0)
>  #endif
>  
> -static int
> +static ssize_t
>  do_pread(
>  	int		fd,
>  	off64_t		offset,
> -	ssize_t		count,
> -	ssize_t		buffer_size)
> +	size_t		count,
> +	size_t		buffer_size)
>  {
>  	if (!vectors)
>  		return pread(fd, buffer, min(count, buffer_size), offset);
> diff --git a/io/pwrite.c b/io/pwrite.c
> index 26f79579..3df976a8 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -61,12 +61,12 @@ pwrite_help(void)
>  }
>  
>  #ifdef HAVE_PWRITEV
> -static int
> +static ssize_t
>  do_pwritev(
>  	int		fd,
>  	off64_t		offset,
> -	ssize_t		count,
> -	ssize_t		buffer_size,
> +	size_t		count,
> +	size_t		buffer_size,
>  	int 		pwritev2_flags)
>  {
>  	int vecs = 0;
> @@ -105,12 +105,12 @@ do_pwritev(
>  #define do_pwritev(fd, offset, count, buffer_size) (0)
>  #endif
>  
> -static int
> +static ssize_t
>  do_pwrite(
>  	int		fd,
>  	off64_t		offset,
> -	ssize_t		count,
> -	ssize_t		buffer_size,
> +	size_t		count,
> +	size_t		buffer_size,
>  	int		pwritev2_flags)
>  {
>  	if (!vectors)
> @@ -269,7 +269,7 @@ write_once(
>  	long long	*total,
>  	int		pwritev2_flags)
>  {
> -	size_t bytes;
> +	ssize_t bytes;
>  	bytes = do_pwrite(file->fd, offset, count, count, pwritev2_flags);
>  	if (bytes < 0)
>  		return -1;
> 
