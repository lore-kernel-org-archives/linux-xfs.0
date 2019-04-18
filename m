Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27732 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387519AbfDRPs6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Apr 2019 11:48:58 -0400
Date: Thu, 18 Apr 2019 11:48:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/9] xfs: Set up infastructure for deferred attribute
 operations
Message-ID: <20190418154854.GB2885@bfoster>
References: <20190412225036.22939-1-allison.henderson@oracle.com>
 <20190412225036.22939-5-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190412225036.22939-5-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 12, 2019 at 03:50:31PM -0700, Allison Henderson wrote:
> This patch adds two new log item types for setting or
> removing attributes as deferred operations.  The
> xfs_attri_log_item logs an intent to set or remove an
> attribute.  The corresponding xfs_attrd_log_item holds
> a reference to the xfs_attri_log_item and is freed once
> the transaction is done.  Both log items use a generic
> xfs_attr_log_format structure that contains the attribute
> name, value, flags, inode, and an op_flag that indicates
> if the operations is a set or remove.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---

This mostly looks sane to me on a first high level pass. We're adding
the intent/done log item infrastructure for attrs, associated dfops
processing code and log recovery hooks. I'll probably have to go back
through this once I get further through the series and have grokked more
context, but so far I think I just have some various nits and aesthetic
comments.

Firstly, note that git complained about an extra blank line at EOF of
xfs_trans_attr.c when I applied this patch. Also, the commit log above
looks like it could be widened (I think 68 chars is the standard) and
could probably include a bit more context on the big picture changes
associated with this work. In general, I think the commit log should
(briefly) explain 1.) how attrs currently work 2.) how things are
expected to work based on this infrastructure and 3.) the advantage(s)
of doing so.

For example, one thing that is glossed over is that this implies we'll
be logging xattr values even in remote attribute block cases. BTW, do we
need to update the transaction reservation to account for that? I didn't
notice that being changed anwhere (yet)..

>  fs/xfs/Makefile                |   2 +
>  fs/xfs/libxfs/xfs_attr.c       |   5 +-
>  fs/xfs/libxfs/xfs_attr.h       |  25 ++
>  fs/xfs/libxfs/xfs_defer.c      |   1 +
>  fs/xfs/libxfs/xfs_defer.h      |   3 +
>  fs/xfs/libxfs/xfs_log_format.h |  44 +++-
>  fs/xfs/libxfs/xfs_types.h      |   1 +
>  fs/xfs/xfs_attr_item.c         | 558 +++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_attr_item.h         | 103 ++++++++
>  fs/xfs/xfs_log_recover.c       | 172 +++++++++++++
>  fs/xfs/xfs_ondisk.h            |   2 +
>  fs/xfs/xfs_trans.h             |  10 +
>  fs/xfs/xfs_trans_attr.c        | 240 ++++++++++++++++++
>  13 files changed, 1162 insertions(+), 4 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> new file mode 100644
> index 0000000..0ea19b4
> --- /dev/null
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -0,0 +1,558 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> + * Author: Allison Henderson <allison.henderson@oracle.com>
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_bit.h"
> +#include "xfs_mount.h"
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
> +#include "xfs_shared.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
> +
> +static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
> +{
> +	return container_of(lip, struct xfs_attri_log_item, item);
> +}
> +
> +void
> +xfs_attri_item_free(
> +	struct xfs_attri_log_item	*attrip)
> +{
> +	kmem_free(attrip->item.li_lv_shadow);
> +	kmem_free(attrip);
> +}
> +
> +/*
> + * This returns the number of iovecs needed to log the given attri item.
> + * We only need 1 iovec for an attri item.  It just logs the attr_log_format
> + * structure.
> + */
> +static inline int
> +xfs_attri_item_sizeof(
> +	struct xfs_attri_log_item *attrip)
> +{
> +	return sizeof(struct xfs_attri_log_format);
> +}
> +
> +STATIC void
> +xfs_attri_item_size(
> +	struct xfs_log_item	*lip,
> +	int			*nvecs,
> +	int			*nbytes)
> +{
> +	struct xfs_attri_log_item       *attrip = ATTRI_ITEM(lip);
> +
> +	*nvecs += 1;
> +	*nbytes += xfs_attri_item_sizeof(attrip);
> +
> +	if (attrip->name_len > 0) {
> +		*nvecs += 1;
> +		*nbytes += ATTR_NVEC_SIZE(attrip->name_len);
> +	}
> +
> +	if (attrip->value_len > 0) {
> +		*nvecs += 1;
> +		*nbytes += ATTR_NVEC_SIZE(attrip->value_len);
> +	}
> +}
> +
> +/*
> + * This is called to fill in the vector of log iovecs for the
> + * given attri log item. We use only 1 iovec, and we point that
> + * at the attri_log_format structure embedded in the attri item.
> + * It is at this point that we assert that all of the attr
> + * slots in the attri item have been filled.
> + */

I see a bunch of places throughout this patch such as above where the
line length formatting looks inconsistent. The above comment should be
widened to 80 chars. I'm sure much of this code was boilerplate brought
over from other log items and such, but we should take the opportunity
to properly format the new code we're adding.

> +STATIC void
> +xfs_attri_item_format(
> +	struct xfs_log_item	*lip,
> +	struct xfs_log_vec	*lv)
> +{
> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
> +	struct xfs_log_iovec	*vecp = NULL;
> +
> +	attrip->format.alfi_type = XFS_LI_ATTRI;
> +	attrip->format.alfi_size = 1;
> +	if (attrip->name_len > 0)
> +		attrip->format.alfi_size++;
> +	if (attrip->value_len > 0)
> +		attrip->format.alfi_size++;
> +

I'd move these afli_size updates to the equivalent if checks below.

> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
> +			&attrip->format,
> +			xfs_attri_item_sizeof(attrip));
> +	if (attrip->name_len > 0)
> +		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
> +				attrip->name, ATTR_NVEC_SIZE(attrip->name_len));
> +
> +	if (attrip->value_len > 0)
> +		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
> +				attrip->value,
> +				ATTR_NVEC_SIZE(attrip->value_len));
> +}
> +
> +
> +/*
> + * Pinning has no meaning for an attri item, so just return.
> + */
> +STATIC void
> +xfs_attri_item_pin(
> +	struct xfs_log_item	*lip)
> +{
> +}
> +
> +/*
> + * The unpin operation is the last place an ATTRI is manipulated in the log. It
> + * is either inserted in the AIL or aborted in the event of a log I/O error. In
> + * either case, the ATTRI transaction has been successfully committed to make it
> + * this far. Therefore, we expect whoever committed the ATTRI to either
> + * construct and commit the ATTRD or drop the ATTRD's reference in the event of
> + * error. Simply drop the log's ATTRI reference now that the log is done with
> + * it.
> + */
> +STATIC void
> +xfs_attri_item_unpin(
> +	struct xfs_log_item	*lip,
> +	int			remove)
> +{
> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
> +
> +	xfs_attri_release(attrip);
> +}
> +
> +/*
> + * attri items have no locking or pushing.  However, since ATTRIs are pulled
> + * from the AIL when their corresponding ATTRDs are committed to disk, their
> + * situation is very similar to being pinned.  Return XFS_ITEM_PINNED so that
> + * the caller will eventually flush the log.  This should help in getting the
> + * ATTRI out of the AIL.
> + */
> +STATIC uint
> +xfs_attri_item_push(
> +	struct xfs_log_item	*lip,
> +	struct list_head	*buffer_list)
> +{
> +	return XFS_ITEM_PINNED;
> +}
> +
> +/*
> + * The ATTRI has been either committed or aborted if the transaction has been
> + * cancelled. If the transaction was cancelled, an ATTRD isn't going to be
> + * constructed and thus we free the ATTRI here directly.
> + */
> +STATIC void
> +xfs_attri_item_unlock(
> +	struct xfs_log_item	*lip)
> +{
> +	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
> +		xfs_attri_release(ATTRI_ITEM(lip));
> +}
> +
> +/*
> + * The ATTRI is logged only once and cannot be moved in the log, so simply
> + * return the lsn at which it's been logged.
> + */
> +STATIC xfs_lsn_t
> +xfs_attri_item_committed(
> +	struct xfs_log_item	*lip,
> +	xfs_lsn_t		lsn)
> +{
> +	return lsn;
> +}
> +
> +STATIC void
> +xfs_attri_item_committing(
> +	struct xfs_log_item	*lip,
> +	xfs_lsn_t		lsn)
> +{
> +}
> +
> +/*
> + * This is the ops vector shared by all attri log items.
> + */
> +static const struct xfs_item_ops xfs_attri_item_ops = {
> +	.iop_size	= xfs_attri_item_size,
> +	.iop_format	= xfs_attri_item_format,
> +	.iop_pin	= xfs_attri_item_pin,
> +	.iop_unpin	= xfs_attri_item_unpin,
> +	.iop_unlock	= xfs_attri_item_unlock,
> +	.iop_committed	= xfs_attri_item_committed,
> +	.iop_push	= xfs_attri_item_push,
> +	.iop_committing = xfs_attri_item_committing
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
> +	uint			size;
> +
> +	size = (uint)(sizeof(struct xfs_attri_log_item));
> +	attrip = kmem_zalloc(size, KM_SLEEP);
> +
> +	xfs_log_item_init(mp, &(attrip->item), XFS_LI_ATTRI,
> +			  &xfs_attri_item_ops);

No need for those braces around attrip->item, and with those removed we
can reduce this to a single line.

> +	attrip->format.alfi_id = (uintptr_t)(void *)attrip;
> +	atomic_set(&attrip->refcount, 2);
> +
> +	return attrip;
> +}
> +
> +/*
> + * Copy an attr format buffer from the given buf, and into the destination
> + * attr format structure.
> + */
> +int
> +xfs_attri_copy_format(struct xfs_log_iovec *buf,
> +		      struct xfs_attri_log_format *dst_attr_fmt)
> +{
> +	struct xfs_attri_log_format *src_attr_fmt = buf->i_addr;
> +	uint len = sizeof(struct xfs_attri_log_format);
> +
> +	if (buf->i_len == len) {
> +		memcpy((char *)dst_attr_fmt, (char *)src_attr_fmt, len);
> +		return 0;
> +	}
> +	return -EFSCORRUPTED;

Can we invert the logic flow here (and below)? I.e.,

	...
	if (buf->i_len != len)
		return -EFSCORRUPTED;
	memcpy(...);
	return 0;

> +}
> +
> +/*
> + * Copy an attr format buffer from the given buf, and into the destination
> + * attr format structure.
> + */
> +int
> +xfs_attrd_copy_format(struct xfs_log_iovec *buf,
> +		      struct xfs_attrd_log_format *dst_attr_fmt)
> +{
> +	struct xfs_attrd_log_format *src_attr_fmt = buf->i_addr;
> +	uint len = sizeof(struct xfs_attrd_log_format);
> +
> +	if (buf->i_len == len) {
> +		memcpy((char *)dst_attr_fmt, (char *)src_attr_fmt, len);
> +		return 0;
> +	}
> +	return -EFSCORRUPTED;
> +}
> +

This function appears to be unused. The recover code looks like it just
casts the iovec buffer directly to an attrd_log_format to determine the
id.

> +/*
> + * Freeing the attrip requires that we remove it from the AIL if it has already
> + * been placed there. However, the ATTRI may not yet have been placed in the
> + * AIL when called by xfs_attri_release() from ATTRD processing due to the
> + * ordering of committed vs unpin operations in bulk insert operations. Hence
> + * the reference count to ensure only the last caller frees the ATTRI.
> + */
> +void
> +xfs_attri_release(
> +	struct xfs_attri_log_item	*attrip)
> +{
> +	ASSERT(atomic_read(&attrip->refcount) > 0);
> +	if (atomic_dec_and_test(&attrip->refcount)) {
> +		xfs_trans_ail_remove(&attrip->item, SHUTDOWN_LOG_IO_ERROR);
> +		xfs_attri_item_free(attrip);
> +	}
> +}
> +
> +static inline struct xfs_attrd_log_item *ATTRD_ITEM(struct xfs_log_item *lip)
> +{
> +	return container_of(lip, struct xfs_attrd_log_item, item);
> +}
> +
> +STATIC void
> +xfs_attrd_item_free(struct xfs_attrd_log_item *attrdp)
> +{
> +	kmem_free(attrdp->item.li_lv_shadow);
> +	kmem_free(attrdp);
> +}
> +
> +/*
> + * This returns the number of iovecs needed to log the given attrd item.
> + * We only need 1 iovec for an attrd item.  It just logs the attr_log_format
> + * structure.
> + */
> +static inline int
> +xfs_attrd_item_sizeof(
> +	struct xfs_attrd_log_item *attrdp)
> +{
> +	return sizeof(struct xfs_attrd_log_format);
> +}
> +
> +STATIC void
> +xfs_attrd_item_size(
> +	struct xfs_log_item	*lip,
> +	int			*nvecs,
> +	int			*nbytes)
> +{
> +	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
> +	*nvecs += 1;
> +	*nbytes += xfs_attrd_item_sizeof(attrdp);
> +}
> +
> +/*
> + * This is called to fill in the vector of log iovecs for the
> + * given attrd log item. We use only 1 iovec, and we point that
> + * at the attr_log_format structure embedded in the attrd item.
> + * It is at this point that we assert that all of the attr
> + * slots in the attrd item have been filled.
> + */
> +STATIC void
> +xfs_attrd_item_format(
> +	struct xfs_log_item	*lip,
> +	struct xfs_log_vec	*lv)
> +{
> +	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
> +	struct xfs_log_iovec	*vecp = NULL;
> +
> +	attrdp->format.alfd_type = XFS_LI_ATTRD;
> +	attrdp->format.alfd_size = 1;
> +
> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRD_FORMAT,
> +			&attrdp->format,
> +			xfs_attrd_item_sizeof(attrdp));

The above looks like it could be shrunk to 2 lines as well after 80 char
widening. Note that I'm sure I haven't caught all of these, just
pointing out some examples as I notice them.

FWIW, if you happen to use vim, I sometimes use ':set cc=80' to draw an
80 char line in the viewer that helps to quickly eyeball new code for
this kind of thing.

> +}
> +
> +/*
> + * Pinning has no meaning for an attrd item, so just return.
> + */
> +STATIC void
> +xfs_attrd_item_pin(
> +	struct xfs_log_item	*lip)
> +{
> +}
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
> + * The ATTRD is either committed or aborted if the transaction is cancelled. If
> + * the transaction is cancelled, drop our reference to the ATTRI and free the
> + * ATTRD.
> + */
> +STATIC void
> +xfs_attrd_item_unlock(
> +	struct xfs_log_item	*lip)
> +{
> +	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
> +
> +	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
> +		xfs_attri_release(attrdp->attrip);
> +		xfs_attrd_item_free(attrdp);
> +	}
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
> +	xfs_attri_release(attrdp->attrip);
> +	xfs_attrd_item_free(attrdp);
> +
> +	return (xfs_lsn_t)-1;
> +}
> +
> +STATIC void
> +xfs_attrd_item_committing(
> +	struct xfs_log_item	*lip,
> +	xfs_lsn_t		lsn)
> +{
> +}
> +
> +/*
> + * This is the ops vector shared by all attrd log items.
> + */
> +static const struct xfs_item_ops xfs_attrd_item_ops = {
> +	.iop_size	= xfs_attrd_item_size,
> +	.iop_format	= xfs_attrd_item_format,
> +	.iop_pin	= xfs_attrd_item_pin,
> +	.iop_unpin	= xfs_attrd_item_unpin,
> +	.iop_unlock	= xfs_attrd_item_unlock,
> +	.iop_committed	= xfs_attrd_item_committed,
> +	.iop_push	= xfs_attrd_item_push,
> +	.iop_committing = xfs_attrd_item_committing
> +};
> +
> +/*
> + * Allocate and initialize an attrd item
> + */
> +struct xfs_attrd_log_item *
> +xfs_attrd_init(
> +	struct xfs_mount	*mp,
> +	struct xfs_attri_log_item	*attrip)
> +
> +{
> +	struct xfs_attrd_log_item	*attrdp;
> +	uint			size;
> +
> +	size = (uint)(sizeof(struct xfs_attrd_log_item));
> +	attrdp = kmem_zalloc(size, KM_SLEEP);
> +
> +	xfs_log_item_init(mp, &attrdp->item, XFS_LI_ATTRD,
> +			  &xfs_attrd_item_ops);
> +	attrdp->attrip = attrip;
> +	attrdp->format.alfd_alf_id = attrip->format.alfi_id;
> +
> +	return attrdp;
> +}
> +
> +/*
> + * Process an attr intent item that was recovered from
> + * the log.  We need to delete the attr that it describes.
> + */

^^^ :)

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
> +
> +	ASSERT(!test_bit(XFS_ATTRI_RECOVERED, &attrip->flags));
> +
> +	/*
> +	 * First check the validity of the attr described by the
> +	 * ATTRI.  If any are bad, then assume that all are bad and
> +	 * just toss the ATTRI.
> +	 */
> +	attrp = &attrip->format;
> +	if (
> +	    /*
> +	     * Must have either XFS_ATTR_OP_FLAGS_SET or
> +	     * XFS_ATTR_OP_FLAGS_REMOVE set
> +	     */
> +	    !(attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET ||
> +		attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_REMOVE) ||
> +
> +	    /* Check size of value and name lengths */
> +	    (attrp->alfi_value_len > XATTR_SIZE_MAX ||
> +		attrp->alfi_name_len > XATTR_NAME_MAX) ||
> +
> +	    /*
> +	     * If the XFS_ATTR_OP_FLAGS_SET flag is set,
> +	     * there must also be a name and value
> +	     */
> +	    (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET &&
> +		(attrp->alfi_value_len == 0 || attrp->alfi_name_len == 0)) ||

It's been a while since I've played with any attribute stuff, but is
this always the case or can we not have an empty attribute?

> +
> +	    /*
> +	     * If the XFS_ATTR_OP_FLAGS_REMOVE flag is set,
> +	     * there must also be a name
> +	     */
> +	    (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_REMOVE &&
> +		(attrp->alfi_name_len == 0))
> +	) {

Comments are always nice of course, but interspersed with logic like
this makes the whole thing hard to read. I'd suggest to just generalize
the comment to include whatever things are non-obvious, condense the if
logic and leave the comment above it.

> +		/*
> +		 * This will pull the ATTRI from the AIL and
> +		 * free the memory associated with it.
> +		 */
> +		set_bit(XFS_ATTRI_RECOVERED, &attrip->flags);
> +		xfs_attri_release(attrip);
> +		return -EIO;
> +	}
> +
> +	attrp = &attrip->format;
> +	error = xfs_iget(mp, 0, attrp->alfi_ino, 0, 0, &ip);
> +	if (error)
> +		return error;
> +
> +	error = xfs_attr_args_init(&args, ip, attrip->name,
> +			attrp->alfi_name_len, attrp->alfi_attr_flags);
> +	if (error)
> +		return error;
> +
> +	args.hashval = xfs_da_hashname(args.name, args.namelen);
> +	args.value = attrip->value;
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
> +	set_bit(XFS_ATTRI_RECOVERED, &attrip->flags);
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
> index 0000000..fce7515
> --- /dev/null
> +++ b/fs/xfs/xfs_attr_item.h
> @@ -0,0 +1,103 @@
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
> +/* nvecs must be in multiples of 4 */
> +#define ATTR_NVEC_SIZE(size) (size == sizeof(int32_t) ? sizeof(int32_t) : \
> +				size + sizeof(int32_t) - \
> +				(size % sizeof(int32_t)))
> +

Why? Also, any reason we couldn't use round_up() or some such here?

> +/*
> + * This is the "attr intention" log item.  It is used to log the fact
> + * that some attrs need to be processed.  It is used in conjunction with the
> + * "attr done" log item described below.
> + *
> + * The ATTRI is reference counted so that it is not freed prior to both the
> + * ATTRI and ATTRD being committed and unpinned. This ensures the ATTRI is
> + * inserted into the AIL even in the event of out of order ATTRI/ATTRD
> + * processing. In other words, an ATTRI is born with two references:
> + *
> + *      1.) an ATTRI held reference to track ATTRI AIL insertion
> + *      2.) an ATTRD held reference to track ATTRD commit
> + *
> + * On allocation, both references are the responsibility of the caller. Once
> + * the ATTRI is added to and dirtied in a transaction, ownership of reference
> + * one transfers to the transaction. The reference is dropped once the ATTRI is
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
> + */
> +struct xfs_attri_log_item {
> +	xfs_log_item_t			item;
> +	atomic_t			refcount;
> +	unsigned long			flags;	/* misc flags */
> +	int				name_len;
> +	void				*name;
> +	int				value_len;
> +	void				*value;
> +	struct xfs_attri_log_format	format;
> +};

I think we usually try to use field prefix names in these various
structures (as you've done in other places). I.e., attri_item,
attrd_item, etc. would probably be consistent with similar structures
like the efi/efd log items.

> +
> +/*
> + * This is the "attr done" log item.  It is used to log
> + * the fact that some attrs earlier mentioned in an attri item
> + * have been freed.
> + */
> +struct xfs_attrd_log_item {
> +	struct xfs_log_item		item;
> +	struct xfs_attri_log_item	*attrip;
> +	struct xfs_attrd_log_format	format;
> +};
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
...
> diff --git a/fs/xfs/xfs_trans_attr.c b/fs/xfs/xfs_trans_attr.c
> new file mode 100644
> index 0000000..3679348
> --- /dev/null
> +++ b/fs/xfs/xfs_trans_attr.c
> @@ -0,0 +1,240 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> + * Author: Allison Henderson <allison.henderson@oracle.com>
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_bit.h"
> +#include "xfs_mount.h"
> +#include "xfs_defer.h"
> +#include "xfs_trans.h"
> +#include "xfs_trans_priv.h"
> +#include "xfs_attr_item.h"
> +#include "xfs_alloc.h"
> +#include "xfs_bmap.h"
> +#include "xfs_trace.h"
> +#include "libxfs/xfs_da_format.h"
> +#include "xfs_da_btree.h"
> +#include "xfs_attr.h"
> +#include "xfs_inode.h"
> +#include "xfs_icache.h"
> +#include "xfs_quota.h"
> +
> +/*
> + * This routine is called to allocate an "attr free done"
> + * log item.
> + */
> +struct xfs_attrd_log_item *
> +xfs_trans_get_attrd(struct xfs_trans		*tp,
> +		  struct xfs_attri_log_item	*attrip)
> +{
> +	struct xfs_attrd_log_item			*attrdp;
> +
> +	ASSERT(tp != NULL);
> +
> +	attrdp = xfs_attrd_init(tp->t_mountp, attrip);
> +	ASSERT(attrdp != NULL);
> +
> +	/*
> +	 * Get a log_item_desc to point at the new item.
> +	 */
> +	xfs_trans_add_item(tp, &attrdp->item);
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
> +	struct xfs_buf			*leaf_bp = NULL;
> +
> +	error = xfs_qm_dqattach_locked(args->dp, 0);
> +	if (error)
> +		return error;
> +
> +	switch (op_flags) {
> +	case XFS_ATTR_OP_FLAGS_SET:
> +		args->op_flags |= XFS_DA_OP_ADDNAME;
> +		error = xfs_attr_set_args(args, &leaf_bp, false);
> +		break;
> +	case XFS_ATTR_OP_FLAGS_REMOVE:
> +		ASSERT(XFS_IFORK_Q((args->dp)));
> +		error = xfs_attr_remove_args(args, false);
> +		break;
> +	default:
> +		error = -EFSCORRUPTED;
> +	}
> +
> +	if (error) {
> +		if (leaf_bp)
> +			xfs_trans_brelse(args->trans, leaf_bp);
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
> +	set_bit(XFS_LI_DIRTY, &attrdp->item.li_flags);
> +
> +	attrdp->attrip->name = (void *)args->name;
> +	attrdp->attrip->value = (void *)args->value;
> +	attrdp->attrip->name_len = args->namelen;
> +	attrdp->attrip->value_len = args->valuelen;
> +

What's the reason for updating the attri here? It's already been
committed by the time we get around to the attrd. Is this used again
somewhere?

> +	return error;
> +}
> +
> +static int
> +xfs_attr_diff_items(
> +	void				*priv,
> +	struct list_head		*a,
> +	struct list_head		*b)
> +{
> +	return 0;
> +}
> +
> +/* Get an ATTRI. */
> +STATIC void *
> +xfs_attr_create_intent(
> +	struct xfs_trans		*tp,
> +	unsigned int			count)
> +{
> +	struct xfs_attri_log_item		*attrip;
> +
> +	ASSERT(tp != NULL);
> +	ASSERT(count == 1);
> +
> +	attrip = xfs_attri_init(tp->t_mountp);
> +	ASSERT(attrip != NULL);
> +
> +	/*
> +	 * Get a log_item_desc to point at the new item.
> +	 */
> +	xfs_trans_add_item(tp, &attrip->item);
> +	return attrip;
> +}
> +
> +/* Log an attr to the intent item. */
> +STATIC void
> +xfs_attr_log_item(
> +	struct xfs_trans		*tp,
> +	void				*intent,
> +	struct list_head		*item)
> +{
> +	struct xfs_attri_log_item	*attrip = intent;
> +	struct xfs_attr_item		*attr;
> +	struct xfs_attri_log_format	*attrp;
> +	char				*name_value;
> +
> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
> +	name_value = ((char *)attr) + sizeof(struct xfs_attr_item);
> +
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &attrip->item.li_flags);
> +
> +	attrp = &attrip->format;
> +	attrp->alfi_ino = attr->xattri_ip->i_ino;
> +	attrp->alfi_op_flags = attr->xattri_op_flags;
> +	attrp->alfi_value_len = attr->xattri_value_len;
> +	attrp->alfi_name_len = attr->xattri_name_len;
> +	attrp->alfi_attr_flags = attr->xattri_flags;
> +
> +	attrip->name = name_value;
> +	attrip->value = &name_value[attr->xattri_name_len];
> +	attrip->name_len = attr->xattri_name_len;
> +	attrip->value_len = attr->xattri_value_len;

So once we're at this point, we've constructed an xfs_attr_item to
describe the high level deferred operation, created an intent log item
and we're now logging that xfs_attri_log_item. We fill in the log format
structure based on the xfs_attr_item and point the xfs_attri_log_item
name/value pointers at the xfs_attr_item memory. It's thus important to
note we've established a subtle relationship between these two data
structures because they may have different lifecycles.

> +}
> +
> +/* Get an ATTRD so we can process all the attrs. */
> +STATIC void *
> +xfs_attr_create_done(
> +	struct xfs_trans		*tp,
> +	void				*intent,
> +	unsigned int			count)
> +{
> +	return xfs_trans_get_attrd(tp, intent);
> +}
> +
> +/* Process an attr. */
> +STATIC int
> +xfs_attr_finish_item(
> +	struct xfs_trans		*tp,
> +	struct list_head		*item,
> +	void				*done_item,
> +	void				**state)
> +{
> +	struct xfs_attr_item		*attr;
> +	char				*name_value;
> +	int				error;
> +	int				local;
> +	struct xfs_da_args		args;
> +
> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
> +	name_value = ((char *)attr) + sizeof(struct xfs_attr_item);
> +
> +	error = xfs_attr_args_init(&args, attr->xattri_ip, name_value,
> +				   attr->xattri_name_len, attr->xattri_flags);
> +	if (error)
> +		goto out;
> +
> +	args.hashval = xfs_da_hashname(args.name, args.namelen);
> +	args.value = &name_value[attr->xattri_name_len];
> +	args.valuelen = attr->xattri_value_len;
> +	args.op_flags = XFS_DA_OP_OKNOENT;
> +	args.total = xfs_attr_calc_size(&args, &local);
> +	args.trans = tp;
> +
> +	error = xfs_trans_attr(&args, done_item,
> +			attr->xattri_op_flags);

So now we've committed/rolled our xfs_attri_log_item intent and
created/attached the xfs_attrd_log_item and thus we're free to perform
the operation...

> +out:
> +	kmem_free(attr);

... and here is where we end up freeing the xfs_attr_item created for
the dfops infrastructure that holds our name and value memory.

Hmm.. I think this means our name/value memory accesses are safe because
the xfs_attri_log_item only accesses them in the ->iop_format()
callback, which occurs during transaction commit of the intent and we're
long past that.

That said, the attri/attrd log items themselves outlive the current
transaction commit sequence (i.e. until the attrd is physically
logged/committed and we free both). That means that once we free the
attr above we technically have an attri passing through the log
infrastructure with a couple invalid pointers, they just don't happen to
be used. It might be worth thinking about how we can clean that up,
whether it be clearing those pointers here, or allocating the name/val
memory separately and transferring it to the attri, etc. Whatever we end
up doing, we should probably add a comment somewhere to explain exactly
what's going on as well.

Brian

> +	return error;
> +}
> +
> +/* Abort all pending ATTRs. */
> +STATIC void
> +xfs_attr_abort_intent(
> +	void				*intent)
> +{
> +	xfs_attri_release(intent);
> +}
> +
> +/* Cancel an attr */
> +STATIC void
> +xfs_attr_cancel_item(
> +	struct list_head		*item)
> +{
> +	struct xfs_attr_item	*attr;
> +
> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
> +	kmem_free(attr);
> +}
> +
> +const struct xfs_defer_op_type xfs_attr_defer_type = {
> +	.max_items	= XFS_ATTRI_MAX_FAST_ATTRS,
> +	.diff_items	= xfs_attr_diff_items,
> +	.create_intent	= xfs_attr_create_intent,
> +	.abort_intent	= xfs_attr_abort_intent,
> +	.log_item	= xfs_attr_log_item,
> +	.create_done	= xfs_attr_create_done,
> +	.finish_item	= xfs_attr_finish_item,
> +	.cancel_item	= xfs_attr_cancel_item,
> +};
> +
> -- 
> 2.7.4
> 
