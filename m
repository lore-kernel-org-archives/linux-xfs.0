Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 712F9C43217
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 12:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D80C64E6B
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 12:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbhBWM6V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 07:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232688AbhBWM6G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 07:58:06 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A08AC061574
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 04:57:26 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id o6so1836093pjf.5
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 04:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=mzGSu4pk/8IMJt3/o7rc+1bvG3LclANEb4e9YKEnXm4=;
        b=P4qmLEr0RHh/qvqhDJ57Yru695p/Xk515aqZU/qzHfnru/i8N3SM3bIW/zVbNsSBfx
         4dZEDO3EE0q6ZQehkBjvcgNdR1S8eveNEKyBxKuTQAhZsz5/J7CGmDaGPsJ/ewYGhAdO
         bh0uFja/EwHLbFlTrYScqCLykN3vBvSynRzW2LwVva46gUa/1eJNzDlZJgd3I17S4LsT
         WysQnrmB9333RioaEEKn+nEb7so5HDQVozSSKWiYQQhLnzUTfObeqvQO/nanknksm4M3
         AgD46czMc2ZgrSYzVGHr8SyOxR9BArZnUeCVn2vxrULt37BpWP5Dm8e063Qzn7uEKsng
         FvkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=mzGSu4pk/8IMJt3/o7rc+1bvG3LclANEb4e9YKEnXm4=;
        b=DgCIxqojVjt4ozJwkQ/cpg1VwZ6JteCuLrQc2Ch8T2cyAF7WGOGtOD3GuAp5Wd/ezA
         Z+yvuSwAIyToNGpvEXkIlAV0yzo/rXNQ8Wp3BsCzE2KxiZ5bMWm9iP1Df0XgJnz+48WL
         XEM4FsqdIckpjnmV0kbsrDbiVTCHQTUJcdHsPwi/Yb4NoZjsfkjSaOyT2SIK7NO9SO9v
         jLUDWBGQ6hj6evanLlqeLuJO+9Dy7EWbQ37uEidlPuYVrtliFN+BPGqhKjry00aYUF/W
         sVWopPm4fCXyVrCDX59hNUtaby7mqTvboq+mN5Sdg5Xga6I2QFY/nsZ3y0MBJjJlPjjw
         8Vbg==
X-Gm-Message-State: AOAM531ZqCEW8rn5I7MR7b7vLW0FJo5uj8Yon3+JR23taw+nXni5uhdd
        /QWpHup2ibOdiQ+ru1l7jatWMoO2vk8=
X-Google-Smtp-Source: ABdhPJxs/isWiDrZj4hAay6QLguv5xw8w/sc6x8qwlOX3ZxVNci7j+mY+t+F84gEtTCwmnbtPOxDxg==
X-Received: by 2002:a17:902:d2c9:b029:e1:8692:aa7c with SMTP id n9-20020a170902d2c9b02900e18692aa7cmr2359924plc.21.1614085045268;
        Tue, 23 Feb 2021 04:57:25 -0800 (PST)
Received: from garuda ([122.171.216.250])
        by smtp.gmail.com with ESMTPSA id i15sm3378072pjl.54.2021.02.23.04.57.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Feb 2021 04:57:24 -0800 (PST)
References: <20210223033442.3267258-1-david@fromorbit.com> <20210223033442.3267258-4-david@fromorbit.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: move and rename xfs_blkdev_issue_flush
In-reply-to: <20210223033442.3267258-4-david@fromorbit.com>
Date:   Tue, 23 Feb 2021 18:27:21 +0530
Message-ID: <87ft1nlz66.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 23 Feb 2021 at 09:04, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Move it to xfs_bio_io.c as we are about to add new async cache flush
> functionality that uses bios directly, so all this stuff should be
> in the same place. Rename the function to xfs_flush_bdev() to match
> the xfs_rw_bdev() function that already exists in this file.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
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


-- 
chandan
