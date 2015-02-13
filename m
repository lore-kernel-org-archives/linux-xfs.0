Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D9D8F7F69
	for <xfs@oss.sgi.com>; Fri, 13 Feb 2015 12:45:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5983DAC001
	for <xfs@oss.sgi.com>; Fri, 13 Feb 2015 10:45:00 -0800 (PST)
Received: from mail-we0-f169.google.com (mail-we0-f169.google.com
	[74.125.82.169]) by cuda.sgi.com with ESMTP id seXMiScMUPYR1FkS
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Feb 2015 10:44:58 -0800 (PST)
Received: by mail-we0-f169.google.com with SMTP id k48so18386411wev.0
	for <xfs@oss.sgi.com>; Fri, 13 Feb 2015 10:44:57 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 13 Feb 2015 15:44:57 -0300
Message-ID: <CAF1in6QW=PS0qfBAtQZHC23r+WVAXv5TLxFAr0r6RfTNiOnXcQ@mail.gmail.com>
Subject: XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 990 of file
	fs/xfs/xfs_ialloc.c
From: Pablo Silva <psilvao@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8066686724556720960=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8066686724556720960==
Content-Type: multipart/alternative; boundary=001a11c2616e18b985050efca2c7

--001a11c2616e18b985050efca2c7
Content-Type: text/plain; charset=UTF-8

Hi !

    We have a server with centos 6.6, kernel version:
2.6.32-431.17.1.el6.x86_64, where we got the following message:

Feb 12 19:22:15 vtl kernel:
Feb 12 19:22:15 vtl kernel: Pid: 3502, comm: touch Not tainted
2.6.32-431.17.1.el6.x86_64 #1
Feb 12 19:22:15 vtl kernel: Call Trace:
Feb 12 19:22:15 vtl kernel: [<ffffffffa041ae5f>] ?
xfs_error_report+0x3f/0x50 [xfs]
Feb 12 19:22:15 vtl kernel: [<ffffffffa0422980>] ? xfs_ialloc+0x60/0x6e0 [xfs]
Feb 12 19:22:15 vtl kernel: [<ffffffffa041ec2e>] ? xfs_dialloc+0x43e/0x850 [xfs]
Feb 12 19:22:15 vtl kernel: [<ffffffffa0422980>] ? xfs_ialloc+0x60/0x6e0 [xfs]
Feb 12 19:22:15 vtl kernel: [<ffffffffa044007a>] ?
kmem_zone_zalloc+0x3a/0x50 [xfs]
Feb 12 19:22:15 vtl kernel: [<ffffffffa043b814>] ?
xfs_dir_ialloc+0x74/0x2b0 [xfs]
Feb 12 19:22:15 vtl kernel: [<ffffffffa043d900>] ? xfs_create+0x440/0x640 [xfs]
Feb 12 19:22:15 vtl kernel: [<ffffffffa044aa5d>] ? xfs_vn_mknod+0xad/0x1c0 [xfs]
Feb 12 19:22:15 vtl kernel: [<ffffffffa044aba0>] ? xfs_vn_create+0x10/0x20 [xfs]
Feb 12 19:22:15 vtl kernel: [<ffffffff81198086>] ? vfs_create+0xe6/0x110
Feb 12 19:22:15 vtl kernel: [<ffffffff8119bb9e>] ? do_filp_open+0xa8e/0xd20
Feb 12 19:22:15 vtl kernel: [<ffffffff811a7ea2>] ? alloc_fd+0x92/0x160
Feb 12 19:22:15 vtl kernel: XFS: Internal error
XFS_WANT_CORRUPTED_GOTO at line 990 of file fs/xfs/xfs_ialloc.c.
Caller 0xffffffffa0422980

I can't find more information for this..., perhaps a bug or other
thing ..., welcome any hint for to research..

Thanks in advance!

-Pablo

--001a11c2616e18b985050efca2c7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi !<br><br></div>=C2=A0=C2=A0=C2=A0 We have a server=
 with centos 6.6, kernel version: 2.6.32-431.17.1.el6.x86_64, where we got =
the following message:<br><br><pre class=3D"">Feb 12 19:22:15 vtl kernel:=
=20
Feb 12 19:22:15 vtl kernel: Pid: 3502, comm: touch Not tainted 2.6.32-431.1=
7.1.el6.x86_64 #1
Feb 12 19:22:15 vtl kernel: Call Trace:
Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa041ae5f&gt;] ? xfs_error_report+0=
x3f/0x50 [xfs]
Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa0422980&gt;] ? xfs_ialloc+0x60/0x=
6e0 [xfs]
Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa041ec2e&gt;] ? xfs_dialloc+0x43e/=
0x850 [xfs]
Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa0422980&gt;] ? xfs_ialloc+0x60/0x=
6e0 [xfs]
Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa044007a&gt;] ? kmem_zone_zalloc+0=
x3a/0x50 [xfs]
Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa043b814&gt;] ? xfs_dir_ialloc+0x7=
4/0x2b0 [xfs]
Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa043d900&gt;] ? xfs_create+0x440/0=
x640 [xfs]
Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa044aa5d&gt;] ? xfs_vn_mknod+0xad/=
0x1c0 [xfs]
Feb 12 19:22:15 vtl kernel: [&lt;ffffffffa044aba0&gt;] ? xfs_vn_create+0x10=
/0x20 [xfs]
Feb 12 19:22:15 vtl kernel: [&lt;ffffffff81198086&gt;] ? vfs_create+0xe6/0x=
110
Feb 12 19:22:15 vtl kernel: [&lt;ffffffff8119bb9e&gt;] ? do_filp_open+0xa8e=
/0xd20
Feb 12 19:22:15 vtl kernel: [&lt;ffffffff811a7ea2&gt;] ? alloc_fd+0x92/0x16=
0
Feb 12 19:22:15 vtl kernel: XFS: Internal error XFS_WANT_CORRUPTED_GOTO at =
line 990 of file fs/xfs/xfs_ialloc.c.  Caller 0xffffffffa0422980
<br></pre><pre class=3D"">I can&#39;t find more information for this..., pe=
rhaps a bug or other thing ..., welcome any hint for to research..<br><br><=
/pre><pre class=3D"">Thanks in advance!<br><br></pre><pre class=3D"">-Pablo=
 <br></pre></div>

--001a11c2616e18b985050efca2c7--


--===============8066686724556720960==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8066686724556720960==--
