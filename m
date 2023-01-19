Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A77BFC00A5A
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Jan 2023 04:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjASE7q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 23:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjASE7S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 23:59:18 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4344E51A
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 20:52:58 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id b6so599232pgi.7
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 20:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j62/8OeG5uBY+uaMfuKtbVcz9TiZfyS9W41aQ0k/c2Q=;
        b=ldYd/bdZyPMHSKsFKqkVwi71Line7pIGoQnS0Xizcm5/QVLF9KWYAq2dhzmgkUf0ds
         4NGKtyS3sJa7URmYaAxoLY8h72UDrKVh63eYJ2yfsiHzR4VE9wKeUYhdCOHFSJCLmBw2
         KGTw1y3ZlwcjAv8jLXLAMD6WDfCg7oE/rJBMYMdG42ddt1w5vzTpCwAE/UFlLGj3Fqh3
         ngb62ooNhxk+r5geeZFMRXMf/YibMEnVCcuaB/POT1mrWt72lgk1Ke29NtGLwOZphcRt
         sRba5FXkd14Gi4JMX/qOTnmeg/fLys5DUhWNmL42M3oXviTBjeLTsPNLcz7ideXsZPsD
         ZGhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j62/8OeG5uBY+uaMfuKtbVcz9TiZfyS9W41aQ0k/c2Q=;
        b=zXLuhgnwCTBlUYr7r29vjR9t3DXWVXwpPehu2PdQs0MEeE1iwGukKRNTZFkdUKtE4e
         uq8FytDaE6aWZiHQA93Mng0UFoPaTUW1i3GUvfFHTPT7VuD1cDxb/UjWbo1g6EQyiyLk
         2oSAw/mV2izVK5B9C7BFITUwC02RZdvXOGl4PUkSijoqY/eSI4okyZeK4VJeucIgXgJT
         auY+8VYcT6AN+MeLnYGw6wMqUgbLe7oxs3dmliDMAKTliDC7ukPweqhXbqoLxQbBEGm3
         pukfS4kDBjhQbUW0ZBTz9seV0t4bdZ6fbrVTrH6Y6i15FjMDTxLN0VV9Hrg/5lLzaZKM
         hXvg==
X-Gm-Message-State: AFqh2krlI1IicWn1G5hTY78lSDzghmDBOCy0uzAg2CtML4nMg5NXsP4N
        5oEQ/F6dwBkmzMH0X+PyGxA0xA==
X-Google-Smtp-Source: AMrXdXumaCYhiE1Z6q7pFqvQQ1gjTKc6dl2nOC3ipkRF5MPkrPrjqZOB/F9rwRQj5X6V22e8KE6eRQ==
X-Received: by 2002:a05:6a00:21c9:b0:58d:f607:5300 with SMTP id t9-20020a056a0021c900b0058df6075300mr3984784pfj.8.1674103977488;
        Wed, 18 Jan 2023 20:52:57 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id 134-20020a62148c000000b0056bc30e618dsm22979484pfu.38.2023.01.18.20.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 20:52:56 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pIMuz-004okg-Lr; Thu, 19 Jan 2023 15:52:53 +1100
Date:   Thu, 19 Jan 2023 15:52:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>, kasan-dev@googlegroups.com,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: Re: Lockdep splat with xfs
Message-ID: <20230119045253.GI360264@dread.disaster.area>
References: <f9ff999a-e170-b66b-7caf-293f2b147ac2@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9ff999a-e170-b66b-7caf-293f2b147ac2@opensource.wdc.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[cc kasan list as this is a kasan bug]

On Thu, Jan 19, 2023 at 10:28:38AM +0900, Damien Le Moal wrote:
> I got the below kasan splat running on 6.2-rc3.
> 
> The machine is currently running some SMR & CMR drives benchmarks and xfs is
> used only for the rootfs (on an m.2 ssd) to log test results. So nothing special
> really exercising xfs.
> 
> My tests are still running (they take several days so I do not want to interrupt
> them) so I have not tried the latest Linus tree. Have you got reports of
> something similar ? Is that fixed already ? I did not dig into the issue :)
> 
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 6.2.0-rc3+ #1637 Not tainted
> ------------------------------------------------------
> kswapd0/177 is trying to acquire lock:
> ffff8881fe452118 (&xfs_dir_ilock_class){++++}-{3:3}, at:
> xfs_icwalk_ag+0x9d8/0x11f0 [xfs]
> 
> but task is already holding lock:
> ffffffff83b5d280 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x760/0xf90
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (fs_reclaim){+.+.}-{0:0}:
>        fs_reclaim_acquire+0x122/0x170
>        __alloc_pages+0x1b3/0x690
>        __stack_depot_save+0x3b4/0x4b0
>        kasan_save_stack+0x32/0x40
>        kasan_set_track+0x25/0x30
>        __kasan_kmalloc+0x88/0x90
>        __kmalloc_node+0x5a/0xc0
>        xfs_attr_copy_value+0xf2/0x170 [xfs]

It's a false positive, and the allocation context it comes from
in XFS is documented as needing to avoid lockdep tracking because
this path is know to trigger false positive memory reclaim recursion
reports:

        if (!args->value) {
                args->value = kvmalloc(valuelen, GFP_KERNEL | __GFP_NOLOCKDEP);
                if (!args->value)
                        return -ENOMEM;
        }
        args->valuelen = valuelen;


XFS is telling the allocator not to track this allocation with
lockdep, and that is getting passed down through the allocator which
has not passed it to lockdep (correct behaviour!), but then KASAN is
trying to track the allocation and that needs to do a memory
allocation.  __stack_depot_save() is passed the gfp mask from the
allocation context so it has __GFP_NOLOCKDEP right there, but it
does:

        if (unlikely(can_alloc && !smp_load_acquire(&next_slab_inited))) {
                /*
                 * Zero out zone modifiers, as we don't have specific zone
                 * requirements. Keep the flags related to allocation in atomic
                 * contexts and I/O.
                 */
                alloc_flags &= ~GFP_ZONEMASK;
>>>>>>>         alloc_flags &= (GFP_ATOMIC | GFP_KERNEL);
                alloc_flags |= __GFP_NOWARN;
                page = alloc_pages(alloc_flags, STACK_ALLOC_ORDER);

It masks masks out anything other than GFP_ATOMIC and GFP_KERNEL
related flags. This drops __GFP_NOLOCKDEP on the floor, hence
lockdep tracks an allocation in a context we've explicitly said not
to track. Hence lockdep (correctly!) explodes later when the
false positive "lock inode in reclaim context" situation triggers.

This is a KASAN bug. It should not be dropping __GFP_NOLOCKDEP from
the allocation context flags.

-Dave.


>        xfs_attr_get+0x36a/0x4b0 [xfs]
>        xfs_get_acl+0x1a5/0x3f0 [xfs]
>        __get_acl.part.0+0x1d5/0x2e0
>        vfs_get_acl+0x11b/0x1a0
>        do_get_acl+0x39/0x520
>        do_getxattr+0xcb/0x330
>        getxattr+0xde/0x140
>        path_getxattr+0xc1/0x140
>        do_syscall_64+0x38/0x80
>        entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> -> #0 (&xfs_dir_ilock_class){++++}-{3:3}:
>        __lock_acquire+0x2b91/0x69e0
>        lock_acquire+0x1a3/0x520
>        down_write_nested+0x9c/0x240
>        xfs_icwalk_ag+0x9d8/0x11f0 [xfs]
>        xfs_icwalk+0x4c/0xd0 [xfs]
>        xfs_reclaim_inodes_nr+0x148/0x1f0 [xfs]
>        super_cache_scan+0x3a5/0x500
>        do_shrink_slab+0x324/0x900
>        shrink_slab+0x376/0x4f0
>        shrink_node+0x80f/0x1ae0
>        balance_pgdat+0x6e2/0xf90
>        kswapd+0x312/0x9b0
>        kthread+0x29f/0x340
>        ret_from_fork+0x1f/0x30
> 
> other info that might help us debug this:
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(fs_reclaim);
>                                lock(&xfs_dir_ilock_class);
>                                lock(fs_reclaim);
>   lock(&xfs_dir_ilock_class);
> 
>  *** DEADLOCK ***
> 
> 3 locks held by kswapd0/177:
>  #0: ffffffff83b5d280 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x760/0xf90
>  #1: ffffffff83b2b8b0 (shrinker_rwsem){++++}-{3:3}, at: shrink_slab+0x237/0x4f0
>  #2: ffff8881a73cc0e0 (&type->s_umount_key#36){++++}-{3:3}, at:
> super_cache_scan+0x58/0x500
> 
> stack backtrace:
> CPU: 16 PID: 177 Comm: kswapd0 Not tainted 6.2.0-rc3+ #1637
> Hardware name: Supermicro AS -2014CS-TR/H12SSW-AN6, BIOS 2.4 02/23/2022
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x50/0x63
>  check_noncircular+0x268/0x310
>  ? print_circular_bug+0x440/0x440
>  ? check_path.constprop.0+0x24/0x50
>  ? save_trace+0x46/0xd00
>  ? add_lock_to_list+0x188/0x5a0
>  __lock_acquire+0x2b91/0x69e0
>  ? lockdep_hardirqs_on_prepare+0x410/0x410
>  lock_acquire+0x1a3/0x520
>  ? xfs_icwalk_ag+0x9d8/0x11f0 [xfs]
>  ? lock_downgrade+0x6d0/0x6d0
>  ? lock_is_held_type+0xdc/0x130
>  down_write_nested+0x9c/0x240
>  ? xfs_icwalk_ag+0x9d8/0x11f0 [xfs]
>  ? up_read+0x30/0x30
>  ? xfs_icwalk_ag+0x9d8/0x11f0 [xfs]
>  ? rcu_read_lock_sched_held+0x3f/0x70
>  ? xfs_ilock+0x252/0x2f0 [xfs]
>  xfs_icwalk_ag+0x9d8/0x11f0 [xfs]
>  ? xfs_inode_free_cowblocks+0x1f0/0x1f0 [xfs]
>  ? lock_is_held_type+0xdc/0x130
>  ? find_held_lock+0x2d/0x110
>  ? xfs_perag_get+0x2c0/0x2c0 [xfs]
>  ? rwlock_bug.part.0+0x90/0x90
>  xfs_icwalk+0x4c/0xd0 [xfs]
>  xfs_reclaim_inodes_nr+0x148/0x1f0 [xfs]
>  ? xfs_reclaim_inodes+0x1f0/0x1f0 [xfs]
>  super_cache_scan+0x3a5/0x500
>  do_shrink_slab+0x324/0x900
>  shrink_slab+0x376/0x4f0
>  ? set_shrinker_bit+0x230/0x230
>  ? mem_cgroup_calculate_protection+0x4a/0x4e0
>  shrink_node+0x80f/0x1ae0
>  balance_pgdat+0x6e2/0xf90
>  ? finish_task_switch.isra.0+0x218/0x920
>  ? shrink_node+0x1ae0/0x1ae0
>  ? lock_is_held_type+0xdc/0x130
>  kswapd+0x312/0x9b0
>  ? balance_pgdat+0xf90/0xf90
>  ? prepare_to_swait_exclusive+0x250/0x250
>  ? __kthread_parkme+0xc1/0x1f0
>  ? schedule+0x151/0x230
>  ? balance_pgdat+0xf90/0xf90
>  kthread+0x29f/0x340
>  ? kthread_complete_and_exit+0x30/0x30
>  ret_from_fork+0x1f/0x30
>  </TASK>
> 
> 
> -- 
> Damien Le Moal
> Western Digital Research
> 

-- 
Dave Chinner
david@fromorbit.com
