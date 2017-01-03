Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60862 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760347AbdACSUA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jan 2017 13:20:00 -0500
Subject: Re: [PATCH] Fix max_retries _show and _store functions
References: <20170103175331.8089-1-cmaiolino@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7818525d-fd15-d245-a958-1648b5df3ecd@sandeen.net>
Date: Tue, 3 Jan 2017 12:19:53 -0600
MIME-Version: 1.0
In-Reply-To: <20170103175331.8089-1-cmaiolino@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On 1/3/17 11:53 AM, Carlos Maiolino wrote:
> max_retries _show and _store functions should test against cfg->max_retries,
> not cfg->retry_timeout
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Whoever made those mistakes should be very ashamed.  ;)
I guess it was a cut and paste error.  :(

This should probably cc: stable, too.

Thanks,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

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
>  	else
>  		cfg->max_retries = val;
>  	return count;
> 
