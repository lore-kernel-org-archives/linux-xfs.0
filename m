Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8438AC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 08:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60FBA61A62
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 08:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbhKSIrs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Nov 2021 03:47:48 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44078 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233326AbhKSIrs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Nov 2021 03:47:48 -0500
Date:   Fri, 19 Nov 2021 09:44:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637311486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=BtHRJz56fjI816Vn1TPP0n0DadX6sQ2/aRWzMEJXVjw=;
        b=t3jQQmhfM/qu/MU4bcBhDzuuO1HGUMNsWHaYjtinuUpYQRwrQWhVJwPE9DYvc5QyX1W7wb
        ZTQXy7VebihBaJdpVYJpziXqsdXaTYN+5D6X7I3DEfyQ2xLURRYWgcF0+k31K4cbZCtK0+
        7Ie2cFn57UkRIXsRsWFqYADUHrRKmeNv4wtIGIXBgFKYTWy3YYfYN0Rna7fNJz/A3AeP7e
        ElR6zmOBtjyGpxN4xsxUh6Lwe76AMh6J4LQ1C9wy42yFNJoadfN6JYh7G1qUKhznby2DBc
        xcKNqGY80QV05gzmlvBHx9x8KwSIW8y9A20PZ0g7EwivQZoqQ0EIzViWB+gdNQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637311486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=BtHRJz56fjI816Vn1TPP0n0DadX6sQ2/aRWzMEJXVjw=;
        b=M/LNHYHldptZ5tkswNllkxsKiZnKTGFvZ5n2szjHjkBIOEVaZuo8J9ssY2oe2Jkfn4XiSh
        2ERLWSDxpWsBcLAA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-xfs@vger.kernel.org, linux-mm@kvack.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: [LOCKDEP] Circular locking dependency detected, fs_reclaim vs
 xfs_nondir_ilock_class
Message-ID: <20211119084444.ykmkdogsjdj3vtbi@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

left my box unattended for a while and lockdep reported this:

| ======================================================
| WARNING: possible circular locking dependency detected
| 5.16.0-rc1+ #12 Not tainted
| ------------------------------------------------------
| kswapd1/510 is trying to acquire lock:
| ffff88800c98ac70 (&xfs_nondir_ilock_class){++++}-{3:3}, at: xfs_icwalk_ag+0x365/0x810
|
| but task is already holding lock:
| ffffffff82a76d60 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x4c4/0x5b0
|
| which lock already depends on the new lock.
|
|
| the existing dependency chain (in reverse order) is:
|
| -> #1 (fs_reclaim){+.+.}-{0:0}:
|        fs_reclaim_acquire+0xa1/0xd0
|        __alloc_pages+0xed/0x380
|        new_slab+0x277/0x430
|        ___slab_alloc.constprop.0+0xb6a/0xfc0
|        __slab_alloc.constprop.0+0x42/0x80
|        __kmalloc_node+0xcc/0x200
|        xfs_attr_copy_value+0x6e/0x90
|        xfs_attr_get+0xa0/0xc0
|        xfs_get_acl+0xe4/0x210
|        get_acl.part.0+0x55/0x110
|        posix_acl_xattr_get+0x6a/0x120
|        vfs_getxattr+0x172/0x1a0
|        getxattr+0xb5/0x240
|        __x64_sys_fgetxattr+0x66/0xb0
|        do_syscall_64+0x59/0x80
|        entry_SYSCALL_64_after_hwframe+0x44/0xae
|
| -> #0 (&xfs_nondir_ilock_class){++++}-{3:3}:
|        __lock_acquire+0x12cb/0x2320
|        lock_acquire+0xc9/0x2e0
|        down_write_nested+0x42/0x110
|        xfs_icwalk_ag+0x365/0x810
|        xfs_icwalk+0x38/0xa0
|        xfs_reclaim_inodes_nr+0x90/0xc0
|        super_cache_scan+0x18e/0x1f0
|        shrink_slab.constprop.0+0x1cf/0x4d0
|        shrink_node+0x1e2/0x470
|        balance_pgdat+0x26d/0x5b0
|        kswapd+0x224/0x4e0
|        kthread+0x17a/0x1a0
|        ret_from_fork+0x1f/0x30
|
| other info that might help us debug this:
|
|  Possible unsafe locking scenario:
|        CPU0                    CPU1
|        ----                    ----
|   lock(fs_reclaim);
|                                lock(&xfs_nondir_ilock_class);
|                                lock(fs_reclaim);
|   lock(&xfs_nondir_ilock_class);
|
|  *** DEADLOCK ***
|
| 3 locks held by kswapd1/510:
|  #0: ffffffff82a76d60 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x4c4/0x5b0
|  #1: ffffffff82a69d58 (shrinker_rwsem){++++}-{3:3}, at: shrink_slab.constprop.0+0x3b/0x4d0
|  #2: ffff888553ccd0e8 (&type->s_umount_key#32){++++}-{3:3}, at: super_cache_scan+0x38/0x1f0
|
| stack backtrace:
| CPU: 12 PID: 510 Comm: kswapd1 Not tainted 5.16.0-rc1+ #12
| Hardware name: Intel Corporation S2600CP/S2600CP, BIOS SE5C600.86B.02.03.0003.041920141333 04/19/2014
| Call Trace:
|  <TASK>
|  dump_stack_lvl+0x45/0x59
|  check_noncircular+0xff/0x110
|  __lock_acquire+0x12cb/0x2320
|  lock_acquire+0xc9/0x2e0
|  ? xfs_icwalk_ag+0x365/0x810
|  ? lock_is_held_type+0xd6/0x130
|  down_write_nested+0x42/0x110
|  ? xfs_icwalk_ag+0x365/0x810
|  xfs_icwalk_ag+0x365/0x810
|  xfs_icwalk+0x38/0xa0
|  xfs_reclaim_inodes_nr+0x90/0xc0
|  super_cache_scan+0x18e/0x1f0
|  shrink_slab.constprop.0+0x1cf/0x4d0
|  shrink_node+0x1e2/0x470
|  balance_pgdat+0x26d/0x5b0
|  ? lock_is_held_type+0xd6/0x130
|  kswapd+0x224/0x4e0
|  ? wait_woken+0x90/0x90
|  ? balance_pgdat+0x5b0/0x5b0
|  kthread+0x17a/0x1a0
|  ? set_kthread_struct+0x40/0x40
|  ret_from_fork+0x1f/0x30
|  </TASK>

It appears to be related to commit
   d634525db63e9 ("xfs: replace kmem_alloc_large() with kvmalloc()")

as SLUB's new_slab() has
|     return allocate_slab(s,
|            flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);

which drops the __GFP_NOLOCKDEP as used in xfs_attr_copy_value():
|     args->value = kvmalloc(valuelen, GFP_KERNEL | __GFP_NOLOCKDEP);

However I can't tell if this should happen or not I'm just pointing out
that it is.

Sebastian
