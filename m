Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47600 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932197AbeCBWLZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Mar 2018 17:11:25 -0500
Subject: Re: [PATCH 01/16] misc: fix gcc 7.3 warnings
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
 <151993158177.22223.13396508401318390165.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <af22a8cb-a8b5-627a-6202-19ff035ad82c@sandeen.net>
Date: Fri, 2 Mar 2018 16:11:24 -0600
MIME-Version: 1.0
In-Reply-To: <151993158177.22223.13396508401318390165.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org



On 3/1/18 1:13 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix various compiler warnings that pop up in 7.3.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

(after long code archaeology session and reading to be sure
that last fallthrough really is correct, ugh, comments
would have been good when _cnt & _bno were merged...)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  db/bit.c        |    4 ++--
>  repair/dinode.c |    1 +
>  repair/scan.c   |    1 +
>  3 files changed, 4 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/db/bit.c b/db/bit.c
> index bf8d80e..a6d8c9f 100644
> --- a/db/bit.c
> +++ b/db/bit.c
> @@ -111,11 +111,11 @@ getbitval(
>  			/* handle endian swap here */
>  #if __BYTE_ORDER == LITTLE_ENDIAN
>  			if (i == 0 && signext && nbits < 64)
> -				rval = -1LL << nbits;
> +				rval = (~0ULL) << nbits;
>  			rval |= 1ULL << (nbits - i - 1);
>  #else
>  			if ((i == (nbits - 1)) && signext && nbits < 64)
> -				rval |= (-1LL << nbits);
> +				rval |= ((~0ULL) << nbits);
>  			rval |= 1ULL << (nbits - i - 1);
>  #endif
>  		}
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 32cc769..07bcf80 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -525,6 +525,7 @@ _("data fork in rt inode %" PRIu64 " found metadata block %" PRIu64 " in rt bmap
>  		case XR_E_INUSE:
>  			if (pwe)
>  				break;
> +			/* fall through */
>  		case XR_E_MULT:
>  			set_rtbmap(ext, XR_E_MULT);
>  			do_warn(
> diff --git a/repair/scan.c b/repair/scan.c
> index e4ac4a7..0fc41f2 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -705,6 +705,7 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
>  							     XR_E_FREE);
>  						break;
>  					}
> +					/* fall through */
>  				default:
>  					do_warn(
>  	_("block (%d,%d-%d) multiply claimed by %s space tree, state - %d\n"),
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
