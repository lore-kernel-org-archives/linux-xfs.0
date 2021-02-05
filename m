Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4036DC433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 18:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02BC664EE8
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 18:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbhBEQmZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Feb 2021 11:42:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233387AbhBEQjA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Feb 2021 11:39:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 93ACD64FCB
        for <linux-xfs@vger.kernel.org>; Fri,  5 Feb 2021 18:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612548887;
        bh=Z9yhw8DQg+gON8KMcnC2D9KE9mAHw0cmOHwYuGAZgLo=;
        h=From:To:Subject:Date:From;
        b=Az67nuhIUngfZirS7AENkx6/C3/ThbXLW9ut+28iArtxpyoP4l3v4tqO7plEIAxbQ
         hQVxBTGaHGBoXV8BBQfVnVxuOCPNNyYOvZyWnF6yZR8auQLCziin2VNa0TZuhR6oT8
         Bn3/Q6+up2GEMsI+1v3YpIyfm3Rm6xXeVkLaxywa4fLbt44EQxiEggRj8nuCIKxKnB
         LWg5Bmq9np2zbHVPRKrjh8KWH5Ke9kfNnatStbfQQT7YAD3R+NZfFWWfBWvtRpAusu
         XchDyur8Uf05tPbZ2WvS5VwLAaRaXfBSQb+uSoZKgD6SvtMxY8a0VSPVuEnrGtvePF
         /HhIG72OfRBoA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211577] New: [generic/475] WARNING: CPU: 1 PID: 11596 at
 fs/iomap/buffered-io.c:79 iomap_page_release+0x220/0x290
Date:   Fri, 05 Feb 2021 18:14:47 +0000
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
Message-ID: <bug-211577-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211577

            Bug ID: 211577
           Summary: [generic/475] WARNING: CPU: 1 PID: 11596 at
                    fs/iomap/buffered-io.c:79
                    iomap_page_release+0x220/0x290
           Product: File System
           Version: 2.5
    Kernel Version: linux 5.11.0-rc6+
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

xfstests generic/475 hit a kernel warning as below
# ./check generic/475
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/ppc64le ibm-p9z-xx-xxx 5.11.0-rc6+ #4 SMP Fri Feb 5
10:22:14 EST 2021
MKFS_OPTIONS  -- -f -m crc=3D1,finobt=3D1,rmapbt=3D1,reflink=3D1,inobtcount=
=3D1,bigtime=3D1
/dev/sda3
MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /dev/sda3
/mnt/xfstests/scratch

generic/475     _check_dmesg: something found in dmesg (see
/var/lib/xfstests/results//generic/475.dmesg)

Ran: generic/475
Failures: generic/475
Failed 1 of 1 tests

[ 1026.319574] XFS (dm-0): xfs_imap_lookup: xfs_ialloc_read_agi() returned
error -5, agno 2
[ 1026.319704] XFS (dm-0): xfs_do_force_shutdown(0x2) called from line 1196=
 of
file fs/xfs/xfs_log.c. Return address =3D c0080000019a801c
[ 1026.319715] XFS (dm-0): Log I/O Error Detected. Shutting down filesystem
[ 1026.319721] XFS (dm-0): Please unmount the filesystem and rectify the
problem(s)
[ 1026.320282] XFS (dm-0): xfs_imap_lookup: xfs_ialloc_read_agi() returned
error -5, agno 0
[ 1026.822032] ------------[ cut here ]------------
[ 1026.822053] WARNING: CPU: 1 PID: 11596 at fs/iomap/buffered-io.c:79
iomap_page_release+0x220/0x290
[ 1026.822069] Modules linked in: dm_mod bonding rfkill sunrpc uio_pdrv_gen=
irq
uio pseries_rng drm fuse drm_panel_orientation_quirks ip_tables xfs libcrc3=
2c
sd_mod t10_pi ibmvscsi ibmveth scs
i_transport_srp xts vmx_crypto
[ 1026.822151] CPU: 1 PID: 11596 Comm: umount Not tainted 5.11.0-rc6+ #4
[ 1026.822162] NIP:  c0000000006a0f20 LR: c0000000006a0df4 CTR:
c0000000006a1230
[ 1026.822172] REGS: c00000002b847590 TRAP: 0700   Not tainted  (5.11.0-rc6=
+)
[ 1026.822181] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR:
44004882  XER: 20040123
[ 1026.822231] CFAR: c0000000006a0e28 IRQMASK: 0
               GPR00: c000000000475028 c00000002b847830 c000000002127000
0000000000000010
               GPR04: 0000000000000000 0000000000000010 0000000000000000
ffffffffffffffff
               GPR08: ffffffffffff0000 0000000000000000 0000000000000000
0000000000000000
               GPR12: c0000000006a1230 c00000001ec9ee00 0000000000000000
00007fffe03f6b64
               GPR16: 000000000ee6b280 00007fffe03f6ad0 0000000000000000
0000000000000000
               GPR20: 0000000000000000 0000000000000000 0000000000000000
c0000000012c4a40
               GPR24: 0000000000000000 0000000000000001 ffffffffffffffff
c000000021aacf40
               GPR28: c00000002b847968 c00000000c027440 0000000000000001
c00c00000015c240
[ 1026.822390] NIP [c0000000006a0f20] iomap_page_release+0x220/0x290
[ 1026.822400] LR [c0000000006a0df4] iomap_page_release+0xf4/0x290
[ 1026.822410] Call Trace:
[ 1026.822416] [c00000002b847830] [c0000000006a1484]
iomap_invalidatepage+0x254/0x2c0 (unreliable)=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[ 1026.822434] [c00000002b847880] [c000000000475028]
truncate_cleanup_page+0xa8/0x1d0
[ 1026.822449] [c00000002b8478b0] [c000000000475e7c]
truncate_inode_pages_range+0x22c/0x9d0
[ 1026.822464] [c00000002b847ac0] [c0000000005e2818] evict+0x218/0x230
[ 1026.822478] [c00000002b847b00] [c0000000005e28c0] dispose_list+0x90/0xe0
[ 1026.822491] [c00000002b847b40] [c0000000005e2ab4] evict_inodes+0x1a4/0x2=
70
[ 1026.822504] [c00000002b847be0] [c0000000005b1af0]
generic_shutdown_super+0x70/0x170
[ 1026.822518] [c00000002b847c60] [c0000000005b1f08] kill_block_super+0x38/=
0xb0
[ 1026.822531] [c00000002b847c90] [c0000000005b3380]
deactivate_locked_super+0x80/0x140
[ 1026.822545] [c00000002b847cd0] [c0000000005ee64c] cleanup_mnt+0x15c/0x240
[ 1026.822559] [c00000002b847d20] [c00000000019a3a4] task_work_run+0xb4/0x1=
20
[ 1026.822573] [c00000002b847d70] [c000000000024ca4]
do_notify_resume+0x164/0x170
[ 1026.822588] [c00000002b847da0] [c00000000003b51c]
syscall_exit_prepare+0x24c/0x390
[ 1026.822603] [c00000002b847e10] [c00000000000d380]
system_call_vectored_common+0x100/0x26c
[ 1026.822617] Instruction dump:
[ 1026.822626] 4bf01109 60000000 2c3e0000 e8610028 4082fea0 4bdce3d5 600000=
00
4bfffe94
[ 1026.822658] 3869ffff 60000000 4bfffe50 60420000 <0fe00000> 4bffff08 6000=
0000
60420000
[ 1026.822690] irq event stamp: 4666
[ 1026.822697] hardirqs last  enabled at (4665): [<c000000000542b04>]
__slab_free+0x414/0x610
[ 1026.822709] hardirqs last disabled at (4666): [<c0000000000098f4>]
program_check_common_virt+0x304/0x360
[ 1026.822720] softirqs last  enabled at (4618): [<c00000000060889c>]
wb_queue_work+0x11c/0x300
[ 1026.822731] softirqs last disabled at (4614): [<c000000000608824>]
wb_queue_work+0xa4/0x300
[ 1026.822742] ---[ end trace 2285fc94a41146ef ]---

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
