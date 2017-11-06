Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35836 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754213AbdKFUSB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 15:18:01 -0500
Date: Mon, 6 Nov 2017 12:17:48 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/8] xfs: remove unreachable error injection code in
 xfs_qm_dqget
Message-ID: <20171106201748.GG6244@magnolia>
References: <20171106143456.13567-1-hch@lst.de>
 <20171106143456.13567-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171106143456.13567-6-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 06, 2017 at 03:34:53PM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_dquot.c | 17 -----------------
>  1 file changed, 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 8338b894d54f..d57c2db64e59 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -53,13 +53,6 @@
>   * otherwise by the lowest id first, see xfs_dqlock2.
>   */
>  
> -#ifdef DEBUG
> -xfs_buftarg_t *xfs_dqerror_target;
> -int xfs_do_dqerror;
> -int xfs_dqreq_num;
> -int xfs_dqerror_mod = 33;
> -#endif
> -
>  struct kmem_zone		*xfs_qm_dqtrxzone;
>  static struct kmem_zone		*xfs_qm_dqzone;
>  
> @@ -770,15 +763,6 @@ xfs_qm_dqget(
>  		return -ESRCH;
>  	}
>  
> -#ifdef DEBUG
> -	if (xfs_do_dqerror) {
> -		if ((xfs_dqerror_target == mp->m_ddev_targp) &&
> -		    (xfs_dqreq_num++ % xfs_dqerror_mod) == 0) {
> -			xfs_debug(mp, "Returning error in dqget");
> -			return -EIO;
> -		}
> -	}
> -
>  	ASSERT(type == XFS_DQ_USER ||
>  	       type == XFS_DQ_PROJ ||
>  	       type == XFS_DQ_GROUP);
> @@ -786,7 +770,6 @@ xfs_qm_dqget(
>  		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  		ASSERT(xfs_inode_dquot(ip, type) == NULL);
>  	}
> -#endif
>  
>  restart:
>  	mutex_lock(&qi->qi_tree_lock);
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
