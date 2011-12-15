Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBFGxuT3015461 for <xfs@oss.sgi.com>; Thu, 15 Dec 2011 10:59:56 -0600
Date: Thu, 15 Dec 2011 11:00:21 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 17/19] xfs: merge xfs_qm_dqinit_core into the only caller
Message-ID: <20111215170021.GK29840@sgi.com>
References: <20111206215806.844405397@bombadil.infradead.org>
	<20111206215855.635965028@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206215855.635965028@bombadil.infradead.org>
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

On Tue, Dec 06, 2011 at 04:58:23PM -0500, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>

> ---
>  fs/xfs/xfs_dquot.c |   27 +++++++--------------------
>  1 file changed, 7 insertions(+), 20 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_dquot.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dquot.c	2011-11-25 11:56:36.905143783 +0100
> +++ xfs/fs/xfs/xfs_dquot.c	2011-11-25 11:56:40.861789014 +0100
> @@ -154,24 +154,6 @@ xfs_qm_dqdestroy(
>  }
>  
>  /*
> - * This is what a 'fresh' dquot inside a dquot chunk looks like on disk.
> - */
> -STATIC void
> -xfs_qm_dqinit_core(
> -	xfs_dqid_t	id,
> -	uint		type,
> -	xfs_dqblk_t	*d)
> -{
> -	/*
> -	 * Caller has zero'd the entire dquot 'chunk' already.
> -	 */
> -	d->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
> -	d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
> -	d->dd_diskdq.d_id = cpu_to_be32(id);
> -	d->dd_diskdq.d_flags = type;
> -}
> -
> -/*
>   * If default limits are in force, push them into the dquot now.
>   * We overwrite the dquot limits only if they are zero and this
>   * is not the root dquot.
> @@ -327,8 +309,13 @@ xfs_qm_init_dquot_blk(
>  	curid = id - (id % q->qi_dqperchunk);
>  	ASSERT(curid >= 0);
>  	memset(d, 0, BBTOB(q->qi_dqchunklen));
> -	for (i = 0; i < q->qi_dqperchunk; i++, d++, curid++)
> -		xfs_qm_dqinit_core(curid, type, d);
> +	for (i = 0; i < q->qi_dqperchunk; i++, d++, curid++) {
> +		d->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
> +		d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
> +		d->dd_diskdq.d_id = cpu_to_be32(curid);
> +		d->dd_diskdq.d_flags = type;
> +	}
> +
>  	xfs_trans_dquot_buf(tp, bp,
>  			    (type & XFS_DQ_USER ? XFS_BLF_UDQUOT_BUF :
>  			    ((type & XFS_DQ_PROJ) ? XFS_BLF_PDQUOT_BUF :
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
