Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:35974 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163798AbeBOSSh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Feb 2018 13:18:37 -0500
Date: Thu, 15 Feb 2018 19:18:41 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs_scrub: call for testing
Message-ID: <20180215191841.1cf3a76b@harpe.intellique.com>
In-Reply-To: <e0ada9ef-aafb-5179-2729-447d67bd6265@sandeen.net>
References: <e0ada9ef-aafb-5179-2729-447d67bd6265@sandeen.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/eBcymdldm4R/=5db._T75WG"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

--Sig_/eBcymdldm4R/=5db._T75WG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Fri, 2 Feb 2018 15:36:33 -0600
Eric Sandeen <sandeen@sandeen.net> =C3=A9crivait:

> Hey all -=20
>=20
> Darrick's done a great job with landing the xfs_scrub code in
> upstream kernel v4.15, and now merged on the for-next branch of
> xfsprogs to be released in xfsprogs-4.15.0.
>=20
> As with any big new body of code, there might be some rough
> edges despite best efforts.  It'd be great to have people do
> some testing at this semi-early stage.
>=20
> The 10,000ft overview is that the new xfs_scrub command can
> /validate/ a lot of what's on disk while the filesystem
> is mounted; and the ability to repair will come in the future.
>=20
> For now, with the 4.15 kernel, functionality is limited to
> "scrubbing" meaning that it will simply check for consistency;
> in 4.15 there is no facility to repair or optimize/preen the
> filesystem.
>=20
> I'd really value feedback on scrub as it stand at this point -
> Is the documentation clear?  Is the output correct?  Do the
> tool's arguments make sense?  Does it segfault?  Does it
> find real errors?  Does it crash your kernel? Does it
> eat your data?
>=20

It's enabled

~# grep SCRUB /boot/config-4.15.3-storiq64

We live dangerously here:

[   24.217353] XFS (vdb): EXPERIMENTAL reflink feature enabled. Use at
your own risk! [   24.217646] XFS (vdb): Mounting V5 Filesystem
[   24.247828] XFS (vdb): Starting recovery (logdev: internal)
[   24.251312] XFS (vdb): Ending recovery (logdev: internal)


So it works:



CONFIG_EDAC_ATOMIC_SCRUB=3Dy
CONFIG_XEN_SCRUB_PAGES=3Dy
CONFIG_XFS_ONLINE_SCRUB=3Dy
~# xfs_scrub /mnt/raid/
EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
Error: /mnt/raid: Kernel metadata optimization facility is not
available.  Use -n to scrub. Info: /mnt/raid: Scrub aborted after phase
1. /mnt/raid: 2 errors found.
~#=20
~# xfs_scrub -n /mnt/raid/
EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
Info: AG 1 superblock: Optimization is possible.
Info: AG 2 superblock: Optimization is possible.
Info: AG 3 superblock: Optimization is possible.
515,5MiB data used;  19,0 inodes used.
372,6MiB data found; 19,0 inodes found.
~#=20
~#=20

After a dirty unmount:

root@storiq-clef-usb:~# xfs_scrub -n /mnt/raid/
EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
Info: AG 1 superblock: Optimization is possible.
Info: AG 2 superblock: Optimization is possible.
Info: AG 3 superblock: Optimization is possible.
877,9MiB data used;  27,0 inodes used.
735,0MiB data found; 27,0 inodes found.

After mangling the device with an hex editor:

~# xfs_scrub -n /mnt/raid/
EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
Info: AG 1 superblock: Optimization is possible.
Info: AG 2 superblock: Optimization is possible.
Info: AG 3 superblock: Optimization is possible.
Error: Inode 96 directory entries: Repairs are required.
Error: Inode 99 inode record: Repairs are required.
Error: Inode 99 data block map: Repairs are required.
Error: Inode 99 attr block map: Repairs are required.
Error: Inode 99 CoW block map: Repairs are required.
Error: Inode 99 extended attributes: Repairs are required.
Error: Inode 99 parent pointer: Repairs are required.
Info: /mnt/raid: Filesystem has errors, skipping connectivity checks.
877,9MiB data used;  27,0 inodes used.
735,0MiB data found; 27,0 inodes found.
/mnt/raid: 7 errors found.  Unmount and run xfs_repair.

I then mangled the file some more, but it didn't mount anymore
(structure needs repair).=20

Here is the output of dmesg during these experiments:

[  239.408757] Call Trace:
[  239.408776]  xfs_corruption_error+0x85/0x90 [xfs]
[  239.408794]  ? xfs_iget+0x30d/0x700 [xfs]
[  239.408811]  xfs_iread+0x1bd/0x1f0 [xfs]
[  239.408829]  ? xfs_iget+0x30d/0x700 [xfs]
[  239.408847]  xfs_iget+0x30d/0x700 [xfs]
[  239.408850]  ? kstrtoll+0x22/0x70
[  239.408865]  xfs_scrub_get_inode+0x79/0x180 [xfs]
[  239.408880]  xfs_scrub_setup_inode_bmap+0x11/0xb0 [xfs]
[  239.408895]  xfs_scrub_metadata+0x22d/0x2b0 [xfs]
[  239.408915]  ? xfs_scrub_bmap+0x380/0x380 [xfs]
[  239.408952]  xfs_ioc_scrub_metadata+0x41/0x70 [xfs]
[  239.408975]  xfs_file_ioctl+0x8be/0xa30 [xfs]
[  239.408996]  ? __queue_work+0xf7/0x2a0
[  239.408997]  ? pty_write+0x42/0x50
[  239.408999]  ? __clear_rsb+0x25/0x3d
[  239.409001]  ? __clear_rsb+0x15/0x3d
[  239.409003]  ? __clear_rsb+0x25/0x3d
[  239.409004]  ? __clear_rsb+0x15/0x3d
[  239.409006]  ? __clear_rsb+0x25/0x3d
[  239.409007]  ? __clear_rsb+0x15/0x3d
[  239.409018]  ? __clear_rsb+0x25/0x3d
[  239.409020]  ? __clear_rsb+0x15/0x3d
[  239.409021]  ? __clear_rsb+0x25/0x3d
[  239.409023]  ? __clear_rsb+0x15/0x3d
[  239.409025]  ? __clear_rsb+0x25/0x3d
[  239.409026]  ? __clear_rsb+0x15/0x3d
[  239.409028]  ? __clear_rsb+0x25/0x3d
[  239.409029]  ? __clear_rsb+0x15/0x3d
[  239.409031]  ? __clear_rsb+0x25/0x3d
[  239.409032]  ? __clear_rsb+0x15/0x3d
[  239.409034]  ? __clear_rsb+0x25/0x3d
[  239.409035]  ? __clear_rsb+0x15/0x3d
[  239.409037]  ? __clear_rsb+0x25/0x3d
[  239.409038]  ? __clear_rsb+0x15/0x3d
[  239.409040]  ? __clear_rsb+0x25/0x3d
[  239.409042]  ? __clear_rsb+0x15/0x3d
[  239.409043]  ? __clear_rsb+0x25/0x3d
[  239.409045]  ? __clear_rsb+0x15/0x3d
[  239.409046]  ? __clear_rsb+0x25/0x3d
[  239.409048]  ? __clear_rsb+0x15/0x3d
[  239.409049]  ? __clear_rsb+0x25/0x3d
[  239.409051]  ? __clear_rsb+0x15/0x3d
[  239.409053]  do_vfs_ioctl+0x86/0x5a0
[  239.409055]  ? __schedule+0x214/0x6d0
[  239.409057]  SyS_ioctl+0x36/0x70
[  239.409058]  ? exit_to_usermode_loop+0x6a/0x90
[  239.409060]  do_syscall_64+0x60/0x190
[  239.409062]  entry_SYSCALL_64_after_hwframe+0x21/0x86
[  239.409063] RIP: 0033:0x7f9c0acb41c7
[  239.409064] RSP: 002b:00007ffe2d223d48 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000010
[  239.409065] RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007f9c0ac=
b41c7
[  239.409066] RDX: 00007ffe2d223e90 RSI: 00000000c040583c RDI: 00000000000=
00003
[  239.409067] RBP: 00007ffe2d223e90 R08: 000000000040e254 R09: 00007f9c0ac=
1e99a
[  239.409068] R10: 00007f9c0af77460 R11: 0000000000000246 R12: 00000000000=
00003
[  239.409069] R13: 00007ffe2d226940 R14: 0000000000000001 R15: 00007ffe2d2=
23f60
[  239.409071] XFS (vdb): Corruption detected. Unmount and run xfs_repair
[  239.409240] XFS (vdb): xfs_iread: validation failed for inode 99
[  239.409242] 00000000a80c7e65: 49 4e 41 ed 03 01 00 00 00 00 03 e8 00 00 =
00 64  INA............d
[  239.409243] 00000000ba03f95e: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 =
00 00  ................
[  239.409244] 000000004897c577: 5a 85 bd d9 16 ce 05 cf 59 5d 16 8d 1d e6 =
0d 5e  Z.......Y].....^
[  239.409245] 00000000a7d0657f: 59 63 97 ca 2e d7 1c f7 00 00 00 00 00 00 =
01 41  Yc.............A
[  239.409267] XFS (vdb): Internal error xfs_iread at line 514 of file fs/x=
fs/libxfs/xfs_inode_buf.c.  Caller xfs_iget+0x30d/0x700 [xfs]
[  239.409268] CPU: 0 PID: 2080 Comm: xfs_scrub Not tainted 4.15.3-storiq64=
 #1
[  239.409269] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[  239.409270] Call Trace:
[  239.409290]  xfs_corruption_error+0x85/0x90 [xfs]
[  239.409308]  ? xfs_iget+0x30d/0x700 [xfs]
[  239.409325]  xfs_iread+0x1bd/0x1f0 [xfs]
[  239.409348]  ? xfs_iget+0x30d/0x700 [xfs]
[  239.409379]  xfs_iget+0x30d/0x700 [xfs]
[  239.409382]  ? kstrtoll+0x22/0x70
[  239.409397]  xfs_scrub_get_inode+0x79/0x180 [xfs]
[  239.409413]  xfs_scrub_setup_inode_bmap+0x11/0xb0 [xfs]
[  239.409427]  xfs_scrub_metadata+0x22d/0x2b0 [xfs]
[  239.409443]  ? xfs_scrub_bmap+0x380/0x380 [xfs]
[  239.409461]  xfs_ioc_scrub_metadata+0x41/0x70 [xfs]
[  239.409479]  xfs_file_ioctl+0x8be/0xa30 [xfs]
[  239.409481]  ? __queue_work+0xf7/0x2a0
[  239.409482]  ? pty_write+0x42/0x50
[  239.409484]  ? __clear_rsb+0x25/0x3d
[  239.409486]  ? __clear_rsb+0x15/0x3d
[  239.409488]  ? __clear_rsb+0x25/0x3d
[  239.409489]  ? __clear_rsb+0x15/0x3d
[  239.409491]  ? __clear_rsb+0x25/0x3d
[  239.409493]  ? __clear_rsb+0x15/0x3d
[  239.409494]  ? __clear_rsb+0x25/0x3d
[  239.409496]  ? __clear_rsb+0x15/0x3d
[  239.409497]  ? __clear_rsb+0x25/0x3d
[  239.409499]  ? __clear_rsb+0x15/0x3d
[  239.409501]  ? __clear_rsb+0x25/0x3d
[  239.409502]  ? __clear_rsb+0x15/0x3d
[  239.409504]  ? __clear_rsb+0x25/0x3d
[  239.409505]  ? __clear_rsb+0x15/0x3d
[  239.409507]  ? __clear_rsb+0x25/0x3d
[  239.409509]  ? __clear_rsb+0x15/0x3d
[  239.409510]  ? __clear_rsb+0x25/0x3d
[  239.409512]  ? __clear_rsb+0x15/0x3d
[  239.409514]  ? __clear_rsb+0x25/0x3d
[  239.409515]  ? __clear_rsb+0x15/0x3d
[  239.409517]  ? __clear_rsb+0x25/0x3d
[  239.409518]  ? __clear_rsb+0x15/0x3d
[  239.409520]  ? __clear_rsb+0x25/0x3d
[  239.409522]  ? __clear_rsb+0x15/0x3d
[  239.409523]  ? __clear_rsb+0x25/0x3d
[  239.409525]  ? __clear_rsb+0x15/0x3d
[  239.409526]  ? __clear_rsb+0x25/0x3d
[  239.409528]  ? __clear_rsb+0x15/0x3d
[  239.409530]  do_vfs_ioctl+0x86/0x5a0
[  239.409532]  ? __schedule+0x214/0x6d0
[  239.409534]  SyS_ioctl+0x36/0x70
[  239.409535]  ? exit_to_usermode_loop+0x6a/0x90
[  239.409537]  do_syscall_64+0x60/0x190
[  239.409539]  entry_SYSCALL_64_after_hwframe+0x21/0x86
[  239.409540] RIP: 0033:0x7f9c0acb41c7
[  239.409541] RSP: 002b:00007ffe2d223d48 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000010
[  239.409542] RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007f9c0ac=
b41c7
[  239.409543] RDX: 00007ffe2d223e90 RSI: 00000000c040583c RDI: 00000000000=
00003
[  239.409544] RBP: 00007ffe2d223e90 R08: 000000000040e263 R09: 00007f9c0ac=
1e99a
[  239.409545] R10: 00007f9c0af77460 R11: 0000000000000246 R12: 00000000000=
00003
[  239.409546] R13: 00007ffe2d226940 R14: 0000000000000001 R15: 00007ffe2d2=
23f60
[  239.409547] XFS (vdb): Corruption detected. Unmount and run xfs_repair
[  239.409728] XFS (vdb): xfs_iread: validation failed for inode 99
[  239.409730] 00000000a80c7e65: 49 4e 41 ed 03 01 00 00 00 00 03 e8 00 00 =
00 64  INA............d
[  239.409732] 00000000ba03f95e: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 =
00 00  ................
[  239.409733] 000000004897c577: 5a 85 bd d9 16 ce 05 cf 59 5d 16 8d 1d e6 =
0d 5e  Z.......Y].....^
[  239.409733] 00000000a7d0657f: 59 63 97 ca 2e d7 1c f7 00 00 00 00 00 00 =
01 41  Yc.............A
[  239.409752] XFS (vdb): Internal error xfs_iread at line 514 of file fs/x=
fs/libxfs/xfs_inode_buf.c.  Caller xfs_iget+0x30d/0x700 [xfs]
[  239.409754] CPU: 0 PID: 2080 Comm: xfs_scrub Not tainted 4.15.3-storiq64=
 #1
[  239.409755] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[  239.409755] Call Trace:
[  239.409779]  xfs_corruption_error+0x85/0x90 [xfs]
[  239.409814]  ? xfs_iget+0x30d/0x700 [xfs]
[  239.409832]  xfs_iread+0x1bd/0x1f0 [xfs]
[  239.409851]  ? xfs_iget+0x30d/0x700 [xfs]
[  239.409869]  xfs_iget+0x30d/0x700 [xfs]
[  239.409885]  xfs_scrub_get_inode+0x79/0x180 [xfs]
[  239.409900]  xfs_scrub_setup_inode_contents+0x11/0x70 [xfs]
[  239.409916]  ? xfs_scrub_setup_xattr+0x3e/0x60 [xfs]
[  239.409930]  xfs_scrub_metadata+0x22d/0x2b0 [xfs]
[  239.409946]  ? xfs_scrub_xattr_rec+0x130/0x130 [xfs]
[  239.409970]  xfs_ioc_scrub_metadata+0x41/0x70 [xfs]
[  239.410005]  xfs_file_ioctl+0x8be/0xa30 [xfs]
[  239.410007]  ? __queue_work+0xf7/0x2a0
[  239.410018]  ? pty_write+0x42/0x50
[  239.410020]  ? __clear_rsb+0x25/0x3d
[  239.410022]  ? __clear_rsb+0x15/0x3d
[  239.410024]  ? __clear_rsb+0x25/0x3d
[  239.410025]  ? __clear_rsb+0x15/0x3d
[  239.410027]  ? __clear_rsb+0x25/0x3d
[  239.410028]  ? __clear_rsb+0x15/0x3d
[  239.410030]  ? __clear_rsb+0x25/0x3d
[  239.410031]  ? __clear_rsb+0x15/0x3d
[  239.410033]  ? __clear_rsb+0x25/0x3d
[  239.410034]  ? __clear_rsb+0x15/0x3d
[  239.410036]  ? __clear_rsb+0x25/0x3d
[  239.410037]  ? __clear_rsb+0x15/0x3d
[  239.410039]  ? __clear_rsb+0x25/0x3d
[  239.410040]  ? __clear_rsb+0x15/0x3d
[  239.410042]  ? __clear_rsb+0x25/0x3d
[  239.410044]  ? __clear_rsb+0x15/0x3d
[  239.410045]  ? __clear_rsb+0x25/0x3d
[  239.410047]  ? __clear_rsb+0x15/0x3d
[  239.410048]  ? __clear_rsb+0x25/0x3d
[  239.410050]  ? __clear_rsb+0x15/0x3d
[  239.410051]  ? __clear_rsb+0x25/0x3d
[  239.410053]  ? __clear_rsb+0x15/0x3d
[  239.410054]  ? __clear_rsb+0x25/0x3d
[  239.410056]  ? __clear_rsb+0x15/0x3d
[  239.410057]  ? __clear_rsb+0x25/0x3d
[  239.410059]  ? __clear_rsb+0x15/0x3d
[  239.410060]  ? __clear_rsb+0x25/0x3d
[  239.410062]  ? __clear_rsb+0x15/0x3d
[  239.410064]  do_vfs_ioctl+0x86/0x5a0
[  239.410066]  ? __schedule+0x214/0x6d0
[  239.410068]  SyS_ioctl+0x36/0x70
[  239.410069]  ? exit_to_usermode_loop+0x6a/0x90
[  239.410071]  do_syscall_64+0x60/0x190
[  239.410073]  entry_SYSCALL_64_after_hwframe+0x21/0x86
[  239.410074] RIP: 0033:0x7f9c0acb41c7
[  239.410075] RSP: 002b:00007ffe2d223d48 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000010
[  239.410077] RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007f9c0ac=
b41c7
[  239.410077] RDX: 00007ffe2d223e90 RSI: 00000000c040583c RDI: 00000000000=
00003
[  239.410078] RBP: 00007ffe2d223e90 R08: 000000000040e283 R09: 00007f9c0ac=
1e99a
[  239.410079] R10: 00007f9c0af77460 R11: 0000000000000246 R12: 00000000000=
00003
[  239.410080] R13: 00007ffe2d226940 R14: 0000000000000001 R15: 00007ffe2d2=
23f60
[  239.410082] XFS (vdb): Corruption detected. Unmount and run xfs_repair
[  239.410256] XFS (vdb): xfs_iread: validation failed for inode 99
[  239.410258] 00000000a80c7e65: 49 4e 41 ed 03 01 00 00 00 00 03 e8 00 00 =
00 64  INA............d
[  239.410259] 00000000ba03f95e: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 =
00 00  ................
[  239.410260] 000000004897c577: 5a 85 bd d9 16 ce 05 cf 59 5d 16 8d 1d e6 =
0d 5e  Z.......Y].....^
[  239.410261] 00000000a7d0657f: 59 63 97 ca 2e d7 1c f7 00 00 00 00 00 00 =
01 41  Yc.............A
[  239.410282] XFS (vdb): Internal error xfs_iread at line 514 of file fs/x=
fs/libxfs/xfs_inode_buf.c.  Caller xfs_iget+0x30d/0x700 [xfs]
[  239.410284] CPU: 0 PID: 2080 Comm: xfs_scrub Not tainted 4.15.3-storiq64=
 #1
[  239.410285] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[  239.410285] Call Trace:
[  239.410304]  xfs_corruption_error+0x85/0x90 [xfs]
[  239.410323]  ? xfs_iget+0x30d/0x700 [xfs]
[  239.410340]  xfs_iread+0x1bd/0x1f0 [xfs]
[  239.410362]  ? xfs_iget+0x30d/0x700 [xfs]
[  239.410396]  xfs_iget+0x30d/0x700 [xfs]
[  239.410412]  xfs_scrub_get_inode+0x79/0x180 [xfs]
[  239.410427]  xfs_scrub_setup_inode_contents+0x11/0x70 [xfs]
[  239.410442]  xfs_scrub_metadata+0x22d/0x2b0 [xfs]
[  239.410456]  ? xfs_scrub_parent_validate+0x240/0x240 [xfs]
[  239.410475]  xfs_ioc_scrub_metadata+0x41/0x70 [xfs]
[  239.410494]  xfs_file_ioctl+0x8be/0xa30 [xfs]
[  239.410496]  ? __queue_work+0xf7/0x2a0
[  239.410498]  ? pty_write+0x42/0x50
[  239.410500]  ? __clear_rsb+0x25/0x3d
[  239.410501]  ? __clear_rsb+0x15/0x3d
[  239.410503]  ? __clear_rsb+0x25/0x3d
[  239.410505]  ? __clear_rsb+0x15/0x3d
[  239.410506]  ? __clear_rsb+0x25/0x3d
[  239.410508]  ? __clear_rsb+0x15/0x3d
[  239.410509]  ? __clear_rsb+0x25/0x3d
[  239.410511]  ? __clear_rsb+0x15/0x3d
[  239.410512]  ? __clear_rsb+0x25/0x3d
[  239.410514]  ? __clear_rsb+0x15/0x3d
[  239.410515]  ? __clear_rsb+0x25/0x3d
[  239.410517]  ? __clear_rsb+0x15/0x3d
[  239.410519]  ? __clear_rsb+0x25/0x3d
[  239.410520]  ? __clear_rsb+0x15/0x3d
[  239.410522]  ? __clear_rsb+0x25/0x3d
[  239.410523]  ? __clear_rsb+0x15/0x3d
[  239.410525]  ? __clear_rsb+0x25/0x3d
[  239.410526]  ? __clear_rsb+0x15/0x3d
[  239.410528]  ? __clear_rsb+0x25/0x3d
[  239.410529]  ? __clear_rsb+0x15/0x3d
[  239.410531]  ? __clear_rsb+0x25/0x3d
[  239.410532]  ? __clear_rsb+0x15/0x3d
[  239.410534]  ? __clear_rsb+0x25/0x3d
[  239.410535]  ? __clear_rsb+0x15/0x3d
[  239.410537]  ? __clear_rsb+0x25/0x3d
[  239.410539]  ? __clear_rsb+0x15/0x3d
[  239.410540]  ? __clear_rsb+0x25/0x3d
[  239.410542]  ? __clear_rsb+0x15/0x3d
[  239.410543]  do_vfs_ioctl+0x86/0x5a0
[  239.410546]  ? __schedule+0x214/0x6d0
[  239.410547]  SyS_ioctl+0x36/0x70
[  239.410549]  ? exit_to_usermode_loop+0x6a/0x90
[  239.410550]  do_syscall_64+0x60/0x190
[  239.410552]  entry_SYSCALL_64_after_hwframe+0x21/0x86
[  239.410553] RIP: 0033:0x7f9c0acb41c7
[  239.410554] RSP: 002b:00007ffe2d223d48 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000010
[  239.410556] RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007f9c0ac=
b41c7
[  239.410557] RDX: 00007ffe2d223e90 RSI: 00000000c040583c RDI: 00000000000=
00003
[  239.410558] RBP: 00007ffe2d223e90 R08: 000000000040e2a5 R09: 00007f9c0ac=
1e99a
[  239.410558] R10: 00007f9c0af77460 R11: 0000000000000246 R12: 00000000000=
00003
[  239.410559] R13: 00007ffe2d226940 R14: 0000000000000001 R15: 00007ffe2d2=
23f60
[  239.410561] XFS (vdb): Corruption detected. Unmount and run xfs_repair
[  239.410679] systemd-journald[197]: /dev/kmsg buffer overrun, some messag=
es lost.
[  289.069032] XFS (vdb): Unmounting Filesystem
[  347.669570] XFS (vdb): EXPERIMENTAL reflink feature enabled. Use at your=
 own risk!
[  347.669785] XFS (vdb): Mounting V5 Filesystem
[  347.678771] XFS (vdb): Ending clean mount
[  402.947693] XFS (vdb): Unmounting Filesystem
[  476.483462] XFS (vdb): EXPERIMENTAL reflink feature enabled. Use at your=
 own risk!
[  476.483653] XFS (vdb): Mounting V5 Filesystem
[  476.494540] XFS (vdb): xfs_iread: validation failed for inode 96
[  476.494548] 00000000687389b7: 49 4e 41 ed 03 01 00 00 00 00 00 00 00 00 =
00 00  INA.............
[  476.494550] 00000000119c2671: 00 00 00 05 00 00 00 00 00 00 00 00 00 00 =
00 00  ................
[  476.494552] 00000000f81aa31f: 5a 85 cc 89 3a 7d aa 56 5a 85 cb d6 2c 7a =
9d 23  Z...:}.VZ...,z.#
[  476.494553] 0000000073ce204e: 5a 85 cb d6 2c 7a 9d 23 00 00 00 00 00 00 =
00 3c  Z...,z.#.......<
[  476.494622] XFS (vdb): Internal error xfs_iread at line 514 of file fs/x=
fs/libxfs/xfs_inode_buf.c.  Caller xfs_iget+0x30d/0x700 [xfs]
[  476.494627] CPU: 0 PID: 2450 Comm: mount Not tainted 4.15.3-storiq64 #1
[  476.494629] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[  476.494631] Call Trace:
[  476.494662]  xfs_corruption_error+0x85/0x90 [xfs]
[  476.494686]  ? xfs_iget+0x30d/0x700 [xfs]
[  476.494707]  xfs_iread+0x1bd/0x1f0 [xfs]
[  476.494730]  ? xfs_iget+0x30d/0x700 [xfs]
[  476.494751]  xfs_iget+0x30d/0x700 [xfs]
[  476.494773]  ? xlog_cil_init_post_recovery+0x27/0x50 [xfs]
[  476.494793]  xfs_mountfs+0x542/0x900 [xfs]
[  476.494815]  xfs_fs_fill_super+0x35d/0x4f0 [xfs]
[  476.494837]  ? xfs_test_remount_options.isra.24+0x50/0x50 [xfs]
[  476.494843]  mount_bdev+0x16d/0x1a0
[  476.494869]  mount_fs+0xc/0x70
[  476.494879]  vfs_kern_mount+0x59/0x110
[  476.494893]  ? __get_fs_type+0x17/0x30
[  476.494896]  do_mount+0x196/0xb50
[  476.494909]  ? memdup_user+0x39/0x60
[  476.494912]  SyS_mount+0x7f/0xc0
[  476.494917]  do_syscall_64+0x60/0x190
[  476.494924]  entry_SYSCALL_64_after_hwframe+0x21/0x86
[  476.494928] RIP: 0033:0x7f8a43e06d8a
[  476.494930] RSP: 002b:00007ffc2baaa498 EFLAGS: 00000202 ORIG_RAX: 000000=
00000000a5
[  476.494933] RAX: ffffffffffffffda RBX: 000000000060b040 RCX: 00007f8a43e=
06d8a
[  476.494934] RDX: 000000000060f620 RSI: 000000000060df30 RDI: 00000000006=
0b220
[  476.494935] RBP: 0000000000000000 R08: 0000000000000000 R09: 00007f8a43d=
6999a
[  476.494936] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 00000000006=
0b220
[  476.494937] R13: 000000000060f620 R14: 0000000000000000 R15: 00000000000=
00001
[  476.494940] XFS (vdb): Corruption detected. Unmount and run xfs_repair
[  476.494948] XFS (vdb): failed to read root inode


Et voil=C3=A0 :)
--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/eBcymdldm4R/=5db._T75WG
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlqFzwEACgkQX3jQXNUicVapPwCgk/cPTkKnX4MhCX7nDfEEuFf7
4TMAoIbyn0OKrKexCzasyYSB9VvObH44
=3PLH
-----END PGP SIGNATURE-----

--Sig_/eBcymdldm4R/=5db._T75WG--
