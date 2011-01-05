Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p05Ne9Vx248372 for <xfs@oss.sgi.com>; Wed, 5 Jan 2011 17:40:09 -0600
Subject: Re: [PATCH] xfs_repair: multithread phase 2
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1294121588-17233-1-git-send-email-david@fromorbit.com>
References: <1294121588-17233-1-git-send-email-david@fromorbit.com>
Date: Wed, 05 Jan 2011 17:42:14 -0600
Message-ID: <1294270934.2312.105.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Tue, 2011-01-04 at 17:13 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Running some recent repair tests on broken filesystem meant running
> phase 1 and 2 repeatedly to reproduce an issue at the start of phase
> 3. Phase 2 was taking approximately 10 minutes to run as it
> processes each AG serially.
> 
> Phase 2 can be trivially parallelised - it is simply scanning the
> per AG trees to calculate free block counts and free and used inodes
> counts. This can be done safely in parallel by giving each AG it's
> own structure to aggregate counts into, then once the AG scan is
> complete adding them all together.
> 
> This patch uses 32-way threading which results in no noticable
> slowdown on single SATA drives with NCQ, but results in ~10x
> reduction in runtime on a 12 disk RAID-0 array.

This is great.  And evidently not very hard at all.  It should
have been done a long time ago...

I had a few of the same comments Christoph had (though
I didn't know about the the workqueues).  I'll reiterate
one, that SCAN_THREADS should be a command line option.
32 is a fine default, but there's no sense in restricting
it to that.

A few other things, below, but this looks good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  repair/phase2.c |   16 +---
>  repair/scan.c   |  303 +++++++++++++++++++++++++++++++-----------------------
>  repair/scan.h   |   37 -------
>  3 files changed, 176 insertions(+), 180 deletions(-)

. . .
 
> diff --git a/repair/scan.c b/repair/scan.c
> index 85017ff..dd62776 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c

. . .
 
> @@ -469,6 +477,34 @@ _("out-of-order bmap key (file offset) in inode %llu, %s fork, fsbno %llu\n"),
>  }
>  

Can this (and scanfunc_cnt() and scanfunc_ino()) be given
static scope now?

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
> +

. . .

> @@ -1155,42 +1169,15 @@ validate_agi(
>  }
. . .
> -void
> -scan_ag(
> -	xfs_agnumber_t	agno)
> +void *
> +scan_ag(void *args)

Maybe arg (singular)

>  {
> +	struct aghdr_cnts *agcnts = args;
> +	xfs_agnumber_t	agno = agcnts->agno;
>  	xfs_agf_t	*agf;
>  	xfs_buf_t	*agfbuf;
>  	int		agf_dirty = 0;

. . .

> @@ -1331,4 +1308,72 @@ scan_ag(
>  		libxfs_putbuf(sbbuf);
>  	free(sb);
>  	PROG_RPT_INC(prog_rpt_done[agno], 1);
> +
> +#ifdef XR_INODE_TRACE
> +	print_inode_list(i);

I know this is only under XR_INODE_TRACE, but
now that you're multi-threading these, the
output can get interleaved and therefore
somewhat useless.  Maybe you could adjust
print_inode_list() so it includes the AG
number with each line output rather than
just prior to printing all of them.

> +#endif
> +	return NULL;
> +}
> +
> +#define SCAN_THREADS 32

Make this configurable at runtime.

> +
> +void
> +scan_ags(
> +	struct xfs_mount	*mp)
> +{
> +	struct aghdr_cnts agcnts[mp->m_sb.sb_agcount];

There is some mention about the per-thread stack size
getting set at the time the program starts in the pthread
documentation.  I don't expect this will be a problem in
practice, but maybe this should be allocated dynamically.

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
> +		for (j = 0; j < SCAN_THREADS; j++) {
			xfs_agnumber_t agno = i + j;

> +			if (i + j >= mp->m_sb.sb_agcount)

			if (agno >= mp->m_sb.sg_agcount)
				(and so on, throughout this section)

> +				break;
> +			memset(&agcnts[i + j], 0, sizeof(agcnts[i]));
							agcnts[i + j]

> +			agcnts[i + j].agno = i + j;
> +			err = pthread_create(&thr[j], NULL, scan_ag,
> +							&agcnts[i + j]);
> +			if (err)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
