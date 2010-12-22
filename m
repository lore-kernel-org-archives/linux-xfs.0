Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBM5XWHD176480 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 23:33:32 -0600
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CFC3614732AE
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 21:35:27 -0800 (PST)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	hQ3mjc6iX6UK4Dnn for <xfs@oss.sgi.com>;
	Tue, 21 Dec 2010 21:35:27 -0800 (PST)
Received: by qyk12 with SMTP id 12so5146530qyk.5
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 21:35:27 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 22 Dec 2010 11:05:26 +0530
Message-ID: <AANLkTikOcJA5a6u2YDXVGAEY0CqKiATTF02VeBsSKtU0@mail.gmail.com>
Subject: XFS hangs
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1453448885232450071=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>

--===============1453448885232450071==
Content-Type: multipart/alternative; boundary=0016363b8030d7758e0497f91e2f

--0016363b8030d7758e0497f91e2f
Content-Type: text/plain; charset=ISO-8859-1

Hi,
I am encountering hang of XFS filesystem, please find the logs as given
below:
INFO: task usb_mount:1858 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
usb_mount        D [84a42440] 8032d62c     0  1858
1816                             (user thread)
Stack : 00000107 00000000 85e7be80 00030002 84a425c8 8032d62c 7fffffff
84a42440
        00000002 8496e200 00000001 00000000 85e7bf00 85e7bef8 7fa2f2e0
8032d62c
        00000001 801d69a8 85e7bd40 801d6b34 85e7bd4c 8032dc6c 00000000
801dbc80
        85e7be80 864315a8 8662c980 00000001 00000742 00000000 00000000
84b85800
        85e7bd90 801d6cc0 7fffffff 84a42440 00000002 8032ee74 00000081
804158a0
        ...
Call Trace:
[<8032d574>] __schedule+0x618/0x6b8 from[<8032d62c>] schedule+0x18/0x3c
[<8032d62c>] schedule+0x18/0x3c from[<8032dc6c>] schedule_timeout+0x2c/0x1c0
[<8032dc6c>] schedule_timeout+0x2c/0x1c0 from[<8032ee74>] __down+0x8c/0xdc
[<8032ee74>] __down+0x8c/0xdc from[<8004500c>] down+0x40/0x88
[<8004500c>] down+0x40/0x88 from[<801ca838>] xfs_buf_lock+0xcc/0x15c
[<801ca838>] xfs_buf_lock+0xcc/0x15c from[<801b71a0>] xfs_getsb+0x38/0x54
[<801b71a0>] xfs_getsb+0x38/0x54 from[<801d64a8>] xfs_sync_fsdata+0x7c/0x154
[<801d64a8>] xfs_sync_fsdata+0x7c/0x154 from[<801d7284>]
xfs_quiesce_data+0x34/0x60
[<801d7284>] xfs_quiesce_data+0x34/0x60 from[<801d3514>]
xfs_fs_sync_fs+0x30/0xec
[<801d3514>] xfs_fs_sync_fs+0x30/0xec from[<800ba09c>]
__fsync_super+0xa4/0xc8
[<800ba09c>] __fsync_super+0xa4/0xc8 from[<800ba0d4>] fsync_super+0x14/0x28
[<800ba0d4>] fsync_super+0x14/0x28 from[<800ba4a0>]
generic_shutdown_super+0x34/0x190
[<800ba4a0>] generic_shutdown_super+0x34/0x190 from[<800ba654>]
kill_block_super+0x58/0x80
[<800ba654>] kill_block_super+0x58/0x80 from[<800bac6c>]
deactivate_super+0x7c/0x110
[<800bac6c>] deactivate_super+0x7c/0x110 from[<800d2bbc>]
sys_umount+0x310/0x358
[<800d2bbc>] sys_umount+0x310/0x358 from[<8000ff44>] stack_done+0x20/0x3c
After reboot it works fine, but during this state XFS does not works no
operation.

Thanks,
Amit Sahrawat

--0016363b8030d7758e0497f91e2f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi, </div>
<div>I am encountering hang of XFS filesystem, please find the logs as give=
n below:</div>
<div>INFO: task usb_mount:1858 blocked for more than 120 seconds.<br>&quot;=
echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disables this mes=
sage.<br>usb_mount=A0=A0=A0=A0=A0=A0=A0 D [84a42440] 8032d62c=A0=A0=A0=A0 0=
=A0 1858=A0=A0 1816=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (user thread)<br>
Stack : 00000107 00000000 85e7be80 00030002 84a425c8 8032d62c 7fffffff 84a4=
2440<br>=A0=A0=A0=A0=A0=A0=A0 00000002 8496e200 00000001 00000000 85e7bf00 =
85e7bef8 7fa2f2e0 8032d62c<br>=A0=A0=A0=A0=A0=A0=A0 00000001 801d69a8 85e7b=
d40 801d6b34 85e7bd4c 8032dc6c 00000000 801dbc80<br>
=A0=A0=A0=A0=A0=A0=A0 85e7be80 864315a8 8662c980 00000001 00000742 00000000=
 00000000 84b85800<br>=A0=A0=A0=A0=A0=A0=A0 85e7bd90 801d6cc0 7fffffff 84a4=
2440 00000002 8032ee74 00000081 804158a0<br>=A0=A0=A0=A0=A0=A0=A0 ...<br>Ca=
ll Trace:<br>[&lt;8032d574&gt;] __schedule+0x618/0x6b8 from[&lt;8032d62c&gt=
;] schedule+0x18/0x3c<br>
[&lt;8032d62c&gt;] schedule+0x18/0x3c from[&lt;8032dc6c&gt;] schedule_timeo=
ut+0x2c/0x1c0<br>[&lt;8032dc6c&gt;] schedule_timeout+0x2c/0x1c0 from[&lt;80=
32ee74&gt;] __down+0x8c/0xdc<br>[&lt;8032ee74&gt;] __down+0x8c/0xdc from[&l=
t;8004500c&gt;] down+0x40/0x88<br>
[&lt;8004500c&gt;] down+0x40/0x88 from[&lt;801ca838&gt;] xfs_buf_lock+0xcc/=
0x15c<br>[&lt;801ca838&gt;] xfs_buf_lock+0xcc/0x15c from[&lt;801b71a0&gt;] =
xfs_getsb+0x38/0x54<br>[&lt;801b71a0&gt;] xfs_getsb+0x38/0x54 from[&lt;801d=
64a8&gt;] xfs_sync_fsdata+0x7c/0x154<br>
[&lt;801d64a8&gt;] xfs_sync_fsdata+0x7c/0x154 from[&lt;801d7284&gt;] xfs_qu=
iesce_data+0x34/0x60<br>[&lt;801d7284&gt;] xfs_quiesce_data+0x34/0x60 from[=
&lt;801d3514&gt;] xfs_fs_sync_fs+0x30/0xec<br>[&lt;801d3514&gt;] xfs_fs_syn=
c_fs+0x30/0xec from[&lt;800ba09c&gt;] __fsync_super+0xa4/0xc8<br>
[&lt;800ba09c&gt;] __fsync_super+0xa4/0xc8 from[&lt;800ba0d4&gt;] fsync_sup=
er+0x14/0x28<br>[&lt;800ba0d4&gt;] fsync_super+0x14/0x28 from[&lt;800ba4a0&=
gt;] generic_shutdown_super+0x34/0x190<br>[&lt;800ba4a0&gt;] generic_shutdo=
wn_super+0x34/0x190 from[&lt;800ba654&gt;] kill_block_super+0x58/0x80<br>
[&lt;800ba654&gt;] kill_block_super+0x58/0x80 from[&lt;800bac6c&gt;] deacti=
vate_super+0x7c/0x110<br>[&lt;800bac6c&gt;] deactivate_super+0x7c/0x110 fro=
m[&lt;800d2bbc&gt;] sys_umount+0x310/0x358<br>[&lt;800d2bbc&gt;] sys_umount=
+0x310/0x358 from[&lt;8000ff44&gt;] stack_done+0x20/0x3c<br>
</div>
<div>After reboot it works fine, but during this state XFS does not works n=
o operation.</div>
<div>=A0</div>
<div>Thanks,</div>
<div>Amit Sahrawat</div>
<div>=A0</div>

--0016363b8030d7758e0497f91e2f--


--===============1453448885232450071==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1453448885232450071==--
