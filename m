Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B39457F52
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 00:33:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2E3B5AC007
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 22:33:20 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jhjE3M5cNeULCQBX for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 22:33:19 -0700 (PDT)
Date: Thu, 24 Apr 2014 15:32:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 04/11] xfs: update inode allocation/free transaction
	reservations for finobt
Message-ID: <20140424053259.GA15995@dastard>
References: <1397146116-42546-1-git-send-email-bfoster@redhat.com>
	<1397146116-42546-5-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397146116-42546-5-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 10, 2014 at 12:08:29PM -0400, Brian Foster wrote:
> Create the xfs_calc_finobt_res() helper to calculate the finobt log
> reservation for inode allocation and free. Update
> XFS_IALLOC_SPACE_RES() to reserve blocks for the additional finobt
> insertion on inode allocation. Create XFS_IFREE_SPACE_RES() to
> reserve blocks for the potential finobt record insertion on inode
> free (i.e., if an inode chunk was previously fully allocated).
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_inode.c       | 25 ++++++++++++++++++++++-
>  fs/xfs/xfs_trans_resv.c  | 53 +++++++++++++++++++++++++++++++++++++++++++++---
>  fs/xfs/xfs_trans_space.h |  7 ++++++-
>  3 files changed, 80 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 5e7a38f..8576892 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1837,8 +1837,31 @@ xfs_inactive_ifree(
>  	int			error;
>  
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
> -	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, 0, 0);
> +
> +	/*
> +	 * The ifree transaction might need to allocate blocks for record
> +	 * insertion to the finobt. We don't want to fail here at ENOSPC, so
> +	 * allow ifree to dip into the reserved block pool if necessary.
> +	 *
> +	 * Freeing large sets of inodes generally means freeing inode chunks,
> +	 * directory and file data blocks, so this should be relatively safe.
> +	 * Only under severe circumstances should it be possible to free enough
> +	 * inodes to exhaust the reserve block pool via finobt expansion while
> +	 * at the same time not creating free space in the filesystem.
> +	 *
> +	 * Send a warning if the reservation does happen to fail, as the inode
> +	 * now remains allocated and sits on the unlinked list until the fs is
> +	 * repaired.
> +	 */
> +	tp->t_flags |= XFS_TRANS_RESERVE;
> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree,
> +				  XFS_IFREE_SPACE_RES(mp), 0);
>  	if (error) {
> +		if (error == ENOSPC)
> +			xfs_warn_ratelimited(mp,
> +			"Failed to remove inode(s) from unlinked list. "
> +			"Please free space, unmount and run xfs_repair.");
> +
>  		ASSERT(XFS_FORCED_SHUTDOWN(mp));
>  		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
>  		return error;

Comment is good, but if we get an ENOSPC error here we won't be in a
shutdown state, hence the assert needs fixing (i.e. else {assert})

Otherwise this looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
