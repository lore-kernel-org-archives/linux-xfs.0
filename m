Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:52165 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751196AbeAEBgZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jan 2018 20:36:25 -0500
Date: Fri, 5 Jan 2018 12:36:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/21] xfs: add scrub cross-referencing helpers for the
 inode btrees
Message-ID: <20180105013606.GU30682@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398981557.18741.8176324698766997260.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398981557.18741.8176324698766997260.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 04:43:35PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a couple of functions to the inode btrees that will be used
> to cross-reference metadata against the inobt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c |   99 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ialloc.h |    6 +++
>  2 files changed, 105 insertions(+)

Some minor things.

> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 3b57ef0..5de1ef3 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2751,3 +2751,102 @@ xfs_verify_dir_ino(
>  		return false;
>  	return xfs_verify_ino(mp, ino);
>  }
> +
> +/* Is there an inode record covering a given range of inode numbers? */
> +int
> +xfs_ialloc_has_inode_record(
> +	struct xfs_btree_cur	*cur,
> +	xfs_agino_t		low,
> +	xfs_agino_t		high,
> +	bool			*exists)
> +{
> +	struct xfs_inobt_rec_incore	irec;
> +	xfs_agino_t		agino;
> +	uint16_t		holemask;
> +	int			has;

has_record

> +	int			i;
> +	int			error;
> +
> +	*exists = false;
> +	error = xfs_inobt_lookup(cur, low, XFS_LOOKUP_LE, &has);
> +	while (error == 0 && has) {
> +		error = xfs_inobt_get_rec(cur, &irec, &has);
> +		if (error || irec.ir_startino > high)
> +			break;
> +
> +		agino = irec.ir_startino;
> +		holemask = irec.ir_holemask;
> +		for (i = 0; i < XFS_INOBT_HOLEMASK_BITS; holemask >>= 1,
> +				i++, agino += XFS_INODES_PER_HOLEMASK_BIT) {
> +			if (holemask & 1)
> +				continue;
> +			if (agino + XFS_INODES_PER_HOLEMASK_BIT > low &&
> +					agino <= high) {
> +				*exists = true;
> +				goto out;

return 0;

Then the out label can go away.

> +			}
> +		}
> +
> +		error = xfs_btree_increment(cur, 0, &has);
> +	}
> +out:
> +	return error;
> +}
> +
> +/* Is there an inode record covering a given extent? */
> +int
> +xfs_ialloc_has_inodes_at_extent(
> +	struct xfs_btree_cur	*cur,
> +	xfs_agblock_t		bno,
> +	xfs_extlen_t		len,
> +	bool			*exists)
> +{
> +	xfs_agino_t		low;
> +	xfs_agino_t		high;
> +
> +	low = XFS_OFFBNO_TO_AGINO(cur->bc_mp, bno, 0);
> +	high = XFS_OFFBNO_TO_AGINO(cur->bc_mp, bno + len, 0) - 1;
> +
> +	return xfs_ialloc_has_inode_record(cur, low, high, exists);
> +}
> +
> +struct xfs_ialloc_count_inodes {
> +	xfs_agino_t			count;
> +	xfs_agino_t			freecount;
> +};
> +
> +/* Record inode counts across all inobt records. */
> +STATIC int
> +xfs_ialloc_count_inodes_helper(
> +	struct xfs_btree_cur		*cur,
> +	union xfs_btree_rec		*rec,
> +	void				*priv)
> +{
> +	struct xfs_inobt_rec_incore	irec;
> +	struct xfs_ialloc_count_inodes	*ci = priv;
> +
> +	xfs_inobt_btrec_to_irec(cur->bc_mp, rec, &irec);
> +	ci->count += irec.ir_count;
> +	ci->freecount += irec.ir_freecount;
> +
> +	return 0;
> +}
> +
> +/* Count allocated and free inodes under an inobt. */
> +int
> +xfs_ialloc_count_inodes(
> +	struct xfs_btree_cur		*cur,
> +	xfs_agino_t			*count,
> +	xfs_agino_t			*freecount)
> +{
> +	struct xfs_ialloc_count_inodes	ci = {0};
> +	int				error;
> +
> +	ASSERT(cur->bc_btnum == XFS_BTNUM_INO);
> +	error = xfs_btree_query_all(cur, xfs_ialloc_count_inodes_helper, &ci);
> +	if (!error) {
> +		*count = ci.count;
> +		*freecount = ci.freecount;
> +	}
> +	return error;

Took me a minute to release that the branch was run when !error.
I'd be more obvious if it used typical error handling:

	if (error)
		return error;
	*count = ci.count;
	*freecount = ci.freecount;
	return 0;

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
