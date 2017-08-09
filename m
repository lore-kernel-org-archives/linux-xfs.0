Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:7562 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751958AbdHIVdL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2017 17:33:11 -0400
Date: Thu, 10 Aug 2017 07:33:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of an attribute
Message-ID: <20170809213307.GJ21024@dastard>
References: <1502276772-24293-1-git-send-email-alex@zadarastorage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1502276772-24293-1-git-send-email-alex@zadarastorage.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: alex@zadarastorage.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, darrick.wong@oracle.com, libor.klepac@bcom.cz

On Wed, Aug 09, 2017 at 02:06:12PM +0300, alex@zadarastorage.com wrote:
> From: Alex Lyakas <alex@zadarastorage.com>
> 
> The new attribute leaf buffer is not held locked across
> the transaction roll between the shortform->leaf modification
> and the addition of the new entry. As a result, the attribute
> buffer modification being made is not atomic from
> an operational perspective. Hence the AIL push can grab it in
> the transient state of "just created" after the initial
> transaction is rolled, because the buffer has been released.
> This leads to xfs_attr3_leaf_verify() asserting that
> hdr.count is zero, treating this as in-memory corruption,
> and shutting down the filesystem.
> 
> Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 19 ++++++++++++++++++-
>  fs/xfs/libxfs/xfs_attr_leaf.c |  4 +++-
>  fs/xfs/libxfs/xfs_attr_leaf.h |  3 ++-
>  3 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index de7b9bd..982e322 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -216,10 +216,11 @@
>  	struct xfs_defer_ops	dfops;
>  	struct xfs_trans_res	tres;
>  	xfs_fsblock_t		firstblock;
>  	int			rsvd = (flags & ATTR_ROOT) != 0;
>  	int			error, err2, local;
> +	struct xfs_buf		*leaf_bp = NULL;
>  
>  	XFS_STATS_INC(mp, xs_attr_set);
>  
>  	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
>  		return -EIO;
> @@ -325,11 +326,17 @@
>  		/*
>  		 * It won't fit in the shortform, transform to a leaf block.
>  		 * GROT: another possible req'mt for a double-split btree op.
>  		 */
>  		xfs_defer_init(args.dfops, args.firstblock);
> -		error = xfs_attr_shortform_to_leaf(&args);
> +		error = xfs_attr_shortform_to_leaf(&args, &leaf_bp);
> +		/*
> +		 * Prevent the leaf buffer from being unlocked
> +		 * when "args.trans" transaction commits.
> +		 */
> +		if (leaf_bp)
> +			xfs_trans_bhold(args.trans, leaf_bp);
>  		if (!error)
>  			error = xfs_defer_finish(&args.trans, args.dfops, dp);
>  		if (error) {
>  			args.trans = NULL;
>  			xfs_defer_cancel(&dfops);

Hmmmm, looking closer at xfs_defer_finish(), just holding the buffer
here isn't sufficient. xfs_defer_finish() can roll the transaction a
number of times and holding the buffer is a one-shot deal. Hence the
buffer held buffer will have BLI_HOLD removed on the next commit
and be unlocked by the second commit, whether it be inside
xfs_defer_finish() or the roll that occurs below.

ISTR a previous discussion with Darrick that we needed something
like xfs_defer_join() with buffers instead of inodes to allow them
to be held across a call to xfs_defer_finish()....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
