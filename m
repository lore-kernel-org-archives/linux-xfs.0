Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0DIplRY154724 for <xfs@oss.sgi.com>; Fri, 13 Jan 2012 12:51:47 -0600
Message-ID: <4F107D41.8050204@sgi.com>
Date: Fri, 13 Jan 2012 12:51:45 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 07/12] repair: fix another ABBA deadlock in inode
	prefetching
References: <20111202174619.179530033@bombadil.infradead.org>
	<20111202174742.307774458@bombadil.infradead.org>
In-Reply-To: <20111202174742.307774458@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com




> Index: xfsprogs-dev/repair/prefetch.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/prefetch.c	2011-11-25 13:46:47.195999430 +0100
> +++ xfsprogs-dev/repair/prefetch.c	2011-11-25 13:50:41.264731371 +0100
> @@ -641,7 +641,18 @@ pf_queuing_worker(
>   		pftrace("queuing irec %p in AG %d, sem count = %d",
>   			irec, args->agno, i);
>   #endif
> -		sem_wait(&args->ra_count);
> +		err = sem_trywait(&args->ra_count);
> +		if (err == EAGAIN) {
> +			/*
> +			 * Kick the queue once we have reached the limit;
> +			 * without this the threads processing the inodes
> +			 * might get stuck on a buffer that has been locked
> +			 * and added to the I/O queue but is waiting for
> +			 * the thread to be woken.
> +			 */
> +			pf_start_io_workers(args);
> +			sem_wait(&args->ra_count);
> +		}
>
>   		num_inos = 0;
>   		bno = XFS_AGINO_TO_AGBNO(mp, cur_irec->ino_startnum);
>

Could the second sem_wait() also fail with EAGAIN?

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
