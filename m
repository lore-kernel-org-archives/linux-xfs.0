Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47390 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754662AbeEANo5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 May 2018 09:44:57 -0400
Date: Tue, 1 May 2018 09:44:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 09/13] xfs: remove xfs_qm_dqread flags argument
Message-ID: <20180501134454.GB4525@bfoster.bfoster>
References: <152506698177.21553.13500862866416804148.stgit@magnolia>
 <152506705098.21553.6894396720813018127.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152506705098.21553.6894396720813018127.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de

On Sun, Apr 29, 2018 at 10:44:11PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the _qm_dqread functionality to _qm_dqensure, then remove the flags
> argument from xfs_qm_dqread since the only DQALLOC users were internal
> to xfs_dquot.c anyway.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_dquot.c |   37 +++++++++++++++++++++++--------------
>  fs/xfs/xfs_dquot.h |    6 +++---
>  fs/xfs/xfs_qm.c    |    4 ++--
>  3 files changed, 28 insertions(+), 19 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index d8730f6110b8..7a343b571ea9 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -521,16 +521,15 @@ xfs_dquot_from_disk(
>  
>  /*
>   * Read in the ondisk dquot using dqtobp() then copy it to an incore version,
> - * and release the buffer immediately.
> - *
> - * If XFS_QMOPT_DQALLOC is set, allocate a dquot on disk if it needed.
> + * and release the buffer immediately.  If @can_alloc is specified, fill any
> + * holes in the on-disk metadata.
>   */
> -int
> -xfs_qm_dqread(
> +STATIC int
> +xfs_dquot_setup(
>  	struct xfs_mount	*mp,
>  	xfs_dqid_t		id,
>  	uint			type,
> -	uint			flags,
> +	bool			can_alloc,
>  	struct xfs_dquot	**dqpp)
>  {
>  	struct xfs_dquot	*dqp;
> @@ -543,7 +542,7 @@ xfs_qm_dqread(
>  
>  	/* Try to read the buffer... */
>  	error = xfs_dquot_disk_read(mp, dqp, &bp);
> -	if (error == -ENOENT && (flags & XFS_QMOPT_DQALLOC)) {
> +	if (error == -ENOENT && can_alloc) {
>  		/* ...or allocate a new block and buffer. */
>  		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_dqalloc,
>  				XFS_QM_DQALLOC_SPACE_RES(mp), 0, 0, &tp);
> @@ -581,6 +580,20 @@ xfs_qm_dqread(
>  	return error;
>  }
>  
> +/*
> + * Read in the ondisk dquot using dqtobp() then copy it to an incore version,
> + * and release the buffer immediately.
> + */
> +int
> +xfs_qm_dqread(
> +	struct xfs_mount	*mp,
> +	xfs_dqid_t		id,
> +	uint			type,
> +	struct xfs_dquot	**dqpp)
> +{
> +	return xfs_dquot_setup(mp, id, type, false, dqpp);
> +}
> +
>  /*
>   * Advance to the next id in the current chunk, or if at the
>   * end of the chunk, skip ahead to first id in next allocated chunk
> @@ -746,7 +759,7 @@ xfs_qm_dqget(
>  	struct xfs_mount	*mp,
>  	xfs_dqid_t		id,
>  	uint			type,
> -	uint			flags,	  /* DQALLOC, DQSUSER, DQREPAIR, DOWARN */
> +	uint			flags,	/* DQALLOC, DQSUSER, DQREPAIR, DOWARN */
>  	struct xfs_dquot	**O_dqpp)
>  {
>  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> @@ -765,7 +778,7 @@ xfs_qm_dqget(
>  		return 0;
>  	}
>  
> -	error = xfs_qm_dqread(mp, id, type, flags, &dqp);
> +	error = xfs_dquot_setup(mp, id, type, flags & XFS_QMOPT_DQALLOC, &dqp);
>  	if (error)
>  		return error;
>  
> @@ -820,16 +833,12 @@ xfs_qm_dqget_inode(
>  	struct radix_tree_root	*tree = xfs_dquot_tree(qi, type);
>  	struct xfs_dquot	*dqp;
>  	xfs_dqid_t		id;
> -	uint			flags = 0;
>  	int			error;
>  
>  	error = xfs_qm_dqget_checks(mp, type);
>  	if (error)
>  		return error;
>  
> -	if (can_alloc)
> -		flags |= XFS_QMOPT_DQALLOC;
> -
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  	ASSERT(xfs_inode_dquot(ip, type) == NULL);
>  
> @@ -850,7 +859,7 @@ xfs_qm_dqget_inode(
>  	 * we re-acquire the lock.
>  	 */
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -	error = xfs_qm_dqread(mp, id, type, flags, &dqp);
> +	error = xfs_dquot_setup(mp, id, type, can_alloc, &dqp);
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	if (error)
>  		return error;
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 8a5b30e952b0..486a1b475574 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -160,8 +160,8 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
>  #define XFS_QM_ISPDQ(dqp)	((dqp)->dq_flags & XFS_DQ_PROJ)
>  #define XFS_QM_ISGDQ(dqp)	((dqp)->dq_flags & XFS_DQ_GROUP)
>  
> -extern int		xfs_qm_dqread(struct xfs_mount *, xfs_dqid_t, uint,
> -					uint, struct xfs_dquot	**);
> +extern int		xfs_qm_dqread(struct xfs_mount *mp, xfs_dqid_t id,
> +					uint type, struct xfs_dquot **dqpp);
>  extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
>  extern int		xfs_qm_dqflush(struct xfs_dquot *, struct xfs_buf **);
>  extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
> @@ -172,7 +172,7 @@ extern void		xfs_qm_adjust_dqlimits(struct xfs_mount *,
>  extern xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip,
>  					uint type);
>  extern int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
> -					uint type, uint flags,
> +					uint type, uint can_alloc,
>  					struct xfs_dquot **dqpp);
>  extern int		xfs_qm_dqget_inode(struct xfs_inode *ip, uint type,
>  					bool can_alloc,
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index fb14954610ee..9f646222c4ac 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -569,7 +569,7 @@ xfs_qm_set_defquota(
>  	struct xfs_def_quota    *defq;
>  	int			error;
>  
> -	error = xfs_qm_dqread(mp, 0, type, 0, &dqp);
> +	error = xfs_qm_dqread(mp, 0, type, &dqp);
>  
>  	if (!error) {
>  		xfs_disk_dquot_t        *ddqp = &dqp->q_core;
> @@ -647,7 +647,7 @@ xfs_qm_init_quotainfo(
>  			XFS_IS_UQUOTA_RUNNING(mp) ? XFS_DQ_USER :
>  			 (XFS_IS_GQUOTA_RUNNING(mp) ? XFS_DQ_GROUP :
>  			  XFS_DQ_PROJ),
> -			0, &dqp);
> +			&dqp);
>  
>  	if (!error) {
>  		xfs_disk_dquot_t	*ddqp = &dqp->q_core;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
