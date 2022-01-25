Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B07EBC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Jan 2022 02:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S3417779AbiAYCLZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 21:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3416018AbiAYByD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 20:54:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465CFC047CE5
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 17:10:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F4A7B8160E
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jan 2022 01:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531C0C340E4;
        Tue, 25 Jan 2022 01:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643073024;
        bh=DImuVQBg0I2+GV/nnUEO2g4pJ+UBTNDbH2A1OBUc8hU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l1CbecfFx1p+Q8z8yLpmYCgXLxaek8FDhECXPutV4/77HtrgOXS8B2hFFEcxYr4/R
         ycu58opa/CcF+EtHoQy/xF2okE4sSG4v3YzWNeSV0VH4iqQ5tCG+j1vfRhmUue8AfC
         4G6GCjw0N8ErxrJpobPVJSReLbCft6Mmg4nkfu1yLRIvKOHgwf+SgS+i4jRMbDivUy
         w1mMM0A82cb5y4x9YCgFmfpObIBriSHHgpRdmzUP3s/YRPxUc78cCu3+X6T+U2C+vS
         Hz9EvUZUQo7H+4m+zzi01MkBfQY15IfbD2jbo2Uom/byCcjt30ZwSxcTyr6FDwAXPu
         0mKvRHRE1yF8A==
Date:   Mon, 24 Jan 2022 17:10:23 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v26 04/12] xfs: Set up infrastructure for log attribute
 replay
Message-ID: <20220125011023.GK13563@magnolia>
References: <20220124052708.580016-1-allison.henderson@oracle.com>
 <20220124052708.580016-5-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124052708.580016-5-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 23, 2022 at 10:27:00PM -0700, Allison Henderson wrote:
> Currently attributes are modified directly across one or more
> transactions. But they are not logged or replayed in the event of an
> error. The goal of log attr replay is to enable logging and replaying
> of attribute operations using the existing delayed operations
> infrastructure.  This will later enable the attributes to become part of
> larger multi part operations that also must first be recorded to the
> log.  This is mostly of interest in the scheme of parent pointers which
> would need to maintain an attribute containing parent inode information
> any time an inode is moved, created, or removed.  Parent pointers would
> then be of interest to any feature that would need to quickly derive an
> inode path from the mount point. Online scrub, nfs lookups and fs grow
> or shrink operations are all features that could take advantage of this.
> 
> This patch adds two new log item types for setting or removing
> attributes as deferred operations.  The xfs_attri_log_item will log an
> intent to set or remove an attribute.  The corresponding
> xfs_attrd_log_item holds a reference to the xfs_attri_log_item and is
> freed once the transaction is done.  Both log items use a generic
> xfs_attr_log_format structure that contains the attribute name, value,
> flags, inode, and an op_flag that indicates if the operations is a set
> or remove.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/Makefile                 |   1 +
>  fs/xfs/libxfs/xfs_attr.c        |  42 ++-
>  fs/xfs/libxfs/xfs_attr.h        |  38 +++
>  fs/xfs/libxfs/xfs_defer.c       |  10 +-
>  fs/xfs/libxfs/xfs_defer.h       |   2 +
>  fs/xfs/libxfs/xfs_log_format.h  |  44 +++-
>  fs/xfs/libxfs/xfs_log_recover.h |   2 +
>  fs/xfs/scrub/common.c           |   2 +
>  fs/xfs/xfs_attr_item.c          | 440 ++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_attr_item.h          |  46 ++++
>  fs/xfs/xfs_attr_list.c          |   1 +
>  fs/xfs/xfs_ioctl32.c            |   2 +
>  fs/xfs/xfs_iops.c               |   2 +
>  fs/xfs/xfs_log.c                |   4 +
>  fs/xfs/xfs_log.h                |  11 +
>  fs/xfs/xfs_log_recover.c        |   2 +
>  fs/xfs/xfs_ondisk.h             |   2 +
>  17 files changed, 645 insertions(+), 6 deletions(-)
> 

<snip past the boilerplate that looks ok>

> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> new file mode 100644
> index 000000000000..bc22bfdd8a67
> --- /dev/null
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -0,0 +1,440 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2021 Oracle.  All Rights Reserved.
> + * Author: Allison Collins <allison.henderson@oracle.com>

Please update the copyright year to 2022.  Even though I feel like
it's 2062. ;)

> + */
> +
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_shared.h"
> +#include "xfs_mount.h"
> +#include "xfs_defer.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans.h"
> +#include "xfs_trans_priv.h"
> +#include "xfs_log.h"
> +#include "xfs_inode.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
> +#include "xfs_attr.h"
> +#include "xfs_attr_item.h"
> +#include "xfs_trace.h"
> +#include "xfs_inode.h"
> +#include "xfs_trans_space.h"
> +#include "xfs_error.h"
> +#include "xfs_log_priv.h"
> +#include "xfs_log_recover.h"
> +
> +static const struct xfs_item_ops xfs_attri_item_ops;
> +static const struct xfs_item_ops xfs_attrd_item_ops;
> +
> +static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
> +{
> +	return container_of(lip, struct xfs_attri_log_item, attri_item);
> +}
> +
> +STATIC void
> +xfs_attri_item_free(
> +	struct xfs_attri_log_item	*attrip)
> +{
> +	kmem_free(attrip->attri_item.li_lv_shadow);
> +	kmem_free(attrip);
> +}
> +
> +/*
> + * Freeing the attrip requires that we remove it from the AIL if it has already
> + * been placed there. However, the ATTRI may not yet have been placed in the
> + * AIL when called by xfs_attri_release() from ATTRD processing due to the
> + * ordering of committed vs unpin operations in bulk insert operations. Hence
> + * the reference count to ensure only the last caller frees the ATTRI.
> + */
> +STATIC void
> +xfs_attri_release(
> +	struct xfs_attri_log_item	*attrip)
> +{
> +	ASSERT(atomic_read(&attrip->attri_refcount) > 0);
> +	if (atomic_dec_and_test(&attrip->attri_refcount)) {
> +		xfs_trans_ail_delete(&attrip->attri_item,
> +				     SHUTDOWN_LOG_IO_ERROR);
> +		xfs_attri_item_free(attrip);
> +	}
> +}
> +
> +STATIC void
> +xfs_attri_item_size(
> +	struct xfs_log_item		*lip,
> +	int				*nvecs,
> +	int				*nbytes)
> +{
> +	struct xfs_attri_log_item       *attrip = ATTRI_ITEM(lip);
> +
> +	*nvecs += 2;
> +	*nbytes += sizeof(struct xfs_attri_log_format) +
> +			xlog_calc_iovec_len(attrip->attri_name_len);
> +
> +	if (!attrip->attri_value_len)
> +		return;
> +
> +	*nvecs += 1;
> +	*nbytes += xlog_calc_iovec_len(attrip->attri_value_len);
> +}
> +
> +/*
> + * This is called to fill in the log iovecs for the given attri log
> + * item. We use  1 iovec for the attri_format_item, 1 for the name, and
> + * another for the value if it is present
> + */
> +STATIC void
> +xfs_attri_item_format(
> +	struct xfs_log_item	*lip,
> +	struct xfs_log_vec	*lv)
> +{
> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
> +	struct xfs_log_iovec		*vecp = NULL;

Nit: Lining up the name indentation here.

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
> +
> +	ASSERT(attrip->attri_name_len > 0);
> +	attrip->attri_format.alfi_size++;
> +
> +	if (attrip->attri_value_len > 0)
> +		attrip->attri_format.alfi_size++;
> +
> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
> +			&attrip->attri_format,
> +			sizeof(struct xfs_attri_log_format));
> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
> +			attrip->attri_name,
> +			xlog_calc_iovec_len(attrip->attri_name_len));
> +	if (attrip->attri_value_len > 0)
> +		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
> +				attrip->attri_value,
> +				xlog_calc_iovec_len(attrip->attri_value_len));
> +}

<snip since the omitted code hasn't changed in ages>

> +STATIC int
> +xlog_recover_attri_commit_pass2(
> +	struct xlog                     *log,
> +	struct list_head		*buffer_list,
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
> +	int				buffer_size;
> +
> +	attri_formatp = item->ri_buf[region].i_addr;
> +
> +	/* Validate xfs_attri_log_format */
> +	if (!xfs_attri_validate(mp, attri_formatp)) {
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	buffer_size = attri_formatp->alfi_name_len +
> +		      attri_formatp->alfi_value_len;
> +
> +	/* memory alloc failure will cause replay to abort */
> +	attrip = xfs_attri_init(mp, buffer_size);
> +	if (attrip == NULL)
> +		return -ENOMEM;
> +
> +	error = xfs_attri_copy_format(&item->ri_buf[region],
> +				      &attrip->attri_format);
> +	if (error)
> +		goto out;
> +
> +	attrip->attri_name_len = attri_formatp->alfi_name_len;
> +	attrip->attri_value_len = attri_formatp->alfi_value_len;
> +	region++;
> +	name = ((char *)attrip) + sizeof(struct xfs_attri_log_item);
> +	memcpy(name, item->ri_buf[region].i_addr, attrip->attri_name_len);
> +	attrip->attri_name = name;
> +
> +	if (!xfs_attr_namecheck(name, attrip->attri_name_len)) {
> +		error = -EFSCORRUPTED;

This should XFS_ERROR_REPORT so the sysadmin knows why the mount failed.

> +		goto out;
> +	}
> +
> +	if (attrip->attri_value_len > 0) {
> +		region++;
> +		value = ((char *)attrip) + sizeof(struct xfs_attri_log_item) +
> +				attrip->attri_name_len;
> +		memcpy(value, item->ri_buf[region].i_addr,
> +				attrip->attri_value_len);
> +		attrip->attri_value = value;
> +	}
> +
> +	/*
> +	 * The ATTRI has two references. One for the ATTRD and one for ATTRI to
> +	 * ensure it makes it into the AIL. Insert the ATTRI into the AIL
> +	 * directly and drop the ATTRI reference. Note that
> +	 * xfs_trans_ail_update() drops the AIL lock.
> +	 */
> +	xfs_trans_ail_insert(log->l_ailp, &attrip->attri_item, lsn);
> +	xfs_attri_release(attrip);
> +	return 0;
> +out:
> +	xfs_attri_item_free(attrip);
> +	return error;
> +}
> +
> +/*
> + * This routine is called when an ATTRD format structure is found in a committed
> + * transaction in the log. Its purpose is to cancel the corresponding ATTRI if
> + * it was still in the log. To do this it searches the AIL for the ATTRI with
> + * an id equal to that in the ATTRD format structure. If we find it we drop
> + * the ATTRD reference, which removes the ATTRI from the AIL and frees it.
> + */
> +STATIC int
> +xlog_recover_attrd_commit_pass2(
> +	struct xlog			*log,
> +	struct list_head		*buffer_list,
> +	struct xlog_recover_item	*item,
> +	xfs_lsn_t			lsn)
> +{
> +	struct xfs_attrd_log_format	*attrd_formatp;
> +
> +	attrd_formatp = item->ri_buf[0].i_addr;
> +	if (item->ri_buf[0].i_len != sizeof(struct xfs_attrd_log_format)) {
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	xlog_recover_release_intent(log, XFS_LI_ATTRI,
> +				    attrd_formatp->alfd_alf_id);
> +	return 0;
> +}
> +
> +static const struct xfs_item_ops xfs_attri_item_ops = {
> +	.iop_size	= xfs_attri_item_size,
> +	.iop_format	= xfs_attri_item_format,
> +	.iop_unpin	= xfs_attri_item_unpin,
> +	.iop_committed	= xfs_attri_item_committed,
> +	.iop_release    = xfs_attri_item_release,
> +	.iop_match	= xfs_attri_item_match,
> +};
> +
> +const struct xlog_recover_item_ops xlog_attri_item_ops = {
> +	.item_type	= XFS_LI_ATTRI,
> +	.commit_pass2	= xlog_recover_attri_commit_pass2,
> +};
> +
> +static const struct xfs_item_ops xfs_attrd_item_ops = {
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.iop_size	= xfs_attrd_item_size,
> +	.iop_format	= xfs_attrd_item_format,
> +	.iop_release    = xfs_attrd_item_release,
> +};
> +
> +const struct xlog_recover_item_ops xlog_attrd_item_ops = {
> +	.item_type	= XFS_LI_ATTRD,
> +	.commit_pass2	= xlog_recover_attrd_commit_pass2,
> +};
> diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
> new file mode 100644
> index 000000000000..34b04377a891
> --- /dev/null
> +++ b/fs/xfs/xfs_attr_item.h
> @@ -0,0 +1,46 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later
> + *
> + * Copyright (C) 2021 Oracle.  All Rights Reserved.
> + * Author: Allison Collins <allison.henderson@oracle.com>

Year update here too.

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
> + * This is the "attr intention" log item.  It is used to log the fact that some
> + * extended attribute operations need to be processed.  An operation is
> + * currently either a set or remove.  Set or remove operations are described by
> + * the xfs_attr_item which may be logged to this intent.
> + *
> + * During a normal attr operation, name and value point to the name and value
> + * fields of the calling functions xfs_da_args.  During a recovery, the name

I initially thought 'calling' and 'functions' were a verb and object,
then realized that 'functions' is a possessive.  How about rewording
that slightly:

"...of the caller's xfs_da_args structure."

So that with all those nits cleaned up,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> + * and value buffers are copied from the log, and stored in a trailing buffer
> + * attached to the xfs_attr_item until they are committed.  They are freed when
> + * the xfs_attr_item itself is freed when the work is done.
> + */
> +struct xfs_attri_log_item {
> +	struct xfs_log_item		attri_item;
> +	atomic_t			attri_refcount;
> +	int				attri_name_len;
> +	int				attri_value_len;
> +	void				*attri_name;
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
> +#endif	/* __XFS_ATTR_ITEM_H__ */
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 2d1e5134cebe..90a14e85e76d 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -15,6 +15,7 @@
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
>  #include "xfs_bmap.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_attr_sf.h"
>  #include "xfs_attr_leaf.h"
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 004ed2a251e8..618a46a1d5fb 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -17,6 +17,8 @@
>  #include "xfs_itable.h"
>  #include "xfs_fsops.h"
>  #include "xfs_rtalloc.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_ioctl.h"
>  #include "xfs_ioctl32.h"
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 3447c19e99da..7cf7b4fce4b9 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -13,6 +13,8 @@
>  #include "xfs_inode.h"
>  #include "xfs_acl.h"
>  #include "xfs_quota.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_trans.h"
>  #include "xfs_trace.h"
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 89fec9a18c34..8ba8563114b9 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2157,6 +2157,10 @@ xlog_print_tic_res(
>  	    REG_TYPE_STR(CUD_FORMAT, "cud_format"),
>  	    REG_TYPE_STR(BUI_FORMAT, "bui_format"),
>  	    REG_TYPE_STR(BUD_FORMAT, "bud_format"),
> +	    REG_TYPE_STR(ATTRI_FORMAT, "attri_format"),
> +	    REG_TYPE_STR(ATTRD_FORMAT, "attrd_format"),
> +	    REG_TYPE_STR(ATTR_NAME, "attr name"),
> +	    REG_TYPE_STR(ATTR_VALUE, "attr value"),
>  	};
>  	BUILD_BUG_ON(ARRAY_SIZE(res_type_str) != XLOG_REG_TYPE_MAX + 1);
>  #undef REG_TYPE_STR
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index dc1b77b92fc1..fd945eb66c32 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -21,6 +21,17 @@ struct xfs_log_vec {
>  
>  #define XFS_LOG_VEC_ORDERED	(-1)
>  
> +/*
> + * Calculate the log iovec length for a given user buffer length. Intended to be
> + * used by ->iop_size implementations when sizing buffers of arbitrary
> + * alignments.
> + */
> +static inline int
> +xlog_calc_iovec_len(int len)
> +{
> +	return roundup(len, sizeof(int32_t));
> +}
> +
>  static inline void *
>  xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
>  		uint type)
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 96c997ed2ec8..f1edb315e341 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1800,6 +1800,8 @@ static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
>  	&xlog_cud_item_ops,
>  	&xlog_bui_item_ops,
>  	&xlog_bud_item_ops,
> +	&xlog_attri_item_ops,
> +	&xlog_attrd_item_ops,
>  };
>  
>  static const struct xlog_recover_item_ops *
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 25991923c1a8..758702b9495f 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -132,6 +132,8 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
>  
>  	/*
>  	 * The v5 superblock format extended several v4 header structures with
> -- 
> 2.25.1
> 
