Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23761 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755598AbdAJXQw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 18:16:52 -0500
Date: Tue, 10 Jan 2017 15:16:44 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v7 6/6] xfs: sanity check inode di_mode
Message-ID: <20170110231644.GP14038@birch.djwong.org>
References: <1484062757-12433-1-git-send-email-amir73il@gmail.com>
 <1484062757-12433-7-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484062757-12433-7-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Jan 10, 2017 at 05:39:17PM +0200, Amir Goldstein wrote:
> Check for invalid file type in xfs_dinode_verify()
> and fail to load the inode structure from disk.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 0091ac3..d93f9d9 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -29,6 +29,7 @@
>  #include "xfs_icache.h"
>  #include "xfs_trans.h"
>  #include "xfs_ialloc.h"
> +#include "xfs_dir2.h"
>  
>  /*
>   * Check that none of the inode's in the buffer have a next
> @@ -398,6 +399,8 @@ xfs_dinode_verify(
>  		return false;
>  
>  	mode = be16_to_cpu(dip->di_mode);
> +	if (mode && xfs_mode_to_ftype(mode) == XFS_DIR3_FT_UNKNOWN)
> +		return false;
>  
>  	/* No zero-length symlinks/dirs. */
>  	if ((S_ISLNK(mode) || S_ISDIR(mode)) && dip->di_size == 0)
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
