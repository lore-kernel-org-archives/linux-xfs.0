Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbfBGPvk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Feb 2019 10:51:40 -0500
Date: Thu, 7 Feb 2019 10:51:37 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: Don't free EOF blocks on close when extent size
 hints are set
Message-ID: <20190207155137.GD2880@bfoster>
References: <20190207050813.24271-1-david@fromorbit.com>
 <20190207050813.24271-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207050813.24271-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 07, 2019 at 04:08:12PM +1100, Dave Chinner wrote:
> When we have a workload that does open/write/close on files with
> extent size hints set in parallel with other allocation, the file
> becomes rapidly fragmented. This is due to close() calling
> xfs_release() and removing the preallocated extent beyond EOF.  This
> occurs for both buffered and direct writes that append to files with
> extent size hints.
> 
> The existing open/write/close hueristic in xfs_release() does not
> catch this as writes to files using extent size hints do not use
> delayed allocation and hence do not leave delayed allocation blocks
> allocated on the inode that can be detected in xfs_release(). Hence
> XFS_IDIRTY_RELEASE never gets set.
> 
> In xfs_file_release(), we can tell whether the inode has extent size
> hints set and skip EOF block truncation. We add this check to
> xfs_can_free_eofblocks() so that we treat the post-EOF preallocated
> extent like intentional preallocation and so are persistent unless
> directly removed by userspace.
> 
> Before:
> 
> Test 2: Extent size hint fragmentation counts
> 
> /mnt/scratch/file.0: 1002
> /mnt/scratch/file.1: 1002
> /mnt/scratch/file.2: 1002
> /mnt/scratch/file.3: 1002
> /mnt/scratch/file.4: 1002
> /mnt/scratch/file.5: 1002
> /mnt/scratch/file.6: 1002
> /mnt/scratch/file.7: 1002
> 
> After:
> 
> Test 2: Extent size hint fragmentation counts
> 
> /mnt/scratch/file.0: 4
> /mnt/scratch/file.1: 4
> /mnt/scratch/file.2: 4
> /mnt/scratch/file.3: 4
> /mnt/scratch/file.4: 4
> /mnt/scratch/file.5: 4
> /mnt/scratch/file.6: 4
> /mnt/scratch/file.7: 4
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 1ee8c5539fa4..98e5e305b789 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -761,12 +761,15 @@ xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
>  		return false;
>  
>  	/*
> -	 * Do not free real preallocated or append-only files unless the file
> -	 * has delalloc blocks and we are forced to remove them.
> +	 * Do not free extent size hints, real preallocated or append-only files
> +	 * unless the file has delalloc blocks and we are forced to remove
> +	 * them.
>  	 */
> -	if (ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
> +	if (xfs_get_extsz_hint(ip) ||
> +	    (ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))) {
>  		if (!force || ip->i_delayed_blks == 0)
>  			return false;
> +	}

Note that this will affect the background eofblocks scanner as well such
that we'll no longer ever trim files with an extent size hint. I'm not
saying that's necessarily a problem, but it should at minimum be
discussed in the commit log (which currently only refers to the more
problematic release context).

The consideration to be made is that this could affect the ability to
reclaim post-eof space on -ENOSPC mitigating eofblocks scans in cases
where there are large extent size hints (or many files with smaller
extsz hints, etc.). That might be something worth trying to accommodate
one way or another since it's slightly inconsistent behavior. Consider
that an unmount -> reclaim induced force eofb trim -> mount would
suddenly free up a bunch of space that the eofblocks scan didn't, for
example. This is already the case for preallocated files of course, so
this may very well be reasonable enough for extsz hints as well. What
might also be interesting is considering whether it's worth further
differentiating an -ENOSPC scan from a typical background scan to allow
the former to behave a bit more like reclaim in this regard.

Brian

>  
>  	return true;
>  }
> -- 
> 2.20.1
> 
