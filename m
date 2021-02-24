Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B0AC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 20:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C50A60202
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 20:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235555AbhBXUqL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:46:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235366AbhBXUqK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Feb 2021 15:46:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF63464E09;
        Wed, 24 Feb 2021 20:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614199530;
        bh=wyZjdOSn7n/i2NPCUAxSsFtRKF9eHdWm297zhjIn150=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ODeXQoa97OpQpL6NBgVutyPWOzNNRGiXvPp1Qyg9j9nj1ocMpfJxB+pnLxV8mFQ+O
         PBoPWobqGqz7kHLy93/KQdg+KntlMM1nDoLDj14HYQEaesahMmWq+J6KoCs9EVze0i
         nAZzWwtNBLrpBTJgQpQqkLp5eHdwCG6LMia9jzw7z+QlrGms68wCgrm0iw2G1wgUS8
         vq5wf7jeySBpA65nqDILqM4OeD7dNaDdmvayf1V1Pzm94Iz69AfH6If2dIKvMI1/L2
         CNBAHfVjrOfpGrGdmUYAaeL51wUOFl9Jrx8XvLU7f1t+jsGG0qDgOn21i9IuoiSiNn
         EM7VnBDC7LkGA==
Date:   Wed, 24 Feb 2021 12:45:29 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: move and rename xfs_blkdev_issue_flush
Message-ID: <20210224204529.GS7272@magnolia>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223033442.3267258-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 02:34:37PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Move it to xfs_bio_io.c as we are about to add new async cache flush
> functionality that uses bios directly, so all this stuff should be
> in the same place. Rename the function to xfs_flush_bdev() to match
> the xfs_rw_bdev() function that already exists in this file.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I don't get why it's necessary to consolidate the synchronous flush
function with the (future) async flush, since all the sync flush callers
go through a buftarg, including the log.  All this seems to do is shift
pointer dereferencing into callers.

Why not make the async flush function take a buftarg?

--D

> ---
>  fs/xfs/xfs_bio_io.c | 8 ++++++++
>  fs/xfs/xfs_buf.c    | 2 +-
>  fs/xfs/xfs_file.c   | 6 +++---
>  fs/xfs/xfs_linux.h  | 1 +
>  fs/xfs/xfs_log.c    | 2 +-
>  fs/xfs/xfs_super.c  | 7 -------
>  fs/xfs/xfs_super.h  | 1 -
>  7 files changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
> index e2148f2d5d6b..5abf653a45d4 100644
> --- a/fs/xfs/xfs_bio_io.c
> +++ b/fs/xfs/xfs_bio_io.c
> @@ -59,3 +59,11 @@ xfs_rw_bdev(
>  		invalidate_kernel_vmap_range(data, count);
>  	return error;
>  }
> +
> +void
> +xfs_flush_bdev(
> +	struct block_device	*bdev)
> +{
> +	blkdev_issue_flush(bdev, GFP_NOFS);
> +}
> +
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f6e5235df7c9..b1d6c530c693 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1958,7 +1958,7 @@ xfs_free_buftarg(
>  	percpu_counter_destroy(&btp->bt_io_count);
>  	list_lru_destroy(&btp->bt_lru);
>  
> -	xfs_blkdev_issue_flush(btp);
> +	xfs_flush_bdev(btp->bt_bdev);
>  
>  	kmem_free(btp);
>  }
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 38528e59030e..dd33ef2d0e20 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -196,9 +196,9 @@ xfs_file_fsync(
>  	 * inode size in case of an extending write.
>  	 */
>  	if (XFS_IS_REALTIME_INODE(ip))
> -		xfs_blkdev_issue_flush(mp->m_rtdev_targp);
> +		xfs_flush_bdev(mp->m_rtdev_targp->bt_bdev);
>  	else if (mp->m_logdev_targp != mp->m_ddev_targp)
> -		xfs_blkdev_issue_flush(mp->m_ddev_targp);
> +		xfs_flush_bdev(mp->m_ddev_targp->bt_bdev);
>  
>  	/*
>  	 * Any inode that has dirty modifications in the log is pinned.  The
> @@ -218,7 +218,7 @@ xfs_file_fsync(
>  	 */
>  	if (!log_flushed && !XFS_IS_REALTIME_INODE(ip) &&
>  	    mp->m_logdev_targp == mp->m_ddev_targp)
> -		xfs_blkdev_issue_flush(mp->m_ddev_targp);
> +		xfs_flush_bdev(mp->m_ddev_targp->bt_bdev);
>  
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index af6be9b9ccdf..e94a2aeefee8 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -196,6 +196,7 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
>  
>  int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
>  		char *data, unsigned int op);
> +void xfs_flush_bdev(struct block_device *bdev);
>  
>  #define ASSERT_ALWAYS(expr)	\
>  	(likely(expr) ? (void)0 : assfail(NULL, #expr, __FILE__, __LINE__))
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index ff26fb46d70f..493454c98c6f 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2015,7 +2015,7 @@ xlog_sync(
>  	 * layer state machine for preflushes.
>  	 */
>  	if (log->l_targ != log->l_mp->m_ddev_targp || split) {
> -		xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
> +		xfs_flush_bdev(log->l_mp->m_ddev_targp->bt_bdev);
>  		need_flush = false;
>  	}
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 21b1d034aca3..85dd9593b40b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -339,13 +339,6 @@ xfs_blkdev_put(
>  		blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
>  }
>  
> -void
> -xfs_blkdev_issue_flush(
> -	xfs_buftarg_t		*buftarg)
> -{
> -	blkdev_issue_flush(buftarg->bt_bdev, GFP_NOFS);
> -}
> -
>  STATIC void
>  xfs_close_devices(
>  	struct xfs_mount	*mp)
> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> index 1ca484b8357f..79cb2dece811 100644
> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -88,7 +88,6 @@ struct block_device;
>  
>  extern void xfs_quiesce_attr(struct xfs_mount *mp);
>  extern void xfs_flush_inodes(struct xfs_mount *mp);
> -extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
>  extern xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *,
>  					   xfs_agnumber_t agcount);
>  
> -- 
> 2.28.0
> 
