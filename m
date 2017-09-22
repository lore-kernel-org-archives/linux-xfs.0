Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:30354 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751794AbdIVFgB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Sep 2017 01:36:01 -0400
Date: Fri, 22 Sep 2017 15:35:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 1/3] xfs: Show realtime device stats on statfs calls
 if inherit flag set
Message-ID: <20170922053523.GC10955@dastard>
References: <20170919035238.3976871-1-rwareing@fb.com>
 <20170919035238.3976871-2-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170919035238.3976871-2-rwareing@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, hch@infradead.org

On Mon, Sep 18, 2017 at 08:52:36PM -0700, Richard Wareing wrote:
> - Reports realtime device free blocks in statfs calls if inheritance
>   bit is set on the inode of directory.  This is a bit more intuitive,
>   especially for use-cases which are using a much larger device for
>   the realtime device.
> - Add XFS_IS_REALTIME_MOUNT option to gate based on the existence of a
>   realtime device on the mount, similar to the XFS_IS_REALTIME_INODE
>   option.
> 
> Signed-off-by: Richard Wareing <rwareing@fb.com>

Didn't Christoph give a Reviewed-by for this one? Normally when we
repost a patch that already has a revewied-by we include it in the
commit message. That tells other reviewers and the maintainer that
it has already been reviewed :P

> Changes since v3:
> * Fixed accounting bug, we are not required to substract m_alloc_set_aside
>   as this is a data device only requirement.
> * Added XFS_IS_REALTIME_MOUNT macro based on learnings from CVE-2017-14340,
>   now provides similar gating on the mount as XFS_IS_REALTIME_INODE does
>   for the inode.
> 
> Changes since v2:
> * Style updated per Christoph Hellwig's comment
> * Fixed bug: statp->f_bavail = statp->f_bfree
> 
>  fs/xfs/xfs_linux.h | 2 ++
>  fs/xfs/xfs_super.c | 8 ++++++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 044fb0e..fe46e71 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -280,8 +280,10 @@ static inline __uint64_t howmany_64(__uint64_t x, __uint32_t y)
>  
>  #ifdef CONFIG_XFS_RT
>  #define XFS_IS_REALTIME_INODE(ip) ((ip)->i_d.di_flags & XFS_DIFLAG_REALTIME)
> +#define XFS_IS_REALTIME_MOUNT(mp) ((mp)->m_rtdev_targp ? 1 : 0)
>  #else
>  #define XFS_IS_REALTIME_INODE(ip) (0)
> +#define XFS_IS_REALTIME_MOUNT(mp) (0)
>  #endif

Good idea. I think we should probably turn these into inline
functions. That can be done in a new patch, though.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
