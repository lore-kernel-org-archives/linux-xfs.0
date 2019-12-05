Return-Path: <SRS0=6LQP=Z3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=MAILING_LIST_MULTI,PDS_BTC_ID,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC974C43603
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 06:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93A0522525
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 06:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbfLEGMG convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 01:12:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbfLEGMF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Dec 2019 01:12:05 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 205465] [xfstests generic/475]: general protection fault: 0000
 [#1] SMP KASAN PTI,  RIP: 0010:iter_file_splice_write+0x63f/0xa90
Date:   Thu, 05 Dec 2019 06:12:03 +0000
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
Message-ID: <bug-205465-201763-BDPf1dzk8w@https.bugzilla.kernel.org/>
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

--- Comment #3 from Zorro Lang (zlang@redhat.com) ---
(In reply to Darrick J. Wong from comment #2)
> Could you please post the source line translations of the relevant
> functions?  I don't have your kernel build.

I already removed this testing kernel build, and merged lots of new patches.
But good news is I still can reproduce this issue[1] (by g/461 this time). I'll
build the new kernel and post the source line translations of the relevant
functions later.


[ 4693.175856] run fstests generic/461 at 2019-12-04 21:46:00 
[ 4693.694096] XFS (sda5): Mounting V5 Filesystem 
[ 4693.703963] XFS (sda5): Ending clean mount 
[ 4693.710992] xfs filesystem being mounted at /mnt/xfstests/mnt2 supports
timestamps until 2038 (0x7fffffff) 
[ 4693.726744] XFS (sda5): User initiated shutdown received. Shutting down
filesystem 
[ 4693.740549] XFS (sda5): Unmounting Filesystem 
[ 4693.895876] XFS (sda5): Mounting V5 Filesystem 
[ 4693.905492] XFS (sda5): Ending clean mount 
[ 4693.912655] xfs filesystem being mounted at /mnt/xfstests/mnt2 supports
timestamps until 2038 (0x7fffffff) 
[ 4702.015718] restraintd[1391]: *** Current Time: Wed Dec 04 21:46:11 2019
Localwatchdog at: Fri Dec 06 20:32:11 2019 
[ 4708.950866] XFS (sda5): User initiated shutdown received. Shutting down
filesystem 
[ 4708.972833] kasan: CONFIG_KASAN_INLINE enabled 
[ 4708.977801] kasan: GPF could be caused by NULL-ptr deref or user memory
access 
[ 4708.985889] general protection fault: 0000 [#1] SMP KASAN PTI 
[ 4708.992294] CPU: 0 PID: 19412 Comm: fsstress Not tainted 5.4.0+ #1 
[ 4708.999190] Hardware name: Dell Inc. PowerEdge R630/0CNCJW, BIOS 1.2.10
03/09/2015 
[ 4709.007655] RIP: 0010:iter_file_splice_write+0x668/0xa00 
[ 4709.013584] Code: 00 00 48 89 fa 48 c1 ea 03 80 3c 1a 00 0f 85 97 02 00 00
48 8b 56 10 48 c7 46 10 00 00 00 00 48 8d 7a 08 49 89 f8 49 c1 e8 03 <41> 80 3c
18 00 0f 85 96 02 00 00 48 8b 52 08 4c 89 e7 41 83 c6 01 
[ 4709.034540] RSP: 0018:ffff8887ca8bf8d8 EFLAGS: 00010202 
[ 4709.040373] RAX: 0000000000000000 RBX: dffffc0000000000 RCX:
ffffffff93c2f280 
[ 4709.048336] RDX: 0000000000000000 RSI: ffff8887fcd05000 RDI:
0000000000000008 
[ 4709.056299] RBP: ffffed1102ae1ca7 R08: 0000000000000001 R09:
fffff94000397e8f 
[ 4709.064262] R10: fffff94000397e8e R11: ffffea0001cbf477 R12:
ffff88881570e400 
[ 4709.072225] R13: 0000000000003000 R14: 0000000000000010 R15:
ffffed1102ae1c9f 
[ 4709.080188] FS:  00007f89493b6b80(0000) GS:ffff888827a00000(0000)
knlGS:0000000000000000 
[ 4709.089217] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[ 4709.095628] CR2: 00007f89493b5000 CR3: 00000007ce162004 CR4:
00000000001606f0 
[ 4709.103590] Call Trace: 
[ 4709.106327]  ? __x64_sys_tee+0x220/0x220 
[ 4709.110704]  ? generic_file_splice_read+0x4f5/0x6c0 
[ 4709.116148]  ? add_to_pipe+0x370/0x370 
[ 4709.120330]  ? _cond_resched+0x15/0x30 
[ 4709.124518]  direct_splice_actor+0x107/0x1d0 
[ 4709.129284]  splice_direct_to_actor+0x32d/0x8a0 
[ 4709.134342]  ? wakeup_pipe_readers+0x80/0x80 
[ 4709.139099]  ? do_splice_to+0x140/0x140 
[ 4709.143381]  ? security_file_permission+0x53/0x2b0 
[ 4709.148738]  do_splice_direct+0x158/0x250 
[ 4709.153212]  ? splice_direct_to_actor+0x8a0/0x8a0 
[ 4709.158464]  ? __sb_start_write+0x1c4/0x310 
[ 4709.163125]  vfs_copy_file_range+0x39c/0xa40 
[ 4709.167890]  ? __x64_sys_sendfile+0x1d0/0x1d0 
[ 4709.172753]  ? lockdep_hardirqs_on+0x590/0x590 
[ 4709.177706]  ? lock_downgrade+0x6d0/0x6d0 
[ 4709.182180]  ? lock_acquire+0x15a/0x3d0 
[ 4709.186459]  ? __might_fault+0xc4/0x1a0 
[ 4709.190754]  __x64_sys_copy_file_range+0x1e8/0x460 
[ 4709.196101]  ? __ia32_sys_copy_file_range+0x460/0x460 
[ 4709.201749]  ? __audit_syscall_exit+0x796/0xab0 
[ 4709.206810]  do_syscall_64+0x9f/0x4f0 
[ 4709.210897]  entry_SYSCALL_64_after_hwframe+0x49/0xbe 
[ 4709.216534] RIP: 0033:0x7f89488a96fd 
[ 4709.220523] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89
f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 5b 57 2c 00 f7 d8 64 89 01 48 
[ 4709.241479] RSP: 002b:00007fff83524e98 EFLAGS: 00000246 ORIG_RAX:
0000000000000146 
[ 4709.249928] RAX: ffffffffffffffda RBX: 00007fff83524ee8 RCX:
00007f89488a96fd 
[ 4709.257891] RDX: 0000000000000004 RSI: 00007fff83524ee0 RDI:
0000000000000003 
[ 4709.265854] RBP: 0000000000010fcc R08: 0000000000010fcc R09:
0000000000000000 
[ 4709.273817] R10: 00007fff83524ee8 R11: 0000000000000246 R12:
00007fff83524ee0 
[ 4709.281779] R13: 0000000000000003 R14: 0000000000000004 R15:
0000000000214da7 
[ 4709.289746] Modules linked in: intel_rapl_msr intel_rapl_common iTCO_wdt
iTCO_vendor_support sb_edac x86_pkg_temp_thermal intel_powerclamp dcdbas
coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel intel_cstate intel_uncore intel_rapl_perf dax_pmem_compat
device_dax nd_pmem dax_pmem_core pcspkr mei_me ipmi_ssif mei lpc_ich sg ipmi_si
ipmi_devintf ipmi_msghandler rfkill sunrpc acpi_power_meter ip_tables xfs
libcrc32c sd_mod mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt
fb_sys_fops drm_vram_helper lpfc drm_ttm_helper ttm nvmet_fc nvmet drm nvme_fc
crc32c_intel nvme_fabrics ahci igb libahci nvme_core libata scsi_transport_fc
megaraid_sas dca i2c_algo_bit wmi 
[ 4709.358683] ---[ end trace 2d7c5824fba18cef ]--- 
[ 4709.432470] RIP: 0010:iter_file_splice_write+0x668/0xa00 
[ 4709.438415] Code: 00 00 48 89 fa 48 c1 ea 03 80 3c 1a 00 0f 85 97 02 00 00
48 8b 56 10 48 c7 46 10 00 00 00 00 48 8d 7a 08 49 89 f8 49 c1 e8 03 <41> 80 3c
18 00 0f 85 96 02 00 00 48 8b 52 08 4c 89 e7 41 83 c6 01 
[ 4709.459386] RSP: 0018:ffff8887ca8bf8d8 EFLAGS: 00010202 
[ 4709.465230] RAX: 0000000000000000 RBX: dffffc0000000000 RCX:
ffffffff93c2f280 
[ 4709.473196] RDX: 0000000000000000 RSI: ffff8887fcd05000 RDI:
0000000000000008 
[ 4709.481161] RBP: ffffed1102ae1ca7 R08: 0000000000000001 R09:
fffff94000397e8f 
[ 4709.489138] R10: fffff94000397e8e R11: ffffea0001cbf477 R12:
ffff88881570e400 
[ 4709.497112] R13: 0000000000003000 R14: 0000000000000010 R15:
ffffed1102ae1c9f 
[ 4709.505079] FS:  00007f89493b6b80(0000) GS:ffff888827a00000(0000)
knlGS:0000000000000000 
[ 4709.514110] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[ 4709.520534] CR2: 00007f89493b5000 CR3: 00000007ce162004 CR4:
00000000001606f0 
[ 4715.584506] XFS (sda5): Unmounting Filesystem

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
