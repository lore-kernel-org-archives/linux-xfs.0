Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41944 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754981AbeDWNye (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Apr 2018 09:54:34 -0400
Date: Mon, 23 Apr 2018 09:54:20 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/13] xfs: refactor XFS_QMOPT_DQNEXT out of existence
Message-ID: <20180423135418.GA43600@bfoster.bfoster>
References: <152440954198.29601.14390250048915099607.stgit@magnolia>
 <152440955861.29601.18309284922689232857.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152440955861.29601.18309284922689232857.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de

On Sun, Apr 22, 2018 at 08:05:58AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> There's only one caller of DQNEXT and its semantics can be moved into a
> separate function, so create the function and get rid of the flag.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_quota_defs.h |    1 
>  fs/xfs/scrub/quota.c           |    3 -
>  fs/xfs/xfs_dquot.c             |   63 ++++++++++++++------------
>  fs/xfs/xfs_dquot.h             |    2 +
>  fs/xfs/xfs_qm.h                |    6 ++-
>  fs/xfs/xfs_qm_syscalls.c       |   96 +++++++++++++++++++++++++++-------------
>  fs/xfs/xfs_quotaops.c          |    8 +--
>  7 files changed, 108 insertions(+), 71 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index bb1b13a..c80b226 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -114,7 +114,6 @@ typedef uint16_t	xfs_qwarncnt_t;
>  #define XFS_QMOPT_SBVERSION	0x0000040 /* change superblock version num */
>  #define XFS_QMOPT_GQUOTA	0x0002000 /* group dquot requested */
>  #define XFS_QMOPT_ENOSPC	0x0004000 /* enospc instead of edquot (prj) */
> -#define XFS_QMOPT_DQNEXT	0x0008000 /* return next dquot >= this ID */
>  
>  /*
>   * flags to xfs_trans_mod_dquot to indicate which field needs to be
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index 6ba465e..50415e8 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -268,8 +268,7 @@ xfs_scrub_quota(
>  		if (xfs_scrub_should_terminate(sc, &error))
>  			break;
>  
> -		error = xfs_qm_dqget(mp, NULL, id, dqtype, XFS_QMOPT_DQNEXT,
> -				&dq);
> +		error = xfs_qm_dqget_next(mp, id, dqtype, &dq);
>  		if (error == -ENOENT)
>  			break;
>  		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK,
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index a7daef9..79a9df6 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -728,18 +728,6 @@ xfs_qm_dqget(
>  			goto restart;
>  		}
>  
> -		/* uninit / unused quota found in radix tree, keep looking  */
> -		if (flags & XFS_QMOPT_DQNEXT) {
> -			if (XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
> -				xfs_dqunlock(dqp);
> -				mutex_unlock(&qi->qi_tree_lock);
> -				error = xfs_dq_get_next_id(mp, type, &id);
> -				if (error)
> -					return error;
> -				goto restart;
> -			}
> -		}
> -
>  		dqp->q_nrefs++;
>  		mutex_unlock(&qi->qi_tree_lock);
>  
> @@ -766,13 +754,6 @@ xfs_qm_dqget(
>  	if (ip)
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  
> -	/* If we are asked to find next active id, keep looking */
> -	if (error == -ENOENT && (flags & XFS_QMOPT_DQNEXT)) {
> -		error = xfs_dq_get_next_id(mp, type, &id);
> -		if (!error)
> -			goto restart;
> -	}
> -
>  	if (error)
>  		return error;
>  
> @@ -823,17 +804,6 @@ xfs_qm_dqget(
>  	qi->qi_dquots++;
>  	mutex_unlock(&qi->qi_tree_lock);
>  
> -	/* If we are asked to find next active id, keep looking */
> -	if (flags & XFS_QMOPT_DQNEXT) {
> -		if (XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
> -			xfs_qm_dqput(dqp);
> -			error = xfs_dq_get_next_id(mp, type, &id);
> -			if (error)
> -				return error;
> -			goto restart;
> -		}
> -	}
> -
>   dqret:
>  	ASSERT((ip == NULL) || xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  	trace_xfs_dqget_miss(dqp);
> @@ -842,6 +812,39 @@ xfs_qm_dqget(
>  }
>  
>  /*
> + * Starting at @id and progressing upwards, look for an initialized incore
> + * dquot, lock it, and return it.
> + */
> +int
> +xfs_qm_dqget_next(
> +	struct xfs_mount	*mp,
> +	xfs_dqid_t		id,
> +	uint			type,
> +	struct xfs_dquot	**dqpp)
> +{
> +	struct xfs_dquot	*dqp;
> +	int			error = 0;
> +
> +	*dqpp = NULL;
> +	for (; !error; error = xfs_dq_get_next_id(mp, type, &id)) {
> +		error = xfs_qm_dqget(mp, NULL, id, type, 0, &dqp);
> +		if (error == -ENOENT)
> +			continue;
> +		else if (error != 0)
> +			break;
> +
> +		if (!XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
> +			*dqpp = dqp;
> +			return 0;
> +		}
> +
> +		xfs_qm_dqput(dqp);
> +	}
> +
> +	return error;
> +}
> +
> +/*
>   * Release a reference to the dquot (decrement ref-count) and unlock it.
>   *
>   * If there is a group quota attached to this dquot, carefully release that
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 2f536f3..303e71d 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -171,6 +171,8 @@ extern void		xfs_qm_adjust_dqlimits(struct xfs_mount *,
>  					       struct xfs_dquot *);
>  extern int		xfs_qm_dqget(xfs_mount_t *, xfs_inode_t *,
>  					xfs_dqid_t, uint, uint, xfs_dquot_t **);
> +extern int		xfs_qm_dqget_next(struct xfs_mount *mp, xfs_dqid_t id,
> +					uint type, struct xfs_dquot **dqpp);
>  extern void		xfs_qm_dqput(xfs_dquot_t *);
>  
>  extern void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 2975a82..e3129b2 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -170,8 +170,10 @@ extern void		xfs_qm_dqrele_all_inodes(struct xfs_mount *, uint);
>  
>  /* quota ops */
>  extern int		xfs_qm_scall_trunc_qfiles(struct xfs_mount *, uint);
> -extern int		xfs_qm_scall_getquota(struct xfs_mount *, xfs_dqid_t *,
> -					uint, struct qc_dqblk *, uint);
> +extern int		xfs_qm_scall_getquota(struct xfs_mount *, xfs_dqid_t,
> +					uint, struct qc_dqblk *);
> +extern int		xfs_qm_scall_getquota_next(struct xfs_mount *,
> +					xfs_dqid_t *, uint, struct qc_dqblk *);
>  extern int		xfs_qm_scall_setqlim(struct xfs_mount *, xfs_dqid_t, uint,
>  					struct qc_dqblk *);
>  extern int		xfs_qm_scall_quotaon(struct xfs_mount *, uint);
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 9cb5c38..0234cfc 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -622,39 +622,14 @@ xfs_qm_log_quotaoff(
>  	return error;
>  }
>  
> -
> -int
> -xfs_qm_scall_getquota(
> +/* Fill out the quota context. */
> +static void
> +xfs_qm_scall_getquota_fill_qc(
>  	struct xfs_mount	*mp,
> -	xfs_dqid_t		*id,
>  	uint			type,
> -	struct qc_dqblk		*dst,
> -	uint			dqget_flags)
> +	const struct xfs_dquot	*dqp,
> +	struct qc_dqblk		*dst)
>  {
> -	struct xfs_dquot	*dqp;
> -	int			error;
> -
> -	/*
> -	 * Try to get the dquot. We don't want it allocated on disk, so
> -	 * we aren't passing the XFS_QMOPT_DOALLOC flag. If it doesn't
> -	 * exist, we'll get ENOENT back.
> -	 */
> -	error = xfs_qm_dqget(mp, NULL, *id, type, dqget_flags, &dqp);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * If everything's NULL, this dquot doesn't quite exist as far as
> -	 * our utility programs are concerned.
> -	 */
> -	if (XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
> -		error = -ENOENT;
> -		goto out_put;
> -	}
> -
> -	/* Fill in the ID we actually read from disk */
> -	*id = be32_to_cpu(dqp->q_core.d_id);
> -
>  	memset(dst, 0, sizeof(*dst));
>  	dst->d_spc_hardlimit =
>  		XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_blk_hardlimit));
> @@ -696,7 +671,7 @@ xfs_qm_scall_getquota(
>  	if (((XFS_IS_UQUOTA_ENFORCED(mp) && type == XFS_DQ_USER) ||
>  	     (XFS_IS_GQUOTA_ENFORCED(mp) && type == XFS_DQ_GROUP) ||
>  	     (XFS_IS_PQUOTA_ENFORCED(mp) && type == XFS_DQ_PROJ)) &&
> -	    *id != 0) {
> +	    dqp->q_core.d_id != 0) {
>  		if ((dst->d_space > dst->d_spc_softlimit) &&
>  		    (dst->d_spc_softlimit > 0)) {
>  			ASSERT(dst->d_spc_timer != 0);
> @@ -707,11 +682,70 @@ xfs_qm_scall_getquota(
>  		}
>  	}
>  #endif
> +}
> +
> +/* Return the quota information for the dquot matching id. */
> +int
> +xfs_qm_scall_getquota(
> +	struct xfs_mount	*mp,
> +	xfs_dqid_t		id,
> +	uint			type,
> +	struct qc_dqblk		*dst)
> +{
> +	struct xfs_dquot	*dqp;
> +	int			error;
> +
> +	/*
> +	 * Try to get the dquot. We don't want it allocated on disk, so
> +	 * we aren't passing the XFS_QMOPT_DOALLOC flag. If it doesn't
> +	 * exist, we'll get ENOENT back.
> +	 */
> +	error = xfs_qm_dqget(mp, NULL, id, type, 0, &dqp);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * If everything's NULL, this dquot doesn't quite exist as far as
> +	 * our utility programs are concerned.
> +	 */
> +	if (XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
> +		error = -ENOENT;
> +		goto out_put;
> +	}
> +
> +	xfs_qm_scall_getquota_fill_qc(mp, type, dqp, dst);
> +
>  out_put:
>  	xfs_qm_dqput(dqp);
>  	return error;
>  }
>  
> +/*
> + * Return the quota information for the first initialized dquot whose id
> + * is at least as high as id.
> + */
> +int
> +xfs_qm_scall_getquota_next(
> +	struct xfs_mount	*mp,
> +	xfs_dqid_t		*id,
> +	uint			type,
> +	struct qc_dqblk		*dst)
> +{
> +	struct xfs_dquot	*dqp;
> +	int			error;
> +
> +	error = xfs_qm_dqget_next(mp, *id, type, &dqp);
> +	if (error)
> +		return error;
> +
> +	/* Fill in the ID we actually read from disk */
> +	*id = be32_to_cpu(dqp->q_core.d_id);
> +
> +	xfs_qm_scall_getquota_fill_qc(mp, type, dqp, dst);
> +
> +	xfs_qm_dqput(dqp);
> +	return error;
> +}
>  
>  STATIC int
>  xfs_dqrele_inode(
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index a651085..c93fc91 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -239,8 +239,7 @@ xfs_fs_get_dqblk(
>  		return -ESRCH;
>  
>  	id = from_kqid(&init_user_ns, qid);
> -	return xfs_qm_scall_getquota(mp, &id,
> -				      xfs_quota_type(qid.type), qdq, 0);
> +	return xfs_qm_scall_getquota(mp, id, xfs_quota_type(qid.type), qdq);
>  }
>  
>  /* Return quota info for active quota >= this qid */
> @@ -260,9 +259,8 @@ xfs_fs_get_nextdqblk(
>  		return -ESRCH;
>  
>  	id = from_kqid(&init_user_ns, *qid);
> -	ret = xfs_qm_scall_getquota(mp, &id,
> -				    xfs_quota_type(qid->type), qdq,
> -				    XFS_QMOPT_DQNEXT);
> +	ret = xfs_qm_scall_getquota_next(mp, &id, xfs_quota_type(qid->type),
> +			qdq);
>  	if (ret)
>  		return ret;
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
