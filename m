Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 Nov 2007 15:57:40 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lABNvXbP028420
	for <xfs@oss.sgi.com>; Sun, 11 Nov 2007 15:57:35 -0800
Message-ID: <473796EF.6050104@sandeen.net>
Date: Sun, 11 Nov 2007 17:57:35 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [xfs-masters] [PATCH] fs/xfs: remove duplicated defines
References: <20071111134351.106efb98@lucky.kitzblitz>
In-Reply-To: <20071111134351.106efb98@lucky.kitzblitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-masters@oss.sgi.com
Cc: xfs@oss.sgi.com, kernel-janitors@vger.kernel.org

Nicolas Kaiser wrote:
> Remove duplicated defines.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---

Heh, each defined twice, but used 0 times in the kernel.  Could probably
just remove them altogether (though I guess btoc is used in
xfstests/ltp/doio.c in userspace/xfstests, but that's the *only* place)

-Eric

>  fs/xfs/linux-2.6/xfs_linux.h |    4 ----
>  1 file changed, 4 deletions(-)
> 
> --- a/fs/xfs/linux-2.6/xfs_linux.h	2007-11-07 11:26:20.000000000 +0100
> +++ b/fs/xfs/linux-2.6/xfs_linux.h	2007-11-11 13:07:11.000000000 +0100
> @@ -167,12 +167,8 @@
>  
>  /* clicks to bytes */
>  #define	ctob(x)		((__psunsigned_t)(x)<<BPCSHIFT)
> -#define btoct(x)        ((__psunsigned_t)(x)>>BPCSHIFT)
>  #define	ctob64(x)	((__uint64_t)(x)<<BPCSHIFT)
>  
> -/* bytes to clicks */
> -#define btoc(x)         (((__psunsigned_t)(x)+(NBPC-1))>>BPCSHIFT)
> -
>  #define ENOATTR		ENODATA		/* Attribute not found */
>  #define EWRONGFS	EINVAL		/* Mount with wrong filesystem type */
>  #define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
> 
> 
