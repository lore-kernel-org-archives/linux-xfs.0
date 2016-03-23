Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BB84C7CB0
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 07:43:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8D87C304051
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 05:43:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qA8dnIML39Jn4ZYU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 23 Mar 2016 05:43:15 -0700 (PDT)
Date: Wed, 23 Mar 2016 08:43:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Failing XFS memory allocation
Message-ID: <20160323124312.GB43073@bfoster.bfoster>
References: <56F26CCE.6010502@kyup.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56F26CCE.6010502@kyup.com>
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
To: Nikolay Borisov <kernel@kyup.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 23, 2016 at 12:15:42PM +0200, Nikolay Borisov wrote:
> Hello,
> 
> So I have an XFS filesystem which houses 2 2.3T sparse files, which are
> loop-mounted. Recently I migrated a server to a 4.4.6 kernel and this
> morning I observed the following in my dmesg:
> 
> XFS: loop0(15174) possible memory allocation deadlock size 107168 in
> kmem_alloc (mode:0x2400240)
> 

Is there a stack trace associated with this message?

> the mode is essentially (GFP_KERNEL | GFP_NOWARN) &= ~__GFP_FS.
> Here is the site of the loop file in case it matters:
> 
> du -h --apparent-size /storage/loop/file1
> 2.3T	/storage/loop/file1
> 
> du -h /storage/loop/file1
> 878G	/storage/loop/file1
> 
> And this string is repeated multiple times. Looking at the output of
> "echo w > /proc/sysrq-trigger" I see the following suspicious entry:
> 
> loop0           D ffff881fe081f038     0 15174      2 0x00000000
>  ffff881fe081f038 ffff883ff29fa700 ffff881fecb70d00 ffff88407fffae00
>  0000000000000000 0000000502404240 ffffffff81e30d60 0000000000000000
>  0000000000000000 ffff881f00000003 0000000000000282 ffff883f00000000
> Call Trace:
>  [<ffffffff8163ac01>] ? _raw_spin_lock_irqsave+0x21/0x60
>  [<ffffffff81636fd7>] schedule+0x47/0x90
>  [<ffffffff81639f03>] schedule_timeout+0x113/0x1e0
>  [<ffffffff810ac580>] ? lock_timer_base+0x80/0x80
>  [<ffffffff816363d4>] io_schedule_timeout+0xa4/0x110
>  [<ffffffff8114aadf>] congestion_wait+0x7f/0x130
>  [<ffffffff810939e0>] ? woken_wake_function+0x20/0x20
>  [<ffffffffa0283bac>] kmem_alloc+0x8c/0x120 [xfs]
>  [<ffffffff81181751>] ? __kmalloc+0x121/0x250
>  [<ffffffffa0283c73>] kmem_realloc+0x33/0x80 [xfs]
>  [<ffffffffa02546cd>] xfs_iext_realloc_indirect+0x3d/0x60 [xfs]
>  [<ffffffffa02548cf>] xfs_iext_irec_new+0x3f/0xf0 [xfs]
>  [<ffffffffa0254c0d>] xfs_iext_add_indirect_multi+0x14d/0x210 [xfs]
>  [<ffffffffa02554b5>] xfs_iext_add+0xc5/0x230 [xfs]

It looks like it's working to add a new extent to the in-core extent
list. If this is the stack associated with the warning message (combined
with the large alloc size), I wonder if there's a fragmentation issue on
the file leading to an excessive number of extents.

What does 'xfs_bmap -v /storage/loop/file1' show?

Brian

>  [<ffffffff8112b5c5>] ? mempool_alloc_slab+0x15/0x20
>  [<ffffffffa0256269>] xfs_iext_insert+0x59/0x110 [xfs]
>  [<ffffffffa0230928>] ? xfs_bmap_add_extent_hole_delay+0xd8/0x740 [xfs]
>  [<ffffffffa0230928>] xfs_bmap_add_extent_hole_delay+0xd8/0x740 [xfs]
>  [<ffffffff8112b5c5>] ? mempool_alloc_slab+0x15/0x20
>  [<ffffffff8112b725>] ? mempool_alloc+0x65/0x180
>  [<ffffffffa02543d8>] ? xfs_iext_get_ext+0x38/0x70 [xfs]
>  [<ffffffffa0254e8d>] ? xfs_iext_bno_to_ext+0xed/0x150 [xfs]
>  [<ffffffffa02311b5>] xfs_bmapi_reserve_delalloc+0x225/0x250 [xfs]
>  [<ffffffffa023131e>] xfs_bmapi_delay+0x13e/0x290 [xfs]
>  [<ffffffffa02730ad>] xfs_iomap_write_delay+0x17d/0x300 [xfs]
>  [<ffffffffa022e434>] ? xfs_bmapi_read+0x114/0x330 [xfs]
>  [<ffffffffa025ddc5>] __xfs_get_blocks+0x585/0xa90 [xfs]
>  [<ffffffff81324b53>] ? __percpu_counter_add+0x63/0x80
>  [<ffffffff811374cd>] ? account_page_dirtied+0xed/0x1b0
>  [<ffffffff811cfc59>] ? alloc_buffer_head+0x49/0x60
>  [<ffffffff811d07c0>] ? alloc_page_buffers+0x60/0xb0
>  [<ffffffff811d13e5>] ? create_empty_buffers+0x45/0xc0
>  [<ffffffffa025e324>] xfs_get_blocks+0x14/0x20 [xfs]
>  [<ffffffff811d34e2>] __block_write_begin+0x1c2/0x580
>  [<ffffffffa025e310>] ? xfs_get_blocks_direct+0x20/0x20 [xfs]
>  [<ffffffffa025bbb1>] xfs_vm_write_begin+0x61/0xf0 [xfs]
>  [<ffffffff81127e50>] generic_perform_write+0xd0/0x1f0
>  [<ffffffffa026a341>] xfs_file_buffered_aio_write+0xe1/0x240 [xfs]
>  [<ffffffff812e16d2>] ? bt_clear_tag+0xb2/0xd0
>  [<ffffffffa026ab87>] xfs_file_write_iter+0x167/0x170 [xfs]
>  [<ffffffff81199d76>] vfs_iter_write+0x76/0xa0
>  [<ffffffffa03fb735>] lo_write_bvec+0x65/0x100 [loop]
>  [<ffffffffa03fd589>] loop_queue_work+0x689/0x924 [loop]
>  [<ffffffff8163ba52>] ? retint_kernel+0x10/0x10
>  [<ffffffff81074d71>] kthread_worker_fn+0x61/0x1c0
>  [<ffffffff81074d10>] ? flush_kthread_work+0x120/0x120
>  [<ffffffff81074d10>] ? flush_kthread_work+0x120/0x120
>  [<ffffffff810744d7>] kthread+0xd7/0xf0
>  [<ffffffff8107d22e>] ? schedule_tail+0x1e/0xd0
>  [<ffffffff81074400>] ? kthread_freezable_should_stop+0x80/0x80
>  [<ffffffff8163b2af>] ret_from_fork+0x3f/0x70
>  [<ffffffff81074400>] ? kthread_freezable_should_stop+0x80/0x80
> 
> So this seems that there are writes to the loop device being queued and
> while being served XFS has to do some internal memory allocation to fit
> the new data, however due to some *uknown* reason it fails and starts
> looping in kmem_alloc.  I didn't see any OOM reports so presumably the
> server was not out of memory, but unfortunately I didn't check the
> memory fragmentation, though I collected a crash dump in case you need
> further info.
> 
> The one thing which bugs me is that XFS tried to allocate 107 contiguous
> kb which is page-order-26 isn't this waaaaay too big and almost never
> satisfiable, despite direct/bg reclaim to be enabled? For now I've
> reverted to using 3.12.52 kernel, where this issue hasn't been observed
> (yet) any ideas would be much appreciated.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
