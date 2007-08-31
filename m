Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Aug 2007 03:59:22 -0700 (PDT)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7VAxE4p027188
	for <linux-xfs@oss.sgi.com>; Fri, 31 Aug 2007 03:59:19 -0700
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1IR4DU-0003ux-VX
	for linux-xfs@oss.sgi.com; Fri, 31 Aug 2007 12:59:08 +0200
Received: from 82-46-103-219.cable.ubr05.azte.blueyonder.co.uk ([82.46.103.219])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Fri, 31 Aug 2007 12:59:08 +0200
Received: from byron.bbradley by 82-46-103-219.cable.ubr05.azte.blueyonder.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Fri, 31 Aug 2007 12:59:08 +0200
From: Byron Bradley <byron.bbradley@gmail.com>
Subject: XFS Fails Quality Assurance Tests on ARM
Date: Fri, 31 Aug 2007 10:58:52 +0000 (UTC)
Message-ID: <fb8s9c$t02$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

XFS Fails Quality Assurance Tests on ARM

[to: linux-xfs]
[cc: lkml]

Hello,

I am one of the developers at http://linkstationwiki.net , we are trying to
port linux (2.6.22) to the LinkStation Pro. This has an ARM926EJ chip and
we are having problems with XFS (the default filesystem for these devices).

While we only have a few users who have reported problems with XFS in real
life, the quality assurance tests consistently fail and leave the
partitions in an inconsistent and irreparable state. With debug mode
enabled the following assertion fails during test 001:

Assertion failed: (char *)sfep - (char *)sfp == dp->i_d.di_size, file:
fs/xfs/xfs_dir2_sf.c, line: 647 kernel BUG at fs/xfs/support/debug.c:82!
Unable to handle kernel NULL pointer dereference at virtual address
00000000 pgd = c5888000
[00000000] *pgd=06254031, *pte=00000000, *ppte=00000000 Internal error:
Oops: 817 [#1]
Modules linked in: nfs nfsd exportfs lockd nfs_acl sunrpc reiserfs fuse
CPU: 0    Not tainted  (2.6.22 #7)
PC is at __bug+0x20/0x2c
LR is at 0x60000013
pc : [<c002937c>]    lr : [<60000013>]    psr: 60000013 sp : c678fba0  ip
: c678fad0  fp : c678fbac r10: c606fd40  r9 : c01a6aac  r8 : 00000008 r7 :
c606fda8  r6 : 00000000  r5 : 00000030  r4 : c606fdae r3 : 00000000  r2 :
00000000  r1 : 0000223a  r0 : 0000002c Flags: nZCv  IRQs on  FIQs on  Mode
SVC_32  Segment user Control: a005317f  Table: 05888000  DAC: 00000015
Process mkdir (pid: 1522, stack limit = 0xc678e260) Stack: (0xc678fba0 to
0xc6790000)
fba0: c678fbbc c678fbb0 c01ab70c c002936c c678fbe4 c678fbc0 c015d6e0
c01ab6ec fbc0: 00000000 c63b8290 c606fd40 00000000 00000008 c678fd04
c678fc1c c678fbe8 fbe0: c015d760 c015d5f4 c00c48a8 c678fc20 c678fc0c
00000000 c63b8290 c606fd40 fc00: 00000000 00000008 c01a6aac c678fd04
c678fca4 c678fc20 c015205c c015d748 fc20: c63b8290 00000004 c678ff00
00000008 c160e498 062d19b9 00000000 00000000 fc40: c606fd40 00000000
00000000 00000000 00000000 00000000 00000008 00000000 fc60: 000005f2
c018f22c 00000000 00000000 00000000 00000000 01000000 00000000 fc80:
00000000 00000000 c606fd60 c63b8238 c606fd40 c678fcf8 c678fce4 c678fca8
fca0: c018f244 c0151f48 c678fcf8 c016bec0 00000000 00000008 00460000
00000000 fcc0: 00000008 00460000 00000000 c606fd60 c606fd40 c63b8238
c678fd34 c678fce8 fce0: c01953b4 c018f1e4 c678fd04 c678fcf8 00000010
c678fd44 c678e000 000200d2 fd00: c678fd2c c678fd10 c678fd2c c63b8238
00000000 c61a2458 c678fdb0 c678fda4 fd20: c1714aa0 c6070e40 c678fd5c
c678fd38 c01a6aac c019530c 00000000 00000000 fd40: c61a2458 c678fdb0
c678fec0 c63b8238 c678fd94 c678fd60 c009639c c01a6a68 fd60: c678e000
c6070eac c678fdcc c678fda4 c5e7700e 00000107 c678fec0 c5e77000 fd80:
c678e000 00000000 c678fde4 c678fd98 c00981c0 c0096230 c678e000 00000001
fda0: c678fdc4 00c27168 00000004 c5e7700a c1714aa0 c61a2458 c678fdf4
c678fec0 fdc0: c17141a0 c678fec0 c78ba598 c5e77000 c678e000 c678fde8
c678fe5c c678fde8 fde0: c0098914 c00979a0 c78ba598 c17141a0 00000017
4013c000 c678ff3c 00000001 fe00: 00000001 00000000 c678ffb0 4013c058
0c678ffac c678ff00 fe20: c0024230 c002c6b0 c5889000 c5a64b64 c678ff10
00000002 c678fec0 c0552200 fe40: c5e77000 00000001 c0025794 009000c3
c678fe6c c678fe60 c0098a18 c0098894 fe60: c678fe9c c678fe70 c0098c40
c0098a04 c678fe9c c678fe80 c5e77000 00000001 fe80: c678fec0 ffffff9c
c0025794 009000c3 c678febc c678fea0 c0099748 c0098b90 fea0: bebde6c4
c678ff40 c678fec0 000000c3 c678ff2c c678fec0 c0092184 c0099714 fec0:
c61a2458 c1714aa0 00000017 4013c000 c678ff3c 00000001 00000001 00000000
fee0: c678ffb0 4013c058 00000000 40149000 c678ffac c678ff00 c0024230
c002c6b0 ff00: c5889000 c5a64b64 c678ff10 00000002 00000000 bebde6c4
c678ff40 bebde911 ff20: c678ff3c c678ff30 c0092274 c0092170 c678ffa4
c678ff40 c002b270 c0092268 ff40: 40017000 c0025794 c678ff64 00000000
00000000 400d9000 40016000 ffffffff ff60: 00000001 00001fdc 00000001
0001520c 00000000 40149000 c678ff9c c678ff88 ff80: c002c9c0 c002c6b0
ffffffff ffffffff 00000001 00000000 00000000 c678ffa8 ffa0: c0024fa0
c002b260 00000001 00000000 bebde911 bebde6c4 bebde6c4 ffffffff ffc0:
00000001 00000000 bebde911 bebde7a4 00000003 00000001 000001ed bebde754
ffe0: 400e1300 bebde638 0000984c 400e1310 60000010 bebde911 00000000
00000000 Backtrace:
[<c002935c>] (__bug+0x0/0x2c) from [<c01ab70c>] (assfail+0x30/0x38)
[<c01ab6dc>] (assfail+0x0/0x38) from [<c015d6e0>]
(xfs_dir2_sf_check+0xfc/0x154) [<c015d5e4>] (xfs_dir2_sf_check+0x0/0x154)
from [<c015d760>] (xfs_dir2_sf_lookup+0x28/0x360) [<c015d738>]
(xfs_dir2_sf_lookup+0x0/0x360) from [<c015205c>]
(xfs_dir_lookup+0x124/0x170) [<c0151f38>] (xfs_dir_lookup+0x0/0x170) from
[<c018f244>] (xfs_dir_lookup_int+0x70/0x134)
 r7:c678fcf8 r6:c606fd40 r5:c63b8238 r4:c606fd60
[<c018f1d4>] (xfs_dir_lookup_int+0x0/0x134) from [<c01953b4>]
(xfs_lookup+0xb8/0x160) [<c01952fc>] (xfs_lookup+0x0/0x160) from
[<c01a6aac>] (xfs_vn_lookup+0x54/0x98) [<c01a6a58>]
(xfs_vn_lookup+0x0/0x98) from [<c009639c>] (do_lookup+0x17c/0x1b8)
 r5:c63b8238 r4:c678fec0
[<c0096220>] (do_lookup+0x0/0x1b8) from [<c00981c0>]
(__link_path_walk+0x830/0xef4) [<c0097990>] (__link_path_walk+0x0/0xef4)
from [<c0098914>] (link_path_walk+0x90/0x170) [<c0098884>]
(link_path_walk+0x0/0x170) from [<c0098a18>] (path_walk+0x24/0x28)
[<c00989f4>] (path_walk+0x0/0x28) from [<c0098c40>]
(do_path_lookup+0xc0/0x278) [<c0098b80>] (do_path_lookup+0x0/0x278) from
[<c0099748>] (__user_walk_fd+0x44/0x64) [<c0099704>]
(__user_walk_fd+0x0/0x64) from [<c0092184>] (vfs_stat_fd+0x24/0x54)
 r7:000000c3 r6:c678fec0 r5:c678ff40 r4:bebde6c4
[<c0092160>] (vfs_stat_fd+0x0/0x54) from [<c0092274>] (vfs_stat+0x1c/0x20)
 r6:bebde911 r5:c678ff40 r4:bebde6c4
[<c0092258>] (vfs_stat+0x0/0x20) from [<c002b270>]
(sys_oabi_stat64+0x20/0x3c) [<c002b250>] (sys_oabi_stat64+0x0/0x3c) from
[<c0024fa0>] (ret_fast_syscall+0x0/0x2c)
 r5:00000000 r4:00000001
Code: e1a01000 e59f000c eb008188 e3a03000 (e5833000)

esandeen in #xfs pointed me towards this bug,
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=414932 , and suggested
that I compare the size and offset of stucts between x86 and ARM. After
modifying over 40 structs to give them the same offsets as x86 the problem
is still present. I have already tried the patch by Greg Ungerer from 2004
but again this didn't change anything. I also tried compiling the kernel
and userspace tools with an 8-bit structure size boundary but it made no
difference.

Further details of my attempts are at
http://www.linkstationwiki.net/index.php/Buffalo_ARM9_Kernel_Port#XFS_Arm_Issues
. I will keep this up to date until we find a solution.

Anybody got any ideas of how we fix this?

Thanks,

-- 
Byron Bradley
