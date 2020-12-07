Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F04F4C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5E2B23884
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgLGRPJ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 12:15:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbgLGRPI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Dec 2020 12:15:08 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 210535] New: [xfstests generic/466] XFS: Assertion failed:
 next_agino == irec->ir_startino + XFS_INODES_PER_CHUNK, file:
 fs/xfs/xfs_iwalk.c, line: 366
Date:   Mon, 07 Dec 2020 17:14:26 +0000
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
Message-ID: <bug-210535-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=210535

            Bug ID: 210535
           Summary: [xfstests generic/466] XFS: Assertion failed:
                    next_agino == irec->ir_startino +
                    XFS_INODES_PER_CHUNK, file: fs/xfs/xfs_iwalk.c, line:
                    366
           Product: File System
           Version: 2.5
    Kernel Version: xfs-linux xfs-5.10-fixes-7
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

Created attachment 294021
  --> https://bugzilla.kernel.org/attachment.cgi?id=294021&action=edit
generic-466.full

xfstests generic/466 hit below assertion failure on power9 ppc64le:

[16404.196161] XFS: Assertion failed: next_agino == irec->ir_startino +
XFS_INODES_PER_CHUNK, file: fs/xfs/xfs_iwalk.c, line: 366
[16404.196204] ------------[ cut here ]------------
[16404.196253] WARNING: CPU: 3 PID: 1865338 at fs/xfs/xfs_message.c:112
assfail+0x70/0xb0 [xfs]
[16404.196262] Modules linked in: dm_log_writes dm_thin_pool dm_persistent_data
dm_bio_prison dm_snapshot dm_bufio ext4 mbcache jbd2 loop dm_flakey dm_mod
bonding rfkill sunrpc pseries_rng xts uio_pdrv_genirq uio vmx_crypto ip_tables
xfs libcrc32c sd_mod t10_pi sg ibmvscsi ibmveth scsi_transport_srp [last
unloaded: scsi_debug]
[16404.196355] CPU: 3 PID: 1865338 Comm: xfs_scrub Tainted: G        W        
5.10.0-rc1 #1
[16404.196363] NIP:  c008000000497858 LR: c008000000497820 CTR:
c000000000929090
[16404.196370] REGS: c00000002c04b590 TRAP: 0700   Tainted: G        W         
(5.10.0-rc1)
[16404.196377] MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28002448 
XER: 00000003
[16404.196407] CFAR: c008000000497830 IRQMASK: 0 
               GPR00: c008000000497820 c00000002c04b820 c008000000579500
ffffffffffffffea 
               GPR04: 000000000000000a c00000002c04b720 c008000000557e50
0000000000000000 
               GPR08: ffffffffffffffc0 0000000000000000 0000000000000000
0000000000000000 
               GPR12: c000000000929090 c00000001ecaca80 00000100376b5338
00007fff837b0000 
               GPR16: 00007fff84244410 00007fff84244420 00007fffeaedabd0
00000100376b5330 
               GPR20: 0000000010019e90 c0000000b4caa380 c0000000b4caa390
0000000000000017 
               GPR24: c00000002c04b924 0000000000000000 0000000000000000
c0000004d1984000 
               GPR28: c00000002c04b928 c00000002c04b930 c00000002c04b9c0
0000000000000000 
[16404.196571] NIP [c008000000497858] assfail+0x70/0xb0 [xfs]
[16404.196618] LR [c008000000497820] assfail+0x38/0xb0 [xfs]
[16404.196625] Call Trace:
[16404.196670] [c00000002c04b820] [c008000000497820] assfail+0x38/0xb0 [xfs]
(unreliable)
[16404.196722] [c00000002c04b890] [c0080000004960cc]
xfs_iwalk_run_callbacks+0x1f4/0x240 [xfs]
[16404.196772] [c00000002c04b900] [c00800000049640c] xfs_iwalk_ag+0x2f4/0x420
[xfs]
[16404.196823] [c00000002c04b9a0] [c008000000496728] xfs_iwalk+0x150/0x2b0
[xfs]
[16404.196871] [c00000002c04bab0] [c008000000494e98] xfs_bulkstat+0x150/0x290
[xfs]
[16404.196919] [c00000002c04bb40] [c00800000047aed8]
xfs_ioc_bulkstat.isra.8+0xc0/0x160 [xfs]
[16404.196965] [c00000002c04bbe0] [c00800000047e5dc]
xfs_file_ioctl+0xd04/0x1148 [xfs]
[16404.196979] [c00000002c04bd70] [c000000000656bd8] sys_ioctl+0xf8/0x150
[16404.196989] [c00000002c04bdc0] [c00000000003e078]
system_call_exception+0x108/0x210
[16404.197000] [c00000002c04be20] [c00000000000d240]
system_call_common+0xf0/0x27c
[16404.197009] Instruction dump:
[16404.197018] 8be9000c 2b9f0001 409d0020 3c620000 e863dd08 7fe4fb78 38630010
48090d65 
[16404.197044] e8410018 60000000 73e90001 4082001c <0fe00000> 38210070 e8010010
ebe1fff8 
[16404.197071] CPU: 3 PID: 1865338 Comm: xfs_scrub Tainted: G        W        
5.10.0-rc1 #1
[16404.197078] Call Trace:
[16404.197085] [c00000002c04b330] [c00000000098e778] dump_stack+0xec/0x144
(unreliable)
[16404.197099] [c00000002c04b370] [c000000000187e0c] __warn+0xcc/0x14c
[16404.197109] [c00000002c04b400] [c00000000098d318] report_bug+0x108/0x1f0
[16404.197119] [c00000002c04b4a0] [c000000000030180]
program_check_exception+0x2c0/0x3f0
[16404.197129] [c00000002c04b520] [c000000000009664]
program_check_common_virt+0x2c4/0x310
[16404.197212] --- interrupt: 700 at assfail+0x70/0xb0 [xfs]
                   LR = assfail+0x38/0xb0 [xfs]
[16404.197257] [c00000002c04b890] [c0080000004960cc]
xfs_iwalk_run_callbacks+0x1f4/0x240 [xfs]
[16404.197304] [c00000002c04b900] [c00800000049640c] xfs_iwalk_ag+0x2f4/0x420
[xfs]
[16404.197352] [c00000002c04b9a0] [c008000000496728] xfs_iwalk+0x150/0x2b0
[xfs]
[16404.197400] [c00000002c04bab0] [c008000000494e98] xfs_bulkstat+0x150/0x290
[xfs]
[16404.197449] [c00000002c04bb40] [c00800000047aed8]
xfs_ioc_bulkstat.isra.8+0xc0/0x160 [xfs]
[16404.197498] [c00000002c04bbe0] [c00800000047e5dc]
xfs_file_ioctl+0xd04/0x1148 [xfs]
[16404.197509] [c00000002c04bd70] [c000000000656bd8] sys_ioctl+0xf8/0x150
[16404.197519] [c00000002c04bdc0] [c00000000003e078]
system_call_exception+0x108/0x210
[16404.197529] [c00000002c04be20] [c00000000000d240]
system_call_common+0xf0/0x27c
[16404.197539] irq event stamp: 72
[16404.197546] hardirqs last  enabled at (71): [<c000000000271134>]
console_unlock+0x794/0x960
[16404.197554] hardirqs last disabled at (72): [<c00000000000965c>]
program_check_common_virt+0x2bc/0x310
[16404.197563] softirqs last  enabled at (0): [<c0000000001844d0>]
copy_process+0x8c0/0x1ce0
[16404.197571] softirqs last disabled at (0): [<0000000000000000>] 0x0
[16404.197578] ---[ end trace 07ddd4c1a34360a2 ]---

I tested on xfs-linux for-next branch which HEAD is:
eb8409071a1d (HEAD -> for-next, tag: xfs-5.10-fixes-7, origin/xfs-5.10-fixes,
origin/for-next) xfs: revert "xfs: fix rmap key and record comparison
functions"

And looks like the disk of this power9 machine is 4k sector size. More details
refer to attachments.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
