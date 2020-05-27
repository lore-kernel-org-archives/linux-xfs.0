Return-Path: <SRS0=YlU2=7J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C69D5C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 May 2020 12:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E84E208B6
	for <linux-xfs@archiver.kernel.org>; Wed, 27 May 2020 12:15:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jSDH8u6X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgE0MPm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 May 2020 08:15:42 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23736 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725766AbgE0MPl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 May 2020 08:15:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590581738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3RirYTofnsSa7WOghkW+yRCtyIBNaSlcHhHTdRJv2jI=;
        b=jSDH8u6Xlb7vqp4tiy4DeDDFjGwVRaFoBiUwkvFY3uJE5bIxAgrtyJtCvhGnM9RDELJBT2
        3gk+P/FecssuhonznpuyRQqieprtCHVfsl2rZh16rt8KHAqFlJl2pfP0Kj0/Md88qBC+ip
        qeqW/rOCsDAS5pWBqPYL2gHfvhgzXps=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-ddGxpd4jM2qwSHybiRgKMg-1; Wed, 27 May 2020 08:15:35 -0400
X-MC-Unique: ddGxpd4jM2qwSHybiRgKMg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E6B11005512;
        Wed, 27 May 2020 12:15:34 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B08325D9E5;
        Wed, 27 May 2020 12:15:33 +0000 (UTC)
Date:   Wed, 27 May 2020 08:15:31 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs_repair: port the online repair newbt structure
Message-ID: <20200527121531.GA12014@bfoster>
References: <158993944270.983175.4120094597556662259.stgit@magnolia>
 <158993944912.983175.201802914672044021.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158993944912.983175.201802914672044021.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 19, 2020 at 06:50:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Port the new btree staging context and related block reservation helper
> code from the kernel to repair.  We'll use this in subsequent patches to
> implement btree bulk loading.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  include/libxfs.h         |    1 
>  libxfs/libxfs_api_defs.h |    2 
>  repair/Makefile          |    4 -
>  repair/bload.c           |  303 ++++++++++++++++++++++++++++++++++++++++++++++
>  repair/bload.h           |   77 ++++++++++++
>  repair/xfs_repair.c      |   17 +++
>  6 files changed, 402 insertions(+), 2 deletions(-)
>  create mode 100644 repair/bload.c
>  create mode 100644 repair/bload.h
> 
> 
...
> diff --git a/repair/bload.c b/repair/bload.c
> new file mode 100644
> index 00000000..9bc17468
> --- /dev/null
> +++ b/repair/bload.c
> @@ -0,0 +1,303 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2020 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#include <libxfs.h>
> +#include "bload.h"
> +
> +#define trace_xrep_newbt_claim_block(...)	((void) 0)
> +#define trace_xrep_newbt_free_blocks(...)	((void) 0)
> +
> +int bload_leaf_slack = -1;
> +int bload_node_slack = -1;
> +
> +/* Ported routines from fs/xfs/scrub/repair.c */
> +

Looks mostly straightforward, but I'll have to come back to this as I
get to the code that uses it later in the series. In the meantime, I see
some of these helpers in scrub/repair.c while not others. Are there
references to other routines that are intended to be copies from kernel
code?

Brian

> +/*
> + * Roll a transaction, keeping the AG headers locked and reinitializing
> + * the btree cursors.
> + */
> +int
> +xrep_roll_ag_trans(
> +	struct repair_ctx	*sc)
> +{
> +	int			error;
> +
> +	/* Keep the AG header buffers locked so we can keep going. */
> +	if (sc->agi_bp)
> +		libxfs_trans_bhold(sc->tp, sc->agi_bp);
> +	if (sc->agf_bp)
> +		libxfs_trans_bhold(sc->tp, sc->agf_bp);
> +	if (sc->agfl_bp)
> +		libxfs_trans_bhold(sc->tp, sc->agfl_bp);
> +
> +	/*
> +	 * Roll the transaction.  We still own the buffer and the buffer lock
> +	 * regardless of whether or not the roll succeeds.  If the roll fails,
> +	 * the buffers will be released during teardown on our way out of the
> +	 * kernel.  If it succeeds, we join them to the new transaction and
> +	 * move on.
> +	 */
> +	error = -libxfs_trans_roll(&sc->tp);
> +	if (error)
> +		return error;
> +
> +	/* Join AG headers to the new transaction. */
> +	if (sc->agi_bp)
> +		libxfs_trans_bjoin(sc->tp, sc->agi_bp);
> +	if (sc->agf_bp)
> +		libxfs_trans_bjoin(sc->tp, sc->agf_bp);
> +	if (sc->agfl_bp)
> +		libxfs_trans_bjoin(sc->tp, sc->agfl_bp);
> +
> +	return 0;
> +}
> +
> +/* Initialize accounting resources for staging a new AG btree. */
> +void
> +xrep_newbt_init_ag(
> +	struct xrep_newbt		*xnr,
> +	struct repair_ctx		*sc,
> +	const struct xfs_owner_info	*oinfo,
> +	xfs_fsblock_t			alloc_hint,
> +	enum xfs_ag_resv_type		resv)
> +{
> +	memset(xnr, 0, sizeof(struct xrep_newbt));
> +	xnr->sc = sc;
> +	xnr->oinfo = *oinfo; /* structure copy */
> +	xnr->alloc_hint = alloc_hint;
> +	xnr->resv = resv;
> +	INIT_LIST_HEAD(&xnr->resv_list);
> +}
> +
> +/* Initialize accounting resources for staging a new inode fork btree. */
> +void
> +xrep_newbt_init_inode(
> +	struct xrep_newbt		*xnr,
> +	struct repair_ctx		*sc,
> +	int				whichfork,
> +	const struct xfs_owner_info	*oinfo)
> +{
> +	xrep_newbt_init_ag(xnr, sc, oinfo,
> +			XFS_INO_TO_FSB(sc->mp, sc->ip->i_ino),
> +			XFS_AG_RESV_NONE);
> +	xnr->ifake.if_fork = kmem_zone_zalloc(xfs_ifork_zone, 0);
> +	xnr->ifake.if_fork_size = XFS_IFORK_SIZE(sc->ip, whichfork);
> +}
> +
> +/*
> + * Initialize accounting resources for staging a new btree.  Callers are
> + * expected to add their own reservations (and clean them up) manually.
> + */
> +void
> +xrep_newbt_init_bare(
> +	struct xrep_newbt		*xnr,
> +	struct repair_ctx		*sc)
> +{
> +	xrep_newbt_init_ag(xnr, sc, &XFS_RMAP_OINFO_ANY_OWNER, NULLFSBLOCK,
> +			XFS_AG_RESV_NONE);
> +}
> +
> +/* Designate specific blocks to be used to build our new btree. */
> +int
> +xrep_newbt_add_blocks(
> +	struct xrep_newbt	*xnr,
> +	xfs_fsblock_t		fsbno,
> +	xfs_extlen_t		len)
> +{
> +	struct xrep_newbt_resv	*resv;
> +
> +	resv = kmem_alloc(sizeof(struct xrep_newbt_resv), KM_MAYFAIL);
> +	if (!resv)
> +		return ENOMEM;
> +
> +	INIT_LIST_HEAD(&resv->list);
> +	resv->fsbno = fsbno;
> +	resv->len = len;
> +	resv->used = 0;
> +	list_add_tail(&resv->list, &xnr->resv_list);
> +	return 0;
> +}
> +
> +/* Reserve disk space for our new btree. */
> +int
> +xrep_newbt_alloc_blocks(
> +	struct xrep_newbt	*xnr,
> +	uint64_t		nr_blocks)
> +{
> +	struct repair_ctx	*sc = xnr->sc;
> +	xfs_alloctype_t		type;
> +	xfs_fsblock_t		alloc_hint = xnr->alloc_hint;
> +	int			error = 0;
> +
> +	type = sc->ip ? XFS_ALLOCTYPE_START_BNO : XFS_ALLOCTYPE_NEAR_BNO;
> +
> +	while (nr_blocks > 0 && !error) {
> +		struct xfs_alloc_arg	args = {
> +			.tp		= sc->tp,
> +			.mp		= sc->mp,
> +			.type		= type,
> +			.fsbno		= alloc_hint,
> +			.oinfo		= xnr->oinfo,
> +			.minlen		= 1,
> +			.maxlen		= nr_blocks,
> +			.prod		= 1,
> +			.resv		= xnr->resv,
> +		};
> +
> +		error = -libxfs_alloc_vextent(&args);
> +		if (error)
> +			return error;
> +		if (args.fsbno == NULLFSBLOCK)
> +			return ENOSPC;
> +
> +		/* We don't have real EFIs here so skip that. */
> +
> +		error = xrep_newbt_add_blocks(xnr, args.fsbno, args.len);
> +		if (error)
> +			break;
> +
> +		nr_blocks -= args.len;
> +		alloc_hint = args.fsbno + args.len - 1;
> +
> +		if (sc->ip)
> +			error = -libxfs_trans_roll_inode(&sc->tp, sc->ip);
> +		else
> +			error = xrep_roll_ag_trans(sc);
> +	}
> +
> +	return error;
> +}
> +
> +/*
> + * Release blocks that were reserved for a btree repair.  If the repair
> + * succeeded then we log deferred frees for unused blocks.  Otherwise, we try
> + * to free the extents immediately to roll the filesystem back to where it was
> + * before we started.
> + */
> +static inline int
> +xrep_newbt_destroy_reservation(
> +	struct xrep_newbt	*xnr,
> +	struct xrep_newbt_resv	*resv,
> +	bool			cancel_repair)
> +{
> +	struct repair_ctx	*sc = xnr->sc;
> +
> +	if (cancel_repair) {
> +		int		error;
> +
> +		/* Free the extent then roll the transaction. */
> +		error = -libxfs_free_extent(sc->tp, resv->fsbno, resv->len,
> +				&xnr->oinfo, xnr->resv);
> +		if (error)
> +			return error;
> +
> +		if (sc->ip)
> +			return -libxfs_trans_roll_inode(&sc->tp, sc->ip);
> +		return xrep_roll_ag_trans(sc);
> +	}
> +
> +	/* We don't have EFIs here so skip the EFD. */
> +
> +	/*
> +	 * Use the deferred freeing mechanism to schedule for deletion any
> +	 * blocks we didn't use to rebuild the tree.  This enables us to log
> +	 * them all in the same transaction as the root change.
> +	 */
> +	resv->fsbno += resv->used;
> +	resv->len -= resv->used;
> +	resv->used = 0;
> +
> +	if (resv->len == 0)
> +		return 0;
> +
> +	trace_xrep_newbt_free_blocks(sc->mp,
> +			XFS_FSB_TO_AGNO(sc->mp, resv->fsbno),
> +			XFS_FSB_TO_AGBNO(sc->mp, resv->fsbno),
> +			resv->len, xnr->oinfo.oi_owner);
> +
> +	__xfs_bmap_add_free(sc->tp, resv->fsbno, resv->len, &xnr->oinfo, true);
> +
> +	return 0;
> +}
> +
> +/* Free all the accounting info and disk space we reserved for a new btree. */
> +void
> +xrep_newbt_destroy(
> +	struct xrep_newbt	*xnr,
> +	int			error)
> +{
> +	struct repair_ctx	*sc = xnr->sc;
> +	struct xrep_newbt_resv	*resv, *n;
> +	int			err2;
> +
> +	list_for_each_entry_safe(resv, n, &xnr->resv_list, list) {
> +		err2 = xrep_newbt_destroy_reservation(xnr, resv, error != 0);
> +		if (err2)
> +			goto junkit;
> +
> +		list_del(&resv->list);
> +		kmem_free(resv);
> +	}
> +
> +junkit:
> +	/*
> +	 * If we still have reservations attached to @newbt, cleanup must have
> +	 * failed and the filesystem is about to go down.  Clean up the incore
> +	 * reservations.
> +	 */
> +	list_for_each_entry_safe(resv, n, &xnr->resv_list, list) {
> +		list_del(&resv->list);
> +		kmem_free(resv);
> +	}
> +
> +	if (sc->ip) {
> +		kmem_cache_free(xfs_ifork_zone, xnr->ifake.if_fork);
> +		xnr->ifake.if_fork = NULL;
> +	}
> +}
> +
> +/* Feed one of the reserved btree blocks to the bulk loader. */
> +int
> +xrep_newbt_claim_block(
> +	struct xfs_btree_cur	*cur,
> +	struct xrep_newbt	*xnr,
> +	union xfs_btree_ptr	*ptr)
> +{
> +	struct xrep_newbt_resv	*resv;
> +	xfs_fsblock_t		fsb;
> +
> +	/*
> +	 * The first item in the list should always have a free block unless
> +	 * we're completely out.
> +	 */
> +	resv = list_first_entry(&xnr->resv_list, struct xrep_newbt_resv, list);
> +	if (resv->used == resv->len)
> +		return ENOSPC;
> +
> +	/*
> +	 * Peel off a block from the start of the reservation.  We allocate
> +	 * blocks in order to place blocks on disk in increasing record or key
> +	 * order.  The block reservations tend to end up on the list in
> +	 * decreasing order, which hopefully results in leaf blocks ending up
> +	 * together.
> +	 */
> +	fsb = resv->fsbno + resv->used;
> +	resv->used++;
> +
> +	/* If we used all the blocks in this reservation, move it to the end. */
> +	if (resv->used == resv->len)
> +		list_move_tail(&resv->list, &xnr->resv_list);
> +
> +	trace_xrep_newbt_claim_block(cur->bc_mp,
> +			XFS_FSB_TO_AGNO(cur->bc_mp, fsb),
> +			XFS_FSB_TO_AGBNO(cur->bc_mp, fsb),
> +			1, xnr->oinfo.oi_owner);
> +
> +	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
> +		ptr->l = cpu_to_be64(fsb);
> +	else
> +		ptr->s = cpu_to_be32(XFS_FSB_TO_AGBNO(cur->bc_mp, fsb));
> +	return 0;
> +}
> diff --git a/repair/bload.h b/repair/bload.h
> new file mode 100644
> index 00000000..020c4834
> --- /dev/null
> +++ b/repair/bload.h
> @@ -0,0 +1,77 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2020 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#ifndef __XFS_REPAIR_BLOAD_H__
> +#define __XFS_REPAIR_BLOAD_H__
> +
> +extern int bload_leaf_slack;
> +extern int bload_node_slack;
> +
> +struct repair_ctx {
> +	struct xfs_mount	*mp;
> +	struct xfs_inode	*ip;
> +	struct xfs_trans	*tp;
> +
> +	struct xfs_buf		*agi_bp;
> +	struct xfs_buf		*agf_bp;
> +	struct xfs_buf		*agfl_bp;
> +};
> +
> +struct xrep_newbt_resv {
> +	/* Link to list of extents that we've reserved. */
> +	struct list_head	list;
> +
> +	/* FSB of the block we reserved. */
> +	xfs_fsblock_t		fsbno;
> +
> +	/* Length of the reservation. */
> +	xfs_extlen_t		len;
> +
> +	/* How much of this reservation we've used. */
> +	xfs_extlen_t		used;
> +};
> +
> +struct xrep_newbt {
> +	struct repair_ctx	*sc;
> +
> +	/* List of extents that we've reserved. */
> +	struct list_head	resv_list;
> +
> +	/* Fake root for new btree. */
> +	union {
> +		struct xbtree_afakeroot	afake;
> +		struct xbtree_ifakeroot	ifake;
> +	};
> +
> +	/* rmap owner of these blocks */
> +	struct xfs_owner_info	oinfo;
> +
> +	/* The last reservation we allocated from. */
> +	struct xrep_newbt_resv	*last_resv;
> +
> +	/* Allocation hint */
> +	xfs_fsblock_t		alloc_hint;
> +
> +	/* per-ag reservation type */
> +	enum xfs_ag_resv_type	resv;
> +};
> +
> +#define for_each_xrep_newbt_reservation(xnr, resv, n)	\
> +	list_for_each_entry_safe((resv), (n), &(xnr)->resv_list, list)
> +
> +void xrep_newbt_init_bare(struct xrep_newbt *xnr, struct repair_ctx *sc);
> +void xrep_newbt_init_ag(struct xrep_newbt *xnr, struct repair_ctx *sc,
> +		const struct xfs_owner_info *oinfo, xfs_fsblock_t alloc_hint,
> +		enum xfs_ag_resv_type resv);
> +void xrep_newbt_init_inode(struct xrep_newbt *xnr, struct repair_ctx *sc,
> +		int whichfork, const struct xfs_owner_info *oinfo);
> +int xrep_newbt_add_blocks(struct xrep_newbt *xnr, xfs_fsblock_t fsbno,
> +		xfs_extlen_t len);
> +int xrep_newbt_alloc_blocks(struct xrep_newbt *xnr, uint64_t nr_blocks);
> +void xrep_newbt_destroy(struct xrep_newbt *xnr, int error);
> +int xrep_newbt_claim_block(struct xfs_btree_cur *cur, struct xrep_newbt *xnr,
> +		union xfs_btree_ptr *ptr);
> +
> +#endif /* __XFS_REPAIR_BLOAD_H__ */
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 9d72fa8e..8fbd3649 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -24,6 +24,7 @@
>  #include "rmap.h"
>  #include "libfrog/fsgeom.h"
>  #include "libfrog/platform.h"
> +#include "bload.h"
>  
>  /*
>   * option tables for getsubopt calls
> @@ -39,6 +40,8 @@ enum o_opt_nums {
>  	AG_STRIDE,
>  	FORCE_GEO,
>  	PHASE2_THREADS,
> +	BLOAD_LEAF_SLACK,
> +	BLOAD_NODE_SLACK,
>  	O_MAX_OPTS,
>  };
>  
> @@ -49,6 +52,8 @@ static char *o_opts[] = {
>  	[AG_STRIDE]		= "ag_stride",
>  	[FORCE_GEO]		= "force_geometry",
>  	[PHASE2_THREADS]	= "phase2_threads",
> +	[BLOAD_LEAF_SLACK]	= "debug_bload_leaf_slack",
> +	[BLOAD_NODE_SLACK]	= "debug_bload_node_slack",
>  	[O_MAX_OPTS]		= NULL,
>  };
>  
> @@ -260,6 +265,18 @@ process_args(int argc, char **argv)
>  		_("-o phase2_threads requires a parameter\n"));
>  					phase2_threads = (int)strtol(val, NULL, 0);
>  					break;
> +				case BLOAD_LEAF_SLACK:
> +					if (!val)
> +						do_abort(
> +		_("-o debug_bload_leaf_slack requires a parameter\n"));
> +					bload_leaf_slack = (int)strtol(val, NULL, 0);
> +					break;
> +				case BLOAD_NODE_SLACK:
> +					if (!val)
> +						do_abort(
> +		_("-o debug_bload_node_slack requires a parameter\n"));
> +					bload_node_slack = (int)strtol(val, NULL, 0);
> +					break;
>  				default:
>  					unknown('o', val);
>  					break;
> 

