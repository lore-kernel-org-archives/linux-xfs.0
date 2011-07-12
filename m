Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6CDeGjD035345
	for <linux-xfs@oss.sgi.com>; Tue, 12 Jul 2011 08:40:18 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF011167E5AC
	for <linux-xfs@oss.sgi.com>; Tue, 12 Jul 2011 06:40:13 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id EGl3Jig9oHpA6fLJ for <linux-xfs@oss.sgi.com>;
	Tue, 12 Jul 2011 06:40:13 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1QgdC2-0008MN-Uo
	for linux-xfs@oss.sgi.com; Tue, 12 Jul 2011 15:40:06 +0200
Received: from xpc1.ast.cam.ac.uk ([131.111.68.219])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 12 Jul 2011 15:40:06 +0200
Received: from jeremy by xpc1.ast.cam.ac.uk with local (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 12 Jul 2011 15:40:06 +0200
From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: kernel bug on 2.6.38.8
Date: Tue, 12 Jul 2011 14:37:27 +0100
Message-ID: <ivhimo$vam$1@dough.gmane.org>
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

Hi - I built the fedora kernel kernel-2.6.38.8-35.fc15.src.rpm on Fedora 14, 
and have hit this bug while trying to copy files from an XFS partition:

[74755.600382] kernel BUG at fs/xfs/linux-2.6/xfs_aops.c:85!
[74755.600545] invalid opcode: 0000 [#1] SMP 
[74755.600707] last sysfs file: 
/sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
[74755.601020] CPU 0 
[74755.601020] Modules linked in: btrfs nfs fscache nfsd lockd nfs_acl 
auth_rpcgss hwmon_vid sunrpc ipv6 zlib_deflate libcrc32c xfs exportfs uinput 
ppdev microcode k8temp edac_core edac_mce_amd forcedeth snd_intel8x0 
snd_ac97_codec ac97_bus snd_seq snd_seq_device snd_pcm snd_timer snd 
soundcore snd_page_alloc nv_tco i2c_nforce2 i2c_core raid456 
async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx 
linear parport_pc parport firewire_ohci firewire_core crc_itu_t sata_nv 
pata_acpi ata_generic pata_amd 3w_9xxx [last unloaded: btrfs]
[74755.601020] 
[74755.601020] Pid: 11102, comm: flush-9:0 Not tainted 
2.6.38.8-35.fc14.x86_64 #1 WinFast C51GM03/C51MCP51
[74755.601020] RIP: 0010:[<ffffffffa02556d0>]  [<ffffffffa02556d0>] 
xfs_count_page_state+0x1d/0x55 [xfs]
[74755.601020] RSP: 0018:ffff8800007f39b0  EFLAGS: 00010246
[74755.601020] RAX: 002000000002002d RBX: ffffea0001318b88 RCX: 
0000000000000010
[74755.601020] RDX: ffff8800007f3a38 RSI: ffff8800007f3a3c RDI: 
ffffea0001318b88
[74755.601020] RBP: ffff8800007f39b0 R08: 0000000000000000 R09: 
0000000000000008
[74755.601020] R10: 00000000000169dc R11: 0000000000016990 R12: 
ffff88001d6dcd90
[74755.601020] R13: ffff88005b804590 R14: ffffffffffffffff R15: 
0000000000000000
[74755.601020] FS:  00007fe8f530b720(0000) GS:ffff88005fc00000(0000) 
knlGS:0000000000000000
[74755.601020] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[74755.601020] CR2: 00007fc91f391000 CR3: 00000000589c1000 CR4: 
00000000000006f0
[74755.601020] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[74755.601020] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[74755.601020] Process flush-9:0 (pid: 11102, threadinfo ffff8800007f2000, 
task ffff88005b804590)
[74755.601020] Stack:
[74755.601020]  ffff8800007f3a70 ffffffffa0255822 ffff8800007f3a10 
ffffffff8123ff80
[74755.601020]  000000000003ffff 0000000000018001 0000000000040000 
ffff8800007f3b10
[74755.601020]  ffff8800007f3d40 0000000000000000 000000000000000e 
ffff88001d6dcee0
[74755.601020] Call Trace:
[74755.601020]  [<ffffffffa0255822>] xfs_vm_writepage+0x8a/0x404 [xfs]
[74755.601020]  [<ffffffff8123ff80>] ? 
radix_tree_gang_lookup_tag_slot+0x81/0xa2
[74755.601020]  [<ffffffff810e00d5>] ? find_get_pages_tag+0x6f/0xd5
[74755.601020]  [<ffffffff810e7653>] __writepage+0x17/0x30
[74755.601020]  [<ffffffff810e7ced>] write_cache_pages+0x243/0x36a
[74755.601020]  [<ffffffff8148c37f>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[74755.601020]  [<ffffffff810e763c>] ? __writepage+0x0/0x30
[74755.601020]  [<ffffffffa02579fd>] ? xfs_bdwrite+0x5f/0x67 [xfs]
[74755.601020]  [<ffffffffa023c5f5>] ? xfs_iflush+0x181/0x1c1 [xfs]
[74755.608512]  [<ffffffffa02579fd>] ? xfs_bdwrite+0x5f/0x67 [xfs]
[74755.608512]  [<ffffffff810e7e38>] generic_writepages+0x24/0x26
[74755.608512]  [<ffffffffa0254bbd>] xfs_vm_writepages+0x4d/0x56 [xfs]
[74755.608512]  [<ffffffff810e8a0e>] do_writepages+0x21/0x2a
[74755.608512]  [<ffffffff81149aa0>] writeback_single_inode+0x9c/0x19b
[74755.608512]  [<ffffffff81149d9b>] writeback_sb_inodes+0xa1/0x12b
[74755.608512]  [<ffffffff8114a7bc>] writeback_inodes_wb+0x163/0x175
[74755.608512]  [<ffffffff8114aa1d>] wb_writeback+0x24f/0x368
[74755.608512]  [<ffffffff8114acb9>] wb_do_writeback+0x183/0x19e
[74755.608512]  [<ffffffff8114ad5c>] bdi_writeback_thread+0x88/0x205
[74755.608512]  [<ffffffff8114acd4>] ? bdi_writeback_thread+0x0/0x205
[74755.608512]  [<ffffffff8107326e>] kthread+0x82/0x8a
[74755.608512]  [<ffffffff8100ba64>] kernel_thread_helper+0x4/0x10
[74755.608512]  [<ffffffff810731ec>] ? kthread+0x0/0x8a
[74755.608512]  [<ffffffff8100ba60>] ? kernel_thread_helper+0x0/0x10
[74755.608512] Code: e1 e1 e0 48 83 c4 38 5b 41 5c 41 5d c9 c3 55 48 89 e5 
66 66 66 66 90 c7 02 00 00 00 00 c7 06 00 00 00 00 48 8b 07 f6 c4 08 75 02 
<0f> 0b 48 8b 4f 10 48 89 c8 48 8b 38 f7 c7 00 10 00 00 74 08 c7 
[74755.608512] RIP  [<ffffffffa02556d0>] xfs_count_page_state+0x1d/0x55 
[xfs]
[74755.608512]  RSP <ffff8800007f39b0>
[74755.616787] ---[ end trace 0f1bab8cfc7bd97a ]---

This happened a second time and now the machine has locked up.

The machine is x86-64 with 1.5GB or RAM. I'm currently trying out btrfs, so 
it was a suprise to get an xfs crash (copying from xfs to btrfs).

Is this problem fixed or is it new? If I go back to 2.6.35 will I avoid it?

Thanks

Jeremy


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
