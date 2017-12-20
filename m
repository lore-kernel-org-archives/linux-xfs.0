Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48090 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbdLTCsv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 21:48:51 -0500
Date: Tue, 19 Dec 2017 18:48:47 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/7] mkfs: protofile only needs to be set up once
Message-ID: <20171220024847.GK12613@magnolia>
References: <20171218091158.14537-1-david@fromorbit.com>
 <20171218091158.14537-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171218091158.14537-4-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 18, 2017 at 08:11:54PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  mkfs/xfs_mkfs.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 4a9c457ce603..7cc5ee2ddb9d 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -4024,8 +4024,6 @@ main(
>  	 */
>  	calculate_log_size(&cfg, &cli, mp);
>  
> -	protostring = setup_proto(protofile);
> -
>  	if (!quiet || dry_run) {
>  		print_mkfs_cfg(&cfg, dfile, logfile, rtfile);
>  		if (dry_run)
> -- 
> 2.15.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
