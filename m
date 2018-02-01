Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55288 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751715AbeBAVnr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Feb 2018 16:43:47 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 306373E500
        for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2018 21:43:47 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED2795D6B7
        for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2018 21:43:46 +0000 (UTC)
Date: Thu, 1 Feb 2018 16:43:45 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC] xfs: change agfl perag res into an rmapbt-based
 reservation
Message-ID: <20180201214344.GA32709@bfoster.bfoster>
References: <20180131145901.17053-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180131145901.17053-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Wed, Jan 31, 2018 at 09:59:01AM -0500, Brian Foster wrote:
...
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> This is RFC for the moment because I have reproduced a one-off
> sb_fdblocks inconsistency during xfstests. Unfortunately, I have not
> been able to reproduce that problem after several rmapbt/reflink enabled
> cycles so far.
> 
> It's not yet clear to me if this is a bug in this patch or not, so more
> testing is required at minimum. I'm sending this out for thoughts in the
> meantime.
> 

FYI - I've finally reproduced this particular problem and it triggered
on a kernel without this patch applied, so I'm fairly confident it's
unrelated. I still have to narrow down the reproducer, but I'll look
into that independently. In the meantime I think it's safe to drop RFC
status from this patch..

Brian

> Brian
> 
>  fs/xfs/libxfs/xfs_ag_resv.c    | 39 ++++++++++++++++++++++-----------------
>  fs/xfs/libxfs/xfs_ag_resv.h    | 31 +++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_alloc.c      | 14 +++-----------
>  fs/xfs/libxfs/xfs_rmap_btree.c |  4 ++++
>  fs/xfs/xfs_mount.h             |  9 +++++----
>  fs/xfs/xfs_reflink.c           |  2 +-
>  6 files changed, 66 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index 2291f4224e24..1945202426c4 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -95,13 +95,13 @@ xfs_ag_resv_critical(
>  
>  	switch (type) {
>  	case XFS_AG_RESV_METADATA:
> -		avail = pag->pagf_freeblks - pag->pag_agfl_resv.ar_reserved;
> +		avail = pag->pagf_freeblks - pag->pag_rmapbt_resv.ar_reserved;
>  		orig = pag->pag_meta_resv.ar_asked;
>  		break;
> -	case XFS_AG_RESV_AGFL:
> +	case XFS_AG_RESV_RMAPBT:
>  		avail = pag->pagf_freeblks + pag->pagf_flcount -
>  			pag->pag_meta_resv.ar_reserved;
> -		orig = pag->pag_agfl_resv.ar_asked;
> +		orig = pag->pag_rmapbt_resv.ar_asked;
>  		break;
>  	default:
>  		ASSERT(0);
> @@ -126,10 +126,10 @@ xfs_ag_resv_needed(
>  {
>  	xfs_extlen_t			len;
>  
> -	len = pag->pag_meta_resv.ar_reserved + pag->pag_agfl_resv.ar_reserved;
> +	len = pag->pag_meta_resv.ar_reserved + pag->pag_rmapbt_resv.ar_reserved;
>  	switch (type) {
>  	case XFS_AG_RESV_METADATA:
> -	case XFS_AG_RESV_AGFL:
> +	case XFS_AG_RESV_RMAPBT:
>  		len -= xfs_perag_resv(pag, type)->ar_reserved;
>  		break;
>  	case XFS_AG_RESV_NONE:
> @@ -160,10 +160,11 @@ __xfs_ag_resv_free(
>  	if (pag->pag_agno == 0)
>  		pag->pag_mount->m_ag_max_usable += resv->ar_asked;
>  	/*
> -	 * AGFL blocks are always considered "free", so whatever
> -	 * was reserved at mount time must be given back at umount.
> +	 * RMAPBT blocks come from the AGFL and AGFL blocks are always
> +	 * considered "free", so whatever was reserved at mount time must be
> +	 * given back at umount.
>  	 */
> -	if (type == XFS_AG_RESV_AGFL)
> +	if (type == XFS_AG_RESV_RMAPBT)
>  		oldresv = resv->ar_orig_reserved;
>  	else
>  		oldresv = resv->ar_reserved;
> @@ -185,7 +186,7 @@ xfs_ag_resv_free(
>  	int				error;
>  	int				err2;
>  
> -	error = __xfs_ag_resv_free(pag, XFS_AG_RESV_AGFL);
> +	error = __xfs_ag_resv_free(pag, XFS_AG_RESV_RMAPBT);
>  	err2 = __xfs_ag_resv_free(pag, XFS_AG_RESV_METADATA);
>  	if (err2 && !error)
>  		error = err2;
> @@ -284,15 +285,15 @@ xfs_ag_resv_init(
>  		}
>  	}
>  
> -	/* Create the AGFL metadata reservation */
> -	if (pag->pag_agfl_resv.ar_asked == 0) {
> +	/* Create the RMAPBT metadata reservation */
> +	if (pag->pag_rmapbt_resv.ar_asked == 0) {
>  		ask = used = 0;
>  
>  		error = xfs_rmapbt_calc_reserves(mp, agno, &ask, &used);
>  		if (error)
>  			goto out;
>  
> -		error = __xfs_ag_resv_init(pag, XFS_AG_RESV_AGFL, ask, used);
> +		error = __xfs_ag_resv_init(pag, XFS_AG_RESV_RMAPBT, ask, used);
>  		if (error)
>  			goto out;
>  	}
> @@ -304,7 +305,7 @@ xfs_ag_resv_init(
>  		return error;
>  
>  	ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
> -	       xfs_perag_resv(pag, XFS_AG_RESV_AGFL)->ar_reserved <=
> +	       xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
>  	       pag->pagf_freeblks + pag->pagf_flcount);
>  #endif
>  out:
> @@ -325,8 +326,10 @@ xfs_ag_resv_alloc_extent(
>  	trace_xfs_ag_resv_alloc_extent(pag, type, args->len);
>  
>  	switch (type) {
> -	case XFS_AG_RESV_METADATA:
>  	case XFS_AG_RESV_AGFL:
> +		return;
> +	case XFS_AG_RESV_RMAPBT:
> +	case XFS_AG_RESV_METADATA:
>  		resv = xfs_perag_resv(pag, type);
>  		break;
>  	default:
> @@ -341,7 +344,7 @@ xfs_ag_resv_alloc_extent(
>  
>  	len = min_t(xfs_extlen_t, args->len, resv->ar_reserved);
>  	resv->ar_reserved -= len;
> -	if (type == XFS_AG_RESV_AGFL)
> +	if (type == XFS_AG_RESV_RMAPBT)
>  		return;
>  	/* Allocations of reserved blocks only need on-disk sb updates... */
>  	xfs_trans_mod_sb(args->tp, XFS_TRANS_SB_RES_FDBLOCKS, -(int64_t)len);
> @@ -365,8 +368,10 @@ xfs_ag_resv_free_extent(
>  	trace_xfs_ag_resv_free_extent(pag, type, len);
>  
>  	switch (type) {
> -	case XFS_AG_RESV_METADATA:
>  	case XFS_AG_RESV_AGFL:
> +		return;
> +	case XFS_AG_RESV_RMAPBT:
> +	case XFS_AG_RESV_METADATA:
>  		resv = xfs_perag_resv(pag, type);
>  		break;
>  	default:
> @@ -379,7 +384,7 @@ xfs_ag_resv_free_extent(
>  
>  	leftover = min_t(xfs_extlen_t, len, resv->ar_asked - resv->ar_reserved);
>  	resv->ar_reserved += leftover;
> -	if (type == XFS_AG_RESV_AGFL)
> +	if (type == XFS_AG_RESV_RMAPBT)
>  		return;
>  	/* Freeing into the reserved pool only requires on-disk update... */
>  	xfs_trans_mod_sb(tp, XFS_TRANS_SB_RES_FDBLOCKS, len);
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
> index 8d6c687deef3..938f2f96c5e8 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.h
> +++ b/fs/xfs/libxfs/xfs_ag_resv.h
> @@ -32,4 +32,35 @@ void xfs_ag_resv_alloc_extent(struct xfs_perag *pag, enum xfs_ag_resv_type type,
>  void xfs_ag_resv_free_extent(struct xfs_perag *pag, enum xfs_ag_resv_type type,
>  		struct xfs_trans *tp, xfs_extlen_t len);
>  
> +/*
> + * RMAPBT reservation accounting wrappers. Since rmapbt blocks are sourced from
> + * the AGFL, they are allocated one at a time and the reservation updates don't
> + * require a transaction.
> + */
> +static inline void
> +xfs_ag_resv_rmapbt_alloc(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno)
> +{
> +	struct xfs_alloc_arg	args = {0};
> +	struct xfs_perag	*pag;
> +
> +	args.len = 1;
> +	pag = xfs_perag_get(mp, agno);
> +	xfs_ag_resv_alloc_extent(pag, XFS_AG_RESV_RMAPBT, &args);
> +	xfs_perag_put(pag);
> +}
> +
> +static inline void
> +xfs_ag_resv_rmapbt_free(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno)
> +{
> +	struct xfs_perag	*pag;
> +
> +	pag = xfs_perag_get(mp, agno);
> +	xfs_ag_resv_free_extent(pag, XFS_AG_RESV_RMAPBT, NULL, 1);
> +	xfs_perag_put(pag);
> +}
> +
>  #endif	/* __XFS_AG_RESV_H__ */
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index c02781a4c091..8c401efb2d74 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1564,7 +1564,6 @@ xfs_alloc_ag_vextent_small(
>  	int		*stat)	/* status: 0-freelist, 1-normal/none */
>  {
>  	struct xfs_owner_info	oinfo;
> -	struct xfs_perag	*pag;
>  	int		error;
>  	xfs_agblock_t	fbno;
>  	xfs_extlen_t	flen;
> @@ -1616,18 +1615,13 @@ xfs_alloc_ag_vextent_small(
>  			/*
>  			 * If we're feeding an AGFL block to something that
>  			 * doesn't live in the free space, we need to clear
> -			 * out the OWN_AG rmap and add the block back to
> -			 * the AGFL per-AG reservation.
> +			 * out the OWN_AG rmap.
>  			 */
>  			xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
>  			error = xfs_rmap_free(args->tp, args->agbp, args->agno,
>  					fbno, 1, &oinfo);
>  			if (error)
>  				goto error0;
> -			pag = xfs_perag_get(args->mp, args->agno);
> -			xfs_ag_resv_free_extent(pag, XFS_AG_RESV_AGFL,
> -					args->tp, 1);
> -			xfs_perag_put(pag);
>  
>  			*stat = 0;
>  			return 0;
> @@ -1911,14 +1905,12 @@ xfs_free_ag_extent(
>  	XFS_STATS_INC(mp, xs_freex);
>  	XFS_STATS_ADD(mp, xs_freeb, len);
>  
> -	trace_xfs_free_extent(mp, agno, bno, len, type == XFS_AG_RESV_AGFL,
> -			haveleft, haveright);
> +	trace_xfs_free_extent(mp, agno, bno, len, type, haveleft, haveright);
>  
>  	return 0;
>  
>   error0:
> -	trace_xfs_free_extent(mp, agno, bno, len, type == XFS_AG_RESV_AGFL,
> -			-1, -1);
> +	trace_xfs_free_extent(mp, agno, bno, len, type, -1, -1);
>  	if (bno_cur)
>  		xfs_btree_del_cursor(bno_cur, XFS_BTREE_ERROR);
>  	if (cnt_cur)
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index e829c3e489ea..8560091554e0 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -130,6 +130,8 @@ xfs_rmapbt_alloc_block(
>  	be32_add_cpu(&agf->agf_rmap_blocks, 1);
>  	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
>  
> +	xfs_ag_resv_rmapbt_alloc(cur->bc_mp, cur->bc_private.a.agno);
> +
>  	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
>  	*stat = 1;
>  	return 0;
> @@ -158,6 +160,8 @@ xfs_rmapbt_free_block(
>  			      XFS_EXTENT_BUSY_SKIP_DISCARD);
>  	xfs_trans_agbtree_delta(cur->bc_tp, -1);
>  
> +	xfs_ag_resv_rmapbt_free(cur->bc_mp, cur->bc_private.a.agno);
> +
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index e0792d036be2..f659045507fb 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -327,6 +327,7 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
>  enum xfs_ag_resv_type {
>  	XFS_AG_RESV_NONE = 0,
>  	XFS_AG_RESV_METADATA,
> +	XFS_AG_RESV_RMAPBT,
>  	XFS_AG_RESV_AGFL,
>  };
>  
> @@ -391,8 +392,8 @@ typedef struct xfs_perag {
>  
>  	/* Blocks reserved for all kinds of metadata. */
>  	struct xfs_ag_resv	pag_meta_resv;
> -	/* Blocks reserved for just AGFL-based metadata. */
> -	struct xfs_ag_resv	pag_agfl_resv;
> +	/* Blocks reserved for the reverse mapping btree. */
> +	struct xfs_ag_resv	pag_rmapbt_resv;
>  
>  	/* reference count */
>  	uint8_t			pagf_refcount_level;
> @@ -406,8 +407,8 @@ xfs_perag_resv(
>  	switch (type) {
>  	case XFS_AG_RESV_METADATA:
>  		return &pag->pag_meta_resv;
> -	case XFS_AG_RESV_AGFL:
> -		return &pag->pag_agfl_resv;
> +	case XFS_AG_RESV_RMAPBT:
> +		return &pag->pag_rmapbt_resv;
>  	default:
>  		return NULL;
>  	}
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 270246943a06..832df6f49ba1 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1061,7 +1061,7 @@ xfs_reflink_ag_has_free_space(
>  		return 0;
>  
>  	pag = xfs_perag_get(mp, agno);
> -	if (xfs_ag_resv_critical(pag, XFS_AG_RESV_AGFL) ||
> +	if (xfs_ag_resv_critical(pag, XFS_AG_RESV_RMAPBT) ||
>  	    xfs_ag_resv_critical(pag, XFS_AG_RESV_METADATA))
>  		error = -ENOSPC;
>  	xfs_perag_put(pag);
> -- 
> 2.13.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
