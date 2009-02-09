Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n19EYECL251061 for <xfs@oss.sgi.com>; Mon, 9 Feb 2009 08:34:15 -0600
Received: from stlx01.stz-softwaretechnik.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7011C18F337A
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2009 06:33:36 -0800 (PST)
Received: from stlx01.stz-softwaretechnik.com (stz-softwaretechnik.de
	[217.160.223.211]) by cuda.sgi.com with ESMTP id
	7ZC9Xve6w9q5Sxc6 for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2009 06:33:36 -0800 (PST)
Received: from rg by stlx01.stz-softwaretechnik.com with local (Exim 3.36 #1
	(Debian)) id 1LWXCP-0005hi-00
	for <xfs@oss.sgi.com>; Mon, 09 Feb 2009 15:33:25 +0100
Date: Mon, 9 Feb 2009 15:33:15 +0100
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: kernel: Access to block zero: fs: <sdg> inode: 231137029....
Message-ID: <20090209143315.GB2535@p15145560.pureserver.info>
Mime-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hello,

this is the second time I got hit by this problem in the last 2 months.

The server did respond to ping and all processes were still running, but the
load went up to >30. Neither a shutdown nor a sync command could be executed,
in the end I had to reset the server because nobody could access the samba
shares anymore. 

System: Debian Etch linux-image-2.6.18-6-amd64 (since today 2.6.24 from
etch-n-half). sdg is a fibre attached (QLA2422) RAID array.

Any idea what the reason for this could be? xfs_check of /dev/sdg didn't find anything.

Ralf


Feb  6 20:53:04 VU0EF005 kernel: Access to block zero: fs: <sdg> inode: 231137029 start_block : 0 start_off : 0 blkcnt : 0 extent-state : 0 
Feb  6 20:53:04 VU0EF005 kernel: ----------- [cut here ] --------- [please bite here ] ---------
Feb  6 20:53:04 VU0EF005 kernel: Kernel BUG at fs/xfs/support/debug.c:57
Feb  6 20:53:04 VU0EF005 kernel: invalid opcode: 0000 [1] SMP 
Feb  6 20:53:04 VU0EF005 kernel: CPU 0 
Feb  6 20:53:04 VU0EF005 kernel: Modules linked in: nfs nfsd exportfs lockd nfs_acl sunrpc button ac battery ipv6 bonding xfs loop sr_mod parport_pc parport floppy sg
 i2c_i801 i2c_core serio_raw psmouse pcspkr shpchp pci_hotplug evdev joydev ext3 jbd mbcache dm_mirror dm_snapshot dm_mod raid1 md_mod ide_generic usbhid usb_storage 
ide_cd cdrom ehci_hcd uhci_hcd e1000 sd_mod thermal processor fan qla2xxx firmware_class scsi_transport_fc ahci libata scsi_mod piix ide_core
Feb  6 20:53:04 VU0EF005 kernel: Pid: 10532, comm: smbd Not tainted 2.6.18-6-amd64 #1
Feb  6 20:53:04 VU0EF005 kernel: RIP: 0010:[<ffffffff88295be3>]  [<ffffffff88295be3>] :xfs:cmn_err+0xda/0x11f
Feb  6 20:53:04 VU0EF005 kernel: RSP: 0018:ffff810132b95868  EFLAGS: 00010246
Feb  6 20:53:04 VU0EF005 kernel: RAX: 000000000000006f RBX: ffffffff88297a7c RCX: ffff81042149c000
Feb  6 20:53:04 VU0EF005 kernel: RDX: 0000000000000003 RSI: 0000000000000297 RDI: ffffffff882afc8c
Feb  6 20:53:04 VU0EF005 kernel: RBP: 0000000000000000 R08: ffffffff8044f868 R09: 0000000000000000
Feb  6 20:53:04 VU0EF005 kernel: R10: 0000000000000046 R11: ffff810001036620 R12: 0000000000000297
Feb  6 20:53:04 VU0EF005 kernel: R13: ffff810219837a00 R14: 0000000001840000 R15: ffff810132b95c58
Feb  6 20:53:04 VU0EF005 kernel: FS:  00002b9024223e80(0000) GS:ffffffff80521000(0000) knlGS:0000000000000000
Feb  6 20:53:04 VU0EF005 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb  6 20:53:04 VU0EF005 kernel: CR2: 00002b7956cb2000 CR3: 00000002121d4000 CR4: 00000000000006e0
Feb  6 20:53:04 VU0EF005 kernel: Process smbd (pid: 10532, threadinfo ffff810132b94000, task ffff81041e62f080)
Feb  6 20:53:04 VU0EF005 kernel: Stack:  0000003000000030 ffff810132b95968 ffff810132b95888 000000000000183f
Feb  6 20:53:04 VU0EF005 kernel: ffffffff8826f6cb ffff810132b95ba0 ffff810420f6e2e0 000000000dc6df05
Feb  6 20:53:04 VU0EF005 kernel: 0000000000000000 0000000000000000 ffff810219835000 ffff810219837a00
Feb  6 20:53:04 VU0EF005 kernel: Call Trace:
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff8826f6cb>] :xfs:xfs_iext_get_ext+0x43/0x69
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff8826f6cb>] :xfs:xfs_iext_get_ext+0x43/0x69
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff88254746>] :xfs:xfs_bmap_search_multi_extents+0x9a/0xd7
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff8022e05e>] __up_write+0x21/0x10d
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff88254838>] :xfs:xfs_bmap_search_extents+0xb5/0xc2
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff88254c0a>] :xfs:xfs_bmapi+0x29a/0x1c83
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff80239491>] remove_wait_queue+0x12/0x45
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff802c041a>] free_poll_entry+0x11/0x1a
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff802186c7>] poll_freewait+0x29/0x6a
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff8020fa36>] do_select+0x41c/0x439
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff8027c98d>] default_wake_function+0x0/0xe
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff882933e5>] :xfs:xfs_zero_eof+0x180/0x22e
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff8025def2>] _spin_lock_bh+0x9/0x14
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff8020d5c4>] current_fs_time+0x3b/0x40
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff8025d914>] __down_write_nested+0x12/0x9a
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff8021b858>] tcp_recvmsg+0x9f0/0xb05
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff882940af>] :xfs:xfs_write+0x4af/0x95c
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff8038b7f5>] sock_aio_read+0x4f/0x5e
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff8829080a>] :xfs:xfs_file_aio_write+0x69/0x6e
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff80215ebd>] do_sync_write+0xc7/0x104
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff8028fa92>] autoremove_wake_function+0x0/0x2e
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff8022ae78>] mntput_no_expire+0x19/0x8b
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff80214967>] vfs_write+0xce/0x174
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff8023fc8d>] sys_pwrite64+0x50/0x70
Feb  6 20:53:04 VU0EF005 kernel: [<ffffffff80257bd6>] system_call+0x7e/0x83
Feb  6 20:53:04 VU0EF005 kernel: 
Feb  6 20:53:04 VU0EF005 kernel: 
Feb  6 20:53:04 VU0EF005 kernel: Code: 0f 0b 68 b0 b0 29 88 c2 39 00 eb 2b 48 c7 c6 ce b0 29 88 48 
Feb  6 20:53:04 VU0EF005 kernel: RIP  [<ffffffff88295be3>] :xfs:cmn_err+0xda/0x11f
Feb  6 20:53:04 VU0EF005 kernel: RSP <ffff810132b95868>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
