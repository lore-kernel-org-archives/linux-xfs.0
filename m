Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36612 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752383AbdDFPmM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2017 11:42:12 -0400
Date: Thu, 6 Apr 2017 08:42:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] mkfs: rtinherit minval should be 0
Message-ID: <20170406154208.GW4864@birch.djwong.org>
References: <20170406143426.19727-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170406143426.19727-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 06, 2017 at 04:34:26PM +0200, Jan Tulak wrote:
> As with any other option, rtinherit=[0|1], but minval was incorrectly
> set to 1, so it was not possible to disable this option.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  mkfs/xfs_mkfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 6fedc05c..5aac4d1b 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -290,7 +290,7 @@ struct opt_params dopts = {
>  		},
>  		{ .index = D_RTINHERIT,
>  		  .conflicts = { LAST_CONFLICT },
> -		  .minval = 1,
> +		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
> -- 
> 2.12.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
