Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48902C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Oct 2022 17:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiJIRry (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Oct 2022 13:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiJIRrw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Oct 2022 13:47:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD47325590
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 10:47:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BECC60B85
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 17:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC510C433B5
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 17:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665337669;
        bh=uW/e5vuph4YFHRhlIhH1yfI+VanQ/UP5mnIuVZaIUMM=;
        h=From:To:Subject:Date:From;
        b=pMrdwkvF3YOoTxZdlvBWfWIR12N74qf0SyJBjyBIyY04xvCgXT6QZEx7RirWQkbJb
         5rnpeFGnYPMZiS5+ZrtTuS9zfCKXsEhxKmqpLcuqFMuWi6esIwSEDumWLtA8BhdMI6
         ov0xcX/2J9ZYdouqnnbYb9AREhFA963HKXOrmcYqfzUz4wLGuPEmkKWszngpNWKLJ8
         +d7Fu7hSSJEWwZUg4S4UWyGX8H2MK4EFYlQWjJSx40xZKut3hr4OTGzrOsaZzirU9Y
         QRoH87Ksm0zS6pj+1NHM/Ue1JVlOgbbFWPyCQt4zIXETSL25EZDng0eyjO2En2c2+/
         UcnaxXBJ/vTOg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B9688C433E6; Sun,  9 Oct 2022 17:47:49 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216566] New: [xfstests generic/648] BUG: unable to handle page
 fault, RIP: 0010:__xfs_dir3_data_check+0x171/0x700 [xfs]
Date:   Sun, 09 Oct 2022 17:47:49 +0000
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
Message-ID: <bug-216566-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216566

            Bug ID: 216566
           Summary: [xfstests generic/648] BUG: unable to handle page
                    fault, RIP: 0010:__xfs_dir3_data_check+0x171/0x700
                    [xfs]
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

xfstests generic/648 hit kernel panic[1] on xfs with 64k directory block si=
ze
(-n size=3D65536), before panic, there's a kernel assertion (not sure if it=
's
related).

It's reproducable, but not easy. Generally I reproduced it by loop running
generic/648 on xfs (-n size=3D65536) hundreds of time.

The last time I hit this panic on linux with HEAD=3D

commit a6afa4199d3d038fbfdff5511f7523b0e30cb774
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Oct 8 10:30:44 2022 -0700

    Merge tag 'mailbox-v6.1' of
git://git.linaro.org/landing-teams/working/fujitsu/integration

[1]
[  397.108795] loop: Write error at byte offset 3952001024, length 4096.=20
[  397.130710] loop0: writeback error on inode 1494978, offset 1630208, sec=
tor
7718752=20
[  397.130778] XFS (loop0): log I/O error -5=20
[  397.131327] loop: Write error at byte offset 2651811840, length 4096.=20
[  397.138435] XFS (loop0): Filesystem has been shut down due to log error
(0x2).=20
[  397.142446] XFS (loop0): log I/O error -5=20
[  397.148884] XFS (loop0): Please unmount the filesystem and rectify the
problem(s).=20
[  397.173024] XFS (loop0): Unmounting Filesystem=20
[  395.005786] restraintd[7627]: *** Current Time: Sun Oct 09 10:29:31 2022=
=20
Localwatchdog at: Tue Oct 11 10:24:31 2022=20
[  398.203242] XFS (dm-0): Unmounting Filesystem=20
[  398.223779] XFS (dm-0): Mounting V5 Filesystem=20
[  398.364785] XFS (dm-0): Starting recovery (logdev: internal)=20
[  398.987258] XFS (dm-0): Ending recovery (logdev: internal)=20
[  399.000633] loop0: detected capacity change from 0 to 10346136=20
[  399.735192] XFS (loop0): Mounting V5 Filesystem=20
[  399.763005] XFS (loop0): Starting recovery (logdev: internal)=20
[  399.816308] XFS (loop0): Bad dir block magic!=20
[  399.820681] XFS: Assertion failed: 0, file: fs/xfs/xfs_buf_item_recover.=
c,
line: 414=20
[  399.828459] ------------[ cut here ]------------=20
[  399.833080] WARNING: CPU: 97 PID: 114754 at fs/xfs/xfs_message.c:104
assfail+0x2f/0x36 [xfs]=20
[  399.841633] Modules linked in: loop dm_mod rfkill intel_rapl_msr
intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common
ipmi_ssif i10nm_edac nfit x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm mlx5_ib mgag200 i2c_algo_bit drm_shmem_helper irqbypass sunrpc
ib_uverbs drm_kms_helper rapl dcdbas acpi_ipmi intel_cstate syscopyarea ipm=
i_si
ib_core mei_me dell_smbios sysfillrect i2c_i801 isst_if_mbox_pci isst_if_mm=
io
ipmi_devintf intel_uncore sysimgblt pcspkr wmi_bmof dell_wmi_descriptor
isst_if_common mei fb_sys_fops i2c_smbus intel_pch_thermal intel_vsec
ipmi_msghandler acpi_power_meter drm fuse xfs libcrc32c sd_mod t10_pi sg
mlx5_core ahci mlxfw libahci crct10dif_pclmul crc32_pclmul tls crc32c_intel
ghash_clmulni_intel libata psample megaraid_sas tg3 pci_hyperv_intf wmi=20
[  399.911998] CPU: 97 PID: 114754 Comm: mount Kdump: loaded Not tainted 6.=
0.0+
#1=20
[  399.919311] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4
12/17/2021=20
[  399.926794] RIP: 0010:assfail+0x2f/0x36 [xfs]=20
[  399.931239] Code: 49 89 d0 41 89 c9 48 c7 c2 60 3e cf c0 48 89 f1 48 89 =
fe
48 c7 c7 6c 5e ce c0 e8 3a fe ff ff 80 3d 4a 57 0b 00 00 74 02 0f 0b <0f> 0=
b c3
cc cc cc cc 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48=20
[  399.949991] RSP: 0018:ff7b3d2f8751b910 EFLAGS: 00010246=20
[  399.955219] RAX: 0000000000000000 RBX: ff44dbd80e68de00 RCX:
000000007fffffff=20
[  399.962359] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
ffffffffc0ce5e6c=20
[  399.969490] RBP: ff44dbd856214000 R08: 0000000000000000 R09:
000000000000000a=20
[  399.976625] R10: 000000000000000a R11: f000000000000000 R12:
000000050001ddb2=20
[  399.983758] R13: ff44dbd84122be00 R14: ff44dbd856214000 R15:
ff44dbd804bf5c00=20
[  399.990890] FS:  00007fcd7164b800(0000) GS:ff44dbe7bfa00000(0000)
knlGS:0000000000000000=20
[  399.998977] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[  400.004721] CR2: 000055f074d8a3f8 CR3: 00000010c699a005 CR4:
0000000000771ee0=20
[  400.011855] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000=20
[  400.018991] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400=20
[  400.026127] PKRU: 55555554=20
[  400.028841] Call Trace:=20
[  400.031297]  <TASK>=20
[  400.033409]  xlog_recover_validate_buf_type+0x17c/0x670 [xfs]=20
[  400.039235]  xlog_recover_buf_commit_pass2+0x349/0x430 [xfs]=20
[  400.044979]  xlog_recover_items_pass2+0x51/0xd0 [xfs]=20
[  400.050101]  xlog_recover_commit_trans+0x30f/0x360 [xfs]=20
[  400.055483]  xlog_recovery_process_trans+0xf1/0x110 [xfs]=20
[  400.060951]  xlog_recover_process_data+0x84/0x140 [xfs]=20
[  400.066248]  xlog_do_recovery_pass+0x24f/0x6a0 [xfs]=20
[  400.071282]  xlog_do_log_recovery+0x6b/0xc0 [xfs]=20
[  400.076056]  xlog_do_recover+0x33/0x1f0 [xfs]=20
[  400.080485]  xlog_recover+0xde/0x190 [xfs]=20
[  400.084646]  xfs_log_mount+0x19f/0x340 [xfs]=20
[  400.088988]  xfs_mountfs+0x44b/0x980 [xfs]=20
[  400.093159]  ? xfs_filestream_get_parent+0x90/0x90 [xfs]=20
[  400.098538]  xfs_fs_fill_super+0x4bc/0x900 [xfs]=20
[  400.103230]  ? xfs_open_devices+0x1f0/0x1f0 [xfs]=20
[  400.108011]  get_tree_bdev+0x16d/0x270=20
[  400.111772]  vfs_get_tree+0x22/0xc0=20
[  400.115265]  do_new_mount+0x17a/0x310=20
[  400.118941]  __x64_sys_mount+0x107/0x140=20
[  400.122875]  do_syscall_64+0x59/0x90=20
[  400.126461]  ? syscall_exit_work+0x103/0x130=20
[  400.130745]  ? syscall_exit_to_user_mode+0x12/0x30=20
[  400.135543]  ? do_syscall_64+0x69/0x90=20
[  400.139297]  ? do_syscall_64+0x69/0x90=20
[  400.143051]  ? syscall_exit_work+0x103/0x130=20
[  400.147331]  ? syscall_exit_to_user_mode+0x12/0x30=20
[  400.152123]  ? do_syscall_64+0x69/0x90=20
[  400.155878]  ? syscall_exit_work+0x103/0x130=20
[  400.160159]  ? syscall_exit_to_user_mode+0x12/0x30=20
[  400.164960]  ? do_syscall_64+0x69/0x90=20
[  400.168715]  ? syscall_exit_to_user_mode+0x12/0x30=20
[  400.173512]  ? do_syscall_64+0x69/0x90=20
[  400.177268]  ? syscall_exit_to_user_mode+0x12/0x30=20
[  400.182066]  ? do_syscall_64+0x69/0x90=20
[  400.185822]  entry_SYSCALL_64_after_hwframe+0x63/0xcd=20
[  400.190882] RIP: 0033:0x7fcd7143f7be=20
[  400.194463] Code: 48 8b 0d 65 a6 1b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 =
2e
0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3=
d 01
f0 ff ff 73 01 c3 48 8b 0d 32 a6 1b 00 f7 d8 64 89 01 48=20
[  400.213216] RSP: 002b:00007ffdf9207bd8 EFLAGS: 00000246 ORIG_RAX:
00000000000000a5=20
[  400.220791] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007fcd7143f7be=20
[  400.227924] RDX: 000055687c0def90 RSI: 000055687c0d9630 RDI:
000055687c0ddfe0=20
[  400.235065] RBP: 000055687c0d9400 R08: 0000000000000000 R09:
0000000000000001=20
[  400.242198] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000=20
[  400.249330] R13: 000055687c0def90 R14: 000055687c0ddfe0 R15:
000055687c0d9400=20
[  400.256462]  </TASK>=20
[  400.258654] ---[ end trace 0000000000000000 ]---=20
[  400.263417] XFS (loop0): _xfs_buf_ioapply: no buf ops on daddr 0x319a88 =
len
16=20
[  400.270640] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
................=20
[  400.278639] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
................=20
[  400.286640] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
................=20
[  400.294638] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
................=20
[  400.302639] 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
................=20
[  400.310639] 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
................=20
[  400.318636] 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
................=20
[  400.326636] 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
................=20
[  400.334639] CPU: 97 PID: 114754 Comm: mount Kdump: loaded Tainted: G=20=
=20=20=20=20=20=20
W          6.0.0+ #1=20
[  400.343419] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4
12/17/2021=20
[  400.350897] Call Trace:=20
[  400.353350]  <TASK>=20
[  400.355457]  dump_stack_lvl+0x34/0x48=20
[  400.359122]  _xfs_buf_ioapply+0x167/0x1b0 [xfs]=20
[  400.363727]  ? wake_up_q+0x90/0x90=20
[  400.367131]  __xfs_buf_submit+0x69/0x220 [xfs]=20
[  400.371637]  xfs_buf_delwri_submit_buffers+0xe3/0x230 [xfs]=20
[  400.377273]  xfs_buf_delwri_submit+0x36/0xc0 [xfs]=20
[  400.382124]  xlog_recover_process_ophdr+0xb7/0x150 [xfs]=20
[  400.387507]  xlog_recover_process_data+0x84/0x140 [xfs]=20
[  400.392801]  xlog_do_recovery_pass+0x24f/0x6a0 [xfs]=20
[  400.397840]  xlog_do_log_recovery+0x6b/0xc0 [xfs]=20
[  400.402614]  xlog_do_recover+0x33/0x1f0 [xfs]=20
[  400.407042]  xlog_recover+0xde/0x190 [xfs]=20
[  400.411211]  xfs_log_mount+0x19f/0x340 [xfs]=20
[  400.415553]  xfs_mountfs+0x44b/0x980 [xfs]=20
[  400.419720]  ? xfs_filestream_get_parent+0x90/0x90 [xfs]=20
[  400.425104]  xfs_fs_fill_super+0x4bc/0x900 [xfs]=20
[  400.429790]  ? xfs_open_devices+0x1f0/0x1f0 [xfs]=20
[  400.434556]  get_tree_bdev+0x16d/0x270=20
[  400.438310]  vfs_get_tree+0x22/0xc0=20
[  400.441804]  do_new_mount+0x17a/0x310=20
[  400.445470]  __x64_sys_mount+0x107/0x140=20
[  400.449395]  do_syscall_64+0x59/0x90=20
[  400.452973]  ? syscall_exit_work+0x103/0x130=20
[  400.457248]  ? syscall_exit_to_user_mode+0x12/0x30=20
[  400.462038]  ? do_syscall_64+0x69/0x90=20
[  400.465792]  ? do_syscall_64+0x69/0x90=20
[  400.469546]  ? syscall_exit_work+0x103/0x130=20
[  400.473817]  ? syscall_exit_to_user_mode+0x12/0x30=20
[  400.478610]  ? do_syscall_64+0x69/0x90=20
[  400.482363]  ? syscall_exit_work+0x103/0x130=20
[  400.486634]  ? syscall_exit_to_user_mode+0x12/0x30=20
[  400.491427]  ? do_syscall_64+0x69/0x90=20
[  400.495182]  ? syscall_exit_to_user_mode+0x12/0x30=20
[  400.499974]  ? do_syscall_64+0x69/0x90=20
[  400.503727]  ? syscall_exit_to_user_mode+0x12/0x30=20
[  400.508518]  ? do_syscall_64+0x69/0x90=20
[  400.512272]  entry_SYSCALL_64_after_hwframe+0x63/0xcd=20
[  400.517323] RIP: 0033:0x7fcd7143f7be=20
[  400.520904] Code: 48 8b 0d 65 a6 1b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 =
2e
0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3=
d 01
f0 ff ff 73 01 c3 48 8b 0d 32 a6 1b 00 f7 d8 64 89 01 48=20
[  400.539648] RSP: 002b:00007ffdf9207bd8 EFLAGS: 00000246 ORIG_RAX:
00000000000000a5=20
[  400.547215] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007fcd7143f7be=20
[  400.554349] RDX: 000055687c0def90 RSI: 000055687c0d9630 RDI:
000055687c0ddfe0=20
[  400.561482] RBP: 000055687c0d9400 R08: 0000000000000000 R09:
0000000000000001=20
[  400.568612] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000=20
[  400.575747] R13: 000055687c0def90 R14: 000055687c0ddfe0 R15:
000055687c0d9400=20
[  400.582881]  </TASK>=20
[  400.585095] BUG: unable to handle page fault for address: ff7b3d2f8f3eff=
f8=20
[  400.591971] #PF: supervisor read access in kernel mode=20
[  400.597109] #PF: error_code(0x0000) - not-present page=20
[  400.602248] PGD 100000067 P4D 1001b9067 PUD 1001ba067 PMD 139973067 PTE =
0=20
[  400.609034] Oops: 0000 [#1] PREEMPT SMP NOPTI=20
[  400.613395] CPU: 97 PID: 114754 Comm: mount Kdump: loaded Tainted: G=20=
=20=20=20=20=20=20
W          6.0.0+ #1=20
[  400.622174] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4
12/17/2021=20
[  400.629652] RIP: 0010:__xfs_dir3_data_check+0x171/0x700 [xfs]=20
[  400.635458] Code: c3 c0 e9 04 ff ff ff 3d 58 44 32 44 0f 84 55 ff ff ff =
48
c7 c0 c9 71 c3 c0 e9 ed fe ff ff 41 8b 45 00 4c 8d 54 05 f8 4c 29 f0 <41> 8=
b 12
48 83 e8 08 48 c1 e8 03 0f ca 39 c2 73 3f 89 d2 4c 89 d0=20
[  400.654206] RSP: 0018:ff7b3d2f8751b860 EFLAGS: 00010206=20
[  400.659430] RAX: 000000000000ffc0 RBX: ff44dbd80f84d980 RCX:
d14cad4d1bf69f29=20
[  400.666563] RDX: 0000000000000006 RSI: ff44dbd80f84d980 RDI:
0000000000000000=20
[  400.673697] RBP: ff7b3d2f8f3e0000 R08: ff7b3d2f8751b9f0 R09:
ff7b3d2f8751b9f0=20
[  400.680831] R10: ff7b3d2f8f3efff8 R11: 0000000000001000 R12:
ff44dbd856214000=20
[  400.687961] R13: ff44dbd807616c00 R14: 0000000000000040 R15:
ff44dbd80e68de70=20
[  400.695093] FS:  00007fcd7164b800(0000) GS:ff44dbe7bfa00000(0000)
knlGS:0000000000000000=20
[  400.703182] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[  400.708928] CR2: ff7b3d2f8f3efff8 CR3: 00000010c699a005 CR4:
0000000000771ee0=20
[  400.716060] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000=20
[  400.723191] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400=20
[  400.730324] PKRU: 55555554=20
[  400.733037] Call Trace:=20
[  400.735492]  <TASK>=20
[  400.737596]  xfs_dir3_block_write_verify+0x28/0x90 [xfs]=20
[  400.742971]  _xfs_buf_ioapply+0x4a/0x1b0 [xfs]=20
[  400.747485]  ? wake_up_q+0x90/0x90=20
[  400.750892]  __xfs_buf_submit+0x69/0x220 [xfs]=20
[  400.755397]  xfs_buf_delwri_submit_buffers+0xe3/0x230 [xfs]=20
[  400.761022]  xfs_buf_delwri_submit+0x36/0xc0 [xfs]=20
[  400.765876]  xlog_recover_process_ophdr+0xb7/0x150 [xfs]=20
[  400.771259]  xlog_recover_process_data+0x84/0x140 [xfs]=20
[  400.776554]  xlog_do_recovery_pass+0x24f/0x6a0 [xfs]=20
[  400.781589]  xlog_do_log_recovery+0x6b/0xc0 [xfs]=20
[  400.786356]  xlog_do_recover+0x33/0x1f0 [xfs]=20
[  400.790775]  xlog_recover+0xde/0x190 [xfs]=20
[  400.794936]  xfs_log_mount+0x19f/0x340 [xfs]=20
[  400.799278]  xfs_mountfs+0x44b/0x980 [xfs]=20
[  400.803445]  ? xfs_filestream_get_parent+0x90/0x90 [xfs]=20
[  400.808827]  xfs_fs_fill_super+0x4bc/0x900 [xfs]=20
[  400.813508]  ? xfs_open_devices+0x1f0/0x1f0 [xfs]=20
[  400.818274]  get_tree_bdev+0x16d/0x270=20
[  400.822028]  vfs_get_tree+0x22/0xc0=20
[  400.825519]  do_new_mount+0x17a/0x310=20
[  400.829186]  __x64_sys_mount+0x107/0x140=20
[  400.833112]  do_syscall_64+0x59/0x90=20
[  400.836690]  ? syscall_exit_work+0x103/0x130=20
[  400.840962]  ? syscall_exit_to_user_mode+0x12/0x30=20
[  400.845755]  ? do_syscall_64+0x69/0x90=20
[  400.849508]  ? do_syscall_64+0x69/0x90=20
[  400.853262]  ? syscall_exit_work+0x103/0x130=20
[  400.857533]  ? syscall_exit_to_user_mode+0x12/0x30=20
[  400.862327]  ? do_syscall_64+0x69/0x90=20
[  400.866078]  ? syscall_exit_work+0x103/0x130=20
[  400.870352]  ? syscall_exit_to_user_mode+0x12/0x30=20
[  400.875144]  ? do_syscall_64+0x69/0x90=20
[  400.878897]  ? syscall_exit_to_user_mode+0x12/0x30=20
[  400.883691]  ? do_syscall_64+0x69/0x90=20
[  400.887441]  ? syscall_exit_to_user_mode+0x12/0x30=20
[  400.892237]  ? do_syscall_64+0x69/0x90=20
[  400.895987]  entry_SYSCALL_64_after_hwframe+0x63/0xcd=20
[  400.901039] RIP: 0033:0x7fcd7143f7be=20
[  400.904619] Code: 48 8b 0d 65 a6 1b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 =
2e
0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3=
d 01
f0 ff ff 73 01 c3 48 8b 0d 32 a6 1b 00 f7 d8 64 89 01 48=20
[  400.923367] RSP: 002b:00007ffdf9207bd8 EFLAGS: 00000246 ORIG_RAX:
00000000000000a5=20
[  400.930931] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007fcd7143f7be=20
[  400.938063] RDX: 000055687c0def90 RSI: 000055687c0d9630 RDI:
000055687c0ddfe0=20
[  400.945196] RBP: 000055687c0d9400 R08: 0000000000000000 R09:
0000000000000001=20
[  400.952329] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000=20
[  400.959464] R13: 000055687c0def90 R14: 000055687c0ddfe0 R15:
000055687c0d9400=20
[  400.966594]  </TASK>=20
[  400.968789] Modules linked in: loop dm_mod rfkill intel_rapl_msr
intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common
ipmi_ssif i10nm_edac nfit x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm mlx5_ib mgag200 i2c_algo_bit drm_shmem_helper irqbypass sunrpc
ib_uverbs drm_kms_helper rapl dcdbas acpi_ipmi intel_cstate syscopyarea ipm=
i_si
ib_core mei_me dell_smbios sysfillrect i2c_i801 isst_if_mbox_pci isst_if_mm=
io
ipmi_devintf intel_uncore sysimgblt pcspkr wmi_bmof dell_wmi_descriptor
isst_if_common mei fb_sys_fops i2c_smbus intel_pch_thermal intel_vsec
ipmi_msghandler acpi_power_meter drm fuse xfs libcrc32c sd_mod t10_pi sg
mlx5_core ahci mlxfw libahci crct10dif_pclmul crc32_pclmul tls crc32c_intel
ghash_clmulni_intel libata psample megaraid_sas tg3 pci_hyperv_intf wmi=20
[  401.039126] CR2: ff7b3d2f8f3efff8

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
