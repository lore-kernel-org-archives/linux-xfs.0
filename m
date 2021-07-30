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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B0B1C4320A
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jul 2021 15:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00850604D7
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jul 2021 15:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239248AbhG3PAm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Jul 2021 11:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239607AbhG3O67 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jul 2021 10:58:59 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8CDC0617A0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Jul 2021 07:58:25 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id a20so11452749plm.0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Jul 2021 07:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=6oBcWHww1ZPqXh32dNUKTkvQZtjTV3rQ1p9iVJF/5Rs=;
        b=dnTysRTTuC3h2OvLl45SgLiZuPg9eAFiYiXGp2hnHRYu7s7KhTAv71BtXbYQH6C7hf
         k21mb+1g4iI5TFC1Cvd8N8YGnYHZ3pTcexJTwL7UOxhAfaXxXhmDwfurB6kHewMXPUxA
         U8cR3UznCFW042rPcHeovPGbbn0kLVbYwGG/OiXOcmfBMdizC/fp3VpvgJzhahX8ZJ/c
         EXjLPgwkIjfHZkbGhxgnDWuARUOb0n4G8pBdf94zvJEcNtE2Jm+3qAYX2kYnuezPpnZb
         rWvt4WOi257fygAOooBMnK+sRRqaUk7LbA2blsWldD7BPSxCgdeCD0fEkiV30Oq3ZM9U
         7SgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=6oBcWHww1ZPqXh32dNUKTkvQZtjTV3rQ1p9iVJF/5Rs=;
        b=UpvVKFiN3jpE+duo9mEhp9Y4s0bsaR+AMDORx7toGSVqnUV+lkX6ruHHMOwbog05EB
         QN5LUpH/3VwBbrFU6cN9ccLy9A7wyRGuAR8eHVRbt7N5RboTMs9uHoLPhHULOOV9sVRl
         loK7BxjhLpvmK12anrrkXnVDkMtnBs5wNL7YCJeVa9yUdfsiGb7xrV0R4I0AxsVWX9lX
         JEq2cxZh7mQeczyb2+Uy3PJL4EWwMejm2rlWNVHa/aZXDEtM+Wa3BSSBQ20VB0pvwbEq
         8Q6cMRSLc1U5sF7xZb1fIs3UfcJ2+OsxL+JuI6ec6tgtbB9A4F40g1UQWLAj+WCrD69v
         3a3A==
X-Gm-Message-State: AOAM5317d6jSqDbKN8XlCgsRbB9cKVsyeZCIQzWTwkyDa2bWeLMkqjUY
        eHsI2jNVAVJqC9QpAFE4ICDu7SCX255SGQ==
X-Google-Smtp-Source: ABdhPJyMtm87ikWyWIvNVKah5O8dsEyUAyNI9cuumi8+NpQge3yHPSc6v/GyDvFZoapE+8W/pkL58Q==
X-Received: by 2002:a63:d458:: with SMTP id i24mr2042640pgj.289.1627657104489;
        Fri, 30 Jul 2021 07:58:24 -0700 (PDT)
Received: from garuda ([122.171.174.228])
        by smtp.gmail.com with ESMTPSA id w21sm2811748pfq.40.2021.07.30.07.58.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 30 Jul 2021 07:58:24 -0700 (PDT)
References: <20210727062053.11129-1-allison.henderson@oracle.com> <20210727062053.11129-12-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 11/16] xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
In-reply-to: <20210727062053.11129-12-allison.henderson@oracle.com>
Date:   Fri, 30 Jul 2021 20:28:21 +0530
Message-ID: <87sfzv97ci.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 27 Jul 2021 at 11:50, Allison Henderson wrote:
> From: Allison Collins <allison.henderson@oracle.com>
>
> These routines set up and queue a new deferred attribute operations.
> These functions are meant to be called by any routine needing to
> initiate a deferred attribute operation as opposed to the existing
> inline operations. New helper function xfs_attr_item_init also added.
>
> Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.

Apart from the issues pointed out by Darrick, the remaining changes seem to be
fine.

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


--
chandan
