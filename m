Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q35KYcMx070336 for <xfs@oss.sgi.com>; Thu, 5 Apr 2012 15:34:40 -0500
Received: from na3sys009aog105.obsmtp.com (na3sys009aog105.obsmtp.com
	[74.125.149.75]) by cuda.sgi.com with SMTP id cU6d1uUgBLUbCvnA
	for <xfs@oss.sgi.com>; Thu, 05 Apr 2012 13:34:31 -0700 (PDT)
Received: by lbgc1 with SMTP id c1so373029lbg.24
	for <xfs@oss.sgi.com>; Thu, 05 Apr 2012 13:34:29 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 5 Apr 2012 16:34:29 -0400
Message-ID: <CAFcHYYA5Ff3zdVtqArnWjM1vYkn-2BQfAnthUTQwTbWH=L3Mhg@mail.gmail.com>
Subject: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1518 of file
	fs/xfs/xfs_alloc.c.
From: Robert Bennett <rbennett@mail.crawford.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3046106761760085613=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3046106761760085613==
Content-Type: multipart/alternative; boundary=f46d04088d7b7cc5b804bcf47794

--f46d04088d7b7cc5b804bcf47794
Content-Type: text/plain; charset=ISO-8859-1

file system error - unmounted file system and had to perform xfs_repair -L

file system came back, thank you!

below is the pertinent portion of the log file.

0 length files created in lost+found

An rsync process was occurring at the time.


Please help me to troubleshoot this.


[root@alice lost+found]# uname -a
Linux alice 2.6.32-131.17.1.el6.x86_64 #1 SMP Thu Sep 29 10:24:25 EDT 2011
x86_64 x86_64 x86_64 GNU/Linux

thanks

-bob


 Mar 28 14:48:28 alice kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO
at line 1518 of file fs/xfs/xfs_alloc.c. Caller 0xffffffffa023a532

Mar 28 14:48:28 alice kernel: Pid: 6135, comm: mv Not tainted
2.6.32-131.17.1.el6.x86_64 #1

Mar 28 14:48:28 alice kernel: Call Trace:

Mar 28 14:48:28 alice kernel: [<ffffffffa0262163>] ?
xfs_error_report+0x43/0x50 [xfs]

Mar 28 14:48:28 alice kernel: [<ffffffffa023a532>] ?
xfs_free_extent+0xa2/0xc0 [xfs]

Mar 28 14:48:28 alice kernel: [<ffffffffa02385da>] ?
xfs_free_ag_extent+0x56a/0x7e0 [xfs]

Mar 28 14:48:28 alice kernel: [<ffffffffa023a532>] ?
xfs_free_extent+0xa2/0xc0 [xfs]

Mar 28 14:48:28 alice kernel: [<ffffffffa0243edd>] ?
xfs_bmap_finish+0x15d/0x1a0 [xfs]

Mar 28 14:48:28 alice kernel: [<ffffffffa0269cf3>] ?
xfs_itruncate_finish+0x183/0x390 [xfs]

Mar 28 14:48:28 alice kernel: [<ffffffffa0284dc8>] ?
xfs_inactive+0x358/0x4e0 [xfs]

Mar 28 14:48:28 alice kernel: [<ffffffff814dc34e>] ? mutex_lock+0x1e/0x50

Mar 28 14:48:28 alice kernel: [<ffffffffa0294fa0>] ?
xfs_fs_clear_inode+0xa0/0xe0 [xfs]

Mar 28 14:48:28 alice kernel: [<ffffffff8118cb7f>] ? clear_inode+0x8f/0x110

Mar 28 14:48:28 alice kernel: [<ffffffff8118d326>] ?
generic_delete_inode+0x196/0x1d0

Mar 28 14:48:28 alice kernel: [<ffffffff8118d3c5>] ?
generic_drop_inode+0x65/0x80

Mar 28 14:48:28 alice kernel: [<ffffffff8118c232>] ? iput+0x62/0x70

Mar 28 14:48:28 alice kernel: [<ffffffff811835e2>] ?
do_unlinkat+0x112/0x1c0

Mar 28 14:48:28 alice kernel: [<ffffffff81177e36>] ?
sys_newfstatat+0x36/0x50

Mar 28 14:48:28 alice kernel: [<ffffffff811837f2>] ? sys_unlinkat+0x22/0x40

Mar 28 14:48:28 alice kernel: [<ffffffff8100b172>] ?
system_call_fastpath+0x16/0x1b

Mar 28 14:48:28 alice kernel: xfs_force_shutdown(drbd1,0x8) called from
line 4011 of file fs/xfs/xfs_bmap.c. Return address = 0xffffffffa0243f16

Mar 28 14:48:28 alice kernel: Filesystem "drbd1": Corruption of in-memory
data detected. Shutting down filesystem: drbd1

Mar 28 14:48:28 alice kernel: Please umount the filesystem, and rectify the
problem(s)

--f46d04088d7b7cc5b804bcf47794
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable



<p class=3D"MsoNormal">file system error - unmounted file system and had to=
 perform
xfs_repair -L </p>

<p class=3D"MsoNormal">file system came back, thank you! </p>

<p class=3D"MsoNormal">below is the pertinent portion of the log file. <br>=
</p><p class=3D"MsoNormal">0 length files created in lost+found</p><p class=
=3D"MsoNormal">An rsync process was occurring at the time.<br></p><p class=
=3D"MsoNormal">
<br></p><p class=3D"MsoNormal">Please help me to troubleshoot this.=A0=A0</=
p><p class=3D"MsoNormal"><br></p><p class=3D"MsoNormal">[root@alice lost+fo=
und]# uname -a<br>Linux alice 2.6.32-131.17.1.el6.x86_64 #1 SMP Thu Sep 29 =
10:24:25 EDT 2011 x86_64 x86_64 x86_64 GNU/Linux<br>
<br></p>

<p class=3D"MsoNormal">thanks </p>

<p class=3D"MsoNormal">-bob</p><p class=3D"MsoNormal"><br> </p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: XFS internal error
XFS_WANT_CORRUPTED_GOTO at line 1518 of file fs/xfs/xfs_alloc.c. Caller
0xffffffffa023a532 </p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: Pid: 6135, comm: mv No=
t
tainted 2.6.32-131.17.1.el6.x86_64 #1 </p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: Call Trace: </p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: [&lt;ffffffffa0262163&=
gt;] ?
xfs_error_report+0x43/0x50 [xfs]</p>

<p class=3D"MsoNormal"><span style></span>Mar 28 14:48:28 alice
kernel: [&lt;ffffffffa023a532&gt;] ? xfs_free_extent+0xa2/0xc0 [xfs]</p>

<p class=3D"MsoNormal"><span style></span>Mar 28 14:48:28 alice
kernel: [&lt;ffffffffa02385da&gt;] ? xfs_free_ag_extent+0x56a/0x7e0 [xfs] <=
/p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: [&lt;ffffffffa023a532&=
gt;] ?
xfs_free_extent+0xa2/0xc0 [xfs] </p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: [&lt;ffffffffa0243edd&=
gt;] ?
xfs_bmap_finish+0x15d/0x1a0 [xfs]</p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: [&lt;ffffffffa0269cf3&=
gt;] ?
xfs_itruncate_finish+0x183/0x390 [xfs] </p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: [&lt;ffffffffa0284dc8&=
gt;] ?
xfs_inactive+0x358/0x4e0 [xfs] </p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: [&lt;ffffffff814dc34e&=
gt;] ?
mutex_lock+0x1e/0x50 </p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: [&lt;ffffffffa0294fa0&=
gt;] ?
xfs_fs_clear_inode+0xa0/0xe0 [xfs] </p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: [&lt;ffffffff8118cb7f&=
gt;] ?
clear_inode+0x8f/0x110 </p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: [&lt;ffffffff8118d326&=
gt;] ?
generic_delete_inode+0x196/0x1d0 </p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: [&lt;ffffffff8118d3c5&=
gt;] ?
generic_drop_inode+0x65/0x80 </p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: [&lt;ffffffff8118c232&=
gt;] ?
iput+0x62/0x70 </p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: [&lt;ffffffff811835e2&=
gt;] ?
do_unlinkat+0x112/0x1c0 </p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: [&lt;ffffffff81177e36&=
gt;] ?
sys_newfstatat+0x36/0x50 </p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: [&lt;ffffffff811837f2&=
gt;] ?
sys_unlinkat+0x22/0x40 </p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: [&lt;ffffffff8100b172&=
gt;] ?
system_call_fastpath+0x16/0x1b </p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: xfs_force_shutdown(drb=
d1,0x8)
called from line 4011 of file fs/xfs/xfs_bmap.c. Return address =3D
0xffffffffa0243f16 </p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: Filesystem &quot;drbd1=
&quot;:
Corruption of in-memory data detected. Shutting down filesystem: drbd1 </p>

<p class=3D"MsoNormal">Mar 28 14:48:28 alice kernel: Please umount the file=
system,
and rectify the problem(s)</p>


--f46d04088d7b7cc5b804bcf47794--


--===============3046106761760085613==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3046106761760085613==--
