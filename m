Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59392 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbeKMGG5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Nov 2018 01:06:57 -0500
Subject: Re: [PATCH] xfs: Remove noinline from #define STATIC
References: <7302f4a13c1cbf62b07f636878ce25fcca84b6c4.camel@perches.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6420cf91-89c8-a876-7a0d-25ab8ba428b8@sandeen.net>
Date: Mon, 12 Nov 2018 14:12:08 -0600
MIME-Version: 1.0
In-Reply-To: <7302f4a13c1cbf62b07f636878ce25fcca84b6c4.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Joe Perches <joe@perches.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On 11/10/18 7:21 PM, Joe Perches wrote:
> Reduce total object size quite a bit (~32KB) and presumably
> improve performance at the same time.
> 
> Total object size old vs new (x86-64 defconfig with xfs)
> 
>     text	   data	    bss	    dec	    hex	filename
> - 959351	 165573	    632	1125556	 112cb4	(TOTALS) (old)
> + 924683	 165669	    632	1090984	 10a5a8	(TOTALS) (new)

And what does it do to maximum stack excursions?

-Eric

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/xfs/xfs_linux.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index edbd5a210df2..f33c8b626bca 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -242,7 +242,7 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
>  #endif /* XFS_WARN */
>  #endif /* DEBUG */
>  
> -#define STATIC static noinline
> +#define STATIC static
>  
>  #ifdef CONFIG_XFS_RT
>  
> 
