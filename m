Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9BI1s1h191451 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 13:01:54 -0500
Received: from crcuda.crossroads.com (crcuda.crossroads.com [66.219.50.99]) by
	cuda.sgi.com with ESMTP id GbBeIkXSMefDEKfY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 11:03:26 -0700 (PDT)
Received: from crds-transport1.COMMSTOR.Crossroads.com
	(crds-transport1.commstor.crossroads.com [192.168.120.151]) by
	crcuda.crossroads.com with ESMTP id XkOXox2BF2Pwp6lQ
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Oct 2012 13:03:25 -0500 (CDT)
Message-ID: <507709EC.1040105@crossroads.com>
Date: Thu, 11 Oct 2012 13:03:24 -0500
From: Wayne Walker <wwalker@crossroads.com>
MIME-Version: 1.0
Subject: Re: File system corruption
References: <5077077A.3040608@crossroads.com>
In-Reply-To: <5077077A.3040608@crossroads.com>
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
To: xfs@oss.sgi.com

On 10/11/2012 12:52 PM, Wayne Walker wrote:
> In short, I am able to:  mkfs...; mount...; cp 1gbfile...; sync; cp 
> 1gbfile...; sync  # and now the xfs is corrupt
>
> I see multiple bugs
>
> 1. very simple, non-corner-case actions create a corrupted file system
> 2. corrupt data is knowingly written to the file system.
> 3. the file system stays online and writable
> 4. future write operations to the file system return success.
>
> Details:
<snip>

I left out that the files written to disk have data after the first 4K, 
but the first 4K is 0's..

And I left out the dmesg info:

XFS mounting filesystem sde1
Ending clean XFS mount for filesystem: sde1
ffff880d244f1200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
Filesystem "sde1": XFS internal error xfs_alloc_read_agf at line 2157 of 
file fs/xfs/xfs_alloc.c.  Caller 0xffffffffa01c0989

Pid: 18009, comm: flush-8:64 Not tainted 2.6.32-71.29.1.el6.x86_64 #1
Call Trace:
  [<ffffffffa01eacc3>] xfs_error_report+0x43/0x50 [xfs]
  [<ffffffffa01c0989>] ? xfs_alloc_read_agf+0x39/0xe0 [xfs]
  [<ffffffffa01ead2a>] xfs_corruption_error+0x5a/0x70 [xfs]
  [<ffffffffa01c08af>] xfs_read_agf+0xef/0x190 [xfs]
  [<ffffffffa01c0989>] ? xfs_alloc_read_agf+0x39/0xe0 [xfs]
  [<ffffffff81156a90>] ? cache_alloc_refill+0x1c0/0x240
  [<ffffffffa01c0989>] xfs_alloc_read_agf+0x39/0xe0 [xfs]
  [<ffffffffa01c2dd4>] xfs_alloc_fix_freelist+0x2f4/0x480 [xfs]
  [<ffffffff812593c9>] ? cpumask_next_and+0x29/0x50
  [<ffffffff81062c74>] ? find_busiest_group+0x254/0xb40
  [<ffffffffa0203fc8>] ? xfs_perag_get+0x48/0xc0 [xfs]
  [<ffffffffa01c3193>] xfs_alloc_vextent+0x173/0x600 [xfs]
  [<ffffffffa0203fc8>] ? xfs_perag_get+0x48/0xc0 [xfs]
  [<ffffffffa01cd2a7>] xfs_bmap_btalloc+0x167/0x9d0 [xfs]
  [<ffffffffa01cdb1e>] xfs_bmap_alloc+0xe/0x10 [xfs]
  [<ffffffffa01d4696>] xfs_bmapi+0x9f6/0x11a0 [xfs]
  [<ffffffffa01fd3c0>] ? xfs_log_reserve+0xf0/0x150 [xfs]
  [<ffffffff814cad26>] ? down_write+0x16/0x40
  [<ffffffffa01f6b75>] xfs_iomap_write_allocate+0x1c5/0x3b0 [xfs]
  [<ffffffff81264e08>] ? call_rwsem_wake+0x18/0x30
  [<ffffffffa01f78b9>] xfs_iomap+0x389/0x440 [xfs]
  [<ffffffff8119633b>] ? __mark_inode_dirty+0x3b/0x160
  [<ffffffffa0210dbd>] xfs_map_blocks+0x2d/0x40 [xfs]
  [<ffffffffa0212408>] xfs_page_state_convert+0x2f8/0x750 [xfs]
  [<ffffffff8125ec05>] ? radix_tree_gang_lookup_tag_slot+0x95/0xe0
  [<ffffffffa0212a16>] xfs_vm_writepage+0x86/0x170 [xfs]
  [<ffffffff8111f6e7>] __writepage+0x17/0x40
  [<ffffffff81120979>] write_cache_pages+0x189/0x430
  [<ffffffff8111f6d0>] ? __writepage+0x0/0x40
  [<ffffffff81120c44>] generic_writepages+0x24/0x30
  [<ffffffffa02117fe>] xfs_vm_writepages+0x5e/0x80 [xfs]
  [<ffffffff81120c71>] do_writepages+0x21/0x40
  [<ffffffff8119694d>] writeback_single_inode+0xdd/0x2c0
  [<ffffffff81196d4e>] writeback_sb_inodes+0xce/0x180
  [<ffffffff81196ea3>] writeback_inodes_wb+0xa3/0x1a0
  [<ffffffff8119723b>] wb_writeback+0x29b/0x3f0
  [<ffffffff814c92b6>] ? thread_return+0x4e/0x778
  [<ffffffff8119744b>] wb_do_writeback+0xbb/0x240
  [<ffffffff81197633>] bdi_writeback_task+0x63/0x1b0
  [<ffffffff81091d67>] ? bit_waitqueue+0x17/0xd0
  [<ffffffff8112f040>] ? bdi_start_fn+0x0/0x100
  [<ffffffff8112f0c6>] bdi_start_fn+0x86/0x100
  [<ffffffff8112f040>] ? bdi_start_fn+0x0/0x100
  [<ffffffff81091b36>] kthread+0x96/0xa0
  [<ffffffff810141ca>] child_rip+0xa/0x20
  [<ffffffff81091aa0>] ? kthread+0x0/0xa0
  [<ffffffff810141c0>] ? child_rip+0x0/0x20
Filesystem "sde1": page discard on page ffffea0003cfc418, inode 0x1004, 
offset 0.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
