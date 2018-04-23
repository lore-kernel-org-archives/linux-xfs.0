Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39534 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755198AbeDWNzS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Apr 2018 09:55:18 -0400
Date: Mon, 23 Apr 2018 09:54:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 07/13] xfs: refactor incore dquot initialization functions
Message-ID: <20180423135457.GG43600@bfoster.bfoster>
References: <152440954198.29601.14390250048915099607.stgit@magnolia>
 <152440959784.29601.7345409188558922914.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152440959784.29601.7345409188558922914.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de

On Sun, Apr 22, 2018 at 08:06:37AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create two incore dquot initialization functions that will help us to
> disentangle dqget and dqread.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_dquot.c |   80 +++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 50 insertions(+), 30 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 62415f1..7154909 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -491,26 +491,14 @@ xfs_qm_dqtobp(
>  	return 0;
>  }
>  
> -
> -/*
> - * Read in the ondisk dquot using dqtobp() then copy it to an incore version,
> - * and release the buffer immediately.
> - *
> - * If XFS_QMOPT_DQALLOC is set, allocate a dquot on disk if it needed.
> - */
> -int
> -xfs_qm_dqread(
> +/* Allocate and initialize everything we need for an incore dquot. */
> +STATIC struct xfs_dquot *
> +xfs_qm_dqinit_once(

I find the init_once() naming confusing. How about something more
straightforward like xfs_dquot_alloc()?

>  	struct xfs_mount	*mp,
>  	xfs_dqid_t		id,
> -	uint			type,
> -	uint			flags,
> -	struct xfs_dquot	**O_dqpp)
> +	uint			type)
>  {
>  	struct xfs_dquot	*dqp;
> -	struct xfs_disk_dquot	*ddqp;
> -	struct xfs_buf		*bp;
> -	struct xfs_trans	*tp = NULL;
> -	int			error;
>  
>  	dqp = kmem_zone_zalloc(xfs_qm_dqzone, KM_SLEEP);
>  
> @@ -549,7 +537,52 @@ xfs_qm_dqread(
>  	}
>  
>  	XFS_STATS_INC(mp, xs_qm_dquot);
> +	return dqp;
> +}
> +
> +/* Copy the in-core quota fields in from the on-disk buffer. */
> +STATIC void
> +xfs_qm_dqinit_from_buf(
> +	struct xfs_dquot	*dqp,
> +	struct xfs_disk_dquot	*ddqp)
> +{
> +	/* copy everything from disk dquot to the incore dquot */
> +	memcpy(&dqp->q_core, ddqp, sizeof(xfs_disk_dquot_t));
> +	xfs_qm_dquot_logitem_init(dqp);

I wonder if the logitem init should really be part of the "init from
buf" helper?

Otherwise looks fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +
> +	/*
> +	 * Reservation counters are defined as reservation plus current usage
> +	 * to avoid having to add every time.
> +	 */
> +	dqp->q_res_bcount = be64_to_cpu(ddqp->d_bcount);
> +	dqp->q_res_icount = be64_to_cpu(ddqp->d_icount);
> +	dqp->q_res_rtbcount = be64_to_cpu(ddqp->d_rtbcount);
> +
> +	/* initialize the dquot speculative prealloc thresholds */
> +	xfs_dquot_set_prealloc_limits(dqp);
> +}
> +
> +/*
> + * Read in the ondisk dquot using dqtobp() then copy it to an incore version,
> + * and release the buffer immediately.
> + *
> + * If XFS_QMOPT_DQALLOC is set, allocate a dquot on disk if it needed.
> + */
> +int
> +xfs_qm_dqread(
> +	struct xfs_mount	*mp,
> +	xfs_dqid_t		id,
> +	uint			type,
> +	uint			flags,
> +	struct xfs_dquot	**O_dqpp)
> +{
> +	struct xfs_dquot	*dqp;
> +	struct xfs_disk_dquot	*ddqp;
> +	struct xfs_buf		*bp;
> +	struct xfs_trans	*tp = NULL;
> +	int			error;
>  
> +	dqp = xfs_qm_dqinit_once(mp, id, type);
>  	trace_xfs_dqread(dqp);
>  
>  	if (flags & XFS_QMOPT_DQALLOC) {
> @@ -574,20 +607,7 @@ xfs_qm_dqread(
>  		goto error1;
>  	}
>  
> -	/* copy everything from disk dquot to the incore dquot */
> -	memcpy(&dqp->q_core, ddqp, sizeof(xfs_disk_dquot_t));
> -	xfs_qm_dquot_logitem_init(dqp);
> -
> -	/*
> -	 * Reservation counters are defined as reservation plus current usage
> -	 * to avoid having to add every time.
> -	 */
> -	dqp->q_res_bcount = be64_to_cpu(ddqp->d_bcount);
> -	dqp->q_res_icount = be64_to_cpu(ddqp->d_icount);
> -	dqp->q_res_rtbcount = be64_to_cpu(ddqp->d_rtbcount);
> -
> -	/* initialize the dquot speculative prealloc thresholds */
> -	xfs_dquot_set_prealloc_limits(dqp);
> +	xfs_qm_dqinit_from_buf(dqp, ddqp);
>  
>  	/* Mark the buf so that this will stay incore a little longer */
>  	xfs_buf_set_ref(bp, XFS_DQUOT_REF);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
