Return-Path: <SRS0=Ja7n=76=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32518C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Jun 2020 12:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0975A208B3
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Jun 2020 12:09:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DyXb0EBf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgFQMJq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Jun 2020 08:09:46 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23782 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726355AbgFQMJp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jun 2020 08:09:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592395782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CQq/doB8L1jXJwDgx7x9zQRt0fMLLd5daltgi+r75Kg=;
        b=DyXb0EBf6xzRT9PV5pIXwQQ1PHic6G47ODD+/qWuhnSn1Vgo5LhHJi9HsEQK4zgWnGwC7I
        PfxZKS07GLZXKSyDda9+1vn4KfPpur9RA6p5xFo6V4v9YybWg6lP6UpFQ3l7iEsYiSdK+t
        xqtZ7G4fx7gZiuINIvN3B/OJKOmzeI0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-BPF5qSOvPPKh0lrXk7OC7w-1; Wed, 17 Jun 2020 08:09:40 -0400
X-MC-Unique: BPF5qSOvPPKh0lrXk7OC7w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8929880332A;
        Wed, 17 Jun 2020 12:09:39 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DB93A19C79;
        Wed, 17 Jun 2020 12:09:38 +0000 (UTC)
Date:   Wed, 17 Jun 2020 08:09:36 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs_repair: make container for btree bulkload root
 and block reservation
Message-ID: <20200617120936.GC27169@bfoster>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
 <159107203211.315004.18315004143675889981.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159107203211.315004.18315004143675889981.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 01, 2020 at 09:27:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create appropriate data structures to manage the fake btree root and
> block reservation lists needed to stage a btree bulkload operation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  include/libxfs.h         |    1 
>  libxfs/libxfs_api_defs.h |    2 +
>  repair/Makefile          |    4 +-
>  repair/bulkload.c        |   97 ++++++++++++++++++++++++++++++++++++++++++++++
>  repair/bulkload.h        |   57 +++++++++++++++++++++++++++
>  repair/xfs_repair.c      |   17 ++++++++
>  6 files changed, 176 insertions(+), 2 deletions(-)
>  create mode 100644 repair/bulkload.c
>  create mode 100644 repair/bulkload.h
> 
> 
> diff --git a/include/libxfs.h b/include/libxfs.h
> index 12447835..b9370139 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -76,6 +76,7 @@ struct iomap;
>  #include "xfs_rmap.h"
>  #include "xfs_refcount_btree.h"
>  #include "xfs_refcount.h"
> +#include "xfs_btree_staging.h"
>  
>  #ifndef ARRAY_SIZE
>  #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index be06c763..61047f8f 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -27,12 +27,14 @@
>  #define xfs_alloc_fix_freelist		libxfs_alloc_fix_freelist
>  #define xfs_alloc_min_freelist		libxfs_alloc_min_freelist
>  #define xfs_alloc_read_agf		libxfs_alloc_read_agf
> +#define xfs_alloc_vextent		libxfs_alloc_vextent
>  
>  #define xfs_attr_get			libxfs_attr_get
>  #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
>  #define xfs_attr_namecheck		libxfs_attr_namecheck
>  #define xfs_attr_set			libxfs_attr_set
>  
> +#define __xfs_bmap_add_free		__libxfs_bmap_add_free
>  #define xfs_bmapi_read			libxfs_bmapi_read
>  #define xfs_bmapi_write			libxfs_bmapi_write
>  #define xfs_bmap_last_offset		libxfs_bmap_last_offset
> diff --git a/repair/Makefile b/repair/Makefile
> index 0964499a..62d84bbf 100644
> --- a/repair/Makefile
> +++ b/repair/Makefile
> @@ -9,11 +9,11 @@ LSRCFILES = README
>  
>  LTCOMMAND = xfs_repair
>  
> -HFILES = agheader.h attr_repair.h avl.h bmap.h btree.h \
> +HFILES = agheader.h attr_repair.h avl.h bulkload.h bmap.h btree.h \
>  	da_util.h dinode.h dir2.h err_protos.h globals.h incore.h protos.h \
>  	rt.h progress.h scan.h versions.h prefetch.h rmap.h slab.h threads.h
>  
> -CFILES = agheader.c attr_repair.c avl.c bmap.c btree.c \
> +CFILES = agheader.c attr_repair.c avl.c bulkload.c bmap.c btree.c \
>  	da_util.c dino_chunks.c dinode.c dir2.c globals.c incore.c \
>  	incore_bmc.c init.c incore_ext.c incore_ino.c phase1.c \
>  	phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c \
> diff --git a/repair/bulkload.c b/repair/bulkload.c
> new file mode 100644
> index 00000000..4c69fe0d
> --- /dev/null
> +++ b/repair/bulkload.c
> @@ -0,0 +1,97 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2020 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#include <libxfs.h>
> +#include "bulkload.h"
> +
> +int bload_leaf_slack = -1;
> +int bload_node_slack = -1;
> +
> +/* Initialize accounting resources for staging a new AG btree. */
> +void
> +bulkload_init_ag(
> +	struct bulkload			*bkl,
> +	struct repair_ctx		*sc,
> +	const struct xfs_owner_info	*oinfo)
> +{
> +	memset(bkl, 0, sizeof(struct bulkload));
> +	bkl->sc = sc;
> +	bkl->oinfo = *oinfo; /* structure copy */
> +	INIT_LIST_HEAD(&bkl->resv_list);
> +}
> +
> +/* Designate specific blocks to be used to build our new btree. */
> +int
> +bulkload_add_blocks(
> +	struct bulkload		*bkl,
> +	xfs_fsblock_t		fsbno,
> +	xfs_extlen_t		len)
> +{
> +	struct bulkload_resv	*resv;
> +
> +	resv = kmem_alloc(sizeof(struct bulkload_resv), KM_MAYFAIL);
> +	if (!resv)
> +		return ENOMEM;
> +
> +	INIT_LIST_HEAD(&resv->list);
> +	resv->fsbno = fsbno;
> +	resv->len = len;
> +	resv->used = 0;
> +	list_add_tail(&resv->list, &bkl->resv_list);
> +	return 0;
> +}
> +
> +/* Free all the accounting info and disk space we reserved for a new btree. */
> +void
> +bulkload_destroy(
> +	struct bulkload		*bkl,
> +	int			error)
> +{
> +	struct bulkload_resv	*resv, *n;
> +
> +	list_for_each_entry_safe(resv, n, &bkl->resv_list, list) {
> +		list_del(&resv->list);
> +		kmem_free(resv);
> +	}
> +}
> +
> +/* Feed one of the reserved btree blocks to the bulk loader. */
> +int
> +bulkload_claim_block(
> +	struct xfs_btree_cur	*cur,
> +	struct bulkload		*bkl,
> +	union xfs_btree_ptr	*ptr)
> +{
> +	struct bulkload_resv	*resv;
> +	xfs_fsblock_t		fsb;
> +
> +	/*
> +	 * The first item in the list should always have a free block unless
> +	 * we're completely out.
> +	 */
> +	resv = list_first_entry(&bkl->resv_list, struct bulkload_resv, list);
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
> +		list_move_tail(&resv->list, &bkl->resv_list);
> +
> +	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
> +		ptr->l = cpu_to_be64(fsb);
> +	else
> +		ptr->s = cpu_to_be32(XFS_FSB_TO_AGBNO(cur->bc_mp, fsb));
> +	return 0;
> +}
> diff --git a/repair/bulkload.h b/repair/bulkload.h
> new file mode 100644
> index 00000000..79f81cb0
> --- /dev/null
> +++ b/repair/bulkload.h
> @@ -0,0 +1,57 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Copyright (C) 2020 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#ifndef __XFS_REPAIR_BULKLOAD_H__
> +#define __XFS_REPAIR_BULKLOAD_H__
> +
> +extern int bload_leaf_slack;
> +extern int bload_node_slack;
> +
> +struct repair_ctx {
> +	struct xfs_mount	*mp;
> +};
> +
> +struct bulkload_resv {
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
> +struct bulkload {
> +	struct repair_ctx	*sc;
> +
> +	/* List of extents that we've reserved. */
> +	struct list_head	resv_list;
> +
> +	/* Fake root for new btree. */
> +	struct xbtree_afakeroot	afake;
> +
> +	/* rmap owner of these blocks */
> +	struct xfs_owner_info	oinfo;
> +
> +	/* The last reservation we allocated from. */
> +	struct bulkload_resv	*last_resv;
> +};
> +
> +#define for_each_bulkload_reservation(bkl, resv, n)	\
> +	list_for_each_entry_safe((resv), (n), &(bkl)->resv_list, list)
> +
> +void bulkload_init_ag(struct bulkload *bkl, struct repair_ctx *sc,
> +		const struct xfs_owner_info *oinfo);
> +int bulkload_add_blocks(struct bulkload *bkl, xfs_fsblock_t fsbno,
> +		xfs_extlen_t len);
> +void bulkload_destroy(struct bulkload *bkl, int error);
> +int bulkload_claim_block(struct xfs_btree_cur *cur, struct bulkload *bkl,
> +		union xfs_btree_ptr *ptr);
> +
> +#endif /* __XFS_REPAIR_BULKLOAD_H__ */
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 9d72fa8e..3bfc8311 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -24,6 +24,7 @@
>  #include "rmap.h"
>  #include "libfrog/fsgeom.h"
>  #include "libfrog/platform.h"
> +#include "bulkload.h"
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

