Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39712 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfHLPk3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 11:40:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CFcwTY117108
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 15:40:23 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2u9pjq8cwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 15:40:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CFctFm113187
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 15:40:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2u9n9h0cbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 15:40:22 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CFeMpk020274
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 15:40:22 GMT
Date: Mon, 12 Aug 2019 08:40:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 03/18] xfs: Set up infastructure for deferred
 attribute operations
Message-ID: <20190812154020.GA3440173@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-4-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-4-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Collins <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:37:11PM -0700, Allison Collins wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Currently attributes are modified directly across one or more
> transactions.  But they are not logged or replayed in the event of
> an error. The goal of delayed attributes is to enable logging and
> replaying of attribute operations using the existing delayed
> operations infrastructure.  This will later enable the attributes
> to become part of larger multi part operations that also must first
> be recorded to the log.  This is mostly of interest in the scheme of
> parent pointers which would need to maintain an attribute containing
> parent inode information any time an inode is moved, created, or
> removed.  Parent pointers would then be of interest to any feature
> that would need to quickly derive an inode path from the mount
> point.  Online scrub, nfs lookups and fs grow or shrink operations
> are all features that could take advantage of this.
> 
> This patch adds two new log item types for setting or removing
> attributes as deferred operations.  The xfs_attri_log_item logs an
> intent to set or remove an attribute.  The corresponding
> xfs_attrd_log_item holds a reference to the xfs_attri_log_item and
> is freed once the transaction is done.  Both log items use a generic
> xfs_attr_log_format structure that contains the attribute name,
> value, flags, inode, and an op_flag that indicates if the operations
> is a set or remove.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/Makefile                |   2 +-
>  fs/xfs/libxfs/xfs_attr.c       |   5 +-
>  fs/xfs/libxfs/xfs_attr.h       |  25 ++
>  fs/xfs/libxfs/xfs_defer.c      |   1 +
>  fs/xfs/libxfs/xfs_defer.h      |   3 +
>  fs/xfs/libxfs/xfs_log_format.h |  44 ++-
>  fs/xfs/libxfs/xfs_types.h      |   1 +
>  fs/xfs/xfs_attr_item.c         | 755 +++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_attr_item.h         | 102 ++++++
>  fs/xfs/xfs_log.c               |   4 +
>  fs/xfs/xfs_log_recover.c       | 174 ++++++++++
>  fs/xfs/xfs_ondisk.h            |   2 +
>  fs/xfs/xfs_trans.h             |   4 +-
>  13 files changed, 1116 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 06b68b6..70b4716 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -102,6 +102,7 @@ xfs-y				+= xfs_log.o \
>  				   xfs_bmap_item.o \
>  				   xfs_buf_item.o \
>  				   xfs_extfree_item.o \
> +				   xfs_attr_item.o \
>  				   xfs_icreate_item.o \
>  				   xfs_inode_item.o \
>  				   xfs_refcount_item.o \
> @@ -109,7 +110,6 @@ xfs-y				+= xfs_log.o \
>  				   xfs_log_recover.o \
>  				   xfs_trans_ail.o \
>  				   xfs_trans_buf.o
> -
>  # optional features
>  xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
>  				   xfs_dquot_item.o \
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 0c91116..1f76618 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -24,6 +24,7 @@
>  #include "xfs_quota.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_trace.h"
> +#include "xfs_attr_item.h"
>  
>  /*
>   * xfs_attr.c
> @@ -57,7 +58,7 @@ STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>  
>  
> -STATIC int
> +int
>  xfs_attr_args_init(
>  	struct xfs_da_args	*args,
>  	struct xfs_inode	*dp,
> @@ -151,7 +152,7 @@ xfs_attr_get(
>  /*
>   * Calculate how many blocks we need for the new attribute,
>   */
> -STATIC int
> +int
>  xfs_attr_calc_size(
>  	struct xfs_da_args	*args,
>  	int			*local)
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index aa7261a..9132d4f 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -78,6 +78,28 @@ typedef struct attrlist_ent {	/* data from attr_list() */
>  } attrlist_ent_t;
>  
>  /*
> + * List of attrs to commit later.
> + */
> +struct xfs_attr_item {
> +	struct xfs_inode  *xattri_ip;
> +	uint32_t	  xattri_op_flags;
> +	void		  *xattri_value;      /* attr value */
> +	uint32_t	  xattri_value_len;   /* length of value */
> +	void		  *xattri_name;	      /* attr name */
> +	uint32_t	  xattri_name_len;    /* length of name */
> +	uint32_t	  xattri_flags;       /* attr flags */
> +	struct list_head  xattri_list;

pahole says you could reduce the size of this header from 64 to 56 bytes
by grouping all the pointers together and all the uin32_t together.

> +
> +	/*
> +	 * A byte array follows the header containing the file name and
> +	 * attribute value.
> +	 */
> +};
> +
> +#define XFS_ATTR_ITEM_SIZEOF(namelen, valuelen)	\
> +	(sizeof(struct xfs_attr_item) + (namelen) + (valuelen))
> +
> +/*
>   * Given a pointer to the (char*) buffer containing the attr_list() result,
>   * and an index, return a pointer to the indicated attribute in the buffer.
>   */

<skip past things that look ok>

> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> new file mode 100644
> index 0000000..2340589
> --- /dev/null
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -0,0 +1,755 @@
> +// SPDX-License-Identifier: GPL-2.0+

Sooooo... [redact idiotic spdx drama that I don't care to rehash]

This means that "GPL-2.0+" is not correct here, it's supposed to be
"GPL-2.0-or-later" as defined in LICENSES/preferred/GPL-2.0, and Greg KH
can go fix all the breakage he pushed in the kernel with insufficient
review.

> +/*
> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> + * Author: Allison Henderson <allison.henderson@oracle.com>
> + */
> +
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
> +#include "xfs_buf_item.h"
> +#include "xfs_attr_item.h"
> +#include "xfs_log.h"
> +#include "xfs_btree.h"
> +#include "xfs_rmap.h"
> +#include "xfs_inode.h"
> +#include "xfs_icache.h"
> +#include "xfs_attr.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
> +#include "xfs_shared.h"
> +#include "xfs_attr_item.h"
> +#include "xfs_alloc.h"
> +#include "xfs_bmap.h"
> +#include "xfs_trace.h"
> +#include "libxfs/xfs_da_format.h"
> +#include "xfs_inode.h"
> +#include "xfs_quota.h"
> +
> +
> +/*
> + * This routine is called to allocate an "attr free done" log item.
> + */
> +struct xfs_attrd_log_item *
> +xfs_trans_get_attrd(struct xfs_trans		*tp,
> +		  struct xfs_attri_log_item	*attrip)
> +{
> +	struct xfs_attrd_log_item		*attrdp;
> +
> +	ASSERT(tp != NULL);
> +
> +	attrdp = xfs_attrd_init(tp->t_mountp, attrip);
> +	ASSERT(attrdp != NULL);
> +
> +	/*
> +	 * Get a log_item_desc to point at the new item.
> +	 */
> +	xfs_trans_add_item(tp, &attrdp->attrd_item);
> +	return attrdp;
> +}
> +
> +/*
> + * Delete an attr and log it to the ATTRD. Note that the transaction is marked
> + * dirty regardless of whether the attr delete succeeds or fails to support the
> + * ATTRI/ATTRD lifecycle rules.
> + */
> +int
> +xfs_trans_attr(
> +	struct xfs_da_args		*args,
> +	struct xfs_attrd_log_item	*attrdp,
> +	uint32_t			op_flags)
> +{
> +	int				error;
> +
> +	error = xfs_qm_dqattach_locked(args->dp, 0);
> +	if (error)
> +		return error;
> +
> +	switch (op_flags) {
> +	case XFS_ATTR_OP_FLAGS_SET:
> +		args->op_flags |= XFS_DA_OP_ADDNAME;
> +		error = xfs_attr_set_args(args);
> +		break;
> +	case XFS_ATTR_OP_FLAGS_REMOVE:
> +		ASSERT(XFS_IFORK_Q((args->dp)));
> +		error = xfs_attr_remove_args(args);
> +		break;
> +	default:
> +		error = -EFSCORRUPTED;

The default clause needs a break; here.

> +	}
> +
> +	/*
> +	 * Mark the transaction dirty, even on error. This ensures the
> +	 * transaction is aborted, which:
> +	 *
> +	 * 1.) releases the ATTRI and frees the ATTRD
> +	 * 2.) shuts down the filesystem
> +	 */
> +	args->trans->t_flags |= XFS_TRANS_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
> +
> +	return error;
> +}
> +

<skip stuff that looks ok>

> +/*
> + * This is the ops vector shared by all attri log items.
> + */

We just got rid of this comment above all the other log item ops
structure definitions, so you can clip these out.

> +static const struct xfs_item_ops xfs_attri_item_ops = {
> +	.iop_size	= xfs_attri_item_size,
> +	.iop_format	= xfs_attri_item_format,
> +	.iop_pin	= xfs_attri_item_pin,
> +	.iop_unpin	= xfs_attri_item_unpin,
> +	.iop_committed	= xfs_attri_item_committed,
> +	.iop_push	= xfs_attri_item_push,
> +	.iop_committing = xfs_attri_item_committing,
> +	.iop_release    = xfs_attri_item_release,
> +};
> +
> +
> +/*
> + * Allocate and initialize an attri item
> + */
> +struct xfs_attri_log_item *
> +xfs_attri_init(
> +	struct xfs_mount	*mp)
> +
> +{
> +	struct xfs_attri_log_item	*attrip;
> +	uint				size;
> +
> +	size = (uint)(sizeof(struct xfs_attri_log_item));
> +	attrip = kmem_zalloc(size, KM_SLEEP);
> +
> +	xfs_log_item_init(mp, &attrip->attri_item, XFS_LI_ATTRI,
> +			  &xfs_attri_item_ops);
> +	attrip->attri_format.alfi_id = (uintptr_t)(void *)attrip;

/me wonders if we ought to clean up all these *[id]_id types so that we
don't have to employ all these annoying casts, but that's not relevant
to this series.

> +	atomic_set(&attrip->attri_refcount, 2);
> +
> +	return attrip;
> +}
> +

<skip more stuff that looked ok>

> +/*
> + * Pinning has no meaning for an attrd item, so just return.
> + */
> +STATIC void
> +xfs_attrd_item_pin(
> +	struct xfs_log_item	*lip)
> +{
> +}

Hmm, didn't Christoph refactor the log code in 5.3 so that log items
don't need all these empty unlock/committing/pin functions?

> +
> +/*
> + * Since pinning has no meaning for an attrd item, unpinning does
> + * not either.
> + */
> +STATIC void
> +xfs_attrd_item_unpin(
> +	struct xfs_log_item	*lip,
> +	int			remove)
> +{
> +}
> +
> +/*
> + * There isn't much you can do to push on an attrd item.  It is simply stuck
> + * waiting for the log to be flushed to disk.
> + */
> +STATIC uint
> +xfs_attrd_item_push(
> +	struct xfs_log_item	*lip,
> +	struct list_head	*buffer_list)
> +{
> +	return XFS_ITEM_PINNED;
> +}
> +
> +/*
> + * When the attrd item is committed to disk, all we need to do is delete our
> + * reference to our partner attri item and then free ourselves. Since we're
> + * freeing ourselves we must return -1 to keep the transaction code from
> + * further referencing this item.
> + */
> +STATIC xfs_lsn_t
> +xfs_attrd_item_committed(
> +	struct xfs_log_item	*lip,
> +	xfs_lsn_t		lsn)
> +{
> +	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
> +
> +	/*
> +	 * Drop the ATTRI reference regardless of whether the ATTRD has been
> +	 * aborted. Once the ATTRD transaction is constructed, it is the sole
> +	 * responsibility of the ATTRD to release the ATTRI (even if the ATTRI
> +	 * is aborted due to log I/O error).
> +	 */
> +	xfs_attri_release(attrdp->attrd_attrip);
> +	xfs_attrd_item_free(attrdp);
> +
> +	return (xfs_lsn_t)-1;

NULLCOMMITLSN?

<skip more>

> +/*
> + * Process an attr intent item that was recovered from the log.  We need to
> + * delete the attr that it describes.
> + */
> +int
> +xfs_attri_recover(
> +	struct xfs_mount		*mp,
> +	struct xfs_attri_log_item	*attrip)
> +{
> +	struct xfs_inode		*ip;
> +	struct xfs_attrd_log_item	*attrdp;
> +	struct xfs_da_args		args;
> +	struct xfs_attri_log_format	*attrp;
> +	struct xfs_trans_res		tres;
> +	int				local;
> +	int				error = 0;
> +	int				rsvd = 0;
> +	struct xfs_name			name;
> +
> +	ASSERT(!test_bit(XFS_ATTRI_RECOVERED, &attrip->attri_flags));
> +
> +	/*
> +	 * First check the validity of the attr described by the ATTRI.  If any
> +	 * are bad, then assume that all are bad and just toss the ATTRI.
> +	 */
> +	attrp = &attrip->attri_format;
> +	if (
> +	    !(attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET ||
> +		attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_REMOVE) ||
> +	      (attrp->alfi_value_len > XATTR_SIZE_MAX) ||
> +	      (attrp->alfi_name_len > XATTR_NAME_MAX) ||
> +	      (attrp->alfi_name_len == 0)
> +	) {
> +		/*
> +		 * This will pull the ATTRI from the AIL and free the memory
> +		 * associated with it.
> +		 */
> +		set_bit(XFS_ATTRI_RECOVERED, &attrip->attri_flags);
> +		xfs_attri_release(attrip);
> +		return -EIO;

This is probably more EFSCORRUPTED than EIO here, right?

> +	}
> +
> +	attrp = &attrip->attri_format;
> +	error = xfs_iget(mp, 0, attrp->alfi_ino, 0, 0, &ip);
> +	if (error)
> +		return error;
> +
> +	name.name = attrip->attri_name;
> +	name.len = attrp->alfi_name_len;
> +	name.type = attrp->alfi_attr_flags;
> +	error = xfs_attr_args_init(&args, ip, &name);
> +	if (error)
> +		return error;
> +
> +	args.hashval = xfs_da_hashname(args.name, args.namelen);
> +	args.value = attrip->attri_value;
> +	args.valuelen = attrp->alfi_value_len;
> +	args.op_flags = XFS_DA_OP_OKNOENT;
> +	args.total = xfs_attr_calc_size(&args, &local);
> +
> +	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> +			M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
> +	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
> +	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> +
> +	error = xfs_trans_alloc(mp, &tres, args.total,  0,
> +				rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
> +	if (error)
> +		return error;
> +	attrdp = xfs_trans_get_attrd(args.trans, attrip);
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +
> +	xfs_trans_ijoin(args.trans, ip, 0);
> +	error = xfs_trans_attr(&args, attrdp, attrp->alfi_op_flags);
> +	if (error)
> +		goto abort_error;
> +
> +
> +	set_bit(XFS_ATTRI_RECOVERED, &attrip->attri_flags);
> +	xfs_trans_log_inode(args.trans, ip, XFS_ILOG_CORE | XFS_ILOG_ADATA);
> +	error = xfs_trans_commit(args.trans);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	return error;
> +
> +abort_error:
> +	xfs_trans_cancel(args.trans);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	return error;
> +}
> diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
> new file mode 100644
> index 0000000..aad32ed
> --- /dev/null
> +++ b/fs/xfs/xfs_attr_item.h
> @@ -0,0 +1,102 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> + * Author: Allison Henderson <allison.henderson@oracle.com>
> + */
> +#ifndef	__XFS_ATTR_ITEM_H__
> +#define	__XFS_ATTR_ITEM_H__
> +
> +/* kernel only ATTRI/ATTRD definitions */
> +
> +struct xfs_mount;
> +struct kmem_zone;
> +
> +/*
> + * Max number of attrs in fast allocation path.
> + */
> +#define XFS_ATTRI_MAX_FAST_ATTRS        1
> +
> +
> +/*
> + * Define ATTR flag bits. Manipulated by set/clear/test_bit operators.
> + */
> +#define	XFS_ATTRI_RECOVERED	1
> +
> +
> +/* iovec length must be 32-bit aligned */
> +#define ATTR_NVEC_SIZE(size) (size == sizeof(int32_t) ? sizeof(int32_t) : \
> +				size + sizeof(int32_t) - \
> +				(size % sizeof(int32_t)))
> +
> +/*
> + * This is the "attr intention" log item.  It is used to log the fact that some
> + * need to be processed.  It is used in conjunction with the "attr done" log
> + * item described below.
> + *
> + * The ATTRI is reference counted so that it is not freed prior to both the
> + * ATTRI and ATTRD being committed and unpinned. This ensures the ATTRI is
> + * inserted into the AIL even in the event of out of order ATTRI/ATTRD
> + * processing. In other words, an ATTRI is born with two references:
> + *
> + *      1.) an ATTRI held reference to track ATTRI AIL insertion
> + *      2.) an ATTRD held reference to track ATTRD commit
> + *
> + * On allocation, both references are the responsibility of the caller. Once the
> + * ATTRI is added to and dirtied in a transaction, ownership of reference one
> + * transfers to the transaction. The reference is dropped once the ATTRI is
> + * inserted to the AIL or in the event of failure along the way (e.g., commit
> + * failure, log I/O error, etc.). Note that the caller remains responsible for
> + * the ATTRD reference under all circumstances to this point. The caller has no
> + * means to detect failure once the transaction is committed, however.
> + * Therefore, an ATTRD is required after this point, even in the event of
> + * unrelated failure.
> + *
> + * Once an ATTRD is allocated and dirtied in a transaction, reference two
> + * transfers to the transaction. The ATTRD reference is dropped once it reaches
> + * the unpin handler. Similar to the ATTRI, the reference also drops in the
> + * event of commit failure or log I/O errors. Note that the ATTRD is not
> + * inserted in the AIL, so at this point both the ATTI and ATTRD are freed.

"...the ATTRI and ATTRD are freed." ?

> + */
> +struct xfs_attri_log_item {
> +	struct xfs_log_item		attri_item;
> +	atomic_t			attri_refcount;
> +	unsigned long			attri_flags;	/* misc flags */
> +	int				attri_name_len;
> +	void				*attri_name;
> +	int				attri_value_len;
> +	void				*attri_value;
> +	struct xfs_attri_log_format	attri_format;
> +};
> +
> +/*
> + * This is the "attr done" log item.  It is used to log the fact that some attrs
> + * earlier mentioned in an attri item have been freed.
> + */
> +struct xfs_attrd_log_item {
> +	struct xfs_log_item		attrd_item;
> +	struct xfs_attri_log_item	*attrd_attrip;
> +	struct xfs_attrd_log_format	attrd_format;
> +};

Can these be rearranged to use less memory?

Everything else after this looks ok to me.

--D

> +
> +/*
> + * Max number of attrs in fast allocation path.
> + */
> +#define	XFS_ATTRD_MAX_FAST_ATTRS	1
> +
> +extern struct kmem_zone	*xfs_attri_zone;
> +extern struct kmem_zone	*xfs_attrd_zone;
> +
> +struct xfs_attri_log_item	*xfs_attri_init(struct xfs_mount *mp);
> +struct xfs_attrd_log_item	*xfs_attrd_init(struct xfs_mount *mp,
> +					struct xfs_attri_log_item *attrip);
> +int xfs_attri_copy_format(struct xfs_log_iovec *buf,
> +			   struct xfs_attri_log_format *dst_attri_fmt);
> +int xfs_attrd_copy_format(struct xfs_log_iovec *buf,
> +			   struct xfs_attrd_log_format *dst_attrd_fmt);
> +void			xfs_attri_item_free(struct xfs_attri_log_item *attrip);
> +void			xfs_attri_release(struct xfs_attri_log_item *attrip);
> +
> +int			xfs_attri_recover(struct xfs_mount *mp,
> +					struct xfs_attri_log_item *attrip);
> +
> +#endif	/* __XFS_ATTR_ITEM_H__ */
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 00e9f5c..2fbd180 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2005,6 +2005,10 @@ xlog_print_tic_res(
>  	    REG_TYPE_STR(CUD_FORMAT, "cud_format"),
>  	    REG_TYPE_STR(BUI_FORMAT, "bui_format"),
>  	    REG_TYPE_STR(BUD_FORMAT, "bud_format"),
> +	    REG_TYPE_STR(ATTRI_FORMAT, "attri_format"),
> +	    REG_TYPE_STR(ATTRD_FORMAT, "attrd_format"),
> +	    REG_TYPE_STR(ATTR_NAME, "attr_name"),
> +	    REG_TYPE_STR(ATTR_VALUE, "attr_value"),
>  	};
>  	BUILD_BUG_ON(ARRAY_SIZE(res_type_str) != XLOG_REG_TYPE_MAX + 1);
>  #undef REG_TYPE_STR
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 13d1d3e..233efdb3 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -20,6 +20,7 @@
>  #include "xfs_log_recover.h"
>  #include "xfs_inode_item.h"
>  #include "xfs_extfree_item.h"
> +#include "xfs_attr_item.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_alloc.h"
>  #include "xfs_ialloc.h"
> @@ -1885,6 +1886,8 @@ xlog_recover_reorder_trans(
>  		case XFS_LI_CUD:
>  		case XFS_LI_BUI:
>  		case XFS_LI_BUD:
> +		case XFS_LI_ATTRI:
> +		case XFS_LI_ATTRD:
>  			trace_xfs_log_recover_item_reorder_tail(log,
>  							trans, item, pass);
>  			list_move_tail(&item->ri_list, &inode_list);
> @@ -3422,6 +3425,119 @@ xlog_recover_efd_pass2(
>  	return 0;
>  }
>  
> +STATIC int
> +xlog_recover_attri_pass2(
> +	struct xlog                     *log,
> +	struct xlog_recover_item        *item,
> +	xfs_lsn_t                       lsn)
> +{
> +	int                             error;
> +	struct xfs_mount                *mp = log->l_mp;
> +	struct xfs_attri_log_item       *attrip;
> +	struct xfs_attri_log_format     *attri_formatp;
> +	char				*name = NULL;
> +	char				*value = NULL;
> +	int				region = 0;
> +
> +	attri_formatp = item->ri_buf[region].i_addr;
> +
> +	attrip = xfs_attri_init(mp);
> +	error = xfs_attri_copy_format(&item->ri_buf[region],
> +				      &attrip->attri_format);
> +	if (error) {
> +		xfs_attri_item_free(attrip);
> +		return error;
> +	}
> +
> +	attrip->attri_name_len = attri_formatp->alfi_name_len;
> +	attrip->attri_value_len = attri_formatp->alfi_value_len;
> +	attrip = kmem_realloc(attrip, sizeof(struct xfs_attri_log_item) +
> +			      attrip->attri_name_len + attrip->attri_value_len,
> +			      KM_SLEEP);
> +
> +	if (attrip->attri_name_len > 0) {
> +		region++;
> +		name = ((char *)attrip) + sizeof(struct xfs_attri_log_item);
> +		memcpy(name, item->ri_buf[region].i_addr,
> +		       attrip->attri_name_len);
> +		attrip->attri_name = name;
> +	}
> +
> +	if (attrip->attri_value_len > 0) {
> +		region++;
> +		value = ((char *)attrip) + sizeof(struct xfs_attri_log_item) +
> +			attrip->attri_name_len;
> +		memcpy(value, item->ri_buf[region].i_addr,
> +			attrip->attri_value_len);
> +		attrip->attri_value = value;
> +	}
> +
> +	spin_lock(&log->l_ailp->ail_lock);
> +	/*
> +	 * The ATTRI has two references. One for the ATTRD and one for ATTRI to
> +	 * ensure it makes it into the AIL. Insert the ATTRI into the AIL
> +	 * directly and drop the ATTRI reference. Note that
> +	 * xfs_trans_ail_update() drops the AIL lock.
> +	 */
> +	xfs_trans_ail_update(log->l_ailp, &attrip->attri_item, lsn);
> +	xfs_attri_release(attrip);
> +	return 0;
> +}
> +
> +
> +/*
> + * This routine is called when an ATTRD format structure is found in a committed
> + * transaction in the log. Its purpose is to cancel the corresponding ATTRI if
> + * it was still in the log. To do this it searches the AIL for the ATTRI with
> + * an id equal to that in the ATTRD format structure. If we find it we drop
> + * the ATTRD reference, which removes the ATTRI from the AIL and frees it.
> + */
> +STATIC int
> +xlog_recover_attrd_pass2(
> +	struct xlog                     *log,
> +	struct xlog_recover_item        *item)
> +{
> +	struct xfs_attrd_log_format	*attrd_formatp;
> +	struct xfs_attri_log_item	*attrip = NULL;
> +	struct xfs_log_item		*lip;
> +	uint64_t			attri_id;
> +	struct xfs_ail_cursor		cur;
> +	struct xfs_ail			*ailp = log->l_ailp;
> +
> +	attrd_formatp = item->ri_buf[0].i_addr;
> +	ASSERT((item->ri_buf[0].i_len ==
> +				(sizeof(struct xfs_attrd_log_format))));
> +	attri_id = attrd_formatp->alfd_alf_id;
> +
> +	/*
> +	 * Search for the ATTRI with the id in the ATTRD format structure in the
> +	 * AIL.
> +	 */
> +	spin_lock(&ailp->ail_lock);
> +	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> +	while (lip != NULL) {
> +		if (lip->li_type == XFS_LI_ATTRI) {
> +			attrip = (struct xfs_attri_log_item *)lip;
> +			if (attrip->attri_format.alfi_id == attri_id) {
> +				/*
> +				 * Drop the ATTRD reference to the ATTRI. This
> +				 * removes the ATTRI from the AIL and frees it.
> +				 */
> +				spin_unlock(&ailp->ail_lock);
> +				xfs_attri_release(attrip);
> +				spin_lock(&ailp->ail_lock);
> +				break;
> +			}
> +		}
> +		lip = xfs_trans_ail_cursor_next(ailp, &cur);
> +	}
> +
> +	xfs_trans_ail_cursor_done(&cur);
> +	spin_unlock(&ailp->ail_lock);
> +
> +	return 0;
> +}
> +
>  /*
>   * This routine is called to create an in-core extent rmap update
>   * item from the rui format structure which was logged on disk.
> @@ -3974,6 +4090,8 @@ xlog_recover_ra_pass2(
>  		break;
>  	case XFS_LI_EFI:
>  	case XFS_LI_EFD:
> +	case XFS_LI_ATTRI:
> +	case XFS_LI_ATTRD:
>  	case XFS_LI_QUOTAOFF:
>  	case XFS_LI_RUI:
>  	case XFS_LI_RUD:
> @@ -4002,6 +4120,8 @@ xlog_recover_commit_pass1(
>  	case XFS_LI_INODE:
>  	case XFS_LI_EFI:
>  	case XFS_LI_EFD:
> +	case XFS_LI_ATTRI:
> +	case XFS_LI_ATTRD:
>  	case XFS_LI_DQUOT:
>  	case XFS_LI_ICREATE:
>  	case XFS_LI_RUI:
> @@ -4040,6 +4160,10 @@ xlog_recover_commit_pass2(
>  		return xlog_recover_efi_pass2(log, item, trans->r_lsn);
>  	case XFS_LI_EFD:
>  		return xlog_recover_efd_pass2(log, item);
> +	case XFS_LI_ATTRI:
> +		return xlog_recover_attri_pass2(log, item, trans->r_lsn);
> +	case XFS_LI_ATTRD:
> +		return xlog_recover_attrd_pass2(log, item);
>  	case XFS_LI_RUI:
>  		return xlog_recover_rui_pass2(log, item, trans->r_lsn);
>  	case XFS_LI_RUD:
> @@ -4601,6 +4725,48 @@ xlog_recover_cancel_efi(
>  	spin_lock(&ailp->ail_lock);
>  }
>  
> +/* Release the ATTRI since we're cancelling everything. */
> +STATIC void
> +xlog_recover_cancel_attri(
> +	struct xfs_mount                *mp,
> +	struct xfs_ail                  *ailp,
> +	struct xfs_log_item             *lip)
> +{
> +	struct xfs_attri_log_item         *attrip;
> +
> +	attrip = container_of(lip, struct xfs_attri_log_item, attri_item);
> +
> +	spin_unlock(&ailp->ail_lock);
> +	xfs_attri_release(attrip);
> +	spin_lock(&ailp->ail_lock);
> +}
> +
> +
> +/* Recover the ATTRI if necessary. */
> +STATIC int
> +xlog_recover_process_attri(
> +	struct xfs_mount                *mp,
> +	struct xfs_ail                  *ailp,
> +	struct xfs_log_item             *lip)
> +{
> +	struct xfs_attri_log_item       *attrip;
> +	int                             error;
> +
> +	/*
> +	 * Skip ATTRIs that we've already processed.
> +	 */
> +	attrip = container_of(lip, struct xfs_attri_log_item, attri_item);
> +	if (test_bit(XFS_ATTRI_RECOVERED, &attrip->attri_flags))
> +		return 0;
> +
> +	spin_unlock(&ailp->ail_lock);
> +	error = xfs_attri_recover(mp, attrip);
> +	spin_lock(&ailp->ail_lock);
> +
> +	return error;
> +}
> +
> +
>  /* Recover the RUI if necessary. */
>  STATIC int
>  xlog_recover_process_rui(
> @@ -4729,6 +4895,7 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
>  	case XFS_LI_RUI:
>  	case XFS_LI_CUI:
>  	case XFS_LI_BUI:
> +	case XFS_LI_ATTRI:
>  		return true;
>  	default:
>  		return false;
> @@ -4847,6 +5014,10 @@ xlog_recover_process_intents(
>  		case XFS_LI_EFI:
>  			error = xlog_recover_process_efi(log->l_mp, ailp, lip);
>  			break;
> +		case XFS_LI_ATTRI:
> +			error = xlog_recover_process_attri(log->l_mp,
> +							   ailp, lip);
> +			break;
>  		case XFS_LI_RUI:
>  			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
>  			break;
> @@ -4912,6 +5083,9 @@ xlog_recover_cancel_intents(
>  		case XFS_LI_BUI:
>  			xlog_recover_cancel_bui(log->l_mp, ailp, lip);
>  			break;
> +		case XFS_LI_ATTRI:
> +			xlog_recover_cancel_attri(log->l_mp, ailp, lip);
> +			break;
>  		}
>  
>  		lip = xfs_trans_ail_cursor_next(ailp, &cur);
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index b6701b4..120fb0c 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -125,6 +125,8 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
>  
>  	/*
>  	 * The v5 superblock format extended several v4 header structures with
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 64d7f17..95924dc 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -26,6 +26,9 @@ struct xfs_cui_log_item;
>  struct xfs_cud_log_item;
>  struct xfs_bui_log_item;
>  struct xfs_bud_log_item;
> +struct xfs_attrd_log_item;
> +struct xfs_attri_log_item;
> +struct xfs_da_args;
>  
>  struct xfs_log_item {
>  	struct list_head		li_ail;		/* AIL pointers */
> @@ -229,7 +232,6 @@ void		xfs_trans_log_buf(struct xfs_trans *, struct xfs_buf *, uint,
>  void		xfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
>  bool		xfs_trans_buf_is_dirty(struct xfs_buf *bp);
>  void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
> -
>  int		xfs_trans_commit(struct xfs_trans *);
>  int		xfs_trans_roll(struct xfs_trans **);
>  int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
> -- 
> 2.7.4
> 
