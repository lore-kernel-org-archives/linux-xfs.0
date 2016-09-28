Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38177 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752906AbcI1SsG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2016 14:48:06 -0400
Date: Wed, 28 Sep 2016 11:47:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/63] xfs: create refcount update intent log items
Message-ID: <20160928184756.GS14092@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503127360.30303.13509008550712587655.stgit@birch.djwong.org>
 <20160928162017.GE8852@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160928162017.GE8852@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Wed, Sep 28, 2016 at 12:20:18PM -0400, Brian Foster wrote:
> On Tue, Sep 27, 2016 at 07:54:33PM -0700, Darrick J. Wong wrote:
> > Create refcount update intent/done log items to record redo
> > information in the log.  Because we need to roll transactions between
> > updating the bmbt mapping and updating the reverse mapping, we also
> > have to track the status of the metadata updates that will be recorded
> > in the post-roll transactions, just in case we crash before committing
> > the final transaction.  This mechanism enables log recovery to finish
> > what was already started.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/Makefile                |    1 
> >  fs/xfs/libxfs/xfs_log_format.h |   59 ++++++
> >  fs/xfs/xfs_refcount_item.c     |  406 ++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_refcount_item.h     |  102 ++++++++++
> >  fs/xfs/xfs_super.c             |   18 ++
> >  5 files changed, 584 insertions(+), 2 deletions(-)
> >  create mode 100644 fs/xfs/xfs_refcount_item.c
> >  create mode 100644 fs/xfs/xfs_refcount_item.h
> > 
> > 
> ...
> > diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> > new file mode 100644
> > index 0000000..ac52b02
> > --- /dev/null
> > +++ b/fs/xfs/xfs_refcount_item.c
> > @@ -0,0 +1,406 @@
> ...
> > +/*
> > + * This is called to fill in the vector of log iovecs for the
> > + * given cud log item. We use only 1 iovec, and we point that
> > + * at the cud_log_format structure embedded in the cud item.
> > + * It is at this point that we assert that all of the extent
> > + * slots in the cud item have been filled.
> > + */
> > +STATIC void
> > +xfs_cud_item_format(
> > +	struct xfs_log_item	*lip,
> > +	struct xfs_log_vec	*lv)
> > +{
> > +	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
> > +	struct xfs_log_iovec	*vecp = NULL;
> > +
> > +	cudp->cud_format.cud_type = XFS_LI_CUD;
> > +	cudp->cud_format.cud_size = 1;
> > +
> > +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_CUD_FORMAT, &cudp->cud_format,
> > +			sizeof(struct xfs_rud_log_format));
> 
> They're the same size, but:	      xfs_cud_log_format

Yikes, good catch!

--D

> 
> Brian
> 
> > +}
> > +
> > +/*
> > + * Pinning has no meaning for an cud item, so just return.
> > + */
> > +STATIC void
> > +xfs_cud_item_pin(
> > +	struct xfs_log_item	*lip)
> > +{
> > +}
> > +
> > +/*
> > + * Since pinning has no meaning for an cud item, unpinning does
> > + * not either.
> > + */
> > +STATIC void
> > +xfs_cud_item_unpin(
> > +	struct xfs_log_item	*lip,
> > +	int			remove)
> > +{
> > +}
> > +
> > +/*
> > + * There isn't much you can do to push on an cud item.  It is simply stuck
> > + * waiting for the log to be flushed to disk.
> > + */
> > +STATIC uint
> > +xfs_cud_item_push(
> > +	struct xfs_log_item	*lip,
> > +	struct list_head	*buffer_list)
> > +{
> > +	return XFS_ITEM_PINNED;
> > +}
> > +
> > +/*
> > + * The CUD is either committed or aborted if the transaction is cancelled. If
> > + * the transaction is cancelled, drop our reference to the CUI and free the
> > + * CUD.
> > + */
> > +STATIC void
> > +xfs_cud_item_unlock(
> > +	struct xfs_log_item	*lip)
> > +{
> > +	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
> > +
> > +	if (lip->li_flags & XFS_LI_ABORTED) {
> > +		xfs_cui_release(cudp->cud_cuip);
> > +		kmem_zone_free(xfs_cud_zone, cudp);
> > +	}
> > +}
> > +
> > +/*
> > + * When the cud item is committed to disk, all we need to do is delete our
> > + * reference to our partner cui item and then free ourselves. Since we're
> > + * freeing ourselves we must return -1 to keep the transaction code from
> > + * further referencing this item.
> > + */
> > +STATIC xfs_lsn_t
> > +xfs_cud_item_committed(
> > +	struct xfs_log_item	*lip,
> > +	xfs_lsn_t		lsn)
> > +{
> > +	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
> > +
> > +	/*
> > +	 * Drop the CUI reference regardless of whether the CUD has been
> > +	 * aborted. Once the CUD transaction is constructed, it is the sole
> > +	 * responsibility of the CUD to release the CUI (even if the CUI is
> > +	 * aborted due to log I/O error).
> > +	 */
> > +	xfs_cui_release(cudp->cud_cuip);
> > +	kmem_zone_free(xfs_cud_zone, cudp);
> > +
> > +	return (xfs_lsn_t)-1;
> > +}
> > +
> > +/*
> > + * The CUD dependency tracking op doesn't do squat.  It can't because
> > + * it doesn't know where the free extent is coming from.  The dependency
> > + * tracking has to be handled by the "enclosing" metadata object.  For
> > + * example, for inodes, the inode is locked throughout the extent freeing
> > + * so the dependency should be recorded there.
> > + */
> > +STATIC void
> > +xfs_cud_item_committing(
> > +	struct xfs_log_item	*lip,
> > +	xfs_lsn_t		lsn)
> > +{
> > +}
> > +
> > +/*
> > + * This is the ops vector shared by all cud log items.
> > + */
> > +static const struct xfs_item_ops xfs_cud_item_ops = {
> > +	.iop_size	= xfs_cud_item_size,
> > +	.iop_format	= xfs_cud_item_format,
> > +	.iop_pin	= xfs_cud_item_pin,
> > +	.iop_unpin	= xfs_cud_item_unpin,
> > +	.iop_unlock	= xfs_cud_item_unlock,
> > +	.iop_committed	= xfs_cud_item_committed,
> > +	.iop_push	= xfs_cud_item_push,
> > +	.iop_committing = xfs_cud_item_committing,
> > +};
> > +
> > +/*
> > + * Allocate and initialize an cud item with the given number of extents.
> > + */
> > +struct xfs_cud_log_item *
> > +xfs_cud_init(
> > +	struct xfs_mount		*mp,
> > +	struct xfs_cui_log_item		*cuip)
> > +
> > +{
> > +	struct xfs_cud_log_item	*cudp;
> > +
> > +	cudp = kmem_zone_zalloc(xfs_cud_zone, KM_SLEEP);
> > +	xfs_log_item_init(mp, &cudp->cud_item, XFS_LI_CUD, &xfs_cud_item_ops);
> > +	cudp->cud_cuip = cuip;
> > +	cudp->cud_format.cud_cui_id = cuip->cui_format.cui_id;
> > +
> > +	return cudp;
> > +}
> > diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
> > new file mode 100644
> > index 0000000..7b8f56b
> > --- /dev/null
> > +++ b/fs/xfs/xfs_refcount_item.h
> > @@ -0,0 +1,102 @@
> > +/*
> > + * Copyright (C) 2016 Oracle.  All Rights Reserved.
> > + *
> > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it would be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write the Free Software Foundation,
> > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> > + */
> > +#ifndef	__XFS_REFCOUNT_ITEM_H__
> > +#define	__XFS_REFCOUNT_ITEM_H__
> > +
> > +/*
> > + * There are (currently) two pairs of refcount btree redo item types:
> > + * increase and decrease.  The log items for these are CUI (refcount
> > + * update intent) and CUD (refcount update done).  The redo item type
> > + * is encoded in the flags field of each xfs_map_extent.
> > + *
> > + * *I items should be recorded in the *first* of a series of rolled
> > + * transactions, and the *D items should be recorded in the same
> > + * transaction that records the associated refcountbt updates.
> > + *
> > + * Should the system crash after the commit of the first transaction
> > + * but before the commit of the final transaction in a series, log
> > + * recovery will use the redo information recorded by the intent items
> > + * to replay the refcountbt metadata updates.
> > + */
> > +
> > +/* kernel only CUI/CUD definitions */
> > +
> > +struct xfs_mount;
> > +struct kmem_zone;
> > +
> > +/*
> > + * Max number of extents in fast allocation path.
> > + */
> > +#define	XFS_CUI_MAX_FAST_EXTENTS	16
> > +
> > +/*
> > + * Define CUI flag bits. Manipulated by set/clear/test_bit operators.
> > + */
> > +#define	XFS_CUI_RECOVERED		1
> > +
> > +/*
> > + * This is the "refcount update intent" log item.  It is used to log
> > + * the fact that some reverse mappings need to change.  It is used in
> > + * conjunction with the "refcount update done" log item described
> > + * below.
> > + *
> > + * These log items follow the same rules as struct xfs_efi_log_item;
> > + * see the comments about that structure (in xfs_extfree_item.h) for
> > + * more details.
> > + */
> > +struct xfs_cui_log_item {
> > +	struct xfs_log_item		cui_item;
> > +	atomic_t			cui_refcount;
> > +	atomic_t			cui_next_extent;
> > +	unsigned long			cui_flags;	/* misc flags */
> > +	struct xfs_cui_log_format	cui_format;
> > +};
> > +
> > +static inline size_t
> > +xfs_cui_log_item_sizeof(
> > +	unsigned int		nr)
> > +{
> > +	return offsetof(struct xfs_cui_log_item, cui_format) +
> > +			xfs_cui_log_format_sizeof(nr);
> > +}
> > +
> > +/*
> > + * This is the "refcount update done" log item.  It is used to log the
> > + * fact that some refcountbt updates mentioned in an earlier cui item
> > + * have been performed.
> > + */
> > +struct xfs_cud_log_item {
> > +	struct xfs_log_item		cud_item;
> > +	struct xfs_cui_log_item		*cud_cuip;
> > +	struct xfs_cud_log_format	cud_format;
> > +};
> > +
> > +extern struct kmem_zone	*xfs_cui_zone;
> > +extern struct kmem_zone	*xfs_cud_zone;
> > +
> > +struct xfs_cui_log_item *xfs_cui_init(struct xfs_mount *, uint);
> > +struct xfs_cud_log_item *xfs_cud_init(struct xfs_mount *,
> > +		struct xfs_cui_log_item *);
> > +int xfs_cui_copy_format(struct xfs_log_iovec *buf,
> > +		struct xfs_cui_log_format *dst_cui_fmt);
> > +void xfs_cui_item_free(struct xfs_cui_log_item *);
> > +void xfs_cui_release(struct xfs_cui_log_item *);
> > +
> > +#endif	/* __XFS_REFCOUNT_ITEM_H__ */
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 2d092f9..abe69c6 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -47,6 +47,7 @@
> >  #include "xfs_sysfs.h"
> >  #include "xfs_ondisk.h"
> >  #include "xfs_rmap_item.h"
> > +#include "xfs_refcount_item.h"
> >  
> >  #include <linux/namei.h>
> >  #include <linux/init.h>
> > @@ -1788,8 +1789,23 @@ xfs_init_zones(void)
> >  	if (!xfs_rui_zone)
> >  		goto out_destroy_rud_zone;
> >  
> > +	xfs_cud_zone = kmem_zone_init(sizeof(struct xfs_cud_log_item),
> > +			"xfs_cud_item");
> > +	if (!xfs_cud_zone)
> > +		goto out_destroy_rui_zone;
> > +
> > +	xfs_cui_zone = kmem_zone_init(
> > +			xfs_cui_log_item_sizeof(XFS_CUI_MAX_FAST_EXTENTS),
> > +			"xfs_cui_item");
> > +	if (!xfs_cui_zone)
> > +		goto out_destroy_cud_zone;
> > +
> >  	return 0;
> >  
> > + out_destroy_cud_zone:
> > +	kmem_zone_destroy(xfs_cud_zone);
> > + out_destroy_rui_zone:
> > +	kmem_zone_destroy(xfs_rui_zone);
> >   out_destroy_rud_zone:
> >  	kmem_zone_destroy(xfs_rud_zone);
> >   out_destroy_icreate_zone:
> > @@ -1832,6 +1848,8 @@ xfs_destroy_zones(void)
> >  	 * destroy caches.
> >  	 */
> >  	rcu_barrier();
> > +	kmem_zone_destroy(xfs_cui_zone);
> > +	kmem_zone_destroy(xfs_cud_zone);
> >  	kmem_zone_destroy(xfs_rui_zone);
> >  	kmem_zone_destroy(xfs_rud_zone);
> >  	kmem_zone_destroy(xfs_icreate_zone);
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
