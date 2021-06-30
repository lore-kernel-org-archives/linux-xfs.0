Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA68C11F67
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 03:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AF2B61CD6
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 03:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbhF3DPo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Jun 2021 23:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232222AbhF3DPo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Jun 2021 23:15:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 44E3861CEF
        for <linux-xfs@vger.kernel.org>; Wed, 30 Jun 2021 03:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625022796;
        bh=GHq6qgF16d/EwQj0Fj6Yat3MCuOXIDfeZjxuTSkUQfE=;
        h=From:To:Subject:Date:From;
        b=nl9M7qJD+hiiprSghu0/Pi341/31Ksko52hfUy43l1ajX9YzXq/4v7sRWCUHdayLE
         1lv1n7jwaht5UgbxCH3hx83BHKfeqILTVmYP/BZ7qOWPpjmv63BHO34WfLmTgKURCx
         YgsNXKbqtU6+8z35+9bnkvrY2jVbBRb9h56KDuYXYVBY6xdEcoAGScPQdclIONMTNg
         s8MTwCkT8wFI+5/yoasD55QoK/8qryZDciiGLuipf5kVS4sIXZEWc6FVxpF3cQ9JI7
         AIG4TSCy2xu0kUnw3mjtwRaDAvbGnt0OcoBlpI3A4aTBTbxETrdsJxlQ1lYCshMTZL
         UkVfEqtWz6Fzw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 213625] New: [xfstests xfs/104] XFS: Assertion failed: agno <
 mp->m_sb.sb_agcount, file: fs/xfs/libxfs/xfs_types.c, line: 22
Date:   Wed, 30 Jun 2021 03:13:15 +0000
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
Message-ID: <bug-213625-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213625

            Bug ID: 213625
           Summary: [xfstests xfs/104] XFS: Assertion failed: agno <
                    mp->m_sb.sb_agcount, file: fs/xfs/libxfs/xfs_types.c,
                    line: 22
           Product: File System
           Version: 2.5
    Kernel Version: 5.13.0-rc4 + xfs-5.14-merge-6
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

xfstests xfs/104 hit below assertion failure sometimes:

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 xx-xxxxxx-xx 5.13.0-rc4 #1 SMP Tue Jun 29
05:50:25 EDT 2021
MKFS_OPTIONS  -- -f -m crc=3D1,finobt=3D1,rmapbt=3D0,reflink=3D1,bigtime=3D=
1,inobtcount=3D1
/dev/sda4
MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /dev/sda4
/mnt/xfstests/scratch

xfs/104 65s ... _check_dmesg: something found in dmesg (see
/var/lib/xfstests/results//xfs/104.dmesg)

Ran: xfs/104
Failures: xfs/104
Failed 1 of 1 tests

[13125.805128] run fstests xfs/104 at 2021-06-29 10:24:52
[13134.956592] XFS (sda4): EXPERIMENTAL big timestamp feature in use. Use at
your own risk!
[13134.995357] XFS (sda4): EXPERIMENTAL inode btree counters feature in use.
Use at your own risk!
[13135.038187] XFS (sda4): Mounting V5 Filesystem
[13135.390309] XFS (sda4): Ending clean mount
[13139.312723] XFS: Assertion failed: agno < mp->m_sb.sb_agcount, file:
fs/xfs/libxfs/xfs_types.c, line: 22
[13139.359309] ------------[ cut here ]------------
[13139.380510] WARNING: CPU: 10 PID: 408971 at fs/xfs/xfs_message.c:112
assfail+0x56/0x59 [xfs]
[13139.419539] Modules linked in: intel_rapl_msr intel_rapl_common sb_edac
x86_pkg_temp_thermal iTCO_wdt intel_powerclamp iTCO_vendor_support coretemp
kvm_intel kvm irqbypass rapl intel_cstate intel_uncore pcspkr rfkill mgag200
i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops
lpc_ich cec hpilo ioatdma ipmi_ssif dca acpi_ipmi ipmi_si sunrpc ipmi_devin=
tf
ipmi_msghandler acpi_power_meter drm fuse xfs libcrc32c sd_mod ata_generic
crct10dif_pclmul t10_pi crc32_pclmul crc32c_intel ata_piix ghash_clmulni_in=
tel
serio_raw libata hpsa tg3 hpwdt scsi_transport_sas
[13139.653264] CPU: 10 PID: 408971 Comm: xfsaild/sda4 Not tainted 5.13.0-rc=
4 #1
[13139.687177] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 09/18/2013
[13139.718906] RIP: 0010:assfail+0x56/0x59 [xfs]
[13139.740817] Code: 2a 83 e0 07 48 c1 e9 03 8a 14 11 38 c2 7f 10 84 d2 74 =
0c
48 c7 c7 0c c3 d1 c0 e8 4f 8c 76 f0 80 3d e4 86 16 00 00 74 02 0f 0b <0f> 0=
b c3
48 8d 45 10 48 8d 54 24 28 4c 89 f6 48 c7 c7 00 17 be c0
[13139.826163] RSP: 0018:ffffc9000e3377b8 EFLAGS: 00010246
[13139.851029] RAX: 0000000000000004 RBX: 0000000000000004 RCX:
1ffffffff81a3861
[13139.883756] RDX: dffffc0000000000 RSI: ffffc9000e3375a8 RDI:
fffff52001c66ee9
[13139.916464] RBP: 000000000003e700 R08: 00000000ffffffea R09:
ffff888828ff0c87
[13139.949143] R10: ffffed11051fe190 R11: 0000000000000001 R12:
ffff8884b0d60000
[13139.981839] R13: ffffed10961ac00b R14: ffff8884b0d601c7 R15:
dffffc0000000000
[13140.014803] FS:  0000000000000000(0000) GS:ffff888828e00000(0000)
knlGS:0000000000000000
[13140.052307] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[13140.078462] CR2: 0000000000ee62e8 CR3: 00000003ad82c001 CR4:
00000000001706e0
[13140.111267] Call Trace:
[13140.122271]  xfs_verify_icount+0x262/0x3c0 [xfs]
[13140.143652]  ? xfs_validate_sb_common+0x98e/0x1160 [xfs]
[13140.167916]  xfs_validate_sb_write.isra.0+0xf2/0x3c0 [xfs]
[13140.193288]  xfs_sb_write_verify+0x1ac/0x3b0 [xfs]
[13140.215459]  ? xfs_validate_sb_common+0x1160/0x1160 [xfs]
[13140.240738]  ? check_prev_add+0x20f0/0x20f0
[13140.259798]  _xfs_buf_ioapply+0x15f/0x5b0 [xfs]
[13140.280455]  ? _xfs_buf_map_pages+0x420/0x420 [xfs]
[13140.302672]  ? xfs_buf_ioapply_map+0x690/0x690 [xfs]
[13140.324783]  ? __lock_contended+0x910/0x910
[13140.344264]  ? do_raw_spin_trylock+0xb5/0x180
[13140.364835]  ? wake_up_q+0x110/0x110
[13140.381298]  ? __xfs_buf_submit+0x128/0x6a0 [xfs]
[13140.402870]  ? xfs_buf_delwri_submit_buffers+0x329/0xac0 [xfs]
[13140.429743]  __xfs_buf_submit+0x21c/0x6a0 [xfs]
[13140.450902]  xfs_buf_delwri_submit_buffers+0x329/0xac0 [xfs]
[13140.477408]  ? __lock_release+0x494/0xa40
[13140.495516]  ? xfs_buf_ioend_work+0x20/0x20 [xfs]
[13140.517556]  ? xfsaild_push+0x424/0x1bc0 [xfs]
[13140.538061]  xfsaild_push+0x42e/0x1bc0 [xfs]
[13140.557609]  ? find_held_lock+0x33/0x110
[13140.575891]  ? xfs_trans_ail_cursor_first+0x180/0x180 [xfs]
[13140.601775]  xfsaild+0x176/0x9b0 [xfs]
[13140.618811]  ? lockdep_hardirqs_on_prepare.part.0+0x19a/0x350
[13140.645262]  ? xfsaild_push+0x1bc0/0x1bc0 [xfs]
[13140.666210]  ? __kthread_parkme+0xcb/0x1b0
[13140.684802]  ? xfsaild_push+0x1bc0/0x1bc0 [xfs]
[13140.706111]  kthread+0x368/0x440
[13140.720737]  ? _raw_spin_unlock_irq+0x24/0x30
[13140.740567]  ? set_mems_allowed+0x300/0x300
[13140.759764]  ret_from_fork+0x22/0x30
[13140.775837] irq event stamp: 1351
[13140.790863] hardirqs last  enabled at (1361): [<ffffffffb0d6718d>]
console_unlock+0x4dd/0x5f0
[13140.829443] hardirqs last disabled at (1370): [<ffffffffb0d6711e>]
console_unlock+0x46e/0x5f0
[13140.868951] softirqs last  enabled at (1238): [<ffffffffb2e00608>]
__do_softirq+0x608/0x940
[13140.906939] softirqs last disabled at (1231): [<ffffffffb0bf53d0>]
__irq_exit_rcu+0x200/0x2c0
[13140.945886] ---[ end trace 16aeb6c1e80505cc ]---
[13143.646976] XFS (sda4): xlog_verify_grant_tail: space > BBTOB(tail_block=
s)
[13143.646977] XFS (sda4): xlog_verify_grant_tail: space > BBTOB(tail_block=
s)
[13184.651417] XFS (sda4): Unmounting Filesystem
[13185.083451] XFS: Assertion failed: atomic_read(&pag->pag_ref) =3D=3D 0, =
file:
fs/xfs/libxfs/xfs_ag.c, line: 195
[13185.127684] ------------[ cut here ]------------
[13185.148627] WARNING: CPU: 16 PID: 409327 at fs/xfs/xfs_message.c:112
assfail+0x56/0x59 [xfs]
[13185.188085] Modules linked in: intel_rapl_msr intel_rapl_common sb_edac
x86_pkg_temp_thermal iTCO_wdt intel_powerclamp iTCO_vendor_support coretemp
kvm_intel kvm irqbypass rapl intel_cstate intel_uncore pcspkr rfkill mgag200
i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops
lpc_ich cec hpilo ioatdma ipmi_ssif dca acpi_ipmi ipmi_si sunrpc ipmi_devin=
tf
ipmi_msghandler acpi_power_meter drm fuse xfs libcrc32c sd_mod ata_generic
crct10dif_pclmul t10_pi crc32_pclmul crc32c_intel ata_piix ghash_clmulni_in=
tel
serio_raw libata hpsa tg3 hpwdt scsi_transport_sas
[13185.422572] CPU: 16 PID: 409327 Comm: umount Tainted: G        W=20=20=
=20=20=20=20=20=20
5.13.0-rc4 #1
[13185.458693] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 09/18/2013
[13185.489177] RIP: 0010:assfail+0x56/0x59 [xfs]
[13185.509421] Code: 2a 83 e0 07 48 c1 e9 03 8a 14 11 38 c2 7f 10 84 d2 74 =
0c
48 c7 c7 0c c3 d1 c0 e8 4f 8c 76 f0 80 3d e4 86 16 00 00 74 02 0f 0b <0f> 0=
b c3
48 8d 45 10 48 8d 54 24 28 4c 89 f6 48 c7 c7 00 17 be c0
[13185.594701] RSP: 0018:ffffc9000871fd18 EFLAGS: 00010246
[13185.618568] RAX: 0000000000000004 RBX: ffff8884c9ede000 RCX:
1ffffffff81a3861
[13185.650804] RDX: dffffc0000000000 RSI: ffffc9000871fb08 RDI:
fffff520010e3f95
[13185.683813] RBP: 0000000000000005 R08: 00000000ffffffea R09:
ffff8883db3f0c87
[13185.717308] R10: ffffed107b67e190 R11: 0000000000000001 R12:
ffff8884b0d606c8
[13185.750025] R13: ffff8884b0d60000 R14: ffff8884c9ede00c R15:
ffff8884b0d60670
[13185.782750] FS:  00007fe45d15fc40(0000) GS:ffff8883db200000(0000)
knlGS:0000000000000000
[13185.819630] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[13185.845799] CR2: 00007f80869e8000 CR3: 000000052b6e0004 CR4:
00000000001706e0
[13185.878364] Call Trace:
[13185.889489]  xfs_free_perag+0x152/0x1a0 [xfs]
[13185.909657]  xfs_unmountfs+0xfe/0x1a0 [xfs]
[13185.929145]  ? xfs_mountfs+0x18f0/0x18f0 [xfs]
[13185.949335]  xfs_fs_put_super+0x5d/0x170 [xfs]
[13185.970049]  generic_shutdown_super+0x136/0x330
[13185.990792]  kill_block_super+0x95/0xd0
[13186.008049]  deactivate_locked_super+0x8d/0x140
[13186.029203]  cleanup_mnt+0x31f/0x4a0
[13186.045783]  task_work_run+0xce/0x170
[13186.062777]  exit_to_user_mode_loop+0x138/0x140
[13186.083718]  exit_to_user_mode_prepare+0xea/0x130
[13186.105095]  syscall_exit_to_user_mode+0x19/0x60
[13186.125888]  do_syscall_64+0x4d/0x80
[13186.142102]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[13186.164982] RIP: 0033:0x7fe45d39050b
[13186.180767] Code: 29 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 90 f3 0f 1e =
fa
31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e fa b8 a6 00 00 00 0f 05 <48> 3=
d 00
f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 31 29 0c 00 f7 d8
[13186.267927] RSP: 002b:00007fff8fe46eb8 EFLAGS: 00000246 ORIG_RAX:
00000000000000a6
[13186.302373] RAX: 0000000000000000 RBX: 00005610e7b0d630 RCX:
00007fe45d39050b
[13186.334206] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
00005610e7b12150
[13186.366924] RBP: 00005610e7b0d400 R08: 0000000000000000 R09:
00007fff8fe45c40
[13186.400100] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[13186.432333] R13: 00005610e7b12150 R14: 00005610e7b0d510 R15:
00005610e7b0d400
[13186.465047] irq event stamp: 648769
[13186.482980] hardirqs last  enabled at (648779): [<ffffffffb0d6718d>]
console_unlock+0x4dd/0x5f0
[13186.525448] hardirqs last disabled at (648788): [<ffffffffb0d6711e>]
console_unlock+0x46e/0x5f0
[13186.565184] softirqs last  enabled at (648802): [<ffffffffb2e00608>]
__do_softirq+0x608/0x940
[13186.604244] softirqs last disabled at (648797): [<ffffffffb0bf53d0>]
__irq_exit_rcu+0x200/0x2c0
[13186.644126] ---[ end trace 16aeb6c1e80505cd ]---
[18170.722499] XFS: Assertion failed: atomic_read(&pag->pag_ref) =3D=3D 0, =
file:
fs/xfs/libxfs/xfs_ag.c, line: 176
[18170.767259] ------------[ cut here ]------------
[18170.788261] WARNING: CPU: 4 PID: 0 at fs/xfs/xfs_message.c:112
assfail+0x56/0x59 [xfs]
[18170.824971] Modules linked in: intel_rapl_msr intel_rapl_common sb_edac
x86_pkg_temp_thermal iTCO_wdt intel_powerclamp iTCO_vendor_support coretemp
kvm_intel kvm irqbypass rapl intel_cstate intel_uncore pcspkr rfkill mgag200
i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops
lpc_ich cec hpilo ioatdma ipmi_ssif dca acpi_ipmi ipmi_si sunrpc ipmi_devin=
tf
ipmi_msghandler acpi_power_meter drm fuse xfs libcrc32c sd_mod ata_generic
crct10dif_pclmul t10_pi crc32_pclmul crc32c_intel ata_piix ghash_clmulni_in=
tel
serio_raw libata hpsa tg3 hpwdt scsi_transport_sas
[18171.353235] CPU: 4 PID: 0 Comm: swapper/4 Tainted: G        W=20=20=20=
=20=20=20=20=20
5.13.0-rc4 #1
[18171.388739] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 09/18/2013
[18171.418832] RIP: 0010:assfail+0x56/0x59 [xfs]
[18171.441370] Code: 2a 83 e0 07 48 c1 e9 03 8a 14 11 38 c2 7f 10 84 d2 74 =
0c
48 c7 c7 0c c3 d1 c0 e8 4f 8c 76 f0 80 3d e4 86 16 00 00 74 02 0f 0b <0f> 0=
b c3
48 8d 45 10 48 8d 54 24 28 4c 89 f6 48 c7 c7 00 17 be c0
[18171.531812] RSP: 0018:ffffc900037b0df8 EFLAGS: 00010246
[18171.555642] RAX: 0000000000000004 RBX: ffff888450e893d8 RCX:
1ffffffff81a3861
[18171.588590] RDX: dffffc0000000000 RSI: ffffc900037b0be8 RDI:
fffff520006f61b1
[18171.621236] RBP: ffff888450e8900c R08: 00000000ffffffea R09:
ffff8883d9bf0c87
[18171.653998] R10: ffffed107b37e190 R11: 0000000000000001 R12:
ffff888450e89000
[18171.686797] R13: ffffc900037b0ea0 R14: 0000000000000000 R15:
ffff888450e893d8
[18171.719349] FS:  0000000000000000(0000) GS:ffff8883d9a00000(0000)
knlGS:0000000000000000
[18171.855358] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18171.881656] CR2: 00007fffa6077c50 CR3: 00000003ad82c003 CR4:
00000000001706e0
[18171.914332] Call Trace:
[18171.925457]  <IRQ>
[18171.934779]  __xfs_free_perag+0xb1/0x100 [xfs]
[18171.955285]  rcu_do_batch+0x37c/0xc50
[18171.972261]  ? sync_rcu_exp_select_cpus+0x540/0x540
[18171.995379]  ? _raw_spin_unlock_irqrestore+0x47/0x50
[18172.017765]  ? trace_hardirqs_on+0x1c/0x160
[18172.037205]  rcu_core+0x300/0x460
[18172.052472]  __do_softirq+0x1f0/0x940
[18172.068800]  __irq_exit_rcu+0x200/0x2c0
[18172.086604]  irq_exit_rcu+0xa/0x20
[18172.102014]  sysvec_apic_timer_interrupt+0x6f/0x90
[18172.124024]  </IRQ>
[18172.133434]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[18172.157028] RIP: 0010:cpuidle_enter_state+0x1f8/0x8d0
[18172.179916] Code: 00 41 8b 77 04 bf ff ff ff ff e8 e3 f0 ff ff 31 ff e8 =
7c
d2 af fe 80 7c 24 0c 00 0f 85 9e 01 00 00 e8 6c a0 dd fe fb 45 85 e4 <0f> 8=
8 8c
02 00 00 49 63 ec 48 8d 44 6d 00 48 8d 44 85 00 48 8d 7c
[18172.363257] RSP: 0018:ffffc9000328fd70 EFLAGS: 00000202
[18172.387280] RAX: 00000000033c0a49 RBX: ffffffffb42a4280 RCX:
1ffffffff68cba71
[18172.419860] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
ffffffffb21a4724
[18172.455290] RBP: 0000000000000004 R08: 0000000000000001 R09:
ffffffffb4663367
[18172.490017] R10: fffffbfff68cc66c R11: 0000000000000001 R12:
0000000000000004
[18172.522639] R13: ffffe8fba9a01f14 R14: 00001086b374824d R15:
ffffe8fba9a01f10
[18172.555479]  ? cpuidle_enter_state+0x1f4/0x8d0
[18172.576095]  cpuidle_enter+0x4a/0xa0
[18172.592475]  cpuidle_idle_call+0x26d/0x3e0
[18172.611078]  ? arch_cpu_idle_exit+0x40/0x40
[18172.630384]  ? lockdep_hardirqs_on_prepare.part.0+0x19a/0x350
[18172.656555]  ? tsc_verify_tsc_adjust+0x2f/0x220
[18172.677095]  do_idle+0x12a/0x200
[18172.692037]  cpu_startup_entry+0x19/0x20
[18172.709892]  start_secondary+0x2c7/0x3b0
[18172.727785]  ? set_cpu_sibling_map+0x2050/0x2050
[18172.748753]  ? set_bringup_idt_handler.constprop.0+0x88/0x90
[18172.774322]  ? start_cpu0+0xc/0xc
[18172.789735]  secondary_startup_64_no_verify+0xc2/0xcb
[18172.813519] irq event stamp: 54267312
[18172.830347] hardirqs last  enabled at (54267322): [<ffffffffb0d6718d>]
console_unlock+0x4dd/0x5f0
[18172.870990] hardirqs last disabled at (54267331): [<ffffffffb0d6711e>]
console_unlock+0x46e/0x5f0
[18172.911706] softirqs last  enabled at (54266438): [<ffffffffb2e00608>]
__do_softirq+0x608/0x940
[18172.951646] softirqs last disabled at (54266443): [<ffffffffb0bf53d0>]
__irq_exit_rcu+0x200/0x2c0
[18172.991903] ---[ end trace 16aeb6c1e80505d1 ]---

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
