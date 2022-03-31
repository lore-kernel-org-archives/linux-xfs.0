Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66CC5C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Mar 2022 20:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241434AbiCaUdY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 16:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241360AbiCaUdX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Mar 2022 16:33:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6CD19CCFE
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 13:31:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45BF261B0C
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 20:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A3393C34112
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 20:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648758694;
        bh=WUACOW2JavvzeUBOiyVvuuOibFGJdsb0cjRyAqeOIbg=;
        h=From:To:Subject:Date:From;
        b=CMz/cjQUdO5VantTN322glKhDNKFf+mKrALDj/nI0zYGiM0SCR88hGYlgydvGo9uS
         F5Rv0c44g+513HEwL2VcgW3691ZEN7X270WCnEl3rS4kgP4So+FqNeEE4qy1Q3ZK6F
         WEVg08uMfhJqR7b+B9YlXMXh5teizgtkK+LecmCttdDxolwCeag2EeQAr0UmGcu+cM
         SGxmRzDpHDDAI/+XC2gYC4HXcfPsCam0Omhcb0b6DO1q2DVZKhiM/xF7vit0kkTDzM
         d8bzHKGFTbd6MMkBef1ya3gXf1NxLCp+hBjEATG/YuHk80jJK+JMxJhi053JyQN9Jx
         mdqxa/1jb4miw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 90AE7C05FCE; Thu, 31 Mar 2022 20:31:34 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215785] New: kernel NULL pointer dereference in
 fs/xfs/xfs_log_recover.c: xlog_recover_reorder_trans() when mount a corrupted
 image
Date:   Thu, 31 Mar 2022 20:31:34 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: wenqingliu0120@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-215785-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215785

            Bug ID: 215785
           Summary: kernel NULL pointer dereference in
                    fs/xfs/xfs_log_recover.c: xlog_recover_reorder_trans()
                    when mount a corrupted image
           Product: File System
           Version: 2.5
    Kernel Version: 5.17.1, 5.15.32
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: wenqingliu0120@gmail.com
        Regression: No

Created attachment 300673
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300673&action=3Dedit
corrupted image and .config

- Overview=20
kernel NULL pointer dereference in fs/xfs/xfs_log_recover.c:
xlog_recover_reorder_trans()  when mount a corrupted image

- Reproduce=20
tested on kernel 5.17.1, 5.15.32

$ mkdir mnt
$ unzip tmp8.zip
$ sudo mount -t xfs tmp8.img mnt

- Kernel dump
[   50.862358] loop0: detected capacity change from 0 to 32768
[   50.883991] XFS (loop0): Deprecated V4 format (crc=3D0) will not be supp=
orted
after September 2030.
[   50.884096] XFS (loop0): Mounting V10 Filesystem
[   50.885490] XFS (loop0): Starting recovery (logdev: internal)
[   50.885518] BUG: kernel NULL pointer dereference, address: 0000000000000=
000
[   50.885569] #PF: supervisor read access in kernel mode
[   50.885590] #PF: error_code(0x0000) - not-present page
[   50.885609] PGD 0 P4D 0=20
[   50.885622] Oops: 0000 [#1] PREEMPT SMP NOPTI
[   50.885640] CPU: 3 PID: 961 Comm: mount Not tainted 5.17.1 #1
[   50.885663] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.13.0-1ubuntu1.1 04/01/2014
[   50.885691] RIP: 0010:xlog_recover_reorder_trans+0xd7/0x4c0 [xfs]
[   50.885987] Code: 48 89 44 24 30 48 89 7e 30 48 89 7e 38 48 39 cd 4c 8b =
65
00 49 89 ee 0f 84 43 02 00 00 49 c7 c7 c0 fc 49 c0 4c 8b 45 18 31 db <49> 8=
b 00
0f b7 08 89 de 89 da 48 83 fe 0c 0f 87 a5 03 00 00 49 8b
[   50.886068] RSP: 0018:ffffb8aa8047b9c8 EFLAGS: 00010246
[   50.886090] RAX: ffff9bafd1271900 RBX: 0000000000000000 RCX:
ffffb8aa8047b9f0
[   50.886117] RDX: ffff9bafd1271900 RSI: ffff9bafd1271640 RDI:
ffff9bafd1271670
[   50.886144] RBP: ffff9bafd1271900 R08: 0000000000000000 R09:
0000000000000001
[   50.886170] R10: 0000000000000005 R11: ffff9bafd10d93f8 R12:
ffffb8aa8047b9f0
[   50.886197] R13: ffff9bafd1271640 R14: ffff9bafd1271900 R15:
ffffffffc049fcc0
[   50.886224] FS:  00007f4142af0080(0000) GS:ffff9bb1b5d80000(0000)
knlGS:0000000000000000
[   50.886255] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   50.886277] CR2: 0000000000000000 CR3: 0000000105044005 CR4:
0000000000370ee0
[   50.886307] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   50.886334] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[   50.886360] Call Trace:
[   50.886387]  <TASK>
[   50.886398]  ? slab_post_alloc_hook+0x56/0x2c0
[   50.886421]  xlog_recover_commit_trans+0x83/0x300 [xfs]
[   50.886550]  ? xfs_buf_delwri_submit+0x35/0xf0 [xfs]
[   50.886663]  xlog_recovery_process_trans+0x8e/0xc0 [xfs]
[   50.886781]  xlog_recover_process_data+0xab/0x130 [xfs]
[   50.886900]  xlog_do_recovery_pass+0x2d5/0x5c0 [xfs]
[   50.887023]  xlog_do_log_recovery+0x62/0xb0 [xfs]
[   50.887139]  xlog_do_recover+0x34/0x190 [xfs]
[   50.887253]  xlog_recover+0xbc/0x170 [xfs]
[   50.887366]  xfs_log_mount+0x125/0x2d0 [xfs]
[   50.887483]  xfs_mountfs+0x4e0/0xa50 [xfs]
[   50.887594]  ? kmem_alloc+0x88/0x140 [xfs]
[   50.887706]  ? xfs_filestream_get_parent+0x70/0x70 [xfs]
[   50.887819]  xfs_fs_fill_super+0x69f/0x880 [xfs]
[   50.887932]  ? sget_fc+0x1be/0x230
[   50.887949]  ? xfs_fs_inode_init_once+0x70/0x70 [xfs]
[   50.888064]  get_tree_bdev+0x16a/0x280
[   50.888082]  vfs_get_tree+0x22/0xc0
[   50.888098]  path_mount+0x59b/0x9a0
[   50.888114]  do_mount+0x75/0x90
[   50.888129]  __x64_sys_mount+0x86/0xd0
[   50.888145]  do_syscall_64+0x37/0xb0
[   50.888820]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   50.889518] RIP: 0033:0x7f41423b115a
[   50.890218] Code: 48 8b 0d 31 8d 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 =
2e
0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3=
d 01
f0 ff ff 73 01 c3 48 8b 0d fe 8c 2c 00 f7 d8 64 89 01 48
[   50.891656] RSP: 002b:00007ffc770985f8 EFLAGS: 00000202 ORIG_RAX:
00000000000000a5
[   50.892383] RAX: ffffffffffffffda RBX: 00005600900f9420 RCX:
00007f41423b115a
[   50.893113] RDX: 00005600900f9600 RSI: 00005600900fb320 RDI:
0000560090102c40
[   50.893835] RBP: 0000000000000000 R08: 0000000000000000 R09:
00005600900f9620
[   50.894566] R10: 00000000c0ed0000 R11: 0000000000000202 R12:
0000560090102c40
[   50.895257] R13: 00005600900f9600 R14: 0000000000000000 R15:
00007f41428d28a4
[   50.895894]  </TASK>
[   50.896514] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi
scsi_transport_iscsi xfs input_leds joydev serio_raw qemu_fw_cfg autofs4
hid_generic usbhid hid raid10 raid456 async_raid6_recov async_memcpy async_=
pq
async_xor async_tx raid1 raid0 multipath linear qxl drm_ttm_helper ttm
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops psmouse drm
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel crypto_simd
cryptd
[   50.899203] CR2: 0000000000000000
[   50.899903] ---[ end trace 0000000000000000 ]---
[   50.900566] RIP: 0010:xlog_recover_reorder_trans+0xd7/0x4c0 [xfs]
[   50.901362] Code: 48 89 44 24 30 48 89 7e 30 48 89 7e 38 48 39 cd 4c 8b =
65
00 49 89 ee 0f 84 43 02 00 00 49 c7 c7 c0 fc 49 c0 4c 8b 45 18 31 db <49> 8=
b 00
0f b7 08 89 de 89 da 48 83 fe 0c 0f 87 a5 03 00 00 49 8b
[   50.902823] RSP: 0018:ffffb8aa8047b9c8 EFLAGS: 00010246
[   50.903489] RAX: ffff9bafd1271900 RBX: 0000000000000000 RCX:
ffffb8aa8047b9f0
[   50.904209] RDX: ffff9bafd1271900 RSI: ffff9bafd1271640 RDI:
ffff9bafd1271670
[   50.904984] RBP: ffff9bafd1271900 R08: 0000000000000000 R09:
0000000000000001
[   50.905706] R10: 0000000000000005 R11: ffff9bafd10d93f8 R12:
ffffb8aa8047b9f0
[   50.906382] R13: ffff9bafd1271640 R14: ffff9bafd1271900 R15:
ffffffffc049fcc0
[   50.907096] FS:  00007f4142af0080(0000) GS:ffff9bb1b5d80000(0000)
knlGS:0000000000000000
[   50.907814] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   50.908540] CR2: 0000000000000000 CR3: 0000000105044005 CR4:
0000000000370ee0
[   50.909304] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   50.910045] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
