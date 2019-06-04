Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:37319 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726595AbfFDGYr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 02:24:47 -0400
Date: Tue, 4 Jun 2019 16:24:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 18/20] xfs: remove unused buffer cache APIs
Message-ID: <20190604062442.GS29573@dread.disaster.area>
References: <20190603172945.13819-1-hch@lst.de>
 <20190603172945.13819-19-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603172945.13819-19-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 03, 2019 at 07:29:43PM +0200, Christoph Hellwig wrote:
> Now that the log code uses bios directly we can drop various special
> cases in the buffer cache code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 83 ++----------------------------------------------
>  fs/xfs/xfs_buf.h | 27 ----------------
>  2 files changed, 2 insertions(+), 108 deletions(-)

That's a nice result. One minor thing:

> @@ -1258,7 +1192,7 @@ xfs_buf_ioend_async(
>  	struct xfs_buf	*bp)
>  {
>  	INIT_WORK(&bp->b_ioend_work, xfs_buf_ioend_work);
> -	queue_work(bp->b_ioend_wq, &bp->b_ioend_work);
> +	queue_work(bp->b_target->bt_mount->m_buf_workqueue, &bp->b_ioend_work);
>  }

It'd be nice to keep bp->b_ioend_wq to avoid pointer chasing here.
Perhaps we could set it up in _xfs_buf_alloc() where we are pretty
much guaranteed to have the xfs_mount hot in cache, and then it's
set for the life of the buffer. Just a thought, but either way:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
