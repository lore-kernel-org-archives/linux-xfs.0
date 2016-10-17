Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19740 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936212AbcJQVMA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 17:12:00 -0400
Date: Mon, 17 Oct 2016 14:11:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/4] xfs: remove the same fs check from
 xfs_file_share_range
Message-ID: <20161017211154.GB26485@birch.djwong.org>
References: <1476705920-32493-1-git-send-email-hch@lst.de>
 <1476705920-32493-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476705920-32493-2-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 17, 2016 at 02:05:17PM +0200, Christoph Hellwig wrote:
> The VFS already does the check, and the placement of this duplicate is in
> the way of the following locking rework.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_file.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index a314fc7..20563f2 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1003,9 +1003,6 @@ xfs_file_share_range(
>  	    IS_SWAPFILE(inode_out))
>  		return -ETXTBSY;
>  
> -	/* Reflink only works within this filesystem. */
> -	if (inode_in->i_sb != inode_out->i_sb)
> -		return -EXDEV;
>  	same_inode = (inode_in->i_ino == inode_out->i_ino);
>  
>  	/* Don't reflink dirs, pipes, sockets... */
> -- 
> 2.1.4
> 
