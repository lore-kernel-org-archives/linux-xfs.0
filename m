Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50265 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbdLGVoP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Dec 2017 16:44:15 -0500
Date: Thu, 7 Dec 2017 13:44:10 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 4/7] xfs: truncate transaction does not modify the
 inobt
Message-ID: <20171207214410.GY19219@magnolia>
References: <20171130185836.18481-1-bfoster@redhat.com>
 <20171130185836.18481-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171130185836.18481-5-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 30, 2017 at 01:58:33PM -0500, Brian Foster wrote:
> The truncate transaction does not ever modify the inode btree, but
> includes an associated log reservation. Update
> xfs_calc_itruncate_reservation() to remove the reservation
> associated with inobt updates.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_trans_resv.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 173b1bc13ffe..037a1295d289 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -232,8 +232,6 @@ xfs_calc_write_reservation(
>   *    the super block to reflect the freed blocks: sector size
>   *    worst case split in allocation btrees per extent assuming 4 extents:
>   *		4 exts * 2 trees * (2 * max depth - 1) * block size
> - *    the inode btree: max depth * blocksize
> - *    the allocation btrees: 2 trees * (max depth - 1) * block size
>   */
>  STATIC uint
>  xfs_calc_itruncate_reservation(
> @@ -245,12 +243,7 @@ xfs_calc_itruncate_reservation(
>  				      XFS_FSB_TO_B(mp, 1))),
>  		    (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
>  		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4),
> -				      XFS_FSB_TO_B(mp, 1)) +
> -		    xfs_calc_buf_res(5, 0) +
> -		    xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
> -				     XFS_FSB_TO_B(mp, 1)) +
> -		    xfs_calc_buf_res(2 + mp->m_ialloc_blks +
> -				     mp->m_in_maxlevels, 0)));
> +				      XFS_FSB_TO_B(mp, 1))));
>  }
>  
>  /*
> -- 
> 2.13.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
