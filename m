Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACF8C3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 10:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15C3B206BB
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 10:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbfH0KFo convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 06:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbfH0KFo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Aug 2019 06:05:44 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 201819] [xfstests generic/299]: WARNING: CPU: 15 PID: 23147 at
 kernel/workqueue.c:4170 destroy_workqueue+0x118/0x590
Date:   Tue, 27 Aug 2019 10:05:43 +0000
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
Message-ID: <bug-201819-201763-NrDcZ6kW9A@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201819-201763@https.bugzilla.kernel.org/>
References: <bug-201819-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201819

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
Hit this issue again on xfs-linux xfs-5.3-fixes-6:

[106054.030958] run fstests generic/270 at 2019-08-27 04:23:38
[106055.933668] XFS (sda3): Mounting V5 Filesystem
[106055.978106] XFS (sda3): Ending clean mount
[106055.983144] XFS (sda3): Quotacheck needed: Please wait.
[106056.112537] XFS (sda3): Quotacheck: Done.
[106209.302559] 270 (9465): drop_caches: 3
[106210.119303] XFS (sda3): Unmounting Filesystem
[106210.479206] ------------[ cut here ]------------
[106210.483938] WARNING: CPU: 1 PID: 9903 at kernel/workqueue.c:4335
destroy_workqueue+0x12d/0x5a0
[106210.492616] Modules linked in: dm_log_writes dm_mod intel_rapl_msr iTCO_wdt
iTCO_vendor_support mei_wdt dcdbas dell_smm_hwmon intel_rapl_common skx_edac
nfit x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel
snd_hda_codec_realtek kvm snd_hda_codec_generic ledtrig_audio
snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hda_core irqbypass
crct10dif_pclmul snd_hwdep crc32_pclmul snd_seq ghash_clmulni_intel
snd_seq_device intel_cstate dell_wmi snd_pcm intel_uncore intel_rapl_perf
sparse_keymap pcspkr snd_timer video snd dax_pmem_compat nd_pmem device_dax
dax_pmem_core dell_smbios wmi_bmof dell_wmi_descriptor intel_wmi_thunderbolt
soundcore mei_me mei sg i2c_i801 sunrpc ioatdma dca xfs libcrc32c sr_mod cdrom
sd_mod radeon i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt
fb_sys_fops ttm ahci libahci uas crc32c_intel drm serio_raw e1000e libata
usb_storage wmi
[106210.569964] CPU: 1 PID: 9903 Comm: umount Not tainted 5.3.0-rc2+ #1
[106210.576304] Hardware name: Dell Inc. Precision 5820 Tower/0CK05C, BIOS
0.6.0 07/19/2017
[106210.584379] RIP: 0010:destroy_workqueue+0x12d/0x5a0
[106210.589333] Code: 89 f8 48 c1 e8 03 42 0f b6 04 28 84 c0 74 08 3c 03 0f 8e
32 04 00 00 41 83 7e 18 01 7e 13 48 c7 c7 00 86 28 a7 e8 1c 44 12 00 <0f> 0b e9
12 4c 00 00 49 8d 7e 58 48 89 f8 48 c1 e8 03 42 0f b6 04
[106210.608151] RSP: 0018:ffff88810a5d7d08 EFLAGS: 00010286
[106210.613450] RAX: 0000000000000024 RBX: ffffe8fffea4f458 RCX:
ffffffffa5c323b2
[106210.620657] RDX: 0000000000000000 RSI: 0000000000000008 RDI:
ffff88811a7e740c
[106210.627863] RBP: ffff888014c89e00 R08: ffffed10234fe099 R09:
ffffed10234fe099
[106210.635067] R10: ffffed10234fe098 R11: ffff88811a7f04c7 R12:
ffffed10029913e4
[106210.642272] R13: dffffc0000000000 R14: ffffe8fffea4f400 R15:
000000000000000f
[106210.649480] FS:  00007fbf7f4e1080(0000) GS:ffff88811a600000(0000)
knlGS:0000000000000000
[106210.657637] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[106210.663455] CR2: 00007f85fc101000 CR3: 00000001127a4004 CR4:
00000000003606e0
[106210.670659] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[106210.677863] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[106210.685068] Call Trace:
[106210.687793]  xfs_destroy_mount_workqueues+0xe7/0x150 [xfs]
[106210.693388]  xfs_fs_put_super+0x9f/0x100 [xfs]
[106210.697913]  generic_shutdown_super+0x12e/0x330
[106210.702522]  kill_block_super+0x94/0xe0
[106210.706436]  deactivate_locked_super+0x82/0xd0
[106210.710958]  deactivate_super+0x123/0x140
[106210.715046]  ? freeze_super+0x290/0x290
[106210.718962]  ? _raw_spin_unlock+0x24/0x30
[106210.723049]  ? dput+0x11a/0x8c0
[106210.726273]  cleanup_mnt+0x1ee/0x3c0
[106210.729929]  task_work_run+0x104/0x190
[106210.733761]  exit_to_usermode_loop+0x143/0x160
[106210.738283]  do_syscall_64+0x3fa/0x500
[106210.742111]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[106210.747238] RIP: 0033:0x7fbf7e51c16b
[106210.750893] Code: 0d 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 90 f3 0f 1e fa
31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e fa b8 a6 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d ed 0c 2c 00 f7 d8 64 89 01 48
[106210.769710] RSP: 002b:00007ffe156e2298 EFLAGS: 00000246 ORIG_RAX:
00000000000000a6
[106210.777350] RAX: 0000000000000000 RBX: 00005631a94f02d0 RCX:
00007fbf7e51c16b
[106210.784555] RDX: 0000000000000001 RSI: 0000000000000000 RDI:
00005631a94f9000
[106210.791760] RBP: 0000000000000000 R08: 00005631a94f8610 R09:
00007fbf7e59e300
[106210.798966] R10: 0000000000000000 R11: 0000000000000246 R12:
00005631a94f9000
[106210.806171] R13: 00007fbf7f2c8184 R14: 00005631a94f04b0 R15:
00000000ffffffff
[106210.813382] irq event stamp: 0
[106210.816515] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[106210.822857] hardirqs last disabled at (0): [<ffffffffa4fe1be4>]
copy_process+0x19c4/0x6510
[106210.831188] softirqs last  enabled at (0): [<ffffffffa4fe1c80>]
copy_process+0x1a60/0x6510
[106210.839519] softirqs last disabled at (0): [<0000000000000000>] 0x0
[106210.845857] ---[ end trace f560decc3c76b0f1 ]---
[106210.850568] Showing busy workqueues and worker pools:
[106210.855699] workqueue events: flags=0x0
[106210.859621]   pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=1/256
[106210.865704]     pending: free_obj_work
[106210.869550] workqueue mm_percpu_wq: flags=0x8
[106210.873989]   pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=1/256
[106210.880068]     pending: vmstat_update
[106211.175544] XFS (sda3): Mounting V5 Filesystem
[106211.324636] XFS (sda3): Ending clean mount
[106218.059451] XFS (sda3): Unmounting Filesystem
[106218.200093] XFS (sda3): Mounting V5 Filesystem
[106218.293378] XFS (sda3): Ending clean mount
[106218.340576] XFS (sda3): Quotacheck needed: Please wait.
[106224.712481] XFS (sda3): Quotacheck: Done.
[106225.304201] XFS (sda3): Unmounting Filesystem
[106225.774772] XFS (sda2): Unmounting Filesystem

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
