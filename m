Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5O6Jncf251122 for <xfs@oss.sgi.com>; Fri, 24 Jun 2011 01:19:49 -0500
Received: from mail-ew0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0517BE10D51
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 23:19:46 -0700 (PDT)
Received: from mail-ew0-f53.google.com (mail-ew0-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id rHdoO7Wqj8U8jEZZ
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 23:19:46 -0700 (PDT)
Received: by ewy8 with SMTP id 8so856630ewy.26
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 23:19:45 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 24 Jun 2011 11:49:45 +0530
Message-ID: <BANLkTinCLAb3X59J=SnXgEkeRCLgB6FAGg@mail.gmail.com>
Subject: Failure of test case : 250
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1763693050151275602=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1763693050151275602==
Content-Type: multipart/alternative; boundary=0016e65aeabe1ca54804a66f30b2

--0016e65aeabe1ca54804a66f30b2
Content-Type: text/plain; charset=ISO-8859-1

Dear All,

Test Case : 250 results in failure on x86(2.6.31.y) and ARM(2.6.35.13..)
**
*Please find the logs for both versions as given below:*
[root@localhost xfstests-2011-05-11]# ./check -xfs 250
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 localhost 2.6.31.5-127.fc12.i686.PAE
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb4
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sdb4 /media/d
250  [failed, exit status 1] - no qualified output
Ran: 250
Failures: 250
Failed 1 of 1 tests
[root@localhost xfstests-2011-05-11]#

*LOGS for X86:
*Jun 24 11:38:24 localhost kernel: XFS mounting filesystem sdb3
Jun 24 11:38:34 localhost kernel: XFS mounting filesystem sdb4
Jun 24 11:38:35 localhost kernel: XFS mounting filesystem sdb3
Jun 24 11:38:36 localhost gnome-keyring-daemon[1653]: removing removable
location: /media/c
Jun 24 11:38:36 localhost gnome-keyring-daemon[1653]: no volume registered
at: /media/c
Jun 24 11:39:14 localhost kernel: XFS mounting filesystem loop0
Jun 24 11:39:17 localhost kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO
at line 2915 of file fs/xfs/xfs_btree.c.  Caller 0xfabda425
Jun 24 11:39:17 localhost kernel: Pid: 2305, comm: xfs_io Not tainted
2.6.31.5-127.fc12.i686.PAE #1
Jun 24 11:39:17 localhost kernel: Call Trace:
Jun 24 11:39:17 localhost kernel: [<fabf07ac>] xfs_error_report+0x31/0x33
[xfs]
Jun 24 11:39:17 localhost kernel: [<fabe5d8b>] xfs_btree_insert+0x9d/0x11e
[xfs]
Jun 24 11:39:17 localhost kernel: [<fabda425>] ?
xfs_bmap_add_extent_hole_real+0x587/0x630 [xfs]
Jun 24 11:39:17 localhost kernel: [<fabda425>]
xfs_bmap_add_extent_hole_real+0x587/0x630 [xfs]
Jun 24 11:39:17 localhost kernel: [<fabde92e>]
xfs_bmap_add_extent+0x278/0x386 [xfs]
Jun 24 11:39:17 localhost kernel: [<fac0d991>] ? kmem_zone_alloc+0x51/0x93
[xfs]
Jun 24 11:39:17 localhost kernel: [<fac0d991>] ? kmem_zone_alloc+0x51/0x93
[xfs]
Jun 24 11:39:17 localhost kernel: [<fabe0370>] xfs_bmapi+0x8bf/0x1012 [xfs]
Jun 24 11:39:17 localhost kernel: [<fac09224>] ?
xfs_trans_unlock_chunk+0x8a/0xc8 [xfs]
Jun 24 11:39:17 localhost kernel: [<fabfd39d>] ?
xfs_log_release_iclog+0x16/0x3f [xfs]
Jun 24 11:39:17 localhost kernel: [<fac07c00>] ?
_xfs_trans_commit+0x1f8/0x2c8 [xfs]
Jun 24 11:39:17 localhost kernel: [<fac0d005>]
xfs_alloc_file_space+0x273/0x324 [xfs]
Jun 24 11:39:17 localhost kernel: [<fac0d228>]
xfs_change_file_space+0x172/0x30e [xfs]
Jun 24 11:39:17 localhost kernel: [<c056ce8d>] ? inode_has_perm+0x69/0x84
Jun 24 11:39:17 localhost kernel: [<fac13d17>] xfs_vn_fallocate+0x71/0x101
[xfs]
Jun 24 11:39:17 localhost kernel: [<c056cf31>] ? file_has_perm+0x89/0xa3
Jun 24 11:39:17 localhost kernel: [<c04c7b5a>] do_fallocate+0xc5/0xe1
Jun 24 11:39:17 localhost kernel: [<c04d348c>] ioctl_preallocate+0xa4/0xae
Jun 24 11:39:17 localhost kernel: [<c04d3922>] do_vfs_ioctl+0x48c/0x4d6
Jun 24 11:39:17 localhost kernel: [<c056d1d5>] ?
selinux_file_ioctl+0x43/0x46
Jun 24 11:39:17 localhost kernel: [<c04d39b2>] sys_ioctl+0x46/0x66
Jun 24 11:39:17 localhost kernel: [<c0408f7b>] sysenter_do_call+0x12/0x28
Jun 24 11:39:17 localhost kernel: Filesystem "loop0": XFS internal error
xfs_trans_cancel at line 1161 of file fs/xfs/xfs_trans.c.  Caller 0xfac0d09a
Jun 24 11:39:17 localhost kernel:
Jun 24 11:39:17 localhost kernel: Pid: 2305, comm: xfs_io Not tainted
2.6.31.5-127.fc12.i686.PAE #1
Jun 24 11:39:17 localhost kernel: Call Trace:
Jun 24 11:39:17 localhost kernel: [<fabf07ac>] xfs_error_report+0x31/0x33
[xfs]
Jun 24 11:39:17 localhost kernel: [<fac07448>] xfs_trans_cancel+0x50/0xd0
[xfs]
Jun 24 11:39:17 localhost kernel: [<fac0d09a>] ?
xfs_alloc_file_space+0x308/0x324 [xfs]
Jun 24 11:39:17 localhost kernel: [<fac0d09a>]
xfs_alloc_file_space+0x308/0x324 [xfs]
Jun 24 11:39:17 localhost kernel: [<fac0d228>]
xfs_change_file_space+0x172/0x30e [xfs]
Jun 24 11:39:17 localhost kernel: [<c056ce8d>] ? inode_has_perm+0x69/0x84
Jun 24 11:39:17 localhost kernel: [<fac13d17>] xfs_vn_fallocate+0x71/0x101
[xfs]
Jun 24 11:39:17 localhost kernel: [<c056cf31>] ? file_has_perm+0x89/0xa3
Jun 24 11:39:17 localhost kernel: [<c04c7b5a>] do_fallocate+0xc5/0xe1
Jun 24 11:39:17 localhost kernel: [<c04d348c>] ioctl_preallocate+0xa4/0xae
Jun 24 11:39:17 localhost kernel: [<c04d3922>] do_vfs_ioctl+0x48c/0x4d6
Jun 24 11:39:17 localhost kernel: [<c056d1d5>] ?
selinux_file_ioctl+0x43/0x46
Jun 24 11:39:17 localhost kernel: [<c04d39b2>] sys_ioctl+0x46/0x66
Jun 24 11:39:17 localhost kernel: [<c0408f7b>] sysenter_do_call+0x12/0x28
Jun 24 11:39:17 localhost kernel: xfs_force_shutdown(loop0,0x8) called from
line 1162 of file fs/xfs/xfs_trans.c.  Return address = 0xfac0745e
Jun 24 11:39:17 localhost kernel: Filesystem "loop0": Corruption of
in-memory data detected.  Shutting down filesystem: loop0
Jun 24 11:39:17 localhost kernel: Please umount the filesystem, and rectify
the problem(s)
Jun 24 11:39:17 localhost kernel: Filesystem "loop0": xfs_log_force: error 5
returned.
Jun 24 11:39:17 localhost kernel: Filesystem "loop0": xfs_log_force: error 5
returned.
Jun 24 11:39:18 localhost gnome-keyring-daemon[1653]: removing removable
location: /media/c/250.mnt
Jun 24 11:39:18 localhost gnome-keyring-daemon[1653]: no volume registered
at: /media/c/250.mnt
Jun 24 11:39:21 localhost kernel: XFS mounting filesystem sdb3
Jun 24 11:39:21 localhost gnome-keyring-daemon[1653]: removing removable
location: /media/c
Jun 24 11:39:21 localhost gnome-keyring-daemon[1653]: no volume registered
at: /media/c



*LOG FOR ARM:*
#./check -xfs 250
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/armv7l localhost 2.6.35.13
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda4
MOUNT_OPTIONS -- /dev/sda4 /media/usb/sda4
XFS mounting filesystem sda4
XFS mounting filesystem sda3
250
XFS mounting filesystem loop0
XFS internal error XFS_WANT_CORRUPTED_GOTO at line 2875 of file
fs/xfs/xfs_btree.c.  Caller 0xc017a9ec
Backtrace:
[<c0024000>] (dump_backtrace+0x0/0x110) from [<c03240c8>]
(dump_stack+0x18/0x1c)
 r6:00000001 r5:d73e77b8 r4:d73e7688 r3:d67db978
[<c03240b0>] (dump_stack+0x0/0x1c) from [<c0195fc8>]
(xfs_error_report+0x4c/0x5c)
[<c0195f7c>] (xfs_error_report+0x0/0x5c) from [<c0188aa0>]
(xfs_btree_insert+0xbc/0x164)
[<c01889e4>] (xfs_btree_insert+0x0/0x164) from [<c017a9ec>]
(xfs_bmap_add_extent_hole_real+0x6a4/0x75c)
[<c017a348>] (xfs_bmap_add_extent_hole_real+0x0/0x75c) from [<c017d068>]
(xfs_bmap_add_extent+0x260/0x38c)
[<c017ce08>] (xfs_bmap_add_extent+0x0/0x38c) from [<c017fdf0>]
(xfs_bmapi+0x778/0xe40)
[<c017f678>] (xfs_bmapi+0x0/0xe40) from [<c01b53a8>]
(xfs_alloc_file_space+0x238/0x2f4)
[<c01b5170>] (xfs_alloc_file_space+0x0/0x2f4) from [<c01b8160>]
(xfs_change_file_space+0x198/0x374)
[<c01b7fc8>] (xfs_change_file_space+0x0/0x374) from [<c01c2a04>]
(xfs_vn_fallocate+0x104/0x154)
[<c01c2900>] (xfs_vn_fallocate+0x0/0x154) from [<c00a75f0>]
(do_fallocate+0xd0/0xe8)
 r9:0000000a r8:00000000 r7:0000000a r6:00000000 r5:0000000a
r4:ffffffff
[<c00a7520>] (do_fallocate+0x0/0xe8) from [<c00b7e78>]
(ioctl_preallocate+0xf8/0x100)
 r9:d67da000 r8:c0020128 r7:00000003 r6:d6fda840 r5:d73cbc00
r4:d67da000
[<c00b7d80>] (ioctl_preallocate+0x0/0x100) from [<c00b83bc>]
(do_vfs_ioctl+0x53c/0x594)
 r9:d67da000 r8:c0020128 r7:00000003 r6:4030582a r5:d73cbc00
r4:bef7e210
[<c00b7e80>] (do_vfs_ioctl+0x0/0x594) from [<c00b8454>]
(sys_ioctl+0x40/0x64)
[<c00b8414>] (sys_ioctl+0x0/0x64) from [<c001ff80>]
(ret_fast_syscall+0x0/0x30)
 r7:00000036 r6:0002a6c0 r5:00000003 r4:bef7e210
Filesystem "loop0": XFS internal error xfs_trans_cancel at line 1724 of file
fs/xfs/xfs_trans.c.  Caller 0xc01b544c
Backtrace:
[<c0024000>] (dump_backtrace+0x0/0x110) from [<c03240c8>]
(dump_stack+0x18/0x1c)
 r6:d6161400 r5:0000000c r4:cb10e5a0 r3:d67dbc30
[<c03240b0>] (dump_stack+0x0/0x1c) from [<c0195fc8>]
(xfs_error_report+0x4c/0x5c)
[<c0195f7c>] (xfs_error_report+0x0/0x5c) from [<c01b1d18>]
(xfs_trans_cancel+0x7c/0x108)
[<c01b1c9c>] (xfs_trans_cancel+0x0/0x108) from [<c01b544c>]
(xfs_alloc_file_space+0x2dc/0x2f4)
 r6:d6fda720 r5:d6161400 r4:00000004
[<c01b5170>] (xfs_alloc_file_space+0x0/0x2f4) from [<c01b8160>]
(xfs_change_file_space+0x198/0x374)
[<c01b7fc8>] (xfs_change_file_space+0x0/0x374) from [<c01c2a04>]
(xfs_vn_fallocate+0x104/0x154)
[<c01c2900>] (xfs_vn_fallocate+0x0/0x154) from [<c00a75f0>]
(do_fallocate+0xd0/0xe8)
 r9:0000000a r8:00000000 r7:0000000a r6:00000000 r5:0000000a
r4:ffffffff
[<c00a7520>] (do_fallocate+0x0/0xe8) from [<c00b7e78>]
(ioctl_preallocate+0xf8/0x100)
 r9:d67da000 r8:c0020128 r7:00000003 r6:d6fda840 r5:d73cbc00
r4:d67da000
[<c00b7d80>] (ioctl_preallocate+0x0/0x100) from [<c00b83bc>]
(do_vfs_ioctl+0x53c/0x594)
 r9:d67da000 r8:c0020128 r7:00000003 r6:4030582a r5:d73cbc00
r4:bef7e210
[<c00b7e80>] (do_vfs_ioctl+0x0/0x594) from [<c00b8454>]
(sys_ioctl+0x40/0x64)
[<c00b8414>] (sys_ioctl+0x0/0x64) from [<c001ff80>]
(ret_fast_syscall+0x0/0x30)
 r7:00000036 r6:0002a6c0 r5:00000003 r4:bef7e210
xfs_force_shutdown(loop0,0x8) called from line 1725 of file
fs/xfs/xfs_trans.c.  Return address = 0xc01b1d2c
Filesystem "loop0": Corruption of in-memory data detected.  Shutting down
filesystem: loop0
Please umount the filesystem, and rectify the problem(s)
xfs_force_shutdown(loop0,0x1) called from line 1017 of file
fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xc01bd334
Filesystem "loop0": xfs_log_force: error 5 returned.
Filesystem "loop0": xfs_log_force: error 5 returned.
 [failed, exit status 1] - no qualified output
umount: can't umount /media/usb/sda3: Device or resource busy
_check_xfs_filesystem: filesystem on /dev/sda3 has dirty log (see 250.full)
_check_xfs_filesystem: filesystem on /dev/sda3 is inconsistent (c) (see
250.full)
_check_xfs_filesystem: filesystem on /dev/sda3 is inconsistent (r) (see
250.full)
Ran: 250
Failures: 250
Failed 1 of 1 tests

Please let me know in case more information is needed.

Thanks & Regards,
Amit Sahrawat

--0016e65aeabe1ca54804a66f30b2
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Dear All,</div><div>=A0</div><div>Test Case : 250 results in failure o=
n x86(2.6.31.y) and ARM(2.6.35.13..)</div><div><strong></strong>=A0</div><d=
iv><strong>Please find the logs for both versions as given below:</strong><=
/div>
<div>[root@localhost xfstests-2011-05-11]# ./check -xfs 250<br>FSTYP=A0=A0=
=A0=A0=A0=A0=A0=A0 -- xfs (non-debug)<br>PLATFORM=A0=A0=A0=A0=A0 -- Linux/i=
686 localhost 2.6.31.5-127.fc12.i686.PAE<br>MKFS_OPTIONS=A0 -- -f -bsize=3D=
4096 /dev/sdb4<br>MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:nfs_t:s0 =
/dev/sdb4 /media/d</div>
<div>250=A0 [failed, exit status 1] - no qualified output<br>Ran: 250<br>Fa=
ilures: 250<br>Failed 1 of 1 tests<br>[root@localhost xfstests-2011-05-11]#=
 </div><div><br><strong>LOGS for X86:<br></strong>Jun 24 11:38:24 localhost=
 kernel: XFS mounting filesystem sdb3<br>
Jun 24 11:38:34 localhost kernel: XFS mounting filesystem sdb4<br>Jun 24 11=
:38:35 localhost kernel: XFS mounting filesystem sdb3<br>Jun 24 11:38:36 lo=
calhost gnome-keyring-daemon[1653]: removing removable location: /media/c<b=
r>
Jun 24 11:38:36 localhost gnome-keyring-daemon[1653]: no volume registered =
at: /media/c<br>Jun 24 11:39:14 localhost kernel: XFS mounting filesystem l=
oop0<br>Jun 24 11:39:17 localhost kernel: XFS internal error XFS_WANT_CORRU=
PTED_GOTO at line 2915 of file fs/xfs/xfs_btree.c.=A0 Caller 0xfabda425<br>
Jun 24 11:39:17 localhost kernel: Pid: 2305, comm: xfs_io Not tainted 2.6.3=
1.5-127.fc12.i686.PAE #1<br>Jun 24 11:39:17 localhost kernel: Call Trace:<b=
r>Jun 24 11:39:17 localhost kernel: [&lt;fabf07ac&gt;] xfs_error_report+0x3=
1/0x33 [xfs]<br>
Jun 24 11:39:17 localhost kernel: [&lt;fabe5d8b&gt;] xfs_btree_insert+0x9d/=
0x11e [xfs]<br>Jun 24 11:39:17 localhost kernel: [&lt;fabda425&gt;] ? xfs_b=
map_add_extent_hole_real+0x587/0x630 [xfs]<br>Jun 24 11:39:17 localhost ker=
nel: [&lt;fabda425&gt;] xfs_bmap_add_extent_hole_real+0x587/0x630 [xfs]<br>
Jun 24 11:39:17 localhost kernel: [&lt;fabde92e&gt;] xfs_bmap_add_extent+0x=
278/0x386 [xfs]<br>Jun 24 11:39:17 localhost kernel: [&lt;fac0d991&gt;] ? k=
mem_zone_alloc+0x51/0x93 [xfs]<br>Jun 24 11:39:17 localhost kernel: [&lt;fa=
c0d991&gt;] ? kmem_zone_alloc+0x51/0x93 [xfs]<br>
Jun 24 11:39:17 localhost kernel: [&lt;fabe0370&gt;] xfs_bmapi+0x8bf/0x1012=
 [xfs]<br>Jun 24 11:39:17 localhost kernel: [&lt;fac09224&gt;] ? xfs_trans_=
unlock_chunk+0x8a/0xc8 [xfs]<br>Jun 24 11:39:17 localhost kernel: [&lt;fabf=
d39d&gt;] ? xfs_log_release_iclog+0x16/0x3f [xfs]<br>
Jun 24 11:39:17 localhost kernel: [&lt;fac07c00&gt;] ? _xfs_trans_commit+0x=
1f8/0x2c8 [xfs]<br>Jun 24 11:39:17 localhost kernel: [&lt;fac0d005&gt;] xfs=
_alloc_file_space+0x273/0x324 [xfs]<br>Jun 24 11:39:17 localhost kernel: [&=
lt;fac0d228&gt;] xfs_change_file_space+0x172/0x30e [xfs]<br>
Jun 24 11:39:17 localhost kernel: [&lt;c056ce8d&gt;] ? inode_has_perm+0x69/=
0x84<br>Jun 24 11:39:17 localhost kernel: [&lt;fac13d17&gt;] xfs_vn_falloca=
te+0x71/0x101 [xfs]<br>Jun 24 11:39:17 localhost kernel: [&lt;c056cf31&gt;]=
 ? file_has_perm+0x89/0xa3<br>
Jun 24 11:39:17 localhost kernel: [&lt;c04c7b5a&gt;] do_fallocate+0xc5/0xe1=
<br>Jun 24 11:39:17 localhost kernel: [&lt;c04d348c&gt;] ioctl_preallocate+=
0xa4/0xae<br>Jun 24 11:39:17 localhost kernel: [&lt;c04d3922&gt;] do_vfs_io=
ctl+0x48c/0x4d6<br>
Jun 24 11:39:17 localhost kernel: [&lt;c056d1d5&gt;] ? selinux_file_ioctl+0=
x43/0x46<br>Jun 24 11:39:17 localhost kernel: [&lt;c04d39b2&gt;] sys_ioctl+=
0x46/0x66<br>Jun 24 11:39:17 localhost kernel: [&lt;c0408f7b&gt;] sysenter_=
do_call+0x12/0x28<br>
Jun 24 11:39:17 localhost kernel: Filesystem &quot;loop0&quot;: XFS interna=
l error xfs_trans_cancel at line 1161 of file fs/xfs/xfs_trans.c.=A0 Caller=
 0xfac0d09a<br>Jun 24 11:39:17 localhost kernel:<br>Jun 24 11:39:17 localho=
st kernel: Pid: 2305, comm: xfs_io Not tainted 2.6.31.5-127.fc12.i686.PAE #=
1<br>
Jun 24 11:39:17 localhost kernel: Call Trace:<br>Jun 24 11:39:17 localhost =
kernel: [&lt;fabf07ac&gt;] xfs_error_report+0x31/0x33 [xfs]<br>Jun 24 11:39=
:17 localhost kernel: [&lt;fac07448&gt;] xfs_trans_cancel+0x50/0xd0 [xfs]<b=
r>
Jun 24 11:39:17 localhost kernel: [&lt;fac0d09a&gt;] ? xfs_alloc_file_space=
+0x308/0x324 [xfs]<br>Jun 24 11:39:17 localhost kernel: [&lt;fac0d09a&gt;] =
xfs_alloc_file_space+0x308/0x324 [xfs]<br>Jun 24 11:39:17 localhost kernel:=
 [&lt;fac0d228&gt;] xfs_change_file_space+0x172/0x30e [xfs]<br>
Jun 24 11:39:17 localhost kernel: [&lt;c056ce8d&gt;] ? inode_has_perm+0x69/=
0x84<br>Jun 24 11:39:17 localhost kernel: [&lt;fac13d17&gt;] xfs_vn_falloca=
te+0x71/0x101 [xfs]<br>Jun 24 11:39:17 localhost kernel: [&lt;c056cf31&gt;]=
 ? file_has_perm+0x89/0xa3<br>
Jun 24 11:39:17 localhost kernel: [&lt;c04c7b5a&gt;] do_fallocate+0xc5/0xe1=
<br>Jun 24 11:39:17 localhost kernel: [&lt;c04d348c&gt;] ioctl_preallocate+=
0xa4/0xae<br>Jun 24 11:39:17 localhost kernel: [&lt;c04d3922&gt;] do_vfs_io=
ctl+0x48c/0x4d6<br>
Jun 24 11:39:17 localhost kernel: [&lt;c056d1d5&gt;] ? selinux_file_ioctl+0=
x43/0x46<br>Jun 24 11:39:17 localhost kernel: [&lt;c04d39b2&gt;] sys_ioctl+=
0x46/0x66<br>Jun 24 11:39:17 localhost kernel: [&lt;c0408f7b&gt;] sysenter_=
do_call+0x12/0x28<br>
Jun 24 11:39:17 localhost kernel: xfs_force_shutdown(loop0,0x8) called from=
 line 1162 of file fs/xfs/xfs_trans.c.=A0 Return address =3D 0xfac0745e<br>=
Jun 24 11:39:17 localhost kernel: Filesystem &quot;loop0&quot;: Corruption =
of in-memory data detected.=A0 Shutting down filesystem: loop0<br>
Jun 24 11:39:17 localhost kernel: Please umount the filesystem, and rectify=
 the problem(s)<br>Jun 24 11:39:17 localhost kernel: Filesystem &quot;loop0=
&quot;: xfs_log_force: error 5 returned.<br>Jun 24 11:39:17 localhost kerne=
l: Filesystem &quot;loop0&quot;: xfs_log_force: error 5 returned.<br>
Jun 24 11:39:18 localhost gnome-keyring-daemon[1653]: removing removable lo=
cation: /media/c/250.mnt<br>Jun 24 11:39:18 localhost gnome-keyring-daemon[=
1653]: no volume registered at: /media/c/250.mnt<br>Jun 24 11:39:21 localho=
st kernel: XFS mounting filesystem sdb3<br>
Jun 24 11:39:21 localhost gnome-keyring-daemon[1653]: removing removable lo=
cation: /media/c<br>Jun 24 11:39:21 localhost gnome-keyring-daemon[1653]: n=
o volume registered at: /media/c</div><div>=A0</div><div>=A0</div><div>=A0<=
/div>
<div><strong>LOG FOR ARM:</strong></div><div>#./check -xfs 250<br>FSTYP=A0=
=A0=A0=A0=A0=A0=A0=A0 -- xfs (non-debug)<br>PLATFORM=A0=A0=A0=A0=A0 -- Linu=
x/armv7l localhost 2.6.35.13<br>MKFS_OPTIONS=A0 -- -f -bsize=3D4096 /dev/sd=
a4<br>MOUNT_OPTIONS -- /dev/sda4 /media/usb/sda4</div>
<div>XFS mounting filesystem sda4<br>XFS mounting filesystem sda3<br>250=A0=
<br>XFS mounting filesystem loop0<br>XFS internal error XFS_WANT_CORRUPTED_=
GOTO at line 2875 of file fs/xfs/xfs_btree.c.=A0 Caller 0xc017a9ec<br>Backt=
race: <br>
[&lt;c0024000&gt;] (dump_backtrace+0x0/0x110) from [&lt;c03240c8&gt;] (dump=
_stack+0x18/0x1c)<br>=A0r6:00000001 r5:d73e77b8 r4:d73e7688 r3:d67db978<br>=
[&lt;c03240b0&gt;] (dump_stack+0x0/0x1c) from [&lt;c0195fc8&gt;] (xfs_error=
_report+0x4c/0x5c)<br>
[&lt;c0195f7c&gt;] (xfs_error_report+0x0/0x5c) from [&lt;c0188aa0&gt;] (xfs=
_btree_insert+0xbc/0x164)<br>[&lt;c01889e4&gt;] (xfs_btree_insert+0x0/0x164=
) from [&lt;c017a9ec&gt;] (xfs_bmap_add_extent_hole_real+0x6a4/0x75c)<br>
[&lt;c017a348&gt;] (xfs_bmap_add_extent_hole_real+0x0/0x75c) from [&lt;c017=
d068&gt;] (xfs_bmap_add_extent+0x260/0x38c)<br>[&lt;c017ce08&gt;] (xfs_bmap=
_add_extent+0x0/0x38c) from [&lt;c017fdf0&gt;] (xfs_bmapi+0x778/0xe40)<br>
[&lt;c017f678&gt;] (xfs_bmapi+0x0/0xe40) from [&lt;c01b53a8&gt;] (xfs_alloc=
_file_space+0x238/0x2f4)<br>[&lt;c01b5170&gt;] (xfs_alloc_file_space+0x0/0x=
2f4) from [&lt;c01b8160&gt;] (xfs_change_file_space+0x198/0x374)<br>[&lt;c0=
1b7fc8&gt;] (xfs_change_file_space+0x0/0x374) from [&lt;c01c2a04&gt;] (xfs_=
vn_fallocate+0x104/0x154)<br>
[&lt;c01c2900&gt;] (xfs_vn_fallocate+0x0/0x154) from [&lt;c00a75f0&gt;] (do=
_fallocate+0xd0/0xe8)<br>=A0r9:0000000a r8:00000000 r7:0000000a r6:00000000=
 r5:0000000a<br>r4:ffffffff<br>[&lt;c00a7520&gt;] (do_fallocate+0x0/0xe8) f=
rom [&lt;c00b7e78&gt;] (ioctl_preallocate+0xf8/0x100)<br>
=A0r9:d67da000 r8:c0020128 r7:00000003 r6:d6fda840 r5:d73cbc00<br>r4:d67da0=
00<br>[&lt;c00b7d80&gt;] (ioctl_preallocate+0x0/0x100) from [&lt;c00b83bc&g=
t;] (do_vfs_ioctl+0x53c/0x594)<br>=A0r9:d67da000 r8:c0020128 r7:00000003 r6=
:4030582a r5:d73cbc00<br>
r4:bef7e210<br>[&lt;c00b7e80&gt;] (do_vfs_ioctl+0x0/0x594) from [&lt;c00b84=
54&gt;] (sys_ioctl+0x40/0x64)<br>[&lt;c00b8414&gt;] (sys_ioctl+0x0/0x64) fr=
om [&lt;c001ff80&gt;] (ret_fast_syscall+0x0/0x30)<br>=A0r7:00000036 r6:0002=
a6c0 r5:00000003 r4:bef7e210<br>
Filesystem &quot;loop0&quot;: XFS internal error xfs_trans_cancel at line 1=
724 of file fs/xfs/xfs_trans.c.=A0 Caller 0xc01b544c</div><div>Backtrace: <=
br>[&lt;c0024000&gt;] (dump_backtrace+0x0/0x110) from [&lt;c03240c8&gt;] (d=
ump_stack+0x18/0x1c)<br>
=A0r6:d6161400 r5:0000000c r4:cb10e5a0 r3:d67dbc30<br>[&lt;c03240b0&gt;] (d=
ump_stack+0x0/0x1c) from [&lt;c0195fc8&gt;] (xfs_error_report+0x4c/0x5c)<br=
>[&lt;c0195f7c&gt;] (xfs_error_report+0x0/0x5c) from [&lt;c01b1d18&gt;] (xf=
s_trans_cancel+0x7c/0x108)<br>
[&lt;c01b1c9c&gt;] (xfs_trans_cancel+0x0/0x108) from [&lt;c01b544c&gt;] (xf=
s_alloc_file_space+0x2dc/0x2f4)<br>=A0r6:d6fda720 r5:d6161400 r4:00000004<b=
r>[&lt;c01b5170&gt;] (xfs_alloc_file_space+0x0/0x2f4) from [&lt;c01b8160&gt=
;] (xfs_change_file_space+0x198/0x374)<br>
[&lt;c01b7fc8&gt;] (xfs_change_file_space+0x0/0x374) from [&lt;c01c2a04&gt;=
] (xfs_vn_fallocate+0x104/0x154)<br>[&lt;c01c2900&gt;] (xfs_vn_fallocate+0x=
0/0x154) from [&lt;c00a75f0&gt;] (do_fallocate+0xd0/0xe8)<br>=A0r9:0000000a=
 r8:00000000 r7:0000000a r6:00000000 r5:0000000a<br>
r4:ffffffff<br>[&lt;c00a7520&gt;] (do_fallocate+0x0/0xe8) from [&lt;c00b7e7=
8&gt;] (ioctl_preallocate+0xf8/0x100)<br>=A0r9:d67da000 r8:c0020128 r7:0000=
0003 r6:d6fda840 r5:d73cbc00<br>r4:d67da000<br>[&lt;c00b7d80&gt;] (ioctl_pr=
eallocate+0x0/0x100) from [&lt;c00b83bc&gt;] (do_vfs_ioctl+0x53c/0x594)<br>
=A0r9:d67da000 r8:c0020128 r7:00000003 r6:4030582a r5:d73cbc00<br>r4:bef7e2=
10<br>[&lt;c00b7e80&gt;] (do_vfs_ioctl+0x0/0x594) from [&lt;c00b8454&gt;] (=
sys_ioctl+0x40/0x64)<br>[&lt;c00b8414&gt;] (sys_ioctl+0x0/0x64) from [&lt;c=
001ff80&gt;] (ret_fast_syscall+0x0/0x30)<br>
=A0r7:00000036 r6:0002a6c0 r5:00000003 r4:bef7e210<br>xfs_force_shutdown(lo=
op0,0x8) called from line 1725 of file fs/xfs/xfs_trans.c.=A0 Return addres=
s =3D 0xc01b1d2c<br>Filesystem &quot;loop0&quot;: Corruption of in-memory d=
ata detected.=A0 Shutting down filesystem: loop0<br>
Please umount the filesystem, and rectify the problem(s)<br>xfs_force_shutd=
own(loop0,0x1) called from line 1017 of file fs/xfs/linux-2.6/xfs_buf.c.=A0=
 Return address =3D 0xc01bd334<br>Filesystem &quot;loop0&quot;: xfs_log_for=
ce: error 5 returned.<br>
Filesystem &quot;loop0&quot;: xfs_log_force: error 5 returned.<br>=A0[faile=
d, exit status 1] - no qualified output<br>umount: can&#39;t umount /media/=
usb/sda3: Device or resource busy<br>_check_xfs_filesystem: filesystem on /=
dev/sda3 has dirty log (see 250.full)<br>
_check_xfs_filesystem: filesystem on /dev/sda3 is inconsistent (c) (see 250=
.full)<br>_check_xfs_filesystem: filesystem on /dev/sda3 is inconsistent (r=
) (see 250.full)<br>Ran: 250<br>Failures: 250<br>Failed 1 of 1 tests</div>
<div>=A0</div><div>Please let me know in case more information is needed.</=
div><div>=A0</div><div>Thanks &amp; Regards,</div><div>Amit Sahrawat</div><=
div>=A0</div>

--0016e65aeabe1ca54804a66f30b2--


--===============1763693050151275602==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1763693050151275602==--
