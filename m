Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35788 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753019AbeA3Qrh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Jan 2018 11:47:37 -0500
Subject: Re: [PATCH 3/2] misc: ubsan fixes
References: <151692412532.32390.5360363880930671862.stgit@magnolia>
 <20180126181448.GU9068@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b28f91db-c8d9-11fe-c572-218c4cc41a1c@sandeen.net>
Date: Tue, 30 Jan 2018 10:47:35 -0600
MIME-Version: 1.0
In-Reply-To: <20180126181448.GU9068@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 1/26/18 12:14 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix a few things the undefined behavior sanitizer complained about.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>


Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---

>  db/bit.c    |    4 ++--
>  repair/sb.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/db/bit.c b/db/bit.c
> index a20b6ba..bf8d80e 100644
> --- a/db/bit.c
> +++ b/db/bit.c
> @@ -112,11 +112,11 @@ getbitval(
>  #if __BYTE_ORDER == LITTLE_ENDIAN
>  			if (i == 0 && signext && nbits < 64)
>  				rval = -1LL << nbits;
> -			rval |= 1LL << (nbits - i - 1);
> +			rval |= 1ULL << (nbits - i - 1);
>  #else
>  			if ((i == (nbits - 1)) && signext && nbits < 64)
>  				rval |= (-1LL << nbits);
> -			rval |= 1LL << (nbits - i - 1);
> +			rval |= 1ULL << (nbits - i - 1);
>  #endif
>  		}
>  	}
> diff --git a/repair/sb.c b/repair/sb.c
> index f40cdea..3dc6538 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -89,11 +89,11 @@ verify_sb_blocksize(xfs_sb_t *sb)
>  	/* check to make sure blocksize is legal 2^N, 9 <= N <= 16 */
>  	if (sb->sb_blocksize == 0)
>  		return XR_BAD_BLOCKSIZE;
> -	if (sb->sb_blocksize != (1 << sb->sb_blocklog))
> -		return XR_BAD_BLOCKLOG;
>  	if (sb->sb_blocklog < XFS_MIN_BLOCKSIZE_LOG ||
>  	    sb->sb_blocklog > XFS_MAX_BLOCKSIZE_LOG)
>  		return XR_BAD_BLOCKLOG;
> +	if (sb->sb_blocksize != (1 << sb->sb_blocklog))
> +		return XR_BAD_BLOCKLOG;
>  
>  	return 0;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
