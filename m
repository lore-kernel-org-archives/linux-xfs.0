Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D11C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 05:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 205FB64ED2
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 05:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhBZFAu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 00:00:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:42962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229453AbhBZFAu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Feb 2021 00:00:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA0FE64DE8;
        Fri, 26 Feb 2021 05:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614315608;
        bh=LuYOHd5bHI0tfnjKLReIoBqOkcKiGsaonHQa8cb+NOA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pSOht/g15ZtaIdHRH8SlhDK6prKCz1FcRx32pv9kF2K03hRbEhJZDG08zviQ83+Jj
         zGsAZYSkiJGIVeElIQ8yKCQSls4x68E5tZCsSZa1YUR6aQ2aK4FgMkPVZxnjQwqLFW
         SH94M/C/Ylt0iGvSq3I//FQ6QuNJktFxUQLrMvur8RcC0QrKq2e/keFL/CjXt5UlAx
         f0Ze1S83YMNJRjVHoSJ/CriiRacMu+MPuVA3PNSI0bfHg+Gyr/XMxluWB2D4lmALjA
         j4iu+ER2AAIBDzklbOuNiPqdSjxuKCLOvLsN/0JNX6S+1h9V6UJhGkc7m9YtVz7gNl
         yFHWSt1FmfYpw==
Date:   Thu, 25 Feb 2021 21:00:09 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 18/22] xfs: Add xfs_attr_set_deferred and
 xfs_attr_remove_deferred
Message-ID: <20210226050009.GY7272@magnolia>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-19-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-19-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:44AM -0700, Allison Henderson wrote:
> From: Allison Collins <allison.henderson@oracle.com>
> 
> These routines to set up and start a new deferred attribute operations.

"These routine set up and queue a new deferred attribute operation..."?

> These functions are meant to be called by any routine needing to
> initiate a deferred attribute operation as opposed to the existing
> inline operations. New helper function xfs_attr_item_init also added.
> 
> Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Other than that it seems fine to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_attr.h |  2 ++
>  2 files changed, 58 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 666cc69..cec861e 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -25,6 +25,7 @@
>  #include "xfs_trans_space.h"
>  #include "xfs_trace.h"
>  #include "xfs_attr_item.h"
> +#include "xfs_attr.h"
>  
>  /*
>   * xfs_attr.c
> @@ -838,9 +839,10 @@ xfs_attr_set(
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
> @@ -849,7 +851,7 @@ xfs_attr_set(
>  		if (error != -EEXIST)
>  			goto out_trans_cancel;
>  
> -		error = xfs_attr_remove_args(args);
> +		error = xfs_attr_remove_deferred(args);
>  		if (error)
>  			goto out_trans_cancel;
>  	}
> @@ -879,6 +881,58 @@ xfs_attr_set(
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
> index ee79763..4abf02c 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -462,5 +462,7 @@ bool xfs_attr_namecheck(const void *name, size_t length);
>  void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>  			      struct xfs_da_args *args);
>  int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
> +int xfs_attr_set_deferred(struct xfs_da_args *args);
> +int xfs_attr_remove_deferred(struct xfs_da_args *args);
>  
>  #endif	/* __XFS_ATTR_H__ */
> -- 
> 2.7.4
> 
