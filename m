Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48842 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728352AbeGZCXw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jul 2018 22:23:52 -0400
Subject: Re: [PATCH 06/10] xfs_scrub: don't error out if an optimize-only
 repair isn't supported
References: <153006766483.20121.9285982017465570544.stgit@magnolia>
 <153006770873.20121.6125776702823601560.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <442c155f-967a-acae-9647-00627bb6e0ca@sandeen.net>
Date: Wed, 25 Jul 2018 18:09:33 -0700
MIME-Version: 1.0
In-Reply-To: <153006770873.20121.6125776702823601560.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 6/26/18 7:48 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the kernel told us a metadata object could be optimized, we ask it to
> do the optimization and it spits back that it doesn't support
> optimizing, don't record this as an error since the fs is still
> consistent.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/scrub.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/scrub/scrub.c b/scrub/scrub.c
> index c893f2c9..fe4e880f 100644
> --- a/scrub/scrub.c
> +++ b/scrub/scrub.c
> @@ -782,10 +782,11 @@ _("Filesystem is shut down, aborting."));
>  		case ENOTTY:
>  		case EOPNOTSUPP:
>  			/*
> -			 * If we forced repairs, don't complain if kernel
> -			 * doesn't know how to fix.
> +			 * If we forced repairs or this is a preen, don't
> +			 * error out if the kernel doesn't know how to fix.
>  			 */
> -			if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
> +			if (is_unoptimized(&oldm) ||
> +			    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
>  				return CHECK_DONE;
>  			/* fall through */
>  		case EINVAL:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
