Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535B7C4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jul 2021 12:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B1BC60230
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jul 2021 12:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhG3MWJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Jul 2021 08:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbhG3MWI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jul 2021 08:22:08 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CA1C061765
        for <linux-xfs@vger.kernel.org>; Fri, 30 Jul 2021 05:22:03 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso20565138pjb.1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Jul 2021 05:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=wGgLy2rB0YVz+xAIN1Kz37cus9xJQ3iWclJmoMO4BFU=;
        b=agFsIm71Fep4lx98tqta+c1wtbWZZlQoe5GTMLpZN/a/sXkE6JjaAjhCd5lLmFTN3g
         2lxtPDBG49fxPeMGMVamIGrrNW1hm77QW9E7KVfvJQ27LrerFqXJBZhbmTKnCThOA+2i
         JK584CiA+jg0qu+6sJORfaNVbjQLh/weDQMzeubFdnRYRf7N6NebQqPX4M0x+48h2r5P
         Qcyry8Z5kn9HsQIC7rU7PDC1/Du6Og928NJ05EEHq6ZZxZCSx+gjhwaT7P7r2sCTGeaE
         DEpNPHH6idhkLvzkOZJDzo0fXGTHxRTVxtXsdrIoR6opmAx3pOev/7BfvLPu9Ev7J347
         Wovg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=wGgLy2rB0YVz+xAIN1Kz37cus9xJQ3iWclJmoMO4BFU=;
        b=Xz8/QBC/zGm2uTpxsQQNEyZnoNzX3BlQxXpKER1SzUlDXFdVLjAXtBrURWCJ0PgAAD
         2CwLxKZZ+7QdTm6k7+/8OWnbEzlo5Xf4qmG/EG9/I7Y0IK5xj3BEvb8RWRPtD0zsx/0i
         I+E9Cye0gr1V0hYhdzVPU5KZPefK+yE0l3lFdod4kefdjVSWPkbpd8i3SpahhyP+kdvR
         lBaI332361Hx6AbugkpT1HKsHVFQy9tGruPkk7OKIDTLXQP6t/kaAW7gZ6fm0rDK3oR9
         3q/nT7KsWPxkdlepdps+dD0c1Mw9ScxlofT+8rqP7hmLUYs96ZVgyXrykIRLTHJQFO2o
         oBIg==
X-Gm-Message-State: AOAM530nMHhyz5HTKuhyJ1WHzNV9tg/mrE40OkDOrN4TCZJuv7z1GX0E
        5Wd+a/tWPMG30fEwQP1j87bSh6Ral99V5g==
X-Google-Smtp-Source: ABdhPJxhodb/yQTt6RgkAdkhZHodc2MsNESZLTXB4vrIdH9TvvZrW2FbqcgpF1PX10KayVYvHmWFBw==
X-Received: by 2002:a17:902:d501:b029:12c:3386:96ed with SMTP id b1-20020a170902d501b029012c338696edmr2370850plg.39.1627647722360;
        Fri, 30 Jul 2021 05:22:02 -0700 (PDT)
Received: from garuda ([122.171.174.228])
        by smtp.gmail.com with ESMTPSA id r10sm2210386pff.7.2021.07.30.05.22.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 30 Jul 2021 05:22:02 -0700 (PDT)
References: <20210727062053.11129-1-allison.henderson@oracle.com> <20210727062053.11129-10-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 09/16] xfs: Implement attr logging and replay
In-reply-to: <20210727062053.11129-10-allison.henderson@oracle.com>
Date:   Fri, 30 Jul 2021 17:51:57 +0530
Message-ID: <87v94s800q.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 27 Jul 2021 at 11:50, Allison Henderson wrote:
> This patch adds the needed routines to create, log and recover logged
> extended attribute intents.
>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c  |   1 +
>  fs/xfs/libxfs/xfs_defer.h  |   1 +
>  fs/xfs/libxfs/xfs_format.h |  10 +-
>  fs/xfs/xfs_attr_item.c     | 377 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 388 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index eff4a12..e9caff7 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -178,6 +178,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
>  	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
>  	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
>  	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
> +	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
>  };
>  
>  static void
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 0ed9dfa..72a5789 100644
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
> index 3a4da111..93c1263 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -485,7 +485,9 @@ xfs_sb_has_incompat_feature(
>  	return (sbp->sb_features_incompat & feature) != 0;
>  }
>  
> -#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
> +#define XFS_SB_FEAT_INCOMPAT_LOG_DELATTR   (1 << 0)	/* Delayed Attributes */
> +#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
> +	(XFS_SB_FEAT_INCOMPAT_LOG_DELATTR)
>  #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
>  static inline bool
>  xfs_sb_has_incompat_log_feature(
> @@ -590,6 +592,12 @@ static inline bool xfs_sb_version_hasbigtime(struct xfs_sb *sbp)
>  		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_BIGTIME);
>  }
>  
> +static inline bool xfs_sb_version_hasdelattr(struct xfs_sb *sbp)
> +{
> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> +		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_LOG_DELATTR);
> +}
> +
>  /*
>   * Inode btree block counter.  We record the number of inobt and finobt blocks
>   * in the AGI header so that we can skip the finobt walk at mount time when
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index a810c2a..44c44d9 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -275,6 +275,182 @@ xfs_attrd_item_release(
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
> +xfs_trans_attr_finish_update(
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
> +	error = xfs_qm_dqattach_locked(args->dp, 0);
> +	if (error)
> +		return error;
> +
> +	switch (op) {
> +	case XFS_ATTR_OP_FLAGS_SET:
> +		args->op_flags |= XFS_DA_OP_ADDNAME;

One nit: XFS_DA_OP_ADDNAME was already set by xfs_attr_set().

I don't see any other issues apart from the above nit and those pointed out by
Darrick.

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
> +	 * attr intent/done items are null when delayed attributes are disabled
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
> +	if (!xfs_hasdelattr(mp))
> +		return NULL;
> +
> +	attrip = xfs_attri_init(mp, 0);
> +	if (attrip == NULL)
> +		return NULL;
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
> +	 * Corner case that can happen during a recovery.  Because the first
> +	 * iteration of a multi part delay op happens in xfs_attri_item_recover
> +	 * to maintain the order of the log replay items.  But the new
> +	 * transactions do not automatically rejoin during a recovery as they do
> +	 * in a standard delay op, so we need to catch this here and rejoin the
> +	 * leaf to the new transaction
> +	 */
> +	if (attr->xattri_dac.leaf_bp &&
> +	    attr->xattri_dac.leaf_bp->b_transp != tp) {
> +		xfs_trans_bjoin(tp, attr->xattri_dac.leaf_bp);
> +		xfs_trans_bhold(tp, attr->xattri_dac.leaf_bp);
> +	}
> +
> +	/*
> +	 * Always reset trans after EAGAIN cycle
> +	 * since the transaction is new
> +	 */
> +	dac->da_args->trans = tp;
> +
> +	error = xfs_trans_attr_finish_update(dac, done_item, &dac->leaf_bp,
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
> @@ -306,6 +482,30 @@ xfs_attri_item_match(
>  	return ATTRI_ITEM(lip)->attri_format.alfi_id == intent_id;
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
> +	uint					size;
> +
> +	ASSERT(tp != NULL);
> +
> +	size = sizeof(struct xfs_attrd_log_item);
> +	attrdp = kmem_zalloc(size, 0);
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
>  static const struct xfs_item_ops xfs_attrd_item_ops = {
>  	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
>  	.iop_size	= xfs_attrd_item_size,
> @@ -313,6 +513,29 @@ static const struct xfs_item_ops xfs_attrd_item_ops = {
>  	.iop_release    = xfs_attrd_item_release,
>  };
>  
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
>  /* Is this recovered ATTRI ok? */
>  static inline bool
>  xfs_attri_validate(
> @@ -340,13 +563,167 @@ xfs_attri_validate(
>  	return xfs_hasdelattr(mp);
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
> +	if (!xfs_attri_validate(mp, attrip))
> +		return -EFSCORRUPTED;
> +
> +	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
> +	if (error)
> +		return error;
> +
> +	attr = kmem_zalloc(sizeof(struct xfs_attr_item) +
> +			   sizeof(struct xfs_da_args), KM_NOFS);
> +	args = (struct xfs_da_args *)((char *)attr +
> +		   sizeof(struct xfs_attr_item));
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
> +	ret = xfs_trans_attr_finish_update(&attr->xattri_dac, done_item,
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
> +	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list);
> +
> +out_unlock:
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
>  static const struct xfs_item_ops xfs_attri_item_ops = {
>  	.iop_size	= xfs_attri_item_size,
>  	.iop_format	= xfs_attri_item_format,
>  	.iop_unpin	= xfs_attri_item_unpin,
>  	.iop_committed	= xfs_attri_item_committed,
>  	.iop_release    = xfs_attri_item_release,
> +	.iop_recover	= xfs_attri_item_recover,
>  	.iop_match	= xfs_attri_item_match,
> +	.iop_relog	= xfs_attri_item_relog,
>  };


-- 
chandan
