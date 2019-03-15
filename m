Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:3677 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726910AbfCODmk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 23:42:40 -0400
Date: Fri, 15 Mar 2019 14:42:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: only free posteof blocks on first close
Message-ID: <20190315034237.GL23020@dastard>
References: <155259893433.30230.6566995969675098053.stgit@magnolia>
 <155259894034.30230.7188877605950498518.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155259894034.30230.7188877605950498518.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Mar 14, 2019 at 02:29:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Certain workloads fragment files on XFS very badly, such as a software
> package that creates a number of threads, each of which repeatedly run
> the sequence: open a file, perform a synchronous write, and close the
> file, which defeats the speculative preallocation mechanism.  We work
> around this problem by only deleting posteof blocks the /first/ time a
> file is closed to preserve the behavior that unpacking a tarball lays
> out files one after the other with no gaps.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_inode.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 665fb2518a66..981c34bdec25 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1262,9 +1262,7 @@ xfs_release(
>  				return error;
>  		}
>  
> -		/* delalloc blocks after truncation means it really is dirty */
> -		if (ip->i_delayed_blks)
> -			xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
> +		xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);

I've been meaning to test this exact setup to see what the impact
is, but haven't got to it yet. I can't really comment on it sanely
until I see what it does to various workloads....

We do need more than this though. e.g we need to skip the block
freeing compeltely on O_RDONLY file closes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
