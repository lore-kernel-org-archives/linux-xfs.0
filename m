Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mADEN7AM022261 for <xfs@oss.sgi.com>; Thu, 13 Nov 2008 06:23:08 -0800
Received: from smtp6.poczta.onet.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C1B251B7F868
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2008 06:23:05 -0800 (PST)
Received: from smtp6.poczta.onet.pl (smtp6.poczta.onet.pl [213.180.130.36]) by
	cuda.sgi.com with ESMTP id 2mvv0MB9bOg6ms0c for
	<xfs@oss.sgi.com>; Thu, 13 Nov 2008 06:23:05 -0800 (PST)
Received: from ip-83-238-22-2.netia.com.pl ([83.238.22.2]:39472 "EHLO
	[192.168.242.3]" rhost-flags-OK-FAIL-OK-FAIL) by ps6.test.onet.pl
	with ESMTPA id S184551386AbYKMOXEb9zHq (ORCPT
	<rfc822;xfs@oss.sgi.com>); Thu, 13 Nov 2008 15:23:04 +0100
Message-ID: <491C3842.4090902@poczta.onet.pl>
Date: Thu, 13 Nov 2008 15:22:58 +0100
From: "aluno3@poczta.onet.pl" <aluno3@poczta.onet.pl>
MIME-Version: 1.0
Subject: [xfs] Calltrace in 2.6.27 kernel
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi

I tested kernel 2.6.27 with stress test using fsstress,dd,LVM and
snapshots. After a few hours and overflow of snapshot I got call trace:

device-mapper: snapshots: Invalidating snapshot: Unable to allocate
exception.
I/O error in filesystem ("dm-49") meta-data dev dm-49 block
0x1d4c3b0       ("xlog_recover_do..(read#2)")
 error 5 buf count 8192
XFS: log mount/recovery failed: error 5
XFS: log mount failed
I/O error in filesystem ("dm-49") meta-data dev dm-49 block 0x0      
("xlog_recover_iodone") error 5 buf
 count 512
xfs_force_shutdown(dm-49,0x1) called from line 285 of file
fs/xfs/xfs_log_recover.c.  Return address = 0x
c0295a94
BUG: unable to handle kernel NULL pointer dereference at 0000002c
IP: [<c029553d>] xfs_log_force_umount+0x3d/0x170
*pdpt = 00000000345cf001 *pde = 0000000000000000
Oops: 0000 [#1] SMP
Modules linked in: iscsi_trgt mptctl mptbase drbd bonding iscsi_tcp
libiscsi scsi_transport_iscsi aacraid
 sata_nv forcedeth button ftdi_sio usbserial

Pid: 26593, comm: mount Not tainted (2.6.27 #24)
EIP: 0060:[<c029553d>] EFLAGS: 00010246 CPU: 0
EIP is at xfs_log_force_umount+0x3d/0x170
EAX: 00000000 EBX: f45bfc00 ECX: 00000000 EDX: 00000000
ESI: 00000000 EDI: 00000000 EBP: 00000000 ESP: f4757dd0
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process mount (pid: 26593, ti=f4756000 task=f569c780 task.ti=f4756000)
Stack: 00000001 00000001 00000001 f45bfc00 00000000 00000000 c02a88d0
f45bfc00
       f5291c00 f4757e38 00000001 c0295a94 0000011d 00000000 00000000
f5291c00
       f2aeba40 c02abd44 f5291c00 c02ac254 00000000 c02b1987 f5291c00
c02acb64
Call Trace:
 [<c02a88d0>] xfs_do_force_shutdown+0x40/0x110
 [<c0295a94>] xlog_recover_iodone+0x44/0x70
 [<c02abd44>] xfs_buf_iodone_work+0x34/0x70
 [<c02ac254>] xfs_buf_iorequest+0x74/0x80
 [<c02b1987>] xfs_bdstrat_cb+0x37/0x50
 [<c02acb64>] xfs_flush_buftarg+0x64/0x120
 [<c02ac58d>] xfs_free_buftarg+0xd/0x40
 [<c02b404e>] xfs_fs_fill_super+0x3ae/0x400
 [<c017ba38>] vfs_kern_mount+0x58/0x110
 [<c017bb9a>] do_kern_mount+0x2a/0x70
 [<c01900ee>] do_new_mount+0x5e/0x90
 [<c0190680>] do_mount+0x180/0x1a0
 [<c015c5da>] __alloc_pages_internal+0x9a/0x410
 [<c01908d1>] sys_mount+0x71/0xb0
 [<c0103a52>] syscall_call+0x7/0xb
 =======================
Code: 74 06 f6 46 0c 02 74 36 8b 83 04 02 00 00 8b 93 08 02 00 00 83 c8
10 89 93 08 02 00 00 89 83 04 02
00 00 8b 83 f8 00 00 00 31 d2 <8b> 48 2c 83 c9 20 89 48 2c 89 d0 5d 5a
5b 5e 5f 5d c3 90 85 d2
EIP: [<c029553d>] xfs_log_force_umount+0x3d/0x170 SS:ESP 0068:f4757dd0
---[ end trace 4287ff249aa7843b ]---

I made the same test again with 2.6.27.5 and patch from 2.6.28-rc for
XFS but result was same,too.I got next call trace:

device-mapper: snapshots: Invalidating snapshot: Unable to allocate
exception.
I/O error in filesystem ("dm-49") meta-data dev dm-49 block
0x1194002       ("xlog_recover_do..(read#1)")
 error 5 buf count 512
XFS: log mount/recovery failed: error 5
XFS: log mount failed
I/O error in filesystem ("dm-49") meta-data dev dm-49 block
0x1770018       ("xlog_recover_iodone") error
 5 buf count 4096
xfs_force_shutdown(dm-49,0x1) called from line 285 of file
fs/xfs/xfs_log_recover.c.  Return address = 0x
c0295c74
BUG: unable to handle kernel NULL pointer dereference at 0000002c
IP: [<c029571d>] xfs_log_force_umount+0x3d/0x170
*pdpt = 0000000023a0e001 *pde = 0000000000000000
Oops: 0000 [#1] SMP
Modules linked in: iscsi_trgt mptctl mptbase drbd bonding iscsi_tcp
libiscsi scsi_transport_iscsi aacraid
 sata_nv forcedeth button ftdi_sio usbserial

Pid: 27461, comm: mount Not tainted (2.6.27.5 #25)
EIP: 0060:[<c029571d>] EFLAGS: 00010246 CPU: 1
EIP is at xfs_log_force_umount+0x3d/0x170
EAX: 00000000 EBX: e7198400 ECX: 00000000 EDX: 00000000
ESI: 00000000 EDI: 00000000 EBP: 00000000 ESP: f1a21dd0
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process mount (pid: 27461, ti=f1a20000 task=f6f9d560 task.ti=f1a20000)
Stack: 00000001 00000001 00000001 e7198400 00000000 00000000 c02a8ae0
e7198400
       e6e71140 f1a21e38 00000001 c0295c74 0000011d 01770018 00000000
e6e71140
       e7deed40 c02abf54 e6e71140 c02ac464 00000000 c02b1b97 e6e71140
c02acd74
Call Trace:
 [<c02a8ae0>] xfs_do_force_shutdown+0x40/0x110
[<c0295c74>] xlog_recover_iodone+0x44/0x70
 [<c02abf54>] xfs_buf_iodone_work+0x34/0x70
 [<c02ac464>] xfs_buf_iorequest+0x74/0x80
 [<c02b1b97>] xfs_bdstrat_cb+0x37/0x50
 [<c02acd74>] xfs_flush_buftarg+0x64/0x120
 [<c02ac79d>] xfs_free_buftarg+0xd/0x40
 [<c02b425e>] xfs_fs_fill_super+0x3ae/0x400
 [<c017b7ef>] get_sb_bdev+0xdf/0x110
 [<c02b42c2>] xfs_fs_get_sb+0x12/0x20
 [<c02b3eb0>] xfs_fs_fill_super+0x0/0x400
 [<c017b9d8>] vfs_kern_mount+0x58/0x110
 [<c017bb3a>] do_kern_mount+0x2a/0x70
 [<c019008e>] do_new_mount+0x5e/0x90
 [<c0190620>] do_mount+0x180/0x1a0
 [<c015c59a>] __alloc_pages_internal+0x9a/0x410
 [<c0190871>] sys_mount+0x71/0xb0
 [<c0103a52>] syscall_call+0x7/0xb
 =======================
Code: 74 06 f6 46 0c 02 74 36 8b 83 04 02 00 00 8b 93 08 02 00 00 83 c8
10 89 93 08 02 00 00 89 83 04 02
00 00 8b 83 f8 00 00 00 31 d2 <8b> 48 2c 83 c9 20 89 48 2c 89 d0 5d 5a
5b 5e 5f 5d c3 90 85 d2
EIP: [<c029571d>] xfs_log_force_umount+0x3d/0x170 SS:ESP 0068:f1a21dd0
---[ end trace 669eb868e544de5d ]---



Maybe You know where is problem? Is there any solution for fixing it?

Best





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
