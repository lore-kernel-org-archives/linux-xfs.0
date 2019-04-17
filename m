Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:51262 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727340AbfDQVKq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Apr 2019 17:10:46 -0400
Date: Thu, 18 Apr 2019 07:10:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: widen inode delalloc block counter to 64-bits
Message-ID: <20190417211042.GP29573@dread.disaster.area>
References: <155546518260.176148.16583864799178682873.stgit@magnolia>
 <155546519490.176148.10439883748477358842.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155546519490.176148.10439883748477358842.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 16, 2019 at 06:39:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Widen the incore inode's i_delayed_blks counter to be a 64-bit integer.
> This is necessary to fix an integer overflow problem that can be
> reproduced easily now that we use the counter to track blocks that are
> assigned to the inode in memory but not on disk.  This includes actual
> delalloc reservations as well as real extents in the COW fork that
> are waiting to be remapped into the data fork.
> 
> These 'delayed mapping' blocks can easily exceed 2^32 blocks if one
> creates a very large sparse file of size approximately 2^33 bytes with
> one byte written every 2^23 bytes, sets a very large COW extent size
> hint of 2^23 blocks, reflinks the first file into a second file, and
> then writes a single byte every 2^23 blocks in the original file.
> 
> When this happens, we'll try to create approximately 1024 2^23 extent
> reservations in the COW fork, which will overflow the counter and cause
> problems.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_inode.h |    2 +-
>  fs/xfs/xfs_qm.c    |    3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 87e701b638ae..558173f95a03 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -56,7 +56,7 @@ typedef struct xfs_inode {
>  	spinlock_t		i_flags_lock;	/* inode i_flags lock */
>  	/* Miscellaneous state. */
>  	unsigned long		i_flags;	/* see defined flags below */
> -	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
> +	uint64_t		i_delayed_blks;	/* count of delay alloc blks */
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */

This fills a 4 byte hole in the structure, yes?  Might be worth
mentioning in the commit log that it doesn't increase the size of
the struct inode, then.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
