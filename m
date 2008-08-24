Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Aug 2008 14:59:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7OLxlXa032633
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 14:59:48 -0700
Received: from mx3.mail.elte.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 746ECFAF148
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 15:01:07 -0700 (PDT)
Received: from mx3.mail.elte.hu (mx3.mail.elte.hu [157.181.1.138]) by cuda.sgi.com with ESMTP id omBjLlXPlK4xf1sl for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 15:01:07 -0700 (PDT)
Received: from hermes.teteny.elte.hu ([157.181.96.2] helo=hermes.teteny.bme.hu)
	by mx3.mail.elte.hu with esmtp (Exim)
	id 1KXNdq-00054W-1a
	from <kirk@bteam.hu>
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 00:01:06 +0200
Received: from localhost (localhost [127.0.0.1])
	by hermes.teteny.bme.hu (Postfix) with ESMTP id A5C501E0003FF
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 00:05:25 +0200 (CEST)
Received: from hermes.teteny.bme.hu ([127.0.0.1])
	by localhost (hermes.teteny.bme.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZemFTzHVQOP0 for <xfs@oss.sgi.com>;
	Mon, 25 Aug 2008 00:05:14 +0200 (CEST)
Received: from [152.66.235.6] (revana.teteny.bme.hu [152.66.235.6])
	by hermes.teteny.bme.hu (Postfix) with ESMTP id 89C3A1E0003FE
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 00:05:04 +0200 (CEST)
Message-ID: <48B1D9FC.4090203@bteam.hu>
Date: Mon, 25 Aug 2008 00:00:28 +0200
From: Nagy Zoltan <kirk@bteam.hu>
MIME-Version: 1.0
Subject: xfs shutdown with 2.6.27-rc4 
Content-Type: multipart/mixed;
 boundary="------------080804060204060506030502"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------080804060204060506030502
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



hello,

i'm having a strange problem with our new storage cluster, i've read
nearly every xfs related threads (which contained:"called from line 1164
of file fs/xfs/xfs_trans.c" - i've surprised that the line number gives
very accurate results - and helps to omit old problems )

i've rsynced more than 4T of data into the system (and i've hit the
xfs-rsync bug, but it's working now without any problems)

problem occurs when copying simultaniously from windows/linux boxes to
the filesystem thru samba causes the crashes.

with older kernels the whole system crashed, with circular locking
problems (similar:http://oss.sgi.com/archives/xfs/2008-08/msg00354.html
) but with 2.6.27-rc4, it's just shutdows the filesystem, and i'm able
to remount it.

the biggest problem is that i can't cause the system to crash with tests
 - i'm currently copying kernel trees in parrallel

i'm not sure that this is an xfs bug, because: rsync worked, and when i
tweaked the proc values and run test after test, it doesn't crashed.

the setup is:
node:(x8)
	kernel:2.6.27-rc4
	raid5
	dmcrypt
	iscsi_target (0.4.16)

master:
	kernel:2.6.27-rc4
	openiscsid (2.0-870)
	raid5
	xfs
	samba	(3.0.24-6etch10)





$ xfs_info /dev/md3
meta-data=/dev/md3           isize=256    agcount=128, agsize=26718592 blks
         =                   sectsz=4096  attr=1
data     =                   bsize=4096   blocks=3418704352, imaxpct=25
         =                   sunit=128    swidth=896 blks, unwritten=1
naming   =version 2          bsize=4096
log      =internal           bsize=4096   blocks=32768, version=2
         =                   sectsz=4096  sunit=1 blks
realtime =none               extsz=458752 blocks=0, rtextents=0


- --
Nagy Zoltan (kirk) <kirk@bteam.hu>
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkix2fsACgkQLcjF8xTqkoBrvwCg22IjkGT3WRVNCRBIDp56CTNw
uZYAoK7pImMY7efqaxwKqhV0H5hDYdUT
=Zg5Z
-----END PGP SIGNATURE-----

--------------080804060204060506030502
Content-Type: text/plain;
 name="wiki.trace3"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="wiki.trace3"

XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1736 of file fs/xfs/xfs_bmap.c.  Caller 0xc034b05f
Pid: 18801, comm: pdflush Not tainted 2.6.27-rc4 #4
 [<c03473f8>] xfs_bmap_add_extent_unwritten_real+0x1498/0x16a0
 [<c034b05f>] xfs_bmap_add_extent+0x45f/0x560
 [<c033a127>] xfs_alloc_vextent+0x267/0x4f0
 [<c038704c>] xfs_trans_log_inode+0x1c/0x50
 [<c034b05f>] xfs_bmap_add_extent+0x45f/0x560
 [<c034f46b>] xfs_bmapi+0x9db/0x15f0
 [<c0344cd8>] xfs_bmap_search_multi_extents+0x98/0xe0
 [<c0372fae>] xfs_iomap_write_allocate+0x2de/0x490
 [<c0374114>] xfs_iomap+0x334/0x410
 [<c038f784>] xfs_map_blocks+0x44/0x90
 [<c0390c16>] xfs_page_state_convert+0x536/0x790
 [<c0390fb0>] xfs_vm_writepage+0x60/0x100
 [<c01610a8>] __writepage+0x8/0x30
 [<c0161615>] write_cache_pages+0x225/0x340
 [<c01610a0>] __writepage+0x0/0x30
 [<c03f8cb3>] submit_bio+0x63/0xf0
 [<c0161750>] generic_writepages+0x20/0x30
 [<c016178b>] do_writepages+0x2b/0x50
 [<c01a1196>] __writeback_single_inode+0x86/0x310
 [<c0385dc6>] xfs_trans_first_ail+0x16/0x30
 [<c0376bca>] xfs_log_need_covered+0x6a/0xb0
 [<c01a17fe>] generic_sync_sb_inodes+0x1de/0x2c0
 [<c01a1c77>] writeback_inodes+0x87/0xb0
 [<c0162135>] wb_kupdate+0x85/0xf0
 [<c0162590>] pdflush+0x0/0x1b0
 [<c016267e>] pdflush+0xee/0x1b0
 [<c01620b0>] wb_kupdate+0x0/0xf0
 [<c01387c2>] kthread+0x42/0x70
 [<c0138780>] kthread+0x0/0x70
 [<c0103c1b>] kernel_thread_helper+0x7/0x1c
 =======================
Filesystem "md3": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs_trans.c.  Caller 0xc0373074
Pid: 18801, comm: pdflush Not tainted 2.6.27-rc4 #4
 [<c0385439>] xfs_trans_cancel+0xe9/0x110
 [<c0373074>] xfs_iomap_write_allocate+0x3a4/0x490
 [<c0373074>] xfs_iomap_write_allocate+0x3a4/0x490
 [<c0374114>] xfs_iomap+0x334/0x410
 [<c038f784>] xfs_map_blocks+0x44/0x90
 [<c0390c16>] xfs_page_state_convert+0x536/0x790
 [<c0390fb0>] xfs_vm_writepage+0x60/0x100
 [<c01610a8>] __writepage+0x8/0x30
 [<c0161615>] write_cache_pages+0x225/0x340
 [<c01610a0>] __writepage+0x0/0x30
 [<c03f8cb3>] submit_bio+0x63/0xf0
 [<c0161750>] generic_writepages+0x20/0x30
 [<c016178b>] do_writepages+0x2b/0x50
 [<c01a1196>] __writeback_single_inode+0x86/0x310
 [<c0385dc6>] xfs_trans_first_ail+0x16/0x30
 [<c0376bca>] xfs_log_need_covered+0x6a/0xb0
 [<c01a17fe>] generic_sync_sb_inodes+0x1de/0x2c0
 [<c01a1c77>] writeback_inodes+0x87/0xb0
 [<c0162135>] wb_kupdate+0x85/0xf0
 [<c0162590>] pdflush+0x0/0x1b0
 [<c016267e>] pdflush+0xee/0x1b0
 [<c01620b0>] wb_kupdate+0x0/0xf0
 [<c01387c2>] kthread+0x42/0x70
 [<c0138780>] kthread+0x0/0x70
 [<c0103c1b>] kernel_thread_helper+0x7/0x1c
 =======================
xfs_force_shutdown(md3,0x8) called from line 1165 of file fs/xfs/xfs_trans.c.  Return address = 0xc0385451
Filesystem "md3": Corruption of in-memory data detected.  Shutting down filesystem: md3
Please umount the filesystem, and rectify the problem(s)
Filesystem "md3": xfs_log_force: error 5 returned.
Filesystem "md3": xfs_log_force: error 5 returned.

--------------080804060204060506030502
Content-Type: text/plain;
 name="wiki.trace2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="wiki.trace2"

Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1af
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1af
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1af
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1ac
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1ac
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1ac
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a9
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a9
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a9
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: f4
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: f4
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: f5
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: f5
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: f6
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: f6
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: f7
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: f7
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: f8
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: f8
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: f9
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: f9
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: fa
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: fa
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: fb
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: fb
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: fc
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: fc
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: fd
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: fd
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: fe
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: fe
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: ff
Filesystem "md3": Access to block zero in inode 537262150 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: ff
Filesystem "md3": XFS internal error xfs_trans_cancel at line 1163 of file fs/xfs/xfs_trans.c.  Caller 0xc035db84
Pid: 18598, comm: pdflush Not tainted 2.6.26.3 #2
 [<c0370119>] xfs_trans_cancel+0xe9/0x110
 [<c035db84>] xfs_iomap_write_allocate+0x3a4/0x490
 [<c035db84>] xfs_iomap_write_allocate+0x3a4/0x490
 [<c035ec24>] xfs_iomap+0x334/0x410
 [<c037af94>] xfs_map_blocks+0x44/0x90
 [<c037c8df>] xfs_page_state_convert+0x53f/0x7a0
 [<c037cc80>] xfs_vm_writepage+0x60/0x100
 [<c0154cb8>] __writepage+0x8/0x30
 [<c0155235>] write_cache_pages+0x215/0x300
 [<c0154cb0>] __writepage+0x0/0x30
 [<c0155340>] generic_writepages+0x20/0x30
 [<c015537b>] do_writepages+0x2b/0x50
 [<c0192c86>] __writeback_single_inode+0x86/0x310
 [<c01208d7>] hrtick_set+0x67/0x110
 [<c0155516>] get_dirty_limits+0x16/0x2c0
 [<c01932de>] sync_sb_inodes+0x1ce/0x2b0
 [<c0193741>] writeback_inodes+0x91/0xc0
 [<c0155d23>] background_writeout+0x93/0xc0
 [<c0156260>] pdflush+0x0/0x1b0
 [<c015634e>] pdflush+0xee/0x1b0
 [<c0155c90>] background_writeout+0x0/0xc0
 [<c0137062>] kthread+0x42/0x70
 [<c0137020>] kthread+0x0/0x70
 [<c0103aa3>] kernel_thread_helper+0x7/0x14
 =======================
xfs_force_shutdown(md3,0x8) called from line 1164 of file fs/xfs/xfs_trans.c.  Return address = 0xc0370131
Filesystem "md3": Corruption of in-memory data detected.  Shutting down filesystem: md3
Please umount the filesystem, and rectify the problem(s)
BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<c037dbd9>] xfs_buf_delwri_split+0x59/0xf0
*pdpt = 00000000334b0001 *pde = 0000000000000000
Oops: 0000 [#1] SMP
Modules linked in: iscsi_tcp libiscsi scsi_transport_iscsi

Pid: 927, comm: xfsbufd Not tainted (2.6.26.3 #2)
EIP: 0060:[<c037dbd9>] EFLAGS: 00010282 CPU: 1
EIP is at xfs_buf_delwri_split+0x59/0xf0
EAX: 00000000 EBX: f5037cc0 ECX: 00000000 EDX: 00000000
ESI: ffffffdc EDI: f2501fbc EBP: f35003b0 ESP: f2501f98
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process xfsbufd (pid: 927, ti=f2500000 task=f30cd440 task.ti=f2500000)
Stack: 00001194 f35003b8 00000001 00000000 00001194 00000000 f2501fbc f3500380
       c037ecf0 f2501fbc f2501fbc fffffffc f3500380 c037ec90 00000000 c0137062
       c0137020 00000000 00000000 c0103aa3 f24ffdc0 00000000 00000000 00000000
Call Trace:
 [<c037ecf0>] xfsbufd+0x60/0x100
 [<c037ec90>] xfsbufd+0x0/0x100
 [<c0137062>] kthread+0x42/0x70
 [<c0137020>] kthread+0x0/0x70
 [<c0103aa3>] kernel_thread_helper+0x7/0x14
 =======================
Code: 7e e3 2e 00 8b 43 30 31 c9 8d 58 dc 39 c5 8b 53 24 89 4c 24 08 0f 84 7e 00 00 00 8d 72 dc eb 15 89 f6 ff 44 24 08 8d 46 24 39 c5 <8b> 56 24 74 69 89 f3 8d 72 dc 89 d8 e8 96 f1 ff ff 85 c0 75 e2
EIP: [<c037dbd9>] xfs_buf_delwri_split+0x59/0xf0 SS:ESP 0068:f2501f98
---[ end trace 6879b7e6cabe4008 ]---
Filesystem "md3": xfs_log_force: error 5 returned.
Filesystem "md3": xfs_log_force: error 5 returned.

--------------080804060204060506030502--
