Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55408 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932078AbeCFXGs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Mar 2018 18:06:48 -0500
Date: Tue, 6 Mar 2018 15:06:42 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/5] Call libxfs_destroy from other utilities
Message-ID: <20180306230642.GO18989@magnolia>
References: <d81cf576-6082-008b-761e-82c487e6a87a@redhat.com>
 <a2564908-f093-19ca-94e3-fab9bfaa88b5@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2564908-f093-19ca-94e3-fab9bfaa88b5@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Mar 06, 2018 at 03:56:29PM -0600, Eric Sandeen wrote:
> Call libxfs_destroy() from xfs_copy, xfs_db, mkfs.xfs, and
> xfs_repair to allow us to detect leaked items in these
> utilities as well.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  copy/xfs_copy.c     | 1 +
>  db/init.c           | 2 ++
>  mkfs/xfs_mkfs.c     | 1 +
>  repair/xfs_repair.c | 1 +
>  4 files changed, 5 insertions(+)
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index 16ee4d9..0b80613 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -1215,6 +1215,7 @@ main(int argc, char **argv)
>  
>  	check_errors();
>  	libxfs_umount(mp);
> +	libxfs_destroy();
>  
>  	return 0;
>  }
> diff --git a/db/init.c b/db/init.c
> index b108a06..29fc344 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -236,5 +236,7 @@ close_devices:
>  		libxfs_device_close(x.logdev);
>  	if (x.rtdev)
>  		libxfs_device_close(x.rtdev);
> +	libxfs_destroy();
> +
>  	return exitcode;
>  }
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index f973b6b..1ca6a2d 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -4045,6 +4045,7 @@ main(
>  	if (xi.logdev && xi.logdev != xi.ddev)
>  		libxfs_device_close(xi.logdev);
>  	libxfs_device_close(xi.ddev);
> +	libxfs_destroy();
>  
>  	return 0;
>  }
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index b2dd91b..312a0d0 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -1082,6 +1082,7 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
>  	if (x.logdev && x.logdev != x.ddev)
>  		libxfs_device_close(x.logdev);
>  	libxfs_device_close(x.ddev);
> +	libxfs_destroy();
>  
>  	if (verbose)
>  		summary_report();
> -- 
> 1.8.3.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
