Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Nov 2006 13:26:49 -0800 (PST)
Received: from mail.wrs.com (mail.windriver.com [147.11.1.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kALLQaaG028711
	for <xfs@oss.sgi.com>; Tue, 21 Nov 2006 13:26:36 -0800
Received: from ALA-MAIL03.corp.ad.wrs.com (ala-mail03 [147.11.57.144])
	by mail.wrs.com (8.13.6/8.13.3) with ESMTP id kALHGL6M025750
	for <xfs@oss.sgi.com>; Tue, 21 Nov 2006 09:16:21 -0800 (PST)
MIME-Version: 1.0
Subject: XFS sync hang
Date: Tue, 21 Nov 2006 09:16:19 -0800
Message-ID: <37B62E0F71C9E14B9859FADB1FC3E3E1077D84@ala-mail02.corp.ad.wrs.com>
From: "Kottaridis, Chris" <chris.kottaridis@windriver.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I have a system based off of 2.6.10 with XFS on top of LVM2 on top of
RAID 1 of SCSI disks. The sync commands hang it looks like waiting for a
lock. One of them seems to be trying to lock xfs_buf at least two others
are waiting on a super lock. I see this in the log files:
 
One of the sync commands is waiting for the xfs_buf lock:

Nov 13 19:13:34 typhoon-base-unit0 kernel: sync D C3370BF0 0 8602 1
15685 (NOTLB)
Nov 13 19:13:34 typhoon-base-unit0 kernel: db40de44 00000046 e94e2c70
c3370bf0 c3245ee0 f7eb9680 00000000 f7ebe000 
Nov 13 19:13:34 typhoon-base-unit0 kernel: f8d44c77 c02c57f1 00000000
00000000 00000000 c3245060 00000002 00000732 
Nov 13 19:13:34 typhoon-base-unit0 kernel: ee94e205 00000152 c3370bf0
e94e2c70 e94e2de4 0000219a c3370bf0 00000002 
Nov 13 19:13:34 typhoon-base-unit0 kernel: Call Trace:
Nov 13 19:13:34 typhoon-base-unit0 kernel: [<c0461796>] __down+0x76/0xde
Nov 13 19:13:34 typhoon-base-unit0 kernel: [<c0461922>]
__down_failed+0xa/0x10
Nov 13 19:13:34 typhoon-base-unit0 kernel: [<c0276642>]
.text.lock.xfs_buf+0x4b/0x51
Nov 13 19:13:34 typhoon-base-unit0 kernel: [<c02724dd>]
xfs_bwrite+0x9a/0xe7
Nov 13 19:13:34 typhoon-base-unit0 kernel: [<c026a1f1>]
xfs_syncsub+0x148/0x34f
Nov 13 19:13:34 typhoon-base-unit0 kernel: [<c026973a>]
xfs_sync+0x2a/0x2c
Nov 13 19:13:34 typhoon-base-unit0 kernel: [<c027bd93>]
linvfs_sync_super+0x41/0xf5
Nov 13 19:13:34 typhoon-base-unit0 kernel: [<c016dbe2>]
sync_filesystems+0xe2/0xef
Nov 13 19:13:34 typhoon-base-unit0 kernel: [<c0168f0c>]
do_sync+0x4f/0x83
Nov 13 19:13:34 typhoon-base-unit0 kernel: [<c0168f52>]
sys_sync+0x12/0x16
Nov 13 19:13:34 typhoon-base-unit0 kernel: [<c0102554>]
no_dpa_vsyscall_enter+0x8/0x1b

There are two other sync comamnds waiting on the super lock, which I
assume the above
sync has:

Nov 13 19:13:34 typhoon-base-unit0 kernel: sync D C04CAB60 0 15093 24660
(NOTLB)
Nov 13 19:13:34 typhoon-base-unit0 kernel: da407f38 00000046 f024f250
c04cab60 c3235ee0 0004037f da407f54 c0145da1 
Nov 13 19:13:34 typhoon-base-unit0 kernel: f8d2cbb7 f29e2e10 da407f04
00000000 00000000 c3235060 00000000 00000c17 
Nov 13 19:13:34 typhoon-base-unit0 kernel: c1b08a89 0000015b c04cab60
f024f250 f024f3c4 00003af5 c04cab60 00000002 
Nov 13 19:13:34 typhoon-base-unit0 kernel: Call Trace:
Nov 13 19:13:34 typhoon-base-unit0 kernel: [<c0461796>] __down+0x76/0xde
Nov 13 19:13:34 typhoon-base-unit0 kernel: [<c0461922>]
__down_failed+0xa/0x10
Nov 13 19:13:34 typhoon-base-unit0 kernel: [<c016e5c7>]
.text.lock.super+0xad/0x192
Nov 13 19:13:34 typhoon-base-unit0 kernel: [<c0168f04>]
do_sync+0x47/0x83
Nov 13 19:13:34 typhoon-base-unit0 kernel: [<c0168f52>]
sys_sync+0x12/0x16
Nov 13 19:13:34 typhoon-base-unit0 kernel: [<c0102554>]
no_dpa_vsyscall_enter+0x8/0x1b

I couldn't actually find a .text.lock.xfs_buf routine anywhere until I
compiled with -save-temps and found it in an assembly file generated at
compile time. I assume this is in the pagebuf_lock routine. I assume
some other process has the lock on the pagebuf and it either died
without unlocking or is hung up some way that isn't obvious from the
logs.
 
I see a PAGEBUF_LOCK_TRACKING option that will add a field to the pb
struct to try and track who has the lock. It gets enabled by setting
CONFIG_XFS_DEBUG, but I've heard that enabling CONFIG_XFS_DEBUG has it's
own problem. So, I thought I'd just try and set the
PAGEBUF_LOCK_TRACKING macro and see if I can;t determine the process
that is not free'ing the lock.
 
Any advice or comments are appreciated.
 
Thanks
 
Chris Kottaridis
Senior Engineer
Wind River Systems
719-522-9786
 


[[HTML alternate version deleted]]
