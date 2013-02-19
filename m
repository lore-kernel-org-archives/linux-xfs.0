Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 902807F4E
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 17:09:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6EF6F8F8037
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 15:09:02 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	xq478GiO2dWCq1oD for <xfs@oss.sgi.com>;
	Tue, 19 Feb 2013 15:09:00 -0800 (PST)
Date: Wed, 20 Feb 2013 10:08:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 5/7] xfs: xfs_dquot prealloc throttling watermarks and
	low free space
Message-ID: <20130219230857.GH10731@dastard>
References: <1361291851-24714-1-git-send-email-bfoster@redhat.com>
	<1361291851-24714-6-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1361291851-24714-6-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 19, 2013 at 11:37:29AM -0500, Brian Foster wrote:
> Enable tracking of high and low watermarks for preallocation
> throttling of files under quota restrictions. These values are
> calculated when the quota limit is read from disk or modified and
> cached for later use by the throttling algorithm.
> 
> The high watermark specifies when preallocation is disabled, the
> low watermark specifies when throttling is enabled and the low free
> space data structure contains precalculated low free space limits
> to serve as input to determine the level of throttling required.
> 
> Note that the low free space data structure is based on the
> existing global low free space data structure with the exception of
> using three stages (5%, 3% and 1%) rather than five to reduce the
> impact of xfs_dquot memory overhead.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_dquot.c       |   43 +++++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_dquot.h       |   13 +++++++++++++
>  fs/xfs/xfs_qm_syscalls.c |    1 +
>  3 files changed, 55 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index e1833b9..bd25be3 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -90,13 +90,18 @@ xfs_qm_adjust_dqlimits(
>  {
>  	xfs_quotainfo_t		*q = mp->m_quotainfo;
>  	xfs_disk_dquot_t	*d = &dq->q_core;
> +	int			prealloc = 0;
>  
>  	ASSERT(d->d_id);
>  
> -	if (q->qi_bsoftlimit && !d->d_blk_softlimit)
> +	if (q->qi_bsoftlimit && !d->d_blk_softlimit) {
>  		d->d_blk_softlimit = cpu_to_be64(q->qi_bsoftlimit);
> -	if (q->qi_bhardlimit && !d->d_blk_hardlimit)
> +		prealloc = 1;
> +	}
> +	if (q->qi_bhardlimit && !d->d_blk_hardlimit) {
>  		d->d_blk_hardlimit = cpu_to_be64(q->qi_bhardlimit);
> +		prealloc = 1;
> +	}
>  	if (q->qi_isoftlimit && !d->d_ino_softlimit)
>  		d->d_ino_softlimit = cpu_to_be64(q->qi_isoftlimit);
>  	if (q->qi_ihardlimit && !d->d_ino_hardlimit)
> @@ -105,6 +110,9 @@ xfs_qm_adjust_dqlimits(
>  		d->d_rtb_softlimit = cpu_to_be64(q->qi_rtbsoftlimit);
>  	if (q->qi_rtbhardlimit && !d->d_rtb_hardlimit)
>  		d->d_rtb_hardlimit = cpu_to_be64(q->qi_rtbhardlimit);
> +
> +	if (prealloc)
> +		xfs_dquot_init_prealloc(dq);

		xfs_dquot_set_prealloc_limits(dq);

Because it is used to overwrite existing limits here, not just
initialise them...

>  }
>  
>  /*
> @@ -249,6 +257,34 @@ xfs_qm_init_dquot_blk(
>  	xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
>  }
>  
> +/*
> + * Initialize the preallocation throttling watermarks and low free space table.

"Initialise the dynamic speculative preallocation thresholds." 

> + * The lo/hi watermarks correspond to the soft and hard limits by default. If a
> + * soft limit is not specified, we use 95% of the hard limit.
> + */
> +void
> +xfs_dquot_init_prealloc(struct xfs_dquot *dqp)
> +{
> +	int i;
> +	int pct = 1;
> +
> +	dqp->q_prealloc_hi_wmark = be64_to_cpu(dqp->q_core.d_blk_hardlimit);
> +	dqp->q_prealloc_lo_wmark = be64_to_cpu(dqp->q_core.d_blk_softlimit);
> +	if (!dqp->q_prealloc_lo_wmark) {
> +		dqp->q_prealloc_lo_wmark = dqp->q_prealloc_hi_wmark;
> +		do_div(dqp->q_prealloc_lo_wmark, 100);
> +		dqp->q_prealloc_lo_wmark *= 95;
> +	}
> +
> +	for (i = 0; i < XFS_QLOWSP_MAX; i++) {
> +		__uint64_t space = dqp->q_prealloc_hi_wmark;
> +
> +		do_div(space, 100);
> +		dqp->q_low_space[i] = space * pct;
> +		pct += XFS_QLOWSP_PCNT_INCR;
> +	}

This seems kind of obscure. It's just a simple assignment of 3
values, so why not just unroll the loop like so:

	__uint64_t space = dqp->q_prealloc_hi_wmark;

	do_div(space, 100);
	dqp->q_low_space[XFS_QLOWSP_1_PCNT] = space;
	dqp->q_low_space[XFS_QLOWSP_3_PCNT] = space * 3
	dqp->q_low_space[XFS_QLOWSP_5_PCNT] = space * 5;

And it effectively documents itself.

I know the mount lowspace array is initialised in a loop, but it has
a fairly obvious per-iteration increment of 1 percent....

> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -32,6 +32,14 @@
>  struct xfs_mount;
>  struct xfs_trans;
>  
> +enum {
> +	XFS_QLOWSP_1_PCNT = 0,
> +	XFS_QLOWSP_3_PCNT,
> +	XFS_QLOWSP_5_PCNT,
> +	XFS_QLOWSP_MAX
> +};
> +#define XFS_QLOWSP_PCNT_INCR 2

And gets rid of this strange vowel-challenged XFS_QLOWSP_PCNT_INCR
thingy....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
