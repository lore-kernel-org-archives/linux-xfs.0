Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E76F6C636CC
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 05:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjBOFUe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Feb 2023 00:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjBOFUd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Feb 2023 00:20:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B99B32528
        for <linux-xfs@vger.kernel.org>; Tue, 14 Feb 2023 21:20:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14922B81F95
        for <linux-xfs@vger.kernel.org>; Wed, 15 Feb 2023 05:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF615C433D2;
        Wed, 15 Feb 2023 05:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676438429;
        bh=IEIXbnUFFp63/OyCLqY0iBy3djJWuCSsyB2ZVFqwQ3g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fon0Nmon27ZmKiOck/Haryf7zlunmES0xCBrO7G8oNrDm614asXJulKSv/07T9wgv
         NdEAmVqF0kALRK1JtEFj4iSvtU3EQNw2yzg2WaA9OUUDwWrTCa+/Uvscw0ABm+b7Wx
         N9WL3gFn95YrypDUpL7R/wTfaNPy3FwT1WxFnVyLzPNdp2kAUMwNchurW4hPp65Snb
         2eQ8kxOZMNjl2nfr7Ndc57HMMUmzkxwXi8DV6uPb5VsiI8KT7tTTSR/Uz5cWfVQZVE
         1MU6NSI1E8gm/DM+4Y1RQur0bA80sfvGMA9dFogXjIiSyBlcO/O4XYqk1K4Ak5+6/t
         GAY9/zQqGUrbA==
Date:   Tue, 14 Feb 2023 21:20:29 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Long Li <leo.lilong@huawei.com>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org, houtao1@huawei.com,
        yi.zhang@huawei.com, guoxuenan@huawei.com
Subject: Re: [PATCH] xfs: fix a UAF when inode item push
Message-ID: <Y+xrnVi2KiHldi3P@magnolia>
References: <20230211022941.GA1515023@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230211022941.GA1515023@ceph-admin>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 11, 2023 at 10:29:41AM +0800, Long Li wrote:
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
> When reclaim inodes, it will race with inode item push if log is shutdown.
> Consider the following call graph, xfs_inode and xfs_inode_log_item may
> be freed after release bp, threefore, the lip cannot be accessed after this.
> 
>   CPU0					CPU1
>   xfs_inode_item_push			xfs_reclaim_inode
>   -------------------			-----------------
>   xfs_buf_trylock(bp)
>   spin_unlock(&lip->li_ailp->ail_lock)
>   xfs_buf_relse(bp)
>   					xfs_buf_lock(bp)
>   					spin_lock(&ailp->ail_lock)
>   					spin_unlock(&ailp->ail_lock)
>   					xfs_buf_relse(bp)
> 					__xfs_inode_free(ip)
>   spin_lock(&lip->li_ailp->ail_lock)
> 
> Fixes: 90c60e164012 ("xfs: xfs_iflush() is no longer necessary")
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/xfs_inode_item.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index ca2941ab6cbc..52895e51fac5 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -545,6 +545,7 @@ xfs_inode_item_push(
>  	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
>  	struct xfs_inode	*ip = iip->ili_inode;
>  	struct xfs_buf		*bp = lip->li_buf;
> +	struct xfs_ail		*ailp = lip->li_ailp;
>  	uint			rval = XFS_ITEM_SUCCESS;
>  	int			error;
>  
> @@ -567,7 +568,7 @@ xfs_inode_item_push(
>  	if (!xfs_buf_trylock(bp))
>  		return XFS_ITEM_LOCKED;
>  
> -	spin_unlock(&lip->li_ailp->ail_lock);
> +	spin_unlock(&ailp->ail_lock);
>  
>  	/*
>  	 * We need to hold a reference for flushing the cluster buffer as it may
> @@ -591,7 +592,7 @@ xfs_inode_item_push(
>  		rval = XFS_ITEM_LOCKED;
>  	}
>  
> -	spin_lock(&lip->li_ailp->ail_lock);
> +	spin_lock(&ailp->ail_lock);

So what you're saying here is that once we release the buffer, it's
possible that the log item can get released too?  And now the spin_lock
call walks off the (now released) log item?

Do dquot log items suffer from the same problem?

--D

>  	return rval;
>  }
>  
> -- 
> 2.31.1
> 
