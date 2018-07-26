Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48702 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728292AbeGZCVn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jul 2018 22:21:43 -0400
Subject: Re: [PATCH 05/10] xfs_scrub: allow developers to force repairs
References: <153006766483.20121.9285982017465570544.stgit@magnolia>
 <153006769719.20121.5967943300879363502.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5aed0192-7a9b-dbd5-9a52-c52fcd970a63@sandeen.net>
Date: Wed, 25 Jul 2018 18:07:24 -0700
MIME-Version: 1.0
In-Reply-To: <153006769719.20121.5967943300879363502.stgit@magnolia>
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
> Now that we have an error injection knob in the kernel to simulate
> corruptions, enable it in xfs_scrub so that developers can test all
> the repair capabilities.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/scrub.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/scrub/scrub.c b/scrub/scrub.c
> index af665c83..c893f2c9 100644
> --- a/scrub/scrub.c
> +++ b/scrub/scrub.c
> @@ -612,14 +612,18 @@ __xfs_scrub_test(
>  	bool				repair)
>  {
>  	struct xfs_scrub_metadata	meta = {0};
> +	struct xfs_error_injection	inject;
>  	static bool			injected;
>  	int				error;
>  
>  	if (debug_tweak_on("XFS_SCRUB_NO_KERNEL"))
>  		return false;
>  	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !injected) {
> -		str_info(ctx, "XFS_SCRUB_FORCE_REPAIR", "Not supported.");
> -		return false;
> +		inject.fd = ctx->mnt_fd;
> +		inject.errtag = XFS_ERRTAG_FORCE_SCRUB_REPAIR;
> +		error = ioctl(ctx->mnt_fd, XFS_IOC_ERROR_INJECTION, &inject);
> +		if (error == 0)
> +			injected = true;
>  	}
>  
>  	meta.sm_type = type;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
