Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54326 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729727AbfCYLGr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Mar 2019 07:06:47 -0400
Date: Mon, 25 Mar 2019 04:06:46 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: serialize unaligned dio writes against all other
 dio writes
Message-ID: <20190325110646.GA7890@infradead.org>
References: <20190322165242.40662-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190322165242.40662-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Zorro Lang <zlang@redhat.com>

>  	if (unaligned_io) {
> +		/* unaligned dio always waits, bail */
> +		if (iocb->ki_flags & IOCB_NOWAIT)
> +			return -EAGAIN;
> +		else
>  			inode_dio_wait(inode);

No need for the else here.

>  	} else if (iolock == XFS_IOLOCK_EXCL) {
>  		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
>  		iolock = XFS_IOLOCK_SHARED;
> @@ -548,6 +549,8 @@ xfs_file_dio_aio_write(
>  
>  	trace_xfs_file_direct_write(ip, count, iocb->ki_pos);
>  	ret = iomap_dio_rw(iocb, from, &xfs_iomap_ops, xfs_dio_write_end_io);
> +	if (unaligned_io && !is_sync_kiocb(iocb))
> +		inode_dio_wait(inode);

Instead of explicittly waiting here I'd much rather just mark the
I/O as sync before submitting it.  The only thing needed for that
is to clear iocb->ki_complete.  To avoid too much low-level hacking
that is probably best done with a:

static inline void mark_kiocb_sync(struct kiocb *kiocb)
{
	kiocb->ki_complete = NULL;
}

helper in fs.h.
