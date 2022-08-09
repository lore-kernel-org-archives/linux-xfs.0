Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50AC0C3F6B0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 19:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245518AbiHITHY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 15:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348294AbiHITGj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 15:06:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A788527152
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 11:49:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 551F6B81722
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 18:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51F5C433D7;
        Tue,  9 Aug 2022 18:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660070995;
        bh=ZLiuAYICCxFxBNoc9j5Zt1fFqXn1xY2jpiqw54zkrXo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XrrAPs0Me/PoQQSSBaa2WGKoAZE9nXpufxlsupUrJ7xodUzgDQ3eLNN/JySZ4qlUv
         qV5/zM+pVqI/Dh/Qaxc6SBMsti65Pys0N+0Chs/jmEsBYNHOO1cPJh2GpjwoGZYS2b
         pF+uSfQ8CToFr2UNyDVSBC9O5eWKDnIudXL/HzP66g7cKZnH1JHQ4r5ien2HsCfrsi
         FdgOXZczQUWWDd0Zo415Ae+GzJFrBabtloeWD/9C1nfqbActyrIbjL3RsKi3VSBDfe
         KkxumW0O8zTN+NCR1RaQwbHPSiztEL5Nt2wKOXU981J/Rj6oW+T0njODV22+I+PLer
         25duKW83aPvDg==
Date:   Tue, 9 Aug 2022 11:49:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v2 15/18] xfs: Add parent pointers to rename
Message-ID: <YvKsUyj3Ob9lqFYh@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
 <20220804194013.99237-16-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804194013.99237-16-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 04, 2022 at 12:40:10PM -0700, Allison Henderson wrote:
> This patch removes the old parent pointer attribute during the rename
> operation, and re-adds the updated parent pointer.  In the case of
> xfs_cross_rename, we modify the routine not to roll the transaction just
> yet.  We will do this after the parent pointer is added in the calling
> xfs_rename function.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_inode.c | 128 +++++++++++++++++++++++++++++++++------------
>  1 file changed, 94 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 69bb67f2a252..8a81b78b6dd7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2776,7 +2776,7 @@ xfs_cross_rename(
>  	}
>  	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
> -	return xfs_finish_rename(tp);
> +	return 0;
>  
>  out_trans_abort:
>  	xfs_trans_cancel(tp);
> @@ -2834,26 +2834,31 @@ xfs_rename_alloc_whiteout(
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
> +	struct user_namespace		*mnt_userns,
> +	struct xfs_inode		*src_dp,
> +	struct xfs_name			*src_name,
> +	struct xfs_inode		*src_ip,
> +	struct xfs_inode		*target_dp,
> +	struct xfs_name			*target_name,
> +	struct xfs_inode		*target_ip,
> +	unsigned int			flags)
>  {
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
> +	xfs_dir2_dataptr_t		new_diroffset;
> +	xfs_dir2_dataptr_t		old_diroffset;
> +	struct xfs_parent_defer		*old_parent_ptr = NULL;
> +	struct xfs_parent_defer		*new_parent_ptr = NULL;
> +	struct xfs_parent_defer		*target_parent_ptr = NULL;
>  
>  	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
>  
> @@ -2877,6 +2882,15 @@ xfs_rename(
>  
>  	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
>  				inodes, &num_inodes);
> +	if (xfs_has_parent(mp)) {
> +		error = xfs_parent_init(mp, src_ip, NULL, &old_parent_ptr);
> +		if (error)
> +			goto out_release_wip;
> +		error = xfs_parent_init(mp, src_ip, target_name,
> +					&new_parent_ptr);
> +		if (error)
> +			goto out_release_wip;
> +	}
>  
>  retry:
>  	nospace_error = 0;
> @@ -2889,7 +2903,7 @@ xfs_rename(
>  				&tp);
>  	}
>  	if (error)
> -		goto out_release_wip;
> +		goto drop_incompat;
>  
>  	/*
>  	 * Attach the dquots to the inodes
> @@ -2911,14 +2925,14 @@ xfs_rename(
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
> @@ -2928,15 +2942,16 @@ xfs_rename(
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
> @@ -3052,7 +3067,7 @@ xfs_rename(
>  		 * to account for the ".." reference from the new entry.
>  		 */
>  		error = xfs_dir_createname(tp, target_dp, target_name,
> -					   src_ip->i_ino, spaceres, NULL);
> +					   src_ip->i_ino, spaceres, &new_diroffset);
>  		if (error)
>  			goto out_trans_cancel;
>  
> @@ -3073,10 +3088,14 @@ xfs_rename(
>  		 * name at the destination directory, remove it first.
>  		 */
>  		error = xfs_dir_replace(tp, target_dp, target_name,
> -					src_ip->i_ino, spaceres, NULL);
> +					src_ip->i_ino, spaceres, &new_diroffset);
>  		if (error)
>  			goto out_trans_cancel;
>  
> +		if (xfs_has_parent(mp))
> +			error = xfs_parent_init(mp, target_ip, NULL,
> +						&target_parent_ptr);
> +
>  		xfs_trans_ichgtime(tp, target_dp,
>  					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  
> @@ -3146,26 +3165,67 @@ xfs_rename(
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
> +	if (new_parent_ptr) {
> +		error = xfs_parent_defer_add(tp, target_dp, new_parent_ptr,
> +					     new_diroffset);
> +		if (error)
> +			goto out_trans_cancel;
> +	}
> +
> +	if (old_parent_ptr) {
> +		error = xfs_parent_defer_remove(tp, src_dp, old_parent_ptr,
> +						old_diroffset);
> +		if (error)
> +			goto out_trans_cancel;
> +	}
> +
> +	if (target_parent_ptr) {
> +		error = xfs_parent_defer_remove(tp, target_dp,
> +						target_parent_ptr,
> +						new_diroffset);
> +		if (error)
> +			goto out_trans_cancel;
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

Sorry to be fussy, but could you separate the ILOCK unlocking changes
(and maybe the variable indentation part too) into a separate prep
patch, please?

Also, who frees the xfs_parent_defer objects?

--D

> +
>  	return error;
>  
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
> +drop_incompat:
> +	if (new_parent_ptr)
> +		xfs_parent_cancel(mp, new_parent_ptr);
> +	if (old_parent_ptr)
> +		xfs_parent_cancel(mp, old_parent_ptr);
> +	if (target_parent_ptr)
> +		xfs_parent_cancel(mp, target_parent_ptr);
>  out_release_wip:
>  	if (wip)
>  		xfs_irele(wip);
> -- 
> 2.25.1
> 
