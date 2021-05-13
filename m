Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32046C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 03:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0402E61417
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 03:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhEMD4T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 23:56:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230104AbhEMD4S (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 May 2021 23:56:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9619A61413;
        Thu, 13 May 2021 03:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620878108;
        bh=snNAYSpuW4Kb6SE7MK31avibQYp2tiVX9xPPWEno/VE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sPm9fQNGpIDksCwKcH/H3hxbtqoszyDXgZGqKeiU/rJ9/g8CFsl8Qg1f8oYyi37Ps
         npaaAshCveLYvHiGLJ+RVnjYaOmWIeG/gJvr8EEH0/KtWkwtdrPeabJM20lKWKjcW5
         O75bO6nlmb5/qILHjCclxb+yKaGHfDPYurVHtuRncOE+zB73HY555265bad+urMcj0
         RJI38ZKCj9Gn9tGrM+cqL9OZRacvtyEHLZhpuXp45sbWoQB9R/3FBGpJmcM2ZOSeVi
         Uz8HKsyYk3M9nQHi2iqp+qyXA5iw+oC91L/byvw8mL56q/5o0JmkE1xVn98eJEr1AU
         ofqjv5K1zqYBQ==
Date:   Wed, 12 May 2021 20:55:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/22] xfs: convert allocbt cursors to use perags
Message-ID: <20210513035507.GS8582@magnolia>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-15-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-15-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 05:20:46PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Fairly simple mechanical change...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c       | 25 ++++++++++---------------
>  fs/xfs/libxfs/xfs_alloc_btree.c | 26 ++++++++++----------------
>  fs/xfs/libxfs/xfs_alloc_btree.h |  8 ++++----
>  fs/xfs/scrub/agheader_repair.c  |  8 ++++----
>  fs/xfs/scrub/common.c           |  4 ++--
>  fs/xfs/xfs_discard.c            |  2 +-
>  fs/xfs/xfs_fsmap.c              |  2 +-
>  7 files changed, 32 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 10747cc4d8f6..c99a80286efa 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -776,8 +776,7 @@ xfs_alloc_cur_setup(
>  	 */
>  	if (!acur->cnt)
>  		acur->cnt = xfs_allocbt_init_cursor(args->mp, args->tp,
> -						args->agbp, args->agno,
> -						args->pag, XFS_BTNUM_CNT);
> +					args->agbp, args->pag, XFS_BTNUM_CNT);
>  	error = xfs_alloc_lookup_ge(acur->cnt, 0, args->maxlen, &i);
>  	if (error)
>  		return error;
> @@ -787,12 +786,10 @@ xfs_alloc_cur_setup(
>  	 */
>  	if (!acur->bnolt)
>  		acur->bnolt = xfs_allocbt_init_cursor(args->mp, args->tp,
> -						args->agbp, args->agno,
> -						args->pag, XFS_BTNUM_BNO);
> +					args->agbp, args->pag, XFS_BTNUM_BNO);
>  	if (!acur->bnogt)
>  		acur->bnogt = xfs_allocbt_init_cursor(args->mp, args->tp,
> -						args->agbp, args->agno,
> -						args->pag, XFS_BTNUM_BNO);
> +					args->agbp, args->pag, XFS_BTNUM_BNO);
>  	return i == 1 ? 0 : -ENOSPC;
>  }
>  
> @@ -1220,7 +1217,7 @@ xfs_alloc_ag_vextent_exact(
>  	 * Allocate/initialize a cursor for the by-number freespace btree.
>  	 */
>  	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
> -					  args->agno, args->pag, XFS_BTNUM_BNO);
> +					  args->pag, XFS_BTNUM_BNO);
>  
>  	/*
>  	 * Lookup bno and minlen in the btree (minlen is irrelevant, really).
> @@ -1280,7 +1277,7 @@ xfs_alloc_ag_vextent_exact(
>  	 * Allocate/initialize a cursor for the by-size btree.
>  	 */
>  	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
> -					args->agno, args->pag, XFS_BTNUM_CNT);
> +					args->pag, XFS_BTNUM_CNT);
>  	ASSERT(args->agbno + args->len <= be32_to_cpu(agf->agf_length));
>  	error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen, args->agbno,
>  				      args->len, XFSA_FIXUP_BNO_OK);
> @@ -1677,7 +1674,7 @@ xfs_alloc_ag_vextent_size(
>  	 * Allocate and initialize a cursor for the by-size btree.
>  	 */
>  	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
> -					args->agno, args->pag, XFS_BTNUM_CNT);
> +					args->pag, XFS_BTNUM_CNT);
>  	bno_cur = NULL;
>  	busy = false;
>  
> @@ -1840,7 +1837,7 @@ xfs_alloc_ag_vextent_size(
>  	 * Allocate and initialize a cursor for the by-block tree.
>  	 */
>  	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
> -					args->agno, args->pag, XFS_BTNUM_BNO);
> +					args->pag, XFS_BTNUM_BNO);
>  	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen,
>  			rbno, rlen, XFSA_FIXUP_CNT_OK)))
>  		goto error0;
> @@ -1913,8 +1910,7 @@ xfs_free_ag_extent(
>  	/*
>  	 * Allocate and initialize a cursor for the by-block btree.
>  	 */
> -	bno_cur = xfs_allocbt_init_cursor(mp, tp, agbp, agno,
> -					NULL, XFS_BTNUM_BNO);
> +	bno_cur = xfs_allocbt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_BNO);
>  	/*
>  	 * Look for a neighboring block on the left (lower block numbers)
>  	 * that is contiguous with this space.
> @@ -1984,8 +1980,7 @@ xfs_free_ag_extent(
>  	/*
>  	 * Now allocate and initialize a cursor for the by-size tree.
>  	 */
> -	cnt_cur = xfs_allocbt_init_cursor(mp, tp, agbp, agno,
> -					NULL, XFS_BTNUM_CNT);
> +	cnt_cur = xfs_allocbt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_CNT);
>  	/*
>  	 * Have both left and right contiguous neighbors.
>  	 * Merge all three into a single free block.
> @@ -2496,7 +2491,7 @@ xfs_exact_minlen_extent_available(
>  	int			error = 0;
>  
>  	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, agbp,
> -					args->agno, args->pag, XFS_BTNUM_CNT);
> +					args->pag, XFS_BTNUM_CNT);
>  	error = xfs_alloc_lookup_ge(cnt_cur, 0, args->minlen, stat);
>  	if (error)
>  		goto out;
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index a52ab25bbf0b..0c2e4cff4ee3 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -26,8 +26,7 @@ xfs_allocbt_dup_cursor(
>  	struct xfs_btree_cur	*cur)
>  {
>  	return xfs_allocbt_init_cursor(cur->bc_mp, cur->bc_tp,
> -			cur->bc_ag.agbp, cur->bc_ag.agno,
> -			cur->bc_ag.pag, cur->bc_btnum);
> +			cur->bc_ag.agbp, cur->bc_ag.pag, cur->bc_btnum);
>  }
>  
>  STATIC void
> @@ -39,13 +38,12 @@ xfs_allocbt_set_root(
>  	struct xfs_buf		*agbp = cur->bc_ag.agbp;
>  	struct xfs_agf		*agf = agbp->b_addr;
>  	int			btnum = cur->bc_btnum;
> -	struct xfs_perag	*pag = agbp->b_pag;
>  
>  	ASSERT(ptr->s != 0);
>  
>  	agf->agf_roots[btnum] = ptr->s;
>  	be32_add_cpu(&agf->agf_levels[btnum], inc);
> -	pag->pagf_levels[btnum] += inc;
> +	cur->bc_ag.pag->pagf_levels[btnum] += inc;
>  
>  	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
>  }
> @@ -224,7 +222,7 @@ xfs_allocbt_init_ptr_from_cur(
>  {
>  	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
>  
> -	ASSERT(cur->bc_ag.agno == be32_to_cpu(agf->agf_seqno));
> +	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agf->agf_seqno));
>  
>  	ptr->s = agf->agf_roots[cur->bc_btnum];
>  }
> @@ -472,7 +470,6 @@ STATIC struct xfs_btree_cur *
>  xfs_allocbt_init_common(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
> -	xfs_agnumber_t		agno,
>  	struct xfs_perag	*pag,
>  	xfs_btnum_t		btnum)
>  {
> @@ -486,6 +483,7 @@ xfs_allocbt_init_common(
>  	cur->bc_mp = mp;
>  	cur->bc_btnum = btnum;
>  	cur->bc_blocklog = mp->m_sb.sb_blocklog;
> +	cur->bc_ag.abt.active = false;
>  
>  	if (btnum == XFS_BTNUM_CNT) {
>  		cur->bc_ops = &xfs_cntbt_ops;
> @@ -496,13 +494,10 @@ xfs_allocbt_init_common(
>  		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
>  	}
>  
> -	cur->bc_ag.agno = agno;
> -	cur->bc_ag.abt.active = false;
> -	if (pag) {
> -		/* take a reference for the cursor */
> -		atomic_inc(&pag->pag_ref);
> -	}
> +	/* take a reference for the cursor */
> +	atomic_inc(&pag->pag_ref);
>  	cur->bc_ag.pag = pag;
> +	cur->bc_ag.agno = pag->pag_agno;
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb))
>  		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
> @@ -518,14 +513,13 @@ xfs_allocbt_init_cursor(
>  	struct xfs_mount	*mp,		/* file system mount point */
>  	struct xfs_trans	*tp,		/* transaction pointer */
>  	struct xfs_buf		*agbp,		/* buffer for agf structure */
> -	xfs_agnumber_t		agno,		/* allocation group number */
>  	struct xfs_perag	*pag,
>  	xfs_btnum_t		btnum)		/* btree identifier */
>  {
>  	struct xfs_agf		*agf = agbp->b_addr;
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = xfs_allocbt_init_common(mp, tp, agno, pag, btnum);
> +	cur = xfs_allocbt_init_common(mp, tp, pag, btnum);
>  	if (btnum == XFS_BTNUM_CNT)
>  		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
>  	else
> @@ -541,12 +535,12 @@ struct xfs_btree_cur *
>  xfs_allocbt_stage_cursor(
>  	struct xfs_mount	*mp,
>  	struct xbtree_afakeroot	*afake,
> -	xfs_agnumber_t		agno,
> +	struct xfs_perag	*pag,
>  	xfs_btnum_t		btnum)
>  {
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = xfs_allocbt_init_common(mp, NULL, agno, NULL, btnum);
> +	cur = xfs_allocbt_init_common(mp, NULL, pag, btnum);
>  	xfs_btree_stage_afakeroot(cur, afake);
>  	return cur;
>  }
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
> index a10cedba18d8..9eb4c667a6b8 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.h
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.h
> @@ -47,11 +47,11 @@ struct xbtree_afakeroot;
>  		 (maxrecs) * sizeof(xfs_alloc_key_t) + \
>  		 ((index) - 1) * sizeof(xfs_alloc_ptr_t)))
>  
> -extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
> -		struct xfs_trans *, struct xfs_buf *,
> -		xfs_agnumber_t, struct xfs_perag *pag, xfs_btnum_t);
> +extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *mp,
> +		struct xfs_trans *tp, struct xfs_buf *bp,
> +		struct xfs_perag *pag, xfs_btnum_t btnum);
>  struct xfs_btree_cur *xfs_allocbt_stage_cursor(struct xfs_mount *mp,
> -		struct xbtree_afakeroot *afake, xfs_agnumber_t agno,
> +		struct xbtree_afakeroot *afake, struct xfs_perag *pag,
>  		xfs_btnum_t btnum);
>  extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
>  extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 251410c19198..ee2d85e3fd4a 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -246,7 +246,7 @@ xrep_agf_calc_from_btrees(
>  	int			error;
>  
>  	/* Update the AGF counters from the bnobt. */
> -	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> +	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp,
>  			sc->sa.pag, XFS_BTNUM_BNO);
>  	error = xfs_alloc_query_all(cur, xrep_agf_walk_allocbt, &raa);
>  	if (error)
> @@ -260,7 +260,7 @@ xrep_agf_calc_from_btrees(
>  	agf->agf_longest = cpu_to_be32(raa.longest);
>  
>  	/* Update the AGF counters from the cntbt. */
> -	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> +	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp,
>  			sc->sa.pag, XFS_BTNUM_CNT);
>  	error = xfs_btree_count_blocks(cur, &blocks);
>  	if (error)
> @@ -497,7 +497,7 @@ xrep_agfl_collect_blocks(
>  	xfs_btree_del_cursor(cur, error);
>  
>  	/* Find all blocks currently being used by the bnobt. */
> -	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> +	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp,
>  			sc->sa.pag, XFS_BTNUM_BNO);
>  	error = xbitmap_set_btblocks(&ra.agmetablocks, cur);
>  	if (error)
> @@ -505,7 +505,7 @@ xrep_agfl_collect_blocks(
>  	xfs_btree_del_cursor(cur, error);
>  
>  	/* Find all blocks currently being used by the cntbt. */
> -	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> +	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp,
>  			sc->sa.pag, XFS_BTNUM_CNT);
>  	error = xbitmap_set_btblocks(&ra.agmetablocks, cur);
>  	if (error)
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index cc7688ce79b2..3035f8cee6f6 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -465,14 +465,14 @@ xchk_ag_btcur_init(
>  	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_BNO)) {
>  		/* Set up a bnobt cursor for cross-referencing. */
>  		sa->bno_cur = xfs_allocbt_init_cursor(mp, sc->tp, sa->agf_bp,
> -				agno, sa->pag, XFS_BTNUM_BNO);
> +				sa->pag, XFS_BTNUM_BNO);
>  	}
>  
>  	if (sa->agf_bp &&
>  	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_CNT)) {
>  		/* Set up a cntbt cursor for cross-referencing. */
>  		sa->cnt_cur = xfs_allocbt_init_cursor(mp, sc->tp, sa->agf_bp,
> -				agno, sa->pag, XFS_BTNUM_CNT);
> +				sa->pag, XFS_BTNUM_CNT);
>  	}
>  
>  	/* Set up a inobt cursor for cross-referencing. */
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 311ebaad4f5a..736df5660f1f 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -50,7 +50,7 @@ xfs_trim_extents(
>  		goto out_put_perag;
>  	agf = agbp->b_addr;
>  
> -	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno, pag, XFS_BTNUM_CNT);
> +	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, pag, XFS_BTNUM_CNT);
>  
>  	/*
>  	 * Look up the longest btree in the AGF and start with it.
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 623cabaeafee..7501dd941a63 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -740,7 +740,7 @@ xfs_getfsmap_datadev_bnobt_query(
>  
>  	/* Allocate cursor for this AG and query_range it. */
>  	*curpp = xfs_allocbt_init_cursor(tp->t_mountp, tp, info->agf_bp,
> -			info->pag->pag_agno, info->pag, XFS_BTNUM_BNO);
> +			info->pag, XFS_BTNUM_BNO);
>  	key->ar_startblock = info->low.rm_startblock;
>  	key[1].ar_startblock = info->high.rm_startblock;
>  	return xfs_alloc_query_range(*curpp, key, &key[1],
> -- 
> 2.31.1
> 
