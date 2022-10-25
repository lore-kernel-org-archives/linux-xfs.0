Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1397FA373E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 21:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiJYVc0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 17:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbiJYVcZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 17:32:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D00BB3A6
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 14:32:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01099B81CF3
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 21:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A158C433D6;
        Tue, 25 Oct 2022 21:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666733541;
        bh=7LCswRYeu1WVABYeFn7cY9p0eSIJRUbtSxmRmHhkNN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vIX4KCjaRGAyS3Hw1mFGx8O4PDwSxvo3ICgkhAC4NASqTYaeEfRGYT33vGric1tv5
         v9B5e0sI5ERrBMufaZNeu6JaVDQ4ytpIkR/lohMgQOliHASJMo+bh4qO0N/yI1pfl9
         UdIiMw1gI88f7AnjxkrM8128hejuo1dfnDNytu/x0PJDIF1oy5qy8iIE7hDtywpvlt
         18nme7Ghy3wRoA69ZTZdhppoPx9lT+uLIXDqHtRPMh7guxeAnReC91BjfsHtJxhO7P
         Z6hGamFQtHCeNlkQM3k7ZE/AslZ5n6amCyIkUOGC94snlLW/PJ/LtZClwAc4Ptijao
         hu3NiuHqNlKdQ==
Date:   Tue, 25 Oct 2022 14:32:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 19/27] xfs: Add parent pointers to xfs_cross_rename
Message-ID: <Y1hV5WzaeYR742RX@magnolia>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
 <20221021222936.934426-20-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021222936.934426-20-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 21, 2022 at 03:29:28PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Cross renames are handled separately from standard renames, and
> need different handling to update the parent attributes correctly.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_inode.c | 79 ++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 63 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 83cc52c2bcf1..c79d1047d118 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2746,27 +2746,49 @@ xfs_finish_rename(
>   */
>  STATIC int
>  xfs_cross_rename(
> -	struct xfs_trans	*tp,
> -	struct xfs_inode	*dp1,
> -	struct xfs_name		*name1,
> -	struct xfs_inode	*ip1,
> -	struct xfs_inode	*dp2,
> -	struct xfs_name		*name2,
> -	struct xfs_inode	*ip2,
> -	int			spaceres)
> -{
> -	int		error = 0;
> -	int		ip1_flags = 0;
> -	int		ip2_flags = 0;
> -	int		dp2_flags = 0;
> +	struct xfs_trans		*tp,
> +	struct xfs_inode		*dp1,
> +	struct xfs_name			*name1,
> +	struct xfs_inode		*ip1,
> +	struct xfs_inode		*dp2,
> +	struct xfs_name			*name2,
> +	struct xfs_inode		*ip2,
> +	int				spaceres)
> +{
> +	struct xfs_mount		*mp = dp1->i_mount;
> +	int				error = 0;
> +	int				ip1_flags = 0;
> +	int				ip2_flags = 0;
> +	int				dp2_flags = 0;
> +	int				new_diroffset, old_diroffset;
> +	struct xfs_parent_defer		*old_parent_ptr = NULL;
> +	struct xfs_parent_defer		*new_parent_ptr = NULL;
> +	struct xfs_parent_defer		*old_parent_ptr2 = NULL;
> +	struct xfs_parent_defer		*new_parent_ptr2 = NULL;
> +
> +

Nit: extra blank line

> +	if (xfs_has_parent(mp)) {
> +		error = xfs_parent_init(mp, &old_parent_ptr);
> +		if (error)
> +			goto out_trans_abort;
> +		error = xfs_parent_init(mp, &new_parent_ptr);
> +		if (error)
> +			goto out_trans_abort;
> +		error = xfs_parent_init(mp, &old_parent_ptr2);
> +		if (error)
> +			goto out_trans_abort;
> +		error = xfs_parent_init(mp, &new_parent_ptr2);
> +		if (error)
> +			goto out_trans_abort;
> +	}
>  
>  	/* Swap inode number for dirent in first parent */
> -	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, NULL);
> +	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, &old_diroffset);
>  	if (error)
>  		goto out_trans_abort;
>  
>  	/* Swap inode number for dirent in second parent */
> -	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, NULL);
> +	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, &new_diroffset);
>  	if (error)
>  		goto out_trans_abort;
>  
> @@ -2827,6 +2849,20 @@ xfs_cross_rename(
>  		}
>  	}
>  
> +	if (xfs_has_parent(mp)) {
> +		error = xfs_parent_defer_replace(tp, dp1,

Isn't xfs_parent_defer_replace() added in the next patch?

> +				old_parent_ptr, old_diroffset, name2, dp2,
> +				new_parent_ptr, new_diroffset, ip1);

The changes to xfs_parent_defer_replace that I mention in the next patch
notwithstanding, this looks good now.

--D

> +		if (error)
> +			goto out_trans_abort;
> +
> +		error = xfs_parent_defer_replace(tp, dp2, new_parent_ptr2,
> +				new_diroffset, name1, dp1, old_parent_ptr2,
> +				old_diroffset, ip2);
> +		if (error)
> +			goto out_trans_abort;
> +	}
> +
>  	if (ip1_flags) {
>  		xfs_trans_ichgtime(tp, ip1, ip1_flags);
>  		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
> @@ -2841,10 +2877,21 @@ xfs_cross_rename(
>  	}
>  	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
> -	return xfs_finish_rename(tp);
>  
> +	error = xfs_finish_rename(tp);
> +	goto out;
>  out_trans_abort:
>  	xfs_trans_cancel(tp);
> +out:
> +	if (new_parent_ptr)
> +		xfs_parent_cancel(mp, new_parent_ptr);
> +	if (old_parent_ptr)
> +		xfs_parent_cancel(mp, old_parent_ptr);
> +	if (new_parent_ptr2)
> +		xfs_parent_cancel(mp, new_parent_ptr2);
> +	if (old_parent_ptr2)
> +		xfs_parent_cancel(mp, old_parent_ptr2);
> +
>  	return error;
>  }
>  
> -- 
> 2.25.1
> 
