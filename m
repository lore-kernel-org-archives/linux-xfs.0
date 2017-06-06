Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44078 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751423AbdFFQ1n (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jun 2017 12:27:43 -0400
Date: Tue, 6 Jun 2017 12:27:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 06/13] xfs: export _inobt_btrec_to_irec and
 _ialloc_cluster_alignment for scrub
Message-ID: <20170606162741.GA55166@bfoster.bfoster>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
 <149643867690.23065.2925885507896539128.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149643867690.23065.2925885507896539128.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 02, 2017 at 02:24:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a function to extract an in-core inobt record from a generic
> btree_rec union so that scrub will be able to check inobt records
> and check inode block alignment.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c |   43 ++++++++++++++++++++++++++-----------------
>  fs/xfs/libxfs/xfs_ialloc.h |    5 +++++
>  2 files changed, 31 insertions(+), 17 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 1e5ed94..33626373 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -46,7 +46,7 @@
>  /*
>   * Allocation group level functions.
>   */
> -static inline int
> +int
>  xfs_ialloc_cluster_alignment(
>  	struct xfs_mount	*mp)
>  {
> @@ -98,24 +98,14 @@ xfs_inobt_update(
>  	return xfs_btree_update(cur, &rec);
>  }
>  
> -/*
> - * Get the data from the pointed-to record.
> - */
> -int					/* error */
> -xfs_inobt_get_rec(
> -	struct xfs_btree_cur	*cur,	/* btree cursor */
> -	xfs_inobt_rec_incore_t	*irec,	/* btree record */
> -	int			*stat)	/* output: success/failure */
> +void
> +xfs_inobt_btrec_to_irec(
> +	struct xfs_mount		*mp,
> +	union xfs_btree_rec		*rec,
> +	struct xfs_inobt_rec_incore	*irec)
>  {
> -	union xfs_btree_rec	*rec;
> -	int			error;
> -
> -	error = xfs_btree_get_rec(cur, &rec, stat);
> -	if (error || *stat == 0)
> -		return error;
> -
>  	irec->ir_startino = be32_to_cpu(rec->inobt.ir_startino);
> -	if (xfs_sb_version_hassparseinodes(&cur->bc_mp->m_sb)) {
> +	if (xfs_sb_version_hassparseinodes(&mp->m_sb)) {
>  		irec->ir_holemask = be16_to_cpu(rec->inobt.ir_u.sp.ir_holemask);
>  		irec->ir_count = rec->inobt.ir_u.sp.ir_count;
>  		irec->ir_freecount = rec->inobt.ir_u.sp.ir_freecount;
> @@ -130,6 +120,25 @@ xfs_inobt_get_rec(
>  				be32_to_cpu(rec->inobt.ir_u.f.ir_freecount);
>  	}
>  	irec->ir_free = be64_to_cpu(rec->inobt.ir_free);
> +}
> +
> +/*
> + * Get the data from the pointed-to record.
> + */
> +int					/* error */
> +xfs_inobt_get_rec(
> +	struct xfs_btree_cur	*cur,	/* btree cursor */
> +	xfs_inobt_rec_incore_t	*irec,	/* btree record */

Might as well kill the typedef usage while we're here. Otherwise looks
good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	int			*stat)	/* output: success/failure */
> +{
> +	union xfs_btree_rec	*rec;
> +	int			error;
> +
> +	error = xfs_btree_get_rec(cur, &rec, stat);
> +	if (error || *stat == 0)
> +		return error;
> +
> +	xfs_inobt_btrec_to_irec(cur->bc_mp, rec, irec);
>  
>  	return 0;
>  }
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index 0bb8966..b32cfb5 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -168,5 +168,10 @@ int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
>  int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
>  		xfs_agnumber_t agno, struct xfs_buf **bpp);
>  
> +union xfs_btree_rec;
> +void xfs_inobt_btrec_to_irec(struct xfs_mount *mp, union xfs_btree_rec *rec,
> +		struct xfs_inobt_rec_incore *irec);
> +
> +int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
>  
>  #endif	/* __XFS_IALLOC_H__ */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
