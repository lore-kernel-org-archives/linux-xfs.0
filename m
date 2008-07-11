Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Jul 2008 10:03:31 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6BH38AZ027961
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 10:03:08 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3787618B8603
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 10:04:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 9AYXip8Cg0fNMZve for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 10:04:11 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 375E1AC6278
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 12:04:11 -0500 (CDT)
Message-ID: <4877928A.1020008@sandeen.net>
Date: Fri, 11 Jul 2008 12:04:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: xfs leaking?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

after my  fill-the-1T-fs-with-20k-files test I tried an xfs_repair, and
it was sorrowfully slow compared to e2fsck of ext4 - I stopped it after
almost 2 hours, and only half complete.

I noticed that during the run, I was about out of memory (8G) and
swapping badly.

So I unmounted the fs, dropped caches, and was astounded to find
10492540 buffer heads still in the slab caches.

This was all  on 2.6.26-rc2 (I need to update) and lazy-count=1, 1T fs,
32 ags, mounted with inode64, nobarriers, and maximal logbuf count & size.

Rebooted, let the fs_mark test run just a bit, then tried removing the
xfs module because I forgot to load the one with dave's  fix, and:


slab error in kmem_cache_destroy(): cache `xfs_inode': Can't free all
objects
Pid: 3676, comm: rmmod Not tainted 2.6.26-rc2 #3

Call Trace:
 [<ffffffff80287e18>] kmem_cache_destroy+0x7d/0xb9
 [<ffffffffa03e6708>] :xfs:xfs_cleanup+0x5c/0xf9
 [<ffffffffa03e67bf>] :xfs:exit_xfs_fs+0x1a/0x28
 [<ffffffff80250b1f>] sys_delete_module+0x186/0x1de
 [<ffffffff8020bee2>] tracesys+0xd5/0xda

slab error in kmem_cache_destroy(): cache `xfs_buf_item': Can't free all
objects
Pid: 3676, comm: rmmod Not tainted 2.6.26-rc2 #3

Call Trace:
 [<ffffffff80287e18>] kmem_cache_destroy+0x7d/0xb9
 [<ffffffffa03e674c>] :xfs:xfs_cleanup+0xa0/0xf9
 [<ffffffffa03e67bf>] :xfs:exit_xfs_fs+0x1a/0x28
 [<ffffffff80250b1f>] sys_delete_module+0x186/0x1de
 [<ffffffff8020bee2>] tracesys+0xd5/0xda

slab error in kmem_cache_destroy(): cache `xfs_ili': Can't free all objects
Pid: 3676, comm: rmmod Not tainted 2.6.26-rc2 #3

Call Trace:
 [<ffffffff80287e18>] kmem_cache_destroy+0x7d/0xb9
 [<ffffffffa03e6790>] :xfs:xfs_cleanup+0xe4/0xf9
 [<ffffffffa03e67bf>] :xfs:exit_xfs_fs+0x1a/0x28
 [<ffffffff80250b1f>] sys_delete_module+0x186/0x1de
 [<ffffffff8020bee2>] tracesys+0xd5/0xda

slab error in kmem_cache_destroy(): cache `xfs_buf': Can't free all objects
Pid: 3676, comm: rmmod Not tainted 2.6.26-rc2 #3

Call Trace:
 [<ffffffff80287e18>] kmem_cache_destroy+0x7d/0xb9
 [<ffffffffa03e67c4>] :xfs:exit_xfs_fs+0x1f/0x28
 [<ffffffff80250b1f>] sys_delete_module+0x186/0x1de
 [<ffffffff8020bee2>] tracesys+0xd5/0xda

slab error in kmem_cache_destroy(): cache `xfs_vnode': Can't free all
objects
Pid: 3676, comm: rmmod Not tainted 2.6.26-rc2 #3

Call Trace:
 [<ffffffff80287e18>] kmem_cache_destroy+0x7d/0xb9
 [<ffffffffa03e5e5a>] :xfs:xfs_destroy_zones+0x21/0x36
 [<ffffffff80250b1f>] sys_delete_module+0x186/0x1de
 [<ffffffff8020bee2>] tracesys+0xd5/0xda

BUG: unable to handle kernel paging request at ffffffffa03ebabb
IP: [<ffffffff8031a399>] strnlen+0x11/0x1a
PGD 203067 PUD 207063 PMD 21d714067 PTE 0
Oops: 0000 [1] SMP
CPU 2
Modules linked in: autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6
dm_multipath sbs sbshc battery acpi_memhotplug ac parport_pc lp parport
sg dcdbas ide_cd_mod cdrom tg3 button serio_raw k8temp i2c_piix4 shpchp
pcspkr i2c_core hwmon dm_snapshot dm_zero dm_mirror dm_log dm_mod
qla2xxx scsi_transport_fc sata_svw libata sd_mod scsi_mod ext3 jbd
uhci_hcd ohci_hcd ehci_hcd [last unloaded: xfs]
Pid: 3687, comm: grep Not tainted 2.6.26-rc2 #3
RIP: 0010:[<ffffffff8031a399>]  [<ffffffff8031a399>] strnlen+0x11/0x1a
RSP: 0018:ffff810107163cc0  EFLAGS: 00010297
RAX: ffffffffa03ebabb RBX: ffff810107163d28 RCX: ffffffff8056ae84
RDX: ffff810107163d58 RSI: fffffffffffffffe RDI: ffffffffa03ebabb
RBP: ffff81010718b0cc R08: 00000000ffffffff R09: 0000000000000240
R10: ffffffffffffffff R11: ffff81011fc113c0 R12: ffffffffa03ebabb
R13: 0000000000000011 R14: 0000000000000010 R15: ffff81010718c000
FS:  00007f09e29386e0(0000) GS:ffff81011faa3940(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffa03ebabb CR3: 000000011d4b9000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process grep (pid: 3687, threadinfo ffff810107162000, task ffff81011dd461c0)
Stack:  ffffffff8031b5a2 0000000000000001 000000008029c713 0000000000000f34
 ffff81010718b0cc ffffffff8056ae84 ffff81011dc420c0 0000000000039c1c
 ffff81011ddb6540 0000000000000000 0000000000008404 ffff81011dc420c0
Call Trace:
 [<ffffffff8031b5a2>] ? vsnprintf+0x31a/0x585
 [<ffffffff802a4977>] ? seq_printf+0x67/0x8f
 [<ffffffff80285a64>] ? s_show+0x160/0x28d
 [<ffffffff80285b2c>] ? s_show+0x228/0x28d
 [<ffffffff802a4e30>] ? seq_read+0x109/0x29d
 [<ffffffff802c7dc0>] ? proc_reg_read+0x73/0x8e
 [<ffffffff8028c6c0>] ? vfs_read+0xaa/0x132
 [<ffffffff8028ca5c>] ? sys_read+0x45/0x6e
 [<ffffffff8020bee2>] ? tracesys+0xd5/0xda


Code: f2 ae 48 f7 d1 48 8d 44 11 ff 40 38 30 74 0a 48 ff c8 48 39 d0 73
f3 31 c0 c3 48 89 f8 eb 03 48 ff c0 48 ff ce 48 83 fe ff 74 05 <80> 38
00 75 ef 48 29 f8 c3 31 c0 eb 12 41 38 c8 74 0a 48 ff c2
RIP  [<ffffffff8031a399>] strnlen+0x11/0x1a
 RSP <ffff810107163cc0>
CR2: ffffffffa03ebabb
---[ end trace 6767d9b951178909 ]---

-Eric
