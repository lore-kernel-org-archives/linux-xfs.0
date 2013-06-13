Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 326CA7F72
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 21:37:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E53A88F804B
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 19:37:48 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	2GGCxOBzMoqkuuHo for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 19:37:47 -0700 (PDT)
Date: Thu, 13 Jun 2013 12:37:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: fix the symbolic link assert in xfs_ifree
Message-ID: <20130613023744.GI29338@dastard>
References: <20130612182818.363497890@.sgi.com>
	<20130612182836.141843930@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130612182836.141843930@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 12, 2013 at 01:28:19PM -0500, Mark Tinguely wrote:
> Adding an extended attribute to a symbolic link can force that
> link to an remote extent. xfs_inactive() incorrectly assumes
> that any symbolic link small enough to be in the inode core
> is incore, resulting in the remote extent to not be removed.
> xfs_ifree() will assert on presence of this leaked remote extent.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
> xfstest is coming.
> 
>  fs/xfs/xfs_symlink.c  |   24 +++++++++++++++++++++++-
>  fs/xfs/xfs_symlink.h  |    1 +
>  fs/xfs/xfs_vnodeops.c |   15 +++------------
>  3 files changed, 27 insertions(+), 13 deletions(-)
> 
> Index: b/fs/xfs/xfs_symlink.c
> ===================================================================
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -606,7 +606,7 @@ xfs_inactive_symlink_rmt(
>  
>  	tp = *tpp;
>  	mp = ip->i_mount;
> -	ASSERT(ip->i_d.di_size > XFS_IFORK_DSIZE(ip));
> +	ASSERT(ip->i_df.if_flags & XFS_IFEXTENTS);
>  	/*
>  	 * We're freeing a symlink that has some
>  	 * blocks allocated to it.  Free the
> @@ -720,3 +720,25 @@ xfs_inactive_symlink_rmt(
>   error0:
>  	return error;
>  }
> +
> +/*
> + * xfs_inactive_symlink - free a symlink
> + */
> +int
> +xfs_inactive_symlink(
> +	struct xfs_inode	*ip,
> +	struct xfs_trans	**tp)
> +{
> +

Needs to:

	- emit a tracepoint (trace_xfs_symlink_inactive(ip))
	- assert the inode is locked appropriately
	- check for a shutdown condition
	- check for zero size and return success immediately
	- check inode size is within bounds (0 < size < MAXPATHLEN)

i.e. all the same preamble that xfs_readlink() has.

> +	/*
> +	 * Zero length symlinks _can_ exist.
> +	 */
> +	if (ip->i_df.if_flags & XFS_IFINLINE) {
> +		if (ip->i_df.if_bytes > 0)
> +			xfs_idata_realloc(ip, -(ip->i_df.if_bytes),
> +					  XFS_DATA_FORK);
> +		ASSERT(ip->i_df.if_bytes == 0);
> +		return 0;
> +	} else
> +		return (xfs_inactive_symlink_rmt(ip, tp));

No need for an else here, and no need for the () around the
xfs_inactive_symlink_rmt() function call.

> +}
> Index: b/fs/xfs/xfs_symlink.h
> ===================================================================
> --- a/fs/xfs/xfs_symlink.h
> +++ b/fs/xfs/xfs_symlink.h
> @@ -61,6 +61,7 @@ int xfs_symlink(struct xfs_inode *dp, st
>  		const char *target_path, umode_t mode, struct xfs_inode **ipp);
>  int xfs_readlink(struct xfs_inode *ip, char *link);
>  int xfs_inactive_symlink_rmt(struct xfs_inode *ip, struct xfs_trans **tpp);
> +int xfs_inactive_symlink(struct xfs_inode *ip, struct xfs_trans **tpp);

xfs_inactive_symlink_rmt() is no longer exported, so it can be
removed from the header and made STATIC.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
