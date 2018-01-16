Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55196 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbeAPXFk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 18:05:40 -0500
Date: Tue, 16 Jan 2018 15:05:36 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 07/21] xfs: add scrub cross-referencing helpers for
 the inode btrees
Message-ID: <20180116230536.GY5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398981557.18741.8176324698766997260.stgit@magnolia>
 <20180105215145.GK5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180105215145.GK5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>

On Fri, Jan 05, 2018 at 01:51:45PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a couple of functions to the inode btrees that will be used
> to cross-reference metadata against the inobt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: minor fixes suggested by dchinner

Ping?

--D

> ---
>  fs/xfs/libxfs/xfs_ialloc.c |   99 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ialloc.h |    6 +++
>  2 files changed, 105 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 3b57ef0..decda7e 100644
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
> +	int			has_record;
> +	int			i;
> +	int			error;
> +
> +	*exists = false;
> +	error = xfs_inobt_lookup(cur, low, XFS_LOOKUP_LE, &has_record);
> +	while (error == 0 && has_record) {
> +		error = xfs_inobt_get_rec(cur, &irec, &has_record);
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
> +				return 0;
> +			}
> +		}
> +
> +		error = xfs_btree_increment(cur, 0, &has_record);
> +	}
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
> +	if (error)
> +		return error;
> +
> +	*count = ci.count;
> +	*freecount = ci.freecount;
> +	return 0;
> +}
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index 66a8de0..c5402bb 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -170,6 +170,12 @@ int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
>  union xfs_btree_rec;
>  void xfs_inobt_btrec_to_irec(struct xfs_mount *mp, union xfs_btree_rec *rec,
>  		struct xfs_inobt_rec_incore *irec);
> +int xfs_ialloc_has_inodes_at_extent(struct xfs_btree_cur *cur,
> +		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
> +int xfs_ialloc_has_inode_record(struct xfs_btree_cur *cur, xfs_agino_t low,
> +		xfs_agino_t high, bool *exists);
> +int xfs_ialloc_count_inodes(struct xfs_btree_cur *cur, xfs_agino_t *count,
> +		xfs_agino_t *freecount);
>  
>  int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
>  void xfs_ialloc_agino_range(struct xfs_mount *mp, xfs_agnumber_t agno,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
