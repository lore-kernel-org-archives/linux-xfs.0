Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FE3C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jan 2022 23:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiAaXlx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jan 2022 18:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiAaXlw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jan 2022 18:41:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136C6C061714
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jan 2022 15:41:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D29A2B82CBD
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jan 2022 23:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2DDC340E8;
        Mon, 31 Jan 2022 23:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643672509;
        bh=KMZzyItWn2taY6b89GvaRDHIK2G1nLL4OOV3U5NvhTU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d0/wwoEd8PztO/XQTyOxiZTuB9yRZK1V/6EwOn3IKAkhqkQe5a1IxgGUeArsb1JCi
         u6JD9h7ciSjoGeC2jzm4TnfmpCXnd/cxj40hsUiqrAd5vX7DmO5GyIAT4M/9DfLOdQ
         PGkpxWywzjHRvaLF7D09KxrromdZeVHR+T6EoPsRzPpQufnkusnckgBp83a3LodcG4
         HOyDa2ShRVKIQfTK2tkrc0wAvCHQEpGRIJgpZVC1XleQJhc0WUU+f3GdBl5oahv3uK
         Ri7V1haYDmlX6O/cwK21AOZ6z8HNWHeUUvgoz8cnVy8rSl2KmA8RN7HYto0xqncnIF
         LL1qLqvucEhtw==
Date:   Mon, 31 Jan 2022 15:41:49 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: move xfs_update_prealloc_flags() to xfs_pnfs.c
Message-ID: <20220131234149.GH8313@magnolia>
References: <20220131233920.784181-1-david@fromorbit.com>
 <20220131233920.784181-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131233920.784181-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 01, 2022 at 10:39:19AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The operations that xfs_update_prealloc_flags() perform are now
> unique to xfs_fs_map_blocks(), so move xfs_update_prealloc_flags()
> to be a static function in xfs_pnfs.c and cut out all the
> other functionality that is doesn't use anymore.
> 

LGTM,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_file.c  | 32 -------------------------------
>  fs/xfs/xfs_inode.h |  8 --------
>  fs/xfs/xfs_pnfs.c  | 47 ++++++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 45 insertions(+), 42 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 082e3ef81418..cecc5dedddff 100644
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
> index ce6d66f20385..b5e5c7ddfe67 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -70,6 +70,49 @@ xfs_fs_get_uuid(
>  	return 0;
>  }
>  
> +/*
> + * We cannot use file based VFS helpers such as file_modified() to update inode
> + * state as PNFS doesn't provide us with an open file context that the VFS
> + * helpers require. Hence we open code a best effort timestamp update and
> + * SUID/SGID stripping here, knowing that server side security in PNFS settings
> + * is largely non-existent as clients have storage level remote write access.
> + * Hence clients have the capability to overwrite filesystem metadata, and so
> + * the filesystem trust domain extends to untrusted, uncontrollable remote
> + * clients.  Hence server side enforced filesystem "security" in filesystem
> + * based PNFS block layout settings is pure theatre: friends don't let friends
> + * host executables on PNFS exported XFS volumes, let alone SUID executables.
> + *
> + * We also need to set the inode prealloc flag to ensure that the extents we
> + * allocate beyond the existing EOF and hand to the PNFS client are not removed
> + * by background blockgc scanning, ENOSPC mitigations or inode reclaim before
> + * the PNFS client calls xfs_fs_block_commit() to indicate that data has been
> + * written and the file size can be extended.
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
> @@ -164,7 +207,7 @@ xfs_fs_map_blocks(
>  		 * that the blocks allocated and handed out to the client are
>  		 * guaranteed to be present even after a server crash.
>  		 */
> -		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
> +		error = xfs_fs_map_update_inode(ip);
>  		if (!error)
>  			error = xfs_log_force_inode(ip);
>  		if (error)
> @@ -257,7 +300,7 @@ xfs_fs_commit_blocks(
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
