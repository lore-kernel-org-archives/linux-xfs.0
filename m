Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0K52D5P027136 for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 23:02:14 -0600
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F1C5102F358
	for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 21:04:30 -0800 (PST)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	teJlJ0E0JreCsEQL for <xfs@oss.sgi.com>;
	Wed, 19 Jan 2011 21:04:30 -0800 (PST)
Received: by qyj19 with SMTP id 19so1548592qyj.5
	for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 21:04:30 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 20 Jan 2011 10:34:30 +0530
Message-ID: <AANLkTin22efc0cHSmM+2rNQpE2aJoobQCnMwbNUjw617@mail.gmail.com>
Subject: XFS - issues with writes using sync
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8887799676077751665=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

--===============8887799676077751665==
Content-Type: multipart/alternative; boundary=0016363b8b7091e003049a401190

--0016363b8b7091e003049a401190
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I am facing issues in XFS for a simple test case.
*Target:* ARM
*Kernel version:* 2.6.35.9

*Test case:*
mkfs.xfs -f /dev/sda2
mount -t xfs /dev/sda2 /mnt/usb/sda2
(Run script - trying to fragment the XFS formatted partition)
#!/bin/sh
index=0
while [ "$?" == 0 ]
do
index=$((index+1))
sync
cp /mnt/usb/sda1/setupfile /mnt/usb/sda2/setupfile.$index
done

Partition Size on which files are being created - 1GB(I need to fragment
this first to run other cases)
Size of *'setupfile'*  - 16K

There used be no such issues till *2.6.34*(last XFS version where we tried
to create setup). There is no reset involved this time, just simple running
the script caused this issue.

*Back Trace:*
#> ./createsetup.sh
kernel BUG at fs/buffer.c:396!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 817 [#1] PREEMPT
last sysfs file:
/sys/devices/platform/ehci-sdp.1/usb2/2-1/2-1.3/2-1.3:1.0/host0/target0:0:0/0:0:0:0/model
Modules linked in:
CPU: 0    Not tainted  (2.6.35.9 #4)
PC is at __bug+0x24/0x30
LR is at walk_stackframe+0x24/0x40
pc : [<c04483e8>]    lr : [<c04481b8>]    psr: 60000013
sp : c35cfee0  ip : c35cfdd0  fp : c35cfeec
r10: c05c7b64  r9 : c35896a8  r8 : c35c07f0
r7 : c7856688  r6 : c78585e0  r5 : c402a960  r4 : c78566c8
r3 : 00000000  r2 : c35cfe30  r1 : c35cfe00  r0 : 00000025
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c53c7d  Table: 83c28059  DAC: 00000017
Process xfsdatad/0 (pid: 340, stack limit = 0xc35ce2e8)
Stack: (0xc35cfee0 to 0xc35d0000)
fee0: c35cff2c c35cfef0 c05126e4 c04483d0 00000004 c78584c0 c78585e0
c05c78b4
ff00: c35cff2c c35cff10 c05a51cc c05c0220 c78584c0 c35c07c8 c78584c0
c78585e0
ff20: c35cff4c c35cff30 c05c7a50 c05125fc c35c07c8 c35c07f0 c35c07f4
c3d264a0
ff40: c35cff74 c35cff50 c05c7c4c c05c7a28 c35cff74 c35cff60 c35ce000
c35896a0
ff60: c35c07f4 c3d264a0 c35cffc4 c35cff78 c0482874 c05c7b70 c35cff9c
c35cff88
ff80: c06f7158 00000000 c3d264a0 c0486820 c35cff90 c35cff90 c06f2bb4
c3c1fec0
ffa0: c35cffcc c048268c c35896a0 00000000 00000000 00000000 c35cfff4
c35cffc8
ffc0: c0486380 c0482698 00000000 00000000 c35cffd0 c35cffd0 c3c1fec0
c04862fc
ffe0: c046eeb8 00000013 00000000 c35cfff8 c046eeb8 c0486308 00000000
00000000
Backtrace:
[<c04483c4>] (__bug+0x0/0x30) from [<c05126e4>]
(end_buffer_async_write+0xf4/0x1c8)
[<c05125f0>] (end_buffer_async_write+0x0/0x1c8) from [<c05c7a50>]
(xfs_destroy_ioend+0x34/0x84)
 r6:c78585e0 r5:c78584c0 r4:c35c07c8
[<c05c7a1c>] (xfs_destroy_ioend+0x0/0x84) from [<c05c7c4c>]
(xfs_end_io+0xe8/0xf0)
 r7:c3d264a0 r6:c35c07f4 r5:c35c07f0 r4:c35c07c8
[<c05c7b64>] (xfs_end_io+0x0/0xf0) from [<c0482874>]
(worker_thread+0x1e8/0x294)
 r7:c3d264a0 r6:c35c07f4 r5:c35896a0 r4:c35ce000
[<c048268c>] (worker_thread+0x0/0x294) from [<c0486380>] (kthread+0x84/0x8c)
[<c04862fc>] (kthread+0x0/0x8c) from [<c046eeb8>] (do_exit+0x0/0x6cc)
 r7:00000013 r6:c046eeb8 r5:c04862fc r4:c3c1fec0
Code: e59f0010 e1a01003 eb0aa878 e3a03000 (e5833000)
---[ end trace 016e72fe751b35ae ]---
^C^Z[1] + Stopped                    ./createsetup.sh

After this I tried to unmount the XFS partition,

#umount /mnt/usb/sda2 (This command hangs and never returns)

Then, I did a reset of the target to check the state of XFS partition on
next mount.

*Back trace:*
#> mount /dev/sda2 /mnt/
XFS mounting filesystem sda2
Starting XFS recovery on filesystem: sda2 (logdev: internal)
Filesystem "sda2": XFS internal error xlog_valid_rec_header(1) at line 3431
of file fs/xfs/xfs_log_recover.c.  Caller 0xc05b95d8

Backtrace:
[<c04486ac>] (dump_backtrace+0x0/0x110) from [<c06f24e0>]
(dump_stack+0x18/0x1c)
 r6:c324e000 r5:00000000 r4:000012bb r3:c3629be0
[<c06f24c8>] (dump_stack+0x0/0x1c) from [<c05a07e8>]
(xfs_error_report+0x4c/0x5c)
[<c05a079c>] (xfs_error_report+0x0/0x5c) from [<c05b5870>]
(xlog_valid_rec_header+0xe4/0x10c)
[<c05b578c>] (xlog_valid_rec_header+0x0/0x10c) from [<c05b95d8>]
(xlog_do_recovery_pass+0x80/0x650)
 r7:00000000 r6:c324e000 r5:c36d2440 r4:c3044220
[<c05b9558>] (xlog_do_recovery_pass+0x0/0x650) from [<c05b9bf4>]
(xlog_do_log_recovery+0x4c/0x90)
[<c05b9ba8>] (xlog_do_log_recovery+0x0/0x90) from [<c05b9c58>]
(xlog_do_recover+0x20/0x120)
 r9:00000000 r8:0001e91e r7:00000000 r6:000012bb r5:00000000
r4:c3044220
[<c05b9c38>] (xlog_do_recover+0x0/0x120) from [<c05b9de0>]
(xlog_recover+0x88/0xa8)
 r9:00000000 r8:0001e91e r7:00000000 r6:000012bb r5:00000000
r4:c3044220
[<c05b9d58>] (xlog_recover+0x0/0xa8) from [<c05b2888>]
(xfs_log_mount+0xec/0x17c)
 r7:00000000 r6:00000000 r4:c300fc00
[<c05b279c>] (xfs_log_mount+0x0/0x17c) from [<c05bc6a4>]
(xfs_mountfs+0x310/0x674)
 r9:00000000 r8:0001e91e r7:000004b0 r6:00002580 r5:c05d4f84
r4:c300fc00
[<c05bc394>] (xfs_mountfs+0x0/0x674) from [<c05d4f84>]
(xfs_fs_fill_super+0x1f8/0x36c)
 r9:00000040 r8:00000400 r7:c05d4d8c r6:00000000 r5:c36fd600
r4:c300fc00
[<c05d4d8c>] (xfs_fs_fill_super+0x0/0x36c) from [<c04ee600>]
(get_sb_bdev+0x114/0x170)
[<c04ee4ec>] (get_sb_bdev+0x0/0x170) from [<c05d2f44>]
(xfs_fs_get_sb+0x24/0x30)
[<c05d2f20>] (xfs_fs_get_sb+0x0/0x30) from [<c04ed138>]
(vfs_kern_mount+0x64/0x114)
[<c04ed0d4>] (vfs_kern_mount+0x0/0x114) from [<c04ed244>]
(do_kern_mount+0x3c/0xe0)
 r8:00008000 r7:c31db500 r6:c32eb000 r5:c365bf20 r4:c07f6a6c
[<c04ed208>] (do_kern_mount+0x0/0xe0) from [<c0506594>]
(do_mount+0x700/0x77c)
 r8:00008000 r7:00000000 r6:00000000 r5:c31db500 r4:00000020
r3:c32eb000
[<c0505e94>] (do_mount+0x0/0x77c) from [<c050669c>] (sys_mount+0x8c/0xcc)
[<c0506610>] (sys_mount+0x0/0xcc) from [<c04449a0>]
(ret_fast_syscall+0x0/0x30)
 r7:00000015 r6:001854e0 r5:bee32780 r4:00186028
XFS: log mount/recovery failed: error 117
XFS: log mount failed
mount: mounting /dev/sda2 on /mnt/ failed: Structure needs cleaning


Tried to us xfs_repair on the device
#> xfs_repair /dev/sda2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_repair.  If you are unable to mount the filesystem, then use
the -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.

#> xfs_repair -L /dev/sda2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
ALERT: The filesystem has valuable metadata changes in a log which is being
destroyed because the -L option was used.
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
bad hash ordering in block 8388617 of directory inode 128
imap claims a free inode 200248 is in use, correcting imap and clearing
inode
cleared inode 200248
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
entry "setupfile.3126" at block 22 offset 2576 in directory inode 128
references free inode 200248
        clearing inode number in entry at offset 2576...
        - agno = 1
        - agno = 2
        - agno = 3
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
rebuilding directory inode 128
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

Please let me know if there is anything i have missed. Also, if it is good
enough to 2.6.35.9 for product?

Thanks & Regards,
Amit Sahrawat

--0016363b8b7091e003049a401190
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi,</div>
<div>=A0</div>
<div>I am facing issues in XFS for a simple test case. </div>
<div><strong>Target:</strong> ARM</div>
<div><strong>Kernel version:</strong> 2.6.35.9</div>
<div>=A0</div>
<div><strong>Test case:</strong></div>
<div>mkfs.xfs -f /dev/sda2</div>
<div>mount -t xfs /dev/sda2 /mnt/usb/sda2</div>
<div>(Run script - trying to fragment the XFS formatted partition)</div>
<div>#!/bin/sh=A0<br>index=3D0<br>while [ &quot;$?&quot; =3D=3D 0 ]<br>do<b=
r>index=3D$((index+1))<br>sync<br>cp /mnt/usb/sda1/setupfile /mnt/usb/sda2/=
setupfile.$index<br>done</div>
<div>=A0</div>
<div>Partition Size on which files are being created - 1GB(I need to fragme=
nt this first to run other cases)</div>
<div>Size of <em>&#39;setupfile&#39;</em>=A0 - 16K</div>
<div>=A0</div>
<div>There used be no such issues till <strong>2.6.34</strong>(last XFS ver=
sion where we tried to create setup). There is no reset involved this time,=
 just simple running the script caused this issue.</div>
<div>=A0</div>
<div><strong>Back Trace:</strong></div>
<div>#&gt; ./createsetup.sh <br>kernel BUG at fs/buffer.c:396!<br>Unable to=
 handle kernel NULL pointer dereference at virtual address 00000000<br>pgd =
=3D c0004000<br>[00000000] *pgd=3D00000000<br>Internal error: Oops: 817 [#1=
] PREEMPT<br>
last sysfs file: /sys/devices/platform/ehci-sdp.1/usb2/2-1/2-1.3/2-1.3:1.0/=
host0/target0:0:0/0:0:0:0/model<br>Modules linked in:<br>CPU: 0=A0=A0=A0 No=
t tainted=A0 (2.6.35.9 #4)<br>PC is at __bug+0x24/0x30<br>LR is at walk_sta=
ckframe+0x24/0x40<br>
pc : [&lt;c04483e8&gt;]=A0=A0=A0 lr : [&lt;c04481b8&gt;]=A0=A0=A0 psr: 6000=
0013<br>sp : c35cfee0=A0 ip : c35cfdd0=A0 fp : c35cfeec<br>r10: c05c7b64=A0=
 r9 : c35896a8=A0 r8 : c35c07f0<br>r7 : c7856688=A0 r6 : c78585e0=A0 r5 : c=
402a960=A0 r4 : c78566c8<br>
r3 : 00000000=A0 r2 : c35cfe30=A0 r1 : c35cfe00=A0 r0 : 00000025<br>Flags: =
nZCv=A0 IRQs on=A0 FIQs on=A0 Mode SVC_32=A0 ISA ARM=A0 Segment kernel<br>C=
ontrol: 10c53c7d=A0 Table: 83c28059=A0 DAC: 00000017<br>Process xfsdatad/0 =
(pid: 340, stack limit =3D 0xc35ce2e8)<br>
Stack: (0xc35cfee0 to 0xc35d0000)<br>fee0: c35cff2c c35cfef0 c05126e4 c0448=
3d0 00000004 c78584c0 c78585e0 c05c78b4<br>ff00: c35cff2c c35cff10 c05a51cc=
 c05c0220 c78584c0 c35c07c8 c78584c0 c78585e0<br>ff20: c35cff4c c35cff30 c0=
5c7a50 c05125fc c35c07c8 c35c07f0 c35c07f4 c3d264a0<br>
ff40: c35cff74 c35cff50 c05c7c4c c05c7a28 c35cff74 c35cff60 c35ce000 c35896=
a0<br>ff60: c35c07f4 c3d264a0 c35cffc4 c35cff78 c0482874 c05c7b70 c35cff9c =
c35cff88<br>ff80: c06f7158 00000000 c3d264a0 c0486820 c35cff90 c35cff90 c06=
f2bb4 c3c1fec0<br>
ffa0: c35cffcc c048268c c35896a0 00000000 00000000 00000000 c35cfff4 c35cff=
c8<br>ffc0: c0486380 c0482698 00000000 00000000 c35cffd0 c35cffd0 c3c1fec0 =
c04862fc<br>ffe0: c046eeb8 00000013 00000000 c35cfff8 c046eeb8 c0486308 000=
00000 00000000<br>
Backtrace: <br>[&lt;c04483c4&gt;] (__bug+0x0/0x30) from [&lt;c05126e4&gt;] =
(end_buffer_async_write+0xf4/0x1c8)<br>[&lt;c05125f0&gt;] (end_buffer_async=
_write+0x0/0x1c8) from [&lt;c05c7a50&gt;] (xfs_destroy_ioend+0x34/0x84)<br>
=A0r6:c78585e0 r5:c78584c0 r4:c35c07c8<br>[&lt;c05c7a1c&gt;] (xfs_destroy_i=
oend+0x0/0x84) from [&lt;c05c7c4c&gt;] (xfs_end_io+0xe8/0xf0)<br>=A0r7:c3d2=
64a0 r6:c35c07f4 r5:c35c07f0 r4:c35c07c8<br>[&lt;c05c7b64&gt;] (xfs_end_io+=
0x0/0xf0) from [&lt;c0482874&gt;] (worker_thread+0x1e8/0x294)<br>
=A0r7:c3d264a0 r6:c35c07f4 r5:c35896a0 r4:c35ce000<br>[&lt;c048268c&gt;] (w=
orker_thread+0x0/0x294) from [&lt;c0486380&gt;] (kthread+0x84/0x8c)<br>[&lt=
;c04862fc&gt;] (kthread+0x0/0x8c) from [&lt;c046eeb8&gt;] (do_exit+0x0/0x6c=
c)<br>
=A0r7:00000013 r6:c046eeb8 r5:c04862fc r4:c3c1fec0<br>Code: e59f0010 e1a010=
03 eb0aa878 e3a03000 (e5833000) <br>---[ end trace 016e72fe751b35ae ]---</d=
iv>
<div>^C^Z[1] + Stopped=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 ./createsetup.sh</div>
<div>=A0</div>
<div>After this I tried to unmount the XFS partition,</div>
<div>=A0</div>
<div>#umount /mnt/usb/sda2 (This command hangs and never returns)</div>
<div>=A0</div>
<div>Then, I did a reset of the target to check the state of XFS partition =
on next mount.</div>
<div>=A0</div>
<div><strong>Back trace:</strong></div>
<div>#&gt; mount /dev/sda2 /mnt/<br>XFS mounting filesystem sda2<br>Startin=
g XFS recovery on filesystem: sda2 (logdev: internal)<br>Filesystem &quot;s=
da2&quot;: XFS internal error xlog_valid_rec_header(1) at line 3431 of file=
 fs/xfs/xfs_log_recover.c.=A0 Caller 0xc05b95d8<br>
=A0<br>Backtrace: <br>[&lt;c04486ac&gt;] (dump_backtrace+0x0/0x110) from [&=
lt;c06f24e0&gt;] (dump_stack+0x18/0x1c)<br>=A0r6:c324e000 r5:00000000 r4:00=
0012bb r3:c3629be0<br>[&lt;c06f24c8&gt;] (dump_stack+0x0/0x1c) from [&lt;c0=
5a07e8&gt;] (xfs_error_report+0x4c/0x5c)<br>
[&lt;c05a079c&gt;] (xfs_error_report+0x0/0x5c) from [&lt;c05b5870&gt;] (xlo=
g_valid_rec_header+0xe4/0x10c)<br>[&lt;c05b578c&gt;] (xlog_valid_rec_header=
+0x0/0x10c) from [&lt;c05b95d8&gt;] (xlog_do_recovery_pass+0x80/0x650)<br>
=A0r7:00000000 r6:c324e000 r5:c36d2440 r4:c3044220<br>[&lt;c05b9558&gt;] (x=
log_do_recovery_pass+0x0/0x650) from [&lt;c05b9bf4&gt;] (xlog_do_log_recove=
ry+0x4c/0x90)<br>[&lt;c05b9ba8&gt;] (xlog_do_log_recovery+0x0/0x90) from [&=
lt;c05b9c58&gt;] (xlog_do_recover+0x20/0x120)<br>
=A0r9:00000000 r8:0001e91e r7:00000000 r6:000012bb r5:00000000<br>r4:c30442=
20<br>[&lt;c05b9c38&gt;] (xlog_do_recover+0x0/0x120) from [&lt;c05b9de0&gt;=
] (xlog_recover+0x88/0xa8)<br>=A0r9:00000000 r8:0001e91e r7:00000000 r6:000=
012bb r5:00000000<br>
r4:c3044220<br>[&lt;c05b9d58&gt;] (xlog_recover+0x0/0xa8) from [&lt;c05b288=
8&gt;] (xfs_log_mount+0xec/0x17c)<br>=A0r7:00000000 r6:00000000 r4:c300fc00=
<br>[&lt;c05b279c&gt;] (xfs_log_mount+0x0/0x17c) from [&lt;c05bc6a4&gt;] (x=
fs_mountfs+0x310/0x674)<br>
=A0r9:00000000 r8:0001e91e r7:000004b0 r6:00002580 r5:c05d4f84<br>r4:c300fc=
00<br>[&lt;c05bc394&gt;] (xfs_mountfs+0x0/0x674) from [&lt;c05d4f84&gt;] (x=
fs_fs_fill_super+0x1f8/0x36c)<br>=A0r9:00000040 r8:00000400 r7:c05d4d8c r6:=
00000000 r5:c36fd600<br>
r4:c300fc00<br>[&lt;c05d4d8c&gt;] (xfs_fs_fill_super+0x0/0x36c) from [&lt;c=
04ee600&gt;] (get_sb_bdev+0x114/0x170)<br>[&lt;c04ee4ec&gt;] (get_sb_bdev+0=
x0/0x170) from [&lt;c05d2f44&gt;] (xfs_fs_get_sb+0x24/0x30)<br>[&lt;c05d2f2=
0&gt;] (xfs_fs_get_sb+0x0/0x30) from [&lt;c04ed138&gt;] (vfs_kern_mount+0x6=
4/0x114)<br>
[&lt;c04ed0d4&gt;] (vfs_kern_mount+0x0/0x114) from [&lt;c04ed244&gt;] (do_k=
ern_mount+0x3c/0xe0)<br>=A0r8:00008000 r7:c31db500 r6:c32eb000 r5:c365bf20 =
r4:c07f6a6c<br>[&lt;c04ed208&gt;] (do_kern_mount+0x0/0xe0) from [&lt;c05065=
94&gt;] (do_mount+0x700/0x77c)<br>
=A0r8:00008000 r7:00000000 r6:00000000 r5:c31db500 r4:00000020<br>r3:c32eb0=
00<br>[&lt;c0505e94&gt;] (do_mount+0x0/0x77c) from [&lt;c050669c&gt;] (sys_=
mount+0x8c/0xcc)<br>[&lt;c0506610&gt;] (sys_mount+0x0/0xcc) from [&lt;c0444=
9a0&gt;] (ret_fast_syscall+0x0/0x30)<br>
=A0r7:00000015 r6:001854e0 r5:bee32780 r4:00186028<br>XFS: log mount/recove=
ry failed: error 117<br>XFS: log mount failed<br>mount: mounting /dev/sda2 =
on /mnt/ failed: Structure needs cleaning</div>
<div>=A0</div>
<div>=A0</div>
<div>Tried to us xfs_repair on the device</div>
<div>#&gt; xfs_repair /dev/sda2<br>Phase 1 - find and verify superblock...<=
br>Phase 2 - using internal log<br>=A0=A0=A0=A0=A0=A0=A0 - zero log...<br>E=
RROR: The filesystem has valuable metadata changes in a log which needs to<=
br>be replayed.=A0 Mount the filesystem to replay the log, and unmount it b=
efore<br>
re-running xfs_repair.=A0 If you are unable to mount the filesystem, then u=
se<br>the -L option to destroy the log and attempt a repair.<br>Note that d=
estroying the log may cause corruption -- please attempt a mount<br>of the =
filesystem before doing this.</div>

<div>=A0</div>
<div>#&gt; xfs_repair -L /dev/sda2<br>Phase 1 - find and verify superblock.=
..<br>Phase 2 - using internal log<br>=A0=A0=A0=A0=A0=A0=A0 - zero log...<b=
r>ALERT: The filesystem has valuable metadata changes in a log which is bei=
ng<br>destroyed because the -L option was used.<br>
=A0=A0=A0=A0=A0=A0=A0 - scan filesystem freespace and inode maps...<br>=A0=
=A0=A0=A0=A0=A0=A0 - found root inode chunk<br>Phase 3 - for each AG...<br>=
=A0=A0=A0=A0=A0=A0=A0 - scan and clear agi unlinked lists...<br>=A0=A0=A0=
=A0=A0=A0=A0 - process known inodes and perform inode discovery...<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 0<br>bad hash ordering in block 8388617 of=
 directory inode 128<br>imap claims a free inode 200248 is in use, correcti=
ng imap and clearing inode<br>cleared inode 200248<br>=A0=A0=A0=A0=A0=A0=A0=
 - agno =3D 1<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 2<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 3<br>=A0=A0=A0=A0=A0=A0=A0 - process newly=
 discovered inodes...<br>Phase 4 - check for duplicate blocks...<br>=A0=A0=
=A0=A0=A0=A0=A0 - setting up duplicate extent list...<br>=A0=A0=A0=A0=A0=A0=
=A0 - check for inodes claiming duplicate blocks...<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 0<br>entry &quot;setupfile.3126&quot; at b=
lock 22 offset 2576 in directory inode 128 references free inode 200248<br>=
=A0=A0=A0=A0=A0=A0=A0 clearing inode number in entry at offset 2576...<br>=
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 1<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 2<br=
>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 3<br>Phase 5 - rebuild AG headers and tree=
s...<br>=A0=A0=A0=A0=A0=A0=A0 - reset superblock...<br>Phase 6 - check inod=
e connectivity...<br>=A0=A0=A0=A0=A0=A0=A0 - resetting contents of realtime=
 bitmap and summary inodes<br>=A0=A0=A0=A0=A0=A0=A0 - traversing filesystem=
 ...<br>
rebuilding directory inode 128<br>=A0=A0=A0=A0=A0=A0=A0 - traversal finishe=
d ...<br>=A0=A0=A0=A0=A0=A0=A0 - moving disconnected inodes to lost+found .=
..<br>Phase 7 - verify and correct link counts...<br>done</div>
<div>=A0</div>
<div>Please let me know if there is anything i have missed. Also, if it is =
good enough to 2.6.35.9 for product? </div>
<div>=A0</div>
<div>Thanks &amp; Regards,</div>
<div>Amit Sahrawat</div>
<div>=A0</div>
<div>=A0</div>

--0016363b8b7091e003049a401190--


--===============8887799676077751665==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8887799676077751665==--
