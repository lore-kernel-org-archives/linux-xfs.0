Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0BA0C433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 03:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 827A9613AB
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 03:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhD0DH7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Apr 2021 23:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231363AbhD0DH6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Apr 2021 23:07:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F7C761029;
        Tue, 27 Apr 2021 03:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619492836;
        bh=JLgaURqGRzchjvMBNvb3WVtJwxvI+zWiM4RRxIh8B8A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ML0QitePTp5+LBXzNwSXFEVZKp93+k6hstcPewzSjXKvJglucViwGsNdMqHbbm1G1
         hLLEtjgnfJf2C+5Nup5w70nCg5lnI3OgEEE4RohAeOdlMumphnWrt3tZ9d15a4woTr
         qM+NmV671753bCXidS2941FWRg+7OgP/j5eAHXtFjIBStdqJT10bqFPrR5XlWRyvQk
         5dIZEmImwXRYQO3WcHeYsXIpk+EFYYfKM0LIRWIY7nIkAo4OG/Yig0hIEpC6k7ywcX
         Pey6ZNrggVztrZ4/dIWgBc8LjOQqS259czzzgHo404rhrwojhipk0U3XhhDTTNJSgb
         theBPg7ky27YA==
Date:   Mon, 26 Apr 2021 20:07:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: update superblock counters correctly for
 !lazysbcount
Message-ID: <20210427030715.GE1251862@magnolia>
References: <20210427011201.4175506-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210427011201.4175506-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 27, 2021 at 09:12:01AM +0800, Gao Xiang wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Keep the mount superblock counters up to date for !lazysbcount
> filesystems so that when we log the superblock they do not need
> updating in any way because they are already correct.
> 
> It's found by what Zorro reported:
> 1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
> 2. mount $dev $mnt
> 3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
> 4. umount $mnt
> 5. xfs_repair -n $dev
> and I've seen no problem with this patch.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reported-by: Zorro Lang <zlang@redhat.com>
> Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> 
> As per discussion earilier [1], use the way Dave suggested instead.
> Also update the line to
> 	mp->m_sb.sb_fdblocks += tp->t_fdblocks_delta + tp->t_res_fdblocks_delta;
> so it can fix the case above.
> 
> with XFS debug off, xfstests auto testcases fail on my loop-device-based
> testbed with this patch and Darrick's [2]:
> 
> generic/095 generic/300 generic/600 generic/607 xfs/073 xfs/148 xfs/273
> xfs/293 xfs/491 xfs/492 xfs/495 xfs/503 xfs/505 xfs/506 xfs/514 xfs/515

Hmm, with the following four patches applied:

https://lore.kernel.org/linux-xfs/20210427000204.GC3122264@magnolia/T/#u
https://lore.kernel.org/linux-xfs/20210425225110.GD63242@dread.disaster.area/T/#t
https://lore.kernel.org/linux-xfs/20210427011201.4175506-1-hsiangkao@redhat.com/T/#u
https://lore.kernel.org/linux-xfs/20210427030232.GE3122264@magnolia/T/#u

I /think/ all the obvious problems with !lazysbcount filesystems are
fixed.  The exceptions AFAICT are xfs/491 and xfs/492, which fuzz the
summary counters; we'll deal with those later.

--D

> 
> MKFS_OPTIONS="-mcrc=0 -llazy-count=0"
> 
> and these testcases above still fail without these patches or with
> XFS debug on, so I've seen no regression due to this patch.
> 
> [1] https://lore.kernel.org/r/20210422030102.GA63242@dread.disaster.area/
> [2] https://lore.kernel.org/r/20210425154634.GZ3122264@magnolia/
> 
>  fs/xfs/libxfs/xfs_sb.c | 16 +++++++++++++---
>  fs/xfs/xfs_trans.c     |  3 +++
>  2 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 60e6d255e5e2..dfbbcbd448c1 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -926,9 +926,19 @@ xfs_log_sb(
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_buf		*bp = xfs_trans_getsb(tp);
>  
> -	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> -	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> -	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> +	/*
> +	 * Lazy sb counters don't update the in-core superblock so do that now.
> +	 * If this is at unmount, the counters will be exactly correct, but at
> +	 * any other time they will only be ballpark correct because of
> +	 * reservations that have been taken out percpu counters. If we have an
> +	 * unclean shutdown, this will be corrected by log recovery rebuilding
> +	 * the counters from the AGF block counts.
> +	 */
> +	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> +		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> +		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> +		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> +	}
>  
>  	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index bcc978011869..1e37aa8eca5a 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -629,6 +629,9 @@ xfs_trans_unreserve_and_mod_sb(
>  
>  	/* apply remaining deltas */
>  	spin_lock(&mp->m_sb_lock);
> +	mp->m_sb.sb_fdblocks += tp->t_fdblocks_delta + tp->t_res_fdblocks_delta;
> +	mp->m_sb.sb_icount += idelta;
> +	mp->m_sb.sb_ifree += ifreedelta;
>  	mp->m_sb.sb_frextents += rtxdelta;
>  	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
>  	mp->m_sb.sb_agcount += tp->t_agcount_delta;
> -- 
> 2.27.0
> 
