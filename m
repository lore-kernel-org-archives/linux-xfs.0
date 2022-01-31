Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9634C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jan 2022 17:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380696AbiAaRh5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jan 2022 12:37:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52192 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381036AbiAaRh4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jan 2022 12:37:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F5C26102C
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jan 2022 17:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BD8C340E8;
        Mon, 31 Jan 2022 17:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643650675;
        bh=XBZaDOBo4PW4WFj02bwcwfhIxN2GQj9eCauwEPAY7rI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BVpWATRmflTFh8BV18qWQNPXNJ+WRtwN+eFs8WA8XUbwP1E2hhK8wKLF/kBbpAjoY
         tD8+iL+8bA34HwL+6oBfAp7ZdiPG/ZrX7EpiMD6hsDES0fjReXuBbF9kO6yGbaAhpQ
         j1yS+c03CCfHlE2Oxxc6CTz5e1f/ZsTo5nOF5aNFLTHQlNkg8Snw9J6SVgWpaahrMn
         sjf74V8aOSKoioPCNyqxqPHIUZRO2iQvz12RGBHrggvvlxqHAXewIURGeP8ENNAgpA
         ci41oVRYvr2bOmBNNI2rZbJQSMHK/M1MYxDtj94KkTYR+aARMksRTITJXgamHBHvTa
         1aJwEniZ+RSgw==
Date:   Mon, 31 Jan 2022 09:37:55 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: move xfs_update_prealloc_flags() to xfs_pnfs.c
Message-ID: <20220131173755.GD8313@magnolia>
References: <164351876356.4177728.10148216594418485828.stgit@magnolia>
 <20220131064350.739863-1-david@fromorbit.com>
 <20220131064350.739863-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131064350.739863-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 31, 2022 at 05:43:49PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The operations that xfs_update_prealloc_flags() perform are now
> unique to xfs_fs_map_blocks(), so move xfs_update_prealloc_flags()
> to be a static function in xfs_pnfs.c and cut out all the
> other functionality that is doesn't use anymore.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_file.c  | 32 --------------------------------
>  fs/xfs/xfs_inode.h |  8 --------
>  fs/xfs/xfs_pnfs.c  | 38 ++++++++++++++++++++++++++++++++++++--
>  3 files changed, 36 insertions(+), 42 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index ae6f5b15a023..ddc3336e8f84 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -66,38 +66,6 @@ xfs_is_falloc_aligned(
>  	return !((pos | len) & mask);
>  }
>  
> -int
> -xfs_update_prealloc_flags(
> -	struct xfs_inode	*ip,
> -	enum xfs_prealloc_flags	flags)
> -{
> -	struct xfs_trans	*tp;
> -	int			error;
> -
> -	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_writeid,
> -			0, 0, 0, &tp);
> -	if (error)
> -		return error;
> -
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> -
> -	if (!(flags & XFS_PREALLOC_INVISIBLE)) {
> -		VFS_I(ip)->i_mode &= ~S_ISUID;
> -		if (VFS_I(ip)->i_mode & S_IXGRP)
> -			VFS_I(ip)->i_mode &= ~S_ISGID;
> -		xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> -	}
> -
> -	if (flags & XFS_PREALLOC_SET)
> -		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
> -	if (flags & XFS_PREALLOC_CLEAR)
> -		ip->i_diflags &= ~XFS_DIFLAG_PREALLOC;
> -
> -	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -	return xfs_trans_commit(tp);
> -}
> -
>  /*
>   * Fsync operations on directories are much simpler than on regular files,
>   * as there is no file data to flush, and thus also no need for explicit
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 3fc6d77f5be9..b7e8f14d9fca 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -462,14 +462,6 @@ xfs_itruncate_extents(
>  }
>  
>  /* from xfs_file.c */
> -enum xfs_prealloc_flags {
> -	XFS_PREALLOC_SET	= (1 << 1),
> -	XFS_PREALLOC_CLEAR	= (1 << 2),
> -	XFS_PREALLOC_INVISIBLE	= (1 << 3),
> -};
> -
> -int	xfs_update_prealloc_flags(struct xfs_inode *ip,
> -				  enum xfs_prealloc_flags flags);
>  int	xfs_break_layouts(struct inode *inode, uint *iolock,
>  		enum layout_break_reason reason);
>  
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index ce6d66f20385..4abe17312c2b 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -70,6 +70,40 @@ xfs_fs_get_uuid(
>  	return 0;
>  }
>  
> +/*
> + * We cannot use file based VFS helpers such as file_modified() to update
> + * inode state as we modify the data/metadata in the inode here. Hence we have

Hmm.  I'm a little fuzzy on the significance of "...as we modify the
data/metadata" here.  fallocate also modifies file contents and
metadata, so why is pnfs special?

Is it because pnfs doesn't check for freeze/ro state before calling
->map_blocks, and we don't want to stall on file_update_time?

> + * to open code the timestamp updates and SUID/SGID stripping. We also need
> + * to set the inode prealloc flag to ensure that the extents we allocate are not
> + * removed if the inode is reclaimed from memory before xfs_fs_block_commit()
> + * is from the client to indicate that data has been written and the file size

"is called from the client" ?

--D

> + * can be extended.
> + */
> +static int
> +xfs_fs_map_update_inode(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_trans	*tp;
> +	int			error;
> +
> +	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_writeid,
> +			0, 0, 0, &tp);
> +	if (error)
> +		return error;
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +
> +	VFS_I(ip)->i_mode &= ~S_ISUID;
> +	if (VFS_I(ip)->i_mode & S_IXGRP)
> +		VFS_I(ip)->i_mode &= ~S_ISGID;
> +	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> +	ip->i_diflags |= XFS_DIFLAG_PREALLOC;
> +
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +	return xfs_trans_commit(tp);
> +}
> +
>  /*
>   * Get a layout for the pNFS client.
>   */
> @@ -164,7 +198,7 @@ xfs_fs_map_blocks(
>  		 * that the blocks allocated and handed out to the client are
>  		 * guaranteed to be present even after a server crash.
>  		 */
> -		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
> +		error = xfs_fs_map_update_inode(ip);
>  		if (!error)
>  			error = xfs_log_force_inode(ip);
>  		if (error)
> @@ -257,7 +291,7 @@ xfs_fs_commit_blocks(
>  		length = end - start;
>  		if (!length)
>  			continue;
> -	
> +
>  		/*
>  		 * Make sure reads through the pagecache see the new data.
>  		 */
> -- 
> 2.33.0
> 
