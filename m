Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA45u2jb130722 for <xfs@oss.sgi.com>; Thu, 4 Nov 2010 00:56:02 -0500
Received: from mail-gw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D78171C12CE3
	for <xfs@oss.sgi.com>; Wed,  3 Nov 2010 22:57:25 -0700 (PDT)
Received: from mail-gw0-f53.google.com (mail-gw0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id WByx9i1jVCvBom6P
	for <xfs@oss.sgi.com>; Wed, 03 Nov 2010 22:57:25 -0700 (PDT)
Received: by gwb1 with SMTP id 1so1292525gwb.26
	for <xfs@oss.sgi.com>; Wed, 03 Nov 2010 22:57:25 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 4 Nov 2010 11:27:24 +0530
Message-ID: <AANLkTi=mLwQ0N_cErHzES1ZWvOa8jQspeYwKgn9sU4Jm@mail.gmail.com>
Subject: XFS mounting fails on MIPS
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3601797172646202931=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============3601797172646202931==
Content-Type: multipart/alternative; boundary=001636283e7805c1b2049433d553

--001636283e7805c1b2049433d553
Content-Type: text/plain; charset=ISO-8859-1

Linux XFS version : 2.6.34
Architecure: MIPS
I am getting the following error during mount.

XFS mounting filesystem sda2
Starting XFS recovery on filesystem: sda2 (logdev: internal)
XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1518 of file
fs/xfs/xfs_alloc.c.  Caller 0x801174a0
Call Trace:
[<800050bc>] dump_stack+0x8/0x34
[<80115254>] xfs_free_ag_extent+0x128/0x7a8
[<801174a0>] xfs_free_extent+0xa0/0xcc
[<80155278>] xlog_recover_process_efi+0x15c/0x210
[<801553cc>] xlog_recover_process_efis+0xa0/0x12c
[<8015590c>] xlog_recover_finish+0x28/0xcc
[<8015d4fc>] xfs_mountfs+0x4f0/0x5d0
[<801758d8>] xfs_fs_fill_super+0x158/0x360
[<8008b67c>] get_sb_bdev+0x11c/0x1c4
[<801734e0>] xfs_fs_get_sb+0x20/0x2c
[<80089cd0>] vfs_kern_mount+0x68/0xd0
[<80089d9c>] do_kern_mount+0x54/0x118
[<800a4e98>] do_mount+0x7f0/0x86c
[<800a4fb0>] sys_mount+0x9c/0xf8
[<80002124>] stack_done+0x20/0x3c

Filesystem "sda2": XFS internal error xfs_trans_cancel at line 1161 of file
fs/xfs/xfs_trans.c.  Caller 0x801552f8

Call Trace:
[<800050bc>] dump_stack+0x8/0x34
[<801601f0>] xfs_trans_cancel+0x88/0x118
[<801552f8>] xlog_recover_process_efi+0x1dc/0x210
[<801553cc>] xlog_recover_process_efis+0xa0/0x12c
[<8015590c>] xlog_recover_finish+0x28/0xcc
[<8015d4fc>] xfs_mountfs+0x4f0/0x5d0
[<801758d8>] xfs_fs_fill_super+0x158/0x360
[<8008b67c>] get_sb_bdev+0x11c/0x1c4
[<801734e0>] xfs_fs_get_sb+0x20/0x2c
[<80089cd0>] vfs_kern_mount+0x68/0xd0
[<80089d9c>] do_kern_mount+0x54/0x118
[<800a4e98>] do_mount+0x7f0/0x86c
[<800a4fb0>] sys_mount+0x9c/0xf8
[<80002124>] stack_done+0x20/0x3c

xfs_force_shutdown(sda2,0x8) called from line 1162 of file
fs/xfs/xfs_trans.c.  Return address = 0x80160204
Filesystem "sda2": Corruption of in-memory data detected.  Shutting down
filesystem: sda2
Please umount the filesystem, and rectify the problem(s)
Failed to recover EFIs on filesystem: sda2
XFS: log mount finish failed

With Regards
Ajeet Yadav

--001636283e7805c1b2049433d553
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Linux XFS version : 2.6.34</div>
<div>Architecure: MIPS</div>
<div>I am getting the following error during mount.</div>
<div>=A0</div>
<div>XFS mounting filesystem sda2<br>Starting XFS recovery on filesystem: s=
da2 (logdev: internal)<br>XFS internal error XFS_WANT_CORRUPTED_GOTO at lin=
e 1518 of file fs/xfs/xfs_alloc.c.=A0 Caller 0x801174a0<br>Call Trace:<br>
[&lt;800050bc&gt;] dump_stack+0x8/0x34<br>[&lt;80115254&gt;] xfs_free_ag_ex=
tent+0x128/0x7a8<br>[&lt;801174a0&gt;] xfs_free_extent+0xa0/0xcc<br>[&lt;80=
155278&gt;] xlog_recover_process_efi+0x15c/0x210<br>[&lt;801553cc&gt;] xlog=
_recover_process_efis+0xa0/0x12c<br>
[&lt;8015590c&gt;] xlog_recover_finish+0x28/0xcc<br>[&lt;8015d4fc&gt;] xfs_=
mountfs+0x4f0/0x5d0<br>[&lt;801758d8&gt;] xfs_fs_fill_super+0x158/0x360<br>=
[&lt;8008b67c&gt;] get_sb_bdev+0x11c/0x1c4<br>[&lt;801734e0&gt;] xfs_fs_get=
_sb+0x20/0x2c<br>
[&lt;80089cd0&gt;] vfs_kern_mount+0x68/0xd0<br>[&lt;80089d9c&gt;] do_kern_m=
ount+0x54/0x118<br>[&lt;800a4e98&gt;] do_mount+0x7f0/0x86c<br>[&lt;800a4fb0=
&gt;] sys_mount+0x9c/0xf8<br>[&lt;80002124&gt;] stack_done+0x20/0x3c<br>
=A0<br>Filesystem &quot;sda2&quot;: XFS internal error xfs_trans_cancel at =
line 1161 of file fs/xfs/xfs_trans.c.=A0 Caller 0x801552f8<br>=A0<br>Call T=
race:<br>[&lt;800050bc&gt;] dump_stack+0x8/0x34<br>[&lt;801601f0&gt;] xfs_t=
rans_cancel+0x88/0x118<br>
[&lt;801552f8&gt;] xlog_recover_process_efi+0x1dc/0x210<br>[&lt;801553cc&gt=
;] xlog_recover_process_efis+0xa0/0x12c<br>[&lt;8015590c&gt;] xlog_recover_=
finish+0x28/0xcc<br>[&lt;8015d4fc&gt;] xfs_mountfs+0x4f0/0x5d0<br>[&lt;8017=
58d8&gt;] xfs_fs_fill_super+0x158/0x360<br>
[&lt;8008b67c&gt;] get_sb_bdev+0x11c/0x1c4<br>[&lt;801734e0&gt;] xfs_fs_get=
_sb+0x20/0x2c<br>[&lt;80089cd0&gt;] vfs_kern_mount+0x68/0xd0<br>[&lt;80089d=
9c&gt;] do_kern_mount+0x54/0x118<br>[&lt;800a4e98&gt;] do_mount+0x7f0/0x86c=
<br>
[&lt;800a4fb0&gt;] sys_mount+0x9c/0xf8<br>[&lt;80002124&gt;] stack_done+0x2=
0/0x3c<br>=A0<br>xfs_force_shutdown(sda2,0x8) called from line 1162 of file=
 fs/xfs/xfs_trans.c.=A0 Return address =3D 0x80160204<br>Filesystem &quot;s=
da2&quot;: Corruption of in-memory data detected.=A0 Shutting down filesyst=
em: sda2<br>
Please umount the filesystem, and rectify the problem(s)<br>Failed to recov=
er EFIs on filesystem: sda2<br>XFS: log mount finish failed</div>
<div>=A0</div>
<div>With Regards</div>
<div>Ajeet Yadav</div>
<div>=A0</div>
<div>=A0</div>

--001636283e7805c1b2049433d553--


--===============3601797172646202931==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3601797172646202931==--
