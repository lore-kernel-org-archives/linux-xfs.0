Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 774D6C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 00:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbiERAbI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 20:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiERAbH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 20:31:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332E3BC90
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:31:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC090B81D64
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE4BC385B8;
        Wed, 18 May 2022 00:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652833862;
        bh=zGAnJwjurB0FKePxGspoqQBvxlAVmsXyaD3224cMsHQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NxSWLL2P8QaBaFsImqfLW44u1jmq3RuswbAN/nHw9X1HmsUYQKHUirWcNRiGGogN4
         O4EjKRu5bdSWpGk58UM+P6vtdfp/3iT0XhFGBD+AX0gNsKqme8oZjSyZgR3iLzXl6N
         bdNb0LiQx2m/dXTy/O26YYswRJwrfQLFAGRbzVshXqhvxzL6wcFZAwy733uPnmprnC
         K66rWzSv4b7T2Kcw7fuUNZx4OMtt0HuQaFu5/ujAIeBVgZR7gJ70TCi37pEb6vvC4Y
         lxHrMI4amihKTJUKjGW+lwDqtZ0pF3ZpLG7rry79SYv+RR7uL6hzBZnJRq5rdpffXT
         YqE7DZfIL5K1g==
Date:   Tue, 17 May 2022 17:31:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/18] xfsprogs: Implement attr logging and replay
Message-ID: <YoQ+RkkbPDDj0Get@magnolia>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
 <20220518001227.1779324-9-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518001227.1779324-9-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 17, 2022 at 05:12:17PM -0700, Allison Henderson wrote:
> Source kernel commit: 1d08e11d04d293cb7006d1c8641be1fdd8a8e397
> 
> This patch adds the needed routines to create, log and recover logged
> extended attribute intents.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  libxfs/defer_item.c | 119 ++++++++++++++++++++++++++++++++++++++++++++
>  libxfs/xfs_defer.c  |   1 +
>  libxfs/xfs_defer.h  |   1 +
>  libxfs/xfs_format.h |   9 +++-
>  4 files changed, 129 insertions(+), 1 deletion(-)
> 
> diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
> index 1337fa5fa457..d2d12b50cce4 100644
> --- a/libxfs/defer_item.c
> +++ b/libxfs/defer_item.c
> @@ -120,6 +120,125 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
>  	.cancel_item	= xfs_extent_free_cancel_item,
>  };
>  
> +/*
> + * Performs one step of an attribute update intent and marks the attrd item
> + * dirty..  An attr operation may be a set or a remove.  Note that the
> + * transaction is marked dirty regardless of whether the operation succeeds or
> + * fails to support the ATTRI/ATTRD lifecycle rules.
> + */
> +STATIC int
> +xfs_trans_attr_finish_update(

This ought to have a name indicating that it's an xattr operation, since
defer_item.c contains stubs for what in the kernel are real logged
operations.

--D

> +	struct xfs_delattr_context	*dac,
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
> +	args->trans->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
> +
> +	return error;
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
> +	return NULL;
> +}
> +
> +/* Abort all pending ATTRs. */
> +STATIC void
> +xfs_attr_abort_intent(
> +	struct xfs_log_item		*intent)
> +{
> +}
> +
> +/* Get an ATTRD so we can process all the attrs. */
> +static struct xfs_log_item *
> +xfs_attr_create_done(
> +	struct xfs_trans		*tp,
> +	struct xfs_log_item		*intent,
> +	unsigned int			count)
> +{
> +	return NULL;
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
> +	int				error;
> +	struct xfs_delattr_context	*dac;
> +
> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
> +	dac = &attr->xattri_dac;
> +
> +	/*
> +	 * Always reset trans after EAGAIN cycle
> +	 * since the transaction is new
> +	 */
> +	dac->da_args->trans = tp;
> +
> +	error = xfs_trans_attr_finish_update(dac, &dac->leaf_bp,
> +					     attr->xattri_op_flags);
> +	if (error != -EAGAIN)
> +		kmem_free(attr);
> +
> +	return error;
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
>   * AGFL blocks are accounted differently in the reserve pools and are not
>   * inserted into the busy extent list.
> diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
> index 3a2576c14ee9..259ae39f90b5 100644
> --- a/libxfs/xfs_defer.c
> +++ b/libxfs/xfs_defer.c
> @@ -180,6 +180,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
>  	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
>  	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
>  	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
> +	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
>  };
>  
>  static bool
> diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
> index c3a540345fae..f18494c0d791 100644
> --- a/libxfs/xfs_defer.h
> +++ b/libxfs/xfs_defer.h
> @@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
>  	XFS_DEFER_OPS_TYPE_RMAP,
>  	XFS_DEFER_OPS_TYPE_FREE,
>  	XFS_DEFER_OPS_TYPE_AGFL_FREE,
> +	XFS_DEFER_OPS_TYPE_ATTR,
>  	XFS_DEFER_OPS_TYPE_MAX,
>  };
>  
> diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
> index d665c04e69dd..302b50bc5830 100644
> --- a/libxfs/xfs_format.h
> +++ b/libxfs/xfs_format.h
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
> -- 
> 2.25.1
> 
