Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C18AC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 01:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiDGBHu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 21:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbiDGBHt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 21:07:49 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 52042641E
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 18:05:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D4E4D10E578F;
        Thu,  7 Apr 2022 11:05:45 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ncGam-00Ef9i-6E; Thu, 07 Apr 2022 11:05:44 +1000
Date:   Thu, 7 Apr 2022 11:05:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V9 12/19] xfs: Introduce macros to represent new maximum
 extent counts for data/attr forks
Message-ID: <20220407010544.GC1544202@dread.disaster.area>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
 <20220406061904.595597-13-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406061904.595597-13-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=624e38ea
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=ZF8QtMNok2HvXQ4siOAA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 06, 2022 at 11:48:56AM +0530, Chandan Babu R wrote:
> This commit defines new macros to represent maximum extent counts allowed by
> filesystems which have support for large per-inode extent counters.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       |  9 ++++-----
>  fs/xfs/libxfs/xfs_bmap_btree.c |  3 ++-
>  fs/xfs/libxfs/xfs_format.h     | 24 ++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_inode_buf.c  |  4 +++-
>  fs/xfs/libxfs/xfs_inode_fork.c |  3 ++-
>  fs/xfs/libxfs/xfs_inode_fork.h | 21 +++++++++++++++++----
>  6 files changed, 50 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index b317226fb4ba..1254d4d4821e 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -61,10 +61,8 @@ xfs_bmap_compute_maxlevels(
>  	int		sz;		/* root block size */
>  
>  	/*
> -	 * The maximum number of extents in a file, hence the maximum number of
> -	 * leaf entries, is controlled by the size of the on-disk extent count,
> -	 * either a signed 32-bit number for the data fork, or a signed 16-bit
> -	 * number for the attr fork.
> +	 * The maximum number of extents in a fork, hence the maximum number of
> +	 * leaf entries, is controlled by the size of the on-disk extent count.
>  	 *
>  	 * Note that we can no longer assume that if we are in ATTR1 that the
>  	 * fork offset of all the inodes will be
> @@ -74,7 +72,8 @@ xfs_bmap_compute_maxlevels(
>  	 * ATTR2 we have to assume the worst case scenario of a minimum size
>  	 * available.
>  	 */
> -	maxleafents = xfs_iext_max_nextents(whichfork);
> +	maxleafents = xfs_iext_max_nextents(xfs_has_large_extent_counts(mp),
> +				whichfork);
>  	if (whichfork == XFS_DATA_FORK)
>  		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
>  	else

Just to confirm, the large extent count feature bit can only be
added when the filesystem is unmounted?

> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 453309fc85f2..7aabeccea9ab 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -611,7 +611,8 @@ xfs_bmbt_maxlevels_ondisk(void)
>  	minrecs[1] = xfs_bmbt_block_maxrecs(blocklen, false) / 2;
>  
>  	/* One extra level for the inode root. */
> -	return xfs_btree_compute_maxlevels(minrecs, MAXEXTNUM) + 1;
> +	return xfs_btree_compute_maxlevels(minrecs,
> +			XFS_MAX_EXTCNT_DATA_FORK_LARGE) + 1;
>  }

Why is this set to XFS_MAX_EXTCNT_DATA_FORK_LARGE rather than being
conditional xfs_has_large_extent_counts(mp)? i.e. if the feature bit
is not set, the maximum on-disk levels in the bmbt is determined by
XFS_MAX_EXTCNT_DATA_FORK_SMALL, not XFS_MAX_EXTCNT_DATA_FORK_LARGE.

The "_ondisk" suffix implies that it has something to do with the
on-disk format of the filesystem, but AFAICT what we are calculating
here is a constant used for in-memory structure allocation? There
needs to be something explained/changed here, because this is
confusing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
