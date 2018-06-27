Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:39102 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932186AbeF0HlQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jun 2018 03:41:16 -0400
Received: by mail-wm0-f66.google.com with SMTP id p11-v6so4288877wmc.4
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jun 2018 00:41:16 -0700 (PDT)
Date: Wed, 27 Jun 2018 09:41:12 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: cow unwritten conversion uses uninitialized dfops
Message-ID: <20180627074112.rdmwndvlgfjmmtul@odin.usersys.redhat.com>
References: <20180626121502.41354-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180626121502.41354-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 26, 2018 at 08:15:02AM -0400, Brian Foster wrote:
> A couple COW fork unwritten extent conversion helpers pass an
> uninitialized dfops pointer to xfs_bmapi_write(). This does not
> cause problems because conversion does not use a transaction or the
> dfops structure for the COW fork.  Drop the uninitialized usage of
> dfops in these codepaths and pass NULL along to xfs_bmapi_write()
> instead.
> 

This looks ok for me,  you can add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>




> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_reflink.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 592fb2071a03..ff10b5e70029 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -312,8 +312,7 @@ xfs_reflink_convert_cow_extent(
>  	struct xfs_inode		*ip,
>  	struct xfs_bmbt_irec		*imap,
>  	xfs_fileoff_t			offset_fsb,
> -	xfs_filblks_t			count_fsb,
> -	struct xfs_defer_ops		*dfops)
> +	xfs_filblks_t			count_fsb)
>  {
>  	xfs_fsblock_t			first_block = NULLFSBLOCK;
>  	int				nimaps = 1;
> @@ -327,7 +326,7 @@ xfs_reflink_convert_cow_extent(
>  		return 0;
>  	return xfs_bmapi_write(NULL, ip, imap->br_startoff, imap->br_blockcount,
>  			XFS_BMAPI_COWFORK | XFS_BMAPI_CONVERT, &first_block,
> -			0, imap, &nimaps, dfops);
> +			0, imap, &nimaps, NULL);
>  }
>  
>  /* Convert all of the unwritten CoW extents in a file's range to real ones. */
> @@ -342,7 +341,6 @@ xfs_reflink_convert_cow(
>  	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
>  	xfs_filblks_t		count_fsb = end_fsb - offset_fsb;
>  	struct xfs_bmbt_irec	imap;
> -	struct xfs_defer_ops	dfops;
>  	xfs_fsblock_t		first_block = NULLFSBLOCK;
>  	int			nimaps = 1, error = 0;
>  
> @@ -352,7 +350,7 @@ xfs_reflink_convert_cow(
>  	error = xfs_bmapi_write(NULL, ip, offset_fsb, count_fsb,
>  			XFS_BMAPI_COWFORK | XFS_BMAPI_CONVERT |
>  			XFS_BMAPI_CONVERT_ONLY, &first_block, 0, &imap, &nimaps,
> -			&dfops);
> +			NULL);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
>  }
> @@ -458,8 +456,7 @@ xfs_reflink_allocate_cow(
>  	if (nimaps == 0)
>  		return -ENOSPC;
>  convert:
> -	return xfs_reflink_convert_cow_extent(ip, imap, offset_fsb, count_fsb,
> -			&dfops);
> +	return xfs_reflink_convert_cow_extent(ip, imap, offset_fsb, count_fsb);
>  out_bmap_cancel:
>  	xfs_defer_cancel(&dfops);
>  	xfs_trans_unreserve_quota_nblks(tp, ip, (long)resblks, 0,
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
