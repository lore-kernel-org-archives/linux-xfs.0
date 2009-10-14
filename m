Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9EF8LsK198638
	for <linux-xfs@oss.sgi.com>; Wed, 14 Oct 2009 10:08:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 07DD45DFC
	for <linux-xfs@oss.sgi.com>; Wed, 14 Oct 2009 08:09:51 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lPzoK1RLne1FrmFw for
	<linux-xfs@oss.sgi.com>; Wed, 14 Oct 2009 08:09:51 -0700 (PDT)
Date: Wed, 14 Oct 2009 11:09:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: deadlocks with fallocate
Message-ID: <20091014150951.GA13123@infradead.org>
References: <hak2l2$ko2$1@ger.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <hak2l2$ko2$1@ger.gmane.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Thomas Neumann <tneumann@users.sourceforge.net>
Cc: linux-xfs@oss.sgi.com

On Thu, Oct 08, 2009 at 08:59:45AM +0200, Thomas Neumann wrote:
> I am willing to help to debug the problem, although it is probably a race 
> condition, as it does not occur all of the time. Is there anything I should 
> do to pinpoint the problem?
> It always seems to occur when the user space calls fallocate (100% of my log 
> entries contained this function call), but otherwise I am not sure what 
> triggers it.

I think we're deadlocking here because we have one process waiting from
I/O completions from another task, but the waiting task holds a lock
that the I/O completion needs.

> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> xfsconvertd/0 D 0000000000000000     0   411      2 0x00000000
>  ffff88007b21d3e0 0000000000000046 ffff88007d4e8c40 ffff88007b21dfd8
>  ffff88007adfdb40 0000000000015980 0000000000015980 ffff88007b21dfd8
>  0000000000015980 ffff88007b21dfd8 0000000000015980 ffff88007adfdf00
> Call Trace:
>  [<ffffffff81526162>] io_schedule+0x42/0x60
>  [<ffffffff810df6d5>] sync_page+0x35/0x50
>  [<ffffffff815268e5>] __wait_on_bit+0x55/0x80
>  [<ffffffff810df7f0>] wait_on_page_bit+0x70/0x80
>  [<ffffffff810ecce8>] shrink_page_list+0x3d8/0x550
>  [<ffffffff810ed7e6>] shrink_inactive_list+0x6b6/0x700
>  [<ffffffff810ed881>] shrink_list+0x51/0xb0
>  [<ffffffff810eddea>] shrink_zone+0x1ea/0x200
>  [<ffffffff810ee823>] shrink_zones+0x63/0xf0
>  [<ffffffff810ee920>] do_try_to_free_pages+0x70/0x280
>  [<ffffffff810eec9c>] try_to_free_pages+0x9c/0xc0
>  [<ffffffff810e6342>] __alloc_pages_slowpath+0x232/0x520
>  [<ffffffff810e6776>] __alloc_pages_nodemask+0x146/0x180
>  [<ffffffff811143f7>] alloc_pages_current+0x87/0xd0
>  [<ffffffff8111939c>] allocate_slab+0x11c/0x1b0
>  [<ffffffff8111945b>] new_slab+0x2b/0x190
>  [<ffffffff8111b641>] __slab_alloc+0x121/0x230
>  [<ffffffff8111b980>] kmem_cache_alloc+0xf0/0x130
>  [<ffffffffa009b57d>] kmem_zone_alloc+0x5d/0xd0 [xfs]
>  [<ffffffffa009b609>] kmem_zone_zalloc+0x19/0x50 [xfs]
>  [<ffffffffa009368f>] _xfs_trans_alloc+0x2f/0x70 [xfs]
>  [<ffffffffa0093832>] xfs_trans_alloc+0x92/0xa0 [xfs]
>  [<ffffffffa0083691>] xfs_iomap_write_unwritten+0x71/0x200 [xfs]
>  [<ffffffffa009c435>] xfs_end_bio_unwritten+0x65/0x80 [xfs]
>  [<ffffffff81075c47>] run_workqueue+0xb7/0x190
>  [<ffffffff81076fa6>] worker_thread+0x96/0xf0
>  [<ffffffff81012f8a>] child_rip+0xa/0x20

This thread is completing an unwritten I/O, which is the XFS name
for preallocated space as the one that is created by posix_fallocate
since the system call was wired up.  It needs to allocate memory
for the transaction pointer, and we go down all the way into the
page allocator where we get stuck, probably waiting for I/O on the
same inode.  

>  [<ffffffffa009c0e5>] xfs_ioend_wait+0x85/0xc0 [xfs]
>  [<ffffffffa0097d1d>] xfs_setattr+0x85d/0xb20 [xfs]
>  [<ffffffffa00a2ebd>] xfs_vn_fallocate+0xed/0x100 [xfs]
>  [<ffffffff8112556d>] do_fallocate+0xfd/0x110
>  [<ffffffff811255c9>] sys_fallocate+0x49/0x70
>  [<ffffffff81011f42>] system_call_fastpath+0x16/0x1b

And this thread is inside the fallocate handler.

Can you try if the hack below makes the problem go away?


Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-10-14 17:06:50.489254023 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2009-10-14 17:07:54.055006445 +0200
@@ -278,6 +278,8 @@ xfs_end_bio_unwritten(
 	xfs_off_t		offset = ioend->io_offset;
 	size_t			size = ioend->io_size;
 
+	current->flags |= PF_FSTRANS;
+
 	if (likely(!ioend->io_error)) {
 		if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 			int error;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
