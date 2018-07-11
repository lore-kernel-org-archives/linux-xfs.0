Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46078 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388110AbeGKQ2A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jul 2018 12:28:00 -0400
Date: Wed, 11 Jul 2018 09:22:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/6] xfs: remove if_real_bytes
Message-ID: <20180711162250.GA32415@magnolia>
References: <20180710060528.4071-1-hch@lst.de>
 <20180710060528.4071-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180710060528.4071-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 10, 2018 at 08:05:23AM +0200, Christoph Hellwig wrote:
> The field is only used for asserts, and to track if we really need to do
> realloc when growing the inode fork data.  But the krealloc function
> already performs this check internally, so there is no need to keep track
> of the real allocation size.
> 
> This will free space in the inode fork for keeping a sequence counter of
> changes to the extent list.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_fork.c | 19 ++++---------------
>  fs/xfs/libxfs/xfs_inode_fork.h |  1 -
>  fs/xfs/xfs_inode.c             |  3 +--
>  fs/xfs/xfs_inode_item.c        |  4 ----
>  4 files changed, 5 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 183ec0cb8921..dee85b0f8846 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -158,7 +158,6 @@ xfs_init_local_fork(
>  	}
>  
>  	ifp->if_bytes = size;
> -	ifp->if_real_bytes = real_size;
>  	ifp->if_flags &= ~(XFS_IFEXTENTS | XFS_IFBROOT);
>  	ifp->if_flags |= XFS_IFINLINE;
>  }
> @@ -226,7 +225,6 @@ xfs_iformat_extents(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	ifp->if_real_bytes = 0;
>  	ifp->if_bytes = 0;
>  	ifp->if_u1.if_root = NULL;
>  	ifp->if_height = 0;
> @@ -317,7 +315,6 @@ xfs_iformat_btree(
>  	ifp->if_flags &= ~XFS_IFEXTENTS;
>  	ifp->if_flags |= XFS_IFBROOT;
>  
> -	ifp->if_real_bytes = 0;
>  	ifp->if_bytes = 0;
>  	ifp->if_u1.if_root = NULL;
>  	ifp->if_height = 0;
> @@ -501,7 +498,6 @@ xfs_idata_realloc(
>  		 */
>  		real_size = roundup(new_size, 4);
>  		if (ifp->if_u1.if_data == NULL) {
> -			ASSERT(ifp->if_real_bytes == 0);
>  			ifp->if_u1.if_data = kmem_alloc(real_size,
>  							KM_SLEEP | KM_NOFS);
>  		} else {
> @@ -509,15 +505,12 @@ xfs_idata_realloc(
>  			 * Only do the realloc if the underlying size
>  			 * is really changing.
>  			 */
> -			if (ifp->if_real_bytes != real_size) {
> -				ifp->if_u1.if_data =
> -					kmem_realloc(ifp->if_u1.if_data,
> -							real_size,
> -							KM_SLEEP | KM_NOFS);
> -			}
> +			ifp->if_u1.if_data =
> +				kmem_realloc(ifp->if_u1.if_data,
> +						real_size,
> +						KM_SLEEP | KM_NOFS);
>  		}
>  	}
> -	ifp->if_real_bytes = real_size;
>  	ifp->if_bytes = new_size;
>  	ASSERT(ifp->if_bytes <= XFS_IFORK_SIZE(ip, whichfork));
>  }
> @@ -543,17 +536,13 @@ xfs_idestroy_fork(
>  	 */
>  	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
>  		if (ifp->if_u1.if_data != NULL) {
> -			ASSERT(ifp->if_real_bytes != 0);
>  			kmem_free(ifp->if_u1.if_data);
>  			ifp->if_u1.if_data = NULL;
> -			ifp->if_real_bytes = 0;
>  		}
>  	} else if ((ifp->if_flags & XFS_IFEXTENTS) && ifp->if_height) {
>  		xfs_iext_destroy(ifp);
>  	}
>  
> -	ASSERT(ifp->if_real_bytes == 0);
> -
>  	if (whichfork == XFS_ATTR_FORK) {
>  		kmem_zone_free(xfs_ifork_zone, ip->i_afp);
>  		ip->i_afp = NULL;
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 781b1603df5e..46242052aad0 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -14,7 +14,6 @@ struct xfs_dinode;
>   */
>  typedef struct xfs_ifork {
>  	int			if_bytes;	/* bytes in if_u1 */
> -	int			if_real_bytes;	/* bytes allocated in if_u1 */
>  	struct xfs_btree_block	*if_broot;	/* file's incore btree root */
>  	short			if_broot_bytes;	/* bytes allocated for root */
>  	unsigned char		if_flags;	/* per-fork flags */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 5df4de666cc1..b6da446ae946 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -927,7 +927,7 @@ xfs_ialloc(
>  	case S_IFLNK:
>  		ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
>  		ip->i_df.if_flags = XFS_IFEXTENTS;
> -		ip->i_df.if_bytes = ip->i_df.if_real_bytes = 0;
> +		ip->i_df.if_bytes = 0;
>  		ip->i_df.if_u1.if_root = NULL;
>  		break;
>  	default:
> @@ -1877,7 +1877,6 @@ xfs_inactive(
>  	 * to clean up here.
>  	 */
>  	if (VFS_I(ip)->i_mode == 0) {
> -		ASSERT(ip->i_df.if_real_bytes == 0);
>  		ASSERT(ip->i_df.if_broot_bytes == 0);
>  		return;
>  	}
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 2389c34c172d..fa1c4fe2ffbf 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -194,8 +194,6 @@ xfs_inode_item_format_data_fork(
>  			 * to be there by xfs_idata_realloc().
>  			 */
>  			data_bytes = roundup(ip->i_df.if_bytes, 4);
> -			ASSERT(ip->i_df.if_real_bytes == 0 ||
> -			       ip->i_df.if_real_bytes >= data_bytes);
>  			ASSERT(ip->i_df.if_u1.if_data != NULL);
>  			ASSERT(ip->i_d.di_size > 0);
>  			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_ILOCAL,
> @@ -280,8 +278,6 @@ xfs_inode_item_format_attr_fork(
>  			 * to be there by xfs_idata_realloc().
>  			 */
>  			data_bytes = roundup(ip->i_afp->if_bytes, 4);
> -			ASSERT(ip->i_afp->if_real_bytes == 0 ||
> -			       ip->i_afp->if_real_bytes >= data_bytes);
>  			ASSERT(ip->i_afp->if_u1.if_data != NULL);
>  			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_LOCAL,
>  					ip->i_afp->if_u1.if_data,
> -- 
> 2.18.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
