Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48228 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964828AbeALQsZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Jan 2018 11:48:25 -0500
Date: Fri, 12 Jan 2018 08:47:38 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH][xfs-next] xfs: fix check on struct_version for versions
 4 or greater
Message-ID: <20180112164738.GW5602@magnolia>
References: <20180112163715.27169-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180112163715.27169-1-colin.king@canonical.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Colin King <colin.king@canonical.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, Eric Sandeen <sandeen@redhat.com>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jan 12, 2018 at 04:37:15PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> It appears that the check for versions 4 or more is incorrect and is
> off-by-one. Fix this.
> 
> Detected by CoverityScan, CID#1463775 ("Logically dead code")
> 
> Fixes: ac503a4cc9e8 ("xfs: refactor the geometry structure filling function")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_sb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 35b005d66977..869a2f3f0375 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -951,7 +951,7 @@ xfs_fs_geometry(
>  	geo->rtsectsize = sbp->sb_blocksize;
>  	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
>  
> -	if (struct_version < 3)
> +	if (struct_version < 4)
>  		return 0;
>  
>  	if (xfs_sb_version_haslogv2(sbp))
> -- 
> 2.15.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
