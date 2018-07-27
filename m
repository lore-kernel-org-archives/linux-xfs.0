Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56226 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730340AbeG0PnY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Jul 2018 11:43:24 -0400
Date: Fri, 27 Jul 2018 10:21:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/16] xfs: pass transaction lock while setting up agresv
 on cyclic metadata
Message-ID: <20180727142113.GB22227@bfoster>
References: <153256436688.29021.4638459579042241728.stgit@magnolia>
 <153256437346.29021.16149947898612665862.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153256437346.29021.16149947898612665862.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

On Wed, Jul 25, 2018 at 05:19:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Pass a tranaction pointer through to all helpers that calculate the
> per-AG block reservation.  Online repair will use this to reinitialize
> per-ag reservations while it still holds all the AG headers locked to
> the repair transaction.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Seems fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ag_resv.c        |   13 +++++++------
>  fs/xfs/libxfs/xfs_ag_resv.h        |    2 +-
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |   10 ++++++----
>  fs/xfs/libxfs/xfs_ialloc_btree.h   |    4 ++--
>  fs/xfs/libxfs/xfs_refcount_btree.c |    5 +++--
>  fs/xfs/libxfs/xfs_refcount_btree.h |    3 ++-
>  fs/xfs/libxfs/xfs_rmap_btree.c     |    5 +++--
>  fs/xfs/libxfs/xfs_rmap_btree.h     |    2 +-
>  fs/xfs/xfs_fsops.c                 |    2 +-
>  9 files changed, 26 insertions(+), 20 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index fecd187fcf2c..e701ebc36c06 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -248,7 +248,8 @@ __xfs_ag_resv_init(
>  /* Create a per-AG block reservation. */
>  int
>  xfs_ag_resv_init(
> -	struct xfs_perag		*pag)
> +	struct xfs_perag		*pag,
> +	struct xfs_trans		*tp)
>  {
>  	struct xfs_mount		*mp = pag->pag_mount;
>  	xfs_agnumber_t			agno = pag->pag_agno;
> @@ -260,11 +261,11 @@ xfs_ag_resv_init(
>  	if (pag->pag_meta_resv.ar_asked == 0) {
>  		ask = used = 0;
>  
> -		error = xfs_refcountbt_calc_reserves(mp, agno, &ask, &used);
> +		error = xfs_refcountbt_calc_reserves(mp, tp, agno, &ask, &used);
>  		if (error)
>  			goto out;
>  
> -		error = xfs_finobt_calc_reserves(mp, agno, &ask, &used);
> +		error = xfs_finobt_calc_reserves(mp, tp, agno, &ask, &used);
>  		if (error)
>  			goto out;
>  
> @@ -282,7 +283,7 @@ xfs_ag_resv_init(
>  
>  			mp->m_inotbt_nores = true;
>  
> -			error = xfs_refcountbt_calc_reserves(mp, agno, &ask,
> +			error = xfs_refcountbt_calc_reserves(mp, tp, agno, &ask,
>  					&used);
>  			if (error)
>  				goto out;
> @@ -298,7 +299,7 @@ xfs_ag_resv_init(
>  	if (pag->pag_rmapbt_resv.ar_asked == 0) {
>  		ask = used = 0;
>  
> -		error = xfs_rmapbt_calc_reserves(mp, agno, &ask, &used);
> +		error = xfs_rmapbt_calc_reserves(mp, tp, agno, &ask, &used);
>  		if (error)
>  			goto out;
>  
> @@ -309,7 +310,7 @@ xfs_ag_resv_init(
>  
>  #ifdef DEBUG
>  	/* need to read in the AGF for the ASSERT below to work */
> -	error = xfs_alloc_pagf_init(pag->pag_mount, NULL, pag->pag_agno, 0);
> +	error = xfs_alloc_pagf_init(pag->pag_mount, tp, pag->pag_agno, 0);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
> index 4619b554ee90..d1005116b43b 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.h
> +++ b/fs/xfs/libxfs/xfs_ag_resv.h
> @@ -7,7 +7,7 @@
>  #define	__XFS_AG_RESV_H__
>  
>  int xfs_ag_resv_free(struct xfs_perag *pag);
> -int xfs_ag_resv_init(struct xfs_perag *pag);
> +int xfs_ag_resv_init(struct xfs_perag *pag, struct xfs_trans *tp);
>  
>  bool xfs_ag_resv_critical(struct xfs_perag *pag, enum xfs_ag_resv_type type);
>  xfs_extlen_t xfs_ag_resv_needed(struct xfs_perag *pag,
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 735a33252eb2..86c50208a143 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -552,6 +552,7 @@ xfs_inobt_max_size(
>  static int
>  xfs_inobt_count_blocks(
>  	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
>  	xfs_agnumber_t		agno,
>  	xfs_btnum_t		btnum,
>  	xfs_extlen_t		*tree_blocks)
> @@ -560,14 +561,14 @@ xfs_inobt_count_blocks(
>  	struct xfs_btree_cur	*cur;
>  	int			error;
>  
> -	error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
> +	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
>  	if (error)
>  		return error;
>  
> -	cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno, btnum);
> +	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
>  	error = xfs_btree_count_blocks(cur, tree_blocks);
>  	xfs_btree_del_cursor(cur, error);
> -	xfs_buf_relse(agbp);
> +	xfs_trans_brelse(tp, agbp);
>  
>  	return error;
>  }
> @@ -578,6 +579,7 @@ xfs_inobt_count_blocks(
>  int
>  xfs_finobt_calc_reserves(
>  	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
>  	xfs_agnumber_t		agno,
>  	xfs_extlen_t		*ask,
>  	xfs_extlen_t		*used)
> @@ -588,7 +590,7 @@ xfs_finobt_calc_reserves(
>  	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
>  		return 0;
>  
> -	error = xfs_inobt_count_blocks(mp, agno, XFS_BTNUM_FINO, &tree_len);
> +	error = xfs_inobt_count_blocks(mp, tp, agno, XFS_BTNUM_FINO, &tree_len);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
> index bf8f0c405e7d..ebdd0c6b8766 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.h
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
> @@ -60,8 +60,8 @@ int xfs_inobt_rec_check_count(struct xfs_mount *,
>  #define xfs_inobt_rec_check_count(mp, rec)	0
>  #endif	/* DEBUG */
>  
> -int xfs_finobt_calc_reserves(struct xfs_mount *mp, xfs_agnumber_t agno,
> -		xfs_extlen_t *ask, xfs_extlen_t *used);
> +int xfs_finobt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
> +		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
>  extern xfs_extlen_t xfs_iallocbt_calc_size(struct xfs_mount *mp,
>  		unsigned long long len);
>  
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index b71937982c5b..bcd65ee37260 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -408,6 +408,7 @@ xfs_refcountbt_max_size(
>  int
>  xfs_refcountbt_calc_reserves(
>  	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
>  	xfs_agnumber_t		agno,
>  	xfs_extlen_t		*ask,
>  	xfs_extlen_t		*used)
> @@ -422,14 +423,14 @@ xfs_refcountbt_calc_reserves(
>  		return 0;
>  
>  
> -	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
> +	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
>  	if (error)
>  		return error;
>  
>  	agf = XFS_BUF_TO_AGF(agbp);
>  	agblocks = be32_to_cpu(agf->agf_length);
>  	tree_len = be32_to_cpu(agf->agf_refcount_blocks);
> -	xfs_buf_relse(agbp);
> +	xfs_trans_brelse(tp, agbp);
>  
>  	*ask += xfs_refcountbt_max_size(mp, agblocks);
>  	*used += tree_len;
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
> index d2852b6e1fa8..c868394ac02e 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.h
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.h
> @@ -55,6 +55,7 @@ extern xfs_extlen_t xfs_refcountbt_max_size(struct xfs_mount *mp,
>  		xfs_agblock_t agblocks);
>  
>  extern int xfs_refcountbt_calc_reserves(struct xfs_mount *mp,
> -		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
> +		struct xfs_trans *tp, xfs_agnumber_t agno, xfs_extlen_t *ask,
> +		xfs_extlen_t *used);
>  
>  #endif	/* __XFS_REFCOUNT_BTREE_H__ */
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index 221a88ea60bb..f79cf040d745 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -554,6 +554,7 @@ xfs_rmapbt_max_size(
>  int
>  xfs_rmapbt_calc_reserves(
>  	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
>  	xfs_agnumber_t		agno,
>  	xfs_extlen_t		*ask,
>  	xfs_extlen_t		*used)
> @@ -567,14 +568,14 @@ xfs_rmapbt_calc_reserves(
>  	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
>  		return 0;
>  
> -	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
> +	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
>  	if (error)
>  		return error;
>  
>  	agf = XFS_BUF_TO_AGF(agbp);
>  	agblocks = be32_to_cpu(agf->agf_length);
>  	tree_len = be32_to_cpu(agf->agf_rmap_blocks);
> -	xfs_buf_relse(agbp);
> +	xfs_trans_brelse(tp, agbp);
>  
>  	/* Reserve 1% of the AG or enough for 1 block per record. */
>  	*ask += max(agblocks / 100, xfs_rmapbt_max_size(mp, agblocks));
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
> index 50198b6c3bb2..820d668b063d 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.h
> @@ -51,7 +51,7 @@ extern xfs_extlen_t xfs_rmapbt_calc_size(struct xfs_mount *mp,
>  extern xfs_extlen_t xfs_rmapbt_max_size(struct xfs_mount *mp,
>  		xfs_agblock_t agblocks);
>  
> -extern int xfs_rmapbt_calc_reserves(struct xfs_mount *mp,
> +extern int xfs_rmapbt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
>  		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
>  
>  #endif	/* __XFS_RMAP_BTREE_H__ */
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 3f2bd6032cf8..7c00b8bedfe3 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -536,7 +536,7 @@ xfs_fs_reserve_ag_blocks(
>  
>  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
>  		pag = xfs_perag_get(mp, agno);
> -		err2 = xfs_ag_resv_init(pag);
> +		err2 = xfs_ag_resv_init(pag, NULL);
>  		xfs_perag_put(pag);
>  		if (err2 && !error)
>  			error = err2;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
