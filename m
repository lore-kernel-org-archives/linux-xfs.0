Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49524 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751283AbeF3RgG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Jun 2018 13:36:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5UHYRmR146469
        for <linux-xfs@vger.kernel.org>; Sat, 30 Jun 2018 17:36:05 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2jx2gprvd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 30 Jun 2018 17:36:05 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5UHa4Rd014047
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 30 Jun 2018 17:36:04 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5UHa4ic032386
        for <linux-xfs@vger.kernel.org>; Sat, 30 Jun 2018 17:36:04 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 06/21] xfs: repair free space btrees
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986824747.3155.3861118263934672652.stgit@magnolia>
Message-ID: <f1f4546f-c226-cd48-7890-75bcbe0f9d6e@oracle.com>
Date: Sat, 30 Jun 2018 10:36:02 -0700
MIME-Version: 1.0
In-Reply-To: <152986824747.3155.3861118263934672652.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 06/24/2018 12:24 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rebuild the free space btrees from the gaps in the rmap btree.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/Makefile             |    1
>   fs/xfs/scrub/alloc.c        |    1
>   fs/xfs/scrub/alloc_repair.c |  561 +++++++++++++++++++++++++++++++++++++++++++
>   fs/xfs/scrub/common.c       |    8 +
>   fs/xfs/scrub/repair.h       |    2
>   fs/xfs/scrub/scrub.c        |    4
>   fs/xfs/xfs_extent_busy.c    |   14 +
>   fs/xfs/xfs_extent_busy.h    |    4
>   8 files changed, 591 insertions(+), 4 deletions(-)
>   create mode 100644 fs/xfs/scrub/alloc_repair.c
> 
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index a36cccbec169..841e0824eeb6 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -164,6 +164,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
>   ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
>   xfs-y				+= $(addprefix scrub/, \
>   				   agheader_repair.o \
> +				   alloc_repair.o \
>   				   repair.o \
>   				   )
>   endif
> diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
> index 50e4f7fa06f0..e2514c84cb7a 100644
> --- a/fs/xfs/scrub/alloc.c
> +++ b/fs/xfs/scrub/alloc.c
> @@ -15,7 +15,6 @@
>   #include "xfs_log_format.h"
>   #include "xfs_trans.h"
>   #include "xfs_sb.h"
> -#include "xfs_alloc.h"
>   #include "xfs_rmap.h"
>   #include "xfs_alloc.h"
>   #include "scrub/xfs_scrub.h"
> diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
> new file mode 100644
> index 000000000000..c25a2b0d71f1
> --- /dev/null
> +++ b/fs/xfs/scrub/alloc_repair.c
> @@ -0,0 +1,561 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2018 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_defer.h"
> +#include "xfs_btree.h"
> +#include "xfs_bit.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans.h"
> +#include "xfs_sb.h"
> +#include "xfs_alloc.h"
> +#include "xfs_alloc_btree.h"
> +#include "xfs_rmap.h"
> +#include "xfs_rmap_btree.h"
> +#include "xfs_inode.h"
> +#include "xfs_refcount.h"
> +#include "xfs_extent_busy.h"
> +#include "scrub/xfs_scrub.h"
> +#include "scrub/scrub.h"
> +#include "scrub/common.h"
> +#include "scrub/btree.h"
> +#include "scrub/trace.h"
> +#include "scrub/repair.h"
> +
> +/*
> + * Free Space Btree Repair
> + * =======================
> + *
> + * The reverse mappings are supposed to record all space usage for the entire
> + * AG.  Therefore, we can recalculate the free extents in an AG by looking for
> + * gaps in the physical extents recorded in the rmapbt.  On a reflink
> + * filesystem this is a little more tricky in that we have to be aware that
> + * the rmap records are allowed to overlap.
> + *
> + * We derive which blocks belonged to the old bnobt/cntbt by recording all the
> + * OWN_AG extents and subtracting out the blocks owned by all other OWN_AG
> + * metadata: the rmapbt blocks visited while iterating the reverse mappings
> + * and the AGFL blocks.
> + *
> + * Once we have both of those pieces, we can reconstruct the bnobt and cntbt
> + * by blowing out the free block state and freeing all the extents that we
> + * found.  This adds the requirement that we can't have any busy extents in
> + * the AG because the busy code cannot handle duplicate records.
> + *
> + * Note that we can only rebuild both free space btrees at the same time
> + * because the regular extent freeing infrastructure loads both btrees at the
> + * same time.
> + */
> +
> +struct xfs_repair_alloc_extent {
> +	struct list_head		list;
> +	xfs_agblock_t			bno;
> +	xfs_extlen_t			len;
> +};
> +
> +struct xfs_repair_alloc {
> +	struct xfs_repair_extent_list	nobtlist; /* rmapbt/agfl blocks */
> +	struct xfs_repair_extent_list	*btlist;  /* OWN_AG blocks */
> +	struct list_head		*extlist; /* free extents */
> +	struct xfs_scrub_context	*sc;
> +	uint64_t			nr_records; /* length of extlist */
> +	xfs_agblock_t			next_bno; /* next bno we want to see */
> +	xfs_agblock_t			nr_blocks; /* free blocks in extlist */
Align the comments on the right to a common column?

> +};
> +
> +/* Record extents that aren't in use from gaps in the rmap records. */
> +STATIC int
> +xfs_repair_alloc_extent_fn(
> +	struct xfs_btree_cur		*cur,
> +	struct xfs_rmap_irec		*rec,
> +	void				*priv)
> +{
> +	struct xfs_repair_alloc		*ra = priv;
> +	struct xfs_repair_alloc_extent	*rae;
> +	xfs_fsblock_t			fsb;
> +	int				error;
> +
> +	/* Record all the OWN_AG blocks... */
> +	if (rec->rm_owner == XFS_RMAP_OWN_AG) {
> +		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
> +				rec->rm_startblock);
> +		error = xfs_repair_collect_btree_extent(ra->sc,
> +				ra->btlist, fsb, rec->rm_blockcount);
> +		if (error)
> +			return error;
> +	}
> +
> +	/* ...and all the rmapbt blocks... */
> +	error = xfs_repair_collect_btree_cur_blocks(ra->sc, cur,
> +			xfs_repair_collect_btree_cur_blocks_in_extent_list,
> +			&ra->nobtlist);
> +	if (error)
> +		return error;
> +
> +	/* ...and all the free space. */
> +	if (rec->rm_startblock > ra->next_bno) {
> +		trace_xfs_repair_alloc_extent_fn(cur->bc_mp,
> +				cur->bc_private.a.agno,
> +				ra->next_bno, rec->rm_startblock - ra->next_bno,
> +				XFS_RMAP_OWN_NULL, 0, 0);
> +
> +		rae = kmem_alloc(sizeof(struct xfs_repair_alloc_extent),
> +				KM_MAYFAIL);
> +		if (!rae)
> +			return -ENOMEM;
> +		INIT_LIST_HEAD(&rae->list);
> +		rae->bno = ra->next_bno;
> +		rae->len = rec->rm_startblock - ra->next_bno;
> +		list_add_tail(&rae->list, ra->extlist);
> +		ra->nr_records++;
> +		ra->nr_blocks += rae->len;
> +	}
> +	ra->next_bno = max_t(xfs_agblock_t, ra->next_bno,
> +			rec->rm_startblock + rec->rm_blockcount);
> +	return 0;
> +}
Alrighty, seems to follow the commentary.  Thx!

> +
> +/* Collect an AGFL block for the not-to-release list. */
> +static int
> +xfs_repair_collect_agfl_block(
> +	struct xfs_mount		*mp,
> +	xfs_agblock_t			bno,
> +	void				*priv)
> +{
> +	struct xfs_repair_alloc		*ra = priv;
> +	xfs_fsblock_t			fsb;
> +
> +	fsb = XFS_AGB_TO_FSB(mp, ra->sc->sa.agno, bno);
> +	return xfs_repair_collect_btree_extent(ra->sc, &ra->nobtlist, fsb, 1);
> +}
> +
> +/* Compare two btree extents. */
> +static int
> +xfs_repair_allocbt_extent_cmp(
> +	void				*priv,
> +	struct list_head		*a,
> +	struct list_head		*b)
> +{
> +	struct xfs_repair_alloc_extent	*ap;
> +	struct xfs_repair_alloc_extent	*bp;
> +
> +	ap = container_of(a, struct xfs_repair_alloc_extent, list);
> +	bp = container_of(b, struct xfs_repair_alloc_extent, list);
> +
> +	if (ap->bno > bp->bno)
> +		return 1;
> +	else if (ap->bno < bp->bno)
> +		return -1;
> +	return 0;
> +}
> +
> +/* Put an extent onto the free list. */
> +STATIC int
> +xfs_repair_allocbt_free_extent(
While on the topic of name shortening, I've noticed other places
in the code shorten "extent" to "ext", and it seems pretty readable.
Just a suggestion if it helps :-)


> +	struct xfs_scrub_context	*sc,
> +	xfs_fsblock_t			fsbno,
> +	xfs_extlen_t			len,
> +	struct xfs_owner_info		*oinfo)
> +{
> +	int				error;
> +
> +	error = xfs_free_extent(sc->tp, fsbno, len, oinfo, 0);
> +	if (error)
> +		return error;
> +	error = xfs_repair_roll_ag_trans(sc);
> +	if (error)
> +		return error;
> +	return xfs_mod_fdblocks(sc->mp, -(int64_t)len, false);
> +}
> +
> +/* Find the longest free extent in the list. */
> +static struct xfs_repair_alloc_extent *
> +xfs_repair_allocbt_get_longest(
> +	struct list_head		*free_extents)
> +{
> +	struct xfs_repair_alloc_extent	*rae;
> +	struct xfs_repair_alloc_extent	*res = NULL;
> +
> +	list_for_each_entry(rae, free_extents, list) {
> +		if (!res || rae->len > res->len)
> +			res = rae;
> +	}
> +	return res;
> +}
> +
> +/* Find the shortest free extent in the list. */
> +static struct xfs_repair_alloc_extent *
> +xfs_repair_allocbt_get_shortest(
> +	struct list_head		*free_extents)
> +{
> +	struct xfs_repair_alloc_extent	*rae;
> +	struct xfs_repair_alloc_extent	*res = NULL;
> +
> +	list_for_each_entry(rae, free_extents, list) {
> +		if (!res || rae->len < res->len)
> +			res = rae;
> +		if (res->len == 1)
> +			break;
> +	}
> +	return res;
> +}
> +
> +/*
> + * Allocate a block from the (cached) shortest extent in the AG.  In theory
> + * this should never fail, since we already checked that there was enough
> + * space to handle the new btrees.
> + */
> +STATIC xfs_fsblock_t
> +xfs_repair_allocbt_alloc_block(
> +	struct xfs_scrub_context	*sc,
> +	struct list_head		*free_extents,
> +	struct xfs_repair_alloc_extent	**cached_result)
> +{
> +	struct xfs_repair_alloc_extent	*ext = *cached_result;
> +	xfs_fsblock_t			fsb;
> +
> +	/* No cached result, see if we can find another. */
> +	if (!ext) {
> +		ext = xfs_repair_allocbt_get_shortest(free_extents);
> +		ASSERT(ext);
> +		if (!ext)
> +			return NULLFSBLOCK;
> +	}
> +
> +	/* Subtract one block. */
> +	fsb = XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, ext->bno);
> +	ext->bno++;
> +	ext->len--;
> +	if (ext->len == 0) {
> +		list_del(&ext->list);
> +		kmem_free(ext);
> +		ext = NULL;
> +	}
> +
> +	*cached_result = ext;
> +	return fsb;
> +}
> +
> +/* Free every record in the extent list. */
> +STATIC void
> +xfs_repair_allocbt_cancel_freelist(
> +	struct list_head		*extlist)
> +{
> +	struct xfs_repair_alloc_extent	*rae;
> +	struct xfs_repair_alloc_extent	*n;
> +
> +	list_for_each_entry_safe(rae, n, extlist, list) {
> +		list_del(&rae->list);
> +		kmem_free(rae);
> +	}
> +}
> +
> +/*
> + * Iterate all reverse mappings to find (1) the free extents, (2) the OWN_AG
> + * extents, (3) the rmapbt blocks, and (4) the AGFL blocks.  The free space is
> + * (1) + (2) - (3) - (4).  Figure out if we have enough free space to
> + * reconstruct the free space btrees.  Caller must clean up the input lists
> + * if something goes wrong.
> + */
> +STATIC int
> +xfs_repair_allocbt_find_freespace(
> +	struct xfs_scrub_context	*sc,
> +	struct list_head		*free_extents,
> +	struct xfs_repair_extent_list	*old_allocbt_blocks)
> +{
> +	struct xfs_repair_alloc		ra;
> +	struct xfs_repair_alloc_extent	*rae;
> +	struct xfs_btree_cur		*cur;
> +	struct xfs_mount		*mp = sc->mp;
> +	xfs_agblock_t			agend;
> +	xfs_agblock_t			nr_blocks;
> +	int				error;
> +
> +	ra.extlist = free_extents;
> +	ra.btlist = old_allocbt_blocks;
> +	xfs_repair_init_extent_list(&ra.nobtlist);
> +	ra.next_bno = 0;
> +	ra.nr_records = 0;
> +	ra.nr_blocks = 0;
> +	ra.sc = sc;
> +
> +	/*
> +	 * Iterate all the reverse mappings to find gaps in the physical
> +	 * mappings, all the OWN_AG blocks, and all the rmapbt extents.
> +	 */
> +	cur = xfs_rmapbt_init_cursor(mp, sc->tp, sc->sa.agf_bp, sc->sa.agno);
> +	error = xfs_rmap_query_all(cur, xfs_repair_alloc_extent_fn, &ra);
> +	if (error)
> +		goto err;
> +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> +	cur = NULL;
> +
> +	/* Insert a record for space between the last rmap and EOAG. */
> +	agend = be32_to_cpu(XFS_BUF_TO_AGF(sc->sa.agf_bp)->agf_length);
> +	if (ra.next_bno < agend) {
> +		rae = kmem_alloc(sizeof(struct xfs_repair_alloc_extent),
> +				KM_MAYFAIL);
> +		if (!rae) {
> +			error = -ENOMEM;
> +			goto err;
> +		}
> +		INIT_LIST_HEAD(&rae->list);
> +		rae->bno = ra.next_bno;
> +		rae->len = agend - ra.next_bno;
> +		list_add_tail(&rae->list, free_extents);
> +		ra.nr_records++;
> +	}
> +
> +	/* Collect all the AGFL blocks. */
> +	error = xfs_agfl_walk(mp, XFS_BUF_TO_AGF(sc->sa.agf_bp),
> +			sc->sa.agfl_bp, xfs_repair_collect_agfl_block, &ra);
> +	if (error)
> +		goto err;
> +
> +	/* Do we actually have enough space to do this? */
> +	nr_blocks = 2 * xfs_allocbt_calc_size(mp, ra.nr_records);
> +	if (!xfs_repair_ag_has_space(sc->sa.pag, nr_blocks, XFS_AG_RESV_NONE) ||
> +	    ra.nr_blocks < nr_blocks) {
> +		error = -ENOSPC;
> +		goto err;
> +	}
> +
> +	/* Compute the old bnobt/cntbt blocks. */
> +	error = xfs_repair_subtract_extents(sc, old_allocbt_blocks,
> +			&ra.nobtlist);
> +	if (error)
> +		goto err;
> +	xfs_repair_cancel_btree_extents(sc, &ra.nobtlist);
> +	return 0;
> +
> +err:
> +	xfs_repair_cancel_btree_extents(sc, &ra.nobtlist);
> +	if (cur)
> +		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> +	return error;
> +}
Ok, makes sense after some digging. I might not have figured out the 2
had Dave not pointed that out though.  But for the most part the in body
comments help a lot.  Thx!

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=nNxagNoo077f7e1qascS_gP9gvh_A31xun9uDjsIiRw&s=pV06fEkJolQtBTE33dKzWHVyIvrswKx5pwP148R8jcs&e=
> 
