Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47994 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755460AbeFSUlN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 16:41:13 -0400
Date: Tue, 19 Jun 2018 13:40:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] mkfs: removed unused dft var from open_config_file
Message-ID: <20180619204057.GE21698@magnolia>
References: <b437d75c-7226-19bc-c709-9b706ef853eb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b437d75c-7226-19bc-c709-9b706ef853eb@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>

On Tue, Jun 19, 2018 at 03:07:01PM -0500, Eric Sandeen wrote:
> This should have been removed when I removed the dft->type
> tracking.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/mkfs/config.c b/mkfs/config.c
> index 70d752c..e4534c3 100644
> --- a/mkfs/config.c
> +++ b/mkfs/config.c
> @@ -549,9 +549,8 @@ config_stat_check(
>   * If not specified or if above fails, try either cli-spec'd file or "default"
>   * in MKFS_XFS_CONF_DIR.
>   *
> - * If any config file is successfully opened, dft->type is set to reflect the
> - * source, an fd is returned, and the absolute path is returned in **fpath,
> - * which must be free()'d by the caller.
> + * If any config file is successfully opened, an fd is returned, and the
> + * absolute path is returned in **fpath, which must be free()'d by the caller.
>   *
>   * If a cli-specified file is not found -1 is returned and errno set. Otherwise
>   * the file descriptor is returned.
> @@ -559,7 +558,6 @@ config_stat_check(
>  int
>  open_config_file(
>  	const char			*config_file,
> -	struct mkfs_default_params	*dft,
>  	char				**fpath)
>  {
>  	int				dirfd = -1, fd = -1, len, ret = 0;
> diff --git a/mkfs/config.h b/mkfs/config.h
> index f4af2c7..d338347 100644
> --- a/mkfs/config.h
> +++ b/mkfs/config.h
> @@ -79,7 +79,6 @@ struct mkfs_default_params {
>  int
>  open_config_file(
>  	const char			*cli_config_file,
> -	struct mkfs_default_params	*dft,
>  	char				**fpath);
>  
>  int
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 9d85eab..9802150 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3791,7 +3791,7 @@ _("respecification of configuration not allowed\n"));
>  		}
>  	}
>  
> -	fd = open_config_file(cli_config_file, &dft, &config_file);
> +	fd = open_config_file(cli_config_file, &config_file);
>  	if (fd >= 0) {
>  		ret = parse_defaults_file(fd, &dft, config_file);
>  		if (ret) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
