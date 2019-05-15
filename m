Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47014 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729653AbfEOMHD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 May 2019 08:07:03 -0400
Date: Wed, 15 May 2019 08:07:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Linus' tree hangs in generic/530
Message-ID: <20190515120657.GA2898@bfoster>
References: <20190515063208.GA6981@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515063208.GA6981@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, May 14, 2019 at 11:32:08PM -0700, Christoph Hellwig wrote:
> When running the xfstests auto group on x86_64, 4k fs and reflink
> I get the following hang in generic/530.  Did anyone else notice it?
> 

I've seen this test take forever on older kernels without the associated
kernel fixes (the unlinked inode cache, I think), but I don't recall
seeing anything like this on for-next. I just ran a few more iterations
without any problems.

It looks like we're waiting on log reservation space for some reason,
which seems strange given that nothing else should be running at this
point of the mount.

FWIW, I'm on a smallish block device in a resource limited VM. From
530.full:

meta-data=/dev/mapper/test-scratch isize=512    agcount=4, agsize=983040 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=3932160, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
create
Opened 49997 files in 18.09s.
umount
Unmount took 1s.

Have you determined whether this is actually hung btw as opposed to
hitting some kind of sequence with pathological performance that isn't
typically hit during the test? I don't recall whether the older kernel
tests I referred to above resulted in task hung warnings or not, but I
guess it wouldn't surprise me given how long the tests seemed to take to
complete (I eventually just killed and expunged them).

Brian

> generic/530	[   41.352893] run fstests generic/530 at 2019-05-15 06:25:17
> [   41.750323] XFS (vdc): Mounting V5 Filesystem
> [   41.760564] XFS (vdc): Ending clean mount
> [   41.780058] XFS (vdc): User initiated shutdown received. Shutting down filesm
> [   41.786504] XFS (vdc): Unmounting Filesystem
> [   42.065589] XFS (vdc): Mounting V5 Filesystem
> [   42.074010] XFS (vdc): Ending clean mount
> [   45.567686] XFS (vdc): User initiated shutdown received. Shutting down filesm
> [   46.129502] XFS (vdc): Unmounting Filesystem
> [   46.630663] XFS (vdc): Mounting V5 Filesystem
> [   46.902250] XFS (vdc): Starting recovery (logdev: internal)
> [   69.622105] random: crng init done
> [   69.622587] random: 7 urandom warning(s) missed due to ratelimiting
> [  243.000576] INFO: task mount:4446 blocked for more than 120 seconds.
> [  243.004255]       Not tainted 5.1.0+ #4615
> [  243.006585] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this.
> [  243.010465] mount           D    0  4446   4228 0x00004000
> [  243.013467] Call Trace:
> [  243.014736]  ? __schedule+0x2e3/0x870
> [  243.016576]  schedule+0x28/0x90
> [  243.019076]  xlog_grant_head_wait+0x4e/0x2b0
> [  243.021715]  xlog_grant_head_check+0xeb/0x160
> [  243.024000]  xfs_log_reserve+0x10d/0x330
> [  243.025690]  ? __percpu_counter_compare+0x14/0x60
> [  243.027829]  xfs_trans_reserve+0x1a7/0x2b0
> [  243.029854]  xfs_trans_alloc+0xc7/0x1e0
> [  243.031662]  xfs_inactive_ifree+0x1a8/0x1f0
> [  243.033055]  xfs_inactive+0xf7/0x260
> [  243.034261]  xfs_fs_destroy_inode+0xcc/0x2c0
> [  243.035551]  destroy_inode+0x36/0x70
> [  243.036734]  xlog_recover_process_one_iunlink+0xeb/0x170
> [  243.038142]  xlog_recover_process_iunlinks.isra.32+0x77/0xc0
> [  243.039428]  xlog_recover_finish+0x2e/0x90
> [  243.040479]  xfs_log_mount_finish+0x5a/0x100
> [  243.041470]  xfs_mountfs+0x560/0x990
> [  243.042288]  ? xfs_mru_cache_create+0x186/0x1e0
> [  243.043139]  xfs_fs_fill_super+0x4fc/0x710
> [  243.043953]  ? xfs_test_remount_options+0x50/0x50
> [  243.044916]  mount_bdev+0x17a/0x1b0
> [  243.045693]  legacy_get_tree+0x2b/0x50
> [  243.046358]  vfs_get_tree+0x23/0xe0
> [  243.046997]  do_mount+0x2da/0xa40
> [  243.047693]  ? memdup_user+0x39/0x60
> [  243.048543]  ksys_mount+0xb1/0xd0
> [  243.049367]  __x64_sys_mount+0x1c/0x20
> [  243.050117]  do_syscall_64+0x4b/0x190
> [  243.050847]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [  243.051652] RIP: 0033:0x7fd9fb8b27fa
> [  243.052220] Code: Bad RIP value.
> [  243.052784] RSP: 002b:00007ffd46b484a8 EFLAGS: 00000202 ORIG_RAX: 00000000005
> [  243.054026] RAX: ffffffffffffffda RBX: 00005646aad78970 RCX: 00007fd9fb8b27fa
> [  243.055109] RDX: 00005646aad78b50 RSI: 00005646aad78b90 RDI: 00005646aad78b70
> [  243.056088] RBP: 0000000000000000 R08: 0000000000000000 R09: 00005646aad78b50
> [  243.057080] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 00005646aad78b70
> [  243.058081] R13: 00005646aad78b50 R14: 0000000000000000 R15: 00000000ffffffff
