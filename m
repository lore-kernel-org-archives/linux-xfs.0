Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C21FC6FA8E
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Mar 2023 06:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjCEGVL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Mar 2023 01:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjCEGVK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Mar 2023 01:21:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1073517149
        for <linux-xfs@vger.kernel.org>; Sat,  4 Mar 2023 22:21:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82447B802C5
        for <linux-xfs@vger.kernel.org>; Sun,  5 Mar 2023 06:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 30027C4339E
        for <linux-xfs@vger.kernel.org>; Sun,  5 Mar 2023 06:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677997263;
        bh=mmKKsbCCBT0iRpZIZ4bGS7V+KS6PvLzj4Ntw2p4geZ4=;
        h=From:To:Subject:Date:From;
        b=RzpdtMk+RyoDoStYLmj++T6r5xtUJDS78EQJCI0hbIte9cZGbbp/4qxQe5C5cpZ/m
         zdRz6EDCvvLT6OBNhzc0lNsWA4q/qEa40Vu0zt7c+3thKUIOClt9b5hGrPXWktDUgD
         CtG5HoxJ30b9/1WSnfSo+nVdtgT/j0cpDh62XWBjTIX++nzSxufq/jfep2uCTSEY2/
         9evkZBeSagGP/0FQ0RZHJAKaQkZiJXqNaqQq6WaGSOsGbhTM9gXwJm+NeZeMvLBvQ3
         gjyTgjOfdFVNRccYjWwBkPso9QlRMvcO/4mfLZy3gEy/wZoyP569dyCTsITLPWsmGs
         rM/eSaK0uSl7g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 1E00EC43142; Sun,  5 Mar 2023 06:21:03 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217138] New: [xfstests] XFS: Assertion failed:
 xfs_bmap_validate_extent(ip, whichfork, &rec) == NULL, file:
 fs/xfs/libxfs/xfs_inode_fork.c, line: 557
Date:   Sun, 05 Mar 2023 06:21:02 +0000
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
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-217138-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217138

            Bug ID: 217138
           Summary: [xfstests] XFS: Assertion failed:
                    xfs_bmap_validate_extent(ip, whichfork, &rec) =3D=3D NU=
LL,
                    file: fs/xfs/libxfs/xfs_inode_fork.c, line: 557
           Product: File System
           Version: 2.5
    Kernel Version: v6.3-rc0
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

Created attachment 303854
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D303854&action=3Dedit
console.log

Recently I start to hit a kernel assertion bug by running xfstests on xfs w=
ith
pmem (persistent memory)devices. No matter the mount option is
dax=3Dalways/inode/never, all can trigger this bug.

[ 8266.774823] run fstests generic/270 at 2023-03-03 15:56:00=20
[ 8269.422750] memfd_create() without MFD_EXEC nor MFD_NOEXEC_SEAL, pid=3D2=
216706
'systemd'=20
[ 8270.586114] XFS (pmem0): DAX enabled. Warning: EXPERIMENTAL, use at your=
 own
risk=20
[ 8270.595040] XFS (pmem0): Mounting V5 Filesystem
2d15fd14-f03b-40c6-9443-d3af15fe64c2=20
[ 8270.616055] XFS (pmem0): Ending clean mount=20
[ 8270.621619] XFS (pmem0): Quotacheck needed: Please wait.=20
[ 8270.635448] XFS (pmem0): Quotacheck: Done.=20
[ 8273.499839] XFS: Assertion failed: xfs_bmap_validate_extent(ip, whichfor=
k,
&rec) =3D=3D NULL, file: fs/xfs/libxfs/xfs_inode_fork.c, line: 557=20
[ 8273.512622] ------------[ cut here ]------------=20
[ 8273.517282] WARNING: CPU: 24 PID: 2216892 at fs/xfs/xfs_message.c:104
assfail+0x54/0x70 [xfs]=20
[ 8273.526050] Modules linked in: ext4 mbcache jbd2 loop intel_rapl_msr
intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common rfki=
ll
i10nm_edac nfit x86_pkg_temp_thermal intel_powerclamp coretemp ipmi_ssif
kvm_intel mgag200 i2c_algo_bit mlx5_ib drm_shmem_helper dell_smbios
drm_kms_helper ib_uverbs kvm iTCO_wdt iTCO_vendor_support sunrpc dcdbas
irqbypass rapl intel_cstate acpi_ipmi ipmi_si intel_uncore ib_core dax_pmem
nd_pmem dell_wmi_descriptor wmi_bmof mei_me syscopyarea pcspkr ipmi_devintf
dax_hmem isst_if_mbox_pci i2c_i801 isst_if_mmio sysfillrect mei sysimgblt
isst_if_common i2c_smbus intel_vsec ipmi_msghandler acpi_power_meter drm fu=
se
xfs libcrc32c sd_mod t10_pi sg mlx5_core crct10dif_pclmul crc32_pclmul
crc32c_intel mlxfw ahci libahci tls ghash_clmulni_intel psample megaraid_sas
libata tg3 pci_hyperv_intf wmi dm_mirror dm_region_hash dm_log dm_mod [last
unloaded: scsi_debug]=20
[ 8273.605731] CPU: 24 PID: 2216892 Comm: 2216549.fsstres Kdump: loaded Not
tainted 6.2.0+ #1=20
[ 8273.614012] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4
12/17/2021=20
[ 8273.621518] RIP: 0010:assfail+0x54/0x70 [xfs]=20
[ 8273.626087] Code: c1 48 ba 00 00 00 00 00 fc ff df 48 89 c1 83 e0 07 48 =
c1
e9 03 0f b6 14 11 38 c2 7f 04 84 d2 75 10 80 3d ae 16 2f 00 00 75 15 <0f> 0=
b c3
cc cc cc cc 48 c7 c7 f0 14 95 c1 e8 59 dc e6 d5 eb e2 0f=20
[ 8273.644857] RSP: 0018:ffa0000026497278 EFLAGS: 00010246=20
[ 8273.650109] RAX: 0000000000000000 RBX: ff110006fbfa5040 RCX:
1ffffffff832a29e=20
[ 8273.657278] RDX: 0000000000000004 RSI: ffa0000026496fe0 RDI:
ffffffffc17ad880=20
[ 8273.664435] RBP: ffa00000264972f0 R08: 00000000ffffffea R09:
ffa0000026496f87=20
[ 8273.671601] R10: fff3fc0004c92df0 R11: 0000000000000001 R12:
ffa00000264972d0=20
[ 8273.678761] R13: ff11000687e3b288 R14: 00000000000000f0 R15:
ff110006fbfa5000=20
[ 8273.685919] FS:  00007f40e02b5740(0000) GS:ff11000ced800000(0000)
knlGS:0000000000000000=20
[ 8273.694031] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[ 8273.699803] CR2: 0000000001ebb178 CR3: 00000006cb6d2004 CR4:
0000000000771ee0=20
[ 8273.706963] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000=20
[ 8273.714120] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400=20
[ 8273.721281] PKRU: 55555554=20
[ 8273.724018] Call Trace:=20
[ 8273.726498]  <TASK>=20
[ 8273.728630]  xfs_iextents_copy+0x412/0x610 [xfs]=20
[ 8273.733462]  ? __pfx_xfs_iextents_copy+0x10/0x10 [xfs]=20
[ 8273.738818]  ? xfs_inode_to_log_dinode+0x8d7/0x1370 [xfs]=20
[ 8273.744445]  ? do_raw_spin_unlock+0x55/0x1f0=20
[ 8273.748755]  xfs_inode_item_format_data_fork+0x9c9/0x10f0 [xfs]=20
[ 8273.754905]  xfs_inode_item_format+0x6b3/0xb40 [xfs]=20
[ 8273.760088]  ? trace_contention_end+0x177/0x1f0=20
[ 8273.764656]  ? __pfx_xfs_inode_item_format+0x10/0x10 [xfs]=20
[ 8273.770375]  xlog_cil_insert_format_items+0x2b2/0x5f0 [xfs]=20
[ 8273.776173]  xlog_cil_insert_items+0xe2/0x1060 [xfs]=20
[ 8273.781370]  ? __lock_acquired+0x209/0x830=20
[ 8273.785507]  ? __pfx___lock_acquired+0x10/0x10=20
[ 8273.789980]  ? __pfx___down_read_trylock+0x10/0x10=20
[ 8273.794805]  ? __pfx_xlog_cil_insert_items+0x10/0x10 [xfs]=20
[ 8273.800502]  ? xlog_cil_commit+0x59/0x690 [xfs]=20
[ 8273.805252]  xlog_cil_commit+0xa3/0x690 [xfs]=20
[ 8273.809856]  __xfs_trans_commit+0x8c3/0xec0 [xfs]=20
[ 8273.814781]  ? __pfx___xfs_trans_commit+0x10/0x10 [xfs]=20
[ 8273.820223]  ? __pfx_xfs_trans_alloc_inode+0x10/0x10 [xfs]=20
[ 8273.825957]  xfs_iomap_write_direct+0x362/0x630 [xfs]=20
[ 8273.831233]  ? __pfx_xfs_iomap_write_direct+0x10/0x10 [xfs]=20
[ 8273.837050]  ? xfs_direct_write_iomap_begin+0x8ad/0xd80 [xfs]=20
[ 8273.842998]  ? rcu_read_lock_sched_held+0x43/0x80=20
[ 8273.847737]  xfs_direct_write_iomap_begin+0x8d6/0xd80 [xfs]=20
[ 8273.853536]  ? slab_free_freelist_hook+0x11d/0x1d0=20
[ 8273.858355]  ? __pfx_xfs_direct_write_iomap_begin+0x10/0x10 [xfs]=20
[ 8273.864648]  ? __xfs_trans_commit+0x8cd/0xec0 [xfs]=20
[ 8273.869752]  ? kmem_cache_free+0xf9/0x3c0=20
[ 8273.873837]  ? __pfx_xfs_direct_write_iomap_begin+0x10/0x10 [xfs]=20
[ 8273.880133]  iomap_iter+0x341/0xe40=20
[ 8273.883667]  dax_iomap_rw+0x216/0x3a0=20
[ 8273.887366]  ? __pfx_dax_iomap_rw+0x10/0x10=20
[ 8273.891625]  ? xfs_file_write_checks+0x4b6/0x960 [xfs]=20
[ 8273.896991]  xfs_file_dax_write+0x278/0x9d0 [xfs]=20
[ 8273.901903]  ? __pfx_xfs_file_dax_write+0x10/0x10 [xfs]=20
[ 8273.907336]  ? xfs_file_write_iter+0x236/0x6a0 [xfs]=20
[ 8273.912513]  vfs_write+0x807/0xc70=20
[ 8273.915966]  ? __pfx_vfs_write+0x10/0x10=20
[ 8273.919934]  ? __fget_files+0x1d0/0x3f0=20
[ 8273.923848]  ksys_write+0xf9/0x1d0=20
[ 8273.927281]  ? __pfx_ksys_write+0x10/0x10=20
[ 8273.931316]  ? ktime_get_coarse_real_ts64+0x130/0x170=20
[ 8273.936421]  do_syscall_64+0x59/0x90=20
[ 8273.940033]  ? do_syscall_64+0x69/0x90=20
[ 8273.943813]  ? lockdep_hardirqs_on+0x79/0x100=20
[ 8273.948199]  ? do_syscall_64+0x69/0x90=20
[ 8273.951979]  ? lockdep_hardirqs_on+0x79/0x100=20
[ 8273.956364]  ? do_syscall_64+0x69/0x90=20
[ 8273.960142]  ? lockdep_hardirqs_on+0x79/0x100=20
[ 8273.964529]  ? do_syscall_64+0x69/0x90=20
[ 8273.968305]  ? lockdep_hardirqs_on+0x79/0x100=20
[ 8273.972693]  entry_SYSCALL_64_after_hwframe+0x72/0xdc=20
[ 8273.977768] RIP: 0033:0x7f40e013eb97=20
[ 8273.981374] Code: 0b 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f =
00
f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3=
d 00
f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24=20
[ 8274.000150] RSP: 002b:00007ffec966ee78 EFLAGS: 00000246 ORIG_RAX:
0000000000000001=20
[ 8274.007747] RAX: ffffffffffffffda RBX: 0000000000014f69 RCX:
00007f40e013eb97=20
[ 8274.014903] RDX: 0000000000014f69 RSI: 0000000001e5be00 RDI:
0000000000000004=20
[ 8274.022054] RBP: 0000000000000004 R08: 0000000000000003 R09:
0000000000000079=20
[ 8274.029205] R10: 0000000000000102 R11: 0000000000000246 R12:
0000000000000169=20
[ 8274.036364] R13: 00000000003ec889 R14: 0000000001e5be00 R15:
0000000000000000=20
[ 8274.043554]  </TASK>=20
[ 8274.045769] irq event stamp: 104511=20
[ 8274.049286] hardirqs last  enabled at (104521): [<ffffffff96dfac3b>]
__up_console_sem+0x6b/0x80=20
[ 8274.058006] hardirqs last disabled at (104530): [<ffffffff96dfac20>]
__up_console_sem+0x50/0x80=20
[ 8274.066729] softirqs last  enabled at (104544): [<ffffffff990ea156>]
__do_softirq+0x616/0x9c7=20
[ 8274.075277] softirqs last disabled at (104539): [<ffffffff96c48f76>]
__irq_exit_rcu+0x136/0x2a0=20
[ 8274.083994] ---[ end trace 0000000000000000 ]---=20
[ 8274.110301] XFS: Assertion failed: xfs_bmap_validate_extent(ip, whichfor=
k,
&rec) =3D=3D NULL, file: fs/xfs/libxfs/xfs_inode_fork.c, line: 557=20
[ 8274.122725] ------------[ cut here ]------------=20
[ 8274.127367] WARNING: CPU: 24 PID: 2216824 at fs/xfs/xfs_message.c:104
assfail+0x54/0x70 [xfs]=20
...
...

I hit this bug many times by different xfstests cases. e.g. generic/270,
generic/476 and generic/650. And the g/650 trigger another assertion and ke=
rnel
panic at last. More details refer to attachment console.log.

The HEAD commit I tested is:

commit 2eb29d59ddf02e39774abfb60b2030b0b7e27c1f
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Mar 2 15:08:54 2023 -0800

    Merge tag 'drm-next-2023-03-03-1' of git://anongit.freedesktop.org/drm/=
drm

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
