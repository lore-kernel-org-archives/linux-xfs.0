Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FE6C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jan 2022 17:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380975AbiAaRZZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jan 2022 12:25:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380854AbiAaRZK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jan 2022 12:25:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E77AC061714
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jan 2022 09:25:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E177860F8A
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jan 2022 17:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4162AC340EE;
        Mon, 31 Jan 2022 17:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643649909;
        bh=w4tdnj9wiYypwRo8RiVc3l2SqW06qlikdiv/7RWu72c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=myoCqnFnFQtrZfpe/fR9MwZEfLhFuH2yJGvy1bNIOTv7IeHgyFhZs0knWcTk3HuDE
         g7K3F7sJ1jJ4KLD0T3eIpgujCzJPJNkjlMEzJjZwe1BBPoWvvvt/chGXWs09jr2vzR
         30ivzBwln2OfLHIuPBeWoYfI9qQ/BD+ZdreFNWzHH8jn5eyd5U3LeqH71klDQOIajZ
         1jN8NCUWL65xDXfB6Sjruq41fkPrTSZREZ3/jnj3XUQWC0XZSt0xMQB1qMW85Btbeu
         Sg/G3NoC+2Wk4Z3MfA6fFk+bTgO8ZDqeSmGkkj3Kq9BWwChFpndnOX1Pb8d02RID3x
         /sJhxbxbiTy1Q==
Date:   Mon, 31 Jan 2022 09:25:08 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: remove XFS_PREALLOC_SYNC
Message-ID: <20220131172508.GA8313@magnolia>
References: <164351876356.4177728.10148216594418485828.stgit@magnolia>
 <20220131064350.739863-1-david@fromorbit.com>
 <20220131064350.739863-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131064350.739863-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 31, 2022 at 05:43:46PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Callers can acheive the same thing by calling xfs_log_force_inode()
> after making their modifications. There is no need for
> xfs_update_prealloc_flags() to do this.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_file.c  | 8 +++-----
>  fs/xfs/xfs_inode.h | 3 +--
>  fs/xfs/xfs_pnfs.c  | 6 ++++--
>  3 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 22ad207bedf4..6eda41710a5a 100644
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
> @@ -1085,6 +1080,9 @@ xfs_file_fallocate(
>  	if (do_file_insert)
>  		error = xfs_insert_file_space(ip, offset, len);

This needs to handle a nonzero error case here.

The rest of the logic makes sense though.

--D

>  
> +	if (file->f_flags & O_DSYNC)
> +		error = xfs_log_force_inode(ip);
> +
>  out_unlock:
>  	xfs_iunlock(ip, iolock);
>  	return error;
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
