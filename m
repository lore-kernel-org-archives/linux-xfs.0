Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 327C37F55
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 07:43:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 121C9304062
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 05:43:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JtK0aCykBMgXmj7D for
	<xfs@oss.sgi.com>; Fri, 02 May 2014 05:43:13 -0700 (PDT)
Date: Fri, 2 May 2014 08:50:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] xfs: truncate_setsize should be outside transactions
Message-ID: <20140502125049.GA7709@bfoster.bfoster>
References: <1398983979-23696-1-git-send-email-david@fromorbit.com>
	<20140502045443.GA8867@infradead.org>
	<20140502050053.GA17578@infradead.org>
	<20140502064700.GB26353@dastard> <20140502070054.GC26353@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140502070054.GC26353@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, May 02, 2014 at 05:00:54PM +1000, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> truncate_setsize() removes pages from the page cache, and hence
> requires page locks to be held. It is not valid to lock a page cache
> page inside a transaction context as we can hold page locks when we
> we reserve space for a transaction. If we do, then we expose an ABBA
> deadlock between log space reservation and page locks.
> 
> That is, both the write path and writeback lock a page, then start a
> transaction for block allocation, which means they can block waiting
> for a log reservation with the page lock held. If we hold a log
> reservation and then do something that locks a page (e.g.
> truncate_setsize in xfs_setattr_size) then that page lock can block
> on the page locked and waiting for a log reservation. If the
> transaction that is waiting for the page lock is the only active
> transaction in the system that can free log space via a commit,
> then writeback will never make progress and so log space will never
> free up.
> 
> This issue with xfs_setattr_size() was introduced back in 2010 by
> commit fa9b227 ("xfs: new truncate sequence") which moved the page
> cache truncate from outside the transaction context (what was
> xfs_itruncate_data()) to inside the transaction context as a call to
> truncate_setsize().
> 
> The reason truncate_setsize() was located where in this place was
> that we can't change the file size until after we are in the
> transaction context and the operation will either succeed or shut
> down the filesystem on failure. Hence we have to split
> truncate_setsize() back into a pagecache operation that occurs
> before the transaction context, and a i_size_write() call that
> happens within the transaction context.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

The manifestation of this that we have seen has writeback blocked on log
reservation, and a thread sitting on this:

 #0 [ffff88022e153b18] __schedule at ffffffff815f137d
 #1 [ffff88022e153b80] io_schedule at ffffffff815f1bdd
 #2 [ffff88022e153b98] sleep_on_page at ffffffff811410be
 #3 [ffff88022e153ba8] __wait_on_bit at ffffffff815ef940
 #4 [ffff88022e153be8] wait_on_page_bit at ffffffff81140e46
 #5 [ffff88022e153c38] truncate_inode_pages_range at ffffffff81150d03
 #6 [ffff88022e153d88] truncate_pagecache at ffffffff81151027
 #7 [ffff88022e153db0] truncate_setsize at ffffffff81151059
 #8 [ffff88022e153dc0] xfs_setattr_size at ffffffffa01f3594 [xfs]
 #9 [ffff88022e153e10] xfs_vn_setattr at ffffffffa01f37e0 [xfs]
#10 [ffff88022e153e30] notify_change at ffffffff811cc349
#11 [ffff88022e153e78] do_truncate at ffffffff811adb43
#12 [ffff88022e153ef0] vfs_truncate at ffffffff811adcf1
#13 [ffff88022e153f28] do_sys_truncate at ffffffff811add9c
#14 [ffff88022e153f70] sys_truncate at ffffffff811adf3e
#15 [ffff88022e153f80] system_call_fastpath at ffffffff815fc819

That wait_on_page_bit() call maps to this bit of code:

0xffffffff81150cef <truncate_inode_pages_range+879>:    mov    %rdx,%rdi
0xffffffff81150cf2 <truncate_inode_pages_range+882>:    mov    $0xd,%esi
0xffffffff81150cf7 <truncate_inode_pages_range+887>:    mov    %rdx,-0x130(%rbp)
0xffffffff81150cfe <truncate_inode_pages_range+894>:    callq  0xffffffff81140dc0 <wait_on_page_bit>

So this thread has basically come in, reserved log space, attempted a
truncate and is sitting blocked on writeback. xfs_vm_writepage() has the
page, set the writeback bit and attempted a log reservation for the file
size update transaction. Therefore, no progress can be made.

Ordered properly, the truncate should either wait on writeback without
holding the log space hostage or grab the page lock before writeback is
set, allowing either path to proceed once the page is acquired.

Makes sense, thanks for tracking this down...

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_iops.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index ef1ca01..ab2dc47 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -808,22 +808,27 @@ xfs_setattr_size(
>  	 */
>  	inode_dio_wait(inode);
>  
> +	/*
> +	 * Do all the page cache truncate work outside the transaction
> +	 * context as the "lock" order is page lock->log space reservation.
> +	 * i.e. locking pages inside the transaction can ABBA deadlock with
> +	 * writeback. We have to do the inode size update inside the
> +	 * transaction, however, as xfs_trans_reserve() can fail with ENOMEM
> +	 * and we can't make user visible changes on non-fatal errors.
> +	 */
>  	error = -block_truncate_page(inode->i_mapping, newsize, xfs_get_blocks);
>  	if (error)
>  		return error;
> +	truncate_pagecache(inode, newsize);
>  
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
>  	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	truncate_setsize(inode, newsize);
> -
>  	commit_flags = XFS_TRANS_RELEASE_LOG_RES;
>  	lock_flags |= XFS_ILOCK_EXCL;
> -
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -
>  	xfs_trans_ijoin(tp, ip, 0);
>  
>  	/*
> @@ -856,6 +861,7 @@ xfs_setattr_size(
>  	 * they get written to.
>  	 */
>  	ip->i_d.di_size = newsize;
> +	i_size_write(inode, newsize);
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
>  	if (newsize <= oldsize) {
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
