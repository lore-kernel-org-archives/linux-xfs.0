Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47772 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751092AbdFHNCs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Jun 2017 09:02:48 -0400
Date: Thu, 8 Jun 2017 09:02:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 14/13] xfs: allow reading of already-locked remote
 symbolic link
Message-ID: <20170608130244.GD5244@bfoster.bfoster>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
 <20170602221942.GE5636@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170602221942.GE5636@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 02, 2017 at 03:19:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Expose the readlink variant that doesn't take the inode lock so that
> the scrubber can inspect symlink contents.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_symlink.c |    6 +++---
>  fs/xfs/xfs_symlink.h |    1 +
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index f2cb45e..49380485 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -43,8 +43,8 @@
>  #include "xfs_log.h"
>  
>  /* ----- Kernel only functions below ----- */
> -STATIC int
> -xfs_readlink_bmap(
> +int
> +xfs_readlink_bmap_ilocked(
>  	struct xfs_inode	*ip,
>  	char			*link)
>  {
> @@ -153,7 +153,7 @@ xfs_readlink(
>  	}
>  
>  
> -	error = xfs_readlink_bmap(ip, link);
> +	error = xfs_readlink_bmap_ilocked(ip, link);
>  
>   out:
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> diff --git a/fs/xfs/xfs_symlink.h b/fs/xfs/xfs_symlink.h
> index e75245d..aeaee89 100644
> --- a/fs/xfs/xfs_symlink.h
> +++ b/fs/xfs/xfs_symlink.h
> @@ -21,6 +21,7 @@
>  
>  int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
>  		const char *target_path, umode_t mode, struct xfs_inode **ipp);
> +int xfs_readlink_bmap_ilocked(struct xfs_inode *ip, char *link);
>  int xfs_readlink(struct xfs_inode *ip, char *link);
>  int xfs_inactive_symlink(struct xfs_inode *ip);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
