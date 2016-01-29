Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 704497CA2
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 17:05:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 00A11AC003
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 15:05:36 -0800 (PST)
Received: from mga04.intel.com ([192.55.52.120]) by cuda.sgi.com with ESMTP id
	04t7VWIkaDlf0ltx for <xfs@oss.sgi.com>;
	Fri, 29 Jan 2016 15:05:35 -0800 (PST)
Date: Fri, 29 Jan 2016 16:05:31 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: real-time device BUG
Message-ID: <20160129230531.GA29895@linux.intel.com>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>

Today I was trying to get real-time devices working with XFS, and both a
manual pwrite() to a real-time device and xfs_rtcp end up with a lockdep spat
followed by a kernel BUG.  This behavior is consistent between kernel versions
v4.4 and v4.5-rc1.  I initially found this using some pmem block devices, but
it also happens with BRD.

Here is the sequence for the xfs_rtcp splat and a pair of 4GiB BRD devices on
v4.5-rc1 since that is probably easiest to reproduce:

  # fdisk -l /dev/ram*
  Disk /dev/ram0: 4 GiB, 4294967296 bytes, 8388608 sectors
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 4096 bytes
  I/O size (minimum/optimal): 4096 bytes / 4096 bytes
  Disk /dev/ram1: 4 GiB, 4294967296 bytes, 8388608 sectors
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 4096 bytes
  I/O size (minimum/optimal): 4096 bytes / 4096 bytes
  
  # mkfs.xfs -f -r rtdev=/dev/ram0 /dev/ram1
  meta-data=/dev/ram1              isize=512    agcount=4, agsize=262144 blks
           =                       sectsz=4096  attr=2, projid32bit=1
           =                       crc=1        finobt=1, sparse=0
  data     =                       bsize=4096   blocks=1048576, imaxpct=25
           =                       sunit=0      swidth=0 blks
  naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
  log      =internal log           bsize=4096   blocks=2560, version=2
           =                       sectsz=4096  sunit=1 blks, lazy-count=1
  realtime =/dev/ram0              extsz=4096   blocks=1048576, rtextents=1048576

  # mount -t xfs -o rtdev=/dev/ram0 /dev/ram1 /mnt
  
  # mount | grep '/mnt'
  /dev/ram1 on /mnt type xfs (rw,relatime,seclabel,attr2,inode64,rtdev=/dev/ram0,noquota)
  
  # xfs_rtcp ~/data /mnt/
  xfs_rtcp: /root/data is not a realtime file.
  Segmentation fault

Where ~/data is some random data of 31 MiB in size.

Here's the lockdep splat and BUG:

[  103.664626] XFS (ram1): Mounting V5 Filesystem
[  103.672209] XFS (ram1): Ending clean mount
[  135.034912] 
[  135.035304] =============================================
[  135.036268] [ INFO: possible recursive locking detected ]
[  135.037605] 4.5.0-rc1 #9 Not tainted
[  135.038423] ---------------------------------------------
[  135.039026] xfs_rtcp/1575 is trying to acquire lock:
[  135.039540]  (&xfs_nondir_ilock_class){++++..}, at: [<ffffffff81484272>] xfs_ilock+0x1a2/0x1f0
[  135.040551] 
[  135.040551] but task is already holding lock:
[  135.041152]  (&xfs_nondir_ilock_class){++++..}, at: [<ffffffff81484272>] xfs_ilock+0x1a2/0x1f0
[  135.042066] 
[  135.042066] other info that might help us debug this:
[  135.042730]  Possible unsafe locking scenario:
[  135.042730] 
[  135.043335]        CPU0
[  135.043587]        ----
[  135.043839]   lock(&xfs_nondir_ilock_class);
[  135.044289]   lock(&xfs_nondir_ilock_class);
[  135.044733] 
[  135.044733]  *** DEADLOCK ***
[  135.044733] 
[  135.045323]  May be due to missing lock nesting notation
[  135.045323] 
[  135.045989] 5 locks held by xfs_rtcp/1575:
[  135.046403]  #0:  (sb_writers#15){.+.+.+}, at: [<ffffffff8124c214>] __sb_start_write+0xb4/0xf0
[  135.047317]  #1:  (&sb->s_type->i_mutex_key#18){+.+.+.}, at: [<ffffffff81477d09>] xfs_file_dio_aio_write+0xa9/0x3e0
[  135.048413]  #2:  (&(&ip->i_iolock)->mr_lock){+++++.}, at: [<ffffffff81484222>] xfs_ilock+0x152/0x1f0
[  135.049415]  #3:  (sb_internal#2){.+.+.+}, at: [<ffffffff8124c1d8>] __sb_start_write+0x78/0xf0
[  135.050338]  #4:  (&xfs_nondir_ilock_class){++++..}, at: [<ffffffff81484272>] xfs_ilock+0x1a2/0x1f0
[  135.051278] 
[  135.051278] stack backtrace:
[  135.051709] CPU: 0 PID: 1575 Comm: xfs_rtcp Not tainted 4.5.0-rc1 #9
[  135.052340] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.8.2-20150714_191134- 04/01/2014
[  135.053279]  0000000000000000 00000000a6b2eb4a ffff88003651b5b0 ffffffff8155f5e2
[  135.054043]  ffffffff82f22840 ffff88003651b6a0 ffffffff810f4edb ffffffff8102336e
[  135.054807]  ffff88003651b618 0000000000000046 0000000000000000 00000000810635de
[  135.055579] Call Trace:
[  135.055830]  [<ffffffff8155f5e2>] dump_stack+0x44/0x62
[  135.056348]  [<ffffffff810f4edb>] __lock_acquire+0x1b3b/0x1b70
[  135.056937]  [<ffffffff8102336e>] ? kernel_fpu_end+0xe/0x10
[  135.057497]  [<ffffffff810f1ef6>] ? check_usage+0x96/0x590
[  135.058028]  [<ffffffff810f587f>] lock_acquire+0xaf/0x130
[  135.058575]  [<ffffffff81484272>] ? xfs_ilock+0x1a2/0x1f0
[  135.059112]  [<ffffffff8146d48c>] ? xfs_bmap_rtalloc+0x12c/0x350
[  135.059704]  [<ffffffff810ede1b>] down_write_nested+0x4b/0xb0
[  135.060270]  [<ffffffff81484272>] ? xfs_ilock+0x1a2/0x1f0
[  135.060795]  [<ffffffff81484272>] xfs_ilock+0x1a2/0x1f0
[  135.061311]  [<ffffffff8146d48c>] xfs_bmap_rtalloc+0x12c/0x350
[  135.061886]  [<ffffffff814306f8>] ? xfs_bmap_search_extents+0x78/0x100
[  135.062532]  [<ffffffff8143729b>] xfs_bmap_alloc+0x2b/0x30
[  135.063070]  [<ffffffff814389f2>] xfs_bmapi_write+0x6f2/0xf40
[  135.063644]  [<ffffffff81480c50>] xfs_iomap_write_direct+0x2c0/0x410
[  135.064273]  [<ffffffff8146a9ee>] __xfs_get_blocks+0x19e/0x9b0
[  135.064843]  [<ffffffff810f304d>] ? trace_hardirqs_on+0xd/0x10
[  135.065422]  [<ffffffff8146b237>] xfs_get_blocks_direct+0x17/0x20
[  135.066034]  [<ffffffff8128e951>] do_blockdev_direct_IO+0xa91/0x2fe0
[  135.066664]  [<ffffffff81223c29>] ? kmem_cache_free+0xa9/0x270
[  135.067240]  [<ffffffff8146b220>] ? xfs_get_blocks+0x20/0x20
[  135.067796]  [<ffffffff81290ee3>] __blockdev_direct_IO+0x43/0x50
[  135.068399]  [<ffffffff81468f50>] ? xfs_end_io+0xb0/0xb0
[  135.068920]  [<ffffffff814689b1>] xfs_vm_direct_IO+0xc1/0x120
[  135.069489]  [<ffffffff81468f50>] ? xfs_end_io+0xb0/0xb0
[  135.070008]  [<ffffffff81477e5d>] xfs_file_dio_aio_write+0x1fd/0x3e0
[  135.070636]  [<ffffffff81478349>] xfs_file_write_iter+0x99/0x150
[  135.071270]  [<ffffffff8124866c>] __vfs_write+0xcc/0x110
[  135.071787]  [<ffffffff81248f0c>] vfs_write+0xac/0x1a0
[  135.072296]  [<ffffffff8126a426>] ? __fget_light+0x66/0x90
[  135.072835]  [<ffffffff81249e88>] SyS_write+0x58/0xd0
[  135.073338]  [<ffffffff81a50e72>] entry_SYSCALL_64_fastpath+0x12/0x76
[  135.077170] XFS: Assertion failed: xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL), file: fs/xfs/libxfs/xfs_bmap.c, line: 4039
[  135.078379] ------------[ cut here ]------------
[  135.078848] kernel BUG at fs/xfs/xfs_message.c:113!
[  135.079334] invalid opcode: 0000 [#1] SMP 
[  135.079762] Modules linked in: nd_pmem nd_btt nd_e820 libnvdimm
[  135.080405] CPU: 0 PID: 1575 Comm: xfs_rtcp Not tainted 4.5.0-rc1 #9
[  135.081024] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.8.2-20150714_191134- 04/01/2014
[  135.081963] task: ffff8800baa8e000 ti: ffff880036518000 task.ti: ffff880036518000
[  135.082716] RIP: 0010:[<ffffffff8148bfd0>]  [<ffffffff8148bfd0>] assfail+0x20/0x30
[  135.083479] RSP: 0018:ffff88003651b488  EFLAGS: 00010246
[  135.083997] RAX: 0000000000000000 RBX: ffff88003651b56c RCX: 0000000000000000
[  135.084698] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff81ee0d88
[  135.085399] RBP: ffff88003651b488 R08: 0000000000000000 R09: 0000000000000000
[  135.086092] R10: 000000000000000a R11: f000000000000000 R12: 0000000000000000
[  135.086788] R13: ffff8801f85a8f80 R14: ffff8800ac988000 R15: 0000000000000000
[  135.087486] FS:  00007f287a6ce700(0000) GS:ffff88041a000000(0000) knlGS:0000000000000000
[  135.088282] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  135.088834] CR2: 00007f59a07f9000 CR3: 00000000aca05000 CR4: 00000000000006f0
[  135.089533] Stack:
[  135.089736]  ffff88003651b548 ffffffff814376db ffffffff82249420 0000000000000000
[  135.090510]  000000000000a52b ffff88003651b588 0000000000000001 0000000000000000
[  135.091271]  ffff88003651b500 00000000810ed803 ffffffff810ed745 0000000000000000
[  135.092025] Call Trace:
[  135.092277]  [<ffffffff814376db>] xfs_bmapi_read+0xcb/0x3b0
[  135.092820]  [<ffffffff810ed745>] ? cpuacct_charge+0x5/0x190
[  135.093377]  [<ffffffff810db936>] ? update_curr+0x66/0x180
[  135.093907]  [<ffffffff814673da>] xfs_rtbuf_get+0x5a/0x130
[  135.094448]  [<ffffffff810cd27b>] ? finish_task_switch+0x6b/0x250
[  135.095036]  [<ffffffff81467b43>] xfs_rtmodify_summary_int+0x93/0x120
[  135.095665]  [<ffffffff810cd27b>] ? finish_task_switch+0x6b/0x250
[  135.096261]  [<ffffffff814b3b72>] xfs_rtallocate_extent_size+0xf2/0x3c0
[  135.096904]  [<ffffffff81494e81>] ? kmem_zone_alloc+0x81/0x120
[  135.097472]  [<ffffffff81222d50>] ? kmem_cache_alloc+0xd0/0x1e0
[  135.098040]  [<ffffffff81494e81>] ? kmem_zone_alloc+0x81/0x120
[  135.098622]  [<ffffffff814b4888>] xfs_rtallocate_extent+0x1f8/0x260
[  135.099253]  [<ffffffff8146d51a>] xfs_bmap_rtalloc+0x1ba/0x350
[  135.099820]  [<ffffffff8143729b>] xfs_bmap_alloc+0x2b/0x30
[  135.100361]  [<ffffffff814389f2>] xfs_bmapi_write+0x6f2/0xf40
[  135.100921]  [<ffffffff81480c50>] xfs_iomap_write_direct+0x2c0/0x410
[  135.101545]  [<ffffffff8146a9ee>] __xfs_get_blocks+0x19e/0x9b0
[  135.102116]  [<ffffffff810f304d>] ? trace_hardirqs_on+0xd/0x10
[  135.102682]  [<ffffffff8146b237>] xfs_get_blocks_direct+0x17/0x20
[  135.103279]  [<ffffffff8128e951>] do_blockdev_direct_IO+0xa91/0x2fe0
[  135.103892]  [<ffffffff81223c29>] ? kmem_cache_free+0xa9/0x270
[  135.104466]  [<ffffffff8146b220>] ? xfs_get_blocks+0x20/0x20
[  135.105011]  [<ffffffff81290ee3>] __blockdev_direct_IO+0x43/0x50
[  135.105601]  [<ffffffff81468f50>] ? xfs_end_io+0xb0/0xb0
[  135.106120]  [<ffffffff814689b1>] xfs_vm_direct_IO+0xc1/0x120
[  135.106673]  [<ffffffff81468f50>] ? xfs_end_io+0xb0/0xb0
[  135.107211]  [<ffffffff81477e5d>] xfs_file_dio_aio_write+0x1fd/0x3e0
[  135.107828]  [<ffffffff81478349>] xfs_file_write_iter+0x99/0x150
[  135.108425]  [<ffffffff8124866c>] __vfs_write+0xcc/0x110
[  135.108942]  [<ffffffff81248f0c>] vfs_write+0xac/0x1a0
[  135.109451]  [<ffffffff8126a426>] ? __fget_light+0x66/0x90
[  135.109989]  [<ffffffff81249e88>] SyS_write+0x58/0xd0
[  135.110488]  [<ffffffff81a50e72>] entry_SYSCALL_64_fastpath+0x12/0x76
[  135.111118] Code: 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 f1 41 89 d0 48 c7 c6 c0 4d f2 81 48 89 fa 31 ff 48 89 e5 e8 b0 f8 ff ff <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 
[  135.113646] RIP  [<ffffffff8148bfd0>] assfail+0x20/0x30
[  135.114177]  RSP <ffff88003651b488>
[  135.114541] ---[ end trace 8e97f4b936072524 ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
