Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 552A3C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jan 2022 23:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiAaXkr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jan 2022 18:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiAaXkr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jan 2022 18:40:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C93C061714
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jan 2022 15:40:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0A98B82CC4
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jan 2022 23:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EC7C340E8;
        Mon, 31 Jan 2022 23:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643672444;
        bh=Oxjc/6a5z4ZcEtLE5z5r0jmY3zuTzHmrw9oCZir/BNw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=djdcysO7k4658PgIoEmITD73hSPYMbvnWgZvmp3NsJzbvD/lofrDUy/R9gJ/5S5+E
         nZPUfLD4sr61MlfNWXCZac9s0YkfbFPM2mjbPLoQmHDi+BW4f54OnE7/Qfo7gsgCOL
         K0atVVnZguf3Gkex/NRBLwgbIqke35B1kbmOEi653AXPC00jDSuZR9scL9ShwJT2Uc
         UKpFpMCuY5EUwDI7BqoculV+Sn13H8h4HikXdUPvyUDTRl69laAeZPV+7b9qqoASy2
         58P5JhEGhXnTD9oG4jKhJvqyU5mKNq4hC31MFtZUTFUNVnHsaBZj933V+8oFoOD8nz
         HAW31YQ7ZhckA==
Date:   Mon, 31 Jan 2022 15:40:43 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: remove XFS_PREALLOC_SYNC
Message-ID: <20220131234043.GG8313@magnolia>
References: <20220131233920.784181-1-david@fromorbit.com>
 <20220131233920.784181-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131233920.784181-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 01, 2022 at 10:39:16AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Callers can acheive the same thing by calling xfs_log_force_inode()
> after making their modifications. There is no need for
> xfs_update_prealloc_flags() to do this.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c  | 13 +++++++------
>  fs/xfs/xfs_inode.h |  3 +--
>  fs/xfs/xfs_pnfs.c  |  6 ++++--
>  3 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 22ad207bedf4..ed375b3d0614 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -95,8 +95,6 @@ xfs_update_prealloc_flags(
>  		ip->i_diflags &= ~XFS_DIFLAG_PREALLOC;
>  
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -	if (flags & XFS_PREALLOC_SYNC)
> -		xfs_trans_set_sync(tp);
>  	return xfs_trans_commit(tp);
>  }
>  
> @@ -1057,9 +1055,6 @@ xfs_file_fallocate(
>  		}
>  	}
>  
> -	if (file->f_flags & O_DSYNC)
> -		flags |= XFS_PREALLOC_SYNC;
> -
>  	error = xfs_update_prealloc_flags(ip, flags);
>  	if (error)
>  		goto out_unlock;
> @@ -1082,8 +1077,14 @@ xfs_file_fallocate(
>  	 * leave shifted extents past EOF and hence losing access to
>  	 * the data that is contained within them.
>  	 */
> -	if (do_file_insert)
> +	if (do_file_insert) {
>  		error = xfs_insert_file_space(ip, offset, len);
> +		if (error)
> +			goto out_unlock;
> +	}
> +
> +	if (file->f_flags & O_DSYNC)
> +		error = xfs_log_force_inode(ip);
>  
>  out_unlock:
>  	xfs_iunlock(ip, iolock);
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index c447bf04205a..3fc6d77f5be9 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -465,8 +465,7 @@ xfs_itruncate_extents(
>  enum xfs_prealloc_flags {
>  	XFS_PREALLOC_SET	= (1 << 1),
>  	XFS_PREALLOC_CLEAR	= (1 << 2),
> -	XFS_PREALLOC_SYNC	= (1 << 3),
> -	XFS_PREALLOC_INVISIBLE	= (1 << 4),
> +	XFS_PREALLOC_INVISIBLE	= (1 << 3),
>  };
>  
>  int	xfs_update_prealloc_flags(struct xfs_inode *ip,
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index d6334abbc0b3..ce6d66f20385 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -164,10 +164,12 @@ xfs_fs_map_blocks(
>  		 * that the blocks allocated and handed out to the client are
>  		 * guaranteed to be present even after a server crash.
>  		 */
> -		error = xfs_update_prealloc_flags(ip,
> -				XFS_PREALLOC_SET | XFS_PREALLOC_SYNC);
> +		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
> +		if (!error)
> +			error = xfs_log_force_inode(ip);
>  		if (error)
>  			goto out_unlock;
> +
>  	} else {
>  		xfs_iunlock(ip, lock_flags);
>  	}
> -- 
> 2.33.0
> 
