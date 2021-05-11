Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE36C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 12:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA2B46191C
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 12:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhEKMbr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 08:31:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31861 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231432AbhEKMbr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 May 2021 08:31:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620736241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3WES6CE0JpDr22/SVy+Vhx3mVrgiw9lOL1QhLP5JZOI=;
        b=RNto6McZim+oJW5ZKV67yDnn8nT4O+j7Y4JEeChpydUHJu2snK/U66KEmKg4Ij1DL9/I9Z
        td6aNHrFWKkQ2yM5ArucjBGIPX1Y/r32aSeG+I8TtEuw/gEPdQtzZ0/ad2jKY0MfBwFq2k
        mPtZkzcZHBF7Qkyoy3mPptKfrll3HzQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-Gsi4DTVENvemmq7UWUNhng-1; Tue, 11 May 2021 08:30:39 -0400
X-MC-Unique: Gsi4DTVENvemmq7UWUNhng-1
Received: by mail-qk1-f198.google.com with SMTP id l19-20020a37f5130000b02902e3dc23dc92so14245116qkk.15
        for <linux-xfs@vger.kernel.org>; Tue, 11 May 2021 05:30:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3WES6CE0JpDr22/SVy+Vhx3mVrgiw9lOL1QhLP5JZOI=;
        b=sVbKtDg7oE07FuxVODEpIva0RwuGBBbPAPO3c5uhbKD5BBlqyoi0Cdxn4eP66UMT/T
         pRdfIAFvvbm+9hiYo6eA4Kl1xFyjmNra+qjSJaTtDpRNhKKEP7gFTlmJcKJ4G7AbDv3H
         dZ+h6xe80EJs/9MouOR9vwX7/QQeDTWtordlNpFA70UER8yuGnfcVyWxDWn7f8epGC5a
         dSoxi4i5OPNQsUAapSR5NHegQH/RNTKEjdFeAMyNKRjMKukINfMVhSawUCdqTfTwxB86
         XB7cvxBew03G0Hl8kzm1nxCxJaksNrrpjnmfTXEAYMg2CgiZ28jOTatSsKhpui8KtVg1
         0v3Q==
X-Gm-Message-State: AOAM530Nn/ibpquQOopr5DOXjrdF925QkkoSh96xhh0RIn3mrA3uaEsG
        wx+NnA57SvrQm3rXf3XCxwBnQfbz5A6usSn3vVlHOoZsN0X+ea91rRdFue+b1RhtZ4G+7NZ1YLI
        owAVGdO8g7OgJzwpjB+H5
X-Received: by 2002:a37:a90e:: with SMTP id s14mr27878646qke.262.1620736238608;
        Tue, 11 May 2021 05:30:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlK8spsTlN2aAq1OGSU75hHPSLrityFUdZvbkhijMy/77BbTOQkD8cClNE572DBjKTR+U68g==
X-Received: by 2002:a37:a90e:: with SMTP id s14mr27878621qke.262.1620736238298;
        Tue, 11 May 2021 05:30:38 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id x18sm8586380qtq.40.2021.05.11.05.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 05:30:38 -0700 (PDT)
Date:   Tue, 11 May 2021 08:30:36 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/22] xfs: convert refcount btree cursor to use perags
Message-ID: <YJp47OanS8u7IKaU@bfoster>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-14-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-14-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 05:20:45PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_refcount.c       | 39 +++++++++++++++++-------------
>  fs/xfs/libxfs/xfs_refcount.h       |  9 ++++++-
>  fs/xfs/libxfs/xfs_refcount_btree.c | 22 +++++++----------
>  fs/xfs/libxfs/xfs_refcount_btree.h |  4 +--
>  fs/xfs/scrub/agheader_repair.c     |  2 +-
>  fs/xfs/scrub/bmap.c                |  8 +++---
>  fs/xfs/scrub/common.c              |  2 +-
>  fs/xfs/xfs_fsmap.c                 |  3 +--
>  fs/xfs/xfs_reflink.c               |  4 +--
>  9 files changed, 50 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 1c2bd2949d7d..3c2b99cbd57d 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -22,6 +22,7 @@
>  #include "xfs_bit.h"
>  #include "xfs_refcount.h"
>  #include "xfs_rmap.h"
> +#include "xfs_ag.h"
>  
>  /* Allowable refcount adjustment amounts. */
>  enum xfs_refc_adjust_op {
> @@ -1142,14 +1143,13 @@ xfs_refcount_finish_one(
>  	struct xfs_btree_cur		*rcur;
>  	struct xfs_buf			*agbp = NULL;
>  	int				error = 0;
> -	xfs_agnumber_t			agno;
>  	xfs_agblock_t			bno;
>  	xfs_agblock_t			new_agbno;
>  	unsigned long			nr_ops = 0;
>  	int				shape_changes = 0;
> +	struct xfs_perag		*pag;
>  
> -	agno = XFS_FSB_TO_AGNO(mp, startblock);
> -	ASSERT(agno != NULLAGNUMBER);
> +	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, startblock));
>  	bno = XFS_FSB_TO_AGBNO(mp, startblock);
>  
>  	trace_xfs_refcount_deferred(mp, XFS_FSB_TO_AGNO(mp, startblock),
> @@ -1157,15 +1157,17 @@ xfs_refcount_finish_one(
>  			blockcount);
>  
>  	if (XFS_TEST_ERROR(false, mp,
> -			XFS_ERRTAG_REFCOUNT_FINISH_ONE))
> -		return -EIO;
> +			XFS_ERRTAG_REFCOUNT_FINISH_ONE)) {
> +		error = -EIO;
> +		goto out_drop;
> +	}
>  
>  	/*
>  	 * If we haven't gotten a cursor or the cursor AG doesn't match
>  	 * the startblock, get one now.
>  	 */
>  	rcur = *pcur;
> -	if (rcur != NULL && rcur->bc_ag.agno != agno) {
> +	if (rcur != NULL && rcur->bc_ag.pag != pag) {
>  		nr_ops = rcur->bc_ag.refc.nr_ops;
>  		shape_changes = rcur->bc_ag.refc.shape_changes;
>  		xfs_refcount_finish_one_cleanup(tp, rcur, 0);
> @@ -1173,12 +1175,12 @@ xfs_refcount_finish_one(
>  		*pcur = NULL;
>  	}
>  	if (rcur == NULL) {
> -		error = xfs_alloc_read_agf(tp->t_mountp, tp, agno,
> +		error = xfs_alloc_read_agf(tp->t_mountp, tp, pag->pag_agno,
>  				XFS_ALLOC_FLAG_FREEING, &agbp);
>  		if (error)
> -			return error;
> +			goto out_drop;
>  
> -		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
> +		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, pag);
>  		rcur->bc_ag.refc.nr_ops = nr_ops;
>  		rcur->bc_ag.refc.shape_changes = shape_changes;
>  	}
> @@ -1188,12 +1190,12 @@ xfs_refcount_finish_one(
>  	case XFS_REFCOUNT_INCREASE:
>  		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
>  			new_len, XFS_REFCOUNT_ADJUST_INCREASE, NULL);
> -		*new_fsb = XFS_AGB_TO_FSB(mp, agno, new_agbno);
> +		*new_fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
>  		break;
>  	case XFS_REFCOUNT_DECREASE:
>  		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
>  			new_len, XFS_REFCOUNT_ADJUST_DECREASE, NULL);
> -		*new_fsb = XFS_AGB_TO_FSB(mp, agno, new_agbno);
> +		*new_fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
>  		break;
>  	case XFS_REFCOUNT_ALLOC_COW:
>  		*new_fsb = startblock + blockcount;
> @@ -1210,8 +1212,10 @@ xfs_refcount_finish_one(
>  		error = -EFSCORRUPTED;
>  	}
>  	if (!error && *new_len > 0)
> -		trace_xfs_refcount_finish_one_leftover(mp, agno, type,
> +		trace_xfs_refcount_finish_one_leftover(mp, pag->pag_agno, type,
>  				bno, blockcount, new_agbno, *new_len);
> +out_drop:
> +	xfs_perag_put(pag);
>  	return error;
>  }
>  
> @@ -1672,7 +1676,7 @@ xfs_refcount_recover_extent(
>  int
>  xfs_refcount_recover_cow_leftovers(
>  	struct xfs_mount		*mp,
> -	xfs_agnumber_t			agno)
> +	struct xfs_perag		*pag)
>  {
>  	struct xfs_trans		*tp;
>  	struct xfs_btree_cur		*cur;
> @@ -1704,10 +1708,10 @@ xfs_refcount_recover_cow_leftovers(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
> +	error = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0, &agbp);
>  	if (error)
>  		goto out_trans;
> -	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
> +	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, pag);
>  
>  	/* Find all the leftover CoW staging extents. */
>  	memset(&low, 0, sizeof(low));
> @@ -1729,11 +1733,12 @@ xfs_refcount_recover_cow_leftovers(
>  		if (error)
>  			goto out_free;
>  
> -		trace_xfs_refcount_recover_extent(mp, agno, &rr->rr_rrec);
> +		trace_xfs_refcount_recover_extent(mp, pag->pag_agno,
> +				&rr->rr_rrec);
>  
>  		/* Free the orphan record */
>  		agbno = rr->rr_rrec.rc_startblock - XFS_REFC_COW_START;
> -		fsb = XFS_AGB_TO_FSB(mp, agno, agbno);
> +		fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, agbno);
>  		xfs_refcount_free_cow_extent(tp, fsb,
>  				rr->rr_rrec.rc_blockcount);
>  
> diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
> index 209795539c8d..9f6e9aae4da0 100644
> --- a/fs/xfs/libxfs/xfs_refcount.h
> +++ b/fs/xfs/libxfs/xfs_refcount.h
> @@ -6,6 +6,13 @@
>  #ifndef __XFS_REFCOUNT_H__
>  #define __XFS_REFCOUNT_H__
>  
> +struct xfs_trans;
> +struct xfs_mount;
> +struct xfs_perag;
> +struct xfs_btree_cur;
> +struct xfs_bmbt_irec;
> +struct xfs_refcount_irec;
> +
>  extern int xfs_refcount_lookup_le(struct xfs_btree_cur *cur,
>  		xfs_agblock_t bno, int *stat);
>  extern int xfs_refcount_lookup_ge(struct xfs_btree_cur *cur,
> @@ -50,7 +57,7 @@ void xfs_refcount_alloc_cow_extent(struct xfs_trans *tp, xfs_fsblock_t fsb,
>  void xfs_refcount_free_cow_extent(struct xfs_trans *tp, xfs_fsblock_t fsb,
>  		xfs_extlen_t len);
>  extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
> -		xfs_agnumber_t agno);
> +		struct xfs_perag *pag);
>  
>  /*
>   * While we're adjusting the refcounts records of an extent, we have
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index 74f8ac0209f1..8f6577cb3475 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -26,7 +26,7 @@ xfs_refcountbt_dup_cursor(
>  	struct xfs_btree_cur	*cur)
>  {
>  	return xfs_refcountbt_init_cursor(cur->bc_mp, cur->bc_tp,
> -			cur->bc_ag.agbp, cur->bc_ag.agno, cur->bc_ag.pag);
> +			cur->bc_ag.agbp, cur->bc_ag.pag);
>  }
>  
>  STATIC void
> @@ -316,13 +316,11 @@ static struct xfs_btree_cur *
>  xfs_refcountbt_init_common(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
> -	xfs_agnumber_t		agno,
>  	struct xfs_perag	*pag)
>  {
>  	struct xfs_btree_cur	*cur;
>  
> -	ASSERT(agno != NULLAGNUMBER);
> -	ASSERT(agno < mp->m_sb.sb_agcount);
> +	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
>  
>  	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>  	cur->bc_tp = tp;
> @@ -331,13 +329,12 @@ xfs_refcountbt_init_common(
>  	cur->bc_blocklog = mp->m_sb.sb_blocklog;
>  	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
>  
> -	cur->bc_ag.agno = agno;
>  	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
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
>  	cur->bc_ag.refc.nr_ops = 0;
>  	cur->bc_ag.refc.shape_changes = 0;
> @@ -351,13 +348,12 @@ xfs_refcountbt_init_cursor(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*agbp,
> -	xfs_agnumber_t		agno,
>  	struct xfs_perag	*pag)
>  {
>  	struct xfs_agf		*agf = agbp->b_addr;
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = xfs_refcountbt_init_common(mp, tp, agno, pag);
> +	cur = xfs_refcountbt_init_common(mp, tp, pag);
>  	cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
>  	cur->bc_ag.agbp = agbp;
>  	return cur;
> @@ -368,11 +364,11 @@ struct xfs_btree_cur *
>  xfs_refcountbt_stage_cursor(
>  	struct xfs_mount	*mp,
>  	struct xbtree_afakeroot	*afake,
> -	xfs_agnumber_t		agno)
> +	struct xfs_perag	*pag)
>  {
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = xfs_refcountbt_init_common(mp, NULL, agno, NULL);
> +	cur = xfs_refcountbt_init_common(mp, NULL, pag);
>  	xfs_btree_stage_afakeroot(cur, afake);
>  	return cur;
>  }
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
> index 8b82a39f104a..bd9ed9e1e41f 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.h
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.h
> @@ -47,9 +47,9 @@ struct xbtree_afakeroot;
>  
>  extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
>  		struct xfs_trans *tp, struct xfs_buf *agbp,
> -		xfs_agnumber_t agno, struct xfs_perag *pag);
> +		struct xfs_perag *pag);
>  struct xfs_btree_cur *xfs_refcountbt_stage_cursor(struct xfs_mount *mp,
> -		struct xbtree_afakeroot *afake, xfs_agnumber_t agno);
> +		struct xbtree_afakeroot *afake, struct xfs_perag *pag);
>  extern int xfs_refcountbt_maxrecs(int blocklen, bool leaf);
>  extern void xfs_refcountbt_compute_maxlevels(struct xfs_mount *mp);
>  
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 981c689e3d95..251410c19198 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -282,7 +282,7 @@ xrep_agf_calc_from_btrees(
>  	/* Update the AGF counters from the refcountbt. */
>  	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
>  		cur = xfs_refcountbt_init_cursor(mp, sc->tp, agf_bp,
> -				sc->sa.agno, sc->sa.pag);
> +				sc->sa.pag);
>  		error = xfs_btree_count_blocks(cur, &blocks);
>  		if (error)
>  			goto err;
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index b20c3f03b3c5..5adef162115d 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -545,18 +545,18 @@ STATIC int
>  xchk_bmap_check_ag_rmaps(
>  	struct xfs_scrub		*sc,
>  	int				whichfork,
> -	xfs_agnumber_t			agno)
> +	struct xfs_perag		*pag)
>  {
>  	struct xchk_bmap_check_rmap_info	sbcri;
>  	struct xfs_btree_cur		*cur;
>  	struct xfs_buf			*agf;
>  	int				error;
>  
> -	error = xfs_alloc_read_agf(sc->mp, sc->tp, agno, 0, &agf);
> +	error = xfs_alloc_read_agf(sc->mp, sc->tp, pag->pag_agno, 0, &agf);
>  	if (error)
>  		return error;
>  
> -	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf, sc->sa.pag);
> +	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf, pag);
>  
>  	sbcri.sc = sc;
>  	sbcri.whichfork = whichfork;
> @@ -610,7 +610,7 @@ xchk_bmap_check_rmaps(
>  		return 0;
>  
>  	for_each_perag(sc->mp, agno, pag) {
> -		error = xchk_bmap_check_ag_rmaps(sc, whichfork, pag->pag_agno);
> +		error = xchk_bmap_check_ag_rmaps(sc, whichfork, pag);
>  		if (error)
>  			return error;
>  		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 48381c1adeed..cc7688ce79b2 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -500,7 +500,7 @@ xchk_ag_btcur_init(
>  	if (sa->agf_bp && xfs_sb_version_hasreflink(&mp->m_sb) &&
>  	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_REFC)) {
>  		sa->refc_cur = xfs_refcountbt_init_cursor(mp, sc->tp,
> -				sa->agf_bp, agno, sa->pag);
> +				sa->agf_bp, sa->pag);
>  	}
>  }
>  
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 7bfe9ea35de0..623cabaeafee 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -210,8 +210,7 @@ xfs_getfsmap_is_shared(
>  
>  	/* Are there any shared blocks here? */
>  	flen = 0;
> -	cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp,
> -			info->pag->pag_agno, info->pag);
> +	cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp, info->pag);
>  
>  	error = xfs_refcount_find_shared(cur, rec->rm_startblock,
>  			rec->rm_blockcount, &fbno, &flen, false);
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 28ffe1817f9b..c256104772cb 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -144,7 +144,7 @@ xfs_reflink_find_shared(
>  	if (error)
>  		return error;
>  
> -	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
> +	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agbp->b_pag);
>  
>  	error = xfs_refcount_find_shared(cur, agbno, aglen, fbno, flen,
>  			find_end_of_shared);
> @@ -763,7 +763,7 @@ xfs_reflink_recover_cow(
>  		return 0;
>  
>  	for_each_perag(mp, agno, pag) {
> -		error = xfs_refcount_recover_cow_leftovers(mp, pag->pag_agno);
> +		error = xfs_refcount_recover_cow_leftovers(mp, pag);
>  		if (error) {
>  			xfs_perag_put(pag);
>  			break;
> -- 
> 2.31.1
> 

