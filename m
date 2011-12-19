Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBJ9ai5S062058
	for <linux-xfs@oss.sgi.com>; Mon, 19 Dec 2011 03:36:47 -0600
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id Vq5uMN0QtWDTNlvn for <linux-xfs@oss.sgi.com>;
	Mon, 19 Dec 2011 01:36:43 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1RcZeA-0005jp-3e
	for linux-xfs@oss.sgi.com; Mon, 19 Dec 2011 10:36:38 +0100
Received: from xpc1.ast.cam.ac.uk ([131.111.68.219])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 19 Dec 2011 10:36:38 +0100
Received: from jeremy by xpc1.ast.cam.ac.uk with local (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 19 Dec 2011 10:36:38 +0100
From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: bug in fs/xfs/xfs_aops.c:959! (kernel 3.1.5)
Date: Mon, 19 Dec 2011 09:36:24 +0000
Message-ID: <jcn0ip$hsk$1@dough.gmane.org>
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

Hello - this was just produced in kernel 3.1.5 (Fedora 16, x86-64, 
kernel-3.1.5-1.fc16.x86_64).

Jeremy


Dec 19 00:56:06 xback2 kernel: [374538.665353] ------------[ cut here 
]------------
Dec 19 00:56:06 xback2 kernel: [374538.665431] kernel BUG at 
fs/xfs/xfs_aops.c:959!
Dec 19 00:56:06 xback2 kernel: [374538.665504] invalid opcode: 0000 [#1] SMP 
Dec 19 00:56:06 xback2 kernel: [374538.665578] CPU 1 
Dec 19 00:56:06 xback2 kernel: [374538.665581] Modules linked in: btrfs 
zlib_deflate libcrc32c nfs fscache it87 hwmon_vid xfs raid456 
async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx 
ppdev linear snd_intel8x0 snd_ac97_codec ac97_bus snd_seq snd_seq_device 
snd_pcm snd_timer snd edac_core k8temp edac_mce_amd forcedeth soundcore 
snd_page_alloc parport_pc parport nfsd lockd nfs_acl auth_rpcgss sunrpc 
nv_tco i2c_nforce2 i2c_core uinput firewire_ohci firewire_core pata_acpi 
ata_generic crc_itu_t sata_nv pata_amd 3w_9xxx [last unloaded: btrfs]
Dec 19 00:56:06 xback2 kernel: [374538.666079] 
Dec 19 00:56:06 xback2 kernel: [374538.666079] Pid: 22689, comm: flush-9:0 
Not tainted 3.1.5-1.fc16.x86_64 #1 WinFast C51GM03/C51MCP51
Dec 19 00:56:06 xback2 kernel: [374538.666079] RIP: 0010:
[<ffffffffa02ec7e2>]  [<ffffffffa02ec7e2>] xfs_vm_writepage+0x4c2/0x4f0 
[xfs]
Dec 19 00:56:06 xback2 kernel: [374538.666079] RSP: 0018:ffff88000017d920  
EFLAGS: 00010246
Dec 19 00:56:06 xback2 kernel: [374538.666079] RAX: 002000000002002d RBX: 
ffff88001812b6d0 RCX: 000000000000000c
Dec 19 00:56:06 xback2 kernel: [374538.666079] RDX: 0000000000000000 RSI: 
ffff88000017dc60 RDI: ffffea000038a600
Dec 19 00:56:06 xback2 kernel: [374538.666079] RBP: ffff88000017d9d0 R08: 
0000000000000000 R09: 0000000000016400
Dec 19 00:56:06 xback2 kernel: [374538.666079] R10: ffff88005fddc700 R11: 
0000000000000014 R12: 0000000000001023
Dec 19 00:56:06 xback2 kernel: [374538.666079] R13: ffffea000038a600 R14: 
ffff88001812b588 R15: ffff88000017da80
Dec 19 00:56:06 xback2 kernel: [374538.666079] FS:  00007f0ec79f07c0(0000) 
GS:ffff88005fb00000(0000) knlGS:00000000f7728840
Dec 19 00:56:06 xback2 kernel: [374538.666079] CS:  0010 DS: 0000 ES: 0000 
CR0: 000000008005003b
Dec 19 00:56:06 xback2 kernel: [374538.666079] CR2: 00007f4439b8c000 CR3: 
000000001fd2f000 CR4: 00000000000006e0
Dec 19 00:56:06 xback2 kernel: [374538.666079] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Dec 19 00:56:06 xback2 kernel: [374538.666079] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Dec 19 00:56:06 xback2 kernel: [374538.666079] Process flush-9:0 (pid: 
22689, threadinfo ffff88000017c000, task ffff88004fb49730)
Dec 19 00:56:06 xback2 kernel: [374538.666079] Stack:
Dec 19 00:56:06 xback2 kernel: [374538.666079]  ffff88000017d970 
ffffffff812aa14d 000000000003ffff ffff88000017dc60
Dec 19 00:56:06 xback2 kernel: [374538.666079]  0000000000040000 
0000000001b3fe15 0000000000001000 0000000001024000
Dec 19 00:56:06 xback2 kernel: [374538.666079]  0000000000000000 
000000000000000e ffff88000017d9d0 ffffffff81114df4
Dec 19 00:56:06 xback2 kernel: [374538.666079] Call Trace:
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff812aa14d>] ? 
radix_tree_gang_lookup_tag_slot+0x8d/0xd0
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff81114df4>] ? 
find_get_pages_tag+0x44/0x140
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffffa02ee67f>] ? 
xfs_buf_get+0x8f/0x1a0 [xfs]
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff8111dec7>] 
__writepage+0x17/0x40
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff8111e32d>] 
write_cache_pages+0x20d/0x460
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff81053162>] ? 
complete+0x52/0x60
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff8111deb0>] ? 
set_page_dirty_lock+0x60/0x60
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffffa02ee551>] ? 
xfs_buf_delwri_queue+0xb1/0x150 [xfs]
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffffa02eec5a>] ? 
xfs_bdwrite+0x4a/0xb0 [xfs]
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffffa033406b>] ? 
xfs_iflush+0x20b/0x220 [xfs]
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff8111e5ca>] 
generic_writepages+0x4a/0x70
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffffa02eb8fd>] 
xfs_vm_writepages+0x4d/0x60 [xfs]
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff8111f8d1>] 
do_writepages+0x21/0x40
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff81198af9>] 
writeback_single_inode+0x149/0x3e0
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff81198f30>] 
writeback_sb_inodes+0x1a0/0x240
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff8119906e>] 
__writeback_inodes_wb+0x9e/0xd0
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff8119a25b>] 
wb_writeback+0x25b/0x340
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff8111eb4a>] ? 
determine_dirtyable_memory+0x1a/0x30
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff8119a7b3>] 
wb_do_writeback+0x1c3/0x200
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff815cdfaf>] ? 
schedule_timeout+0x16f/0x320
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff8119a873>] 
bdi_writeback_thread+0x83/0x2a0
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff8119a7f0>] ? 
wb_do_writeback+0x200/0x200
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff8108ddbc>] 
kthread+0x8c/0xa0
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff815d9974>] 
kernel_thread_helper+0x4/0x10
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff8108dd30>] ? 
kthread_worker_fn+0x190/0x190
Dec 19 00:56:06 xback2 kernel: [374538.666079]  [<ffffffff815d9970>] ? 
gs_change+0x13/0x13
Dec 19 00:56:06 xback2 kernel: [374538.666079] Code: f8 f5 74 bd 4c 89 ef 89 
85 58 ff ff ff e8 f7 ee ff ff f0 41 80 65 00 f7 4c 89 ef e8 59 7a e2 e0 8b 
85 58 ff ff ff e9 60 fd ff ff <0f> 0b 48 89 df e8 94 3a eb e0 44 8b 8d 58 ff 
ff ff e9 d0 fd ff 
Dec 19 00:56:06 xback2 kernel: [374538.666079] RIP  [<ffffffffa02ec7e2>] 
xfs_vm_writepage+0x4c2/0x4f0 [xfs]
Dec 19 00:56:06 xback2 kernel: [374538.666079]  RSP <ffff88000017d920>
Dec 19 00:56:06 xback2 kernel: [374538.671894] ---[ end trace 
280e5e9ba559f193 ]---


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
