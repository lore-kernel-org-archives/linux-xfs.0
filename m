Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47650 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751550AbeCURHb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Mar 2018 13:07:31 -0400
Date: Wed, 21 Mar 2018 10:07:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: remove dead inode version setting code
Message-ID: <20180321170724.GD4818@magnolia>
References: <20180321075248.7677-1-david@fromorbit.com>
 <20180321075248.7677-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180321075248.7677-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 21, 2018 at 06:52:48PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We can only get into the branch if CRCs are enabled, so there's no
> need to check inside the branch for CRCs being enabled....
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 4fe17b368316..b646bf633f66 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -564,10 +564,7 @@ xfs_iread(
>  		/* initialise the on-disk inode core */
>  		memset(&ip->i_d, 0, sizeof(ip->i_d));
>  		VFS_I(ip)->i_generation = prandom_u32();
> -		if (xfs_sb_version_hascrc(&mp->m_sb))
> -			ip->i_d.di_version = 3;
> -		else
> -			ip->i_d.di_version = 2;
> +		ip->i_d.di_version = 3;
>  		return 0;
>  	}
>  
> -- 
> 2.16.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
