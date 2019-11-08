Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF651C5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 06:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B226D21D7E
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 06:51:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725372AbfKHGvn convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 01:51:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726987AbfKHGvn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Nov 2019 01:51:43 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 205467] New: [xfstests generic/475]: XFS: Assertion failed:
 ip->i_d.di_format != XFS_DINODE_FMT_BTREE || ip->i_d.di_nextents >
 XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK), file: fs/xfs/xfs_inode.c, line: 3652
Date:   Fri, 08 Nov 2019 06:51:41 +0000
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
Message-ID: <bug-205467-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205467

            Bug ID: 205467
           Summary: [xfstests generic/475]: XFS: Assertion failed:
                    ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
                    ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip,
                    XFS_DATA_FORK), file: fs/xfs/xfs_inode.c, line: 3652
           Product: File System
           Version: 2.5
    Kernel Version: xfs-linux 5.4.0-rc3+ + xfs-5.5-merge-6 +
                    iomap-5.5-merge-6
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

generic/475 hit a Assertion failure on ppc64le with 512 block size XFS:
[28642.164378] XFS: Assertion failed: ip->i_d.di_format != XFS_DINODE_FMT_BTREE
|| ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK), file:
fs/xfs/xfs_inode.c, line: 3652 
[28642.164485] ------------[ cut here ]------------ 
[28642.164494] kernel BUG at fs/xfs/xfs_message.c:102! 
[28642.164505] Oops: Exception in kernel mode, sig: 5 [#1] 
[28642.164515] LE PAGE_SIZE=64K MMU=Radix MMU=Hash SMP NR_CPUS=2048 NUMA
PowerNV 
[28642.164526] Modules linked in: dm_log_writes dm_thin_pool dm_persistent_data
dm_bio_prison dm_snapshot dm_bufio loop dm_flakey dm_mod i2c_dev sunrpc ext4
ses enclosure scsi_transport_sas xts sg ofpart at24 vmx_crypto powernv_flash
ipmi_powernv uio_pdrv_genirq mtd opal_prd ipmi_devintf ipmi_msghandler uio
mbcache ibmpowernv jbd2 xfs libcrc32c ast i2c_algo_bit drm_vram_helper ttm
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm i40e sd_mod
aacraid drm_panel_orientation_quirks [last unloaded: scsi_debug] 
[28642.164598] CPU: 28 PID: 23394 Comm: xfsaild/dm-0 Tainted: G        W       
 5.4.0-rc3+ #1 
[28642.164610] NIP:  c008000006c7d1e0 LR: c008000006c7d194 CTR:
c0000000008635f0 
[28642.164622] REGS: c0002006ba293870 TRAP: 0700   Tainted: G        W         
(5.4.0-rc3+) 
[28642.164634] MSR:  9000000000029033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 48000482 
XER: 00000000 
[28642.164649] CFAR: c008000006c7d1c4 IRQMASK: 0  
[28642.164649] GPR00: c008000006c7d194 c0002006ba293b00 c008000006dbd800
ffffffffffffffea  
[28642.164649] GPR04: 000000000000000a c0002006ba293a00 c008000006d3be00
0000000000000000  
[28642.164649] GPR08: ffffffffffffffc0 0000000000000001 0000000000000000
0000000000000000  
[28642.164649] GPR12: c0000000008635f0 c0000007fffdf800 c000000002245f78
0000000000000000  
[28642.164649] GPR16: c0002006d5e1a710 c00000000224a730 c0002006d5e1a798
c008000006d42898  
[28642.164649] GPR20: c008000006e16b98 c0002006d5e1a740 c0002005eb1a0000
c0000007fffdf800  
[28642.164649] GPR24: 00000000000000e0 00000000000000e8 c000200299ef35b0
c0002006ba293c20  
[28642.164649] GPR28: c0002005eb1a0000 c000200299ef3568 0000000000000080
0000000000000001  
[28642.164772] NIP [c008000006c7d1e0] assfail+0x88/0xb0 [xfs] 
[28642.164808] LR [c008000006c7d194] assfail+0x3c/0xb0 [xfs] 
[28642.164817] Call Trace: 
[28642.164849] [c0002006ba293b00] [c008000006c7d194] assfail+0x3c/0xb0 [xfs]
(unreliable) 
[28642.164888] [c0002006ba293b70] [c008000006c79d68] xfs_iflush+0x3e0/0x5b0
[xfs] 
[28642.164926] [c0002006ba293c00] [c008000006caba3c]
xfs_inode_item_push+0x104/0x2d0 [xfs] 
[28642.164962] [c0002006ba293c60] [c008000006cbec90] xfsaild_push+0x2d8/0x1580
[xfs] 
[28642.164998] [c0002006ba293d40] [c008000006cc0084] xfsaild+0x14c/0x3e0 [xfs] 
[28642.165013] [c0002006ba293db0] [c0000000001bf2f4] kthread+0x1b4/0x1c0 
[28642.165026] [c0002006ba293e20] [c00000000000b848]
ret_from_kernel_thread+0x5c/0x74 
[28642.165038] Instruction dump: 
[28642.165046] 7fe4fb78 38630010 480942b9 e8410018 73e90001 4082001c 0fe00000
38210070  
[28642.165061] e8010010 ebe1fff8 7c0803a6 4e800020 <0fe00000> 3c620000 e863d7c0
38630028  
[28642.165078] ---[ end trace 4f2fed793e56f874 ]--- 

A weird thing is I tested on xfs-linux xfs-linux 5.4.0-rc3+ + xfs-5.5-merge-6 +
iomap-5.5-merge-6, which already has the fix from bfoster@:

e20e174ca1bd xfs: convert inode to extent format after extent merge due to
shift

I only this this issue once for now, I'll test on latest xfs-linux, to check if
it's still there.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
