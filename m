Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4031FC4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 03:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23E416135D
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 03:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbhHWDPW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Aug 2021 23:15:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234858AbhHWDN7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 22 Aug 2021 23:13:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 56E2061362
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 03:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629688397;
        bh=/M1MH8tfVmjkxUXsvAXQhgBfNvaF67K6mHyz5j+glVk=;
        h=From:To:Subject:Date:From;
        b=oMuO5V2bliDk7xPe9prPHzYG3y0Gn1B0vtW6ijMY86Vihteep9R6WABZXuINrVXBa
         GA2kRQrAbSg2kvdkjwfTGaPwpi1guR3el5JypUXASsqgZoyLxFIrFHP8Qc1GytGffS
         HSCFmuc8yDvJrrmSTDydfobJV83sq1ZRsKuZ7hg2OX84R7gx2/q9/sGqX4QKc67mAb
         hOeVDvjFKtfY6RKJmFEcM/iAopTR7KjyYCPAHAdyHG8AIsmUeN25CB3XQkE7Sd3xNA
         OOc5UooM5m+UMaDt/i9guoUFufjHHLl+f0Zn5onaMQ2SROTKPw2VsoUyLj+hFVBZCc
         ofeQtfqqklFlA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214139] New: [xfstests xfs/319] XFS: Assertion failed:
 got.br_startoff > bno, file: fs/xfs/libxfs/xfs_bmap.c, line: 4715
Date:   Mon, 23 Aug 2021 03:13:16 +0000
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
Message-ID: <bug-214139-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214139

            Bug ID: 214139
           Summary: [xfstests xfs/319] XFS: Assertion failed:
                    got.br_startoff > bno, file: fs/xfs/libxfs/xfs_bmap.c,
                    line: 4715
           Product: File System
           Version: 2.5
    Kernel Version: xfs-5.15-merge-2
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

xfstests xfs/319 fails:
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 ibm-x3550m3-05-vm-00 5.14.0-rc4+ #1 SMP Tue A=
ug
17 11:27:48 EDT 2021
MKFS_OPTIONS  -- -f -m crc=3D1,finobt=3D1,reflink=3D1,rmapbt=3D0,bigtime=3D=
1,inobtcount=3D1
-b size=3D1024 /dev/sda3
MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /dev/sda3
/mnt/xfstests/scratch

xfs/319 _check_xfs_filesystem: filesystem on /dev/sda3 is inconsistent (c)
(see /var/lib/xfstests/results//xfs/319.full for details)
_check_xfs_filesystem: filesystem on /dev/sda3 is inconsistent (r)
(see /var/lib/xfstests/results//xfs/319.full for details)
_check_dmesg: something found in dmesg (see
/var/lib/xfstests/results//xfs/319.dmesg)


[ 1694.392358] run fstests xfs/319 at 2021-08-17 15:31:46
[ 1699.554713] XFS (sda3): Mounting V5 Filesystem
[ 1699.609279] XFS (sda3): Ending clean mount
[ 1699.736279] xfs_io (109413) used greatest stack depth: 21320 bytes left
[ 1699.813788] XFS (sda3): Unmounting Filesystem
[ 1700.925634] XFS (sda3): Mounting V5 Filesystem
[ 1700.980578] XFS (sda3): Ending clean mount
[ 1701.364257] cp (109449) used greatest stack depth: 21160 bytes left
[ 1702.357673] XFS (sda3): Injecting error (false) at file
fs/xfs/libxfs/xfs_bmap.c, line 6256, on filesystem "sda3"
[ 1702.385907] XFS (sda3): Corruption of in-memory data (0x8) detected at
xfs_defer_finish_noroll+0x320/0xb90 [xfs] (fs/xfs/libxfs/xfs_defer.c:504).=
=20
Shutting down filesystem
[ 1702.391088] XFS (sda3): Please unmount the filesystem and rectify the
problem(s)
[ 1702.512505] XFS (sda3): Unmounting Filesystem
[ 1703.325683] XFS (sda3): Mounting V5 Filesystem
[ 1703.405331] XFS (sda3): Starting recovery (logdev: internal)
[ 1703.450253] XFS: Assertion failed: got.br_startoff > bno, file:
fs/xfs/libxfs/xfs_bmap.c, line: 4715
[ 1703.453446] ------------[ cut here ]------------
[ 1703.454839] WARNING: CPU: 5 PID: 109480 at fs/xfs/xfs_message.c:112
assfail+0x56/0x59 [xfs]
[ 1703.457822] Modules linked in: rfkill snd_hda_codec_generic ledtrig_audio
snd_hda_intel snd_intel_dspcfg snd_hda_codec qxl snd_hda_core kvm_intel
snd_hwdep drm_ttm_helper ttm sunrpc snd_seq kvm drm_kms_helper snd_seq_devi=
ce
snd_pcm syscopyarea sysfillrect sysimgblt snd_timer fb_sys_fops snd irqbypa=
ss
cec joydev soundcore virtio_balloon pcspkr i2c_piix4 drm fuse xfs libcrc32c
sd_mod t10_pi crct10dif_pclmul ata_generic crc32_pclmul crc32c_intel
virtio_console ata_piix ghash_clmulni_intel 8139too libata serio_raw 8139cp=
 mii
[ 1703.473242] CPU: 5 PID: 109480 Comm: mount Kdump: loaded Not tainted
5.14.0-rc4+ #1
[ 1703.475799] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[ 1703.477787] RIP: 0010:assfail+0x56/0x59 [xfs]
[ 1703.479528] Code: 2a 83 e0 07 48 c1 e9 03 8a 14 11 38 c2 7f 10 84 d2 74 =
0c
48 c7 c7 4c a1 6a c0 e8 bb 43 80 d4 80 3d b0 06 17 00 00 74 02 0f 0b <0f> 0=
b c3
48 8d 45 10 48 8d 54 24 28 4c 89 f6 48 c7 c7 40 7c 56 c0
[ 1703.485676] RSP: 0018:ffffc90000e475d8 EFLAGS: 00010246
[ 1703.487505] RAX: 0000000000000004 RBX: 0000000000000000 RCX:
1ffffffff80d5429
[ 1703.489924] RDX: dffffc0000000000 RSI: dffffc0000000000 RDI:
fffff520001c8ead
[ 1703.492423] RBP: ffffc90000e47728 R08: ffffc90000e47468 R09:
ffff88817a3f1647
[ 1703.494827] R10: ffffed102f47e2c8 R11: 0000000000000001 R12:
ffff8881193ede10
[ 1703.497267] R13: ffff888176de9048 R14: ffff888109c18000 R15:
0000000000000000
[ 1703.499709] FS:  00007f07f98bf4c0(0000) GS:ffff88817a200000(0000)
knlGS:0000000000000000
[ 1703.502430] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1703.504391] CR2: 00005640c4cd29cc CR3: 0000000130982005 CR4:
00000000000206e0
[ 1703.506921] Call Trace:
[ 1703.507878]  xfs_bmapi_remap+0x658/0x740 [xfs]
[ 1703.509724]  ? xfs_bmapi_convert_delalloc+0xc00/0xc00 [xfs]
[ 1703.512018]  ? sched_clock_cpu+0x15/0x170
[ 1703.513626]  xfs_bmap_finish_one+0x3b7/0x650 [xfs]
[ 1703.515670]  ? xfs_bui_item_recover+0x4a1/0x860 [xfs]
[ 1703.517803]  xfs_bui_item_recover+0x57b/0x860 [xfs]
[ 1703.519849]  ? xlog_recover_bud_commit_pass2+0x140/0x140 [xfs]
[ 1703.522112]  ? lock_downgrade+0x110/0x110
[ 1703.523545]  ? do_raw_spin_trylock+0xb5/0x180
[ 1703.524870]  ? xlog_recover_process_intents+0x229/0xd50 [xfs]
[ 1703.526823]  xlog_recover_process_intents+0x269/0xd50 [xfs]
[ 1703.528708]  ? xlog_recover_add_to_cont_trans+0x5b0/0x5b0 [xfs]
[ 1703.530697]  ? __lock_release+0x494/0xa40
[ 1703.531919]  ? lock_downgrade+0x110/0x110
[ 1703.533205]  xlog_recover_finish+0x4b/0x360 [xfs]
[ 1703.534827]  xfs_log_mount_finish+0x112/0x570 [xfs]
[ 1703.536488]  ? xfs_fs_reserve_ag_blocks+0xca/0x150 [xfs]
[ 1703.538279]  xfs_mountfs+0xf88/0x1a50 [xfs]
[ 1703.539771]  ? __module_address.part.0+0x25/0x300
[ 1703.541194]  ? is_kernel_percpu_address+0x7d/0x100
[ 1703.542652]  ? xfs_default_resblks+0x60/0x60 [xfs]
[ 1703.544335]  ? queue_work_node+0x1a0/0x1a0
[ 1703.545594]  ? rcu_read_lock_sched_held+0x3f/0x70
[ 1703.547032]  xfs_fs_fill_super+0xae5/0x1840 [xfs]
[ 1703.548664]  get_tree_bdev+0x39e/0x690
[ 1703.549878]  ? trace_xfs_inode_timestamp_range+0x230/0x230 [xfs]
[ 1703.551856]  vfs_get_tree+0x8a/0x2d0
[ 1703.552968]  do_new_mount+0x224/0x550
[ 1703.554109]  ? do_add_mount+0x370/0x370
[ 1703.555270]  ? bpf_lsm_capset+0x10/0x10
[ 1703.556447]  ? security_capable+0x56/0x90
[ 1703.557704]  path_mount+0x2be/0x1630
[ 1703.558803]  ? strncpy_from_user+0x6f/0x2c0
[ 1703.560122]  ? finish_automount+0x8d0/0x8d0
[ 1703.561396]  ? getname_flags.part.0+0x8e/0x450
[ 1703.562789]  __x64_sys_mount+0x1fa/0x270
[ 1703.563980]  ? path_mount+0x1630/0x1630
[ 1703.565187]  ? ktime_get_coarse_real_ts64+0x128/0x160
[ 1703.566804]  do_syscall_64+0x3b/0x90
[ 1703.568073]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 1703.569604] RIP: 0033:0x7f07f9aa187e
[ 1703.570781] Code: 48 8b 0d ad 75 0e 00 f7 d8 64 89 01 48 83 c8 ff c3 66 =
2e
0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3=
d 01
f0 ff ff 73 01 c3 48 8b 0d 7a 75 0e 00 f7 d8 64 89 01 48
[ 1703.576041] RSP: 002b:00007fff8aab64e8 EFLAGS: 00000246 ORIG_RAX:
00000000000000a5
[ 1703.578310] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007f07f9aa187e
[ 1703.580340] RDX: 00005593ca9de6d0 RSI: 00005593ca9de710 RDI:
00005593ca9de6f0
[ 1703.582378] RBP: 00005593ca9de400 R08: 00005593ca9de670 R09:
00007fff8aab5210
[ 1703.584393] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[ 1703.586411] R13: 00005593ca9de6d0 R14: 00005593ca9de6f0 R15:
00005593ca9de400
[ 1703.588532] irq event stamp: 17563
[ 1703.589567] hardirqs last  enabled at (17573): [<ffffffff9477bdbd>]
console_unlock+0x4dd/0x5f0
[ 1703.592054] hardirqs last disabled at (17582): [<ffffffff9477bd4e>]
console_unlock+0x46e/0x5f0
[ 1703.594481] softirqs last  enabled at (17028): [<ffffffff968005ca>]
__do_softirq+0x5ca/0x90f
[ 1703.596911] softirqs last disabled at (17019): [<ffffffff945fb8a7>]
__irq_exit_rcu+0x207/0x280
[ 1703.599348] ---[ end trace 9daaa2bace9695ae ]---
[ 1703.600699] XFS: Assertion failed: got.br_startoff - bno >=3D len, file:
fs/xfs/libxfs/xfs_bmap.c, line: 4716
[ 1703.603504] ------------[ cut here ]------------
[ 1703.604863] WARNING: CPU: 5 PID: 109480 at fs/xfs/xfs_message.c:112
assfail+0x56/0x59 [xfs]
[ 1703.607574] Modules linked in: rfkill snd_hda_codec_generic ledtrig_audio
snd_hda_intel snd_intel_dspcfg snd_hda_codec qxl snd_hda_core kvm_intel
snd_hwdep drm_ttm_helper ttm sunrpc snd_seq kvm drm_kms_helper snd_seq_devi=
ce
snd_pcm syscopyarea sysfillrect sysimgblt snd_timer fb_sys_fops snd irqbypa=
ss
cec joydev soundcore virtio_balloon pcspkr i2c_piix4 drm fuse xfs libcrc32c
sd_mod t10_pi crct10dif_pclmul ata_generic crc32_pclmul crc32c_intel
virtio_console ata_piix ghash_clmulni_intel 8139too libata serio_raw 8139cp=
 mii
[ 1703.621261] CPU: 5 PID: 109480 Comm: mount Kdump: loaded Tainted: G     =
   W
        5.14.0-rc4+ #1
[ 1703.623845] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[ 1703.625531] RIP: 0010:assfail+0x56/0x59 [xfs]
[ 1703.627153] Code: 2a 83 e0 07 48 c1 e9 03 8a 14 11 38 c2 7f 10 84 d2 74 =
0c
48 c7 c7 4c a1 6a c0 e8 bb 43 80 d4 80 3d b0 06 17 00 00 74 02 0f 0b <0f> 0=
b c3
48 8d 45 10 48 8d 54 24 28 4c 89 f6 48 c7 c7 40 7c 56 c0
[ 1703.632368] RSP: 0018:ffffc90000e475d8 EFLAGS: 00010246
[ 1703.633914] RAX: 0000000000000004 RBX: 0000000000000000 RCX:
1ffffffff80d5429
[ 1703.635987] RDX: dffffc0000000000 RSI: dffffc0000000000 RDI:
fffff520001c8ead
[ 1703.638235] RBP: ffffc90000e47728 R08: ffffc90000e47468 R09:
ffff88817a3f1647
[ 1703.640288] R10: ffffed102f47e2c8 R11: 0000000000000001 R12:
ffff8881193ede10
[ 1703.642350] R13: ffff888176de9048 R14: ffff888109c18000 R15:
0000000000000000
[ 1703.644382] FS:  00007f07f98bf4c0(0000) GS:ffff88817a200000(0000)
knlGS:0000000000000000
[ 1703.646668] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1703.648362] CR2: 00005640c4cd29cc CR3: 0000000130982005 CR4:
00000000000206e0
[ 1703.650394] Call Trace:
[ 1703.651167]  xfs_bmapi_remap+0x68c/0x740 [xfs]

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
