Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4FinZY012792 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 09:44:49 -0600
Message-ID: <4937FAED.7060503@sandeen.net>
Date: Thu, 04 Dec 2008 09:44:45 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix off by one error in page_region_mask()
References: <49378B60.1060603@sgi.com>
In-Reply-To: <49378B60.1060603@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: lachlan@sgi.com
Cc: xfs-oss <xfs@oss.sgi.com>

Lachlan McIlroy wrote:
> final is calculated to be the last bit to set (ie inclusive) but when we
> do the mask shifting final really needs to be first bit not to set.
> 
> For example if first and final are both bit 0 (ie only first bit to be set)
> then mask is completely shifted and becomes all zeroes.
> 
> Or if first is 0 and final is 63 then the mask is shifted one bit when it
> shouldn't be shifted at all.

Lachlan, what's the end result of this bug?  What's the broken behavior?

Thanks,
-Eric

> --- xfs-fix.orig/fs/xfs/linux-2.6/xfs_buf.c
> +++ xfs-fix/fs/xfs/linux-2.6/xfs_buf.c
> @@ -129,15 +129,17 @@ page_region_mask(
>   	int		first, final;
> 
>   	first = BTOPR(offset);
> -	final = BTOPRT(offset + length - 1);
> -	first = min(first, final);
> +	final = BTOPRT(offset + length);
> +
> +	if (first >= final)
> +		return 0UL;
> 
>   	mask = ~0UL;
>   	mask <<= BITS_PER_LONG - (final - first);
>   	mask >>= BITS_PER_LONG - (final);
> 
>   	ASSERT(offset + length <= PAGE_CACHE_SIZE);
> -	ASSERT((final - first) < BITS_PER_LONG && (final - first) >= 0);
> +	ASSERT((final - first) <= BITS_PER_LONG && (final - first) > 0);
> 
>   	return mask;
>   }
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
