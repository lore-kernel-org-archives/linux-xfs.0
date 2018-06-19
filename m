Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58844 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752308AbeFSE52 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 00:57:28 -0400
Date: Mon, 18 Jun 2018 21:57:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: More robust inode extent count validation
Message-ID: <20180619045725.GJ8128@magnolia>
References: <20180619024128.22669-1-david@fromorbit.com>
 <20180619024128.22669-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619024128.22669-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 19, 2018 at 12:41:28PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When the inode is in extent format, it can't have more extents that
> fit in the inode fork. We don't currenty check this, and so this
> corruption goes unnoticed by the inode verifiers. This can lead to
> crashes operating on invalid in-memory structures.
> 
> Attempts to access such a inode will now error out in the verifier
> rather than allowing modification operations to proceed.
> 
> Reported-by: Wen Xu <wen.xu@gatech.edu>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_format.h    |  3 ++
>  fs/xfs/libxfs/xfs_inode_buf.c | 74 +++++++++++++++++++++--------------
>  2 files changed, 48 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 1c5a8aaf2bfc..1cb298fec274 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -962,6 +962,9 @@ typedef enum xfs_dinode_fmt {
>  		XFS_DFORK_DSIZE(dip, mp) : \
>  		XFS_DFORK_ASIZE(dip, mp))
>  
> +#define XFS_DFORK_MAXEXT(dip, mp, w) \
> +	(XFS_DFORK_SIZE(dip, mp, w) / sizeof(xfs_bmbt_rec_t))
> +
>  /*
>   * Return pointers to the data or attribute forks.
>   */
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index d38d724534c4..a41b6e5519e0 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -374,6 +374,45 @@ xfs_log_dinode_to_disk(
>  	}
>  }
>  
> +static xfs_failaddr_t
> +xfs_dinode_verify_fork(
> +	struct xfs_dinode	*dip,
> +	struct xfs_mount	*mp,
> +	int			whichfork)
> +{
> +	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> +
> +	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
> +	case XFS_DINODE_FMT_LOCAL:
> +		/*
> +		 * no local regular files yet
> +		 */
> +		if (whichfork == XFS_DATA_FORK) {
> +			if (S_ISREG(be16_to_cpu(dip->di_mode)))
> +				return __this_address;
> +			if (be64_to_cpu(dip->di_size) >
> +					XFS_DFORK_SIZE(dip, mp, whichfork))
> +				return __this_address;
> +		}
> +		if (di_nextents)
> +			return __this_address;
> +		/* fall through */

We could break here too, right?  There's no point in further checks of
di_nextents for local format forks.

> +	case XFS_DINODE_FMT_EXTENTS:
> +		if (di_nextents > XFS_DFORK_MAXEXT(dip, mp, whichfork))
> +			return __this_address;

Are we supposed to break here?

--D

> +	case XFS_DINODE_FMT_BTREE:
> +		if (whichfork == XFS_ATTR_FORK)
> +			if (di_nextents > MAXAEXTNUM)
> +				return __this_address;
> +		else if (di_nextents > MAXEXTNUM)
> +			return __this_address;
> +		break;
> +	default:
> +		return __this_address;
> +	}
> +	return NULL;
> +}
> +
>  xfs_failaddr_t
>  xfs_dinode_verify(
>  	struct xfs_mount	*mp,
> @@ -441,24 +480,9 @@ xfs_dinode_verify(
>  	case S_IFREG:
>  	case S_IFLNK:
>  	case S_IFDIR:
> -		switch (dip->di_format) {
> -		case XFS_DINODE_FMT_LOCAL:
> -			/*
> -			 * no local regular files yet
> -			 */
> -			if (S_ISREG(mode))
> -				return __this_address;
> -			if (di_size > XFS_DFORK_DSIZE(dip, mp))
> -				return __this_address;
> -			if (dip->di_nextents)
> -				return __this_address;
> -			/* fall through */
> -		case XFS_DINODE_FMT_EXTENTS:
> -		case XFS_DINODE_FMT_BTREE:
> -			break;
> -		default:
> -			return __this_address;
> -		}
> +		fa = xfs_dinode_verify_fork(dip, mp, XFS_DATA_FORK);
> +		if (fa)
> +			return fa;
>  		break;
>  	case 0:
>  		/* Uninitialized inode ok. */
> @@ -468,17 +492,9 @@ xfs_dinode_verify(
>  	}
>  
>  	if (XFS_DFORK_Q(dip)) {
> -		switch (dip->di_aformat) {
> -		case XFS_DINODE_FMT_LOCAL:
> -			if (dip->di_anextents)
> -				return __this_address;
> -		/* fall through */
> -		case XFS_DINODE_FMT_EXTENTS:
> -		case XFS_DINODE_FMT_BTREE:
> -			break;
> -		default:
> -			return __this_address;
> -		}
> +		fa = xfs_dinode_verify_fork(dip, mp, XFS_ATTR_FORK);
> +		if (fa)
> +			return fa;
>  	} else {
>  		/*
>  		 * If there is no fork offset, this may be a freshly-made inode
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
