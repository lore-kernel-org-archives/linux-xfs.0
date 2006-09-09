Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 09 Sep 2006 16:41:39 -0700 (PDT)
Received: from smtp106.biz.mail.mud.yahoo.com (smtp106.biz.mail.mud.yahoo.com [68.142.200.254])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k89NfWDW025958
	for <linux-xfs@oss.sgi.com>; Sat, 9 Sep 2006 16:41:32 -0700
Message-ID: <450342F9.8090301@stwo-corp.com>
Date: Sat, 09 Sep 2006 15:40:57 -0700
From: Michael Morrison <mikem@stwo-corp.com>
MIME-Version: 1.0
Subject: oops mounting unassembled md device
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Got on oops when trying to mount xfs filesystem onto unassembled md
raid0 device.
What else can I provide to help with this?

Linux version: 2.6.18-rc4
Drives are hanging off an LSI fibre channel controller which is driven by
the mpt driver in drivers/message/fusion.

Steps leading up to this:

1. assemble 8 drive raid0 on /dev/md0
2. mount filesystem: /bin/mount -t xfs /dev/md0 /mnt/testfs -o
noatime,nodiratime
3. umount /mnt/testfs
4. mdadm --stop /dev/md0
5. /bin/mount -t xfs /dev/md0 /mnt/testfs -o noatime,nodiratime

BUG: unable to handle kernel NULL pointer dereference at virtual address
00000004
 printing eip:
c03f18f6
*pde = 00000000
Oops: 0000 [#1]
SMP
Modules linked in: mptctl ppdev XENA2 tc ch sr_mod w83781d hwmon_vid
i2c_isa mptfc mptscsih mptbase scsi_transport_fc i2c_i801 i2c_core rtc
cdc_subset usbnet e1000
CPU:    1
EIP:    0060:[<c03f18f6>]    Not tainted VLI
EFLAGS: 00010282   (2.6.18-rc4 #5)
EIP is at raid0_unplug+0x1a/0x59
eax: 00000000   ebx: 00000000   ecx: c03f18dc   edx: 00000000
esi: f7f9a400   edi: e73f3d64   ebp: df5221f8   esp: e73f3d40
ds: 007b   es: 007b   ss: 0068
Process mount (pid: 11481, ti=e73f2000 task=f7835030 task.ti=e73f2000)
Stack: 00000001 e73f3d3c e73f3d3c e73f3d64 c02d7be2 f7d357a4 00000000
df5221f0
       00000000 e73f3d64 e73f3d64 f724c800 00000005 f724cb68 f66b57d0
c02c8c6b
       df5221c0 00000001 f724c800 00000000 f7f21c80 f66b57c0 00000000
00000000
Call Trace:
 [<c02d7be2>] xfs_flush_buftarg+0x1b9/0x1bb
 [<c02c8c6b>] xfs_mount+0x380/0x4d6
 [<c02ded89>] xfs_fs_fill_super+0xaf/0x20f
 [<c02fe473>] snprintf+0x27/0x2b
 [<c019d1cd>] disk_name+0xa9/0xbf
 [<c01693c1>] sb_set_blocksize+0x1f/0x45
 [<c0168eda>] get_sb_bdev+0x13a/0x17d
 [<c02def20>] xfs_fs_get_sb+0x37/0x3b
 [<c02decda>] xfs_fs_fill_super+0x0/0x20f
 [<c016916e>] vfs_kern_mount+0x55/0xa6
 [<c0169201>] do_kern_mount+0x42/0x5a
 [<c017f963>] do_new_mount+0x83/0xdb
 [<c01800d8>] do_mount+0x1dd/0x20f
 [<c017fea4>] copy_mount_options+0x60/0xb7
 [<c0180428>] sys_mount+0x9f/0xe0
 [<c0102ced>] sysenter_past_esp+0x56/0x79
Code: f0 ff c6 05 5c 3e 53 c0 01 83 c4 10 5b c3 90 90 90 57 56 53 31 db
83 ec 04 8b 44 24 14 8b b0 e8 00 00 00 8b 06 8b 96 98 00 00 00 <8b> 40
04 83 fa 00 8b 78 1c 7e 1a 8b 04 9f 8b 40 18 8b 40 58 8b
EIP: [<c03f18f6>] raid0_unplug+0x1a/0x59 SS:ESP 0068:e73f3d40
