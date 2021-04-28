Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B73D5C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 956E16140B
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhD1ENo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 00:13:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229437AbhD1ENn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 00:13:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E9E9613E5;
        Wed, 28 Apr 2021 04:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619583179;
        bh=4v0ODsUhImwneYmIB7to314QQGOLjVFOJXeCQndZ9/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=higg9rfZUAmsKc8PLPMF3FR9VN/XMYWHaQPIsHzBfeXbwgAKepST8yw6BV4ncl/p7
         FOkAtFfjp33zxmY5aSRN58JUV6OncvKwHfGtMbxjhaOn5xBO5hdgj7f+EBNtw1Wj3w
         KHYwP27+Ai5VdvnHvTJ+cSm8mu3lY/pRRTYF2aEG9bAj0kLr7dRd4s/5/Zm6V+74Gz
         YOlZ+EYG/dDfXjBlewvGzDduiaV+PHjx6jU1jtj0+7x3PDGtscIqytrbu1ySg3xBcc
         vpzujxXVF4MyxFUL7pqRg7+gkNJS/Z6SZ45/vZYb5QzpskqCZzl98WV9t2GH6NcnHB
         bNpZ/W9mq6YQA==
Date:   Tue, 27 Apr 2021 21:12:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 3/3] xfs: set aside allocation btree blocks from block
 reservation
Message-ID: <20210428041258.GG3122264@magnolia>
References: <20210423131050.141140-1-bfoster@redhat.com>
 <20210423131050.141140-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423131050.141140-4-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 23, 2021 at 09:10:50AM -0400, Brian Foster wrote:
> The blocks used for allocation btrees (bnobt and countbt) are
> technically considered free space. This is because as free space is
> used, allocbt blocks are removed and naturally become available for
> traditional allocation. However, this means that a significant
> portion of free space may consist of in-use btree blocks if free
> space is severely fragmented.
> 
> On large filesystems with large perag reservations, this can lead to
> a rare but nasty condition where a significant amount of physical
> free space is available, but the majority of actual usable blocks
> consist of in-use allocbt blocks. We have a record of a (~12TB, 32
> AG) filesystem with multiple AGs in a state with ~2.5GB or so free
> blocks tracked across ~300 total allocbt blocks, but effectively at
> 100% full because the the free space is entirely consumed by
> refcountbt perag reservation.
> 
> Such a large perag reservation is by design on large filesystems.
> The problem is that because the free space is so fragmented, this AG
> contributes the 300 or so allocbt blocks to the global counters as
> free space. If this pattern repeats across enough AGs, the
> filesystem lands in a state where global block reservation can
> outrun physical block availability. For example, a streaming
> buffered write on the affected filesystem continues to allow delayed
> allocation beyond the point where writeback starts to fail due to
> physical block allocation failures. The expected behavior is for the
> delalloc block reservation to fail gracefully with -ENOSPC before
> physical block allocation failure is a possibility.
> 
> To address this problem, set aside in-use allocbt blocks at
> reservation time and thus ensure they cannot be reserved until truly
> available for physical allocation. This allows alloc btree metadata
> to continue to reside in free space, but dynamically adjusts
> reservation availability based on internal state. Note that the
> logic requires that the allocbt counter is fully populated at
> reservation time before it is fully effective. We currently rely on
> the mount time AGF scan in the perag reservation initialization code
> for this dependency on filesystems where it's most important (i.e.
> with active perag reservations).
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

<nod>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_mount.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index cb1e2c4702c3..bdfee1943796 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1188,6 +1188,7 @@ xfs_mod_fdblocks(
>  	int64_t			lcounter;
>  	long long		res_used;
>  	s32			batch;
> +	uint64_t		set_aside;
>  
>  	if (delta > 0) {
>  		/*
> @@ -1227,8 +1228,20 @@ xfs_mod_fdblocks(
>  	else
>  		batch = XFS_FDBLOCKS_BATCH;
>  
> +	/*
> +	 * Set aside allocbt blocks because these blocks are tracked as free
> +	 * space but not available for allocation. Technically this means that a
> +	 * single reservation cannot consume all remaining free space, but the
> +	 * ratio of allocbt blocks to usable free blocks should be rather small.
> +	 * The tradeoff without this is that filesystems that maintain high
> +	 * perag block reservations can over reserve physical block availability
> +	 * and fail physical allocation, which leads to much more serious
> +	 * problems (i.e. transaction abort, pagecache discards, etc.) than
> +	 * slightly premature -ENOSPC.
> +	 */
> +	set_aside = mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
>  	percpu_counter_add_batch(&mp->m_fdblocks, delta, batch);
> -	if (__percpu_counter_compare(&mp->m_fdblocks, mp->m_alloc_set_aside,
> +	if (__percpu_counter_compare(&mp->m_fdblocks, set_aside,
>  				     XFS_FDBLOCKS_BATCH) >= 0) {
>  		/* we had space! */
>  		return 0;
> -- 
> 2.26.3
> 
