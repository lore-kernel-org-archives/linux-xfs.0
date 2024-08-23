Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E067418594C
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 17:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724433763; cv=none; b=MnkAbbd20o6mCNGV7J+UcfeV7DTcnEOS7aG0HhzQN1SxTtuERSmKc6ddvkzT77OcJ4DL9wOROMuauRFStAm+ppPB73iqpBRNnErRdy3CJ6bwREAlxZ2iaojgtGmGwFU6tjCeqArZR4SKiq423wFQe5Z/joqK3uHGMAv0iAa0hIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724433763; c=relaxed/simple;
	bh=NAWr2Lu/cNoCBg4jX3SgFjO/yRV2aUs7KkXyZV2fRaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WUXaCDI6Q6vrRTe+VXZr2/5Wh+WOMbLV+j+7CfUGwXy1SrzDGEIkplSCkQkPjdz0pfrzzXsDYh8kobM4D1Y6EYtRU4LyhjPC9T3ot+if//nGaEk6GTJCQ4HuQIq81j6titIZYcD1xXRhtke6V+42MNCo1k9Wm4eRcckh5iGLVzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NPZwDJgK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NPZwDJgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95BAC32786;
	Fri, 23 Aug 2024 17:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724433762;
	bh=NAWr2Lu/cNoCBg4jX3SgFjO/yRV2aUs7KkXyZV2fRaI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NPZwDJgKVFVRzrkOqGVtK/kys4r8F/rjr84PEDXB1E+l4c+Gm7wnSoKQkuzHZmfqV
	 XoiPxYh829fE50stNb/L5hUIXabjuQdaSCcXdhJduAVaXm5c/l1ilbzb1b1kGX90NK
	 ZH58t0NpL0B74ZeNoCHRaVts11IHXYTQcipPbUY9NDFCQHaPQtcslP9RVJiOLmniGN
	 Sd60o5Szj8Mzh5oXWY6HnJO+UodrKpZN71IribMU02fodpsp64Wd2lZqFS5dPB8yV7
	 JIMP+n/7poFMBymL2G0Aesry1dq19uywpsl1bRNmwjSfySiu0EKwhLOaEXErcc3L0e
	 ijj0VCafOkTbg==
Date: Fri, 23 Aug 2024 10:22:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 5/5] xfs: fix a UAF when inode item push
Message-ID: <20240823172242.GI865349@frogsfrogsfrogs>
References: <20240823110439.1585041-1-leo.lilong@huawei.com>
 <20240823110439.1585041-6-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823110439.1585041-6-leo.lilong@huawei.com>

On Fri, Aug 23, 2024 at 07:04:39PM +0800, Long Li wrote:
> KASAN reported a UAF bug while fault injection test:
> 
>   ==================================================================
>   BUG: KASAN: use-after-free in xfs_inode_item_push+0x2db/0x2f0
>   Read of size 8 at addr ffff888022f74788 by task xfsaild/sda/479
> 
>   CPU: 0 PID: 479 Comm: xfsaild/sda Not tainted 6.2.0-rc7-00003-ga8a43e2eb5f6 #89
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x51/0x6a
>    print_report+0x171/0x4a6
>    kasan_report+0xb7/0x130
>    xfs_inode_item_push+0x2db/0x2f0
>    xfsaild+0x729/0x1f70
>    kthread+0x290/0x340
>    ret_from_fork+0x1f/0x30
>    </TASK>
> 
>   Allocated by task 494:
>    kasan_save_stack+0x22/0x40
>    kasan_set_track+0x25/0x30
>    __kasan_slab_alloc+0x58/0x70
>    kmem_cache_alloc+0x197/0x5d0
>    xfs_inode_item_init+0x62/0x170
>    xfs_trans_ijoin+0x15e/0x240
>    xfs_init_new_inode+0x573/0x1820
>    xfs_create+0x6a1/0x1020
>    xfs_generic_create+0x544/0x5d0
>    vfs_mkdir+0x5d0/0x980
>    do_mkdirat+0x14e/0x220
>    __x64_sys_mkdir+0x6a/0x80
>    do_syscall_64+0x39/0x80
>    entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
>   Freed by task 14:
>    kasan_save_stack+0x22/0x40
>    kasan_set_track+0x25/0x30
>    kasan_save_free_info+0x2e/0x40
>    __kasan_slab_free+0x114/0x1b0
>    kmem_cache_free+0xee/0x4e0
>    xfs_inode_free_callback+0x187/0x2a0
>    rcu_do_batch+0x317/0xce0
>    rcu_core+0x686/0xa90
>    __do_softirq+0x1b6/0x626
> 
>   The buggy address belongs to the object at ffff888022f74758
>    which belongs to the cache xfs_ili of size 200
>   The buggy address is located 48 bytes inside of
>    200-byte region [ffff888022f74758, ffff888022f74820)
> 
>   The buggy address belongs to the physical page:
>   page:ffffea00008bdd00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x22f74
>   head:ffffea00008bdd00 order:1 compound_mapcount:0 subpages_mapcount:0 compound_pincount:0
>   flags: 0x1fffff80010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
>   raw: 001fffff80010200 ffff888010ed4040 ffffea00008b2510 ffffea00008bde10
>   raw: 0000000000000000 00000000001a001a 00000001ffffffff 0000000000000000
>   page dumped because: kasan: bad access detected
> 
>   Memory state around the buggy address:
>    ffff888022f74680: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
>    ffff888022f74700: fc fc fc fc fc fc fc fc fc fc fc fa fb fb fb fb
>   >ffff888022f74780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                         ^
>    ffff888022f74800: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
>    ffff888022f74880: fc fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   ==================================================================
> 
> When push inode item in xfsaild, it will race with reclaim inodes task.
> Consider the following call graph, both tasks deal with the same inode.
> During flushing the cluster, it will enter xfs_iflush_abort() in shutdown
> conditions, inode's XFS_IFLUSHING flag will be cleared and lip->li_buf set
> to null. Concurrently, inode will be reclaimed in shutdown conditions,
> there is no need to wait xfs buf lock because of lip->li_buf is null at
> this time, inode will be freed via rcu callback if xfsaild task schedule
> out during flushing the cluster. so, it is unsafe to reference lip after
> flushing the cluster in xfs_inode_item_push().
> 
> 			<log item is in AIL>
> 			<filesystem shutdown>
> spin_lock(&ailp->ail_lock)
> xfs_inode_item_push(lip)
>   xfs_buf_trylock(bp)
>   spin_unlock(&lip->li_ailp->ail_lock)
>   xfs_iflush_cluster(bp)
>     if (xfs_is_shutdown())
>       xfs_iflush_abort(ip)
> 	xfs_trans_ail_delete(ip)
> 	  spin_lock(&ailp->ail_lock)
> 	  spin_unlock(&ailp->ail_lock)
> 	xfs_iflush_abort_clean(ip)
>       error = -EIO
> 			<log item removed from AIL>
> 			<log item li_buf set to null>
>     if (error)
>       xfs_force_shutdown()
> 	xlog_shutdown_wait(mp->m_log)
> 	  might_sleep()
> 					xfs_reclaim_inode(ip)
> 					if (shutdown)
> 					  xfs_iflush_shutdown_abort(ip)
> 					    if (!bp)
> 					      xfs_iflush_abort(ip)
> 					      return
> 				        __xfs_inode_free(ip)
> 					   call_rcu(ip, xfs_inode_free_callback)
> 			......
> 			<rcu grace period expires>
> 			<rcu free callbacks run somewhere>
> 			  xfs_inode_free_callback(ip)
> 			    kmem_cache_free(ip->i_itemp)
> 			......
> <starts running again>
>     xfs_buf_ioend_fail(bp);
>       xfs_buf_ioend(bp)
>         xfs_buf_relse(bp);
>     return error
> spin_lock(&lip->li_ailp->ail_lock)
>   <UAF on log item>
> 
> Additionally, after xfsaild_push_item(), the tracepoints can still access
> the log item, potentially causing a UAF. I've previously submitted two
> versions [1][2] attempting to solve this issue, but the solutions had
> flaws.
> 
> Fix it by returning XFS_ITEM_UNSAFE in xfs_inode_item_push() when the log
> item might be freed, ensuring xfsaild does not access the log item after
> it is pushed.
> 
> [1] https://patchwork.kernel.org/project/xfs/patch/20230211022941.GA1515023@ceph-admin/
> [2] https://patchwork.kernel.org/project/xfs/patch/20230722025721.312909-1-leo.lilong@huawei.com/
> Fixes: 90c60e164012 ("xfs: xfs_iflush() is no longer necessary")
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/xfs_inode_item.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index b509cbd191f4..c855cd2c81a5 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -720,10 +720,11 @@ STATIC uint
>  xfs_inode_item_push(
>  	struct xfs_log_item	*lip,
>  	struct list_head	*buffer_list)
> -		__releases(&lip->li_ailp->ail_lock)
> -		__acquires(&lip->li_ailp->ail_lock)
> +		__releases(&ailp->ail_lock)
> +		__acquires(&ailp->ail_lock)

I wonder, is smatch or whatever actually uses these annotations smart
enough to read through the local variable declarations below?

>  {
>  	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
> +	struct xfs_ail		*ailp = lip->li_ailp;
>  	struct xfs_inode	*ip = iip->ili_inode;
>  	struct xfs_buf		*bp = lip->li_buf;
>  	uint			rval = XFS_ITEM_SUCCESS;
> @@ -748,7 +749,7 @@ xfs_inode_item_push(
>  	if (!xfs_buf_trylock(bp))
>  		return XFS_ITEM_LOCKED;
>  
> -	spin_unlock(&lip->li_ailp->ail_lock);
> +	spin_unlock(&ailp->ail_lock);
>  
>  	/*
>  	 * We need to hold a reference for flushing the cluster buffer as it may
> @@ -762,17 +763,23 @@ xfs_inode_item_push(
>  		if (!xfs_buf_delwri_queue(bp, buffer_list))
>  			rval = XFS_ITEM_FLUSHING;
>  		xfs_buf_relse(bp);
> -	} else {
> +	} else if (error == -EAGAIN) {
>  		/*
>  		 * Release the buffer if we were unable to flush anything. On
>  		 * any other error, the buffer has already been released.
>  		 */
> -		if (error == -EAGAIN)
> -			xfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  		rval = XFS_ITEM_LOCKED;
> +	} else {
> +		/*
> +		 * The filesystem has already been shut down. If there's a race
> +		 * between inode flush and inode reclaim, the inode might be
> +		 * freed. Accessing the item after this point would be unsafe.
> +		 */
> +		rval = XFS_ITEM_UNSAFE;

I wonder if it's time to convert this to a switch statement but the fix
looks correct so

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


>  	}
>  
> -	spin_lock(&lip->li_ailp->ail_lock);
> +	spin_lock(&ailp->ail_lock);
>  	return rval;
>  }
>  
> -- 
> 2.39.2
> 
> 
