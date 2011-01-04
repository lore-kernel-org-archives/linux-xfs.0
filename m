Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p04A0Xcc220430 for <xfs@oss.sgi.com>; Tue, 4 Jan 2011 04:00:33 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 186E423167D
	for <xfs@oss.sgi.com>; Tue,  4 Jan 2011 02:02:40 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Vh2uo7ibe3MuEL8e for
	<xfs@oss.sgi.com>; Tue, 04 Jan 2011 02:02:40 -0800 (PST)
Date: Tue, 4 Jan 2011 05:02:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_repair: multithread phase 2
Message-ID: <20110104100240.GB26885@infradead.org>
References: <1294121588-17233-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294121588-17233-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> This patch uses 32-way threading which results in no noticable
> slowdown on single SATA drives with NCQ, but results in ~10x
> reduction in runtime on a 12 disk RAID-0 array.

Shouldn't we have at least an option to allow tuning this value,
similar to the ag_stride?  In fact I wonder why phase 3/4 should
use different values for it than phase2.

> @@ -75,8 +80,10 @@ scan_sbtree(
>  				xfs_agblock_t		bno,
>  				xfs_agnumber_t		agno,
>  				int			suspect,
> -				int			isroot),
> -	int		isroot)
> +				int			isroot,
> +				struct aghdr_cnts	*agcnts),
> +	int		isroot,
> +	struct aghdr_cnts *agcnts)

Please make this a

	void *priv

to keep scan_sbtree generic.

>  void
> +scanfunc_bno(
> +	struct xfs_btree_block	*block,
> +	int			level,
> +	xfs_agblock_t		bno,
> +	xfs_agnumber_t		agno,
> +	int			suspect,
> +	int			isroot,
> +	struct aghdr_cnts	*agcnts)
> +{
> +	return scanfunc_allocbt(block, level, bno, agno,
> +				suspect, isroot, XFS_ABTB_MAGIC, agcnts);
> +}

Now that we have private data bassed to the scanfuncs we could use that
to communicate if we're doing a bno or cnt scan.  Maybe writing it
directly into struct aghdr_cnts is too ugly, in that case we can have
a scan_priv structure that contains the magic and the aghdr_cnts.

>  
>  void
>  scan_freelist(

This could become static.

>   * Scan an AG for obvious corruption.
>   *
>   * Note: This code is not reentrant due to the use of global variables.

That's not true any more I think.

>   */
> -void
> -scan_ag(
> -	xfs_agnumber_t	agno)
> +void *
> +scan_ag(void *args)

Can be static.

> +#define SCAN_THREADS 32
> +
> +void
> +scan_ags(
> +	struct xfs_mount	*mp)
> +{
> +	struct aghdr_cnts agcnts[mp->m_sb.sb_agcount];
> +	pthread_t	thr[SCAN_THREADS];
> +	__uint64_t	fdblocks = 0;
> +	__uint64_t	icount = 0;
> +	__uint64_t	ifreecount = 0;
> +	int		i, j, err;
> +
> +	/*
> +	 * scan a few AGs in parallel. The scan is IO latency bound,
> +	 * so running a few at a time will speed it up significantly.
> +	 */
> +	for (i = 0; i < mp->m_sb.sb_agcount; i += SCAN_THREADS) {

I think this should use the workqueues from repair/threads.c.  Just
create a workqueue with 32 threads, and then enqueue all the AGs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
