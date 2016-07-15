Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A4A3F7CA2
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2016 13:33:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 69B368F8035
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2016 11:33:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id joMOxAAodshVPUFu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Jul 2016 11:33:44 -0700 (PDT)
Date: Fri, 15 Jul 2016 14:33:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 041/119] xfs: create rmap update intent log items
Message-ID: <20160715183341.GA55338@bfoster.bfoster>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612653482.12839.13343504748508270421.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612653482.12839.13343504748508270421.stgit@birch.djwong.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Thu, Jun 16, 2016 at 06:22:14PM -0700, Darrick J. Wong wrote:
> Create rmap update intent/done log items to record redo information in
> the log.  Because we need to roll transactions between updating the
> bmbt mapping and updating the reverse mapping, we also have to track
> the status of the metadata updates that will be recorded in the
> post-roll transactions, just in case we crash before committing the
> final transaction.  This mechanism enables log recovery to finish what
> was already started.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

A couple nits below, otherwise looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/Makefile                |    1 
>  fs/xfs/libxfs/xfs_log_format.h |   67 ++++++
>  fs/xfs/libxfs/xfs_rmap_btree.h |   19 ++
>  fs/xfs/xfs_rmap_item.c         |  459 ++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_rmap_item.h         |  100 +++++++++
>  fs/xfs/xfs_super.c             |   21 ++
>  6 files changed, 665 insertions(+), 2 deletions(-)
>  create mode 100644 fs/xfs/xfs_rmap_item.c
>  create mode 100644 fs/xfs/xfs_rmap_item.h
> 
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 2de8c20..8ae0a10 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -104,6 +104,7 @@ xfs-y				+= xfs_log.o \
>  				   xfs_extfree_item.o \
>  				   xfs_icreate_item.o \
>  				   xfs_inode_item.o \
> +				   xfs_rmap_item.o \
>  				   xfs_log_recover.o \
>  				   xfs_trans_ail.o \
>  				   xfs_trans_buf.o \
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index e5baba3..b9627b7 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -110,7 +110,9 @@ static inline uint xlog_get_cycle(char *ptr)
>  #define XLOG_REG_TYPE_COMMIT		18
>  #define XLOG_REG_TYPE_TRANSHDR		19
>  #define XLOG_REG_TYPE_ICREATE		20
> -#define XLOG_REG_TYPE_MAX		20
> +#define XLOG_REG_TYPE_RUI_FORMAT	21
> +#define XLOG_REG_TYPE_RUD_FORMAT	22
> +#define XLOG_REG_TYPE_MAX		22
>  
>  /*
>   * Flags to log operation header
> @@ -227,6 +229,8 @@ typedef struct xfs_trans_header {
>  #define	XFS_LI_DQUOT		0x123d
>  #define	XFS_LI_QUOTAOFF		0x123e
>  #define	XFS_LI_ICREATE		0x123f
> +#define	XFS_LI_RUI		0x1240	/* rmap update intent */
> +#define	XFS_LI_RUD		0x1241
>  
>  #define XFS_LI_TYPE_DESC \
>  	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
> @@ -236,7 +240,9 @@ typedef struct xfs_trans_header {
>  	{ XFS_LI_BUF,		"XFS_LI_BUF" }, \
>  	{ XFS_LI_DQUOT,		"XFS_LI_DQUOT" }, \
>  	{ XFS_LI_QUOTAOFF,	"XFS_LI_QUOTAOFF" }, \
> -	{ XFS_LI_ICREATE,	"XFS_LI_ICREATE" }
> +	{ XFS_LI_ICREATE,	"XFS_LI_ICREATE" }, \
> +	{ XFS_LI_RUI,		"XFS_LI_RUI" }, \
> +	{ XFS_LI_RUD,		"XFS_LI_RUD" }
>  
>  /*
>   * Inode Log Item Format definitions.
> @@ -604,6 +610,63 @@ typedef struct xfs_efd_log_format_64 {
>  } xfs_efd_log_format_64_t;
>  
>  /*
> + * RUI/RUD (reverse mapping) log format definitions
> + */
> +struct xfs_map_extent {
> +	__uint64_t		me_owner;
> +	__uint64_t		me_startblock;
> +	__uint64_t		me_startoff;
> +	__uint32_t		me_len;
> +	__uint32_t		me_flags;
> +};
> +
> +/* rmap me_flags: upper bits are flags, lower byte is type code */
> +#define XFS_RMAP_EXTENT_MAP		1
> +#define XFS_RMAP_EXTENT_MAP_SHARED	2
> +#define XFS_RMAP_EXTENT_UNMAP		3
> +#define XFS_RMAP_EXTENT_UNMAP_SHARED	4
> +#define XFS_RMAP_EXTENT_CONVERT		5
> +#define XFS_RMAP_EXTENT_CONVERT_SHARED	6
> +#define XFS_RMAP_EXTENT_ALLOC		7
> +#define XFS_RMAP_EXTENT_FREE		8
> +#define XFS_RMAP_EXTENT_TYPE_MASK	0xFF

I assume all of the _SHARED stuff defined here and throughout is not
used until reflink.. (not that big of a deal if it's a PITA to remove).

> +
> +#define XFS_RMAP_EXTENT_ATTR_FORK	(1U << 31)
> +#define XFS_RMAP_EXTENT_BMBT_BLOCK	(1U << 30)
> +#define XFS_RMAP_EXTENT_UNWRITTEN	(1U << 29)
> +
> +#define XFS_RMAP_EXTENT_FLAGS		(XFS_RMAP_EXTENT_TYPE_MASK | \
> +					 XFS_RMAP_EXTENT_ATTR_FORK | \
> +					 XFS_RMAP_EXTENT_BMBT_BLOCK | \
> +					 XFS_RMAP_EXTENT_UNWRITTEN)
> +
> +/*
> + * This is the structure used to lay out an rui log item in the
> + * log.  The rui_extents field is a variable size array whose
> + * size is given by rui_nextents.
> + */
> +struct xfs_rui_log_format {
> +	__uint16_t		rui_type;	/* rui log item type */
> +	__uint16_t		rui_size;	/* size of this item */
> +	__uint32_t		rui_nextents;	/* # extents to free */
> +	__uint64_t		rui_id;		/* rui identifier */
> +	struct xfs_map_extent	rui_extents[1];	/* array of extents to rmap */
> +};
> +
> +/*
> + * This is the structure used to lay out an rud log item in the
> + * log.  The rud_extents array is a variable size array whose
> + * size is given by rud_nextents;
> + */
> +struct xfs_rud_log_format {
> +	__uint16_t		rud_type;	/* rud log item type */
> +	__uint16_t		rud_size;	/* size of this item */
> +	__uint32_t		rud_nextents;	/* # of extents freed */
> +	__uint64_t		rud_rui_id;	/* id of corresponding rui */
> +	struct xfs_map_extent	rud_extents[1];	/* array of extents rmapped */
> +};
> +
> +/*
>   * Dquot Log format definitions.
>   *
>   * The first two fields must be the type and size fitting into
...
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> new file mode 100644
> index 0000000..91a3b2c
> --- /dev/null
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -0,0 +1,459 @@
...
> +/*
> + * Copy an RUI format buffer from the given buf, and into the destination
> + * RUI format structure.  The RUI/RUD items were designed not to need any
> + * special alignment handling.
> + */
> +int
> +xfs_rui_copy_format(
> +	struct xfs_log_iovec		*buf,
> +	struct xfs_rui_log_format	*dst_rui_fmt)
> +{
> +	struct xfs_rui_log_format	*src_rui_fmt;
> +	uint				len;
> +
> +	src_rui_fmt = buf->i_addr;
> +	len = sizeof(struct xfs_rui_log_format) +
> +			(src_rui_fmt->rui_nextents - 1) *
> +			sizeof(struct xfs_map_extent);
> +
> +	if (buf->i_len == len) {
> +		memcpy((char *)dst_rui_fmt, (char *)src_rui_fmt, len);
> +		return 0;
> +	}
> +	return -EFSCORRUPTED;

I'd switch this around since we don't have the mess that
xfs_efi_copy_format() has to deal with. E.g.,

	if (buf->i_len != len)
		return -EFSCORRUPTED;

	memcpy(..);
	return 0;

Brian

> +}
> +
> +/*
> + * Freeing the RUI requires that we remove it from the AIL if it has already
> + * been placed there. However, the RUI may not yet have been placed in the AIL
> + * when called by xfs_rui_release() from RUD processing due to the ordering of
> + * committed vs unpin operations in bulk insert operations. Hence the reference
> + * count to ensure only the last caller frees the RUI.
> + */
> +void
> +xfs_rui_release(
> +	struct xfs_rui_log_item	*ruip)
> +{
> +	if (atomic_dec_and_test(&ruip->rui_refcount)) {
> +		xfs_trans_ail_remove(&ruip->rui_item, SHUTDOWN_LOG_IO_ERROR);
> +		xfs_rui_item_free(ruip);
> +	}
> +}
> +
> +static inline struct xfs_rud_log_item *RUD_ITEM(struct xfs_log_item *lip)
> +{
> +	return container_of(lip, struct xfs_rud_log_item, rud_item);
> +}
> +
> +STATIC void
> +xfs_rud_item_free(struct xfs_rud_log_item *rudp)
> +{
> +	if (rudp->rud_format.rud_nextents > XFS_RUD_MAX_FAST_EXTENTS)
> +		kmem_free(rudp);
> +	else
> +		kmem_zone_free(xfs_rud_zone, rudp);
> +}
> +
> +/*
> + * This returns the number of iovecs needed to log the given rud item.
> + * We only need 1 iovec for an rud item.  It just logs the rud_log_format
> + * structure.
> + */
> +static inline int
> +xfs_rud_item_sizeof(
> +	struct xfs_rud_log_item	*rudp)
> +{
> +	return sizeof(struct xfs_rud_log_format) +
> +			(rudp->rud_format.rud_nextents - 1) *
> +			sizeof(struct xfs_map_extent);
> +}
> +
> +STATIC void
> +xfs_rud_item_size(
> +	struct xfs_log_item	*lip,
> +	int			*nvecs,
> +	int			*nbytes)
> +{
> +	*nvecs += 1;
> +	*nbytes += xfs_rud_item_sizeof(RUD_ITEM(lip));
> +}
> +
> +/*
> + * This is called to fill in the vector of log iovecs for the
> + * given rud log item. We use only 1 iovec, and we point that
> + * at the rud_log_format structure embedded in the rud item.
> + * It is at this point that we assert that all of the extent
> + * slots in the rud item have been filled.
> + */
> +STATIC void
> +xfs_rud_item_format(
> +	struct xfs_log_item	*lip,
> +	struct xfs_log_vec	*lv)
> +{
> +	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
> +	struct xfs_log_iovec	*vecp = NULL;
> +
> +	ASSERT(rudp->rud_next_extent == rudp->rud_format.rud_nextents);
> +
> +	rudp->rud_format.rud_type = XFS_LI_RUD;
> +	rudp->rud_format.rud_size = 1;
> +
> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_RUD_FORMAT, &rudp->rud_format,
> +			xfs_rud_item_sizeof(rudp));
> +}
> +
> +/*
> + * Pinning has no meaning for an rud item, so just return.
> + */
> +STATIC void
> +xfs_rud_item_pin(
> +	struct xfs_log_item	*lip)
> +{
> +}
> +
> +/*
> + * Since pinning has no meaning for an rud item, unpinning does
> + * not either.
> + */
> +STATIC void
> +xfs_rud_item_unpin(
> +	struct xfs_log_item	*lip,
> +	int			remove)
> +{
> +}
> +
> +/*
> + * There isn't much you can do to push on an rud item.  It is simply stuck
> + * waiting for the log to be flushed to disk.
> + */
> +STATIC uint
> +xfs_rud_item_push(
> +	struct xfs_log_item	*lip,
> +	struct list_head	*buffer_list)
> +{
> +	return XFS_ITEM_PINNED;
> +}
> +
> +/*
> + * The RUD is either committed or aborted if the transaction is cancelled. If
> + * the transaction is cancelled, drop our reference to the RUI and free the
> + * RUD.
> + */
> +STATIC void
> +xfs_rud_item_unlock(
> +	struct xfs_log_item	*lip)
> +{
> +	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
> +
> +	if (lip->li_flags & XFS_LI_ABORTED) {
> +		xfs_rui_release(rudp->rud_ruip);
> +		xfs_rud_item_free(rudp);
> +	}
> +}
> +
> +/*
> + * When the rud item is committed to disk, all we need to do is delete our
> + * reference to our partner rui item and then free ourselves. Since we're
> + * freeing ourselves we must return -1 to keep the transaction code from
> + * further referencing this item.
> + */
> +STATIC xfs_lsn_t
> +xfs_rud_item_committed(
> +	struct xfs_log_item	*lip,
> +	xfs_lsn_t		lsn)
> +{
> +	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
> +
> +	/*
> +	 * Drop the RUI reference regardless of whether the RUD has been
> +	 * aborted. Once the RUD transaction is constructed, it is the sole
> +	 * responsibility of the RUD to release the RUI (even if the RUI is
> +	 * aborted due to log I/O error).
> +	 */
> +	xfs_rui_release(rudp->rud_ruip);
> +	xfs_rud_item_free(rudp);
> +
> +	return (xfs_lsn_t)-1;
> +}
> +
> +/*
> + * The RUD dependency tracking op doesn't do squat.  It can't because
> + * it doesn't know where the free extent is coming from.  The dependency
> + * tracking has to be handled by the "enclosing" metadata object.  For
> + * example, for inodes, the inode is locked throughout the extent freeing
> + * so the dependency should be recorded there.
> + */
> +STATIC void
> +xfs_rud_item_committing(
> +	struct xfs_log_item	*lip,
> +	xfs_lsn_t		lsn)
> +{
> +}
> +
> +/*
> + * This is the ops vector shared by all rud log items.
> + */
> +static const struct xfs_item_ops xfs_rud_item_ops = {
> +	.iop_size	= xfs_rud_item_size,
> +	.iop_format	= xfs_rud_item_format,
> +	.iop_pin	= xfs_rud_item_pin,
> +	.iop_unpin	= xfs_rud_item_unpin,
> +	.iop_unlock	= xfs_rud_item_unlock,
> +	.iop_committed	= xfs_rud_item_committed,
> +	.iop_push	= xfs_rud_item_push,
> +	.iop_committing = xfs_rud_item_committing,
> +};
> +
> +/*
> + * Allocate and initialize an rud item with the given number of extents.
> + */
> +struct xfs_rud_log_item *
> +xfs_rud_init(
> +	struct xfs_mount		*mp,
> +	struct xfs_rui_log_item		*ruip,
> +	uint				nextents)
> +
> +{
> +	struct xfs_rud_log_item	*rudp;
> +	uint			size;
> +
> +	ASSERT(nextents > 0);
> +	if (nextents > XFS_RUD_MAX_FAST_EXTENTS) {
> +		size = (uint)(sizeof(struct xfs_rud_log_item) +
> +			((nextents - 1) * sizeof(struct xfs_map_extent)));
> +		rudp = kmem_zalloc(size, KM_SLEEP);
> +	} else {
> +		rudp = kmem_zone_zalloc(xfs_rud_zone, KM_SLEEP);
> +	}
> +
> +	xfs_log_item_init(mp, &rudp->rud_item, XFS_LI_RUD, &xfs_rud_item_ops);
> +	rudp->rud_ruip = ruip;
> +	rudp->rud_format.rud_nextents = nextents;
> +	rudp->rud_format.rud_rui_id = ruip->rui_format.rui_id;
> +
> +	return rudp;
> +}
> diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
> new file mode 100644
> index 0000000..bd36ab5
> --- /dev/null
> +++ b/fs/xfs/xfs_rmap_item.h
> @@ -0,0 +1,100 @@
> +/*
> + * Copyright (C) 2016 Oracle.  All Rights Reserved.
> + *
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +#ifndef	__XFS_RMAP_ITEM_H__
> +#define	__XFS_RMAP_ITEM_H__
> +
> +/*
> + * There are (currently) three pairs of rmap btree redo item types: map, unmap,
> + * and convert.  The common abbreviations for these are RUI (rmap update
> + * intent) and RUD (rmap update done).  The redo item type is encoded in the
> + * flags field of each xfs_map_extent.
> + *
> + * *I items should be recorded in the *first* of a series of rolled
> + * transactions, and the *D items should be recorded in the same transaction
> + * that records the associated rmapbt updates.  Typically, the first
> + * transaction will record a bmbt update, followed by some number of
> + * transactions containing rmapbt updates, and finally transactions with any
> + * bnobt/cntbt updates.
> + *
> + * Should the system crash after the commit of the first transaction but
> + * before the commit of the final transaction in a series, log recovery will
> + * use the redo information recorded by the intent items to replay the
> + * (rmapbt/bnobt/cntbt) metadata updates in the non-first transaction.
> + */
> +
> +/* kernel only RUI/RUD definitions */
> +
> +struct xfs_mount;
> +struct kmem_zone;
> +
> +/*
> + * Max number of extents in fast allocation path.
> + */
> +#define	XFS_RUI_MAX_FAST_EXTENTS	16
> +
> +/*
> + * Define RUI flag bits. Manipulated by set/clear/test_bit operators.
> + */
> +#define	XFS_RUI_RECOVERED		1
> +
> +/*
> + * This is the "rmap update intent" log item.  It is used to log the fact that
> + * some reverse mappings need to change.  It is used in conjunction with the
> + * "rmap update done" log item described below.
> + *
> + * These log items follow the same rules as struct xfs_efi_log_item; see the
> + * comments about that structure (in xfs_extfree_item.h) for more details.
> + */
> +struct xfs_rui_log_item {
> +	struct xfs_log_item		rui_item;
> +	atomic_t			rui_refcount;
> +	atomic_t			rui_next_extent;
> +	unsigned long			rui_flags;	/* misc flags */
> +	struct xfs_rui_log_format	rui_format;
> +};
> +
> +/*
> + * This is the "rmap update done" log item.  It is used to log the fact that
> + * some rmapbt updates mentioned in an earlier rui item have been performed.
> + */
> +struct xfs_rud_log_item {
> +	struct xfs_log_item		rud_item;
> +	struct xfs_rui_log_item		*rud_ruip;
> +	uint				rud_next_extent;
> +	struct xfs_rud_log_format	rud_format;
> +};
> +
> +/*
> + * Max number of extents in fast allocation path.
> + */
> +#define	XFS_RUD_MAX_FAST_EXTENTS	16
> +
> +extern struct kmem_zone	*xfs_rui_zone;
> +extern struct kmem_zone	*xfs_rud_zone;
> +
> +struct xfs_rui_log_item *xfs_rui_init(struct xfs_mount *, uint);
> +struct xfs_rud_log_item *xfs_rud_init(struct xfs_mount *,
> +		struct xfs_rui_log_item *, uint);
> +int xfs_rui_copy_format(struct xfs_log_iovec *buf,
> +		struct xfs_rui_log_format *dst_rui_fmt);
> +void xfs_rui_item_free(struct xfs_rui_log_item *);
> +void xfs_rui_release(struct xfs_rui_log_item *);
> +
> +#endif	/* __XFS_RMAP_ITEM_H__ */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 1575849..a8300e4 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -47,6 +47,7 @@
>  #include "xfs_sysfs.h"
>  #include "xfs_ondisk.h"
>  #include "xfs_defer.h"
> +#include "xfs_rmap_item.h"
>  
>  #include <linux/namei.h>
>  #include <linux/init.h>
> @@ -1762,8 +1763,26 @@ xfs_init_zones(void)
>  	if (!xfs_icreate_zone)
>  		goto out_destroy_ili_zone;
>  
> +	xfs_rud_zone = kmem_zone_init((sizeof(struct xfs_rud_log_item) +
> +			((XFS_RUD_MAX_FAST_EXTENTS - 1) *
> +				 sizeof(struct xfs_map_extent))),
> +			"xfs_rud_item");
> +	if (!xfs_rud_zone)
> +		goto out_destroy_icreate_zone;
> +
> +	xfs_rui_zone = kmem_zone_init((sizeof(struct xfs_rui_log_item) +
> +			((XFS_RUI_MAX_FAST_EXTENTS - 1) *
> +				sizeof(struct xfs_map_extent))),
> +			"xfs_rui_item");
> +	if (!xfs_rui_zone)
> +		goto out_destroy_rud_zone;
> +
>  	return 0;
>  
> + out_destroy_rud_zone:
> +	kmem_zone_destroy(xfs_rud_zone);
> + out_destroy_icreate_zone:
> +	kmem_zone_destroy(xfs_icreate_zone);
>   out_destroy_ili_zone:
>  	kmem_zone_destroy(xfs_ili_zone);
>   out_destroy_inode_zone:
> @@ -1802,6 +1821,8 @@ xfs_destroy_zones(void)
>  	 * destroy caches.
>  	 */
>  	rcu_barrier();
> +	kmem_zone_destroy(xfs_rui_zone);
> +	kmem_zone_destroy(xfs_rud_zone);
>  	kmem_zone_destroy(xfs_icreate_zone);
>  	kmem_zone_destroy(xfs_ili_zone);
>  	kmem_zone_destroy(xfs_inode_zone);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
