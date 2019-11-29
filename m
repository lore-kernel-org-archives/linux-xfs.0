Return-Path: <SRS0=kniB=ZV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF2B5C432C0
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Nov 2019 11:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F284208E4
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Nov 2019 11:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfK2Lgx convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Nov 2019 06:36:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbfK2Lgw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 29 Nov 2019 06:36:52 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 205465] [xfstests generic/475]: general protection fault: 0000
 [#1] SMP KASAN PTI,  RIP: 0010:iter_file_splice_write+0x63f/0xa90
Date:   Fri, 29 Nov 2019 11:36:51 +0000
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
Message-ID: <bug-205465-201763-xkiC6ZQvNs@https.bugzilla.kernel.org/>
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

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
Hit this panic again on mainline linux v5.4 (HEAD=c2da5bdc66a3) with
xfs-linux(xfs-5.5-merge-15 + iomap-5.5-merge-11 + vfs-5.5-merge-1):

[14842.571874] kasan: CONFIG_KASAN_INLINE enabled 
[14842.576866] kasan: GPF could be caused by NULL-ptr deref or user memory
access 
[14842.584962] general protection fault: 0000 [#1] SMP KASAN PTI 
[14842.591387] CPU: 30 PID: 12775 Comm: fsstress Tainted: G    B            
5.4.0+ #1 
[14842.599938] Hardware name: Dell Inc. PowerEdge R730/0599V5, BIOS 2.8.0
005/17/2018 
[14842.608403] RIP: 0010:iter_file_splice_write+0x63f/0xa90 
[14842.614341] Code: 00 00 48 89 f8 48 c1 e8 03 80 3c 18 00 0f 85 61 03 00 00
48 8b 46 10 48 c7 46 10 00 00 00 00 48 8d 78 08 48 89 fa 48 c1 ea 03 <80> 3c 1a
00 0f 85 52 03 00 00 48 8b 40 08 48 89 ef e8 5b 2e 7d 01 
[14842.635305] RSP: 0018:ffff888b9935fc68 EFLAGS: 00010202 
[14842.641142] RAX: 0000000000000000 RBX: dffffc0000000000 RCX:
0000000000000010 
[14842.649110] RDX: 0000000000000001 RSI: ffff888bb0d53208 RDI:
0000000000000008 
[14842.657069] RBP: ffff888b713fb400 R08: fffff94005b3058f R09:
fffff94005b3058f 
[14842.665038] R10: fffff94005b3058e R11: ffffea002d982c77 R12:
ffffed116e27f6a7 
[14842.673005] R13: ffffed116e27f69f R14: 000000000002ff84 R15:
ffff888b713fb4fc 
[14842.680969] FS:  00007fcaa5972b80(0000) GS:ffff888115c00000(0000)
knlGS:0000000000000000 
[14842.690006] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[14842.696424] CR2: 000055a30542b000 CR3: 0000000b9fc8e005 CR4:
00000000001606e0 
[14842.704393] Call Trace: 
[14842.707147]  ? __x64_sys_tee+0x220/0x220 
[14842.711535]  ? lock_acquire+0x15a/0x3d0 
[14842.715820]  ? do_splice+0xb37/0x1110 
[14842.719919]  ? __sb_start_write+0x191/0x310 
[14842.724592]  ? __sb_start_write+0x1c4/0x310 
[14842.729273]  do_splice+0xa12/0x1110 
[14842.733175]  ? opipe_prep+0x300/0x300 
[14842.737267]  ? syscall_slow_exit_work+0x540/0x540 
[14842.742523]  ? __audit_syscall_exit+0x796/0xab0 
[14842.747592]  __x64_sys_splice+0x247/0x2d0 
[14842.752080]  do_syscall_64+0x9f/0x4f0 
[14842.756177]  entry_SYSCALL_64_after_hwframe+0x49/0xbe 
[14842.761817] RIP: 0033:0x7fcaa4e6b39b 
[14842.765810] Code: c7 c0 ff ff ff ff eb b6 0f 1f 80 00 00 00 00 f3 0f 1e fa
48 8d 05 c5 52 2c 00 49 89 ca 8b 00 85 c0 75 14 b8 13 01 00 00 0f 05 <48> 3d 00
f0 ff ff 77 75 c3 0f 1f 40 00 41 57 4d 89 c7 41 56 49 89 
[14842.786771] RSP: 002b:00007fffbae7c5f8 EFLAGS: 00000246 ORIG_RAX:
0000000000000113 
[14842.795227] RAX: ffffffffffffffda RBX: 0000000000000004 RCX:
00007fcaa4e6b39b 
[14842.803196] RDX: 0000000000000004 RSI: 0000000000000000 RDI:
0000000000000005 
[14842.811162] RBP: 00007fffbae7c648 R08: 000000000000cb23 R09:
0000000000000000 
[14842.819133] R10: 00007fffbae7c648 R11: 0000000000000246 R12:
000000000000cb23 
[14842.827104] R13: 000000000000cb23 R14: 000000000000cb23 R15:
0000000000000003 
[14842.835082] Modules linked in: dm_mod intel_rapl_msr iTCO_wdt
iTCO_vendor_support dcdbas intel_rapl_common sb_edac x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel intel_cstate intel_uncore intel_rapl_perf pcspkr
dax_pmem_compat device_dax nd_pmem dax_pmem_core mxm_wmi cdc_ether lpc_ich
usbnet mii mei_me mei ipmi_ssif sg ioatdma dca ipmi_si ipmi_devintf
ipmi_msghandler acpi_power_meter sunrpc vfat fat ip_tables xfs sr_mod cdrom
sd_mod mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops
i2c_algo_bit drm_vram_helper ttm drm ahci bnx2x libahci libata mdio
megaraid_sas libcrc32c tg3 crc32c_intel wmi 
[14842.902703] ---[ end trace dfcbf13626b906e6 ]--- 
[14843.053619] RIP: 0010:iter_file_splice_write+0x63f/0xa90 
[14843.059564] Code: 00 00 48 89 f8 48 c1 e8 03 80 3c 18 00 0f 85 61 03 00 00
48 8b 46 10 48 c7 46 10 00 00 00 00 48 8d 78 08 48 89 fa 48 c1 ea 03 <80> 3c 1a
00 0f 85 52 03 00 00 48 8b 40 08 48 89 ef e8 5b 2e 7d 01 
[14843.080528] RSP: 0018:ffff888b9935fc68 EFLAGS: 00010202 
[14843.086372] RAX: 0000000000000000 RBX: dffffc0000000000 RCX:
0000000000000010 
[14843.094348] RDX: 0000000000000001 RSI: ffff888bb0d53208 RDI:
0000000000000008 
[14843.102322] RBP: ffff888b713fb400 R08: fffff94005b3058f R09:
fffff94005b3058f 
[14843.110297] R10: fffff94005b3058e R11: ffffea002d982c77 R12:
ffffed116e27f6a7 
[14843.118262] R13: ffffed116e27f69f R14: 000000000002ff84 R15:
ffff888b713fb4fc 
[14843.126237] FS:  00007fcaa5972b80(0000) GS:ffff888115c00000(0000)
knlGS:0000000000000000 
[14843.135270] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[14843.141693] CR2: 000055a30542b000 CR3: 0000000b9fc8e005 CR4:
00000000001606e0

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
