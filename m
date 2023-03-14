Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A956C6FD1D
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Mar 2023 15:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjCNPWj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 11:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjCNPWj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 11:22:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC93872B32
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 08:22:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78681617DE
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 15:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D84D6C433AA
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 15:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678807356;
        bh=yS9Xgn2/5IF+hY7N2oB4NfauBo7Ys1iqwWq+YnbExzk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=KcBVgx94SxN88iQWlA+GlGjAIPGNOpgnqRAgdQ0Hc6JKNI++P7bLypYodepMf5Ug+
         Do1rbT7aHzDZ3SDfS4P2gt7+MiEHB6lY5khPf4pIUwgGlvnQMK+N75w2g2yVtdc1Ha
         OqEAsfiftZfZ+0kddRMGvmxoO/IkErJNWzEksYz/MHond43QccXzyYr3Ys0f36vr19
         GKpCNOszy5h8Bn0NXn6YLP3nswPxGlXj9G26nbQmFGFQYZ4AMsAUhlfLAqhXzxhu1a
         RPLSGTtbkEdugGh1QtbCEtlsVF6YO/DhXsyXKImlSpYEH8JnAijwwPYwINXYB3k2bB
         BVc+BtJocS+WA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C596FC43142; Tue, 14 Mar 2023 15:22:36 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217138] [xfstests] XFS: Assertion failed:
 xfs_bmap_validate_extent(ip, whichfork, &rec) == NULL, file:
 fs/xfs/libxfs/xfs_inode_fork.c, line: 557
Date:   Tue, 14 Mar 2023 15:22:36 +0000
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
Message-ID: <bug-217138-201763-gLeTDox1Ty@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217138-201763@https.bugzilla.kernel.org/>
References: <bug-217138-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217138

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
[  854.173089] run fstests generic/270 at 2023-03-12 13:58:29=20
[  856.833887] memfd_create() without MFD_EXEC nor MFD_NOEXEC_SEAL, pid=3D1=
10193
'systemd'=20
[  849.010141] restraintd[2857]: *** Current Time: Sun Mar 12 13:58:32 2023=
=20
Localwatchdog at: Tue Mar 14 13:47:32 2023=20
[  857.976080] XFS (pmem0): DAX enabled. Warning: EXPERIMENTAL, use at your=
 own
risk=20
[  857.985038] XFS (pmem0): Mounting V5 Filesystem
e50966df-cb79-4d0c-9600-17be31022868=20
[  858.005751] XFS (pmem0): Ending clean mount=20
[  858.012146] XFS (pmem0): Quotacheck needed: Please wait.=20
[  858.025572] XFS (pmem0): Quotacheck: Done.=20
[  865.178004] XFS: Assertion failed: xfs_bmap_validate_extent(ip, whichfor=
k,
&rec) =3D=3D NULL, file: fs/xfs/libxfs/xfs_inode_fork.c, line: 559=20
[  865.190634] ------------[ cut here ]------------=20
[  865.195296] WARNING: CPU: 39 PID: 110331 at fs/xfs/xfs_message.c:104
assfail+0x54/0x70 [xfs]=20
[  865.204026] Modules linked in: loop rfkill intel_rapl_msr intel_rapl_com=
mon
intel_uncore_frequency intel_uncore_frequency_common ipmi_ssif i10nm_edac n=
fit
x86_pkg_temp_thermal intel_powerclamp coretemp mlx5_ib mgag200 i2c_algo_bit
drm_shmem_helper ib_uverbs dell_smbios drm_kms_helper kvm_intel iTCO_wdt
iTCO_vendor_support sunrpc dcdbas kvm irqbypass rapl intel_cstate acpi_ipmi
ib_core intel_uncore ipmi_si dax_pmem nd_pmem syscopyarea wmi_bmof
dell_wmi_descriptor pcspkr dax_hmem isst_if_mbox_pci mei_me i2c_i801
ipmi_devintf sysfillrect isst_if_mmio mei sysimgblt isst_if_common i2c_smbus
intel_vsec ipmi_msghandler acpi_power_meter drm fuse xfs libcrc32c sd_mod
t10_pi sg mlx5_core crct10dif_pclmul crc32_pclmul crc32c_intel mlxfw ahci
libahci tls ghash_clmulni_intel psample megaraid_sas tg3 libata pci_hyperv_=
intf
wmi dm_mirror dm_region_hash dm_log dm_mod=20
[  865.279707] CPU: 39 PID: 110331 Comm: 110035.fsstress Kdump: loaded Not
tainted 6.3.0-rc1+ #1=20
[  865.288254] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4
12/17/2021=20
[  865.295761] RIP: 0010:assfail+0x54/0x70 [xfs]=20
[  865.300361] Code: c1 48 ba 00 00 00 00 00 fc ff df 48 89 c1 83 e0 07 48 =
c1
e9 03 0f b6 14 11 38 c2 7f 04 84 d2 75 10 80 3d fe 16 2f 00 00 75 15 <0f> 0=
b c3
cc cc cc cc 48 c7 c7 10 46 9c c1 e8 89 ac ff d4 eb e2 0f=20
[  865.319133] RSP: 0018:ffa0000038f6efc8 EFLAGS: 00010246=20
[  865.324384] RAX: 0000000000000000 RBX: ffa0000038f6f050 RCX:
1ffffffff83388c2=20
[  865.331544] RDX: 0000000000000004 RSI: ffa0000038f6ed30 RDI:
ffffffffc1820a00=20
[  865.338700] RBP: ff11000723a9c040 R08: 00000000ffffffea R09:
ffa0000038f6ecd7=20
[  865.345867] R10: fff3fc00071edd9a R11: 0000000000000001 R12:
ff11000723a9c000=20
[  865.353018] R13: ffa0000038f6f030 R14: ff1100108dee11c8 R15:
0000000000000000=20
[  865.360178] FS:  00007fdd43d29740(0000) GS:ff11002035c00000(0000)
knlGS:0000000000000000=20
[  865.368288] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[  865.374062] CR2: 0000000000d50538 CR3: 00000006b3594003 CR4:
0000000000771ee0=20
[  865.381223] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000=20
[  865.388380] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400=20
[  865.395538] PKRU: 55555554=20
[  865.398285] Call Trace:=20
[  865.400767]  <TASK>=20
[  865.402899]  xfs_iextents_copy+0x4ec/0x6e0 [xfs]=20
[  865.407746]  ? xfs_bmap_validate_extent+0x1e3/0x2a0 [xfs]=20
[  865.413370]  ? __pfx_xfs_iextents_copy+0x10/0x10 [xfs]=20
[  865.418747]  ? xfs_inode_to_log_dinode+0x8d7/0x1370 [xfs]=20
[  865.424389]  ? do_raw_spin_unlock+0x55/0x1f0=20
[  865.428698]  xfs_inode_item_format_data_fork+0x9c9/0x10f0 [xfs]=20
[  865.434864]  xfs_inode_item_format+0x6b3/0xb40 [xfs]=20
[  865.440079]  ? trace_contention_end+0x177/0x1f0=20
[  865.444645]  ? __pfx_xfs_inode_item_format+0x10/0x10 [xfs]=20
[  865.450386]  xlog_cil_insert_format_items+0x2b2/0x5f0 [xfs]=20
[  865.456206]  xlog_cil_insert_items+0xe2/0x1060 [xfs]=20
[  865.461429]  ? __lock_acquired+0x209/0x830=20
[  865.465566]  ? __pfx___lock_acquired+0x10/0x10=20
[  865.470037]  ? __pfx___down_read_trylock+0x10/0x10=20
[  865.474864]  ? __pfx_xlog_cil_insert_items+0x10/0x10 [xfs]=20
[  865.480600]  ? xlog_cil_commit+0x59/0x690 [xfs]=20
[  865.485373]  xlog_cil_commit+0xa3/0x690 [xfs]=20
[  865.489981]  __xfs_trans_commit+0x8c3/0xec0 [xfs]=20
[  865.494936]  ? __pfx___xfs_trans_commit+0x10/0x10 [xfs]=20
[  865.500395]  ? __pfx_xfs_trans_alloc_inode+0x10/0x10 [xfs]=20
[  865.506131]  xfs_iomap_write_direct+0x362/0x630 [xfs]=20
[  865.511439]  ? __pfx_xfs_iomap_write_direct+0x10/0x10 [xfs]=20
[  865.517253]  ? xfs_direct_write_iomap_begin+0x8ad/0xd80 [xfs]=20
[  865.523249]  ? rcu_read_lock_sched_held+0x43/0x80=20
[  865.527996]  xfs_direct_write_iomap_begin+0x8d6/0xd80 [xfs]=20
[  865.533812]  ? slab_free_freelist_hook+0x11d/0x1d0=20
[  865.538639]  ? __pfx_xfs_direct_write_iomap_begin+0x10/0x10 [xfs]=20
[  865.544960]  ? __xfs_trans_commit+0x8cd/0xec0 [xfs]=20
[  865.550074]  ? kmem_cache_free+0xf9/0x3c0=20
[  865.554161]  ? __pfx_xfs_direct_write_iomap_begin+0x10/0x10 [xfs]=20
[  865.560496]  iomap_iter+0x341/0xe40=20
[  865.564037]  dax_iomap_rw+0x216/0x3a0=20
[  865.567735]  ? __pfx_dax_iomap_rw+0x10/0x10=20
[  865.571998]  ? xfs_file_write_checks+0x4b6/0x960 [xfs]=20
[  865.577388]  xfs_file_dax_write+0x278/0x9d0 [xfs]=20
[  865.582323]  ? __pfx_xfs_file_dax_write+0x10/0x10 [xfs]=20
[  865.587770]  ? __mutex_lock+0x741/0x1490=20
[  865.591732]  ? xfs_file_write_iter+0x236/0x6a0 [xfs]=20
[  865.596932]  do_iter_readv_writev+0x199/0x300=20
[  865.601327]  ? __pfx_do_iter_readv_writev+0x10/0x10=20
[  865.606248]  ? selinux_file_permission+0x356/0x440=20
[  865.611096]  do_iter_write+0x11f/0x3b0=20
[  865.614883]  iter_file_splice_write+0x5a5/0xaf0=20
[  865.619471]  ? __pfx_iter_file_splice_write+0x10/0x10=20
[  865.624548]  ? lock_acquire+0x1d8/0x660=20
[  865.628425]  ? __pfx_lock_acquire+0x10/0x10=20
[  865.632677]  do_splice+0x3d9/0xcc0=20
[  865.636117]  ? __pfx_do_splice+0x10/0x10=20
[  865.640077]  ? __might_fault+0xbc/0x160=20
[  865.643958]  __do_splice+0x102/0x1d0=20
[  865.647574]  ? __pfx___do_splice+0x10/0x10=20
[  865.651721]  __x64_sys_splice+0x151/0x210=20
[  865.655778]  do_syscall_64+0x59/0x90=20
[  865.659399]  ? do_syscall_64+0x69/0x90=20
[  865.663175]  ? lockdep_hardirqs_on+0x79/0x100=20
[  865.667565]  ? do_syscall_64+0x69/0x90=20
[  865.671346]  ? do_syscall_64+0x69/0x90=20
[  865.675133]  ? do_syscall_64+0x69/0x90=20
[  865.678914]  ? do_syscall_64+0x69/0x90=20
[  865.682692]  ? lockdep_hardirqs_on+0x79/0x100=20
[  865.687081]  entry_SYSCALL_64_after_hwframe+0x72/0xdc=20
[  865.692166] RIP: 0033:0x7fdd43b4ec8a=20
[  865.695772] Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 00 f3 0f =
1e
fa 49 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 15 b8 13 01 00 00 0f 05 <48> 3=
d 00
f0 ff ff 77 7e c3 0f 1f 44 00 00 41 54 48 83 ec 30 44 89=20
[  865.714543] RSP: 002b:00007fff2a17aa78 EFLAGS: 00000246 ORIG_RAX:
0000000000000113=20
[  865.722144] RAX: ffffffffffffffda RBX: 0000000000010000 RCX:
00007fdd43b4ec8a=20
[  865.729303] RDX: 0000000000000005 RSI: 0000000000000000 RDI:
0000000000000006=20
[  865.736461] RBP: 0000000000000005 R08: 0000000000010000 R09:
0000000000000000=20
[  865.743624] R10: 00007fff2a17aac0 R11: 0000000000000246 R12:
0000000000010000=20
[  865.750788] R13: 0000000000000004 R14: 000000000001e468 R15:
0000000000000000=20
[  865.757977]  </TASK>=20
[  865.760199] irq event stamp: 305803=20
[  865.763717] hardirqs last  enabled at (305813): [<ffffffff95ffacab>]
__up_console_sem+0x6b/0x80=20
[  865.772436] hardirqs last disabled at (305822): [<ffffffff95ffac90>]
__up_console_sem+0x50/0x80=20
[  865.781154] softirqs last  enabled at (305770): [<ffffffff982eb156>]
__do_softirq+0x616/0x9c7=20
[  865.789699] softirqs last disabled at (305765): [<ffffffff95e48ff6>]
__irq_exit_rcu+0x136/0x2a0=20
[  865.798421] ---[ end trace 0000000000000000 ]---=20

# Get the debug information which asked by Darrick:

[  865.803066] XFS (pmem0): bmbt_rec: startoff=3D11594, startblock=3D11594,
blockcount=3D0, state=3D0x0....validation returned addr 0x00000000d67d9cc8=
=20
[  865.803066]

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
