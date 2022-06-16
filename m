Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE9DCCA47D
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 07:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359048AbiFPHip (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 03:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359595AbiFPHi0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 03:38:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4834B5675A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 00:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=duuYzH5Esv0LAa4g6OmqFFZ32kB/OXYWoHwSY4gbpvs=; b=AjfNev1zOYe09CbsiKavHUCUNy
        sOUcgWBquhZ8WK25IXFqA9vzZbCqarn+Ma4R5nGZsJM9MWXuanxSWP9V96VRuWsv9rK0zwXGQoU30
        fKLcuAhnABFeXozeAVKFHOCgar5WJTNGGkyO57M5miAuwViRXLTEalhDBgo7FiVLh4ptrwkBT5xdC
        8pGf841vR7K6iuFwG6VikoIVl5ZFxpu2lFmf8aXovhi4Ev4NGvm+57ZDFoOIdZRIO0C2e5Sf2PaAx
        o1/1hU+IY5VihPhZftj3tTGWEWco2L4UcrlmVtYxNdhZlG+OI39QDOK3+9OseDTILHlrj6bxmoeaX
        GhJdcffg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1k59-001662-Qz; Thu, 16 Jun 2022 07:38:23 +0000
Date:   Thu, 16 Jun 2022 00:38:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/50] xfs: pass perag to xfs_alloc_read_agf()
Message-ID: <Yqrd763BrdIO9UvQ@infradead.org>
References: <20220611012659.3418072-1-david@fromorbit.com>
 <20220611012659.3418072-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611012659.3418072-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 11:26:14AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_alloc_read_agf() initialises the perag if it hasn't been done
> yet, so it makes sense to pass it the perag rather than pull a
> reference from the buffer. This allows callers to be per-ag centric
> rather than passing mount/agno pairs everywhere.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag.c             | 19 +++++++--------
>  fs/xfs/libxfs/xfs_ag_resv.c        |  2 +-
>  fs/xfs/libxfs/xfs_alloc.c          | 30 ++++++++++-------------
>  fs/xfs/libxfs/xfs_alloc.h          | 13 ++--------
>  fs/xfs/libxfs/xfs_bmap.c           |  2 +-
>  fs/xfs/libxfs/xfs_ialloc.c         |  2 +-
>  fs/xfs/libxfs/xfs_refcount.c       |  6 ++---
>  fs/xfs/libxfs/xfs_refcount_btree.c |  2 +-
>  fs/xfs/libxfs/xfs_rmap_btree.c     |  2 +-
>  fs/xfs/scrub/agheader_repair.c     |  6 ++---
>  fs/xfs/scrub/bmap.c                |  2 +-
>  fs/xfs/scrub/common.c              |  2 +-
>  fs/xfs/scrub/fscounters.c          |  2 +-
>  fs/xfs/scrub/repair.c              |  5 ++--
>  fs/xfs/xfs_discard.c               |  2 +-
>  fs/xfs/xfs_extfree_item.c          |  6 ++++-
>  fs/xfs/xfs_filestream.c            |  2 +-
>  fs/xfs/xfs_fsmap.c                 |  3 +--
>  fs/xfs/xfs_reflink.c               | 38 +++++++++++++++++-------------
>  fs/xfs/xfs_reflink.h               |  3 ---
>  20 files changed, 68 insertions(+), 81 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 734ef170936e..c1a1c9f414c3 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -120,16 +120,13 @@ xfs_initialize_perag_data(
>  
>  	for (index = 0; index < agcount; index++) {
>  		/*
> -		 * read the agf, then the agi. This gets us
> -		 * all the information we need and populates the
> -		 * per-ag structures for us.
> +		 * Read the AGF and AGI buffers to populate the per-ag
> +		 * structures for us.
>  		 */
> -		error = xfs_alloc_read_agf(mp, NULL, index, 0, NULL);
> -		if (error)
> -			return error;
> -
>  		pag = xfs_perag_get(mp, index);
> -		error = xfs_ialloc_read_agi(pag, NULL, NULL);
> +		error = xfs_alloc_read_agf(pag, NULL, 0, NULL);
> +		if (!error)
> +			error = xfs_ialloc_read_agi(pag, NULL, NULL);
>  		if (error) {
>  			xfs_perag_put(pag);
>  			return error;
> @@ -792,7 +789,7 @@ xfs_ag_shrink_space(
>  
>  	agi = agibp->b_addr;
>  
> -	error = xfs_alloc_read_agf(mp, *tpp, pag->pag_agno, 0, &agfbp);
> +	error = xfs_alloc_read_agf(pag, *tpp, 0, &agfbp);
>  	if (error)
>  		return error;
>  
> @@ -909,7 +906,7 @@ xfs_ag_extend_space(
>  	/*
>  	 * Change agf length.
>  	 */
> -	error = xfs_alloc_read_agf(pag->pag_mount, tp, pag->pag_agno, 0, &bp);
> +	error = xfs_alloc_read_agf(pag, tp, 0, &bp);
>  	if (error)
>  		return error;
>  
> @@ -952,7 +949,7 @@ xfs_ag_get_geometry(
>  	error = xfs_ialloc_read_agi(pag, NULL, &agi_bp);
>  	if (error)
>  		return error;
> -	error = xfs_alloc_read_agf(pag->pag_mount, NULL, pag->pag_agno, 0, &agf_bp);
> +	error = xfs_alloc_read_agf(pag, NULL, 0, &agf_bp);
>  	if (error)
>  		goto out_agi;
>  
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index ce28bf8f72dc..5af123d13a63 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -322,7 +322,7 @@ xfs_ag_resv_init(
>  	 * address.
>  	 */
>  	if (has_resv) {
> -		error2 = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0, NULL);
> +		error2 = xfs_alloc_read_agf(pag, tp, 0, NULL);
>  		if (error2)
>  			return error2;
>  
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index f7853ab7b962..5d6ca86c4882 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2609,7 +2609,7 @@ xfs_alloc_fix_freelist(
>  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
>  
>  	if (!pag->pagf_init) {
> -		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
> +		error = xfs_alloc_read_agf(pag, tp, flags, &agbp);
>  		if (error) {
>  			/* Couldn't lock the AGF so skip this AG. */
>  			if (error == -EAGAIN)
> @@ -2639,7 +2639,7 @@ xfs_alloc_fix_freelist(
>  	 * Can fail if we're not blocking on locks, and it's held.
>  	 */
>  	if (!agbp) {
> -		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
> +		error = xfs_alloc_read_agf(pag, tp, flags, &agbp);
>  		if (error) {
>  			/* Couldn't lock the AGF so skip this AG. */
>  			if (error == -EAGAIN)
> @@ -3080,34 +3080,30 @@ xfs_read_agf(
>   * perag structure if necessary. If the caller provides @agfbpp, then return the
>   * locked buffer to the caller, otherwise free it.
>   */
> -int					/* error */
> +int
>  xfs_alloc_read_agf(
> -	struct xfs_mount	*mp,	/* mount point structure */
> -	struct xfs_trans	*tp,	/* transaction pointer */
> -	xfs_agnumber_t		agno,	/* allocation group number */
> -	int			flags,	/* XFS_ALLOC_FLAG_... */
> +	struct xfs_perag	*pag,
> +	struct xfs_trans	*tp,
> +	int			flags,
>  	struct xfs_buf		**agfbpp)
>  {
>  	struct xfs_buf		*agfbp;
> -	struct xfs_agf		*agf;		/* ag freelist header */
> -	struct xfs_perag	*pag;		/* per allocation group data */
> +	struct xfs_agf		*agf;
>  	int			error;
>  	int			allocbt_blks;
>  
> -	trace_xfs_alloc_read_agf(mp, agno);
> +	trace_xfs_alloc_read_agf(pag->pag_mount, pag->pag_agno);
>  
>  	/* We don't support trylock when freeing. */
>  	ASSERT((flags & (XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK)) !=
>  			(XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK));
> -	ASSERT(agno != NULLAGNUMBER);
> -	error = xfs_read_agf(mp, tp, agno,
> +	error = xfs_read_agf(pag->pag_mount, tp, pag->pag_agno,
>  			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XBF_TRYLOCK : 0,
>  			&agfbp);
>  	if (error)
>  		return error;
>  
>  	agf = agfbp->b_addr;
> -	pag = agfbp->b_pag;
>  	if (!pag->pagf_init) {
>  		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
>  		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
> @@ -3121,7 +3117,7 @@ xfs_alloc_read_agf(
>  			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
>  		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
>  		pag->pagf_init = 1;
> -		pag->pagf_agflreset = xfs_agfl_needs_reset(mp, agf);
> +		pag->pagf_agflreset = xfs_agfl_needs_reset(pag->pag_mount, agf);
>  
>  		/*
>  		 * Update the in-core allocbt counter. Filter out the rmapbt
> @@ -3131,13 +3127,13 @@ xfs_alloc_read_agf(
>  		 * counter only tracks non-root blocks.
>  		 */
>  		allocbt_blks = pag->pagf_btreeblks;
> -		if (xfs_has_rmapbt(mp))
> +		if (xfs_has_rmapbt(pag->pag_mount))
>  			allocbt_blks -= be32_to_cpu(agf->agf_rmap_blocks) - 1;
>  		if (allocbt_blks > 0)
> -			atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
> +			atomic64_add(allocbt_blks, &pag->pag_mount->m_allocbt_blks);

Overly long line here.  I think in general this function would benefit
from a local xfs_mount *mp variable anyway.

> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index bea65f2fe657..65c5dfe17ecf 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -16,9 +16,6 @@ static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
>  	return xfs_is_reflink_inode(ip) || xfs_is_always_cow_inode(ip);
>  }
>  
> -extern int xfs_reflink_find_shared(struct xfs_mount *mp, struct xfs_trans *tp,
> -		xfs_agnumber_t agno, xfs_agblock_t agbno, xfs_extlen_t aglen,
> -		xfs_agblock_t *fbno, xfs_extlen_t *flen, bool find_maximal);

Dropping this extern seems unrelated, and should move into a separate
patch together with actually marking it static.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
