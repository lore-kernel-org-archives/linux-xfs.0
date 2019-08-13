Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41742 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbfHMTRR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Aug 2019 15:17:17 -0400
Date: Tue, 13 Aug 2019 15:17:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 03/18] xfs: Set up infastructure for deferred
 attribute operations
Message-ID: <20190813191714.GF37069@bfoster>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-4-allison.henderson@oracle.com>
 <20190812192849.GB31869@bfoster>
 <5bac82b6-dec4-34f2-4cc9-c79c0679175d@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bac82b6-dec4-34f2-4cc9-c79c0679175d@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Collins <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 13, 2019 at 11:43:51AM -0700, Allison Collins wrote:
> 
> On 8/12/19 12:28 PM, Brian Foster wrote:
> > On Fri, Aug 09, 2019 at 02:37:11PM -0700, Allison Collins wrote:
> > > From: Allison Henderson <allison.henderson@oracle.com>
> > > 
> > > Currently attributes are modified directly across one or more
> > > transactions.  But they are not logged or replayed in the event of
> > > an error. The goal of delayed attributes is to enable logging and
> > > replaying of attribute operations using the existing delayed
> > > operations infrastructure.  This will later enable the attributes
> > > to become part of larger multi part operations that also must first
> > > be recorded to the log.  This is mostly of interest in the scheme of
> > > parent pointers which would need to maintain an attribute containing
> > > parent inode information any time an inode is moved, created, or
> > > removed.  Parent pointers would then be of interest to any feature
> > > that would need to quickly derive an inode path from the mount
> > > point.  Online scrub, nfs lookups and fs grow or shrink operations
> > > are all features that could take advantage of this.
> > > 
> > > This patch adds two new log item types for setting or removing
> > > attributes as deferred operations.  The xfs_attri_log_item logs an
> > > intent to set or remove an attribute.  The corresponding
> > > xfs_attrd_log_item holds a reference to the xfs_attri_log_item and
> > > is freed once the transaction is done.  Both log items use a generic
> > > xfs_attr_log_format structure that contains the attribute name,
> > > value, flags, inode, and an op_flag that indicates if the operations
> > > is a set or remove.
> > > 
> > > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > > ---
...
> > > +/*
> > > + * Process an attr intent item that was recovered from the log.  We need to
> > > + * delete the attr that it describes.
> > > + */
> > > +int
> > > +xfs_attri_recover(
> > > +	struct xfs_mount		*mp,
> > > +	struct xfs_attri_log_item	*attrip)
> > > +{
> > > +	struct xfs_inode		*ip;
> > > +	struct xfs_attrd_log_item	*attrdp;
> > > +	struct xfs_da_args		args;
> > > +	struct xfs_attri_log_format	*attrp;
> > > +	struct xfs_trans_res		tres;
> > > +	int				local;
> > > +	int				error = 0;
> > > +	int				rsvd = 0;
> > > +	struct xfs_name			name;
> > > +
> > > +	ASSERT(!test_bit(XFS_ATTRI_RECOVERED, &attrip->attri_flags));
> > > +
> > > +	/*
> > > +	 * First check the validity of the attr described by the ATTRI.  If any
> > > +	 * are bad, then assume that all are bad and just toss the ATTRI.
> > > +	 */
> > > +	attrp = &attrip->attri_format;
> > > +	if (
> > > +	    !(attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET ||
> > > +		attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_REMOVE) ||
> > > +	      (attrp->alfi_value_len > XATTR_SIZE_MAX) ||
> > > +	      (attrp->alfi_name_len > XATTR_NAME_MAX) ||
> > > +	      (attrp->alfi_name_len == 0)
> > > +	) {
> > 
> > Can we fix the brace usage here?
> Sure, it's got a lot of logic going on here, so I was trying to make it
> easier to look at.  You prefer the parens not to be on separate lines?
> 

Yeah, and just align the checks that go together to be consistent with
the rest of the code:

	if (!(attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET ||
	      attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_REMOVE) ||
	    (attrp->alfi_value_len > XATTR_SIZE_MAX) ||
	    (attrp->alfi_name_len > XATTR_NAME_MAX) ||
	    (attrp->alfi_name_len == 0)) {
		...
	}

Thanks!

Brian

> > 
> > > +		/*
> > > +		 * This will pull the ATTRI from the AIL and free the memory
> > > +		 * associated with it.
> > > +		 */
> > > +		set_bit(XFS_ATTRI_RECOVERED, &attrip->attri_flags);
> > > +		xfs_attri_release(attrip);
> > > +		return -EIO;
> > > +	}
> > > +
> > > +	attrp = &attrip->attri_format;
> > 
> > Just assigned attrp above.
> > 
> > > +	error = xfs_iget(mp, 0, attrp->alfi_ino, 0, 0, &ip);
> > > +	if (error)
> > > +		return error;
> > > +
> > 
> > I don't see any corresponding xfs_irele() in this function.
> You fixed the busy inode bug I was chasing!  Thank you!
> 
> > 
> > > +	name.name = attrip->attri_name;
> > > +	name.len = attrp->alfi_name_len;
> > > +	name.type = attrp->alfi_attr_flags;
> > > +	error = xfs_attr_args_init(&args, ip, &name);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	args.hashval = xfs_da_hashname(args.name, args.namelen);
> > > +	args.value = attrip->attri_value;
> > > +	args.valuelen = attrp->alfi_value_len;
> > > +	args.op_flags = XFS_DA_OP_OKNOENT;
> > > +	args.total = xfs_attr_calc_size(&args, &local);
> > > +
> > > +	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> > > +			M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
> > > +	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
> > > +	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> > > +
> > > +	error = xfs_trans_alloc(mp, &tres, args.total,  0,
> > > +				rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
> > > +	if (error)
> > > +		return error;
> > > +	attrdp = xfs_trans_get_attrd(args.trans, attrip);
> > > +
> > > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > +
> > > +	xfs_trans_ijoin(args.trans, ip, 0);
> > > +	error = xfs_trans_attr(&args, attrdp, attrp->alfi_op_flags);
> > > +	if (error)
> > > +		goto abort_error;
> > > +
> > > +
> > > +	set_bit(XFS_ATTRI_RECOVERED, &attrip->attri_flags);
> > > +	xfs_trans_log_inode(args.trans, ip, XFS_ILOG_CORE | XFS_ILOG_ADATA);
> > > +	error = xfs_trans_commit(args.trans);
> > > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > +	return error;
> > > +
> > > +abort_error:
> > > +	xfs_trans_cancel(args.trans);
> > > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > +	return error;
> > > +}
> > > diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
> > > new file mode 100644
> > > index 0000000..aad32ed
> > > --- /dev/null
> > > +++ b/fs/xfs/xfs_attr_item.h
> > > @@ -0,0 +1,102 @@
> > > +// SPDX-License-Identifier: GPL-2.0+
> > > +/*
> > > + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> > > + * Author: Allison Henderson <allison.henderson@oracle.com>
> > > + */
> > > +#ifndef	__XFS_ATTR_ITEM_H__
> > > +#define	__XFS_ATTR_ITEM_H__
> > > +
> > > +/* kernel only ATTRI/ATTRD definitions */
> > > +
> > > +struct xfs_mount;
> > > +struct kmem_zone;
> > > +
> > > +/*
> > > + * Max number of attrs in fast allocation path.
> > > + */
> > > +#define XFS_ATTRI_MAX_FAST_ATTRS        1
> > > +
> > 
> > I don't think we really need a macro for this given there is no concept
> > of a fast path. I'd just hardcode the 1 in the dfops structure.
> Alrighty, will clean that out too.
> 
> > 
> > > +
> > > +/*
> > > + * Define ATTR flag bits. Manipulated by set/clear/test_bit operators.
> > > + */
> > > +#define	XFS_ATTRI_RECOVERED	1
> > > +
> > > +
> > > +/* iovec length must be 32-bit aligned */
> > > +#define ATTR_NVEC_SIZE(size) (size == sizeof(int32_t) ? sizeof(int32_t) : \
> > > +				size + sizeof(int32_t) - \
> > > +				(size % sizeof(int32_t)))
> > > +
> > > +/*
> > > + * This is the "attr intention" log item.  It is used to log the fact that some
> > > + * need to be processed.  It is used in conjunction with the "attr done" log
> > 
> > Some what need to be processed?
> The attribute operation in general (set or remove).  I will add a little
> extra commentary to help clarify
> 
> > 
> > > + * item described below.
> > > + *
> > > + * The ATTRI is reference counted so that it is not freed prior to both the
> > > + * ATTRI and ATTRD being committed and unpinned. This ensures the ATTRI is
> > > + * inserted into the AIL even in the event of out of order ATTRI/ATTRD
> > > + * processing. In other words, an ATTRI is born with two references:
> > > + *
> > > + *      1.) an ATTRI held reference to track ATTRI AIL insertion
> > > + *      2.) an ATTRD held reference to track ATTRD commit
> > > + *
> > > + * On allocation, both references are the responsibility of the caller. Once the
> > > + * ATTRI is added to and dirtied in a transaction, ownership of reference one
> > > + * transfers to the transaction. The reference is dropped once the ATTRI is
> > > + * inserted to the AIL or in the event of failure along the way (e.g., commit
> > > + * failure, log I/O error, etc.). Note that the caller remains responsible for
> > > + * the ATTRD reference under all circumstances to this point. The caller has no
> > > + * means to detect failure once the transaction is committed, however.
> > > + * Therefore, an ATTRD is required after this point, even in the event of
> > > + * unrelated failure.
> > > + *
> > > + * Once an ATTRD is allocated and dirtied in a transaction, reference two
> > > + * transfers to the transaction. The ATTRD reference is dropped once it reaches
> > > + * the unpin handler. Similar to the ATTRI, the reference also drops in the
> > > + * event of commit failure or log I/O errors. Note that the ATTRD is not
> > > + * inserted in the AIL, so at this point both the ATTI and ATTRD are freed.
> > > + */
> > > +struct xfs_attri_log_item {
> > > +	struct xfs_log_item		attri_item;
> > > +	atomic_t			attri_refcount;
> > > +	unsigned long			attri_flags;	/* misc flags */
> > > +	int				attri_name_len;
> > > +	void				*attri_name;
> > > +	int				attri_value_len;
> > > +	void				*attri_value;
> > > +	struct xfs_attri_log_format	attri_format;
> > > +};
> > > +
> > > +/*
> > > + * This is the "attr done" log item.  It is used to log the fact that some attrs
> > > + * earlier mentioned in an attri item have been freed.
> > > + */
> > > +struct xfs_attrd_log_item {
> > > +	struct xfs_log_item		attrd_item;
> > > +	struct xfs_attri_log_item	*attrd_attrip;
> > > +	struct xfs_attrd_log_format	attrd_format;
> > > +};
> > > +
> > > +/*
> > > + * Max number of attrs in fast allocation path.
> > > + */
> > > +#define	XFS_ATTRD_MAX_FAST_ATTRS	1
> > > +
> > 
> > This define is unused.
> > 
> > > +extern struct kmem_zone	*xfs_attri_zone;
> > > +extern struct kmem_zone	*xfs_attrd_zone;
> > > +
> > 
> > The above zones don't exist either.
> Ok, will remove these then
> 
> > 
> > > +struct xfs_attri_log_item	*xfs_attri_init(struct xfs_mount *mp);
> > > +struct xfs_attrd_log_item	*xfs_attrd_init(struct xfs_mount *mp,
> > > +					struct xfs_attri_log_item *attrip);
> > > +int xfs_attri_copy_format(struct xfs_log_iovec *buf,
> > > +			   struct xfs_attri_log_format *dst_attri_fmt);
> > > +int xfs_attrd_copy_format(struct xfs_log_iovec *buf,
> > > +			   struct xfs_attrd_log_format *dst_attrd_fmt);
> > 
> > Function doesn't exist.
> > 
> > > +void			xfs_attri_item_free(struct xfs_attri_log_item *attrip);
> > > +void			xfs_attri_release(struct xfs_attri_log_item *attrip);
> > > +
> > > +int			xfs_attri_recover(struct xfs_mount *mp,
> > > +					struct xfs_attri_log_item *attrip);
> > > +
> > > +#endif	/* __XFS_ATTR_ITEM_H__ */
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index 00e9f5c..2fbd180 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -2005,6 +2005,10 @@ xlog_print_tic_res(
> > >   	    REG_TYPE_STR(CUD_FORMAT, "cud_format"),
> > >   	    REG_TYPE_STR(BUI_FORMAT, "bui_format"),
> > >   	    REG_TYPE_STR(BUD_FORMAT, "bud_format"),
> > > +	    REG_TYPE_STR(ATTRI_FORMAT, "attri_format"),
> > > +	    REG_TYPE_STR(ATTRD_FORMAT, "attrd_format"),
> > > +	    REG_TYPE_STR(ATTR_NAME, "attr_name"),
> > > +	    REG_TYPE_STR(ATTR_VALUE, "attr_value"),
> > >   	};
> > >   	BUILD_BUG_ON(ARRAY_SIZE(res_type_str) != XLOG_REG_TYPE_MAX + 1);
> > >   #undef REG_TYPE_STR
> > > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > > index 13d1d3e..233efdb3 100644
> > > --- a/fs/xfs/xfs_log_recover.c
> > > +++ b/fs/xfs/xfs_log_recover.c
> > ...
> > > @@ -3422,6 +3425,119 @@ xlog_recover_efd_pass2(
> > >   	return 0;
> > >   }
> > > +STATIC int
> > > +xlog_recover_attri_pass2(
> > > +	struct xlog                     *log,
> > > +	struct xlog_recover_item        *item,
> > > +	xfs_lsn_t                       lsn)
> > > +{
> > > +	int                             error;
> > > +	struct xfs_mount                *mp = log->l_mp;
> > > +	struct xfs_attri_log_item       *attrip;
> > > +	struct xfs_attri_log_format     *attri_formatp;
> > > +	char				*name = NULL;
> > > +	char				*value = NULL;
> > > +	int				region = 0;
> > > +
> > > +	attri_formatp = item->ri_buf[region].i_addr;
> > > +
> > > +	attrip = xfs_attri_init(mp);
> > > +	error = xfs_attri_copy_format(&item->ri_buf[region],
> > > +				      &attrip->attri_format);
> > > +	if (error) {
> > > +		xfs_attri_item_free(attrip);
> > > +		return error;
> > > +	}
> > > +
> > > +	attrip->attri_name_len = attri_formatp->alfi_name_len;
> > > +	attrip->attri_value_len = attri_formatp->alfi_value_len;
> > > +	attrip = kmem_realloc(attrip, sizeof(struct xfs_attri_log_item) +
> > > +			      attrip->attri_name_len + attrip->attri_value_len,
> > > +			      KM_SLEEP);
> > > +
> > > +	if (attrip->attri_name_len > 0) {
> > > +		region++;
> > > +		name = ((char *)attrip) + sizeof(struct xfs_attri_log_item);
> > > +		memcpy(name, item->ri_buf[region].i_addr,
> > > +		       attrip->attri_name_len);
> > > +		attrip->attri_name = name;
> > > +	}
> > 
> > Same comment wrt to a required name.
> > 
> > > +
> > > +	if (attrip->attri_value_len > 0) {
> > > +		region++;
> > > +		value = ((char *)attrip) + sizeof(struct xfs_attri_log_item) +
> > > +			attrip->attri_name_len;
> > > +		memcpy(value, item->ri_buf[region].i_addr,
> > > +			attrip->attri_value_len);
> > > +		attrip->attri_value = value;
> > > +	}
> > > +
> > > +	spin_lock(&log->l_ailp->ail_lock);
> > > +	/*
> > > +	 * The ATTRI has two references. One for the ATTRD and one for ATTRI to
> > > +	 * ensure it makes it into the AIL. Insert the ATTRI into the AIL
> > > +	 * directly and drop the ATTRI reference. Note that
> > > +	 * xfs_trans_ail_update() drops the AIL lock.
> > > +	 */
> > > +	xfs_trans_ail_update(log->l_ailp, &attrip->attri_item, lsn);
> > > +	xfs_attri_release(attrip);
> > > +	return 0;
> > > +}
> > > +
> > > +
> > ...
> > > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > > index 64d7f17..95924dc 100644
> > > --- a/fs/xfs/xfs_trans.h
> > > +++ b/fs/xfs/xfs_trans.h
> > > @@ -26,6 +26,9 @@ struct xfs_cui_log_item;
> > >   struct xfs_cud_log_item;
> > >   struct xfs_bui_log_item;
> > >   struct xfs_bud_log_item;
> > > +struct xfs_attrd_log_item;
> > > +struct xfs_attri_log_item;
> > > +struct xfs_da_args;
> > 
> > What are the xfs_trans.h changes for?
> 
> Oh, they used to be for xfs_trans_attr and friends in v1.  I noticed a
> recent change moved this family of routines into their corresponding
> *_item.c files, so I followed suit.  Will clean these out.
> 
> Thanks for the review!  I know it's a lot!
> Allison
> 
> > 
> > Brian
> > 
> > >   struct xfs_log_item {
> > >   	struct list_head		li_ail;		/* AIL pointers */
> > > @@ -229,7 +232,6 @@ void		xfs_trans_log_buf(struct xfs_trans *, struct xfs_buf *, uint,
> > >   void		xfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
> > >   bool		xfs_trans_buf_is_dirty(struct xfs_buf *bp);
> > >   void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
> > > -
> > >   int		xfs_trans_commit(struct xfs_trans *);
> > >   int		xfs_trans_roll(struct xfs_trans **);
> > >   int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
> > > -- 
> > > 2.7.4
> > > 
