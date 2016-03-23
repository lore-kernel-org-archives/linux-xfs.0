Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D8A7F7CB1
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 08:11:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3AB2EAC007
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 06:11:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QRWf7GXHWUzJfhAx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 23 Mar 2016 06:11:01 -0700 (PDT)
Date: Wed, 23 Mar 2016 09:10:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Failing XFS memory allocation
Message-ID: <20160323131059.GC43073@bfoster.bfoster>
References: <56F26CCE.6010502@kyup.com>
	<20160323124312.GB43073@bfoster.bfoster> <56F29279.70600@kyup.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56F29279.70600@kyup.com>
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

On Wed, Mar 23, 2016 at 02:56:25PM +0200, Nikolay Borisov wrote:
> 
> 
> On 03/23/2016 02:43 PM, Brian Foster wrote:
> > On Wed, Mar 23, 2016 at 12:15:42PM +0200, Nikolay Borisov wrote:
...
> > It looks like it's working to add a new extent to the in-core extent
> > list. If this is the stack associated with the warning message (combined
> > with the large alloc size), I wonder if there's a fragmentation issue on
> > the file leading to an excessive number of extents.
> 
> Yes this is the stack trace associated.
> 
> > 
> > What does 'xfs_bmap -v /storage/loop/file1' show?
> 
> It spews a lot of stuff but here is a summary, more detailed info can be
> provided if you need it:
> 
> xfs_bmap -v /storage/loop/file1 | wc -l
> 900908
> xfs_bmap -v /storage/loop/file1 | grep -c hole
> 94568
> 
> Also, what would constitute an "excessive number of extents"?
> 

I'm not sure where one would draw the line tbh, it's just a matter of
having too many extents to the point that it causes problems in terms of
performance (i.e., reading/modifying the extent list) or such as the
allocation problem you're running into. As it is, XFS maintains the full
extent list for an active inode in memory, so that's 800k+ extents that
it's looking for memory for.

It looks like that is your problem here. 800k or so extents over 878G
looks to be about 1MB per extent. Are you using extent size hints? One
option that might prevent this is to use a larger extent size hint
value. Another might be to preallocate the entire file up front with
fallocate. You'd probably have to experiment with what option or value
works best for your workload.

Brian

> > 
> > Brian
> > 
> >>  [<ffffffff8112b5c5>] ? mempool_alloc_slab+0x15/0x20
> >>  [<ffffffffa0256269>] xfs_iext_insert+0x59/0x110 [xfs]
> >>  [<ffffffffa0230928>] ? xfs_bmap_add_extent_hole_delay+0xd8/0x740 [xfs]
> >>  [<ffffffffa0230928>] xfs_bmap_add_extent_hole_delay+0xd8/0x740 [xfs]
> >>  [<ffffffff8112b5c5>] ? mempool_alloc_slab+0x15/0x20
> >>  [<ffffffff8112b725>] ? mempool_alloc+0x65/0x180
> >>  [<ffffffffa02543d8>] ? xfs_iext_get_ext+0x38/0x70 [xfs]
> >>  [<ffffffffa0254e8d>] ? xfs_iext_bno_to_ext+0xed/0x150 [xfs]
> >>  [<ffffffffa02311b5>] xfs_bmapi_reserve_delalloc+0x225/0x250 [xfs]
> >>  [<ffffffffa023131e>] xfs_bmapi_delay+0x13e/0x290 [xfs]
> >>  [<ffffffffa02730ad>] xfs_iomap_write_delay+0x17d/0x300 [xfs]
> >>  [<ffffffffa022e434>] ? xfs_bmapi_read+0x114/0x330 [xfs]
> >>  [<ffffffffa025ddc5>] __xfs_get_blocks+0x585/0xa90 [xfs]
> >>  [<ffffffff81324b53>] ? __percpu_counter_add+0x63/0x80
> >>  [<ffffffff811374cd>] ? account_page_dirtied+0xed/0x1b0
> >>  [<ffffffff811cfc59>] ? alloc_buffer_head+0x49/0x60
> >>  [<ffffffff811d07c0>] ? alloc_page_buffers+0x60/0xb0
> >>  [<ffffffff811d13e5>] ? create_empty_buffers+0x45/0xc0
> >>  [<ffffffffa025e324>] xfs_get_blocks+0x14/0x20 [xfs]
> >>  [<ffffffff811d34e2>] __block_write_begin+0x1c2/0x580
> >>  [<ffffffffa025e310>] ? xfs_get_blocks_direct+0x20/0x20 [xfs]
> >>  [<ffffffffa025bbb1>] xfs_vm_write_begin+0x61/0xf0 [xfs]
> >>  [<ffffffff81127e50>] generic_perform_write+0xd0/0x1f0
> >>  [<ffffffffa026a341>] xfs_file_buffered_aio_write+0xe1/0x240 [xfs]
> >>  [<ffffffff812e16d2>] ? bt_clear_tag+0xb2/0xd0
> >>  [<ffffffffa026ab87>] xfs_file_write_iter+0x167/0x170 [xfs]
> >>  [<ffffffff81199d76>] vfs_iter_write+0x76/0xa0
> >>  [<ffffffffa03fb735>] lo_write_bvec+0x65/0x100 [loop]
> >>  [<ffffffffa03fd589>] loop_queue_work+0x689/0x924 [loop]
> >>  [<ffffffff8163ba52>] ? retint_kernel+0x10/0x10
> >>  [<ffffffff81074d71>] kthread_worker_fn+0x61/0x1c0
> >>  [<ffffffff81074d10>] ? flush_kthread_work+0x120/0x120
> >>  [<ffffffff81074d10>] ? flush_kthread_work+0x120/0x120
> >>  [<ffffffff810744d7>] kthread+0xd7/0xf0
> >>  [<ffffffff8107d22e>] ? schedule_tail+0x1e/0xd0
> >>  [<ffffffff81074400>] ? kthread_freezable_should_stop+0x80/0x80
> >>  [<ffffffff8163b2af>] ret_from_fork+0x3f/0x70
> >>  [<ffffffff81074400>] ? kthread_freezable_should_stop+0x80/0x80
> >>
> >> So this seems that there are writes to the loop device being queued and
> >> while being served XFS has to do some internal memory allocation to fit
> >> the new data, however due to some *uknown* reason it fails and starts
> >> looping in kmem_alloc.  I didn't see any OOM reports so presumably the
> >> server was not out of memory, but unfortunately I didn't check the
> >> memory fragmentation, though I collected a crash dump in case you need
> >> further info.
> >>
> >> The one thing which bugs me is that XFS tried to allocate 107 contiguous
> >> kb which is page-order-26 isn't this waaaaay too big and almost never
> >> satisfiable, despite direct/bg reclaim to be enabled? For now I've
> >> reverted to using 3.12.52 kernel, where this issue hasn't been observed
> >> (yet) any ideas would be much appreciated.
> >>
> >> _______________________________________________
> >> xfs mailing list
> >> xfs@oss.sgi.com
> >> http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
