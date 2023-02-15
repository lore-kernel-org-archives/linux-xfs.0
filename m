Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA0D0C636D4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 23:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjBOXzT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Feb 2023 18:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjBOXzS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Feb 2023 18:55:18 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00382004E
        for <linux-xfs@vger.kernel.org>; Wed, 15 Feb 2023 15:55:17 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id r3so368947pfh.4
        for <linux-xfs@vger.kernel.org>; Wed, 15 Feb 2023 15:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MTOEmDwNwZ4WVjGKtbstZvUi7WCVvXebpsHRCTPmkno=;
        b=A31Fma5BvPo8aGGthf75ceyJznNkxinszqJYBqEYjPBV+23DLx4NzFzSCMqfIHEnyH
         siLNX+yVew1TmXaC2P9DwwmItJRLL2WWV0Q2POyDWCSghmpMGx393psBkuboTwlKVO/z
         tT7PtLd2idv/h0/qmoMJ7vDwKn0oZYp+LKsUY6n784qubamEzAZNCUtVaClEevytQ5Ts
         brmhW6HL9BXgpyZhmoIkMX7sRkWeA9dBkyJWXq/SbYoIcZ/KZ7gVbpZJxwfW+VbFq2b6
         mBjSfsy8vHgpTx9gRie4ymRTzoDTSGPjEpjsx+f18m7BJMzJV5WedKrClkU+4ltVbhMS
         dF6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MTOEmDwNwZ4WVjGKtbstZvUi7WCVvXebpsHRCTPmkno=;
        b=FK6ixtZVHY9z9ABytFP+JnTKOs97y481Xos8QC4gTI8c6mu45Vb2ibskHG1sBIgChM
         Z6xi5ptwMfY6JOx8V9lVLP3dYugqoqrkZNzbqzRt7qX4PjiLyr374lGPXOv5U4+M5Mn9
         HyCnyYKhSkVya5/cZ8Mhwqz4akAQ3sFkG4XbHBYJuiIRhEMs1nYtlSAY+KTyqSxWoPVQ
         gHv9IvCRV7ESeHPapgQVALewDNEaef0qECMXrUJBHWcLTZkuG0KP0GfWiJ1ktdeut4ZV
         3xPd0a98mO5SYMIY0794rAlbBku1PelcR7u3vRRcPk/jNgaF5y7DJPGABZL3s3gR7rjE
         8vTg==
X-Gm-Message-State: AO0yUKXTSrRP813WiOWSW3fLAbvEDlY8MifYANVj6phMvf8+eIvNDb5x
        pFdRNkm2g56lDQmvsEzlfzSfIoyM7u2I5xbf
X-Google-Smtp-Source: AK7set9sRANZecDpXSAUtpShaGwQk70BMDZBP3RXQ+WLfEcAj+TXkn+naiAjHhJShlqCG5r/ZDdJqQ==
X-Received: by 2002:a62:17c5:0:b0:5a8:aa1d:30e9 with SMTP id 188-20020a6217c5000000b005a8aa1d30e9mr2875085pfx.18.1676505317184;
        Wed, 15 Feb 2023 15:55:17 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id i20-20020aa78b54000000b00580e3917af7sm12235920pfd.117.2023.02.15.15.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 15:55:16 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pSRcH-00Fn8h-VR; Thu, 16 Feb 2023 10:55:13 +1100
Date:   Thu, 16 Feb 2023 10:55:13 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Long Li <leo.lilong@huawei.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org, houtao1@huawei.com,
        yi.zhang@huawei.com, guoxuenan@huawei.com
Subject: Re: [PATCH] xfs: fix a UAF when inode item push
Message-ID: <20230215235513.GQ360264@dread.disaster.area>
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

This is really hard to work out the actual path here and it's much
more complex than this description implies. It took me some time to
work it out (my notes are below). In future, can you please include
the full stack context in the race descriptions?

		<log item is in AIL>

spin_lock(&ailp->ail_lock)
xfs_inode_item_push(lip)
  xfs_buf_trylock(bp)
  spin_unlock(&lip->li_ailp->ail_lock)
  xfs_iflush_cluster(bp)
    if (xfs_is_shutdown())
      skip inode
    if (no inodes flushed)
      return -EAGAIN
  if (-EAGAIN)
    xfs_buf_relse(bp)
<gets pre-empted>
					xfs_reclaim_inode(ip)
					if (shutdown)
					  xfs_iflush_shutdown_abort(ip)
					    xfs_buf_lock(bp)
					    xfs_iflush_abort(ip)
					      xfs_trans_ail_delete(ip)
					        spin_lock(&ailp->ail_lock)
					        spin_unlock(&ailp->ail_lock)
		<log item removed from AIL>
					      xfs_iflush_abort_clean(ip)
					    xfs_buf_relse(bp)
				         __xfs_inode_free(ip)
					   call_rcu(ip, xfs_inode_free_callback)
		......
		<rcu grace period expires>
		<rcu free callbacks run somewhere>
		  xfs_inode_free_callback(ip)
		    kmem_cache_free(ip->i_itemp)
		.....

<starts running again>
spin_lock(&lip->li_ailp->ail_lock)
  <UAF on log item>

This is a lot more complex than explained, and looks to me like
it requires at least CONFIG_PREEMPT=y and xfs_inode_item_push()
to be pre-empted across a RCU grace period expiry so that the log
item can be freed before the ail lock is obtained through the log
item.

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

Changing this also requires the sparse locking annotations at the
head of the function to be updated.

>  	/*
>  	 * We need to hold a reference for flushing the cluster buffer as it may

This comment also needs updating to indicate that after the buffer
is released, it is unsafe to reference the inode log item because
we can race with inode reclaim freeing the inode log item in
shutdown conditions.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
