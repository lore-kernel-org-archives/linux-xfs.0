Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 55E187CA1
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2016 19:26:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C24D8AC001
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2016 17:26:55 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	jm6hl6UYHCLkfyDS for <xfs@oss.sgi.com>;
	Mon, 27 Jun 2016 17:26:51 -0700 (PDT)
Date: Tue, 28 Jun 2016 10:26:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: iomap infrastructure and multipage writes V5
Message-ID: <20160628002649.GI12670@dastard>
References: <1464792297-13185-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1464792297-13185-1-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Jun 01, 2016 at 04:44:43PM +0200, Christoph Hellwig wrote:
> This series add a new file system I/O path that uses the iomap structure
> introduced for the pNFS support and support multi-page buffered writes.
> 
> This was first started by Dave Chinner a long time ago, then I did beat
> it into shape for production runs in a very constrained ARM NAS
> enviroment for Tuxera almost as long ago, and now half a dozen rewrites
> later it's back.
> 
> The basic idea is to avoid the per-block get_blocks overhead
> and make use of extents in the buffered write path by iterating over
> them instead.

Christoph, it look slike there's an ENOSPC+ENOMEM behavioural regression here.
generic/224 on my 1p/1GB RAM VM using a 1k lock size filesystem has
significantly different behaviour once ENOSPC is hit withi this patchset.

It ends up with an endless stream of errors like this:

[  687.530641] XFS (sdc): page discard on page ffffea0000197700, inode 0xb52c, offset 400338944.
[  687.539828] XFS (sdc): page discard on page ffffea0000197740, inode 0xb52c, offset 400343040.
[  687.549035] XFS (sdc): page discard on page ffffea0000197780, inode 0xb52c, offset 400347136.
[  687.558222] XFS (sdc): page discard on page ffffea00001977c0, inode 0xb52c, offset 400351232.
[  687.567391] XFS (sdc): page discard on page ffffea0000846000, inode 0xb52c, offset 400355328.
[  687.576602] XFS (sdc): page discard on page ffffea0000846040, inode 0xb52c, offset 400359424.
[  687.585794] XFS (sdc): page discard on page ffffea0000846080, inode 0xb52c, offset 400363520.
[  687.595005] XFS (sdc): page discard on page ffffea00008460c0, inode 0xb52c, offset 400367616.

Yeah, it's been going for ten minutes already, and it's reporting
this for every page on inode 0xb52c. df reports:

Filesystem     1K-blocks    Used Available Use% Mounted on
/dev/sdc         1038336 1038334         2 100% /mnt/scratch


So it's looking very much like the iomap write is allowing pages
through the write side rather than giving ENOSPC. i.e. the initial
alloc fails, it triggers a flush, which triggers a page discard,
which then allows the next write to proceed because it's free up
blocks. The trace looks like this

              dd-12284 [000]   983.936583: xfs_file_buffered_write: dev 8:32 ino 0xb52c size 0xa00000 offset 0x1f37a000 count 0x1000 ioflags 
              dd-12284 [000]   983.936584: xfs_ilock:            dev 8:32 ino 0xb52c flags ILOCK_EXCL caller 0xffffffff8150bb47s
              dd-12284 [000]   983.936585: xfs_iomap_prealloc_size: dev 8:32 ino 0xb52c prealloc blocks 64 shift 6 m_writeio_blocks 64
              dd-12284 [000]   983.936585: xfs_delalloc_enospc:  dev 8:32 ino 0xb52c isize 0x1f37a000 disize 0xa00000 offset 0x1f37a000 count 4096
              dd-12284 [000]   983.936586: xfs_delalloc_enospc:  dev 8:32 ino 0xb52c isize 0x1f37a000 disize 0xa00000 offset 0x1f37a000 count 4096
              dd-12284 [000]   983.936586: xfs_iunlock:          dev 8:32 ino 0xb52c flags ILOCK_EXCL caller 0xffffffff8150bc61s
    kworker/u2:0-6     [000]   983.946649: xfs_writepage:        dev 8:32 ino 0xb52c pgoff 0x1f379000 size 0x1f37a000 offset 0 length 0 delalloc 1 unwritten 0
    kworker/u2:0-6     [000]   983.946650: xfs_ilock:            dev 8:32 ino 0xb52c flags ILOCK_SHARED caller 0xffffffff814f4b49s
    kworker/u2:0-6     [000]   983.946651: xfs_iunlock:          dev 8:32 ino 0xb52c flags ILOCK_SHARED caller 0xffffffff814f4bf5s
    kworker/u2:0-6     [000]   983.948093: xfs_ilock:            dev 8:32 ino 0xb52c flags ILOCK_EXCL caller 0xffffffff814f555fs
    kworker/u2:0-6     [000]   983.948095: xfs_bunmap:           dev 8:32 ino 0xb52c size 0xa00000 bno 0x7cde4 len 0x1flags  caller 0xffffffff814f9123s
    kworker/u2:0-6     [000]   983.948096: xfs_bmap_pre_update:  dev 8:32 ino 0xb52c state  idx 0 offset 511460 block 4503599627239431 count 4 flag 0 caller 0xffffffff814c6ea3s
    kworker/u2:0-6     [000]   983.948097: xfs_bmap_post_update: dev 8:32 ino 0xb52c state  idx 0 offset 511461 block 4503599627239431 count 3 flag 0 caller 0xffffffff814c6f1es
    kworker/u2:0-6     [000]   983.948097: xfs_bunmap:           dev 8:32 ino 0xb52c size 0xa00000 bno 0x7cde5 len 0x1flags  caller 0xffffffff814f9123s
    kworker/u2:0-6     [000]   983.948098: xfs_bmap_pre_update:  dev 8:32 ino 0xb52c state  idx 0 offset 511461 block 4503599627239431 count 3 flag 0 caller 0xffffffff814c6ea3s
    kworker/u2:0-6     [000]   983.948098: xfs_bmap_post_update: dev 8:32 ino 0xb52c state  idx 0 offset 511462 block 4503599627239431 count 2 flag 0 caller 0xffffffff814c6f1es
    kworker/u2:0-6     [000]   983.948099: xfs_bunmap:           dev 8:32 ino 0xb52c size 0xa00000 bno 0x7cde6 len 0x1flags  caller 0xffffffff814f9123s
    kworker/u2:0-6     [000]   983.948099: xfs_bmap_pre_update:  dev 8:32 ino 0xb52c state  idx 0 offset 511462 block 4503599627239431 count 2 flag 0 caller 0xffffffff814c6ea3s
    kworker/u2:0-6     [000]   983.948100: xfs_bmap_post_update: dev 8:32 ino 0xb52c state  idx 0 offset 511463 block 4503599627239431 count 1 flag 0 caller 0xffffffff814c6f1es
    kworker/u2:0-6     [000]   983.948100: xfs_bunmap:           dev 8:32 ino 0xb52c size 0xa00000 bno 0x7cde7 len 0x1flags  caller 0xffffffff814f9123s
    kworker/u2:0-6     [000]   983.948101: xfs_iext_remove:      dev 8:32 ino 0xb52c state  idx 0 offset 511463 block 4503599627239431 count 1 flag 0 caller 0xffffffff814c6d2as
    kworker/u2:0-6     [000]   983.948101: xfs_iunlock:          dev 8:32 ino 0xb52c flags ILOCK_EXCL caller 0xffffffff814f55e8s
    kworker/u2:0-6     [000]   983.948102: xfs_invalidatepage:   dev 8:32 ino 0xb52c pgoff 0x1f379000 size 0x1f37a000 offset 0 length 1000 delalloc 1 unwritten 0
    kworker/u2:0-6     [000]   983.948102: xfs_releasepage:      dev 8:32 ino 0xb52c pgoff 0x1f379000 size 0x1f37a000 offset 0 length 0 delalloc 0 unwritten 0

[snip eof block scan locking]

              dd-12284 [000]   983.948239: xfs_file_buffered_write: dev 8:32 ino 0xb52c size 0xa00000 offset 0x1f37a000 count 0x1000 ioflags 
              dd-12284 [000]   983.948239: xfs_ilock:            dev 8:32 ino 0xb52c flags ILOCK_EXCL caller 0xffffffff8150bb47s
              dd-12284 [000]   983.948240: xfs_iomap_prealloc_size: dev 8:32 ino 0xb52c prealloc blocks 64 shift 0 m_writeio_blocks 64
              dd-12284 [000]   983.948242: xfs_delalloc_enospc:  dev 8:32 ino 0xb52c isize 0x1f37a000 disize 0xa00000 offset 0x1f37a000 count 4096
              dd-12284 [000]   983.948243: xfs_iext_insert:      dev 8:32 ino 0xb52c state  idx 0 offset 511464 block 4503599627239431 count 4 flag 0 caller 0xffffffff814c265as
              dd-12284 [000]   983.948243: xfs_iunlock:          dev 8:32 ino 0xb52c flags ILOCK_EXCL caller 0xffffffff8150bc61s
              dd-12284 [000]   983.948244: xfs_iomap_alloc:      dev 8:32 ino 0xb52c size 0xa00000 offset 0x1f37a000 count 4096 type invalid startoff 0x7cde8 startblock -1 blockcount 0x4
              dd-12284 [000]   983.948250: xfs_iunlock:          dev 8:32 ino 0xb52c flags IOLOCK_EXCL caller 0xffffffff81502378s
              dd-12284 [000]   983.948254: xfs_ilock:            dev 8:32 ino 0xb52c flags IOLOCK_EXCL caller 0xffffffff81502352s
              dd-12284 [000]   983.948256: xfs_update_time:      dev 8:32 ino 0xb52c
              dd-12284 [000]   983.948257: xfs_log_reserve:      dev 8:32 t_ocnt 0 t_cnt 0 t_curr_res 2860 t_unit_res 2860 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 956212 grant_write_cycle 1 grant_write_bytes 956212 curr_cycle 1 curr_block 1863 tail_cycle 1 tail_block 1861
              dd-12284 [000]   983.948257: xfs_log_reserve_exit: dev 8:32 t_ocnt 0 t_cnt 0 t_curr_res 2860 t_unit_res 2860 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 959072 grant_write_cycle 1 grant_write_bytes 959072 curr_cycle 1 curr_block 1863 tail_cycle 1 tail_block 1861
              dd-12284 [000]   983.948258: xfs_ilock:            dev 8:32 ino 0xb52c flags ILOCK_EXCL caller 0xffffffff8150c4dfs
              dd-12284 [000]   983.948260: xfs_log_done_nonperm: dev 8:32 t_ocnt 0 t_cnt 0 t_curr_res 2860 t_unit_res 2860 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 959072 grant_write_cycle 1 grant_write_bytes 959072 curr_cycle 1 curr_block 1863 tail_cycle 1 tail_block 1861
              dd-12284 [000]   983.948260: xfs_log_ungrant_enter: dev 8:32 t_ocnt 0 t_cnt 0 t_curr_res 2860 t_unit_res 2860 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 959072 grant_write_cycle 1 grant_write_bytes 959072 curr_cycle 1 curr_block 1863 tail_cycle 1 tail_block 1861
              dd-12284 [000]   983.948260: xfs_log_ungrant_sub:  dev 8:32 t_ocnt 0 t_cnt 0 t_curr_res 2860 t_unit_res 2860 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 959072 grant_write_cycle 1 grant_write_bytes 959072 curr_cycle 1 curr_block 1863 tail_cycle 1 tail_block 1861
              dd-12284 [000]   983.948261: xfs_log_ungrant_exit: dev 8:32 t_ocnt 0 t_cnt 0 t_curr_res 2860 t_unit_res 2860 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 956212 grant_write_cycle 1 grant_write_bytes 956212 curr_cycle 1 curr_block 1863 tail_cycle 1 tail_block 1861
              dd-12284 [000]   983.948261: xfs_iunlock:          dev 8:32 ino 0xb52c flags ILOCK_EXCL caller 0xffffffff81526d6cs

Ad so the cycle goes. The next page at offset 0x1f37b000 fails
allocation, triggers a flush, which results in the write at
0x1f37a000 failing and freeing it's delalloc blocks, which then
allows the retry of the write at 0x1f37b000 to succeed....

I can see that mapping errors (i.e. the AS_ENOSPC error) ar enot
propagated into the write() path, but that's the same as the old
code. What I don't quite understand is how delalloc has blown
through the XFS_ALLOC_SET_ASIDE() limits which are supposed to
trigger ENOSPC on the write() side much earlier than just one or two
blocks free....

Something doesn't quite add up here, and I haven't been able to put
my finger on it yet.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
