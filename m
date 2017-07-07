Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59460 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752490AbdGGMCM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Jul 2017 08:02:12 -0400
Date: Fri, 7 Jul 2017 20:01:43 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: [BUG] sb_fdblocks counting error caused by too large indlen returned
 from xfs_bmap_worst_indlen()
Message-ID: <20170707120040.GG29475@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>

Hi all,

I recently hit a repeatable sb_fdblocks corruption as below:

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
sb_fdblocks 14538692, counted 14669764
        - found root inode chunk
Phase 3 - for each AG...
...

And the count diff is always 14669764 - 14538692 = 131072 (128k). The
XFS in question was formated with "-m rmapbt=1 -b 1k" option.

After turning on XFS_WARN and adding some debug printks (I appended the
detailed logs at the end of mail), I found that this was caused by too
large 'indlen' returned by xfs_bmap_worst_indlen(), which can't fit in a
17 bits value (STARTBLOCKVALBITS is defined as 17), so the assert in
nullstartblock() failed: ASSERT(k < (1 << STARTBLOCKVALBITS));

>From the log, newlen = 151513, which needs 18 bits, so nullstartblock()
throws away the 18th bit, and the sb_fdblocks difference is always 2^17
= 131072.

To reproduce this, you need to keep enough dirty data in memory, so that
you can keep a large enough delay allocated extent in memory (not
converted to allocated by writeback thread), then speculative
preallocation could allocate large number of blocks based on the
existing extent size.

I first saw this by running xfs/217 on a ppc64 host with 18G memory, and
the default vm.dirty_background_ratio is 10, so it could keep around
1.8G dirty memory. Now I can reproduce by tuning
vm.dirty_background_ratio and vm.dirty_ratio on a x86_64 host with 4G
memory.

---- 8< ----
#!/bin/bash
dev=/dev/sdc1
mnt=/mnt/xfs

# write 1G file
size=$((1024*1024*1024))

echo 90 > /proc/sys/vm/dirty_background_ratio
echo 90 > /proc/sys/vm/dirty_ratio

mkfs -t xfs -m rmapbt=1 -b size=1k -f $dev
mount $dev $mnt

xfs_io -fc "pwrite -b 1m 0 $size" $mnt/testfile
umount $mnt

xfs_repair -n $dev
exit $?
---- >8 ----

This is uncovered by commit fd26a88093ba ("xfs: factor rmap btree size
into the indlen calculations"), which adds worst-case size of rmapbt
into account. But I'm not sure what's the best fix.

BTW, what are these magic numbers? What's the reason behind
STARTBLOCKVALBITS being 17? I can't find any explanation..

#define STARTBLOCKVALBITS       17
#define STARTBLOCKMASKBITS      (15 + 20)

Thanks,
Eryu

[11342.901613] XFS (sdc7): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[11342.911072] XFS (sdc7): Mounting V5 Filesystem
[11342.949401] XFS (sdc7): Ending clean mount
[11342.962794] xfs_bmap_add_extent_hole_delay: oldlen(323) = startblockval(left.br_startblock)(90) + startblockval(new->br_startblock)(233)
[11342.975049] xfs_bmap_add_extent_hole_delay: temp(4032) = left.br_blockcount(1024) + new->br_blockcount(3008)
[11342.984871] xfs_bmap_add_extent_hole_delay: xfs_bmap_worst_indlen(temp) = 308
[11342.992005] xfs_bmap_add_extent_hole_delay: newlen = 308
[11342.999286] xfs_bmap_add_extent_hole_delay: oldlen(620) = startblockval(left.br_startblock)(308) + startblockval(new->br_startblock)(312)
[11343.011626] xfs_bmap_add_extent_hole_delay: temp(8128) = left.br_blockcount(4032) + new->br_blockcount(4096)
[11343.021446] xfs_bmap_add_extent_hole_delay: xfs_bmap_worst_indlen(temp) = 603
[11343.028578] xfs_bmap_add_extent_hole_delay: newlen = 603
[11343.036615] xfs_bmap_add_extent_hole_delay: oldlen(1211) = startblockval(left.br_startblock)(603) + startblockval(new->br_startblock)(608)
[11343.049041] xfs_bmap_add_extent_hole_delay: temp(16320) = left.br_blockcount(8128) + new->br_blockcount(8192)
[11343.058951] xfs_bmap_add_extent_hole_delay: xfs_bmap_worst_indlen(temp) = 1194
[11343.066170] xfs_bmap_add_extent_hole_delay: newlen = 1194
[11343.077016] xfs_bmap_add_extent_hole_delay: oldlen(2393) = startblockval(left.br_startblock)(1194) + startblockval(new->br_startblock)(1199)
[11343.089617] xfs_bmap_add_extent_hole_delay: temp(32704) = left.br_blockcount(16320) + new->br_blockcount(16384)
[11343.099699] xfs_bmap_add_extent_hole_delay: xfs_bmap_worst_indlen(temp) = 2380
[11343.106919] xfs_bmap_add_extent_hole_delay: newlen = 2380
[11343.123254] xfs_bmap_add_extent_hole_delay: oldlen(4764) = startblockval(left.br_startblock)(2380) + startblockval(new->br_startblock)(2384)
[11343.135855] xfs_bmap_add_extent_hole_delay: temp(65472) = left.br_blockcount(32704) + new->br_blockcount(32768)
[11343.145936] xfs_bmap_add_extent_hole_delay: xfs_bmap_worst_indlen(temp) = 4746
[11343.153156] xfs_bmap_add_extent_hole_delay: newlen = 4746
[11343.180360] xfs_bmap_add_extent_hole_delay: oldlen(9496) = startblockval(left.br_startblock)(4746) + startblockval(new->br_startblock)(4750)
[11343.192958] xfs_bmap_add_extent_hole_delay: temp(131008) = left.br_blockcount(65472) + new->br_blockcount(65536)
[11343.203131] xfs_bmap_add_extent_hole_delay: xfs_bmap_worst_indlen(temp) = 9480
[11343.210350] xfs_bmap_add_extent_hole_delay: newlen = 9480
[11343.259106] xfs_bmap_add_extent_hole_delay: oldlen(18964) = startblockval(left.br_startblock)(9480) + startblockval(new->br_startblock)(9484)
[11343.271793] xfs_bmap_add_extent_hole_delay: temp(262080) = left.br_blockcount(131008) + new->br_blockcount(131072)
[11343.282140] xfs_bmap_add_extent_hole_delay: xfs_bmap_worst_indlen(temp) = 18949
[11343.289446] xfs_bmap_add_extent_hole_delay: newlen = 18949
[11343.381338] xfs_bmap_add_extent_hole_delay: oldlen(37903) = startblockval(left.br_startblock)(18949) + startblockval(new->br_startblock)(18954)
[11343.394196] xfs_bmap_add_extent_hole_delay: temp(524224) = left.br_blockcount(262080) + new->br_blockcount(262144)
[11343.404545] xfs_bmap_add_extent_hole_delay: xfs_bmap_worst_indlen(temp) = 37887
[11343.411852] xfs_bmap_add_extent_hole_delay: newlen = 37887
[11343.590032] xfs_bmap_add_extent_hole_delay: oldlen(75779) = startblockval(left.br_startblock)(37887) + startblockval(new->br_startblock)(37892)
[11343.602892] xfs_bmap_add_extent_hole_delay: temp(1048512) = left.br_blockcount(524224) + new->br_blockcount(524288)
[11343.613325] xfs_bmap_add_extent_hole_delay: xfs_bmap_worst_indlen(temp) = 75763
[11343.620630] xfs_bmap_add_extent_hole_delay: newlen = 75763
[11343.972010] xfs_bmap_add_extent_hole_delay: oldlen(151531) = startblockval(left.br_startblock)(75763) + startblockval(new->br_startblock)(75768)
[11343.984957] xfs_bmap_add_extent_hole_delay: temp(2097088) = left.br_blockcount(1048512) + new->br_blockcount(1048576)
[11343.995558] xfs_bmap_add_extent_hole_delay: xfs_bmap_worst_indlen(temp) = 151513
[11344.002952] xfs_bmap_add_extent_hole_delay: newlen = 151513
[11344.008528] XFS: Assertion failed: k < (1 << STARTBLOCKVALBITS), file: fs/xfs/libxfs/xfs_format.h, line: 1569
[11344.018456] ------------[ cut here ]------------
[11344.023142] WARNING: CPU: 1 PID: 7594 at fs/xfs/xfs_message.c:105 asswarn+0x22/0x30 [xfs]
[11344.031379] Modules linked in: xfs(OE) libcrc32c btrfs intel_powerclamp coretemp xor kvm_intel raid6_pq kvm irqbypass crc32_pclmul ghash_clmulni_intel iTCO_wdt iTCO_vendor_support pcbc cdc_ether aesni_intel sg ipmi_si crypto_simd pcspkr glue_helper lpc_ich usbnet i2c_i801 cryptd mfd_core mii ipmi_devintf ioatdma shpchp ipmi_msghandler i7core_edac dca acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables ext4 jbd2 mbcache sr_mod sd_mod cdrom mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm ata_generic pata_acpi drm ata_piix crc32c_intel libata megaraid_sas i2c_core bnx2 dm_mirror dm_region_hash dm_log dm_mod [last unloaded: xfs]
[11344.091315] CPU: 1 PID: 7594 Comm: xfs_io Tainted: G        W  OE   4.12.0 #102
[11344.098674] Hardware name: IBM System x3550 M3 -[7944OEJ]-/90Y4784     , BIOS -[D6E150CUS-1.11]- 02/08/2011
[11344.108423] task: ffff88017481ea40 task.stack: ffffc90003d14000
[11344.114460] RIP: 0010:asswarn+0x22/0x30 [xfs]
[11344.118881] RSP: 0018:ffffc90003d17ad0 EFLAGS: 00010282
[11344.124145] RAX: 00000000ffffffea RBX: 0000000000000051 RCX: 0000000000000021
[11344.131339] RDX: ffffc90003d179f8 RSI: 000000000000000a RDI: ffffffffa07d8b22
[11344.138470] RBP: ffffc90003d17ad0 R08: 0000000000000000 R09: 0000000000000000
[11344.145665] R10: 000000000000000a R11: f000000000000000 R12: ffff880143648000
[11344.152853] R13: ffffc90003d17c7c R14: 0000000000024fd9 R15: 0000000000024fd9
[11344.160047] FS:  00007fbe214f5740(0000) GS:ffff88017ba40000(0000) knlGS:0000000000000000
[11344.168190] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[11344.173989] CR2: 00007fbe214f2000 CR3: 0000000171bb2000 CR4: 00000000000006e0
[11344.181180] Call Trace:
[11344.183715]  xfs_bmap_add_extent_hole_delay+0x76b/0x7c0 [xfs]
[11344.189539]  ? xfs_mod_fdblocks+0xa6/0x1a0 [xfs]
[11344.194247]  xfs_bmapi_reserve_delalloc+0x263/0x310 [xfs]
[11344.199731]  ? xfs_bmbt_get_all+0x18/0x20 [xfs]
[11344.204354]  ? xfs_iext_get_extent+0x35/0x40 [xfs]
[11344.209240]  xfs_file_iomap_begin+0x658/0x8c0 [xfs]
[11344.214165]  ? iomap_write_end+0x38/0x80
[11344.218127]  iomap_apply+0x44/0xf0
[11344.221571]  iomap_file_buffered_write+0x68/0xa0
[11344.226225]  ? iomap_write_begin.constprop.16+0xf0/0xf0
[11344.231545]  xfs_file_buffered_aio_write+0xca/0x240 [xfs]
[11344.237009]  ? page_add_new_anon_rmap+0x89/0xc0
[11344.241631]  xfs_file_write_iter+0xfc/0x140 [xfs]
[11344.246405]  __vfs_write+0xc5/0x140
[11344.249936]  vfs_write+0xb2/0x1b0
[11344.253315]  ? syscall_trace_enter+0x1b7/0x290
[11344.257800]  SyS_pwrite64+0x69/0xa0
[11344.261294]  do_syscall_64+0x67/0x150
[11344.265021]  entry_SYSCALL64_slow_path+0x25/0x25
[11344.269682] RIP: 0033:0x7fbe210d5fb3
[11344.273262] RSP: 002b:00007ffd75b34778 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
[11344.280888] RAX: ffffffffffffffda RBX: 000000003ff00000 RCX: 00007fbe210d5fb3
[11344.288078] RDX: 0000000000100000 RSI: 00007fbe213f4000 RDI: 0000000000000003
[11344.295269] RBP: 00000000000003ff R08: 0000000000000000 R09: 0000000000101030
[11344.302419] R10: 000000003ff00000 R11: 0000000000000246 R12: 0000000000100000
[11344.309608] R13: 000000003ff00000 R14: 00000000ffffffff R15: 0000000000000000
[11344.316804] Code: 0f 0b 0f 1f 80 00 00 00 00 66 66 66 66 90 55 48 89 f1 41 89 d0 48 c7 c6 98 3a 7e a0 48 89 fa 31 c0 48 89 e5 31 ff e8 2e fd ff ff <0f> ff 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48
[11344.335722] ---[ end trace 812850ed381d73bb ]---
