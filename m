Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52872 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727972AbfGRTDr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 15:03:47 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5D116284B5
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2019 19:03:43 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 204223] New: [xfstests generic/388]: XFS: Assertion failed:
 ip->i_d.di_format != XFS_DINODE_FMT_BTREE || ip->i_d.di_nextents >
 XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK), file: fs/xfs/xfs_inode.c, line: 3646
Date: Thu, 18 Jul 2019 19:03:42 +0000
Message-ID: <bug-204223-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204223

            Bug ID: 204223
           Summary: [xfstests generic/388]: XFS: Assertion failed:
                    ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
                    ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip,
                    XFS_DATA_FORK), file: fs/xfs/xfs_inode.c, line: 3646
           Product: File System
           Version: 2.5
    Kernel Version: 4.19.58
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: mcgrof@kernel.org
                CC: filesystem_xfs@kernel-bugs.kernel.org,
                    mcgrof@kernel.org, zlang@redhat.com
        Depends on: 204049
        Regression: No

Running generic/388 in a loop with an "xfs_nocrc" configuration as per oscheck
[0], which I'm using for XFS stable maintenace, I can now easily reproduce a
crash. The crash actually triggers *right away* so a loop is often not needed.

[0] https://gitlab.com/mcgrof/oscheck

# xfs_info /dev/loop5
meta-data=/dev/loop5             isize=256    agcount=4, agsize=1310720 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0, sparse=0, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=5242880, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Note that the crash on this report is different than that reported and observed
currently on upstream [1].

[1] https://bugzilla.kernel.org/show_bug.cgi?id=204049

The crash from the log:

[129134.433052] XFS (loop5): Mounting V4 Filesystem
[129134.448216] XFS (loop5): Starting recovery (logdev: internal)
[129134.490377] XFS (loop5): Ending recovery (logdev: internal)
[129135.496378] XFS (loop5): xfs_do_force_shutdown(0x8) called from line 463 of
file fs/xfs/libxfs/xfs_defer.c.  Return address = 00000000aec438ec
[129135.499383] BUG: unable to handle kernel NULL pointer dereference at
00000000000000a4
[129135.501291] PGD 0 P4D 0
[129135.502040] Oops: 0000 [#1] SMP PTI
[129135.502974] CPU: 6 PID: 12203 Comm: fsstress Tainted: G            E    
4.19.58 #3
[129135.504855] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[129135.507540] RIP: 0010:xfs_trans_brelse+0x21/0xd0 [xfs]
[129135.508817] Code: e5 eb 8d 66 0f 1f 44 00 00 0f 1f 44 00 00 41 54 49 89 f4
55 53 48 85 ff 0f 84 a1 00 00 00 48 8b ae e8 00 00 00 0f 1f 44 00 00 <8b> 85 a4
00 00 00
 85 c0 75 5a 48 8b 45 40 a8 08 75 09 f6 85 a0 00
[129135.513156] RSP: 0018:ffff98ee01533ba0 EFLAGS: 00010286
[129135.514453] RAX: 00000000fffffffb RBX: ffff8c50a85c0000 RCX:
0000000000000000
[129135.516216] RDX: 00000000ffffffc0 RSI: ffff8c50af5ed800 RDI:
ffff8c50b557dde8
[129135.517985] RBP: 0000000000000000 R08: 0000000000000000 R09:
0000000000000000
[129135.519749] R10: 000000000000000a R11: f000000000000000 R12:
ffff8c50af5ed800
[129135.521515] R13: 0000000000000000 R14: ffff8c4fd8d87bc0 R15:
00000000fffffffb
[129135.523284] FS:  00007f38aacefb80(0000) GS:ffff8c50b7b80000(0000)
knlGS:0000000000000000
[129135.525237] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[129135.526645] CR2: 00000000000000a4 CR3: 00000002337f8004 CR4:
00000000007606e0
[129135.528416] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[129135.530185] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[129135.531953] PKRU: 55555554
[129135.532725] Call Trace:
[129135.533472]  xfs_attr_set+0x3b9/0x420 [xfs]
[129135.534568]  xfs_xattr_set+0x4e/0x90 [xfs]
[129135.535638]  ? lookup_fast+0xc8/0x2e0
[129135.536616]  __vfs_setxattr+0x66/0x80
[129135.537607]  __vfs_setxattr_noperm+0x67/0x1a0
[129135.538722]  ? inode_permission+0x31/0x180
[129135.539843]  vfs_setxattr+0x81/0xa0
[129135.540914]  ? setxattr+0xa1/0x1c0
[129135.541833]  setxattr+0x13b/0x1c0
[129135.542734]  ? filename_lookup.part.62+0xe0/0x170
[129135.543925]  ? __check_object_size+0x15d/0x189
[129135.545074]  ? strncpy_from_user+0x4a/0x160
[129135.546157]  path_setxattr+0xbe/0xe0
[129135.547110]  __x64_sys_setxattr+0x27/0x30
[129135.548159]  do_syscall_64+0x55/0xf0
[129135.549120]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[129135.550375] RIP: 0033:0x7f38aade843a
[129135.551329] Code: 48 8b 0d 59 3a 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e
0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 bc 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 26 3a 0c 00 f7 d8 64 89 01 48
[129135.555577] RSP: 002b:00007ffe4eb6a6c8 EFLAGS: 00000202 ORIG_RAX:
00000000000000bc
[129135.557436] RAX: ffffffffffffffda RBX: 0000000000000064 RCX:
00007f38aade843a
[129135.559207] RDX: 000055a62efd2810 RSI: 00007ffe4eb6a700 RDI:
000055a62efd27e0
[129135.560971] RBP: 0000000000000002 R08: 0000000000000001 R09:
00007ffe4eb6a437
[129135.562745] R10: 0000000000000064 R11: 0000000000000202 R12:
0000000000000001
[129135.564501] R13: 000000000000096f R14: 00007ffe4eb6a700 R15:
000055a62efd2810
[129135.566269] Modules linked in: loop(E) xfs(E) libcrc32c(E)
crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E) aesni_intel(E)
aes_x86_64(E) crypto_simd(E) cryptd(E) glue_helper(E) virtio_balloon(E)
evdev(E) joydev(E) pcspkr(E) serio_raw(E) i6300esb(E) button(E) ip_tables(E)
x_tables(E) autofs4(E) ext4(E) crc32c_generic(E) crc16(E) mbcache(E) jbd2(E)
fscrypto(E) ata_generic(E) virtio_net(E) net_failover(E) failover(E)
virtio_blk(E) ata_piix(E) libata(E) nvme(E) uhci_hcd(E) scsi_mod(E) ehci_hcd(E)
psmouse(E) virtio_pci(E) nvme_core(E) virtio_ring(E) crc32c_intel(E) usbcore(E)
virtio(E) i2c_piix4(E) floppy(E)
[129135.572747] XFS (loop5): writeback error on sector 2434464
[129135.578585] CR2: 00000000000000a4
[129135.578587] ---[ end trace 4929621d71ca58c2 ]---
[129135.578622] RIP: 0010:xfs_trans_brelse+0x21/0xd0 [xfs]
[129135.578624] Code: e5 eb 8d 66 0f 1f 44 00 00 0f 1f 44 00 00 41 54 49 89 f4
55 53 48 85 ff 0f 84 a1 00 00 00 48 8b ae e8 00 00 00 0f 1f 44 00 00 <8b> 85 a4
00 00 00 85 c0 75 5a 48 8b 45 40 a8 08 75 09 f6 85 a0 00
[129135.587555] RSP: 0018:ffff98ee01533ba0 EFLAGS: 00010286
[129135.588849] RAX: 00000000fffffffb RBX: ffff8c50a85c0000 RCX:
0000000000000000
[129135.590610] RDX: 00000000ffffffc0 RSI: ffff8c50af5ed800 RDI:
ffff8c50b557dde8
[129135.592381] RBP: 0000000000000000 R08: 0000000000000000 R09:
0000000000000000
[129135.594146] R10: 000000000000000a R11: f000000000000000 R12:
ffff8c50af5ed800
[129135.595912] R13: 0000000000000000 R14: ffff8c4fd8d87bc0 R15:
00000000fffffffb
[129135.597680] FS:  00007f38aacefb80(0000) GS:ffff8c50b7b80000(0000)
knlGS:0000000000000000
[129135.599659] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[129135.601066] CR2: 00000000000000a4 CR3: 00000002337f8004 CR4:
00000000007606e0
[129135.602840] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[129135.604606] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[129135.606376] PKRU: 55555554


Referenced Bugs:

https://bugzilla.kernel.org/show_bug.cgi?id=204049
[Bug 204049] [xfstests generic/388]: XFS: Assertion failed: ip->i_d.di_format
!= XFS_DINODE_FMT_BTREE || ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip,
XFS_DATA_FORK), file: fs/xfs/xfs_inode.c, line: 3646
-- 
You are receiving this mail because:
You are watching the assignee of the bug.
You are watching someone on the CC list of the bug.
