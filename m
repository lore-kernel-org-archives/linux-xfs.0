Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1GIauTj011264 for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 12:36:56 -0600
Date: Thu, 16 Feb 2012 12:36:59 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 02/12] xfs: do exact log space wakeups in
	xlog_ungrant_log_space
Message-ID: <20120216183659.GR7762@sgi.com>
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141433.714245384@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111212141433.714245384@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Dec 12, 2011 at 09:13:49AM -0500, Christoph Hellwig wrote:
> The only reason that xfs_log_space_wake had to do opportunistic wakeups
> was that the old xfs_log_move_tail calling convention didn't allow for
> exact wakeups when not updating the log tail LSN.

Man, that's a doosey. 

when you called xfs_log_move_tail...

if you passed tail_lsn = 1
it would:			not move the tail
				ignore strict accounting and wake only 1

if you passed tail_lsn = 0
it would:			get tail_lsn from l_last_sync_lsn
				move the tail
				pay attention to strict accounting
				wake as many as is correct

if you passed tail_lsn = !1, !0
it would:			move the tail
				pay attention to strict accounting
				wake as many as is correct.

The important thing to understand is that the opportunistic wakeups
would ignore the the test (free_bytes < need_bytes) in
xfs_log_move_tail, so you could wake a process regardless of whether
there is sufficient space in the log for it.  No wonder they had to
pepper the code with opportunistic wakeups to prevent log space hangs... 

> Since this issue has
> been fixed we can do exact wakeups now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---
>  fs/xfs/xfs_log.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: xfs/fs/xfs/xfs_log.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log.c	2011-12-11 15:30:49.977750776 +0100
> +++ xfs/fs/xfs/xfs_log.c	2011-12-11 17:49:00.692836117 +0100
> @@ -2748,7 +2748,7 @@ xlog_ungrant_log_space(xlog_t	     *log,
>  
>  	trace_xfs_log_ungrant_exit(log, ticket);
>  
> -	xfs_log_space_wake(log->l_mp, true);
> +	xfs_log_space_wake(log->l_mp, false);

Yeah, he's doing an _exact_ wakeup now.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
