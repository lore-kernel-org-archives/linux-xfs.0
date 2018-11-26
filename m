Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33596 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbeK0JyO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Nov 2018 04:54:14 -0500
Date: Mon, 26 Nov 2018 14:58:25 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: clean up indentation issues, remove an unwanted
 space
Message-ID: <20181126225825.GD6792@magnolia>
References: <20181123165913.26671-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181123165913.26671-1-colin.king@canonical.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Colin King <colin.king@canonical.com>
Cc: linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Nov 23, 2018 at 04:59:13PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a statement that has an unwanted space in the indentation.
> Remove it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 05db9540e459..f21756751540 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2242,7 +2242,7 @@ xfs_ifree_cluster(
>  		 * want it to fail. We can acheive this by adding a write
>  		 * verifier to the buffer.
>  		 */
> -		 bp->b_ops = &xfs_inode_buf_ops;
> +		bp->b_ops = &xfs_inode_buf_ops;
>  
>  		/*
>  		 * Walk the inodes already attached to the buffer and mark them
> -- 
> 2.19.1
> 
