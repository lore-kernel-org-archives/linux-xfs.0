Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B6B2BEFFE
	for <linux-xfs@vger.kernel.org>; Thu, 26 Jun 2025 09:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750930257; cv=none; b=jaObjvNchHn4QArumruViPvQ8TNDjRAWyQ+e8Z3hyNpsIA4TO/fIUBQv10jfNI0WzUTEEOcBBdU5LG1JsYRIDGLIso2a7IBgV7J81BG+9AB0CMLjbQqXx2m9pH/Ae3KewQ15wUGudx2coqg76O6iUMwe6pmg68pybmj9wKu7UXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750930257; c=relaxed/simple;
	bh=iNVU8uykmx1uJ53ej3QgOEDL1LYXeSPpdZXA//Hqfkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KB/mf0diP95xdV1VfBYR2Ch2/kGYyTu9cduPkBaefnIjozvS5Qjdl9Az8Q7OcoUu6pObi7bxcdmI5H0gNwaYUF4SjEKGCFlxZdVQ8/WGaBdoanTBk63Gi1vqMH/x8N5GyaCEXrGsl/tHqDCVMg6b5WAa+7dOoLAYt73unnorvDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l0il1mb3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l0il1mb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED31C4CEEB;
	Thu, 26 Jun 2025 09:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750930257;
	bh=iNVU8uykmx1uJ53ej3QgOEDL1LYXeSPpdZXA//Hqfkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l0il1mb3x1NVckNXCJS6y/YNlJyo3GiYBo2Nj5kmn8O1x4IztvMkGS4/X9aQwEDsG
	 +AQKdR6dUz0isky81/rEG/oi/787qCM0yXl4+KYMv5w3tKdNM3IUIUSNavMYOtOH1Y
	 dcX9f5Op1PdRl7ggGzTcRbNAGHXv20Zwk4ay8jDResvyV5X40lxGRl/NVcASxJ9Cp/
	 yHggc+FeMQAOLmrAEFns5WI4A5WYLqQD99Q4ms/s+j2Vwjuhl++1z1KznpDL/J6IZ3
	 ZEEj0WatqUP5F4L12w+DsUKSTbnHsqhOelUoqozBzdzlI+za2NIEjczxNfFW1niqMs
	 YU8m4sH8emp5Q==
Date: Thu, 26 Jun 2025 11:30:53 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort
 deadlock
Message-ID: <j4ustx36oj7degphcxjoiv3doaihappefw6y7itqty5ova3jkl@um542de6ytzb>
References: <20250625224957.1436116-1-david@fromorbit.com>
 <-GZ0NZO98FBVD0afu_Z2kjhxJXeKbeeBY5HQDuPIb5M8pF27l727AC62ya69dW8fWwP07e-8sxPWSbj5kIKU9A==@protonmail.internalid>
 <20250625224957.1436116-2-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625224957.1436116-2-david@fromorbit.com>

On Thu, Jun 26, 2025 at 08:48:54AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>


Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> Lock order of xfs_ifree_cluster() is cluster buffer -> try ILOCK
> -> IFLUSHING, except for the last inode in the cluster that is
> triggering the free. In that case, the lock order is ILOCK ->
> cluster buffer -> IFLUSHING.
> 
> xfs_iflush_cluster() uses cluster buffer -> try ILOCK -> IFLUSHING,
> so this can safely run concurrently with xfs_ifree_cluster().
> 
> xfs_inode_item_precommit() uses ILOCK -> cluster buffer, but this
> cannot race with xfs_ifree_cluster() so being in a different order
> will not trigger a deadlock.
> 
> xfs_reclaim_inode() during a filesystem shutdown uses ILOCK ->
> IFLUSHING -> cluster buffer via xfs_iflush_shutdown_abort(), and
> this deadlocks against xfs_ifree_cluster() like so:
> 
>  sysrq: Show Blocked State
>  task:kworker/10:37   state:D stack:12560 pid:276182 tgid:276182 ppid:2      flags:0x00004000
>  Workqueue: xfs-inodegc/dm-3 xfs_inodegc_worker
>  Call Trace:
>   <TASK>
>   __schedule+0x650/0xb10
>   schedule+0x6d/0xf0
>   schedule_timeout+0x8b/0x180
>   schedule_timeout_uninterruptible+0x1e/0x30
>   xfs_ifree+0x326/0x730
>   xfs_inactive_ifree+0xcb/0x230
>   xfs_inactive+0x2c8/0x380
>   xfs_inodegc_worker+0xaa/0x180
>   process_scheduled_works+0x1d4/0x400
>   worker_thread+0x234/0x2e0
>   kthread+0x147/0x170
>   ret_from_fork+0x3e/0x50
>   ret_from_fork_asm+0x1a/0x30
>   </TASK>
>  task:fsync-tester    state:D stack:12160 pid:2255943 tgid:2255943 ppid:3988702 flags:0x00004006
>  Call Trace:
>   <TASK>
>   __schedule+0x650/0xb10
>   schedule+0x6d/0xf0
>   schedule_timeout+0x31/0x180
>   __down_common+0xbe/0x1f0
>   __down+0x1d/0x30
>   down+0x48/0x50
>   xfs_buf_lock+0x3d/0xe0
>   xfs_iflush_shutdown_abort+0x51/0x1e0
>   xfs_icwalk_ag+0x386/0x690
>   xfs_reclaim_inodes_nr+0x114/0x160
>   xfs_fs_free_cached_objects+0x19/0x20
>   super_cache_scan+0x17b/0x1a0
>   do_shrink_slab+0x180/0x350
>   shrink_slab+0xf8/0x430
>   drop_slab+0x97/0xf0
>   drop_caches_sysctl_handler+0x59/0xc0
>   proc_sys_call_handler+0x189/0x280
>   proc_sys_write+0x13/0x20
>   vfs_write+0x33d/0x3f0
>   ksys_write+0x7c/0xf0
>   __x64_sys_write+0x1b/0x30
>   x64_sys_call+0x271d/0x2ee0
>   do_syscall_64+0x68/0x130
>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> We can't change the lock order of xfs_ifree_cluster() - XFS_ISTALE
> and XFS_IFLUSHING are serialised through to journal IO completion
> by the cluster buffer lock being held.
> 
> There's quite a few asserts in the code that check that XFS_ISTALE
> does not occur out of sync with buffer locking (e.g. in
> xfs_iflush_cluster). There's also a dependency on the inode log item
> being removed from the buffer before XFS_IFLUSHING is cleared, also
> with asserts that trigger on this.
> 
> Further, we don't have a requirement for the inode to be locked when
> completing or aborting inode flushing because all the inode state
> updates are serialised by holding the cluster buffer lock across the
> IO to completion.
> 
> We can't check for XFS_IRECLAIM in xfs_ifree_mark_inode_stale() and
> skip the inode, because there is no guarantee that the inode will be
> reclaimed. Hence it *must* be marked XFS_ISTALE regardless of
> whether reclaim is preparing to free that inode. Similarly, we can't
> check for IFLUSHING before locking the inode because that would
> result in dirty inodes not being marked with ISTALE in the event of
> racing with XFS_IRECLAIM.
> 
> Hence we have to address this issue from the xfs_reclaim_inode()
> side. It is clear that we cannot hold the inode locked here when
> calling xfs_iflush_shutdown_abort() because it is the inode->buffer
> lock order that causes the deadlock against xfs_ifree_cluster().
> 
> Hence we need to drop the ILOCK before aborting the inode in the
> shutdown case. Once we've aborted the inode, we can grab the ILOCK
> again and then immediately reclaim it as it is now guaranteed to be
> clean.
> 
> Note that dropping the ILOCK in xfs_reclaim_inode() means that it
> can now be locked by xfs_ifree_mark_inode_stale() and seen whilst in
> this state. This is safe because we have left the XFS_IFLUSHING flag
> on the inode and so xfs_ifree_mark_inode_stale() will simply set
> XFS_ISTALE and move to the next inode. An ASSERT check in this path
> needs to be tweaked to take into account this new shutdown
> interaction.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_icache.c | 8 ++++++++
>  fs/xfs/xfs_inode.c  | 2 +-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 726e29b837e6..bbc2f2973dcc 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -979,7 +979,15 @@ xfs_reclaim_inode(
>  	 */
>  	if (xlog_is_shutdown(ip->i_mount->m_log)) {
>  		xfs_iunpin_wait(ip);
> +		/*
> +		 * Avoid a ABBA deadlock on the inode cluster buffer vs
> +		 * concurrent xfs_ifree_cluster() trying to mark the inode
> +		 * stale. We don't need the inode locked to run the flush abort
> +		 * code, but the flush abort needs to lock the cluster buffer.
> +		 */
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		xfs_iflush_shutdown_abort(ip);
> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		goto reclaim;
>  	}
>  	if (xfs_ipincount(ip))
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ee3e0f284287..761a996a857c 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1635,7 +1635,7 @@ xfs_ifree_mark_inode_stale(
>  	iip = ip->i_itemp;
>  	if (__xfs_iflags_test(ip, XFS_IFLUSHING)) {
>  		ASSERT(!list_empty(&iip->ili_item.li_bio_list));
> -		ASSERT(iip->ili_last_fields);
> +		ASSERT(iip->ili_last_fields || xlog_is_shutdown(mp->m_log));
>  		goto out_iunlock;
>  	}
> 
> --
> 2.45.2
> 
> 
