Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D89DDC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 22:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85D1B613EB
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 22:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238242AbhELWoE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 18:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236311AbhELWlQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 May 2021 18:41:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E5DB61073;
        Wed, 12 May 2021 22:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620859207;
        bh=C0DJCQFCg1IWOWWgITGeFfsZTVdFvGybWGDgZdijIJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h/KCsM7Sx8LobtsYp8fCvORJ08Est3W3R3Qz3F+KIMTQyuOc88607C/4oNWvh+Iun
         5/lTPIWqyL8+3n5FE3IZBwjNUiiZSNfmcJ/Q8XR1CZckeiOtjscGyMY8N/uMobckgt
         WQGn64kA09jSE4v+8axCIpYap39DslC2ia6FdSWoyGc/GohXQyC964TjColvvlge1t
         AN5CLoSImE5uMcixTXB9L4JGlVU6avBFpSZLm+vTzxbQ/0JlIp/DmLejvTlaKr57mm
         dLGDij3FXn0uql+TlpZAUoVnSWSgJufCRt6MMEGxuyjOjAofOeE/8Bh722PV6BO+/s
         zaoFmxxrSplgQ==
Date:   Wed, 12 May 2021 15:40:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/22] xfs: add a perag to the btree cursor
Message-ID: <20210512224006.GG8582@magnolia>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-12-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-12-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 05:20:43PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Which will eventually completely replace the agno in it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c          | 25 +++++++++++++++----------
>  fs/xfs/libxfs/xfs_alloc_btree.c    | 13 ++++++++++---
>  fs/xfs/libxfs/xfs_alloc_btree.h    |  3 ++-
>  fs/xfs/libxfs/xfs_btree.c          |  2 ++
>  fs/xfs/libxfs/xfs_btree.h          |  4 +++-
>  fs/xfs/libxfs/xfs_ialloc.c         | 16 ++++++++--------
>  fs/xfs/libxfs/xfs_ialloc_btree.c   | 15 +++++++++++----
>  fs/xfs/libxfs/xfs_ialloc_btree.h   |  7 ++++---
>  fs/xfs/libxfs/xfs_refcount.c       |  4 ++--
>  fs/xfs/libxfs/xfs_refcount_btree.c | 17 ++++++++++++-----
>  fs/xfs/libxfs/xfs_refcount_btree.h |  2 +-
>  fs/xfs/libxfs/xfs_rmap.c           |  6 +++---
>  fs/xfs/libxfs/xfs_rmap_btree.c     | 17 ++++++++++++-----
>  fs/xfs/libxfs/xfs_rmap_btree.h     |  2 +-
>  fs/xfs/scrub/agheader_repair.c     | 20 +++++++++++---------
>  fs/xfs/scrub/bmap.c                |  2 +-
>  fs/xfs/scrub/common.c              | 12 ++++++------
>  fs/xfs/scrub/repair.c              |  5 +++--
>  fs/xfs/xfs_discard.c               |  2 +-
>  fs/xfs/xfs_fsmap.c                 |  6 +++---
>  fs/xfs/xfs_reflink.c               |  2 +-
>  21 files changed, 112 insertions(+), 70 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index ce31c00dbf6f..7ec4af6bf494 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -776,7 +776,8 @@ xfs_alloc_cur_setup(
>  	 */
>  	if (!acur->cnt)
>  		acur->cnt = xfs_allocbt_init_cursor(args->mp, args->tp,
> -					args->agbp, args->agno, XFS_BTNUM_CNT);
> +						args->agbp, args->agno,
> +						args->pag, XFS_BTNUM_CNT);

If we still have to pass the AG[FI] buffer into the _init_cursor
functions, why not get the perag reference from the xfs_buf and
eliminate the agno/pag parameter?  It looks like cursors get their own
active reference to the perag, so I think only the _stage_cursor
function needs to be passed a perag structure, right?

The mechanical conversion stuff in the rest of this patch look fine to
me.

--D

>  	error = xfs_alloc_lookup_ge(acur->cnt, 0, args->maxlen, &i);
>  	if (error)
>  		return error;
> @@ -786,10 +787,12 @@ xfs_alloc_cur_setup(
>  	 */
>  	if (!acur->bnolt)
>  		acur->bnolt = xfs_allocbt_init_cursor(args->mp, args->tp,
> -					args->agbp, args->agno, XFS_BTNUM_BNO);
> +						args->agbp, args->agno,
> +						args->pag, XFS_BTNUM_BNO);
>  	if (!acur->bnogt)
>  		acur->bnogt = xfs_allocbt_init_cursor(args->mp, args->tp,
> -					args->agbp, args->agno, XFS_BTNUM_BNO);
> +						args->agbp, args->agno,
> +						args->pag, XFS_BTNUM_BNO);
>  	return i == 1 ? 0 : -ENOSPC;
>  }
>  
> @@ -1217,7 +1220,7 @@ xfs_alloc_ag_vextent_exact(
>  	 * Allocate/initialize a cursor for the by-number freespace btree.
>  	 */
>  	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
> -					  args->agno, XFS_BTNUM_BNO);
> +					  args->agno, args->pag, XFS_BTNUM_BNO);
>  
>  	/*
>  	 * Lookup bno and minlen in the btree (minlen is irrelevant, really).
> @@ -1277,7 +1280,7 @@ xfs_alloc_ag_vextent_exact(
>  	 * Allocate/initialize a cursor for the by-size btree.
>  	 */
>  	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
> -		args->agno, XFS_BTNUM_CNT);
> +					args->agno, args->pag, XFS_BTNUM_CNT);
>  	ASSERT(args->agbno + args->len <= be32_to_cpu(agf->agf_length));
>  	error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen, args->agbno,
>  				      args->len, XFSA_FIXUP_BNO_OK);
> @@ -1674,7 +1677,7 @@ xfs_alloc_ag_vextent_size(
>  	 * Allocate and initialize a cursor for the by-size btree.
>  	 */
>  	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
> -		args->agno, XFS_BTNUM_CNT);
> +					args->agno, args->pag, XFS_BTNUM_CNT);
>  	bno_cur = NULL;
>  	busy = false;
>  
> @@ -1837,7 +1840,7 @@ xfs_alloc_ag_vextent_size(
>  	 * Allocate and initialize a cursor for the by-block tree.
>  	 */
>  	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
> -		args->agno, XFS_BTNUM_BNO);
> +					args->agno, args->pag, XFS_BTNUM_BNO);
>  	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen,
>  			rbno, rlen, XFSA_FIXUP_CNT_OK)))
>  		goto error0;
> @@ -1909,7 +1912,8 @@ xfs_free_ag_extent(
>  	/*
>  	 * Allocate and initialize a cursor for the by-block btree.
>  	 */
> -	bno_cur = xfs_allocbt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_BNO);
> +	bno_cur = xfs_allocbt_init_cursor(mp, tp, agbp, agno,
> +					NULL, XFS_BTNUM_BNO);
>  	/*
>  	 * Look for a neighboring block on the left (lower block numbers)
>  	 * that is contiguous with this space.
> @@ -1979,7 +1983,8 @@ xfs_free_ag_extent(
>  	/*
>  	 * Now allocate and initialize a cursor for the by-size tree.
>  	 */
> -	cnt_cur = xfs_allocbt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_CNT);
> +	cnt_cur = xfs_allocbt_init_cursor(mp, tp, agbp, agno,
> +					NULL, XFS_BTNUM_CNT);
>  	/*
>  	 * Have both left and right contiguous neighbors.
>  	 * Merge all three into a single free block.
> @@ -2490,7 +2495,7 @@ xfs_exact_minlen_extent_available(
>  	int			error = 0;
>  
>  	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, agbp,
> -			args->agno, XFS_BTNUM_CNT);
> +					args->agno, args->pag, XFS_BTNUM_CNT);
>  	error = xfs_alloc_lookup_ge(cnt_cur, 0, args->minlen, stat);
>  	if (error)
>  		goto out;
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 19fdf87e86b9..a52ab25bbf0b 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -27,7 +27,7 @@ xfs_allocbt_dup_cursor(
>  {
>  	return xfs_allocbt_init_cursor(cur->bc_mp, cur->bc_tp,
>  			cur->bc_ag.agbp, cur->bc_ag.agno,
> -			cur->bc_btnum);
> +			cur->bc_ag.pag, cur->bc_btnum);
>  }
>  
>  STATIC void
> @@ -473,6 +473,7 @@ xfs_allocbt_init_common(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
>  	xfs_agnumber_t		agno,
> +	struct xfs_perag	*pag,
>  	xfs_btnum_t		btnum)
>  {
>  	struct xfs_btree_cur	*cur;
> @@ -497,6 +498,11 @@ xfs_allocbt_init_common(
>  
>  	cur->bc_ag.agno = agno;
>  	cur->bc_ag.abt.active = false;
> +	if (pag) {
> +		/* take a reference for the cursor */
> +		atomic_inc(&pag->pag_ref);
> +	}
> +	cur->bc_ag.pag = pag;
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb))
>  		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
> @@ -513,12 +519,13 @@ xfs_allocbt_init_cursor(
>  	struct xfs_trans	*tp,		/* transaction pointer */
>  	struct xfs_buf		*agbp,		/* buffer for agf structure */
>  	xfs_agnumber_t		agno,		/* allocation group number */
> +	struct xfs_perag	*pag,
>  	xfs_btnum_t		btnum)		/* btree identifier */
>  {
>  	struct xfs_agf		*agf = agbp->b_addr;
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = xfs_allocbt_init_common(mp, tp, agno, btnum);
> +	cur = xfs_allocbt_init_common(mp, tp, agno, pag, btnum);
>  	if (btnum == XFS_BTNUM_CNT)
>  		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
>  	else
> @@ -539,7 +546,7 @@ xfs_allocbt_stage_cursor(
>  {
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = xfs_allocbt_init_common(mp, NULL, agno, btnum);
> +	cur = xfs_allocbt_init_common(mp, NULL, agno, NULL, btnum);
>  	xfs_btree_stage_afakeroot(cur, afake);
>  	return cur;
>  }
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
> index a5b998e950fe..a10cedba18d8 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.h
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.h
> @@ -13,6 +13,7 @@
>  struct xfs_buf;
>  struct xfs_btree_cur;
>  struct xfs_mount;
> +struct xfs_perag;
>  struct xbtree_afakeroot;
>  
>  /*
> @@ -48,7 +49,7 @@ struct xbtree_afakeroot;
>  
>  extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
>  		struct xfs_trans *, struct xfs_buf *,
> -		xfs_agnumber_t, xfs_btnum_t);
> +		xfs_agnumber_t, struct xfs_perag *pag, xfs_btnum_t);
>  struct xfs_btree_cur *xfs_allocbt_stage_cursor(struct xfs_mount *mp,
>  		struct xbtree_afakeroot *afake, xfs_agnumber_t agno,
>  		xfs_btnum_t btnum);
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 0f12b885600d..44044317c0fb 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -377,6 +377,8 @@ xfs_btree_del_cursor(
>  	       XFS_FORCED_SHUTDOWN(cur->bc_mp));
>  	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
>  		kmem_free(cur->bc_ops);
> +	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
> +		xfs_perag_put(cur->bc_ag.pag);
>  	kmem_cache_free(xfs_btree_cur_zone, cur);
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 10e50cbacacf..8233f8679ba9 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -11,6 +11,7 @@ struct xfs_inode;
>  struct xfs_mount;
>  struct xfs_trans;
>  struct xfs_ifork;
> +struct xfs_perag;
>  
>  extern kmem_zone_t	*xfs_btree_cur_zone;
>  
> @@ -180,11 +181,12 @@ union xfs_btree_irec {
>  
>  /* Per-AG btree information. */
>  struct xfs_btree_cur_ag {
> +	xfs_agnumber_t		agno;
> +	struct xfs_perag	*pag;
>  	union {
>  		struct xfs_buf		*agbp;
>  		struct xbtree_afakeroot	*afake;	/* for staging cursor */
>  	};
> -	xfs_agnumber_t		agno;
>  	union {
>  		struct {
>  			unsigned long nr_ops;	/* # record updates */
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 8dc9225a5353..905872bab426 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -183,7 +183,7 @@ xfs_inobt_insert(
>  	int			i;
>  	int			error;
>  
> -	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
> +	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, btnum);
>  
>  	for (thisino = newino;
>  	     thisino < newino + newlen;
> @@ -531,7 +531,7 @@ xfs_inobt_insert_sprec(
>  	int				i;
>  	struct xfs_inobt_rec_incore	rec;
>  
> -	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
> +	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, btnum);
>  
>  	/* the new record is pre-aligned so we know where to look */
>  	error = xfs_inobt_lookup(cur, nrec->ir_startino, XFS_LOOKUP_EQ, &i);
> @@ -1145,7 +1145,7 @@ xfs_dialloc_ag_inobt(
>  	ASSERT(pag->pagi_freecount > 0);
>  
>   restart_pagno:
> -	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
> +	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, XFS_BTNUM_INO);
>  	/*
>  	 * If pagino is 0 (this is the root inode allocation) use newino.
>  	 * This must work because we've just allocated some.
> @@ -1598,7 +1598,7 @@ xfs_dialloc_ag(
>  	if (!pagino)
>  		pagino = be32_to_cpu(agi->agi_newino);
>  
> -	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_FINO);
> +	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, XFS_BTNUM_FINO);
>  
>  	error = xfs_check_agi_freecount(cur, agi);
>  	if (error)
> @@ -1641,7 +1641,7 @@ xfs_dialloc_ag(
>  	 * the original freecount. If all is well, make the equivalent update to
>  	 * the inobt using the finobt record and offset information.
>  	 */
> -	icur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
> +	icur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, XFS_BTNUM_INO);
>  
>  	error = xfs_check_agi_freecount(icur, agi);
>  	if (error)
> @@ -1954,7 +1954,7 @@ xfs_difree_inobt(
>  	/*
>  	 * Initialize the cursor.
>  	 */
> -	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
> +	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, XFS_BTNUM_INO);
>  
>  	error = xfs_check_agi_freecount(cur, agi);
>  	if (error)
> @@ -2080,7 +2080,7 @@ xfs_difree_finobt(
>  	int				error;
>  	int				i;
>  
> -	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_FINO);
> +	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, XFS_BTNUM_FINO);
>  
>  	error = xfs_inobt_lookup(cur, ibtrec->ir_startino, XFS_LOOKUP_EQ, &i);
>  	if (error)
> @@ -2281,7 +2281,7 @@ xfs_imap_lookup(
>  	 * we have a record, we need to ensure it contains the inode number
>  	 * we are looking up.
>  	 */
> -	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
> +	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, XFS_BTNUM_INO);
>  	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &i);
>  	if (!error) {
>  		if (i)
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 4ec8ea1331a5..6c4efdf01674 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -36,7 +36,7 @@ xfs_inobt_dup_cursor(
>  {
>  	return xfs_inobt_init_cursor(cur->bc_mp, cur->bc_tp,
>  			cur->bc_ag.agbp, cur->bc_ag.agno,
> -			cur->bc_btnum);
> +			cur->bc_ag.pag, cur->bc_btnum);
>  }
>  
>  STATIC void
> @@ -429,6 +429,7 @@ xfs_inobt_init_common(
>  	struct xfs_mount	*mp,		/* file system mount point */
>  	struct xfs_trans	*tp,		/* transaction pointer */
>  	xfs_agnumber_t		agno,		/* allocation group number */
> +	struct xfs_perag	*pag,
>  	xfs_btnum_t		btnum)		/* ialloc or free ino btree */
>  {
>  	struct xfs_btree_cur	*cur;
> @@ -451,6 +452,11 @@ xfs_inobt_init_common(
>  		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
>  
>  	cur->bc_ag.agno = agno;
> +	if (pag) {
> +		/* take a reference for the cursor */
> +		atomic_inc(&pag->pag_ref);
> +	}
> +	cur->bc_ag.pag = pag;
>  	return cur;
>  }
>  
> @@ -461,12 +467,13 @@ xfs_inobt_init_cursor(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*agbp,
>  	xfs_agnumber_t		agno,
> +	struct xfs_perag	*pag,
>  	xfs_btnum_t		btnum)
>  {
>  	struct xfs_btree_cur	*cur;
>  	struct xfs_agi		*agi = agbp->b_addr;
>  
> -	cur = xfs_inobt_init_common(mp, tp, agno, btnum);
> +	cur = xfs_inobt_init_common(mp, tp, agno, pag, btnum);
>  	if (btnum == XFS_BTNUM_INO)
>  		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
>  	else
> @@ -485,7 +492,7 @@ xfs_inobt_stage_cursor(
>  {
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = xfs_inobt_init_common(mp, NULL, agno, btnum);
> +	cur = xfs_inobt_init_common(mp, NULL, agno, NULL, btnum);
>  	xfs_btree_stage_afakeroot(cur, afake);
>  	return cur;
>  }
> @@ -672,7 +679,7 @@ xfs_inobt_cur(
>  	if (error)
>  		return error;
>  
> -	cur = xfs_inobt_init_cursor(mp, tp, *agi_bpp, agno, which);
> +	cur = xfs_inobt_init_cursor(mp, tp, *agi_bpp, agno, NULL, which);
>  	*curpp = cur;
>  	return 0;
>  }
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
> index d5afe01fb2de..04dfa7eee81f 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.h
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
> @@ -13,6 +13,7 @@
>  struct xfs_buf;
>  struct xfs_btree_cur;
>  struct xfs_mount;
> +struct xfs_perag;
>  
>  /*
>   * Btree block header size depends on a superblock flag.
> @@ -45,9 +46,9 @@ struct xfs_mount;
>  		 (maxrecs) * sizeof(xfs_inobt_key_t) + \
>  		 ((index) - 1) * sizeof(xfs_inobt_ptr_t)))
>  
> -extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
> -		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t,
> -		xfs_btnum_t);
> +extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *mp,
> +		struct xfs_trans *tp, struct xfs_buf *agbp, xfs_agnumber_t agno,
> +		struct xfs_perag *pag, xfs_btnum_t btnum);
>  struct xfs_btree_cur *xfs_inobt_stage_cursor(struct xfs_mount *mp,
>  		struct xbtree_afakeroot *afake, xfs_agnumber_t agno,
>  		xfs_btnum_t btnum);
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 2037b9f23069..1c2bd2949d7d 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1178,7 +1178,7 @@ xfs_refcount_finish_one(
>  		if (error)
>  			return error;
>  
> -		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
> +		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
>  		rcur->bc_ag.refc.nr_ops = nr_ops;
>  		rcur->bc_ag.refc.shape_changes = shape_changes;
>  	}
> @@ -1707,7 +1707,7 @@ xfs_refcount_recover_cow_leftovers(
>  	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
>  	if (error)
>  		goto out_trans;
> -	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
> +	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
>  
>  	/* Find all the leftover CoW staging extents. */
>  	memset(&low, 0, sizeof(low));
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index c4ddf9ded00b..74f8ac0209f1 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -26,7 +26,7 @@ xfs_refcountbt_dup_cursor(
>  	struct xfs_btree_cur	*cur)
>  {
>  	return xfs_refcountbt_init_cursor(cur->bc_mp, cur->bc_tp,
> -			cur->bc_ag.agbp, cur->bc_ag.agno);
> +			cur->bc_ag.agbp, cur->bc_ag.agno, cur->bc_ag.pag);
>  }
>  
>  STATIC void
> @@ -316,7 +316,8 @@ static struct xfs_btree_cur *
>  xfs_refcountbt_init_common(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
> -	xfs_agnumber_t		agno)
> +	xfs_agnumber_t		agno,
> +	struct xfs_perag	*pag)
>  {
>  	struct xfs_btree_cur	*cur;
>  
> @@ -332,6 +333,11 @@ xfs_refcountbt_init_common(
>  
>  	cur->bc_ag.agno = agno;
>  	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
> +	if (pag) {
> +		/* take a reference for the cursor */
> +		atomic_inc(&pag->pag_ref);
> +	}
> +	cur->bc_ag.pag = pag;
>  
>  	cur->bc_ag.refc.nr_ops = 0;
>  	cur->bc_ag.refc.shape_changes = 0;
> @@ -345,12 +351,13 @@ xfs_refcountbt_init_cursor(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*agbp,
> -	xfs_agnumber_t		agno)
> +	xfs_agnumber_t		agno,
> +	struct xfs_perag	*pag)
>  {
>  	struct xfs_agf		*agf = agbp->b_addr;
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = xfs_refcountbt_init_common(mp, tp, agno);
> +	cur = xfs_refcountbt_init_common(mp, tp, agno, pag);
>  	cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
>  	cur->bc_ag.agbp = agbp;
>  	return cur;
> @@ -365,7 +372,7 @@ xfs_refcountbt_stage_cursor(
>  {
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = xfs_refcountbt_init_common(mp, NULL, agno);
> +	cur = xfs_refcountbt_init_common(mp, NULL, agno, NULL);
>  	xfs_btree_stage_afakeroot(cur, afake);
>  	return cur;
>  }
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
> index eab1b0c672c0..8b82a39f104a 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.h
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.h
> @@ -47,7 +47,7 @@ struct xbtree_afakeroot;
>  
>  extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
>  		struct xfs_trans *tp, struct xfs_buf *agbp,
> -		xfs_agnumber_t agno);
> +		xfs_agnumber_t agno, struct xfs_perag *pag);
>  struct xfs_btree_cur *xfs_refcountbt_stage_cursor(struct xfs_mount *mp,
>  		struct xbtree_afakeroot *afake, xfs_agnumber_t agno);
>  extern int xfs_refcountbt_maxrecs(int blocklen, bool leaf);
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 1d0a6b686eea..0d7a6997120c 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -708,7 +708,7 @@ xfs_rmap_free(
>  	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
>  		return 0;
>  
> -	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
> +	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno, NULL);
>  
>  	error = xfs_rmap_unmap(cur, bno, len, false, oinfo);
>  
> @@ -962,7 +962,7 @@ xfs_rmap_alloc(
>  	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
>  		return 0;
>  
> -	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
> +	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno, NULL);
>  	error = xfs_rmap_map(cur, bno, len, false, oinfo);
>  
>  	xfs_btree_del_cursor(cur, error);
> @@ -2408,7 +2408,7 @@ xfs_rmap_finish_one(
>  			goto out_drop;
>  		}
>  
> -		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag->pag_agno);
> +		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag->pag_agno, pag);
>  	}
>  	*pcur = rcur;
>  
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index ba2f7064451b..7bef8feeded1 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -52,7 +52,7 @@ xfs_rmapbt_dup_cursor(
>  	struct xfs_btree_cur	*cur)
>  {
>  	return xfs_rmapbt_init_cursor(cur->bc_mp, cur->bc_tp,
> -			cur->bc_ag.agbp, cur->bc_ag.agno);
> +			cur->bc_ag.agbp, cur->bc_ag.agno, cur->bc_ag.pag);
>  }
>  
>  STATIC void
> @@ -449,7 +449,8 @@ static struct xfs_btree_cur *
>  xfs_rmapbt_init_common(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
> -	xfs_agnumber_t		agno)
> +	xfs_agnumber_t		agno,
> +	struct xfs_perag	*pag)
>  {
>  	struct xfs_btree_cur	*cur;
>  
> @@ -463,6 +464,11 @@ xfs_rmapbt_init_common(
>  	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
>  	cur->bc_ag.agno = agno;
>  	cur->bc_ops = &xfs_rmapbt_ops;
> +	if (pag) {
> +		/* take a reference for the cursor */
> +		atomic_inc(&pag->pag_ref);
> +	}
> +	cur->bc_ag.pag = pag;
>  
>  	return cur;
>  }
> @@ -473,12 +479,13 @@ xfs_rmapbt_init_cursor(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*agbp,
> -	xfs_agnumber_t		agno)
> +	xfs_agnumber_t		agno,
> +	struct xfs_perag	*pag)
>  {
>  	struct xfs_agf		*agf = agbp->b_addr;
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = xfs_rmapbt_init_common(mp, tp, agno);
> +	cur = xfs_rmapbt_init_common(mp, tp, agno, pag);
>  	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
>  	cur->bc_ag.agbp = agbp;
>  	return cur;
> @@ -493,7 +500,7 @@ xfs_rmapbt_stage_cursor(
>  {
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = xfs_rmapbt_init_common(mp, NULL, agno);
> +	cur = xfs_rmapbt_init_common(mp, NULL, agno, NULL);
>  	xfs_btree_stage_afakeroot(cur, afake);
>  	return cur;
>  }
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
> index 57fab72e26ad..c94f418cc06b 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.h
> @@ -43,7 +43,7 @@ struct xbtree_afakeroot;
>  
>  struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
>  				struct xfs_trans *tp, struct xfs_buf *bp,
> -				xfs_agnumber_t agno);
> +				xfs_agnumber_t agno, struct xfs_perag *pag);
>  struct xfs_btree_cur *xfs_rmapbt_stage_cursor(struct xfs_mount *mp,
>  		struct xbtree_afakeroot *afake, xfs_agnumber_t agno);
>  void xfs_rmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 1cdfbd57f36b..5dd91bf04c18 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -247,7 +247,7 @@ xrep_agf_calc_from_btrees(
>  
>  	/* Update the AGF counters from the bnobt. */
>  	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> -			XFS_BTNUM_BNO);
> +			sc->sa.pag, XFS_BTNUM_BNO);
>  	error = xfs_alloc_query_all(cur, xrep_agf_walk_allocbt, &raa);
>  	if (error)
>  		goto err;
> @@ -261,7 +261,7 @@ xrep_agf_calc_from_btrees(
>  
>  	/* Update the AGF counters from the cntbt. */
>  	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> -			XFS_BTNUM_CNT);
> +			sc->sa.pag, XFS_BTNUM_CNT);
>  	error = xfs_btree_count_blocks(cur, &blocks);
>  	if (error)
>  		goto err;
> @@ -269,7 +269,8 @@ xrep_agf_calc_from_btrees(
>  	btreeblks += blocks - 1;
>  
>  	/* Update the AGF counters from the rmapbt. */
> -	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno);
> +	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> +			sc->sa.pag);
>  	error = xfs_btree_count_blocks(cur, &blocks);
>  	if (error)
>  		goto err;
> @@ -282,7 +283,7 @@ xrep_agf_calc_from_btrees(
>  	/* Update the AGF counters from the refcountbt. */
>  	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
>  		cur = xfs_refcountbt_init_cursor(mp, sc->tp, agf_bp,
> -				sc->sa.agno);
> +				sc->sa.agno, sc->sa.pag);
>  		error = xfs_btree_count_blocks(cur, &blocks);
>  		if (error)
>  			goto err;
> @@ -490,7 +491,8 @@ xrep_agfl_collect_blocks(
>  	xbitmap_init(&ra.agmetablocks);
>  
>  	/* Find all space used by the free space btrees & rmapbt. */
> -	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno);
> +	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> +			sc->sa.pag);
>  	error = xfs_rmap_query_all(cur, xrep_agfl_walk_rmap, &ra);
>  	if (error)
>  		goto err;
> @@ -498,7 +500,7 @@ xrep_agfl_collect_blocks(
>  
>  	/* Find all blocks currently being used by the bnobt. */
>  	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> -			XFS_BTNUM_BNO);
> +			sc->sa.pag, XFS_BTNUM_BNO);
>  	error = xbitmap_set_btblocks(&ra.agmetablocks, cur);
>  	if (error)
>  		goto err;
> @@ -506,7 +508,7 @@ xrep_agfl_collect_blocks(
>  
>  	/* Find all blocks currently being used by the cntbt. */
>  	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> -			XFS_BTNUM_CNT);
> +			sc->sa.pag, XFS_BTNUM_CNT);
>  	error = xbitmap_set_btblocks(&ra.agmetablocks, cur);
>  	if (error)
>  		goto err;
> @@ -807,7 +809,7 @@ xrep_agi_calc_from_btrees(
>  	int			error;
>  
>  	cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp, sc->sa.agno,
> -			XFS_BTNUM_INO);
> +			sc->sa.pag, XFS_BTNUM_INO);
>  	error = xfs_ialloc_count_inodes(cur, &count, &freecount);
>  	if (error)
>  		goto err;
> @@ -829,7 +831,7 @@ xrep_agi_calc_from_btrees(
>  		xfs_agblock_t	blocks;
>  
>  		cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp, sc->sa.agno,
> -				XFS_BTNUM_FINO);
> +				sc->sa.pag, XFS_BTNUM_FINO);
>  		error = xfs_btree_count_blocks(cur, &blocks);
>  		if (error)
>  			goto err;
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index c60a1990d629..a792d9ffd61e 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -556,7 +556,7 @@ xchk_bmap_check_ag_rmaps(
>  	if (error)
>  		return error;
>  
> -	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf, agno);
> +	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf, agno, NULL);
>  
>  	sbcri.sc = sc;
>  	sbcri.whichfork = whichfork;
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index c8da976b50fc..50768559fb60 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -465,42 +465,42 @@ xchk_ag_btcur_init(
>  	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_BNO)) {
>  		/* Set up a bnobt cursor for cross-referencing. */
>  		sa->bno_cur = xfs_allocbt_init_cursor(mp, sc->tp, sa->agf_bp,
> -				agno, XFS_BTNUM_BNO);
> +				agno, sa->pag, XFS_BTNUM_BNO);
>  	}
>  
>  	if (sa->agf_bp &&
>  	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_CNT)) {
>  		/* Set up a cntbt cursor for cross-referencing. */
>  		sa->cnt_cur = xfs_allocbt_init_cursor(mp, sc->tp, sa->agf_bp,
> -				agno, XFS_BTNUM_CNT);
> +				agno, sa->pag, XFS_BTNUM_CNT);
>  	}
>  
>  	/* Set up a inobt cursor for cross-referencing. */
>  	if (sa->agi_bp &&
>  	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_INO)) {
>  		sa->ino_cur = xfs_inobt_init_cursor(mp, sc->tp, sa->agi_bp,
> -					agno, XFS_BTNUM_INO);
> +				agno, sa->pag, XFS_BTNUM_INO);
>  	}
>  
>  	/* Set up a finobt cursor for cross-referencing. */
>  	if (sa->agi_bp && xfs_sb_version_hasfinobt(&mp->m_sb) &&
>  	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_FINO)) {
>  		sa->fino_cur = xfs_inobt_init_cursor(mp, sc->tp, sa->agi_bp,
> -				agno, XFS_BTNUM_FINO);
> +				agno, sa->pag, XFS_BTNUM_FINO);
>  	}
>  
>  	/* Set up a rmapbt cursor for cross-referencing. */
>  	if (sa->agf_bp && xfs_sb_version_hasrmapbt(&mp->m_sb) &&
>  	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_RMAP)) {
>  		sa->rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp, sa->agf_bp,
> -				agno);
> +				agno, sa->pag);
>  	}
>  
>  	/* Set up a refcountbt cursor for cross-referencing. */
>  	if (sa->agf_bp && xfs_sb_version_hasreflink(&mp->m_sb) &&
>  	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_REFC)) {
>  		sa->refc_cur = xfs_refcountbt_init_cursor(mp, sc->tp,
> -				sa->agf_bp, agno);
> +				sa->agf_bp, agno, sa->pag);
>  	}
>  }
>  
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 6b62872c4d10..862dc56fd8cd 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -555,7 +555,7 @@ xrep_reap_block(
>  	} else {
>  		agf_bp = sc->sa.agf_bp;
>  	}
> -	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf_bp, agno);
> +	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf_bp, agno, sc->sa.pag);
>  
>  	/* Can we find any other rmappings? */
>  	error = xfs_rmap_has_other_keys(cur, agbno, 1, oinfo, &has_other_rmap);
> @@ -892,7 +892,8 @@ xrep_find_ag_btree_roots(
>  		fab->height = 0;
>  	}
>  
> -	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno);
> +	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> +			sc->sa.pag);
>  	error = xfs_rmap_query_all(cur, xrep_findroot_rmap, &ri);
>  	xfs_btree_del_cursor(cur, error);
>  
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 972864250bd2..311ebaad4f5a 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -50,7 +50,7 @@ xfs_trim_extents(
>  		goto out_put_perag;
>  	agf = agbp->b_addr;
>  
> -	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno, XFS_BTNUM_CNT);
> +	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno, pag, XFS_BTNUM_CNT);
>  
>  	/*
>  	 * Look up the longest btree in the AGF and start with it.
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 835dd6e3819b..b654a2bf9a9f 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -211,7 +211,7 @@ xfs_getfsmap_is_shared(
>  	/* Are there any shared blocks here? */
>  	flen = 0;
>  	cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp,
> -			info->pag->pag_agno);
> +			info->pag->pag_agno, info->pag);
>  
>  	error = xfs_refcount_find_shared(cur, rec->rm_startblock,
>  			rec->rm_blockcount, &fbno, &flen, false);
> @@ -708,7 +708,7 @@ xfs_getfsmap_datadev_rmapbt_query(
>  
>  	/* Allocate cursor for this AG and query_range it. */
>  	*curpp = xfs_rmapbt_init_cursor(tp->t_mountp, tp, info->agf_bp,
> -			info->pag->pag_agno);
> +			info->pag->pag_agno, info->pag);
>  	return xfs_rmap_query_range(*curpp, &info->low, &info->high,
>  			xfs_getfsmap_datadev_helper, info);
>  }
> @@ -741,7 +741,7 @@ xfs_getfsmap_datadev_bnobt_query(
>  
>  	/* Allocate cursor for this AG and query_range it. */
>  	*curpp = xfs_allocbt_init_cursor(tp->t_mountp, tp, info->agf_bp,
> -			info->pag->pag_agno, XFS_BTNUM_BNO);
> +			info->pag->pag_agno, info->pag, XFS_BTNUM_BNO);
>  	key->ar_startblock = info->low.rm_startblock;
>  	key[1].ar_startblock = info->high.rm_startblock;
>  	return xfs_alloc_query_range(*curpp, key, &key[1],
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 0e430b0c1b16..28ffe1817f9b 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -144,7 +144,7 @@ xfs_reflink_find_shared(
>  	if (error)
>  		return error;
>  
> -	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
> +	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
>  
>  	error = xfs_refcount_find_shared(cur, agbno, aglen, fbno, flen,
>  			find_end_of_shared);
> -- 
> 2.31.1
> 
