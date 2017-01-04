Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49855 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752334AbdADF6J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2017 00:58:09 -0500
Date: Tue, 3 Jan 2017 21:58:03 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] Fix max_retries _show and _store functions
Message-ID: <20170104055803.GE14031@birch.djwong.org>
References: <20170103175331.8089-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170103175331.8089-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 03, 2017 at 06:53:31PM +0100, Carlos Maiolino wrote:
> max_retries _show and _store functions should test against cfg->max_retries,
> not cfg->retry_timeout
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_sysfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 276d302..de6195e 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -396,7 +396,7 @@ max_retries_show(
>  	int		retries;
>  	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
>  
> -	if (cfg->retry_timeout == XFS_ERR_RETRY_FOREVER)
> +	if (cfg->max_retries == XFS_ERR_RETRY_FOREVER)
>  		retries = -1;
>  	else
>  		retries = cfg->max_retries;
> @@ -422,7 +422,7 @@ max_retries_store(
>  		return -EINVAL;
>  
>  	if (val == -1)
> -		cfg->retry_timeout = XFS_ERR_RETRY_FOREVER;
> +		cfg->max_retries = XFS_ERR_RETRY_FOREVER;

Applied, thanks.

--D

>  	else
>  		cfg->max_retries = val;
>  	return count;
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
