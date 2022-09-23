Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E447BC07E9D
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 21:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbiIWVQI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 17:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiIWVQH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 17:16:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB035121646
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 14:16:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6091960FA8
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 21:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA68C433D6;
        Fri, 23 Sep 2022 21:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663967763;
        bh=Lk50zjGCYpdFAeTEr5SXZiTfA39EN+y5WxCtm6ZvbJ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ek6JgK+OLYFhGo8caSCnyOWJdVj/dx8hcMGsJAOhu/GAd3wPuN/1yXAcLXpNHOdMT
         WByXLKIpHzQ5VGWJJYTxJOReU+4WUDLDtgI/aWA0YvzYBVjZS8iwueaQ9ivqUEXrrl
         O5ePByxhcmI6Ldh9wZmq15RRV3K9kDV8jBPeK9aAwZehl2xY4lRvGzpWHKIQoaVMHa
         vukFC9aCe8AO4LxDr+fgqah+SgHG8mhsXagm5f5iGU6vlAm58mnLoOX+MjhYYA7k91
         PStYvXbZU72vwS+J8XjdoYcvbsCtLACiXi2elOJUBofJpyAX/p8T2moZ2KjA9oh0Nt
         Ut16U7/pYcUMw==
Date:   Fri, 23 Sep 2022 14:16:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 16/26] xfs: add parent attributes to symlink
Message-ID: <Yy4iE7B4cGo2wwPH@magnolia>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
 <20220922054458.40826-17-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922054458.40826-17-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 21, 2022 at 10:44:48PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch modifies xfs_symlink to add a parent pointer to the inode.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Ooh, a new patch.

> ---
>  fs/xfs/xfs_symlink.c | 31 +++++++++++++++++++++++++++----
>  1 file changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 27a7d7c57015..14079367335b 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -23,6 +23,8 @@
>  #include "xfs_trans.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_error.h"
> +#include "xfs_parent.h"
> +#include "xfs_defer.h"
>  
>  /* ----- Kernel only functions below ----- */
>  int
> @@ -172,6 +174,8 @@ xfs_symlink(
>  	struct xfs_dquot	*pdqp = NULL;
>  	uint			resblks;
>  	xfs_ino_t		ino;
> +	xfs_dir2_dataptr_t      diroffset;
> +	struct xfs_parent_defer *parent = NULL;
>  
>  	*ipp = NULL;
>  
> @@ -179,10 +183,10 @@ xfs_symlink(
>  
>  	if (xfs_is_shutdown(mp))
>  		return -EIO;
> -
>  	/*
>  	 * Check component lengths of the target path name.
>  	 */
> +
>  	pathlen = strlen(target_path);
>  	if (pathlen >= XFS_SYMLINK_MAXLEN)      /* total string too long */
>  		return -ENAMETOOLONG;
> @@ -204,12 +208,18 @@ xfs_symlink(
>  	 * The symlink will fit into the inode data fork?
>  	 * There can't be any attributes so we get the whole variable part.
>  	 */
> -	if (pathlen <= XFS_LITINO(mp))
> +	if (pathlen <= XFS_LITINO(mp) && !xfs_has_parent(mp))
>  		fs_blocks = 0;
>  	else
>  		fs_blocks = xfs_symlink_blocks(mp, pathlen);
>  	resblks = XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);

Same comment as the last two patches: Please update
xfs_symlink_space_res to handle the free space that might be needed to
expand the xattr structure ondisk:

unsigned int
xfs_symlink_space_res(
	struct xfs_mount	*mp,
	unsigned int		namelen,
	unsigned int		fsblocks)
{
	unsigned int		ret;

	ret = XFS_IALLOC_SPACE_RES(mp) +
	      XFS_DIRENTER_SPACE_RES(mp, namelen) +
	      fsblocks;

	if (xfs_has_parent(mp))
		ret += xfs_pptr_calc_space_res(mp, namelen);

	return ret;
}

Everything else in here otherwise looks good to me.

--D

>  
> +	if (xfs_has_parent(mp)) {
> +		error = xfs_parent_init(mp, &parent);
> +		if (error)
> +			return error;
> +	}
> +
>  	error = xfs_trans_alloc_icreate(mp, &M_RES(mp)->tr_symlink, udqp, gdqp,
>  			pdqp, resblks, &tp);
>  	if (error)
> @@ -233,7 +243,7 @@ xfs_symlink(
>  	if (!error)
>  		error = xfs_init_new_inode(mnt_userns, tp, dp, ino,
>  				S_IFLNK | (mode & ~S_IFMT), 1, 0, prid,
> -				false, &ip);
> +				xfs_has_parent(mp), &ip);
>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -315,12 +325,20 @@ xfs_symlink(
>  	 * Create the directory entry for the symlink.
>  	 */
>  	error = xfs_dir_createname(tp, dp, link_name,
> -			ip->i_ino, resblks, NULL);
> +			ip->i_ino, resblks, &diroffset);
>  	if (error)
>  		goto out_trans_cancel;
>  	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
>  
> +	if (parent) {
> +		error = xfs_parent_defer_add(tp, parent, dp, link_name,
> +					     diroffset, ip);
> +		if (error)
> +			goto out_trans_cancel;
> +	}
> +
> +
>  	/*
>  	 * If this is a synchronous mount, make sure that the
>  	 * symlink transaction goes to disk before returning to
> @@ -344,6 +362,8 @@ xfs_symlink(
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
>  out_release_inode:
> +	xfs_defer_cancel(tp);
> +
>  	/*
>  	 * Wait until after the current transaction is aborted to finish the
>  	 * setup of the inode and release the inode.  This prevents recursive
> @@ -362,6 +382,9 @@ xfs_symlink(
>  		xfs_iunlock(dp, XFS_ILOCK_EXCL);
>  	if (ip)
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	if (parent)
> +		xfs_parent_cancel(mp, parent);
> +
>  	return error;
>  }
>  
> -- 
> 2.25.1
> 
