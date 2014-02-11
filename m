Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 533D97F3F
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 00:22:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CA626AC009
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 22:22:17 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	tAGzEZbsd2lf7xJ5 for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 22:22:15 -0800 (PST)
Date: Tue, 11 Feb 2014 17:22:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 03/11] xfs: support the XFS_BTNUM_FINOBT free inode
	btree type
Message-ID: <20140211062211.GD13647@dastard>
References: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
	<1391536182-9048-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1391536182-9048-4-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 04, 2014 at 12:49:34PM -0500, Brian Foster wrote:
> Define the AGI fields for the finobt root/level and add magic
> numbers. Update the btree code to add support for the new
> XFS_BTNUM_FINOBT inode btree.
> 
> The finobt root block is reserved immediately following the inobt
> root block in the AG. Update XFS_PREALLOC_BLOCKS() to determine the
> starting AG data block based on whether finobt support is enabled.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_ag.h           | 32 +++++++++++++++----------
>  fs/xfs/xfs_btree.c        |  6 +++--
>  fs/xfs/xfs_btree.h        |  3 +++
>  fs/xfs/xfs_format.h       | 14 ++++++++++-
>  fs/xfs/xfs_ialloc.c       | 37 +++++++++++++++++++++++++----
>  fs/xfs/xfs_ialloc_btree.c | 60 +++++++++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_log_recover.c  |  2 ++
>  fs/xfs/xfs_stats.c        |  1 +
>  fs/xfs/xfs_stats.h        | 18 +++++++++++++-
>  fs/xfs/xfs_types.h        |  2 +-
>  10 files changed, 150 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
> index 3fc1098..5d3011f 100644
> --- a/fs/xfs/xfs_ag.h
> +++ b/fs/xfs/xfs_ag.h
> @@ -164,22 +164,28 @@ typedef struct xfs_agi {
>  	__be32		agi_pad32;
>  	__be64		agi_lsn;	/* last write sequence */
>  
> +	__be32		agi_free_root; /* root of the free inode btree */
> +	__be32		agi_free_level;/* levels in free inode btree */
> +
>  	/* structure must be padded to 64 bit alignment */
>  } xfs_agi_t;

Can you add comments to the agi structure that indicate where the
contiguous logging regions start and end?

.....

>  #ifdef DEBUG
> @@ -1515,14 +1517,39 @@ xfs_ialloc_log_agi(
>  	ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
>  #endif
>  	/*
> -	 * Compute byte offsets for the first and last fields.
> +	 * The growth of the agi buffer over time now requires that we interpret
> +	 * the buffer as two logical regions delineated at the end of the unlinked
> +	 * list. This is due to the size of the hash table and its location in the
> +	 * middle of the agi.
> +	 *
> +	 * For example, a request to log a field before agi_unlinked and a field
> +	 * after agi_unlinked could cause us to log the entire hash table and use
> +	 * an excessive amount of log space. To avoid this behavior, log the
> +	 * region up through agi_unlinked in one call and the region after
> +	 * agi_unlinked through the end of the structure in another.
>  	 */

This comment should be at the head of the function as it describes
the constraints the function works under, rather than explaining
particular piece of the code.

....
> @@ -334,11 +384,17 @@ xfs_inobt_init_cursor(
>  
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
> -	cur->bc_nlevels = be32_to_cpu(agi->agi_level);
>  	cur->bc_btnum = btnum;
> +	if (btnum == XFS_BTNUM_INO) {
> +		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
> +		cur->bc_ops = &xfs_inobt_ops;
> +	} else {
> +		cur->bc_nlevels = be32_to_cpu(agi->agi_free_level);
> +		cur->bc_ops = &xfs_finobt_ops;

		ASSERT(btnum == XFS_BTNUM_FINO);
....

Otherwise looks pretty good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
