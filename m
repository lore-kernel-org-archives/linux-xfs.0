Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24736 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751316AbdARNtm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Jan 2017 08:49:42 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 77770FAF23
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2017 13:48:55 +0000 (UTC)
Date: Wed, 18 Jan 2017 08:48:54 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [BUG] generic/232 hangs on XFS DAX mount
Message-ID: <20170118134853.GA1569@bfoster.bfoster>
References: <20170118074628.GP1859@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170118074628.GP1859@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 18, 2017 at 03:46:28PM +0800, Eryu Guan wrote:
> Hi all,
> 
> I hit a generic/232 hang on XFS DAX mount, kernel is 4.10-rc4, 4.9
> kernel also could reproduce, so at least it's not a 4.10 regression. I
> haven't tested other kernel versions yet.
> 
> I reproduced it by running generic/232 in a tight loop, it usually hangs
> within 50 iterations. test dev is 15G brd ramdisk.
> 
> I append detailed host info and test config at the end. If you need more
> info please let me know.
> 

FYI, this doesn't appear to be related to DAX. I could reproduce on a
current kernel using defaults on a ramdisk. I also saw the following
assert before the hang:

[  935.549559] XFS: Assertion failed: !(bp->b_flags & _XBF_DELWRI_Q), file: fs/xfs/xfs_buf.c, line: 1010
[  935.558779] ------------[ cut here ]------------
[  935.563516] WARNING: CPU: 7 PID: 29192 at fs/xfs/xfs_message.c:105 asswarn+0x31/0x40 [xfs]
[  935.571778] Modules linked in: xfs brd ip6t_REJECT nf_reject_ipv6 xt_conntrack ip6t_rpfilter ip_set nfnetlink ebtable_broute bridge stp llc ebtable_nat ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_e
[  935.642928] CPU: 7 PID: 29192 Comm: 232 Not tainted 4.10.0-rc4 #3
[  935.649005] Hardware name: Dell Inc. PowerEdge R715/0G2DP3, BIOS 2.3.0 10/18/2011
[  935.656468] Call Trace:
[  935.658912]  dump_stack+0x63/0x86
[  935.662217]  __warn+0xcb/0xf0
[  935.665210]  ? xfs_buftarg_shrink_scan+0x8d/0xc0 [xfs]
[  935.670335]  warn_slowpath_null+0x1d/0x20
[  935.674365]  asswarn+0x31/0x40 [xfs]
[  935.677962]  xfs_buf_rele+0x399/0x3e0 [xfs]
[  935.682163]  xfs_buftarg_shrink_scan+0x8d/0xc0 [xfs]
[  935.687117]  shrink_slab.part.40+0x1f5/0x420
[  935.691376]  shrink_slab+0x29/0x30
[  935.694768]  drop_slab_node+0x31/0x60
[  935.698419]  drop_slab+0x3f/0x70
[  935.701638]  drop_caches_sysctl_handler+0x71/0xc0
[  935.706329]  proc_sys_call_handler+0xea/0x110
[  935.710675]  proc_sys_write+0x14/0x20
[  935.714327]  __vfs_write+0x37/0x160
[  935.717806]  ? selinux_file_permission+0xd7/0x110
[  935.722499]  ? security_file_permission+0x3b/0xc0
[  935.727192]  vfs_write+0xb5/0x1a0
[  935.730496]  SyS_write+0x55/0xc0
[  935.733717]  entry_SYSCALL_64_fastpath+0x1a/0xa9
[  935.738322] RIP: 0033:0x7f5351f92c20
[  935.741888] RSP: 002b:00007fff469bc9a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  935.749440] RAX: ffffffffffffffda RBX: 00007f535225c5e0 RCX: 00007f5351f92c20
[  935.756559] RDX: 0000000000000002 RSI: 000055e935a2ba90 RDI: 0000000000000001
[  935.763677] RBP: 0000000000000001 R08: 00007f535225d740 R09: 00007f53528aa700
[  935.770794] R10: 0000000000000073 R11: 0000000000000246 R12: 000055e935c14780
[  935.777912] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
[  935.785072] ---[ end trace 43d9a50105018845 ]---

... which suggests we've freed a buffer while on a delwri submit queue
(presumably via an AIL push). Indeed, after the fact tracing shows the
AIL spinning on some flush locked dquots.

The problem didn't reproduce with the drop_caches removed from
_check_quota_usage() in xfstests/common/quota. It's possible for that to
be a false negative, but otherwise I'd suspect we have some kind of a
buffer tracking problem between LRU reclaim (i.e., the above shrinker)
and the AIL which results in the flush lock being acquired and never
released (I/O asociated w/ flush never submitted perhaps?). The
quotactl() call below is probably stuck waiting on the flush lock as a
result.

Brian

> Thanks,
> Eryu
> 
> TEST_DEV=/dev/ram0
> SCRATCH_DEV=/dev/ram1
> TEST_DIR=/mnt/test
> SCRATCH_MNT=/mnt/scratch
> MKFS_OPTIONS="-f -m crc=1 -b size=4k"
> MOUNT_OPTIONS="-o dax"
> 
> [ 4489.611370] sysrq: SysRq : Show Blocked State
> [ 4489.632865]   task                        PC stack   pid father
> [ 4489.661722] xfs_quota       D    0 30771  30468 0x00000080
> [ 4489.689072] Call Trace:
> [ 4489.701239]  __schedule+0x21c/0x6b0
> [ 4489.717525]  ? __free_pages+0x19/0x30
> [ 4489.734712]  schedule+0x36/0x80
> [ 4489.749458]  schedule_timeout+0x21c/0x3a0
> [ 4489.768249]  ? __slab_free+0x9b/0x2c0
> [ 4489.785477]  wait_for_completion+0x11c/0x180
> [ 4489.805688]  ? wake_up_q+0x80/0x80
> [ 4489.821670]  xfs_qm_dqpurge+0x6b/0x1b0 [xfs]
> [ 4489.841764]  ? xfs_qm_need_dqattach+0x80/0x80 [xfs]
> [ 4489.864823]  xfs_qm_dquot_walk.isra.10+0xfb/0x190 [xfs]
> [ 4489.889610]  xfs_qm_dqpurge_all+0x5c/0x80 [xfs]
> [ 4489.910959]  xfs_qm_scall_quotaoff+0x127/0x380 [xfs]
> [ 4489.934407]  xfs_quota_disable+0x3d/0x50 [xfs]
> [ 4489.955286]  SyS_quotactl+0x391/0x850
> [ 4489.972522]  ? __audit_syscall_entry+0xaf/0x100
> [ 4489.993523]  ? syscall_trace_enter+0x1d0/0x2b0
> [ 4490.014486]  ? __audit_syscall_exit+0x209/0x290
> [ 4490.035763]  do_syscall_64+0x67/0x180
> [ 4490.053266]  entry_SYSCALL64_slow_path+0x25/0x25
> [ 4490.074955] RIP: 0033:0x7eff755e2fea
> [ 4490.091854] RSP: 002b:00007ffe012179d8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b3
> [ 4490.127517] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007eff755e2fea
> [ 4490.162364] RDX: 0000000000000000 RSI: 00000000012ee2f0 RDI: 0000000000580200
> [ 4490.196833] RBP: 00000000012ee310 R08: 00007ffe012179ec R09: 0000000000000000
> [ 4490.231139] R10: 00007ffe012179ec R11: 0000000000000206 R12: 00000000012ee2d0
> [ 4490.264475] R13: 00000000012ed0a0 R14: 0000000000000000 R15: 00000000012ed080
> 
> [root@hp-dl360g9-15 xfstests]# lscpu
> Architecture:          x86_64
> CPU op-mode(s):        32-bit, 64-bit
> Byte Order:            Little Endian
> CPU(s):                16
> On-line CPU(s) list:   0-15
> Thread(s) per core:    1
> Core(s) per socket:    8
> Socket(s):             2
> NUMA node(s):          2
> Vendor ID:             GenuineIntel
> CPU family:            6
> Model:                 63
> Model name:            Intel(R) Xeon(R) CPU E5-2630 v3 @ 2.40GHz
> Stepping:              2
> CPU MHz:               2400.000
> BogoMIPS:              4801.94
> Virtualization:        VT-x
> L1d cache:             32K
> L1i cache:             32K
> L2 cache:              256K
> L3 cache:              20480K
> NUMA node0 CPU(s):     0-3,8-11
> NUMA node1 CPU(s):     4-7,12-15
> [root@hp-dl360g9-15 xfstests]# free -m
>               total        used        free      shared  buff/cache   available
> Mem:          64305         761       63382           9         161       63071
> Swap:         16379           0       16379
> [root@hp-dl360g9-15 xfstests]# uname -a
> Linux hp-dl360g9-15 4.10.0-rc4 #18 SMP Wed Jan 18 11:39:05 CST 2017 x86_64 x86_64 x86_64 GNU/Linux
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
