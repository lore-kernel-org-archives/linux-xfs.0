Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32157 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934873AbcJQRfK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 13:35:10 -0400
Date: Mon, 17 Oct 2016 10:35:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove redundant assignment of ifp
Message-ID: <20161017173500.GH1120@birch.djwong.org>
References: <20161017173240.26542-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161017173240.26542-1-colin.king@canonical.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Colin King <colin.king@canonical.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org

On Mon, Oct 17, 2016 at 06:32:40PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Remove redundant ifp = ifp statement, it does nothing. Found with
> static analysis by CoverityScan.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index c27344c..0283b7e 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5204,7 +5204,7 @@ xfs_bunmapi_cow(
>  	ep = xfs_bmap_search_extents(ip, del->br_startoff, XFS_COW_FORK, &eof,
>  			&eidx, &got, &new);
>  
> -	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK); ifp = ifp;
> +	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
>  	ASSERT((eidx >= 0) && (eidx < ifp->if_bytes /
>  		(uint)sizeof(xfs_bmbt_rec_t)));
>  	ASSERT(del->br_blockcount > 0);
> -- 
> 2.9.3
> 
