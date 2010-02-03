Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o132IN7B204444 for <xfs@oss.sgi.com>; Tue, 2 Feb 2010 20:18:23 -0600
Received: from mail-ew0-f227.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A64F1371EE1
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2010 18:19:30 -0800 (PST)
Received: from mail-ew0-f227.google.com (mail-ew0-f227.google.com
	[209.85.219.227]) by cuda.sgi.com with ESMTP id
	CneUJEdzhJrdsKXf for <xfs@oss.sgi.com>;
	Tue, 02 Feb 2010 18:19:30 -0800 (PST)
Received: by ewy27 with SMTP id 27so827138ewy.18
	for <xfs@oss.sgi.com>; Tue, 02 Feb 2010 18:19:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100202112300.GA23809@infradead.org>
References: <13bb8ce11002011924h611099feh4955eedcc6e588a6@mail.gmail.com>
	<20100202112300.GA23809@infradead.org>
Date: Tue, 2 Feb 2010 20:19:29 -0600
Message-ID: <13bb8ce11002021819l7e17dac4n5f58a9887a16fae2@mail.gmail.com>
Subject: Re: State of XFS on ARM
From: Daniel Goller <morfic@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Thanks for the many replys, it also made me realize how basic and
general the question was, without giving much details about the
hardware.

I see my "can't mount a xfs partition after successful unmounting
without needing to clear the log" in 2.6.32, 2.6.33-rc2 and now
2.6.33-rc6.

The arm device:

Processor       : Feroceon 88FR131 rev 1 (v5l)
BogoMIPS        : 1192.75
Features        : swp half thumb fastmult edsp
CPU implementer : 0x56
CPU architecture: 5TE
CPU variant     : 0x2
CPU part        : 0x131
CPU revision    : 1

Hardware        : Marvell SheevaPlug Reference Board
Revision        : 0000
Serial          : 0000000000000000


Typically i just can't mount without a xfs_repair -L  which seems to
be all i need to get it back and lose no data in the process.

In 2.6.33-rc6 i had it for the first time do this: (which basically
stopped the boot process cold as it would not go past this point)
keeping this partition from being mounted at boot then allowed me to
record the following when manually mounting it)


* Mounting local filesystems...
Internal error: Oops: 5 [#1]
last sysfs file: /sys/kernel/uevent_seqnum
Modules linked in:
CPU: 0    Not tainted  (2.6.33-rc6 #1)
PC is at xlog_recover_process_data+0x1c4/0x304
LR is at xlog_recover_unmount_trans+0x10/0x1c
pc : []    lr : []    psr: 20000013
sp : df091c78  ip : 0000000a  fp : 00000001
r10: df0794d0  r9 : df091d14  r8 : e0ffea00
r7 : df091d04  r6 : e0ffe034  r5 : 00000010  r4 : 02e00a34
r3 : 00000001  r2 : c0563190  r1 : c05631b8  r0 : 00000000
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0005317f  Table: 1f314000  DAC: 00000015
Process mount (pid: 857, stack limit =3D 0xdf090270)
Stack: (0xdf091c78 to 0xdf092000)
1c60:                                                       00000007 df2910=
00
1c80: 00000005 df3329c0 00000000 00000001 00000005 df3329c0 df291000 000000=
05
1ca0: 00000001 00000000 df332cc0 0000000f 00000000 c0206eb0 00000001 df332c=
c0
1cc0: df091d44 ffffffff c0563174 c003d13c df091d44 c058dddc c0563174 000000=
02
1ce0: 00000002 00000000 00000000 00000000 df332cc0 c003d66c 00000028 df332c=
00
1d00: c04f0121 00000000 00000000 00000000 00000000 df0ade00 00000000 000000=
00
1d20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
1d40: 00000000 e0ffe000 00000000 df3329c0 00000000 00000028 00000000 000000=
06
1d60: 00000000 a3d7b000 00000000 c02074d8 00000006 00000000 00000001 c04277=
58
1d80: 60000013 df3329c0 00000000 00000006 00000000 00408100 00000000 c02075=
34
1da0: 00000006 00000000 00000000 df3329c0 00000000 00000006 00000000 004081=
00
1dc0: 00000000 c0208be4 00000006 00000000 00000006 00000000 00000028 000000=
00
1de0: df0fd800 000001c0 00000000 c0202b58 00020000 df0fd800 c0220a64 df0fd8=
00
1e00: c0220a64 073904d0 00000000 073904cc 00000000 c020ac34 00020000 000002=
d0
1e20: 00000001 00000000 51eb851f c02154fc 00000000 00000058 df296000 c01f1b=
1c
1e40: 0000000a 00000058 df189120 c01f1b1c 0000000a df0fda9c df296000 c01f1b=
1c
1e60: 00000000 df0fd800 df218a00 00000000 df28a000 00000000 00000000 df28a0=
00
1e80: 00000000 c0220a64 df218a00 00000000 df6b8340 00000003 df6b839c 000000=
00
1ea0: df218a00 c00991fc 33616473 df096f00 df096da0 000000d0 df096da0 df096f=
40
1ec0: 0000000a c007cdd8 df296d00 df296d00 c056dfc4 df096da0 df28a000 000000=
00
1ee0: df28a000 c021ed60 c02208e8 df296d00 00000000 c00981fc df296d00 c00ab3=
04
1f00: c056dfc4 df096d60 df28a000 df096da0 00000000 c00982d0 00000000 000000=
30
1f20: df091f48 df096da0 df096d60 c00addc4 00000a18 00200800 df28a000 df0900=
00
1f40: 00000000 0001e560 dfbebe00 df705d80 c007186c df241000 0001e560 002008=
00
1f60: 00000000 c002b044 df090000 00000000 0001e560 c00ae3f4 df28a000 c00476=
c8
1f80: 00000000 df28a000 df096da0 df096d60 00000000 0001ea18 00200800 0001e5=
70
1fa0: 00000015 c002aec0 0001ea18 00200800 0001e560 0001e570 0001e988 002008=
00
1fc0: 0001ea18 00200800 0001e570 00000015 0001c444 00000000 00000000 0001e5=
60
1fe0: 00200800 befff5cc 0000b0f4 40115384 60000010 0001e560 00000000 000000=
00
[] (xlog_recover_process_data+0x1c4/0x304) from []
(xlog_do_recovery_pass+0x1b0/0x794)
[] (xlog_do_recovery_pass+0x1b0/0x794) from [] (xlog_do_log_recovery+0x44/0=
x88)
[] (xlog_do_log_recovery+0x44/0x88) from [] (xlog_do_recover+0x18/0x124)
[] (xlog_do_recover+0x18/0x124) from [] (xlog_recover+0x7c/0xc4)
[] (xlog_recover+0x7c/0xc4) from [] (xfs_log_mount+0x154/0x18c)
[] (xfs_log_mount+0x154/0x18c) from [] (xfs_mountfs+0x34c/0x670)
[] (xfs_mountfs+0x34c/0x670) from [] (xfs_fs_fill_super+0x17c/0x2c0)
[] (xfs_fs_fill_super+0x17c/0x2c0) from [] (get_sb_bdev+0x138/0x170)
[] (get_sb_bdev+0x138/0x170) from [] (xfs_fs_get_sb+0x1c/0x28)
[] (xfs_fs_get_sb+0x1c/0x28) from [] (vfs_kern_mount+0x50/0xe0)
[] (vfs_kern_mount+0x50/0xe0) from [] (do_kern_mount+0x34/0xdc)
[] (do_kern_mount+0x34/0xdc) from [] (do_mount+0x154/0x700)
[] (do_mount+0x154/0x700) from [] (sys_mount+0x84/0xc4)
[] (sys_mount+0x84/0xc4) from [] (ret_fast_syscall+0x0/0x28)
Code: 93a03000 82033001 e3530000 0a000048 (e5d43008)
---[ end trace b80cd4d01963a09f ]---
/etc/init.d/localmount: line 15:   857 Segmentation fault      mount
-at "$types"

it seems to operate fine since running a xfs_repair -L  on it from the
x86_64 laptop (It is a disk in a usb enclosure, which makes the moving
of the drive to clear the log rather easy)

> The git tree with the current versions of the patches to fix this is
> here:
>
> =A0 =A0 =A0 =A0http://git.kernel.org/?p=3Dlinux/kernel/git/jejb/xfs-vipt/=
.git;a=3Dsummary
>
>

I will probably not get a chance to try pulling this from git before
the weekend, if the Sheevaplug however the type of arm machine you
were referring to (i honestly never looked at its cache), i would be
interested in trying the fix and (hopefully) stick to xfs for this
partition.

Thanks,

Daniel Goller

Let me know if there is further information you would like to look at
for this issue.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
