Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39474 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752147AbeGDAr6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 20:47:58 -0400
Date: Tue, 3 Jul 2018 17:47:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/25] xfs: use ->t_firstblock in xfs_bmapi_remap()
Message-ID: <20180704004743.GI32415@magnolia>
References: <20180703172319.24509-1-bfoster@redhat.com>
 <20180703172319.24509-10-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703172319.24509-10-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 01:23:03PM -0400, Brian Foster wrote:
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 4ace1267fc35..05647d4b8f3e 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4503,7 +4503,6 @@ xfs_bmapi_remap(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp;
>  	struct xfs_btree_cur	*cur = NULL;
> -	xfs_fsblock_t		firstblock = NULLFSBLOCK;
>  	struct xfs_bmbt_irec	got;
>  	struct xfs_iext_cursor	icur;
>  	int			whichfork = xfs_bmapi_whichfork(flags);
> @@ -4546,7 +4545,7 @@ xfs_bmapi_remap(
>  
>  	if (ifp->if_flags & XFS_IFBROOT) {
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
> -		cur->bc_private.b.firstblock = firstblock;
> +		cur->bc_private.b.firstblock = tp->t_firstblock;
>  		cur->bc_private.b.flags = 0;
>  	}
>  
> @@ -4559,7 +4558,7 @@ xfs_bmapi_remap(
>  		got.br_state = XFS_EXT_NORM;
>  
>  	error = xfs_bmap_add_extent_hole_real(tp, ip, whichfork, &icur,
> -			&cur, &got, &firstblock, &logflags, flags);
> +			&cur, &got, &tp->t_firstblock, &logflags, flags);
>  	if (error)
>  		goto error0;
>  
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
