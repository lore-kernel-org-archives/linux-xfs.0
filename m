Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1G02lUc213747 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 18:02:47 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9GpVtI9tZdHVC0EN for <xfs@oss.sgi.com>;
	Wed, 15 Feb 2012 16:02:45 -0800 (PST)
Date: Thu, 16 Feb 2012 11:02:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/9] xfs: user per-cpu stats for the total dquot numbers
Message-ID: <20120216000243.GQ14132@dastard>
References: <20120215022926.577682146@bombadil.infradead.org>
	<20120215023147.612027782@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120215023147.612027782@bombadil.infradead.org>
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

On Tue, Feb 14, 2012 at 09:29:31PM -0500, Christoph Hellwig wrote:
> Switch the total number of dquots counter over to use the per-cpu stats
> implementation, and reintroduce the number of unused dquots counter
> dropped earlier in the series.
> 
> Btw, I wonder if we should simply add these counters to /proc/fs/xfs/xqmstat
> instead of keeping the odd format and mostly superflous /proc/fs/xfs/xqm
> around.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---
>  fs/xfs/xfs_dquot.c    |    7 ++++---
>  fs/xfs/xfs_qm.c       |    3 ++-
>  fs/xfs/xfs_qm.h       |    1 -
>  fs/xfs/xfs_qm_stats.c |    4 ++--
>  fs/xfs/xfs_qm_stats.h |    5 +++++
>  5 files changed, 13 insertions(+), 7 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_qm_stats.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_qm_stats.c	2012-02-12 13:22:45.040270187 -0800
> +++ xfs/fs/xfs/xfs_qm_stats.c	2012-02-12 13:22:49.553603603 -0800
> @@ -52,9 +52,9 @@ static int xqm_proc_show(struct seq_file
>  	/* maximum; incore; ratio free to inuse; freelist */
>  	seq_printf(m, "%d\t%d\t%d\t%u\n",
>  			0,
> -			xfs_Gqm? atomic_read(&xfs_Gqm->qm_totaldquots) : 0,
> +			xqmstats_sum(XQMSTAT_END_XQMSTAT),
>  			0,
> -			0);
> +			xqmstats_sum(XQMSTAT_END_XQMSTAT + 1));
>  	return 0;
>  }
>  
> Index: xfs/fs/xfs/xfs_qm_stats.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_qm_stats.h	2012-02-12 13:22:45.040270187 -0800
> +++ xfs/fs/xfs/xfs_qm_stats.h	2012-02-12 13:22:49.553603603 -0800
> @@ -33,6 +33,9 @@ struct xqmstats {
>  	__uint32_t		xs_qm_dqshake_reclaims;
>  	__uint32_t		xs_qm_dqinact_reclaims;
>  #define XQMSTAT_END_XQMSTAT	8
> +	__uint32_t		xs_qm_dquots;
> +	__uint32_t		xs_qm_dquots_unused;
> +#define XQMSTAT_END_XQM		(XQMSTAT_END_XQMSTAT + 4)

Shouldn't that be (XQMSTAT_END_XQMSTAT + 2)?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
