Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49080 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753347AbeBLUx0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Feb 2018 15:53:26 -0500
Subject: Re: [PATCH 5/7] xfs_scrub: reclassify some of the warning messages
References: <151787293446.3743.11110014829952400444.stgit@magnolia>
 <151787297178.3743.12195489468667039346.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b798e93f-4b52-2dd6-d715-580ffde96df7@sandeen.net>
Date: Mon, 12 Feb 2018 14:53:25 -0600
MIME-Version: 1.0
In-Reply-To: <151787297178.3743.12195489468667039346.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 2/5/18 5:22 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Some of the warning messages are actually runtime errors in optional
> components, so turn them into informational messages.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/inodes.c |    6 +++---
>  scrub/phase6.c |    4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/scrub/inodes.c b/scrub/inodes.c
> index 57b773e..744b003 100644
> --- a/scrub/inodes.c
> +++ b/scrub/inodes.c
> @@ -157,7 +157,7 @@ xfs_iterate_inodes_range(
>  		bulkreq.icount = inogrp.xi_alloccount;
>  		error = ioctl(ctx->mnt_fd, XFS_IOC_FSBULKSTAT, &bulkreq);
>  		if (error)
> -			str_warn(ctx, descr, "%s", strerror_r(errno,
> +			str_info(ctx, descr, "%s", strerror_r(errno,
>  						buf, DESCR_BUFSZ));
>  
>  		xfs_iterate_inodes_range_check(ctx, &inogrp, bstat);
> @@ -181,8 +181,8 @@ xfs_iterate_inodes_range(
>  				}
>  				snprintf(idescr, DESCR_BUFSZ, "inode %"PRIu64,
>  						(uint64_t)bs->bs_ino);
> -				str_warn(ctx, idescr, "%s", strerror_r(error,
> -						buf, DESCR_BUFSZ));
> +				str_info(ctx, idescr,
> +_("Changed too many times during scan; giving up."));
>  				break;
>  			case XFS_ITERATE_INODES_ABORT:
>  				error = 0;
> diff --git a/scrub/phase6.c b/scrub/phase6.c
> index f985950..e255eef 100644
> --- a/scrub/phase6.c
> +++ b/scrub/phase6.c
> @@ -188,7 +188,6 @@ xfs_report_verify_inode(
>  	void				*arg)
>  {
>  	char				descr[DESCR_BUFSZ];
> -	char				buf[DESCR_BUFSZ];
>  	bool				moveon;
>  	int				fd;
>  	int				error;
> @@ -209,7 +208,8 @@ xfs_report_verify_inode(
>  		if (error == ESTALE)
>  			return error;
>  
> -		str_warn(ctx, descr, "%s", strerror_r(error, buf, DESCR_BUFSZ));
> +		str_info(ctx, descr,
> +_("Disappeared during read error reporting."));
>  		return error;
>  	}
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
