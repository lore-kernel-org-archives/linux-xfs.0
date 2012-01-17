Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0HMgZME181613 for <xfs@oss.sgi.com>; Tue, 17 Jan 2012 16:42:35 -0600
Message-ID: <4F15F959.4000405@sgi.com>
Date: Tue, 17 Jan 2012 16:42:33 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch 02/12] xfs: do exact log space wakeups in
	xlog_ungrant_log_space
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141433.714245384@bombadil.infradead.org>
In-Reply-To: <20111212141433.714245384@bombadil.infradead.org>
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

On 01/-10/63 13:59, Christoph Hellwig wrote:
> The only reason that xfs_log_space_wake had to do opportunistic wakeups
> was that the old xfs_log_move_tail calling convention didn't allow for
> exact wakeups when not updating the log tail LSN.  Since this issue has
> been fixed we can do exact wakeups now.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
>
> ---
>   fs/xfs/xfs_log.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: xfs/fs/xfs/xfs_log.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log.c	2011-12-11 15:30:49.977750776 +0100
> +++ xfs/fs/xfs/xfs_log.c	2011-12-11 17:49:00.692836117 +0100
> @@ -2748,7 +2748,7 @@ xlog_ungrant_log_space(xlog_t	     *log,
>
>   	trace_xfs_log_ungrant_exit(log, ticket);
>
> -	xfs_log_space_wake(log->l_mp, true);
> +	xfs_log_space_wake(log->l_mp, false);
>   }
>
>   /*
>

It make sense that xlog_ungrant_log_space() does not need to do 
opportunistic wakeup.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
