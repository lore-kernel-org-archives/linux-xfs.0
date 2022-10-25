Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCBE6C38A2D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 20:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbiJYU6u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 16:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJYU6t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 16:58:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909C6B56DE
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 13:58:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22F85B81BE1
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 20:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3FFC433C1;
        Tue, 25 Oct 2022 20:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666731525;
        bh=juAh/oFIqPQCW1jPqyTiY8irzcXPUiIFwyeJa4DVww8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AXwi1GegbdM2RLpfAd8z/NGWUS4BYhDphUncCpsKxFJQVSwn3iXzoo8CItpo3jQcK
         nXZ6O/prCnO9lt8/X7DDk9/jIu6KX9OtYR0SAVfscg3ihMb954oWcvQju1IabuNq3z
         qaKx1p89ljottRlaiE8g/8Lb4Ft8Q9AAujowyMnZLlu0tJ7w//4UX9W6VkK9V9FCfX
         IxyE2sN7ca7m3SvgA40joYQD0hu2ZkOQnWe2qrAtHNQ92C6aQh7CgO9iKnHmJfnaYl
         FjV79yeoP6lvsKkcDMIxCgC5EEARPrWwZsG9b3Kpohm5ZPSsWY3v1AtbuBPRi5YX1b
         sESb/Mtsppb1Q==
Date:   Tue, 25 Oct 2022 13:58:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 16/27] xfs: add parent attributes to link
Message-ID: <Y1hOBZqdVeMLT6Xc@magnolia>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
 <20221021222936.934426-17-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021222936.934426-17-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 21, 2022 at 03:29:25PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch modifies xfs_link to add a parent pointer to the inode.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_inode.c | 60 ++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 50 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ae6604f51ce8..f2e7da1befa4 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1248,16 +1248,32 @@ xfs_create_tmpfile(
>  	return error;
>  }
>  
> +unsigned int
> +xfs_link_space_res(
> +	struct xfs_mount	*mp,
> +	unsigned int		namelen)
> +{
> +	unsigned int		ret;
> +
> +	ret = XFS_DIRENTER_SPACE_RES(mp, namelen);
> +	if (xfs_has_parent(mp))
> +		ret += xfs_pptr_calc_space_res(mp, namelen);
> +
> +	return ret;
> +}
> +
>  int
>  xfs_link(
> -	xfs_inode_t		*tdp,
> -	xfs_inode_t		*sip,
> +	struct xfs_inode	*tdp,
> +	struct xfs_inode	*sip,
>  	struct xfs_name		*target_name)
>  {
> -	xfs_mount_t		*mp = tdp->i_mount;
> -	xfs_trans_t		*tp;
> +	struct xfs_mount	*mp = tdp->i_mount;
> +	struct xfs_trans	*tp;
>  	int			error, nospace_error = 0;
>  	int			resblks;
> +	xfs_dir2_dataptr_t	diroffset;
> +	struct xfs_parent_defer	*parent = NULL;
>  
>  	trace_xfs_link(tdp, target_name);
>  
> @@ -1274,11 +1290,17 @@ xfs_link(
>  	if (error)
>  		goto std_return;
>  
> -	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
> +	if (xfs_has_parent(mp)) {
> +		error = xfs_parent_init(mp, &parent);
> +		if (error)
> +			goto std_return;
> +	}
> +
> +	resblks = xfs_link_space_res(mp, target_name->len);
>  	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
>  			&tp, &nospace_error);
>  	if (error)
> -		goto std_return;
> +		goto drop_incompat;
>  
>  	/*
>  	 * If we are using project inheritance, we only allow hard link
> @@ -1311,14 +1333,27 @@ xfs_link(
>  	}
>  
>  	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
> -				   resblks, NULL);
> +				   resblks, &diroffset);
>  	if (error)
> -		goto error_return;
> +		goto out_defer_cancel;
>  	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
>  
>  	xfs_bumplink(tp, sip);
>  
> +	/*
> +	 * If we have parent pointers, we now need to add the parent record to
> +	 * the attribute fork of the inode. If this is the initial parent
> +	 * attribute, we need to create it correctly, otherwise we can just add
> +	 * the parent to the inode.
> +	 */
> +	if (parent) {
> +		error = xfs_parent_defer_add(tp, parent, tdp, target_name,
> +					     diroffset, sip);
> +		if (error)
> +			goto out_defer_cancel;
> +	}
> +
>  	/*
>  	 * If this is a synchronous mount, make sure that the
>  	 * link transaction goes to disk before returning to
> @@ -1332,11 +1367,16 @@ xfs_link(
>  	xfs_iunlock(sip, XFS_ILOCK_EXCL);
>  	return error;
>  
> - error_return:
> +out_defer_cancel:
> +	xfs_defer_cancel(tp);
> +error_return:
>  	xfs_trans_cancel(tp);

It's no longer necessary to call xfs_defer_cancel before
xfs_trans_cancel, so you can eliminate this cleanup code.

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


>  	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
>  	xfs_iunlock(sip, XFS_ILOCK_EXCL);
> - std_return:
> +drop_incompat:
> +	if (parent)
> +		xfs_parent_cancel(mp, parent);
> +std_return:
>  	if (error == -ENOSPC && nospace_error)
>  		error = nospace_error;
>  	return error;
> -- 
> 2.25.1
> 
