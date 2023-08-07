Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E0CC001DB
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Aug 2023 16:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjHGQgO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 12:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbjHGQgL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 12:36:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65664172D
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 09:35:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CE3C61F4D
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 16:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD352C433CB
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 16:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691426135;
        bh=22y7Jl5YQKDNcH0oFrlAa9yjQ1FL7PxxCx3nFhUW34c=;
        h=From:To:Subject:Date:From;
        b=Tw+HTNyt5CTlj8AhrZJtr8rRW/xCfx+FXU5kH2Clce9ZVE3gBRD54dc8IySchEBxf
         o5ZyFDya9vkDHs3IBghNcrkacm2YCQmboXwtznFRal9HcA/j8rN7iJ5vxVIcIfPWNi
         Sz+Qmsg4/Y4dTgpmBSJ/A39VV4x5s2z1lOGUHg1M22Q9i0OUHOi82rozBVoLQyAt/F
         vuoh7AKxT7ANXjnnKUIRTuYWo6g55xNRREbwQZSfkrhI5RsKLRBPLqr+RzWN0uP4iL
         J0v/riKbYT81culKKt/00AjQ22Mlntp5zMrwyuBT1C1iiOPLDW3BRqLgm9p8pDNYcf
         TCfyd7rIP7Jzg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id BAEA0C53BCD; Mon,  7 Aug 2023 16:35:35 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217769] New: XFS crash on mount on kernels >= 6.1
Date:   Mon, 07 Aug 2023 16:35:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: xani666@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression attachments.created
Message-ID: <bug-217769-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217769

            Bug ID: 217769
           Summary: XFS crash on mount on kernels >=3D 6.1
           Product: File System
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: xani666@gmail.com
        Regression: No

Created attachment 304789
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D304789&action=3Dedit
full boot sequence where XFS fails

Background:

I've seen that happen on few machines now, both consumer (my personal lapto=
p)
and enterprise (VMs on server with ECC memory) so I think any kind of disk
corruption could be ruled out here.

Common things between the machines is that all of them were on Debian,
dist-upgraded multiple times. IIRC the filesystem was originally formatted =
on
4.9 kernel. So basically XFS was formatted long time ago:

xfs_db> version
versionnum [0xb4b4+0x8a] =3D
V4,NLINK,DIRV2,ATTR,ALIGN,LOGV2,EXTFLG,MOREBITS,ATTR2,LAZYSBCOUNT,PROJID32B=
IT

xfs_info /dev/vda2=20
meta-data=3D/dev/vda2              isize=3D256    agcount=3D4, agsize=3D624=
064 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D0        finobt=3D0, sparse=3D0, r=
mapbt=3D0
         =3D                       reflink=3D0    bigtime=3D0 inobtcount=3D=
0 nrext64=3D0
data     =3D                       bsize=3D4096   blocks=3D2496256, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D0
log      =3Dinternal log           bsize=3D4096   blocks=3D2560, version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

And now *some* of them started to crash near-immediately on boot. After
upgrading to Debian's 6.1 I get the crash, booting the old version (either
5,17, 5.10 or 4.19) works fine. I also tried 6.5~rc4 from experimental to t=
he
same effect, and 6.3 on my laptop (where it only crashes one of the partiti=
ons,
as in attachment

The other interesting part is that the server mentioned in logs have a HA p=
air,
that was formatted at the same date, used near-same but doesn't (so far) ha=
ve
same behaviour.

In both cases XFS complains about in-memory corruption but I don't believe
that's the case, aside of one of the systems having ECC memory (and dozen o=
ther
VMs running without problem) I also memtested them  for ~hour just to be su=
re.
I also booted that VM on other machine with same effect.

The log in question:=20

[   16.115185] ------------[ cut here ]------------
[   16.115856] WARNING: CPU: 2 PID: 646 at fs/xfs/xfs_inode.c:1831
xfs_iunlink+0x165/0x1e0 [xfs]
[   16.118200] Modules linked in: tcp_diag inet_diag binfmt_misc ext4
ghash_clmulni_intel sha512_ssse3 sha512_generic crc16 mbcache jbd2 aesni_in=
tel
crypto_simd cryptd cirrus drm_shmem_helper drm_kms_helper i6300esb
virtio_balloon watchdog pcspkr button joydev evdev serio_raw loop fuse drm
efi_pstore dm_mod configfs qemu_fw_cfg virtio_rng rng_core ip_tables x_tabl=
es
autofs4 hid_generic usbhid hid xfs libcrc32c crc32c_generic ata_generic
virtio_net virtio_blk net_failover failover uhci_hcd ata_piix crct10dif_pcl=
mul
crct10dif_common ehci_hcd libata virtio_pci crc32_pclmul floppy crc32c_intel
virtio_pci_legacy_dev virtio_pci_modern_dev virtio scsi_mod usbcore psmouse
scsi_common virtio_ring usb_common i2c_piix4
[   16.129279] CPU: 2 PID: 646 Comm: 6_dirty_io_sche Not tainted 6.5.0-0-am=
d64
#1  Debian 6.5~rc4-1~exp1
[   16.129290] Hardware name: hq hqblade212.non.3dart.com, BIOS 0.5.1
01/01/2007
[   16.129293] RIP: 0010:xfs_iunlink+0x165/0x1e0 [xfs]
[   16.134173] Code: 89 4c 24 04 72 2d e8 ea 5f f1 d8 8b 74 24 04 48 8d bd =
e0
00 00 00 e8 8a 40 94 d9 48 89 c3 48 85 c0 74 07 48 83 78 20 00 75 26 <0f> 0=
b e8
24 9c f1 d8 eb 13 f3 0f 1e fa 48 c7 c6 be fe 64 c0 4c 89
[   16.134177] RSP: 0018:ffffae6740c67b60 EFLAGS: 00010246
[   16.134189] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
0000000000000006
[   16.134192] RDX: 0000000000000000 RSI: ffff9810817bfd98 RDI:
0000000000088b40
[   16.134194] RBP: ffff9810809cd800 R08: ffff9810817bff28 R09:
ffff9810809cd8e0
[   16.134196] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff9810861e2ae0
[   16.134199] R13: 00000000000101c0 R14: ffff981081642900 R15:
ffff981084217c00
[   16.146474] FS:  00007f89734e06c0(0000) GS:ffff981119d00000(0000)
knlGS:0000000000000000
[   16.146478] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.146480] CR2: 00007f8972b04000 CR3: 00000001024a6002 CR4:
00000000000206e0
[   16.146493] Call Trace:
[   16.146533]  <TASK>
[   16.146536]  ? xfs_iunlink+0x165/0x1e0 [xfs]
[   16.153113]  ? __warn+0x81/0x130
[   16.153193]  ? xfs_iunlink+0x165/0x1e0 [xfs]
[   16.154796]  ? report_bug+0x191/0x1c0
[   16.155433]  ? handle_bug+0x3c/0x80
[   16.155468]  ? exc_invalid_op+0x17/0x70
[   16.155472]  ? asm_exc_invalid_op+0x1a/0x20
[   16.155498]  ? xfs_iunlink+0x165/0x1e0 [xfs]
[   16.159010]  xfs_rename+0xaf9/0xe50 [xfs]
[   16.159285]  xfs_vn_rename+0xfe/0x170 [xfs]
[   16.161080]  ? __pfx_bpf_lsm_inode_permission+0x10/0x10
[   16.161137]  vfs_rename+0xb7e/0xd40
[   16.163241]  ? do_renameat2+0x57a/0x5f0
[   16.163256]  do_renameat2+0x57a/0x5f0
[   16.163277]  __x64_sys_rename+0x43/0x50
[   16.165707]  do_syscall_64+0x60/0xc0
[   16.165740]  ? do_syscall_64+0x6c/0xc0
[   16.165746]  ? do_syscall_64+0x6c/0xc0
[   16.165749]  ? do_syscall_64+0x6c/0xc0
[   16.165754]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[   16.165776] RIP: 0033:0x7f89b7277997
[   16.170373] Code: e8 ce 0f 0a 00 f7 d8 19 c0 5b c3 0f 1f 84 00 00 00 00 =
00
b8 ff ff ff ff 5b c3 66 0f 1f 84 00 00 00 00 00 b8 52 00 00 00 0f 05 <48> 3=
d 00
f0 ff ff 77 01 c3 48 8b 15 39 94 17 00 f7 d8 64 89 02 b8
[   16.170377] RSP: 002b:00007f89734dfc88 EFLAGS: 00000246 ORIG_RAX:
0000000000000052
[   16.170382] RAX: ffffffffffffffda RBX: 00007f89734dfca0 RCX:
00007f89b7277997
[   16.170384] RDX: 00007f8972b5fbb9 RSI: 00007f8972b5fb80 RDI:
00007f8972b5fb30
[   16.170386] RBP: 00007f8975544480 R08: 0000000000000009 R09:
0000000000000fa0
[   16.170388] R10: 0000000000000000 R11: 0000000000000246 R12:
00007f89734dfca0
[   16.170399] R13: 00007f89734dfcd0 R14: 00007f8972f5e3e8 R15:
00007f8975544480
[   16.170407]  </TASK>
[   16.170408] ---[ end trace 0000000000000000 ]---
[   16.170419] XFS (vda2): Internal error xfs_trans_cancel at line 1104 of =
file
fs/xfs/xfs_trans.c.  Caller xfs_rename+0x613/0xe50 [xfs]
[   16.201330] CPU: 2 PID: 646 Comm: 6_dirty_io_sche Tainted: G        W=20=
=20=20=20=20=20=20
  6.5.0-0-amd64 #1  Debian 6.5~rc4-1~exp1
[   16.201335] Hardware name: hq hqblade212.non.3dart.com, BIOS 0.5.1
01/01/2007
[   16.201337] Call Trace:
[   16.201377]  <TASK>
[   16.201382]  dump_stack_lvl+0x47/0x60
[   16.201412]  xfs_trans_cancel+0x131/0x150 [xfs]
[   16.214058]  xfs_rename+0x613/0xe50 [xfs]
[   16.218956]  xfs_vn_rename+0xfe/0x170 [xfs]
[   16.218956]  ? __pfx_bpf_lsm_inode_permission+0x10/0x10
[   16.222083]  vfs_rename+0xb7e/0xd40
[   16.222083]  ? do_renameat2+0x57a/0x5f0
[   16.222083]  do_renameat2+0x57a/0x5f0
[   16.222083]  __x64_sys_rename+0x43/0x50
[   16.222083]  do_syscall_64+0x60/0xc0
[   16.222083]  ? do_syscall_64+0x6c/0xc0
[   16.222083]  ? do_syscall_64+0x6c/0xc0
[   16.222083]  ? do_syscall_64+0x6c/0xc0
[   16.222083]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[   16.222083] RIP: 0033:0x7f89b7277997
[   16.222083] Code: e8 ce 0f 0a 00 f7 d8 19 c0 5b c3 0f 1f 84 00 00 00 00 =
00
b8 ff ff ff ff 5b c3 66 0f 1f 84 00 00 00 00 00 b8 52 00 00 00 0f 05 <48> 3=
d 00
f0 ff ff 77 01 c3 48 8b 15 39 94 17 00 f7 d8 64 89 02 b8
[   16.222083] RSP: 002b:00007f89734dfc88 EFLAGS: 00000246 ORIG_RAX:
0000000000000052
[   16.222083] RAX: ffffffffffffffda RBX: 00007f89734dfca0 RCX:
00007f89b7277997
[   16.222083] RDX: 00007f8972b5fbb9 RSI: 00007f8972b5fb80 RDI:
00007f8972b5fb30
[   16.222083] RBP: 00007f8975544480 R08: 0000000000000009 R09:
0000000000000fa0
[   16.222083] R10: 0000000000000000 R11: 0000000000000246 R12:
00007f89734dfca0
[   16.222083] R13: 00007f89734dfcd0 R14: 00007f8972f5e3e8 R15:
00007f8975544480
[   16.222083]  </TASK>
[   16.223078] XFS (vda2): Corruption of in-memory data (0x8) detected at
xfs_trans_cancel+0x14a/0x150 [xfs] (fs/xfs/xfs_trans.c:1105).  Shutting down
filesystem.
[   16.223941] systemd-journald[251]:
/var/log/journal/48d6a6734183b423cc1f60686f4553bb/system.journal: IO error,
rotating.
[   16.224548] XFS (vda2): Please unmount the filesystem and rectify the
problem(s)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
