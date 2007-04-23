Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 14:49:40 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3NLnbfB014624
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 14:49:37 -0700
Date: Mon, 23 Apr 2007 22:24:03 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review: fix use after free of log buffers on shutdown.
Message-ID: <20070423212403.GD13572@infradead.org>
References: <20070419075338.GV48531920@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419075338.GV48531920@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Apr 19, 2007 at 05:53:38PM +1000, David Chinner wrote:
> 
> When unmounting the filesystem we write an unmount record into the
> log just before we start freeing up in memory structures.
> 
> When we wait for the unmount record to hit the disk, we don't
> wait for the log buffers to be finished with, we only wait for part of
> the iodone callback to be run - the bit that processes the
> unmount record completion.
> 
> Hence when the unmount wakes up, it races with the remainder of the
> log io completion and pretty much the first thing it does is free
> the log buffers.
> 
> As a result, when iodone processing completes and we check the
> buffer's async status, the buffer can already have been freed.
> 
> Luckily, all log I/O is issued asynchronously, so we don't really
> need the async check and so we can avoid this use after free
> easily.

Looks good to me.

> Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2007-04-19 17:18:14.097380099 +1000
> +++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2007-04-19 17:51:03.017078512 +1000
> @@ -988,14 +988,16 @@ xlog_iodone(xfs_buf_t *bp)
>  	} else if (iclog->ic_state & XLOG_STATE_IOERROR) {
>  		aborted = XFS_LI_ABORTED;
>  	}
> +
> +	/* log I/O is always issued ASYNC */
> +	ASSERT(XFS_BUF_ISASYNC(bp));
>  	xlog_state_done_syncing(iclog, aborted);
> -	if (!(XFS_BUF_ISASYNC(bp))) {
> -		/*
> -		 * Corresponding psema() will be done in bwrite().  If we don't
> -		 * vsema() here, panic.
> -		 */
> -		XFS_BUF_V_IODONESEMA(bp);
> -	}
> +	/*
> +	 * do not reference the buffer (bp) here as we could race
> +	 * with it being freed after writing the unmount record to the
> +	 * log.
> +	 */
> +
>  }	/* xlog_iodone */
>  
>  /*
> 
> 
---end quoted text---
