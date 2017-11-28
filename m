Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32312 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753578AbdK1CVN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Nov 2017 21:21:13 -0500
Date: Mon, 27 Nov 2017 18:21:08 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix leaks on corruption errors in xfs_bmap.c
Message-ID: <20171128022108.GF21412@magnolia>
References: <4b6bc004-3a7f-40f7-7d97-d1f358439b88@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b6bc004-3a7f-40f7-7d97-d1f358439b88@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Nov 27, 2017 at 04:48:02PM -0600, Eric Sandeen wrote:
> Use _GOTO instead of _RETURN so we can free the allocated
> cursor on error.
> 
> Fixes: bf80628 ("xfs: remove xfs_bmse_shift_one")
> Fixes-coverity-id: 1423813
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok, will test
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> 
> Compile-tested only 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 08df809..87884aa 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5662,7 +5662,8 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
>  		*done = true;
>  		goto del_cursor;
>  	}
> -	XFS_WANT_CORRUPTED_RETURN(mp, !isnullstartblock(got.br_startblock));
> +	XFS_WANT_CORRUPTED_GOTO(mp, !isnullstartblock(got.br_startblock),
> +				del_cursor);
>  
>  	new_startoff = got.br_startoff - offset_shift_fsb;
>  	if (xfs_iext_peek_prev_extent(ifp, &icur, &prev)) {
> @@ -5767,7 +5768,8 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
>  			goto del_cursor;
>  		}
>  	}
> -	XFS_WANT_CORRUPTED_RETURN(mp, !isnullstartblock(got.br_startblock));
> +	XFS_WANT_CORRUPTED_GOTO(mp, !isnullstartblock(got.br_startblock),
> +				del_cursor);
>  
>  	if (stop_fsb >= got.br_startoff + got.br_blockcount) {
>  		error = -EIO;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
