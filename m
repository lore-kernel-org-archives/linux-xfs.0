Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B76C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 15:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 915422075E
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 15:23:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RoLT3B18"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbgFRPXw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 11:23:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36452 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726905AbgFRPXu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jun 2020 11:23:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592493826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/VA/RqKH23WhmuxaxYi/8bYvpCP/tNYsHRylEEc7ZGM=;
        b=RoLT3B18QCE7iro0PN5jn+FysqxEO6ZMHC6vq/6Nk/aDe0MN4ghjG3xaNTFmrw0irvvRZK
        SZoXU2slGUlRciEb4KLlGNl7wmqlCAXqTx0F3cqWeXaiAGk7muJCooglqA9poNbisdsIoj
        C2vTA9uaJK2G7VEldqF6xlViZ+gKvFc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-sXZxYtSWPNiKB6Sw4eb6uQ-1; Thu, 18 Jun 2020 11:23:44 -0400
X-MC-Unique: sXZxYtSWPNiKB6Sw4eb6uQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2C5A835B58;
        Thu, 18 Jun 2020 15:23:42 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 32A885C1D0;
        Thu, 18 Jun 2020 15:23:42 +0000 (UTC)
Date:   Thu, 18 Jun 2020 11:23:40 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs_repair: rebuild free space btrees with bulk
 loader
Message-ID: <20200618152340.GA32216@bfoster>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
 <159107205826.315004.10575212713029898023.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159107205826.315004.10575212713029898023.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 01, 2020 at 09:27:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the btree bulk loading functions to rebuild the free space btrees
> and drop the open-coded implementation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libxfs/libxfs_api_defs.h |    3 
>  repair/agbtree.c         |  158 ++++++++++
>  repair/agbtree.h         |   10 +
>  repair/phase5.c          |  703 ++++------------------------------------------
>  4 files changed, 236 insertions(+), 638 deletions(-)
> 
> 
...
> diff --git a/repair/agbtree.c b/repair/agbtree.c
> index e4179a44..3b8ab47c 100644
> --- a/repair/agbtree.c
> +++ b/repair/agbtree.c
> @@ -150,3 +150,161 @@ _("Insufficient memory saving lost blocks.\n"));
>  
>  	bulkload_destroy(&btr->newbt, 0);
>  }
...
> +/*
> + * Return the next free space extent tree record from the previous value we
> + * saw.
> + */
> +static inline struct extent_tree_node *
> +get_bno_rec(
> +	struct xfs_btree_cur	*cur,
> +	struct extent_tree_node	*prev_value)
> +{
> +	xfs_agnumber_t		agno = cur->bc_ag.agno;
> +
> +	if (cur->bc_btnum == XFS_BTNUM_BNO) {
> +		if (!prev_value)
> +			return findfirst_bno_extent(agno);
> +		return findnext_bno_extent(prev_value);
> +	}
> +
> +	/* cnt btree */
> +	if (!prev_value)
> +		return findfirst_bcnt_extent(agno);
> +	return findnext_bcnt_extent(agno, prev_value);
> +}
> +
> +/* Grab one bnobt record and put it in the btree cursor. */
> +static int
> +get_bnobt_record(
> +	struct xfs_btree_cur		*cur,
> +	void				*priv)
> +{
> +	struct bt_rebuild		*btr = priv;
> +	struct xfs_alloc_rec_incore	*arec = &cur->bc_rec.a;
> +
> +	btr->bno_rec = get_bno_rec(cur, btr->bno_rec);
> +	arec->ar_startblock = btr->bno_rec->ex_startblock;
> +	arec->ar_blockcount = btr->bno_rec->ex_blockcount;
> +	btr->freeblks += btr->bno_rec->ex_blockcount;
> +	return 0;
> +}

Nit, but the 'bno' naming in the above functions suggest this is bnobt
specific when it actually covers the bnobt and cntbt. Can we call these
something more generic? get_[bt_]record() seems reasonable enough to me
given they're static.

Other than that the factoring looks much nicer and the rest LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +
> +void
> +init_freespace_cursors(
> +	struct repair_ctx	*sc,
> +	xfs_agnumber_t		agno,
> +	unsigned int		free_space,
> +	unsigned int		*nr_extents,
> +	int			*extra_blocks,
> +	struct bt_rebuild	*btr_bno,
> +	struct bt_rebuild	*btr_cnt)
> +{
> +	unsigned int		bno_blocks;
> +	unsigned int		cnt_blocks;
> +	int			error;
> +
> +	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr_bno);
> +	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr_cnt);
> +
> +	btr_bno->cur = libxfs_allocbt_stage_cursor(sc->mp,
> +			&btr_bno->newbt.afake, agno, XFS_BTNUM_BNO);
> +	btr_cnt->cur = libxfs_allocbt_stage_cursor(sc->mp,
> +			&btr_cnt->newbt.afake, agno, XFS_BTNUM_CNT);
> +
> +	btr_bno->bload.get_record = get_bnobt_record;
> +	btr_bno->bload.claim_block = rebuild_claim_block;
> +
> +	btr_cnt->bload.get_record = get_bnobt_record;
> +	btr_cnt->bload.claim_block = rebuild_claim_block;
> +
> +	/*
> +	 * Now we need to allocate blocks for the free space btrees using the
> +	 * free space records we're about to put in them.  Every record we use
> +	 * can change the shape of the free space trees, so we recompute the
> +	 * btree shape until we stop needing /more/ blocks.  If we have any
> +	 * left over we'll stash them in the AGFL when we're done.
> +	 */
> +	do {
> +		unsigned int	num_freeblocks;
> +
> +		bno_blocks = btr_bno->bload.nr_blocks;
> +		cnt_blocks = btr_cnt->bload.nr_blocks;
> +
> +		/* Compute how many bnobt blocks we'll need. */
> +		error = -libxfs_btree_bload_compute_geometry(btr_bno->cur,
> +				&btr_bno->bload, *nr_extents);
> +		if (error)
> +			do_error(
> +_("Unable to compute free space by block btree geometry, error %d.\n"), -error);
> +
> +		/* Compute how many cntbt blocks we'll need. */
> +		error = -libxfs_btree_bload_compute_geometry(btr_cnt->cur,
> +				&btr_cnt->bload, *nr_extents);
> +		if (error)
> +			do_error(
> +_("Unable to compute free space by length btree geometry, error %d.\n"), -error);
> +
> +		/* We don't need any more blocks, so we're done. */
> +		if (bno_blocks >= btr_bno->bload.nr_blocks &&
> +		    cnt_blocks >= btr_cnt->bload.nr_blocks)
> +			break;
> +
> +		/* Allocate however many more blocks we need this time. */
> +		if (bno_blocks < btr_bno->bload.nr_blocks)
> +			reserve_btblocks(sc->mp, agno, btr_bno,
> +					btr_bno->bload.nr_blocks - bno_blocks);
> +		if (cnt_blocks < btr_cnt->bload.nr_blocks)
> +			reserve_btblocks(sc->mp, agno, btr_cnt,
> +					btr_cnt->bload.nr_blocks - cnt_blocks);
> +
> +		/* Ok, now how many free space records do we have? */
> +		*nr_extents = count_bno_extents_blocks(agno, &num_freeblocks);
> +	} while (1);
> +
> +	*extra_blocks = (bno_blocks - btr_bno->bload.nr_blocks) +
> +			(cnt_blocks - btr_cnt->bload.nr_blocks);
> +}
> +
> +/* Rebuild the free space btrees. */
> +void
> +build_freespace_btrees(
> +	struct repair_ctx	*sc,
> +	xfs_agnumber_t		agno,
> +	struct bt_rebuild	*btr_bno,
> +	struct bt_rebuild	*btr_cnt)
> +{
> +	int			error;
> +
> +	/* Add all observed bnobt records. */
> +	error = -libxfs_btree_bload(btr_bno->cur, &btr_bno->bload, btr_bno);
> +	if (error)
> +		do_error(
> +_("Error %d while creating bnobt btree for AG %u.\n"), error, agno);
> +
> +	/* Add all observed cntbt records. */
> +	error = -libxfs_btree_bload(btr_cnt->cur, &btr_cnt->bload, btr_cnt);
> +	if (error)
> +		do_error(
> +_("Error %d while creating cntbt btree for AG %u.\n"), error, agno);
> +
> +	/* Since we're not writing the AGF yet, no need to commit the cursor */
> +	libxfs_btree_del_cursor(btr_bno->cur, 0);
> +	libxfs_btree_del_cursor(btr_cnt->cur, 0);
> +}
> diff --git a/repair/agbtree.h b/repair/agbtree.h
> index 50ea3c60..63352247 100644
> --- a/repair/agbtree.h
> +++ b/repair/agbtree.h
> @@ -20,10 +20,20 @@ struct bt_rebuild {
>  	/* Tree-specific data. */
>  	union {
>  		struct xfs_slab_cursor	*slab_cursor;
> +		struct {
> +			struct extent_tree_node	*bno_rec;
> +			unsigned int		freeblks;
> +		};
>  	};
>  };
>  
>  void finish_rebuild(struct xfs_mount *mp, struct bt_rebuild *btr,
>  		struct xfs_slab *lost_fsb);
> +void init_freespace_cursors(struct repair_ctx *sc, xfs_agnumber_t agno,
> +		unsigned int free_space, unsigned int *nr_extents,
> +		int *extra_blocks, struct bt_rebuild *btr_bno,
> +		struct bt_rebuild *btr_cnt);
> +void build_freespace_btrees(struct repair_ctx *sc, xfs_agnumber_t agno,
> +		struct bt_rebuild *btr_bno, struct bt_rebuild *btr_cnt);
>  
>  #endif /* __XFS_REPAIR_AG_BTREE_H__ */
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 8175aa6f..a93d900d 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -81,7 +81,10 @@ static uint64_t	*sb_ifree_ag;		/* free inodes per ag */
>  static uint64_t	*sb_fdblocks_ag;	/* free data blocks per ag */
>  
>  static int
> -mk_incore_fstree(xfs_mount_t *mp, xfs_agnumber_t agno)
> +mk_incore_fstree(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	unsigned int		*num_freeblocks)
>  {
>  	int			in_extent;
>  	int			num_extents;
> @@ -93,6 +96,8 @@ mk_incore_fstree(xfs_mount_t *mp, xfs_agnumber_t agno)
>  	xfs_extlen_t		blen;
>  	int			bstate;
>  
> +	*num_freeblocks = 0;
> +
>  	/*
>  	 * scan the bitmap for the ag looking for continuous
>  	 * extents of free blocks.  At this point, we know
> @@ -148,6 +153,7 @@ mk_incore_fstree(xfs_mount_t *mp, xfs_agnumber_t agno)
>  #endif
>  				add_bno_extent(agno, extent_start, extent_len);
>  				add_bcnt_extent(agno, extent_start, extent_len);
> +				*num_freeblocks += extent_len;
>  			}
>  		}
>  	}
> @@ -161,6 +167,7 @@ mk_incore_fstree(xfs_mount_t *mp, xfs_agnumber_t agno)
>  #endif
>  		add_bno_extent(agno, extent_start, extent_len);
>  		add_bcnt_extent(agno, extent_start, extent_len);
> +		*num_freeblocks += extent_len;
>  	}
>  
>  	return(num_extents);
> @@ -338,287 +345,6 @@ finish_cursor(bt_status_t *curs)
>  	free(curs->btree_blocks);
>  }
>  
> -/*
> - * We need to leave some free records in the tree for the corner case of
> - * setting up the AGFL. This may require allocation of blocks, and as
> - * such can require insertion of new records into the tree (e.g. moving
> - * a record in the by-count tree when a long extent is shortened). If we
> - * pack the records into the leaves with no slack space, this requires a
> - * leaf split to occur and a block to be allocated from the free list.
> - * If we don't have any blocks on the free list (because we are setting
> - * it up!), then we fail, and the filesystem will fail with the same
> - * failure at runtime. Hence leave a couple of records slack space in
> - * each block to allow immediate modification of the tree without
> - * requiring splits to be done.
> - *
> - * XXX(hch): any reason we don't just look at mp->m_alloc_mxr?
> - */
> -#define XR_ALLOC_BLOCK_MAXRECS(mp, level) \
> -	(libxfs_allocbt_maxrecs((mp), (mp)->m_sb.sb_blocksize, (level) == 0) - 2)
> -
> -/*
> - * this calculates a freespace cursor for an ag.
> - * btree_curs is an in/out.  returns the number of
> - * blocks that will show up in the AGFL.
> - */
> -static int
> -calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
> -			xfs_agblock_t *extents, bt_status_t *btree_curs)
> -{
> -	xfs_extlen_t		blocks_needed;		/* a running count */
> -	xfs_extlen_t		blocks_allocated_pt;	/* per tree */
> -	xfs_extlen_t		blocks_allocated_total;	/* for both trees */
> -	xfs_agblock_t		num_extents;
> -	int			i;
> -	int			extents_used;
> -	int			extra_blocks;
> -	bt_stat_level_t		*lptr;
> -	bt_stat_level_t		*p_lptr;
> -	extent_tree_node_t	*ext_ptr;
> -	int			level;
> -
> -	num_extents = *extents;
> -	extents_used = 0;
> -
> -	ASSERT(num_extents != 0);
> -
> -	lptr = &btree_curs->level[0];
> -	btree_curs->init = 1;
> -
> -	/*
> -	 * figure out how much space we need for the leaf level
> -	 * of the tree and set up the cursor for the leaf level
> -	 * (note that the same code is duplicated further down)
> -	 */
> -	lptr->num_blocks = howmany(num_extents, XR_ALLOC_BLOCK_MAXRECS(mp, 0));
> -	lptr->num_recs_pb = num_extents / lptr->num_blocks;
> -	lptr->modulo = num_extents % lptr->num_blocks;
> -	lptr->num_recs_tot = num_extents;
> -	level = 1;
> -
> -#ifdef XR_BLD_FREE_TRACE
> -	fprintf(stderr, "%s 0 %d %d %d %d\n", __func__,
> -			lptr->num_blocks,
> -			lptr->num_recs_pb,
> -			lptr->modulo,
> -			lptr->num_recs_tot);
> -#endif
> -	/*
> -	 * if we need more levels, set them up.  # of records
> -	 * per level is the # of blocks in the level below it
> -	 */
> -	if (lptr->num_blocks > 1)  {
> -		for (; btree_curs->level[level - 1].num_blocks > 1
> -				&& level < XFS_BTREE_MAXLEVELS;
> -				level++)  {
> -			lptr = &btree_curs->level[level];
> -			p_lptr = &btree_curs->level[level - 1];
> -			lptr->num_blocks = howmany(p_lptr->num_blocks,
> -					XR_ALLOC_BLOCK_MAXRECS(mp, level));
> -			lptr->modulo = p_lptr->num_blocks
> -					% lptr->num_blocks;
> -			lptr->num_recs_pb = p_lptr->num_blocks
> -					/ lptr->num_blocks;
> -			lptr->num_recs_tot = p_lptr->num_blocks;
> -#ifdef XR_BLD_FREE_TRACE
> -			fprintf(stderr, "%s %d %d %d %d %d\n", __func__,
> -					level,
> -					lptr->num_blocks,
> -					lptr->num_recs_pb,
> -					lptr->modulo,
> -					lptr->num_recs_tot);
> -#endif
> -		}
> -	}
> -
> -	ASSERT(lptr->num_blocks == 1);
> -	btree_curs->num_levels = level;
> -
> -	/*
> -	 * ok, now we have a hypothetical cursor that
> -	 * will work for both the bno and bcnt trees.
> -	 * now figure out if using up blocks to set up the
> -	 * trees will perturb the shape of the freespace tree.
> -	 * if so, we've over-allocated.  the freespace trees
> -	 * as they will be *after* accounting for the free space
> -	 * we've used up will need fewer blocks to to represent
> -	 * than we've allocated.  We can use the AGFL to hold
> -	 * xfs_agfl_size (sector/struct xfs_agfl) blocks but that's it.
> -	 * Thus we limit things to xfs_agfl_size/2 for each of the 2 btrees.
> -	 * if the number of extra blocks is more than that,
> -	 * we'll have to be called again.
> -	 */
> -	for (blocks_needed = 0, i = 0; i < level; i++)  {
> -		blocks_needed += btree_curs->level[i].num_blocks;
> -	}
> -
> -	/*
> -	 * record the # of blocks we've allocated
> -	 */
> -	blocks_allocated_pt = blocks_needed;
> -	blocks_needed *= 2;
> -	blocks_allocated_total = blocks_needed;
> -
> -	/*
> -	 * figure out how many free extents will be used up by
> -	 * our space allocation
> -	 */
> -	if ((ext_ptr = findfirst_bcnt_extent(agno)) == NULL)
> -		do_error(_("can't rebuild fs trees -- not enough free space "
> -			   "on ag %u\n"), agno);
> -
> -	while (ext_ptr != NULL && blocks_needed > 0)  {
> -		if (ext_ptr->ex_blockcount <= blocks_needed)  {
> -			blocks_needed -= ext_ptr->ex_blockcount;
> -			extents_used++;
> -		} else  {
> -			blocks_needed = 0;
> -		}
> -
> -		ext_ptr = findnext_bcnt_extent(agno, ext_ptr);
> -
> -#ifdef XR_BLD_FREE_TRACE
> -		if (ext_ptr != NULL)  {
> -			fprintf(stderr, "got next extent [%u %u]\n",
> -				ext_ptr->ex_startblock, ext_ptr->ex_blockcount);
> -		} else  {
> -			fprintf(stderr, "out of extents\n");
> -		}
> -#endif
> -	}
> -	if (blocks_needed > 0)
> -		do_error(_("ag %u - not enough free space to build freespace "
> -			   "btrees\n"), agno);
> -
> -	ASSERT(num_extents >= extents_used);
> -
> -	num_extents -= extents_used;
> -
> -	/*
> -	 * see if the number of leaf blocks will change as a result
> -	 * of the number of extents changing
> -	 */
> -	if (howmany(num_extents, XR_ALLOC_BLOCK_MAXRECS(mp, 0))
> -			!= btree_curs->level[0].num_blocks)  {
> -		/*
> -		 * yes -- recalculate the cursor.  If the number of
> -		 * excess (overallocated) blocks is < xfs_agfl_size/2, we're ok.
> -		 * we can put those into the AGFL.  we don't try
> -		 * and get things to converge exactly (reach a
> -		 * state with zero excess blocks) because there
> -		 * exist pathological cases which will never
> -		 * converge.  first, check for the zero-case.
> -		 */
> -		if (num_extents == 0)  {
> -			/*
> -			 * ok, we've used up all the free blocks
> -			 * trying to lay out the leaf level. go
> -			 * to a one block (empty) btree and put the
> -			 * already allocated blocks into the AGFL
> -			 */
> -			if (btree_curs->level[0].num_blocks != 1)  {
> -				/*
> -				 * we really needed more blocks because
> -				 * the old tree had more than one level.
> -				 * this is bad.
> -				 */
> -				 do_warn(_("not enough free blocks left to "
> -					   "describe all free blocks in AG "
> -					   "%u\n"), agno);
> -			}
> -#ifdef XR_BLD_FREE_TRACE
> -			fprintf(stderr,
> -				"ag %u -- no free extents, alloc'ed %d\n",
> -				agno, blocks_allocated_pt);
> -#endif
> -			lptr->num_blocks = 1;
> -			lptr->modulo = 0;
> -			lptr->num_recs_pb = 0;
> -			lptr->num_recs_tot = 0;
> -
> -			btree_curs->num_levels = 1;
> -
> -			/*
> -			 * don't reset the allocation stats, assume
> -			 * they're all extra blocks
> -			 * don't forget to return the total block count
> -			 * not the per-tree block count.  these are the
> -			 * extras that will go into the AGFL.  subtract
> -			 * two for the root blocks.
> -			 */
> -			btree_curs->num_tot_blocks = blocks_allocated_pt;
> -			btree_curs->num_free_blocks = blocks_allocated_pt;
> -
> -			*extents = 0;
> -
> -			return(blocks_allocated_total - 2);
> -		}
> -
> -		lptr = &btree_curs->level[0];
> -		lptr->num_blocks = howmany(num_extents,
> -					XR_ALLOC_BLOCK_MAXRECS(mp, 0));
> -		lptr->num_recs_pb = num_extents / lptr->num_blocks;
> -		lptr->modulo = num_extents % lptr->num_blocks;
> -		lptr->num_recs_tot = num_extents;
> -		level = 1;
> -
> -		/*
> -		 * if we need more levels, set them up
> -		 */
> -		if (lptr->num_blocks > 1)  {
> -			for (level = 1; btree_curs->level[level-1].num_blocks
> -					> 1 && level < XFS_BTREE_MAXLEVELS;
> -					level++)  {
> -				lptr = &btree_curs->level[level];
> -				p_lptr = &btree_curs->level[level-1];
> -				lptr->num_blocks = howmany(p_lptr->num_blocks,
> -					XR_ALLOC_BLOCK_MAXRECS(mp, level));
> -				lptr->modulo = p_lptr->num_blocks
> -						% lptr->num_blocks;
> -				lptr->num_recs_pb = p_lptr->num_blocks
> -						/ lptr->num_blocks;
> -				lptr->num_recs_tot = p_lptr->num_blocks;
> -			}
> -		}
> -		ASSERT(lptr->num_blocks == 1);
> -		btree_curs->num_levels = level;
> -
> -		/*
> -		 * now figure out the number of excess blocks
> -		 */
> -		for (blocks_needed = 0, i = 0; i < level; i++)  {
> -			blocks_needed += btree_curs->level[i].num_blocks;
> -		}
> -		blocks_needed *= 2;
> -
> -		ASSERT(blocks_allocated_total >= blocks_needed);
> -		extra_blocks = blocks_allocated_total - blocks_needed;
> -	} else  {
> -		if (extents_used > 0) {
> -			/*
> -			 * reset the leaf level geometry to account
> -			 * for consumed extents.  we can leave the
> -			 * rest of the cursor alone since the number
> -			 * of leaf blocks hasn't changed.
> -			 */
> -			lptr = &btree_curs->level[0];
> -
> -			lptr->num_recs_pb = num_extents / lptr->num_blocks;
> -			lptr->modulo = num_extents % lptr->num_blocks;
> -			lptr->num_recs_tot = num_extents;
> -		}
> -
> -		extra_blocks = 0;
> -	}
> -
> -	btree_curs->num_tot_blocks = blocks_allocated_pt;
> -	btree_curs->num_free_blocks = blocks_allocated_pt;
> -
> -	*extents = num_extents;
> -
> -	return(extra_blocks);
> -}
> -
>  /* Map btnum to buffer ops for the types that need it. */
>  static const struct xfs_buf_ops *
>  btnum_to_ops(
> @@ -643,270 +369,6 @@ btnum_to_ops(
>  	}
>  }
>  
> -static void
> -prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
> -		bt_status_t *btree_curs, xfs_agblock_t startblock,
> -		xfs_extlen_t blockcount, int level, xfs_btnum_t btnum)
> -{
> -	struct xfs_btree_block	*bt_hdr;
> -	xfs_alloc_key_t		*bt_key;
> -	xfs_alloc_ptr_t		*bt_ptr;
> -	xfs_agblock_t		agbno;
> -	bt_stat_level_t		*lptr;
> -	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
> -	int			error;
> -
> -	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
> -
> -	level++;
> -
> -	if (level >= btree_curs->num_levels)
> -		return;
> -
> -	lptr = &btree_curs->level[level];
> -	bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
> -
> -	if (be16_to_cpu(bt_hdr->bb_numrecs) == 0)  {
> -		/*
> -		 * only happens once when initializing the
> -		 * left-hand side of the tree.
> -		 */
> -		prop_freespace_cursor(mp, agno, btree_curs, startblock,
> -				blockcount, level, btnum);
> -	}
> -
> -	if (be16_to_cpu(bt_hdr->bb_numrecs) ==
> -				lptr->num_recs_pb + (lptr->modulo > 0))  {
> -		/*
> -		 * write out current prev block, grab us a new block,
> -		 * and set the rightsib pointer of current block
> -		 */
> -#ifdef XR_BLD_FREE_TRACE
> -		fprintf(stderr, " %d ", lptr->prev_agbno);
> -#endif
> -		if (lptr->prev_agbno != NULLAGBLOCK) {
> -			ASSERT(lptr->prev_buf_p != NULL);
> -			libxfs_buf_mark_dirty(lptr->prev_buf_p);
> -			libxfs_buf_relse(lptr->prev_buf_p);
> -		}
> -		lptr->prev_agbno = lptr->agbno;;
> -		lptr->prev_buf_p = lptr->buf_p;
> -		agbno = get_next_blockaddr(agno, level, btree_curs);
> -
> -		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
> -
> -		error = -libxfs_buf_get(mp->m_dev,
> -				XFS_AGB_TO_DADDR(mp, agno, agbno),
> -				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
> -		if (error)
> -			do_error(
> -	_("Cannot grab free space btree buffer, err=%d"),
> -					error);
> -		lptr->agbno = agbno;
> -
> -		if (lptr->modulo)
> -			lptr->modulo--;
> -
> -		/*
> -		 * initialize block header
> -		 */
> -		lptr->buf_p->b_ops = ops;
> -		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
> -		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
> -		libxfs_btree_init_block(mp, lptr->buf_p, btnum, level,
> -					0, agno);
> -
> -		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
> -
> -		/*
> -		 * propagate extent record for first extent in new block up
> -		 */
> -		prop_freespace_cursor(mp, agno, btree_curs, startblock,
> -				blockcount, level, btnum);
> -	}
> -	/*
> -	 * add extent info to current block
> -	 */
> -	be16_add_cpu(&bt_hdr->bb_numrecs, 1);
> -
> -	bt_key = XFS_ALLOC_KEY_ADDR(mp, bt_hdr,
> -				be16_to_cpu(bt_hdr->bb_numrecs));
> -	bt_ptr = XFS_ALLOC_PTR_ADDR(mp, bt_hdr,
> -				be16_to_cpu(bt_hdr->bb_numrecs),
> -				mp->m_alloc_mxr[1]);
> -
> -	bt_key->ar_startblock = cpu_to_be32(startblock);
> -	bt_key->ar_blockcount = cpu_to_be32(blockcount);
> -	*bt_ptr = cpu_to_be32(btree_curs->level[level-1].agbno);
> -}
> -
> -/*
> - * rebuilds a freespace tree given a cursor and type
> - * of tree to build (bno or bcnt).  returns the number of free blocks
> - * represented by the tree.
> - */
> -static xfs_extlen_t
> -build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
> -		bt_status_t *btree_curs, xfs_btnum_t btnum)
> -{
> -	xfs_agnumber_t		i;
> -	xfs_agblock_t		j;
> -	struct xfs_btree_block	*bt_hdr;
> -	xfs_alloc_rec_t		*bt_rec;
> -	int			level;
> -	xfs_agblock_t		agbno;
> -	extent_tree_node_t	*ext_ptr;
> -	bt_stat_level_t		*lptr;
> -	xfs_extlen_t		freeblks;
> -	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
> -	int			error;
> -
> -	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
> -
> -#ifdef XR_BLD_FREE_TRACE
> -	fprintf(stderr, "in build_freespace_tree, agno = %d\n", agno);
> -#endif
> -	level = btree_curs->num_levels;
> -	freeblks = 0;
> -
> -	ASSERT(level > 0);
> -
> -	/*
> -	 * initialize the first block on each btree level
> -	 */
> -	for (i = 0; i < level; i++)  {
> -		lptr = &btree_curs->level[i];
> -
> -		agbno = get_next_blockaddr(agno, i, btree_curs);
> -		error = -libxfs_buf_get(mp->m_dev,
> -				XFS_AGB_TO_DADDR(mp, agno, agbno),
> -				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
> -		if (error)
> -			do_error(
> -	_("Cannot grab free space btree buffer, err=%d"),
> -					error);
> -
> -		if (i == btree_curs->num_levels - 1)
> -			btree_curs->root = agbno;
> -
> -		lptr->agbno = agbno;
> -		lptr->prev_agbno = NULLAGBLOCK;
> -		lptr->prev_buf_p = NULL;
> -		/*
> -		 * initialize block header
> -		 */
> -		lptr->buf_p->b_ops = ops;
> -		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
> -		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
> -		libxfs_btree_init_block(mp, lptr->buf_p, btnum, i, 0, agno);
> -	}
> -	/*
> -	 * run along leaf, setting up records.  as we have to switch
> -	 * blocks, call the prop_freespace_cursor routine to set up the new
> -	 * pointers for the parent.  that can recurse up to the root
> -	 * if required.  set the sibling pointers for leaf level here.
> -	 */
> -	if (btnum == XFS_BTNUM_BNO)
> -		ext_ptr = findfirst_bno_extent(agno);
> -	else
> -		ext_ptr = findfirst_bcnt_extent(agno);
> -
> -#ifdef XR_BLD_FREE_TRACE
> -	fprintf(stderr, "bft, agno = %d, start = %u, count = %u\n",
> -		agno, ext_ptr->ex_startblock, ext_ptr->ex_blockcount);
> -#endif
> -
> -	lptr = &btree_curs->level[0];
> -
> -	for (i = 0; i < btree_curs->level[0].num_blocks; i++)  {
> -		/*
> -		 * block initialization, lay in block header
> -		 */
> -		lptr->buf_p->b_ops = ops;
> -		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
> -		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
> -		libxfs_btree_init_block(mp, lptr->buf_p, btnum, 0, 0, agno);
> -
> -		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
> -		bt_hdr->bb_numrecs = cpu_to_be16(lptr->num_recs_pb +
> -							(lptr->modulo > 0));
> -#ifdef XR_BLD_FREE_TRACE
> -		fprintf(stderr, "bft, bb_numrecs = %d\n",
> -				be16_to_cpu(bt_hdr->bb_numrecs));
> -#endif
> -
> -		if (lptr->modulo > 0)
> -			lptr->modulo--;
> -
> -		/*
> -		 * initialize values in the path up to the root if
> -		 * this is a multi-level btree
> -		 */
> -		if (btree_curs->num_levels > 1)
> -			prop_freespace_cursor(mp, agno, btree_curs,
> -					ext_ptr->ex_startblock,
> -					ext_ptr->ex_blockcount,
> -					0, btnum);
> -
> -		bt_rec = (xfs_alloc_rec_t *)
> -			  ((char *)bt_hdr + XFS_ALLOC_BLOCK_LEN(mp));
> -		for (j = 0; j < be16_to_cpu(bt_hdr->bb_numrecs); j++) {
> -			ASSERT(ext_ptr != NULL);
> -			bt_rec[j].ar_startblock = cpu_to_be32(
> -							ext_ptr->ex_startblock);
> -			bt_rec[j].ar_blockcount = cpu_to_be32(
> -							ext_ptr->ex_blockcount);
> -			freeblks += ext_ptr->ex_blockcount;
> -			if (btnum == XFS_BTNUM_BNO)
> -				ext_ptr = findnext_bno_extent(ext_ptr);
> -			else
> -				ext_ptr = findnext_bcnt_extent(agno, ext_ptr);
> -#if 0
> -#ifdef XR_BLD_FREE_TRACE
> -			if (ext_ptr == NULL)
> -				fprintf(stderr, "null extent pointer, j = %d\n",
> -					j);
> -			else
> -				fprintf(stderr,
> -				"bft, agno = %d, start = %u, count = %u\n",
> -					agno, ext_ptr->ex_startblock,
> -					ext_ptr->ex_blockcount);
> -#endif
> -#endif
> -		}
> -
> -		if (ext_ptr != NULL)  {
> -			/*
> -			 * get next leaf level block
> -			 */
> -			if (lptr->prev_buf_p != NULL)  {
> -#ifdef XR_BLD_FREE_TRACE
> -				fprintf(stderr, " writing fst agbno %u\n",
> -					lptr->prev_agbno);
> -#endif
> -				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
> -				libxfs_buf_mark_dirty(lptr->prev_buf_p);
> -				libxfs_buf_relse(lptr->prev_buf_p);
> -			}
> -			lptr->prev_buf_p = lptr->buf_p;
> -			lptr->prev_agbno = lptr->agbno;
> -			lptr->agbno = get_next_blockaddr(agno, 0, btree_curs);
> -			bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(lptr->agbno);
> -
> -			error = -libxfs_buf_get(mp->m_dev,
> -					XFS_AGB_TO_DADDR(mp, agno, lptr->agbno),
> -					XFS_FSB_TO_BB(mp, 1),
> -					&lptr->buf_p);
> -			if (error)
> -				do_error(
> -	_("Cannot grab free space btree buffer, err=%d"),
> -						error);
> -		}
> -	}
> -
> -	return(freeblks);
> -}
> -
>  /*
>   * XXX(hch): any reason we don't just look at mp->m_inobt_mxr?
>   */
> @@ -2038,6 +1500,28 @@ _("Insufficient memory to construct refcount cursor."));
>  	free_slab_cursor(&refc_cur);
>  }
>  
> +/* Fill the AGFL with any leftover bnobt rebuilder blocks. */
> +static void
> +fill_agfl(
> +	struct bt_rebuild	*btr,
> +	__be32			*agfl_bnos,
> +	unsigned int		*agfl_idx)
> +{
> +	struct bulkload_resv	*resv, *n;
> +	struct xfs_mount	*mp = btr->newbt.sc->mp;
> +
> +	for_each_bulkload_reservation(&btr->newbt, resv, n) {
> +		xfs_agblock_t	bno;
> +
> +		bno = XFS_FSB_TO_AGBNO(mp, resv->fsbno + resv->used);
> +		while (resv->used < resv->len &&
> +		       *agfl_idx < libxfs_agfl_size(mp)) {
> +			agfl_bnos[(*agfl_idx)++] = cpu_to_be32(bno++);
> +			resv->used++;
> +		}
> +	}
> +}
> +
>  /*
>   * build both the agf and the agfl for an agno given both
>   * btree cursors.
> @@ -2048,9 +1532,8 @@ static void
>  build_agf_agfl(
>  	struct xfs_mount	*mp,
>  	xfs_agnumber_t		agno,
> -	struct bt_status	*bno_bt,
> -	struct bt_status	*bcnt_bt,
> -	xfs_extlen_t		freeblks,	/* # free blocks in tree */
> +	struct bt_rebuild	*btr_bno,
> +	struct bt_rebuild	*btr_cnt,
>  	struct bt_status	*rmap_bt,
>  	struct bt_status	*refcnt_bt,
>  	struct xfs_slab		*lost_fsb)
> @@ -2060,7 +1543,6 @@ build_agf_agfl(
>  	unsigned int		agfl_idx;
>  	struct xfs_agfl		*agfl;
>  	struct xfs_agf		*agf;
> -	xfs_fsblock_t		fsb;
>  	__be32			*freelist;
>  	int			error;
>  
> @@ -2092,13 +1574,17 @@ build_agf_agfl(
>  		agf->agf_length = cpu_to_be32(mp->m_sb.sb_dblocks -
>  			(xfs_rfsblock_t) mp->m_sb.sb_agblocks * agno);
>  
> -	agf->agf_roots[XFS_BTNUM_BNO] = cpu_to_be32(bno_bt->root);
> -	agf->agf_levels[XFS_BTNUM_BNO] = cpu_to_be32(bno_bt->num_levels);
> -	agf->agf_roots[XFS_BTNUM_CNT] = cpu_to_be32(bcnt_bt->root);
> -	agf->agf_levels[XFS_BTNUM_CNT] = cpu_to_be32(bcnt_bt->num_levels);
> +	agf->agf_roots[XFS_BTNUM_BNO] =
> +			cpu_to_be32(btr_bno->newbt.afake.af_root);
> +	agf->agf_levels[XFS_BTNUM_BNO] =
> +			cpu_to_be32(btr_bno->newbt.afake.af_levels);
> +	agf->agf_roots[XFS_BTNUM_CNT] =
> +			cpu_to_be32(btr_cnt->newbt.afake.af_root);
> +	agf->agf_levels[XFS_BTNUM_CNT] =
> +			cpu_to_be32(btr_cnt->newbt.afake.af_levels);
>  	agf->agf_roots[XFS_BTNUM_RMAP] = cpu_to_be32(rmap_bt->root);
>  	agf->agf_levels[XFS_BTNUM_RMAP] = cpu_to_be32(rmap_bt->num_levels);
> -	agf->agf_freeblks = cpu_to_be32(freeblks);
> +	agf->agf_freeblks = cpu_to_be32(btr_bno->freeblks);
>  	agf->agf_rmap_blocks = cpu_to_be32(rmap_bt->num_tot_blocks -
>  			rmap_bt->num_free_blocks);
>  	agf->agf_refcount_root = cpu_to_be32(refcnt_bt->root);
> @@ -2115,9 +1601,8 @@ build_agf_agfl(
>  		 * Don't count the root blocks as they are already
>  		 * accounted for.
>  		 */
> -		blks = (bno_bt->num_tot_blocks - bno_bt->num_free_blocks) +
> -			(bcnt_bt->num_tot_blocks - bcnt_bt->num_free_blocks) -
> -			2;
> +		blks = btr_bno->newbt.afake.af_blocks +
> +			btr_cnt->newbt.afake.af_blocks - 2;
>  		if (xfs_sb_version_hasrmapbt(&mp->m_sb))
>  			blks += rmap_bt->num_tot_blocks - rmap_bt->num_free_blocks - 1;
>  		agf->agf_btreeblks = cpu_to_be32(blks);
> @@ -2159,50 +1644,14 @@ build_agf_agfl(
>  			freelist[agfl_idx] = cpu_to_be32(NULLAGBLOCK);
>  	}
>  
> -	/*
> -	 * do we have left-over blocks in the btree cursors that should
> -	 * be used to fill the AGFL?
> -	 */
> -	if (bno_bt->num_free_blocks > 0 || bcnt_bt->num_free_blocks > 0)  {
> -		/*
> -		 * yes, now grab as many blocks as we can
> -		 */
> -		agfl_idx = 0;
> -		while (bno_bt->num_free_blocks > 0 &&
> -		       agfl_idx < libxfs_agfl_size(mp))
> -		{
> -			freelist[agfl_idx] = cpu_to_be32(
> -					get_next_blockaddr(agno, 0, bno_bt));
> -			agfl_idx++;
> -		}
> -
> -		while (bcnt_bt->num_free_blocks > 0 &&
> -		       agfl_idx < libxfs_agfl_size(mp))
> -		{
> -			freelist[agfl_idx] = cpu_to_be32(
> -					get_next_blockaddr(agno, 0, bcnt_bt));
> -			agfl_idx++;
> -		}
> -		/*
> -		 * now throw the rest of the blocks away and complain
> -		 */
> -		while (bno_bt->num_free_blocks > 0) {
> -			fsb = XFS_AGB_TO_FSB(mp, agno,
> -					get_next_blockaddr(agno, 0, bno_bt));
> -			error = slab_add(lost_fsb, &fsb);
> -			if (error)
> -				do_error(
> -_("Insufficient memory saving lost blocks.\n"));
> -		}
> -		while (bcnt_bt->num_free_blocks > 0) {
> -			fsb = XFS_AGB_TO_FSB(mp, agno,
> -					get_next_blockaddr(agno, 0, bcnt_bt));
> -			error = slab_add(lost_fsb, &fsb);
> -			if (error)
> -				do_error(
> -_("Insufficient memory saving lost blocks.\n"));
> -		}
> +	/* Fill the AGFL with leftover blocks or save them for later. */
> +	agfl_idx = 0;
> +	freelist = xfs_buf_to_agfl_bno(agfl_buf);
> +	fill_agfl(btr_bno, freelist, &agfl_idx);
> +	fill_agfl(btr_cnt, freelist, &agfl_idx);
>  
> +	/* Set the AGF counters for the AGFL. */
> +	if (agfl_idx > 0) {
>  		agf->agf_flfirst = 0;
>  		agf->agf_fllast = cpu_to_be32(agfl_idx - 1);
>  		agf->agf_flcount = cpu_to_be32(agfl_idx);
> @@ -2300,18 +1749,14 @@ phase5_func(
>  	uint64_t		num_free_inos;
>  	uint64_t		finobt_num_inos;
>  	uint64_t		finobt_num_free_inos;
> -	bt_status_t		bno_btree_curs;
> -	bt_status_t		bcnt_btree_curs;
> +	struct bt_rebuild	btr_bno;
> +	struct bt_rebuild	btr_cnt;
>  	bt_status_t		ino_btree_curs;
>  	bt_status_t		fino_btree_curs;
>  	bt_status_t		rmap_btree_curs;
>  	bt_status_t		refcnt_btree_curs;
>  	int			extra_blocks = 0;
>  	uint			num_freeblocks;
> -	xfs_extlen_t		freeblks1;
> -#ifdef DEBUG
> -	xfs_extlen_t		freeblks2;
> -#endif
>  	xfs_agblock_t		num_extents;
>  
>  	if (verbose)
> @@ -2320,7 +1765,7 @@ phase5_func(
>  	/*
>  	 * build up incore bno and bcnt extent btrees
>  	 */
> -	num_extents = mk_incore_fstree(mp, agno);
> +	num_extents = mk_incore_fstree(mp, agno, &num_freeblocks);
>  
>  #ifdef XR_BLD_FREE_TRACE
>  	fprintf(stderr, "# of bno extents is %d\n", count_bno_extents(agno));
> @@ -2392,8 +1837,8 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  	/*
>  	 * track blocks that we might really lose
>  	 */
> -	extra_blocks = calculate_freespace_cursor(mp, agno,
> -				&num_extents, &bno_btree_curs);
> +	init_freespace_cursors(&sc, agno, num_freeblocks, &num_extents,
> +			&extra_blocks, &btr_bno, &btr_cnt);
>  
>  	/*
>  	 * freespace btrees live in the "free space" but the filesystem treats
> @@ -2410,37 +1855,18 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  	if (extra_blocks > 0)
>  		sb_fdblocks_ag[agno] -= extra_blocks;
>  
> -	bcnt_btree_curs = bno_btree_curs;
> -
> -	bno_btree_curs.owner = XFS_RMAP_OWN_AG;
> -	bcnt_btree_curs.owner = XFS_RMAP_OWN_AG;
> -	setup_cursor(mp, agno, &bno_btree_curs);
> -	setup_cursor(mp, agno, &bcnt_btree_curs);
> -
>  #ifdef XR_BLD_FREE_TRACE
>  	fprintf(stderr, "# of bno extents is %d\n", count_bno_extents(agno));
>  	fprintf(stderr, "# of bcnt extents is %d\n", count_bcnt_extents(agno));
>  #endif
>  
> -	/*
> -	 * now rebuild the freespace trees
> -	 */
> -	freeblks1 = build_freespace_tree(mp, agno,
> -					&bno_btree_curs, XFS_BTNUM_BNO);
> +	build_freespace_btrees(&sc, agno, &btr_bno, &btr_cnt);
> +
>  #ifdef XR_BLD_FREE_TRACE
> -	fprintf(stderr, "# of free blocks == %d\n", freeblks1);
> +	fprintf(stderr, "# of free blocks == %d/%d\n", btr_bno.freeblks,
> +			btr_cnt.freeblks);
>  #endif
> -	write_cursor(&bno_btree_curs);
> -
> -#ifdef DEBUG
> -	freeblks2 = build_freespace_tree(mp, agno,
> -				&bcnt_btree_curs, XFS_BTNUM_CNT);
> -#else
> -	(void) build_freespace_tree(mp, agno, &bcnt_btree_curs, XFS_BTNUM_CNT);
> -#endif
> -	write_cursor(&bcnt_btree_curs);
> -
> -	ASSERT(freeblks1 == freeblks2);
> +	ASSERT(btr_bno.freeblks == btr_cnt.freeblks);
>  
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
>  		build_rmap_tree(mp, agno, &rmap_btree_curs);
> @@ -2457,8 +1883,9 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  	/*
>  	 * set up agf and agfl
>  	 */
> -	build_agf_agfl(mp, agno, &bno_btree_curs, &bcnt_btree_curs, freeblks1,
> -			&rmap_btree_curs, &refcnt_btree_curs, lost_fsb);
> +	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, &rmap_btree_curs,
> +			&refcnt_btree_curs, lost_fsb);
> +
>  	/*
>  	 * build inode allocation tree.
>  	 */
> @@ -2480,7 +1907,8 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  	/*
>  	 * tear down cursors
>  	 */
> -	finish_cursor(&bno_btree_curs);
> +	finish_rebuild(mp, &btr_bno, lost_fsb);
> +	finish_rebuild(mp, &btr_cnt, lost_fsb);
>  	finish_cursor(&ino_btree_curs);
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
>  		finish_cursor(&rmap_btree_curs);
> @@ -2488,7 +1916,6 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  		finish_cursor(&refcnt_btree_curs);
>  	if (xfs_sb_version_hasfinobt(&mp->m_sb))
>  		finish_cursor(&fino_btree_curs);
> -	finish_cursor(&bcnt_btree_curs);
>  
>  	/*
>  	 * release the incore per-AG bno/bcnt trees so the extent nodes
> 

