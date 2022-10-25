Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D4A5FA373E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 21:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiJYVGW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 17:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbiJYVGU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 17:06:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9297295E53
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 14:06:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D92FB81F13
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 21:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD89C433C1;
        Tue, 25 Oct 2022 21:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666731976;
        bh=G8+BuqkG0fpuH1HFCs8lQbu9TxWyNuCbHrWZjPlkmIE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KcEWyrFMkRqYAq7csDIL8g/NClcu9XaV/64H1G5w6ttRV0LZDuFHUWaGE5QswVzzp
         lZgCFJpMtz5K/lJrcaVRPN3ZOn/FpxgJkVVBzB+NkJhan+VFaJLDEUEcMqPvMpapje
         J/7F2ke1gRe4VpCa2vc0IwEP4CJZmkqx7/J1ttmwtgNr/4qDDCqJmTU01zjEV7GA8e
         2B4b//5MN2da3UKGfZeRHGLoVt+qt8Tge4PnjkRzWMp1tIjnFOSYf4H1VpGSD05GwQ
         9C9B2vk08DPWwpVpe7SMbdlEQcO/I1d9RZax8sXkany6Z/lWDt9AKaDx0srbsYp5j+
         K4MZ5a5A9NnXA==
Date:   Tue, 25 Oct 2022 14:06:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 17/27] xfs: add parent attributes to symlink
Message-ID: <Y1hPyDRNZ4k/ahL/@magnolia>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
 <20221021222936.934426-18-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021222936.934426-18-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 21, 2022 at 03:29:26PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch modifies xfs_symlink to add a parent pointer to the inode.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_symlink.c | 50 +++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 45 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 27a7d7c57015..968ca257cd82 100644
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
> @@ -142,6 +144,23 @@ xfs_readlink(
>  	return error;
>  }
>  
> +unsigned int
> +xfs_symlink_space_res(

Should the XFS_SYMLINK_SPACE_RES macro be removed from
xfs_trans_space.h?

Come to think of it, the same question applies to the previous patch.

> +	struct xfs_mount	*mp,
> +	unsigned int		namelen,
> +	unsigned int		fsblocks)
> +{
> +	unsigned int		ret;
> +
> +	ret = XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp, namelen) +
> +	      fsblocks;

Nit: This should probably be indented two tabs.

> +
> +	if (xfs_has_parent(mp))
> +		ret += xfs_pptr_calc_space_res(mp, namelen);
> +
> +	return ret;
> +}
> +
>  int
>  xfs_symlink(
>  	struct user_namespace	*mnt_userns,
> @@ -172,6 +191,8 @@ xfs_symlink(
>  	struct xfs_dquot	*pdqp = NULL;
>  	uint			resblks;
>  	xfs_ino_t		ino;
> +	xfs_dir2_dataptr_t      diroffset;
> +	struct xfs_parent_defer *parent = NULL;
>  
>  	*ipp = NULL;
>  
> @@ -179,10 +200,10 @@ xfs_symlink(
>  
>  	if (xfs_is_shutdown(mp))
>  		return -EIO;
> -
>  	/*
>  	 * Check component lengths of the target path name.
>  	 */
> +

Unnecessary whitespace changes (while we're on nits...)

>  	pathlen = strlen(target_path);
>  	if (pathlen >= XFS_SYMLINK_MAXLEN)      /* total string too long */
>  		return -ENAMETOOLONG;
> @@ -204,11 +225,17 @@ xfs_symlink(
>  	 * The symlink will fit into the inode data fork?
>  	 * There can't be any attributes so we get the whole variable part.
>  	 */
> -	if (pathlen <= XFS_LITINO(mp))
> +	if (pathlen <= XFS_LITINO(mp) && !xfs_has_parent(mp))

Why do we require !xfs_has_parent here?  fs_blocks are the blocks needed
to reserve space for the remote symlink target blocks.  Link targets are
not recorded in pptrs, so I am surprised to see this here.

>  		fs_blocks = 0;
>  	else
>  		fs_blocks = xfs_symlink_blocks(mp, pathlen);
> -	resblks = XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
> +	resblks = xfs_symlink_space_res(mp, link_name->len, fs_blocks);
> +
> +	if (xfs_has_parent(mp)) {
> +		error = xfs_parent_init(mp, &parent);
> +		if (error)
> +			return error;
> +	}
>  
>  	error = xfs_trans_alloc_icreate(mp, &M_RES(mp)->tr_symlink, udqp, gdqp,
>  			pdqp, resblks, &tp);
> @@ -233,7 +260,7 @@ xfs_symlink(
>  	if (!error)
>  		error = xfs_init_new_inode(mnt_userns, tp, dp, ino,
>  				S_IFLNK | (mode & ~S_IFMT), 1, 0, prid,
> -				false, &ip);
> +				xfs_has_parent(mp), &ip);

Ahaaaaa, some of these init_xattrs = false occurrences from earlier
patches get replaced by xfs_has_parent calls later.  I'll go back and
revise my earlier comments then.

>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -315,12 +342,20 @@ xfs_symlink(
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
> @@ -344,6 +379,8 @@ xfs_symlink(
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
>  out_release_inode:
> +	xfs_defer_cancel(tp);

Two complaints: xfs_trans_cancel frees @tp so the xfs_defer_cancel call
is a UAF error.

Second, xfs_trans_cancel calls xfs_defer_cancel so it's not necessary.

--D

> +
>  	/*
>  	 * Wait until after the current transaction is aborted to finish the
>  	 * setup of the inode and release the inode.  This prevents recursive
> @@ -362,6 +399,9 @@ xfs_symlink(
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
