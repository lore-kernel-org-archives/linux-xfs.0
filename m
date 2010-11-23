Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oANAJ1Vo192084 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 04:19:01 -0600
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 580E419C847
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 02:20:37 -0800 (PST)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id NXOWLeFiNZgT9GpE
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 02:20:37 -0800 (PST)
Received: by qwc9 with SMTP id 9so330539qwc.26
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 02:20:37 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 23 Nov 2010 15:50:37 +0530
Message-ID: <AANLkTimNBapoCGa--2+PDME0q4nD5soLEudznHjFVB84@mail.gmail.com>
Subject: 2.6.34 - XFS crash radix_tree_tag_set
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6460377013090860353=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============6460377013090860353==
Content-Type: multipart/alternative; boundary=0015175cd0fc5241490495b5b93a

--0015175cd0fc5241490495b5b93a
Content-Type: text/plain; charset=ISO-8859-1

I have the following backtrace on my ARM target, please have a look

Backtrace:

[<c002f414>] (__bug+0x0/0x30) from [<c0207124>]
(radix_tree_tag_set+0xa0/0xe8)

[<c0207084>] (radix_tree_tag_set+0x0/0xe8) from [<c01e6fb0>]
(__xfs_inode_set_reclaim_tag+0x44/0x54)

[<c01e6f6c>] (__xfs_inode_set_reclaim_tag+0x0/0x54) from [<c01e700c>]
(xfs_inode_set_reclaim_tag+0x4c/0xac)

 r6:00000002 r5:ce558000 r4:d7ca6f00 r3:00000000

[<c01e6fc0>] (xfs_inode_set_reclaim_tag+0x0/0xac) from [<c01e50e0>]
(xfs_fs_destroy_inode+0x150/0x16c)

 r5:d7ca6f00 r4:d7ca7020

[<c01e4f90>] (xfs_fs_destroy_inode+0x0/0x16c) from [<c00e58a0>]
(destroy_inode+0x30/0x4c)

 r7:00000000 r6:00000002 r5:ce663c00 r4:d7ca7020

[<c00e5870>] (destroy_inode+0x0/0x4c) from [<c01b8c9c>]
(xfs_iget+0x78c/0x854)

 r4:cd87c000 r3:c031a2b8

[<c01b8510>] (xfs_iget+0x0/0x854) from [<c01d71a4>] (xfs_lookup+0x128/0x15c)

[<c01d707c>] (xfs_lookup+0x0/0x15c) from [<c01e39f8>]
(xfs_vn_lookup+0x48/0x90)

[<c01e39b0>] (xfs_vn_lookup+0x0/0x90) from [<c00dae84>]
(do_lookup+0xcc/0x19c)

 r6:d7ca640c r5:cd87de00 r4:cd87de90

[<c00dadb8>] (do_lookup+0x0/0x19c) from [<c00dcaa4>]
(__link_path_walk+0x964/0xe0c)

[<c00dc140>] (__link_path_walk+0x0/0xe0c) from [<c00dd0ec>]
(path_walk+0x50/0x9c)

[<c00dd09c>] (path_walk+0x0/0x9c) from [<c00dd2a8>]
(do_path_lookup+0x128/0x150)

 r7:cd87c000 r6:00000001 r5:cd87de90 r4:d69bf000

[<c00dd180>] (do_path_lookup+0x0/0x150) from [<c00ddcb4>]
(user_path_at+0x60/0x94)

 r8:00000001 r7:cd87df08 r6:ffffff9c r5:cd87de90 r4:d69bf000

[<c00ddc54>] (user_path_at+0x0/0x94) from [<c00d5d20>]
(vfs_fstatat+0x34/0x64)

 r8:c002b528 r7:000000c3 r6:880ae7b0 r5:cd87df40 r4:cd87df08

[<c00d5cec>] (vfs_fstatat+0x0/0x64) from [<c00d5e50>] (vfs_stat+0x24/0x28)

 r6:880ae7b0 r5:880ae740 r4:cd87df40

[<c00d5e2c>] (vfs_stat+0x0/0x28) from [<c00d5e74>] (sys_stat64+0x20/0x3c)

[<c00d5e54>] (sys_stat64+0x0/0x3c) from [<c002b380>]
(ret_fast_syscall+0x0/0x2c)

--0015175cd0fc5241490495b5b93a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"MsoNormal"><span lang=3D"EN-US">I have the following backtrac=
e on my ARM target, please have a look</span></div>
<div class=3D"MsoNormal"><span lang=3D"EN-US"></span>=A0</div>
<div class=3D"MsoNormal"><span lang=3D"EN-US">Backtrace: </span></div>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[&lt;c002f414&gt;] (__bug+0x0/0=
x30) from [&lt;c0207124&gt;] (radix_tree_tag_set+0xa0/0xe8)</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[&lt;c0207084&gt;] (radix_tree_=
tag_set+0x0/0xe8) from [&lt;c01e6fb0&gt;] (__xfs_inode_set_reclaim_tag+0x44=
/0x54)</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[&lt;c01e6f6c&gt;] (__xfs_inode=
_set_reclaim_tag+0x0/0x54) from [&lt;c01e700c&gt;] (xfs_inode_set_reclaim_t=
ag+0x4c/0xac)</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">=A0r6:00000002 r5:ce558000 r4:d=
7ca6f00 r3:00000000</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[&lt;c01e6fc0&gt;] (xfs_inode_s=
et_reclaim_tag+0x0/0xac) from [&lt;c01e50e0&gt;] (xfs_fs_destroy_inode+0x15=
0/0x16c)</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">=A0r5:d7ca6f00 r4:d7ca7020</spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[&lt;c01e4f90&gt;] (xfs_fs_dest=
roy_inode+0x0/0x16c) from [&lt;c00e58a0&gt;] (destroy_inode+0x30/0x4c)</spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">=A0r7:00000000 r6:00000002 r5:c=
e663c00 r4:d7ca7020</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[&lt;c00e5870&gt;] (destroy_ino=
de+0x0/0x4c) from [&lt;c01b8c9c&gt;] (xfs_iget+0x78c/0x854)</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">=A0r4:cd87c000 r3:c031a2b8</spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[&lt;c01b8510&gt;] (xfs_iget+0x=
0/0x854) from [&lt;c01d71a4&gt;] (xfs_lookup+0x128/0x15c)</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[&lt;c01d707c&gt;] (xfs_lookup+=
0x0/0x15c) from [&lt;c01e39f8&gt;] (xfs_vn_lookup+0x48/0x90)</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[&lt;c01e39b0&gt;] (xfs_vn_look=
up+0x0/0x90) from [&lt;c00dae84&gt;] (do_lookup+0xcc/0x19c)</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">=A0r6:d7ca640c r5:cd87de00 r4:c=
d87de90</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[&lt;c00dadb8&gt;] (do_lookup+0=
x0/0x19c) from [&lt;c00dcaa4&gt;] (__link_path_walk+0x964/0xe0c)</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[&lt;c00dc140&gt;] (__link_path=
_walk+0x0/0xe0c) from [&lt;c00dd0ec&gt;] (path_walk+0x50/0x9c)</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[&lt;c00dd09c&gt;] (path_walk+0=
x0/0x9c) from [&lt;c00dd2a8&gt;] (do_path_lookup+0x128/0x150)</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">=A0r7:cd87c000 r6:00000001 r5:c=
d87de90 r4:d69bf000</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[&lt;c00dd180&gt;] (do_path_loo=
kup+0x0/0x150) from [&lt;c00ddcb4&gt;] (user_path_at+0x60/0x94)</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">=A0r8:00000001 r7:cd87df08 r6:f=
fffff9c r5:cd87de90 r4:d69bf000</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[&lt;c00ddc54&gt;] (user_path_a=
t+0x0/0x94) from [&lt;c00d5d20&gt;] (vfs_fstatat+0x34/0x64)</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">=A0r8:c002b528 r7:000000c3 r6:8=
80ae7b0 r5:cd87df40 r4:cd87df08</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[&lt;c00d5cec&gt;] (vfs_fstatat=
+0x0/0x64) from [&lt;c00d5e50&gt;] (vfs_stat+0x24/0x28)</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">=A0r6:880ae7b0 r5:880ae740 r4:c=
d87df40</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[&lt;c00d5e2c&gt;] (vfs_stat+0x=
0/0x28) from [&lt;c00d5e74&gt;] (sys_stat64+0x20/0x3c)</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[&lt;c00d5e54&gt;] (sys_stat64+=
0x0/0x3c) from [&lt;c002b380&gt;] (ret_fast_syscall+0x0/0x2c)</span></p>

--0015175cd0fc5241490495b5b93a--


--===============6460377013090860353==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6460377013090860353==--
