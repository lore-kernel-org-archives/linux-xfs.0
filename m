Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 19:03:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A23Ubo007970
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 19:03:32 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id MAA21152; Thu, 10 Apr 2008 12:04:04 +1000
Message-ID: <47FD7594.10206@sgi.com>
Date: Thu, 10 Apr 2008 12:04:04 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch] fix up xfsbdstrat b0rkage
References: <20080410014737.GO108924158@sgi.com>
In-Reply-To: <20080410014737.GO108924158@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> Not sure how this got through testing, but it's screwed.
> 
> ---
> 
> Don't error out on good I/Os in xfsbdstrat().
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  fs/xfs/linux-2.6/xfs_lrw.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_lrw.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_lrw.c	2008-04-10 11:02:30.000000000 +1000
> +++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_lrw.c	2008-04-10 11:40:54.533326543 +1000
> @@ -885,8 +885,10 @@ xfsbdstrat(
>  	struct xfs_buf		*bp)
>  {
>  	ASSERT(mp);
> -	if (!XFS_FORCED_SHUTDOWN(mp))
> +	if (!XFS_FORCED_SHUTDOWN(mp)) {
>  		xfs_buf_iorequest(bp);
> +		return;
> +	}
>  
>  	xfs_buftrace("XFSBDSTRAT IOERROR", bp);
>  	xfs_bioerror_relse(bp);

Looks good Dave,

Don
