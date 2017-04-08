Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43902 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751841AbdDHO0n (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 8 Apr 2017 10:26:43 -0400
Subject: Re: [PATCH] libxfs: fix xfs_extent_busy_flush macro definition
References: <20170408025255.GP4864@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <585a3bce-22f8-e162-87a7-bfa6e57ffad5@sandeen.net>
Date: Sat, 8 Apr 2017 09:26:42 -0500
MIME-Version: 1.0
In-Reply-To: <20170408025255.GP4864@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 4/7/17 9:52 PM, Darrick J. Wong wrote:
> xfs_extent_busy_flush is a void function, so don't reduce it to zero.
> This shuts up gcc warnings about do-nothing statements.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Whoops, thanks.  Need to test w/ newer gcc I guess, sorry!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  libxfs/libxfs_priv.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index c2d4494..167786e 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -419,7 +419,7 @@ roundup_64(__uint64_t x, __uint32_t y)
>  	*(busy_gen) = __foo;					\
>  	false;							\
>  })
> -#define xfs_extent_busy_flush(mp,pag,busy_gen)		(0)
> +#define xfs_extent_busy_flush(mp,pag,busy_gen)		do { } while(0)
>  
>  /* avoid unused variable warning */
>  #define xfs_alloc_busy_insert(tp,ag,b,len)	({	\
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
