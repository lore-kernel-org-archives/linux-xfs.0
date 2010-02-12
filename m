Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CEjZRZ258827 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 08:45:35 -0600
Subject: Re: [PATCH 2/2] xfs_export_operations.commit_metadata
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100211220505.26466.99037.stgit@case>
References: <20100211220454.26466.37578.stgit@case>
	<20100211220505.26466.99037.stgit@case>
Date: Fri, 12 Feb 2010 08:46:46 -0600
Message-ID: <1265986006.3201.112.camel@doink1>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: bfields@fieldses.org, linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, 2010-02-11 at 16:05 -0600, Ben Myers wrote:
> This is the commit_metadata export operation for XFS, including the changes
> suggested by hch and dgc:
> 
> - Takes two two inodes instead of dentries and can assume the parent is
> always set.

I alluded to this in my review of the first patch.
This could be changed considered in a more generic
sense, "sync one or two inodes' metadata" rather
than presupposing the two inodes have a parent/child
relationship.

> - Uses xfs_lock_two_inodes for the ilock.
> 
> - Forces the log up to the larger lsn of parent and child.
> 
> - Uses XFS_LSN_CMP for lsn comparison.
> 
> - Doesn't force the log if nobody had a pincount.

So if the log doesn't get forced, what causes the
desired metadata sync expected as a result of this
call?  (Maybe this is a dumb question.)

> Signed-off-by: Ben Myers <bpm@sgi.com>
> ---
>  fs/xfs/linux-2.6/xfs_export.c |   43 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_export.c b/fs/xfs/linux-2.6/xfs_export.c
> index 87b8cbd..d37ced1 100644
> --- a/fs/xfs/linux-2.6/xfs_export.c
> +++ b/fs/xfs/linux-2.6/xfs_export.c
> @@ -29,6 +29,7 @@
>  #include "xfs_vnodeops.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_inode.h"
> +#include "xfs_inode_item.h"
>  
>  /*
>   * Note that we only accept fileids which are long enough rather than allow
> @@ -215,9 +216,51 @@ xfs_fs_get_parent(
>  	return d_obtain_alias(VFS_I(cip));
>  }
>  
> +STATIC int
> +xfs_fs_nfs_commit_metadata(
> +	struct inode		*parent,
> +	struct inode		*child)
> +{
> +	struct xfs_inode	*dp = XFS_I(parent);
> +	struct xfs_inode	*ip = NULL;
> +	struct xfs_mount	*mp = dp->i_mount;
> +	xfs_lsn_t		force_lsn = NULLCOMMITLSN;
> +	int			error = 0;
> +
> +	if (child) {
> +		ip = XFS_I(child);
> +		xfs_lock_two_inodes(dp, ip, XFS_ILOCK_SHARED);
> +	} else {
> +		xfs_ilock(dp, XFS_ILOCK_SHARED);
> +	}
> +
> +	if (xfs_ipincount(dp)) {
> +		force_lsn = dp->i_itemp->ili_last_lsn;
> +		if (ip && xfs_ipincount(ip) &&
> +		    XFS_LSN_CMP(force_lsn, ip->i_itemp->ili_last_lsn) < 0) {
> +			force_lsn = ip->i_itemp->ili_last_lsn;
> +		}
> +	} else if (ip && xfs_ipincount(ip)) {
> +		force_lsn = ip->i_itemp->ili_last_lsn;
> +	}
> +
> +	if (force_lsn != NULLCOMMITLSN) {
> +		error = _xfs_log_force(mp, force_lsn,
> +				XFS_LOG_FORCE | XFS_LOG_SYNC, NULL);

You want this here:
 error = xfs_log_force_lsn(mp, force_lsn, XFS_LOG_FORCE | XFS_LOG_SYNC);


> +	}
> +
> +	if (child)
> +		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +	if (parent)
> +		xfs_iunlock(dp, XFS_ILOCK_SHARED);
> +
> +	return error;
> +}
> +
>  const struct export_operations xfs_export_operations = {
>  	.encode_fh		= xfs_fs_encode_fh,
>  	.fh_to_dentry		= xfs_fs_fh_to_dentry,
>  	.fh_to_parent		= xfs_fs_fh_to_parent,
>  	.get_parent		= xfs_fs_get_parent,
> +	.commit_metadata	= xfs_fs_nfs_commit_metadata,
>  };
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
