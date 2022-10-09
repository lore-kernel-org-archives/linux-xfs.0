Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DDDC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Oct 2022 12:20:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiJIMUA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Oct 2022 08:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiJIMT7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Oct 2022 08:19:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B681007A
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 05:19:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8C2960BC7
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 12:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18FB3C43143
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 12:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665317997;
        bh=uZSipceLoLMWeBwx3cKWmzEWcVXs/Bd6eQ53QBv+6Dc=;
        h=From:To:Subject:Date:From;
        b=AVs4g182jUJY7ij7lub+07O6eeFzqq11svK9tbWctVnOTGKBDq0YDoEMzzf7WLAzt
         13W3mQoRMRo/1MVa4uI7xjAhl6HmSph3P8WXRvrzunRlTHsMyRc3GkNKmMZb75gbnv
         +hNa4tVM/RMtWSfXNtx8D2f2ItzutifwpRRNUml1TyTKCVrhuKc8GUSOf9foJj2keZ
         WVklxCzgHJRJ4I+t54AV+PUbkj1o6K5O2zz7vNQ3vsv6rHOl3t1GTceaZnw73X8UbS
         HdN6tVTc+7MuSHtsGR2vMzn7ka9O1girFbgZGCl1Pt83rfLB9vrFCu7cCy8wp0VHvA
         r+NimY4vT1oBw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0661DC433EA; Sun,  9 Oct 2022 12:19:57 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216564] New: [xfstests xfs/013] WARNING: CPU: 4 PID: 3240987 at
 fs/dax.c:380 dax_insert_entry+0x6b8/0xa70
Date:   Sun, 09 Oct 2022 12:19:56 +0000
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
Message-ID: <bug-216564-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216564

            Bug ID: 216564
           Summary: [xfstests xfs/013] WARNING: CPU: 4 PID: 3240987 at
                    fs/dax.c:380 dax_insert_entry+0x6b8/0xa70
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

I hit below kernel warning on xfs (on pmem) with:
MOUNT_OPTIONS=3D"-o dax=3Dalways".
MKFS_OPTIONS=3D"-b size=3D4096 -d su=3D2m,sw=3D1 -m
crc=3D1,finobt=3D1,rmapbt=3D0,reflink=3D0,inobtcount=3D1,bigtime=3D1"

And besides xfs/013, others cases likes xfs/104, xfs/168 and xfs/538 trigge=
red
this warning too.

[16212.233693] run fstests xfs/013 at 2022-10-08 15:17:59
[16220.298671] XFS (pmem0): DAX enabled. Warning: EXPERIMENTAL, use at your=
 own
risk
[16220.307421] XFS (pmem0): Mounting V5 Filesystem
[16220.328753] XFS (pmem0): Ending clean mount
[16220.353113] XFS (pmem0): Unmounting Filesystem
[16220.979982] XFS (pmem0): DAX enabled. Warning: EXPERIMENTAL, use at your=
 own
risk
[16220.988705] XFS (pmem0): Mounting V5 Filesystem
[16221.010026] XFS (pmem0): Ending clean mount
[17212.927302] ------------[ cut here ]------------
[17212.932779] WARNING: CPU: 4 PID: 3240987 at fs/dax.c:380
dax_insert_entry+0x6b8/0xa70
[17212.940623] Modules linked in: overlay dm_log_writes ext4 mbcache jbd2 l=
oop
rfkill sunrpc intel_rapl_msr intel_rapl_common intel_uncore_frequency mgag2=
00
intel_uncore_frequency_common ipmi_ssif i2c_algo_bit mlx5_ib drm_shmem_help=
er
i10nm_edac drm_kms_helper nfit syscopyarea x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel dcdbas kvm irqbypass dell_smbios rapl
intel_cstate ib_uverbs intel_uncore nd_pmem dax_pmem pcspkr dell_wmi_descri=
ptor
wmi_bmof mei_me isst_if_mmio ib_core isst_if_mbox_pci sysfillrect acpi_ipmi
isst_if_common i2c_i801 sysimgblt fb_sys_fops i2c_smbus mei ipmi_si
intel_pch_thermal intel_vsec ipmi_devintf ipmi_msghandler acpi_power_meter =
drm
fuse xfs libcrc32c sd_mod t10_pi sg mlx5_core crct10dif_pclmul crc32_pclmul
crc32c_intel mlxfw ghash_clmulni_intel ahci tls libahci psample megaraid_sas
pci_hyperv_intf tg3 libata wmi dm_mirror dm_region_hash dm_log dm_mod [last
unloaded: scsi_debug]
[17213.021327] CPU: 4 PID: 3240987 Comm: fsstress Kdump: loaded Tainted: G=
=20=20=20=20=20
  W          6.0.0+ #1
[17213.030374] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4
12/17/2021
[17213.037852] RIP: 0010:dax_insert_entry+0x6b8/0xa70
[17213.042655] Code: 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 48 c1 ee 03 =
42
80 3c 26 00 0f 85 18 03 00 00 48 8b 7b 20 48 8d 6f 01 e9 9b fe ff ff <0f> 0=
b e9
e3 fe ff ff 31 f6 4c 89 ef 44 89 04 24 e8 c3 a2 62 00 44
[17213.061409] RSP: 0000:ffa000002a4f7818 EFLAGS: 00010086
[17213.066644] RAX: ffd4000004060d40 RBX: ffd4000004060d00 RCX:
0000000000000000
[17213.073783] RDX: 0000000000000290 RSI: ff110011667bc448 RDI:
ff1100096a1e7008
[17213.080917] RBP: ffd4000004060d18 R08: 0000000000000000 R09:
ffffffff98787fc7
[17213.088049] R10: fffffbfff30f0ff8 R11: 0000000000000001 R12:
dffffc0000000000
[17213.095182] R13: ffa000002a4f7a58 R14: ff11001143a5fc48 R15:
0000000000000008
[17213.102316] FS:  00007fb39b93b740(0000) GS:ff11000cd9600000(0000)
knlGS:0000000000000000
[17213.110410] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[17213.116154] CR2: 00007fb39b935000 CR3: 0000000a4a274005 CR4:
0000000000771ee0
[17213.123288] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[17213.130420] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[17213.137553] PKRU: 55555554
[17213.140267] Call Trace:
[17213.142720]  <TASK>
[17213.144835]  ? dax_read_unlock+0xd/0x40
[17213.148687]  ? __dax_invalidate_entry+0x1f0/0x1f0
[17213.153402]  ? dax_read_unlock+0x20/0x40
[17213.157334]  ? dax_iomap_direct_access+0x14d/0x1d0
[17213.162143]  dax_fault_iter+0x29d/0x6d0
[17213.166002]  ? dax_pmd_load_hole+0xa50/0xa50
[17213.170289]  ? iomap_iter+0x83b/0xdc0
[17213.173978]  dax_iomap_pte_fault+0x3ec/0xa40
[17213.178264]  ? dax_fault_iter+0x6d0/0x6d0
[17213.182299]  ? lock_acquire+0x1d8/0x620
[17213.186186]  ? xfs_ilock+0x162/0x4d0 [xfs]
[17213.190442]  ? xfs_ilock+0x162/0x4d0 [xfs]
[17213.194691]  __xfs_filemap_fault+0x612/0x8f0 [xfs]
[17213.199621]  ? xfs_file_fsync+0xae0/0xae0 [xfs]
[17213.204299]  __do_fault+0xf5/0x440
[17213.207717]  do_fault+0x427/0x710
[17213.211047]  __handle_mm_fault+0xa15/0xe60
[17213.215171]  ? vm_iomap_memory+0x150/0x150
[17213.219271]  ? __lock_release+0x4c1/0xa00
[17213.223311]  ? count_memcg_event_mm.part.0+0xbd/0x1d0
[17213.228381]  handle_mm_fault+0x16b/0x5e0
[17213.232325]  do_user_addr_fault+0x343/0xdd0
[17213.236523]  ? rcu_read_lock_sched_held+0x43/0x80
[17213.241241]  exc_page_fault+0x5a/0xe0
[17213.244920]  asm_exc_page_fault+0x22/0x30
[17213.248939] RIP: 0033:0x7fb39b6cb17a
[17213.252527] Code: 00 00 b9 ff ff ff ff c4 e2 68 f5 c9 c5 fb 92 c9 62 e1 =
7f
29 7f 00 c3 66 0f 1f 84 00 00 00 00 00 40 0f b6 c6 48 89 d1 48 89 fa <f3> a=
a 48
89 d0 c3 48 3b 15 51 f2 12 00 77 e7 62 e1 fe 28 7f 07 62
[17213.271279] RSP: 002b:00007fff0a1fbee8 EFLAGS: 00010206
[17213.276516] RAX: 0000000000000056 RBX: 0000000000289000 RCX:
0000000000005524
[17213.283647] RDX: 00007fb39b92e000 RSI: 0000000000000056 RDI:
00007fb39b935000
[17213.290781] RBP: 028f5c28f5c28f5c R08: 0000000000000000 R09:
0000000000289000
[17213.297913] R10: 0000000000000008 R11: 0000000000000246 R12:
000000000000c524
[17213.305045] R13: 8f5c28f5c28f5c29 R14: 000000000040cff0 R15:
00007fb39b93b6c0
[17213.312205]  </TASK>
[17213.314397] irq event stamp: 9780986
[17213.317975] hardirqs last  enabled at (9780985): [<ffffffff93a205f9>]
kasan_quarantine_put+0x109/0x220
[17213.327284] hardirqs last disabled at (9780986): [<ffffffff954adafe>]
_raw_spin_lock_irq+0x5e/0x90
[17213.336245] softirqs last  enabled at (9776938): [<ffffffff95800625>]
__do_softirq+0x625/0x9b0
[17213.344859] softirqs last disabled at (9776931): [<ffffffff9322640c>]
__irq_exit_rcu+0x1fc/0x2a0
[17213.353648] ---[ end trace 0000000000000000 ]---
[17636.123091] ------------[ cut here ]------------
[17636.128588] WARNING: CPU: 14 PID: 3240987 at fs/dax.c:404
dax_disassociate_entry+0x82/0x2c0
[17636.136952] Modules linked in: overlay dm_log_writes ext4 mbcache jbd2 l=
oop
rfkill sunrpc intel_rapl_msr intel_rapl_common intel_uncore_frequency mgag2=
00
intel_uncore_frequency_common ipmi_ssif i2c_algo_bit mlx5_ib drm_shmem_help=
er
i10nm_edac drm_kms_helper nfit syscopyarea x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel dcdbas kvm irqbypass dell_smbios rapl
intel_cstate ib_uverbs intel_uncore nd_pmem dax_pmem pcspkr dell_wmi_descri=
ptor
wmi_bmof mei_me isst_if_mmio ib_core isst_if_mbox_pci sysfillrect acpi_ipmi
isst_if_common i2c_i801 sysimgblt fb_sys_fops i2c_smbus mei ipmi_si
intel_pch_thermal intel_vsec ipmi_devintf ipmi_msghandler acpi_power_meter =
drm
fuse xfs libcrc32c sd_mod t10_pi sg mlx5_core crct10dif_pclmul crc32_pclmul
crc32c_intel mlxfw ghash_clmulni_intel ahci tls libahci psample megaraid_sas
pci_hyperv_intf tg3 libata wmi dm_mirror dm_region_hash dm_log dm_mod [last
unloaded: scsi_debug]
[17636.217656] CPU: 14 PID: 3240987 Comm: fsstress Kdump: loaded Tainted: G=
=20=20=20=20
   W          6.0.0+ #1
[17636.226791] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4
12/17/2021
[17636.234277] RIP: 0010:dax_disassociate_entry+0x82/0x2c0
[17636.239513] Code: c1 e8 03 42 80 3c 20 00 0f 85 c3 01 00 00 48 8b 43 18 =
4c
8d 53 20 48 83 f8 01 0f 84 ec 00 00 00 48 39 c8 74 07 48 85 c0 74 02 <0f> 0=
b 4c
89 c8 48 c1 e8 03 42 80 3c 20 00 0f 85 61 01 00 00 4c 89
[17636.258268] RSP: 0018:ffa000002a4f7780 EFLAGS: 00010086
[17636.263500] RAX: ff1100060b511448 RBX: ffd40000091176c0 RCX:
ff11001144b58448
[17636.270634] RDX: 0000000000000001 RSI: 0000000000000000 RDI:
ffd40000091176f4
[17636.277765] RBP: 00000000002445db R08: 0000000000000000 R09:
ffd40000091176d8
[17636.284900] R10: ffd40000091176e0 R11: 0000000000000001 R12:
dffffc0000000000
[17636.292030] R13: ffd40000091176f4 R14: 00000000002445db R15:
fffffbfff2c5c28a
[17636.299165] FS:  00007fb39b93b740(0000) GS:ff11000cdaa00000(0000)
knlGS:0000000000000000
[17636.307251] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[17636.313005] CR2: 00007fb39b93a000 CR3: 0000000a4a274005 CR4:
0000000000771ee0
[17636.320138] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[17636.327269] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[17636.334402] PKRU: 55555554
[17636.337117] Call Trace:
[17636.339568]  <TASK>
[17636.341691]  __dax_invalidate_entry+0xe1/0x1f0
[17636.346150]  ? dax_layout_busy_page+0x20/0x20
[17636.350533]  ? find_lock_entries+0x508/0x940
[17636.354821]  dax_delete_mapping_entry+0xf/0x20
[17636.359278]  truncate_folio_batch_exceptionals.part.0+0x400/0x510
[17636.365391]  ? clear_shadow_entry+0x210/0x210
[17636.369783]  truncate_inode_pages_range+0x1a8/0xe10
[17636.374681]  ? truncate_inode_partial_folio+0x890/0x890
[17636.379931]  ? unmap_mapping_range+0xe0/0x250
[17636.384323]  ? xfs_bmap_collapse_extents+0x650/0x650 [xfs]
[17636.389964]  xfs_flush_unmap_range+0xca/0x110 [xfs]
[17636.394981]  xfs_prepare_shift+0x103/0x210 [xfs]
[17636.399738]  xfs_insert_file_space+0x30e/0x5e0 [xfs]
[17636.404836]  ? xfs_collapse_file_space+0x570/0x570 [xfs]
[17636.410274]  ? xfs_vn_getattr+0x12f0/0x1320 [xfs]
[17636.415117]  ? setattr_prepare+0xe6/0x9e0
[17636.419156]  xfs_file_fallocate+0x5c0/0xdd0 [xfs]
[17636.424002]  ? xfs_break_layouts+0x130/0x130 [xfs]
[17636.428925]  ? rcu_read_unlock+0x40/0x40
[17636.432886]  vfs_fallocate+0x2aa/0xbb0
[17636.436654]  __x64_sys_fallocate+0xb4/0x100
[17636.440853]  do_syscall_64+0x59/0x90
[17636.444439]  ? do_syscall_64+0x69/0x90
[17636.448196]  ? lockdep_hardirqs_on+0x79/0x100
[17636.452568]  ? do_syscall_64+0x69/0x90
[17636.456327]  ? do_syscall_64+0x69/0x90
[17636.460078]  ? do_syscall_64+0x69/0x90
[17636.463832]  ? asm_exc_page_fault+0x22/0x30
[17636.468027]  ? lockdep_hardirqs_on+0x79/0x100
[17636.472398]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[17636.477455] RIP: 0033:0x7fb39b7432ca
[17636.481043] Code: d8 64 89 02 b8 ff ff ff ff eb bd 0f 1f 44 00 00 f3 0f =
1e
fa 49 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 15 b8 1d 01 00 00 0f 05 <48> 3=
d 00
f0 ff ff 77 5e c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24
[17636.499790] RSP: 002b:00007fff0a1fbfb8 EFLAGS: 00000246 ORIG_RAX:
000000000000011d
[17636.507364] RAX: ffffffffffffffda RBX: 0000000000000020 RCX:
00007fb39b7432ca
[17636.514498] RDX: 0000000000039000 RSI: 0000000000000020 RDI:
0000000000000003
[17636.521636] RBP: 0000000000000003 R08: 0000000000000068 R09:
00007fff0a1fbfdc
[17636.528771] R10: 0000000000063000 R11: 0000000000000246 R12:
0000000000017c23
[17636.535904] R13: 0000000000063000 R14: 0000000000000000 R15:
0000000000039000
[17636.543062]  </TASK>
[17636.545254] irq event stamp: 66760960
[17636.548920] hardirqs last  enabled at (66760959): [<ffffffff954addf4>]
_raw_spin_unlock_irq+0x24/0x50
[17636.558140] hardirqs last disabled at (66760960): [<ffffffff954adafe>]
_raw_spin_lock_irq+0x5e/0x90
[17636.567182] softirqs last  enabled at (66760216): [<ffffffff95800625>]
__do_softirq+0x625/0x9b0
[17636.575884] softirqs last disabled at (66760209): [<ffffffff9322640c>]
__irq_exit_rcu+0x1fc/0x2a0
[17636.584756] ---[ end trace 0000000000000000 ]---
[18289.471495] XFS (pmem0): Unmounting Filesystem
[18291.618034] XFS (pmem1): Unmounting Filesystem

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
