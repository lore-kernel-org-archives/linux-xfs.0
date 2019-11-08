Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 508E6C5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 06:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1986121882
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 06:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbfKHGcm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 01:32:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:56402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfKHGcm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Nov 2019 01:32:42 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 205465] New: [xfstests generic/475]: general protection fault:
 0000 [#1] SMP KASAN PTI,  RIP: 0010:iter_file_splice_write+0x63f/0xa90
Date:   Fri, 08 Nov 2019 06:32:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-205465-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205465

            Bug ID: 205465
           Summary: [xfstests generic/475]: general protection fault: 0000
                    [#1] SMP KASAN PTI,  RIP:
                    0010:iter_file_splice_write+0x63f/0xa90
           Product: File System
           Version: 2.5
    Kernel Version: xfs-linux 5.4.0-rc3+ + xfs-5.5-merge-6 +
                    iomap-5.5-merge-6
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
I hit a kernel panic on xfs-linux "xfs-5.5-merge-6 + iomap-5.5-merge-6":

[34623.023691] run fstests generic/475 at 2019-10-31 20:19:44 
[34626.293952] XFS (dm-0): Mounting V5 Filesystem 
[34626.441140] XFS (dm-0): Ending clean mount 
[34626.483454] Mounted xfs file system at /mnt/xfstests/mnt2 supports
timestamps until 2038 (0x7fffffff) 
[34628.679834] iomap_finish_ioend: 7 callbacks suppressed 
[34628.679840] dm-0: writeback error on inode 16797854, offset 1150976, sector
15762000 
[34628.679905] dm-0: writeback error on inode 16797854, offset 2818048, sector
15761568 
[34628.684120] dm-0: writeback error on inode 162, offset 176128, sector 21936 
[34628.706668] dm-0: writeback error on inode 25166791, offset 1314816, sector
23616848 

[34342.606123] dm-0: writeback error on inode 9220, offset 2793472, sector
181616 
[34342.606215] dm-0: writeback error on inode 8429459, offset 212992, sector
7939416 
[34342.638699] Buffer I/O error on dev dm-0, logical block 31457156, async page
read 
[34342.672923] XFS (dm-0): log I/O error -5 
[34342.704060] Buffer I/O error on dev dm-0, logical block 31457157, async page
read 
[34342.739474] XFS (dm-0): xfs_do_force_shutdown(0x2) called from line 1297 of
file fs/xfs/xfs_log.c. Return address = ffffffffc096045d 
[34342.771022] Buffer I/O error on dev dm-0, logical block 31457158, async page
read 
[34342.803487] XFS (dm-0): Log I/O Error Detected. Shutting down filesystem 
[34342.803491] XFS (dm-0): Please unmount the filesystem and rectify the
problem(s) 
[34342.805783] XFS (dm-0): log I/O error -5 
[34342.837407] Buffer I/O error on dev dm-0, logical block 31457159, async page
read 
[34347.295823] kasan: CONFIG_KASAN_INLINE enabled 
[34347.317883] kasan: GPF could be caused by NULL-ptr deref or user memory
access 
[34347.355081] general protection fault: 0000 [#1] SMP KASAN PTI 
[34347.381157] CPU: 1 PID: 28596 Comm: fsstress Tainted: G    B            
5.4.0-rc3+ #1 
[34347.416675] Hardware name: HP ProLiant ML150 Gen9/ProLiant ML150 Gen9, BIOS
P95 10/17/2018 
[34347.454030] RIP: 0010:iter_file_splice_write+0x63f/0xa90 
[34347.477454] Code: 00 00 48 89 f8 48 c1 e8 03 80 3c 18 00 0f 85 61 03 00 00
48 8b 46 10 48 c7 46 10 00 00 00 00 48 8d 78 08 48 89 fa 48 c1 ea 03 <80> 3c 1a
00 0f 85 52 03 00 00 48 8b 40 08 48 89 ef e8 cb 87 7e 01 
[34347.567386] RSP: 0018:ffff8881021478e8 EFLAGS: 00010202 
[34347.594284] RAX: 0000000000000000 RBX: dffffc0000000000 RCX:
0000000000000010 
[34347.630173] RDX: 0000000000000001 RSI: ffff88803bb2f230 RDI:
0000000000000008 
[34347.664386] RBP: ffff88804593f800 R08: fffff9400085f55f R09:
fffff9400085f55f 
[34347.697446] R10: fffff9400085f55e R11: ffffea00042faaf7 R12:
ffffed1008b27f27 
[34347.729815] R13: ffffed1008b27f1f R14: 000000000000f991 R15:
ffff88804593f8fc 
[34347.762054] FS:  00007fb54c31db80(0000) GS:ffff888111200000(0000)
knlGS:0000000000000000 
[34347.798497] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[34347.824248] CR2: 00007fa1677d97bc CR3: 000000010a6b0005 CR4:
00000000001606e0 
[34347.861461] Call Trace: 
[34347.872401]  ? __x64_sys_tee+0x220/0x220 
[34347.890482]  ? generic_file_splice_read+0x4f5/0x6c0 
[34347.913129]  ? add_to_pipe+0x330/0x330 
[34347.930226]  ? _cond_resched+0x15/0x30 
[34347.947065]  direct_splice_actor+0x107/0x1d0 
[34347.966187]  splice_direct_to_actor+0x2ed/0x7f0 
[34347.986506]  ? wakeup_pipe_readers+0x80/0x80 
[34348.005665]  ? do_splice_to+0x140/0x140 
[34348.022821]  ? security_file_permission+0x53/0x2b0 
[34348.044361]  do_splice_direct+0x158/0x250 
[34348.062308]  ? splice_direct_to_actor+0x7f0/0x7f0 
[34348.083596]  ? __sb_start_write+0x1c4/0x310 
[34348.102277]  vfs_copy_file_range+0x39c/0xa40 
[34348.121542]  ? __x64_sys_sendfile+0x1d0/0x1d0 
[34348.141038]  ? lockdep_hardirqs_on+0x590/0x590 
[34348.160710]  ? lock_downgrade+0x6d0/0x6d0 
[34348.178716]  ? lock_acquire+0x15a/0x3d0 
[34348.196037]  ? __might_fault+0xc4/0x1b0 
[34348.213777]  __x64_sys_copy_file_range+0x1e8/0x460 
[34348.235365]  ? __ia32_sys_copy_file_range+0x460/0x460 
[34348.257992]  ? __audit_syscall_exit+0x796/0xab0 
[34348.278378]  do_syscall_64+0x9f/0x4f0 
[34348.294861]  entry_SYSCALL_64_after_hwframe+0x49/0xbe 
[34348.317937] RIP: 0033:0x7fb54b80f99d 
[34348.334352] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89
f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d bb 64 2c 00 f7 d8 64 89 01 48 
[34348.423644] RSP: 002b:00007ffedb7d1ae8 EFLAGS: 00000246 ORIG_RAX:
0000000000000146 
[34348.457684] RAX: ffffffffffffffda RBX: 00007ffedb7d1b38 RCX:
00007fb54b80f99d 
[34348.489609] RDX: 0000000000000004 RSI: 00007ffedb7d1b30 RDI:
0000000000000003 
[34348.521710] RBP: 000000000001cb24 R08: 000000000001cb24 R09:
0000000000000000 
[34348.554435] R10: 00007ffedb7d1b38 R11: 0000000000000246 R12:
00007ffedb7d1b30 
[34348.586406] R13: 0000000000000003 R14: 0000000000000004 R15:
00000000000bfb4b 
[34348.618467] Modules linked in: dm_mod iTCO_wdt intel_rapl_msr
iTCO_vendor_support intel_rapl_common sb_edac x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel intel_cstate intel_uncore intel_rapl_perf dax_pmem_compat
device_dax dax_pmem_core pcspkr nd_pmem i2c_i801 lpc_ich ipmi_ssif hpilo hpwdt
ipmi_si sg ioatdma ipmi_devintf dca sunrpc ipmi_msghandler acpi_tad
acpi_power_meter vfat fat xfs libcrc32c sd_mod mgag200 drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops i2c_algo_bit drm_vram_helper ttm
ahci libahci drm libata crc32c_intel tg3 wmi 
[34348.869785] ---[ end trace 0c361151da993489 ]--- 
[34348.908928] RIP: 0010:iter_file_splice_write+0x63f/0xa90 
[34348.932900] Code: 00 00 48 89 f8 48 c1 e8 03 80 3c 18 00 0f 85 61 03 00 00
48 8b 46 10 48 c7 46 10 00 00 00 00 48 8d 78 08 48 89 fa 48 c1 ea 03 <80> 3c 1a
00 0f 85 52 03 00 00 48 8b 40 08 48 89 ef e8 cb 87 7e 01 
[34349.017307] RSP: 0018:ffff8881021478e8 EFLAGS: 00010202 
[34349.040799] RAX: 0000000000000000 RBX: dffffc0000000000 RCX:
0000000000000010 
[34349.072993] RDX: 0000000000000001 RSI: ffff88803bb2f230 RDI:
0000000000000008 
[34349.105063] RBP: ffff88804593f800 R08: fffff9400085f55f R09:
fffff9400085f55f 
[34349.137064] R10: fffff9400085f55e R11: ffffea00042faaf7 R12:
ffffed1008b27f27 
[34349.169397] R13: ffffed1008b27f1f R14: 000000000000f991 R15:
ffff88804593f8fc 
[34349.201528] FS:  00007fb54c31db80(0000) GS:ffff888111200000(0000)
knlGS:0000000000000000 
[34349.238784] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[34349.264602] CR2: 00007fa1677d97bc CR3: 000000010a6b0005 CR4:
00000000001606e0 
[34349.812107] XFS (dm-0): Unmounting Filesystem 
[34350.152935] XFS (dm-0): Mounting V5 Filesystem 

# cat generic/475.full
meta-data=/dev/sdb4              isize=512    agcount=4, agsize=983040 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=3932160, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
device-mapper: remove ioctl on error-test  failed: No such device or address
Command failed.
seed = 1572771114
seed = 1572585309
seed = 1572643818
seed = 1572855289
...
...


Sorry for this late bug report, I find this issue earlier, but I was stuck by
other things, didn't have time to report it. I'll test on latest xfs to check
if this issue still there.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
