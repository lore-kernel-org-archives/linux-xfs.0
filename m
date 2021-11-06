Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA14DC433EF
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Nov 2021 02:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DA586103B
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Nov 2021 02:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhKFCNN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Nov 2021 22:13:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231734AbhKFCNM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Nov 2021 22:13:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D950360F93;
        Sat,  6 Nov 2021 02:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636164631;
        bh=iLRSrjyVhB42cUuS2zTaWSBB9ULzAF/3Hy29h/SYlPM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kPN5xJOaxByq4E3858kxYP3AtmrcPpCRN8b2y7ceYXGOITg0TdReIiLc5+2qjMgnF
         D/j6fcJzrz/IpZQLggEnt5pm+ENGPOFEJDVpmCFA/GKn8/kwaWtnRcFJ8EdnI95kkr
         /FN+PZ0npcIY9CF4MR9BF4lBBkPfJt2refAapw+TaiqhZzPp3xFtyDbSU5pE/5jvZO
         EApFAcZdfhhEEnz6M7s8CGJBWSn7ots6yh4YE1ZGR0b6vjHGXGIBCXvJ5dqRpCmV5M
         iFc5f4mXIJLrR73/RUI9N/HuL9QCyZVMkvO/WwIXWxYqOPf8giNWJrTaGNBovM7eqv
         eKCQHEWVjvKEA==
Date:   Fri, 5 Nov 2021 19:10:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-xfs@vger.kernel.org, leah.rumancik@gmail.com
Subject: Re: soft lockup in xfs/170 on a file system formatted with -m crc=0
Message-ID: <20211106021031.GV24307@magnolia>
References: <YYVo8ZyKpy4Di0pK@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYVo8ZyKpy4Di0pK@mit.edu>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 05, 2021 at 01:25:05PM -0400, Theodore Ts'o wrote:
> Is this a known failure?  I can reliably reproduce this soft lockup
> running xfs/170 using "gce-xfstests -c xfs/v4 xfs/170" using
> v5.15-rc4.  The xfs/v4 test config formats the file system using -m
> crc=0 with no special mount options.
> 
> I've attached the kernel config that I used; it's the standard one
> obtained via "gce-xfstests install-kconfig"[1].

Is the system totally idle, or is it still pounding the storage?  The
softlockup looks like we're stuck trying to lock an AGF buffer, which
could just be the result of a long(ish) stall due to other threads or
the log or something else.

I guess "3h6m10s" implies it just died for 3+ hours.

Also, uh... 5.15 didn't prove to be a stable testing base (at least not
without a bunch of other patches to kvm, the memory manager, and the
block layer) until 5.15-rc7.

--D

> 
> 
> [1] https://github.com/tytso/xfstests-bld/blob/master/kvm-xfstests/util/install-kconfig
> 
> Thanks,
> 
> 					- Ted
> 
> commit adac31869b098d5f85d0930874dcf6a524d128d3
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Fri Nov 5 13:10:35 2021 -0400
> 
>     test-appliance: add xfs/170 to xfs/v4's exclude file
>     
>     The xfs/170 test is reliably causing a soft lockup when run on a file
>     system formatted with mkfs.xfs -m crc=0.
>     
>             CONFIG: xfs/v4
>             ZONE:   us-east1-b
>             VM STATUS:      timeout on one test (xfs/170)
>             SINCE LAST UPDATE:      3h6m10s
>             TEST STATUS:    hang
>     
>     run fstests xfs/170 at 2021-11-05 02:27:05
>     ...
>     [11024.269799] XFS (dm-1): Unmounting Filesystem
>     [11024.695394] XFS (dm-1): Mounting V4 Filesystem
>     [11024.731406] XFS (dm-1): Ending clean mount
>     [11024.731552] xfs filesystem being mounted at /xt-vdc supports timestamps until 2038 (0x7fffffff)
>     watchdog: BUG: soft lockup - CPU#1 stuck for 26s! [dd:9671]
>     irq event stamp: 22146924
>     hardirqs last  enabled at (22146923): [<ffffffff903cebad>] _raw_spin_unlock_irqrestore+0x2d/0x40
>     hardirqs last disabled at (22146924): [<ffffffff903bd4fb>] sysvec_apic_timer_interrupt+0xb/0x90
>     softirqs last  enabled at (16886422): [<ffffffff906002ce>] __do_softirq+0x2ce/0x3fd
>     softirqs last disabled at (16886399): [<ffffffff8f6bc1e8>] __irq_exit_rcu+0x88/0xb0
>     CPU: 1 PID: 9671 Comm: dd Not tainted 5.15.0-rc4-xfstests-00018-g124e7c61deb2 #382
>     Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>     RIP: 0010:_raw_spin_unlock_irqrestore+0x35/0x40
>     Code: c7 18 53 48 89 f3 48 8b 74 24 10 e8 e5 3b 35 ff 48 89 ef e8 dd 66 35 ff 80 e7 02 74 06 e8 f3 77 3e ff fb 65 ff 0d 4b 82 c4 6f <5b> 5d c3 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 54 65 ff 05 32
>     RSP: 0018:ffffa055c2913598 EFLAGS: 00000246
>     RAX: 000000000151ef6b RBX: 0000000000000282 RCX: 0000000000000040
>     RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff903cebad
>     RBP: ffff945d3aff4be0 R08: 0000000000000001 R09: 0000000000000001
>     R10: 0000000000000000 R11: 0000000000080000 R12: 0000000000000000
>     R13: ffffa055c2913640 R14: ffff945d13892a10 R15: ffff945d13892a58
>     FS:  00007f62407d8580(0000) GS:ffff945dd9400000(0000) knlGS:0000000000000000
>     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>     CR2: 00007f6240613000 CR3: 000000014bc04004 CR4: 00000000003706e0
>     DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>     DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>     Call Trace:
>      down_trylock+0x25/0x30
>      xfs_buf_trylock+0x17/0x190
>      xfs_buf_find+0x1b3/0x4a0
>      xfs_buf_get_map+0x44/0x3a0
>      xfs_buf_read_map+0x52/0x2e0
>      ? xfs_read_agf+0xa3/0x180
>      xfs_trans_read_buf_map+0x144/0x430
>      ? xfs_read_agf+0xa3/0x180
>      ? __lock_acquire+0x3a7/0x6c0
>      xfs_read_agf+0xa3/0x180
>      xfs_alloc_read_agf+0x4c/0x110
>      xfs_alloc_pagf_init+0x27/0x60
>      xfs_filestream_pick_ag+0x280/0x530
>      xfs_filestream_new_ag+0x87/0x100
>      xfs_bmap_btalloc_filestreams.constprop.0+0xe0/0x120
>      xfs_bmap_btalloc+0x3e6/0x700
>      xfs_bmapi_allocate+0xe4/0x310
>      xfs_bmapi_write+0x42a/0x580
>      xfs_iomap_write_direct+0x18d/0x210
>      xfs_direct_write_iomap_begin+0x3ab/0x690
>      ? lock_is_held_type+0x98/0x100
>      iomap_iter+0x12b/0x240
>      __iomap_dio_rw+0x1ff/0x630
>      iomap_dio_rw+0xa/0x30
>      xfs_file_dio_write_aligned+0xae/0x1c0
>      xfs_file_write_iter+0xd8/0x130
>      new_sync_write+0x122/0x1b0
>      ? mod_objcg_state+0x180/0x2a0
>      vfs_write+0x25d/0x370
>      ksys_write+0x68/0xe0
>      do_syscall_64+0x3b/0x90
>      entry_SYSCALL_64_after_hwframe+0x44/0xae
>     RIP: 0033:0x7f6240700504
>     Code: 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f 80 00 00 00 00 48 8d 05 f9 61 0d 00 8b 00 85 c0 75 13 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 41 54 49 89 d4 55 48 89 f5 53
>     RSP: 002b:00007ffdac48f148 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
>     RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6240700504
>     RDX: 0000000000100000 RSI: 00007f6240514000 RDI: 0000000000000001
>     RBP: 0000000000100000 R08: 00000000ffffffff R09: 0000000000000000
>     R10: ffffffffffffff3b R11: 0000000000000246 R12: 00007f6240514000
>     R13: 0000000000000000 R14: 0000000000000000 R15: 00007f6240514000
>     
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> diff --git a/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/v4.exclude b/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/v4.exclude
> index a9acba9c..83ccfd79 100644
> --- a/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/v4.exclude
> +++ b/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/v4.exclude
> @@ -1,2 +1,16 @@
>  # Normal configurations don't support dax
>  -g dax
> +
> +# On a 5.15-rc4 kernel, xfs/170 reliably causes a soft lockup in
> +# xfs_alloc_read_agf()+0x41/0x110.  Call stack:
> +#
> +# xfs_alloc_pagf_init+0x27/0x60
> +# xfs_filestream_pick_ag+0x280/0x530
> +# xfs_filestream_new_ag+0x87/0x100
> +# xfs_bmap_btalloc_filestreams.constprop.0+0xe0/0x120
> +# xfs_bmap_btalloc+0x3e6/0x700
> +# xfs_bmapi_allocate+0xe4/0x310
> +# xfs_bmapi_convert_delalloc+0x26c/0x480
> +# xfs_map_blocks+0x1b5/0x510
> +# ...
> +xfs/170


