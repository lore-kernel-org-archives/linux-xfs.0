Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:57744 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbfFUIc6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 04:32:58 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id EC466289AF
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2019 08:32:56 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 203947] New: [xfstests generic/475]: general protection fault:
 0000 [#1] RIP: 0010:xfs_setfilesize_ioend+0xb1/0x220 [xfs]
Date: Fri, 21 Jun 2019 08:32:54 +0000
Message-ID: <bug-203947-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203947

            Bug ID: 203947
           Summary: [xfstests generic/475]: general protection fault: 0000
                    [#1] RIP: 0010:xfs_setfilesize_ioend+0xb1/0x220 [xfs]
           Product: File System
           Version: 2.5
    Kernel Version: xfs-linux xfs-5.3-merge-1
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

Description of problem:
generic/475 hit a kernel panic on x86_64, the xfs info is:

meta-data=/dev/sda2              isize=512    agcount=16, agsize=245696 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=3931136, imaxpct=25
         =                       sunit=64     swidth=256 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

part of panic log:
....
[29158.142556] XFS (dm-0): writeback error on sector 19720192 
[29158.167263] XFS (dm-0): writeback error on sector 29562736 
[29158.194303] XFS (dm-0): xfs_do_force_shutdown(0x2) called from line 1272 of
file fs/xfs/xfs_log.c. Return address = 00000000025e6ad7 
[29158.248165] XFS (dm-0): Log I/O Error Detected. Shutting down filesystem 
[29158.278321] XFS (dm-0): Please unmount the filesystem and rectify the
problem(s) 
[29158.647121] XFS (dm-0): Unmounting Filesystem 
[29159.265101] XFS (dm-0): Mounting V5 Filesystem 
[29159.590476] XFS (dm-0): Starting recovery (logdev: internal) 
[29161.495439] XFS (dm-0): Ending recovery (logdev: internal) 
[29163.269463] kasan: CONFIG_KASAN_INLINE enabled 
[29163.291984] kasan: GPF could be caused by NULL-ptr deref or user memory
access 
[29163.328565] general protection fault: 0000 [#1] SMP KASAN PTI 
[29163.354186] CPU: 4 PID: 1049 Comm: kworker/4:3 Not tainted 5.2.0-rc4 #1 
[29163.383882] Hardware name: HP ProLiant DL360 Gen9, BIOS P89 05/06/2015 
[29163.413366] Workqueue: xfs-conv/dm-0 xfs_end_io [xfs] 
[29163.436225] RIP: 0010:xfs_setfilesize_ioend+0xb1/0x220 [xfs] 
[29163.461648] Code: 03 38 d0 7c 08 84 d2 0f 85 3c 01 00 00 49 8d bc 24 f8 00
00 00 45 8b 6d 24 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02
00 0f 85 33 01 00 00 4d 89 ac 24 f8 00 00 00 48 b8 00 00 
[29163.546149] RSP: 0018:ffff888070f37c28 EFLAGS: 00010202 
[29163.569758] RAX: dffffc0000000000 RBX: ffff8880069632c0 RCX:
ffff8880069632e0 
[29163.601781] RDX: 000000000000001f RSI: 0000000000000001 RDI:
00000000000000f8 
[29163.636304] RBP: ffff8880471c6f00 R08: dffffc0000000000 R09:
ffffed1008e38e61 
[29163.669587] R10: 1ffff11008e38dd7 R11: ffff88806f85a8c8 R12:
0000000000000000 
[29163.702129] R13: 0000000004208060 R14: 0000000000000001 R15:
dffffc0000000000 
[29163.734261] FS:  0000000000000000(0000) GS:ffff88810e400000(0000)
knlGS:0000000000000000 
[29163.770758] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[29163.797513] CR2: 000055569b8a2000 CR3: 0000000138816002 CR4:
00000000001606e0 
[29163.832418] Call Trace: 
[29163.844440]  xfs_ioend_try_merge+0x42d/0x610 [xfs] 
[29163.867530]  xfs_end_io+0x217/0x380 [xfs] 
[29163.885689]  ? xfs_setfilesize+0xe0/0xe0 [xfs] 
[29163.905876]  process_one_work+0x8f4/0x1760 
[29163.924473]  ? pwq_dec_nr_in_flight+0x2d0/0x2d0 
[29163.944767]  worker_thread+0x87/0xb50 
[29163.961526]  ? __kthread_parkme+0xb6/0x180 
[29163.979926]  ? process_one_work+0x1760/0x1760 
[29163.999701]  kthread+0x326/0x3f0 
[29164.014194]  ? kthread_create_on_node+0xc0/0xc0 
[29164.034154]  ret_from_fork+0x3a/0x50 
[29164.050229] Modules linked in: dm_mod iTCO_wdt iTCO_vendor_support
intel_rapl sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel intel_cstate
intel_uncore intel_rapl_perf pcspkr dax_pmem_compat device_dax nd_pmem
dax_pmem_core ipmi_ssif sunrpc i2c_i801 lpc_ich ipmi_si hpwdt hpilo sg
ipmi_devintf ipmi_msghandler acpi_tad ioatdma acpi_power_meter dca xfs
libcrc32c mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt
fb_sys_fops sd_mod ttm drm crc32c_intel serio_raw tg3 hpsa scsi_transport_sas
wmi 
[29164.284974] ---[ end trace 185128643cc7ea23 ]--- 
...
...

Version-Release number of selected component (if applicable):
xfs-linux:
 f5b999c03f4c (HEAD -> for-next, tag: xfs-5.3-merge-1, origin/xfs-5.3-merge,
origin/for-next) xfs: remove unused flag arguments

How reproducible:
Once so far, trying to reproduce it.

Steps to Reproduce:
Loop run generic/475

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
