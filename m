Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6FA4E7F9B
	for <linux-xfs@oss.sgi.com>; Tue, 12 Feb 2013 14:23:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 48C9E304053
	for <linux-xfs@oss.sgi.com>; Tue, 12 Feb 2013 12:23:19 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	dtrt2KEAFfWyqU3N for <linux-xfs@oss.sgi.com>;
	Tue, 12 Feb 2013 12:23:16 -0800 (PST)
Date: Wed, 13 Feb 2013 07:22:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Hung in D state during fclose
Message-ID: <20130212202246.GB26694@dastard>
References: <loom.20130212T071115-446@post.gmane.org>
	<20130212065545.GC10731@dastard>
	<3542214BE3A3EF419F236DFE0F878BC90512DC@BL2PRD0310MB374.namprd03.prod.outlook.com>
	<20130212102014.GA26694@dastard>
	<3542214BE3A3EF419F236DFE0F878BC90517D2@BL2PRD0310MB374.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3542214BE3A3EF419F236DFE0F878BC90517D2@BL2PRD0310MB374.namprd03.prod.outlook.com>
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
To: "Cheung, Norman" <Norman.Cheung@kla-tencor.com>
Cc: "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>

On Tue, Feb 12, 2013 at 04:39:48PM +0000, Cheung, Norman wrote:
> It's just as mangled. Write them to a file, make sure it is formatted correctly, and attach it to the email.
> [NLC] attached in a file, sorry for the trouble.  Also paste trace again below  hopefully it will  come thru better.

The file and the paste came through OK.

> > kernel version 3.0.13-0.27
> 
> What distribution is that from?
> [NLC] SUSE 

Yeah, looks to be a SLES kernel - have you talked to you SuSE
support rep about this?

> 1. the disk writing thread hung in fclose
> 
> 
> Tigris_IMC.exe  D 0000000000000000     0  4197   4100 0x00000000
> ffff881f3db921c0 0000000000000086 0000000000000000 ffff881f42eb8b80
> ffff880861419fd8 ffff880861419fd8 ffff880861419fd8 ffff881f3db921c0
> 0000000000080000 0000000000000000 00000000000401e0 00000000061805c1 
> Call Trace:
> [<ffffffff810d89ed>] ? zone_statistics+0x9d/0xa0 
> [<ffffffffa0402682>] ? xfs_iomap_write_delay+0x172/0x2b0 [xfs] 
> [<ffffffff813c7e35>] ? rwsem_down_failed_common+0xc5/0x150
> [<ffffffff811f32a3>] ? call_rwsem_down_write_failed+0x13/0x20
> [<ffffffff813c74ec>] ? down_write+0x1c/0x1d 
> [<ffffffffa03fba8e>] ? xfs_ilock+0x7e/0xa0 [xfs] 
> [<ffffffffa041b64b>] ? __xfs_get_blocks+0x1db/0x3d0 [xfs] 
> [<ffffffff81103340>] ? kmem_cache_alloc+0x100/0x130 
> [<ffffffff8113fa2e>] ? alloc_page_buffers+0x6e/0xe0 
> [<ffffffff81141cdf>] ? __block_write_begin+0x1cf/0x4d0 
> [<ffffffffa041b850>] ? xfs_get_blocks_direct+0x10/0x10 [xfs] 
> [<ffffffffa041b850>] ? xfs_get_blocks_direct+0x10/0x10 [xfs] 
> [<ffffffff8114226b>] ? block_write_begin+0x4b/0xa0 
> [<ffffffffa041b8fb>] ? xfs_vm_write_begin+0x3b/0x70 [xfs] 
> [<ffffffff810c0258>] ? generic_file_buffered_write+0xf8/0x250
> [<ffffffffa04207b5>] ? xfs_file_buffered_aio_write+0xc5/0x130 [xfs] 
> [<ffffffffa042099c>] ? xfs_file_aio_write+0x17c/0x2a0 [xfs] 
> [<ffffffff81115b28>] ? do_sync_write+0xb8/0xf0 
> [<ffffffff8119daa4>] ? security_file_permission+0x24/0xc0
> [<ffffffff8111630a>] ? vfs_write+0xaa/0x190 
> [<ffffffff81116657>] ? sys_write+0x47/0x90 
> [<ffffffff813ce412>] ? system_call_fastpath+0x16/0x1b

So that is doing a write() from fclose, and it's waiting on the
inode XFS_ILOCK_EXCL 

/me wishes that all distros compiled their kernels with frame
pointers enabled so that analysing stack traces is better than "I'm
guessing that the real stack trace is....

> 2. flush from another partition
> 
> flush-8:48      D 0000000000000000     0  4217      2 0x00000000
> ffff883fc053f580 0000000000000046 ffff881f40f348f0 ffff881f40e2aa80
> ffff883fabb83fd8 ffff883fabb83fd8 ffff883fabb83fd8 ffff883fc053f580
> ffff883fc27654c0 ffff881f40dfc040 0000000000000001 ffffffff810656f9 
> Call Trace:
> [<ffffffff810656f9>] ? __queue_work+0xc9/0x390 
> [<ffffffff811e3e3f>] ? cfq_insert_request+0xaf/0x4f0 
> [<ffffffff81065a06>] ? queue_work_on+0x16/0x20 
> [<ffffffff813c69cd>] ? schedule_timeout+0x1dd/0x240 
> [<ffffffffa041a762>] ? kmem_zone_zalloc+0x32/0x50 [xfs] 
> [<ffffffff813c7559>] ? __down+0x6c/0x99 
> [<ffffffff81070377>] ? down+0x37/0x40 
> [<ffffffffa041d59d>] ? xfs_buf_lock+0x1d/0x40 [xfs] 
> [<ffffffffa041d6a3>] ? _xfs_buf_find+0xe3/0x210 [xfs] 
> [<ffffffffa041dcb4>] ? xfs_buf_get+0x64/0x150 [xfs] 
> [<ffffffffa041dfb2>] ? xfs_buf_read+0x12/0xa0 [xfs] 
> [<ffffffffa04151af>] ? xfs_trans_read_buf+0x1bf/0x2f0 [xfs] 
> [<ffffffffa03d06c0>] ? xfs_read_agf+0x60/0x1b0 [xfs] 
> [<ffffffffa03cf3b7>] ? xfs_alloc_update+0x17/0x20 [xfs] 
> [<ffffffffa03d0841>] ? xfs_alloc_read_agf+0x31/0xd0 [xfs] 
> [<ffffffffa03d2083>] ? xfs_alloc_fix_freelist+0x433/0x4a0 [xfs] 
> [<ffffffff810d89ed>] ? zone_statistics+0x9d/0xa0 
> [<ffffffffa03d23a4>] ? xfs_alloc_vextent+0x184/0x4a0 [xfs] 
> [<ffffffffa03dc348>] ? xfs_bmap_btalloc+0x2d8/0x6d0 [xfs] 
> [<ffffffffa03e0efd>] ? xfs_bmapi+0x9bd/0x11a0 [xfs] 
> [<ffffffffa03d9bbc>] ? xfs_bmap_search_multi_extents+0xac/0x120 [xfs] 
> [<ffffffffa040293c>] ? xfs_iomap_write_allocate+0x17c/0x330 [xfs] 
> [<ffffffffa041b20f>] ? xfs_map_blocks+0x19f/0x1b0 [xfs] 
> [<ffffffffa041c20e>] ? xfs_vm_writepage+0x19e/0x470 [xfs] 
> [<ffffffff810c97ba>] ? __writepage+0xa/0x30 
> [<ffffffff810c9c4d>] ? write_cache_pages+0x1cd/0x3d0 
> [<ffffffff810c97b0>] ? bdi_set_max_ratio+0x90/0x90 
> [<ffffffff810c9e93>] ? generic_writepages+0x43/0x70 
> [<ffffffff81139330>] ? writeback_single_inode+0x160/0x300
> [<ffffffff811397d4>] ? writeback_sb_inodes+0x104/0x1a0 
> [<ffffffff81139cfd>] ? writeback_inodes_wb+0x8d/0x140 
> [<ffffffff8113a05b>] ? wb_writeback+0x2ab/0x310 
> [<ffffffff813cedee>] ? apic_timer_interrupt+0xe/0x20 
> [<ffffffff8113a10e>] ? wb_check_old_data_flush+0x4e/0xa0 
> [<ffffffff8113a28b>] ? wb_do_writeback+0x12b/0x160 
> [<ffffffff8113a332>] ? bdi_writeback_thread+0x72/0x150 
> [<ffffffff8113a2c0>] ? wb_do_writeback+0x160/0x160 
> [<ffffffff8106b06e>] ? kthread+0x7e/0x90 
> [<ffffffff813cf544>] ? kernel_thread_helper+0x4/0x10 
> [<ffffffff8106aff0>] ? kthread_worker_fn+0x1a0/0x1a0 
> [<ffffffff813cf540>] ? gs_change+0x13/0x13

Thats the writeback thread waiting on an AGF buffer to be unlocked.
IOWs, there are probably multiple concurrent allocations to the same
AG. But that will be holding the XFS_ILOCK_EXCL lock that the other
thread is waiting.

What thread is holding the AGF buffer is anyone's guess - it could
be waiting on IO completion, which would indicate a problem in the
storage layers below XFS. The output in dmesg from sysrq-w (echo w >
/proc/sysrq-trigger) might help indicate other blocked threads that
could be holding the AGF lock.

.....
>     RAID layout (hardware and/or software) Hardware RAID 0 , 2 disks per RAID.  

What RAID controller? SAS or SATA drives? Stripe chunk/segment size?
Any BBWC?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
