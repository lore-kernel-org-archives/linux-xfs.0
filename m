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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57DF6C432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Aug 2021 10:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40FB7610C9
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Aug 2021 10:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236289AbhH3K2n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Aug 2021 06:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbhH3K2n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Aug 2021 06:28:43 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22993C061575
        for <linux-xfs@vger.kernel.org>; Mon, 30 Aug 2021 03:27:50 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id e16so11402913pfc.6
        for <linux-xfs@vger.kernel.org>; Mon, 30 Aug 2021 03:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:message-id
         :date:mime-version;
        bh=mwRwMkcCVVapJrJNqU5uqygr+joX1ex2VWcr9/AX2rs=;
        b=cQPBvz/M3oCfR/BdpBA8PE7RS/pCMHLFOz+JVdASnw/6sXTKMCXXeUxm6jxvWkPVYd
         sLDc8gjeLHjk2fT+BS+BedIoNM6THMdZkWJA4iyCzusVJ5/p4NgB6idSGoLyxI3aGGRK
         /uzYzkfE462o3wetFDLwmVD9OtbAIOQKbqu0x9UnRnkYjL3s9SirBG6QA6NoZNo9DYh1
         zOHM63XNBZPACNDUO6HRuOfLEoTq7+jlalvSwBh+afFaV4A2clvyaOl/NS6avRvNePab
         bxHJdG2HtVncj1F3Gie/Drqj7C3DApp8eNGLPGqN1ODlwDMD4rrkcDEHuwJ0BEyww3XV
         uSkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:message-id:date:mime-version;
        bh=mwRwMkcCVVapJrJNqU5uqygr+joX1ex2VWcr9/AX2rs=;
        b=dnhhzQCsOrcCt7jhIn4FVkzLgmKJLA4D5lczUvpQj3AsKearM5n/Dewp5r30lBnggS
         8+dOQ2nuxxWkVzKmKjRwT9DVMBaiBo+RerIdzlMYIGGobtPRVWIcePYf7zbQXdUy2Vox
         LuyXfFFruP4JTH4U+m2kGDdue1fhkmzKgCsMDnNc7ZaIzgdmVmuBwbKVq/3O0Ldp29/i
         kB++SwnApRCcxYD0RNy8Pm621ThVQOT/16wgtFqJ4nr4b+zIY+sN36yq17C7++vtNTHP
         7V5ugnJmL+tUJwq8VP4Y9mlo7WWCDxhQXV6fgQLsyTRLlUj453XwDLEWcgS5l7hy1yGZ
         MEWA==
X-Gm-Message-State: AOAM532hbipxVhNHMypY3R9qnfsTp5kNQ8cpmUs8uhmddhjyHqynyu1r
        Q3MGUIfy30rxhziu+DQhMZOsrypbATY=
X-Google-Smtp-Source: ABdhPJwF9bTo1h8mUgdp8K7Gyr+p33t8/OksXRcdHcE7P62snwQrciI/ykAoamh4/31Xk4mNf8rQQQ==
X-Received: by 2002:a65:6183:: with SMTP id c3mr21032870pgv.73.1630319269376;
        Mon, 30 Aug 2021 03:27:49 -0700 (PDT)
Received: from garuda ([122.171.149.36])
        by smtp.gmail.com with ESMTPSA id f11sm13353667pfc.23.2021.08.30.03.27.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 30 Aug 2021 03:27:49 -0700 (PDT)
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210824224434.968720-7-allison.henderson@oracle.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v24 06/11] xfs: Add xfs_attr_set_deferred and
 xfs_attr_remove_deferred
In-reply-to: <20210824224434.968720-7-allison.henderson@oracle.com>
Message-ID: <878s0j9qhp.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 30 Aug 2021 15:57:46 +0530
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 25 Aug 2021 at 04:14, Allison Henderson wrote:
> From: Allison Collins <allison.henderson@oracle.com>
>
> These routines set up and queue a new deferred attribute operations.
> These functions are meant to be called by any routine needing to
> initiate a deferred attribute operation as opposed to the existing
> inline operations. New helper function xfs_attr_item_init also added.
>
> Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 71 ++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_attr.h |  2 ++
>  fs/xfs/xfs_log.c         | 41 +++++++++++++++++++++++
>  fs/xfs/xfs_log.h         |  1 +
>  4 files changed, 112 insertions(+), 3 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index fce67c717be2..6877683e2e35 100644
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
> @@ -726,6 +728,7 @@ xfs_attr_set(
>  	int			error, local;
>  	int			rmt_blks = 0;
>  	unsigned int		total;
> +	int			delayed = xfs_has_larp(mp);
>  
>  	if (xfs_is_shutdown(dp->i_mount))
>  		return -EIO;
> @@ -782,13 +785,19 @@ xfs_attr_set(
>  		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
>  	}
>  
> +	if (delayed) {
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
> @@ -806,9 +815,10 @@ xfs_attr_set(
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
> @@ -816,7 +826,7 @@ xfs_attr_set(
>  		if (error != -EEXIST)
>  			goto out_trans_cancel;
>  
> -		error = xfs_attr_remove_args(args);
> +		error = xfs_attr_remove_deferred(args);
>  		if (error)
>  			goto out_trans_cancel;
>  	}
> @@ -838,6 +848,9 @@ xfs_attr_set(
>  	error = xfs_trans_commit(args->trans);
>  out_unlock:
>  	xfs_iunlock(dp, XFS_ILOCK_EXCL);
> +drop_incompat:
> +	if (delayed)
> +		xlog_drop_incompat_feat(mp->m_log);
>  	return error;
>  
>  out_trans_cancel:
> @@ -846,6 +859,58 @@ xfs_attr_set(
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
> index aa33cdcf26b8..0f326c28ab7c 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -526,5 +526,7 @@ bool xfs_attr_namecheck(const void *name, size_t length);
>  void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>  			      struct xfs_da_args *args);
>  int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
> +int xfs_attr_set_deferred(struct xfs_da_args *args);
> +int xfs_attr_remove_deferred(struct xfs_da_args *args);
>  
>  #endif	/* __XFS_ATTR_H__ */
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 4402c5d09269..0d0afa1aae59 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3993,3 +3993,44 @@ xlog_drop_incompat_feat(
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
> +	if (sb_version_haslogxattrs(&mp->m_sb))
> +		return 0;
> +
> +	/* Enable log-assisted xattrs. */
> +	error = xfs_add_incompat_log_feature(mp,
> +			XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
> +	if (error)
> +		goto drop_incompat;
> +
> +	xfs_warn_once(mp,
> +"EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");
> +
> +	return 0;
> +drop_incompat:
> +	xlog_drop_incompat_feat(mp->m_log);
> +	return error;
> +}
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index dc1b77b92fc1..4504ab60ac85 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -144,5 +144,6 @@ bool	  xlog_force_shutdown(struct xlog *log, int shutdown_flags);
>  
>  void xlog_use_incompat_feat(struct xlog *log);
>  void xlog_drop_incompat_feat(struct xlog *log);
> +int xfs_attr_use_log_assist(struct xfs_mount *mp);
>  
>  #endif	/* __XFS_LOG_H__ */


-- 
chandan
