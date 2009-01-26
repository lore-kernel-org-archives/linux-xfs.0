Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q3GDDM183831 for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 21:16:13 -0600
In-Reply-To: <497D258C.1000908@sandeen.net>
References: <497D258C.1000908@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v753.1)
Message-Id: <235484D7-C9BD-424B-B453-0ED44F92A4C6@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
Subject: Re: [PATCH] don't reallocate sxp variable passed into xfs_swapext
Date: Sun, 25 Jan 2009 21:14:50 -0600
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@linux-foundation.org>, pm@debian.org, xfs-oss <xfs@oss.sgi.com>


On Jan 25, 2009, at 8:53 PM, Eric Sandeen wrote:

> fixes kernel.org bugzilla 12538, xfs_fsr fails on 2.6.29-rc kernels
>
> Regression caused by 743bb4650da9e2595d6cedd01c680b5b9398c74a
>
> This was an embarrasing mistake, reallocating the sxp pointer passed
> in from the main ioctl switch.
>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net
> Reported-by: Paul Martin <pm@debian.org>
> Tested-by: Paul Martin <pm@debian.org>

Reviewed-by Felix Blyakher <felixb@sgi.com>

> ---
>
>
> Index: linux-2.6/fs/xfs/xfs_dfrag.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_dfrag.c
> +++ linux-2.6/fs/xfs/xfs_dfrag.c
> @@ -55,17 +55,11 @@ xfs_swapext(
>  	struct file	*file, *target_file;
>  	int		error = 0;
>
> -	sxp = kmem_alloc(sizeof(xfs_swapext_t), KM_MAYFAIL);
> -	if (!sxp) {
> -		error = XFS_ERROR(ENOMEM);
> -		goto out;
> -	}
> -
>  	/* Pull information for the target fd */
>  	file = fget((int)sxp->sx_fdtarget);
>  	if (!file) {
>  		error = XFS_ERROR(EINVAL);
> -		goto out_free_sxp;
> +		goto out;
>  	}
>
>  	if (!(file->f_mode & FMODE_WRITE) || (file->f_flags & O_APPEND)) {
> @@ -109,8 +103,6 @@ xfs_swapext(
>  	fput(target_file);
>   out_put_file:
>  	fput(file);
> - out_free_sxp:
> -	kmem_free(sxp);
>   out:
>  	return error;
>  }
>
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
