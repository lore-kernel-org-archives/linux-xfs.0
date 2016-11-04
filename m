Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45105 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752083AbcKDS2W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 14:28:22 -0400
Date: Fri, 4 Nov 2016 11:28:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: XFS deadlock while running generic/019 test
Message-ID: <20161104182817.GE32036@birch.djwong.org>
References: <20161104182308.GC6650@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161104182308.GC6650@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-xfs@vger.kernel.org

On Fri, Nov 04, 2016 at 07:23:08PM +0100, Jan Kara wrote:
> Hi,
> 
> XFS has deadlocked for me while running generic/019 test on umount. The
> command is hanging in:
> 
> [ 5429.070390] INFO: task umount:224228 blocked for more than 480 seconds.
> [ 5429.088153]       Tainted: G        W       4.9.0-rc3-64-default+ #29
> [ 5429.105523] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 5429.126043] umount          D ffffffff81618c9d     0 224228 222841 0x00000000
> [ 5429.126055]  ffff881197089000 0000000000000000 ffff881168dcd2c0 ffff8817da5e0480
> [ 5429.126062]  ffff8817dd918480 ffffc90033c83d58 ffffffff81618c9d ffffffff810ad30a
> [ 5429.126073]  ffff8817dcdc0000 ffff881700000047 ffff881168dcd2c0 ffff8811a72ff840
> [ 5429.126096] Call Trace:
> [ 5429.126125]  [<ffffffff81618c9d>] ? __schedule+0x22d/0x6c0
> [ 5429.126144]  [<ffffffff810ad30a>] ? try_to_wake_up+0x4a/0x380
> [ 5429.126155]  [<ffffffff81619166>] schedule+0x36/0x80
> [ 5429.126271]  [<ffffffffa090e0dc>] xfs_ail_push_all_sync+0xac/0xf0 [xfs]
> [ 5429.126285]  [<ffffffff810c7540>] ? prepare_to_wait_event+0x110/0x110
> [ 5429.126386]  [<ffffffffa08f45c3>] xfs_unmountfs+0x73/0x1c0 [xfs]
> [ 5429.126485]  [<ffffffffa08f8ea2>] xfs_fs_put_super+0x32/0x90 [xfs]
> [ 5429.126503]  [<ffffffff81214a8f>] generic_shutdown_super+0x6f/0x100
> [ 5429.126513]  [<ffffffff81214ba7>] kill_block_super+0x27/0x70
> [ 5429.126523]  [<ffffffff812144a3>] deactivate_locked_super+0x43/0x70
> [ 5429.126533]  [<ffffffff81214516>] deactivate_super+0x46/0x60
> [ 5429.126544]  [<ffffffff81231c3f>] cleanup_mnt+0x3f/0x80
> [ 5429.126554]  [<ffffffff81231cd2>] __cleanup_mnt+0x12/0x20
> [ 5429.126565]  [<ffffffff8109fe23>] task_work_run+0x83/0xb0
> [ 5429.126575]  [<ffffffff8107c407>] exit_to_usermode_loop+0x66/0x92
> [ 5429.126586]  [<ffffffff8100391a>] syscall_return_slowpath+0x9a/0xb0
> [ 5429.126602]  [<ffffffff8161d904>] entry_SYSCALL_64_fastpath+0xa7/0xa9
> 
> In between these stuck messages, there are:
> 
> [ 5443.405374] XFS (ram1): xfs_log_force: error -5 returned.
> 
> errors. Full dmesg from the xfstest run is attached. The problem has been
> triggered on XFS mounted with 'dax' mount option over 20G ramdisks. The
> kernel is 4.9-rc3 + Ross' DAX PMD patches (latest series) + my ext4 iomap
> conversion patches.

Hmmm, I posted a patch[1] for a similar unmount hang that Dave found
via generic/388.  No idea if that'll fix this problem, but I suppose
it's worth a shot if you can get it to reproduce quickly/consistently.

(AFAIK it's still soaking in linux-next...)

--D

[1] https://www.spinics.net/lists/linux-xfs/msg01737.html

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR


