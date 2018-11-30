Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54702 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbeK3S35 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Nov 2018 13:29:57 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A6F632FD10
        for <linux-xfs@vger.kernel.org>; Fri, 30 Nov 2018 07:21:36 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201819] New: [xfstests generic/299]: WARNING: CPU: 15 PID:
 23147 at kernel/workqueue.c:4170 destroy_workqueue+0x118/0x590
Date: Fri, 30 Nov 2018 07:21:36 +0000
Message-ID: <bug-201819-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201819

            Bug ID: 201819
           Summary: [xfstests generic/299]: WARNING: CPU: 15 PID: 23147 at
                    kernel/workqueue.c:4170 destroy_workqueue+0x118/0x590
           Product: File System
           Version: 2.5
    Kernel Version: xfs-4.20-fixes-2
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zlang@redhat.com
        Regression: No

xfstests g/299 hit a kernel warning on xfs-linux git tree
(HEAD=xfs-4.20-fixes-2). It's not 100% reproducible, but it's reproducible.
I've hit it twice. Need to run g/299 many times.


FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 xxxx 4.20.0-rc1
MKFS_OPTIONS  -- -f -b size=2048 -m reflink=1,rmapbt=1
/dev/mapper/xxxx-xfscratch
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0
/dev/mapper/xxxx--10-xfscratch /mnt/scratch

generic/299 261s ... _check_dmesg: something found in dmesg (see
/root/git/xfstests-dev/results//generic/299.dmesg)

Ran: generic/299
Failures: generic/299
Failed 1 of 1 tests

[169599.199807] run fstests generic/299 at 2018-11-28 02:52:27
[169600.274921] XFS (dm-3): Unmounting Filesystem
[169604.455628] XFS (dm-3): Mounting V5 Filesystem
[169604.530688] XFS (dm-3): Ending clean mount
[169834.809118] XFS (dm-3): Unmounting Filesystem
[169835.490822] WARNING: CPU: 15 PID: 23147 at kernel/workqueue.c:4170
destroy_workqueue+0x118/0x590
[169835.500736] Modules linked in: sunrpc intel_rapl sb_edac
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel intel_cst
ate iTCO_wdt intel_uncore ipmi_ssif iTCO_vendor_support rndis_host cdc_ether
usbnet sg ipmi_si mii pcspkr intel_rapl_perf ioatdma i2c_i801 ipmi_devintf
lpc_ich ipmi_msghandler xfs libcrc32c s
d_mod mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm
wmi drm igb crc32c_intel megaraid_sas dca i2c_algo_bit dm_mirror dm_region_hash
dm_log dm_mod
[169835.554726] CPU: 15 PID: 23147 Comm: umount Tainted: G        W        
4.20.0-rc1 #1
[169835.563565] Hardware name: IBM System x3650 M4 -[7915ON3]-/00J6520, BIOS
-[VVE124AUS-1.30]- 11/21/2012
[169835.574053] RIP: 0010:destroy_workqueue+0x118/0x590
[169835.579596] Code: b5 20 01 00 00 74 71 49 8d 7e 18 48 89 f8 48 c1 e8 03 42
0f b6 04 38 84 c0 74 08 3c 03 0f 8e 01 04 00 00 41 83 7e 18 01 7e 4e <0f> 0b eb
aa e8 9f 8b 12 00 85 c0 0f 85 61 ff ff ff 48 8d bd 90 00
[169835.600662] RSP: 0018:ffff88012d757d48 EFLAGS: 00010202
[169835.606585] RAX: 0000000000000000 RBX: ffffe8fd73c46458 RCX:
0000000000000000
[169835.614647] RDX: 0000000000000000 RSI: ffffe8fd73c46458 RDI:
ffffe8fd73c46418
[169835.622710] RBP: ffff8801dd73aa80 R08: ffffed003d83daf8 R09:
ffffed003d83daf7
[169835.630773] R10: ffffed003d83daf7 R11: ffff8801ec1ed7bb R12:
ffffed003bae7574
[169835.638835] R13: ffff8801dd73aaa0 R14: ffffe8fd73c46400 R15:
dffffc0000000000
[169835.646898] FS:  00007f5a6a6b6080(0000) GS:ffff8801ec000000(0000)
knlGS:0000000000000000
[169835.656028] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[169835.662538] CR2: 0000557fe04ac928 CR3: 00000001217ca004 CR4:
00000000000606e0
[169835.670600] Call Trace:
[169835.673523]  xfs_fs_put_super+0xbf/0x130 [xfs]
[169835.678589]  generic_shutdown_super+0x12e/0x330
[169835.683747]  kill_block_super+0x94/0xe0
[169835.688130]  deactivate_locked_super+0x82/0xd0
[169835.693190]  deactivate_super+0x123/0x140
[169835.697767]  ? get_super_exclusive_thawed+0x10/0x10
[169835.703315]  ? rcu_is_watching+0x2c/0x80
[169835.707798]  cleanup_mnt+0x9f/0x130
[169835.711792]  task_work_run+0x10e/0x190
[169835.716085]  exit_to_usermode_loop+0x136/0x160
[169835.721147]  do_syscall_64+0x3c3/0x480
[169835.725435]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[169835.731173] RIP: 0033:0x7f5a696eea3b
[169835.735263] Code: 14 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 90 f3 0f 1e fa
31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e fa b8 a6 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 1d 14 2c 00 f7 d8 64 89 01 48
[169835.756320] RSP: 002b:00007ffc4f302678 EFLAGS: 00000246 ORIG_RAX:
00000000000000a6
[169835.764869] RAX: 0000000000000000 RBX: 000055977fde82d0 RCX:
00007f5a696eea3b
[169835.772930] RDX: 0000000000000001 RSI: 0000000000000000 RDI:
000055977fdf0a10
[169835.780993] RBP: 0000000000000000 R08: 000055977fdf0a30 R09:
00007ffc4f300ee0
[169835.789055] R10: 0000000000000000 R11: 0000000000000246 R12:
000055977fdf0a10
[169835.797118] R13: 00007f5a6a49a184 R14: 000055977fde84b0 R15:
00000000ffffffff
[169835.805198] irq event stamp: 5017000
[169835.809288] hardirqs last  enabled at (5016999): [<ffffffff85f7ed09>]
_raw_spin_unlock_irq+0x29/0x40
[169835.819583] hardirqs last disabled at (5017000): [<ffffffff844054d1>]
trace_hardirqs_off_thunk+0x1a/0x1c
[169835.830266] softirqs last  enabled at (5016824): [<ffffffff862006a8>]
__do_softirq+0x6a8/0xa1c
[169835.839981] softirqs last disabled at (5016817): [<ffffffff845bfbc1>]
irq_exit+0x281/0x2d0
[169835.849303] ---[ end trace 784ab3a3b5d6ccc5 ]---
[169835.854644] Showing busy workqueues and worker pools:
[169835.860439] workqueue mm_percpu_wq: flags=0x8
[169835.865651]   pwq 30: cpus=15 node=0 flags=0x0 nice=0 active=1/256
[169835.873167]     pending: vmstat_update
[169835.955915] XFS (dm-2): Unmounting Filesystem

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
