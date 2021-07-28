Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B44C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 19:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72D376103A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 19:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbhG1TYV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 15:24:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230444AbhG1TYV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 15:24:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47D496101E;
        Wed, 28 Jul 2021 19:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627500259;
        bh=IAQs1uGu5PADLRfG/89bw9Mkbb1/QwRdgz00jWMBs5k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ilzbN5vRrbkKGZQVDLl4LSTpr+eGOu7nMZIa9+xrD4Sb5UWnGwFqYZDSQnfQTn7pu
         0aHMlC09xX3Ep+rCmDIUfiDRKk2C2yZob7d9zUcTsBdX9ftOrWvZhAFN6uVLJJnajS
         q8bsREXhpsGiUV2MP5nDqSN5ZGudlPT3bvNAaF5BtzHSixJfKkg0zlq3a+/MK/Cwqd
         f4f8G3D0ouYqrCJAuJ2/i3RU4eP3VymDyA/7SR/yZRO8DwZdMGeBSK1IkA74DFt80L
         67TfRL3rKBQpGPHo5Z9vlvswObpdQqsXeOLbI4hn94hP7nlfdqryywHv8/IgsNvE4q
         Vysx01PfyW62w==
Date:   Wed, 28 Jul 2021 12:24:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 11/16] xfs: Add xfs_attr_set_deferred and
 xfs_attr_remove_deferred
Message-ID: <20210728192418.GE3601443@magnolia>
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-12-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727062053.11129-12-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 11:20:48PM -0700, Allison Henderson wrote:
> From: Allison Collins <allison.henderson@oracle.com>
> 
> These routines set up and queue a new deferred attribute operations.
> These functions are meant to be called by any routine needing to
> initiate a deferred attribute operation as opposed to the existing
> inline operations. New helper function xfs_attr_item_init also added.
> 
> Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 70 +++++++++++++++++++++++++++++++++++++++++++++---
>  fs/xfs/libxfs/xfs_attr.h |  2 ++
>  fs/xfs/xfs_log.c         | 41 ++++++++++++++++++++++++++++
>  fs/xfs/xfs_log.h         |  1 +
>  4 files changed, 111 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index eee219c6..c447c21 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -25,6 +25,8 @@
>  #include "xfs_trans_space.h"
>  #include "xfs_trace.h"
>  #include "xfs_attr_item.h"
> +#include "xfs_attr.h"
> +#include "xfs_log.h"
>  
>  /*
>   * xfs_attr.c
> @@ -779,13 +781,19 @@ xfs_attr_set(
>  		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
>  	}
>  
> +	if (xfs_hasdelattr(mp)) {
> +		error = xfs_attr_use_log_assist(mp);
> +		if (error)
> +			return error;
> +	}
> +
>  	/*
>  	 * Root fork attributes can use reserved data blocks for this
>  	 * operation if necessary
>  	 */
>  	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
>  	if (error)
> -		return error;
> +		goto drop_incompat;
>  
>  	if (args->value || xfs_inode_hasattr(dp)) {
>  		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
> @@ -803,9 +811,10 @@ xfs_attr_set(
>  		if (error != -ENOATTR && error != -EEXIST)
>  			goto out_trans_cancel;
>  
> -		error = xfs_attr_set_args(args);
> +		error = xfs_attr_set_deferred(args);
>  		if (error)
>  			goto out_trans_cancel;
> +
>  		/* shortform attribute has already been committed */
>  		if (!args->trans)
>  			goto out_unlock;
> @@ -814,7 +823,7 @@ xfs_attr_set(
>  		if (error != -EEXIST)
>  			goto out_trans_cancel;
>  
> -		error = xfs_attr_remove_args(args);
> +		error = xfs_attr_remove_deferred(args);
>  		if (error)
>  			goto out_trans_cancel;
>  	}
> @@ -836,6 +845,9 @@ xfs_attr_set(
>  	error = xfs_trans_commit(args->trans);
>  out_unlock:
>  	xfs_iunlock(dp, XFS_ILOCK_EXCL);
> +drop_incompat:
> +	if (xfs_hasdelattr(mp))

Subtle race here: if you turn this into a debug option and someone
changes the value from 1 to 0 while this function is running, we'll fail
to call _drop_incompat here.  You should sample the value at the start
of the function into a local variable and use that throughout.

> +		xlog_drop_incompat_feat(mp->m_log);
>  	return error;
>  
>  out_trans_cancel:
> @@ -844,6 +856,58 @@ xfs_attr_set(
>  	goto out_unlock;
>  }
>  
> +STATIC int
> +xfs_attr_item_init(
> +	struct xfs_da_args	*args,
> +	unsigned int		op_flags,	/* op flag (set or remove) */
> +	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
> +{
> +
> +	struct xfs_attr_item	*new;
> +
> +	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
> +	new->xattri_op_flags = op_flags;
> +	new->xattri_dac.da_args = args;
> +
> +	*attr = new;
> +	return 0;
> +}
> +
> +/* Sets an attribute for an inode as a deferred operation */
> +int
> +xfs_attr_set_deferred(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_attr_item	*new;
> +	int			error = 0;
> +
> +	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
> +	if (error)
> +		return error;
> +
> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> +
> +	return 0;
> +}
> +
> +/* Removes an attribute for an inode as a deferred operation */
> +int
> +xfs_attr_remove_deferred(
> +	struct xfs_da_args	*args)
> +{
> +
> +	struct xfs_attr_item	*new;
> +	int			error;
> +
> +	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
> +	if (error)
> +		return error;
> +
> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> +
> +	return 0;
> +}
> +
>  /*========================================================================
>   * External routines when attribute list is inside the inode
>   *========================================================================*/
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 463b2be..72b0ea5 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -527,5 +527,7 @@ bool xfs_attr_namecheck(const void *name, size_t length);
>  void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>  			      struct xfs_da_args *args);
>  int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
> +int xfs_attr_set_deferred(struct xfs_da_args *args);
> +int xfs_attr_remove_deferred(struct xfs_da_args *args);
>  
>  #endif	/* __XFS_ATTR_H__ */
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 7c593d9..216de6c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3948,3 +3948,44 @@ xlog_drop_incompat_feat(
>  {
>  	up_read(&log->l_incompat_users);
>  }
> +
> +/*
> + * Get permission to use log-assisted atomic exchange of file extents.
> + *
> + * Callers must not be running any transactions or hold any inode locks, and
> + * they must release the permission by calling xlog_drop_incompat_feat
> + * when they're done.
> + */
> +int
> +xfs_attr_use_log_assist(
> +	struct xfs_mount	*mp)
> +{
> +	int			error = 0;
> +
> +	/*
> +	 * Protect ourselves from an idle log clearing the logged xattrs log
> +	 * incompat feature bit.
> +	 */
> +	xlog_use_incompat_feat(mp->m_log);
> +
> +	/*
> +	 * If log-assisted xattrs are already enabled, the caller can use the
> +	 * log assisted swap functions with the log-incompat reference we got.
> +	 */
> +	if (xfs_sb_version_hasdelattr(&mp->m_sb))
> +		return 0;
> +
> +	/* Enable log-assisted xattrs. */
> +	xfs_warn_once(mp,
> +"EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");
> +
> +	error = xfs_add_incompat_log_feature(mp,
> +			XFS_SB_FEAT_INCOMPAT_LOG_DELATTR);
> +	if (error)
> +		goto drop_incompat;

Minor bug here (and yes, it's also in the swapext code that I pointed
you to; apologies for that): We shouldn't print the warning unless the
feature addition actually succeeds.  IOWs, move the xfs_warn_once()
here.

(That said, if the feature add fails then the fs is probably going to
crash soon anyway so it probably doesn't matter...)

--D

> +
> +	return 0;
> +drop_incompat:
> +	xlog_drop_incompat_feat(mp->m_log);
> +	return error;
> +}
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index b274fb9..1e461671 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -144,5 +144,6 @@ xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
>  
>  void xlog_use_incompat_feat(struct xlog *log);
>  void xlog_drop_incompat_feat(struct xlog *log);
> +int xfs_attr_use_log_assist(struct xfs_mount *mp);
>  
>  #endif	/* __XFS_LOG_H__ */
> -- 
> 2.7.4
> 
