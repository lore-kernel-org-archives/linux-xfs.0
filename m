Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33158 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbfEFWUN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 May 2019 18:20:13 -0400
Subject: Re: [PATCH] db/malloc: Use posix_memalign instead of deprecated
 valloc
References: <20190506210326.29581-1-rosenp@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b85f5489-70ed-3145-3989-592ee1de3899@sandeen.net>
Date: Mon, 6 May 2019 17:20:11 -0500
MIME-Version: 1.0
In-Reply-To: <20190506210326.29581-1-rosenp@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Rosen Penev <rosenp@gmail.com>, linux-xfs@vger.kernel.org



On 5/6/19 4:03 PM, Rosen Penev wrote:
> valloc is not available with uClibc-ng as well as being deprecated, which
> causes compilation errors. aligned_alloc is not available before C11 so
> used posix_memalign.'
> 
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  db/malloc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/db/malloc.c b/db/malloc.c
> index 77b3e022..38fe0b05 100644
> --- a/db/malloc.c
> +++ b/db/malloc.c
> @@ -44,8 +44,7 @@ xmalloc(
>  {
>  	void	*ptr;
>  
> -	ptr = valloc(size);
> -	if (ptr)
> +	if(!posix_memalign(&ptr, sysconf(_SC_PAGESIZE), size))


I'll stick a space after the 'if' but otherwise, seems fine, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


>  		return ptr;
>  	badmalloc();
>  	/* NOTREACHED */
> 
