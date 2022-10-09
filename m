Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09FB4C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Oct 2022 11:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiJIL7Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Oct 2022 07:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiJIL7Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Oct 2022 07:59:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8451528709
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 04:59:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66423B80D14
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 11:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1A37EC43470
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 11:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665316757;
        bh=kPKUuTaH7+W/Kcj7SltMaILm2wjsiYv/gcPAVm/FnsE=;
        h=From:To:Subject:Date:From;
        b=AUWUNaaeyQtfVOBcqd8i97f/OJuvJHgelI/a2zNWxTrtj/TnK5n/pwqf9CTo3160H
         D06hVsLe3pIn134TKRDf8Ye5cSw5vVq/04XK5eQCeTmjeZB2/ytQzyO+pTytDUKF5j
         T+v28E7Lr8mKMSynZ0qHkoCSvo48Fk+p0DlotBASKlgMcYjGLILA1IynDuq3T2f19e
         Oz3AHrkwh2+4RIJUQgTXFwyX9lw6RNCpE9155JI35/C5leK01i9GnoydfaEch1X5C8
         XkEVSZY06xuJIynHX4Kd3ip42wugKbbjdvgT9fX89tv3YAm813bDJnZ+/26LxMbF1n
         XCqmBMl9dy4aA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 00384C433E6; Sun,  9 Oct 2022 11:59:16 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216563] New: [xfstests generic/113] memcpy: detected
 field-spanning write (size 32) of single field "efdp->efd_format.efd_extents"
 at fs/xfs/xfs_extfree_item.c:693 (size 16)
Date:   Sun, 09 Oct 2022 11:59:13 +0000
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
Message-ID: <bug-216563-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216563

            Bug ID: 216563
           Summary: [xfstests generic/113] memcpy: detected field-spanning
                    write (size 32) of single field
                    "efdp->efd_format.efd_extents" at
                    fs/xfs/xfs_extfree_item.c:693 (size 16)
           Product: File System
           Version: 2.5
    Kernel Version: v6.1-rc0
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

I xfstests generic/113 hit below kernel warning [1] on xfs with 64k directo=
ry
block size (-n size=3D65536). It's reproducible for me, and the last time I
reproduce this bug on linux v6.0+ which HEAD=3D ...

commit e8bc52cb8df80c31c73c726ab58ea9746e9ff734
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Oct 7 17:04:10 2022 -0700

    Merge tag 'driver-core-6.1-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core

I hit this issue on xfs with 64k directory block size 3 times(aarch64, x86_=
64
and ppc64le), and once on xfs with 1k blocksize (aarch64).


[1]
[ 4328.023770] run fstests generic/113 at 2022-10-08 11:57:42
[ 4330.104632] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at
your own risk!
[ 4333.094807] XFS (sda3): Unmounting Filesystem
[ 4333.934996] XFS (sda3): Mounting V5 Filesystem
[ 4333.973061] XFS (sda3): Ending clean mount
[ 4335.457595] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at
your own risk!
[ 4338.564849] XFS (sda3): Unmounting Filesystem
[ 4339.391848] XFS (sda3): Mounting V5 Filesystem
[ 4339.430908] XFS (sda3): Ending clean mount
[ 4340.100364] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at
your own risk!
[ 4343.379506] XFS (sda3): Unmounting Filesystem
[ 4344.195036] XFS (sda3): Mounting V5 Filesystem
[ 4344.232984] XFS (sda3): Ending clean mount
[ 4345.190073] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at
your own risk!
[ 4348.198562] XFS (sda3): Unmounting Filesystem
[ 4349.065061] XFS (sda3): Mounting V5 Filesystem
[ 4349.104995] XFS (sda3): Ending clean mount
[ 4350.118883] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at
your own risk!
[ 4353.233555] XFS (sda3): Unmounting Filesystem
[ 4354.093530] XFS (sda3): Mounting V5 Filesystem
[ 4354.135975] XFS (sda3): Ending clean mount
[ 4354.337550] ------------[ cut here ]------------
[ 4354.342354] memcpy: detected field-spanning write (size 32) of single fi=
eld
"efdp->efd_format.efd_extents" at fs/xfs/xfs_extfree_item.c:693 (size 16)
[ 4354.355820] WARNING: CPU: 7 PID: 899243 at fs/xfs/xfs_extfree_item.c:693
xfs_efi_item_relog+0x1fc/0x270 [xfs]
[ 4354.365918] Modules linked in: dm_snapshot dm_bufio ext4 mbcache jbd2 lo=
op
dm_flakey dm_mod intel_rapl_msr mgag200 intel_rapl_common
intel_uncore_frequency i2c_algo_bit intel_uncore_frequency_common
drm_shmem_helper ipmi_ssif drm_kms_helper mlx5_ib syscopyarea sysfillrect
mei_me dell_smbios i10nm_edac nfit x86_pkg_temp_thermal intel_powerclamp
coretemp kvm_intel rfkill dcdbas kvm irqbypass rapl intel_cstate ib_uverbs
intel_uncore dell_wmi_descriptor wmi_bmof pcspkr ib_core isst_if_mmio
isst_if_mbox_pci sysimgblt acpi_ipmi isst_if_common i2c_i801 mei fb_sys_fops
ipmi_si i2c_smbus intel_pch_thermal intel_vsec ipmi_devintf ipmi_msghandler
acpi_power_meter sunrpc drm fuse xfs libcrc32c sd_mod t10_pi sg mlx5_core
crct10dif_pclmul crc32_pclmul mlxfw crc32c_intel ghash_clmulni_intel tls ah=
ci
libahci psample megaraid_sas pci_hyperv_intf tg3 libata wmi [last unloaded:
scsi_debug]
[ 4354.443217] CPU: 7 PID: 899243 Comm: kworker/7:0 Kdump: loaded Not taint=
ed
6.0.0+ #1
[ 4354.450990] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4
12/17/2021
[ 4354.458497] Workqueue: xfs-inodegc/sda3 xfs_inodegc_worker [xfs]
[ 4354.464648] RIP: 0010:xfs_efi_item_relog+0x1fc/0x270 [xfs]
[ 4354.470279] Code: 00 00 0f 85 09 ff ff ff b9 10 00 00 00 48 c7 c2 20 a8 =
22
c1 4c 89 f6 48 c7 c7 a0 a8 22 c1 c6 05 50 56 28 00 01 e8 b1 2c 28 c5 <0f> 0=
b e9
e0 fe ff ff 80 3d 3c 56 28 00 00 0f 85 35 ff ff ff b9 10
[ 4354.472133] XFS (sda3): xlog_verify_grant_tail: space > BBTOB(tail_block=
s)
[ 4354.489042] RSP: 0018:ffa0000037dc7950 EFLAGS: 00010286
[ 4354.489088] RAX: 0000000000000000 RBX: 0000000000000002 RCX:
0000000000000000
[ 4354.489092] RDX: 0000000000000001 RSI: ffffffff86cce8e0 RDI:
fff3fc0006fb8f1c
[ 4354.489096] RBP: ff11001170bbf2e0 R08: 0000000000000001 R09:
ff11002031dfd487
[ 4354.489100] R10: ffe21c04063bfa90 R11: 0000000000000001 R12:
ff1100115db29f80
[ 4354.489104] R13: ff1100118a7cb500 R14: 0000000000000020 R15:
ff1100115db2a038
[ 4354.537068] FS:  0000000000000000(0000) GS:ff11002031c00000(0000)
knlGS:0000000000000000
[ 4354.545178] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4354.550938] CR2: 00007fa368b18b30 CR3: 0000000bd962c002 CR4:
0000000000771ee0
[ 4354.558090] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 4354.565240] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[ 4354.572395] PKRU: 55555554
[ 4354.575127] Call Trace:
[ 4354.577598]  <TASK>
[ 4354.579729]  xfs_defer_relog+0x406/0x840 [xfs]
[ 4354.584320]  xfs_defer_finish_noroll+0xb84/0x1790 [xfs]
[ 4354.589685]  ? xfs_defer_trans_abort+0x680/0x680 [xfs]
[ 4354.594954]  ? xfs_defer_cancel+0x290/0x290 [xfs]
[ 4354.599801]  xfs_defer_finish+0x13/0x200 [xfs]
[ 4354.604366]  xfs_itruncate_extents_flags+0x404/0xd70 [xfs]
[ 4354.610060]  ? xfs_link+0x8e0/0x8e0 [xfs]
[ 4354.614218]  ? xfs_trans_ichgtime+0x190/0x190 [xfs]
[ 4354.619236]  ? xfs_inactive_truncate+0xb8/0x250 [xfs]
[ 4354.624427]  ? rcu_read_lock_sched_held+0x43/0x80
[ 4354.629168]  xfs_inactive_truncate+0x109/0x250 [xfs]
[ 4354.634266]  ? xfs_itruncate_extents_flags+0xd70/0xd70 [xfs]
[ 4354.640067]  ? xfs_inactive+0xe6/0x660 [xfs]
[ 4354.644502]  xfs_inactive+0x4ff/0x660 [xfs]
[ 4354.648822]  xfs_inodegc_worker+0x1aa/0x650 [xfs]
[ 4354.653673]  process_one_work+0x8b7/0x1540
[ 4354.657814]  ? __lock_acquired+0x209/0x890
[ 4354.661942]  ? pwq_dec_nr_in_flight+0x230/0x230
[ 4354.666502]  ? __lock_contended+0x980/0x980
[ 4354.670726]  ? worker_thread+0x160/0xed0
[ 4354.674691]  worker_thread+0x5ac/0xed0
[ 4354.678509]  ? process_one_work+0x1540/0x1540
[ 4354.682896]  kthread+0x29f/0x340
[ 4354.686154]  ? kthread_complete_and_exit+0x20/0x20
[ 4354.690974]  ret_from_fork+0x1f/0x30
[ 4354.694603]  </TASK>
[ 4354.696813] irq event stamp: 225213
[ 4354.700325] hardirqs last  enabled at (225223): [<ffffffff843b7f3b>]
__up_console_sem+0x6b/0x80
[ 4354.709049] hardirqs last disabled at (225238): [<ffffffff843b7f20>]
__up_console_sem+0x50/0x80
[ 4354.717770] softirqs last  enabled at (225236): [<ffffffff86800625>]
__do_softirq+0x625/0x9b0
[ 4354.726316] softirqs last disabled at (225231): [<ffffffff8422640c>]
__irq_exit_rcu+0x1fc/0x2a0
[ 4354.735030] ---[ end trace 0000000000000000 ]---
[ 4354.739682] ------------[ cut here ]------------
[ 4354.744333] memcpy: detected field-spanning write (size 32) of single fi=
eld
"efip->efi_format.efi_extents" at fs/xfs/xfs_extfree_item.c:697 (size 16)
[ 4354.757790] WARNING: CPU: 7 PID: 899243 at fs/xfs/xfs_extfree_item.c:697
xfs_efi_item_relog+0x232/0x270 [xfs]
[ 4354.767843] Modules linked in: dm_snapshot dm_bufio ext4 mbcache jbd2 lo=
op
dm_flakey dm_mod intel_rapl_msr mgag200 intel_rapl_common
intel_uncore_frequency i2c_algo_bit intel_uncore_frequency_common
drm_shmem_helper ipmi_ssif drm_kms_helper mlx5_ib syscopyarea sysfillrect
mei_me dell_smbios i10nm_edac nfit x86_pkg_temp_thermal intel_powerclamp
coretemp kvm_intel rfkill dcdbas kvm irqbypass rapl intel_cstate ib_uverbs
intel_uncore dell_wmi_descriptor wmi_bmof pcspkr ib_core isst_if_mmio
isst_if_mbox_pci sysimgblt acpi_ipmi isst_if_common i2c_i801 mei fb_sys_fops
ipmi_si i2c_smbus intel_pch_thermal intel_vsec ipmi_devintf ipmi_msghandler
acpi_power_meter sunrpc drm fuse xfs libcrc32c sd_mod t10_pi sg mlx5_core
crct10dif_pclmul crc32_pclmul mlxfw crc32c_intel ghash_clmulni_intel tls ah=
ci
libahci psample megaraid_sas pci_hyperv_intf tg3 libata wmi [last unloaded:
scsi_debug]
[ 4354.845125] CPU: 7 PID: 899243 Comm: kworker/7:0 Kdump: loaded Tainted: =
G=20=20=20
    W          6.0.0+ #1
[ 4354.854370] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4
12/17/2021
[ 4354.861875] Workqueue: xfs-inodegc/sda3 xfs_inodegc_worker [xfs]
[ 4354.868016] RIP: 0010:xfs_efi_item_relog+0x232/0x270 [xfs]
[ 4354.873643] Code: 00 00 0f 85 35 ff ff ff b9 10 00 00 00 48 c7 c2 20 a9 =
22
c1 4c 89 f6 48 c7 c7 a0 a8 22 c1 c6 05 19 56 28 00 01 e8 7b 2c 28 c5 <0f> 0=
b e9
0c ff ff ff 4c 89 ef e8 bf e2 8e c3 e9 4c ff ff ff e8 b5
[ 4354.892409] RSP: 0018:ffa0000037dc7950 EFLAGS: 00010286
[ 4354.897660] RAX: 0000000000000000 RBX: 0000000000000002 RCX:
0000000000000000
[ 4354.904816] RDX: 0000000000000001 RSI: ffffffff86cce8e0 RDI:
fff3fc0006fb8f1c
[ 4354.911978] RBP: ff11001170bbf2e0 R08: 0000000000000001 R09:
ff11002031dfd487
[ 4354.919135] R10: ffe21c04063bfa90 R11: 0000000000000001 R12:
ff1100118a7c8d90
[ 4354.926296] R13: ff1100118a7cb500 R14: 0000000000000020 R15:
ff1100118a7c8e40
[ 4354.933454] FS:  0000000000000000(0000) GS:ff11002031c00000(0000)
knlGS:0000000000000000
[ 4354.941564] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4354.947337] CR2: 00007fa368b18b30 CR3: 0000000bd962c002 CR4:
0000000000771ee0
[ 4354.954497] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 4354.961653] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[ 4354.968812] PKRU: 55555554
[ 4354.971546] Call Trace:
[ 4354.974021]  <TASK>
[ 4354.976163]  xfs_defer_relog+0x406/0x840 [xfs]
[ 4354.980753]  xfs_defer_finish_noroll+0xb84/0x1790 [xfs]
[ 4354.986135]  ? xfs_defer_trans_abort+0x680/0x680 [xfs]
[ 4354.991400]  ? xfs_defer_cancel+0x290/0x290 [xfs]
[ 4354.996271]  xfs_defer_finish+0x13/0x200 [xfs]
[ 4355.000844]  xfs_itruncate_extents_flags+0x404/0xd70 [xfs]
[ 4355.006487]  ? xfs_link+0x8e0/0x8e0 [xfs]
[ 4355.010642]  ? xfs_trans_ichgtime+0x190/0x190 [xfs]
[ 4355.015656]  ? xfs_inactive_truncate+0xb8/0x250 [xfs]
[ 4355.020851]  ? rcu_read_lock_sched_held+0x43/0x80
[ 4355.025591]  xfs_inactive_truncate+0x109/0x250 [xfs]
[ 4355.030695]  ? xfs_itruncate_extents_flags+0xd70/0xd70 [xfs]
[ 4355.036504]  ? xfs_inactive+0xe6/0x660 [xfs]
[ 4355.040931]  xfs_inactive+0x4ff/0x660 [xfs]
[ 4355.045255]  xfs_inodegc_worker+0x1aa/0x650 [xfs]
[ 4355.050111]  process_one_work+0x8b7/0x1540
[ 4355.054247]  ? __lock_acquired+0x209/0x890
[ 4355.058378]  ? pwq_dec_nr_in_flight+0x230/0x230
[ 4355.062937]  ? __lock_contended+0x980/0x980
[ 4355.067161]  ? worker_thread+0x160/0xed0
[ 4355.071125]  worker_thread+0x5ac/0xed0
[ 4355.074926]  ? process_one_work+0x1540/0x1540
[ 4355.079320]  kthread+0x29f/0x340
[ 4355.082582]  ? kthread_complete_and_exit+0x20/0x20
[ 4355.087406]  ret_from_fork+0x1f/0x30
[ 4355.091042]  </TASK>
[ 4355.093255] irq event stamp: 226333
[ 4355.096768] hardirqs last  enabled at (226343): [<ffffffff843b7f3b>]
__up_console_sem+0x6b/0x80
[ 4355.105492] hardirqs last disabled at (226358): [<ffffffff843b7f20>]
__up_console_sem+0x50/0x80
[ 4355.114214] softirqs last  enabled at (226356): [<ffffffff86800625>]
__do_softirq+0x625/0x9b0
[ 4355.122762] softirqs last disabled at (226351): [<ffffffff8422640c>]
__irq_exit_rcu+0x1fc/0x2a0
[ 4355.131484] ---[ end trace 0000000000000000 ]---
[ 4355.263177] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at
your own risk!
[ 4358.321839] XFS (sda3): Unmounting Filesystem
[ 4359.155439] XFS (sda3): Mounting V5 Filesystem
[ 4359.193937] XFS (sda3): Ending clean mount
[ 4359.367326] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at
your own risk!
[ 4362.438659] XFS (sda3): Unmounting Filesystem
[ 4363.230018] XFS (sda3): Mounting V5 Filesystem
[ 4363.269186] XFS (sda3): Ending clean mount

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
