Return-Path: <SRS0=ClpI=2V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1533CC2D0C8
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Dec 2019 03:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D35E3206CB
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Dec 2019 03:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbfLaDk4 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Dec 2019 22:40:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbfLaDk4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Dec 2019 22:40:56 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 205465] [xfstests generic/475]: general protection fault: 0000
 [#1] SMP KASAN PTI,  RIP: 0010:iter_file_splice_write+0x63f/0xa90
Date:   Tue, 31 Dec 2019 03:40:54 +0000
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
Message-ID: <bug-205465-201763-3NqVyQ44sY@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205465-201763@https.bugzilla.kernel.org/>
References: <bug-205465-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205465

--- Comment #5 from Zorro Lang (zlang@redhat.com) ---
Hit this issue again on upstream mainline kernel 5.5.0-rc4, the HEAD commit is:
commit fd6988496e79a6a4bdb514a4655d2920209eb85d
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Dec 29 15:29:16 2019 -0800

    Linux 5.5-rc4


[31287.078801] kasan: CONFIG_KASAN_INLINE enabled 
[31287.141302] kasan: GPF could be caused by NULL-ptr deref or user memory
access 
[31287.175211] general protection fault: 0000 [#1] SMP KASAN PTI 
[31287.202065] CPU: 18 PID: 14354 Comm: fsstress Not tainted 5.5.0-rc4+ #1 
[31287.231860] Hardware name: HP ProLiant XL190r Gen9/ProLiant XL190r Gen9,
BIOS U14 05/22/2018 
[31287.270854] RIP: 0010:iter_file_splice_write+0x65f/0xa10 
[31287.296139] Code: 00 00 48 89 fa 48 c1 ea 03 80 3c 1a 00 0f 85 e8 02 00 00
48 8b 56 10 48 c7 46 10 00 00 00 00 48 8d 7a 08 48 89 f9 48 c1 e9 03 <80> 3c 19
00 0f 85 80 02 00 00 48 8b 52 08 4c 89 ff 41 83 c5 01 e8 
[31287.384468] RSP: 0018:ffff888074e778e0 EFLAGS: 00010202 
[31287.409475] RAX: 0000000000000000 RBX: dffffc0000000000 RCX:
0000000000000001 
[31287.442886] RDX: 0000000000000000 RSI: ffff888045ddc000 RDI:
0000000000000008 
[31287.475859] RBP: ffffed100909fa27 R08: fffff9400014fa97 R09:
fffff9400014fa97 
[31287.509173] R10: fffff9400014fa96 R11: ffffea0000a7d4b7 R12:
000000000000d38a 
[31287.543272] R13: 0000000000000010 R14: ffffed100909fa1f R15:
ffff8880484fd000 
[31287.577414] FS:  00007fa75d7f2b80(0000) GS:ffff888114200000(0000)
knlGS:0000000000000000 
[31287.616719] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[31287.645465] CR2: 00007ffb22049978 CR3: 000000010055c006 CR4:
00000000001606e0 
[31287.681499] Call Trace: 
[31287.693418]  ? __x64_sys_tee+0x220/0x220 
[31287.712293]  ? generic_file_splice_read+0x4f5/0x6c0 
[31287.735384]  ? add_to_pipe+0x370/0x370 
[31287.753082]  ? _cond_resched+0x15/0x30 
[31287.770530]  direct_splice_actor+0x107/0x1d0 
[31287.790652]  splice_direct_to_actor+0x32d/0x8a0 
[31287.812108]  ? wakeup_pipe_readers+0x80/0x80 
[31287.831962]  ? do_splice_to+0x140/0x140 
[31287.849955]  ? security_file_permission+0x53/0x2b0 
[31287.872161]  do_splice_direct+0x158/0x250 
[31287.890904]  ? splice_direct_to_actor+0x8a0/0x8a0 
[31287.912841]  ? __sb_start_write+0x1c4/0x310 
[31287.932673]  vfs_copy_file_range+0x39c/0xa40 
[31287.952671]  ? __x64_sys_sendfile+0x1d0/0x1d0 
[31287.972959]  ? lockdep_hardirqs_on+0x590/0x590 
[31287.993801]  ? lock_downgrade+0x6d0/0x6d0 
[31288.012379]  ? lock_acquire+0x15a/0x3d0 
[31288.030130]  ? __might_fault+0xc4/0x1a0 
[31288.048482]  __x64_sys_copy_file_range+0x1e8/0x460 
[31288.070780]  ? __ia32_sys_copy_file_range+0x460/0x460 
[31288.094431]  ? __audit_syscall_exit+0x796/0xab0 
[31288.115526]  do_syscall_64+0x9f/0x4f0 
[31288.133481]  entry_SYSCALL_64_after_hwframe+0x49/0xbe 
[31288.160230] RIP: 0033:0x7fa75cce36ed 
[31288.178391] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89
f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 6b 57 2c 00 f7 d8 64 89 01 48 
[31288.266254] RSP: 002b:00007ffe44247728 EFLAGS: 00000246 ORIG_RAX:
0000000000000146 
[31288.302144] RAX: ffffffffffffffda RBX: 000000000000037d RCX:
00007fa75cce36ed 
[31288.335625] RDX: 0000000000000004 RSI: 00007ffe44247760 RDI:
0000000000000003 
[31288.368948] RBP: 00000000006ec600 R08: 000000000001092c R09:
0000000000000000 
[31288.402554] R10: 00007ffe44247768 R11: 0000000000000246 R12:
0000000000000003 
[31288.435810] R13: 000000000001092c R14: 0000000000027b80 R15:
00000000001037f6 
[31288.469094] Modules linked in: loop intel_rapl_msr iTCO_wdt
intel_rapl_common iTCO_vendor_support sb_edac x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel intel_cstate intel_uncore intel_rapl_perf pcspkr nd_pmem
dax_pmem_compat device_dax dax_pmem_core rfkill i2c_i801 lpc_ich hpilo hpwdt
sunrpc ipmi_ssif ioatdma ipmi_si acpi_tad ipmi_devintf ipmi_msghandler
acpi_power_meter ext4 mbcache jbd2 ip_tables xfs libcrc32c sd_mod sg mgag200
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm_vram_helper
drm_ttm_helper ttm drm ahci igb serio_raw crc32c_intel libahci libata tg3 dca
i2c_algo_bit wmi 
[31288.752336] ---[ end trace 568a174fdf5e3acb ]--- 
[31288.782986] RIP: 0010:iter_file_splice_write+0x65f/0xa10 
[31288.807838] Code: 00 00 48 89 fa 48 c1 ea 03 80 3c 1a 00 0f 85 e8 02 00 00
48 8b 56 10 48 c7 46 10 00 00 00 00 48 8d 7a 08 48 89 f9 48 c1 e9 03 <80> 3c 19
00 0f 85 80 02 00 00 48 8b 52 08 4c 89 ff 41 83 c5 01 e8 
[31288.895645] RSP: 0018:ffff888074e778e0 EFLAGS: 00010202 
[31288.920068] RAX: 0000000000000000 RBX: dffffc0000000000 RCX:
0000000000000001 
[31288.953407] RDX: 0000000000000000 RSI: ffff888045ddc000 RDI:
0000000000000008 
[31288.986935] RBP: ffffed100909fa27 R08: fffff9400014fa97 R09:
fffff9400014fa97 
[31289.019794] R10: fffff9400014fa96 R11: ffffea0000a7d4b7 R12:
000000000000d38a 
[31289.052915] R13: 0000000000000010 R14: ffffed100909fa1f R15:
ffff8880484fd000 
[31289.086764] FS:  00007fa75d7f2b80(0000) GS:ffff888114200000(0000)
knlGS:0000000000000000 
[31289.124620] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[31289.151387] CR2: 00007ffb22049978 CR3: 000000010055c006 CR4:
00000000001606e0 
[31301.358103] XFS (sdb2): Unmounting Filesystem 
[31301.706524] XFS (sdb2): Mounting V5 Filesystem

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
