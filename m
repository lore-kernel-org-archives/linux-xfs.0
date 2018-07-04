Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39638 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752147AbeGDAsV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 20:48:21 -0400
Date: Tue, 3 Jul 2018 17:48:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/25] xfs: use ->t_firstblock in insert/collapse range
Message-ID: <20180704004806.GJ32415@magnolia>
References: <20180703172319.24509-1-bfoster@redhat.com>
 <20180703172319.24509-11-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703172319.24509-11-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 01:23:04PM -0400, Brian Foster wrote:
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_bmap_util.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index b49364779966..b690def4962b 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1310,7 +1310,6 @@ xfs_collapse_file_space(
>  	struct xfs_trans	*tp;
>  	int			error;
>  	struct xfs_defer_ops	dfops;
> -	xfs_fsblock_t		first_block;
>  	xfs_fileoff_t		next_fsb = XFS_B_TO_FSB(mp, offset + len);
>  	xfs_fileoff_t		shift_fsb = XFS_B_TO_FSB(mp, len);
>  	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
> @@ -1343,9 +1342,9 @@ xfs_collapse_file_space(
>  			goto out_trans_cancel;
>  		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  
> -		xfs_defer_init(tp, &dfops, &first_block);
> +		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  		error = xfs_bmap_collapse_extents(tp, ip, &next_fsb, shift_fsb,
> -				&done, &first_block);
> +				&done, &tp->t_firstblock);
>  		if (error)
>  			goto out_bmap_cancel;
>  
> @@ -1386,7 +1385,6 @@ xfs_insert_file_space(
>  	struct xfs_trans	*tp;
>  	int			error;
>  	struct xfs_defer_ops	dfops;
> -	xfs_fsblock_t		first_block;
>  	xfs_fileoff_t		stop_fsb = XFS_B_TO_FSB(mp, offset);
>  	xfs_fileoff_t		next_fsb = NULLFSBLOCK;
>  	xfs_fileoff_t		shift_fsb = XFS_B_TO_FSB(mp, len);
> @@ -1422,9 +1420,9 @@ xfs_insert_file_space(
>  
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> -		xfs_defer_init(tp, &dfops, &first_block);
> +		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  		error = xfs_bmap_insert_extents(tp, ip, &next_fsb, shift_fsb,
> -				&done, stop_fsb, &first_block);
> +				&done, stop_fsb, &tp->t_firstblock);
>  		if (error)
>  			goto out_bmap_cancel;
>  
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
