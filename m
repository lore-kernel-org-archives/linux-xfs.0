Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06A0C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jan 2022 03:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351189AbiASDIh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jan 2022 22:08:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238949AbiASDIg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jan 2022 22:08:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F17BC061574
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jan 2022 19:08:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E7C061547
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 03:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 742BCC340E9
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 03:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642561714;
        bh=sBM/TtbLAE1G+vWyoVLbHfsqJDVOfKyWVPeve4jO3KY=;
        h=From:To:Subject:Date:From;
        b=IQv0BHQHblceQDShzbhwJlVsQyeitXC81qlNXwECLESmNEoDXxrhQ2+NNe8FVAluk
         T1wZKtKtXwtg5gB0fjaRNUnijpxmt1Y3OvnfERImwsgQkMMrfBc75ljxpnh2qdf9Kc
         tDRiEg2+yxP+bX1WwMy7xbQToApt7XJ3gCh0xYfLiyqJuhE0yI/JQ/3djVRkdbzjgQ
         jERC4Se62U3leE2JfwK1slxwgZ2P0R4Uo3RG6VCVZ2RMr6kXIaUzr61MZA/nGKLt2G
         qKvm9iXC319xLWZZQdO5+yKM/FOsuaMOb27jxeifhWxpn3+DTtQBkydDILcgcFJlUn
         CiQYUlCKYNU1w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6160CCC13A6; Wed, 19 Jan 2022 03:08:34 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215506] New: Internal error !ino_ok at line 200 of file
 fs/xfs/libxfs/xfs_dir2.c.  Caller xfs_dir_ino_validate+0x5d/0xd0 [xfs]
Date:   Wed, 19 Jan 2022 03:08:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: yanming@tju.edu.cn
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-215506-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215506

            Bug ID: 215506
           Summary: Internal error !ino_ok at line 200 of file
                    fs/xfs/libxfs/xfs_dir2.c.  Caller
                    xfs_dir_ino_validate+0x5d/0xd0 [xfs]
           Product: File System
           Version: 2.5
    Kernel Version: 5.15.4
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: yanming@tju.edu.cn
        Regression: No

Created attachment 300288
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300288&action=3Dedit
tmp.c

I have encountered a bug in xfs file system.

I created a disk image and modified some properties. After that I mount the
image and run some commands related to file operations, and the bug occured.

The file operations are in the "tmp.c" file, and a modified image named
"tmp.img" can be found in
(https://drive.google.com/file/d/1SujibjuGYcBA-jjZ5FtR-rSi7koVt0_d/view?usp=
=3Dsharing).
You can simply reproduce the bug by running the following commands:

gcc -o tmp tmp.c
losetup /dev/loop7 tmp.img
mount -o
"attr2,discard,grpid,filestreams,noikeep,inode32,largeio,logbufs=3D5,noalig=
n,nouuid,noquota,loop"
-t xfs /dev/loop7 /root/mnt
./tmp

The kernel message is shown below:

6,2489,54115223218,-;loop7: detected capacity change from 0 to 131072
6,2490,54115436921,-;loop8: detected capacity change from 0 to 131072
5,2491,54115497587,-;XFS (loop8): Mounting V5 Filesystem
1,2492,54115636142,-;XFS (loop8): Internal error !ino_ok at line 200 of file
fs/xfs/libxfs/xfs_dir2.c.  Caller xfs_dir_ino_validate+0x5d/0xd0 [xfs]
4,2493,54115637100,-;CPU: 0 PID: 17928 Comm: mount Tainted: G        W    L=
=20=20=20
5.15.4 #3
4,2494,54115637493,-;Hardware name: LENOVO 20J6A00NHH/20J6A00NHH, BIOS R0FE=
T24W
(1.04 ) 12/21/2016
4,2495,54115637742,-;Call Trace:
4,2496,54115637857,-; <TASK>
4,2497,54115638019,-; dump_stack_lvl+0xea/0x130
4,2498,54115638586,-; dump_stack+0x1c/0x25
4,2499,54115639082,-; xfs_error_report+0xd3/0xe0 [xfs]
4,2500,54115639769,-; ? xfs_dir_ino_validate+0x5d/0xd0 [xfs]
4,2501,54115640025,-; ? xfs_dir_ino_validate+0x5d/0xd0 [xfs]
4,2502,54115640025,-; xfs_corruption_error+0xab/0x120 [xfs]
4,2503,54115640025,-; ? write_comp_data+0x37/0xc0
4,2504,54115640025,-; xfs_dir_ino_validate+0xa2/0xd0 [xfs]
4,2505,54115640025,-; ? xfs_dir_ino_validate+0x5d/0xd0 [xfs]
4,2506,54115640025,-; xfs_dir2_sf_verify+0x5d2/0xb50 [xfs]
4,2507,54115640025,-; xfs_ifork_verify_local_data+0xd6/0x180 [xfs]
4,2508,54115640025,-; ? __sanitizer_cov_trace_pc+0x31/0x80
4,2509,54115640025,-; xfs_iformat_data_fork+0x3ff/0x4c0 [xfs]
4,2510,54115640025,-; xfs_inode_from_disk+0xb5a/0x1460 [xfs]
4,2511,54115640025,-; xfs_iget+0x1281/0x2850 [xfs]
4,2512,54115640025,-; ? _raw_write_lock_bh+0x130/0x130
4,2513,54115640025,-; ? xfs_verify_icount+0x31a/0x3f0 [xfs]
4,2514,54115640025,-; ? write_comp_data+0x37/0xc0
4,2515,54115640025,-; ? write_comp_data+0x37/0xc0
4,2516,54115640025,-; ? xfs_perag_get+0x260/0x260 [xfs]
4,2517,54115640025,-; ? xfs_inode_free+0xe0/0xe0 [xfs]
4,2518,54115640025,-; ? xfs_mountfs+0x1227/0x1ff0 [xfs]
4,2519,54115640025,-; ? xfs_blockgc_start+0x76/0x490 [xfs]
4,2520,54115640025,-; ? write_comp_data+0x37/0xc0
4,2521,54115640025,-; xfs_mountfs+0x12f5/0x1ff0 [xfs]
4,2522,54115640025,-; ? xfs_mount_reset_sbqflags+0x1a0/0x1a0 [xfs]
4,2523,54115640025,-; ? __sanitizer_cov_trace_pc+0x31/0x80
4,2524,54115640025,-; ? xfs_mru_cache_create+0x4d2/0x690 [xfs]
4,2525,54115640025,-; ? xfs_filestream_get_ag+0x90/0x90 [xfs]
4,2526,54115640025,-; ? write_comp_data+0x37/0xc0
4,2527,54115640025,-; xfs_fs_fill_super+0x1198/0x2030 [xfs]
4,2528,54115640025,-; get_tree_bdev+0x494/0x850
4,2529,54115640025,-; ? xfs_fs_parse_param+0x1920/0x1920 [xfs]
4,2530,54115640025,-; xfs_fs_get_tree+0x2a/0x40 [xfs]
4,2531,54115640025,-; vfs_get_tree+0x9a/0x380
4,2532,54115640025,-; path_mount+0x7e3/0x24c0
4,2533,54115640025,-; ? __kasan_slab_free+0x147/0x1f0
4,2534,54115640025,-; ? finish_automount+0x860/0x860
4,2535,54115640025,-; ? __sanitizer_cov_trace_pc+0x31/0x80
4,2536,54115640025,-; ? putname+0x165/0x1e0
4,2537,54115640025,-; ? write_comp_data+0x37/0xc0
4,2538,54115640025,-; do_mount+0x11b/0x140
4,2539,54115640025,-; ? path_mount+0x24c0/0x24c0
4,2540,54115640025,-; ? write_comp_data+0x37/0xc0
4,2541,54115640025,-; ? __sanitizer_cov_trace_pc+0x31/0x80
4,2542,54115640025,-; ? write_comp_data+0x37/0xc0
4,2543,54115640025,-; __x64_sys_mount+0x1c3/0x2c0
4,2544,54115640025,-; do_syscall_64+0x3b/0xc0
4,2545,54115640025,-; entry_SYSCALL_64_after_hwframe+0x44/0xae
4,2546,54115640025,-;RIP: 0033:0x7fa63cbb0dde
4,2547,54115640025,-;Code: 48 8b 0d b5 80 0c 00 f7 d8 64 89 01 48 83 c8 ff =
c3
66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 =
<48>
3d 01 f0 ff ff 73 01 c3 48 8b 0d 82 80 0c 00 f7 d8 64 89 01 48
4,2548,54115640025,-;RSP: 002b:00007ffcd394f958 EFLAGS: 00000246 ORIG_RAX:
00000000000000a5
4,2549,54115640025,-;RAX: ffffffffffffffda RBX: 00007fa63ccdf204 RCX:
00007fa63cbb0dde
4,2550,54115640025,-;RDX: 000056155b8a6d10 RSI: 000056155b8a6d90 RDI:
000056155b8af870
4,2551,54115640025,-;RBP: 000056155b8a6b00 R08: 0000000000000000 R09:
000056155b8af980
4,2552,54115640025,-;R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
4,2553,54115640025,-;R13: 000056155b8af870 R14: 000056155b8a6d10 R15:
000056155b8a6b00
4,2554,54115640025,-; </TASK>
1,2555,54115662742,-;XFS (loop8): Corruption detected. Unmount and run
xfs_repair
4,2556,54115663126,-;XFS (loop8): Invalid inode number 0x2000000
1,2557,54115663448,-;XFS (loop8): Metadata corruption detected at
xfs_dir2_sf_verify+0x906/0xb50 [xfs], inode 0x60 data fork
1,2558,54115664625,-;XFS (loop8): Unmount and run xfs_repair
1,2559,54115665007,-;XFS (loop8): First 17 bytes of corrupted metadata buff=
er:
1,2560,54115665553,-;00000000: 01 00 00 00 00 60 03 00 60 66 6f 6f 02 00 00=
 00=20
.....`..`foo....
1,2561,54115666121,-;00000010: 63=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
c
4,2562,54115666649,-;XFS (loop8): Failed to read root inode 0x60, error 117

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
