Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBCFDC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Mar 2022 20:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241223AbiCaUJA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 16:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbiCaUI6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Mar 2022 16:08:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA8C23586B
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 13:07:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C95861ACC
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 20:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A76AC34113
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 20:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648757229;
        bh=2ZrI6BrxkNqhnB7bNhqYhUZ4Guv3tOJAX2DYT2m3Ww8=;
        h=From:To:Subject:Date:From;
        b=GAzHtWRKGAgAWrSa0KepZVm6kiI9wCvT8zgPIx2a7qxAFCfJSuDPFgNLFfo0w8fhX
         o/xcYkefi9WVkz5GpYcoQyI6Ujc8n/LXLzkfbC+aKHw4oDqz1HBhSa2ZTLzqEUFzY9
         56P6ozTlLjJHEFtpJV6qyUfqu/HdD/QGMMqaOprLQ27obTWdeZ2+Jq7Nj7Dla/LlHK
         xxd81l+JCr8EQfOmxdogqfWzrUAVPmDkPzC18V5N9bYkTA/Uysfj6X+ukwA4u/kOwn
         Exoi4WDTH0OOCuk9cSWvF2QAUpxvb+KeIKtP0d9C+2LgDtdFzdVwpfVRdN76+eycqc
         vmWq4Xj4wqhWA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5585AC05F98; Thu, 31 Mar 2022 20:07:09 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215783] New: kernel NULL pointer dereference and general
 protection fault in fs/xfs/xfs_buf_item_recover.c:
 xlog_recover_do_reg_buffer() when mount a corrupted image
Date:   Thu, 31 Mar 2022 20:07:08 +0000
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
Message-ID: <bug-215783-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215783

            Bug ID: 215783
           Summary: kernel NULL pointer dereference and general protection
                    fault in fs/xfs/xfs_buf_item_recover.c:
                    xlog_recover_do_reg_buffer() when mount a corrupted
                    image
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

Created attachment 300671
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300671&action=3Dedit
corrupted image and .config

- Overview=20
kernel NULL pointer dereference and general protection fault in
fs/xfs/xfs_buf_item_recover.c:xlog_recover_do_reg_buffer() when mount a
corrupted image, sometimes cause kernel hang

- Reproduce=20
tested on kernel 5.17.1, 5.15.32

$ mkdir mnt
$ unzip tmp7.zip
$ ./mount.sh xfs 7  ##NULL pointer derefence
or
$ sudo mount -t xfs tmp7.img mnt ##general protection fault

- Kernel dump
##1
[  433.401124] loop0: detected capacity change from 0 to 32768
[  433.416943] XFS (loop0): Deprecated V4 format (crc=3D0) will not be supp=
orted
after September 2030.
[  433.417005] XFS (loop0): Mounting V10 Filesystem
[  433.418206] XFS (loop0): Starting recovery (logdev: internal)
[  433.418261] BUG: kernel NULL pointer dereference, address: 0000000000000=
000
[  433.418288] #PF: supervisor read access in kernel mode
[  433.418299] #PF: error_code(0x0000) - not-present page
[  433.418310] PGD 0 P4D 0=20
[  433.418317] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  433.418327] CPU: 0 PID: 977 Comm: mount Not tainted 5.17.1 #1
[  433.418339] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.13.0-1ubuntu1.1 04/01/2014
[  433.418356] RIP: 0010:memcpy_erms+0x6/0x10
[  433.418368] Code: fe ff ff cc eb 1e 0f 1f 00 48 89 f8 48 89 d1 48 c1 e9 =
03
83 e2 07 f3 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 <f3> a=
4 c3
0f 1f 80 00 00 00 00 48 89 f8 48 83 fa 20 72 7e 40 38 fe
[  433.418401] RSP: 0018:ffffa985c0217990 EFLAGS: 00010287
[  433.418412] RAX: ffff97c382232400 RBX: 0000000000000000 RCX:
ffffffff913f5d00
[  433.418425] RDX: ffffffff913f5d00 RSI: 0000000000000000 RDI:
ffff97c382232400
[  433.418439] RBP: ffff97c391472b20 R08: ffff97c391472b34 R09:
0000000000000000
[  433.418452] R10: 0000000000000010 R11: fefefefefefefeff R12:
0000000000000008
[  433.418465] R13: ffff97c391472b34 R14: ffff97c38ff1b958 R15:
00000000ff227eba
[  433.418479] FS:  00007f7490a8d080(0000) GS:ffff97c575c00000(0000)
knlGS:0000000000000000
[  433.418494] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  433.418505] CR2: 0000000000000000 CR3: 0000000105e2c004 CR4:
0000000000370ef0
[  433.418521] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  433.418535] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[  433.418573] Call Trace:
[  433.418580]  <TASK>
[  433.418587]  xlog_recover_do_reg_buffer.isra.11+0xf0/0x1e0 [xfs]
[  433.418768]  xlog_recover_buf_commit_pass2+0x476/0x650 [xfs]
[  433.418844]  xlog_recover_items_pass2+0x4e/0xc0 [xfs]
[  433.418921]  xlog_recover_commit_trans+0x2de/0x300 [xfs]
[  433.418996]  xlog_recovery_process_trans+0x8e/0xc0 [xfs]
[  433.419070]  xlog_recover_process_data+0xab/0x130 [xfs]
[  433.419144]  xlog_do_recovery_pass+0x2d5/0x5c0 [xfs]
[  433.419250]  xlog_do_log_recovery+0x7f/0xb0 [xfs]
[  433.419323]  xlog_do_recover+0x34/0x190 [xfs]
[  433.419402]  xlog_recover+0xbc/0x170 [xfs]
[  433.419477]  xfs_log_mount+0x125/0x2d0 [xfs]
[  433.419549]  xfs_mountfs+0x4e0/0xa50 [xfs]
[  433.419621]  ? kmem_alloc+0x88/0x140 [xfs]
[  433.419691]  ? xfs_filestream_get_parent+0x70/0x70 [xfs]
[  433.419759]  xfs_fs_fill_super+0x69f/0x880 [xfs]
[  433.419829]  ? sget_fc+0x1be/0x230
[  433.419839]  ? xfs_fs_inode_init_once+0x70/0x70 [xfs]
[  433.419911]  get_tree_bdev+0x16a/0x280
[  433.419920]  vfs_get_tree+0x22/0xc0
[  433.419929]  path_mount+0x59b/0x9a0
[  433.419938]  do_mount+0x75/0x90
[  433.419946]  __x64_sys_mount+0x86/0xd0
[  433.420302]  do_syscall_64+0x37/0xb0
[  433.420634]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  433.420966] RIP: 0033:0x7f749034e15a
[  433.421290] Code: 48 8b 0d 31 8d 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 =
2e
0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3=
d 01
f0 ff ff 73 01 c3 48 8b 0d fe 8c 2c 00 f7 d8 64 89 01 48
[  433.421964] RSP: 002b:00007fff34b29268 EFLAGS: 00000202 ORIG_RAX:
00000000000000a5
[  433.422310] RAX: ffffffffffffffda RBX: 000055de17f34420 RCX:
00007f749034e15a
[  433.422676] RDX: 000055de17f34600 RSI: 000055de17f36320 RDI:
000055de17f3dc40
[  433.423024] RBP: 0000000000000000 R08: 0000000000000000 R09:
000055de17f34620
[  433.423377] R10: 00000000c0ed0000 R11: 0000000000000202 R12:
000055de17f3dc40
[  433.423713] R13: 000055de17f34600 R14: 0000000000000000 R15:
00007f749086f8a4
[  433.424043]  </TASK>
[  433.424359] Modules linked in: input_leds serio_raw joydev iscsi_tcp
libiscsi_tcp libiscsi scsi_transport_iscsi qemu_fw_cfg xfs autofs4 raid10
raid456 async_raid6_recov async_memcpy async_pq async_xor hid_generic async=
_tx
raid1 usbhid raid0 multipath linear hid qxl drm_ttm_helper ttm drm_kms_help=
er
syscopyarea sysfillrect sysimgblt fb_sys_fops drm crct10dif_pclmul crc32_pc=
lmul
ghash_clmulni_intel psmouse aesni_intel crypto_simd cryptd
[  433.425796] CR2: 0000000000000000
[  433.426147] ---[ end trace 0000000000000000 ]---
[  433.426497] RIP: 0010:memcpy_erms+0x6/0x10
[  433.426856] Code: fe ff ff cc eb 1e 0f 1f 00 48 89 f8 48 89 d1 48 c1 e9 =
03
83 e2 07 f3 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 <f3> a=
4 c3
0f 1f 80 00 00 00 00 48 89 f8 48 83 fa 20 72 7e 40 38 fe
[  433.427595] RSP: 0018:ffffa985c0217990 EFLAGS: 00010287
[  433.427960] RAX: ffff97c382232400 RBX: 0000000000000000 RCX:
ffffffff913f5d00
[  433.428358] RDX: ffffffff913f5d00 RSI: 0000000000000000 RDI:
ffff97c382232400
[  433.428739] RBP: ffff97c391472b20 R08: ffff97c391472b34 R09:
0000000000000000
[  433.429125] R10: 0000000000000010 R11: fefefefefefefeff R12:
0000000000000008
[  433.429510] R13: ffff97c391472b34 R14: ffff97c38ff1b958 R15:
00000000ff227eba
[  433.429897] FS:  00007f7490a8d080(0000) GS:ffff97c575c00000(0000)
knlGS:0000000000000000
[  433.430291] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  433.430708] CR2: 0000000000000000 CR3: 0000000105e2c004 CR4:
0000000000370ef0
[  433.431110] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  433.431507] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
##2
[   35.767636] loop0: detected capacity change from 0 to 32768
[   35.782283] XFS (loop0): Deprecated V4 format (crc=3D0) will not be supp=
orted
after September 2030.
[   35.782334] XFS (loop0): Mounting V10 Filesystem
[   35.783545] XFS (loop0): Starting recovery (logdev: internal)
[   35.783660] general protection fault, maybe for address 0xffff9c0c8b5306=
00:
0000 [#1] SMP NOPTI
[   35.783699] CPU: 3 PID: 943 Comm: mount Not tainted 5.15.32 #1
[   35.783735] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.13.0-1ubuntu1.1 04/01/2014
[   35.783764] RIP: 0010:memcpy_erms+0x6/0x10
[   35.783783] Code: cc cc cc cc eb 1e 0f 1f 00 48 89 f8 48 89 d1 48 c1 e9 =
03
83 e2 07 f3 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 <f3> a=
4 c3
0f 1f 80 00 00 00 00 48 89 f8 48 83 fa 20 72 7e 40 38 fe
[   35.783845] RSP: 0018:ffffbb6f0095f990 EFLAGS: 00010287
[   35.783866] RAX: ffff9c0c8b530600 RBX: 0000000000000000 RCX:
ffffffff914fb600
[   35.783891] RDX: ffffffff914fb600 RSI: 30a131db6e24bf76 RDI:
ffff9c0c8b530600
[   35.783916] RBP: ffff9c0c83c8b6e0 R08: ffff9c0c83c8b6f4 R09:
30a131db6e24bf76
[   35.783941] R10: ffffbb6f0095f858 R11: 0000000000000000 R12:
0000000000000008
[   35.783964] R13: ffff9c0c83c8b6f4 R14: ffff9c0c91095118 R15:
00000000ff229f6c
[   35.783989] FS:  00007fd72fc59080(0000) GS:ffff9c0e75d80000(0000)
knlGS:0000000000000000
[   35.784017] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   35.784038] CR2: 000055e0eb070ee8 CR3: 0000000111f0c004 CR4:
0000000000370ee0
[   35.784067] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   35.784093] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[   35.784118] Call Trace:
[   35.784130]  <TASK>
[   35.784142]  xlog_recover_do_reg_buffer.isra.11+0xf0/0x1d0 [xfs]
[   35.784291]  xlog_recover_buf_commit_pass2+0x449/0x5f0 [xfs]
[   35.784393]  xlog_recover_items_pass2+0x4a/0xa0 [xfs]
[   35.784490]  xlog_recover_commit_trans+0x2c3/0x2e0 [xfs]
[   35.784590]  xlog_recovery_process_trans+0x8e/0xc0 [xfs]
[   35.784689]  xlog_recover_process_data+0xa3/0x110 [xfs]
[   35.784804]  xlog_do_recovery_pass+0x2d5/0x5c0 [xfs]
[   35.784909]  xlog_do_log_recovery+0x7f/0xb0 [xfs]
[   35.785011]  xlog_do_recover+0x34/0x180 [xfs]
[   35.785129]  xlog_recover+0xbc/0x170 [xfs]
[   35.785229]  xfs_log_mount+0x125/0x2d0 [xfs]
[   35.785331]  xfs_mountfs+0x4ad/0xa50 [xfs]
[   35.785431]  ? kmem_alloc+0x74/0x110 [xfs]
[   35.785530]  ? xfs_filestream_get_parent+0x70/0x70 [xfs]
[   35.785631]  xfs_fs_fill_super+0x6a4/0x890 [xfs]
[   35.785733]  ? sget_fc+0x1bd/0x230
[   35.785749]  ? set_bdev_super+0x90/0x90
[   35.785766]  ? xfs_fs_statfs+0x200/0x200 [xfs]
[   35.785869]  get_tree_bdev+0x16a/0x280
[   35.785872]  vfs_get_tree+0x22/0xc0
[   35.785901]  path_mount+0x5a0/0x9a0
[   35.785918]  do_mount+0x75/0x90
[   35.785932]  __x64_sys_mount+0x86/0xd0
[   35.785949]  do_syscall_64+0x37/0xb0
[   35.785966]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   35.785987] RIP: 0033:0x7fd72f51a15a
[   35.786657] Code: 48 8b 0d 31 8d 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 =
2e
0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3=
d 01
f0 ff ff 73 01 c3 48 8b 0d fe 8c 2c 00 f7 d8 64 89 01 48
[   35.788084] RSP: 002b:00007ffe8d0e64b8 EFLAGS: 00000206 ORIG_RAX:
00000000000000a5
[   35.788808] RAX: ffffffffffffffda RBX: 000055e0eb063420 RCX:
00007fd72f51a15a
[   35.789532] RDX: 000055e0eb063600 RSI: 000055e0eb065320 RDI:
000055e0eb06cc40
[   35.790220] RBP: 0000000000000000 R08: 0000000000000000 R09:
000055e0eb063620
[   35.790906] R10: 00000000c0ed0000 R11: 0000000000000206 R12:
000055e0eb06cc40
[   35.791562] R13: 000055e0eb063600 R14: 0000000000000000 R15:
00007fd72fa3b8a4
[   35.792208]  </TASK>
[   35.792828] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi
scsi_transport_iscsi joydev input_leds serio_raw qemu_fw_cfg xfs autofs4 ra=
id10
raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx raid1 ra=
id0
multipath linear qxl drm_ttm_helper ttm drm_kms_helper syscopyarea sysfillr=
ect
sysimgblt fb_sys_fops drm psmouse hid_generic crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel aesni_intel usbhid crypto_simd hid cryptd
[   35.795726] ---[ end trace 876aa8f34409ae4f ]---
[   35.796447] RIP: 0010:memcpy_erms+0x6/0x10
[   35.797153] Code: cc cc cc cc eb 1e 0f 1f 00 48 89 f8 48 89 d1 48 c1 e9 =
03
83 e2 07 f3 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 <f3> a=
4 c3
0f 1f 80 00 00 00 00 48 89 f8 48 83 fa 20 72 7e 40 38 fe
[   35.798627] RSP: 0018:ffffbb6f0095f990 EFLAGS: 00010287
[   35.799357] RAX: ffff9c0c8b530600 RBX: 0000000000000000 RCX:
ffffffff914fb600
[   35.800098] RDX: ffffffff914fb600 RSI: 30a131db6e24bf76 RDI:
ffff9c0c8b530600
[   35.800843] RBP: ffff9c0c83c8b6e0 R08: ffff9c0c83c8b6f4 R09:
30a131db6e24bf76
[   35.801614] R10: ffffbb6f0095f858 R11: 0000000000000000 R12:
0000000000000008
[   35.802395] R13: ffff9c0c83c8b6f4 R14: ffff9c0c91095118 R15:
00000000ff229f6c
[   35.803158] FS:  00007fd72fc59080(0000) GS:ffff9c0e75d80000(0000)
knlGS:0000000000000000
[   35.803950] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   35.804759] CR2: 000055e0eb070ee8 CR3: 0000000111f0c004 CR4:
0000000000370ee0
[   35.805568] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   35.806404] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
