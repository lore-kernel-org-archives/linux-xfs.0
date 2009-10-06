Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n96ED2QX068084 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 09:13:02 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1D561742E76
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2009 07:14:27 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id fZONXZHu7iACbX3F for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2009 07:14:27 -0700 (PDT)
Message-ID: <4ACB50C1.80702@sandeen.net>
Date: Tue, 06 Oct 2009 09:14:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: stack bloat after stackprotector changes
References: <4ACA5EB0.4010707@sandeen.net> <4ACADB74.5090508@kernel.org>
In-Reply-To: <4ACADB74.5090508@kernel.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Tejun Heo <tj@kernel.org>
Cc: xfs mailing list <xfs@oss.sgi.com>

Tejun Heo wrote:
> Eric Sandeen wrote:
>> It seems that after:
>>
>> commit 5d707e9c8ef2a3596ed5c975c6ff05cec890c2b4
>> Author: Tejun Heo <tj@kernel.org>
>> Date:   Mon Feb 9 22:17:39 2009 +0900
>>
>>     stackprotector: update make rules
>>
>> xfs stack usage jumped up a fair bit;
>>
>> Not a lot in each case but could be significant as it accumulates.
>>
>> I'm not familiar w/ the gcc stack protector feature; would this be an
>> expected result?
> 
> Yeah, it adds a bit of stack usage per each function call and around
> arrays which seem like they could overflow, so the behavior is
> expected and I can see it can be a problem with function call depth
> that deep.  Has it caused actual stack overflow?
> 
> Thanks.
> 

It's hard to point at one thing and say "that caused it" but I did 
overflow (or come very close to it - this one was within 8 bytes).

Add 20 byte or so to each of 65 calls and it starts to matter I guess.

Granted, xfs is being piggy too (as are some of the more common 
functions in the callchain - do_sync_write and write_cache_pages at 320 
bytes each...)

-Eric

          Depth    Size   Location    (65 entries)
          -----    ----   --------
    0)     7280      80   check_object+0x6c/0x1d3
    1)     7200     112   __slab_alloc+0x332/0x3f0
    2)     7088      16   kmem_cache_alloc+0xcb/0x18a
    3)     7072     112   mempool_alloc_slab+0x28/0x3e
    4)     6960     128   mempool_alloc+0x71/0x13c
    5)     6832      32   scsi_sg_alloc+0x5d/0x73
    6)     6800     128   __sg_alloc_table+0x6f/0x134
    7)     6672      64   scsi_alloc_sgtable+0x3b/0x74
    8)     6608      48   scsi_init_sgtable+0x34/0x8c
    9)     6560      80   scsi_init_io+0x3e/0x177
   10)     6480      48   scsi_setup_fs_cmnd+0x9c/0xb9
   11)     6432     160   sd_prep_fn+0x69/0x8bd
   12)     6272      64   blk_peek_request+0xf0/0x1c8
   13)     6208     112   scsi_request_fn+0x92/0x4c4
   14)     6096      48   __blk_run_queue+0x54/0x9a
   15)     6048      80   elv_insert+0xbd/0x1e0
   16)     5968      64   __elv_add_request+0xa7/0xc2
   17)     5904      64   blk_insert_cloned_request+0x90/0xc8
   18)     5840      48   dm_dispatch_request+0x4f/0x8b
   19)     5792      96   dm_request_fn+0x141/0x1ca
   20)     5696      48   __blk_run_queue+0x54/0x9a
   21)     5648      80   cfq_insert_request+0x39d/0x3d4
   22)     5568      80   elv_insert+0x120/0x1e0
   23)     5488      64   __elv_add_request+0xa7/0xc2
   24)     5424      96   __make_request+0x35e/0x3f1
   25)     5328      64   dm_request+0x55/0x234
   26)     5264     128   generic_make_request+0x29e/0x2fc
   27)     5136      80   submit_bio+0xe3/0x100
   28)     5056     112   _xfs_buf_ioapply+0x21d/0x25c [xfs]
   29)     4944      48   xfs_buf_iorequest+0x58/0x9f [xfs]
   30)     4896      48   _xfs_buf_read+0x45/0x74 [xfs]
   31)     4848      48   xfs_buf_read_flags+0x67/0xb5 [xfs]
   32)     4800     112   xfs_trans_read_buf+0x1be/0x2c2 [xfs]
   33)     4688     112   xfs_btree_read_buf_block+0x64/0xbc [xfs]
   34)     4576      96   xfs_btree_lookup_get_block+0x9c/0xd8 [xfs]
   35)     4480     192   xfs_btree_lookup+0x14a/0x408 [xfs]
   36)     4288      32   xfs_alloc_lookup_eq+0x2c/0x42 [xfs]
   37)     4256     112   xfs_alloc_fixup_trees+0x85/0x2b4 [xfs]
   38)     4144     176   xfs_alloc_ag_vextent_near+0x339/0x8e8 [xfs]
   39)     3968      48   xfs_alloc_ag_vextent+0x44/0x126 [xfs]
   40)     3920     128   xfs_alloc_vextent+0x2b1/0x403 [xfs]
   41)     3792     272   xfs_bmap_btalloc+0x4fc/0x6d4 [xfs]
   42)     3520      32   xfs_bmap_alloc+0x21/0x37 [xfs]
   43)     3488     464   xfs_bmapi+0x70b/0xde1 [xfs]
   44)     3024     256   xfs_iomap_write_allocate+0x21d/0x35d [xfs]
   45)     2768     192   xfs_iomap+0x208/0x28a [xfs]
   46)     2576      48   xfs_map_blocks+0x3d/0x5a [xfs]
   47)     2528     256   xfs_page_state_convert+0x2b8/0x589 [xfs]
   48)     2272      96   xfs_vm_writepage+0xbf/0x10e [xfs]
   49)     2176      48   __writepage+0x29/0x5f
   50)     2128     320   write_cache_pages+0x27b/0x415
   51)     1808      32   generic_writepages+0x38/0x4e
   52)     1776      80   xfs_vm_writepages+0x60/0x7f [xfs]
   53)     1696      48   do_writepages+0x3d/0x63
   54)     1648     144   writeback_single_inode+0x169/0x29d
   55)     1504     112   generic_sync_sb_inodes+0x21d/0x37f
   56)     1392      64   writeback_inodes+0xb6/0x125
   57)     1328     192   balance_dirty_pages_ratelimited_nr+0x172/0x2b0
   58)     1136     240   generic_file_buffered_write+0x240/0x33c
   59)      896     256   xfs_write+0x4d4/0x723 [xfs]
   60)      640      32   xfs_file_aio_write+0x79/0x8f [xfs]
   61)      608     320   do_sync_write+0xfa/0x14b
   62)      288      80   vfs_write+0xbd/0x12e
   63)      208      80   sys_write+0x59/0x91
   64)      128     128   system_call_fastpath+0x16/0x1b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
