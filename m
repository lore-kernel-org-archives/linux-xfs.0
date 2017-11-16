Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56446 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759254AbdKPUdf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Nov 2017 15:33:35 -0500
Subject: Re: [PATCH 2/3] xfsprogs: fix wrong do_pwritev definition
References: <20171111172155.31941-1-zlang@redhat.com>
 <20171111172155.31941-2-zlang@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <fcce9c12-2a5f-8682-75dc-b1a9c7724efc@sandeen.net>
Date: Thu, 16 Nov 2017 14:33:34 -0600
MIME-Version: 1.0
In-Reply-To: <20171111172155.31941-2-zlang@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org

On 11/11/17 11:21 AM, Zorro Lang wrote:
> In io/pwrite.c, if not define HAVE_PWRITEV, we will use:
>   #define do_pwritev(fd, offset, count, buffer_size) (0)
> 
> But the real do_pwritev() function is:
>   do_pwritev(fd, offset, count, buffer_size, pwritev2_flags);
> 
> There's one more 'pwritev2_flags' argument.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  io/pwrite.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io/pwrite.c b/io/pwrite.c
> index 3df976a8..a89edfd0 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -102,7 +102,7 @@ do_pwritev(
>  	return bytes;
>  }
>  #else
> -#define do_pwritev(fd, offset, count, buffer_size) (0)
> +#define do_pwritev(fd, offset, count, buffer_size, pwritev2_flags) (0)
>  #endif
>  
>  static ssize_t
> 
