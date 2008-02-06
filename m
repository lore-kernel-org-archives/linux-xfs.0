Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Feb 2008 06:08:58 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m16E8mJE025113
	for <xfs@oss.sgi.com>; Wed, 6 Feb 2008 06:08:50 -0800
Received: from il.marvell.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1047DA3AE1
	for <xfs@oss.sgi.com>; Wed,  6 Feb 2008 06:09:08 -0800 (PST)
Received: from il.marvell.com (galiil.marvell.com [199.203.130.254]) by cuda.sgi.com with ESMTP id CRHkj7jmpYpgsyy0 for <xfs@oss.sgi.com>; Wed, 06 Feb 2008 06:09:08 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: NFSD on XFS with RT subvolume
Date: Wed, 6 Feb 2008 16:08:58 +0200
Message-ID: <B9FFC3F97441D04093A504CEA31B7C4102220ACE@MSILEXCH01.marvell.com>
In-Reply-To: <1202076343.9463.465.camel@edge.scott.net.au>
References: <B9FFC3F97441D04093A504CEA31B7C41021A627E@MSILEXCH01.marvell.com> <1202076343.9463.465.camel@edge.scott.net.au>
From: "Rabeeh Khoury" <rabeeh@marvell.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, Lennert Buijtenhek <buytenh@marvell.com>

> >
> > Exporting an XFS volume with kernel NFSD when real-time subvolume is
> > enabled hangs the kernel.
> >
> > I'm using vanilla LK 2.6.22.7; first I create the XFS volume with
two
> > partitions of 20GB each with extent size of 1MB; then I create a
> > subdirectory in the volume and mark it (using xfs_io util) as it
belongs
> > to the rt subvolume with inheritance flag.
> >
> > After mounting that volume through NFSv3 / UDP; and trying a 'dd
> > if=/dev/zero of=/mnt/rt/test bs=1M count=1000' the machine running
NFSD
> > hangs infinitely.
> 
> Did you manage to get a stack trace, OOC?  No reason why it shouldn't
> work AFAIK.

I didn't mention that I'm using ARM EABI machine for that; but the same
scenario happened on Ubuntu Gutsy 7.10.
The serial console stops responding, but getting Sysrq with showPc
function working I'v got some stack traces (Look for #stack-trace
below).

I'm running Fedora-8 on the ARM machine using xfsprogs-2.9.4-4.f8 RPM.
The output of formatting /dev/sda5 and /dev/sda6 as the rt-subvolume is
the following, but this time /dev/sda5 is 2GByte and /dev/sda6 is
20GByte (look for #mkfs.xfs).

Another note is that sometimes I'm getting an error message that XFS is
trying to access LBA beyond the volume.

Maybe you can suggest few tests that I can perform to figure out what's
the root cause?

--------------- #mkfs.xfs ----------------------
meta-data=/dev/sda5              isize=256    agcount=8, agsize=61246
blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=489968, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=2560, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =/dev/sda6              extsz=1048576 blocks=4885760,
rtextents=19085



-------------- #stack-trace ---------------------
-bash-3.2# SysRq : Show Regs

Pid: 1208, comm:                 nfsd
CPU: 0    Not tainted  (2.6.22.7 #7)
PC is at xfs_iext_get_ext+0x60/0x88
LR is at 0x1ff02
pc : [<c02349b4>]    lr : [<0001ff02>]    psr: 80000013
sp : c5cb3a68  ip : 000000a8  fp : c5cb3a7c
r10: c5cb3c60  r9 : c5cb3d0c  r8 : c5984060
r7 : 0001ffab  r6 : 0001ffac  r5 : c5cb3c60  r4 : 000fffff
r3 : c5cb3a6c  r2 : 0001ffac  r1 : 000000aa  r0 : c49d1800
Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  Segment user
Control: a005317f  Table: 07b38000  DAC: 00000015 [<c00f1b3c>]
(show_regs+0x0/0x50) from [<c02c8278>] (sysrq_handle_showregs+0x20/0x28)
 r4:c03e5654
[<c02c8258>] (sysrq_handle_showregs+0x0/0x28) from [<c02c8110>]
(__handle_sysrq+0xa4/0x148) [<c02c806c>] (__handle_sysrq+0x0/0x148) from
[<c02c841c>] (handle_sysrq+0x34/0x40) [<c02c83e8>]
(handle_sysrq+0x0/0x40) from [<c02ccd40>] (receive_chars+0x17c/0x2c4)
[<c02ccbc4>] (receive_chars+0x0/0x2c4) from [<c02cdec8>]
(serial8250_interrupt+0x74/0x13c) [<c02cde54>]
(serial8250_interrupt+0x0/0x13c) from [<c013b804>]
(handle_IRQ_event+0x44/0x84) [<c013b7c0>] (handle_IRQ_event+0x0/0x84)
from [<c013d080>] (handle_level_irq+0xe0/0xfc)  r7:0001ffab r6:00000000
r5:00000003 r4:c03d8998 [<c013cfa0>] (handle_level_irq+0x0/0xfc) from
[<c0021048>] (asm_do_IRQ+0x48/0x64)
 r5:c03d8998 r4:00000003
[<c0021000>] (asm_do_IRQ+0x0/0x64) from [<c003bef0>]
(__irq_svc+0x30/0x100) Exception stack(0xc5cb3a20 to 0xc5cb3a68)
3a20: c49d1800 000000aa 0001ffac c5cb3a6c 000fffff c5cb3c60 0001ffac
0001ffab
3a40: c5984060 c5cb3d0c c5cb3c60 c5cb3a7c 000000a8 c5cb3a68 0001ff02
c02349b4
3a60: 80000013 ffffffff
 r6:00000002 r5:f1020000 r4:ffffffff
[<c0234954>] (xfs_iext_get_ext+0x0/0x88) from [<c0212c20>]
(xfs_bmap_add_extent_hole_delay+0x54/0x608)
[<c0212bcc>] (xfs_bmap_add_extent_hole_delay+0x0/0x608) from
[<c0214f8c>] (xfs_bmap_add_extent+0x1bc/0x4f8) [<c0214dd0>]
(xfs_bmap_add_extent+0x0/0x4f8) from [<c0215ac4>]
(xfs_bunmapi+0x7fc/0xf38) [<c02152c8>] (xfs_bunmapi+0x0/0xf38) from
[<c0236e9c>] (xfs_itruncate_finish+0x1e4/0x368)
[<c0236cb8>] (xfs_itruncate_finish+0x0/0x368) from [<c025392c>]
(xfs_setattr+0x8b0/0xde4) [<c025307c>] (xfs_setattr+0x0/0xde4) from
[<c025ffd8>] (xfs_vn_setattr+0x16c/0x18c) [<c025fe6c>]
(xfs_vn_setattr+0x0/0x18c) from [<c016b5bc>] (notify_change+0x124/0x244)
 r7:c5b26758 r6:00000068 r5:c5985078 r4:c7d9b8f0 [<c016b498>]
(notify_change+0x0/0x244) from [<c01c9180>] (nfsd_setattr+0x368/0x50c)
[<c01c8e18>] (nfsd_setattr+0x0/0x50c) from [<c01cfdc4>]
(nfsd3_proc_setattr+0xa0/0xc4) [<c01cfd24>]
(nfsd3_proc_setattr+0x0/0xc4) from [<c01c452c>]
(nfsd_dispatch+0xd8/0x1e0)  r7:c2b3a000 r6:c03db9a4 r5:00000018
r4:c62ad000 [<c01c4454>] (nfsd_dispatch+0x0/0x1e0) from [<c03b2ecc>]
(svc_process+0x448/0x7e8)
 r8:c03db944 r7:00000014 r6:c62ad000 r5:c2b3a000 r4:c03db9a4
[<c03b2a84>] (svc_process+0x0/0x7e8) from [<c01c4ba4>]
(nfsd+0x17c/0x2d4) [<c01c4a28>] (nfsd+0x0/0x2d4) from [<c011dee4>]
(do_exit+0x0/0x7c4) SysRq : Show Regs

Pid: 1208, comm:                 nfsd
CPU: 0    Not tainted  (2.6.22.7 #7)
PC is at xfs_trans_dup+0xd0/0xf4
LR is at 0xc60e16b8
pc : [<c024b788>]    lr : [<c60e16b8>]    psr: 60000013
sp : c5cb3ca8  ip : 00000002  fp : c5cb3cc4
r10: c5cb3dd4  r9 : c5cb3d24  r8 : 00000000
r7 : c21cf098  r6 : c21cf310  r5 : 00000000  r4 : 00000000
r3 : 60000093  r2 : c6017000  r1 : 60000013  r0 : 00000004
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  Segment user
Control: a005317f  Table: 07b38000  DAC: 00000015 [<c00f1b3c>]
(show_regs+0x0/0x50) from [<c02c8278>] (sysrq_handle_showregs+0x20/0x28)
 r4:c03e5654
[<c02c8258>] (sysrq_handle_showregs+0x0/0x28) from [<c02c8110>]
(__handle_sysrq+0xa4/0x148) [<c02c806c>] (__handle_sysrq+0x0/0x148) from
[<c02c841c>] (handle_sysrq+0x34/0x40) [<c02c83e8>]
(handle_sysrq+0x0/0x40) from [<c02ccd40>] (receive_chars+0x17c/0x2c4)
[<c02ccbc4>] (receive_chars+0x0/0x2c4) from [<c02cdec8>]
(serial8250_interrupt+0x74/0x13c) [<c02cde54>]
(serial8250_interrupt+0x0/0x13c) from [<c013b804>]
(handle_IRQ_event+0x44/0x84) [<c013b7c0>] (handle_IRQ_event+0x0/0x84)
from [<c013d080>] (handle_level_irq+0xe0/0xfc)
 r7:c21cf098 r6:00000000 r5:00000003 r4:c03d8998 [<c013cfa0>]
(handle_level_irq+0x0/0xfc) from [<c0021048>] (asm_do_IRQ+0x48/0x64)
 r5:c03d8998 r4:00000003
[<c0021000>] (asm_do_IRQ+0x0/0x64) from [<c003bef0>]
(__irq_svc+0x30/0x100) Exception stack(0xc5cb3c60 to 0xc5cb3ca8)
3c60: 00000004 60000013 c6017000 60000093 00000000 00000000 c21cf310
c21cf098
3c80: 00000000 c5cb3d24 c5cb3dd4 c5cb3cc4 00000002 c5cb3ca8 c60e16b8
c024b788
3ca0: 60000013 ffffffff
 r6:00000002 r5:f1020000 r4:ffffffff
[<c024b6b8>] (xfs_trans_dup+0x0/0xf4) from [<c0236f44>]
(xfs_itruncate_finish+0x28c/0x368)
 r7:00000000 r6:00000000 r5:c5984060 r4:c21cf310 [<c0236cb8>]
(xfs_itruncate_finish+0x0/0x368) from [<c025392c>]
(xfs_setattr+0x8b0/0xde4) [<c025307c>] (xfs_setattr+0x0/0xde4) from
[<c025ffd8>] (xfs_vn_setattr+0x16c/0x18c) [<c025fe6c>]
(xfs_vn_setattr+0x0/0x18c) from [<c016b5bc>] (notify_change+0x124/0x244)
 r7:c5b26758 r6:00000068 r5:c5985078 r4:c7d9b8f0 [<c016b498>]
(notify_change+0x0/0x244) from [<c01c9180>] (nfsd_setattr+0x368/0x50c)
[<c01c8e18>] (nfsd_setattr+0x0/0x50c) from [<c01cfdc4>]
(nfsd3_proc_setattr+0xa0/0xc4) [<c01cfd24>]
(nfsd3_proc_setattr+0x0/0xc4) from [<c01c452c>]
(nfsd_dispatch+0xd8/0x1e0)  r7:c2b3a000 r6:c03db9a4 r5:00000018
r4:c62ad000 [<c01c4454>] (nfsd_dispatch+0x0/0x1e0) from [<c03b2ecc>]
(svc_process+0x448/0x7e8)
 r8:c03db944 r7:00000014 r6:c62ad000 r5:c2b3a000 r4:c03db9a4
[<c03b2a84>] (svc_process+0x0/0x7e8) from [<c01c4ba4>]
(nfsd+0x17c/0x2d4) [<c01c4a28>] (nfsd+0x0/0x2d4) from [<c011dee4>]
(do_exit+0x0/0x7c4) SysRq : Show Regs

Pid: 1208, comm:                 nfsd
CPU: 0    Not tainted  (2.6.22.7 #7)
PC is at xfs_bunmapi+0xbfc/0xf38
LR is at 0x2
pc : [<c0215ec4>]    lr : [<00000002>]    psr: 60000013
sp : c5cb3bc8  ip : c5cb3bc8  fp : c5cb3cc4
r10: 00000000  r9 : c59840b0  r8 : 00000000
r7 : 00000bee  r6 : 00000000  r5 : 00000000  r4 : 00000002
r3 : 00000000  r2 : 00000000  r1 : 00053566  r0 : 00000000
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  Segment user
Control: a005317f  Table: 07b38000  DAC: 00000015 [<c00f1b3c>]
(show_regs+0x0/0x50) from [<c02c8278>] (sysrq_handle_showregs+0x20/0x28)
 r4:c03e5654
[<c02c8258>] (sysrq_handle_showregs+0x0/0x28) from [<c02c8110>]
(__handle_sysrq+0xa4/0x148) [<c02c806c>] (__handle_sysrq+0x0/0x148) from
[<c02c841c>] (handle_sysrq+0x34/0x40) [<c02c83e8>]
(handle_sysrq+0x0/0x40) from [<c02ccd40>] (receive_chars+0x17c/0x2c4)
[<c02ccbc4>] (receive_chars+0x0/0x2c4) from [<c02cdec8>]
(serial8250_interrupt+0x74/0x13c) [<c02cde54>]
(serial8250_interrupt+0x0/0x13c) from [<c013b804>]
(handle_IRQ_event+0x44/0x84) [<c013b7c0>] (handle_IRQ_event+0x0/0x84)
from [<c013d080>] (handle_level_irq+0xe0/0xfc)  r7:00000bee r6:00000000
r5:00000003 r4:c03d8998 [<c013cfa0>] (handle_level_irq+0x0/0xfc) from
[<c0021048>] (asm_do_IRQ+0x48/0x64)
 r5:c03d8998 r4:00000003
[<c0021000>] (asm_do_IRQ+0x0/0x64) from [<c003bef0>]
(__irq_svc+0x30/0x100) Exception stack(0xc5cb3b80 to 0xc5cb3bc8)
3b80: 00000000 00053566 00000000 00000000 00000002 00000000 00000000
00000bee
3ba0: 00000000 c59840b0 00000000 c5cb3cc4 c5cb3bc8 c5cb3bc8 00000002
c0215ec4
3bc0: 60000013 ffffffff
 r6:00000002 r5:f1020000 r4:ffffffff
[<c02152c8>] (xfs_bunmapi+0x0/0xf38) from [<c0236e9c>]
(xfs_itruncate_finish+0x1e4/0x368)
[<c0236cb8>] (xfs_itruncate_finish+0x0/0x368) from [<c025392c>]
(xfs_setattr+0x8b0/0xde4) [<c025307c>] (xfs_setattr+0x0/0xde4) from
[<c025ffd8>] (xfs_vn_setattr+0x16c/0x18c) [<c025fe6c>]
(xfs_vn_setattr+0x0/0x18c) from [<c016b5bc>] (notify_change+0x124/0x244)
 r7:c5b26758 r6:00000068 r5:c5985078 r4:c7d9b8f0 [<c016b498>]
(notify_change+0x0/0x244) from [<c01c9180>] (nfsd_setattr+0x368/0x50c)
[<c01c8e18>] (nfsd_setattr+0x0/0x50c) from [<c01cfdc4>]
(nfsd3_proc_setattr+0xa0/0xc4) [<c01cfd24>]
(nfsd3_proc_setattr+0x0/0xc4) from [<c01c452c>]
(nfsd_dispatch+0xd8/0x1e0)  r7:c2b3a000 r6:c03db9a4 r5:00000018
r4:c62ad000 [<c01c4454>] (nfsd_dispatch+0x0/0x1e0) from [<c03b2ecc>]
(svc_process+0x448/0x7e8)
 r8:c03db944 r7:00000014 r6:c62ad000 r5:c2b3a000 r4:c03db9a4
[<c03b2a84>] (svc_process+0x0/0x7e8) from [<c01c4ba4>]
(nfsd+0x17c/0x2d4) [<c01c4a28>] (nfsd+0x0/0x2d4) from [<c011dee4>]
(do_exit+0x0/0x7c4) SysRq : Show Regs

Pid: 1208, comm:                 nfsd
CPU: 0    Not tainted  (2.6.22.7 #7)
PC is at xfs_bmap_add_extent+0x3c4/0x4f8 LR is at
xfs_iext_insert+0x34/0x50
pc : [<c0215194>]    lr : [<c0235df4>]    psr: 60000013
sp : c5cb3b40  ip : 000fffff  fp : c5cb3bc4
r10: c5cb3c88  r9 : c5cb3d0c  r8 : c5984060
r7 : 00064f35  r6 : 00000000  r5 : 00000000  r4 : 00000000
r3 : 00000001  r2 : c5cb3b90  r1 : c5984165  r0 : 00000000
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  Segment user
Control: a005317f  Table: 07b38000  DAC: 00000015 [<c00f1b3c>]
(show_regs+0x0/0x50) from [<c02c8278>] (sysrq_handle_showregs+0x20/0x28)
 r4:c03e5654
[<c02c8258>] (sysrq_handle_showregs+0x0/0x28) from [<c02c8110>]
(__handle_sysrq+0xa4/0x148) [<c02c806c>] (__handle_sysrq+0x0/0x148) from
[<c02c841c>] (handle_sysrq+0x34/0x40) [<c02c83e8>]
(handle_sysrq+0x0/0x40) from [<c02ccd40>] (receive_chars+0x17c/0x2c4)
[<c02ccbc4>] (receive_chars+0x0/0x2c4) from [<c02cdec8>]
(serial8250_interrupt+0x74/0x13c) [<c02cde54>]
(serial8250_interrupt+0x0/0x13c) from [<c013b804>]
(handle_IRQ_event+0x44/0x84) [<c013b7c0>] (handle_IRQ_event+0x0/0x84)
from [<c013d080>] (handle_level_irq+0xe0/0xfc)
 r7:00064f35 r6:00000000 r5:00000003 r4:c03d8998 [<c013cfa0>]
(handle_level_irq+0x0/0xfc) from [<c0021048>] (asm_do_IRQ+0x48/0x64)
 r5:c03d8998 r4:00000003
[<c0021000>] (asm_do_IRQ+0x0/0x64) from [<c003bef0>]
(__irq_svc+0x30/0x100) Exception stack(0xc5cb3af8 to 0xc5cb3b40)
3ae0:                                                       00000000
c5984165
3b00: c5cb3b90 00000001 00000000 00000000 00000000 00064f35 c5984060
c5cb3d0c
3b20: c5cb3c88 c5cb3bc4 000fffff c5cb3b40 c0235df4 c0215194 60000013
ffffffff
 r6:00000002 r5:f1020000 r4:ffffffff
[<c0214dd0>] (xfs_bmap_add_extent+0x0/0x4f8) from [<c0215ac4>]
(xfs_bunmapi+0x7fc/0xf38) [<c02152c8>] (xfs_bunmapi+0x0/0xf38) from
[<c0236e9c>] (xfs_itruncate_finish+0x1e4/0x368)
[<c0236cb8>] (xfs_itruncate_finish+0x0/0x368) from [<c025392c>]
(xfs_setattr+0x8b0/0xde4) [<c025307c>] (xfs_setattr+0x0/0xde4) from
[<c025ffd8>] (xfs_vn_setattr+0x16c/0x18c) [<c025fe6c>]
(xfs_vn_setattr+0x0/0x18c) from [<c016b5bc>] (notify_change+0x124/0x244)
 r7:c5b26758 r6:00000068 r5:c5985078 r4:c7d9b8f0 [<c016b498>]
(notify_change+0x0/0x244) from [<c01c9180>] (nfsd_setattr+0x368/0x50c)
[<c01c8e18>] (nfsd_setattr+0x0/0x50c) from [<c01cfdc4>]
(nfsd3_proc_setattr+0xa0/0xc4) [<c01cfd24>]
(nfsd3_proc_setattr+0x0/0xc4) from [<c01c452c>]
(nfsd_dispatch+0xd8/0x1e0)  r7:c2b3a000 r6:c03db9a4 r5:00000018
r4:c62ad000 [<c01c4454>] (nfsd_dispatch+0x0/0x1e0) from [<c03b2ecc>]
(svc_process+0x448/0x7e8)
 r8:c03db944 r7:00000014 r6:c62ad000 r5:c2b3a000 r4:c03db9a4
[<c03b2a84>] (svc_process+0x0/0x7e8) from [<c01c4ba4>]
(nfsd+0x17c/0x2d4) [<c01c4a28>] (nfsd+0x0/0x2d4) from [<c011dee4>]
(do_exit+0x0/0x7c4) SysRq : Show Regs

Pid: 1208, comm:                 nfsd
CPU: 0    Not tainted  (2.6.22.7 #7)
PC is at xfs_trans_unreserve_and_mod_sb+0x8/0x2a8
LR is at _xfs_trans_commit+0x6c/0x354
pc : [<c024b1cc>]    lr : [<c024c5dc>]    psr: 20000013
sp : c5cb3bb0  ip : c5cb3bc0  fp : c5cb3cc4
r10: c6017000  r9 : c5cb3d24  r8 : 00000000
r7 : 00000000  r6 : 00000010  r5 : c21cf098  r4 : 00000000
r3 : 00000000  r2 : 00000005  r1 : 00000004  r0 : c21cf098
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  Segment user
Control: a005317f  Table: 07b38000  DAC: 00000015 [<c00f1b3c>]
(show_regs+0x0/0x50) from [<c02c8278>] (sysrq_handle_showregs+0x20/0x28)
 r4:c03e5654
[<c02c8258>] (sysrq_handle_showregs+0x0/0x28) from [<c02c8110>]
(__handle_sysrq+0xa4/0x148) [<c02c806c>] (__handle_sysrq+0x0/0x148) from
[<c02c841c>] (handle_sysrq+0x34/0x40) [<c02c83e8>]
(handle_sysrq+0x0/0x40) from [<c02ccd40>] (receive_chars+0x17c/0x2c4)
[<c02ccbc4>] (receive_chars+0x0/0x2c4) from [<c02cdec8>]
(serial8250_interrupt+0x74/0x13c) [<c02cde54>]
(serial8250_interrupt+0x0/0x13c) from [<c013b804>]
(handle_IRQ_event+0x44/0x84) [<c013b7c0>] (handle_IRQ_event+0x0/0x84)
from [<c013d080>] (handle_level_irq+0xe0/0xfc)  r7:00000000 r6:00000000
r5:00000003 r4:c03d8998 [<c013cfa0>] (handle_level_irq+0x0/0xfc) from
[<c0021048>] (asm_do_IRQ+0x48/0x64)
 r5:c03d8998 r4:00000003
[<c0021000>] (asm_do_IRQ+0x0/0x64) from [<c003bef0>]
(__irq_svc+0x30/0x100) Exception stack(0xc5cb3b68 to 0xc5cb3bb0)
3b60:                   c21cf098 00000004 00000005 00000000 00000000
c21cf098
3b80: 00000010 00000000 00000000 c5cb3d24 c6017000 c5cb3cc4 c5cb3bc0
c5cb3bb0
3ba0: c024c5dc c024b1cc 20000013 ffffffff
 r6:00000002 r5:f1020000 r4:ffffffff
[<c024c570>] (_xfs_trans_commit+0x0/0x354) from [<c0236f5c>]
(xfs_itruncate_finish+0x2a4/0x368)
[<c0236cb8>] (xfs_itruncate_finish+0x0/0x368) from [<c025392c>]
(xfs_setattr+0x8b0/0xde4) [<c025307c>] (xfs_setattr+0x0/0xde4) from
[<c025ffd8>] (xfs_vn_setattr+0x16c/0x18c) [<c025fe6c>]
(xfs_vn_setattr+0x0/0x18c) from [<c016b5bc>] (notify_change+0x124/0x244)
 r7:c5b26758 r6:00000068 r5:c5985078 r4:c7d9b8f0 [<c016b498>]
(notify_change+0x0/0x244) from [<c01c9180>] (nfsd_setattr+0x368/0x50c)
[<c01c8e18>] (nfsd_setattr+0x0/0x50c) from [<c01cfdc4>]
(nfsd3_proc_setattr+0xa0/0xc4) [<c01cfd24>]
(nfsd3_proc_setattr+0x0/0xc4) from [<c01c452c>]
(nfsd_dispatch+0xd8/0x1e0)  r7:c2b3a000 r6:c03db9a4 r5:00000018
r4:c62ad000 [<c01c4454>] (nfsd_dispatch+0x0/0x1e0) from [<c03b2ecc>]
(svc_process+0x448/0x7e8)
 r8:c03db944 r7:00000014 r6:c62ad000 r5:c2b3a000 r4:c03db9a4
[<c03b2a84>] (svc_process+0x0/0x7e8) from [<c01c4ba4>]
(nfsd+0x17c/0x2d4) [<c01c4a28>] (nfsd+0x0/0x2d4) from [<c011dee4>]
(do_exit+0x0/0x7c4) SysRq : Show Regs

Pid: 1208, comm:                 nfsd
CPU: 0    Not tainted  (2.6.22.7 #7)
PC is at kmem_zone_zalloc+0x14/0x40
LR is at kmem_zone_alloc+0x6c/0xc0
pc : [<c0258104>]    lr : [<c025809c>]    psr: a0000013
sp : c5cb3c90  ip : c09b74a0  fp : c5cb3ca4
r10: c5cb3dd4  r9 : c5cb3d24  r8 : 00000000
r7 : 00000000  r6 : c21cf098  r5 : c5984060  r4 : c7c3bbc0
r3 : 00000004  r2 : 00000001  r1 : c09b74b0  r0 : c21cf310
Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  Segment user
Control: a005317f  Table: 07b38000  DAC: 00000015 [<c00f1b3c>]
(show_regs+0x0/0x50) from [<c02c8278>] (sysrq_handle_showregs+0x20/0x28)
 r4:c03e5654
[<c02c8258>] (sysrq_handle_showregs+0x0/0x28) from [<c02c8110>]
(__handle_sysrq+0xa4/0x148) [<c02c806c>] (__handle_sysrq+0x0/0x148) from
[<c02c841c>] (handle_sysrq+0x34/0x40) [<c02c83e8>]
(handle_sysrq+0x0/0x40) from [<c02ccd40>] (receive_chars+0x17c/0x2c4)
[<c02ccbc4>] (receive_chars+0x0/0x2c4) from [<c02cdec8>]
(serial8250_interrupt+0x74/0x13c) [<c02cde54>]
(serial8250_interrupt+0x0/0x13c) from [<c013b804>]
(handle_IRQ_event+0x44/0x84) [<c013b7c0>] (handle_IRQ_event+0x0/0x84)
from [<c013d080>] (handle_level_irq+0xe0/0xfc)  r7:00000000 r6:00000000
r5:00000003 r4:c03d8998 [<c013cfa0>] (handle_level_irq+0x0/0xfc) from
[<c0021048>] (asm_do_IRQ+0x48/0x64)
 r5:c03d8998 r4:00000003
[<c0021000>] (asm_do_IRQ+0x0/0x64) from [<c003bef0>]
(__irq_svc+0x30/0x100) Exception stack(0xc5cb3c48 to 0xc5cb3c90)
3c40:                   c21cf310 c09b74b0 00000001 00000004 c7c3bbc0
c5984060
3c60: c21cf098 00000000 00000000 c5cb3d24 c5cb3dd4 c5cb3ca4 c09b74a0
c5cb3c90
3c80: c025809c c0258104 a0000013 ffffffff
 r6:00000002 r5:f1020000 r4:ffffffff
[<c02580f0>] (kmem_zone_zalloc+0x0/0x40) from [<c024b6d8>]
(xfs_trans_dup+0x20/0xf4)  r5:c5984060 r4:c21cf098 [<c024b6b8>]
(xfs_trans_dup+0x0/0xf4) from [<c0236f44>]
(xfs_itruncate_finish+0x28c/0x368)
 r7:00000000 r6:00000000 r5:c5984060 r4:c21cf098 [<c0236cb8>]
(xfs_itruncate_finish+0x0/0x368) from [<c025392c>]
(xfs_setattr+0x8b0/0xde4) [<c025307c>] (xfs_setattr+0x0/0xde4) from
[<c025ffd8>] (xfs_vn_setattr+0x16c/0x18c) [<c025fe6c>]
(xfs_vn_setattr+0x0/0x18c) from [<c016b5bc>] (notify_change+0x124/0x244)
 r7:c5b26758 r6:00000068 r5:c5985078 r4:c7d9b8f0 [<c016b498>]
(notify_change+0x0/0x244) from [<c01c9180>] (nfsd_setattr+0x368/0x50c)
[<c01c8e18>] (nfsd_setattr+0x0/0x50c) from [<c01cfdc4>]
(nfsd3_proc_setattr+0xa0/0xc4) [<c01cfd24>]
(nfsd3_proc_setattr+0x0/0xc4) from [<c01c452c>]
(nfsd_dispatch+0xd8/0x1e0)  r7:c2b3a000 r6:c03db9a4 r5:00000018
r4:c62ad000 [<c01c4454>] (nfsd_dispatch+0x0/0x1e0) from [<c03b2ecc>]
(svc_process+0x448/0x7e8)
 r8:c03db944 r7:00000014 r6:c62ad000 r5:c2b3a000 r4:c03db9a4
[<c03b2a84>] (svc_process+0x0/0x7e8) from [<c01c4ba4>]
(nfsd+0x17c/0x2d4) [<c01c4a28>] (nfsd+0x0/0x2d4) from [<c011dee4>]
(do_exit+0x0/0x7c4) SysRq : Show Regs

Pid: 1208, comm:                 nfsd
CPU: 0    Not tainted  (2.6.22.7 #7)
PC is at xfs_bunmapi+0x330/0xf38
LR is at __init_begin+0x3fff8000/0x30
pc : [<c02155f8>]    lr : [<00000000>]    psr: 80000013
sp : c5cb3bc8  ip : c5cb3c50  fp : c5cb3cc4
r10: 00000000  r9 : 00000000  r8 : 00000000
r7 : 00000bff  r6 : 000fffff  r5 : 00000000  r4 : ffffffff
r3 : 000fffff  r2 : fffe0c00  r1 : 00000000  r0 : 00000bef
Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  Segment user
Control: a005317f  Table: 07b38000  DAC: 00000015 [<c00f1b3c>]
(show_regs+0x0/0x50) from [<c02c8278>] (sysrq_handle_showregs+0x20/0x28)
 r4:c03e5654
[<c02c8258>] (sysrq_handle_showregs+0x0/0x28) from [<c02c8110>]
(__handle_sysrq+0xa4/0x148) [<c02c806c>] (__handle_sysrq+0x0/0x148) from
[<c02c841c>] (handle_sysrq+0x34/0x40) [<c02c83e8>]
(handle_sysrq+0x0/0x40) from [<c02ccd40>] (receive_chars+0x17c/0x2c4)
[<c02ccbc4>] (receive_chars+0x0/0x2c4) from [<c02cdec8>]
(serial8250_interrupt+0x74/0x13c) [<c02cde54>]
(serial8250_interrupt+0x0/0x13c) from [<c013b804>]
(handle_IRQ_event+0x44/0x84) [<c013b7c0>] (handle_IRQ_event+0x0/0x84)
from [<c013d080>] (handle_level_irq+0xe0/0xfc)  r7:00000bff r6:00000000
r5:00000003 r4:c03d8998 [<c013cfa0>] (handle_level_irq+0x0/0xfc) from
[<c0021048>] (asm_do_IRQ+0x48/0x64)
 r5:c03d8998 r4:00000003
[<c0021000>] (asm_do_IRQ+0x0/0x64) from [<c003bef0>]
(__irq_svc+0x30/0x100) Exception stack(0xc5cb3b80 to 0xc5cb3bc8)
3b80: 00000bef 00000000 fffe0c00 000fffff ffffffff 00000000 000fffff
00000bff
3ba0: 00000000 00000000 00000000 c5cb3cc4 c5cb3c50 c5cb3bc8 00000000
c02155f8
3bc0: 80000013 ffffffff
 r6:00000002 r5:f1020000 r4:ffffffff
[<c02152c8>] (xfs_bunmapi+0x0/0xf38) from [<c0236e9c>]
(xfs_itruncate_finish+0x1e4/0x368)
[<c0236cb8>] (xfs_itruncate_finish+0x0/0x368) from [<c025392c>]
(xfs_setattr+0x8b0/0xde4) [<c025307c>] (xfs_setattr+0x0/0xde4) from
[<c025ffd8>] (xfs_vn_setattr+0x16c/0x18c) [<c025fe6c>]
(xfs_vn_setattr+0x0/0x18c) from [<c016b5bc>] (notify_change+0x124/0x244)
 r7:c5b26758 r6:00000068 r5:c5985078 r4:c7d9b8f0 [<c016b498>]
(notify_change+0x0/0x244) from [<c01c9180>] (nfsd_setattr+0x368/0x50c)
[<c01c8e18>] (nfsd_setattr+0x0/0x50c) from [<c01cfdc4>]
(nfsd3_proc_setattr+0xa0/0xc4) [<c01cfd24>]
(nfsd3_proc_setattr+0x0/0xc4) from [<c01c452c>]
(nfsd_dispatch+0xd8/0x1e0)  r7:c2b3a000 r6:c03db9a4 r5:00000018
r4:c62ad000 [<c01c4454>] (nfsd_dispatch+0x0/0x1e0) from [<c03b2ecc>]
(svc_process+0x448/0x7e8)
 r8:c03db944 r7:00000014 r6:c62ad000 r5:c2b3a000 r4:c03db9a4
[<c03b2a84>] (svc_process+0x0/0x7e8) from [<c01c4ba4>]
(nfsd+0x17c/0x2d4) [<c01c4a28>] (nfsd+0x0/0x2d4) from [<c011dee4>]
(do_exit+0x0/0x7c4) SysRq : Resetting Reseting !!
