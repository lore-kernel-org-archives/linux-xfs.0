Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C62C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  9 May 2022 16:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239202AbiEIQrS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 May 2022 12:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239113AbiEIQrR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 May 2022 12:47:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382FC1C6C9C
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 09:43:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEEBF612F5
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 16:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D4CC385AC;
        Mon,  9 May 2022 16:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652114602;
        bh=L0bownLwkGuMUm7aEgSzlg0lQU2b5LEzL7rJ8fKZdag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hk9o3mocSu41zEDQZ+SJ+zwePuPiV4muNwV3h8w0C/gYSyjNavI73CCmjU2pCFHer
         NO5MvZubi6O5QlYV5wELbpB7vzgQlRRyRn9UdrKJxEkiXiW4Lsbn6YnRRd1lxI644q
         QGxM5hB8APNpSLHnITWIqQya9iupzMmu5FpjRsYCQpqCC06/TNkifr+lm7JawkDikA
         1QhOnOk4ncJfs2d0bw2A8HMizt1cHGDbAkoMHS9NnSZtADGv3IQmCnrsKxA5kB+3lf
         0+Yqu6HtxuIGgthvufedkZCSGr9jVVW6atoyO6Ky1oI8F0V37w3I0CGtq48hcA89m7
         meAma0Z+7iKLw==
Date:   Mon, 9 May 2022 09:43:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/18] xfs: avoid empty xattr transaction when attrs are
 inline
Message-ID: <20220509164321.GU27195@magnolia>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509004138.762556-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 09, 2022 at 10:41:21AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> generic/642 triggered a reproducable assert failure in
> xlog_cil_commit() that resulted from a xfs_attr_set() committing
> an empty but dirty transaction. When the CIL is empty and this
> occurs, xlog_cil_commit() tries a background push and this triggers
> a "pushing an empty CIL" assert.
> 
> XFS: Assertion failed: !list_empty(&cil->xc_cil), file: fs/xfs/xfs_log_cil.c, line: 1274
> Call Trace:
>  <TASK>
>  xlog_cil_commit+0xa5a/0xad0
>  __xfs_trans_commit+0xb8/0x330
>  xfs_trans_commit+0x10/0x20
>  xfs_attr_set+0x3e2/0x4c0
>  xfs_xattr_set+0x8d/0xe0
>  __vfs_setxattr+0x6b/0x90
>  __vfs_setxattr_noperm+0x76/0x220
>  __vfs_setxattr_locked+0xdf/0x100
>  vfs_setxattr+0x94/0x170
>  setxattr+0x110/0x200
>  path_setxattr+0xbf/0xe0
>  __x64_sys_setxattr+0x2b/0x30
>  do_syscall_64+0x35/0x80
> 
> The problem is related to the breakdown of attribute addition in
> xfs_attr_set_iter() and how it is called from deferred operations.
> When we have a pure leaf xattr insert, we add the xattr to the leaf
> and set the next state to XFS_DAS_FOUND_LBLK and return -EAGAIN.
> This requeues the xattr defered work, rolls the transaction and
> runs xfs_attr_set_iter() again. This then checks the xattr for
> being remote (it's not) and whether a replace op is being done (this
> is a create op) and if neither are true it returns without having
> done anything.
> 
> xfs_xattri_finish_update() then unconditionally sets the transaction
> dirty, and the deferops finishes and returns to __xfs_trans_commit()
> which sees the transaction dirty and tries to commit it by calling
> xlog_cil_commit(). The transaction is empty, and then the assert
> fires if this happens when the CIL is empty.
> 
> This patch addresses the structure of xfs_attr_set_iter() that
> requires re-entry on leaf add even when nothing will be done. This
> gets rid of the trailing empty transaction and so doesn't trigger
> the XFS_TRANS_DIRTY assignment in xfs_xattri_finish_update()
> incorrectly. Addressing that is for a different patch.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

Looks ok to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 39 +++++++++++++++++++--------------------
>  1 file changed, 19 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 48b7e7efbb30..b3d918195160 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -315,6 +315,7 @@ xfs_attr_leaf_addname(
>  {
>  	struct xfs_da_args	*args = attr->xattri_da_args;
>  	struct xfs_inode	*dp = args->dp;
> +	enum xfs_delattr_state	next_state = XFS_DAS_UNINIT;
>  	int			error;
>  
>  	if (xfs_attr_is_leaf(dp)) {
> @@ -335,37 +336,35 @@ xfs_attr_leaf_addname(
>  			 * when we come back, we'll be a node, so we'll fall
>  			 * down into the node handling code below
>  			 */
> -			trace_xfs_attr_set_iter_return(
> -				attr->xattri_dela_state, args->dp);
> -			return -EAGAIN;
> +			error = -EAGAIN;
> +			goto out;
>  		}
> -
> -		if (error)
> -			return error;
> -
> -		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
> +		next_state = XFS_DAS_FOUND_LBLK;
>  	} else {
>  		error = xfs_attr_node_addname_find_attr(attr);
>  		if (error)
>  			return error;
>  
> +		next_state = XFS_DAS_FOUND_NBLK;
>  		error = xfs_attr_node_addname(attr);
> -		if (error)
> -			return error;
> -
> -		/*
> -		 * If addname was successful, and we dont need to alloc or
> -		 * remove anymore blks, we're done.
> -		 */
> -		if (!args->rmtblkno &&
> -		    !(args->op_flags & XFS_DA_OP_RENAME))
> -			return 0;
> +	}
> +	if (error)
> +		return error;
>  
> -		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
> +	/*
> +	 * We need to commit and roll if we need to allocate remote xattr blocks
> +	 * or perform more xattr manipulations. Otherwise there is nothing more
> +	 * to do and we can return success.
> +	 */
> +	if (args->rmtblkno ||
> +	    (args->op_flags & XFS_DA_OP_RENAME)) {
> +		attr->xattri_dela_state = next_state;
> +		error = -EAGAIN;
>  	}
>  
> +out:
>  	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
> -	return -EAGAIN;
> +	return error;
>  }
>  
>  /*
> -- 
> 2.35.1
> 
