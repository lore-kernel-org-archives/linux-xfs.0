Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42542 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751899AbdHCUTH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 16:19:07 -0400
Date: Thu, 3 Aug 2017 13:18:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: Fix per-inode DAX flag inheritance
Message-ID: <20170803201858.GX4477@magnolia>
References: <1501771038-17216-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1501771038-17216-1-git-send-email-lczerner@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Aug 03, 2017 at 04:37:18PM +0200, Lukas Czerner wrote:
> According to the commit that implemented per-inode DAX flag:
> commit 58f88ca2df72 ("xfs: introduce per-inode DAX enablement")
> the flag is supposed to act as "inherit flag".
> 
> Currently this only works in the situations where parent directory
> already has a flag in di_flags set, otherwise inheritance does not
> work. This is because setting the XFS_DIFLAG2_DAX flag is done in a
> wrong branch designated for di_flags, not di_flags2.
> 
> Fix this by moving the code to branch designated for setting di_flags2,
> which does test for flags in di_flags2.
> 
> Fixes: 58f88ca2df72 ("xfs: introduce per-inode DAX enablement")
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Looks good,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_inode.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ceef77c..ff48f00 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -874,7 +874,6 @@ xfs_ialloc(
>  	case S_IFREG:
>  	case S_IFDIR:
>  		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
> -			uint64_t	di_flags2 = 0;
>  			uint		di_flags = 0;
>  
>  			if (S_ISDIR(mode)) {
> @@ -911,20 +910,23 @@ xfs_ialloc(
>  				di_flags |= XFS_DIFLAG_NODEFRAG;
>  			if (pip->i_d.di_flags & XFS_DIFLAG_FILESTREAM)
>  				di_flags |= XFS_DIFLAG_FILESTREAM;
> -			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
> -				di_flags2 |= XFS_DIFLAG2_DAX;
>  
>  			ip->i_d.di_flags |= di_flags;
> -			ip->i_d.di_flags2 |= di_flags2;
>  		}
>  		if (pip &&
>  		    (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY) &&
>  		    pip->i_d.di_version == 3 &&
>  		    ip->i_d.di_version == 3) {
> +			uint64_t	di_flags2 = 0;
> +
>  			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
> -				ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
> +				di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
>  				ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
>  			}
> +			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
> +				di_flags2 |= XFS_DIFLAG2_DAX;
> +
> +			ip->i_d.di_flags2 |= di_flags2;
>  		}
>  		/* FALLTHROUGH */
>  	case S_IFLNK:
> -- 
> 2.7.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
