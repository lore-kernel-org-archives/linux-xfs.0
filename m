Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB26xlgh000783 for <xfs@oss.sgi.com>; Thu, 2 Dec 2010 00:59:48 -0600
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 832D2160B6BB
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 23:01:31 -0800 (PST)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id SygcYnwMAJup1BaK
	for <xfs@oss.sgi.com>; Wed, 01 Dec 2010 23:01:31 -0800 (PST)
Received: by qwe5 with SMTP id 5so7837165qwe.26
	for <xfs@oss.sgi.com>; Wed, 01 Dec 2010 23:01:30 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 2 Dec 2010 12:31:30 +0530
Message-ID: <AANLkTi=7r8gV-cnBU9WNkn6kHz82qnUp8XD2dzAY+LF7@mail.gmail.com>
Subject: XFS mount fail: XFS_WANT_CORRUPTED_GOTO fs/xfs/xfs_alloc.c
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0485073090544450301=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0485073090544450301==
Content-Type: multipart/alternative; boundary=0015175cded4ccbab7049667fd60

--0015175cded4ccbab7049667fd60
Content-Type: text/plain; charset=ISO-8859-1

Dear all,
This is XFS fail mount log on linux 2.6.30.9

XFS mounting filesystem sda2
Starting XFS recovery on filesystem: sda2 (logdev: internal)
XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1629 of file
fs/xfs/xfs_alloc.c.  Caller 0x80129658
Call Trace:
[<802dedc8>] dump_stack+0x8/0x34 from[<80127400>]
xfs_free_ag_extent+0x128/0x7ac
[<80127400>] xfs_free_ag_extent+0x128/0x7ac from[<80129658>]
xfs_free_extent+0xb8/0xe8
[<80129658>] xfs_free_extent+0xb8/0xe8 from[<80163978>]
xlog_recover_process_efi+0x160/0x214
[<80163978>] xlog_recover_process_efi+0x160/0x214 from[<80163ac4>]
xlog_recover_process_efis+0x98/0x11c
[<80163ac4>] xlog_recover_process_efis+0x98/0x11c from[<8016663c>]
xlog_recover_finish+0x28/0xdc
[<8016663c>] xlog_recover_finish+0x28/0xdc from[<8016aec0>]
xfs_mountfs+0x4d0/0x610
[<8016aec0>] xfs_mountfs+0x4d0/0x610 from[<80184434>]
xfs_fs_fill_super+0x1fc/0x418
[<80184434>] xfs_fs_fill_super+0x1fc/0x418 from[<800bae48>]
get_sb_bdev+0x11c/0x1c0
[<800bae48>] get_sb_bdev+0x11c/0x1c0 from[<80181f20>]
xfs_fs_get_sb+0x20/0x2c
[<80181f20>] xfs_fs_get_sb+0x20/0x2c from[<800b9424>]
vfs_kern_mount+0x68/0xd0
[<800b9424>] vfs_kern_mount+0x68/0xd0 from[<800b94f0>]
do_kern_mount+0x54/0x118
[<800b94f0>] do_kern_mount+0x54/0x118 from[<800d44e8>] do_mount+0x7b4/0x828
[<800d44e8>] do_mount+0x7b4/0x828 from[<800d45f8>] sys_mount+0x9c/0x194
[<800d45f8>] sys_mount+0x9c/0x194 from[<800102c4>] stack_done+0x20/0x3c

Failed to recover EFIs on filesystem: sda2
XFS: log mount finish failed

--0015175cded4ccbab7049667fd60
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Dear all,</div>
<div>This is XFS fail mount log on linux 2.6.30.9</div>
<div>=A0</div>
<div>XFS mounting filesystem sda2<br>Starting XFS recovery on filesystem: s=
da2 (logdev: internal)<br>XFS internal error XFS_WANT_CORRUPTED_GOTO at lin=
e 1629 of file fs/xfs/xfs_alloc.c.=A0 Caller 0x80129658<br>Call Trace:<br>
[&lt;802dedc8&gt;] dump_stack+0x8/0x34 from[&lt;80127400&gt;] xfs_free_ag_e=
xtent+0x128/0x7ac<br>[&lt;80127400&gt;] xfs_free_ag_extent+0x128/0x7ac from=
[&lt;80129658&gt;] xfs_free_extent+0xb8/0xe8<br>[&lt;80129658&gt;] xfs_free=
_extent+0xb8/0xe8 from[&lt;80163978&gt;] xlog_recover_process_efi+0x160/0x2=
14<br>
[&lt;80163978&gt;] xlog_recover_process_efi+0x160/0x214 from[&lt;80163ac4&g=
t;] xlog_recover_process_efis+0x98/0x11c<br>[&lt;80163ac4&gt;] xlog_recover=
_process_efis+0x98/0x11c from[&lt;8016663c&gt;] xlog_recover_finish+0x28/0x=
dc<br>
[&lt;8016663c&gt;] xlog_recover_finish+0x28/0xdc from[&lt;8016aec0&gt;] xfs=
_mountfs+0x4d0/0x610<br>[&lt;8016aec0&gt;] xfs_mountfs+0x4d0/0x610 from[&lt=
;80184434&gt;] xfs_fs_fill_super+0x1fc/0x418<br>[&lt;80184434&gt;] xfs_fs_f=
ill_super+0x1fc/0x418 from[&lt;800bae48&gt;] get_sb_bdev+0x11c/0x1c0<br>
[&lt;800bae48&gt;] get_sb_bdev+0x11c/0x1c0 from[&lt;80181f20&gt;] xfs_fs_ge=
t_sb+0x20/0x2c<br>[&lt;80181f20&gt;] xfs_fs_get_sb+0x20/0x2c from[&lt;800b9=
424&gt;] vfs_kern_mount+0x68/0xd0<br>[&lt;800b9424&gt;] vfs_kern_mount+0x68=
/0xd0 from[&lt;800b94f0&gt;] do_kern_mount+0x54/0x118<br>
[&lt;800b94f0&gt;] do_kern_mount+0x54/0x118 from[&lt;800d44e8&gt;] do_mount=
+0x7b4/0x828<br>[&lt;800d44e8&gt;] do_mount+0x7b4/0x828 from[&lt;800d45f8&g=
t;] sys_mount+0x9c/0x194<br>[&lt;800d45f8&gt;] sys_mount+0x9c/0x194 from[&l=
t;800102c4&gt;] stack_done+0x20/0x3c<br>
=A0<br>Failed to recover EFIs on filesystem: sda2<br>XFS: log mount finish =
failed</div>

--0015175cded4ccbab7049667fd60--


--===============0485073090544450301==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0485073090544450301==--
