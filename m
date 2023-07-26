Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF06C001DE
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jul 2023 07:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbjGZHhI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jul 2023 03:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbjGZHgQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jul 2023 03:36:16 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A207121
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2023 00:35:22 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4R9lzp1VHSz4f3w0v
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2023 15:35:18 +0800 (CST)
Received: from localhost (unknown [10.175.127.227])
        by APP4 (Coremail) with SMTP id gCh0CgBn0LOzzMBkAhVbOw--.17378S3;
        Wed, 26 Jul 2023 15:35:17 +0800 (CST)
Date:   Wed, 26 Jul 2023 15:32:19 +0800
From:   Long Li <leo.lilong@huaweicloud.com>
To:     Dave Chinner <david@fromorbit.com>, Long Li <leo.lilong@huawei.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org, yi.zhang@huawei.com,
        houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2] xfs: fix a UAF when inode item push
Message-ID: <20230726073219.GA1050117@ceph-admin>
References: <20230722025721.312909-1-leo.lilong@huawei.com>
 <ZMCgmBDM6vjVuyLV@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZMCgmBDM6vjVuyLV@dread.disaster.area>
X-CM-TRANSID: gCh0CgBn0LOzzMBkAhVbOw--.17378S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Jw4kCFWkJw1UJrW8Xw4DCFg_yoWxKryDpF
        ZagrWxCrW8JrW7Kr48tr4UXF1Iyw4aka1DGr18Gr1UCa95Gr1YyryYyFyrur9xGrsYvrWa
        qw1UCr90vw1DJw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUglb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
        6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
        CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF
        0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3w
        CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVF
        xhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: hohrhzxlor0w46kxt4xhlfz01xgou0bp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 26, 2023 at 02:27:04PM +1000, Dave Chinner wrote:
> On Sat, Jul 22, 2023 at 10:57:21AM +0800, Long Li wrote:
> > KASAN reported a UAF bug while fault injection test:
> > 
> >   ==================================================================
> >   BUG: KASAN: use-after-free in xfs_inode_item_push+0x2db/0x2f0
> >   Read of size 8 at addr ffff888022f74788 by task xfsaild/sda/479
> > 
> >   CPU: 0 PID: 479 Comm: xfsaild/sda Not tainted 6.2.0-rc7-00003-ga8a43e2eb5f6 #89
> >   Call Trace:
> >    <TASK>
> >    dump_stack_lvl+0x51/0x6a
> >    print_report+0x171/0x4a6
> >    kasan_report+0xb7/0x130
> >    xfs_inode_item_push+0x2db/0x2f0
> >    xfsaild+0x729/0x1f70
> >    kthread+0x290/0x340
> >    ret_from_fork+0x1f/0x30
> >    </TASK>
> > 
> >   Allocated by task 494:
> >    kasan_save_stack+0x22/0x40
> >    kasan_set_track+0x25/0x30
> >    __kasan_slab_alloc+0x58/0x70
> >    kmem_cache_alloc+0x197/0x5d0
> >    xfs_inode_item_init+0x62/0x170
> >    xfs_trans_ijoin+0x15e/0x240
> >    xfs_init_new_inode+0x573/0x1820
> >    xfs_create+0x6a1/0x1020
> >    xfs_generic_create+0x544/0x5d0
> >    vfs_mkdir+0x5d0/0x980
> >    do_mkdirat+0x14e/0x220
> >    __x64_sys_mkdir+0x6a/0x80
> >    do_syscall_64+0x39/0x80
> >    entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > 
> >   Freed by task 14:
> >    kasan_save_stack+0x22/0x40
> >    kasan_set_track+0x25/0x30
> >    kasan_save_free_info+0x2e/0x40
> >    __kasan_slab_free+0x114/0x1b0
> >    kmem_cache_free+0xee/0x4e0
> >    xfs_inode_free_callback+0x187/0x2a0
> >    rcu_do_batch+0x317/0xce0
> >    rcu_core+0x686/0xa90
> >    __do_softirq+0x1b6/0x626
> > 
> >   The buggy address belongs to the object at ffff888022f74758
> >    which belongs to the cache xfs_ili of size 200
> >   The buggy address is located 48 bytes inside of
> >    200-byte region [ffff888022f74758, ffff888022f74820)
> > 
> >   The buggy address belongs to the physical page:
> >   page:ffffea00008bdd00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x22f74
> >   head:ffffea00008bdd00 order:1 compound_mapcount:0 subpages_mapcount:0 compound_pincount:0
> >   flags: 0x1fffff80010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
> >   raw: 001fffff80010200 ffff888010ed4040 ffffea00008b2510 ffffea00008bde10
> >   raw: 0000000000000000 00000000001a001a 00000001ffffffff 0000000000000000
> >   page dumped because: kasan: bad access detected
> > 
> >   Memory state around the buggy address:
> >    ffff888022f74680: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
> >    ffff888022f74700: fc fc fc fc fc fc fc fc fc fc fc fa fb fb fb fb
> >   >ffff888022f74780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >                         ^
> >    ffff888022f74800: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
> >    ffff888022f74880: fc fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >   ==================================================================
> > 
> > When push inode item in xfsaild, it will race with reclaim inodes task.
> > Consider the following call graph, both tasks deal with the same inode.
> > During flushing the cluster, it will enter xfs_iflush_abort() in shutdown
> > conditions, inode's XFS_IFLUSHING flag will be cleared and lip->li_buf set
> > to null. Concurrently, inode will be reclaimed in shutdown conditions,
> > there is no need to wait xfs buf lock because of lip->li_buf is null at
> > this time, inode will be freed via rcu callback if xfsaild task schedule
> > out during flushing the cluster. so, it is unsafe to reference lip after
> > flushing the cluster in xfs_inode_item_push().
> > 
> > 			<log item is in AIL>
> > 			<filesystem shutdown>
> > spin_lock(&ailp->ail_lock)
> > xfs_inode_item_push(lip)
> >   xfs_buf_trylock(bp)
> >   spin_unlock(&lip->li_ailp->ail_lock)
> >   xfs_iflush_cluster(bp)
> >     if (xfs_is_shutdown())
> >       xfs_iflush_abort(ip)
> > 	xfs_trans_ail_delete(ip)
> > 	  spin_lock(&ailp->ail_lock)
> > 	  spin_unlock(&ailp->ail_lock)
> > 	xfs_iflush_abort_clean(ip)
> >       error = -EIO
> > 			<log item removed from AIL>
> > 			<log item li_buf set to null>
> >     if (error)
> >       xfs_force_shutdown()
> > 	xlog_shutdown_wait(mp->m_log)
> > 	  might_sleep()
> > 					xfs_reclaim_inode(ip)
> > 					if (shutdown)
> > 					  xfs_iflush_shutdown_abort(ip)
> > 					    if (!bp)
> > 					      xfs_iflush_abort(ip)
> > 					      return
> > 				        __xfs_inode_free(ip)
> > 					   call_rcu(ip, xfs_inode_free_callback)
> > 			......
> > 			<rcu grace period expires>
> > 			<rcu free callbacks run somewhere>
> > 			  xfs_inode_free_callback(ip)
> > 			    kmem_cache_free(ip->i_itemp)
> > 			......
> > <starts running again>
> >     xfs_buf_ioend_fail(bp);
> >       xfs_buf_ioend(bp)
> >         xfs_buf_relse(bp);
> >     return error
> > spin_lock(&lip->li_ailp->ail_lock)
> >   <UAF on log item>
> 
> Yup. It's not safe to reference the inode log item here...
> 
> > Fix the race condition by add XFS_ILOCK_SHARED lock for inode in
> > xfs_inode_item_push(). The XFS_ILOCK_EXCL lock is held when the inode is
> > reclaimed, so this prevents the uaf from occurring.
> 
> Having reclaim come in and free the inode after we've already
> aborted and removed from the buffer isn't a problem. The inode
> flushing code is designed to handle that safely.
> 
> The problem is that xfs_inode_item_push() tries to use the inode
> item after the failure has occurred and we've already aborted the
> inode item and finished it. i.e. the problem is this line:
> 
> 	spin_lock(&lip->li_ailp->ail_lock);
> 
> because it is using the log item that has been freed to get the
> ailp. We can safely store the alip at the start of the function
> whilst we still hold the ail_lock.
> 

Hi Dave,

That's how I solved it in v1[1], but I found that it doesn't completely
solve the problem, because it's still possible to reference the freed
lip in xfsaild_push(). Unless we don't refer to lip in tracepoint after
xfsaild_push_item().

xfsaild_push()
  xfsaild_push_item()
    lip->li_ops->iop_push()
      xfs_inode_item_push(lip)
	xfs_iflush_cluster(bp)
				......
					xfs_reclaim_inode(ip)
					  ......
					  __xfs_inode_free(ip)
					    call_rcu(ip, xfs_inode_free_callback)
				......		
			<rcu grace period expires>
			<rcu free callbacks run somewhere>
			  xfs_inode_free_callback(ip)
			    kmem_cache_free(ip->i_itemp)
				......
  trace_xfs_ail_xxx(lip) //uaf

[1] https://patchwork.kernel.org/project/xfs/patch/20230211022941.GA1515023@ceph-admin/

Thanks

Long Li

> i.e.
> 
> 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
> +	struct xfs_ail		*ailp = lip->li_ailp;
> 	struct xfs_inode        *ip = iip->ili_inode;
> 	struct xfs_buf          *bp = lip->li_buf;
> 	uint                    rval = XFS_ITEM_SUCCESS;
> ....
> 
> -	spin_unlock(&lip->li_ailp->ail_lock);
> +	spin_unlock(&ailp->ail_lock);
> 
> .....
> 	} else {
> 		/*
> 		 * Release the buffer if we were unable to flush anything. On
> -		 * any other error, the buffer has already been released.
> +		 * any other error, the buffer has already been released and it
> +		 * now unsafe to reference the inode item as a flush abort may
> +		 * have removed it from the AIL and reclaim freed the inode.
> 		 */
> 		if (error == -EAGAIN)
> 			xfs_buf_relse(bp);
> 		rval = XFS_ITEM_LOCKED;
> 	}
> 
> -	spin_lock(&lip->li_ailp->ail_lock);
> +	/* unsafe to reference anything log item related from here on. */
> +	spin_lock(&ailp->ail_lock);
> 	return rval;
> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com

