Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B7CC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Oct 2022 17:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiJIR6i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Oct 2022 13:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiJIR6g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Oct 2022 13:58:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E83B6
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 10:58:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3033D60C51
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 17:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94D0FC43142
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 17:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665338313;
        bh=sBxhgEb3DKp+MyyMXEQlsN7FEZkVyx4KixmMazkiVWI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Gi8wa89coHiDLOfn6CAMJmTzt0E0fc23CSJxPcgB4ydZ9ROxsad2FWPeiz5aYkus3
         oyPWPYo7NXgjRv+A/RJWp0Jrt5FNaRN2O30gohBf4B7k2VL5OBOekJSS0EQnTBuk53
         MEUT0p5/nkqYZmzNpsi/59OF8nPwID3ZHFyNbyaYgzzdcrwyI2JOahImEAv1+F9/7q
         xTMCzaos+q4TwEscnGIJLO4kJaW6/ZwLycbzR84DPngXl4Q2pE4vyD+fBVkkbvO8hM
         gmvXs3HwdKI20GmFL71xarmrh8aXCEKRgvzFBldqrhulvRLCTut9wx22emFMEBpFdh
         fEyDwATgwaRcQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 8464DC05F8A; Sun,  9 Oct 2022 17:58:33 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216567] [xfstests generic/451] kernel BUG at mm/truncate.c:669!
Date:   Sun, 09 Oct 2022 17:58:33 +0000
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
Message-ID: <bug-216567-201763-9phRYnyMqv@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216567-201763@https.bugzilla.kernel.org/>
References: <bug-216567-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216567

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
Hmm... besides this panic, g/451 just hit another panic when I tried to
reproduce this bug:

[ 1084.111233] run fstests generic/451 at 2022-10-09 11:12:39=20
[ 1099.015616] restraintd[2581]: *** Current Time: Sun Oct 09 11:12:56 2022=
=20
Localwatchdog at: Tue Oct 11 10:57:56 2022=20
[ 1101.932132] ------------[ cut here ]------------=20
[ 1101.932220] ------------[ cut here ]------------=20
[ 1101.936972] kernel BUG at include/linux/pagemap.h:1247!=20
[ 1101.936985] invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI=20
[ 1101.941681] kernel BUG at include/linux/pagemap.h:1247!=20
[ 1101.946825] CPU: 19 PID: 557513 Comm: xfs_io Kdump: loaded Not tainted
6.0.0+ #1=20
[ 1101.946831] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4
12/17/2021=20
[ 1101.946833] RIP: 0010:read_pages+0xa29/0xda0=20
[ 1101.976950] Code: ff ff be 01 00 00 00 e9 87 fe ff ff 0f b6 d0 be ff ff =
ff
ff 4c 89 ff 88 44 24 18 e8 11 74 25 00 0f b6 44 24 18 e9 f1 fe ff ff <0f> 0=
b 4c
89 ff e8 1d 86 00 00 e9 ea fe ff ff 48 c7 c6 c0 85 55 99=20
[ 1101.995693] RSP: 0018:ffa00000396ef7f0 EFLAGS: 00010202=20
[ 1102.000921] RAX: 0000000000000002 RBX: dffffc0000000000 RCX:
0000000000000001=20
[ 1102.008054] RDX: 1fe220003427d324 RSI: 0000000000000004 RDI:
ffd40000095e8500=20
[ 1102.015186] RBP: ffffffffc13f66c0 R08: 0000000000000000 R09:
ffffffff9aa44067=20
[ 1102.022321] R10: fffffbfff354880c R11: 0000000000000001 R12:
fff3fc00072ddf4a=20
[ 1102.029451] R13: ffa00000396efa54 R14: ffa00000396efa30 R15:
0000000000000003=20
[ 1102.036584] FS:  00007f1de484b740(0000) GS:ff11002033400000(0000)
knlGS:0000000000000000=20
[ 1102.044671] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[ 1102.050418] CR2: 0000000001c81ff8 CR3: 000000016171e004 CR4:
0000000000771ee0=20
[ 1102.057549] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000=20
[ 1102.064681] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400=20
[ 1102.071815] PKRU: 55555554=20
[ 1102.074527] Call Trace:=20
[ 1102.076982]  <TASK>=20
[ 1102.079092]  ? file_ra_state_init+0xe0/0xe0=20
[ 1102.083283]  ? __xa_clear_mark+0x100/0x100=20
[ 1102.087385]  page_cache_ra_unbounded+0x269/0x510=20
[ 1102.092013]  filemap_get_pages+0x26d/0x980=20
[ 1102.096121]  ? filemap_add_folio+0x150/0x150=20
[ 1102.100403]  filemap_read+0x2a9/0xae0=20
[ 1102.104074]  ? lock_acquire+0x1d8/0x620=20
[ 1102.107921]  ? find_held_lock+0x33/0x120=20
[ 1102.111850]  ? filemap_get_pages+0x980/0x980=20
[ 1102.116121]  ? validate_chain+0x154/0xdf0=20
[ 1102.120133]  ? __lock_contended+0x980/0x980=20
[ 1102.124320]  ? xfs_ilock+0x1d0/0x4d0 [xfs]=20
[ 1102.128582]  ? xfs_ilock+0x1d0/0x4d0 [xfs]=20
[ 1102.132816]  xfs_file_buffered_read+0x16f/0x390 [xfs]=20
[ 1102.137995]  xfs_file_read_iter+0x274/0x560 [xfs]=20
[ 1102.142831]  vfs_read+0x585/0x810=20
[ 1102.146153]  ? kernel_read+0x140/0x140=20
[ 1102.149904]  ? __fget_files+0x1b8/0x3d0=20
[ 1102.153757]  __x64_sys_pread64+0x1a0/0x1f0=20
[ 1102.157860]  ? vfs_read+0x810/0x810=20
[ 1102.161350]  ? ktime_get_coarse_real_ts64+0x130/0x170=20
[ 1102.166409]  do_syscall_64+0x59/0x90=20
[ 1102.169995]  ? asm_exc_page_fault+0x22/0x30=20
[ 1102.174179]  ? lockdep_hardirqs_on+0x79/0x100=20
[ 1102.178538]  entry_SYSCALL_64_after_hwframe+0x63/0xcd=20
[ 1102.183591] RIP: 0033:0x7f1de473c92f=20
[ 1102.187171] Code: 08 89 3c 24 48 89 4c 24 18 e8 dd f2 f5 ff 4c 8b 54 24 =
18
48 8b 54 24 10 41 89 c0 48 8b 74 24 08 8b 3c 24 b8 11 00 00 00 0f 05 <48> 3=
d 00
f0 ff ff 77 31 44 89 c7 48 89 04 24 e8 2d f3 f5 ff 48 8b=20
[ 1102.205916] RSP: 002b:00007ffe2a2997c0 EFLAGS: 00000293 ORIG_RAX:
0000000000000011=20
[ 1102.213483] RAX: ffffffffffffffda RBX: 00007ffe2a299870 RCX:
00007f1de473c92f=20
[ 1102.220615] RDX: 0000000000001000 RSI: 0000000001c80000 RDI:
0000000000000003=20
[ 1102.227746] RBP: 0000000000000003 R08: 0000000000000000 R09:
0000000000000003=20
[ 1102.234881] R10: 0000000000000000 R11: 0000000000000293 R12:
0000000000000000=20
[ 1102.242012] R13: 00000000000a0000 R14: 0000000000000000 R15:
0000000000000000=20
[ 1102.249149]  </TASK>=20
[ 1102.251339] Modules linked in: ipmi_ssif mgag200 i2c_algo_bit
drm_shmem_helper mlx5_ib drm_kms_helper intel_rapl_msr intel_rapl_common
syscopyarea mei_me dell_smbios sysfillrect intel_uncore_frequency
intel_uncore_frequency_common i10nm_edac nfit x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel dcdbas rfkill kvm irqbypass rapl
intel_cstate ib_uverbs intel_uncore wmi_bmof dell_wmi_descriptor
isst_if_mbox_pci ib_core pcspkr acpi_ipmi sysimgblt isst_if_mmio isst_if_co=
mmon
i2c_i801 fb_sys_fops i2c_smbus mei ipmi_si intel_pch_thermal intel_vsec
ipmi_devintf ipmi_msghandler acpi_power_meter sunrpc drm fuse xfs libcrc32c
sd_mod t10_pi sg crct10dif_pclmul mlx5_core crc32_pclmul crc32c_intel mlxfw
ghash_clmulni_intel ahci tls libahci psample megaraid_sas pci_hyperv_intf t=
g3
libata wmi=20
[ 1102.320728] invalid opcode: 0000 [#2] PREEMPT SMP KASAN NOPTI=20
[ 1102.320837] ---[ end trace 0000000000000000 ]---=20
[ 1102.326480] CPU: 10 PID: 557515 Comm: xfs_io Kdump: loaded Tainted: G   =
   D
           6.0.0+ #1=20
[ 1102.326486] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4
12/17/2021=20
[ 1102.362536] RIP: 0010:read_pages+0xa29/0xda0=20
[ 1102.369990] RIP: 0010:read_pages+0xa29/0xda0=20
[ 1102.377478] Code: ff ff be 01 00 00 00 e9 87 fe ff ff 0f b6 d0 be ff ff =
ff
ff 4c 89 ff 88 44 24 18 e8 11 74 25 00 0f b6 44 24 18 e9 f1 fe ff ff <0f> 0=
b 4c
89 ff e8 1d 86 00 00 e9 ea fe ff ff 48 c7 c6 c0 85 55 99=20
[ 1102.381748] Code: ff ff be 01 00 00 00 e9 87 fe ff ff 0f b6 d0 be ff ff =
ff
ff 4c 89 ff 88 44 24 18 e8 11 74 25 00 0f b6 44 24 18 e9 f1 fe ff ff <0f> 0=
b 4c
89 ff e8 1d 86 00 00 e9 ea fe ff ff 48 c7 c6 c0 85 55 99=20
[ 1102.381752] RSP: 0018:ffa0000039a2f748 EFLAGS: 00010202=20
[ 1102.386033] RSP: 0018:ffa00000396ef7f0 EFLAGS: 00010202=20
[ 1102.404773]=20=20
[ 1102.404776] RAX: 0000000000000003 RBX: dffffc0000000000 RCX:
0000000000000001=20
[ 1102.404780] RDX: 1fe220022688e324 RSI: 0000000000000004 RDI:
ffd40000095e8500=20
[ 1102.423538]=20=20
[ 1102.428756] RBP: ffffffffc13f66c0 R08: 0000000000000000 R09:
ffffffff9aa44067=20
[ 1102.428760] R10: fffffbfff354880c R11: 0000000000000001 R12:
fff3fc0007345f37=20
[ 1102.428762] R13: ffa0000039a2f9bc R14: ffa0000039a2f998 R15:
0000000000000044=20
[ 1102.433996] RAX: 0000000000000002 RBX: dffffc0000000000 RCX:
0000000000000001=20
[ 1102.435490] FS:  00007f519912f740(0000) GS:ff11000c26200000(0000)
knlGS:0000000000000000=20
[ 1102.435494] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[ 1102.442636] RDX: 1fe220003427d324 RSI: 0000000000000004 RDI:
ffd40000095e8500=20
[ 1102.449763] CR2: 0000000001730ff8 CR3: 0000000181d82005 CR4:
0000000000771ee0=20
[ 1102.449766] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000=20
[ 1102.449767] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400=20
[ 1102.451267] RBP: ffffffffc13f66c0 R08: 0000000000000000 R09:
ffffffff9aa44067=20
[ 1102.458394] PKRU: 55555554=20
[ 1102.458397] Call Trace:=20
[ 1102.458399]  <TASK>=20
[ 1102.458405]  ? file_ra_state_init+0xe0/0xe0=20
[ 1102.465537] R10: fffffbfff354880c R11: 0000000000000001 R12:
fff3fc00072ddf4a=20
[ 1102.472662]  ? lockdep_hardirqs_on+0x79/0x100=20
[ 1102.479808] R13: ffa00000396efa54 R14: ffa00000396efa30 R15:
0000000000000003=20
[ 1102.487888]  ? _raw_spin_unlock_irqrestore+0x42/0x70=20
[ 1102.493639] FS:  00007f1de484b740(0000) GS:ff11002033400000(0000)
knlGS:0000000000000000=20
[ 1102.500767]  ? free_unref_page+0x31b/0x460=20
[ 1102.507904] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[ 1102.515036]  page_cache_ra_order+0x563/0x7e0=20
[ 1102.522177] CR2: 0000000001c81ff8 CR3: 000000016171e004 CR4:
0000000000771ee0=20
[ 1102.529310]  filemap_get_pages+0x58f/0x980=20
[ 1102.532024] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000=20
[ 1102.534475]  ? filemap_add_folio+0x150/0x150=20
[ 1102.536592] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400=20
[ 1102.540779]  filemap_read+0x2a9/0xae0=20
[ 1102.547919] PKRU: 55555554=20
[ 1102.552275]  ? lock_acquire+0x1d8/0x620=20
[ 1102.559414] ------------[ cut here ]------------=20
[ 1102.564374]  ? find_held_lock+0x33/0x120=20
[ 1102.572472] WARNING: CPU: 19 PID: 557513 at kernel/exit.c:741
do_exit+0x880/0xa70=20
[ 1102.576568]  ? filemap_get_pages+0x980/0x980=20
[ 1102.582318] Modules linked in:=20
[ 1102.586587]  ? validate_chain+0x154/0xdf0=20
[ 1102.586596]  ? xfs_ilock+0x1d0/0x4d0 [xfs]=20
[ 1102.593731]  ipmi_ssif=20
[ 1102.597826]  ? xfs_ilock+0x1d0/0x4d0 [xfs]=20
[ 1102.604966]  mgag200=20
[ 1102.609235]  xfs_file_buffered_read+0x16f/0x390 [xfs]=20
[ 1102.616378]  i2c_algo_bit=20
[ 1102.620042]  xfs_file_read_iter+0x274/0x560 [xfs]=20
[ 1102.622765]  drm_shmem_helper=20
[ 1102.626603]  vfs_read+0x585/0x810=20
[ 1102.631233]  mlx5_ib=20
[ 1102.635157]  ? kernel_read+0x140/0x140=20
[ 1102.635162]  ? __fget_files+0x1b8/0x3d0=20
[ 1102.642647]  drm_kms_helper=20
[ 1102.646920]  __x64_sys_pread64+0x1a0/0x1f0=20
[ 1102.649978]  intel_rapl_msr=20
[ 1102.653988]  ? vfs_read+0x810/0x810=20
[ 1102.653992]  ? ktime_get_coarse_real_ts64+0x130/0x170=20
[ 1102.658099]  intel_rapl_common=20
[ 1102.660466]  do_syscall_64+0x59/0x90=20
[ 1102.664572]  syscopyarea=20
[ 1102.666765]  ? do_syscall_64+0x69/0x90=20
[ 1102.671828]  mei_me=20
[ 1102.674450]  ? lockdep_hardirqs_on+0x79/0x100=20
[ 1102.674455]  ? do_syscall_64+0x69/0x90=20
[ 1102.679167]  dell_smbios=20
[ 1102.682138]  ? do_syscall_64+0x69/0x90=20
[ 1102.682144]  ? lockdep_hardirqs_on+0x79/0x100=20
[ 1102.685468]  sysfillrect=20
[ 1102.687656]  ? do_syscall_64+0x69/0x90=20
[ 1102.687662]  ? lockdep_hardirqs_on+0x79/0x100=20
[ 1102.691414]  intel_uncore_frequency=20
[ 1102.695249]  ? do_syscall_64+0x69/0x90=20
[ 1102.695252]  ? lockdep_hardirqs_on+0x79/0x100=20
[ 1102.698052]  intel_uncore_frequency_common=20
[ 1102.702149]  ? do_syscall_64+0x69/0x90=20
[ 1102.702152]  ? do_syscall_64+0x69/0x90=20
[ 1102.702154]  ? lockdep_hardirqs_on+0x79/0x100=20
[ 1102.704959]  i10nm_edac=20
[ 1102.708449]  entry_SYSCALL_64_after_hwframe+0x63/0xcd=20
[ 1102.708455] RIP: 0033:0x7f5198f3c92f=20
[ 1102.713514]  nfit=20
[ 1102.716569] Code: 08 89 3c 24 48 89 4c 24 18 e8 dd f2 f5 ff 4c 8b 54 24 =
18
48 8b 54 24 10 41 89 c0 48 8b 74 24 08 8b 3c 24 b8 11 00 00 00 0f 05 <48> 3=
d 00
f0 ff ff 77 31 44 89 c7 48 89 04 24 e8 2d f3 f5 ff 48 8b=20
[ 1102.720153]  x86_pkg_temp_thermal=20
[ 1102.722687] RSP: 002b:00007ffea5ebbe90 EFLAGS: 00000293 ORIG_RAX:
0000000000000011=20
[ 1102.726445]  intel_powerclamp=20
[ 1102.728548] RAX: ffffffffffffffda RBX: 00007ffea5ebbf40 RCX:
00007f5198f3c92f=20
[ 1102.728551] RDX: 0000000000001000 RSI: 000000000172f000 RDI:
0000000000000003=20
[ 1102.732918]  coretemp=20
[ 1102.736667] RBP: 0000000000000003 R08: 0000000000000000 R09:
0000000000000003=20
[ 1102.736670] R10: 0000000000028000 R11: 0000000000000293 R12:
0000000000000028=20
[ 1102.736673] R13: 0000000000078000 R14: 0000000000000000 R15:
0000000000028000=20
[ 1102.736679]  </TASK>=20
[ 1102.739218]  kvm_intel=20
[ 1102.742967] Modules linked in: ipmi_ssif mgag200=20
[ 1102.747332]  dcdbas=20
[ 1102.749869]  i2c_algo_bit drm_shmem_helper mlx5_ib=20
[ 1102.753633]  rfkill=20
[ 1102.757987]  drm_kms_helper intel_rapl_msr intel_rapl_common syscopyarea
mei_me=20
[ 1102.761493]  kvm=20
[ 1102.765241]  dell_smbios sysfillrect intel_uncore_frequency
intel_uncore_frequency_common i10nm_edac=20
[ 1102.769605]  irqbypass=20
[ 1102.773701]  nfit x86_pkg_temp_thermal intel_powerclamp coretemp kvm_int=
el=20
[ 1102.777466]  rapl=20
[ 1102.781216]  dcdbas rfkill kvm irqbypass rapl=20
[ 1102.785588]  intel_cstate=20
[ 1102.788035]  intel_cstate ib_uverbs intel_uncore wmi_bmof
dell_wmi_descriptor=20
[ 1102.793092]  ib_uverbs=20
[ 1102.796667]  isst_if_mbox_pci ib_core pcspkr=20
[ 1102.798604]  intel_uncore=20
[ 1102.817348]  acpi_ipmi sysimgblt isst_if_mmio isst_if_common=20
[ 1102.820680]  wmi_bmof=20
[ 1102.828241]  i2c_i801 fb_sys_fops i2c_smbus=20
[ 1102.831226]  dell_wmi_descriptor=20
[ 1102.838356]  mei ipmi_si intel_pch_thermal=20
[ 1102.845500]  isst_if_mbox_pci=20
[ 1102.847776]  intel_vsec ipmi_devintf ipmi_msghandler=20
[ 1102.854920]  ib_core=20
[ 1102.862050]  acpi_power_meter sunrpc drm=20
[ 1102.869197]  pcspkr=20
[ 1102.871383]  fuse xfs libcrc32c sd_mod=20
[ 1102.873755]  acpi_ipmi=20
[ 1102.878369]  t10_pi sg crct10dif_pclmul=20
[ 1102.880489]  sysimgblt=20
[ 1102.885277]  mlx5_core crc32_pclmul crc32c_intel mlxfw ghash_clmulni_int=
el
ahci tls=20
[ 1102.887396]  isst_if_mmio=20
[ 1102.894696]  libahci psample megaraid_sas pci_hyperv_intf tg3=20
[ 1102.896547]  isst_if_common=20
[ 1102.905670]  libata wmi=20
[ 1102.905712] ---[ end trace 0000000000000000 ]---=20
[ 1102.908069]  i2c_i801 fb_sys_fops i2c_smbus mei ipmi_si intel_pch_thermal
intel_vsec ipmi_devintf ipmi_msghandler acpi_power_meter sunrpc=20
[ 1102.983596] RIP: 0010:read_pages+0xa29/0xda0=20
[ 1102.984065]  drm=20
[ 1102.988419] Code: ff ff be 01 00 00 00 e9 87 fe ff ff 0f b6 d0 be ff ff =
ff
ff 4c 89 ff 88 44 24 18 e8 11 74 25 00 0f b6 44 24 18 e9 f1 fe ff ff <0f> 0=
b 4c
89 ff e8 1d 86 00 00 e9 ea fe ff ff 48 c7 c6 c0 85 55 99=20
[ 1102.991052]  fuse xfs libcrc32c sd_mod t10_pi sg crct10dif_pclmul=20
[ 1102.998194] RSP: 0018:ffa00000396ef7f0 EFLAGS: 00010202=20
[ 1103.000567]  mlx5_core crc32_pclmul crc32c_intel mlxfw ghash_clmulni_int=
el
ahci=20
[ 1103.004850]=20=20
[ 1103.007481]  tls libahci psample megaraid_sas pci_hyperv_intf tg3 libata=
=20
[ 1103.013152] RAX: 0000000000000002 RBX: dffffc0000000000 RCX:
0000000000000001=20
[ 1103.013156] RDX: 1fe220003427d324 RSI: 0000000000000004 RDI:
ffd40000095e8500=20
[ 1103.015438]  wmi=20
[ 1103.015442] CPU: 19 PID: 557513 Comm: xfs_io Kdump: loaded Tainted: G   =
   D
           6.0.0+ #1=20
[ 1103.019634] RBP: ffffffffc13f66c0 R08: 0000000000000000 R09:
ffffffff9aa44067=20
[ 1103.022875] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4
12/17/2021=20
[ 1103.022878] RIP: 0010:do_exit+0x880/0xa70=20
[ 1103.026985] R10: fffffbfff354880c R11: 0000000000000001 R12:
fff3fc00072ddf4a=20
[ 1103.029966] Code: ff ff 37 00 48 89 fa 48 c1 e0 2a 48 c1 ea 03 80 3c 02 =
00
0f 85 49 01 00 00 48 8b bd c0 1a 00 00 e8 f5 1c 7f 00 e9 ce fc ff ff <0f> 0=
b e9
c8 f7 ff ff 48 89 ee bf 05 06 00 00 e8 6c 91 02 00 e9 f9=20
[ 1103.034938] R13: ffa00000396efa54 R14: ffa00000396efa30 R15:
0000000000000003=20
[ 1103.037130] RSP: 0018:ffa00000396efee0 EFLAGS: 00010282=20
[ 1103.037134] RAX: dffffc0000000000 RBX: ff110001a13e8000 RCX:
0000000000000000=20
[ 1103.037136] RDX: 1fe220003427d325 RSI: 0000000000000000 RDI:
ff110001a13e9928=20
[ 1103.041067] FS:  00007f519912f740(0000) GS:ff11000c26200000(0000)
knlGS:0000000000000000=20
[ 1103.043172] RBP: 000000000000000b R08: 000000000000000e R09:
fff3fc00072dd000=20
[ 1103.043175] R10: ffe21c04066bfa90 R11: 0000000000000001 R12:
000000000000000b=20
[ 1103.043177] R13: 0000000000000004 R14: 0000000000000000 R15:
ff110001a13e8000=20
[ 1103.043179] FS:  00007f1de484b740(0000) GS:ff11002033400000(0000)
knlGS:0000000000000000=20
[ 1103.046940] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[ 1103.049307] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[ 1103.049310] CR2: 0000000001c81ff8 CR3: 000000016171e004 CR4:
0000000000771ee0=20
[ 1103.049312] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000=20
[ 1103.053159] CR2: 0000000001730ff8 CR3: 0000000181d82005 CR4:
0000000000771ee0=20
[ 1103.055536] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400=20
[ 1103.055540] PKRU: 55555554=20
[ 1103.055543] Call Trace:=20
[ 1103.055545]  <TASK>=20
[ 1103.063203] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000=20
[ 1103.065835]  ? do_syscall_64+0x59/0x90=20
[ 1103.065842]  make_task_dead+0xb0/0xc0=20
[ 1103.071592] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400=20
[ 1103.074399]  rewind_stack_and_make_dead+0x17/0x20=20
[ 1103.076862] PKRU: 55555554=20
[ 1103.081489] RIP: 0033:0x7f1de473c92f=20
[ 1103.081494] Code: 08 89 3c 24 48 89 4c 24 18 e8 dd f2 f5 ff 4c 8b 54 24 =
18
48 8b 54 24 10 41 89 c0 48 8b 74 24 08 8b 3c 24 b8 11 00 00 00 0f 05 <48> 3=
d 00
f0 ff ff 77 31 44 89 c7 48 89 04 24 e8 2d f3 f5 ff 48 8b=20
[ 1103.093837] ------------[ cut here ]------------=20
[ 1103.098110] RSP: 002b:00007ffe2a2997c0 EFLAGS: 00000293 ORIG_RAX:
0000000000000011=20
[ 1103.098114] RAX: ffffffffffffffda RBX: 00007ffe2a299870 RCX:
00007f1de473c92f=20
[ 1103.099966] WARNING: CPU: 10 PID: 557515 at kernel/exit.c:741
do_exit+0x880/0xa70=20
[ 1103.118724] RDX: 0000000000001000 RSI: 0000000001c80000 RDI:
0000000000000003=20
[ 1103.118727] RBP: 0000000000000003 R08: 0000000000000000 R09:
0000000000000003=20
[ 1103.118728] R10: 0000000000000000 R11: 0000000000000293 R12:
0000000000000000=20
[ 1103.118730] R13: 00000000000a0000 R14: 0000000000000000 R15:
0000000000000000=20
[ 1103.118738]  </TASK>=20
[ 1103.124831] Modules linked in:=20
[ 1103.130058] irq event stamp: 10669=20
[ 1103.130060] hardirqs last  enabled at (10669): [<ffffffff96a6be91>]
do_error_trap+0x141/0x160=20
[ 1103.137371]  ipmi_ssif=20
[ 1103.138869] hardirqs last disabled at (10668): [<ffffffff98e7e700>]
exc_invalid_op+0x20/0x50=20
[ 1103.138873] softirqs last  enabled at (10536): [<ffffffff96a93551>]
fpu_clone+0x301/0xa80=20
[ 1103.145582]  mgag200=20
[ 1103.152720] softirqs last disabled at (10534): [<ffffffff96a934ec>]
fpu_clone+0x29c/0xa80=20
[ 1103.152725] ---[ end trace 0000000000000000 ]---=20
[ 1103.159863]  i2c_algo_bit drm_shmem_helper mlx5_ib drm_kms_helper
intel_rapl_msr intel_rapl_common syscopyarea mei_me dell_smbios sysfillrect
intel_uncore_frequency intel_uncore_frequency_common i10nm_edac nfit
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel dcdbas rfkill kvm
irqbypass rapl intel_cstate ib_uverbs intel_uncore wmi_bmof dell_wmi_descri=
ptor
isst_if_mbox_pci ib_core pcspkr acpi_ipmi sysimgblt isst_if_mmio isst_if_co=
mmon
i2c_i801 fb_sys_fops i2c_smbus mei ipmi_si intel_pch_thermal intel_vsec
ipmi_devintf ipmi_msghandler acpi_power_meter sunrpc drm fuse xfs libcrc32c
sd_mod t10_pi sg crct10dif_pclmul mlx5_core crc32_pclmul crc32c_intel mlxfw
ghash_clmulni_intel ahci tls libahci psample megaraid_sas pci_hyperv_intf t=
g3
libata wmi=20
[ 1103.551036] CPU: 10 PID: 557515 Comm: xfs_io Kdump: loaded Tainted: G   =
   D
W          6.0.0+ #1=20
[ 1103.559914] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4
12/17/2021=20
[ 1103.567404] RIP: 0010:do_exit+0x880/0xa70=20
[ 1103.571433] Code: ff ff 37 00 48 89 fa 48 c1 e0 2a 48 c1 ea 03 80 3c 02 =
00
0f 85 49 01 00 00 48 8b bd c0 1a 00 00 e8 f5 1c 7f 00 e9 ce fc ff ff <0f> 0=
b e9
c8 f7 ff ff 48 89 ee bf 05 06 00 00 e8 6c 91 02 00 e9 f9=20
[ 1103.590190] RSP: 0018:ffa0000039a2fee0 EFLAGS: 00010286=20
[ 1103.595432] RAX: dffffc0000000000 RBX: ff11001134470000 RCX:
0000000000000000=20
[ 1103.602573] RDX: 1fe220022688e325 RSI: 0000000000000000 RDI:
ff11001134471928=20
[ 1103.609713] RBP: 000000000000000b R08: 000000000000000e R09:
fff3fc0007345000=20
[ 1103.616858] R10: ffe21c0184c7fa90 R11: 0000000000000001 R12:
000000000000000b=20
[ 1103.623996] R13: 0000000000000004 R14: 0000000000000000 R15:
ff11001134470000=20
[ 1103.631138] FS:  00007f519912f740(0000) GS:ff11000c26200000(0000)
knlGS:0000000000000000=20
[ 1103.639234] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[ 1103.644988] CR2: 0000000001730ff8 CR3: 0000000181d82005 CR4:
0000000000771ee0=20
[ 1103.652128] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000=20
[ 1103.659272] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400=20
[ 1103.666411] PKRU: 55555554=20
[ 1103.669136] Call Trace:=20
[ 1103.671593]  <TASK>=20
[ 1103.673710]  ? lockdep_hardirqs_on+0x79/0x100=20
[ 1103.678088]  make_task_dead+0xb0/0xc0=20
[ 1103.681773]  rewind_stack_and_make_dead+0x17/0x20=20
[ 1103.686495] RIP: 0033:0x7f5198f3c92f=20
[ 1103.690090] Code: 08 89 3c 24 48 89 4c 24 18 e8 dd f2 f5 ff 4c 8b 54 24 =
18
48 8b 54 24 10 41 89 c0 48 8b 74 24 08 8b 3c 24 b8 11 00 00 00 0f 05 <48> 3=
d 00
f0 ff ff 77 31 44 89 c7 48 89 04 24 e8 2d f3 f5 ff 48 8b=20
[ 1103.708846] RSP: 002b:00007ffea5ebbe90 EFLAGS: 00000293 ORIG_RAX:
0000000000000011=20
[ 1103.716428] RAX: ffffffffffffffda RBX: 00007ffea5ebbf40 RCX:
00007f5198f3c92f=20
[ 1103.723570] RDX: 0000000000001000 RSI: 000000000172f000 RDI:
0000000000000003=20
[ 1103.730711] RBP: 0000000000000003 R08: 0000000000000000 R09:
0000000000000003=20
[ 1103.737853] R10: 0000000000028000 R11: 0000000000000293 R12:
0000000000000028=20
[ 1103.744998] R13: 0000000000078000 R14: 0000000000000000 R15:
0000000000028000=20
[ 1103.752147]  </TASK>=20
[ 1103.754354] irq event stamp: 10686=20
[ 1103.757768] hardirqs last  enabled at (10685): [<ffffffff99000d86>]
asm_sysvec_apic_timer_interrupt+0x16/0x20=20
[ 1103.767689] hardirqs last disabled at (10686): [<ffffffff96dbaded>]
console_emit_next_record.constprop.0+0x55d/0x740=20
[ 1103.778215] softirqs last  enabled at (10684): [<ffffffff99200625>]
__do_softirq+0x625/0x9b0=20
[ 1103.786663] softirqs last disabled at (10679): [<ffffffff96c2640c>]
__irq_exit_rcu+0x1fc/0x2a0=20
[ 1103.795280] ---[ end trace 0000000000000000 ]---

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
