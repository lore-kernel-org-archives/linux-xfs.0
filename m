Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:50664 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758714AbdLSGNj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 01:13:39 -0500
Date: Tue, 19 Dec 2017 17:13:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/13] xfs: fail out of xfs_attr3_leaf_lookup_int if it
 looks corrupt
Message-ID: <20171219061327.GU4094@dastard>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
 <151320955989.30654.3751933390923840893.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151320955989.30654.3751933390923840893.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 13, 2017 at 03:59:19PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the xattr leaf block looks corrupt, return -EFSCORRUPTED to userspace
> instead of ASSERTing on debug kernels or running off the end of the
> buffer on regular kernels.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index a5033f0..e130952 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2246,7 +2246,8 @@ xfs_attr3_leaf_lookup_int(
>  	leaf = bp->b_addr;
>  	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
>  	entries = xfs_attr3_leaf_entryp(leaf);
> -	ASSERT(ichdr.count < args->geo->blksize / 8);
> +	if (ichdr.count >= args->geo->blksize / 8)
> +		return -EFSCORRUPTED;

I was wondering exactly what the "/ 8" is for, but I think it's just
a rough calculation of maximum number of leaf entries taht can be in
the block. Doesn't matter right now - this is still better than
assert failures....

So, look fine,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
