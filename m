Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45380 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726681AbfHLT2w (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Aug 2019 15:28:52 -0400
Date: Mon, 12 Aug 2019 15:28:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 03/18] xfs: Set up infastructure for deferred
 attribute operations
Message-ID: <20190812192849.GB31869@bfoster>
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

Mostly small stuff, some of which may overlap with Darrick's comments...

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
...
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

Could use a comment on the xattri_list line as well.

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
> @@ -152,5 +174,8 @@ int xfs_attr_remove_args(struct xfs_da_args *args);
>  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>  		  int flags, struct attrlist_cursor_kern *cursor);
>  bool xfs_attr_namecheck(const void *name, size_t length);
> +int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
> +		       struct xfs_name *name);
> +int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>  
>  #endif	/* __XFS_ATTR_H__ */
...
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> new file mode 100644
> index 0000000..2340589
> --- /dev/null
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -0,0 +1,755 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> + * Author: Allison Henderson <allison.henderson@oracle.com>
> + */
> +
...
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

No such thing as a log_item_desc any more. :)

> +	xfs_trans_add_item(tp, &attrdp->attrd_item);
> +	return attrdp;
> +}
> +
> +/*
> + * Delete an attr and log it to the ATTRD. Note that the transaction is marked
> + * dirty regardless of whether the attr delete succeeds or fails to support the
> + * ATTRI/ATTRD lifecycle rules.
> + */

Looks like the comment needs an update. This function doesn't just
handle deletes.

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
> +	struct xfs_attri_log_item	*attrip;
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

Same deal here.

> +	xfs_trans_add_item(tp, &attrip->attri_item);
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
> +	set_bit(XFS_LI_DIRTY, &attrip->attri_item.li_flags);
> +
> +	/*
> +	 * At this point the xfs_attr_item has been constructed, and we've
> +	 * created the log intent. Fill in the attri log item and log format
> +	 * structure with fields from this xfs_attr_item
> +	 */
> +	attrp = &attrip->attri_format;
> +	attrp->alfi_ino = attr->xattri_ip->i_ino;
> +	attrp->alfi_op_flags = attr->xattri_op_flags;
> +	attrp->alfi_value_len = attr->xattri_value_len;
> +	attrp->alfi_name_len = attr->xattri_name_len;
> +	attrp->alfi_attr_flags = attr->xattri_flags;
> +
> +	attrip->attri_name = name_value;
> +	attrip->attri_value = &name_value[attr->xattri_name_len];
> +	attrip->attri_name_len = attr->xattri_name_len;
> +	attrip->attri_value_len = attr->xattri_value_len;
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
> +	struct xfs_name			name;
> +	struct xfs_attrd_log_item	*attrdp;
> +	struct xfs_attri_log_item	*attrip;
> +
> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
> +	name_value = ((char *)attr) + sizeof(struct xfs_attr_item);
> +
> +	name.name = name_value;
> +	name.len = attr->xattri_name_len;
> +	name.type = attr->xattri_flags;
> +	error = xfs_attr_args_init(&args, attr->xattri_ip, &name);
> +	if (error)
> +		goto out;
> +
> +	args.hashval = xfs_da_hashname(args.name, args.namelen);
> +	args.value = &name_value[attr->xattri_name_len];
> +	args.valuelen = attr->xattri_value_len;
> +	args.op_flags = XFS_DA_OP_OKNOENT;
> +	args.total = xfs_attr_calc_size(&args, &local);

It feels a little strange to calculate this here since it should be part
of the transaction reservation that already occurred. The interface
requires it however, so maybe it's something we can clean up later. For
now, a one liner comment would be useful:

	/* must match existing transaction block res */
	args.total = xfs_attr_calc_size(&args, &local);
	...

> +	args.trans = tp;
> +
> +	error = xfs_trans_attr(&args, done_item,
> +			attr->xattri_op_flags);

This fits on one 80 column line.

> +out:
> +	/*
> +	 * We are about to free the xfs_attr_item, so we need to remove any
> +	 * refrences that are currently pointing at its members
> +	 */

A little more context would help. I.e.:

"The attrip refers to xfs_attr_item memory to log the name and value
with the intent item. This already occurred when the intent was
committed so these fields are no longer accessed. Clear them out of
caution since we're about to free the xfs_attr_item."

> +	attrdp = (struct xfs_attrd_log_item *)done_item;
> +	attrip = attrdp->attrd_attrip;
> +	attrip->attri_name = NULL;
> +	attrip->attri_value = NULL;
> +	attrip->attri_name_len = 0;
> +	attrip->attri_value_len = 0;
> +

Probably no need to clear the length fields either. It kind of confuses
things IMO.

BTW, I know I suggested this and I don't want to churn this patch to
death, but seeing it now along with the above ->total hack makes me
wonder if we could still more elegantly carry things from the high level
xfs_attr_item to the intent log item. It's not immediately clear to me
what the best option is. Perhaps a separate structure to hold things
like the name, value, tx block res, etc..? I'm ultimately fine with this
for now. Just something to think more about for a follow on cleanup I
suppose..

> +	kmem_free(attr);
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
> +static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
> +{
> +	return container_of(lip, struct xfs_attri_log_item, attri_item);
> +}
> +
> +void
> +xfs_attri_item_free(
> +	struct xfs_attri_log_item	*attrip)
> +{
> +	kmem_free(attrip->attri_item.li_lv_shadow);
> +	kmem_free(attrip);
> +}
> +
> +/*
> + * This returns the number of iovecs needed to log the given attri item. We
> + * only need 1 iovec for an attri item.  It just logs the attr_log_format
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
> +	if (attrip->attri_name_len > 0) {
> +		*nvecs += 1;
> +		*nbytes += ATTR_NVEC_SIZE(attrip->attri_name_len);
> +	}

We always need an attr name, right? Perhaps this branch should be
replaced with an assert on ->attri_name_len.

> +
> +	if (attrip->attri_value_len > 0) {
> +		*nvecs += 1;
> +		*nbytes += ATTR_NVEC_SIZE(attrip->attri_value_len);
> +	}
> +}
> +
> +/*
> + * This is called to fill in the vector of log iovecs for the given attri log
> + * item. We use only 1 iovec, and we point that at the attri_log_format
> + * structure embedded in the attri item. It is at this point that we assert
> + * that all of the attr slots in the attri item have been filled.
> + */

Looks like a stale comment. We use up to three iovecs here. I also don't
see any assertion related to attr slots. Irrelevant bit from a different
intent item perhaps?

> +STATIC void
> +xfs_attri_item_format(
> +	struct xfs_log_item	*lip,
> +	struct xfs_log_vec	*lv)
> +{
> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
> +	struct xfs_log_iovec	*vecp = NULL;
> +
> +	attrip->attri_format.alfi_type = XFS_LI_ATTRI;
> +	attrip->attri_format.alfi_size = 1;
> +
> +	/*
> +	 * This size accounting must be done before copying the attrip into the
> +	 * iovec.  If we do it after, the wrong size will be recorded to the log
> +	 * and we trip across assertion checks for bad region sizes later during
> +	 * the log recovery.
> +	 */
> +	if (attrip->attri_name_len > 0)
> +		attrip->attri_format.alfi_size++;

Similar comment as before wrt to a required name.

> +	if (attrip->attri_value_len > 0)
> +		attrip->attri_format.alfi_size++;
> +
> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
> +			&attrip->attri_format,
> +			xfs_attri_item_sizeof(attrip));
> +	if (attrip->attri_name_len > 0)
> +		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
> +				attrip->attri_name,
> +				ATTR_NVEC_SIZE(attrip->attri_name_len));
> +
> +	if (attrip->attri_value_len > 0)
> +		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
> +				attrip->attri_value,
> +				ATTR_NVEC_SIZE(attrip->attri_value_len));
> +}
> +
> +
...
> +
> +/*
> + * This is called to fill in the vector of log iovecs for the
> + * given attrd log item. We use only 1 iovec, and we point that
> + * at the attr_log_format structure embedded in the attrd item.
> + * It is at this point that we assert that all of the attr
> + * slots in the attrd item have been filled.
> + */

Comment can be widened to 80 cols and another reference to an assertion
that doesn't exist.

> +STATIC void
> +xfs_attrd_item_format(
> +	struct xfs_log_item	*lip,
> +	struct xfs_log_vec	*lv)
> +{
> +	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
> +	struct xfs_log_iovec	*vecp = NULL;
> +
> +	attrdp->attrd_format.alfd_type = XFS_LI_ATTRD;
> +	attrdp->attrd_format.alfd_size = 1;
> +
> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRD_FORMAT,
> +			&attrdp->attrd_format, xfs_attrd_item_sizeof(attrdp));
> +}
> +
...
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

Can we fix the brace usage here?

> +		/*
> +		 * This will pull the ATTRI from the AIL and free the memory
> +		 * associated with it.
> +		 */
> +		set_bit(XFS_ATTRI_RECOVERED, &attrip->attri_flags);
> +		xfs_attri_release(attrip);
> +		return -EIO;
> +	}
> +
> +	attrp = &attrip->attri_format;

Just assigned attrp above.

> +	error = xfs_iget(mp, 0, attrp->alfi_ino, 0, 0, &ip);
> +	if (error)
> +		return error;
> +

I don't see any corresponding xfs_irele() in this function.

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

I don't think we really need a macro for this given there is no concept
of a fast path. I'd just hardcode the 1 in the dfops structure.

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

Some what need to be processed?

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
> +
> +/*
> + * Max number of attrs in fast allocation path.
> + */
> +#define	XFS_ATTRD_MAX_FAST_ATTRS	1
> +

This define is unused.

> +extern struct kmem_zone	*xfs_attri_zone;
> +extern struct kmem_zone	*xfs_attrd_zone;
> +

The above zones don't exist either.

> +struct xfs_attri_log_item	*xfs_attri_init(struct xfs_mount *mp);
> +struct xfs_attrd_log_item	*xfs_attrd_init(struct xfs_mount *mp,
> +					struct xfs_attri_log_item *attrip);
> +int xfs_attri_copy_format(struct xfs_log_iovec *buf,
> +			   struct xfs_attri_log_format *dst_attri_fmt);
> +int xfs_attrd_copy_format(struct xfs_log_iovec *buf,
> +			   struct xfs_attrd_log_format *dst_attrd_fmt);

Function doesn't exist.

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
...
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

Same comment wrt to a required name.

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
...
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

What are the xfs_trans.h changes for?

Brian

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
