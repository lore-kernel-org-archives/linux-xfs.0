Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 137FAC4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 03:26:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA5EC60BD3
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 03:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhHBD05 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Aug 2021 23:26:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231432AbhHBD05 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 1 Aug 2021 23:26:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B534B610A6
        for <linux-xfs@vger.kernel.org>; Mon,  2 Aug 2021 03:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627874808;
        bh=ewO0hjWMymE9J9SR7ZJteYkZsFlWyotx3FQxW/LP+EI=;
        h=From:To:Subject:Date:From;
        b=dujso5RccVIRxfcM4svXxgAALvoV7PCMoeoIsFPoLMZ7cYucFkoUIyGXbWGDSvT6F
         QGWnpcaHhX9YWSHA+M7qkZmfIx0SDZdaqLlqConpjcktnfhUf61o63dyDAdzim9xd3
         K6fgfaeVOuktPJyEL+mM/isvlquFa6toLs4DHBHoor4vs2jpf1x2uw32oEWt5veSrg
         Bxyh9EwpKa0UWTmzho3yjdXl1WJzeXlk0smChov6yWupuIxZ8ZCTeJPlDw4Zx7W2pp
         CVAqvUajvA0UWbcC4iDp1rIP2JbjlK14paX6PNkkFu7Z5y6nRTHCkln84dduCKgSbo
         TuBQoi8F2Hfaw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 213941] New: [xfstests xfs/104] XFS: Assertion failed: agno <
 mp->m_sb.sb_agcount, file: fs/xfs/libxfs/xfs_types.c, line: 22
Date:   Mon, 02 Aug 2021 03:26:48 +0000
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
Message-ID: <bug-213941-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213941

            Bug ID: 213941
           Summary: [xfstests xfs/104] XFS: Assertion failed: agno <
                    mp->m_sb.sb_agcount, file: fs/xfs/libxfs/xfs_types.c,
                    line: 22
           Product: File System
           Version: 2.5
    Kernel Version: linux 5.14.0-rc1+ with xfs-linux xfs-5.14-fixes-1
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

xfstests xfs/104 fails on ppc64le with 1k blockszie xfs
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/ppc64le ibm-p9z-18-lp7 5.14.0-rc1+ #1 SMP Thu Jul 29
12:07:08 EDT 2021
MKFS_OPTIONS  -- -f -m crc=3D1,finobt=3D1,reflink=3D1,rmapbt=3D1,bigtime=3D=
1,inobtcount=3D1
-b size=3D1024 /dev/sda3
MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /dev/sda3
/mnt/xfstests/scratch

xfs/104 _check_dmesg: something found in dmesg (see
/var/lib/xfstests/results//xfs/104.dmesg)

Ran: xfs/104
Failures: xfs/104
Failed 1 of 1 tests


xfs/104 hit kernel assertion:

[44729.688228] XFS: Assertion failed: agno < mp->m_sb.sb_agcount, file:
fs/xfs/libxfs/xfs_types.c, line: 22
...
[44761.832781] XFS: Assertion failed: atomic_read(&pag->pag_ref) =3D=3D 0, =
file:
fs/xfs/libxfs/xfs_ag.c, line: 195

Dmesg output as below:

[44697.129906] run fstests xfs/104 at 2021-07-30 01:35:29
[44717.189106] XFS (sda3): EXPERIMENTAL big timestamp feature in use. Use at
your own risk!
[44717.189122] XFS (sda3): EXPERIMENTAL inode btree counters feature in use.
Use at your own risk!
[44717.231858] XFS (sda3): Mounting V5 Filesystem
[44717.603379] XFS (sda3): Ending clean mount
[44729.688228] XFS: Assertion failed: agno < mp->m_sb.sb_agcount, file:
fs/xfs/libxfs/xfs_types.c, line: 22
[44729.688267] ------------[ cut here ]------------
[44729.688272] WARNING: CPU: 7 PID: 3725648 at fs/xfs/xfs_message.c:112
assfail+0x54/0x70 [xfs]
[44729.688350] Modules linked in: ext2 overlay dm_zero dm_log_writes
dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot dm_bufio ext4 mbc=
ache
jbd2 loop dm_flakey dm_mod bonding tls rfkill sunrpc pseries_rng drm fuse
drm_panel_orientation_quirks xfs libcrc32c sd_mod t10_pi ibmvscsi ibmveth
scsi_transport_srp vmx_crypto [last unloaded: scsi_debug]
[44729.688391] CPU: 7 PID: 3725648 Comm: xfsaild/sda3 Tainted: G        W=
=20=20=20=20=20=20
  5.14.0-rc1+ #1
[44729.688399] NIP:  c0080000063776d0 LR: c0080000063776b8 CTR:
000000007fffffff
[44729.688405] REGS: c000000488cbb550 TRAP: 0700   Tainted: G        W=20=
=20=20=20=20=20=20=20=20
(5.14.0-rc1+)
[44729.688411] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR:
28002404  XER: 0000000d
[44729.688426] CFAR: c0080000063776c8 IRQMASK: 0=20
               GPR00: c0080000063776b8 c000000488cbb7f0 c0080000063e8000
ffffffffffffffea=20
               GPR04: 000000000000000a c000000488cbb770 ffffffffffffffc0
0000000000000000=20
               GPR08: 0000000000000000 0000000000000000 0000000000000000
0000000000000000=20
               GPR12: c0080000063b63a0 c00000001eca7700 c0000000001a4cb8
c0000000c5aab1c0=20
               GPR16: 0000000100001d96 00000000000000e5 0000000000000000
0000000000000000=20
               GPR20: 0000000000000000 c000000002cc0a30 c000000002cc03c0
0000000000000001=20
               GPR24: c008000006336f24 000000000000000f 0000000000000003
0000000000000460=20
               GPR28: 00000000000e6440 000000000000000f c000000013c01800
c000000479268000=20
[44729.688490] NIP [c0080000063776d0] assfail+0x54/0x70 [xfs]
[44729.688565] LR [c0080000063776b8] assfail+0x3c/0x70 [xfs]
[44729.688641] Call Trace:
[44729.688644] [c000000488cbb7f0] [c0080000063776b8] assfail+0x3c/0x70 [xfs]
(unreliable)
[44729.688722] [c000000488cbb850] [c0080000062bb1dc]
xfs_verify_icount+0x134/0x198 [xfs]
[44729.688793] [c000000488cbb8b0] [c0080000062b58b4]
xfs_validate_sb_write.isra.0+0x5c/0x198 [xfs]
[44729.688861] [c000000488cbb920] [c0080000062b7920]
xfs_sb_write_verify+0xc8/0x140 [xfs]
[44729.688931] [c000000488cbba70] [c0080000062cba0c]
_xfs_buf_ioapply+0x64/0x1f0 [xfs]
[44729.689006] [c000000488cbbb30] [c0080000062cbc64]
__xfs_buf_submit+0xcc/0x3a0 [xfs]
[44729.689076] [c000000488cbbb80] [c0080000062ccaa0]
xfs_buf_delwri_submit_buffers+0x188/0x430 [xfs]
[44729.689150] [c000000488cbbc30] [c008000006336f24] xfsaild_push+0x1ac/0xd=
00
[xfs]
[44729.689229] [c000000488cbbd20] [c008000006337bc0] xfsaild+0x148/0x400 [x=
fs]
[44729.689302] [c000000488cbbda0] [c0000000001a4e54] kthread+0x1a4/0x1b0
[44729.689310] [c000000488cbbe10] [c00000000000cf64]
ret_from_kernel_thread+0x5c/0x64
[44729.689318] Instruction dump:
[44729.689322] e888dc70 7d264b78 7d455378 f8010010 f821ffa1 4bfff70d 3d2200=
00
e929dc78=20
[44729.689333] 8929000c 2c090000 41820008 0fe00000 <0fe00000> 38210060 e801=
0010
7c0803a6=20
[44729.689345] irq event stamp: 0
[44729.689348] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[44729.689354] hardirqs last disabled at (0): [<c00000000015de44>]
copy_process+0x814/0x19c0
[44729.689361] softirqs last  enabled at (0): [<c00000000015de44>]
copy_process+0x814/0x19c0
[44729.689367] softirqs last disabled at (0): [<0000000000000000>] 0x0
[44729.689373] ---[ end trace 2ec6fe5d770be2e0 ]---
[44740.553974] XFS (sda3): xlog_verify_grant_tail: space > BBTOB(tail_block=
s)
[44740.553975] XFS (sda3): xlog_verify_grant_tail: space > BBTOB(tail_block=
s)
[44761.392965] XFS (sda3): Unmounting Filesystem
[44761.832781] XFS: Assertion failed: atomic_read(&pag->pag_ref) =3D=3D 0, =
file:
fs/xfs/libxfs/xfs_ag.c, line: 195
[44761.832819] ------------[ cut here ]------------
[44761.832824] WARNING: CPU: 3 PID: 3725946 at fs/xfs/xfs_message.c:112
assfail+0x54/0x70 [xfs]
[44761.832906] Modules linked in: ext2 overlay dm_zero dm_log_writes
dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot dm_bufio ext4 mbc=
ache
jbd2 loop dm_flakey dm_mod bonding tls rfkill sunrpc pseries_rng drm fuse
drm_panel_orientation_quirks xfs libcrc32c sd_mod t10_pi ibmvscsi ibmveth
scsi_transport_srp vmx_crypto [last unloaded: scsi_debug]
[44761.832947] CPU: 3 PID: 3725946 Comm: umount Tainted: G        W=20=20=
=20=20=20=20=20=20
5.14.0-rc1+ #1
[44761.832954] NIP:  c0080000063776d0 LR: c0080000063776b8 CTR:
000000007fffffff
[44761.832967] REGS: c000000019d57760 TRAP: 0700   Tainted: G        W=20=
=20=20=20=20=20=20=20=20
(5.14.0-rc1+)
[44761.832973] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR:
28002484  XER: 00000010
[44761.832989] CFAR: c0080000063776c8 IRQMASK: 0=20
               GPR00: c0080000063776b8 c000000019d57a00 c0080000063e8000
ffffffffffffffea=20
               GPR04: 000000000000000a c000000019d57980 ffffffffffffffc0
0000000000000000=20
               GPR08: 0000000000000000 0000000000000000 0000000000000000
0000000000000000=20
               GPR12: c0080000063b63a0 c00000001ecacb00 0000000000000000
ffffffffffffffff=20
               GPR16: 0000000000000000 00007ffff1fdf530 0000000000000000
00007ffff1fdf5c4=20
               GPR20: 000000000ee6b280 000000012db165a8 00007ffff1fdf530
c0000000203a4700=20
               GPR24: 0000000002002000 0000000000000002 c008000006230b58
c000000479268670=20
               GPR28: c000000479268000 c0000004792686c8 0000000000000010
c000000013c07800=20
[44761.833052] NIP [c0080000063776d0] assfail+0x54/0x70 [xfs]
[44761.833125] LR [c0080000063776b8] assfail+0x3c/0x70 [xfs]
[44761.833197] Call Trace:
[44761.833200] [c000000019d57a00] [c0080000063776b8] assfail+0x3c/0x70 [xfs]
(unreliable)
[44761.833279] [c000000019d57a60] [c0080000062325fc] xfs_free_perag+0x124/0=
x170
[xfs]
[44761.833341] [c000000019d57ab0] [c0080000063000dc] xfs_unmountfs+0xe4/0x1=
a0
[xfs]
[44761.833417] [c000000019d57b40] [c008000006309144] xfs_fs_put_super+0x5c/=
0xe0
[xfs]
[44761.833497] [c000000019d57bb0] [c0000000005e5ed0]
generic_shutdown_super+0xc0/0x180
[44761.833506] [c000000019d57c30] [c0000000005e62a8] kill_block_super+0x38/=
0xb0
[44761.833514] [c000000019d57c60] [c0000000005e7730]
deactivate_locked_super+0x80/0x140
[44761.833521] [c000000019d57ca0] [c0000000006246dc] cleanup_mnt+0x15c/0x240
[44761.833528] [c000000019d57cf0] [c00000000019f554] task_work_run+0xb4/0x1=
20
[44761.833535] [c000000019d57d40] [c000000000022ff4]
do_notify_resume+0x134/0x140
[44761.833543] [c000000019d57d70] [c0000000000312a4]
interrupt_exit_user_prepare_main+0x224/0x2a0
[44761.833551] [c000000019d57de0] [c0000000000316e4]
syscall_exit_prepare+0xe4/0x1e0
[44761.833558] [c000000019d57e10] [c00000000000c17c]
system_call_vectored_common+0xfc/0x280
[44761.833566] --- interrupt: 3000 at 0x7fff9fda1134
[44761.833572] NIP:  00007fff9fda1134 LR: 0000000000000000 CTR:
0000000000000000
[44761.833577] REGS: c000000019d57e80 TRAP: 3000   Tainted: G        W=20=
=20=20=20=20=20=20=20=20
(5.14.0-rc1+)
[44761.833582] MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE> =
 CR:
28002404  XER: 00000000
[44761.833598] IRQMASK: 0=20
               GPR00: 0000000000000034 00007ffff1fdf250 00007fff9fe87100
0000000000000000=20
               GPR04: 0000000000000000 00007ffff1fdf268 0000000000000000
0000000000000073=20
               GPR08: 0000000000000000 0000000000000000 0000000000000000
0000000000000000=20
               GPR12: 0000000000000000 00007fff9ffbc4c0 0000000000000000
ffffffffffffffff=20
               GPR16: 0000000000000000 00007ffff1fdf530 0000000000000000
00007ffff1fdf5c4=20
               GPR20: 000000000ee6b280 000000012db165a8 00007ffff1fdf530
00007ffff1fe0bd0=20
               GPR24: 000000012db16510 0000000000000000 000000012db16508
000001000da30630=20
               GPR28: 000001000da30510 0000000000000000 000001000da350f0
000001000da30400=20
[44761.833659] NIP [00007fff9fda1134] 0x7fff9fda1134
[44761.833663] LR [0000000000000000] 0x0
[44761.833667] --- interrupt: 3000
[44761.833671] Instruction dump:
[44761.833674] e888dc70 7d264b78 7d455378 f8010010 f821ffa1 4bfff70d 3d2200=
00
e929dc78=20
[44761.833686] 8929000c 2c090000 41820008 0fe00000 <0fe00000> 38210060 e801=
0010
7c0803a6=20
[44761.833698] irq event stamp: 0
[44761.833701] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[44761.833706] hardirqs last disabled at (0): [<c00000000015de44>]
copy_process+0x814/0x19c0
[44761.833716] softirqs last  enabled at (0): [<c00000000015de44>]
copy_process+0x814/0x19c0
[44761.833724] softirqs last disabled at (0): [<0000000000000000>] 0x0
[44761.833729] ---[ end trace 2ec6fe5d770be2e1 ]---
[44761.882713] XFS: Assertion failed: atomic_read(&pag->pag_ref) =3D=3D 0, =
file:
fs/xfs/libxfs/xfs_ag.c, line: 176
[44761.882735] ------------[ cut here ]------------
[44761.882739] WARNING: CPU: 3 PID: 0 at fs/xfs/xfs_message.c:112
assfail+0x54/0x70 [xfs]
[44761.882813] Modules linked in: ext2 overlay dm_zero dm_log_writes
dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot dm_bufio ext4 mbc=
ache
jbd2 loop dm_flakey dm_mod bonding tls rfkill sunrpc pseries_rng drm fuse
drm_panel_orientation_quirks xfs libcrc32c sd_mod t10_pi ibmvscsi ibmveth
scsi_transport_srp vmx_crypto [last unloaded: scsi_debug]
[44761.882852] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W=20=20=20=
=20=20=20=20=20
5.14.0-rc1+ #1
[44761.882858] NIP:  c0080000063776d0 LR: c0080000063776b8 CTR:
000000007fffffff
[44761.882864] REGS: c00000000d667400 TRAP: 0700   Tainted: G        W=20=
=20=20=20=20=20=20=20=20
(5.14.0-rc1+)
[44761.882870] MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28022484=
=20
XER: 00000010
[44761.882882] CFAR: c0080000063776c8 IRQMASK: 0=20
               GPR00: c0080000063776b8 c00000000d6676a0 c0080000063e8000
ffffffffffffffea=20
               GPR04: 000000000000000a c00000000d667620 ffffffffffffffc0
0000000000000000=20
               GPR08: 0000000000000000 0000000000000000 0000000000000000
0000000000000000=20
               GPR12: c0080000063b63a0 c00000001ecacb00 0000000000000001
000000001ef3c860=20
               GPR16: c000000002c97a00 0000000000000000 0000000000000000
c000000002aedd00=20
               GPR20: c0000006ec355aa0 c000000000265ea0 c000000000265ea0
0000000000000012=20
               GPR24: 000000000000000a c0000006ec355a00 c00000000d667750
c00000000104a600=20
               GPR28: c000000002abda00 c00000000d5b1b00 c000000013c07800
c000000013c07bd8=20
[44761.882944] NIP [c0080000063776d0] assfail+0x54/0x70 [xfs]
[44761.883020] LR [c0080000063776b8] assfail+0x3c/0x70 [xfs]
[44761.883096] Call Trace:
[44761.883099] [c00000000d6676a0] [c0080000063776b8] assfail+0x3c/0x70 [xfs]
(unreliable)
[44761.883180] [c00000000d667700] [c008000006230c08] __xfs_free_perag+0xb0/=
0xe0
[xfs]
[44761.883241] [c00000000d667730] [c000000000265f0c] rcu_do_batch+0x25c/0x7=
60
[44761.883249] [c00000000d6677f0] [c00000000026949c] rcu_core+0x25c/0x320
[44761.883256] [c00000000d667830] [c0000000010057bc] __do_softirq+0x22c/0x6=
fc
[44761.883264] [c00000000d667940] [c00000000016f0f4] __irq_exit_rcu+0x234/0=
x250
[44761.883272] [c00000000d667970] [c00000000016f340] irq_exit+0x20/0x50
[44761.883279] [c00000000d667990] [c000000000029b00]
timer_interrupt+0x1c0/0x540
[44761.883287] [c00000000d667a00] [c000000000009a00]
decrementer_common_virt+0x210/0x220
[44761.883294] --- interrupt: 900 at plpar_hcall_norets_notrace+0x18/0x2c
[44761.883301] NIP:  c0000000000ff47c LR: c000000000c19a14 CTR:
0000000000000000
[44761.883306] REGS: c00000000d667a70 TRAP: 0900   Tainted: G        W=20=
=20=20=20=20=20=20=20=20
(5.14.0-rc1+)
[44761.883311] MSR:  800000000280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR:
28000888  XER: 20040010
[44761.883326] CFAR: 0000000000000c00 IRQMASK: 0=20
               GPR00: 0000000000000000 c00000000d667d10 c000000002c72b00
0000000000000000=20
               GPR04: 00000000000000c0 0000000000000080 001edb18e2640b62
000000000000013a=20
               GPR08: 000000000001f400 0000000000000001 0000000000000000
0000000000000000=20
               GPR12: 0000000000000000 c00000001ecacb00 0000000000000000
000000001ef3c860=20
               GPR16: 0000000000000000 0000000000000000 0000000000000000
0000000000000000=20
               GPR20: 0000000000000000 0000000000000000 0000000000000000
0000000000000001=20
               GPR24: 0000000000000003 0000000000000000 000028b5efdcbe70
0000000000000001=20
               GPR28: 0000000000000000 0000000000000001 c000000002151bb8
c000000002151bc0=20
[44761.883388] NIP [c0000000000ff47c] plpar_hcall_norets_notrace+0x18/0x2c
[44761.883394] LR [c000000000c19a14] check_and_cede_processor.part.0+0x24/0=
x70
[44761.883401] --- interrupt: 900
[44761.883404] [c00000000d667d10] [0000000000000000] 0x0 (unreliable)
[44761.883411] [c00000000d667d70] [c000000000c1a034]
dedicated_cede_loop+0x164/0x210
[44761.883419] [c00000000d667db0] [c000000000c169bc]
cpuidle_enter_state+0x2bc/0x500
[44761.883426] [c00000000d667e10] [c000000000c16c9c] cpuidle_enter+0x4c/0x70
[44761.883432] [c00000000d667e50] [c0000000001cfe60]
cpuidle_idle_call+0x1c0/0x2f0
[44761.883440] [c00000000d667ea0] [c0000000001d0114] do_idle+0x184/0x240
[44761.883450] [c00000000d667f00] [c0000000001d05a8]
cpu_startup_entry+0x38/0x40
[44761.883458] [c00000000d667f30] [c000000000062bf0]
start_secondary+0x280/0x2a0
[44761.883465] [c00000000d667f90] [c00000000000d254]
start_secondary_prolog+0x10/0x14
[44761.883472] Instruction dump:
[44761.883476] e888dc70 7d264b78 7d455378 f8010010 f821ffa1 4bfff70d 3d2200=
00
e929dc78=20
[44761.883487] 8929000c 2c090000 41820008 0fe00000 <0fe00000> 38210060 e801=
0010
7c0803a6=20
[44761.883499] irq event stamp: 242794715
[44761.883502] hardirqs last  enabled at (242794715): [<c0000000000174f4>]
prep_irq_for_idle+0x44/0x70
[44761.883510] hardirqs last disabled at (242794714): [<c0000000001d00cc>]
do_idle+0x13c/0x240
[44761.883516] softirqs last  enabled at (242794710): [<c000000001005c1c>]
__do_softirq+0x68c/0x6fc
[44761.883524] softirqs last disabled at (242794701): [<c00000000016f0f4>]
__irq_exit_rcu+0x234/0x250
[44761.883531] ---[ end trace 2ec6fe5d770be2e2 ]---
[44762.065716] XFS (sda5): Unmounting Filesystem


.full output as below:
meta-data=3D/dev/sda3              isize=3D512    agcount=3D4, agsize=3D393=
2160 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D1
         =3D                       reflink=3D1    bigtime=3D1 inobtcount=3D1
data     =3D                       bsize=3D1024   blocks=3D15728640, imaxpc=
t=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D1024   blocks=3D10240, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
meta-data=3D/dev/sda3              isize=3D512    agcount=3D4, agsize=3D320=
00 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D1
         =3D                       reflink=3D1    bigtime=3D1 inobtcount=3D1
data     =3D                       bsize=3D1024   blocks=3D128000, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D1024   blocks=3D5363, version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
*** stressing a 128000 block filesystem
seed =3D 1628351693
*** growing to a 171008 block filesystem
meta-data=3D/dev/sda3              isize=3D512    agcount=3D4, agsize=3D320=
00 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D1
         =3D                       reflink=3D1    bigtime=3D1 inobtcount=3D1
data     =3D                       bsize=3D1024   blocks=3D128000, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D1024   blocks=3D5363, version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
data blocks changed from 128000 to 171008
AGCOUNT=3D4

*** stressing a 171008 block filesystem
seed =3D 1627435428
*** growing to a 214016 block filesystem
meta-data=3D/dev/sda3              isize=3D512    agcount=3D6, agsize=3D320=
00 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D1
         =3D                       reflink=3D1    bigtime=3D1 inobtcount=3D1
data     =3D                       bsize=3D1024   blocks=3D171008, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D1024   blocks=3D5363, version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
data blocks changed from 171008 to 214016
AGCOUNT=3D6

*** stressing a 214016 block filesystem
seed =3D 1628102755
*** growing to a 257024 block filesystem
meta-data=3D/dev/sda3              isize=3D512    agcount=3D7, agsize=3D320=
00 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D1
         =3D                       reflink=3D1    bigtime=3D1 inobtcount=3D1
data     =3D                       bsize=3D1024   blocks=3D214016, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D1024   blocks=3D5363, version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
data blocks changed from 214016 to 257024
AGCOUNT=3D7

*** stressing a 257024 block filesystem
seed =3D 1627616710
*** growing to a 300032 block filesystem
meta-data=3D/dev/sda3              isize=3D512    agcount=3D9, agsize=3D320=
00 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D1
         =3D                       reflink=3D1    bigtime=3D1 inobtcount=3D1
data     =3D                       bsize=3D1024   blocks=3D257024, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D1024   blocks=3D5363, version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
data blocks changed from 257024 to 300032
AGCOUNT=3D9

*** stressing a 300032 block filesystem
seed =3D 1627863592
*** growing to a 343040 block filesystem
meta-data=3D/dev/sda3              isize=3D512    agcount=3D10, agsize=3D32=
000 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D1
         =3D                       reflink=3D1    bigtime=3D1 inobtcount=3D1
data     =3D                       bsize=3D1024   blocks=3D300032, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D1024   blocks=3D5363, version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
data blocks changed from 300032 to 343040
AGCOUNT=3D10

*** stressing a 343040 block filesystem
seed =3D 1628039937
*** growing to a 386048 block filesystem
meta-data=3D/dev/sda3              isize=3D512    agcount=3D11, agsize=3D32=
000 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D1
         =3D                       reflink=3D1    bigtime=3D1 inobtcount=3D1
data     =3D                       bsize=3D1024   blocks=3D343040, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D1024   blocks=3D5363, version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
data blocks changed from 343040 to 386048
AGCOUNT=3D11

*** stressing a 386048 block filesystem
seed =3D 1627624784
*** growing to a 429056 block filesystem
meta-data=3D/dev/sda3              isize=3D512    agcount=3D13, agsize=3D32=
000 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D1
         =3D                       reflink=3D1    bigtime=3D1 inobtcount=3D1
data     =3D                       bsize=3D1024   blocks=3D386048, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D1024   blocks=3D5363, version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
data blocks changed from 386048 to 429056
AGCOUNT=3D13

*** stressing a 429056 block filesystem
seed =3D 1627859438
*** growing to a 472064 block filesystem
meta-data=3D/dev/sda3              isize=3D512    agcount=3D14, agsize=3D32=
000 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D1
         =3D                       reflink=3D1    bigtime=3D1 inobtcount=3D1
data     =3D                       bsize=3D1024   blocks=3D429056, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D1024   blocks=3D5363, version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
data blocks changed from 429056 to 472064
AGCOUNT=3D14

*** stressing a 472064 block filesystem
seed =3D 1628419199
*** growing to a 515072 block filesystem
meta-data=3D/dev/sda3              isize=3D512    agcount=3D15, agsize=3D32=
000 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D1
         =3D                       reflink=3D1    bigtime=3D1 inobtcount=3D1
data     =3D                       bsize=3D1024   blocks=3D472064, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D1024   blocks=3D5363, version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
data blocks changed from 472064 to 515072
AGCOUNT=3D15

*** stressing a 515072 block filesystem
seed =3D 1627821002
*** growing to a 558080 block filesystem
meta-data=3D/dev/sda3              isize=3D512    agcount=3D17, agsize=3D32=
000 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D1
         =3D                       reflink=3D1    bigtime=3D1 inobtcount=3D1
data     =3D                       bsize=3D1024   blocks=3D515072, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D1024   blocks=3D5363, version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
data blocks changed from 515072 to 558080
AGCOUNT=3D17

*** stressing a 558080 block filesystem
seed =3D 1627556624
*** growing to a 601088 block filesystem
meta-data=3D/dev/sda3              isize=3D512    agcount=3D18, agsize=3D32=
000 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D1
         =3D                       reflink=3D1    bigtime=3D1 inobtcount=3D1
data     =3D                       bsize=3D1024   blocks=3D558080, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D1024   blocks=3D5363, version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
data blocks changed from 558080 to 601088
AGCOUNT=3D18

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
