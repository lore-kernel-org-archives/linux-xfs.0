Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730340AbeG0Pnf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Jul 2018 11:43:35 -0400
Date: Fri, 27 Jul 2018 10:21:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/16] xfs: move the repair extent list into its own file
Message-ID: <20180727142121.GC22227@bfoster>
References: <153256436688.29021.4638459579042241728.stgit@magnolia>
 <153256437975.29021.14919845411774307079.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153256437975.29021.14919845411774307079.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

On Wed, Jul 25, 2018 at 05:19:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the xrep_extent_list code into a separate file.  Logically, this
> data structure is really just a clumsy bitmap, and in the next patch
> we'll make this more obvious.  No functional changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

I'm not terribly familiar with the existing code, but looks like a
straight move:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/Makefile       |    1 
>  fs/xfs/scrub/bitmap.c |  208 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/bitmap.h |   37 +++++++++
>  fs/xfs/scrub/repair.c |  194 ----------------------------------------------
>  fs/xfs/scrub/repair.h |   27 ------
>  5 files changed, 248 insertions(+), 219 deletions(-)
>  create mode 100644 fs/xfs/scrub/bitmap.c
>  create mode 100644 fs/xfs/scrub/bitmap.h
> 
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index a36cccbec169..57ec46951ede 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -164,6 +164,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
>  ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
>  xfs-y				+= $(addprefix scrub/, \
>  				   agheader_repair.o \
> +				   bitmap.o \
>  				   repair.o \
>  				   )
>  endif
> diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
> new file mode 100644
> index 000000000000..a7c2f4773f98
> --- /dev/null
> +++ b/fs/xfs/scrub/bitmap.c
> @@ -0,0 +1,208 @@
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
> +#include "scrub/xfs_scrub.h"
> +#include "scrub/scrub.h"
> +#include "scrub/common.h"
> +#include "scrub/trace.h"
> +#include "scrub/repair.h"
> +#include "scrub/bitmap.h"
> +
> +/* Collect a dead btree extent for later disposal. */
> +int
> +xrep_collect_btree_extent(
> +	struct xfs_scrub	*sc,
> +	struct xrep_extent_list	*exlist,
> +	xfs_fsblock_t		fsbno,
> +	xfs_extlen_t		len)
> +{
> +	struct xrep_extent	*rex;
> +
> +	trace_xrep_collect_btree_extent(sc->mp,
> +			XFS_FSB_TO_AGNO(sc->mp, fsbno),
> +			XFS_FSB_TO_AGBNO(sc->mp, fsbno), len);
> +
> +	rex = kmem_alloc(sizeof(struct xrep_extent), KM_MAYFAIL);
> +	if (!rex)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&rex->list);
> +	rex->fsbno = fsbno;
> +	rex->len = len;
> +	list_add_tail(&rex->list, &exlist->list);
> +
> +	return 0;
> +}
> +
> +/*
> + * An error happened during the rebuild so the transaction will be cancelled.
> + * The fs will shut down, and the administrator has to unmount and run repair.
> + * Therefore, free all the memory associated with the list so we can die.
> + */
> +void
> +xrep_cancel_btree_extents(
> +	struct xfs_scrub	*sc,
> +	struct xrep_extent_list	*exlist)
> +{
> +	struct xrep_extent	*rex;
> +	struct xrep_extent	*n;
> +
> +	for_each_xrep_extent_safe(rex, n, exlist) {
> +		list_del(&rex->list);
> +		kmem_free(rex);
> +	}
> +}
> +
> +/* Compare two btree extents. */
> +static int
> +xrep_btree_extent_cmp(
> +	void			*priv,
> +	struct list_head	*a,
> +	struct list_head	*b)
> +{
> +	struct xrep_extent	*ap;
> +	struct xrep_extent	*bp;
> +
> +	ap = container_of(a, struct xrep_extent, list);
> +	bp = container_of(b, struct xrep_extent, list);
> +
> +	if (ap->fsbno > bp->fsbno)
> +		return 1;
> +	if (ap->fsbno < bp->fsbno)
> +		return -1;
> +	return 0;
> +}
> +
> +/*
> + * Remove all the blocks mentioned in @sublist from the extents in @exlist.
> + *
> + * The intent is that callers will iterate the rmapbt for all of its records
> + * for a given owner to generate @exlist; and iterate all the blocks of the
> + * metadata structures that are not being rebuilt and have the same rmapbt
> + * owner to generate @sublist.  This routine subtracts all the extents
> + * mentioned in sublist from all the extents linked in @exlist, which leaves
> + * @exlist as the list of blocks that are not accounted for, which we assume
> + * are the dead blocks of the old metadata structure.  The blocks mentioned in
> + * @exlist can be reaped.
> + */
> +#define LEFT_ALIGNED	(1 << 0)
> +#define RIGHT_ALIGNED	(1 << 1)
> +int
> +xrep_subtract_extents(
> +	struct xfs_scrub	*sc,
> +	struct xrep_extent_list	*exlist,
> +	struct xrep_extent_list	*sublist)
> +{
> +	struct list_head	*lp;
> +	struct xrep_extent	*ex;
> +	struct xrep_extent	*newex;
> +	struct xrep_extent	*subex;
> +	xfs_fsblock_t		sub_fsb;
> +	xfs_extlen_t		sub_len;
> +	int			state;
> +	int			error = 0;
> +
> +	if (list_empty(&exlist->list) || list_empty(&sublist->list))
> +		return 0;
> +	ASSERT(!list_empty(&sublist->list));
> +
> +	list_sort(NULL, &exlist->list, xrep_btree_extent_cmp);
> +	list_sort(NULL, &sublist->list, xrep_btree_extent_cmp);
> +
> +	/*
> +	 * Now that we've sorted both lists, we iterate exlist once, rolling
> +	 * forward through sublist and/or exlist as necessary until we find an
> +	 * overlap or reach the end of either list.  We do not reset lp to the
> +	 * head of exlist nor do we reset subex to the head of sublist.  The
> +	 * list traversal is similar to merge sort, but we're deleting
> +	 * instead.  In this manner we avoid O(n^2) operations.
> +	 */
> +	subex = list_first_entry(&sublist->list, struct xrep_extent,
> +			list);
> +	lp = exlist->list.next;
> +	while (lp != &exlist->list) {
> +		ex = list_entry(lp, struct xrep_extent, list);
> +
> +		/*
> +		 * Advance subex and/or ex until we find a pair that
> +		 * intersect or we run out of extents.
> +		 */
> +		while (subex->fsbno + subex->len <= ex->fsbno) {
> +			if (list_is_last(&subex->list, &sublist->list))
> +				goto out;
> +			subex = list_next_entry(subex, list);
> +		}
> +		if (subex->fsbno >= ex->fsbno + ex->len) {
> +			lp = lp->next;
> +			continue;
> +		}
> +
> +		/* trim subex to fit the extent we have */
> +		sub_fsb = subex->fsbno;
> +		sub_len = subex->len;
> +		if (subex->fsbno < ex->fsbno) {
> +			sub_len -= ex->fsbno - subex->fsbno;
> +			sub_fsb = ex->fsbno;
> +		}
> +		if (sub_len > ex->len)
> +			sub_len = ex->len;
> +
> +		state = 0;
> +		if (sub_fsb == ex->fsbno)
> +			state |= LEFT_ALIGNED;
> +		if (sub_fsb + sub_len == ex->fsbno + ex->len)
> +			state |= RIGHT_ALIGNED;
> +		switch (state) {
> +		case LEFT_ALIGNED:
> +			/* Coincides with only the left. */
> +			ex->fsbno += sub_len;
> +			ex->len -= sub_len;
> +			break;
> +		case RIGHT_ALIGNED:
> +			/* Coincides with only the right. */
> +			ex->len -= sub_len;
> +			lp = lp->next;
> +			break;
> +		case LEFT_ALIGNED | RIGHT_ALIGNED:
> +			/* Total overlap, just delete ex. */
> +			lp = lp->next;
> +			list_del(&ex->list);
> +			kmem_free(ex);
> +			break;
> +		case 0:
> +			/*
> +			 * Deleting from the middle: add the new right extent
> +			 * and then shrink the left extent.
> +			 */
> +			newex = kmem_alloc(sizeof(struct xrep_extent),
> +					KM_MAYFAIL);
> +			if (!newex) {
> +				error = -ENOMEM;
> +				goto out;
> +			}
> +			INIT_LIST_HEAD(&newex->list);
> +			newex->fsbno = sub_fsb + sub_len;
> +			newex->len = ex->fsbno + ex->len - newex->fsbno;
> +			list_add(&newex->list, &ex->list);
> +			ex->len = sub_fsb - ex->fsbno;
> +			lp = lp->next;
> +			break;
> +		default:
> +			ASSERT(0);
> +			break;
> +		}
> +	}
> +
> +out:
> +	return error;
> +}
> +#undef LEFT_ALIGNED
> +#undef RIGHT_ALIGNED
> diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
> new file mode 100644
> index 000000000000..1038157695a8
> --- /dev/null
> +++ b/fs/xfs/scrub/bitmap.h
> @@ -0,0 +1,37 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2018 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#ifndef __XFS_SCRUB_BITMAP_H__
> +#define __XFS_SCRUB_BITMAP_H__
> +
> +struct xrep_extent {
> +	struct list_head	list;
> +	xfs_fsblock_t		fsbno;
> +	xfs_extlen_t		len;
> +};
> +
> +struct xrep_extent_list {
> +	struct list_head	list;
> +};
> +
> +static inline void
> +xrep_init_extent_list(
> +	struct xrep_extent_list		*exlist)
> +{
> +	INIT_LIST_HEAD(&exlist->list);
> +}
> +
> +#define for_each_xrep_extent_safe(rbe, n, exlist) \
> +	list_for_each_entry_safe((rbe), (n), &(exlist)->list, list)
> +int xrep_collect_btree_extent(struct xfs_scrub *sc,
> +		struct xrep_extent_list *btlist, xfs_fsblock_t fsbno,
> +		xfs_extlen_t len);
> +void xrep_cancel_btree_extents(struct xfs_scrub *sc,
> +		struct xrep_extent_list *btlist);
> +int xrep_subtract_extents(struct xfs_scrub *sc,
> +		struct xrep_extent_list *exlist,
> +		struct xrep_extent_list *sublist);
> +
> +#endif	/* __XFS_SCRUB_BITMAP_H__ */
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 5de1cac424ec..27a904ef6189 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -34,6 +34,7 @@
>  #include "scrub/common.h"
>  #include "scrub/trace.h"
>  #include "scrub/repair.h"
> +#include "scrub/bitmap.h"
>  
>  /*
>   * Attempt to repair some metadata, if the metadata is corrupt and userspace
> @@ -380,200 +381,7 @@ xrep_init_btblock(
>   * sublist.  As with the other btrees we subtract sublist from exlist, and the
>   * result (since the rmapbt lives in the free space) are the blocks from the
>   * old rmapbt.
> - */
> -
> -/* Collect a dead btree extent for later disposal. */
> -int
> -xrep_collect_btree_extent(
> -	struct xfs_scrub	*sc,
> -	struct xrep_extent_list	*exlist,
> -	xfs_fsblock_t		fsbno,
> -	xfs_extlen_t		len)
> -{
> -	struct xrep_extent	*rex;
> -
> -	trace_xrep_collect_btree_extent(sc->mp,
> -			XFS_FSB_TO_AGNO(sc->mp, fsbno),
> -			XFS_FSB_TO_AGBNO(sc->mp, fsbno), len);
> -
> -	rex = kmem_alloc(sizeof(struct xrep_extent), KM_MAYFAIL);
> -	if (!rex)
> -		return -ENOMEM;
> -
> -	INIT_LIST_HEAD(&rex->list);
> -	rex->fsbno = fsbno;
> -	rex->len = len;
> -	list_add_tail(&rex->list, &exlist->list);
> -
> -	return 0;
> -}
> -
> -/*
> - * An error happened during the rebuild so the transaction will be cancelled.
> - * The fs will shut down, and the administrator has to unmount and run repair.
> - * Therefore, free all the memory associated with the list so we can die.
> - */
> -void
> -xrep_cancel_btree_extents(
> -	struct xfs_scrub	*sc,
> -	struct xrep_extent_list	*exlist)
> -{
> -	struct xrep_extent	*rex;
> -	struct xrep_extent	*n;
> -
> -	for_each_xrep_extent_safe(rex, n, exlist) {
> -		list_del(&rex->list);
> -		kmem_free(rex);
> -	}
> -}
> -
> -/* Compare two btree extents. */
> -static int
> -xrep_btree_extent_cmp(
> -	void			*priv,
> -	struct list_head	*a,
> -	struct list_head	*b)
> -{
> -	struct xrep_extent	*ap;
> -	struct xrep_extent	*bp;
> -
> -	ap = container_of(a, struct xrep_extent, list);
> -	bp = container_of(b, struct xrep_extent, list);
> -
> -	if (ap->fsbno > bp->fsbno)
> -		return 1;
> -	if (ap->fsbno < bp->fsbno)
> -		return -1;
> -	return 0;
> -}
> -
> -/*
> - * Remove all the blocks mentioned in @sublist from the extents in @exlist.
>   *
> - * The intent is that callers will iterate the rmapbt for all of its records
> - * for a given owner to generate @exlist; and iterate all the blocks of the
> - * metadata structures that are not being rebuilt and have the same rmapbt
> - * owner to generate @sublist.  This routine subtracts all the extents
> - * mentioned in sublist from all the extents linked in @exlist, which leaves
> - * @exlist as the list of blocks that are not accounted for, which we assume
> - * are the dead blocks of the old metadata structure.  The blocks mentioned in
> - * @exlist can be reaped.
> - */
> -#define LEFT_ALIGNED	(1 << 0)
> -#define RIGHT_ALIGNED	(1 << 1)
> -int
> -xrep_subtract_extents(
> -	struct xfs_scrub	*sc,
> -	struct xrep_extent_list	*exlist,
> -	struct xrep_extent_list	*sublist)
> -{
> -	struct list_head	*lp;
> -	struct xrep_extent	*ex;
> -	struct xrep_extent	*newex;
> -	struct xrep_extent	*subex;
> -	xfs_fsblock_t		sub_fsb;
> -	xfs_extlen_t		sub_len;
> -	int			state;
> -	int			error = 0;
> -
> -	if (list_empty(&exlist->list) || list_empty(&sublist->list))
> -		return 0;
> -	ASSERT(!list_empty(&sublist->list));
> -
> -	list_sort(NULL, &exlist->list, xrep_btree_extent_cmp);
> -	list_sort(NULL, &sublist->list, xrep_btree_extent_cmp);
> -
> -	/*
> -	 * Now that we've sorted both lists, we iterate exlist once, rolling
> -	 * forward through sublist and/or exlist as necessary until we find an
> -	 * overlap or reach the end of either list.  We do not reset lp to the
> -	 * head of exlist nor do we reset subex to the head of sublist.  The
> -	 * list traversal is similar to merge sort, but we're deleting
> -	 * instead.  In this manner we avoid O(n^2) operations.
> -	 */
> -	subex = list_first_entry(&sublist->list, struct xrep_extent,
> -			list);
> -	lp = exlist->list.next;
> -	while (lp != &exlist->list) {
> -		ex = list_entry(lp, struct xrep_extent, list);
> -
> -		/*
> -		 * Advance subex and/or ex until we find a pair that
> -		 * intersect or we run out of extents.
> -		 */
> -		while (subex->fsbno + subex->len <= ex->fsbno) {
> -			if (list_is_last(&subex->list, &sublist->list))
> -				goto out;
> -			subex = list_next_entry(subex, list);
> -		}
> -		if (subex->fsbno >= ex->fsbno + ex->len) {
> -			lp = lp->next;
> -			continue;
> -		}
> -
> -		/* trim subex to fit the extent we have */
> -		sub_fsb = subex->fsbno;
> -		sub_len = subex->len;
> -		if (subex->fsbno < ex->fsbno) {
> -			sub_len -= ex->fsbno - subex->fsbno;
> -			sub_fsb = ex->fsbno;
> -		}
> -		if (sub_len > ex->len)
> -			sub_len = ex->len;
> -
> -		state = 0;
> -		if (sub_fsb == ex->fsbno)
> -			state |= LEFT_ALIGNED;
> -		if (sub_fsb + sub_len == ex->fsbno + ex->len)
> -			state |= RIGHT_ALIGNED;
> -		switch (state) {
> -		case LEFT_ALIGNED:
> -			/* Coincides with only the left. */
> -			ex->fsbno += sub_len;
> -			ex->len -= sub_len;
> -			break;
> -		case RIGHT_ALIGNED:
> -			/* Coincides with only the right. */
> -			ex->len -= sub_len;
> -			lp = lp->next;
> -			break;
> -		case LEFT_ALIGNED | RIGHT_ALIGNED:
> -			/* Total overlap, just delete ex. */
> -			lp = lp->next;
> -			list_del(&ex->list);
> -			kmem_free(ex);
> -			break;
> -		case 0:
> -			/*
> -			 * Deleting from the middle: add the new right extent
> -			 * and then shrink the left extent.
> -			 */
> -			newex = kmem_alloc(sizeof(struct xrep_extent),
> -					KM_MAYFAIL);
> -			if (!newex) {
> -				error = -ENOMEM;
> -				goto out;
> -			}
> -			INIT_LIST_HEAD(&newex->list);
> -			newex->fsbno = sub_fsb + sub_len;
> -			newex->len = ex->fsbno + ex->len - newex->fsbno;
> -			list_add(&newex->list, &ex->list);
> -			ex->len = sub_fsb - ex->fsbno;
> -			lp = lp->next;
> -			break;
> -		default:
> -			ASSERT(0);
> -			break;
> -		}
> -	}
> -
> -out:
> -	return error;
> -}
> -#undef LEFT_ALIGNED
> -#undef RIGHT_ALIGNED
> -
> -/*
>   * Disposal of Blocks from Old per-AG Btrees
>   *
>   * Now that we've constructed a new btree to replace the damaged one, we want
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index 91355f6b0087..a3d491a438f4 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -27,33 +27,8 @@ int xrep_init_btblock(struct xfs_scrub *sc, xfs_fsblock_t fsb,
>  		struct xfs_buf **bpp, xfs_btnum_t btnum,
>  		const struct xfs_buf_ops *ops);
>  
> -struct xrep_extent {
> -	struct list_head	list;
> -	xfs_fsblock_t		fsbno;
> -	xfs_extlen_t		len;
> -};
> -
> -struct xrep_extent_list {
> -	struct list_head	list;
> -};
> -
> -static inline void
> -xrep_init_extent_list(
> -	struct xrep_extent_list	*exlist)
> -{
> -	INIT_LIST_HEAD(&exlist->list);
> -}
> +struct xrep_extent_list;
>  
> -#define for_each_xrep_extent_safe(rbe, n, exlist) \
> -	list_for_each_entry_safe((rbe), (n), &(exlist)->list, list)
> -int xrep_collect_btree_extent(struct xfs_scrub *sc,
> -		struct xrep_extent_list *btlist, xfs_fsblock_t fsbno,
> -		xfs_extlen_t len);
> -void xrep_cancel_btree_extents(struct xfs_scrub *sc,
> -		struct xrep_extent_list *btlist);
> -int xrep_subtract_extents(struct xfs_scrub *sc,
> -		struct xrep_extent_list *exlist,
> -		struct xrep_extent_list *sublist);
>  int xrep_fix_freelist(struct xfs_scrub *sc, bool can_shrink);
>  int xrep_invalidate_blocks(struct xfs_scrub *sc,
>  		struct xrep_extent_list *btlist);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
