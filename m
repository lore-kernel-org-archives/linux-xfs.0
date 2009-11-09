Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA9Kj5eA223245
	for <linux-xfs@oss.sgi.com>; Mon, 9 Nov 2009 14:45:08 -0600
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 107C6CEAEA6
	for <linux-xfs@oss.sgi.com>; Mon,  9 Nov 2009 12:45:14 -0800 (PST)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id CRw0k1vXr1q7ih0u for <linux-xfs@oss.sgi.com>;
	Mon, 09 Nov 2009 12:45:14 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.50) id 1N7b6r-000773-Es
	for linux-xfs@oss.sgi.com; Mon, 09 Nov 2009 21:45:09 +0100
Received: from adsl-068-016-104-079.sip.asm.bellsouth.net ([68.16.104.79])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 09 Nov 2009 21:45:09 +0100
Received: from ecashin by adsl-068-016-104-079.sip.asm.bellsouth.net with
	local (Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 09 Nov 2009 21:45:09 +0100
From: Ed Cashin <ecashin@coraid.com>
Subject: NULL mp->m_log in 2.6.31 xfs_log_move_tail
Date: Mon, 09 Nov 2009 15:39:32 -0500
Message-ID: <87ws1z8mbf.fsf@coraid.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: linux-xfs@oss.sgi.com

A colleague has seen oopses in 2.6.31 when an XFS is mounted on an AoE
target that becomes unresponsive and is marked as "down" by the aoe
driver.  The aoe driver starts failing all new I/O requests after
failing all current requests when the device is down.

I looked at the trace (included below) and put in the following check:

--- linux-2.6.31/fs/xfs/xfs_log.c.20091009	2009-10-09 16:49:23.062989234 -0400
+++ linux-2.6.31/fs/xfs/xfs_log.c	2009-10-09 16:49:39.766738875 -0400
@@ -822,6 +822,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 	xlog_t		*log = mp->m_log;
 	int		need_bytes, free_bytes, cycle, bytes;
 
+	BUG_ON(!log);
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return;
 
... and subsequent tests showed the BUG_ON being triggered.  I meant
to gather more information but have gotten sidetracked, so I'm posting
this information now in the hopes that it is helpful.

I/O error in filesystem ("etherd/e8.1") meta-data dev etherd/e8.1 block 
0x1bf0862       ("xlog_iodone") error 5 buf count 1024
xfs_force_shutdown(etherd/e8.1,0x2) called from line 1044 of file 
fs/xfs/xfs_log.c.  Return address = 0xffffffffa03e79bf
Filesystem "etherd/e8.1": Log I/O Error Detected.  Shutting down 
filesystem: etherd/e8.1
Please umount the filesystem, and rectify the problem(s)
XFS: Unable to update superblock counters. Freespace may not be correct 
on next mount.
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_log.c:825!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/block/etherd!e8.33/state
CPU 1
Modules linked in: aoe xfs exportfs bridge stp llc bnep sco l2cap 
bluetooth rfkill sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter 
ip6_tables ipv6 p4_clockmod freq_table speedstep_lib dm_multipath uinput 
ixgbe e1000e i5k_amb e1000 hwmon i5000_edac ppdev iTCO_wdt 
iTCO_vendor_support edac_core parport_pc dca mdio i2c_i801 parport 
floppy pcspkr shpchp ata_generic pata_acpi radeon ttm drm i2c_algo_bit 
i2c_core [last unloaded: aoe]
Pid: 21300, comm: umount Not tainted 2.6.31 #1 X7DB8
RIP: 0010:[<ffffffffa03e823b>]  [<ffffffffa03e823b>] 
xfs_log_move_tail+0x34/0x174 [xfs]
RSP: 0018:ffff88006e985b08  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88006e985ba8
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88007542c540
RBP: ffff88006e985b48 R08: ffff88007b101900 R09: ffffffff817a21d8
R10: ffff880019379c00 R11: 00000000860c2753 R12: ffff88007542c180
R13: 0000000000000000 R14: ffff88007b101900 R15: 0000000000000000
FS:  00007f089e005740(0000) GS:ffff880001a6f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f089d6d69ce CR3: 00000000765ae000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process umount (pid: 21300, threadinfo ffff88006e984000, task 
ffff88006d8f0000)
Stack:
  0000000000000000 00000000860c2753 ffff88006e985b48 ffff88007b101900
<0> ffff88007542c180 ffff88007b101900 ffff88007b101900 0000000000000000
<0> ffff88006e985b88 ffffffffa03f4e9d ffff88006e985b88 00000000860c2753
Call Trace:
  [<ffffffffa03f4e9d>] xfs_trans_ail_delete+0x82/0xf4 [xfs]
  [<ffffffffa03cc7fd>] xfs_buf_iodone+0x40/0x63 [xfs]
  [<ffffffffa03cc759>] xfs_buf_do_callbacks+0x3c/0x5f [xfs]
  [<ffffffffa03cca19>] xfs_buf_iodone_callbacks+0x136/0x175 [xfs]
  [<ffffffffa04002a5>] xfs_buf_iodone_work+0x63/0x86 [xfs]
  [<ffffffffa040035b>] xfs_buf_ioend+0x93/0xb7 [xfs]
  [<ffffffffa03fb230>] xfs_bioerror+0x56/0x76 [xfs]
  [<ffffffffa0404668>] xfs_bdstrat_cb+0x48/0x67 [xfs]
  [<ffffffffa03fff3e>] xfs_buf_iostrategy+0x2a/0x47 [xfs]
  [<ffffffffa03ffffc>] xfs_flush_buftarg+0xa1/0x125 [xfs]
  [<ffffffffa04000b2>] xfs_free_buftarg+0x32/0x8f [xfs]
  [<ffffffffa0406e61>] xfs_close_devices+0x77/0x94 [xfs]
  [<ffffffffa0406f2f>] xfs_fs_put_super+0xb1/0xe8 [xfs]
  [<ffffffff8112ccf6>] generic_shutdown_super+0x69/0xf2
  [<ffffffff8112cdb9>] kill_block_super+0x3a/0x6a
  [<ffffffff8112d6af>] deactivate_super+0x68/0x95
  [<ffffffff81144420>] mntput_no_expire+0xc6/0x114
  [<ffffffff81144aa6>] sys_umount+0x2f2/0x337
  [<ffffffff81012f82>] system_call_fastpath+0x16/0x1b
Code: 55 41 54 53 48 83 ec 18 0f 1f 44 00 00 65 48 8b 04 25 28 00 00 00 
48 89 45 c8 31 c0 48 8b 9f 40 01 00 00 49 89 f5 48 85 db 75 04 <0f> 0b 
eb fe f6 43 20 08 0f 85 0f 01 00 00 48 85 f6 75 19 48 8d
RIP  [<ffffffffa03e823b>] xfs_log_move_tail+0x34/0x174 [xfs]
  RSP <ffff88006e985b08>
---[ end trace 838ac7bc7c8a18c8 ]---
------------[ cut here ]------------
WARNING: at kernel/exit.c:895 do_exit+0x54/0x6da()
Hardware name: X7DB8
Modules linked in: aoe xfs exportfs bridge stp llc bnep sco l2cap 
bluetooth rfkill sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter 
ip6_tables ipv6 p4_clockmod freq_table speedstep_lib dm_multipath uinput 
ixgbe e1000e i5k_amb e1000 hwmon i5000_edac ppdev iTCO_wdt 
iTCO_vendor_support edac_core parport_pc dca mdio i2c_i801 parport 
floppy pcspkr shpchp ata_generic pata_acpi radeon ttm drm i2c_algo_bit 
i2c_core [last unloaded: aoe]
Pid: 21300, comm: umount Tainted: G      D    2.6.31 #1
Call Trace:
  [<ffffffff810610ff>] warn_slowpath_common+0x8d/0xbb
  [<ffffffff81061154>] warn_slowpath_null+0x27/0x3d
  [<ffffffff8106516f>] do_exit+0x54/0x6da
  [<ffffffff814d564f>] oops_end+0xc8/0xe7
  [<ffffffff810171ad>] die+0x6d/0x8c
  [<ffffffff814d4fdd>] do_trap+0x124/0x147
  [<ffffffff814d705d>] ? atomic_notifier_call_chain+0x26/0x3c
  [<ffffffff81014eb0>] do_invalid_op+0xa9/0xc9
  [<ffffffffa03e823b>] ? xfs_log_move_tail+0x34/0x174 [xfs]
  [<ffffffff814d3c6b>] ? trace_hardirqs_off_thunk+0x3a/0x6c
  [<ffffffff81013e2b>] invalid_op+0x1b/0x20
  [<ffffffffa03e823b>] ? xfs_log_move_tail+0x34/0x174 [xfs]
  [<ffffffffa03f4e9d>] xfs_trans_ail_delete+0x82/0xf4 [xfs]
  [<ffffffffa03cc7fd>] xfs_buf_iodone+0x40/0x63 [xfs]
  [<ffffffffa03cc759>] xfs_buf_do_callbacks+0x3c/0x5f [xfs]
  [<ffffffffa03cca19>] xfs_buf_iodone_callbacks+0x136/0x175 [xfs]
  [<ffffffffa04002a5>] xfs_buf_iodone_work+0x63/0x86 [xfs]
  [<ffffffffa040035b>] xfs_buf_ioend+0x93/0xb7 [xfs]
  [<ffffffffa03fb230>] xfs_bioerror+0x56/0x76 [xfs]
  [<ffffffffa0404668>] xfs_bdstrat_cb+0x48/0x67 [xfs]
  [<ffffffffa03fff3e>] xfs_buf_iostrategy+0x2a/0x47 [xfs]
  [<ffffffffa03ffffc>] xfs_flush_buftarg+0xa1/0x125 [xfs]
  [<ffffffffa04000b2>] xfs_free_buftarg+0x32/0x8f [xfs]
  [<ffffffffa0406e61>] xfs_close_devices+0x77/0x94 [xfs]
  [<ffffffffa0406f2f>] xfs_fs_put_super+0xb1/0xe8 [xfs]
  [<ffffffff8112ccf6>] generic_shutdown_super+0x69/0xf2
  [<ffffffff8112cdb9>] kill_block_super+0x3a/0x6a
  [<ffffffff8112d6af>] deactivate_super+0x68/0x95
  [<ffffffff81144420>] mntput_no_expire+0xc6/0x114
  [<ffffffff81144aa6>] sys_umount+0x2f2/0x337
  [<ffffffff81012f82>] system_call_fastpath+0x16/0x1b
---[ end trace 838ac7bc7c8a18c9 ]---
[root@stuart srrd]#

-- 
  Ed Cashin <ecashin@coraid.com>
  Find experimental aoe Linux driver patches at
  http://coraid.typepad.com/aoe_linux_proving_grounds/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
