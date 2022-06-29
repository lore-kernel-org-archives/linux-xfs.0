Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A549DC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 18:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbiF2SCj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 14:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiF2SCZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 14:02:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016642E68D
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 11:02:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9984B8263F
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 18:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D36C34114;
        Wed, 29 Jun 2022 18:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656525741;
        bh=zhin+B5MkECNlFAOgTxy3f+Iep8/qgLPxyaIa2yn9Mc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s8j2Ajao6pts92kj/+MzQREGJsjGivwUDjcMrqWU6YaXhPG9iInty7iVgj7DVlDKo
         l8GSd9UQYc/BkMvfMlFW5sfWMTM7v7X/6ogVXDZDyML10uGFpLw7rkkt7c6llbgfYq
         rPL0DvBPSxOCcg0XlQ1MCYjyZzwwOtMY5LEjNDJknRH/3/Uy78Z9OkVJqq/7Em2UDe
         WCVhFeUEb48zq7omI69tVv4mgzs2OHRoob2A3Kv6VwOSBOeIkhHDKuzyBJeDnD3szg
         N9mpQEIKXZoUufX3eT1Hzk3+eQAlG3Ea0TVfa0WAhyo+aVH6Ev12A2lFSpnRA/+y3K
         e0fkodGZZtthQ==
Date:   Wed, 29 Jun 2022 11:02:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 13/17] xfs: Add parent pointers to rename
Message-ID: <YryTrGwGy3Yb/Q22@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611094200.129502-14-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 02:41:56AM -0700, Allison Henderson wrote:
> This patch removes the old parent pointer attribute during the rename
> operation, and re-adds the updated parent pointer.  In the case of
> xfs_cross_rename, we modify the routine not to roll the transaction just
> yet.  We will do this after the parent pointer is added in the calling
> xfs_rename function.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_inode.c | 137 +++++++++++++++++++++++++++++++++------------
>  1 file changed, 101 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 160f57df6d58..4566613c6a71 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3153,7 +3153,7 @@ xfs_cross_rename(
>  	}
>  	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
> -	return xfs_finish_rename(tp);
> +	return 0;
>  
>  out_trans_abort:
>  	xfs_trans_cancel(tp);
> @@ -3200,26 +3200,52 @@ xfs_rename_alloc_whiteout(
>   */
>  int
>  xfs_rename(
> -	struct user_namespace	*mnt_userns,
> -	struct xfs_inode	*src_dp,
> -	struct xfs_name		*src_name,
> -	struct xfs_inode	*src_ip,
> -	struct xfs_inode	*target_dp,
> -	struct xfs_name		*target_name,
> -	struct xfs_inode	*target_ip,
> -	unsigned int		flags)
> -{
> -	struct xfs_mount	*mp = src_dp->i_mount;
> -	struct xfs_trans	*tp;
> -	struct xfs_inode	*wip = NULL;		/* whiteout inode */
> -	struct xfs_inode	*inodes[__XFS_SORT_INODES];
> -	int			i;
> -	int			num_inodes = __XFS_SORT_INODES;
> -	bool			new_parent = (src_dp != target_dp);
> -	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
> -	int			spaceres;
> -	bool			retried = false;
> -	int			error, nospace_error = 0;
> +	struct user_namespace		*mnt_userns,
> +	struct xfs_inode		*src_dp,
> +	struct xfs_name			*src_name,
> +	struct xfs_inode		*src_ip,
> +	struct xfs_inode		*target_dp,
> +	struct xfs_name			*target_name,
> +	struct xfs_inode		*target_ip,
> +	unsigned int			flags)
> +{
> +	struct xfs_mount		*mp = src_dp->i_mount;
> +	struct xfs_trans		*tp;
> +	struct xfs_inode		*wip = NULL;		/* whiteout inode */
> +	struct xfs_inode		*inodes[__XFS_SORT_INODES];
> +	int				i;
> +	int				num_inodes = __XFS_SORT_INODES;
> +	bool				new_parent = (src_dp != target_dp);
> +	bool				src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
> +	int				spaceres;
> +	bool				retried = false;
> +	int				error, nospace_error = 0;
> +	struct xfs_parent_name_rec	new_rec;
> +	struct xfs_parent_name_rec	old_rec;
> +	xfs_dir2_dataptr_t		new_diroffset;
> +	xfs_dir2_dataptr_t		old_diroffset;
> +	struct xfs_da_args		new_args = {
> +		.dp		= src_ip,
> +		.geo		= mp->m_attr_geo,
> +		.whichfork	= XFS_ATTR_FORK,
> +		.attr_filter	= XFS_ATTR_PARENT,
> +		.op_flags	= XFS_DA_OP_OKNOENT,
> +		.name		= (const uint8_t *)&new_rec,
> +		.namelen	= sizeof(new_rec),
> +		.value		= (void *)target_name->name,
> +		.valuelen	= target_name->len,
> +	};
> +	struct xfs_da_args		old_args = {
> +		.dp		= src_ip,
> +		.geo		= mp->m_attr_geo,
> +		.whichfork	= XFS_ATTR_FORK,
> +		.attr_filter	= XFS_ATTR_PARENT,
> +		.op_flags	= XFS_DA_OP_OKNOENT,
> +		.name		= (const uint8_t *)&old_rec,
> +		.namelen	= sizeof(old_rec),
> +		.value		= NULL,
> +		.valuelen	= 0,
> +	};
>  
>  	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
>  
> @@ -3242,6 +3268,11 @@ xfs_rename(
>  
>  	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
>  				inodes, &num_inodes);
> +	if (xfs_has_larp(mp)) {
> +		error = xfs_attr_grab_log_assist(mp);
> +		if (error)
> +			goto out_release_wip;
> +	}
>  
>  retry:
>  	nospace_error = 0;
> @@ -3254,7 +3285,7 @@ xfs_rename(
>  				&tp);
>  	}
>  	if (error)
> -		goto out_release_wip;
> +		goto drop_incompat;
>  
>  	/*
>  	 * Attach the dquots to the inodes
> @@ -3276,14 +3307,14 @@ xfs_rename(
>  	 * we can rely on either trans_commit or trans_cancel to unlock
>  	 * them.
>  	 */
> -	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, src_dp, 0);
>  	if (new_parent)
> -		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
> +		xfs_trans_ijoin(tp, target_dp, 0);
> +	xfs_trans_ijoin(tp, src_ip, 0);
>  	if (target_ip)
> -		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
> +		xfs_trans_ijoin(tp, target_ip, 0);
>  	if (wip)
> -		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
> +		xfs_trans_ijoin(tp, wip, 0);
>  
>  	/*
>  	 * If we are using project inheritance, we only allow renames
> @@ -3293,15 +3324,16 @@ xfs_rename(
>  	if (unlikely((target_dp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
>  		     target_dp->i_projid != src_ip->i_projid)) {
>  		error = -EXDEV;
> -		goto out_trans_cancel;
> +		goto out_unlock;
>  	}
>  
>  	/* RENAME_EXCHANGE is unique from here on. */
> -	if (flags & RENAME_EXCHANGE)
> -		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
> +	if (flags & RENAME_EXCHANGE) {
> +		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
>  					target_dp, target_name, target_ip,
>  					spaceres);
> -
> +		goto out_pptr;
> +	}
>  	/*
>  	 * Try to reserve quota to handle an expansion of the target directory.
>  	 * We'll allow the rename to continue in reservationless mode if we hit
> @@ -3415,7 +3447,7 @@ xfs_rename(
>  		 * to account for the ".." reference from the new entry.
>  		 */
>  		error = xfs_dir_createname(tp, target_dp, target_name,
> -					   src_ip->i_ino, spaceres, NULL);
> +					   src_ip->i_ino, spaceres, &new_diroffset);
>  		if (error)
>  			goto out_trans_cancel;
>  
> @@ -3436,7 +3468,7 @@ xfs_rename(
>  		 * name at the destination directory, remove it first.
>  		 */
>  		error = xfs_dir_replace(tp, target_dp, target_name,
> -					src_ip->i_ino, spaceres, NULL);
> +					src_ip->i_ino, spaceres, &new_diroffset);
>  		if (error)
>  			goto out_trans_cancel;
>  
> @@ -3470,7 +3502,7 @@ xfs_rename(
>  		 * directory.
>  		 */
>  		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
> -					target_dp->i_ino, spaceres, NULL);
> +					target_dp->i_ino, spaceres, &new_diroffset);
>  		ASSERT(error != -EEXIST);
>  		if (error)
>  			goto out_trans_cancel;
> @@ -3509,26 +3541,59 @@ xfs_rename(
>  	 */
>  	if (wip)
>  		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
> -					spaceres, NULL);
> +					spaceres, &old_diroffset);
>  	else
>  		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
> -					   spaceres, NULL);
> +					   spaceres, &old_diroffset);
>  
>  	if (error)
>  		goto out_trans_cancel;
>  
> +out_pptr:
> +	if (xfs_sb_version_hasparent(&mp->m_sb)) {
> +		new_args.trans	= tp;
> +		xfs_init_parent_name_rec(&new_rec, target_dp, new_diroffset);
> +		new_args.hashval = xfs_da_hashname(new_args.name,
> +						   new_args.namelen);
> +		error =  xfs_attr_defer_add(&new_args);
> +		if (error)
> +			goto out_trans_cancel;
> +
> +		old_args.trans	= tp;
> +		xfs_init_parent_name_rec(&old_rec, src_dp, old_diroffset);
> +		old_args.hashval = xfs_da_hashname(old_args.name,
> +						   old_args.namelen);
> +		error = xfs_attr_defer_remove(&old_args);
> +		if (error)
> +			goto out_trans_cancel;

Isn't this missing a xfs_attr_defer_remove call for target_ip if the
rename causes target_ip to be unlinked from target_dp?

If you had pptr helper functions, it would be easier to validate that
the code sequence is correct if we could see something like:

	if (want to add something) {
		xfs_dir_createname(..., &newoffset);
		xfs_dir_createpptr(..., newoffset);
	} else if (want to remove something) {
		xfs_dir_removename(..., &oldoffset);
		xfs_dir_removepptr(..., oldoffset);
	} else if (replacing something) {
		xfs_dir_replace(..., &oldoffset, &newoffset);
		xfs_dir_replacepptr(..., oldoffset, newoffset);
	}

The point being that the function call that updates the directory should
be right before the function call that schedules the corresponding pptr
xattr update.

--D

> +	}
> +
>  	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
>  	if (new_parent)
>  		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
>  
>  	error = xfs_finish_rename(tp);
> +
> +out_unlock:
>  	if (wip)
>  		xfs_irele(wip);
> +	if (wip)
> +		xfs_iunlock(wip, XFS_ILOCK_EXCL);
> +	if (target_ip)
> +		xfs_iunlock(target_ip, XFS_ILOCK_EXCL);
> +	xfs_iunlock(src_ip, XFS_ILOCK_EXCL);
> +	if (new_parent)
> +		xfs_iunlock(target_dp, XFS_ILOCK_EXCL);
> +	xfs_iunlock(src_dp, XFS_ILOCK_EXCL);
> +
>  	return error;
>  
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
> +drop_incompat:
> +	if (xfs_has_larp(mp))
> +		xlog_drop_incompat_feat(mp->m_log);
>  out_release_wip:
>  	if (wip)
>  		xfs_irele(wip);
> -- 
> 2.25.1
> 
