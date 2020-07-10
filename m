Return-Path: <SRS0=IY5l=AV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8055BC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 19:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B5AD2075D
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 19:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgGJTKm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jul 2020 15:10:42 -0400
Received: from sandeen.net ([63.231.237.45]:52082 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgGJTKm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Jul 2020 15:10:42 -0400
Received: from Liberator.localdomain (unknown [50.34.194.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 156A24E4B23;
        Fri, 10 Jul 2020 14:10:10 -0500 (CDT)
Subject: Re: [PATCH v2 06/12] xfs_repair: create a new class of btree rebuild
 cursors
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
 <159107205193.315004.2458726856192120217.stgit@magnolia>
 <20200702151801.GB7606@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <f3f75076-48a0-55e6-513e-4c637373285d@sandeen.net>
Date:   Fri, 10 Jul 2020 12:10:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200702151801.GB7606@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/2/20 10:18 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create some new support structures and functions to assist phase5 in
> using the btree bulk loader to reconstruct metadata btrees.  This is the
> first step in removing the open-coded AG btree rebuilding code.
> 
> Note: The code in this patch will not be used anywhere until the next
> patch, so warnings about unused symbols are expected.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: set the "nearly out of space" slack value to 2 so that we don't
> start out with tons of btree splitting right after mount

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Not sure if Brian's RVB carries through the V2 change or not ...

> ---
>  repair/Makefile   |    4 +
>  repair/agbtree.c  |  152 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  repair/agbtree.h  |   29 ++++++++++
>  repair/bulkload.c |   41 ++++++++++++++
>  repair/bulkload.h |    2 +
>  5 files changed, 226 insertions(+), 2 deletions(-)
>  create mode 100644 repair/agbtree.c
>  create mode 100644 repair/agbtree.h
> 
> diff --git a/repair/Makefile b/repair/Makefile
> index 62d84bbf..f6a6e3f9 100644
> --- a/repair/Makefile
> +++ b/repair/Makefile
> @@ -9,11 +9,11 @@ LSRCFILES = README
>  
>  LTCOMMAND = xfs_repair
>  
> -HFILES = agheader.h attr_repair.h avl.h bulkload.h bmap.h btree.h \
> +HFILES = agheader.h agbtree.h attr_repair.h avl.h bulkload.h bmap.h btree.h \
>  	da_util.h dinode.h dir2.h err_protos.h globals.h incore.h protos.h \
>  	rt.h progress.h scan.h versions.h prefetch.h rmap.h slab.h threads.h
>  
> -CFILES = agheader.c attr_repair.c avl.c bulkload.c bmap.c btree.c \
> +CFILES = agheader.c agbtree.c attr_repair.c avl.c bulkload.c bmap.c btree.c \
>  	da_util.c dino_chunks.c dinode.c dir2.c globals.c incore.c \
>  	incore_bmc.c init.c incore_ext.c incore_ino.c phase1.c \
>  	phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c \
> diff --git a/repair/agbtree.c b/repair/agbtree.c
> new file mode 100644
> index 00000000..95a3eac9
> --- /dev/null
> +++ b/repair/agbtree.c
> @@ -0,0 +1,152 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2020 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#include <libxfs.h>
> +#include "err_protos.h"
> +#include "slab.h"
> +#include "rmap.h"
> +#include "incore.h"
> +#include "bulkload.h"
> +#include "agbtree.h"
> +
> +/* Initialize a btree rebuild context. */
> +static void
> +init_rebuild(
> +	struct repair_ctx		*sc,
> +	const struct xfs_owner_info	*oinfo,
> +	xfs_agblock_t			free_space,
> +	struct bt_rebuild		*btr)
> +{
> +	memset(btr, 0, sizeof(struct bt_rebuild));
> +
> +	bulkload_init_ag(&btr->newbt, sc, oinfo);
> +	bulkload_estimate_ag_slack(sc, &btr->bload, free_space);
> +}
> +
> +/*
> + * Update this free space record to reflect the blocks we stole from the
> + * beginning of the record.
> + */
> +static void
> +consume_freespace(
> +	xfs_agnumber_t		agno,
> +	struct extent_tree_node	*ext_ptr,
> +	uint32_t		len)
> +{
> +	struct extent_tree_node	*bno_ext_ptr;
> +	xfs_agblock_t		new_start = ext_ptr->ex_startblock + len;
> +	xfs_extlen_t		new_len = ext_ptr->ex_blockcount - len;
> +
> +	/* Delete the used-up extent from both extent trees. */
> +#ifdef XR_BLD_FREE_TRACE
> +	fprintf(stderr, "releasing extent: %u [%u %u]\n", agno,
> +			ext_ptr->ex_startblock, ext_ptr->ex_blockcount);
> +#endif
> +	bno_ext_ptr = find_bno_extent(agno, ext_ptr->ex_startblock);
> +	ASSERT(bno_ext_ptr != NULL);
> +	get_bno_extent(agno, bno_ext_ptr);
> +	release_extent_tree_node(bno_ext_ptr);
> +
> +	ext_ptr = get_bcnt_extent(agno, ext_ptr->ex_startblock,
> +			ext_ptr->ex_blockcount);
> +	release_extent_tree_node(ext_ptr);
> +
> +	/*
> +	 * If we only used part of this last extent, then we must reinsert the
> +	 * extent to maintain proper sorting order.
> +	 */
> +	if (new_len > 0) {
> +		add_bno_extent(agno, new_start, new_len);
> +		add_bcnt_extent(agno, new_start, new_len);
> +	}
> +}
> +
> +/* Reserve blocks for the new per-AG structures. */
> +static void
> +reserve_btblocks(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	struct bt_rebuild	*btr,
> +	uint32_t		nr_blocks)
> +{
> +	struct extent_tree_node	*ext_ptr;
> +	uint32_t		blocks_allocated = 0;
> +	uint32_t		len;
> +	int			error;
> +
> +	while (blocks_allocated < nr_blocks)  {
> +		xfs_fsblock_t	fsbno;
> +
> +		/*
> +		 * Grab the smallest extent and use it up, then get the
> +		 * next smallest.  This mimics the init_*_cursor code.
> +		 */
> +		ext_ptr = findfirst_bcnt_extent(agno);
> +		if (!ext_ptr)
> +			do_error(
> +_("error - not enough free space in filesystem\n"));
> +
> +		/* Use up the extent we've got. */
> +		len = min(ext_ptr->ex_blockcount, nr_blocks - blocks_allocated);
> +		fsbno = XFS_AGB_TO_FSB(mp, agno, ext_ptr->ex_startblock);
> +		error = bulkload_add_blocks(&btr->newbt, fsbno, len);
> +		if (error)
> +			do_error(_("could not set up btree reservation: %s\n"),
> +				strerror(-error));
> +
> +		error = rmap_add_ag_rec(mp, agno, ext_ptr->ex_startblock, len,
> +				btr->newbt.oinfo.oi_owner);
> +		if (error)
> +			do_error(_("could not set up btree rmaps: %s\n"),
> +				strerror(-error));
> +
> +		consume_freespace(agno, ext_ptr, len);
> +		blocks_allocated += len;
> +	}
> +#ifdef XR_BLD_FREE_TRACE
> +	fprintf(stderr, "blocks_allocated = %d\n",
> +		blocks_allocated);
> +#endif
> +}
> +
> +/* Feed one of the new btree blocks to the bulk loader. */
> +static int
> +rebuild_claim_block(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_ptr	*ptr,
> +	void			*priv)
> +{
> +	struct bt_rebuild	*btr = priv;
> +
> +	return bulkload_claim_block(cur, &btr->newbt, ptr);
> +}
> +
> +/*
> + * Scoop up leftovers from a rebuild cursor for later freeing, then free the
> + * rebuild context.
> + */
> +void
> +finish_rebuild(
> +	struct xfs_mount	*mp,
> +	struct bt_rebuild	*btr,
> +	struct xfs_slab		*lost_fsb)
> +{
> +	struct bulkload_resv	*resv, *n;
> +
> +	for_each_bulkload_reservation(&btr->newbt, resv, n) {
> +		while (resv->used < resv->len) {
> +			xfs_fsblock_t	fsb = resv->fsbno + resv->used;
> +			int		error;
> +
> +			error = slab_add(lost_fsb, &fsb);
> +			if (error)
> +				do_error(
> +_("Insufficient memory saving lost blocks.\n"));
> +			resv->used++;
> +		}
> +	}
> +
> +	bulkload_destroy(&btr->newbt, 0);
> +}
> diff --git a/repair/agbtree.h b/repair/agbtree.h
> new file mode 100644
> index 00000000..50ea3c60
> --- /dev/null
> +++ b/repair/agbtree.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Copyright (C) 2020 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#ifndef __XFS_REPAIR_AG_BTREE_H__
> +#define __XFS_REPAIR_AG_BTREE_H__
> +
> +/* Context for rebuilding a per-AG btree. */
> +struct bt_rebuild {
> +	/* Fake root for staging and space preallocations. */
> +	struct bulkload	newbt;
> +
> +	/* Geometry of the new btree. */
> +	struct xfs_btree_bload	bload;
> +
> +	/* Staging btree cursor for the new tree. */
> +	struct xfs_btree_cur	*cur;
> +
> +	/* Tree-specific data. */
> +	union {
> +		struct xfs_slab_cursor	*slab_cursor;
> +	};
> +};
> +
> +void finish_rebuild(struct xfs_mount *mp, struct bt_rebuild *btr,
> +		struct xfs_slab *lost_fsb);
> +
> +#endif /* __XFS_REPAIR_AG_BTREE_H__ */
> diff --git a/repair/bulkload.c b/repair/bulkload.c
> index 4c69fe0d..81d67e62 100644
> --- a/repair/bulkload.c
> +++ b/repair/bulkload.c
> @@ -95,3 +95,44 @@ bulkload_claim_block(
>  		ptr->s = cpu_to_be32(XFS_FSB_TO_AGBNO(cur->bc_mp, fsb));
>  	return 0;
>  }
> +
> +/*
> + * Estimate proper slack values for a btree that's being reloaded.
> + *
> + * Under most circumstances, we'll take whatever default loading value the
> + * btree bulk loading code calculates for us.  However, there are some
> + * exceptions to this rule:
> + *
> + * (1) If someone turned one of the debug knobs.
> + * (2) The AG has less than ~9% space free.
> + *
> + * Note that we actually use 3/32 for the comparison to avoid division.
> + */
> +void
> +bulkload_estimate_ag_slack(
> +	struct repair_ctx	*sc,
> +	struct xfs_btree_bload	*bload,
> +	unsigned int		free)
> +{
> +	/*
> +	 * The global values are set to -1 (i.e. take the bload defaults)
> +	 * unless someone has set them otherwise, so we just pull the values
> +	 * here.
> +	 */
> +	bload->leaf_slack = bload_leaf_slack;
> +	bload->node_slack = bload_node_slack;
> +
> +	/* No further changes if there's more than 3/32ths space left. */
> +	if (free >= ((sc->mp->m_sb.sb_agblocks * 3) >> 5))
> +		return;
> +
> +	/*
> +	 * We're low on space; load the btrees as tightly as possible.  Leave
> +	 * a couple of open slots in each btree block so that we don't end up
> +	 * splitting the btrees like crazy right after mount.
> +	 */
> +	if (bload->leaf_slack < 0)
> +		bload->leaf_slack = 2;
> +	if (bload->node_slack < 0)
> +		bload->node_slack = 2;
> +}
> diff --git a/repair/bulkload.h b/repair/bulkload.h
> index 79f81cb0..01f67279 100644
> --- a/repair/bulkload.h
> +++ b/repair/bulkload.h
> @@ -53,5 +53,7 @@ int bulkload_add_blocks(struct bulkload *bkl, xfs_fsblock_t fsbno,
>  void bulkload_destroy(struct bulkload *bkl, int error);
>  int bulkload_claim_block(struct xfs_btree_cur *cur, struct bulkload *bkl,
>  		union xfs_btree_ptr *ptr);
> +void bulkload_estimate_ag_slack(struct repair_ctx *sc,
> +		struct xfs_btree_bload *bload, unsigned int free);
>  
>  #endif /* __XFS_REPAIR_BULKLOAD_H__ */
> 
