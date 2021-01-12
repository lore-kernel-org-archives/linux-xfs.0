Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 591FDC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 01:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DA1A22AED
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 01:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbhALBeq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 20:34:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728387AbhALBeq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 20:34:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C7E322E01;
        Tue, 12 Jan 2021 01:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610415245;
        bh=/hs8hS7l2JtCfAkt6o1bXkFtj6FM0y/f1P9XwhKtnrs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uNiuxPNu1WXFZgqIyQCXvtq+jVtsjjUaARgxqEZn01CJwPVg0+IxPXKoA8Atbq6Nn
         x+WWSqIS7TA794NI8osaLdSl5fcF793D1pm/nvN9YhDcoQ1NXEpYmTFFfrIn5LvxyX
         DZMVKXMoEjn6Wlpfu7JLd5UlygJFrfqkuIidPpF5Gq9R4FPzPbHKQzJGe5BIgsqkfC
         7TC1HUmdikyxFJh/TFnQiwB8cFUABPIItglJE8z9Rw+fzNFMCx/hKOmVQ60aYDqznx
         Y/fbHIRgWkrKes+VFDTA29Ph9DoYn/qAR6qvNQb3LY4pR+bDLe9KygTxwk5Uw0/Lam
         yqlec03yPxzUQ==
Date:   Mon, 11 Jan 2021 17:34:02 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com, hch@lst.de,
        allison.henderson@oracle.com
Subject: Re: [PATCH V14 04/16] xfs: Check for extent overflow when adding dir
 entries
Message-ID: <20210112013402.GK1164246@magnolia>
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
 <20210110160720.3922965-5-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210110160720.3922965-5-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 10, 2021 at 09:37:08PM +0530, Chandan Babu R wrote:
> Directory entry addition can cause the following,
> 1. Data block can be added/removed.
>    A new extent can cause extent count to increase by 1.
> 2. Free disk block can be added/removed.
>    Same behaviour as described above for Data block.
> 3. Dabtree blocks.
>    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these
>    can be new extents. Hence extent count can increase by
>    XFS_DA_NODE_MAXDEPTH.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

OK, seems reasonably straight forward,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_fork.h | 13 +++++++++++++
>  fs/xfs/xfs_inode.c             | 10 ++++++++++
>  fs/xfs/xfs_symlink.c           |  5 +++++
>  3 files changed, 28 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index bcac769a7df6..ea1a9dd8a763 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -47,6 +47,19 @@ struct xfs_ifork {
>   */
>  #define XFS_IEXT_PUNCH_HOLE_CNT		(1)
>  
> +/*
> + * Directory entry addition can cause the following,
> + * 1. Data block can be added/removed.
> + *    A new extent can cause extent count to increase by 1.
> + * 2. Free disk block can be added/removed.
> + *    Same behaviour as described above for Data block.
> + * 3. Dabtree blocks.
> + *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these can be new
> + *    extents. Hence extent count can increase by XFS_DA_NODE_MAXDEPTH.
> + */
> +#define XFS_IEXT_DIR_MANIP_CNT(mp) \
> +	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
> +
>  /*
>   * Fork handling.
>   */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index b7352bc4c815..4cc787cc4eee 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1042,6 +1042,11 @@ xfs_create(
>  	if (error)
>  		goto out_trans_cancel;
>  
> +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> +			XFS_IEXT_DIR_MANIP_CNT(mp));
> +	if (error)
> +		goto out_trans_cancel;
> +
>  	/*
>  	 * A newly created regular or special file just has one directory
>  	 * entry pointing to them, but a directory also the "." entry
> @@ -1258,6 +1263,11 @@ xfs_link(
>  	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
>  
> +	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
> +			XFS_IEXT_DIR_MANIP_CNT(mp));
> +	if (error)
> +		goto error_return;
> +
>  	/*
>  	 * If we are using project inheritance, we only allow hard link
>  	 * creation in our tree when the project IDs are the same; else
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 1f43fd7f3209..0b8136a32484 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -220,6 +220,11 @@ xfs_symlink(
>  	if (error)
>  		goto out_trans_cancel;
>  
> +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> +			XFS_IEXT_DIR_MANIP_CNT(mp));
> +	if (error)
> +		goto out_trans_cancel;
> +
>  	/*
>  	 * Allocate an inode for the symlink.
>  	 */
> -- 
> 2.29.2
> 
