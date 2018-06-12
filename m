Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35212 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934619AbeFLWOD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jun 2018 18:14:03 -0400
Date: Tue, 12 Jun 2018 15:14:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/7] mkfs: properly fix TOCTOU open/stat race in config
 file handling
Message-ID: <20180612221401.GQ22045@magnolia>
References: <1528831883-21879-1-git-send-email-sandeen@sandeen.net>
 <1528831883-21879-6-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1528831883-21879-6-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 12, 2018 at 02:31:21PM -0500, Eric Sandeen wrote:
> After open of the configfile, simply fstat() that fd to ensure that
> we are checking the file we just opened, not something that got
> renamed in between.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  mkfs/config.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mkfs/config.c b/mkfs/config.c
> index f27e480..940a055 100644
> --- a/mkfs/config.c
> +++ b/mkfs/config.c
> @@ -550,7 +550,7 @@ open_cli_config(
>  		if (fd < 0)
>  			goto out;
>  
> -		ret = fstatat(dirfd, cli_config_file, &st, AT_SYMLINK_NOFOLLOW);
> +		ret = fstat(fd, &st);
>  		if (ret != 0)
>  			goto err_out_close;
>  
> @@ -563,7 +563,7 @@ open_cli_config(
>  
>  	memcpy(*fpath, cli_config_file, strlen(cli_config_file));
>  
> -	ret = fstatat(AT_FDCWD, cli_config_file, &st, AT_SYMLINK_NOFOLLOW);
> +	ret = fstat(fd, &st);
>  	if (ret != 0)
>  		goto err_out_close;
>  
> @@ -593,7 +593,7 @@ int
>  open_config_file(
>  	const char			*cli_config_file,
>  	struct mkfs_default_params	*dft,
> -	char				**fpath)
> +	char				**fpath)	/* path where config is found */
>  {
>  	int				dirfd, fd = -1, len, ret;
>  	struct stat			st;
> @@ -628,7 +628,7 @@ open_config_file(
>  		goto err_out_close;
>  	}
>  
> -	ret = fstatat(dirfd, "default", &st, AT_SYMLINK_NOFOLLOW);
> +	ret = fstat(fd, &st);
>  	if (ret != 0)
>  		goto err_out_close;
>  
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
