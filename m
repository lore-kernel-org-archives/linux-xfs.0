Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35692 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbfHMNgS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Aug 2019 09:36:18 -0400
Date: Tue, 13 Aug 2019 09:36:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
Message-ID: <20190813133614.GD37069@bfoster>
References: <5f2ab55c-c1ef-a8f2-5662-b35e0838b979@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f2ab55c-c1ef-a8f2-5662-b35e0838b979@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: kaixuxia <xiakaixu1987@gmail.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, newtongao@tencent.com, jasperwang@tencent.com

On Tue, Aug 13, 2019 at 07:17:33PM +0800, kaixuxia wrote:
> When performing rename operation with RENAME_WHITEOUT flag, we will
> hold AGF lock to allocate or free extents in manipulating the dirents
> firstly, and then doing the xfs_iunlink_remove() call last to hold
> AGI lock to modify the tmpfile info, so we the lock order AGI->AGF.
> 

IIUC, the whiteout use case is that we're renaming a file, but the
source dentry must be replaced with a magic whiteout inode rather than
be removed. Therefore, xfs_rename() allocates the whiteout inode as a
tmpfile first in a separate transaction, updates the target dentry with
the source inode, replaces the source dentry to point to the whiteout
inode and finally removes the whiteout inode from the unlinked list
(since it is a tmpfile). This leads to the problem described below
because the rename transaction ends up doing directory block allocs
(locking the AGF) followed by the unlinked list remove (locking the
AGI).

My understanding from reading the code is that this is primarly to
cleanly handle error scenarios. If anything fails after we've allocated
the whiteout tmpfile, it's simply left on the unlinked list and so the
filesystem remains in a consistent/recoverable state. Given that, the
solution here seems like overkill to me. For one, I thought background
unlinked list removal was already on our roadmap (Darrick might have
been looking at that and may already have a prototype as well). Also,
unlinked list removal occurs at log recovery time already. That's
somewhat of an existing purpose of the list, which makes a deferred
unlinked list removal operation superfluous in more traditional cases
where unlinked list removal doesn't require consistency with a directory
operation.

Functional discussion aside.. from a complexity standpoint I'm wondering
if we could do something much more simple like acquire the AGI lock for
a whiteout inode earlier in xfs_rename(). For example, suppose we did
something like:

	/*
	 * Acquire the whiteout agi to preserve locking order in anticipation of
	 * unlinked list removal.
	 */
	if (wip)
		xfs_read_agi(mp, tp, XFS_INO_TO_AGNO(mp, wip->i_ino), &agibp);

... after we allocate the transaction but before we do any directory ops
that can result in block allocations. Would that prevent the problem
you've observed?

Brian

> The big problem here is that we have an ordering constraint on AGF
> and AGI locking - inode allocation locks the AGI, then can allocate
> a new extent for new inodes, locking the AGF after the AGI. Hence
> the ordering that is imposed by other parts of the code is AGI before
> AGF. So we get the ABBA agi&agf deadlock here.
> 
> Process A:
> Call trace:
>  ? __schedule+0x2bd/0x620
>  schedule+0x33/0x90
>  schedule_timeout+0x17d/0x290
>  __down_common+0xef/0x125
>  ? xfs_buf_find+0x215/0x6c0 [xfs]
>  down+0x3b/0x50
>  xfs_buf_lock+0x34/0xf0 [xfs]
>  xfs_buf_find+0x215/0x6c0 [xfs]
>  xfs_buf_get_map+0x37/0x230 [xfs]
>  xfs_buf_read_map+0x29/0x190 [xfs]
>  xfs_trans_read_buf_map+0x13d/0x520 [xfs]
>  xfs_read_agf+0xa6/0x180 [xfs]
>  ? schedule_timeout+0x17d/0x290
>  xfs_alloc_read_agf+0x52/0x1f0 [xfs]
>  xfs_alloc_fix_freelist+0x432/0x590 [xfs]
>  ? down+0x3b/0x50
>  ? xfs_buf_lock+0x34/0xf0 [xfs]
>  ? xfs_buf_find+0x215/0x6c0 [xfs]
>  xfs_alloc_vextent+0x301/0x6c0 [xfs]
>  xfs_ialloc_ag_alloc+0x182/0x700 [xfs]
>  ? _xfs_trans_bjoin+0x72/0xf0 [xfs]
>  xfs_dialloc+0x116/0x290 [xfs]
>  xfs_ialloc+0x6d/0x5e0 [xfs]
>  ? xfs_log_reserve+0x165/0x280 [xfs]
>  xfs_dir_ialloc+0x8c/0x240 [xfs]
>  xfs_create+0x35a/0x610 [xfs]
>  xfs_generic_create+0x1f1/0x2f0 [xfs]
>  ...
> 
> Process B:
> Call trace:
>  ? __schedule+0x2bd/0x620
>  ? xfs_bmapi_allocate+0x245/0x380 [xfs]
>  schedule+0x33/0x90
>  schedule_timeout+0x17d/0x290
>  ? xfs_buf_find+0x1fd/0x6c0 [xfs]
>  __down_common+0xef/0x125
>  ? xfs_buf_get_map+0x37/0x230 [xfs]
>  ? xfs_buf_find+0x215/0x6c0 [xfs]
>  down+0x3b/0x50
>  xfs_buf_lock+0x34/0xf0 [xfs]
>  xfs_buf_find+0x215/0x6c0 [xfs]
>  xfs_buf_get_map+0x37/0x230 [xfs]
>  xfs_buf_read_map+0x29/0x190 [xfs]
>  xfs_trans_read_buf_map+0x13d/0x520 [xfs]
>  xfs_read_agi+0xa8/0x160 [xfs]
>  xfs_iunlink_remove+0x6f/0x2a0 [xfs]
>  ? current_time+0x46/0x80
>  ? xfs_trans_ichgtime+0x39/0xb0 [xfs]
>  xfs_rename+0x57a/0xae0 [xfs]
>  xfs_vn_rename+0xe4/0x150 [xfs]
>  ...
> 
> In this patch we make the unlinked list removal a deferred operation,
> i.e. log an iunlink remove intent and then do it after the RENAME_WHITEOUT
> transaction has committed, and the iunlink remove intention and done
> log items are provided.
> 
> Change the ordering of the operations in the xfs_rename() function
> to hold the AGF lock in the RENAME_WHITEOUT transaction and hold the
> AGI lock in it's own transaction to match that of the rest of the code.
> 
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---
>  fs/xfs/Makefile                |   1 +
>  fs/xfs/libxfs/xfs_defer.c      |   1 +
>  fs/xfs/libxfs/xfs_defer.h      |   2 +
>  fs/xfs/libxfs/xfs_log_format.h |  27 ++-
>  fs/xfs/xfs_inode.c             |  36 +---
>  fs/xfs/xfs_inode.h             |   3 +
>  fs/xfs/xfs_iunlinkrm_item.c    | 458 +++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_iunlinkrm_item.h    |  67 ++++++
>  fs/xfs/xfs_log.c               |   2 +
>  fs/xfs/xfs_log_recover.c       | 148 +++++++++++++
>  fs/xfs/xfs_super.c             |  17 ++
>  fs/xfs/xfs_trans.h             |   2 +
>  12 files changed, 733 insertions(+), 31 deletions(-)
>  create mode 100644 fs/xfs/xfs_iunlinkrm_item.c
>  create mode 100644 fs/xfs/xfs_iunlinkrm_item.h
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 06b68b6..9d5012e 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -106,6 +106,7 @@ xfs-y				+= xfs_log.o \
>  				   xfs_inode_item.o \
>  				   xfs_refcount_item.o \
>  				   xfs_rmap_item.o \
> +				   xfs_iunlinkrm_item.o \
>  				   xfs_log_recover.o \
>  				   xfs_trans_ail.o \
>  				   xfs_trans_buf.o
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index eb2be2a..a0f0a3d 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -176,6 +176,7 @@
>  	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
>  	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
>  	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
> +	[XFS_DEFER_OPS_TYPE_IUNRE]	= &xfs_iunlink_remove_defer_type,
>  };
> 
>  /*
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 7c28d76..9e91a36 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -17,6 +17,7 @@ enum xfs_defer_ops_type {
>  	XFS_DEFER_OPS_TYPE_RMAP,
>  	XFS_DEFER_OPS_TYPE_FREE,
>  	XFS_DEFER_OPS_TYPE_AGFL_FREE,
> +	XFS_DEFER_OPS_TYPE_IUNRE,
>  	XFS_DEFER_OPS_TYPE_MAX,
>  };
> 
> @@ -60,5 +61,6 @@ struct xfs_defer_op_type {
>  extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
>  extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
>  extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
> +extern const struct xfs_defer_op_type xfs_iunlink_remove_defer_type;
> 
>  #endif /* __XFS_DEFER_H__ */
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index e5f97c6..dc85b28 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -117,7 +117,9 @@ struct xfs_unmount_log_format {
>  #define XLOG_REG_TYPE_CUD_FORMAT	24
>  #define XLOG_REG_TYPE_BUI_FORMAT	25
>  #define XLOG_REG_TYPE_BUD_FORMAT	26
> -#define XLOG_REG_TYPE_MAX		26
> +#define XLOG_REG_TYPE_IRI_FORMAT	27
> +#define XLOG_REG_TYPE_IRD_FORMAT	28
> +#define XLOG_REG_TYPE_MAX		28
> 
>  /*
>   * Flags to log operation header
> @@ -240,6 +242,8 @@ struct xfs_unmount_log_format {
>  #define	XFS_LI_CUD		0x1243
>  #define	XFS_LI_BUI		0x1244	/* bmbt update intent */
>  #define	XFS_LI_BUD		0x1245
> +#define	XFS_LI_IRI		0x1246	/* iunlink remove intent */
> +#define	XFS_LI_IRD		0x1247
> 
>  #define XFS_LI_TYPE_DESC \
>  	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
> @@ -255,7 +259,9 @@ struct xfs_unmount_log_format {
>  	{ XFS_LI_CUI,		"XFS_LI_CUI" }, \
>  	{ XFS_LI_CUD,		"XFS_LI_CUD" }, \
>  	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
> -	{ XFS_LI_BUD,		"XFS_LI_BUD" }
> +	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
> +	{ XFS_LI_IRI,		"XFS_LI_IRI" }, \
> +	{ XFS_LI_IRD,		"XFS_LI_IRD" }
> 
>  /*
>   * Inode Log Item Format definitions.
> @@ -773,6 +779,23 @@ struct xfs_bud_log_format {
>  };
> 
>  /*
> + * This is the structure used to lay out iri&ird log item in the log.
> + */
> +typedef struct xfs_iri_log_format {
> +	uint16_t		iri_type;	/* iri log item type */
> +	uint16_t		iri_size;	/* size of this item */
> +	uint64_t		iri_id;		/* id of corresponding iri */
> +	uint64_t		wip_ino;	/* inode number */
> +} xfs_iri_log_format_t;
> +
> +typedef struct xfs_ird_log_format {
> +	uint16_t		ird_type;	/* ird log item type */
> +	uint16_t		ird_size;	/* size of this item */
> +	uint64_t		ird_iri_id;	/* id of corresponding iri */
> +	uint64_t		wip_ino;	/* inode number */
> +} xfs_ird_log_format_t;
> +
> +/*
>   * Dquot Log format definitions.
>   *
>   * The first two fields must be the type and size fitting into
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 6467d5e..7bb3102 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -35,6 +35,7 @@
>  #include "xfs_log.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_reflink.h"
> +#include "xfs_iunlinkrm_item.h"
> 
>  kmem_zone_t *xfs_inode_zone;
> 
> @@ -46,7 +47,6 @@
> 
>  STATIC int xfs_iflush_int(struct xfs_inode *, struct xfs_buf *);
>  STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
> -STATIC int xfs_iunlink_remove(struct xfs_trans *, struct xfs_inode *);
> 
>  /*
>   * helper function to extract extent size hint from inode
> @@ -1110,7 +1110,7 @@
>  /*
>   * Increment the link count on an inode & log the change.
>   */
> -static void
> +void
>  xfs_bumplink(
>  	xfs_trans_t *tp,
>  	xfs_inode_t *ip)
> @@ -2406,7 +2406,7 @@ struct xfs_iunlink {
>  /*
>   * Pull the on-disk inode from the AGI unlinked list.
>   */
> -STATIC int
> +int
>  xfs_iunlink_remove(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip)
> @@ -3261,8 +3261,6 @@ struct xfs_iunlink {
>  	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
>  	if (target_ip)
>  		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
> -	if (wip)
> -		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
> 
>  	/*
>  	 * If we are using project inheritance, we only allow renames
> @@ -3417,35 +3415,15 @@ struct xfs_iunlink {
>  	if (error)
>  		goto out_trans_cancel;
> 
> -	/*
> -	 * For whiteouts, we need to bump the link count on the whiteout inode.
> -	 * This means that failures all the way up to this point leave the inode
> -	 * on the unlinked list and so cleanup is a simple matter of dropping
> -	 * the remaining reference to it. If we fail here after bumping the link
> -	 * count, we're shutting down the filesystem so we'll never see the
> -	 * intermediate state on disk.
> -	 */
> -	if (wip) {
> -		ASSERT(VFS_I(wip)->i_nlink == 0);
> -		xfs_bumplink(tp, wip);
> -		error = xfs_iunlink_remove(tp, wip);
> -		if (error)
> -			goto out_trans_cancel;
> -		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
> -
> -		/*
> -		 * Now we have a real link, clear the "I'm a tmpfile" state
> -		 * flag from the inode so it doesn't accidentally get misused in
> -		 * future.
> -		 */
> -		VFS_I(wip)->i_state &= ~I_LINKABLE;
> -	}
> -
>  	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
>  	if (new_parent)
>  		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
> 
> +	/* add the iunlink remove intent to the tp */
> +	if (wip)
> +		xfs_iunlink_remove_add(tp, wip);
> +
>  	error = xfs_finish_rename(tp);
>  	if (wip)
>  		xfs_irele(wip);
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 558173f..f8c30ca 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -20,6 +20,7 @@
>  struct xfs_mount;
>  struct xfs_trans;
>  struct xfs_dquot;
> +struct xfs_trans;
> 
>  typedef struct xfs_inode {
>  	/* Inode linking and identification information. */
> @@ -414,6 +415,7 @@ enum layout_break_reason {
>  void		xfs_inactive(struct xfs_inode *ip);
>  int		xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
>  			   struct xfs_inode **ipp, struct xfs_name *ci_name);
> +void		xfs_bumplink(struct xfs_trans *, struct xfs_inode *);
>  int		xfs_create(struct xfs_inode *dp, struct xfs_name *name,
>  			   umode_t mode, dev_t rdev, struct xfs_inode **ipp);
>  int		xfs_create_tmpfile(struct xfs_inode *dp, umode_t mode,
> @@ -436,6 +438,7 @@ int		xfs_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,
>  uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
> 
>  uint		xfs_ip2xflags(struct xfs_inode *);
> +int		xfs_iunlink_remove(struct xfs_trans *, struct xfs_inode *);
>  int		xfs_ifree(struct xfs_trans *, struct xfs_inode *);
>  int		xfs_itruncate_extents_flags(struct xfs_trans **,
>  				struct xfs_inode *, int, xfs_fsize_t, int);
> diff --git a/fs/xfs/xfs_iunlinkrm_item.c b/fs/xfs/xfs_iunlinkrm_item.c
> new file mode 100644
> index 0000000..4e38329
> --- /dev/null
> +++ b/fs/xfs/xfs_iunlinkrm_item.c
> @@ -0,0 +1,458 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2019 Tencent.  All Rights Reserved.
> + * Author: Kaixuxia <kaixuxia@tencent.com>
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_bit.h"
> +#include "xfs_shared.h"
> +#include "xfs_mount.h"
> +#include "xfs_defer.h"
> +#include "xfs_trans.h"
> +#include "xfs_trans_priv.h"
> +#include "xfs_log.h"
> +#include "xfs_alloc.h"
> +#include "xfs_inode.h"
> +#include "xfs_icache.h"
> +#include "xfs_iunlinkrm_item.h"
> +
> +kmem_zone_t	*xfs_iri_zone;
> +kmem_zone_t	*xfs_ird_zone;
> +
> +static inline struct xfs_iri_log_item *IRI_ITEM(struct xfs_log_item *lip)
> +{
> +	return container_of(lip, struct xfs_iri_log_item, iri_item);
> +}
> +
> +void
> +xfs_iri_item_free(
> +	struct xfs_iri_log_item *irip)
> +{
> +	kmem_zone_free(xfs_iri_zone, irip);
> +}
> +
> +/*
> + * Freeing the iri requires that we remove it from the AIL if it has already
> + * been placed there. However, the IRI may not yet have been placed in the AIL
> + * when called by xfs_iri_release() from IRD processing due to the ordering of
> + * committed vs unpin operations in bulk insert operations. Hence the reference
> + * count to ensure only the last caller frees the IRI.
> + */
> +void
> +xfs_iri_release(
> +	struct xfs_iri_log_item *irip)
> +{
> +	ASSERT(atomic_read(&irip->iri_refcount) > 0);
> +	if (atomic_dec_and_test(&irip->iri_refcount)) {
> +		xfs_trans_ail_remove(&irip->iri_item, SHUTDOWN_LOG_IO_ERROR);
> +		xfs_iri_item_free(irip);
> +	}
> +}
> +
> +static inline int
> +xfs_iri_item_sizeof(
> +	struct xfs_iri_log_item *irip)
> +{
> +	return sizeof(struct xfs_iri_log_format);
> +}
> +
> +STATIC void
> +xfs_iri_item_size(
> +	struct xfs_log_item	*lip,
> +	int			*nvecs,
> +	int			*nbytes)
> +{
> +	*nvecs += 1;
> +	*nbytes += xfs_iri_item_sizeof(IRI_ITEM(lip));
> +}
> +
> +STATIC void
> +xfs_iri_item_format(
> +	struct xfs_log_item	*lip,
> +	struct xfs_log_vec	*lv)
> +{
> +	struct xfs_iri_log_item	*irip = IRI_ITEM(lip);
> +	struct xfs_log_iovec	*vecp = NULL;
> +
> +	irip->iri_format.iri_type = XFS_LI_IRI;
> +	irip->iri_format.iri_size = 1;
> +
> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_IRI_FORMAT,
> +			&irip->iri_format,
> +			xfs_iri_item_sizeof(irip));
> +}
> +
> +/*
> + * The unpin operation is the last place an IRI is manipulated in the log. It is
> + * either inserted in the AIL or aborted in the event of a log I/O error. In
> + * either case, the IRI transaction has been successfully committed to make it
> + * this far. Therefore, we expect whoever committed the IRI to either construct
> + * and commit the IRD or drop the IRD's reference in the event of error. Simply
> + * drop the log's IRI reference now that the log is done with it.
> + */
> +STATIC void
> +xfs_iri_item_unpin(
> +	struct xfs_log_item	*lip,
> +	int			remove)
> +{
> +	struct xfs_iri_log_item *irip = IRI_ITEM(lip);
> +	xfs_iri_release(irip);
> +}
> +
> +/*
> + * The IRI has been either committed or aborted if the transaction has been
> + * cancelled. If the transaction was cancelled, an IRD isn't going to be
> + * constructed and thus we free the IRI here directly.
> + */
> +STATIC void
> +xfs_iri_item_release(
> +	struct xfs_log_item     *lip)
> +{
> +	xfs_iri_release(IRI_ITEM(lip));
> +}
> +
> +/*
> + * This is the ops vector shared by all iri log items.
> + */
> +static const struct xfs_item_ops xfs_iri_item_ops = {
> +	.iop_size	= xfs_iri_item_size,
> +	.iop_format	= xfs_iri_item_format,
> +	.iop_unpin	= xfs_iri_item_unpin,
> +	.iop_release	= xfs_iri_item_release,
> +};
> +
> +/*
> + * Allocate and initialize an iri item with the given wip ino.
> + */
> +struct xfs_iri_log_item *
> +xfs_iri_init(struct xfs_mount  *mp,
> +	     uint		count)
> +{
> +	struct xfs_iri_log_item *irip;
> +
> +	irip = kmem_zone_zalloc(xfs_iri_zone, KM_SLEEP);
> +
> +	xfs_log_item_init(mp, &irip->iri_item, XFS_LI_IRI, &xfs_iri_item_ops);
> +	irip->iri_format.iri_id = (uintptr_t)(void *)irip;
> +	atomic_set(&irip->iri_refcount, 2);
> +
> +	return irip;
> +}
> +
> +static inline struct xfs_ird_log_item *IRD_ITEM(struct xfs_log_item *lip)
> +{
> +	return container_of(lip, struct xfs_ird_log_item, ird_item);
> +}
> +
> +STATIC void
> +xfs_ird_item_free(struct xfs_ird_log_item *irdp)
> +{
> +	kmem_zone_free(xfs_ird_zone, irdp);
> +}
> +
> +/*
> + * This returns the number of iovecs needed to log the given ird item.
> + * We only need 1 iovec for an ird item.  It just logs the ird_log_format
> + * structure.
> + */
> +STATIC void
> +xfs_ird_item_size(
> +	struct xfs_log_item	*lip,
> +	int			*nvecs,
> +	int			*nbytes)
> +{
> +	*nvecs += 1;
> +	*nbytes += sizeof(struct xfs_ird_log_format);
> +}
> +
> +STATIC void
> +xfs_ird_item_format(
> +	struct xfs_log_item	*lip,
> +	struct xfs_log_vec	*lv)
> +{
> +	struct xfs_ird_log_item *irdp = IRD_ITEM(lip);
> +	struct xfs_log_iovec	*vecp = NULL;
> +
> +	irdp->ird_format.ird_type = XFS_LI_IRD;
> +	irdp->ird_format.ird_size = 1;
> +
> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_IRD_FORMAT, &irdp->ird_format,
> +			sizeof(struct xfs_ird_log_format));
> +}
> +
> +/*
> + * The IRD is either committed or aborted if the transaction is cancelled. If
> + * the transaction is cancelled, drop our reference to the IRI and free the
> + * IRD.
> + */
> +STATIC void
> +xfs_ird_item_release(
> +	struct xfs_log_item	*lip)
> +{
> +	struct xfs_ird_log_item	*irdp = IRD_ITEM(lip);
> +
> +	xfs_iri_release(irdp->ird_irip);
> +	xfs_ird_item_free(irdp);
> +}
> +
> +static const struct xfs_item_ops xfs_ird_item_ops = {
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.iop_size	= xfs_ird_item_size,
> +	.iop_format	= xfs_ird_item_format,
> +	.iop_release	= xfs_ird_item_release,
> +};
> +
> +static struct xfs_ird_log_item *
> +xfs_trans_get_ird(
> +	struct xfs_trans		*tp,
> +	struct xfs_iri_log_item		*irip)
> +{
> +	xfs_ird_log_item_t	*irdp;
> +
> +	ASSERT(tp != NULL);
> +
> +	irdp = kmem_zone_zalloc(xfs_ird_zone, KM_SLEEP);
> +	xfs_log_item_init(tp->t_mountp, &irdp->ird_item, XFS_LI_IRD,
> +			  &xfs_ird_item_ops);
> +	irdp->ird_irip = irip;
> +	irdp->ird_format.wip_ino = irip->iri_format.wip_ino;
> +	irdp->ird_format.ird_iri_id = irip->iri_format.iri_id;
> +
> +	xfs_trans_add_item(tp, &irdp->ird_item);
> +	return irdp;
> +}
> +
> +/* record a iunlink remove intent */
> +int
> +xfs_iunlink_remove_add(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*wip)
> +{
> +	struct xfs_iunlink_remove_intent	*ii;
> +
> +	ii = kmem_alloc(sizeof(struct xfs_iunlink_remove_intent),
> +			KM_SLEEP | KM_NOFS);
> +	INIT_LIST_HEAD(&ii->ri_list);
> +	ii->wip = wip;
> +
> +	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_IUNRE, &ii->ri_list);
> +	return 0;
> +}
> +
> +/* Sort iunlink remove intents by AG. */
> +static int
> +xfs_iunlink_remove_diff_items(
> +	void				*priv,
> +	struct list_head		*a,
> +	struct list_head		*b)
> +{
> +	struct xfs_mount			*mp = priv;
> +	struct xfs_iunlink_remove_intent	*ra;
> +	struct xfs_iunlink_remove_intent	*rb;
> +
> +	ra = container_of(a, struct xfs_iunlink_remove_intent, ri_list);
> +	rb = container_of(b, struct xfs_iunlink_remove_intent, ri_list);
> +	return	XFS_INO_TO_AGNO(mp, ra->wip->i_ino) -
> +		XFS_INO_TO_AGNO(mp, rb->wip->i_ino);
> +}
> +
> +/* Get an IRI */
> +STATIC void *
> +xfs_iunlink_remove_create_intent(
> +	struct xfs_trans		*tp,
> +	unsigned int			count)
> +{
> +	struct xfs_iri_log_item		*irip;
> +
> +	ASSERT(tp != NULL);
> +	ASSERT(count == 1);
> +
> +	irip = xfs_iri_init(tp->t_mountp, count);
> +	ASSERT(irip != NULL);
> +
> +	/*
> +	 * Get a log_item_desc to point at the new item.
> +	 */
> +	xfs_trans_add_item(tp, &irip->iri_item);
> +	return irip;
> +}
> +
> +/* Log a iunlink remove to the intent item. */
> +STATIC void
> +xfs_iunlink_remove_log_item(
> +	struct xfs_trans		*tp,
> +	void				*intent,
> +	struct list_head		*item)
> +{
> +	struct xfs_iri_log_item			*irip = intent;
> +	struct xfs_iunlink_remove_intent	*iunre;
> +
> +	iunre = container_of(item, struct xfs_iunlink_remove_intent, ri_list);
> +
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &irip->iri_item.li_flags);
> +
> +	irip->iri_format.wip_ino = (uint64_t)(iunre->wip->i_ino);
> +}
> +
> +/* Get an IRD so we can process all the deferred iunlink remove. */
> +STATIC void *
> +xfs_iunlink_remove_create_done(
> +	struct xfs_trans		*tp,
> +	void				*intent,
> +	unsigned int			count)
> +{
> +	return xfs_trans_get_ird(tp, intent);
> +}
> +
> +/*
> + * For whiteouts, we need to bump the link count on the whiteout inode.
> + * This means that failures all the way up to this point leave the inode
> + * on the unlinked list and so cleanup is a simple matter of dropping
> + * the remaining reference to it. If we fail here after bumping the link
> + * count, we're shutting down the filesystem so we'll never see the
> + * intermediate state on disk.
> + */
> +static int
> +xfs_trans_log_finish_iunlink_remove(
> +	struct xfs_trans		*tp,
> +	struct xfs_ird_log_item		*irdp,
> +	struct xfs_inode		*wip)
> +{
> +	int 	error;
> +
> +	ASSERT(xfs_isilocked(wip, XFS_ILOCK_EXCL));
> +
> +	xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
> +
> +	ASSERT(VFS_I(wip)->i_nlink == 0);
> +	xfs_bumplink(tp, wip);
> +	error = xfs_iunlink_remove(tp, wip);
> +	xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
> +	/*
> +	 * Now we have a real link, clear the "I'm a tmpfile" state
> +	 * flag from the inode so it doesn't accidentally get misused in
> +	 * future.
> +	 */
> +	VFS_I(wip)->i_state &= ~I_LINKABLE;
> +
> +	/*
> +	 * Mark the transaction dirty, even on error. This ensures the
> +	 * transaction is aborted, which:
> +	 *
> +	 * 1.) releases the IRI and frees the IRD
> +	 * 2.) shuts down the filesystem
> +	 */
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &irdp->ird_item.li_flags);
> +
> +	return error;
> +}
> +
> +/* Process a deferred iunlink remove. */
> +STATIC int
> +xfs_iunlink_remove_finish_item(
> +	struct xfs_trans		*tp,
> +	struct list_head		*item,
> +	void				*done_item,
> +	void				**state)
> +{
> +	struct xfs_iunlink_remove_intent	*iunre;
> +	int					error;
> +
> +	iunre = container_of(item, struct xfs_iunlink_remove_intent, ri_list);
> +	error = xfs_trans_log_finish_iunlink_remove(tp, done_item,
> +			iunre->wip);
> +	kmem_free(iunre);
> +	return error;
> +}
> +
> +/* Abort all pending IRIs. */
> +STATIC void
> +xfs_iunlink_remove_abort_intent(
> +	void		*intent)
> +{
> +	xfs_iri_release(intent);
> +}
> +
> +/* Cancel a deferred iunlink remove. */
> +STATIC void
> +xfs_iunlink_remove_cancel_item(
> +	struct list_head		*item)
> +{
> +	struct xfs_iunlink_remove_intent	*iunre;
> +
> +	iunre = container_of(item, struct xfs_iunlink_remove_intent, ri_list);
> +	kmem_free(iunre);
> +}
> +
> +const struct xfs_defer_op_type xfs_iunlink_remove_defer_type = {
> +	.diff_items	= xfs_iunlink_remove_diff_items,
> +	.create_intent	= xfs_iunlink_remove_create_intent,
> +	.abort_intent	= xfs_iunlink_remove_abort_intent,
> +	.log_item	= xfs_iunlink_remove_log_item,
> +	.create_done	= xfs_iunlink_remove_create_done,
> +	.finish_item	= xfs_iunlink_remove_finish_item,
> +	.cancel_item	= xfs_iunlink_remove_cancel_item,
> +};
> +
> +/*
> + * Process a iunlink remove intent item that was recovered from the log.
> + */
> +int
> +xfs_iri_recover(
> +	struct xfs_trans		*parent_tp,
> +	struct xfs_iri_log_item		*irip)
> +{
> +	int				error = 0;
> +	struct xfs_trans		*tp;
> +	xfs_ino_t			ino;
> +	struct xfs_inode		*ip;
> +	struct xfs_mount		*mp = parent_tp->t_mountp;
> +	struct xfs_ird_log_item		*irdp;
> +
> +	ASSERT(!test_bit(XFS_IRI_RECOVERED, &irip->iri_flags));
> +
> +	ino = irip->iri_format.wip_ino;
> +	if (ino == NULLFSINO || !xfs_verify_dir_ino(mp, ino)) {
> +		xfs_alert(mp, "IRI recover used bad inode ino 0x%llx!", ino);
> +		set_bit(XFS_IRI_RECOVERED, &irip->iri_flags);
> +		xfs_iri_release(irip);
> +		return -EIO;
> +	}
> +	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
> +	if (error)
> +		return error;
> +
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ifree, 0, 0, 0, &tp);
> +	if (error)
> +		return error;
> +	irdp = xfs_trans_get_ird(tp, irip);
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +
> +	ASSERT(VFS_I(ip)->i_nlink == 0);
> +	VFS_I(ip)->i_state |= I_LINKABLE;
> +	xfs_bumplink(tp, ip);
> +	error = xfs_iunlink_remove(tp, ip);
> +	if (error)
> +		goto abort_error;
> +	VFS_I(ip)->i_state &= ~I_LINKABLE;
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &irdp->ird_item.li_flags);
> +
> +	set_bit(XFS_IRI_RECOVERED, &irip->iri_flags);
> +	error = xfs_trans_commit(tp);
> +	return error;
> +
> +abort_error:
> +	xfs_trans_cancel(tp);
> +	return error;
> +}
> diff --git a/fs/xfs/xfs_iunlinkrm_item.h b/fs/xfs/xfs_iunlinkrm_item.h
> new file mode 100644
> index 0000000..54c4ca3
> --- /dev/null
> +++ b/fs/xfs/xfs_iunlinkrm_item.h
> @@ -0,0 +1,67 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2019 Tencent.  All Rights Reserved.
> + * Author: Kaixuxia <kaixuxia@tencent.com>
> + */
> +#ifndef	__XFS_IUNLINKRM_ITEM_H__
> +#define	__XFS_IUNLINKRM_ITEM_H__
> +
> +/*
> + * When performing rename operation with RENAME_WHITEOUT flag, we will hold AGF lock to
> + * allocate or free extents in manipulating the dirents firstly, and then doing the
> + * xfs_iunlink_remove() call last to hold AGI lock to modify the tmpfile info, so we the
> + * lock order AGI->AGF.
> + *
> + * The big problem here is that we have an ordering constraint on AGF and AGI locking -
> + * inode allocation locks the AGI, then can allocate a new extent for new inodes, locking
> + * the AGF after the AGI. Hence the ordering that is imposed by other parts of the code
> + * is AGI before AGF. So we get the ABBA agi&agf deadlock here.
> + *
> + * So make the unlinked list removal a deferred operation, i.e. log an iunlink remove intent
> + * and then do it after the RENAME_WHITEOUT transaction has committed, and the iunlink remove
> + * intention(IRI) and done log items(IRD) are provided.
> + */
> +
> +/* kernel only IRI/IRD definitions */
> +
> +struct xfs_mount;
> +struct kmem_zone;
> +struct xfs_inode;
> +
> +/*
> + * Define IRI flag bits. Manipulated by set/clear/test_bit operators.
> + */
> +#define	XFS_IRI_RECOVERED		1
> +
> +/* This is the "iunlink remove intention" log item. It is used in conjunction
> + * with the "iunlink remove done" log item described below.
> + */
> +typedef struct xfs_iri_log_item {
> +	struct xfs_log_item	iri_item;
> +	atomic_t		iri_refcount;
> +	unsigned long		iri_flags;
> +	xfs_iri_log_format_t	iri_format;
> +} xfs_iri_log_item_t;
> +
> +/* This is the "iunlink remove done" log item. */
> +typedef struct xfs_ird_log_item {
> +	struct xfs_log_item	ird_item;
> +	xfs_iri_log_item_t	*ird_irip;
> +	xfs_ird_log_format_t	ird_format;
> +} xfs_ird_log_item_t;
> +
> +struct xfs_iunlink_remove_intent {
> +	struct list_head		ri_list;
> +	struct xfs_inode		*wip;
> +};
> +
> +extern struct kmem_zone	*xfs_iri_zone;
> +extern struct kmem_zone	*xfs_ird_zone;
> +
> +struct xfs_iri_log_item	*xfs_iri_init(struct xfs_mount *, uint);
> +void xfs_iri_item_free(struct xfs_iri_log_item *);
> +void xfs_iri_release(struct xfs_iri_log_item *);
> +int xfs_iri_recover(struct xfs_trans *, struct xfs_iri_log_item *);
> +int xfs_iunlink_remove_add(struct xfs_trans *, struct xfs_inode *);
> +
> +#endif	/* __XFS_IUNLINKRM_ITEM_H__ */
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 00e9f5c..f87f510 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2005,6 +2005,8 @@ STATIC void xlog_state_done_syncing(
>  	    REG_TYPE_STR(CUD_FORMAT, "cud_format"),
>  	    REG_TYPE_STR(BUI_FORMAT, "bui_format"),
>  	    REG_TYPE_STR(BUD_FORMAT, "bud_format"),
> +	    REG_TYPE_STR(IRI_FORMAT, "iri_format"),
> +	    REG_TYPE_STR(IRD_FORMAT, "ird_format"),
>  	};
>  	BUILD_BUG_ON(ARRAY_SIZE(res_type_str) != XLOG_REG_TYPE_MAX + 1);
>  #undef REG_TYPE_STR
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 13d1d3e..a916f40 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -33,6 +33,7 @@
>  #include "xfs_buf_item.h"
>  #include "xfs_refcount_item.h"
>  #include "xfs_bmap_item.h"
> +#include "xfs_iunlinkrm_item.h"
> 
>  #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
> 
> @@ -1885,6 +1886,8 @@ struct xfs_buf_cancel {
>  		case XFS_LI_CUD:
>  		case XFS_LI_BUI:
>  		case XFS_LI_BUD:
> +		case XFS_LI_IRI:
> +		case XFS_LI_IRD:
>  			trace_xfs_log_recover_item_reorder_tail(log,
>  							trans, item, pass);
>  			list_move_tail(&item->ri_list, &inode_list);
> @@ -3752,6 +3755,96 @@ struct xfs_buf_cancel {
>  }
> 
>  /*
> + * This routine is called to create an in-core iunlink remove intent
> + * item from the iri format structure which was logged on disk.
> + * It allocates an in-core iri, copies the inode from the format
> + * structure into it, and adds the iri to the AIL with the given
> + * LSN.
> + */
> +STATIC int
> +xlog_recover_iri_pass2(
> +	struct xlog			*log,
> +	struct xlog_recover_item	*item,
> +	xfs_lsn_t			lsn)
> +{
> +	xfs_mount_t		*mp = log->l_mp;
> +	xfs_iri_log_item_t	*irip;
> +	xfs_iri_log_format_t	*iri_formatp;
> +
> +	iri_formatp = item->ri_buf[0].i_addr;
> +
> +	irip = xfs_iri_init(mp, 1);
> +	irip->iri_format = *iri_formatp;
> +	if (item->ri_buf[0].i_len != sizeof(xfs_iri_log_format_t)) {
> +		xfs_iri_item_free(irip);
> +		return EFSCORRUPTED;
> +	}
> +
> +	spin_lock(&log->l_ailp->ail_lock);
> +	/*
> +	 * The IRI has two references. One for the IRD and one for IRI to ensure
> +	 * it makes it into the AIL. Insert the IRI into the AIL directly and
> +	 * drop the IRI reference. Note that xfs_trans_ail_update() drops the
> +	 * AIL lock.
> +	 */
> +	xfs_trans_ail_update(log->l_ailp, &irip->iri_item, lsn);
> +	xfs_iri_release(irip);
> +	return 0;
> +}
> +
> +/*
> + * This routine is called when an IRD format structure is found in a committed
> + * transaction in the log. Its purpose is to cancel the corresponding IRI if it
> + * was still in the log. To do this it searches the AIL for the IRI with an id
> + * equal to that in the IRD format structure. If we find it we drop the IRD
> + * reference, which removes the IRI from the AIL and frees it.
> + */
> +STATIC int
> +xlog_recover_ird_pass2(
> +	struct xlog			*log,
> +	struct xlog_recover_item	*item)
> +{
> +	xfs_ird_log_format_t	*ird_formatp;
> +	xfs_iri_log_item_t	*irip = NULL;
> +	struct xfs_log_item	*lip;
> +	uint64_t		iri_id;
> +	struct xfs_ail_cursor	cur;
> +	struct xfs_ail		*ailp = log->l_ailp;
> +
> +	ird_formatp = item->ri_buf[0].i_addr;
> +	if (item->ri_buf[0].i_len == sizeof(xfs_ird_log_format_t))
> +		return -EFSCORRUPTED;
> +	iri_id = ird_formatp->ird_iri_id;
> +
> +	/*
> +	 * Search for the iri with the id in the ird format structure
> +	 * in the AIL.
> +	 */
> +	spin_lock(&ailp->ail_lock);
> +	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> +	while (lip != NULL) {
> +		if (lip->li_type == XFS_LI_IRI) {
> +			irip = (xfs_iri_log_item_t *)lip;
> +			if (irip->iri_format.iri_id == iri_id) {
> +				/*
> +				 * Drop the IRD reference to the IRI. This
> +				 * removes the IRI from the AIL and frees it.
> +				 */
> +				spin_unlock(&ailp->ail_lock);
> +				xfs_iri_release(irip);
> +				spin_lock(&ailp->ail_lock);
> +				break;
> +			}
> +		}
> +		lip = xfs_trans_ail_cursor_next(ailp, &cur);
> +	}
> +	xfs_trans_ail_cursor_done(&cur);
> +	spin_unlock(&ailp->ail_lock);
> +
> +	return 0;
> +}
> +
> +/*
>   * This routine is called when an inode create format structure is found in a
>   * committed transaction in the log.  It's purpose is to initialise the inodes
>   * being allocated on disk. This requires us to get inode cluster buffers that
> @@ -3981,6 +4074,8 @@ struct xfs_buf_cancel {
>  	case XFS_LI_CUD:
>  	case XFS_LI_BUI:
>  	case XFS_LI_BUD:
> +	case XFS_LI_IRI:
> +	case XFS_LI_IRD:
>  	default:
>  		break;
>  	}
> @@ -4010,6 +4105,8 @@ struct xfs_buf_cancel {
>  	case XFS_LI_CUD:
>  	case XFS_LI_BUI:
>  	case XFS_LI_BUD:
> +	case XFS_LI_IRI:
> +	case XFS_LI_IRD:
>  		/* nothing to do in pass 1 */
>  		return 0;
>  	default:
> @@ -4052,6 +4149,10 @@ struct xfs_buf_cancel {
>  		return xlog_recover_bui_pass2(log, item, trans->r_lsn);
>  	case XFS_LI_BUD:
>  		return xlog_recover_bud_pass2(log, item);
> +	case XFS_LI_IRI:
> +		return xlog_recover_iri_pass2(log, item, trans->r_lsn);
> +	case XFS_LI_IRD:
> +		return xlog_recover_ird_pass2(log, item);
>  	case XFS_LI_DQUOT:
>  		return xlog_recover_dquot_pass2(log, buffer_list, item,
>  						trans->r_lsn);
> @@ -4721,6 +4822,46 @@ struct xfs_buf_cancel {
>  	spin_lock(&ailp->ail_lock);
>  }
> 
> +/* Recover the IRI if necessary. */
> +STATIC int
> +xlog_recover_process_iri(
> +	struct xfs_trans		*parent_tp,
> +	struct xfs_ail			*ailp,
> +	struct xfs_log_item		*lip)
> +{
> +	struct xfs_iri_log_item		*irip;
> +	int				error;
> +
> +	/*
> +	 * Skip IRIs that we've already processed.
> +	 */
> +	irip = container_of(lip, struct xfs_iri_log_item, iri_item);
> +	if (test_bit(XFS_IRI_RECOVERED, &irip->iri_flags))
> +		return 0;
> +
> +	spin_unlock(&ailp->ail_lock);
> +	error = xfs_iri_recover(parent_tp, irip);
> +	spin_lock(&ailp->ail_lock);
> +
> +	return error;
> +}
> +
> +/* Release the IRI since we're cancelling everything. */
> +STATIC void
> +xlog_recover_cancel_iri(
> +	struct xfs_mount		*mp,
> +	struct xfs_ail			*ailp,
> +	struct xfs_log_item		*lip)
> +{
> +	struct xfs_iri_log_item         *irip;
> +
> +	irip = container_of(lip, struct xfs_iri_log_item, iri_item);
> +
> +	spin_unlock(&ailp->ail_lock);
> +	xfs_iri_release(irip);
> +	spin_lock(&ailp->ail_lock);
> +}
> +
>  /* Is this log item a deferred action intent? */
>  static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
>  {
> @@ -4729,6 +4870,7 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
>  	case XFS_LI_RUI:
>  	case XFS_LI_CUI:
>  	case XFS_LI_BUI:
> +	case XFS_LI_IRI:
>  		return true;
>  	default:
>  		return false;
> @@ -4856,6 +4998,9 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
>  		case XFS_LI_BUI:
>  			error = xlog_recover_process_bui(parent_tp, ailp, lip);
>  			break;
> +		case XFS_LI_IRI:
> +			error = xlog_recover_process_iri(parent_tp, ailp, lip);
> +			break;
>  		}
>  		if (error)
>  			goto out;
> @@ -4912,6 +5057,9 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
>  		case XFS_LI_BUI:
>  			xlog_recover_cancel_bui(log->l_mp, ailp, lip);
>  			break;
> +		case XFS_LI_IRI:
> +			xlog_recover_cancel_iri(log->l_mp, ailp, lip);
> +			break;
>  		}
> 
>  		lip = xfs_trans_ail_cursor_next(ailp, &cur);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f945023..66742b7 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -34,6 +34,7 @@
>  #include "xfs_rmap_item.h"
>  #include "xfs_refcount_item.h"
>  #include "xfs_bmap_item.h"
> +#include "xfs_iunlinkrm_item.h"
>  #include "xfs_reflink.h"
> 
>  #include <linux/magic.h>
> @@ -1957,8 +1958,22 @@ struct proc_xfs_info {
>  	if (!xfs_bui_zone)
>  		goto out_destroy_bud_zone;
> 
> +	xfs_ird_zone = kmem_zone_init(sizeof(xfs_ird_log_item_t),
> +			"xfs_ird_item");
> +	if (!xfs_ird_zone)
> +		goto out_destroy_bui_zone;
> +
> +	xfs_iri_zone = kmem_zone_init(sizeof(xfs_iri_log_item_t),
> +			"xfs_iri_item");
> +	if (!xfs_iri_zone)
> +		goto out_destroy_ird_zone;
> +
>  	return 0;
> 
> + out_destroy_ird_zone:
> +	kmem_zone_destroy(xfs_ird_zone);
> + out_destroy_bui_zone:
> +	kmem_zone_destroy(xfs_bui_zone);
>   out_destroy_bud_zone:
>  	kmem_zone_destroy(xfs_bud_zone);
>   out_destroy_cui_zone:
> @@ -2007,6 +2022,8 @@ struct proc_xfs_info {
>  	 * destroy caches.
>  	 */
>  	rcu_barrier();
> +	kmem_zone_destroy(xfs_iri_zone);
> +	kmem_zone_destroy(xfs_ird_zone);
>  	kmem_zone_destroy(xfs_bui_zone);
>  	kmem_zone_destroy(xfs_bud_zone);
>  	kmem_zone_destroy(xfs_cui_zone);
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 64d7f17..dd63eaa 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -26,6 +26,8 @@
>  struct xfs_cud_log_item;
>  struct xfs_bui_log_item;
>  struct xfs_bud_log_item;
> +struct xfs_iri_log_item;
> +struct xfs_ird_log_item;
> 
>  struct xfs_log_item {
>  	struct list_head		li_ail;		/* AIL pointers */
> -- 
> 1.8.3.1
> 
> -- 
> kaixuxia
