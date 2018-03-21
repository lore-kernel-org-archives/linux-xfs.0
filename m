Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47660 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751851AbeCUNz0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Mar 2018 09:55:26 -0400
Date: Wed, 21 Mar 2018 09:55:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/9] xfs: refactor inode verifier error logging
Message-ID: <20180321135525.GD11127@bfoster.bfoster>
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
 <152107378868.19571.6256278246118880952.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152107378868.19571.6256278246118880952.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 14, 2018 at 05:29:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor some of the inode verifier failure logging call sites to use
> the new xfs_inode_verifier_error method which dumps the offending buffer
> as well as the code location of the failed check.  This trims the
> output, makes it clearer to the admin that repair must be run, and gives
> the developers more details to work from.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c       |    5 +++--
>  fs/xfs/libxfs/xfs_inode_fork.c |   15 +++++++++------
>  2 files changed, 12 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 5850e76..fe7534e 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1244,8 +1244,9 @@ xfs_iread_extents(
>  			xfs_warn(ip->i_mount,
>  				"corrupt dinode %Lu, (btree extents).",
>  				(unsigned long long) ip->i_ino);
> -			XFS_CORRUPTION_ERROR(__func__,
> -				XFS_ERRLEVEL_LOW, ip->i_mount, block);
> +			xfs_inode_verifier_error(ip, -EFSCORRUPTED,
> +					__func__, block, sizeof(*block),
> +					__this_address);
>  			error = -EFSCORRUPTED;
>  			goto out_brelse;
>  		}
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 613fba2..701c42a 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -195,8 +195,9 @@ xfs_iformat_local(
>  	"corrupt inode %Lu (bad size %d for local fork, size = %d).",
>  			(unsigned long long) ip->i_ino, size,
>  			XFS_DFORK_SIZE(dip, ip->i_mount, whichfork));
> -		XFS_CORRUPTION_ERROR("xfs_iformat_local", XFS_ERRLEVEL_LOW,
> -				     ip->i_mount, dip);
> +		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
> +				"xfs_iformat_local", dip, sizeof(*dip),
> +				__this_address);
>  		return -EFSCORRUPTED;
>  	}
>  
> @@ -231,8 +232,9 @@ xfs_iformat_extents(
>  	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
>  		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
>  			(unsigned long long) ip->i_ino, nex);
> -		XFS_CORRUPTION_ERROR("xfs_iformat_extents(1)", XFS_ERRLEVEL_LOW,
> -				     mp, dip);
> +		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
> +				"xfs_iformat_extents(1)", dip, sizeof(*dip),
> +				__this_address);
>  		return -EFSCORRUPTED;
>  	}
>  
> @@ -309,8 +311,9 @@ xfs_iformat_btree(
>  		     level == 0 || level > XFS_BTREE_MAXLEVELS) {
>  		xfs_warn(mp, "corrupt inode %Lu (btree).",
>  					(unsigned long long) ip->i_ino);
> -		XFS_CORRUPTION_ERROR("xfs_iformat_btree", XFS_ERRLEVEL_LOW,
> -					 mp, dip);
> +		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
> +				"xfs_iformat_btree", dfp, size,
> +				__this_address);
>  		return -EFSCORRUPTED;
>  	}
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
