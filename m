Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F3EC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 09:01:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39E4360F6F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 09:01:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbhHXJCf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Aug 2021 05:02:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234214AbhHXJCd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Aug 2021 05:02:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D8255613AB
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 09:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629795709;
        bh=HdrW4AzyHDEkQ8KDtx8+Z6VPakwo8zJovNtWIsBnO3M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=D+Zy6xcd3qyPKVz03BiVE1cor3arvlI91hVm6l5SppTJML7XbnfX+KJyBXjwQT1Ot
         poBtzjHdK/TCZ0TmsrTmLnFjPpF/nl09wbQO7YGdeLs8EmXZr1bhP0h3v6zpQ1lfb5
         3VwJK8UZaCgtTQLWJucDEk5A5sj9arcGCUlGPt81rGwjSzxr/kS9nhkZdnKZ7bilUU
         YTSavOWKzVh0+9oHplk4thowcvM0QWNznq13uz0QFkdQ9kw6N55VpFK72Y0RjyfclI
         B6eyu8fb/n+bP/zGnyzZ8/A0txOUsh3+JLqKFkv8sldgInGXi2Y3FZiPaHAzWov5MK
         KslzW5b9FEwlQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 213625] [xfstests xfs/104] XFS: Assertion failed: agno <
 mp->m_sb.sb_agcount, file: fs/xfs/libxfs/xfs_types.c, line: 22
Date:   Tue, 24 Aug 2021 09:01:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-213625-201763-cxAuE5jX3u@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213625-201763@https.bugzilla.kernel.org/>
References: <bug-213625-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213625

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
Hit this bug again on xfs-5.15-merge-5:
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/ppc64le ibm-p9z-16-lp7 5.14.0-rc4+ #1 SMP Mon Aug 23
01:51:56 EDT 2021
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

[73251.319855] run fstests xfs/104 at 2021-08-23 23:24:20
[73254.398025] XFS (sda3): Mounting V5 Filesystem
[73254.576277] XFS (sda3): Ending clean mount
[73258.610632] XFS: Assertion failed: agno < mp->m_sb.sb_agcount, file:
fs/xfs/libxfs/xfs_types.c, line: 22
[73258.610673] ------------[ cut here ]------------
[73258.610679] WARNING: CPU: 2 PID: 3873507 at fs/xfs/xfs_message.c:112
assfail+0x54/0x70 [xfs]
[73258.610784] Modules linked in: ext2 overlay dm_zero dm_log_writes
dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot dm_bufio ext4 mbc=
ache
jbd2 loop dm_flakey dm_mod bonding tls rfkill sunrpc pseries_rng drm fuse
drm_panel_orientation_quirks xfs libcrc32c sd_mod t10_pi sg ibmvscsi ibmveth
scsi_transport_srp vmx_crypto [last unloaded: scsi_debug]
[73258.610835] CPU: 2 PID: 3873507 Comm: xfsaild/sda3 Kdump: loaded Tainted=
: G=20
      W         5.14.0-rc4+ #1
[73258.610844] NIP:  c008000005549d68 LR: c008000005549d50 CTR:
000000007fffffff
[73258.610851] REGS: c000000487597550 TRAP: 0700   Tainted: G        W=20=
=20=20=20=20=20=20=20=20
(5.14.0-rc4+)
[73258.610858] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR:
28002404  XER: 0000000d
[73258.610877] CFAR: c008000005549d60 IRQMASK: 0=20
               GPR00: c008000005549d50 c0000004875977f0 c0080000055b8000
ffffffffffffffea=20
               GPR04: 000000000000000a c000000487597770 ffffffffffffffc0
0000000000000000=20
               GPR08: 0000000000000000 0000000000000000 0000000000000000
c008000005586a78=20
               GPR12: c0000000008848e0 c000000007fcdf00 c0000000001a3d98
c0000004ecf9cd80=20
               GPR16: 0000000100000864 0000000000000068 0000000000000000
0000000000000000=20
               GPR20: 0000000000000000 c000000002cf0a30 c000000002cf03c0
0000000000000001=20
               GPR24: c00800000550a4e4 0000000000068640 0000000000000003
0000000000000100=20
               GPR28: 0000000000000007 0000000000000007 c00000004e1fb000
c00000006d1c6000=20
[73258.610971] NIP [c008000005549d68] assfail+0x54/0x70 [xfs]
[73258.611058] LR [c008000005549d50] assfail+0x3c/0x70 [xfs]
[73258.611142] Call Trace:
[73258.611146] [c0000004875977f0] [c008000005549d50] assfail+0x3c/0x70 [xfs]
(unreliable)
[73258.611233] [c000000487597850] [c00800000548c2fc]
xfs_verify_icount+0x134/0x198 [xfs]
[73258.611313] [c0000004875978b0] [c008000005486b74]
xfs_validate_sb_write.isra.0+0x5c/0x198 [xfs]
[73258.611394] [c000000487597920] [c008000005488b40]
xfs_sb_write_verify+0xc8/0x140 [xfs]
[73258.611474] [c000000487597a70] [c00800000549c7ac]
_xfs_buf_ioapply+0x64/0x1f0 [xfs]
[73258.611554] [c000000487597b30] [c00800000549ca04]
__xfs_buf_submit+0xcc/0x3a0 [xfs]
[73258.611635] [c000000487597b80] [c00800000549d860]
xfs_buf_delwri_submit_buffers+0x188/0x430 [xfs]
[73258.611716] [c000000487597c30] [c00800000550a4e4] xfsaild_push+0x1ac/0xd=
00
[xfs]
[73258.611802] [c000000487597d20] [c00800000550b180] xfsaild+0x148/0x400 [x=
fs]
[73258.611887] [c000000487597da0] [c0000000001a3f34] kthread+0x1a4/0x1b0
[73258.611897] [c000000487597e10] [c00000000000cf64]
ret_from_kernel_thread+0x5c/0x64
[73258.611906] Instruction dump:
[73258.611911] e888dd80 7d264b78 7d455378 f8010010 f821ffa1 4bfff70d 3d2200=
00
e929dd88=20
[73258.611925] 8929000c 2c090000 41820008 0fe00000 <0fe00000> 38210060 e801=
0010
7c0803a6=20
[73258.611939] irq event stamp: 0
[73258.611943] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[73258.611951] hardirqs last disabled at (0): [<c00000000015d3b4>]
copy_process+0x814/0x19c0
[73258.611959] softirqs last  enabled at (0): [<c00000000015d3b4>]
copy_process+0x814/0x19c0
[73258.611967] softirqs last disabled at (0): [<0000000000000000>] 0x0
[73258.611973] ---[ end trace 7b942b5bf64fe00e ]---
[73264.518210] XFS: Assertion failed: agno < mp->m_sb.sb_agcount, file:
fs/xfs/libxfs/xfs_types.c, line: 22
[73264.518254] ------------[ cut here ]------------
[73264.518260] WARNING: CPU: 3 PID: 3873507 at fs/xfs/xfs_message.c:112
assfail+0x54/0x70 [xfs]
[73264.518359] Modules linked in: ext2 overlay dm_zero dm_log_writes
dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot dm_bufio ext4 mbc=
ache
jbd2 loop dm_flakey dm_mod bonding tls rfkill sunrpc pseries_rng drm fuse
drm_panel_orientation_quirks xfs libcrc32c sd_mod t10_pi sg ibmvscsi ibmveth
scsi_transport_srp vmx_crypto [last unloaded: scsi_debug]
[73264.518412] CPU: 3 PID: 3873507 Comm: xfsaild/sda3 Kdump: loaded Tainted=
: G=20
      W         5.14.0-rc4+ #1
[73264.518422] NIP:  c008000005549d68 LR: c008000005549d50 CTR:
000000007fffffff
[73264.518429] REGS: c000000487597550 TRAP: 0700   Tainted: G        W=20=
=20=20=20=20=20=20=20=20
(5.14.0-rc4+)
[73264.518437] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR:
28002404  XER: 0000000d
[73264.518456] CFAR: c008000005549d60 IRQMASK: 0=20
               GPR00: c008000005549d50 c0000004875977f0 c0080000055b8000
ffffffffffffffea=20
               GPR04: 000000000000000a c000000487597770 ffffffffffffffc0
0000000000000000=20
               GPR08: 0000000000000000 0000000000000000 0000000000000000
c008000005586a78=20
               GPR12: c0000000008848e0 c000000007fccb00 c0000000001a3d98
c0000004ecf9cd80=20
               GPR16: 0000000100001e5d 00000000000000ca 0000000000000000
0000000000000000=20
               GPR20: 0000000000000000 c000000002cf0a30 c000000002cf03c0
0000000000000001=20
               GPR24: c00800000550a4e4 00000000000bc4c0 0000000000000003
0000000000000360=20
               GPR28: 000000000000000d 000000000000000d c000000057bd7000
c00000006d1c6000=20
[73264.518537] NIP [c008000005549d68] assfail+0x54/0x70 [xfs]
[73264.518621] LR [c008000005549d50] assfail+0x3c/0x70 [xfs]
[73264.518706] Call Trace:
[73264.518710] [c0000004875977f0] [c008000005549d50] assfail+0x3c/0x70 [xfs]
(unreliable)
[73264.518797] [c000000487597850] [c00800000548c2fc]
xfs_verify_icount+0x134/0x198 [xfs]
[73264.518881] [c0000004875978b0] [c008000005486b74]
xfs_validate_sb_write.isra.0+0x5c/0x198 [xfs]
[73264.518963] [c000000487597920] [c008000005488b40]
xfs_sb_write_verify+0xc8/0x140 [xfs]
[73264.519043] [c000000487597a70] [c00800000549c7ac]
_xfs_buf_ioapply+0x64/0x1f0 [xfs]
[73264.519124] [c000000487597b30] [c00800000549ca04]
__xfs_buf_submit+0xcc/0x3a0 [xfs]
[73264.519204] [c000000487597b80] [c00800000549d860]
xfs_buf_delwri_submit_buffers+0x188/0x430 [xfs]
[73264.519286] [c000000487597c30] [c00800000550a4e4] xfsaild_push+0x1ac/0xd=
00
[xfs]
[73264.519370] [c000000487597d20] [c00800000550b180] xfsaild+0x148/0x400 [x=
fs]
[73264.519456] [c000000487597da0] [c0000000001a3f34] kthread+0x1a4/0x1b0
[73264.519466] [c000000487597e10] [c00000000000cf64]
ret_from_kernel_thread+0x5c/0x64
[73264.519475] Instruction dump:
[73264.519480] e888dd80 7d264b78 7d455378 f8010010 f821ffa1 4bfff70d 3d2200=
00
e929dd88=20
[73264.519494] 8929000c 2c090000 41820008 0fe00000 <0fe00000> 38210060 e801=
0010
7c0803a6=20
[73264.519508] irq event stamp: 0
[73264.519512] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[73264.519519] hardirqs last disabled at (0): [<c00000000015d3b4>]
copy_process+0x814/0x19c0
[73264.519527] softirqs last  enabled at (0): [<c00000000015d3b4>]
copy_process+0x814/0x19c0
[73264.519535] softirqs last disabled at (0): [<0000000000000000>] 0x0
[73264.519541] ---[ end trace 7b942b5bf64fe00f ]---
[73282.906755] XFS (sda3): xlog_verify_grant_tail: space > BBTOB(tail_block=
s)
[73304.923750] XFS (sda3): Unmounting Filesystem
[73305.403659] XFS: Assertion failed: atomic_read(&pag->pag_ref) =3D=3D 0, =
file:
fs/xfs/libxfs/xfs_ag.c, line: 195
[73305.403696] ------------[ cut here ]------------
[73305.403701] WARNING: CPU: 0 PID: 3873817 at fs/xfs/xfs_message.c:112
assfail+0x54/0x70 [xfs]
[73305.403811] Modules linked in: ext2 overlay dm_zero dm_log_writes
dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot dm_bufio ext4 mbc=
ache
jbd2 loop dm_flakey dm_mod bonding tls rfkill sunrpc pseries_rng drm fuse
drm_panel_orientation_quirks xfs libcrc32c sd_mod t10_pi sg ibmvscsi ibmveth
scsi_transport_srp vmx_crypto [last unloaded: scsi_debug]
[73305.403861] CPU: 0 PID: 3873817 Comm: umount Kdump: loaded Tainted: G=20=
=20=20=20=20=20=20
W         5.14.0-rc4+ #1
[73305.403871] NIP:  c008000005549d68 LR: c008000005549d50 CTR:
000000007fffffff
[73305.403878] REGS: c0000004e7693750 TRAP: 0700   Tainted: G        W=20=
=20=20=20=20=20=20=20=20
(5.14.0-rc4+)
[73305.403885] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR:
28002484  XER: 00000010
[73305.403904] CFAR: c008000005549d60 IRQMASK: 0=20
               GPR00: c008000005549d50 c0000004e76939f0 c0080000055b8000
ffffffffffffffea=20
               GPR04: 000000000000000a c0000004e7693970 ffffffffffffffc0
0000000000000000=20
               GPR08: 0000000000000000 0000000000000000 0000000000000000
c008000005586a78=20
               GPR12: c0000000008848e0 c0000000049c0000 0000000000000000
ffffffffffffffff=20
               GPR16: 0000000000000000 00007ffff7de67a0 0000000000000000
00007ffff7de6834=20
               GPR20: 000000000ee6b280 0000000128b965a8 00007ffff7de67a0
c00000006f409f00=20
               GPR24: 0000000002002000 0000000000000002 c008000005402c48
c00000006d1c6670=20
               GPR28: c00000006d1c6000 c00000006d1c66c8 0000000000000008
c00000004e1f2800=20
[73305.403980] NIP [c008000005549d68] assfail+0x54/0x70 [xfs]
[73305.404065] LR [c008000005549d50] assfail+0x3c/0x70 [xfs]
[73305.404151] Call Trace:
[73305.404154] [c0000004e76939f0] [c008000005549d50] assfail+0x3c/0x70 [xfs]
(unreliable)
[73305.404241] [c0000004e7693a50] [c00800000540459c] xfs_free_perag+0x124/0=
x170
[xfs]
[73305.404314] [c0000004e7693aa0] [c0080000054d3014] xfs_unmountfs+0xfc/0x1=
c0
[xfs]
[73305.404399] [c0000004e7693b30] [c0080000054dc218]
xfs_fs_put_super+0x60/0x170 [xfs]
[73305.404484] [c0000004e7693bb0] [c0000000005e0bf0]
generic_shutdown_super+0xc0/0x180
[73305.404495] [c0000004e7693c30] [c0000000005e0fc8] kill_block_super+0x38/=
0xb0
[73305.404504] [c0000004e7693c60] [c0000000005e2450]
deactivate_locked_super+0x80/0x140
[73305.404514] [c0000004e7693ca0] [c00000000061effc] cleanup_mnt+0x15c/0x240
[73305.404522] [c0000004e7693cf0] [c00000000019e674] task_work_run+0xb4/0x1=
20
[73305.404531] [c0000004e7693d40] [c000000000022fd4]
do_notify_resume+0x134/0x140
[73305.404541] [c0000004e7693d70] [c0000000000312a0]
interrupt_exit_user_prepare_main+0x220/0x280
[73305.404551] [c0000004e7693de0] [c0000000000316c4]
syscall_exit_prepare+0xe4/0x1e0
[73305.404559] [c0000004e7693e10] [c00000000000c17c]
system_call_vectored_common+0xfc/0x280
[73305.404569] --- interrupt: 3000 at 0x7fffa21af7e4
[73305.404575] NIP:  00007fffa21af7e4 LR: 0000000000000000 CTR:
0000000000000000
[73305.404582] REGS: c0000004e7693e80 TRAP: 3000   Tainted: G        W=20=
=20=20=20=20=20=20=20=20
(5.14.0-rc4+)
[73305.404589] MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE> =
 CR:
28002404  XER: 00000000
[73305.404607] IRQMASK: 0=20
               GPR00: 0000000000000034 00007ffff7de64c0 00007fffa22a7100
0000000000000000=20
               GPR04: 0000000000000000 00007ffff7de64d8 0000000000000000
0000000000000073=20
               GPR08: 0000000000000000 0000000000000000 0000000000000000
0000000000000000=20
               GPR12: 0000000000000000 00007fffa23dbf10 0000000000000000
ffffffffffffffff=20
               GPR16: 0000000000000000 00007ffff7de67a0 0000000000000000
00007ffff7de6834=20
               GPR20: 000000000ee6b280 0000000128b965a8 00007ffff7de67a0
00007ffff7de7e40=20
               GPR24: 0000000128b96510 0000000000000000 0000000128b96508
0000010002f90630=20
               GPR28: 0000010002f90510 0000000000000000 0000010002f95110
0000010002f90400=20
[73305.404681] NIP [00007fffa21af7e4] 0x7fffa21af7e4
[73305.404686] LR [0000000000000000] 0x0
[73305.404691] --- interrupt: 3000
[73305.404695] Instruction dump:
[73305.404700] e888dd80 7d264b78 7d455378 f8010010 f821ffa1 4bfff70d 3d2200=
00
e929dd88=20
[73305.404714] 8929000c 2c090000 41820008 0fe00000 <0fe00000> 38210060 e801=
0010
7c0803a6=20
[73305.404728] irq event stamp: 0
[73305.404732] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[73305.404738] hardirqs last disabled at (0): [<c00000000015d3b4>]
copy_process+0x814/0x19c0
[73305.404746] softirqs last  enabled at (0): [<c00000000015d3b4>]
copy_process+0x814/0x19c0
[73305.404753] softirqs last disabled at (0): [<0000000000000000>] 0x0
[73305.404759] ---[ end trace 7b942b5bf64fe010 ]---
[73305.483620] XFS: Assertion failed: atomic_read(&pag->pag_ref) =3D=3D 0, =
file:
fs/xfs/libxfs/xfs_ag.c, line: 176
[73305.483656] ------------[ cut here ]------------
[73305.483661] WARNING: CPU: 0 PID: 0 at fs/xfs/xfs_message.c:112
assfail+0x54/0x70 [xfs]
[73305.483754] Modules linked in: ext2 overlay dm_zero dm_log_writes
dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot dm_bufio ext4 mbc=
ache
jbd2 loop dm_flakey dm_mod bonding tls rfkill sunrpc pseries_rng drm fuse
drm_panel_orientation_quirks xfs libcrc32c sd_mod t10_pi sg ibmvscsi ibmveth
scsi_transport_srp vmx_crypto [last unloaded: scsi_debug]
[73305.483804] CPU: 0 PID: 0 Comm: swapper/0 Kdump: loaded Tainted: G      =
  W=20
       5.14.0-rc4+ #1
[73305.483812] NIP:  c008000005549d68 LR: c008000005549d50 CTR:
000000007fffffff
[73305.483819] REGS: c000000002c93390 TRAP: 0700   Tainted: G        W=20=
=20=20=20=20=20=20=20=20
(5.14.0-rc4+)
[73305.483826] MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28022484=
=20
XER: 00000010
[73305.483841] CFAR: c008000005549d60 IRQMASK: 0=20
               GPR00: c008000005549d50 c000000002c93630 c0080000055b8000
ffffffffffffffea=20
               GPR04: 000000000000000a c000000002c935b0 ffffffffffffffc0
0000000000000000=20
               GPR08: 0000000000000000 0000000000000000 0000000000000000
c008000005586a78=20
               GPR12: c0000000008848e0 c0000000049c0000 0000000000000001
0000000000000000=20
               GPR16: c000000002cc7a00 0000000000000000 0000000000000000
c000000002b0dd00=20
               GPR20: c0000007fba563a0 c000000000264050 c000000000264050
000000000000000b=20
               GPR24: c0000007fba56300 c000000002c936e0 000000000000000a
c00000000104a5f0=20
               GPR28: c000000002adda00 c000000002befa00 c00000004e1f2800
c00000004e1f2bd8=20
[73305.483915] NIP [c008000005549d68] assfail+0x54/0x70 [xfs]
[73305.484000] LR [c008000005549d50] assfail+0x3c/0x70 [xfs]
[73305.484085] Call Trace:
[73305.484089] [c000000002c93630] [c008000005549d50] assfail+0x3c/0x70 [xfs]
(unreliable)
[73305.484175] [c000000002c93690] [c008000005402cf8] __xfs_free_perag+0xb0/=
0xe0
[xfs]
[73305.484246] [c000000002c936c0] [c0000000002640bc] rcu_do_batch+0x26c/0x7=
40
[73305.484255] [c000000002c93780] [c0000000002675ec] rcu_core+0x25c/0x320
[73305.484263] [c000000002c937c0] [c000000000ffc8c8] __do_softirq+0x228/0x6=
ec
[73305.484272] [c000000002c938d0] [c00000000016e524] __irq_exit_rcu+0x234/0=
x250
[73305.484283] [c000000002c93900] [c00000000016e770] irq_exit+0x20/0x50
[73305.484291] [c000000002c93920] [c000000000029ad0]
timer_interrupt+0x1c0/0x540
[73305.484301] [c000000002c93990] [c000000000009a00]
decrementer_common_virt+0x210/0x220
[73305.484311] --- interrupt: 900 at plpar_hcall_norets_notrace+0x18/0x2c
[73305.484319] NIP:  c0000000000feae8 LR: c000000000c126e4 CTR:
0000000000000000
[73305.484325] REGS: c000000002c93a00 TRAP: 0900   Tainted: G        W=20=
=20=20=20=20=20=20=20=20
(5.14.0-rc4+)
[73305.484332] MSR:  800000000280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR:
28000882  XER: 00000010
[73305.484349] CFAR: 0000000000000c00 IRQMASK: 0=20
               GPR00: 0000000000000000 c000000002c93ca0 c000000002c94100
0000000000000000=20
               GPR04: 00000000000000c0 0000000000000080 000c5a8e5e7326bd
000000000000031b=20
               GPR08: 000000000001f400 0000000000000001 0000000000000000
0000000000000000=20
               GPR12: 0000000000000000 c0000000049c0000 0000000000000000
0000000000000000=20
               GPR16: 0000000000000000 0000000000000000 000000000f7f73f8
000000000f7e54a8=20
               GPR20: 0000000000000001 00000000089ffcb4 0000000000000000
000000000f877e18=20
               GPR24: 0000000011251b80 0000000000000000 000042abc2b6ca10
0000000000000001=20
               GPR28: 0000000000000000 0000000000000001 c000000002161bb8
c000000002161bc0=20
[73305.484424] NIP [c0000000000feae8] plpar_hcall_norets_notrace+0x18/0x2c
[73305.484431] LR [c000000000c126e4] check_and_cede_processor.part.0+0x24/0=
x70
[73305.484439] --- interrupt: 900
[73305.484443] [c000000002c93ca0] [0000000000000000] 0x0 (unreliable)
[73305.484451] [c000000002c93d00] [c000000000c12d04]
dedicated_cede_loop+0x164/0x210
[73305.484459] [c000000002c93d40] [c000000000c0f6cc]
cpuidle_enter_state+0x2bc/0x500
[73305.484469] [c000000002c93da0] [c000000000c0f9ac] cpuidle_enter+0x4c/0x70
[73305.484478] [c000000002c93de0] [c0000000001cece0]
cpuidle_idle_call+0x1c0/0x2f0
[73305.484486] [c000000002c93e30] [c0000000001cef94] do_idle+0x184/0x240
[73305.484494] [c000000002c93e90] [c0000000001cf42c]
cpu_startup_entry+0x3c/0x40
[73305.484502] [c000000002c93ec0] [c000000000012f14] rest_init+0x214/0x380
[73305.484510] [c000000002c93f00] [c0000000020051cc] start_kernel+0x674/0x6=
b0
[73305.484519] [c000000002c93f90] [c00000000000d39c]
start_here_common+0x1c/0x600
[73305.484527] Instruction dump:
[73305.484532] e888dd80 7d264b78 7d455378 f8010010 f821ffa1 4bfff70d 3d2200=
00
e929dd88=20
[73305.484546] 8929000c 2c090000 41820008 0fe00000 <0fe00000> 38210060 e801=
0010
7c0803a6=20
[73305.484559] irq event stamp: 303475094
[73305.484563] hardirqs last  enabled at (303475093): [<c0000000002a8e14>]
tick_nohz_idle_exit+0x94/0x290
[73305.484573] hardirqs last disabled at (303475094): [<c000000000fef914>]
__schedule+0x94/0x8b0
[73305.484583] softirqs last  enabled at (303475088): [<c000000000ffcd1c>]
__do_softirq+0x67c/0x6ec
[73305.484592] softirqs last disabled at (303474779): [<c00000000016e524>]
__irq_exit_rcu+0x234/0x250
[73305.484601] ---[ end trace 7b942b5bf64fe011 ]---
[73305.748779] XFS (sda5): Unmounting Filesystem

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
