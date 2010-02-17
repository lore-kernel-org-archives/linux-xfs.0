Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1H0SVLI192750 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 18:28:32 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 362F213AFF63
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 16:29:47 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	DlW0Gq53nWs70lYv for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2010 16:29:47 -0800 (PST)
Date: Wed, 17 Feb 2010 11:29:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs_export_operations.commit_metadata
Message-ID: <20100217002943.GG28392@discord.disaster>
References: <20100216210026.5694.14423.stgit@case>
	<20100216210418.5694.48417.stgit@case>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100216210418.5694.48417.stgit@case>
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

On Tue, Feb 16, 2010 at 03:04:18PM -0600, Ben Myers wrote:
> This is the commit_metadata export operation for XFS.
> 
> - Takes one inode to be committed.
> 
> - Forces the log up to the lsn of the inode.
> 
> - Doesn't force the log if the inode doesn't have a pincount.
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>
> ---
>  fs/xfs/linux-2.6/xfs_export.c |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_export.c b/fs/xfs/linux-2.6/xfs_export.c
> index 87b8cbd..47a8d1f 100644
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
> @@ -215,9 +216,32 @@ xfs_fs_get_parent(
>  	return d_obtain_alias(VFS_I(cip));
>  }
>  
> +STATIC int
> +xfs_fs_nfs_commit_metadata(
> +	struct inode		*inode)
> +{
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_lsn_t		force_lsn = NULLCOMMITLSN;
> +	int			error = 0;
> +
> +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> +	if (xfs_ipincount(ip)) {
> +		force_lsn = ip->i_itemp->ili_last_lsn;
> +	}
> +	if (force_lsn != NULLCOMMITLSN) {
> +		error = _xfs_log_force(mp, force_lsn,
> +				XFS_LOG_FORCE | XFS_LOG_SYNC, NULL);
> +	}

That could be simplified to:

	if (xfs_ipincount(ip))
		_xfs_log_force(mp, ip->i_itemp->ili_last_lsn
				XFS_LOG_FORCE | XFS_LOG_SYNC, NULL);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
