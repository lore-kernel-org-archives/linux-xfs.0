Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26327 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936237AbcJQVMK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 17:12:10 -0400
Date: Mon, 17 Oct 2016 14:12:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/4] xfs: fix the same_inode check in xfs_file_share_range
Message-ID: <20161017211205.GC26485@birch.djwong.org>
References: <1476705920-32493-1-git-send-email-hch@lst.de>
 <1476705920-32493-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476705920-32493-3-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 17, 2016 at 02:05:18PM +0200, Christoph Hellwig wrote:
> The VFS i_ino is an unsigned long, while XFS inode numbers are 64-bit
> wide, so checking i_ino for equality could lead to rate false positives
> on 32-bit architectures.  Just compare the inode pointers themselves
> to be safe.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 20563f2..012a960 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1003,7 +1003,7 @@ xfs_file_share_range(
>  	    IS_SWAPFILE(inode_out))
>  		return -ETXTBSY;
>  
> -	same_inode = (inode_in->i_ino == inode_out->i_ino);
> +	same_inode = (inode_in == inode_out);
>  
>  	/* Don't reflink dirs, pipes, sockets... */
>  	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
> -- 
> 2.1.4
> 
