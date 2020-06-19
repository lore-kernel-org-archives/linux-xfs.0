Return-Path: <SRS0=O+9a=AA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D15C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 11:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E4462080C
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 11:12:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KupfXalQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732421AbgFSLMA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Jun 2020 07:12:00 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41818 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732579AbgFSLLQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jun 2020 07:11:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592565027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+b52EmLzFbFtvMGenDZzcpyng7astSGRx8nMCdwT+mY=;
        b=KupfXalQs1cU+aC9Wd+/XuVB0nu32aR8LcsB/ViTdrSsunpyicEdWvLxGD7Bvl3M0nr9v/
        iYnpxif5LGlbfw6uFZWXPEdGk5Y6jylV495ZXCVEUKUnMYGWiAC8WVmbw6Yd3Ypy1wh4MW
        X12brPuOCytEodOl9fYvnaifba33sdY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-05znPT8FMhKSJFSeXl4-Xw-1; Fri, 19 Jun 2020 07:10:25 -0400
X-MC-Unique: 05znPT8FMhKSJFSeXl4-Xw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8B79800053;
        Fri, 19 Jun 2020 11:10:23 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 589207166A;
        Fri, 19 Jun 2020 11:10:23 +0000 (UTC)
Date:   Fri, 19 Jun 2020 07:10:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs_repair: remove old btree rebuild support code
Message-ID: <20200619111021.GA36770@bfoster>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
 <159107208399.315004.5025037583246701950.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159107208399.315004.5025037583246701950.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 01, 2020 at 09:28:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This code isn't needed anymore, so get rid of it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/phase5.c |  242 -------------------------------------------------------
>  1 file changed, 242 deletions(-)
> 
> 
> diff --git a/repair/phase5.c b/repair/phase5.c
> index ad009416..439c1065 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -21,52 +21,6 @@
>  #include "bulkload.h"
>  #include "agbtree.h"
>  
> -/*
> - * we maintain the current slice (path from root to leaf)
> - * of the btree incore.  when we need a new block, we ask
> - * the block allocator for the address of a block on that
> - * level, map the block in, and set up the appropriate
> - * pointers (child, silbing, etc.) and keys that should
> - * point to the new block.
> - */
> -typedef struct bt_stat_level  {
> -	/*
> -	 * set in setup_cursor routine and maintained in the tree-building
> -	 * routines
> -	 */
> -	xfs_buf_t		*buf_p;		/* 2 buffer pointers to ... */
> -	xfs_buf_t		*prev_buf_p;
> -	xfs_agblock_t		agbno;		/* current block being filled */
> -	xfs_agblock_t		prev_agbno;	/* previous block */
> -	/*
> -	 * set in calculate/init cursor routines for each btree level
> -	 */
> -	int			num_recs_tot;	/* # tree recs in level */
> -	int			num_blocks;	/* # tree blocks in level */
> -	int			num_recs_pb;	/* num_recs_tot / num_blocks */
> -	int			modulo;		/* num_recs_tot % num_blocks */
> -} bt_stat_level_t;
> -
> -typedef struct bt_status  {
> -	int			init;		/* cursor set up once? */
> -	int			num_levels;	/* # of levels in btree */
> -	xfs_extlen_t		num_tot_blocks;	/* # blocks alloc'ed for tree */
> -	xfs_extlen_t		num_free_blocks;/* # blocks currently unused */
> -
> -	xfs_agblock_t		root;		/* root block */
> -	/*
> -	 * list of blocks to be used to set up this tree
> -	 * and pointer to the first unused block on the list
> -	 */
> -	xfs_agblock_t		*btree_blocks;		/* block list */
> -	xfs_agblock_t		*free_btree_blocks;	/* first unused block */
> -	/*
> -	 * per-level status info
> -	 */
> -	bt_stat_level_t		level[XFS_BTREE_MAXLEVELS];
> -	uint64_t		owner;		/* owner */
> -} bt_status_t;
> -
>  static uint64_t	*sb_icount_ag;		/* allocated inodes per ag */
>  static uint64_t	*sb_ifree_ag;		/* free inodes per ag */
>  static uint64_t	*sb_fdblocks_ag;	/* free data blocks per ag */
> @@ -164,202 +118,6 @@ mk_incore_fstree(
>  	return(num_extents);
>  }
>  
> -static xfs_agblock_t
> -get_next_blockaddr(xfs_agnumber_t agno, int level, bt_status_t *curs)
> -{
> -	ASSERT(curs->free_btree_blocks < curs->btree_blocks +
> -						curs->num_tot_blocks);
> -	ASSERT(curs->num_free_blocks > 0);
> -
> -	curs->num_free_blocks--;
> -	return(*curs->free_btree_blocks++);
> -}
> -
> -/*
> - * set up the dynamically allocated block allocation data in the btree
> - * cursor that depends on the info in the static portion of the cursor.
> - * allocates space from the incore bno/bcnt extent trees and sets up
> - * the first path up the left side of the tree.  Also sets up the
> - * cursor pointer to the btree root.   called by init_freespace_cursor()
> - * and init_ino_cursor()
> - */
> -static void
> -setup_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *curs)
> -{
> -	int			j;
> -	unsigned int		u;
> -	xfs_extlen_t		big_extent_len;
> -	xfs_agblock_t		big_extent_start;
> -	extent_tree_node_t	*ext_ptr;
> -	extent_tree_node_t	*bno_ext_ptr;
> -	xfs_extlen_t		blocks_allocated;
> -	xfs_agblock_t		*agb_ptr;
> -	int			error;
> -
> -	/*
> -	 * get the number of blocks we need to allocate, then
> -	 * set up block number array, set the free block pointer
> -	 * to the first block in the array, and null the array
> -	 */
> -	big_extent_len = curs->num_tot_blocks;
> -	blocks_allocated = 0;
> -
> -	ASSERT(big_extent_len > 0);
> -
> -	if ((curs->btree_blocks = malloc(sizeof(xfs_agblock_t)
> -					* big_extent_len)) == NULL)
> -		do_error(_("could not set up btree block array\n"));
> -
> -	agb_ptr = curs->free_btree_blocks = curs->btree_blocks;
> -
> -	for (j = 0; j < curs->num_free_blocks; j++, agb_ptr++)
> -		*agb_ptr = NULLAGBLOCK;
> -
> -	/*
> -	 * grab the smallest extent and use it up, then get the
> -	 * next smallest.  This mimics the init_*_cursor code.
> -	 */
> -	ext_ptr =  findfirst_bcnt_extent(agno);
> -
> -	agb_ptr = curs->btree_blocks;
> -
> -	/*
> -	 * set up the free block array
> -	 */
> -	while (blocks_allocated < big_extent_len)  {
> -		if (!ext_ptr)
> -			do_error(
> -_("error - not enough free space in filesystem\n"));
> -		/*
> -		 * use up the extent we've got
> -		 */
> -		for (u = 0; u < ext_ptr->ex_blockcount &&
> -				blocks_allocated < big_extent_len; u++)  {
> -			ASSERT(agb_ptr < curs->btree_blocks
> -					+ curs->num_tot_blocks);
> -			*agb_ptr++ = ext_ptr->ex_startblock + u;
> -			blocks_allocated++;
> -		}
> -
> -		error = rmap_add_ag_rec(mp, agno, ext_ptr->ex_startblock, u,
> -				curs->owner);
> -		if (error)
> -			do_error(_("could not set up btree rmaps: %s\n"),
> -				strerror(-error));
> -
> -		/*
> -		 * if we only used part of this last extent, then we
> -		 * need only to reset the extent in the extent
> -		 * trees and we're done
> -		 */
> -		if (u < ext_ptr->ex_blockcount)  {
> -			big_extent_start = ext_ptr->ex_startblock + u;
> -			big_extent_len = ext_ptr->ex_blockcount - u;
> -
> -			ASSERT(big_extent_len > 0);
> -
> -			bno_ext_ptr = find_bno_extent(agno,
> -						ext_ptr->ex_startblock);
> -			ASSERT(bno_ext_ptr != NULL);
> -			get_bno_extent(agno, bno_ext_ptr);
> -			release_extent_tree_node(bno_ext_ptr);
> -
> -			ext_ptr = get_bcnt_extent(agno, ext_ptr->ex_startblock,
> -					ext_ptr->ex_blockcount);
> -			release_extent_tree_node(ext_ptr);
> -#ifdef XR_BLD_FREE_TRACE
> -			fprintf(stderr, "releasing extent: %u [%u %u]\n",
> -				agno, ext_ptr->ex_startblock,
> -				ext_ptr->ex_blockcount);
> -			fprintf(stderr, "blocks_allocated = %d\n",
> -				blocks_allocated);
> -#endif
> -
> -			add_bno_extent(agno, big_extent_start, big_extent_len);
> -			add_bcnt_extent(agno, big_extent_start, big_extent_len);
> -
> -			return;
> -		}
> -		/*
> -		 * delete the used-up extent from both extent trees and
> -		 * find next biggest extent
> -		 */
> -#ifdef XR_BLD_FREE_TRACE
> -		fprintf(stderr, "releasing extent: %u [%u %u]\n",
> -			agno, ext_ptr->ex_startblock, ext_ptr->ex_blockcount);
> -#endif
> -		bno_ext_ptr = find_bno_extent(agno, ext_ptr->ex_startblock);
> -		ASSERT(bno_ext_ptr != NULL);
> -		get_bno_extent(agno, bno_ext_ptr);
> -		release_extent_tree_node(bno_ext_ptr);
> -
> -		ext_ptr = get_bcnt_extent(agno, ext_ptr->ex_startblock,
> -				ext_ptr->ex_blockcount);
> -		ASSERT(ext_ptr != NULL);
> -		release_extent_tree_node(ext_ptr);
> -
> -		ext_ptr = findfirst_bcnt_extent(agno);
> -	}
> -#ifdef XR_BLD_FREE_TRACE
> -	fprintf(stderr, "blocks_allocated = %d\n",
> -		blocks_allocated);
> -#endif
> -}
> -
> -static void
> -write_cursor(bt_status_t *curs)
> -{
> -	int i;
> -
> -	for (i = 0; i < curs->num_levels; i++)  {
> -#if defined(XR_BLD_FREE_TRACE) || defined(XR_BLD_INO_TRACE)
> -		fprintf(stderr, "writing bt block %u\n", curs->level[i].agbno);
> -#endif
> -		if (curs->level[i].prev_buf_p != NULL)  {
> -			ASSERT(curs->level[i].prev_agbno != NULLAGBLOCK);
> -#if defined(XR_BLD_FREE_TRACE) || defined(XR_BLD_INO_TRACE)
> -			fprintf(stderr, "writing bt prev block %u\n",
> -						curs->level[i].prev_agbno);
> -#endif
> -			libxfs_buf_mark_dirty(curs->level[i].prev_buf_p);
> -			libxfs_buf_relse(curs->level[i].prev_buf_p);
> -		}
> -		libxfs_buf_mark_dirty(curs->level[i].buf_p);
> -		libxfs_buf_relse(curs->level[i].buf_p);
> -	}
> -}
> -
> -static void
> -finish_cursor(bt_status_t *curs)
> -{
> -	ASSERT(curs->num_free_blocks == 0);
> -	free(curs->btree_blocks);
> -}
> -
> -/* Map btnum to buffer ops for the types that need it. */
> -static const struct xfs_buf_ops *
> -btnum_to_ops(
> -	xfs_btnum_t	btnum)
> -{
> -	switch (btnum) {
> -	case XFS_BTNUM_BNO:
> -		return &xfs_bnobt_buf_ops;
> -	case XFS_BTNUM_CNT:
> -		return &xfs_cntbt_buf_ops;
> -	case XFS_BTNUM_INO:
> -		return &xfs_inobt_buf_ops;
> -	case XFS_BTNUM_FINO:
> -		return &xfs_finobt_buf_ops;
> -	case XFS_BTNUM_RMAP:
> -		return &xfs_rmapbt_buf_ops;
> -	case XFS_BTNUM_REFC:
> -		return &xfs_refcountbt_buf_ops;
> -	default:
> -		ASSERT(0);
> -		return NULL;
> -	}
> -}
> -
>  /*
>   * XXX: yet more code that can be shared with mkfs, growfs.
>   */
> 

