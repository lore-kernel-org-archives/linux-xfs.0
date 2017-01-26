Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:34673 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753589AbdAZVhd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Jan 2017 16:37:33 -0500
Received: by mail-io0-f182.google.com with SMTP id l66so47515487ioi.1
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2017 13:37:33 -0800 (PST)
Subject: Re: [PATCH (trivial)] xfs: remove unused full argument from bmap
 formatter
References: <cdb58427-dace-29e8-f7c3-ed0d40acebf5@redhat.com>
From: Alex Elder <elder@ieee.org>
Message-ID: <ff5ab867-0668-5fd5-63f3-defe626da54d@ieee.org>
Date: Thu, 26 Jan 2017 15:37:31 -0600
MIME-Version: 1.0
In-Reply-To: <cdb58427-dace-29e8-f7c3-ed0d40acebf5@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 01/26/2017 02:44 PM, Eric Sandeen wrote:
> The "full" argument was used only by the fiemap formatter,
> which is now gone with the iomap updates.
> 
> Remove the unused arg.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good.

Reviewed-by: Alex Elder <elder@linaro.org>

(Trivial patches are easy!)

> ---
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index b9abce5..e0a1a1a 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -779,11 +779,9 @@
>  	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
>  
>  	for (i = 0; i < cur_ext; i++) {
> -		int full = 0;	/* user array is full */
> -
>  		/* format results & advance arg */
> -		error = formatter(&arg, &out[i], &full);
> -		if (error || full)
> +		error = formatter(&arg, &out[i]);
> +		if (error)
>  			break;
>  	}
>  
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index 68a621a..2aabc76 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -35,7 +35,7 @@ int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
>  		xfs_fileoff_t start_fsb, xfs_fileoff_t length);
>  
>  /* bmap to userspace formatter - copy to user & advance pointer */
> -typedef int (*xfs_bmap_format_t)(void **, struct getbmapx *, int *);
> +typedef int (*xfs_bmap_format_t)(void **, struct getbmapx *);
>  int	xfs_getbmap(struct xfs_inode *ip, struct getbmapx *bmv,
>  		xfs_bmap_format_t formatter, void *arg);
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index c67cfb4..cf1363db 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1524,7 +1524,7 @@ struct dentry *
>  }
>  
>  STATIC int
> -xfs_getbmap_format(void **ap, struct getbmapx *bmv, int *full)
> +xfs_getbmap_format(void **ap, struct getbmapx *bmv)
>  {
>  	struct getbmap __user	*base = (struct getbmap __user *)*ap;
>  
> @@ -1567,7 +1567,7 @@ struct dentry *
>  }
>  
>  STATIC int
> -xfs_getbmapx_format(void **ap, struct getbmapx *bmv, int *full)
> +xfs_getbmapx_format(void **ap, struct getbmapx *bmv)
>  {
>  	struct getbmapx __user	*base = (struct getbmapx __user *)*ap;
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

