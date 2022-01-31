Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCCFAC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jan 2022 17:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380981AbiAaRaE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jan 2022 12:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236516AbiAaRaD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jan 2022 12:30:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D17C061714
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jan 2022 09:30:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 550D0B82BB2
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jan 2022 17:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16233C340E8;
        Mon, 31 Jan 2022 17:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643650201;
        bh=TLL/CUwfyXXQ9mwmUZtEJJ162wTboSlFYTozimmO3JU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LacvdSAgnh8rCLmYtUeEvVz48b8hdxQ/OCPq1Onrg1j1gFadGqpFLshB1fVHDdpmy
         Kgx/aApjIF4JtaryFLpf/6BCTP1nDq9uns3+IsXBaZtguoOy+sF4qJGI5a3/+qaZqd
         Yx8bFvSqn55xYOQVkpziN+KsWdTb2QBBQQaHE5TDknjKQaUdhS+4GZSmZg4J60ft2C
         B5qE9TT0J14khkApnFFn5A6YJQ2tftT6wF2/evtWYP12X6ASoNj3UWAPPESCjtxiJC
         IZU/IlgfWdpjjSC7j3g7bgY980a4k5nnKmNk6wrDJIqHfVS3uFoID7T8YQ7bFPuCC9
         wkD2KVmDb910g==
Date:   Mon, 31 Jan 2022 09:30:00 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1.1 3/5] xfs: set prealloc flag in xfs_alloc_file_space()
Message-ID: <20220131173000.GC8313@magnolia>
References: <164351876356.4177728.10148216594418485828.stgit@magnolia>
 <20220131064350.739863-1-david@fromorbit.com>
 <20220131064350.739863-4-david@fromorbit.com>
 <20220131070226.GW59729@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131070226.GW59729@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 31, 2022 at 06:02:26PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we only call xfs_update_prealloc_flags() from
> xfs_file_fallocate() in the case where we need to set the
> preallocation flag, do this in xfs_alloc_file_space() where we
> already have the inode joined into a transaction and get
> rid of the call to xfs_update_prealloc_flags() from the fallocate
> code.
> 
> This also means that we now correctly avoid setting the
> XFS_DIFLAG_PREALLOC flag when xfs_is_always_cow_inode() is true, as
> these inodes will never have preallocated extents.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Aha, there's the @flags elision.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> V1.1
> - fix whitespace damage
> - remove redundant comments in xfs_alloc_file_space().
> 
>  fs/xfs/xfs_bmap_util.c | 9 +++------
>  fs/xfs/xfs_file.c      | 8 --------
>  2 files changed, 3 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index d4a387d3d0ce..eb2e387ba528 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -850,9 +850,6 @@ xfs_alloc_file_space(
>  			rblocks = 0;
>  		}
>  
> -		/*
> -		 * Allocate and setup the transaction.
> -		 */
>  		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
>  				dblocks, rblocks, false, &tp);
>  		if (error)
> @@ -869,9 +866,9 @@ xfs_alloc_file_space(
>  		if (error)
>  			goto error;
>  
> -		/*
> -		 * Complete the transaction
> -		 */
> +		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
> +		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +
>  		error = xfs_trans_commit(tp);
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		if (error)
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 223996822d84..ae6f5b15a023 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -908,7 +908,6 @@ xfs_file_fallocate(
>  	struct inode		*inode = file_inode(file);
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	long			error;
> -	enum xfs_prealloc_flags	flags = 0;
>  	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
>  	loff_t			new_size = 0;
>  	bool			do_file_insert = false;
> @@ -1006,8 +1005,6 @@ xfs_file_fallocate(
>  		}
>  		do_file_insert = true;
>  	} else {
> -		flags |= XFS_PREALLOC_SET;
> -
>  		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
>  		    offset + len > i_size_read(inode)) {
>  			new_size = offset + len;
> @@ -1057,11 +1054,6 @@ xfs_file_fallocate(
>  			if (error)
>  				goto out_unlock;
>  		}
> -
> -		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
> -		if (error)
> -			goto out_unlock;
> -
>  	}
>  
>  	/* Change file size if needed */
> -- 
> Dave Chinner
> david@fromorbit.com
