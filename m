Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:20878 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732372AbfAOU0B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Jan 2019 15:26:01 -0500
Date: Wed, 16 Jan 2019 07:25:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: use generic fillattr to reduce redundant code
Message-ID: <20190115202556.GJ4205@dastard>
References: <20190115170849.GC12689@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115170849.GC12689@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Jan 15, 2019 at 09:08:49AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor xfs_vn_getattr to use generic_fillattr to fill out parts of the
> kstat structure instead of open-coding the same pieces.  This eliminates
> redundant code and fixes a bug where we fail to set the AUTOMOUNT
> attribute.  Obviously, we retain all the xfs-specific parts.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_iops.c |   10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index f48ffd7a8d3e..169bd7824479 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -501,16 +501,9 @@ xfs_vn_getattr(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> +	generic_fillattr(inode, stat);
>  	stat->size = XFS_ISIZE(ip);

Maybe a comment to indicate that we're overwriting some of the
fields that generic_fillattr() also set from the VFS inode, so we
need to call it first before filling out the specific XFS
information?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
