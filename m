Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20425C04A95
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 21:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiIWVwO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 17:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIWVwN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 17:52:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53B61323E2
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 14:52:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 513C461050
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 21:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5D3C433C1;
        Fri, 23 Sep 2022 21:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663969931;
        bh=7NzcoDRmhoyo1TAyJXAOrq+rQXL2S27FJZe5JEbBGbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b11+4nk8OsGE2/vzdRE/k+/7q4CqW1hEMRWpaZEkYmtgpqYyHjhUP9yvd/aapZcgK
         ECN5itHg4dmwFoCO2NB2go/8xdZhvGn91u/HUGdPSfDaET6FGrxzHhQXCChCl+AZjV
         JO3FSoZ6L1RVbTVaUv7yuAaLNXbJkrTqvvJf6RLqRghAsR76SNX+j8M7/J/9Jd8+Bv
         BZVi+1cq7JObyJ2gEAflCVL1EAgt8ZCBcrXVsU+PgUSAmkhw23Fe4ssldjl3zjaozo
         BXTTVVgGlhdPvHi7CWPa6+0SMumS7RxRSt0ID0ANmJzywYLtfVtJvb7cxy5UhAAS4b
         YwMYSbtTRQsSQ==
Date:   Fri, 23 Sep 2022 14:52:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 18/26] xfs: Add parent pointers to xfs_cross_rename
Message-ID: <Yy4qi1rUB6lj542c@magnolia>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
 <20220922054458.40826-19-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922054458.40826-19-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 21, 2022 at 10:44:50PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Cross renames are handled separately from standard renames, and
> need different handling to update the parent attributes correctly.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_inode.c | 85 ++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 70 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 1a35dc972d4d..51724af22bf9 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2682,27 +2682,49 @@ xfs_finish_rename(
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
> +	struct xfs_trans		*tp,
> +	struct xfs_inode		*dp1,
> +	struct xfs_name			*name1,
> +	struct xfs_inode		*ip1,
> +	struct xfs_inode		*dp2,
> +	struct xfs_name			*name2,
> +	struct xfs_inode		*ip2,
> +	int				spaceres)
>  {
> -	int		error = 0;
> -	int		ip1_flags = 0;
> -	int		ip2_flags = 0;
> -	int		dp2_flags = 0;
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

Four?  I think this means that xfs_calc_rename_reservation needs to do:

	overhead += 4 * (sizeof(struct xfs_attri_log_item) +
				whatever_else);

Right?

The rest of the patch looks fine, though...

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
> @@ -2763,6 +2785,28 @@ xfs_cross_rename(
>  		}
>  	}
>  
> +	if (xfs_has_parent(mp)) {
> +		error = xfs_parent_defer_replace(tp, dp1,
> +						  old_parent_ptr,
> +						  old_diroffset,
> +						  name2,
> +						  dp2,
> +						  new_parent_ptr,
> +						  new_diroffset, ip1);

...if you reflowed this to do two-tab indenting instead of kernel-style
indenting I wouldn't be sad. ;)

--D

> +		if (error)
> +			goto out_trans_abort;
> +
> +		error = xfs_parent_defer_replace(tp, dp2,
> +						  new_parent_ptr2,
> +						  new_diroffset,
> +						  name1,
> +						  dp1,
> +						  old_parent_ptr2,
> +						  old_diroffset, ip2);
> +		if (error)
> +			goto out_trans_abort;
> +	}
> +
>  	if (ip1_flags) {
>  		xfs_trans_ichgtime(tp, ip1, ip1_flags);
>  		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
> @@ -2777,10 +2821,21 @@ xfs_cross_rename(
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
