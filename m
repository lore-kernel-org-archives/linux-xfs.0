Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB56G2FI116875 for <xfs@oss.sgi.com>; Mon, 5 Dec 2011 00:16:02 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E6DF1F4162D
	for <xfs@oss.sgi.com>; Sun,  4 Dec 2011 22:15:57 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	d2ZdHHWkCjoCcF0D for <xfs@oss.sgi.com>;
	Sun, 04 Dec 2011 22:15:57 -0800 (PST)
Date: Mon, 5 Dec 2011 16:31:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 15/16] xfs: kill xfs_qm_idtodq
Message-ID: <20111205053131.GV7046@dastard>
References: <20111128082722.604873274@bombadil.infradead.org>
	<20111128082838.888554428@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111128082838.888554428@bombadil.infradead.org>
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

On Mon, Nov 28, 2011 at 03:27:37AM -0500, Christoph Hellwig wrote:
> This function doesn't help the code flow, so merge the dquot allocation and
> transaction handling into xfs_qm_dqread.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This version is much easier to follow.

Couple of small things:

> ---
>  fs/xfs/xfs_dquot.c |  134 ++++++++++++++++++-----------------------------------
>  1 file changed, 47 insertions(+), 87 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_dquot.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dquot.c	2011-11-25 11:56:40.861789014 +0100
> +++ xfs/fs/xfs/xfs_dquot.c	2011-11-25 11:56:42.488446869 +0100
> @@ -550,36 +550,59 @@ xfs_qm_dqtobp(
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
> +	xfs_dqid_t   		id,
                  ^^^ whitespace damage
> +	uint	     		type,
                ^^^^^ whitespace damage

> +	uint			flags,
> +	struct xfs_dquot	**O_dqpp)
>  {
> -	xfs_disk_dquot_t *ddqp;
> -	xfs_buf_t	 *bp;
> -	int		 error;
> -	xfs_trans_t	 *tp;
> +	struct xfs_dquot	*dqp;
> +	struct xfs_disk_dquot	*ddqp;
> +	struct xfs_buf		 *bp;
> +	struct xfs_trans	 *tp = NULL;
> +	int			 error;
> +	int			cancelflags = 0;

Extra whitespace in the bp/tp/error declarations.

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
> +				BBTOB(mp->m_quotainfo->qi_dqchunklen) - 1 +
> +				128,

That reservation value is asking for a macro or separate variable
and a comment explaining it....

therwise, looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
