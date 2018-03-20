Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out2.virusfree.cz ([79.133.37.42]:50234 "EHLO out2.virusfree.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751372AbeCTOn4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Mar 2018 10:43:56 -0400
Received: from localhost3.excello.cz (unknown [IPv6:2001:67c:1590:0:f929:70fd:3cc1:ae86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by posta.excello.cz (Postfix) with ESMTPSA id ED9369D5EC1
        for <linux-xfs@vger.kernel.org>; Tue, 20 Mar 2018 15:37:10 +0100 (CET)
From: Tomas Charvat <tc@excello.cz>
Subject: 4.14.26 XFS: Assertion failed fs/xfs/xfs_message.c
Message-ID: <6913e48f-e4ee-0b88-80ec-ed3560cd8894@excello.cz>
Date: Tue, 20 Mar 2018 15:37:10 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms080403070707040207010001"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms080403070707040207010001
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

Hi in recent versions of kernle-4.14 I'm getting following error.

[Tue Mar 20 14:31:39 2018] XFS: Assertion failed: tp->t_blk_res_used <=3D=

tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
[Tue Mar 20 14:31:39 2018] ------------[ cut here ]------------
[Tue Mar 20 14:31:39 2018] WARNING: CPU: 0 PID: 13025 at
fs/xfs/xfs_message.c:105 asswarn+0x17/0x20
[Tue Mar 20 14:31:39 2018] CPU: 0 PID: 13025 Comm: async_8 Tainted:
G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4.14.26-gentoo #1
[Tue Mar 20 14:31:39 2018] Hardware name: Xen HVM domU, BIOS 4.9.1
01/25/2018
[Tue Mar 20 14:31:39 2018] task: ffff88003da7d940 task.stack:
ffffc90008ba8000
[Tue Mar 20 14:31:39 2018] RIP: 0010:asswarn+0x17/0x20
[Tue Mar 20 14:31:39 2018] RSP: 0018:ffffc90008bab810 EFLAGS: 00010246
[Tue Mar 20 14:31:39 2018] RAX: 0000000000000000 RBX: ffff8800d3f841e0
RCX: 0000000000000000
[Tue Mar 20 14:31:39 2018] RDX: 00000000ffffffc0 RSI: 000000000000000a
RDI: ffffffff81d22af7
[Tue Mar 20 14:31:39 2018] RBP: ffffffffffffffff R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 14:31:39 2018] R10: 000000000000000a R11: f000000000000000
R12: ffff880148594000
[Tue Mar 20 14:31:39 2018] R13: 0000000000200007 R14: 00000000000fdfc0
R15: ffff880148594000
[Tue Mar 20 14:31:39 2018] FS:=C2=A0 00007f7658155700(0000)
GS:ffff88014f400000(0000) knlGS:0000000000000000
[Tue Mar 20 14:31:39 2018] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
[Tue Mar 20 14:31:39 2018] CR2: 00007f327cc05010 CR3: 0000000016b76000
CR4: 00000000000406f0
[Tue Mar 20 14:31:39 2018] Call Trace:
[Tue Mar 20 14:31:39 2018]=C2=A0 xfs_trans_mod_sb+0x226/0x2b0
[Tue Mar 20 14:31:39 2018]=C2=A0 xfs_alloc_ag_vextent+0x130/0x330
[Tue Mar 20 14:31:39 2018]=C2=A0 xfs_alloc_vextent+0x3ba/0x4b0
[Tue Mar 20 14:31:39 2018]=C2=A0 __xfs_inobt_alloc_block.isra.1+0x9f/0x13=
0
[Tue Mar 20 14:31:39 2018]=C2=A0 __xfs_btree_split+0xfd/0x5c0
[Tue Mar 20 14:31:39 2018]=C2=A0 ? xfs_trans_read_buf_map+0x265/0x2f0
[Tue Mar 20 14:31:39 2018]=C2=A0 ?
xfs_btree_read_buf_block.constprop.26+0xaf/0xf0
[Tue Mar 20 14:31:39 2018]=C2=A0 xfs_btree_split+0x66/0x110
[Tue Mar 20 14:31:39 2018]=C2=A0 xfs_btree_make_block_unfull+0x113/0x1d0
[Tue Mar 20 14:31:39 2018]=C2=A0 xfs_btree_insrec+0x419/0x500
[Tue Mar 20 14:31:39 2018]=C2=A0 xfs_btree_insert+0xe2/0x220
[Tue Mar 20 14:31:39 2018]=C2=A0 xfs_difree_finobt+0xd0/0x2d0
[Tue Mar 20 14:31:39 2018]=C2=A0 xfs_difree+0x162/0x220
[Tue Mar 20 14:31:39 2018]=C2=A0 xfs_ifree+0xd0/0x290
[Tue Mar 20 14:31:39 2018]=C2=A0 xfs_inactive_ifree+0xf6/0x290
[Tue Mar 20 14:31:39 2018]=C2=A0 xfs_inactive+0x112/0x2a0
[Tue Mar 20 14:31:39 2018]=C2=A0 xfs_fs_destroy_inode+0x82/0x1f0
[Tue Mar 20 14:31:39 2018]=C2=A0 do_unlinkat+0x1b9/0x320
[Tue Mar 20 14:31:39 2018]=C2=A0 do_syscall_64+0x87/0x330
[Tue Mar 20 14:31:39 2018]=C2=A0 ? schedule+0x2d/0x80
[Tue Mar 20 14:31:39 2018]=C2=A0 entry_SYSCALL_64_after_hwframe+0x3d/0xa2=

[Tue Mar 20 14:31:39 2018] RIP: 0033:0x7f7698c17967
[Tue Mar 20 14:31:39 2018] RSP: 002b:00007f7658154e28 EFLAGS: 00000246
ORIG_RAX: 0000000000000057
[Tue Mar 20 14:31:39 2018] RAX: ffffffffffffffda RBX: 00007f7658781a74
RCX: 00007f7698c17967
[Tue Mar 20 14:31:39 2018] RDX: 00007f7658781a20 RSI: 00007f7658781b30
RDI: 00007f7658781b30
[Tue Mar 20 14:31:39 2018] RBP: 00007f7658154e90 R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 14:31:39 2018] R10: 0000000000000000 R11: 0000000000000246
R12: 00007f76587819e0
[Tue Mar 20 14:31:39 2018] R13: 00007f7658154e80 R14: 0000000000000000
R15: 00007f7658600240
[Tue Mar 20 14:31:39 2018] Code: 10 e8 8e f9 ff ff 0f 0b e8 67 06 db ff
0f 1f 80 00 00 00 00 48 89 f1 41 89 d0 48 c7 c6 68 1f d5 81 48 89 fa 31
ff e8 a9 fc ff ff <0f> 0b c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7
c6 68 1f d5
[Tue Mar 20 14:31:39 2018] ---[ end trace 1d252f8e3d5494fb ]---
[Tue Mar 20 14:41:11 2018] XFS: Assertion failed: tp->t_blk_res_used <=3D=

tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
[Tue Mar 20 14:41:11 2018] ------------[ cut here ]------------
[Tue Mar 20 14:41:11 2018] WARNING: CPU: 1 PID: 2070 at
fs/xfs/xfs_message.c:105 asswarn+0x17/0x20
[Tue Mar 20 14:41:11 2018] CPU: 1 PID: 2070 Comm: async_8 Tainted:
G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4.14.26-gentoo #1
[Tue Mar 20 14:41:11 2018] Hardware name: Xen HVM domU, BIOS 4.9.1
01/25/2018
[Tue Mar 20 14:41:11 2018] task: ffff880147469980 task.stack:
ffffc90000fd8000
[Tue Mar 20 14:41:11 2018] RIP: 0010:asswarn+0x17/0x20
[Tue Mar 20 14:41:11 2018] RSP: 0018:ffffc90000fdb810 EFLAGS: 00010246
[Tue Mar 20 14:41:11 2018] RAX: 0000000000000000 RBX: ffff880012d340f0
RCX: 0000000000000000
[Tue Mar 20 14:41:11 2018] RDX: 00000000ffffffc0 RSI: 000000000000000a
RDI: ffffffff81d22af7
[Tue Mar 20 14:41:11 2018] RBP: ffffffffffffffff R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 14:41:11 2018] R10: 000000000000000a R11: f000000000000000
R12: ffff880148594000
[Tue Mar 20 14:41:11 2018] R13: 0000000000200007 R14: 00000000000fdfc0
R15: ffff880148594000
[Tue Mar 20 14:41:11 2018] FS:=C2=A0 00007f967ca55700(0000)
GS:ffff88014f480000(0000) knlGS:0000000000000000
[Tue Mar 20 14:41:11 2018] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
[Tue Mar 20 14:41:11 2018] CR2: 00007f327e4c6ff0 CR3: 000000002d9ca000
CR4: 00000000000406e0
[Tue Mar 20 14:41:11 2018] Call Trace:
[Tue Mar 20 14:41:11 2018]=C2=A0 xfs_trans_mod_sb+0x226/0x2b0
[Tue Mar 20 14:41:11 2018]=C2=A0 xfs_alloc_ag_vextent+0x130/0x330
[Tue Mar 20 14:41:11 2018]=C2=A0 xfs_alloc_vextent+0x3ba/0x4b0
[Tue Mar 20 14:41:11 2018]=C2=A0 __xfs_inobt_alloc_block.isra.1+0x9f/0x13=
0
[Tue Mar 20 14:41:11 2018]=C2=A0 __xfs_btree_split+0xfd/0x5c0
[Tue Mar 20 14:41:11 2018]=C2=A0 ? xfs_trans_read_buf_map+0x265/0x2f0
[Tue Mar 20 14:41:11 2018]=C2=A0 ?
xfs_btree_read_buf_block.constprop.26+0xaf/0xf0
[Tue Mar 20 14:41:11 2018]=C2=A0 xfs_btree_split+0x66/0x110
[Tue Mar 20 14:41:11 2018]=C2=A0 xfs_btree_make_block_unfull+0x113/0x1d0
[Tue Mar 20 14:41:11 2018]=C2=A0 xfs_btree_insrec+0x419/0x500
[Tue Mar 20 14:41:11 2018]=C2=A0 xfs_btree_insert+0xe2/0x220
[Tue Mar 20 14:41:11 2018]=C2=A0 xfs_difree_finobt+0xd0/0x2d0
[Tue Mar 20 14:41:11 2018]=C2=A0 xfs_difree+0x162/0x220
[Tue Mar 20 14:41:11 2018]=C2=A0 xfs_ifree+0xd0/0x290
[Tue Mar 20 14:41:11 2018]=C2=A0 xfs_inactive_ifree+0xf6/0x290
[Tue Mar 20 14:41:11 2018]=C2=A0 xfs_inactive+0x112/0x2a0
[Tue Mar 20 14:41:11 2018]=C2=A0 xfs_fs_destroy_inode+0x82/0x1f0
[Tue Mar 20 14:41:11 2018]=C2=A0 do_unlinkat+0x1b9/0x320
[Tue Mar 20 14:41:11 2018]=C2=A0 do_syscall_64+0x87/0x330
[Tue Mar 20 14:41:11 2018]=C2=A0 ? __do_page_fault+0x1e0/0x450
[Tue Mar 20 14:41:11 2018]=C2=A0 entry_SYSCALL_64_after_hwframe+0x3d/0xa2=

[Tue Mar 20 14:41:11 2018] RIP: 0033:0x7f96bd517967
[Tue Mar 20 14:41:11 2018] RSP: 002b:00007f967ca54e28 EFLAGS: 00000246
ORIG_RAX: 0000000000000057
[Tue Mar 20 14:41:11 2018] RAX: ffffffffffffffda RBX: 00007f967d081a14
RCX: 00007f96bd517967
[Tue Mar 20 14:41:11 2018] RDX: 00007f967d081c88 RSI: 00007f967d081ad0
RDI: 00007f967d081ad0
[Tue Mar 20 14:41:11 2018] RBP: 00007f967ca54e90 R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 14:41:11 2018] R10: 0000000000000000 R11: 0000000000000246
R12: 00007f967d081c48
[Tue Mar 20 14:41:11 2018] R13: 00007f967ca54e80 R14: 0000000000000000
R15: 00007f967cf00240
[Tue Mar 20 14:41:11 2018] Code: 10 e8 8e f9 ff ff 0f 0b e8 67 06 db ff
0f 1f 80 00 00 00 00 48 89 f1 41 89 d0 48 c7 c6 68 1f d5 81 48 89 fa 31
ff e8 a9 fc ff ff <0f> 0b c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7
c6 68 1f d5
[Tue Mar 20 14:41:11 2018] ---[ end trace 1d252f8e3d5494fc ]---
[Tue Mar 20 14:41:20 2018] XFS: Assertion failed: tp->t_blk_res_used <=3D=

tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
[Tue Mar 20 14:41:20 2018] ------------[ cut here ]------------
[Tue Mar 20 14:41:20 2018] WARNING: CPU: 3 PID: 2070 at
fs/xfs/xfs_message.c:105 asswarn+0x17/0x20
[Tue Mar 20 14:41:20 2018] CPU: 3 PID: 2070 Comm: async_8 Tainted:
G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4.14.26-gentoo #1
[Tue Mar 20 14:41:20 2018] Hardware name: Xen HVM domU, BIOS 4.9.1
01/25/2018
[Tue Mar 20 14:41:20 2018] task: ffff880147469980 task.stack:
ffffc90000fd8000
[Tue Mar 20 14:41:20 2018] RIP: 0010:asswarn+0x17/0x20
[Tue Mar 20 14:41:20 2018] RSP: 0018:ffffc90000fdb810 EFLAGS: 00010246
[Tue Mar 20 14:41:20 2018] RAX: 0000000000000000 RBX: ffff88013496ba50
RCX: 0000000000000000
[Tue Mar 20 14:41:20 2018] RDX: 00000000ffffffc0 RSI: 000000000000000a
RDI: ffffffff81d22af7
[Tue Mar 20 14:41:20 2018] RBP: ffffffffffffffff R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 14:41:20 2018] R10: 000000000000000a R11: f000000000000000
R12: ffff880148594000
[Tue Mar 20 14:41:20 2018] R13: 0000000000100007 R14: 00000000000fdfc0
R15: ffff880148594000
[Tue Mar 20 14:41:20 2018] FS:=C2=A0 00007f967ca55700(0000)
GS:ffff88014f580000(0000) knlGS:0000000000000000
[Tue Mar 20 14:41:20 2018] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
[Tue Mar 20 14:41:20 2018] CR2: 00007f327a9a3010 CR3: 000000002d9ca000
CR4: 00000000000406e0
[Tue Mar 20 14:41:20 2018] Call Trace:
[Tue Mar 20 14:41:20 2018]=C2=A0 xfs_trans_mod_sb+0x226/0x2b0
[Tue Mar 20 14:41:20 2018]=C2=A0 xfs_alloc_ag_vextent+0x130/0x330
[Tue Mar 20 14:41:20 2018]=C2=A0 xfs_alloc_vextent+0x3ba/0x4b0
[Tue Mar 20 14:41:20 2018]=C2=A0 ? kmem_zone_alloc+0x7e/0x100
[Tue Mar 20 14:41:20 2018]=C2=A0 __xfs_inobt_alloc_block.isra.1+0x9f/0x13=
0
[Tue Mar 20 14:41:20 2018]=C2=A0 __xfs_btree_split+0xfd/0x5c0
[Tue Mar 20 14:41:20 2018]=C2=A0 ? xfs_trans_read_buf_map+0x265/0x2f0
[Tue Mar 20 14:41:20 2018]=C2=A0 ?
xfs_btree_read_buf_block.constprop.26+0xaf/0xf0
[Tue Mar 20 14:41:20 2018]=C2=A0 xfs_btree_split+0x66/0x110
[Tue Mar 20 14:41:20 2018]=C2=A0 xfs_btree_make_block_unfull+0x113/0x1d0
[Tue Mar 20 14:41:20 2018]=C2=A0 xfs_btree_insrec+0x419/0x500
[Tue Mar 20 14:41:20 2018]=C2=A0 xfs_btree_insert+0xe2/0x220
[Tue Mar 20 14:41:20 2018]=C2=A0 xfs_difree_finobt+0xd0/0x2d0
[Tue Mar 20 14:41:20 2018]=C2=A0 xfs_difree+0x162/0x220
[Tue Mar 20 14:41:20 2018]=C2=A0 xfs_ifree+0xd0/0x290
[Tue Mar 20 14:41:20 2018]=C2=A0 xfs_inactive_ifree+0xf6/0x290
[Tue Mar 20 14:41:20 2018]=C2=A0 xfs_inactive+0x112/0x2a0
[Tue Mar 20 14:41:20 2018]=C2=A0 xfs_fs_destroy_inode+0x82/0x1f0
[Tue Mar 20 14:41:20 2018]=C2=A0 do_unlinkat+0x1b9/0x320
[Tue Mar 20 14:41:20 2018]=C2=A0 do_syscall_64+0x87/0x330
[Tue Mar 20 14:41:20 2018]=C2=A0 ? schedule+0x2d/0x80
[Tue Mar 20 14:41:20 2018]=C2=A0 entry_SYSCALL_64_after_hwframe+0x3d/0xa2=

[Tue Mar 20 14:41:20 2018] RIP: 0033:0x7f96bd517967
[Tue Mar 20 14:41:20 2018] RSP: 002b:00007f967ca54e28 EFLAGS: 00000246
ORIG_RAX: 0000000000000057
[Tue Mar 20 14:41:20 2018] RAX: ffffffffffffffda RBX: 00007f967d081a14
RCX: 00007f96bd517967
[Tue Mar 20 14:41:20 2018] RDX: 00007f967d081b90 RSI: 00007f967d081ad0
RDI: 00007f967d081ad0
[Tue Mar 20 14:41:20 2018] RBP: 00007f967ca54e90 R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 14:41:20 2018] R10: 0000000000000000 R11: 0000000000000246
R12: 00007f967d081b50
[Tue Mar 20 14:41:20 2018] R13: 00007f967ca54e80 R14: 0000000000000000
R15: 00007f967cf00240
[Tue Mar 20 14:41:20 2018] Code: 10 e8 8e f9 ff ff 0f 0b e8 67 06 db ff
0f 1f 80 00 00 00 00 48 89 f1 41 89 d0 48 c7 c6 68 1f d5 81 48 89 fa 31
ff e8 a9 fc ff ff <0f> 0b c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7
c6 68 1f d5
[Tue Mar 20 14:41:20 2018] ---[ end trace 1d252f8e3d5494fd ]---
[Tue Mar 20 14:41:21 2018] XFS: Assertion failed: tp->t_blk_res_used <=3D=

tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
[Tue Mar 20 14:41:21 2018] ------------[ cut here ]------------
[Tue Mar 20 14:41:21 2018] WARNING: CPU: 1 PID: 2070 at
fs/xfs/xfs_message.c:105 asswarn+0x17/0x20
[Tue Mar 20 14:41:21 2018] CPU: 1 PID: 2070 Comm: async_8 Tainted:
G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4.14.26-gentoo #1
[Tue Mar 20 14:41:21 2018] Hardware name: Xen HVM domU, BIOS 4.9.1
01/25/2018
[Tue Mar 20 14:41:21 2018] task: ffff880147469980 task.stack:
ffffc90000fd8000
[Tue Mar 20 14:41:21 2018] RIP: 0010:asswarn+0x17/0x20
[Tue Mar 20 14:41:21 2018] RSP: 0018:ffffc90000fdb810 EFLAGS: 00010246
[Tue Mar 20 14:41:21 2018] RAX: 0000000000000000 RBX: ffff880012d34a50
RCX: 0000000000000000
[Tue Mar 20 14:41:21 2018] RDX: 00000000ffffffc0 RSI: 000000000000000a
RDI: ffffffff81d22af7
[Tue Mar 20 14:41:21 2018] RBP: ffffffffffffffff R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 14:41:21 2018] R10: 000000000000000a R11: f000000000000000
R12: ffff880148594000
[Tue Mar 20 14:41:21 2018] R13: 0000000000200007 R14: 00000000000fdfc0
R15: ffff880148594000
[Tue Mar 20 14:41:21 2018] FS:=C2=A0 00007f967ca55700(0000)
GS:ffff88014f480000(0000) knlGS:0000000000000000
[Tue Mar 20 14:41:21 2018] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
[Tue Mar 20 14:41:21 2018] CR2: 00007f327aa8fff0 CR3: 000000002d9ca000
CR4: 00000000000406e0
[Tue Mar 20 14:41:21 2018] Call Trace:
[Tue Mar 20 14:41:21 2018]=C2=A0 xfs_trans_mod_sb+0x226/0x2b0
[Tue Mar 20 14:41:21 2018]=C2=A0 xfs_alloc_ag_vextent+0x130/0x330
[Tue Mar 20 14:41:21 2018]=C2=A0 xfs_alloc_vextent+0x3ba/0x4b0
[Tue Mar 20 14:41:21 2018]=C2=A0 __xfs_inobt_alloc_block.isra.1+0x9f/0x13=
0
[Tue Mar 20 14:41:21 2018]=C2=A0 __xfs_btree_split+0xfd/0x5c0
[Tue Mar 20 14:41:21 2018]=C2=A0 ? xfs_trans_read_buf_map+0x265/0x2f0
[Tue Mar 20 14:41:21 2018]=C2=A0 ?
xfs_btree_read_buf_block.constprop.26+0xaf/0xf0
[Tue Mar 20 14:41:21 2018]=C2=A0 xfs_btree_split+0x66/0x110
[Tue Mar 20 14:41:21 2018]=C2=A0 xfs_btree_make_block_unfull+0x113/0x1d0
[Tue Mar 20 14:41:21 2018]=C2=A0 xfs_btree_insrec+0x419/0x500
[Tue Mar 20 14:41:21 2018]=C2=A0 xfs_btree_insert+0xe2/0x220
[Tue Mar 20 14:41:21 2018]=C2=A0 xfs_difree_finobt+0xd0/0x2d0
[Tue Mar 20 14:41:21 2018]=C2=A0 xfs_difree+0x162/0x220
[Tue Mar 20 14:41:21 2018]=C2=A0 xfs_ifree+0xd0/0x290
[Tue Mar 20 14:41:21 2018]=C2=A0 xfs_inactive_ifree+0xf6/0x290
[Tue Mar 20 14:41:21 2018]=C2=A0 xfs_inactive+0x112/0x2a0
[Tue Mar 20 14:41:21 2018]=C2=A0 xfs_fs_destroy_inode+0x82/0x1f0
[Tue Mar 20 14:41:21 2018]=C2=A0 do_unlinkat+0x1b9/0x320
[Tue Mar 20 14:41:21 2018]=C2=A0 do_syscall_64+0x87/0x330
[Tue Mar 20 14:41:21 2018]=C2=A0 ? schedule+0x2d/0x80
[Tue Mar 20 14:41:21 2018]=C2=A0 entry_SYSCALL_64_after_hwframe+0x3d/0xa2=

[Tue Mar 20 14:41:21 2018] RIP: 0033:0x7f96bd517967
[Tue Mar 20 14:41:21 2018] RSP: 002b:00007f967ca54e28 EFLAGS: 00000246
ORIG_RAX: 0000000000000057
[Tue Mar 20 14:41:21 2018] RAX: ffffffffffffffda RBX: 00007f967d081a8c
RCX: 00007f96bd517967
[Tue Mar 20 14:41:21 2018] RDX: 00007f967d081a20 RSI: 00007f967d081b48
RDI: 00007f967d081b48
[Tue Mar 20 14:41:21 2018] RBP: 00007f967ca54e90 R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 14:41:21 2018] R10: 0000000000000000 R11: 0000000000000246
R12: 00007f967d0819e0
[Tue Mar 20 14:41:21 2018] R13: 00007f967ca54e80 R14: 0000000000000000
R15: 00007f967cf00240
[Tue Mar 20 14:41:21 2018] Code: 10 e8 8e f9 ff ff 0f 0b e8 67 06 db ff
0f 1f 80 00 00 00 00 48 89 f1 41 89 d0 48 c7 c6 68 1f d5 81 48 89 fa 31
ff e8 a9 fc ff ff <0f> 0b c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7
c6 68 1f d5
[Tue Mar 20 14:41:21 2018] ---[ end trace 1d252f8e3d5494fe ]---
[Tue Mar 20 14:41:37 2018] XFS: Assertion failed: tp->t_blk_res_used <=3D=

tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
[Tue Mar 20 14:41:37 2018] ------------[ cut here ]------------
[Tue Mar 20 14:41:37 2018] WARNING: CPU: 0 PID: 2070 at
fs/xfs/xfs_message.c:105 asswarn+0x17/0x20
[Tue Mar 20 14:41:37 2018] CPU: 0 PID: 2070 Comm: async_8 Tainted:
G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4.14.26-gentoo #1
[Tue Mar 20 14:41:37 2018] Hardware name: Xen HVM domU, BIOS 4.9.1
01/25/2018
[Tue Mar 20 14:41:37 2018] task: ffff880147469980 task.stack:
ffffc90000fd8000
[Tue Mar 20 14:41:37 2018] RIP: 0010:asswarn+0x17/0x20
[Tue Mar 20 14:41:37 2018] RSP: 0018:ffffc90000fdb810 EFLAGS: 00010246
[Tue Mar 20 14:41:37 2018] RAX: 0000000000000000 RBX: ffff8800d3f84e10
RCX: 0000000000000000
[Tue Mar 20 14:41:37 2018] RDX: 00000000ffffffc0 RSI: 000000000000000a
RDI: ffffffff81d22af7
[Tue Mar 20 14:41:37 2018] RBP: ffffffffffffffff R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 14:41:37 2018] R10: 000000000000000a R11: f000000000000000
R12: ffff880148594000
[Tue Mar 20 14:41:37 2018] R13: 0000000000200007 R14: 00000000000fdfc0
R15: ffff880148594000
[Tue Mar 20 14:41:37 2018] FS:=C2=A0 00007f967ca55700(0000)
GS:ffff88014f400000(0000) knlGS:0000000000000000
[Tue Mar 20 14:41:37 2018] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
[Tue Mar 20 14:41:37 2018] CR2: 00007f327b71a010 CR3: 000000002d9ca000
CR4: 00000000000406f0
[Tue Mar 20 14:41:37 2018] Call Trace:
[Tue Mar 20 14:41:37 2018]=C2=A0 xfs_trans_mod_sb+0x226/0x2b0
[Tue Mar 20 14:41:37 2018]=C2=A0 xfs_alloc_ag_vextent+0x130/0x330
[Tue Mar 20 14:41:37 2018]=C2=A0 xfs_alloc_vextent+0x3ba/0x4b0
[Tue Mar 20 14:41:37 2018]=C2=A0 __xfs_inobt_alloc_block.isra.1+0x9f/0x13=
0
[Tue Mar 20 14:41:37 2018]=C2=A0 __xfs_btree_split+0xfd/0x5c0
[Tue Mar 20 14:41:37 2018]=C2=A0 ? xfs_trans_read_buf_map+0x265/0x2f0
[Tue Mar 20 14:41:37 2018]=C2=A0 ?
xfs_btree_read_buf_block.constprop.26+0xaf/0xf0
[Tue Mar 20 14:41:37 2018]=C2=A0 xfs_btree_split+0x66/0x110
[Tue Mar 20 14:41:37 2018]=C2=A0 xfs_btree_make_block_unfull+0x113/0x1d0
[Tue Mar 20 14:41:37 2018]=C2=A0 xfs_btree_insrec+0x419/0x500
[Tue Mar 20 14:41:37 2018]=C2=A0 xfs_btree_insert+0xe2/0x220
[Tue Mar 20 14:41:37 2018]=C2=A0 xfs_difree_finobt+0xd0/0x2d0
[Tue Mar 20 14:41:37 2018]=C2=A0 xfs_difree+0x162/0x220
[Tue Mar 20 14:41:37 2018]=C2=A0 xfs_ifree+0xd0/0x290
[Tue Mar 20 14:41:37 2018]=C2=A0 xfs_inactive_ifree+0xf6/0x290
[Tue Mar 20 14:41:37 2018]=C2=A0 xfs_inactive+0x112/0x2a0
[Tue Mar 20 14:41:37 2018]=C2=A0 xfs_fs_destroy_inode+0x82/0x1f0
[Tue Mar 20 14:41:37 2018]=C2=A0 do_unlinkat+0x1b9/0x320
[Tue Mar 20 14:41:37 2018]=C2=A0 do_syscall_64+0x87/0x330
[Tue Mar 20 14:41:37 2018]=C2=A0 ? schedule+0x2d/0x80
[Tue Mar 20 14:41:37 2018]=C2=A0 entry_SYSCALL_64_after_hwframe+0x3d/0xa2=

[Tue Mar 20 14:41:37 2018] RIP: 0033:0x7f96bd517967
[Tue Mar 20 14:41:37 2018] RSP: 002b:00007f967ca54e28 EFLAGS: 00000246
ORIG_RAX: 0000000000000057
[Tue Mar 20 14:41:37 2018] RAX: ffffffffffffffda RBX: 00007f967d081b0c
RCX: 00007f96bd517967
[Tue Mar 20 14:41:37 2018] RDX: 00007f967d081a20 RSI: 00007f967d081bc8
RDI: 00007f967d081bc8
[Tue Mar 20 14:41:37 2018] RBP: 00007f967ca54e90 R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 14:41:37 2018] R10: 0000000000000000 R11: 0000000000000246
R12: 00007f967d0819e0
[Tue Mar 20 14:41:37 2018] R13: 00007f967ca54e80 R14: 0000000000000000
R15: 00007f967cf00240
[Tue Mar 20 14:41:37 2018] Code: 10 e8 8e f9 ff ff 0f 0b e8 67 06 db ff
0f 1f 80 00 00 00 00 48 89 f1 41 89 d0 48 c7 c6 68 1f d5 81 48 89 fa 31
ff e8 a9 fc ff ff <0f> 0b c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7
c6 68 1f d5
[Tue Mar 20 14:41:37 2018] ---[ end trace 1d252f8e3d5494ff ]---
[Tue Mar 20 14:51:08 2018] XFS: Assertion failed: tp->t_blk_res_used <=3D=

tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
[Tue Mar 20 14:51:08 2018] ------------[ cut here ]------------
[Tue Mar 20 14:51:08 2018] WARNING: CPU: 2 PID: 12669 at
fs/xfs/xfs_message.c:105 asswarn+0x17/0x20
[Tue Mar 20 14:51:08 2018] CPU: 2 PID: 12669 Comm: async_8 Tainted:
G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4.14.26-gentoo #1
[Tue Mar 20 14:51:08 2018] Hardware name: Xen HVM domU, BIOS 4.9.1
01/25/2018
[Tue Mar 20 14:51:08 2018] task: ffff880003a0b300 task.stack:
ffffc9000aba8000
[Tue Mar 20 14:51:08 2018] RIP: 0010:asswarn+0x17/0x20
[Tue Mar 20 14:51:08 2018] RSP: 0018:ffffc9000abab810 EFLAGS: 00010246
[Tue Mar 20 14:51:08 2018] RAX: 0000000000000000 RBX: ffff880021bf7870
RCX: 0000000000000000
[Tue Mar 20 14:51:08 2018] RDX: 00000000ffffffc0 RSI: 000000000000000a
RDI: ffffffff81d22af7
[Tue Mar 20 14:51:08 2018] RBP: ffffffffffffffff R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 14:51:08 2018] R10: 000000000000000a R11: f000000000000000
R12: ffff880148594000
[Tue Mar 20 14:51:08 2018] R13: 0000000000100007 R14: 00000000000fdfc0
R15: ffff880148594000
[Tue Mar 20 14:51:08 2018] FS:=C2=A0 00007fa079755700(0000)
GS:ffff88014f500000(0000) knlGS:0000000000000000
[Tue Mar 20 14:51:08 2018] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
[Tue Mar 20 14:51:08 2018] CR2: 00007f85a92d3c50 CR3: 000000001b01c000
CR4: 00000000000406e0
[Tue Mar 20 14:51:08 2018] Call Trace:
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_trans_mod_sb+0x226/0x2b0
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_alloc_ag_vextent+0x130/0x330
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_alloc_vextent+0x3ba/0x4b0
[Tue Mar 20 14:51:08 2018]=C2=A0 ? kmem_zone_alloc+0x7e/0x100
[Tue Mar 20 14:51:08 2018]=C2=A0 __xfs_inobt_alloc_block.isra.1+0x9f/0x13=
0
[Tue Mar 20 14:51:08 2018]=C2=A0 __xfs_btree_split+0xfd/0x5c0
[Tue Mar 20 14:51:08 2018]=C2=A0 ? xfs_trans_read_buf_map+0x265/0x2f0
[Tue Mar 20 14:51:08 2018]=C2=A0 ?
xfs_btree_read_buf_block.constprop.26+0xaf/0xf0
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_btree_split+0x66/0x110
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_btree_make_block_unfull+0x113/0x1d0
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_btree_insrec+0x419/0x500
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_btree_insert+0xe2/0x220
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_difree_finobt+0xd0/0x2d0
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_difree+0x162/0x220
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_ifree+0xd0/0x290
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_inactive_ifree+0xf6/0x290
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_inactive+0x112/0x2a0
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_fs_destroy_inode+0x82/0x1f0
[Tue Mar 20 14:51:08 2018]=C2=A0 do_unlinkat+0x1b9/0x320
[Tue Mar 20 14:51:08 2018]=C2=A0 do_syscall_64+0x87/0x330
[Tue Mar 20 14:51:08 2018]=C2=A0 ? schedule+0x2d/0x80
[Tue Mar 20 14:51:08 2018]=C2=A0 entry_SYSCALL_64_after_hwframe+0x3d/0xa2=

[Tue Mar 20 14:51:08 2018] RIP: 0033:0x7fa0ba21f967
[Tue Mar 20 14:51:08 2018] RSP: 002b:00007fa079754e28 EFLAGS: 00000246
ORIG_RAX: 0000000000000057
[Tue Mar 20 14:51:08 2018] RAX: ffffffffffffffda RBX: 00007fa079d81a8c
RCX: 00007fa0ba21f967
[Tue Mar 20 14:51:08 2018] RDX: 00007fa079d81a20 RSI: 00007fa079d81b48
RDI: 00007fa079d81b48
[Tue Mar 20 14:51:08 2018] RBP: 00007fa079754e90 R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 14:51:08 2018] R10: 0000000000000000 R11: 0000000000000246
R12: 00007fa079d819e0
[Tue Mar 20 14:51:08 2018] R13: 00007fa079754e80 R14: 0000000000000000
R15: 00007fa079c00240
[Tue Mar 20 14:51:08 2018] Code: 10 e8 8e f9 ff ff 0f 0b e8 67 06 db ff
0f 1f 80 00 00 00 00 48 89 f1 41 89 d0 48 c7 c6 68 1f d5 81 48 89 fa 31
ff e8 a9 fc ff ff <0f> 0b c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7
c6 68 1f d5
[Tue Mar 20 14:51:08 2018] ---[ end trace 1d252f8e3d549500 ]---
[Tue Mar 20 14:51:08 2018] XFS: Assertion failed: tp->t_blk_res_used <=3D=

tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
[Tue Mar 20 14:51:08 2018] ------------[ cut here ]------------
[Tue Mar 20 14:51:08 2018] WARNING: CPU: 3 PID: 12669 at
fs/xfs/xfs_message.c:105 asswarn+0x17/0x20
[Tue Mar 20 14:51:08 2018] CPU: 3 PID: 12669 Comm: async_8 Tainted:
G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4.14.26-gentoo #1
[Tue Mar 20 14:51:08 2018] Hardware name: Xen HVM domU, BIOS 4.9.1
01/25/2018
[Tue Mar 20 14:51:08 2018] task: ffff880003a0b300 task.stack:
ffffc9000aba8000
[Tue Mar 20 14:51:08 2018] RIP: 0010:asswarn+0x17/0x20
[Tue Mar 20 14:51:08 2018] RSP: 0018:ffffc9000abab810 EFLAGS: 00010246
[Tue Mar 20 14:51:08 2018] RAX: 0000000000000000 RBX: ffff88013496bf00
RCX: 0000000000000000
[Tue Mar 20 14:51:08 2018] RDX: 00000000ffffffc0 RSI: 000000000000000a
RDI: ffffffff81d22af7
[Tue Mar 20 14:51:08 2018] RBP: ffffffffffffffff R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 14:51:08 2018] R10: 000000000000000a R11: f000000000000000
R12: ffff880148594000
[Tue Mar 20 14:51:08 2018] R13: 0000000000200007 R14: 00000000000fdfc0
R15: ffff880148594000
[Tue Mar 20 14:51:08 2018] FS:=C2=A0 00007fa079755700(0000)
GS:ffff88014f580000(0000) knlGS:0000000000000000
[Tue Mar 20 14:51:08 2018] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
[Tue Mar 20 14:51:08 2018] CR2: 000055c9b4898f50 CR3: 000000001b01c000
CR4: 00000000000406e0
[Tue Mar 20 14:51:08 2018] Call Trace:
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_trans_mod_sb+0x226/0x2b0
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_alloc_ag_vextent+0x130/0x330
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_alloc_vextent+0x3ba/0x4b0
[Tue Mar 20 14:51:08 2018]=C2=A0 __xfs_inobt_alloc_block.isra.1+0x9f/0x13=
0
[Tue Mar 20 14:51:08 2018]=C2=A0 __xfs_btree_split+0xfd/0x5c0
[Tue Mar 20 14:51:08 2018]=C2=A0 ? xfs_trans_read_buf_map+0x265/0x2f0
[Tue Mar 20 14:51:08 2018]=C2=A0 ?
xfs_btree_read_buf_block.constprop.26+0xaf/0xf0
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_btree_split+0x66/0x110
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_btree_make_block_unfull+0x113/0x1d0
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_btree_insrec+0x419/0x500
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_btree_insert+0xe2/0x220
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_difree_finobt+0xd0/0x2d0
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_difree+0x162/0x220
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_ifree+0xd0/0x290
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_inactive_ifree+0xf6/0x290
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_inactive+0x112/0x2a0
[Tue Mar 20 14:51:08 2018]=C2=A0 xfs_fs_destroy_inode+0x82/0x1f0
[Tue Mar 20 14:51:08 2018]=C2=A0 do_unlinkat+0x1b9/0x320
[Tue Mar 20 14:51:08 2018]=C2=A0 do_syscall_64+0x87/0x330
[Tue Mar 20 14:51:08 2018]=C2=A0 ? schedule+0x2d/0x80
[Tue Mar 20 14:51:08 2018]=C2=A0 entry_SYSCALL_64_after_hwframe+0x3d/0xa2=

[Tue Mar 20 14:51:08 2018] RIP: 0033:0x7fa0ba21f967
[Tue Mar 20 14:51:08 2018] RSP: 002b:00007fa079754e28 EFLAGS: 00000246
ORIG_RAX: 0000000000000057
[Tue Mar 20 14:51:08 2018] RAX: ffffffffffffffda RBX: 00007fa079d81a14
RCX: 00007fa0ba21f967
[Tue Mar 20 14:51:08 2018] RDX: 00007fa079d81b90 RSI: 00007fa079d81ad0
RDI: 00007fa079d81ad0
[Tue Mar 20 14:51:08 2018] RBP: 00007fa079754e90 R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 14:51:08 2018] R10: 0000000000000000 R11: 0000000000000246
R12: 00007fa079d81b50
[Tue Mar 20 14:51:08 2018] R13: 00007fa079754e80 R14: 0000000000000000
R15: 00007fa079c00240
[Tue Mar 20 14:51:08 2018] Code: 10 e8 8e f9 ff ff 0f 0b e8 67 06 db ff
0f 1f 80 00 00 00 00 48 89 f1 41 89 d0 48 c7 c6 68 1f d5 81 48 89 fa 31
ff e8 a9 fc ff ff <0f> 0b c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7
c6 68 1f d5
[Tue Mar 20 14:51:08 2018] ---[ end trace 1d252f8e3d549501 ]---
[Tue Mar 20 14:51:18 2018] XFS: Assertion failed: tp->t_blk_res_used <=3D=

tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
[Tue Mar 20 14:51:18 2018] ------------[ cut here ]------------
[Tue Mar 20 14:51:18 2018] WARNING: CPU: 0 PID: 12669 at
fs/xfs/xfs_message.c:105 asswarn+0x17/0x20
[Tue Mar 20 14:51:18 2018] CPU: 0 PID: 12669 Comm: async_8 Tainted:
G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4.14.26-gentoo #1
[Tue Mar 20 14:51:18 2018] Hardware name: Xen HVM domU, BIOS 4.9.1
01/25/2018
[Tue Mar 20 14:51:18 2018] task: ffff880003a0b300 task.stack:
ffffc9000aba8000
[Tue Mar 20 14:51:18 2018] RIP: 0010:asswarn+0x17/0x20
[Tue Mar 20 14:51:18 2018] RSP: 0018:ffffc9000abab810 EFLAGS: 00010246
[Tue Mar 20 14:51:18 2018] RAX: 0000000000000000 RBX: ffff8800d3f84b40
RCX: 0000000000000000
[Tue Mar 20 14:51:18 2018] RDX: 00000000ffffffc0 RSI: 000000000000000a
RDI: ffffffff81d22af7
[Tue Mar 20 14:51:18 2018] RBP: ffffffffffffffff R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 14:51:18 2018] R10: 000000000000000a R11: f000000000000000
R12: ffff880148594000
[Tue Mar 20 14:51:18 2018] R13: 0000000000100007 R14: 00000000000fdfc0
R15: ffff880148594000
[Tue Mar 20 14:51:18 2018] FS:=C2=A0 00007fa079755700(0000)
GS:ffff88014f400000(0000) knlGS:0000000000000000
[Tue Mar 20 14:51:18 2018] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
[Tue Mar 20 14:51:18 2018] CR2: 00007f327dbcb010 CR3: 000000001b01c000
CR4: 00000000000406f0
[Tue Mar 20 14:51:18 2018] Call Trace:
[Tue Mar 20 14:51:18 2018]=C2=A0 xfs_trans_mod_sb+0x226/0x2b0
[Tue Mar 20 14:51:18 2018]=C2=A0 xfs_alloc_ag_vextent+0x130/0x330
[Tue Mar 20 14:51:18 2018]=C2=A0 xfs_alloc_vextent+0x3ba/0x4b0
[Tue Mar 20 14:51:18 2018]=C2=A0 __xfs_inobt_alloc_block.isra.1+0x9f/0x13=
0
[Tue Mar 20 14:51:18 2018]=C2=A0 __xfs_btree_split+0xfd/0x5c0
[Tue Mar 20 14:51:18 2018]=C2=A0 ? xfs_trans_read_buf_map+0x265/0x2f0
[Tue Mar 20 14:51:18 2018]=C2=A0 ?
xfs_btree_read_buf_block.constprop.26+0xaf/0xf0
[Tue Mar 20 14:51:18 2018]=C2=A0 xfs_btree_split+0x66/0x110
[Tue Mar 20 14:51:18 2018]=C2=A0 xfs_btree_make_block_unfull+0x113/0x1d0
[Tue Mar 20 14:51:18 2018]=C2=A0 xfs_btree_insrec+0x419/0x500
[Tue Mar 20 14:51:18 2018]=C2=A0 xfs_btree_insert+0xe2/0x220
[Tue Mar 20 14:51:18 2018]=C2=A0 xfs_difree_finobt+0xd0/0x2d0
[Tue Mar 20 14:51:18 2018]=C2=A0 xfs_difree+0x162/0x220
[Tue Mar 20 14:51:18 2018]=C2=A0 xfs_ifree+0xd0/0x290
[Tue Mar 20 14:51:18 2018]=C2=A0 xfs_inactive_ifree+0xf6/0x290
[Tue Mar 20 14:51:18 2018]=C2=A0 xfs_inactive+0x112/0x2a0
[Tue Mar 20 14:51:18 2018]=C2=A0 xfs_fs_destroy_inode+0x82/0x1f0
[Tue Mar 20 14:51:18 2018]=C2=A0 do_unlinkat+0x1b9/0x320
[Tue Mar 20 14:51:18 2018]=C2=A0 do_syscall_64+0x87/0x330
[Tue Mar 20 14:51:18 2018]=C2=A0 ? schedule+0x2d/0x80
[Tue Mar 20 14:51:18 2018]=C2=A0 entry_SYSCALL_64_after_hwframe+0x3d/0xa2=

[Tue Mar 20 14:51:18 2018] RIP: 0033:0x7fa0ba21f967
[Tue Mar 20 14:51:18 2018] RSP: 002b:00007fa079754e28 EFLAGS: 00000246
ORIG_RAX: 0000000000000057
[Tue Mar 20 14:51:18 2018] RAX: ffffffffffffffda RBX: 00007fa079d81a14
RCX: 00007fa0ba21f967
[Tue Mar 20 14:51:18 2018] RDX: 00007fa079d81b90 RSI: 00007fa079d81ad0
RDI: 00007fa079d81ad0
[Tue Mar 20 14:51:18 2018] RBP: 00007fa079754e90 R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 14:51:18 2018] R10: 0000000000000000 R11: 0000000000000246
R12: 00007fa079d81b50
[Tue Mar 20 14:51:18 2018] R13: 00007fa079754e80 R14: 0000000000000000
R15: 00007fa079c00240
[Tue Mar 20 14:51:18 2018] Code: 10 e8 8e f9 ff ff 0f 0b e8 67 06 db ff
0f 1f 80 00 00 00 00 48 89 f1 41 89 d0 48 c7 c6 68 1f d5 81 48 89 fa 31
ff e8 a9 fc ff ff <0f> 0b c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7
c6 68 1f d5
[Tue Mar 20 14:51:18 2018] ---[ end trace 1d252f8e3d549502 ]---
[Tue Mar 20 14:51:34 2018] XFS: Assertion failed: tp->t_blk_res_used <=3D=

tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
[Tue Mar 20 14:51:34 2018] ------------[ cut here ]------------
[Tue Mar 20 14:51:34 2018] WARNING: CPU: 2 PID: 12669 at
fs/xfs/xfs_message.c:105 asswarn+0x17/0x20
[Tue Mar 20 14:51:34 2018] CPU: 2 PID: 12669 Comm: async_8 Tainted:
G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4.14.26-gentoo #1
[Tue Mar 20 14:51:34 2018] Hardware name: Xen HVM domU, BIOS 4.9.1
01/25/2018
[Tue Mar 20 14:51:34 2018] task: ffff880003a0b300 task.stack:
ffffc9000aba8000
[Tue Mar 20 14:51:34 2018] RIP: 0010:asswarn+0x17/0x20
[Tue Mar 20 14:51:34 2018] RSP: 0018:ffffc9000abab810 EFLAGS: 00010246
[Tue Mar 20 14:51:34 2018] RAX: 0000000000000000 RBX: ffff880021bf7780
RCX: 0000000000000000
[Tue Mar 20 14:51:34 2018] RDX: 00000000ffffffc0 RSI: 000000000000000a
RDI: ffffffff81d22af7
[Tue Mar 20 14:51:34 2018] RBP: ffffffffffffffff R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 14:51:34 2018] R10: 000000000000000a R11: f000000000000000
R12: ffff880148594000
[Tue Mar 20 14:51:34 2018] R13: 0000000000100007 R14: 00000000000fdfc0
R15: ffff880148594000
[Tue Mar 20 14:51:34 2018] FS:=C2=A0 00007fa079755700(0000)
GS:ffff88014f500000(0000) knlGS:0000000000000000
[Tue Mar 20 14:51:34 2018] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
[Tue Mar 20 14:51:34 2018] CR2: 00007f327bd7dff0 CR3: 000000001b01c000
CR4: 00000000000406e0
[Tue Mar 20 14:51:34 2018] Call Trace:
[Tue Mar 20 14:51:34 2018]=C2=A0 xfs_trans_mod_sb+0x226/0x2b0
[Tue Mar 20 14:51:34 2018]=C2=A0 xfs_alloc_ag_vextent+0x130/0x330
[Tue Mar 20 14:51:34 2018]=C2=A0 xfs_alloc_vextent+0x3ba/0x4b0
[Tue Mar 20 14:51:34 2018]=C2=A0 __xfs_inobt_alloc_block.isra.1+0x9f/0x13=
0
[Tue Mar 20 14:51:34 2018]=C2=A0 __xfs_btree_split+0xfd/0x5c0
[Tue Mar 20 14:51:34 2018]=C2=A0 ? xfs_trans_read_buf_map+0x265/0x2f0
[Tue Mar 20 14:51:34 2018]=C2=A0 ?
xfs_btree_read_buf_block.constprop.26+0xaf/0xf0
[Tue Mar 20 14:51:34 2018]=C2=A0 xfs_btree_split+0x66/0x110
[Tue Mar 20 14:51:34 2018]=C2=A0 xfs_btree_make_block_unfull+0x113/0x1d0
[Tue Mar 20 14:51:34 2018]=C2=A0 xfs_btree_insrec+0x419/0x500
[Tue Mar 20 14:51:34 2018]=C2=A0 xfs_btree_insert+0xe2/0x220
[Tue Mar 20 14:51:34 2018]=C2=A0 xfs_difree_finobt+0xd0/0x2d0
[Tue Mar 20 14:51:34 2018]=C2=A0 xfs_difree+0x162/0x220
[Tue Mar 20 14:51:34 2018]=C2=A0 xfs_ifree+0xd0/0x290
[Tue Mar 20 14:51:34 2018]=C2=A0 xfs_inactive_ifree+0xf6/0x290
[Tue Mar 20 14:51:34 2018]=C2=A0 xfs_inactive+0x112/0x2a0
[Tue Mar 20 14:51:34 2018]=C2=A0 xfs_fs_destroy_inode+0x82/0x1f0
[Tue Mar 20 14:51:34 2018]=C2=A0 do_unlinkat+0x1b9/0x320
[Tue Mar 20 14:51:34 2018]=C2=A0 do_syscall_64+0x87/0x330
[Tue Mar 20 14:51:34 2018]=C2=A0 ? schedule+0x2d/0x80
[Tue Mar 20 14:51:34 2018]=C2=A0 entry_SYSCALL_64_after_hwframe+0x3d/0xa2=

[Tue Mar 20 14:51:34 2018] RIP: 0033:0x7fa0ba21f967
[Tue Mar 20 14:51:34 2018] RSP: 002b:00007fa079754e28 EFLAGS: 00000246
ORIG_RAX: 0000000000000057
[Tue Mar 20 14:51:34 2018] RAX: ffffffffffffffda RBX: 00007fa079d81a14
RCX: 00007fa0ba21f967
[Tue Mar 20 14:51:34 2018] RDX: 00007fa079d81b78 RSI: 00007fa079d81ad0
RDI: 00007fa079d81ad0
[Tue Mar 20 14:51:34 2018] RBP: 00007fa079754e90 R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 14:51:34 2018] R10: 0000000000000000 R11: 0000000000000246
R12: 00007fa079d81b38
[Tue Mar 20 14:51:34 2018] R13: 00007fa079754e80 R14: 0000000000000000
R15: 00007fa079c00240
[Tue Mar 20 14:51:34 2018] Code: 10 e8 8e f9 ff ff 0f 0b e8 67 06 db ff
0f 1f 80 00 00 00 00 48 89 f1 41 89 d0 48 c7 c6 68 1f d5 81 48 89 fa 31
ff e8 a9 fc ff ff <0f> 0b c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7
c6 68 1f d5
[Tue Mar 20 14:51:34 2018] ---[ end trace 1d252f8e3d549503 ]---
[Tue Mar 20 15:01:12 2018] XFS: Assertion failed: tp->t_blk_res_used <=3D=

tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
[Tue Mar 20 15:01:12 2018] ------------[ cut here ]------------
[Tue Mar 20 15:01:12 2018] WARNING: CPU: 0 PID: 16438 at
fs/xfs/xfs_message.c:105 asswarn+0x17/0x20
[Tue Mar 20 15:01:12 2018] CPU: 0 PID: 16438 Comm: async_8 Tainted:
G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4.14.26-gentoo #1
[Tue Mar 20 15:01:12 2018] Hardware name: Xen HVM domU, BIOS 4.9.1
01/25/2018
[Tue Mar 20 15:01:12 2018] task: ffff8800193872c0 task.stack:
ffffc90009018000
[Tue Mar 20 15:01:12 2018] RIP: 0010:asswarn+0x17/0x20
[Tue Mar 20 15:01:12 2018] RSP: 0018:ffffc9000901b810 EFLAGS: 00010246
[Tue Mar 20 15:01:12 2018] RAX: 0000000000000000 RBX: ffff880019185f00
RCX: 0000000000000000
[Tue Mar 20 15:01:12 2018] RDX: 00000000ffffffc0 RSI: 000000000000000a
RDI: ffffffff81d22af7
[Tue Mar 20 15:01:12 2018] RBP: ffffffffffffffff R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 15:01:12 2018] R10: 000000000000000a R11: f000000000000000
R12: ffff880148594000
[Tue Mar 20 15:01:12 2018] R13: 0000000000100007 R14: 00000000000fdfc0
R15: ffff880148594000
[Tue Mar 20 15:01:12 2018] FS:=C2=A0 00007fa77b477700(0000)
GS:ffff88014f400000(0000) knlGS:0000000000000000
[Tue Mar 20 15:01:12 2018] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
[Tue Mar 20 15:01:12 2018] CR2: 00007f32806c6010 CR3: 0000000007d3e000
CR4: 00000000000406f0
[Tue Mar 20 15:01:12 2018] Call Trace:
[Tue Mar 20 15:01:12 2018]=C2=A0 xfs_trans_mod_sb+0x226/0x2b0
[Tue Mar 20 15:01:12 2018]=C2=A0 xfs_alloc_ag_vextent+0x130/0x330
[Tue Mar 20 15:01:12 2018]=C2=A0 xfs_alloc_vextent+0x3ba/0x4b0
[Tue Mar 20 15:01:12 2018]=C2=A0 __xfs_inobt_alloc_block.isra.1+0x9f/0x13=
0
[Tue Mar 20 15:01:12 2018]=C2=A0 __xfs_btree_split+0xfd/0x5c0
[Tue Mar 20 15:01:12 2018]=C2=A0 ? xfs_trans_read_buf_map+0x265/0x2f0
[Tue Mar 20 15:01:12 2018]=C2=A0 ?
xfs_btree_read_buf_block.constprop.26+0xaf/0xf0
[Tue Mar 20 15:01:12 2018]=C2=A0 xfs_btree_split+0x66/0x110
[Tue Mar 20 15:01:12 2018]=C2=A0 xfs_btree_make_block_unfull+0x113/0x1d0
[Tue Mar 20 15:01:12 2018]=C2=A0 xfs_btree_insrec+0x419/0x500
[Tue Mar 20 15:01:12 2018]=C2=A0 xfs_btree_insert+0xe2/0x220
[Tue Mar 20 15:01:12 2018]=C2=A0 xfs_difree_finobt+0xd0/0x2d0
[Tue Mar 20 15:01:12 2018]=C2=A0 xfs_difree+0x162/0x220
[Tue Mar 20 15:01:12 2018]=C2=A0 xfs_ifree+0xd0/0x290
[Tue Mar 20 15:01:12 2018]=C2=A0 xfs_inactive_ifree+0xf6/0x290
[Tue Mar 20 15:01:12 2018]=C2=A0 xfs_inactive+0x112/0x2a0
[Tue Mar 20 15:01:12 2018]=C2=A0 xfs_fs_destroy_inode+0x82/0x1f0
[Tue Mar 20 15:01:12 2018]=C2=A0 do_unlinkat+0x1b9/0x320
[Tue Mar 20 15:01:12 2018]=C2=A0 do_syscall_64+0x87/0x330
[Tue Mar 20 15:01:12 2018]=C2=A0 ? schedule+0x2d/0x80
[Tue Mar 20 15:01:12 2018]=C2=A0 entry_SYSCALL_64_after_hwframe+0x3d/0xa2=

[Tue Mar 20 15:01:12 2018] RIP: 0033:0x7fa7bbf47967
[Tue Mar 20 15:01:12 2018] RSP: 002b:00007fa77b476e28 EFLAGS: 00000246
ORIG_RAX: 0000000000000057
[Tue Mar 20 15:01:12 2018] RAX: ffffffffffffffda RBX: 00007fa77bac1a14
RCX: 00007fa7bbf47967
[Tue Mar 20 15:01:12 2018] RDX: 00007fa77bac1b90 RSI: 00007fa77bac1ad0
RDI: 00007fa77bac1ad0
[Tue Mar 20 15:01:12 2018] RBP: 00007fa77b476e90 R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 15:01:12 2018] R10: 0000000000000000 R11: 0000000000000246
R12: 00007fa77bac1b50
[Tue Mar 20 15:01:12 2018] R13: 00007fa77b476e80 R14: 0000000000000000
R15: 00007fa77b900240
[Tue Mar 20 15:01:12 2018] Code: 10 e8 8e f9 ff ff 0f 0b e8 67 06 db ff
0f 1f 80 00 00 00 00 48 89 f1 41 89 d0 48 c7 c6 68 1f d5 81 48 89 fa 31
ff e8 a9 fc ff ff <0f> 0b c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7
c6 68 1f d5
[Tue Mar 20 15:01:12 2018] ---[ end trace 1d252f8e3d549504 ]---
[Tue Mar 20 15:01:37 2018] XFS: Assertion failed: tp->t_blk_res_used <=3D=

tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
[Tue Mar 20 15:01:37 2018] ------------[ cut here ]------------
[Tue Mar 20 15:01:37 2018] WARNING: CPU: 3 PID: 16438 at
fs/xfs/xfs_message.c:105 asswarn+0x17/0x20
[Tue Mar 20 15:01:37 2018] CPU: 3 PID: 16438 Comm: async_8 Tainted:
G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4.14.26-gentoo #1
[Tue Mar 20 15:01:37 2018] Hardware name: Xen HVM domU, BIOS 4.9.1
01/25/2018
[Tue Mar 20 15:01:37 2018] task: ffff8800193872c0 task.stack:
ffffc90009018000
[Tue Mar 20 15:01:37 2018] RIP: 0010:asswarn+0x17/0x20
[Tue Mar 20 15:01:37 2018] RSP: 0018:ffffc9000901b810 EFLAGS: 00010246
[Tue Mar 20 15:01:37 2018] RAX: 0000000000000000 RBX: ffff88002b3e9960
RCX: 0000000000000000
[Tue Mar 20 15:01:37 2018] RDX: 00000000ffffffc0 RSI: 000000000000000a
RDI: ffffffff81d22af7
[Tue Mar 20 15:01:37 2018] RBP: ffffffffffffffff R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 15:01:37 2018] R10: 000000000000000a R11: f000000000000000
R12: ffff880148594000
[Tue Mar 20 15:01:37 2018] R13: 0000000000000007 R14: 00000000000fdfc0
R15: ffff880148594000
[Tue Mar 20 15:01:37 2018] FS:=C2=A0 00007fa77b477700(0000)
GS:ffff88014f580000(0000) knlGS:0000000000000000
[Tue Mar 20 15:01:37 2018] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
[Tue Mar 20 15:01:37 2018] CR2: 00007f327c8b0ff0 CR3: 0000000007d3e000
CR4: 00000000000406e0
[Tue Mar 20 15:01:37 2018] Call Trace:
[Tue Mar 20 15:01:37 2018]=C2=A0 xfs_trans_mod_sb+0x226/0x2b0
[Tue Mar 20 15:01:37 2018]=C2=A0 xfs_alloc_ag_vextent+0x130/0x330
[Tue Mar 20 15:01:37 2018]=C2=A0 xfs_alloc_vextent+0x3ba/0x4b0
[Tue Mar 20 15:01:37 2018]=C2=A0 __xfs_inobt_alloc_block.isra.1+0x9f/0x13=
0
[Tue Mar 20 15:01:37 2018]=C2=A0 __xfs_btree_split+0xfd/0x5c0
[Tue Mar 20 15:01:37 2018]=C2=A0 ? xfs_trans_read_buf_map+0x265/0x2f0
[Tue Mar 20 15:01:37 2018]=C2=A0 ?
xfs_btree_read_buf_block.constprop.26+0xaf/0xf0
[Tue Mar 20 15:01:37 2018]=C2=A0 xfs_btree_split+0x66/0x110
[Tue Mar 20 15:01:37 2018]=C2=A0 xfs_btree_make_block_unfull+0x113/0x1d0
[Tue Mar 20 15:01:37 2018]=C2=A0 xfs_btree_insrec+0x419/0x500
[Tue Mar 20 15:01:37 2018]=C2=A0 xfs_btree_insert+0xe2/0x220
[Tue Mar 20 15:01:37 2018]=C2=A0 xfs_difree_finobt+0xd0/0x2d0
[Tue Mar 20 15:01:37 2018]=C2=A0 xfs_difree+0x162/0x220
[Tue Mar 20 15:01:37 2018]=C2=A0 xfs_ifree+0xd0/0x290
[Tue Mar 20 15:01:37 2018]=C2=A0 xfs_inactive_ifree+0xf6/0x290
[Tue Mar 20 15:01:37 2018]=C2=A0 xfs_inactive+0x112/0x2a0
[Tue Mar 20 15:01:37 2018]=C2=A0 xfs_fs_destroy_inode+0x82/0x1f0
[Tue Mar 20 15:01:37 2018]=C2=A0 do_unlinkat+0x1b9/0x320
[Tue Mar 20 15:01:37 2018]=C2=A0 do_syscall_64+0x87/0x330
[Tue Mar 20 15:01:37 2018]=C2=A0 ? schedule+0x2d/0x80
[Tue Mar 20 15:01:37 2018]=C2=A0 entry_SYSCALL_64_after_hwframe+0x3d/0xa2=

[Tue Mar 20 15:01:37 2018] RIP: 0033:0x7fa7bbf47967
[Tue Mar 20 15:01:37 2018] RSP: 002b:00007fa77b476e28 EFLAGS: 00000246
ORIG_RAX: 0000000000000057
[Tue Mar 20 15:01:37 2018] RAX: ffffffffffffffda RBX: 00007fa77bac1a14
RCX: 00007fa7bbf47967
[Tue Mar 20 15:01:37 2018] RDX: 00007fa77bac1b78 RSI: 00007fa77bac1ad0
RDI: 00007fa77bac1ad0
[Tue Mar 20 15:01:37 2018] RBP: 00007fa77b476e90 R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 15:01:37 2018] R10: 0000000000000000 R11: 0000000000000246
R12: 00007fa77bac1b38
[Tue Mar 20 15:01:37 2018] R13: 00007fa77b476e80 R14: 0000000000000000
R15: 00007fa77b900240
[Tue Mar 20 15:01:37 2018] Code: 10 e8 8e f9 ff ff 0f 0b e8 67 06 db ff
0f 1f 80 00 00 00 00 48 89 f1 41 89 d0 48 c7 c6 68 1f d5 81 48 89 fa 31
ff e8 a9 fc ff ff <0f> 0b c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7
c6 68 1f d5
[Tue Mar 20 15:01:37 2018] ---[ end trace 1d252f8e3d549505 ]---
[Tue Mar 20 15:12:49 2018] XFS: Assertion failed: tp->t_blk_res_used <=3D=

tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
[Tue Mar 20 15:12:49 2018] ------------[ cut here ]------------
[Tue Mar 20 15:12:49 2018] WARNING: CPU: 2 PID: 15167 at
fs/xfs/xfs_message.c:105 asswarn+0x17/0x20
[Tue Mar 20 15:12:49 2018] CPU: 2 PID: 15167 Comm: async_8 Tainted:
G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4.14.26-gentoo #1
[Tue Mar 20 15:12:49 2018] Hardware name: Xen HVM domU, BIOS 4.9.1
01/25/2018
[Tue Mar 20 15:12:49 2018] task: ffff880017cf8cc0 task.stack:
ffffc900023c0000
[Tue Mar 20 15:12:49 2018] RIP: 0010:asswarn+0x17/0x20
[Tue Mar 20 15:12:49 2018] RSP: 0018:ffffc900023c3810 EFLAGS: 00010246
[Tue Mar 20 15:12:49 2018] RAX: 0000000000000000 RBX: ffff88001de982d0
RCX: 0000000000000000
[Tue Mar 20 15:12:49 2018] RDX: 00000000ffffffc0 RSI: 000000000000000a
RDI: ffffffff81d22af7
[Tue Mar 20 15:12:49 2018] RBP: ffffffffffffffff R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 15:12:49 2018] R10: 000000000000000a R11: f000000000000000
R12: ffff880148594000
[Tue Mar 20 15:12:49 2018] R13: 0000000000200007 R14: 00000000000fdfc0
R15: ffff880148594000
[Tue Mar 20 15:12:49 2018] FS:=C2=A0 00007f18d0a77700(0000)
GS:ffff88014f500000(0000) knlGS:0000000000000000
[Tue Mar 20 15:12:49 2018] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
[Tue Mar 20 15:12:49 2018] CR2: 00007f18a399c000 CR3: 00000000e4c8e000
CR4: 00000000000406e0
[Tue Mar 20 15:12:49 2018] Call Trace:
[Tue Mar 20 15:12:49 2018]=C2=A0 xfs_trans_mod_sb+0x226/0x2b0
[Tue Mar 20 15:12:49 2018]=C2=A0 xfs_alloc_ag_vextent+0x130/0x330
[Tue Mar 20 15:12:49 2018]=C2=A0 xfs_alloc_vextent+0x3ba/0x4b0
[Tue Mar 20 15:12:49 2018]=C2=A0 __xfs_inobt_alloc_block.isra.1+0x9f/0x13=
0
[Tue Mar 20 15:12:49 2018]=C2=A0 __xfs_btree_split+0xfd/0x5c0
[Tue Mar 20 15:12:49 2018]=C2=A0 ? xfs_trans_read_buf_map+0x265/0x2f0
[Tue Mar 20 15:12:49 2018]=C2=A0 ?
xfs_btree_read_buf_block.constprop.26+0xaf/0xf0
[Tue Mar 20 15:12:49 2018]=C2=A0 xfs_btree_split+0x66/0x110
[Tue Mar 20 15:12:49 2018]=C2=A0 xfs_btree_make_block_unfull+0x113/0x1d0
[Tue Mar 20 15:12:49 2018]=C2=A0 xfs_btree_insrec+0x419/0x500
[Tue Mar 20 15:12:49 2018]=C2=A0 xfs_btree_insert+0xe2/0x220
[Tue Mar 20 15:12:49 2018]=C2=A0 xfs_difree_finobt+0xd0/0x2d0
[Tue Mar 20 15:12:49 2018]=C2=A0 xfs_difree+0x162/0x220
[Tue Mar 20 15:12:49 2018]=C2=A0 xfs_ifree+0xd0/0x290
[Tue Mar 20 15:12:49 2018]=C2=A0 xfs_inactive_ifree+0xf6/0x290
[Tue Mar 20 15:12:49 2018]=C2=A0 xfs_inactive+0x112/0x2a0
[Tue Mar 20 15:12:49 2018]=C2=A0 xfs_fs_destroy_inode+0x82/0x1f0
[Tue Mar 20 15:12:49 2018]=C2=A0 do_unlinkat+0x1b9/0x320
[Tue Mar 20 15:12:49 2018]=C2=A0 do_syscall_64+0x87/0x330
[Tue Mar 20 15:12:49 2018]=C2=A0 ? schedule+0x2d/0x80
[Tue Mar 20 15:12:49 2018]=C2=A0 entry_SYSCALL_64_after_hwframe+0x3d/0xa2=

[Tue Mar 20 15:12:49 2018] RIP: 0033:0x7f191153f967
[Tue Mar 20 15:12:49 2018] RSP: 002b:00007f18d0a76e28 EFLAGS: 00000246
ORIG_RAX: 0000000000000057
[Tue Mar 20 15:12:49 2018] RAX: ffffffffffffffda RBX: 00007f18d10c1a8c
RCX: 00007f191153f967
[Tue Mar 20 15:12:49 2018] RDX: 00007f18d10c1a20 RSI: 00007f18d10c1b48
RDI: 00007f18d10c1b48
[Tue Mar 20 15:12:49 2018] RBP: 00007f18d0a76e90 R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 15:12:49 2018] R10: 0000000000000000 R11: 0000000000000246
R12: 00007f18d10c19e0
[Tue Mar 20 15:12:49 2018] R13: 00007f18d0a76e80 R14: 0000000000000000
R15: 00007f18d0f00240
[Tue Mar 20 15:12:49 2018] Code: 10 e8 8e f9 ff ff 0f 0b e8 67 06 db ff
0f 1f 80 00 00 00 00 48 89 f1 41 89 d0 48 c7 c6 68 1f d5 81 48 89 fa 31
ff e8 a9 fc ff ff <0f> 0b c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7
c6 68 1f d5
[Tue Mar 20 15:12:49 2018] ---[ end trace 1d252f8e3d549506 ]---
[Tue Mar 20 15:13:04 2018] XFS: Assertion failed: tp->t_blk_res_used <=3D=

tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
[Tue Mar 20 15:13:04 2018] ------------[ cut here ]------------
[Tue Mar 20 15:13:04 2018] WARNING: CPU: 0 PID: 15167 at
fs/xfs/xfs_message.c:105 asswarn+0x17/0x20
[Tue Mar 20 15:13:04 2018] CPU: 0 PID: 15167 Comm: async_8 Tainted:
G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4.14.26-gentoo #1
[Tue Mar 20 15:13:04 2018] Hardware name: Xen HVM domU, BIOS 4.9.1
01/25/2018
[Tue Mar 20 15:13:04 2018] task: ffff880017cf8cc0 task.stack:
ffffc900023c0000
[Tue Mar 20 15:13:04 2018] RIP: 0010:asswarn+0x17/0x20
[Tue Mar 20 15:13:04 2018] RSP: 0018:ffffc900023c3810 EFLAGS: 00010246
[Tue Mar 20 15:13:04 2018] RAX: 0000000000000000 RBX: ffff88000d509780
RCX: 0000000000000000
[Tue Mar 20 15:13:04 2018] RDX: 00000000ffffffc0 RSI: 000000000000000a
RDI: ffffffff81d22af7
[Tue Mar 20 15:13:04 2018] RBP: ffffffffffffffff R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 15:13:04 2018] R10: 000000000000000a R11: f000000000000000
R12: ffff880148594000
[Tue Mar 20 15:13:04 2018] R13: 0000000000300044 R14: 00000000000fdfc0
R15: ffff880148594000
[Tue Mar 20 15:13:04 2018] FS:=C2=A0 00007f18d0a77700(0000)
GS:ffff88014f400000(0000) knlGS:0000000000000000
[Tue Mar 20 15:13:04 2018] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
[Tue Mar 20 15:13:04 2018] CR2: 00007f18a1867000 CR3: 00000000e4c8e000
CR4: 00000000000406f0
[Tue Mar 20 15:13:04 2018] Call Trace:
[Tue Mar 20 15:13:04 2018]=C2=A0 xfs_trans_mod_sb+0x226/0x2b0
[Tue Mar 20 15:13:04 2018]=C2=A0 xfs_alloc_ag_vextent+0x130/0x330
[Tue Mar 20 15:13:04 2018]=C2=A0 xfs_alloc_vextent+0x3ba/0x4b0
[Tue Mar 20 15:13:04 2018]=C2=A0 __xfs_inobt_alloc_block.isra.1+0x9f/0x13=
0
[Tue Mar 20 15:13:04 2018]=C2=A0 ? _xfs_buf_find+0x308/0x5e0
[Tue Mar 20 15:13:04 2018]=C2=A0 __xfs_btree_split+0xfd/0x5c0
[Tue Mar 20 15:13:04 2018]=C2=A0 ? xfs_trans_read_buf_map+0x265/0x2f0
[Tue Mar 20 15:13:04 2018]=C2=A0 xfs_btree_split+0x66/0x110
[Tue Mar 20 15:13:04 2018]=C2=A0 xfs_btree_make_block_unfull+0x113/0x1d0
[Tue Mar 20 15:13:04 2018]=C2=A0 xfs_btree_insrec+0x419/0x500
[Tue Mar 20 15:13:04 2018]=C2=A0 xfs_btree_insert+0xe2/0x220
[Tue Mar 20 15:13:04 2018]=C2=A0 xfs_difree_finobt+0xd0/0x2d0
[Tue Mar 20 15:13:04 2018]=C2=A0 xfs_difree+0x162/0x220
[Tue Mar 20 15:13:04 2018]=C2=A0 xfs_ifree+0xd0/0x290
[Tue Mar 20 15:13:04 2018]=C2=A0 xfs_inactive_ifree+0xf6/0x290
[Tue Mar 20 15:13:04 2018]=C2=A0 xfs_inactive+0x112/0x2a0
[Tue Mar 20 15:13:04 2018]=C2=A0 xfs_fs_destroy_inode+0x82/0x1f0
[Tue Mar 20 15:13:04 2018]=C2=A0 do_unlinkat+0x1b9/0x320
[Tue Mar 20 15:13:04 2018]=C2=A0 do_syscall_64+0x87/0x330
[Tue Mar 20 15:13:04 2018]=C2=A0 ? schedule+0x2d/0x80
[Tue Mar 20 15:13:04 2018]=C2=A0 entry_SYSCALL_64_after_hwframe+0x3d/0xa2=

[Tue Mar 20 15:13:04 2018] RIP: 0033:0x7f191153f967
[Tue Mar 20 15:13:04 2018] RSP: 002b:00007f18d0a76e28 EFLAGS: 00000246
ORIG_RAX: 0000000000000057
[Tue Mar 20 15:13:04 2018] RAX: ffffffffffffffda RBX: 00007f18d10c1a14
RCX: 00007f191153f967
[Tue Mar 20 15:13:04 2018] RDX: 00007f18d10c1b70 RSI: 00007f18d10c1ad0
RDI: 00007f18d10c1ad0
[Tue Mar 20 15:13:04 2018] RBP: 00007f18d0a76e90 R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 15:13:04 2018] R10: 0000000000000000 R11: 0000000000000246
R12: 00007f18d10c1b30
[Tue Mar 20 15:13:04 2018] R13: 00007f18d0a76e80 R14: 0000000000000000
R15: 00007f18d0f00240
[Tue Mar 20 15:13:04 2018] Code: 10 e8 8e f9 ff ff 0f 0b e8 67 06 db ff
0f 1f 80 00 00 00 00 48 89 f1 41 89 d0 48 c7 c6 68 1f d5 81 48 89 fa 31
ff e8 a9 fc ff ff <0f> 0b c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7
c6 68 1f d5
[Tue Mar 20 15:13:04 2018] ---[ end trace 1d252f8e3d549507 ]---
[Tue Mar 20 15:21:18 2018] XFS: Assertion failed: tp->t_blk_res_used <=3D=

tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
[Tue Mar 20 15:21:18 2018] ------------[ cut here ]------------
[Tue Mar 20 15:21:18 2018] WARNING: CPU: 2 PID: 7041 at
fs/xfs/xfs_message.c:105 asswarn+0x17/0x20
[Tue Mar 20 15:21:18 2018] CPU: 2 PID: 7041 Comm: async_8 Tainted:
G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4.14.26-gentoo #1
[Tue Mar 20 15:21:18 2018] Hardware name: Xen HVM domU, BIOS 4.9.1
01/25/2018
[Tue Mar 20 15:21:18 2018] task: ffff880026e83300 task.stack:
ffffc90001190000
[Tue Mar 20 15:21:18 2018] RIP: 0010:asswarn+0x17/0x20
[Tue Mar 20 15:21:18 2018] RSP: 0018:ffffc90001193810 EFLAGS: 00010246
[Tue Mar 20 15:21:18 2018] RAX: 0000000000000000 RBX: ffff8800436951e0
RCX: 0000000000000000
[Tue Mar 20 15:21:18 2018] RDX: 00000000ffffffc0 RSI: 000000000000000a
RDI: ffffffff81d22af7
[Tue Mar 20 15:21:18 2018] RBP: ffffffffffffffff R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 15:21:18 2018] R10: 000000000000000a R11: f000000000000000
R12: ffff880148594000
[Tue Mar 20 15:21:18 2018] R13: 0000000000200007 R14: 00000000000fdfc0
R15: ffff880148594000
[Tue Mar 20 15:21:18 2018] FS:=C2=A0 00007f699af37700(0000)
GS:ffff88014f500000(0000) knlGS:0000000000000000
[Tue Mar 20 15:21:18 2018] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
[Tue Mar 20 15:21:18 2018] CR2: 00007f327d33aff0 CR3: 00000000020be000
CR4: 00000000000406e0
[Tue Mar 20 15:21:18 2018] Call Trace:
[Tue Mar 20 15:21:18 2018]=C2=A0 xfs_trans_mod_sb+0x226/0x2b0
[Tue Mar 20 15:21:18 2018]=C2=A0 xfs_alloc_ag_vextent+0x130/0x330
[Tue Mar 20 15:21:18 2018]=C2=A0 xfs_alloc_vextent+0x3ba/0x4b0
[Tue Mar 20 15:21:18 2018]=C2=A0 __xfs_inobt_alloc_block.isra.1+0x9f/0x13=
0
[Tue Mar 20 15:21:18 2018]=C2=A0 __xfs_btree_split+0xfd/0x5c0
[Tue Mar 20 15:21:18 2018]=C2=A0 ? xfs_trans_read_buf_map+0x265/0x2f0
[Tue Mar 20 15:21:18 2018]=C2=A0 ?
xfs_btree_read_buf_block.constprop.26+0xaf/0xf0
[Tue Mar 20 15:21:18 2018]=C2=A0 xfs_btree_split+0x66/0x110
[Tue Mar 20 15:21:18 2018]=C2=A0 xfs_btree_make_block_unfull+0x113/0x1d0
[Tue Mar 20 15:21:18 2018]=C2=A0 xfs_btree_insrec+0x419/0x500
[Tue Mar 20 15:21:18 2018]=C2=A0 xfs_btree_insert+0xe2/0x220
[Tue Mar 20 15:21:18 2018]=C2=A0 xfs_difree_finobt+0xd0/0x2d0
[Tue Mar 20 15:21:18 2018]=C2=A0 xfs_difree+0x162/0x220
[Tue Mar 20 15:21:18 2018]=C2=A0 xfs_ifree+0xd0/0x290
[Tue Mar 20 15:21:18 2018]=C2=A0 xfs_inactive_ifree+0xf6/0x290
[Tue Mar 20 15:21:18 2018]=C2=A0 xfs_inactive+0x112/0x2a0
[Tue Mar 20 15:21:18 2018]=C2=A0 xfs_fs_destroy_inode+0x82/0x1f0
[Tue Mar 20 15:21:18 2018]=C2=A0 do_unlinkat+0x1b9/0x320
[Tue Mar 20 15:21:18 2018]=C2=A0 do_syscall_64+0x87/0x330
[Tue Mar 20 15:21:18 2018]=C2=A0 ? __do_page_fault+0x1e0/0x450
[Tue Mar 20 15:21:18 2018]=C2=A0 entry_SYSCALL_64_after_hwframe+0x3d/0xa2=

[Tue Mar 20 15:21:18 2018] RIP: 0033:0x7f69db9ff967
[Tue Mar 20 15:21:18 2018] RSP: 002b:00007f699af36e28 EFLAGS: 00000246
ORIG_RAX: 0000000000000057
[Tue Mar 20 15:21:18 2018] RAX: ffffffffffffffda RBX: 00007f699b581a14
RCX: 00007f69db9ff967
[Tue Mar 20 15:21:18 2018] RDX: 00007f699b581c88 RSI: 00007f699b581ad0
RDI: 00007f699b581ad0
[Tue Mar 20 15:21:18 2018] RBP: 00007f699af36e90 R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 15:21:18 2018] R10: 0000000000000000 R11: 0000000000000246
R12: 00007f699b581c48
[Tue Mar 20 15:21:18 2018] R13: 00007f699af36e80 R14: 0000000000000000
R15: 00007f699b3c0240
[Tue Mar 20 15:21:18 2018] Code: 10 e8 8e f9 ff ff 0f 0b e8 67 06 db ff
0f 1f 80 00 00 00 00 48 89 f1 41 89 d0 48 c7 c6 68 1f d5 81 48 89 fa 31
ff e8 a9 fc ff ff <0f> 0b c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7
c6 68 1f d5
[Tue Mar 20 15:21:18 2018] ---[ end trace 1d252f8e3d549508 ]---
[Tue Mar 20 15:21:29 2018] XFS: Assertion failed: tp->t_blk_res_used <=3D=

tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
[Tue Mar 20 15:21:29 2018] ------------[ cut here ]------------
[Tue Mar 20 15:21:29 2018] WARNING: CPU: 1 PID: 7041 at
fs/xfs/xfs_message.c:105 asswarn+0x17/0x20
[Tue Mar 20 15:21:29 2018] CPU: 1 PID: 7041 Comm: async_8 Tainted:
G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4.14.26-gentoo #1
[Tue Mar 20 15:21:29 2018] Hardware name: Xen HVM domU, BIOS 4.9.1
01/25/2018
[Tue Mar 20 15:21:29 2018] task: ffff880026e83300 task.stack:
ffffc90001190000
[Tue Mar 20 15:21:29 2018] RIP: 0010:asswarn+0x17/0x20
[Tue Mar 20 15:21:29 2018] RSP: 0018:ffffc90001193810 EFLAGS: 00010246
[Tue Mar 20 15:21:29 2018] RAX: 0000000000000000 RBX: ffff880021bf7b40
RCX: 0000000000000000
[Tue Mar 20 15:21:29 2018] RDX: 00000000ffffffc0 RSI: 000000000000000a
RDI: ffffffff81d22af7
[Tue Mar 20 15:21:29 2018] RBP: ffffffffffffffff R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 15:21:29 2018] R10: 000000000000000a R11: f000000000000000
R12: ffff880148594000
[Tue Mar 20 15:21:29 2018] R13: 0000000000100007 R14: 00000000000fdfc0
R15: ffff880148594000
[Tue Mar 20 15:21:29 2018] FS:=C2=A0 00007f699af37700(0000)
GS:ffff88014f480000(0000) knlGS:0000000000000000
[Tue Mar 20 15:21:29 2018] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
[Tue Mar 20 15:21:29 2018] CR2: 00007f328154e010 CR3: 00000000020be000
CR4: 00000000000406e0
[Tue Mar 20 15:21:29 2018] Call Trace:
[Tue Mar 20 15:21:29 2018]=C2=A0 xfs_trans_mod_sb+0x226/0x2b0
[Tue Mar 20 15:21:29 2018]=C2=A0 xfs_alloc_ag_vextent+0x130/0x330
[Tue Mar 20 15:21:29 2018]=C2=A0 xfs_alloc_vextent+0x3ba/0x4b0
[Tue Mar 20 15:21:29 2018]=C2=A0 __xfs_inobt_alloc_block.isra.1+0x9f/0x13=
0
[Tue Mar 20 15:21:29 2018]=C2=A0 __xfs_btree_split+0xfd/0x5c0
[Tue Mar 20 15:21:29 2018]=C2=A0 ? xfs_trans_read_buf_map+0x265/0x2f0
[Tue Mar 20 15:21:29 2018]=C2=A0 ?
xfs_btree_read_buf_block.constprop.26+0xaf/0xf0
[Tue Mar 20 15:21:29 2018]=C2=A0 xfs_btree_split+0x66/0x110
[Tue Mar 20 15:21:29 2018]=C2=A0 xfs_btree_make_block_unfull+0x113/0x1d0
[Tue Mar 20 15:21:29 2018]=C2=A0 xfs_btree_insrec+0x419/0x500
[Tue Mar 20 15:21:29 2018]=C2=A0 xfs_btree_insert+0xe2/0x220
[Tue Mar 20 15:21:29 2018]=C2=A0 xfs_difree_finobt+0xd0/0x2d0
[Tue Mar 20 15:21:29 2018]=C2=A0 xfs_difree+0x162/0x220
[Tue Mar 20 15:21:29 2018]=C2=A0 xfs_ifree+0xd0/0x290
[Tue Mar 20 15:21:29 2018]=C2=A0 xfs_inactive_ifree+0xf6/0x290
[Tue Mar 20 15:21:29 2018]=C2=A0 xfs_inactive+0x112/0x2a0
[Tue Mar 20 15:21:29 2018]=C2=A0 xfs_fs_destroy_inode+0x82/0x1f0
[Tue Mar 20 15:21:29 2018]=C2=A0 do_unlinkat+0x1b9/0x320
[Tue Mar 20 15:21:29 2018]=C2=A0 do_syscall_64+0x87/0x330
[Tue Mar 20 15:21:29 2018]=C2=A0 ? schedule+0x2d/0x80
[Tue Mar 20 15:21:29 2018]=C2=A0 entry_SYSCALL_64_after_hwframe+0x3d/0xa2=

[Tue Mar 20 15:21:29 2018] RIP: 0033:0x7f69db9ff967
[Tue Mar 20 15:21:29 2018] RSP: 002b:00007f699af36e28 EFLAGS: 00000246
ORIG_RAX: 0000000000000057
[Tue Mar 20 15:21:29 2018] RAX: ffffffffffffffda RBX: 00007f699b581a14
RCX: 00007f69db9ff967
[Tue Mar 20 15:21:29 2018] RDX: 00007f699b581c88 RSI: 00007f699b581ad0
RDI: 00007f699b581ad0
[Tue Mar 20 15:21:29 2018] RBP: 00007f699af36e90 R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 15:21:29 2018] R10: 0000000000000000 R11: 0000000000000246
R12: 00007f699b581c48
[Tue Mar 20 15:21:29 2018] R13: 00007f699af36e80 R14: 0000000000000000
R15: 00007f699b3c0240
[Tue Mar 20 15:21:29 2018] Code: 10 e8 8e f9 ff ff 0f 0b e8 67 06 db ff
0f 1f 80 00 00 00 00 48 89 f1 41 89 d0 48 c7 c6 68 1f d5 81 48 89 fa 31
ff e8 a9 fc ff ff <0f> 0b c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7
c6 68 1f d5
[Tue Mar 20 15:21:29 2018] ---[ end trace 1d252f8e3d549509 ]---
[Tue Mar 20 15:21:30 2018] XFS: Assertion failed: tp->t_blk_res_used <=3D=

tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
[Tue Mar 20 15:21:30 2018] ------------[ cut here ]------------
[Tue Mar 20 15:21:30 2018] WARNING: CPU: 1 PID: 7041 at
fs/xfs/xfs_message.c:105 asswarn+0x17/0x20
[Tue Mar 20 15:21:30 2018] CPU: 1 PID: 7041 Comm: async_8 Tainted:
G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4.14.26-gentoo #1
[Tue Mar 20 15:21:30 2018] Hardware name: Xen HVM domU, BIOS 4.9.1
01/25/2018
[Tue Mar 20 15:21:30 2018] task: ffff880026e83300 task.stack:
ffffc90001190000
[Tue Mar 20 15:21:30 2018] RIP: 0010:asswarn+0x17/0x20
[Tue Mar 20 15:21:30 2018] RSP: 0018:ffffc90001193810 EFLAGS: 00010246
[Tue Mar 20 15:21:30 2018] RAX: 0000000000000000 RBX: ffff880021bf75a0
RCX: 0000000000000000
[Tue Mar 20 15:21:30 2018] RDX: 00000000ffffffc0 RSI: 000000000000000a
RDI: ffffffff81d22af7
[Tue Mar 20 15:21:30 2018] RBP: ffffffffffffffff R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 15:21:30 2018] R10: 000000000000000a R11: f000000000000000
R12: ffff880148594000
[Tue Mar 20 15:21:30 2018] R13: 0000000000200007 R14: 00000000000fdfc0
R15: ffff880148594000
[Tue Mar 20 15:21:30 2018] FS:=C2=A0 00007f699af37700(0000)
GS:ffff88014f480000(0000) knlGS:0000000000000000
[Tue Mar 20 15:21:30 2018] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
[Tue Mar 20 15:21:30 2018] CR2: 00007f327c07e010 CR3: 00000000020be000
CR4: 00000000000406e0
[Tue Mar 20 15:21:30 2018] Call Trace:
[Tue Mar 20 15:21:30 2018]=C2=A0 xfs_trans_mod_sb+0x226/0x2b0
[Tue Mar 20 15:21:30 2018]=C2=A0 xfs_alloc_ag_vextent+0x130/0x330
[Tue Mar 20 15:21:30 2018]=C2=A0 xfs_alloc_vextent+0x3ba/0x4b0
[Tue Mar 20 15:21:30 2018]=C2=A0 __xfs_inobt_alloc_block.isra.1+0x9f/0x13=
0
[Tue Mar 20 15:21:30 2018]=C2=A0 __xfs_btree_split+0xfd/0x5c0
[Tue Mar 20 15:21:30 2018]=C2=A0 ? xfs_trans_read_buf_map+0x265/0x2f0
[Tue Mar 20 15:21:30 2018]=C2=A0 ?
xfs_btree_read_buf_block.constprop.26+0xaf/0xf0
[Tue Mar 20 15:21:30 2018]=C2=A0 xfs_btree_split+0x66/0x110
[Tue Mar 20 15:21:30 2018]=C2=A0 xfs_btree_make_block_unfull+0x113/0x1d0
[Tue Mar 20 15:21:30 2018]=C2=A0 xfs_btree_insrec+0x419/0x500
[Tue Mar 20 15:21:30 2018]=C2=A0 xfs_btree_insert+0xe2/0x220
[Tue Mar 20 15:21:30 2018]=C2=A0 xfs_difree_finobt+0xd0/0x2d0
[Tue Mar 20 15:21:30 2018]=C2=A0 xfs_difree+0x162/0x220
[Tue Mar 20 15:21:30 2018]=C2=A0 xfs_ifree+0xd0/0x290
[Tue Mar 20 15:21:30 2018]=C2=A0 xfs_inactive_ifree+0xf6/0x290
[Tue Mar 20 15:21:30 2018]=C2=A0 xfs_inactive+0x112/0x2a0
[Tue Mar 20 15:21:30 2018]=C2=A0 xfs_fs_destroy_inode+0x82/0x1f0
[Tue Mar 20 15:21:30 2018]=C2=A0 do_unlinkat+0x1b9/0x320
[Tue Mar 20 15:21:30 2018]=C2=A0 do_syscall_64+0x87/0x330
[Tue Mar 20 15:21:30 2018]=C2=A0 ? schedule+0x2d/0x80
[Tue Mar 20 15:21:30 2018]=C2=A0 entry_SYSCALL_64_after_hwframe+0x3d/0xa2=

[Tue Mar 20 15:21:30 2018] RIP: 0033:0x7f69db9ff967
[Tue Mar 20 15:21:30 2018] RSP: 002b:00007f699af36e28 EFLAGS: 00000246
ORIG_RAX: 0000000000000057
[Tue Mar 20 15:21:30 2018] RAX: ffffffffffffffda RBX: 00007f699b581a8c
RCX: 00007f69db9ff967
[Tue Mar 20 15:21:30 2018] RDX: 00007f699b581a20 RSI: 00007f699b581b48
RDI: 00007f699b581b48
[Tue Mar 20 15:21:30 2018] RBP: 00007f699af36e90 R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 15:21:30 2018] R10: 0000000000000000 R11: 0000000000000246
R12: 00007f699b5819e0
[Tue Mar 20 15:21:30 2018] R13: 00007f699af36e80 R14: 0000000000000000
R15: 00007f699b3c0240
[Tue Mar 20 15:21:30 2018] Code: 10 e8 8e f9 ff ff 0f 0b e8 67 06 db ff
0f 1f 80 00 00 00 00 48 89 f1 41 89 d0 48 c7 c6 68 1f d5 81 48 89 fa 31
ff e8 a9 fc ff ff <0f> 0b c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7
c6 68 1f d5
[Tue Mar 20 15:21:30 2018] ---[ end trace 1d252f8e3d54950a ]---
[Tue Mar 20 15:21:45 2018] XFS: Assertion failed: tp->t_blk_res_used <=3D=

tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
[Tue Mar 20 15:21:45 2018] ------------[ cut here ]------------
[Tue Mar 20 15:21:45 2018] WARNING: CPU: 0 PID: 7041 at
fs/xfs/xfs_message.c:105 asswarn+0x17/0x20
[Tue Mar 20 15:21:45 2018] CPU: 0 PID: 7041 Comm: async_8 Tainted:
G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4.14.26-gentoo #1
[Tue Mar 20 15:21:45 2018] Hardware name: Xen HVM domU, BIOS 4.9.1
01/25/2018
[Tue Mar 20 15:21:45 2018] task: ffff880026e83300 task.stack:
ffffc90001190000
[Tue Mar 20 15:21:45 2018] RIP: 0010:asswarn+0x17/0x20
[Tue Mar 20 15:21:45 2018] RSP: 0018:ffffc90001193810 EFLAGS: 00010246
[Tue Mar 20 15:21:45 2018] RAX: 0000000000000000 RBX: ffff880012d344b0
RCX: 0000000000000000
[Tue Mar 20 15:21:45 2018] RDX: 00000000ffffffc0 RSI: 000000000000000a
RDI: ffffffff81d22af7
[Tue Mar 20 15:21:45 2018] RBP: ffffffffffffffff R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 15:21:45 2018] R10: 000000000000000a R11: f000000000000000
R12: ffff880148594000
[Tue Mar 20 15:21:45 2018] R13: 0000000000200007 R14: 00000000000fdfc0
R15: ffff880148594000
[Tue Mar 20 15:21:45 2018] FS:=C2=A0 00007f699af37700(0000)
GS:ffff88014f400000(0000) knlGS:0000000000000000
[Tue Mar 20 15:21:45 2018] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
[Tue Mar 20 15:21:45 2018] CR2: 00007f327e364ff0 CR3: 00000000020be000
CR4: 00000000000406f0
[Tue Mar 20 15:21:45 2018] Call Trace:
[Tue Mar 20 15:21:45 2018]=C2=A0 xfs_trans_mod_sb+0x226/0x2b0
[Tue Mar 20 15:21:45 2018]=C2=A0 xfs_alloc_ag_vextent+0x130/0x330
[Tue Mar 20 15:21:45 2018]=C2=A0 xfs_alloc_vextent+0x3ba/0x4b0
[Tue Mar 20 15:21:45 2018]=C2=A0 __xfs_inobt_alloc_block.isra.1+0x9f/0x13=
0
[Tue Mar 20 15:21:45 2018]=C2=A0 __xfs_btree_split+0xfd/0x5c0
[Tue Mar 20 15:21:45 2018]=C2=A0 ? xfs_trans_read_buf_map+0x265/0x2f0
[Tue Mar 20 15:21:45 2018]=C2=A0 ?
xfs_btree_read_buf_block.constprop.26+0xaf/0xf0
[Tue Mar 20 15:21:45 2018]=C2=A0 xfs_btree_split+0x66/0x110
[Tue Mar 20 15:21:45 2018]=C2=A0 xfs_btree_make_block_unfull+0x113/0x1d0
[Tue Mar 20 15:21:45 2018]=C2=A0 xfs_btree_insrec+0x419/0x500
[Tue Mar 20 15:21:45 2018]=C2=A0 xfs_btree_insert+0xe2/0x220
[Tue Mar 20 15:21:45 2018]=C2=A0 xfs_difree_finobt+0xd0/0x2d0
[Tue Mar 20 15:21:45 2018]=C2=A0 xfs_difree+0x162/0x220
[Tue Mar 20 15:21:45 2018]=C2=A0 xfs_ifree+0xd0/0x290
[Tue Mar 20 15:21:45 2018]=C2=A0 xfs_inactive_ifree+0xf6/0x290
[Tue Mar 20 15:21:45 2018]=C2=A0 xfs_inactive+0x112/0x2a0
[Tue Mar 20 15:21:45 2018]=C2=A0 xfs_fs_destroy_inode+0x82/0x1f0
[Tue Mar 20 15:21:45 2018]=C2=A0 do_unlinkat+0x1b9/0x320
[Tue Mar 20 15:21:45 2018]=C2=A0 do_syscall_64+0x87/0x330
[Tue Mar 20 15:21:45 2018]=C2=A0 ? schedule+0x2d/0x80
[Tue Mar 20 15:21:45 2018]=C2=A0 entry_SYSCALL_64_after_hwframe+0x3d/0xa2=

[Tue Mar 20 15:21:45 2018] RIP: 0033:0x7f69db9ff967
[Tue Mar 20 15:21:45 2018] RSP: 002b:00007f699af36e28 EFLAGS: 00000246
ORIG_RAX: 0000000000000057
[Tue Mar 20 15:21:45 2018] RAX: ffffffffffffffda RBX: 00007f699b581a14
RCX: 00007f69db9ff967
[Tue Mar 20 15:21:45 2018] RDX: 00007f699b581b70 RSI: 00007f699b581ad0
RDI: 00007f699b581ad0
[Tue Mar 20 15:21:45 2018] RBP: 00007f699af36e90 R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 15:21:45 2018] R10: 0000000000000000 R11: 0000000000000246
R12: 00007f699b581b30
[Tue Mar 20 15:21:45 2018] R13: 00007f699af36e80 R14: 0000000000000000
R15: 00007f699b3c0240
[Tue Mar 20 15:21:45 2018] Code: 10 e8 8e f9 ff ff 0f 0b e8 67 06 db ff
0f 1f 80 00 00 00 00 48 89 f1 41 89 d0 48 c7 c6 68 1f d5 81 48 89 fa 31
ff e8 a9 fc ff ff <0f> 0b c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7
c6 68 1f d5
[Tue Mar 20 15:21:45 2018] ---[ end trace 1d252f8e3d54950b ]---
[Tue Mar 20 15:31:09 2018] XFS: Assertion failed: tp->t_blk_res_used <=3D=

tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
[Tue Mar 20 15:31:09 2018] ------------[ cut here ]------------
[Tue Mar 20 15:31:09 2018] WARNING: CPU: 2 PID: 22659 at
fs/xfs/xfs_message.c:105 asswarn+0x17/0x20
[Tue Mar 20 15:31:09 2018] CPU: 2 PID: 22659 Comm: async_8 Tainted:
G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4.14.26-gentoo #1
[Tue Mar 20 15:31:09 2018] Hardware name: Xen HVM domU, BIOS 4.9.1
01/25/2018
[Tue Mar 20 15:31:09 2018] task: ffff880148a3e600 task.stack:
ffffc90006ad8000
[Tue Mar 20 15:31:09 2018] RIP: 0010:asswarn+0x17/0x20
[Tue Mar 20 15:31:09 2018] RSP: 0018:ffffc90006adb810 EFLAGS: 00010246
[Tue Mar 20 15:31:09 2018] RAX: 0000000000000000 RBX: ffff880043695000
RCX: 0000000000000000
[Tue Mar 20 15:31:09 2018] RDX: 00000000ffffffc0 RSI: 000000000000000a
RDI: ffffffff81d22af7
[Tue Mar 20 15:31:09 2018] RBP: ffffffffffffffff R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 15:31:09 2018] R10: 000000000000000a R11: f000000000000000
R12: ffff880148594000
[Tue Mar 20 15:31:09 2018] R13: 0000000000100007 R14: 00000000000fdfc0
R15: ffff880148594000
[Tue Mar 20 15:31:09 2018] FS:=C2=A0 00007f6282655700(0000)
GS:ffff88014f500000(0000) knlGS:0000000000000000
[Tue Mar 20 15:31:09 2018] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
[Tue Mar 20 15:31:09 2018] CR2: 00007f327b8dfff0 CR3: 000000001faf2000
CR4: 00000000000406e0
[Tue Mar 20 15:31:09 2018] Call Trace:
[Tue Mar 20 15:31:09 2018]=C2=A0 xfs_trans_mod_sb+0x226/0x2b0
[Tue Mar 20 15:31:09 2018]=C2=A0 xfs_alloc_ag_vextent+0x130/0x330
[Tue Mar 20 15:31:09 2018]=C2=A0 xfs_alloc_vextent+0x3ba/0x4b0
[Tue Mar 20 15:31:09 2018]=C2=A0 __xfs_inobt_alloc_block.isra.1+0x9f/0x13=
0
[Tue Mar 20 15:31:09 2018]=C2=A0 __xfs_btree_split+0xfd/0x5c0
[Tue Mar 20 15:31:09 2018]=C2=A0 ? xfs_trans_read_buf_map+0x265/0x2f0
[Tue Mar 20 15:31:09 2018]=C2=A0 ?
xfs_btree_read_buf_block.constprop.26+0xaf/0xf0
[Tue Mar 20 15:31:09 2018]=C2=A0 xfs_btree_split+0x66/0x110
[Tue Mar 20 15:31:09 2018]=C2=A0 xfs_btree_make_block_unfull+0x113/0x1d0
[Tue Mar 20 15:31:09 2018]=C2=A0 xfs_btree_insrec+0x419/0x500
[Tue Mar 20 15:31:09 2018]=C2=A0 xfs_btree_insert+0xe2/0x220
[Tue Mar 20 15:31:09 2018]=C2=A0 xfs_difree_finobt+0xd0/0x2d0
[Tue Mar 20 15:31:09 2018]=C2=A0 xfs_difree+0x162/0x220
[Tue Mar 20 15:31:09 2018]=C2=A0 xfs_ifree+0xd0/0x290
[Tue Mar 20 15:31:09 2018]=C2=A0 xfs_inactive_ifree+0xf6/0x290
[Tue Mar 20 15:31:09 2018]=C2=A0 xfs_inactive+0x112/0x2a0
[Tue Mar 20 15:31:09 2018]=C2=A0 xfs_fs_destroy_inode+0x82/0x1f0
[Tue Mar 20 15:31:09 2018]=C2=A0 do_unlinkat+0x1b9/0x320
[Tue Mar 20 15:31:09 2018]=C2=A0 do_syscall_64+0x87/0x330
[Tue Mar 20 15:31:09 2018]=C2=A0 ? __do_page_fault+0x1e0/0x450
[Tue Mar 20 15:31:09 2018]=C2=A0 entry_SYSCALL_64_after_hwframe+0x3d/0xa2=

[Tue Mar 20 15:31:09 2018] RIP: 0033:0x7f62c3117967
[Tue Mar 20 15:31:09 2018] RSP: 002b:00007f6282654e28 EFLAGS: 00000246
ORIG_RAX: 0000000000000057
[Tue Mar 20 15:31:09 2018] RAX: ffffffffffffffda RBX: 00007f6282c81a14
RCX: 00007f62c3117967
[Tue Mar 20 15:31:09 2018] RDX: 00007f6282c81b90 RSI: 00007f6282c81ad0
RDI: 00007f6282c81ad0
[Tue Mar 20 15:31:09 2018] RBP: 00007f6282654e90 R08: 0000000000000000
R09: 0000000000000000
[Tue Mar 20 15:31:09 2018] R10: 0000000000000000 R11: 0000000000000246
R12: 00007f6282c81b50
[Tue Mar 20 15:31:09 2018] R13: 00007f6282654e80 R14: 0000000000000000
R15: 00007f6282b00240
[Tue Mar 20 15:31:09 2018] Code: 10 e8 8e f9 ff ff 0f 0b e8 67 06 db ff
0f 1f 80 00 00 00 00 48 89 f1 41 89 d0 48 c7 c6 68 1f d5 81 48 89 fa 31
ff e8 a9 fc ff ff <0f> 0b c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7
c6 68 1f d5
[Tue Mar 20

--=20
Tomas Charvat
EXCELLO | Virusfree
w: www.virusfree.cz
e: tc@excello.cz



--------------ms080403070707040207010001
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
CxMwggUlMIIEDaADAgECAhBQ2gIvqd8eOJtBTvHzILPxMA0GCSqGSIb3DQEBCwUAMIGXMQsw
CQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxm
b3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBD
bGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTAeFw0xODAxMDgwMDAw
MDBaFw0xOTAxMDgyMzU5NTlaMB4xHDAaBgkqhkiG9w0BCQEWDXRjQGV4Y2VsbG8uY3owggEi
MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDkeI/msUSPHnMwc4o548qbJ2cU2exr4lUX
Cu4t17OwserJN27X7N7OovJsHynVvvecr26slkRuD8t25urCUdIUZXYa3copvxWrK2NJsMio
KmcxMRrZ1xNaPsKybXFpd+wXXljDmzk3JcoTA7OlUNt6/yhCbnaZdUHsjeF5RplR+VNfscrN
wbKARgQzuXNHHtVXlnbtQEbaOoW9ncbcJCLWndcEXVDlfOZykCTAjSgocnxV+J9AdBySGavP
gYVY/i1YX8dAWyoBz+53sDVstYLd8QcxcIB+idqK6CB04Ou0RkgUXmt1tL6s2dw6Qacvbkmk
eBnlXVUXERUIoaFGBs5hAgMBAAGjggHjMIIB3zAfBgNVHSMEGDAWgBSCr2yM+MX+lmF86B89
K3FIXsSLwDAdBgNVHQ4EFgQUi7g6sbkThiwC8MYJLoa2i37L0B4wDgYDVR0PAQH/BAQDAgWg
MAwGA1UdEwEB/wQCMAAwIAYDVR0lBBkwFwYIKwYBBQUHAwQGCysGAQQBsjEBAwUCMBEGCWCG
SAGG+EIBAQQEAwIFIDBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEBATArMCkGCCsGAQUFBwIB
Fh1odHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBLhklodHRw
Oi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNl
Y3VyZUVtYWlsQ0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6Ly9j
cnQuY29tb2RvY2EuY29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJl
RW1haWxDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAYBgNV
HREEETAPgQ10Y0BleGNlbGxvLmN6MA0GCSqGSIb3DQEBCwUAA4IBAQAD0S9hr0wwhxHiGxrh
gO08t800wLEF9Q9SxQsmQ/u1UJDDN+UBGaRFsFpdU0czbN1nYqAEsUpu/ydfG/x4J1Q6sNAJ
vrcUDfKzbY09I1Bzii2aEZYQgm9TUDo8S2C3aiplewXRd5pbFz6WlvEGFLg/t2H920S+1PR0
MmmfcmQR1igCTwfCz5K4kFNpD5EwrLBgLa8mFNpGDrw7cEFd7/HWGG6UnDRJ1MzCM6+TYYnK
qdUWkeDYbotnysrvswM7cUhuPfgy2J83D9vePTjAXMKFo2bnsgqwr9JDR9wjCokHYXmrHDpC
iWisn9258W94wDAPYbCnAqaHUF5hapmlPkdsMIIF5jCCA86gAwIBAgIQapvhODv/K2ufAdXZ
uKdSVjANBgkqhkiG9w0BAQwFADCBhTELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0
ZWQxKzApBgNVBAMTIkNPTU9ETyBSU0EgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTMw
MTEwMDAwMDAwWhcNMjgwMTA5MjM1OTU5WjCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdy
ZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENB
IExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFu
ZCBTZWN1cmUgRW1haWwgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC+s55X
rCh2dUAWxzgDmNPGGHYhUPMleQtMtaDRfTpYPpynMS6n9jR22YRq2tA9NEjk6vW7rN/5sYFL
IP1of3l0NKZ6fLWfF2VgJ5cijKYy/qlAckY1wgOkUMgzKlWlVJGyK+UlNEQ1/5ErCsHq9x9a
U/x1KwTdF/LCrT03Rl/FwFrf1XTCwa2QZYL55AqLPikFlgqOtzk06kb2qvGlnHJvijjI03BO
rNpo+kZGpcHsgyO1/u1OZTaOo8wvEU17VVeP1cHWse9tGKTDyUGg2hJZjrqck39UIm/nKbpD
SZ0JsMoIw/JtOOg0JC56VzQgBo7ictReTQE5LFLG3yQK+xS1AgMBAAGjggE8MIIBODAfBgNV
HSMEGDAWgBS7r34CPfqm8TyEjq3uOJjs2TIy1DAdBgNVHQ4EFgQUgq9sjPjF/pZhfOgfPStx
SF7Ei8AwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAwEQYDVR0gBAowCDAG
BgRVHSAAMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0NPTU9E
T1JTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHEGCCsGAQUFBwEBBGUwYzA7BggrBgEF
BQcwAoYvaHR0cDovL2NydC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQWRkVHJ1c3RDQS5jcnQw
JAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTANBgkqhkiG9w0BAQwFAAOC
AgEAeFyygSg0TzzuX1bOn5dW7I+iaxf28/ZJCAbU2C81zd9A/tNx4+jsQgwRGiHjZrAYayZr
rm78hOx7aEpkfNPQIHGG6Fvq3EzWf/Lvx7/hk6zSPwIal9v5IkDcZoFD7f3iT7PdkHJY9B51
csvU50rxpEg1OyOT8fk2zvvPBuM4qQNqbGWlnhMpIMwpWZT89RY0wpJO+2V6eXEGGHsROs3n
jeP9DqqqAJaBa4wBeKOdGCWn1/Jp2oY6dyNmNppI4ZNMUH4Tam85S1j6E95u4+1Nuru84OrM
IzqvISE2HN/56ebTOWlcrurffade2022O/tUU1gb4jfWCcyvB8czm12FgX/y/lRjmDbEA08Q
JNB2729Y+io1IYO3ztveBdvUCIYZojTq/OCR6MvnzS6X72HP0PRLRTiOSEmIDsS5N5w/8IW1
Hva5hEFy6fDAfd9yI+O+IMMAj1KcL/Zo9jzJ16HO5m60ttl1Enk8MQkz/W3JlHaeI5iKFn4U
Ju1/cP2YHXYPiWf2JyBzsLBrGk1II+3yL8aorYew6CQvdVifC3HtwlSam9V1niiCfOBe2C12
TdKGu05LWIA3ZkFcWJGaNXOZ6Ggyh/TqvXG5v7zmEVDNXFnHn9tFpMpOUvxhcsjycBtH0dZ0
WrNw6gH+HF8TIhCnH3+zzWuDN0Rk6h9KVkfKehIxggQ1MIIEMQIBATCBrDCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEa
MBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50
IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEFDaAi+p3x44m0FO8fMgs/Ew
DQYJYIZIAWUDBAIBBQCgggJZMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTE4MDMyMDE0MzcxMFowLwYJKoZIhvcNAQkEMSIEIOUAKeaWo4jXnLpdWjH/Ums1
/1XEmra4Im2aOJnoahXSMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4D
AgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzELMAkGA1UEBhMCR0Ix
GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UE
ChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEFDaAi+p3x44m0FO8fMgs/Ewgb8GCyqG
SIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5j
aGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDE9
MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBF
bWFpbCBDQQIQUNoCL6nfHjibQU7x8yCz8TANBgkqhkiG9w0BAQEFAASCAQBqX+QFbClMLaT5
Z5PRsAxMh5UvnTJFDAeD4Wn5FxfDX0QtbHDRckCoopHqQJRY6hcjYDYOxoEDtQ9Z91U3KmgI
ornp2gGsFAFiVCDTi5f7m6AaV2JoU7xXm/GAW/y6cue8YY/jBaR5AfRTxt9utDjp4MbGqkZr
r1Gldqe2Tz09SE5GHbHm+C55dvQqIal6b1a207GwmewLV5NMsCaV7JZ5k7epI06ONQ9pEDFY
6KTYbZLR4hdQ8wBvnxx+NUagBjOIWbMQ8yS+BGwBuu8zuFJbZjTxBkyYR5ISSLVzZggSh/hm
Gp/rxX9BrffrkbFf5Dm8lv3nzPUNOoaQKXM9FX/KAAAAAAAA
--------------ms080403070707040207010001--
