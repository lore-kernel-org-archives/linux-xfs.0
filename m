Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F275C3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 09:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 732D82339E
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 09:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfH0J1n convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 05:27:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfH0J1m (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Aug 2019 05:27:42 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 204713] New: [xfstests generic/070] XFS: Assertion failed:
 ichdr.freemap[i].size < args->geo->blksize, file:
 fs/xfs/libxfs/xfs_attr_leaf.c, line: 2006
Date:   Tue, 27 Aug 2019 09:27:41 +0000
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
Message-ID: <bug-204713-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204713

            Bug ID: 204713
           Summary: [xfstests generic/070] XFS: Assertion failed:
                    ichdr.freemap[i].size < args->geo->blksize, file:
                    fs/xfs/libxfs/xfs_attr_leaf.c, line: 2006
           Product: File System
           Version: 2.5
    Kernel Version: xfs-linux xfs-5.3-fixes-6
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

Description of problem:
xfstests generic/070 fails on a ppc64le machine:

[ 5658.277125] run fstests generic/070 at 2019-08-26 07:20:45
[ 5659.360239] XFS: Assertion failed: ichdr.freemap[i].size <
args->geo->blksize, file: fs/xfs/libxfs/xfs_attr_leaf.c, line: 2006
[ 5659.360252] ------------[ cut here ]------------
[ 5659.360306] WARNING: CPU: 0 PID: 36209 at fs/xfs/xfs_message.c:93
asswarn+0x48/0x70 [xfs]
[ 5659.360311] Modules linked in: sg sunrpc pseries_rng xts vmx_crypto xfs
libcrc32c sd_mod ibmvscsi ibmveth scsi_transport_srp
[ 5659.360322] CPU: 0 PID: 36209 Comm: fsstress Not tainted 5.3.0-rc2+ #1
[ 5659.360326] NIP:  c0080000044365f0 LR: c0080000044365ec CTR:
0000000000655170
[ 5659.360330] REGS: c0000003cca17630 TRAP: 0700   Not tainted  (5.3.0-rc2+)
[ 5659.360333] MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28004288 
XER: 00000005
[ 5659.360341] CFAR: c00000000024ea54 IRQMASK: 0 
               GPR00: c0080000044365ec c0000003cca178c0 c008000004530e00
0000000000000024 
               GPR04: c000000002209ed8 c00000000024b2b0 0000000000000000
0000000000000000 
               GPR08: 0000000000000007 0000000000000000 c00000030f37a500
800000280aae2190 
               GPR12: 0000000000004400 c000000003280000 ffffffffffffffff
ffffffffffffffff 
               GPR16: 3ffffffc335e869e 00000000000000d0 3ffffffc335e86a0
000000000000fff8 
               GPR20: 0000000000000208 000000000000001a c000000003280000
c00000039879a080 
               GPR24: c000000398406c00 c0000003cca17964 0000000000000018
c00000039879a000 
               GPR28: 0000000000001000 c0000003cca17ab8 c0000003cca1797a
0000000000000000 
[ 5659.360399] NIP [c0080000044365f0] asswarn+0x48/0x70 [xfs]
[ 5659.360425] LR [c0080000044365ec] asswarn+0x44/0x70 [xfs]
[ 5659.360429] Call Trace:
[ 5659.360455] [c0000003cca178c0] [c0080000044365ec] asswarn+0x44/0x70 [xfs]
(unreliable)
[ 5659.360477] [c0000003cca17920] [c00800000436243c]
xfs_attr3_leaf_remove+0x9f4/0x1660 [xfs]
[ 5659.360499] [c0000003cca17a20] [c008000004359960]
xfs_attr_node_removename+0x158/0x610 [xfs]
[ 5659.360521] [c0000003cca17a90] [c00800000435ad78]
xfs_attr_remove+0x230/0x3e0 [xfs]
[ 5659.360549] [c0000003cca17b90] [c00800000444e2ac] xfs_xattr_set+0xf4/0x130
[xfs]
[ 5659.360556] [c0000003cca17bd0] [c0000000005f74ec]
__vfs_removexattr+0x7c/0xd0
[ 5659.360561] [c0000003cca17c10] [c0000000005f7c34] vfs_removexattr+0xa4/0x170
[ 5659.360566] [c0000003cca17c60] [c0000000005f7d68] removexattr+0x68/0xa0
[ 5659.360570] [c0000003cca17da0] [c0000000005f7eac]
path_removexattr+0x10c/0x130
[ 5659.360575] [c0000003cca17e00] [c0000000005f7f34] sys_lremovexattr+0x24/0x40
[ 5659.360580] [c0000003cca17e20] [c00000000000b588] system_call+0x5c/0x70
[ 5659.360584] Instruction dump:
[ 5659.360587] 3c820000 e884d308 7ca72b78 7c651b78 38600000 f8010010 f821ffa1
4bfffbb5 
[ 5659.360594] 3c620000 e863d310 48066a21 e8410018 <0fe00000> 38210060 e8010010
7c0803a6 
[ 5659.360601] irq event stamp: 0
[ 5659.360605] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[ 5659.360610] hardirqs last disabled at (0): [<c0000000001634c0>]
copy_process+0x780/0x1e90
[ 5659.360615] softirqs last  enabled at (0): [<c0000000001634c0>]
copy_process+0x780/0x1e90
[ 5659.360619] softirqs last disabled at (0): [<0000000000000000>] 0x0
[ 5659.360622] ---[ end trace 51f396007293d782 ]---
[ 5665.982812] XFS (sda3): Unmounting Filesystem
[ 5666.565548] XFS (sda3): Mounting V5 Filesystem
[ 5666.605099] XFS (sda3): Ending clean mount

Version-Release number of selected component (if applicable):
xfs-5.3-fixes-6

How reproducible:
once on ppc64le

Steps to Reproduce:
loop run generic/070

Actual results:
as above

Expected results:
test pass

Additional info:

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
