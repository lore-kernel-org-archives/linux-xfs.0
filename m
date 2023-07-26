Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE721C001E0
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jul 2023 04:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbjGZE2S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jul 2023 00:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbjGZE1z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jul 2023 00:27:55 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5878CA0
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jul 2023 21:27:08 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-666edfc50deso390117b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jul 2023 21:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1690345628; x=1690950428;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3zTrRTCwLPNAOa41v2QOT+JW3PwIeMs9Q16ztw+7Fpw=;
        b=mpvivOPaGAWb+COLHmkKCWGGCYgaFXK0oXtxa4gibu5ZISut5KH6cRp+5/MkUsMX0T
         aXq8ae+SXcdJVfhoV5uOdZYYZ+KgXfgBI2+FGC+MmSPzTuZcpl3KDEjRUkDkCISEz3Rr
         5Fki/Z9IH0VYLs7B9Idi8wHWaP11/1EVIHV9QQOVNSXTSjEBeEuXDLvwUOQmE6Gvu1qQ
         cMpXIIZ1VACajeWM4rD7fwJwvDJAIJFNe1WkpTfop8LSXJcrVHva7B4ElmWctwJKmyZV
         E6KxkcZVepPEK5DYG9oTjfJt5o03D/t9nDGcRhaCTHuI/xKQ4YNmNcHOi43X/FvQljgN
         8+YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690345628; x=1690950428;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3zTrRTCwLPNAOa41v2QOT+JW3PwIeMs9Q16ztw+7Fpw=;
        b=QhWKhtpfX1PfIdh9CSSiXaHC01wR5k2LFFJjvkv4izAOVsnVsraUD5nu3d3Dvh31H9
         e8YJmY887ciXWoHs6TcO4OgeIAfg6xNQtq+ghOj3m7XWeFk/ZNyeNimNPnsXmwTvvYUp
         xDs+CMB4SJDyFlGKOkz6eaBLlkRUwiHzcR9xXxQd2yJJmTbKgH5iglgyvV4SejriEoNN
         GjoYKWeRICGpJeCHVd82qp71S0c5UYPaQJ6S+Ga8dDQ+1ae4F5PhG/1LLXKqzTsqUh6r
         dSbWBN7F4/JkvsmRP2mdefF7WqxpgC3cBed5P6wR9VetOM+3karXlPavfiCVZPJrCXp/
         mPWw==
X-Gm-Message-State: ABy/qLYL2yE7SU41HqXo/PJMrPwvxcD/nvvEX3JAXQ1a45yPBsl7c7DD
        uqb80XiZaTPn0+9+SgR+NYtoSw==
X-Google-Smtp-Source: APBJJlFRI+IHOCVgjFfsbjpbgbLhwO6RxV3UivC/8J2uAVhE2jEy8BBy9R+h7dhEFkE9BYSqciIwjw==
X-Received: by 2002:a05:6a20:8e15:b0:128:ffb7:dcfe with SMTP id y21-20020a056a208e1500b00128ffb7dcfemr1353558pzj.1.1690345627767;
        Tue, 25 Jul 2023 21:27:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id p23-20020a637f57000000b0055adced9e13sm11586015pgn.0.2023.07.25.21.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 21:27:07 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qOW76-00AcBb-2S;
        Wed, 26 Jul 2023 14:27:04 +1000
Date:   Wed, 26 Jul 2023 14:27:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Long Li <leo.lilong@huawei.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org, yi.zhang@huawei.com,
        houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2] xfs: fix a UAF when inode item push
Message-ID: <ZMCgmBDM6vjVuyLV@dread.disaster.area>
References: <20230722025721.312909-1-leo.lilong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230722025721.312909-1-leo.lilong@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jul 22, 2023 at 10:57:21AM +0800, Long Li wrote:
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

Yup. It's not safe to reference the inode log item here...

> Fix the race condition by add XFS_ILOCK_SHARED lock for inode in
> xfs_inode_item_push(). The XFS_ILOCK_EXCL lock is held when the inode is
> reclaimed, so this prevents the uaf from occurring.

Having reclaim come in and free the inode after we've already
aborted and removed from the buffer isn't a problem. The inode
flushing code is designed to handle that safely.

The problem is that xfs_inode_item_push() tries to use the inode
item after the failure has occurred and we've already aborted the
inode item and finished it. i.e. the problem is this line:

	spin_lock(&lip->li_ailp->ail_lock);

because it is using the log item that has been freed to get the
ailp. We can safely store the alip at the start of the function
whilst we still hold the ail_lock.

i.e.

	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+	struct xfs_ail		*ailp = lip->li_ailp;
	struct xfs_inode        *ip = iip->ili_inode;
	struct xfs_buf          *bp = lip->li_buf;
	uint                    rval = XFS_ITEM_SUCCESS;
....

-	spin_unlock(&lip->li_ailp->ail_lock);
+	spin_unlock(&ailp->ail_lock);

.....
	} else {
		/*
		 * Release the buffer if we were unable to flush anything. On
-		 * any other error, the buffer has already been released.
+		 * any other error, the buffer has already been released and it
+		 * now unsafe to reference the inode item as a flush abort may
+		 * have removed it from the AIL and reclaim freed the inode.
		 */
		if (error == -EAGAIN)
			xfs_buf_relse(bp);
		rval = XFS_ITEM_LOCKED;
	}

-	spin_lock(&lip->li_ailp->ail_lock);
+	/* unsafe to reference anything log item related from here on. */
+	spin_lock(&ailp->ail_lock);
	return rval;

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
