Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54880 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752584AbdBNNEr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Feb 2017 08:04:47 -0500
Date: Tue, 14 Feb 2017 08:04:47 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix uninitialized variable in _reflink_convert_cow
Message-ID: <20170214130447.GB3223@bfoster.bfoster>
References: <20170214065417.GC6813@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170214065417.GC6813@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, dan.carpenter@oracle.com

On Mon, Feb 13, 2017 at 10:54:17PM -0800, Darrick J. Wong wrote:
> Fix an uninitialized variable.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_reflink.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 2f3d2d5..da6d08f 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -362,7 +362,7 @@ xfs_reflink_convert_cow(
>  	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
>  	xfs_extnum_t		idx;
>  	bool			found;
> -	int			error;
> +	int			error = 0;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
