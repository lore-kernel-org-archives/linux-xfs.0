Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9237FC43460
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 12:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63D276191D
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 12:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhEKMbl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 08:31:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26665 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231432AbhEKMbl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 May 2021 08:31:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620736234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rcab9CaNmSZAdpOWX4eMzHLvlylcwIJOXhwWe9yFUJE=;
        b=JoOVHuWREIDkLE751Bq3wmyYTVH3U+FxMjCGUCgjafN8znMR30Xx73iA9LqwO255OP7fSW
        gBn4eA1wlNA2IR9ngsu7hXFlU3qEoykcPBm82zhDc99dqZNZNz8F1C6CiSkS6moDL1U1J3
        pbJ9nf792sR9yVt74YsvDt6UoRgGM1g=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-7krhaYDFOBeFL9cB9YlSTw-1; Tue, 11 May 2021 08:30:32 -0400
X-MC-Unique: 7krhaYDFOBeFL9cB9YlSTw-1
Received: by mail-qv1-f71.google.com with SMTP id h17-20020a0cb4d10000b02901c51890529dso15327228qvf.18
        for <linux-xfs@vger.kernel.org>; Tue, 11 May 2021 05:30:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rcab9CaNmSZAdpOWX4eMzHLvlylcwIJOXhwWe9yFUJE=;
        b=HxOLMMa9M0Ecr2SHwyL1++UhnxwCFcyjjFpa0UvcxsvRBlLrjeyi9SPlinBlGMfWKX
         w90U6r8aFUaxYggks8p0zhdVwgIqx8C58zgavc8jAVJnVs4C356Lr/2f/LLuYBV+Hims
         WkVazJ4sZd0lcMZhBm4YwBP0I5ou/0qubLIr9gGkPzUYoQRnrLT9SJbrIVkl1D76fyVi
         fwgrhJovPfwj6jpBcX7wsYAVU1il10bHufB/TYgGsQRZi9d7bpkWOB+PXk0kWnmrsc52
         2g/6ZJf8gDrTBk+JMty7C96GmZ98tmDE8JuWPPuvKt4g1HrXbfyoUsGf2bdwLb/iA8R9
         UNdA==
X-Gm-Message-State: AOAM5320yqlNZFvdlNndnYSbHKYwuxk4HgDeTlbhpzE7tsfyKiSE7GMX
        CWtKJaeOxOOAXGjUvBzXSALmjX9y2/vu/ZcKngxzdBJ1W24ssXsLORTcti3PM6MTC5IH/9UOfDa
        Hd+1vIuc3FkV84EokX5kU
X-Received: by 2002:a37:a857:: with SMTP id r84mr23206173qke.258.1620736231962;
        Tue, 11 May 2021 05:30:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxHzLCE3FevKNUYk+8fwt2ZEb6u2nWQrXSEGeRb74n03fyBt1+/zzf+I2lFbZx5D8RqhnRQHA==
X-Received: by 2002:a37:a857:: with SMTP id r84mr23206137qke.258.1620736231596;
        Tue, 11 May 2021 05:30:31 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id h3sm884448qkk.82.2021.05.11.05.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 05:30:31 -0700 (PDT)
Date:   Tue, 11 May 2021 08:30:29 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/22] xfs: convert rmap btree cursor to using a perag
Message-ID: <YJp45QGeCmmtAkgi@bfoster>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-13-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-13-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 05:20:44PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ag.c         |  2 +-
>  fs/xfs/libxfs/xfs_alloc.c      |  7 ++++---
>  fs/xfs/libxfs/xfs_rmap.c       | 10 ++++-----
>  fs/xfs/libxfs/xfs_rmap.h       |  6 ++++--
>  fs/xfs/libxfs/xfs_rmap_btree.c | 37 +++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_rmap_btree.h |  4 ++--
>  fs/xfs/scrub/agheader_repair.c |  6 ++----
>  fs/xfs/scrub/bmap.c            |  2 +-
>  fs/xfs/scrub/common.c          |  2 +-
>  fs/xfs/scrub/repair.c          | 10 ++++-----
>  fs/xfs/xfs_fsmap.c             |  2 +-
>  11 files changed, 42 insertions(+), 46 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 14d8b866dc6d..44f2787f3556 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -914,7 +914,7 @@ xfs_ag_extend_space(
>  	 * XFS_RMAP_OINFO_SKIP_UPDATE is used here to tell the rmap btree that
>  	 * this doesn't actually exist in the rmap btree.
>  	 */
> -	error = xfs_rmap_free(tp, bp, id->agno,
> +	error = xfs_rmap_free(tp, bp, bp->b_pag,
>  				be32_to_cpu(agf->agf_length) - len,
>  				len, &XFS_RMAP_OINFO_SKIP_UPDATE);
>  	if (error)
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 7ec4af6bf494..10747cc4d8f6 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1092,7 +1092,7 @@ xfs_alloc_ag_vextent_small(
>  	 * If we're feeding an AGFL block to something that doesn't live in the
>  	 * free space, we need to clear out the OWN_AG rmap.
>  	 */
> -	error = xfs_rmap_free(args->tp, args->agbp, args->agno, fbno, 1,
> +	error = xfs_rmap_free(args->tp, args->agbp, args->pag, fbno, 1,
>  			      &XFS_RMAP_OINFO_AG);
>  	if (error)
>  		goto error;
> @@ -1169,7 +1169,7 @@ xfs_alloc_ag_vextent(
>  
>  	/* if not file data, insert new block into the reverse map btree */
>  	if (!xfs_rmap_should_skip_owner_update(&args->oinfo)) {
> -		error = xfs_rmap_alloc(args->tp, args->agbp, args->agno,
> +		error = xfs_rmap_alloc(args->tp, args->agbp, args->pag,
>  				       args->agbno, args->len, &args->oinfo);
>  		if (error)
>  			return error;
> @@ -1899,12 +1899,13 @@ xfs_free_ag_extent(
>  	int				haveright; /* have a right neighbor */
>  	int				i;
>  	int				error;
> +	struct xfs_perag		*pag = agbp->b_pag;
>  
>  	bno_cur = cnt_cur = NULL;
>  	mp = tp->t_mountp;
>  
>  	if (!xfs_rmap_should_skip_owner_update(oinfo)) {
> -		error = xfs_rmap_free(tp, agbp, agno, bno, len, oinfo);
> +		error = xfs_rmap_free(tp, agbp, pag, bno, len, oinfo);
>  		if (error)
>  			goto error0;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 0d7a6997120c..b23f949ee15c 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -696,7 +696,7 @@ int
>  xfs_rmap_free(
>  	struct xfs_trans		*tp,
>  	struct xfs_buf			*agbp,
> -	xfs_agnumber_t			agno,
> +	struct xfs_perag		*pag,
>  	xfs_agblock_t			bno,
>  	xfs_extlen_t			len,
>  	const struct xfs_owner_info	*oinfo)
> @@ -708,7 +708,7 @@ xfs_rmap_free(
>  	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
>  		return 0;
>  
> -	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno, NULL);
> +	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
>  
>  	error = xfs_rmap_unmap(cur, bno, len, false, oinfo);
>  
> @@ -950,7 +950,7 @@ int
>  xfs_rmap_alloc(
>  	struct xfs_trans		*tp,
>  	struct xfs_buf			*agbp,
> -	xfs_agnumber_t			agno,
> +	struct xfs_perag		*pag,
>  	xfs_agblock_t			bno,
>  	xfs_extlen_t			len,
>  	const struct xfs_owner_info	*oinfo)
> @@ -962,7 +962,7 @@ xfs_rmap_alloc(
>  	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
>  		return 0;
>  
> -	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno, NULL);
> +	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
>  	error = xfs_rmap_map(cur, bno, len, false, oinfo);
>  
>  	xfs_btree_del_cursor(cur, error);
> @@ -2408,7 +2408,7 @@ xfs_rmap_finish_one(
>  			goto out_drop;
>  		}
>  
> -		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag->pag_agno, pag);
> +		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
>  	}
>  	*pcur = rcur;
>  
> diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
> index abe633403fd1..f2423cf7f1e2 100644
> --- a/fs/xfs/libxfs/xfs_rmap.h
> +++ b/fs/xfs/libxfs/xfs_rmap.h
> @@ -6,6 +6,8 @@
>  #ifndef __XFS_RMAP_H__
>  #define __XFS_RMAP_H__
>  
> +struct xfs_perag;
> +
>  static inline void
>  xfs_rmap_ino_bmbt_owner(
>  	struct xfs_owner_info	*oi,
> @@ -113,10 +115,10 @@ xfs_owner_info_pack(
>  }
>  
>  int xfs_rmap_alloc(struct xfs_trans *tp, struct xfs_buf *agbp,
> -		   xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
> +		   struct xfs_perag *pag, xfs_agblock_t bno, xfs_extlen_t len,
>  		   const struct xfs_owner_info *oinfo);
>  int xfs_rmap_free(struct xfs_trans *tp, struct xfs_buf *agbp,
> -		  xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
> +		  struct xfs_perag *pag, xfs_agblock_t bno, xfs_extlen_t len,
>  		  const struct xfs_owner_info *oinfo);
>  
>  int xfs_rmap_lookup_le(struct xfs_btree_cur *cur, xfs_agblock_t bno,
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index 7bef8feeded1..cafe181bc92d 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -52,7 +52,7 @@ xfs_rmapbt_dup_cursor(
>  	struct xfs_btree_cur	*cur)
>  {
>  	return xfs_rmapbt_init_cursor(cur->bc_mp, cur->bc_tp,
> -			cur->bc_ag.agbp, cur->bc_ag.agno, cur->bc_ag.pag);
> +				cur->bc_ag.agbp, cur->bc_ag.pag);
>  }
>  
>  STATIC void
> @@ -64,13 +64,12 @@ xfs_rmapbt_set_root(
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
> @@ -84,6 +83,7 @@ xfs_rmapbt_alloc_block(
>  {
>  	struct xfs_buf		*agbp = cur->bc_ag.agbp;
>  	struct xfs_agf		*agf = agbp->b_addr;
> +	struct xfs_perag	*pag = cur->bc_ag.pag;
>  	int			error;
>  	xfs_agblock_t		bno;
>  
> @@ -93,20 +93,19 @@ xfs_rmapbt_alloc_block(
>  	if (error)
>  		return error;
>  
> -	trace_xfs_rmapbt_alloc_block(cur->bc_mp, cur->bc_ag.agno,
> -			bno, 1);
> +	trace_xfs_rmapbt_alloc_block(cur->bc_mp, pag->pag_agno, bno, 1);
>  	if (bno == NULLAGBLOCK) {
>  		*stat = 0;
>  		return 0;
>  	}
>  
> -	xfs_extent_busy_reuse(cur->bc_mp, agbp->b_pag, bno, 1, false);
> +	xfs_extent_busy_reuse(cur->bc_mp, pag, bno, 1, false);
>  
>  	new->s = cpu_to_be32(bno);
>  	be32_add_cpu(&agf->agf_rmap_blocks, 1);
>  	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
>  
> -	xfs_ag_resv_rmapbt_alloc(cur->bc_mp, cur->bc_ag.agno);
> +	xfs_ag_resv_rmapbt_alloc(cur->bc_mp, pag->pag_agno);
>  
>  	*stat = 1;
>  	return 0;
> @@ -119,12 +118,12 @@ xfs_rmapbt_free_block(
>  {
>  	struct xfs_buf		*agbp = cur->bc_ag.agbp;
>  	struct xfs_agf		*agf = agbp->b_addr;
> -	struct xfs_perag	*pag;
> +	struct xfs_perag	*pag = cur->bc_ag.pag;
>  	xfs_agblock_t		bno;
>  	int			error;
>  
>  	bno = xfs_daddr_to_agbno(cur->bc_mp, XFS_BUF_ADDR(bp));
> -	trace_xfs_rmapbt_free_block(cur->bc_mp, cur->bc_ag.agno,
> +	trace_xfs_rmapbt_free_block(cur->bc_mp, pag->pag_agno,
>  			bno, 1);
>  	be32_add_cpu(&agf->agf_rmap_blocks, -1);
>  	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
> @@ -132,7 +131,6 @@ xfs_rmapbt_free_block(
>  	if (error)
>  		return error;
>  
> -	pag = cur->bc_ag.agbp->b_pag;
>  	xfs_extent_busy_insert(cur->bc_tp, pag, bno, 1,
>  			      XFS_EXTENT_BUSY_SKIP_DISCARD);
>  
> @@ -214,7 +212,7 @@ xfs_rmapbt_init_ptr_from_cur(
>  {
>  	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
>  
> -	ASSERT(cur->bc_ag.agno == be32_to_cpu(agf->agf_seqno));
> +	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agf->agf_seqno));
>  
>  	ptr->s = agf->agf_roots[cur->bc_btnum];
>  }
> @@ -449,7 +447,6 @@ static struct xfs_btree_cur *
>  xfs_rmapbt_init_common(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
> -	xfs_agnumber_t		agno,
>  	struct xfs_perag	*pag)
>  {
>  	struct xfs_btree_cur	*cur;
> @@ -462,13 +459,12 @@ xfs_rmapbt_init_common(
>  	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
>  	cur->bc_blocklog = mp->m_sb.sb_blocklog;
>  	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
> -	cur->bc_ag.agno = agno;
>  	cur->bc_ops = &xfs_rmapbt_ops;
> -	if (pag) {
> -		/* take a reference for the cursor */
> -		atomic_inc(&pag->pag_ref);
> -	}
> +
> +	/* take a reference for the cursor */
> +	atomic_inc(&pag->pag_ref);
>  	cur->bc_ag.pag = pag;
> +	cur->bc_ag.agno = pag->pag_agno;
>  
>  	return cur;
>  }
> @@ -479,13 +475,12 @@ xfs_rmapbt_init_cursor(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*agbp,
> -	xfs_agnumber_t		agno,
>  	struct xfs_perag	*pag)
>  {
>  	struct xfs_agf		*agf = agbp->b_addr;
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = xfs_rmapbt_init_common(mp, tp, agno, pag);
> +	cur = xfs_rmapbt_init_common(mp, tp, pag);
>  	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
>  	cur->bc_ag.agbp = agbp;
>  	return cur;
> @@ -496,11 +491,11 @@ struct xfs_btree_cur *
>  xfs_rmapbt_stage_cursor(
>  	struct xfs_mount	*mp,
>  	struct xbtree_afakeroot	*afake,
> -	xfs_agnumber_t		agno)
> +	struct xfs_perag	*pag)
>  {
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = xfs_rmapbt_init_common(mp, NULL, agno, NULL);
> +	cur = xfs_rmapbt_init_common(mp, NULL, pag);
>  	xfs_btree_stage_afakeroot(cur, afake);
>  	return cur;
>  }
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
> index c94f418cc06b..88d8d18788a2 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.h
> @@ -43,9 +43,9 @@ struct xbtree_afakeroot;
>  
>  struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
>  				struct xfs_trans *tp, struct xfs_buf *bp,
> -				xfs_agnumber_t agno, struct xfs_perag *pag);
> +				struct xfs_perag *pag);
>  struct xfs_btree_cur *xfs_rmapbt_stage_cursor(struct xfs_mount *mp,
> -		struct xbtree_afakeroot *afake, xfs_agnumber_t agno);
> +		struct xbtree_afakeroot *afake, struct xfs_perag *pag);
>  void xfs_rmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
>  		struct xfs_trans *tp, struct xfs_buf *agbp);
>  int xfs_rmapbt_maxrecs(int blocklen, int leaf);
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 5dd91bf04c18..981c689e3d95 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -269,8 +269,7 @@ xrep_agf_calc_from_btrees(
>  	btreeblks += blocks - 1;
>  
>  	/* Update the AGF counters from the rmapbt. */
> -	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> -			sc->sa.pag);
> +	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.pag);
>  	error = xfs_btree_count_blocks(cur, &blocks);
>  	if (error)
>  		goto err;
> @@ -491,8 +490,7 @@ xrep_agfl_collect_blocks(
>  	xbitmap_init(&ra.agmetablocks);
>  
>  	/* Find all space used by the free space btrees & rmapbt. */
> -	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> -			sc->sa.pag);
> +	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.pag);
>  	error = xfs_rmap_query_all(cur, xrep_agfl_walk_rmap, &ra);
>  	if (error)
>  		goto err;
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index a792d9ffd61e..b20c3f03b3c5 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -556,7 +556,7 @@ xchk_bmap_check_ag_rmaps(
>  	if (error)
>  		return error;
>  
> -	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf, agno, NULL);
> +	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf, sc->sa.pag);
>  
>  	sbcri.sc = sc;
>  	sbcri.whichfork = whichfork;
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 50768559fb60..48381c1adeed 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -493,7 +493,7 @@ xchk_ag_btcur_init(
>  	if (sa->agf_bp && xfs_sb_version_hasrmapbt(&mp->m_sb) &&
>  	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_RMAP)) {
>  		sa->rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp, sa->agf_bp,
> -				agno, sa->pag);
> +				sa->pag);
>  	}
>  
>  	/* Set up a refcountbt cursor for cross-referencing. */
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 862dc56fd8cd..5cf1c3707b6a 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -509,7 +509,7 @@ xrep_put_freelist(
>  	 * create an rmap for the block prior to merging it or else other
>  	 * parts will break.
>  	 */
> -	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.agno, agbno, 1,
> +	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.pag, agbno, 1,
>  			&XFS_RMAP_OINFO_AG);
>  	if (error)
>  		return error;
> @@ -555,7 +555,7 @@ xrep_reap_block(
>  	} else {
>  		agf_bp = sc->sa.agf_bp;
>  	}
> -	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf_bp, agno, sc->sa.pag);
> +	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf_bp, sc->sa.pag);
>  
>  	/* Can we find any other rmappings? */
>  	error = xfs_rmap_has_other_keys(cur, agbno, 1, oinfo, &has_other_rmap);
> @@ -577,7 +577,8 @@ xrep_reap_block(
>  	 * to run xfs_repair.
>  	 */
>  	if (has_other_rmap)
> -		error = xfs_rmap_free(sc->tp, agf_bp, agno, agbno, 1, oinfo);
> +		error = xfs_rmap_free(sc->tp, agf_bp, sc->sa.pag, agbno,
> +					1, oinfo);
>  	else if (resv == XFS_AG_RESV_AGFL)
>  		error = xrep_put_freelist(sc, agbno);
>  	else
> @@ -892,8 +893,7 @@ xrep_find_ag_btree_roots(
>  		fab->height = 0;
>  	}
>  
> -	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> -			sc->sa.pag);
> +	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.pag);
>  	error = xfs_rmap_query_all(cur, xrep_findroot_rmap, &ri);
>  	xfs_btree_del_cursor(cur, error);
>  
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index b654a2bf9a9f..7bfe9ea35de0 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -708,7 +708,7 @@ xfs_getfsmap_datadev_rmapbt_query(
>  
>  	/* Allocate cursor for this AG and query_range it. */
>  	*curpp = xfs_rmapbt_init_cursor(tp->t_mountp, tp, info->agf_bp,
> -			info->pag->pag_agno, info->pag);
> +			info->pag);
>  	return xfs_rmap_query_range(*curpp, &info->low, &info->high,
>  			xfs_getfsmap_datadev_helper, info);
>  }
> -- 
> 2.31.1
> 

