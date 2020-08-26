Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C531C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 17:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FD182078D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 17:23:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LKEQDwGo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgHZRX3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 13:23:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38691 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725995AbgHZRX2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 13:23:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598462605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7Ehzj2UaoCg6qKTTiUcS7HrxZRRm8IClgulJkQBT30o=;
        b=LKEQDwGodj8X89LWMSh7A0NgdBwQUn3Xbc5EvR9cS5P0W3I8ABGPfg7CxLhBOgTGAniVvM
        k+K/Gelv09db/W1Z6P0OMWOL/cHFnUMvrS5i0VPeXKGUIxjWHIskH9ZwWw+Z4wi8iFI4Jx
        PDylJKk/zcK61ofH/mTsWaFoaqj/nyg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-GyrDIxNnN9KWPzdySWgauw-1; Wed, 26 Aug 2020 13:23:14 -0400
X-MC-Unique: GyrDIxNnN9KWPzdySWgauw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01D77801AEB;
        Wed, 26 Aug 2020 17:23:14 +0000 (UTC)
Received: from bfoster (ovpn-112-11.rdu2.redhat.com [10.10.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8633D7A424;
        Wed, 26 Aug 2020 17:23:13 +0000 (UTC)
Date:   Wed, 26 Aug 2020 13:23:11 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: store inode btree block counts in AGI header
Message-ID: <20200826172311.GC355692@bfoster>
References: <159770499163.3956743.11547013163186111497.stgit@magnolia>
 <159770499882.3956743.13285713456151087581.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159770499882.3956743.13285713456151087581.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 17, 2020 at 03:56:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a btree block usage counters for both inode btrees to the AGI header
> so that we don't have to walk the entire finobt at mount time to create
> the per-AG reservations.
> 

I like the idea. I assume there will be mkfs/repair code to accompany
this..?

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_ag.c           |    4 ++
>  fs/xfs/libxfs/xfs_format.h       |   19 +++++++++
>  fs/xfs/libxfs/xfs_ialloc.c       |    1 
>  fs/xfs/libxfs/xfs_ialloc_btree.c |   78 +++++++++++++++++++++++++++++++++++---
>  fs/xfs/scrub/agheader.c          |   30 +++++++++++++++
>  fs/xfs/scrub/agheader_repair.c   |   17 ++++++++
>  fs/xfs/xfs_ondisk.h              |    2 -
>  fs/xfs/xfs_super.c               |    4 ++
>  8 files changed, 146 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 8cf73fe4338e..65d443c787d0 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -333,6 +333,10 @@ xfs_agiblock_init(
>  	}
>  	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++)
>  		agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
> +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> +		agi->agi_iblocks = cpu_to_be32(1);
> +		agi->agi_fblocks = cpu_to_be32(1);
> +	}
>  }
>  
>  typedef void (*aghdr_init_work_f)(struct xfs_mount *mp, struct xfs_buf *bp,
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 31b7ece985bb..fb4a29eb1c7b 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -449,6 +449,7 @@ xfs_sb_has_compat_feature(
>  #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
>  #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
>  #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
> +#define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
>  #define XFS_SB_FEAT_RO_COMPAT_ALL \
>  		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
>  		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
> @@ -563,6 +564,18 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
>  		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
>  }
>  
> +/*
> + * Inode btree block counter.  We record the number of inobt and finobt blocks
> + * in the AGI header so that we can skip the finobt walk at mount time when
> + * setting up per-AG reservations.  Since this is mostly an optimization of an
> + * existing feature, we only enable it when that feature is also enabled.
> + */
> +static inline bool xfs_sb_version_hasinobtcounts(struct xfs_sb *sbp)
> +{
> +	return xfs_sb_version_hasfinobt(sbp) &&
> +		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT);
> +}

The logic seems sane, but I wonder if we really should check for v5 +
COMPAT_INOBTCNT here and let mkfs worry about the feature compatibility
matrix. That would also mean we'd want to check hasfinobt() as well in
places we adjust the ->agi_fblocks field, log the two fields separately,
etc.

That is arguably overkill, but then why do we have an ->agi_iblocks
field at all? It seems a little odd to have that inobt variant but only
ever account it when finobt is enabled, while it also doesn't appear to
be used. If there are additional implicit benefits in terms of allowing
more fs consistency checks in repair/scrub, then it would seem
beneficial to allow this feature to work with or without finobt. Hm?

> +
>  /*
>   * end of superblock version macros
>   */
> @@ -765,6 +778,9 @@ typedef struct xfs_agi {
>  	__be32		agi_free_root; /* root of the free inode btree */
>  	__be32		agi_free_level;/* levels in free inode btree */
>  
> +	__be32		agi_iblocks;	/* inobt blocks used */
> +	__be32		agi_fblocks;	/* finobt blocks used */
> +
>  	/* structure must be padded to 64 bit alignment */
>  } xfs_agi_t;
>  
> @@ -785,7 +801,8 @@ typedef struct xfs_agi {
>  #define	XFS_AGI_ALL_BITS_R1	((1 << XFS_AGI_NUM_BITS_R1) - 1)
>  #define	XFS_AGI_FREE_ROOT	(1 << 11)
>  #define	XFS_AGI_FREE_LEVEL	(1 << 12)
> -#define	XFS_AGI_NUM_BITS_R2	13
> +#define	XFS_AGI_IBLOCKS		(1 << 13) /* both inobt/finobt block counters */
> +#define	XFS_AGI_NUM_BITS_R2	14
>  
>  /* disk block (xfs_daddr_t) in the AG */
>  #define XFS_AGI_DADDR(mp)	((xfs_daddr_t)(2 << (mp)->m_sectbb_log))
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index f742a96a2fe1..fef1d94c60a4 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2473,6 +2473,7 @@ xfs_ialloc_log_agi(
>  		offsetof(xfs_agi_t, agi_unlinked),
>  		offsetof(xfs_agi_t, agi_free_root),
>  		offsetof(xfs_agi_t, agi_free_level),
> +		offsetof(xfs_agi_t, agi_iblocks),
>  		sizeof(xfs_agi_t)
>  	};
>  #ifdef DEBUG
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 3c8aebc36e64..fc28b38fb463 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -67,6 +67,25 @@ xfs_finobt_set_root(
>  			   XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL);
>  }
>  
> +/* Update the inode btree block counter for this btree. */
> +static inline void
> +xfs_inobt_change_blocks(

Nit, but how about xfs_inobt_mod_blocks() to be consistent with the
transaction accounting helpers?

> +	struct xfs_btree_cur	*cur,
> +	int			howmuch)
> +{
> +	struct xfs_buf		*agbp = cur->bc_ag.agbp;
> +	struct xfs_agi		*agi = agbp->b_addr;
> +
> +	if (!xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb))
> +		return;
> +
> +	if (cur->bc_btnum == XFS_BTNUM_FINO)
> +		be32_add_cpu(&agi->agi_fblocks, howmuch);
> +	else
> +		be32_add_cpu(&agi->agi_iblocks, howmuch);
> +	xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_IBLOCKS);
> +}
> +
>  STATIC int
>  __xfs_inobt_alloc_block(
>  	struct xfs_btree_cur	*cur,
> @@ -102,6 +121,7 @@ __xfs_inobt_alloc_block(
>  
>  	new->s = cpu_to_be32(XFS_FSB_TO_AGBNO(args.mp, args.fsbno));
>  	*stat = 1;
> +	xfs_inobt_change_blocks(cur, 1);
>  	return 0;
>  }
>  
> @@ -122,10 +142,17 @@ xfs_finobt_alloc_block(
>  	union xfs_btree_ptr	*new,
>  	int			*stat)
>  {
> +	int			error;
> +
>  	if (cur->bc_mp->m_finobt_nores)
> -		return xfs_inobt_alloc_block(cur, start, new, stat);
> -	return __xfs_inobt_alloc_block(cur, start, new, stat,
> -			XFS_AG_RESV_METADATA);
> +		error = xfs_inobt_alloc_block(cur, start, new, stat);
> +	else
> +		error = __xfs_inobt_alloc_block(cur, start, new, stat,
> +				XFS_AG_RESV_METADATA);
> +	if (error)
> +		return error;
> +
> +	return 0;

Is there a logic change somewhere in here that I'm missing..? :P

>  }
>  
>  STATIC int
> @@ -134,6 +161,7 @@ __xfs_inobt_free_block(
>  	struct xfs_buf		*bp,
>  	enum xfs_ag_resv_type	resv)
>  {
> +	xfs_inobt_change_blocks(cur, -1);
>  	return xfs_free_extent(cur->bc_tp,
>  			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
>  			&XFS_RMAP_OINFO_INOBT, resv);
> @@ -480,19 +508,29 @@ xfs_inobt_commit_staged_btree(
>  {
>  	struct xfs_agi		*agi = agbp->b_addr;
>  	struct xbtree_afakeroot	*afake = cur->bc_ag.afake;
> +	int			fields;

This (along with a bunch of the changes below) are for scrub, right? I
think that might be better off in a separate patch. In fact, I'd
probably split this up into the following patches: 

1.) new fields + accounting
2.) scrub bits
3.) finobt mount time optimization
3.) enable feature bit

Otherwise the rest mostly looks good to me.

Brian

>  
>  	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
>  
>  	if (cur->bc_btnum == XFS_BTNUM_INO) {
> +		fields = XFS_AGI_ROOT | XFS_AGI_LEVEL;
>  		agi->agi_root = cpu_to_be32(afake->af_root);
>  		agi->agi_level = cpu_to_be32(afake->af_levels);
> -		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_ROOT | XFS_AGI_LEVEL);
> +		if (xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb)) {
> +			agi->agi_iblocks = cpu_to_be32(afake->af_blocks);
> +			fields |= XFS_AGI_IBLOCKS;
> +		}
> +		xfs_ialloc_log_agi(tp, agbp, fields);
>  		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_inobt_ops);
>  	} else {
> +		fields = XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL;
>  		agi->agi_free_root = cpu_to_be32(afake->af_root);
>  		agi->agi_free_level = cpu_to_be32(afake->af_levels);
> -		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREE_ROOT |
> -					     XFS_AGI_FREE_LEVEL);
> +		if (xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb)) {
> +			agi->agi_fblocks = cpu_to_be32(afake->af_blocks);
> +			fields |= XFS_AGI_IBLOCKS;
> +		}
> +		xfs_ialloc_log_agi(tp, agbp, fields);
>  		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_finobt_ops);
>  	}
>  }
> @@ -673,6 +711,28 @@ xfs_inobt_count_blocks(
>  	return error;
>  }
>  
> +/* Read finobt block count from AGI header. */
> +static int
> +xfs_finobt_read_blocks(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	xfs_agnumber_t		agno,
> +	xfs_extlen_t		*tree_blocks)
> +{
> +	struct xfs_buf		*agbp;
> +	struct xfs_agi		*agi;
> +	int			error;
> +
> +	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
> +	if (error)
> +		return error;
> +
> +	agi = agbp->b_addr;
> +	*tree_blocks = be32_to_cpu(agi->agi_fblocks);
> +	xfs_trans_brelse(tp, agbp);
> +	return 0;
> +}
> +
>  /*
>   * Figure out how many blocks to reserve and how many are used by this btree.
>   */
> @@ -690,7 +750,11 @@ xfs_finobt_calc_reserves(
>  	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
>  		return 0;
>  
> -	error = xfs_inobt_count_blocks(mp, tp, agno, XFS_BTNUM_FINO, &tree_len);
> +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
> +		error = xfs_finobt_read_blocks(mp, tp, agno, &tree_len);
> +	else
> +		error = xfs_inobt_count_blocks(mp, tp, agno, XFS_BTNUM_FINO,
> +				&tree_len);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index e9bcf1faa183..ae8e2e0ac64a 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -781,6 +781,35 @@ xchk_agi_xref_icounts(
>  		xchk_block_xref_set_corrupt(sc, sc->sa.agi_bp);
>  }
>  
> +/* Check agi_[fi]blocks against tree size */
> +static inline void
> +xchk_agi_xref_fiblocks(
> +	struct xfs_scrub	*sc)
> +{
> +	struct xfs_agi		*agi = sc->sa.agi_bp->b_addr;
> +	xfs_agblock_t		blocks;
> +	int			error = 0;
> +
> +	if (!xfs_sb_version_hasinobtcounts(&sc->mp->m_sb))
> +		return;
> +
> +	if (sc->sa.ino_cur) {
> +		error = xfs_btree_count_blocks(sc->sa.ino_cur, &blocks);
> +		if (!xchk_should_check_xref(sc, &error, &sc->sa.ino_cur))
> +			return;
> +		if (blocks != be32_to_cpu(agi->agi_iblocks))
> +			xchk_block_xref_set_corrupt(sc, sc->sa.agi_bp);
> +	}
> +
> +	if (sc->sa.fino_cur) {
> +		error = xfs_btree_count_blocks(sc->sa.fino_cur, &blocks);
> +		if (!xchk_should_check_xref(sc, &error, &sc->sa.fino_cur))
> +			return;
> +		if (blocks != be32_to_cpu(agi->agi_fblocks))
> +			xchk_block_xref_set_corrupt(sc, sc->sa.agi_bp);
> +	}
> +}
> +
>  /* Cross-reference with the other btrees. */
>  STATIC void
>  xchk_agi_xref(
> @@ -804,6 +833,7 @@ xchk_agi_xref(
>  	xchk_agi_xref_icounts(sc);
>  	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
>  	xchk_xref_is_not_shared(sc, agbno, 1);
> +	xchk_agi_xref_fiblocks(sc);
>  
>  	/* scrub teardown will take care of sc->sa for us */
>  }
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index bca2ab1d4be9..a85b5bb743f2 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -803,17 +803,34 @@ xrep_agi_calc_from_btrees(
>  	struct xfs_mount	*mp = sc->mp;
>  	xfs_agino_t		count;
>  	xfs_agino_t		freecount;
> +	xfs_agblock_t		blocks;
>  	int			error;
>  
>  	cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp, sc->sa.agno,
>  			XFS_BTNUM_INO);
>  	error = xfs_ialloc_count_inodes(cur, &count, &freecount);
> +	if (error)
> +		goto err;
> +	error = xfs_btree_count_blocks(cur, &blocks);
>  	if (error)
>  		goto err;
>  	xfs_btree_del_cursor(cur, error);
>  
>  	agi->agi_count = cpu_to_be32(count);
>  	agi->agi_freecount = cpu_to_be32(freecount);
> +
> +	/* Update the AGI btree counters. */
> +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> +		agi->agi_iblocks = cpu_to_be32(blocks);
> +
> +		cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp, sc->sa.agno,
> +				XFS_BTNUM_FINO);
> +		if (error)
> +			goto err;
> +		xfs_btree_del_cursor(cur, error);
> +		agi->agi_fblocks = cpu_to_be32(blocks);
> +	}
> +
>  	return 0;
>  err:
>  	xfs_btree_del_cursor(cur, error);
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 5f04d8a5ab2a..acb9b737fe6b 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -23,7 +23,7 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_acl_entry,		12);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_agf,			224);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_agfl,			36);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			336);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			344);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_key,		8);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_rec,		16);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_bmdr_block,		4);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 71ac6c1cdc36..c7ffcb57b586 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1549,6 +1549,10 @@ xfs_fc_fill_super(
>  		goto out_filestream_unmount;
>  	}
>  
> +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
> +		xfs_warn(mp,
> + "EXPERIMENTAL inode btree counters feature in use. Use at your own risk!");
> +
>  	error = xfs_mountfs(mp);
>  	if (error)
>  		goto out_filestream_unmount;
> 

