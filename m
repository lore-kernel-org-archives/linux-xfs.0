Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E2DC433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Jan 2022 20:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiAGUv4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 Jan 2022 15:51:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiAGUv4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jan 2022 15:51:56 -0500
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144F8C061574
        for <linux-xfs@vger.kernel.org>; Fri,  7 Jan 2022 12:51:56 -0800 (PST)
Received: by fieldses.org (Postfix, from userid 2815)
        id 4066064A6; Fri,  7 Jan 2022 15:51:55 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 4066064A6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1641588715;
        bh=GTuUKKD6hJWjcmdyEZMGI1Gz+/yuCgUHZK9aK6lJnrM=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=Fa3T9Zep/GFS5xRbBa/WVIMVTT4qaS2BsC5yH4oXVzBNfMSvCGCtV8e2z8D4PX9QT
         h5seF27j6wE/pWp/QHMNOHdgxDrnAXx7W7a9TY35u2xa+TSpZKK1TLp5bTQoczHhPt
         Yi0oJMtt8Oxqka+c1T9DA+py+bpsM2LVnIr20kMc=
Date:   Fri, 7 Jan 2022 15:51:55 -0500
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     linux-xfs@vger.kernel.org
Subject: Re: all origin/master (b2b436ec Merge tag 'trace-v5.16-rc8' of
 git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace) results
Message-ID: <20220107205155.GF26961@fieldses.org>
References: <20220107053511.013ACA07D1@home.fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220107053511.013ACA07D1@home.fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

For what it's worth: my nightly NFS test run, on upstream b2b436ec "Merge
tag 'trace-v5.16-rc8", spat this out last night.

The night before, on 75acfdb6 "Merge tag 'net-5.16-final' of
git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net", I didn't see
it.

--b.

On Fri, Jan 07, 2022 at 12:35:10AM -0500, J. Bruce Fields wrote:
> [ 7814.324263] ======================================================
> [ 7814.324765] WARNING: possible circular locking dependency detected
> [ 7814.325285] 5.16.0-rc8-00052-gb2b436ec0205 #1221 Not tainted
> [ 7814.325802] ------------------------------------------------------
> [ 7814.326383] kswapd0/74 is trying to acquire lock:
> [ 7814.326730] ffff88801a06b828 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_icwalk_ag+0x7af/0x1440
> [ 7814.327456] 
>                but task is already holding lock:
> [ 7814.327780] ffffffff85176b40 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x91e/0xad0
> [ 7814.328411] 
>                which lock already depends on the new lock.
> 
> [ 7814.328857] 
>                the existing dependency chain (in reverse order) is:
> [ 7814.329367] 
>                -> #1 (fs_reclaim){+.+.}-{0:0}:
> [ 7814.329736]        fs_reclaim_acquire+0xc0/0x100
> [ 7814.330092]        __alloc_pages+0x14f/0x560
> [ 7814.330389]        cache_alloc_refill+0x58c/0x780
> [ 7814.330762]        __kmalloc+0x1f2/0x230
> [ 7814.331026]        xfs_attr_copy_value+0xfb/0x170
> [ 7814.331365]        xfs_attr_get+0x365/0x4b0
> [ 7814.331653]        xfs_get_acl+0x1be/0x410
> [ 7814.331957]        get_acl.part.0+0xb3/0x1e0
> [ 7814.332256]        posix_acl_xattr_get+0x128/0x220
> [ 7814.332625]        vfs_getxattr+0x1db/0x220
> [ 7814.332958]        getxattr+0x100/0x2b0
> [ 7814.333248]        path_getxattr+0xba/0x120
> [ 7814.333576]        do_syscall_64+0x43/0x90
> [ 7814.333887]        entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 7814.334329] 
>                -> #0 (&xfs_dir_ilock_class){++++}-{3:3}:
> [ 7814.334744]        __lock_acquire+0x29f8/0x5b80
> [ 7814.335075]        lock_acquire+0x1a6/0x4b0
> [ 7814.335419]        down_write_nested+0x86/0x130
> [ 7814.335766]        xfs_icwalk_ag+0x7af/0x1440
> [ 7814.336071]        xfs_icwalk+0x4f/0xd0
> [ 7814.336327]        xfs_reclaim_inodes_nr+0x130/0x1c0
> [ 7814.336691]        super_cache_scan+0x3ae/0x520
> [ 7814.337034]        shrink_slab.constprop.0+0x359/0x830
> [ 7814.337531]        shrink_node+0x546/0xf20
> [ 7814.337867]        balance_pgdat+0x41a/0xad0
> [ 7814.338183]        kswapd+0x54c/0xa20
> [ 7814.338422]        kthread+0x3b1/0x490
> [ 7814.338670]        ret_from_fork+0x22/0x30
> [ 7814.338974] 
>                other info that might help us debug this:
> 
> [ 7814.339375]  Possible unsafe locking scenario:
> 
> [ 7814.339730]        CPU0                    CPU1
> [ 7814.340049]        ----                    ----
> [ 7814.340368]   lock(fs_reclaim);
> [ 7814.340558]                                lock(&xfs_dir_ilock_class);
> [ 7814.341114]                                lock(fs_reclaim);
> [ 7814.341610]   lock(&xfs_dir_ilock_class);
> [ 7814.341919] 
>                 *** DEADLOCK ***
> 
> [ 7814.342134] 3 locks held by kswapd0/74:
> [ 7814.342410]  #0: ffffffff85176b40 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x91e/0xad0
> [ 7814.343086]  #1: ffffffff85158fb0 (shrinker_rwsem){++++}-{3:3}, at: shrink_slab.constprop.0+0x71/0x830
> [ 7814.343867]  #2: ffff88800e8fc0e0 (&type->s_umount_key#48){++++}-{3:3}, at: super_cache_scan+0x53/0x520
> [ 7814.344654] 
>                stack backtrace:
> [ 7814.344837] CPU: 0 PID: 74 Comm: kswapd0 Not tainted 5.16.0-rc8-00052-gb2b436ec0205 #1221
> [ 7814.345594] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-6.fc35 04/01/2014
> [ 7814.346354] Call Trace:
> [ 7814.346478]  <TASK>
> [ 7814.346569]  dump_stack_lvl+0x45/0x59
> [ 7814.346835]  check_noncircular+0x23e/0x2e0
> [ 7814.347116]  ? print_circular_bug+0x450/0x450
> [ 7814.347420]  ? filter_irq_stacks+0x90/0x90
> [ 7814.347707]  ? check_noncircular+0x132/0x2e0
> [ 7814.348004]  ? add_lock_to_list.constprop.0+0x193/0x5b0
> [ 7814.348394]  __lock_acquire+0x29f8/0x5b80
> [ 7814.348670]  ? lockdep_hardirqs_on_prepare+0x400/0x400
> [ 7814.349054]  lock_acquire+0x1a6/0x4b0
> [ 7814.349328]  ? xfs_icwalk_ag+0x7af/0x1440
> [ 7814.349665]  ? lock_release+0x6d0/0x6d0
> [ 7814.349977]  ? lock_is_held_type+0xd7/0x130
> [ 7814.350290]  down_write_nested+0x86/0x130
> [ 7814.350563]  ? xfs_icwalk_ag+0x7af/0x1440
> [ 7814.350838]  ? rwsem_down_write_slowpath+0x10f0/0x10f0
> [ 7814.351218]  ? rcu_read_lock_sched_held+0x3f/0x70
> [ 7814.351599]  ? xfs_ilock+0x1da/0x330
> [ 7814.351835]  xfs_icwalk_ag+0x7af/0x1440
> [ 7814.352094]  ? xfs_inode_free_cowblocks+0x1e0/0x1e0
> [ 7814.352449]  ? lock_is_held_type+0xd7/0x130
> [ 7814.352741]  ? find_held_lock+0x2c/0x110
> [ 7814.353007]  ? lock_release+0x3b8/0x6d0
> [ 7814.353296]  ? xfs_perag_get_tag+0xe2/0x430
> [ 7814.353646]  ? lock_downgrade+0x690/0x690
> [ 7814.353956]  ? lock_is_held_type+0xd7/0x130
> [ 7814.354247]  ? rcu_read_lock_sched_held+0x3f/0x70
> [ 7814.354585]  ? xfs_perag_get_tag+0x279/0x430
> [ 7814.354885]  ? xfs_perag_get+0x310/0x310
> [ 7814.355149]  ? xfs_icwalk+0x83/0xd0
> [ 7814.355372]  ? rcu_read_lock_sched_held+0x3f/0x70
> [ 7814.355714]  xfs_icwalk+0x4f/0xd0
> [ 7814.355922]  xfs_reclaim_inodes_nr+0x130/0x1c0
> [ 7814.356236]  ? xfs_reclaim_inodes+0x1d0/0x1d0
> [ 7814.356543]  super_cache_scan+0x3ae/0x520
> [ 7814.356822]  shrink_slab.constprop.0+0x359/0x830
> [ 7814.357177]  ? move_pages_to_lru+0xd80/0xd80
> [ 7814.357534]  shrink_node+0x546/0xf20
> [ 7814.357781]  balance_pgdat+0x41a/0xad0
> [ 7814.358039]  ? shrink_node+0xf20/0xf20
> [ 7814.358294]  ? lock_is_held_type+0xd7/0x130
> [ 7814.358595]  ? lock_is_held_type+0xd7/0x130
> [ 7814.358921]  kswapd+0x54c/0xa20
> [ 7814.359115]  ? balance_pgdat+0xad0/0xad0
> [ 7814.359379]  ? _raw_spin_unlock_irqrestore+0x2d/0x50
> [ 7814.359845]  ? lockdep_hardirqs_on+0x79/0x100
> [ 7814.360152]  ? finish_wait+0x270/0x270
> [ 7814.360400]  ? __kthread_parkme+0xcc/0x1f0
> [ 7814.360682]  ? balance_pgdat+0xad0/0xad0
> [ 7814.360982]  kthread+0x3b1/0x490
> [ 7814.361214]  ? _raw_spin_unlock_irq+0x24/0x50
> [ 7814.361575]  ? set_kthread_struct+0x100/0x100
> [ 7814.361914]  ret_from_fork+0x22/0x30
> [ 7814.362159]  </TASK>
