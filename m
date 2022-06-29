Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D46CBC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 17:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiF2Rf4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 13:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbiF2Rfs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 13:35:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CADF3150C
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 10:35:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB13661E4F
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 17:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0792CC34114;
        Wed, 29 Jun 2022 17:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656524146;
        bh=ziL+9LpzM/V+T+iAEE1EUu3EpGwybBJTqcySo3eEa4Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ns8kjslAoLpAkhl42tMv+lUvNAwyH5+BX9Ny314fTd3es/wAMVC2z6jGOhLhNl+6F
         3FpzR2ebxBknNAaCVwpCbgLICIcy/s8N1W+jlPCvHb5B1O5Fdj99KpYdqSTavYgoIi
         HN41ZUOm72bqhBf38nwmj6p2+tdJ2xXhtdMNQyVEsZwZrnDrfQPGvpMCZgiJtL03OS
         iOJjnbPd2e8vYgCC01KpaYiroSDhNZaj1cLNkMR5gvnS8dtl1+DitpOks4G6MyfE/t
         Goxk5hS40qlg9Wh8jx+mtY1okWBC8AssuEVZlpaGwYIbZJZ/MnA/GcRAq3/vRBigsk
         eezk1dvcBEmFg==
Date:   Wed, 29 Jun 2022 10:35:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 12/17] xfs: remove parent pointers in unlink
Message-ID: <YryNcV4uiLNHPzyp@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-13-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611094200.129502-13-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 02:41:55AM -0700, Allison Henderson wrote:
> This patch removes the parent pointer attribute during unlink
> 
> [bfoster: rebase, use VFS inode generation]
> [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t
>            implemented xfs_attr_remove_parent]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c |  2 +-
>  fs/xfs/libxfs/xfs_attr.h |  1 +
>  fs/xfs/xfs_inode.c       | 63 +++++++++++++++++++++++++++++++---------
>  3 files changed, 51 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index f814a9177237..b86188b63897 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -966,7 +966,7 @@ xfs_attr_defer_replace(
>  }
>  
>  /* Removes an attribute for an inode as a deferred operation */
> -static int
> +int
>  xfs_attr_defer_remove(
>  	struct xfs_da_args	*args)
>  {
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 576062e37d11..386dfc8d6053 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -560,6 +560,7 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
>  int xfs_attr_get_ilocked(struct xfs_da_args *args);
>  int xfs_attr_get(struct xfs_da_args *args);
>  int xfs_attr_defer_add(struct xfs_da_args *args);
> +int xfs_attr_defer_remove(struct xfs_da_args *args);
>  int xfs_attr_set(struct xfs_da_args *args);
>  int xfs_attr_set_iter(struct xfs_attr_intent *attr);
>  int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 41c58df8e568..160f57df6d58 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2828,16 +2828,27 @@ xfs_iunpin_wait(
>   */
>  int
>  xfs_remove(
> -	xfs_inode_t             *dp,
> -	struct xfs_name		*name,
> -	xfs_inode_t		*ip)
> -{
> -	xfs_mount_t		*mp = dp->i_mount;
> -	xfs_trans_t             *tp = NULL;
> -	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
> -	int			dontcare;
> -	int                     error = 0;
> -	uint			resblks;
> +	xfs_inode_t             	*dp,

Please convert these to 'struct xfs_inode	*dp' and fix the
whitespace between the type name and the variable.

> +	struct xfs_name			*name,
> +	xfs_inode_t			*ip)
> +{
> +	xfs_mount_t			*mp = dp->i_mount;
> +	xfs_trans_t             	*tp = NULL;
> +	int				is_dir = S_ISDIR(VFS_I(ip)->i_mode);
> +	int				dontcare;
> +	int                     	error = 0;
> +	uint				resblks;
> +	xfs_dir2_dataptr_t		dir_offset;
> +	struct xfs_parent_name_rec	rec;
> +	struct xfs_da_args		args = {
> +		.dp		= ip,
> +		.geo		= mp->m_attr_geo,
> +		.whichfork	= XFS_ATTR_FORK,
> +		.attr_filter	= XFS_ATTR_PARENT,
> +		.op_flags	= XFS_DA_OP_OKNOENT,
> +		.name		= (const uint8_t *)&rec,
> +		.namelen	= sizeof(rec),
> +	};
>  
>  	trace_xfs_remove(dp, name);
>  
> @@ -2852,6 +2863,12 @@ xfs_remove(
>  	if (error)
>  		goto std_return;
>  
> +	if (xfs_has_larp(mp)) {
> +		error = xfs_attr_grab_log_assist(mp);
> +		if (error)
> +			goto std_return;
> +	}
> +
>  	/*
>  	 * We try to get the real space reservation first, allowing for
>  	 * directory btree deletion(s) implying possible bmap insert(s).  If we
> @@ -2865,10 +2882,10 @@ xfs_remove(
>  	 */
>  	resblks = XFS_REMOVE_SPACE_RES(mp);
>  	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip, &resblks,
> -			&tp, &dontcare, XFS_ILOCK_EXCL);
> +			&tp, &dontcare, 0);
>  	if (error) {
>  		ASSERT(error != -ENOSPC);
> -		goto std_return;
> +		goto drop_incompat;
>  	}
>  
>  	/*
> @@ -2922,12 +2939,22 @@ xfs_remove(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
> +	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, &dir_offset);
>  	if (error) {
>  		ASSERT(error != -ENOENT);
>  		goto out_trans_cancel;
>  	}
>  
> +	if (xfs_sb_version_hasparent(&mp->m_sb)) {
> +		xfs_init_parent_name_rec(&rec, dp, dir_offset);
> +		args.hashval = xfs_da_hashname(args.name, args.namelen);
> +		args.trans = tp;
> +
> +		error = xfs_attr_defer_remove(&args);
> +		if (error)
> +			goto out_trans_cancel;

Why not queue the pptr removal inside xfs_dir_removename?  Is there ever
going to be a case where we want to remove a dirent but not update the
parent pointers?

OH.  Right.  Online repair makes this messy, since it builds all the new
directory structures in an O_TMPFILE directory, without bumping the link
counts of any of the children or changing dotdot entries of child dirs.
Then the contents are swapext'd.

So yes, it's perhaps best to keep those separate....?

--D

> +	}
> +
>  	/*
>  	 * If this is a synchronous mount, make sure that the
>  	 * remove transaction goes to disk before returning to
> @@ -2938,15 +2965,23 @@ xfs_remove(
>  
>  	error = xfs_trans_commit(tp);
>  	if (error)
> -		goto std_return;
> +		goto out_unlock;
>  
>  	if (is_dir && xfs_inode_is_filestream(ip))
>  		xfs_filestream_deassociate(ip);
>  
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>  	return 0;
>  
>   out_trans_cancel:
>  	xfs_trans_cancel(tp);
> + out_unlock:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	xfs_iunlock(dp, XFS_ILOCK_EXCL);
> + drop_incompat:
> +	if (xfs_has_larp(mp))
> +		xlog_drop_incompat_feat(mp->m_log);
>   std_return:
>  	return error;
>  }
> -- 
> 2.25.1
> 
