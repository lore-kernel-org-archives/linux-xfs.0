Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B2B1C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Jan 2022 02:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2364116AbiAYCLh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 21:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359353AbiAYCAf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 21:00:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9D5C09B04A
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 17:19:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70473B81610
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jan 2022 01:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F972C340E4;
        Tue, 25 Jan 2022 01:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643073557;
        bh=eatGT4YPK4tbPuJKQhu6Umc0EMVfCNGxkq6VkYe4gLg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qY8M9GOhlTgGnpbXRaxOhAvEc7FoFGRFuDmOO0DNz0C3rUMN+nSN+Zowkmde6I1/H
         2ETDyrKaMclDtu03ZsD61HPfWJ/Zcbl5l0okMFPURG4VPifSU8wUZGU1Z0lE78gK31
         2BMd3UMH328+gZvpnze2G/xQrIYklDLlxB4X9kbJRGgBDlUlH9+bJGD+0sbzPgewoN
         CmM7ctIvEOLqj85/W+mN9r7ZoB1iMI95MpOzm0G7D39lasnt9E/uEUOkHH1AQVsu1q
         sRcxiCWmYk+XgQFqaS/4DVYIH/Qb5ol6EP7iC4Gr9+szwDncWoNLMFPRPWTRuVHq7B
         zYhf5XUhr9uMQ==
Date:   Mon, 24 Jan 2022 17:19:16 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v26 05/12] xfs: Implement attr logging and replay
Message-ID: <20220125011916.GL13563@magnolia>
References: <20220124052708.580016-1-allison.henderson@oracle.com>
 <20220124052708.580016-6-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124052708.580016-6-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 23, 2022 at 10:27:01PM -0700, Allison Henderson wrote:
> This patch adds the needed routines to create, log and recover logged
> extended attribute intents.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c  |   1 +
>  fs/xfs/libxfs/xfs_defer.h  |   1 +
>  fs/xfs/libxfs/xfs_format.h |   9 +-
>  fs/xfs/xfs_attr_item.c     | 361 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 371 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 214cad940a22..c618e6a98456 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -186,6 +186,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
>  	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
>  	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
>  	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
> +	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
>  };
>  
>  static bool
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index fcd23e5cf1ee..114a3a4930a3 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
>  	XFS_DEFER_OPS_TYPE_RMAP,
>  	XFS_DEFER_OPS_TYPE_FREE,
>  	XFS_DEFER_OPS_TYPE_AGFL_FREE,
> +	XFS_DEFER_OPS_TYPE_ATTR,
>  	XFS_DEFER_OPS_TYPE_MAX,
>  };
>  
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index d665c04e69dd..302b50bc5830 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -388,7 +388,9 @@ xfs_sb_has_incompat_feature(
>  	return (sbp->sb_features_incompat & feature) != 0;
>  }
>  
> -#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
> +#define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed Attributes */
> +#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
> +	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
>  #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
>  static inline bool
>  xfs_sb_has_incompat_log_feature(
> @@ -413,6 +415,11 @@ xfs_sb_add_incompat_log_features(
>  	sbp->sb_features_log_incompat |= features;
>  }
>  
> +static inline bool xfs_sb_version_haslogxattrs(struct xfs_sb *sbp)
> +{
> +	return xfs_sb_is_v5(sbp) && (sbp->sb_features_log_incompat &
> +		 XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
> +}
>  
>  static inline bool
>  xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index bc22bfdd8a67..3f08be0f107c 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -13,6 +13,7 @@
>  #include "xfs_defer.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans.h"
> +#include "xfs_bmap_btree.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_log.h"
>  #include "xfs_inode.h"
> @@ -29,6 +30,8 @@
>  
>  static const struct xfs_item_ops xfs_attri_item_ops;
>  static const struct xfs_item_ops xfs_attrd_item_ops;
> +static struct xfs_attrd_log_item *xfs_trans_get_attrd(struct xfs_trans *tp,
> +					struct xfs_attri_log_item *attrip);
>  
>  static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
>  {
> @@ -257,6 +260,163 @@ xfs_attrd_item_release(
>  	xfs_attrd_item_free(attrdp);
>  }
>  
> +/*
> + * Performs one step of an attribute update intent and marks the attrd item
> + * dirty..  An attr operation may be a set or a remove.  Note that the
> + * transaction is marked dirty regardless of whether the operation succeeds or
> + * fails to support the ATTRI/ATTRD lifecycle rules.
> + */
> +STATIC int
> +xfs_xattri_finish_update(
> +	struct xfs_delattr_context	*dac,
> +	struct xfs_attrd_log_item	*attrdp,
> +	struct xfs_buf			**leaf_bp,
> +	uint32_t			op_flags)
> +{
> +	struct xfs_da_args		*args = dac->da_args;
> +	unsigned int			op = op_flags &
> +					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
> +	int				error;
> +
> +	switch (op) {
> +	case XFS_ATTR_OP_FLAGS_SET:
> +		error = xfs_attr_set_iter(dac, leaf_bp);
> +		break;
> +	case XFS_ATTR_OP_FLAGS_REMOVE:
> +		ASSERT(XFS_IFORK_Q(args->dp));
> +		error = xfs_attr_remove_iter(dac);
> +		break;
> +	default:
> +		error = -EFSCORRUPTED;
> +		break;
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
> +
> +	/*
> +	 * attr intent/done items are null when logged attributes are disabled
> +	 */
> +	if (attrdp)
> +		set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
> +
> +	return error;
> +}
> +
> +/* Log an attr to the intent item. */
> +STATIC void
> +xfs_attr_log_item(
> +	struct xfs_trans		*tp,
> +	struct xfs_attri_log_item	*attrip,
> +	struct xfs_attr_item		*attr)
> +{
> +	struct xfs_attri_log_format	*attrp;
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
> +	attrp->alfi_ino = attr->xattri_dac.da_args->dp->i_ino;
> +	attrp->alfi_op_flags = attr->xattri_op_flags;
> +	attrp->alfi_value_len = attr->xattri_dac.da_args->valuelen;
> +	attrp->alfi_name_len = attr->xattri_dac.da_args->namelen;
> +	attrp->alfi_attr_flags = attr->xattri_dac.da_args->attr_filter;
> +
> +	attrip->attri_name = (void *)attr->xattri_dac.da_args->name;
> +	attrip->attri_value = attr->xattri_dac.da_args->value;
> +	attrip->attri_name_len = attr->xattri_dac.da_args->namelen;
> +	attrip->attri_value_len = attr->xattri_dac.da_args->valuelen;
> +}
> +
> +/* Get an ATTRI. */
> +static struct xfs_log_item *
> +xfs_attr_create_intent(
> +	struct xfs_trans		*tp,
> +	struct list_head		*items,
> +	unsigned int			count,
> +	bool				sort)
> +{
> +	struct xfs_mount		*mp = tp->t_mountp;
> +	struct xfs_attri_log_item	*attrip;
> +	struct xfs_attr_item		*attr;
> +
> +	ASSERT(count == 1);
> +
> +	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
> +		return NULL;
> +
> +	attrip = xfs_attri_init(mp, 0);
> +	if (attrip == NULL)
> +		return NULL;

No need to check attrip here, you've already guaranteed that it can't be
NULL via GFP_NOFAIL.

> +
> +	xfs_trans_add_item(tp, &attrip->attri_item);
> +	list_for_each_entry(attr, items, xattri_list)
> +		xfs_attr_log_item(tp, attrip, attr);
> +	return &attrip->attri_item;
> +}
> +
> +/* Process an attr. */
> +STATIC int
> +xfs_attr_finish_item(
> +	struct xfs_trans		*tp,
> +	struct xfs_log_item		*done,
> +	struct list_head		*item,
> +	struct xfs_btree_cur		**state)
> +{
> +	struct xfs_attr_item		*attr;
> +	struct xfs_attrd_log_item	*done_item = NULL;
> +	int				error;
> +	struct xfs_delattr_context	*dac;
> +
> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
> +	dac = &attr->xattri_dac;
> +	if (done)
> +		done_item = ATTRD_ITEM(done);
> +
> +	/*
> +	 * Always reset trans after EAGAIN cycle
> +	 * since the transaction is new
> +	 */
> +	dac->da_args->trans = tp;
> +
> +	error = xfs_xattri_finish_update(dac, done_item, &dac->leaf_bp,
> +					     attr->xattri_op_flags);
> +	if (error != -EAGAIN)
> +		kmem_free(attr);
> +
> +	return error;
> +}
> +
> +/* Abort all pending ATTRs. */
> +STATIC void
> +xfs_attr_abort_intent(
> +	struct xfs_log_item		*intent)
> +{
> +	xfs_attri_release(ATTRI_ITEM(intent));
> +}
> +
> +/* Cancel an attr */
> +STATIC void
> +xfs_attr_cancel_item(
> +	struct list_head		*item)
> +{
> +	struct xfs_attr_item		*attr;
> +
> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
> +	kmem_free(attr);
> +}
> +
>  STATIC xfs_lsn_t
>  xfs_attri_item_committed(
>  	struct xfs_log_item		*lip,
> @@ -314,6 +474,161 @@ xfs_attri_validate(
>  	return xfs_verify_ino(mp, attrp->alfi_ino);
>  }
>  
> +/*
> + * Process an attr intent item that was recovered from the log.  We need to
> + * delete the attr that it describes.
> + */
> +STATIC int
> +xfs_attri_item_recover(
> +	struct xfs_log_item		*lip,
> +	struct list_head		*capture_list)
> +{
> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
> +	struct xfs_attr_item		*attr;
> +	struct xfs_mount		*mp = lip->li_mountp;
> +	struct xfs_inode		*ip;
> +	struct xfs_da_args		*args;
> +	struct xfs_trans		*tp;
> +	struct xfs_trans_res		tres;
> +	struct xfs_attri_log_format	*attrp;
> +	int				error, ret = 0;
> +	int				total;
> +	int				local;
> +	struct xfs_attrd_log_item	*done_item = NULL;
> +
> +	/*
> +	 * First check the validity of the attr described by the ATTRI.  If any
> +	 * are bad, then assume that all are bad and just toss the ATTRI.
> +	 */
> +	attrp = &attrip->attri_format;
> +	if (!xfs_attri_validate(mp, attrp) ||
> +	    !xfs_attr_namecheck(attrip->attri_name, attrip->attri_name_len))
> +		return -EFSCORRUPTED;
> +
> +	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
> +	if (error)
> +		return error;
> +
> +	attr = kmem_zalloc(sizeof(struct xfs_attr_item) +
> +			   sizeof(struct xfs_da_args), KM_NOFS);
> +	args = (struct xfs_da_args *)(attr + 1);
> +
> +	attr->xattri_dac.da_args = args;
> +	attr->xattri_op_flags = attrp->alfi_op_flags;
> +
> +	args->dp = ip;
> +	args->geo = mp->m_attr_geo;
> +	args->op_flags = attrp->alfi_op_flags;
> +	args->whichfork = XFS_ATTR_FORK;
> +	args->name = attrip->attri_name;
> +	args->namelen = attrp->alfi_name_len;
> +	args->hashval = xfs_da_hashname(args->name, args->namelen);
> +	args->attr_filter = attrp->alfi_attr_flags;
> +
> +	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
> +		args->value = attrip->attri_value;
> +		args->valuelen = attrp->alfi_value_len;
> +		args->total = xfs_attr_calc_size(args, &local);
> +
> +		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> +				 M_RES(mp)->tr_attrsetrt.tr_logres *
> +					args->total;
> +		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
> +		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> +		total = args->total;
> +	} else {
> +		tres = M_RES(mp)->tr_attrrm;
> +		total = XFS_ATTRRM_SPACE_RES(mp);
> +	}

I kinda wonder if this bit where we make up a xfs_trans reservation and
allocate the transaction should be a common helper somewhere...?

(ok to make that a cleanup at the end of the series.)

With that one attrip null check thing fixed, I think this is ready for
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
> +	if (error)
> +		goto out;
> +
> +	args->trans = tp;
> +	done_item = xfs_trans_get_attrd(tp, attrip);
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
> +
> +	ret = xfs_xattri_finish_update(&attr->xattri_dac, done_item,
> +					   &attr->xattri_dac.leaf_bp,
> +					   attrp->alfi_op_flags);
> +	if (ret == -EAGAIN) {
> +		/* There's more work to do, so add it to this transaction */
> +		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
> +	} else
> +		error = ret;
> +
> +	if (error) {
> +		xfs_trans_cancel(tp);
> +		goto out_unlock;
> +	}
> +
> +	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
> +
> +out_unlock:
> +	if (attr->xattri_dac.leaf_bp)
> +		xfs_buf_relse(attr->xattri_dac.leaf_bp);
> +
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	xfs_irele(ip);
> +out:
> +	if (ret != -EAGAIN)
> +		kmem_free(attr);
> +	return error;
> +}
> +
> +/* Re-log an intent item to push the log tail forward. */
> +static struct xfs_log_item *
> +xfs_attri_item_relog(
> +	struct xfs_log_item		*intent,
> +	struct xfs_trans		*tp)
> +{
> +	struct xfs_attrd_log_item	*attrdp;
> +	struct xfs_attri_log_item	*old_attrip;
> +	struct xfs_attri_log_item	*new_attrip;
> +	struct xfs_attri_log_format	*new_attrp;
> +	struct xfs_attri_log_format	*old_attrp;
> +	int				buffer_size;
> +
> +	old_attrip = ATTRI_ITEM(intent);
> +	old_attrp = &old_attrip->attri_format;
> +	buffer_size = old_attrp->alfi_value_len + old_attrp->alfi_name_len;
> +
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +	attrdp = xfs_trans_get_attrd(tp, old_attrip);
> +	set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
> +
> +	new_attrip = xfs_attri_init(tp->t_mountp, buffer_size);
> +	new_attrp = &new_attrip->attri_format;
> +
> +	new_attrp->alfi_ino = old_attrp->alfi_ino;
> +	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
> +	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
> +	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
> +	new_attrp->alfi_attr_flags = old_attrp->alfi_attr_flags;
> +
> +	new_attrip->attri_name_len = old_attrip->attri_name_len;
> +	new_attrip->attri_name = ((char *)new_attrip) +
> +				 sizeof(struct xfs_attri_log_item);
> +	memcpy(new_attrip->attri_name, old_attrip->attri_name,
> +		new_attrip->attri_name_len);
> +
> +	new_attrip->attri_value_len = old_attrip->attri_value_len;
> +	if (new_attrip->attri_value_len > 0) {
> +		new_attrip->attri_value = new_attrip->attri_name +
> +					  new_attrip->attri_name_len;
> +
> +		memcpy(new_attrip->attri_value, old_attrip->attri_value,
> +		       new_attrip->attri_value_len);
> +	}
> +
> +	xfs_trans_add_item(tp, &new_attrip->attri_item);
> +	set_bit(XFS_LI_DIRTY, &new_attrip->attri_item.li_flags);
> +
> +	return &new_attrip->attri_item;
> +}
> +
>  STATIC int
>  xlog_recover_attri_commit_pass2(
>  	struct xlog                     *log,
> @@ -386,6 +701,50 @@ xlog_recover_attri_commit_pass2(
>  	return error;
>  }
>  
> +/*
> + * This routine is called to allocate an "attr free done" log item.
> + */
> +static struct xfs_attrd_log_item *
> +xfs_trans_get_attrd(struct xfs_trans		*tp,
> +		  struct xfs_attri_log_item	*attrip)
> +{
> +	struct xfs_attrd_log_item		*attrdp;
> +
> +	ASSERT(tp != NULL);
> +
> +	attrdp = kmem_cache_alloc(xfs_attrd_cache, GFP_NOFS | __GFP_NOFAIL);
> +
> +	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
> +			  &xfs_attrd_item_ops);
> +	attrdp->attrd_attrip = attrip;
> +	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
> +
> +	xfs_trans_add_item(tp, &attrdp->attrd_item);
> +	return attrdp;
> +}
> +
> +/* Get an ATTRD so we can process all the attrs. */
> +static struct xfs_log_item *
> +xfs_attr_create_done(
> +	struct xfs_trans		*tp,
> +	struct xfs_log_item		*intent,
> +	unsigned int			count)
> +{
> +	if (!intent)
> +		return NULL;
> +
> +	return &xfs_trans_get_attrd(tp, ATTRI_ITEM(intent))->attrd_item;
> +}
> +
> +const struct xfs_defer_op_type xfs_attr_defer_type = {
> +	.max_items	= 1,
> +	.create_intent	= xfs_attr_create_intent,
> +	.abort_intent	= xfs_attr_abort_intent,
> +	.create_done	= xfs_attr_create_done,
> +	.finish_item	= xfs_attr_finish_item,
> +	.cancel_item	= xfs_attr_cancel_item,
> +};
> +
>  /*
>   * This routine is called when an ATTRD format structure is found in a committed
>   * transaction in the log. Its purpose is to cancel the corresponding ATTRI if
> @@ -419,7 +778,9 @@ static const struct xfs_item_ops xfs_attri_item_ops = {
>  	.iop_unpin	= xfs_attri_item_unpin,
>  	.iop_committed	= xfs_attri_item_committed,
>  	.iop_release    = xfs_attri_item_release,
> +	.iop_recover	= xfs_attri_item_recover,
>  	.iop_match	= xfs_attri_item_match,
> +	.iop_relog	= xfs_attri_item_relog,
>  };
>  
>  const struct xlog_recover_item_ops xlog_attri_item_ops = {
> -- 
> 2.25.1
> 
