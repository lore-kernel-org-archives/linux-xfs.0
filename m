Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBFK7BVq021646 for <xfs@oss.sgi.com>; Thu, 15 Dec 2011 14:07:11 -0600
Date: Thu, 15 Dec 2011 14:07:36 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 18/19] xfs: kill xfs_qm_idtodq
Message-ID: <20111215200736.GL29840@sgi.com>
References: <20111206215806.844405397@bombadil.infradead.org>
	<20111206215855.775568812@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206215855.775568812@bombadil.infradead.org>
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

On Tue, Dec 06, 2011 at 04:58:24PM -0500, Christoph Hellwig wrote:
> This function doesn't help the code flow, so merge the dquot allocation and
> transaction handling into xfs_qm_dqread.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>

> ---
>  fs/xfs/xfs_dquot.c |  137 +++++++++++++++++++----------------------------------
>  1 file changed, 50 insertions(+), 87 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_dquot.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dquot.c	2011-12-06 15:53:53.153697880 +0100
> +++ xfs/fs/xfs/xfs_dquot.c	2011-12-06 15:56:37.910367600 +0100
> @@ -550,36 +550,62 @@ xfs_qm_dqtobp(
>   * Read in the ondisk dquot using dqtobp() then copy it to an incore version,
>   * and release the buffer immediately.
>   *
> + * If XFS_QMOPT_DQALLOC is set, allocate a dquot on disk if it needed.
>   */
> -/* ARGSUSED */
>  STATIC int
>  xfs_qm_dqread(
> -	xfs_trans_t	**tpp,
> -	xfs_dqid_t	id,
> -	xfs_dquot_t	*dqp,	/* dquot to get filled in */
> -	uint		flags)
> +	struct xfs_mount	*mp,
> +	xfs_dqid_t		id,
> +	uint			type,
> +	uint			flags,
> +	struct xfs_dquot	**O_dqpp)
>  {
> -	xfs_disk_dquot_t *ddqp;
> -	xfs_buf_t	 *bp;
> -	int		 error;
> -	xfs_trans_t	 *tp;
> +	struct xfs_dquot	*dqp;
> +	struct xfs_disk_dquot	*ddqp;
> +	struct xfs_buf		*bp;
> +	struct xfs_trans	*tp = NULL;
> +	int			error;
> +	int			cancelflags = 0;
>  
> -	ASSERT(tpp);
> +	dqp = xfs_qm_dqinit(mp, id, type);
>  
>  	trace_xfs_dqread(dqp);
>  
> +	if (flags & XFS_QMOPT_DQALLOC) {
> +		tp = xfs_trans_alloc(mp, XFS_TRANS_QM_DQALLOC);
> +		error = xfs_trans_reserve(tp, XFS_QM_DQALLOC_SPACE_RES(mp),
> +				XFS_WRITE_LOG_RES(mp) +
> +				/*
> +				 * Round the chunklen up to the next multiple
> +				 * of 128 (buf log item chunk size)).
> +				 */

Thanks for the comment.  ;)

> +				BBTOB(mp->m_quotainfo->qi_dqchunklen) - 1 + 128,
> +				0,
> +				XFS_TRANS_PERM_LOG_RES,
> +				XFS_WRITE_LOG_COUNT);
> +		if (error)
> +			goto error1;
> +		cancelflags = XFS_TRANS_RELEASE_LOG_RES;
> +	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
