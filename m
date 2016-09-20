Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CAD787CAF
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2016 11:33:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 911EB304043
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2016 09:33:07 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id EmmfC6ZGnIuie6mZ (version=TLSv1
	cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 20 Sep 2016 09:33:06 -0700 (PDT)
Date: Tue, 20 Sep 2016 10:33:04 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: kernel BUG at fs/xfs/xfs_message.c:113!
Message-ID: <20160920163304.GA8999@linux.intel.com>
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
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org

I'm consistently able to generate this kernel BUG with both v4.7 and v4.8-rc7.
This bug reproduces both with and without DAX.
Here is the BUG with v4.8-rc7, passed through kasan_symbolize.py:

  run fstests generic/026 at 2016-09-20 10:22:58
  XFS (pmem0p2): Unmounting Filesystem
  XFS: Assertion failed: tp->t_blk_res_used <= tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 309
  ------------[ cut here ]------------
  kernel BUG at fs/xfs/xfs_message.c:113!
  invalid opcode: 0000 [#1] SMP
  Modules linked in: nd_pmem dax_pmem nd_btt dax nd_e820 libnvdimm
  CPU: 4 PID: 2306 Comm: chacl Not tainted 4.8.0-rc7 #32
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.1-0-gb3ef39f-prebuilt.qemu-project.org 04/01/2014
  task: ffff8805d62b8000 task.stack: ffff88060bdc4000
  RIP: 0010:[<ffffffff814edce0>]  [<ffffffff814edce0>] assfail+0x20/0x30
  RSP: 0018:ffff88060bdc7610  EFLAGS: 00010246
  RAX: 0000000000000000 RBX: ffff88060cda8000 RCX: 0000000000000000
  RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff81eb0231
  RBP: ffff88060bdc7610 R08: 0000000000000000 R09: 0000000000000000
  R10: 000000000000000a R11: f000000000000000 R12: fffffffffffffe00
  R13: ffff880609ce4000 R14: 00000000000bff80 R15: 0000000000000000
  FS:  00007fe8621d9700(0000) GS:ffff880611000000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000001389000 CR3: 000000060c968000 CR4: 00000000001406e0
  Stack:
   ffff88060bdc7638 ffffffff814f5573 ffff88060bdc76e8 0000000000000010
   ffff88060bdc76e8 ffff88060bdc7650 ffffffff8146fc69 ffff880609ce4000
   ffff88060bdc76a0 ffffffff81471280 000000000bdc7878 0000000000000001
  Call Trace:
   [<ffffffff814f5573>] xfs_trans_mod_sb+0x263/0x2a0 fs/xfs/xfs_trans.c:309
   [<ffffffff8146fc69>] xfs_alloc_ag_vextent+0x1c9/0x2c0 fs/xfs/libxfs/xfs_alloc.c:736
   [<ffffffff81471280>] xfs_alloc_vextent+0x8b0/0xca0 fs/xfs/libxfs/xfs_alloc.c:2694
   [<ffffffff8148707e>] xfs_bmap_btalloc+0x2fe/0x880 fs/xfs/libxfs/xfs_bmap.c:3789
   [<ffffffff81487624>] xfs_bmap_alloc+0x24/0x30 fs/xfs/libxfs/xfs_bmap.c:3882
   [<     inline     >] xfs_bmapi_allocate fs/xfs/libxfs/xfs_bmap.c:4314
   [<ffffffff81488d82>] xfs_bmapi_write+0x6f2/0xf40 fs/xfs/libxfs/xfs_bmap.c:4601
   [<ffffffff8147bf87>] xfs_attr_rmtval_set+0x147/0x510 fs/xfs/libxfs/xfs_attr_remote.c:466
   [<ffffffff814735e9>] xfs_attr_leaf_addname+0x409/0x4e0 fs/xfs/libxfs/xfs_attr.c:628
   [<ffffffff81473935>] xfs_attr_set+0x275/0x480 fs/xfs/libxfs/xfs_attr.c:342
   [<ffffffff8151e9fd>] __xfs_set_acl+0xed/0x190 fs/xfs/xfs_acl.c:207
   [<ffffffff8151eb17>] xfs_set_acl+0x77/0x120 fs/xfs/xfs_acl.c:276
   [<ffffffff812f34bf>] set_posix_acl+0x6f/0xb0 fs/posix_acl.c:841
   [<ffffffff812f3bc5>] posix_acl_xattr_set+0x45/0x90 fs/posix_acl.c:859
   [<ffffffff812b0940>] generic_setxattr+0x70/0x80 fs/xattr.c:765
   [<ffffffff812b110f>] __vfs_setxattr_noperm+0xaf/0x1a0 fs/xattr.c:110
   [<ffffffff812b12a7>] vfs_setxattr+0xa7/0xb0 fs/xattr.c:144
   [<ffffffff812b13d9>] setxattr+0x129/0x190 fs/xattr.c:344
   [<ffffffff812b14ea>] path_setxattr+0xaa/0xe0 fs/xattr.c:363
   [<     inline     >] SYSC_setxattr fs/xattr.c:378
   [<ffffffff812b1634>] SyS_setxattr+0x14/0x20 fs/xattr.c:374
   [<ffffffff81af8d7c>] entry_SYSCALL_64_fastpath+0x1f/0xbd arch/x86/entry/entry_64.S:207
  Code: 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 f1 41 89 d0 48 c7 c6 d0 61 ef 81 48 89 fa 31 ff 48 89 e5 e8 b0 f8 ff ff <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90
  RIP  [<ffffffff814edce0>] assfail+0x20/0x30 fs/xfs/xfs_message.c:111
   RSP <ffff88060bdc7610>
  ---[ end trace 59f39750d449cf7e ]---

This is generated by generic/026:

  # ./check generic/026
  FSTYP         -- xfs (debug)
  PLATFORM      -- Linux/x86_64 alara 4.8.0-rc7
  MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem0p2
  MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem0p2 /mnt/xfstests_scratch
  
  generic/026 4s ...

I started hitting this issue when I started setting extsize via xfs_io on both
my TEST and SCRATCH xfstest directories.  Here's a quick snapshot of my
xfstests setup:

  # parted -s -a optimal /dev/pmem0 mkpart Primary 2MiB 12GiB
  # parted -s -a optimal /dev/pmem0 mkpart Primary 12GiB 16382MiB
  # mkfs.xfs -f /dev/pmem0p1
  # mkfs.xfs -f /dev/pmem0p2
  # mount /dev/pmem0p1 /mnt/xfstests_test
  # mount /dev/pmem0p2 /mnt/xfstests_scratch
  # xfs_io -c 'extsize 2m' /mnt/xfstests_test
  # xfs_io -c 'extsize 2m' /mnt/xfstests_scratch

Thanks,
- Ross

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
