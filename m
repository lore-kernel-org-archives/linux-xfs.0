Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6PNKgNk084716 for <xfs@oss.sgi.com>; Sun, 25 Jul 2010 18:20:43 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE40FDEE7BB
	for <xfs@oss.sgi.com>; Sun, 25 Jul 2010 16:23:44 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id rFU5pdZjyXkEfIv5 for
	<xfs@oss.sgi.com>; Sun, 25 Jul 2010 16:23:44 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id DA45D17C
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 01:23:42 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 322D183C804
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 01:22:51 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: bug and fun with XFS: unable to handle kernel NULL pointer dereference
Date: Mon, 26 Jul 2010 00:19:47 +0200
MIME-Version: 1.0
Message-Id: <201007260019.51568@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5682044047329267212=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5682044047329267212==
Content-Type: multipart/signed;
  boundary="nextPart7279667.CxqmJWFvOW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart7279667.CxqmJWFvOW
Content-Type: multipart/mixed;
  boundary="Boundary-01=_DiLTM4Bh7hbxdGP"
Content-Transfer-Encoding: 7bit


--Boundary-01=_DiLTM4Bh7hbxdGP
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I just enjoy an obviously broken XFS filesystem. It was a running=20
server, which I planned to migrate so I did "rsync -aHAX /=20
otherhost::rsyncmodule", and experienced a "killed". At that time I=20
thought it was a one time mistake, so restarted rsync, but Murphy made=20
it get killed again.

So I looked into dmesg, just to find this: It's the log of all messages,=20
so maybe twice the same, I copy everything for reference. See attachment=20
"xfs-bug.dmesg.txt".

I started to look, and quickly found a funny problem: Once I mount that=20
partition, I cannot unmount it again:

# mount /disks/work/
# umount /disks/work/
umount: /disks/work: device is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))

So I rebooted without mounting that partition, and=20

# xfs_repair -n /dev/xvda2 [VERSION:3.1.2]
xfs_repair: /lib64/libuuid.so.1: no version information available=20
(required by xfs_repair)                                                   =
                                                                           =
           =20
Phase 1 - find and verify superblock...                                    =
                                                                           =
                                                                           =
  =20
Phase 2 - using internal log                                               =
                                                                           =
                                                                           =
  =20
        - scan filesystem freespace and inode maps...                      =
                                                                           =
                                                                           =
  =20
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno =3D 0
        - agno =3D 1
local inode 8636461 attr too small (size =3D 0, min size =3D 4)
bad attribute fork in inode 8636461, would clear attr fork
would have cleared inode 8636461
        - agno =3D 2
        - agno =3D 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 3
local inode 8636461 attr too small (size =3D 0, min size =3D 4)
bad attribute fork in inode 8636461, would clear attr fork
would have cleared inode 8636461
        - agno =3D 2
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.


xfs_repair corrected it painlessly, and everything fine again. Just=20
wanted to report that a simple mount works and an immediate umount=20
fails. Maybe this could be fixed, would make repair simpler.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--Boundary-01=_DiLTM4Bh7hbxdGP
Content-Type: text/plain;
  charset="UTF-8";
  name="xfs-bug.dmesg.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="xfs-bug.dmesg.txt"

BUG: unable to handle kernel NULL pointer dereference at 0000000000000002
IP: [<ffffffffa0066e0e>] xfs_attr_shortform_getvalue+0x24/0xda [xfs]
PGD 692a5067 PUD 69f6c067 PMD 0=20
Oops: 0000 [1] SMP=20
last sysfs file: /sys/devices/virtual/net/lo/type
CPU 1=20
Modules linked in: binfmt_misc nfs lockd nfs_acl sunrpc ipv6 fuse loop dm_m=
od rtc_core rtc_lib xennet mptspi mptscsih mptbase scsi_transport_spi scsi_=
mod xfs reiserfs thermal_sys hwmon xenblk cdrom
Supported: Yes
Pid: 1809, comm: syslog-ng Not tainted 2.6.27.48-0.1-xen #1
RIP: e030:[<ffffffffa0066e0e>]  [<ffffffffa0066e0e>] xfs_attr_shortform_get=
value+0x24/0xda [xfs]
RSP: e02b:ffff880068b63cd8  EFLAGS: 00010296
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 000000007c7bfd5e
RDX: 000000007c7bc727 RSI: 0000000000000002 RDI: ffff880068b63d18
RBP: ffff880068b63d18 R08: 0000000000002008 R09: ffffffffa00d81b0
R10: ffff880068b63e68 R11: ffffffff80562f0c R12: ffff880068b63dd8
R13: 0000000000000000 R14: 0000000000002008 R15: ffff880068b63e3c
=46S:  00007fae927a76f0(0000) GS:ffff8800014d5140(0000) knlGS:0000000000000=
000
CS:  e033 DS: 0000 ES: 0000
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process syslog-ng (pid: 1809, threadinfo ffff880068b62000, task ffff88006a3=
ce4c0)
Stack:  ffff880069b50600 ffff880069b50600 ffff880069b50600 ffff880068b63dd8
 0000000000000000 0000000000002008 ffff880068b63e3c ffffffffa0065b08
 ffffffff80562f15 000000000000000a 0000000000000000 0000200800000000
Call Trace:
 [<ffffffffa0065b08>] xfs_attr_fetch+0x87/0xd4 [xfs]
 [<ffffffffa0065bd6>] xfs_attr_get+0x81/0xa3 [xfs]
 [<ffffffffa00aea3f>] xfs_xattr_secure_get+0x41/0x4e [xfs]
 [<ffffffff802bb7c2>] generic_getxattr+0x62/0x66
 [<ffffffff803066db>] cap_inode_need_killpriv+0x2d/0x3b
 [<ffffffff802b3ca9>] fnotify_change+0xa6/0x334
 [<ffffffff8029d6cb>] chown_common+0x81/0x9a
 [<ffffffff8029d74b>] sys_fchown+0x67/0x91
 [<ffffffff8020b418>] system_call_fastpath+0x16/0x1b
 [<00007fae91ccfc07>] 0x7fae91ccfc07


Code: 41 5d 41 5e 41 5f c3 41 57 41 56 41 55 45 31 ed 41 54 55 48 89 fd 53 =
48 83 ec 08 48 8b 47 30 48 8b 40 58 48 8b 40 18 48 8d 58 04 <44> 0f b6 78 0=
2 e9 92 00 00 00 44 0f b6 23 44 3b 65 08 75 77 48=20
RIP  [<ffffffffa0066e0e>] xfs_attr_shortform_getvalue+0x24/0xda [xfs]
 RSP <ffff880068b63cd8>
CR2: 0000000000000002
=2D--[ end trace 0b5d9a76acf21c38 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000002
IP: [<ffffffffa0066e0e>] xfs_attr_shortform_getvalue+0x24/0xda [xfs]
PGD 27932067 PUD 35bf2067 PMD 0=20
Oops: 0000 [2] SMP=20
last sysfs file: /sys/devices/xen/vif-1/modalias
CPU 0=20
Modules linked in: binfmt_misc nfs lockd nfs_acl sunrpc ipv6 fuse loop dm_m=
od rtc_core rtc_lib xennet mptspi mptscsih mptbase scsi_transport_spi scsi_=
mod xfs reiserfs thermal_sys hwmon xenblk cdrom
Supported: Yes
Pid: 5866, comm: rsync Tainted: G      D   2.6.27.48-0.1-xen #1
RIP: e030:[<ffffffffa0066e0e>]  [<ffffffffa0066e0e>] xfs_attr_shortform_get=
value+0x24/0xda [xfs]
RSP: e02b:ffff880068b71be8  EFLAGS: 00010296
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00000000275b19c4
RDX: 0000000008d26645 RSI: 00000000ffffffff RDI: ffff880068b71c28
RBP: ffff880068b71c28 R08: 0000000000000002 R09: ffffffffa00d81d0
R10: ffff880068b71e08 R11: ffff880068b71e08 R12: ffff880068b71ce8
R13: 0000000000000000 R14: 0000000000000002 R15: ffff880068b71d44
=46S:  00007f44789eb6f0(0000) GS:ffffffff80763080(0000) knlGS:0000000000000=
000
CS:  e033 DS: 0000 ES: 0000
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rsync (pid: 5866, threadinfo ffff880068b70000, task ffff880027b3028=
0)
Stack:  0000000000000000 ffff880069b50600 ffff880069b50600 ffff880068b71ce8
 ffff8800636e1ea8 0000000000000002 ffff880068b71d44 ffffffffa0065b08
 ffffffffa00b06d4 000000000000000c ffff8800636e1ea8 0000000200000130
Call Trace:
 [<ffffffffa0065b08>] xfs_attr_fetch+0x87/0xd4 [xfs]
 [<ffffffffa0065bd6>] xfs_attr_get+0x81/0xa3 [xfs]
 [<ffffffffa005ce96>] xfs_acl_get_attr+0x46/0x63 [xfs]
 [<ffffffffa005d613>] xfs_acl_vget+0x6b/0xec [xfs]
 [<ffffffff802bb7c2>] generic_getxattr+0x62/0x66
 [<ffffffff802bc09d>] vfs_getxattr+0xaf/0xc1
 [<ffffffff802bc155>] getxattr+0xa6/0x107
 [<ffffffff802bc2e1>] sys_getxattr+0x4c/0x67
 [<ffffffff8020b418>] system_call_fastpath+0x16/0x1b
 [<00007f4477f2ed79>] 0x7f4477f2ed79


Code: 41 5d 41 5e 41 5f c3 41 57 41 56 41 55 45 31 ed 41 54 55 48 89 fd 53 =
48 83 ec 08 48 8b 47 30 48 8b 40 58 48 8b 40 18 48 8d 58 04 <44> 0f b6 78 0=
2 e9 92 00 00 00 44 0f b6 23 44 3b 65 08 75 77 48=20
RIP  [<ffffffffa0066e0e>] xfs_attr_shortform_getvalue+0x24/0xda [xfs]
 RSP <ffff880068b71be8>
CR2: 0000000000000002
=2D--[ end trace 0b5d9a76acf21c38 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000002
IP: [<ffffffffa0066e0e>] xfs_attr_shortform_getvalue+0x24/0xda [xfs]
PGD 6203b067 PUD 13a8c067 PMD 0=20
Oops: 0000 [3] SMP=20
last sysfs file: /sys/devices/xen/vif-1/modalias
CPU 0=20
Modules linked in: binfmt_misc nfs lockd nfs_acl sunrpc ipv6 fuse loop dm_m=
od rtc_core rtc_lib xennet mptspi mptscsih mptbase scsi_transport_spi scsi_=
mod xfs reiserfs thermal_sys hwmon xenblk cdrom
Supported: Yes
Pid: 6042, comm: rsync Tainted: G      D   2.6.27.48-0.1-xen #1
RIP: e030:[<ffffffffa0066e0e>]  [<ffffffffa0066e0e>] xfs_attr_shortform_get=
value+0x24/0xda [xfs]
RSP: e02b:ffff880027b99be8  EFLAGS: 00010296
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00000000275b19c4
RDX: 0000000008d26645 RSI: 00000000ffffffff RDI: ffff880027b99c28
RBP: ffff880027b99c28 R08: 0000000000000002 R09: ffffffffa00d81d0
R10: ffff880027b99e08 R11: ffff880027b99e08 R12: ffff880027b99ce8
R13: 0000000000000000 R14: 0000000000000002 R15: ffff880027b99d44
=46S:  00007fb4d45fc6f0(0000) GS:ffffffff80763080(0000) knlGS:0000000000000=
000
CS:  e033 DS: 0000 ES: 0000
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rsync (pid: 6042, threadinfo ffff880027b98000, task ffff880027be604=
0)
Stack:  0000000000000001 ffff880069b50600 ffff880069b50600 ffff880027b99ce8
 ffff8800636e1068 0000000000000002 ffff880027b99d44 ffffffffa0065b08
 ffffffffa00b06d4 000000000000000c ffff8800636e1068 0000000200000130
Call Trace:
 [<ffffffffa0065b08>] xfs_attr_fetch+0x87/0xd4 [xfs]
 [<ffffffffa0065bd6>] xfs_attr_get+0x81/0xa3 [xfs]
 [<ffffffffa005ce96>] xfs_acl_get_attr+0x46/0x63 [xfs]
 [<ffffffffa005d613>] xfs_acl_vget+0x6b/0xec [xfs]
 [<ffffffff802bb7c2>] generic_getxattr+0x62/0x66
 [<ffffffff802bc09d>] vfs_getxattr+0xaf/0xc1
 [<ffffffff802bc155>] getxattr+0xa6/0x107
 [<ffffffff802bc2e1>] sys_getxattr+0x4c/0x67
 [<ffffffff8020b418>] system_call_fastpath+0x16/0x1b
 [<00007fb4d3b3fd79>] 0x7fb4d3b3fd79


Code: 41 5d 41 5e 41 5f c3 41 57 41 56 41 55 45 31 ed 41 54 55 48 89 fd 53 =
48 83 ec 08 48 8b 47 30 48 8b 40 58 48 8b 40 18 48 8d 58 04 <44> 0f b6 78 0=
2 e9 92 00 00 00 44 0f b6 23 44 3b 65 08 75 77 48=20
RIP  [<ffffffffa0066e0e>] xfs_attr_shortform_getvalue+0x24/0xda [xfs]
 RSP <ffff880027b99be8>
CR2: 0000000000000002
=2D--[ end trace 0b5d9a76acf21c38 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000002
IP: [<ffffffffa0066e0e>] xfs_attr_shortform_getvalue+0x24/0xda [xfs]
PGD 68f43067 PUD 6921f067 PMD 0=20
Oops: 0000 [4] SMP=20
last sysfs file: /sys/devices/xen/vif-1/modalias
CPU 0=20
Modules linked in: binfmt_misc nfs lockd nfs_acl sunrpc ipv6 fuse loop dm_m=
od rtc_core rtc_lib xennet mptspi mptscsih mptbase scsi_transport_spi scsi_=
mod xfs reiserfs thermal_sys hwmon xenblk cdrom
Supported: Yes
Pid: 6084, comm: rsync Tainted: G      D   2.6.27.48-0.1-xen #1
RIP: e030:[<ffffffffa0066e0e>]  [<ffffffffa0066e0e>] xfs_attr_shortform_get=
value+0x24/0xda [xfs]
RSP: e02b:ffff88006a381be8  EFLAGS: 00010296
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00000000275b19c4
RDX: 0000000008d26645 RSI: 00000000ffffffff RDI: ffff88006a381c28
RBP: ffff88006a381c28 R08: 0000000000000002 R09: ffffffffa00d81d0
R10: ffff88006a381e08 R11: ffff88006a381e08 R12: ffff88006a381ce8
R13: 0000000000000000 R14: 0000000000000002 R15: ffff88006a381d44
=46S:  00007f23683d46f0(0000) GS:ffffffff80763080(0000) knlGS:0000000000000=
000
CS:  e033 DS: 0000 ES: 0000
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rsync (pid: 6084, threadinfo ffff88006a380000, task ffff880027be650=
0)
Stack:  ffff880035a7ab40 ffff880069b50600 ffff880069b50600 ffff88006a381ce8
 ffff8800636e1d78 0000000000000002 ffff88006a381d44 ffffffffa0065b08
 ffffffffa00b06d4 000000000000000c ffff8800636e1d78 0000000200000130
Call Trace:
 [<ffffffffa0065b08>] xfs_attr_fetch+0x87/0xd4 [xfs]
 [<ffffffffa0065bd6>] xfs_attr_get+0x81/0xa3 [xfs]
 [<ffffffffa005ce96>] xfs_acl_get_attr+0x46/0x63 [xfs]
 [<ffffffffa005d613>] xfs_acl_vget+0x6b/0xec [xfs]
 [<ffffffff802bb7c2>] generic_getxattr+0x62/0x66
 [<ffffffff802bc09d>] vfs_getxattr+0xaf/0xc1
 [<ffffffff802bc155>] getxattr+0xa6/0x107
 [<ffffffff802bc2e1>] sys_getxattr+0x4c/0x67
 [<ffffffff8020b418>] system_call_fastpath+0x16/0x1b
 [<00007f2367917d79>] 0x7f2367917d79


Code: 41 5d 41 5e 41 5f c3 41 57 41 56 41 55 45 31 ed 41 54 55 48 89 fd 53 =
48 83 ec 08 48 8b 47 30 48 8b 40 58 48 8b 40 18 48 8d 58 04 <44> 0f b6 78 0=
2 e9 92 00 00 00 44 0f b6 23 44 3b 65 08 75 77 48=20
RIP  [<ffffffffa0066e0e>] xfs_attr_shortform_getvalue+0x24/0xda [xfs]
 RSP <ffff88006a381be8>
CR2: 0000000000000002
=2D--[ end trace 0b5d9a76acf21c38 ]---

--Boundary-01=_DiLTM4Bh7hbxdGP--

--nextPart7279667.CxqmJWFvOW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxMuIcACgkQzhSR9xwSCbSoYACglz7Km5UmAI3w+N5xXHwOp4n2
kPEAnA33N/jdkEzTysyI1JpMKHyAt7fn
=nlH4
-----END PGP SIGNATURE-----

--nextPart7279667.CxqmJWFvOW--


--===============5682044047329267212==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5682044047329267212==--
