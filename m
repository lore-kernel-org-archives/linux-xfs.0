Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33016 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751462AbdKKPqt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 11 Nov 2017 10:46:49 -0500
Subject: Re: [PATCH v2] xfsprogs: fix wrong variable type in write_once
 function
References: <20171111135759.7431-1-zlang@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <96daff60-b086-ef36-2cbf-0b21d01d42b6@sandeen.net>
Date: Sat, 11 Nov 2017 09:46:48 -0600
MIME-Version: 1.0
In-Reply-To: <20171111135759.7431-1-zlang@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org

On 11/11/17 7:57 AM, Zorro Lang wrote:
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
> By the chance, correct all 'ssize_t' type problems in pwrite related
> functions.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> V2 changed more than V1, as below:
> 1) The return value type of do_pwritev and do_pwrite, from 'int' to 'ssize_t'
> 2) The arguments type of do_pwritev and do_pwrite, from 'ssize_t' to 'size_t'
> 
> Thanks,
> Zorro
> 
>  io/pwrite.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
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

I had not noticed this before, but this is odd; buffer_size is not used
in this function. Instead, we test the global "buffersize"

I'm not sure what's going on there, need to read the code bit more.
That's probably a separate fix though.

I think the rest looks ok,

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>



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
