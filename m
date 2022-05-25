Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3564C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 20:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243350AbiEYUgE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 16:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238201AbiEYUgD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 16:36:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40EC650038
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 13:36:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D949E61A3F
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 20:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39F7DC3411B
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 20:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653510961;
        bh=tdcICqfCbr9T1lxGfVy25raeaIvbKGSIKN9BoUQfixQ=;
        h=From:To:Subject:Date:From;
        b=AUOYLuZG28h+WDdEf7Sldk+ubqA6ZeMdzDwxg+haPfqiab5Eb17oZqQeBhrrWuMxy
         7ORrRJssbN3jPTQmsZQYpLOSJFyKJfEeg7tNmz1HEgtW07Xp6Qpd9AwCplTW1h4A+g
         V2v5L2fL7yM0RlZV4C9TgPw7rF5obBeqOF6n+ffzS9rG6cUbxI0nTjkCzeIW0w49cM
         zDk+Df8eVyEbNXaFGwGdgrH3+hgr638xHz42AvpE019ahMuzif6+ZIMuzH3EyS2H8D
         P0YX7zGg8NOvQVLWl29w3m96cuNc2ejL2eirRv+GPiqC3wBkIhQb2dRIADw80HuUlh
         3/B27agq940gA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2ADBBC05FD6; Wed, 25 May 2022 20:36:01 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216031] New: forced kernel crash soon after startup exposes XFS
 growfs race condition
Date:   Wed, 25 May 2022 20:36:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dusty@dustymabe.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-216031-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216031

            Bug ID: 216031
           Summary: forced kernel crash soon after startup exposes XFS
                    growfs race condition
           Product: File System
           Version: 2.5
    Kernel Version: 5.17.6
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: dusty@dustymabe.com
        Regression: No

In Fedora CoreOS we have a test that tests kdump by forcing a kernel crash.=
 We
also have code that does an xfs_growfs on our root filesystem on instance
bringup. Our CI recently exposed a race condition here where if you trigger=
 the
kernel crash in the right time window after growfs the kernel starts spitti=
ng
out traces in the XFS stack.


```
[    1.920053] systemd[1]: Mounting kdumproot-sysroot.mount -
/kdumproot/sysroot...
[    2.194643] SGI XFS with ACLs, security attributes, scrub, quota, no deb=
ug
enabled
[    2.199585] XFS: attr2 mount option is deprecated.
[    2.200537] XFS (vda4): Mounting V5 Filesystem
[    2.241396] XFS (vda4): Starting recovery (logdev: internal)
[    2.264029] XFS (vda4): xfs_buf_find: daddr 0x3b6001 out of range, EOFS
0x3b6000
[    2.264921] ------------[ cut here ]------------
[    2.265443] WARNING: CPU: 0 PID: 487 at fs/xfs/xfs_buf.c:556
xfs_buf_find+0x518/0x5f0 [xfs]
[    2.266645] Modules linked in: xfs crct10dif_pclmul crc32_pclmul
crc32c_intel ghash_clmulni_intel serio_raw virtio_net net_failover
virtio_console failover virtio_blk ata_generic pata_acpi qemu_fw_cfg ip6_ta=
bles
ip_tables ipmi_devintf ipmi_msghandler fuse overlay squashfs loop
[    2.269172] CPU: 0 PID: 487 Comm: mount Not tainted 5.17.6-300.fc36.x86_=
64
#1
[    2.269920] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.16.0-1.fc36 04/01/2014
[    2.270835] RIP: 0010:xfs_buf_find+0x518/0x5f0 [xfs]
[    2.271448] Code: e8 2d 4f f1 c0 e9 e5 fe ff ff 0f 1f 44 00 00 e9 b5 fe =
ff
ff 48 89 c1 48 c7 c2 b0 bb 22 c0 48 c7 c6 e0 c6 23 c0 e8 65 28 05 00 <0f> 0=
b b8
8b ff ff ff e9 cd fe ff ff 0f 1f 44 00 00 e9 1a fd ff ff
[    2.273331] RSP: 0018:ffffc9000073f980 EFLAGS: 00010282
[    2.273888] RAX: 00000000ffffffea RBX: 0000000000000001 RCX:
000000007fffffff
[    2.274642] RDX: 0000000000000021 RSI: 0000000000000000 RDI:
ffffffffc02378fd
[    2.275423] RBP: 0000000000000000 R08: 0000000000000000 R09:
000000000000000a
[    2.276300] R10: 000000000000000a R11: 0fffffffffffffff R12:
ffff8880bb1c5100
[    2.277205] R13: ffffc9000073f9e8 R14: ffffc9000073fa98 R15:
0000000000000001
[    2.278144] FS:  00007f815240f800(0000) GS:ffff8880b8a00000(0000)
knlGS:0000000000000000
[    2.279101] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.279807] CR2: 00007f4b81ba8c08 CR3: 00000000bb248000 CR4:
0000000000350eb0
[    2.280829] Call Trace:
[    2.281176]  <TASK>
[    2.281461]  xfs_buf_get_map+0x35/0x390 [xfs]
[    2.282289]  xfs_buf_read_map+0x39/0x270 [xfs]
[    2.282932]  xfs_buf_readahead_map+0x40/0x50 [xfs]
[    2.283648]  ? xfs_buf_readahead_map+0x22/0x50 [xfs]
[    2.284421]  xlog_buf_readahead+0x52/0x60 [xfs]
[    2.285113]  xlog_recover_commit_trans+0xcf/0x300 [xfs]
[    2.285879]  xlog_recovery_process_trans+0xc0/0xf0 [xfs]
[    2.286685]  xlog_recover_process_data+0xa0/0x120 [xfs]
[    2.287395]  xlog_do_recovery_pass+0x3ae/0x5b0 [xfs]
[    2.288004]  ? preempt_count_add+0x44/0x90
[    2.288474]  xlog_do_log_recovery+0x87/0xb0 [xfs]
[    2.289046]  xlog_do_recover+0x34/0x1b0 [xfs]
[    2.289597]  xlog_recover+0xb6/0x150 [xfs]
[    2.290113]  xfs_log_mount+0x14a/0x280 [xfs]
[    2.290651]  xfs_mountfs+0x3ce/0x840 [xfs]
[    2.291175]  ? xfs_filestream_get_parent+0x70/0x70 [xfs]
[    2.291807]  ? xfs_mru_cache_create+0x136/0x180 [xfs]
[    2.292469]  xfs_fs_fill_super+0x466/0x810 [xfs]
[    2.293032]  ? xfs_init_fs_context+0x170/0x170 [xfs]
[    2.293637]  get_tree_bdev+0x16d/0x260
[    2.294064]  vfs_get_tree+0x25/0xb0
[    2.294465]  path_mount+0x431/0xa70
[    2.294857]  __x64_sys_mount+0xe2/0x120
[    2.295290]  do_syscall_64+0x3a/0x80
[    2.295688]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[    2.296241] RIP: 0033:0x7f81526002ae
[    2.296641] Code: 48 8b 0d 6d fb 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 =
2e
0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3=
d 01
f0 ff ff 73 01 c3 48 8b 0d 3a fb 0d 00 f7 d8 64 89 01 48
[    2.298518] RSP: 002b:00007ffdf1b0e548 EFLAGS: 00000246 ORIG_RAX:
00000000000000a5
[    2.299312] RAX: ffffffffffffffda RBX: 0000564ccec18bb0 RCX:
00007f81526002ae
[    2.300051] RDX: 0000564ccec18f20 RSI: 0000564ccec18f80 RDI:
0000564ccec19c50
[    2.300801] RBP: 0000000000000000 R08: 0000564ccec18e80 R09:
0000000000000073
[    2.301560] R10: 0000000000200000 R11: 0000000000000246 R12:
0000564ccec19c50
[    2.302314] R13: 0000564ccec18f20 R14: 00000000ffffffff R15:
00007f815274e076
[    2.303056]  </TASK>
[    2.303329] ---[ end trace 0000000000000000 ]---
```

The original bug with some more context is at
https://github.com/coreos/fedora-coreos-tracker/issues/1195

This was originally seen with Fedora kernel 5.17.6-300.fc36.x86_64

Eric Sandeen created a small reproducer:

```
#!/bin/bash

rm -f fsfile
mkfs.xfs -b size=3D4096 -dfile,name=3Dfsfile,size=3D486400b
truncate --size=3D10199478272 fsfile
mkdir -p mnt
mount -o loop fsfile mnt
xfs_growfs mnt
for I in `seq 1 32`; do
        mkdir mnt/dir$I
        touch mnt/dir$I/file
done
sync -f mnt
xfs_io -x -c "shutdown" mnt
umount mnt
mount -o loop fsfile mnt
umount mnt
```

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
