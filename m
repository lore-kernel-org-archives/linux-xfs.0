Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 905627F37
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 22:59:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 65E738F8033
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 20:59:50 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id aQJKPEmYkTCUrdvs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 12 May 2013 20:59:46 -0700 (PDT)
Message-ID: <51906528.3030307@oracle.com>
Date: Mon, 13 May 2013 11:59:36 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v8 2/5] xfs: Add pquota fields where gquota is used.
References: <1368220889-25188-1-git-send-email-sekharan@us.ibm.com>
	<1368220889-25188-3-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1368220889-25188-3-git-send-email-sekharan@us.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

Hi,

On 05/11/2013 05:21 AM, Chandra Seetharaman wrote:
> Add project quota changes to all the places where group quota field
> is used:
>    * add separate project quota members into various structures
>    * split project quota and group quotas so that instead of overriding
>      the group quota members incore, the new project quota members are
>      used instead
>    * get rid of usage of the OQUOTA flag incore, in favor of separate
>    * group
>      and project quota flags.
>    * add a project dquot argument to various functions.
> 
> No externally visible interfaces changed.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  fs/xfs/xfs_dquot.c       |   33 ++++-
>  fs/xfs/xfs_dquot.h       |   13 +-
>  fs/xfs/xfs_icache.c      |    4 +-
>  fs/xfs/xfs_inode.h       |    1 +
>  fs/xfs/xfs_ioctl.c       |   14 +-
>  fs/xfs/xfs_iops.c        |    4 +-
>  fs/xfs/xfs_qm.c          |  355 ++++++++++++++++++++++++++++++----------------
>  fs/xfs/xfs_qm.h          |   53 +++++---
>  fs/xfs/xfs_qm_bhv.c      |    2 +-
>  fs/xfs/xfs_qm_syscalls.c |   19 ++-
>  fs/xfs/xfs_quota.h       |   32 +++--
>  fs/xfs/xfs_super.c       |    5 +-
>  fs/xfs/xfs_symlink.c     |   13 ++-
>  fs/xfs/xfs_trans_dquot.c |   94 +++++++------
>  fs/xfs/xfs_vnodeops.c    |   12 +-
>  15 files changed, 416 insertions(+), 238 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index a41f8bf..a25ba5d 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -68,8 +68,7 @@ static struct lock_class_key xfs_dquot_other_class;
>   * This is called to free all the memory associated with a dquot
>   */
>  void
> -xfs_qm_dqdestroy(
> -	xfs_dquot_t	*dqp)
> +xfs_qm_dqdestroy(xfs_dquot_t	*dqp)
>  {
>  	ASSERT(list_empty(&dqp->q_lru));
>  
> @@ -568,6 +567,17 @@ xfs_qm_dqrepair(
>  	return 0;
>  }
>  
> +struct xfs_inode *
> +xfs_dq_to_quota_inode(struct xfs_dquot *dqp)
> +{
> +	if (XFS_QM_ISUDQ(dqp))
> +		return dqp->q_mount->m_quotainfo->qi_uquotaip;
> +	if (XFS_QM_ISGDQ(dqp))
> +		return dqp->q_mount->m_quotainfo->qi_gquotaip;
> +	ASSERT(XFS_QM_ISPDQ(dqp));
> +	return dqp->q_mount->m_quotainfo->qi_pquotaip;
> +}
Is it better to replace above conditional judgment with 'switch...case'?
i.e.
static inline struct xfs_inode *
xfs_dq_to_qip(struct xfs_dquot *dqp)
{
	switch (dqp->dq_flags) {
	case XFS_DQ_USER:
		return dqp->q_mount->m_quotainfo->qi_uquotaip;
	case XFS_DQ_GROUP:
		return dqp->q_mount->m_quotainfo->qi_gqoutaip;
	case XFS_DQ_PROJ:
		return dqp->q_mount->m_quotainfo->qi_pquotaip;
	}

	ASSERT(0);
	return NULL;
}
> +
>  /*
>   * Maps a dquot to the buffer containing its on-disk version.
>   * This returns a ptr to the buffer containing the on-disk dquot
> @@ -584,7 +594,7 @@ xfs_qm_dqtobp(
>  	xfs_bmbt_irec_t map;
>  	int		nmaps = 1, error;
>  	xfs_buf_t	*bp;
> -	xfs_inode_t	*quotip = XFS_DQ_TO_QIP(dqp);
> +	xfs_inode_t	*quotip = xfs_dq_to_quota_inode(dqp);
>  	xfs_mount_t	*mp = dqp->q_mount;
>  	xfs_dqid_t	id = be32_to_cpu(dqp->q_core.d_id);
>  	xfs_trans_t	*tp = (tpp ? *tpp : NULL);
> @@ -815,7 +825,7 @@ xfs_qm_dqget(
>  	xfs_dquot_t	**O_dqpp) /* OUT : locked incore dquot */
>  {
>  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> -	struct radix_tree_root *tree = XFS_DQUOT_TREE(qi, type);
> +	struct radix_tree_root *tree = xfs_dquot_tree(qi, type);
>  	struct xfs_dquot	*dqp;
>  	int			error;
>  
> @@ -947,6 +957,7 @@ xfs_qm_dqput_final(
>  {
>  	struct xfs_quotainfo	*qi = dqp->q_mount->m_quotainfo;
>  	struct xfs_dquot	*gdqp;
> +	struct xfs_dquot	*pdqp;
>  
>  	trace_xfs_dqput_free(dqp);
>  
> @@ -960,21 +971,29 @@ xfs_qm_dqput_final(
>  
>  	/*
>  	 * If we just added a udquot to the freelist, then we want to release
> -	 * the gdquot reference that it (probably) has. Otherwise it'll keep
> -	 * the gdquot from getting reclaimed.
> +	 * the gdquot/pdquot reference that it (probably) has. Otherwise it'll
> +	 * keep the gdquot/pdquot from getting reclaimed.
>  	 */
>  	gdqp = dqp->q_gdquot;
>  	if (gdqp) {
>  		xfs_dqlock(gdqp);
>  		dqp->q_gdquot = NULL;
>  	}
> +
> +	pdqp = dqp->q_pdquot;
> +	if (pdqp) {
> +		xfs_dqlock(pdqp);
> +		dqp->q_pdquot = NULL;
> +	}
>  	xfs_dqunlock(dqp);
>  
>  	/*
> -	 * If we had a group quota hint, release it now.
> +	 * If we had a group/project quota hint, release it now.
>  	 */
>  	if (gdqp)
>  		xfs_qm_dqput(gdqp);
> +	if (pdqp)
> +		xfs_qm_dqput(pdqp);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 4f0ebfc..00ccbf1 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -29,7 +29,6 @@
>   * when quotas are off.
>   */
>  
> -struct xfs_mount;
>  struct xfs_trans;
>  
>  enum {
> @@ -52,7 +51,8 @@ typedef struct xfs_dquot {
>  	int		 q_bufoffset;	/* off of dq in buffer (# dquots) */
>  	xfs_fileoff_t	 q_fileoffset;	/* offset in quotas file */
>  
> -	struct xfs_dquot*q_gdquot;	/* group dquot, hint only */
> +	struct xfs_dquot *q_gdquot;	/* group dquot, hint only */
> +	struct xfs_dquot *q_pdquot;	/* project dquot, hint only */
>  	xfs_disk_dquot_t q_core;	/* actual usage & quotas */
>  	xfs_dq_logitem_t q_logitem;	/* dquot log item */
>  	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
> @@ -118,8 +118,9 @@ static inline int xfs_this_quota_on(struct xfs_mount *mp, int type)
>  	case XFS_DQ_USER:
>  		return XFS_IS_UQUOTA_ON(mp);
>  	case XFS_DQ_GROUP:
> +		return XFS_IS_GQUOTA_ON(mp);
>  	case XFS_DQ_PROJ:
> -		return XFS_IS_OQUOTA_ON(mp);
> +		return XFS_IS_PQUOTA_ON(mp);
>  	default:
>  		return 0;
>  	}
> @@ -131,8 +132,9 @@ static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
>  	case XFS_DQ_USER:
>  		return ip->i_udquot;
>  	case XFS_DQ_GROUP:
> -	case XFS_DQ_PROJ:
>  		return ip->i_gdquot;
> +	case XFS_DQ_PROJ:
> +		return ip->i_pdquot;
>  	default:
>  		return NULL;
>  	}
> @@ -144,9 +146,6 @@ static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
>  #define XFS_QM_ISPDQ(dqp)	((dqp)->dq_flags & XFS_DQ_PROJ)
>  #define XFS_QM_ISGDQ(dqp)	((dqp)->dq_flags & XFS_DQ_GROUP)
>  #define XFS_DQ_TO_QINF(dqp)	((dqp)->q_mount->m_quotainfo)
For now, XFS_DQ_TO_QINF() is used by XFS_DQ_TO_QIP() only.
Maybe we can remove it in this patch as well, if we don't want to make
use of it in any other places to simplify the input...
> -#define XFS_DQ_TO_QIP(dqp)	(XFS_QM_ISUDQ(dqp) ? \
> -				 XFS_DQ_TO_QINF(dqp)->qi_uquotaip : \
> -				 XFS_DQ_TO_QINF(dqp)->qi_gquotaip)
>  
>  extern int		xfs_qm_dqread(struct xfs_mount *, xfs_dqid_t, uint,
>  					uint, struct xfs_dquot	**);
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 96e344e..3f90e1c 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -335,7 +335,9 @@ xfs_iget_cache_miss(
>  	iflags = XFS_INEW;
>  	if (flags & XFS_IGET_DONTCACHE)
>  		iflags |= XFS_IDONTCACHE;
> -	ip->i_udquot = ip->i_gdquot = NULL;
> +	ip->i_udquot = NULL;
> +	ip->i_gdquot = NULL;
> +	ip->i_pdquot = NULL;
>  	xfs_iflags_set(ip, iflags);
>  
>  	/* insert the new inode */
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 9112979..b55fd34 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -250,6 +250,7 @@ typedef struct xfs_inode {
>  	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
>  	struct xfs_dquot	*i_udquot;	/* user dquot */
>  	struct xfs_dquot	*i_gdquot;	/* group dquot */
> +	struct xfs_dquot	*i_pdquot;	/* project dquot */
>  
>  	/* Inode location stuff */
>  	xfs_ino_t		i_ino;		/* inode number (agno/agino)*/
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 5e99968..71a8bc5 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -928,7 +928,7 @@ xfs_ioctl_setattr(
>  	struct xfs_trans	*tp;
>  	unsigned int		lock_flags = 0;
>  	struct xfs_dquot	*udqp = NULL;
> -	struct xfs_dquot	*gdqp = NULL;
> +	struct xfs_dquot	*pdqp = NULL;
>  	struct xfs_dquot	*olddquot = NULL;
>  	int			code;
>  
> @@ -957,7 +957,7 @@ xfs_ioctl_setattr(
>  	if (XFS_IS_QUOTA_ON(mp) && (mask & FSX_PROJID)) {
>  		code = xfs_qm_vop_dqalloc(ip, ip->i_d.di_uid,
>  					 ip->i_d.di_gid, fa->fsx_projid,
> -					 XFS_QMOPT_PQUOTA, &udqp, &gdqp);
> +					 XFS_QMOPT_PQUOTA, &udqp, NULL, &pdqp);
>  		if (code)
>  			return code;
>  	}
> @@ -994,8 +994,8 @@ xfs_ioctl_setattr(
>  		    XFS_IS_PQUOTA_ON(mp) &&
>  		    xfs_get_projid(ip) != fa->fsx_projid) {
>  			ASSERT(tp);
> -			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
> -						capable(CAP_FOWNER) ?
> +			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, NULL,
> +						pdqp, capable(CAP_FOWNER) ?
>  						XFS_QMOPT_FORCE_RES : 0);
>  			if (code)	/* out of quota */
>  				goto error_return;
> @@ -1113,7 +1113,7 @@ xfs_ioctl_setattr(
>  		if (xfs_get_projid(ip) != fa->fsx_projid) {
>  			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
>  				olddquot = xfs_qm_vop_chown(tp, ip,
> -							&ip->i_gdquot, gdqp);
> +							&ip->i_pdquot, pdqp);
>  			}
>  			xfs_set_projid(ip, fa->fsx_projid);
>  
> @@ -1160,13 +1160,13 @@ xfs_ioctl_setattr(
>  	 */
>  	xfs_qm_dqrele(olddquot);
>  	xfs_qm_dqrele(udqp);
> -	xfs_qm_dqrele(gdqp);
> +	xfs_qm_dqrele(pdqp);
>  
>  	return code;
>  
>   error_return:
>  	xfs_qm_dqrele(udqp);
> -	xfs_qm_dqrele(gdqp);
> +	xfs_qm_dqrele(pdqp);
>  	xfs_trans_cancel(tp, 0);
>  	if (lock_flags)
>  		xfs_iunlock(ip, lock_flags);
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index d82efaa..7c54ea4 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -517,7 +517,7 @@ xfs_setattr_nonsize(
>  		ASSERT(udqp == NULL);
>  		ASSERT(gdqp == NULL);
>  		error = xfs_qm_vop_dqalloc(ip, uid, gid, xfs_get_projid(ip),
> -					 qflags, &udqp, &gdqp);
> +					 qflags, &udqp, &gdqp, NULL);
>  		if (error)
>  			return error;
>  	}
> @@ -553,7 +553,7 @@ xfs_setattr_nonsize(
>  		     (XFS_IS_GQUOTA_ON(mp) && igid != gid))) {
>  			ASSERT(tp);
>  			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
> -						capable(CAP_FOWNER) ?
> +						NULL, capable(CAP_FOWNER) ?
>  						XFS_QMOPT_FORCE_RES : 0);
>  			if (error)	/* out of quota */
>  				goto out_trans_cancel;
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index fe4c743..97912cb 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -69,7 +69,7 @@ xfs_qm_dquot_walk(
>  	void			*data)
>  {
>  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> -	struct radix_tree_root	*tree = XFS_DQUOT_TREE(qi, type);
> +	struct radix_tree_root	*tree = xfs_dquot_tree(qi, type);
>  	uint32_t		next_index;
>  	int			last_error = 0;
>  	int			skipped;
> @@ -136,6 +136,7 @@ xfs_qm_dqpurge(
>  	struct xfs_mount	*mp = dqp->q_mount;
>  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
>  	struct xfs_dquot	*gdqp = NULL;
> +	struct xfs_dquot	*pdqp = NULL;
>  
>  	xfs_dqlock(dqp);
>  	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0) {
> @@ -144,8 +145,7 @@ xfs_qm_dqpurge(
>  	}
>  
>  	/*
> -	 * If this quota has a group hint attached, prepare for releasing it
> -	 * now.
> +	 * If this quota has a hint attached, prepare for releasing it now.
>  	 */
>  	gdqp = dqp->q_gdquot;
>  	if (gdqp) {
> @@ -153,6 +153,12 @@ xfs_qm_dqpurge(
>  		dqp->q_gdquot = NULL;
>  	}
>  
> +	pdqp = dqp->q_pdquot;
> +	if (pdqp) {
> +		xfs_dqlock(pdqp);
> +		dqp->q_pdquot = NULL;
> +	}
> +
>  	dqp->dq_flags |= XFS_DQ_FREEING;
>  
>  	xfs_dqflock(dqp);
> @@ -188,7 +194,7 @@ xfs_qm_dqpurge(
>  	xfs_dqfunlock(dqp);
>  	xfs_dqunlock(dqp);
>  
> -	radix_tree_delete(XFS_DQUOT_TREE(qi, dqp->q_core.d_flags),
> +	radix_tree_delete(xfs_dquot_tree(qi, dqp->q_core.d_flags),
>  			  be32_to_cpu(dqp->q_core.d_id));
>  	qi->qi_dquots--;
>  
> @@ -207,6 +213,8 @@ xfs_qm_dqpurge(
>  
>  	if (gdqp)
>  		xfs_qm_dqput(gdqp);
> +	if (pdqp)
> +		xfs_qm_dqput(pdqp);
>  	return 0;
>  }
>  
> @@ -363,6 +371,10 @@ xfs_qm_unmount_quotas(
>  			IRELE(mp->m_quotainfo->qi_gquotaip);
>  			mp->m_quotainfo->qi_gquotaip = NULL;
>  		}
> +		if (mp->m_quotainfo->qi_pquotaip) {
> +			IRELE(mp->m_quotainfo->qi_pquotaip);
> +			mp->m_quotainfo->qi_pquotaip = NULL;
> +		}
>  	}
>  }
>  
> @@ -409,7 +421,10 @@ xfs_qm_dqattach_one(
>  		 * be reclaimed as long as we have a ref from inode and we
>  		 * hold the ilock.
>  		 */
> -		dqp = udqhint->q_gdquot;
> +		if (type == XFS_DQ_GROUP)
> +			dqp = udqhint->q_gdquot;
> +		else
> +			dqp = udqhint->q_pdquot;
Maybe it's better to:
dqp = "type == XFS_DQ_GROUP" ? udqhint->q_gdquot :
			       udqhint->q_pdquot;

>  		if (dqp && be32_to_cpu(dqp->q_core.d_id) == id) {
>  			ASSERT(*IO_idqpp == NULL);
>  
> @@ -452,28 +467,38 @@ xfs_qm_dqattach_one(
>  
>  
>  /*
> - * Given a udquot and gdquot, attach a ptr to the group dquot in the
> + * Given a udquot and gdquot, attach a ptr to the group/project dquot in the
>   * udquot as a hint for future lookups.
>   */
>  STATIC void
> -xfs_qm_dqattach_grouphint(
> -	xfs_dquot_t	*udq,
> -	xfs_dquot_t	*gdq)
> +xfs_qm_dqattach_grouphint(xfs_inode_t *ip, int type)
>  {
> -	xfs_dquot_t	*tmp;
> +	struct xfs_dquot **dqhint;
> +	struct xfs_dquot *gpdq;
> +	struct xfs_dquot *udq = ip->i_udquot;
>  
>  	xfs_dqlock(udq);
>  
> -	tmp = udq->q_gdquot;
> -	if (tmp) {
> -		if (tmp == gdq)
> +	if (type == XFS_DQ_GROUP) {
> +		gpdq = ip->i_gdquot;
> +		dqhint = &udq->q_gdquot;
> +	} else {
> +		gpdq = ip->i_pdquot;
> +		dqhint = &udq->q_pdquot;
> +	}
> +
> +	if (*dqhint) {
> +		struct xfs_dquot *tmp;
> +
> +		if (*dqhint == gpdq)
>  			goto done;
>  
> -		udq->q_gdquot = NULL;
> +		tmp = *dqhint;
> +		*dqhint = NULL;
>  		xfs_qm_dqrele(tmp);
>  	}
>  
> -	udq->q_gdquot = xfs_qm_dqhold(gdq);
> +	*dqhint = xfs_qm_dqhold(gpdq);
>  done:
>  	xfs_dqunlock(udq);
>  }
> @@ -527,12 +552,8 @@ xfs_qm_dqattach_locked(
>  	}
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -	if (XFS_IS_OQUOTA_ON(mp)) {
> -		error = XFS_IS_GQUOTA_ON(mp) ?
> -			xfs_qm_dqattach_one(ip, ip->i_d.di_gid, XFS_DQ_GROUP,
> -						flags & XFS_QMOPT_DQALLOC,
> -						ip->i_udquot, &ip->i_gdquot) :
> -			xfs_qm_dqattach_one(ip, xfs_get_projid(ip), XFS_DQ_PROJ,
> +	if (XFS_IS_GQUOTA_ON(mp)) {
> +		error = xfs_qm_dqattach_one(ip, ip->i_d.di_gid, XFS_DQ_GROUP,
>  						flags & XFS_QMOPT_DQALLOC,
>  						ip->i_udquot, &ip->i_gdquot);
>  		/*
> @@ -544,14 +565,28 @@ xfs_qm_dqattach_locked(
>  		nquotas++;
>  	}
>  
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +	if (XFS_IS_PQUOTA_ON(mp)) {
> +		error = xfs_qm_dqattach_one(ip, xfs_get_projid(ip), XFS_DQ_PROJ,
> +						flags & XFS_QMOPT_DQALLOC,
> +						ip->i_udquot, &ip->i_pdquot);
> +		/*
> +		 * Don't worry about the udquot that we may have
> +		 * attached above. It'll get detached, if not already.
> +		 */
> +		if (error)
> +			goto done;
> +		nquotas++;
> +	}
> +
>  	/*
> -	 * Attach this group quota to the user quota as a hint.
> +	 * Attach this group/project quota to the user quota as a hint.
>  	 * This WON'T, in general, result in a thrash.
>  	 */
> -	if (nquotas == 2) {
> +	if (nquotas > 1 && ip->i_udquot) {
>  		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -		ASSERT(ip->i_udquot);
> -		ASSERT(ip->i_gdquot);
> +		ASSERT(ip->i_gdquot || !XFS_IS_GQUOTA_ON(mp));
> +		ASSERT(ip->i_pdquot || !XFS_IS_PQUOTA_ON(mp));
>  
>  		/*
>  		 * We do not have i_udquot locked at this point, but this check
> @@ -559,8 +594,13 @@ xfs_qm_dqattach_locked(
>  		 * 100% all the time. It is just a hint, and this will
>  		 * succeed in general.
>  		 */
> -		if (ip->i_udquot->q_gdquot != ip->i_gdquot)
> -			xfs_qm_dqattach_grouphint(ip->i_udquot, ip->i_gdquot);
> +		if (XFS_IS_GQUOTA_ON(mp) &&
> +				ip->i_udquot->q_gdquot != ip->i_gdquot)
> +			xfs_qm_dqattach_grouphint(ip, XFS_DQ_GROUP);
> +
> +		if (XFS_IS_PQUOTA_ON(mp) &&
> +				ip->i_udquot->q_pdquot != ip->i_pdquot)
> +			xfs_qm_dqattach_grouphint(ip, XFS_DQ_PROJ);
>  	}
>  
>   done:
> @@ -568,8 +608,10 @@ xfs_qm_dqattach_locked(
>  	if (!error) {
>  		if (XFS_IS_UQUOTA_ON(mp))
>  			ASSERT(ip->i_udquot);
> -		if (XFS_IS_OQUOTA_ON(mp))
> +		if (XFS_IS_GQUOTA_ON(mp))
>  			ASSERT(ip->i_gdquot);
> +		if (XFS_IS_PQUOTA_ON(mp))
> +			ASSERT(ip->i_pdquot);
>  	}
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  #endif
> @@ -602,7 +644,7 @@ void
>  xfs_qm_dqdetach(
>  	xfs_inode_t	*ip)
>  {
> -	if (!(ip->i_udquot || ip->i_gdquot))
> +	if (!(ip->i_udquot || ip->i_gdquot || ip->i_pdquot))
>  		return;
>  
>  	trace_xfs_dquot_dqdetach(ip);
> @@ -617,6 +659,10 @@ xfs_qm_dqdetach(
>  		xfs_qm_dqrele(ip->i_gdquot);
>  		ip->i_gdquot = NULL;
>  	}
> +	if (ip->i_pdquot) {
> +		xfs_qm_dqrele(ip->i_pdquot);
> +		ip->i_pdquot = NULL;
> +	}
>  }
>  
>  int
> @@ -661,6 +707,7 @@ xfs_qm_init_quotainfo(
>  
>  	INIT_RADIX_TREE(&qinf->qi_uquota_tree, GFP_NOFS);
>  	INIT_RADIX_TREE(&qinf->qi_gquota_tree, GFP_NOFS);
> +	INIT_RADIX_TREE(&qinf->qi_pquota_tree, GFP_NOFS);
>  	mutex_init(&qinf->qi_tree_lock);
>  
>  	INIT_LIST_HEAD(&qinf->qi_lru_list);
> @@ -762,6 +809,10 @@ xfs_qm_destroy_quotainfo(
>  		IRELE(qi->qi_gquotaip);
>  		qi->qi_gquotaip = NULL;
>  	}
> +	if (qi->qi_pquotaip) {
> +		IRELE(qi->qi_pquotaip);
> +		qi->qi_pquotaip = NULL;
> +	}
>  	mutex_destroy(&qi->qi_quotaofflock);
>  	kmem_free(qi);
>  	mp->m_quotainfo = NULL;
> @@ -1247,16 +1298,18 @@ xfs_qm_quotacheck(
>  	int		done, count, error, error2;
>  	xfs_ino_t	lastino;
>  	size_t		structsz;
> -	xfs_inode_t	*uip, *gip;
>  	uint		flags;
>  	LIST_HEAD	(buffer_list);
> +	struct xfs_inode	*uip = mp->m_quotainfo->qi_uquotaip;
> +	struct xfs_inode	*gip = mp->m_quotainfo->qi_gquotaip;
> +	struct xfs_inode	*pip = mp->m_quotainfo->qi_pquotaip;
>  
>  	count = INT_MAX;
>  	structsz = 1;
>  	lastino = 0;
>  	flags = 0;
>  
> -	ASSERT(mp->m_quotainfo->qi_uquotaip || mp->m_quotainfo->qi_gquotaip);
> +	ASSERT(uip || gip || pip);
>  	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
>  
>  	xfs_notice(mp, "Quotacheck needed: Please wait.");
> @@ -1266,7 +1319,6 @@ xfs_qm_quotacheck(
>  	 * their counters to zero. We need a clean slate.
>  	 * We don't log our changes till later.
>  	 */
> -	uip = mp->m_quotainfo->qi_uquotaip;
>  	if (uip) {
>  		error = xfs_qm_dqiterate(mp, uip, XFS_QMOPT_UQUOTA,
>  					 &buffer_list);
> @@ -1275,15 +1327,20 @@ xfs_qm_quotacheck(
>  		flags |= XFS_UQUOTA_CHKD;
>  	}
>  
> -	gip = mp->m_quotainfo->qi_gquotaip;
>  	if (gip) {
> -		error = xfs_qm_dqiterate(mp, gip, XFS_IS_GQUOTA_ON(mp) ?
> -					 XFS_QMOPT_GQUOTA : XFS_QMOPT_PQUOTA,
> +		error = xfs_qm_dqiterate(mp, gip, XFS_QMOPT_GQUOTA,
> +					 &buffer_list);
> +		if (error)
> +			goto error_return;
> +		flags |= XFS_GQUOTA_CHKD;
> +	}
> +
> +	if (pip) {
> +		error = xfs_qm_dqiterate(mp, pip, XFS_QMOPT_PQUOTA,
>  					 &buffer_list);
>  		if (error)
>  			goto error_return;
> -		flags |= XFS_IS_GQUOTA_ON(mp) ?
> -					XFS_GQUOTA_CHKD : XFS_PQUOTA_CHKD;
> +		flags |= XFS_PQUOTA_CHKD;
>  	}
>  
>  	do {
> @@ -1378,13 +1435,14 @@ STATIC int
>  xfs_qm_init_quotainos(
>  	xfs_mount_t	*mp)
>  {
> -	xfs_inode_t	*uip, *gip;
> +	struct xfs_inode	*uip = NULL;
> +	struct xfs_inode	*gip = NULL;
> +	struct xfs_inode	*pip = NULL;
>  	int		error;
>  	__int64_t	sbflags;
>  	uint		flags;
>  
>  	ASSERT(mp->m_quotainfo);
> -	uip = gip = NULL;
>  	sbflags = 0;
>  	flags = 0;
>  
> @@ -1395,19 +1453,27 @@ xfs_qm_init_quotainos(
>  		if (XFS_IS_UQUOTA_ON(mp) &&
>  		    mp->m_sb.sb_uquotino != NULLFSINO) {
>  			ASSERT(mp->m_sb.sb_uquotino > 0);
> -			if ((error = xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
> -					     0, 0, &uip)))
> +			error = xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
> +					     0, 0, &uip);
> +			if (error)
>  				return XFS_ERROR(error);
>  		}
> -		if (XFS_IS_OQUOTA_ON(mp) &&
> +		if (XFS_IS_GQUOTA_ON(mp) &&
>  		    mp->m_sb.sb_gquotino != NULLFSINO) {
>  			ASSERT(mp->m_sb.sb_gquotino > 0);
> -			if ((error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
> -					     0, 0, &gip))) {
> -				if (uip)
> -					IRELE(uip);
> -				return XFS_ERROR(error);
> -			}
> +			error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
> +					     0, 0, &gip);
> +			if (error)
> +				goto error_rele;
> +		}
> +		/* Use sb_gquotino for now */
> +		if (XFS_IS_PQUOTA_ON(mp) &&
> +		    mp->m_sb.sb_gquotino != NULLFSINO) {
> +			ASSERT(mp->m_sb.sb_gquotino > 0);
> +			error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
> +					     0, 0, &pip);
> +			if (error)
> +				goto error_rele;
>  		}
>  	} else {
>  		flags |= XFS_QMOPT_SBVERSION;
> @@ -1416,36 +1482,50 @@ xfs_qm_init_quotainos(
>  	}
>  
>  	/*
> -	 * Create the two inodes, if they don't exist already. The changes
> +	 * Create the three inodes, if they don't exist already. The changes
>  	 * made above will get added to a transaction and logged in one of
>  	 * the qino_alloc calls below.  If the device is readonly,
>  	 * temporarily switch to read-write to do this.
>  	 */
>  	if (XFS_IS_UQUOTA_ON(mp) && uip == NULL) {
> -		if ((error = xfs_qm_qino_alloc(mp, &uip,
> +		error = xfs_qm_qino_alloc(mp, &uip,
>  					      sbflags | XFS_SB_UQUOTINO,
> -					      flags | XFS_QMOPT_UQUOTA)))
> +					      flags | XFS_QMOPT_UQUOTA);
> +		if (error)
>  			return XFS_ERROR(error);
>  
>  		flags &= ~XFS_QMOPT_SBVERSION;
>  	}
> -	if (XFS_IS_OQUOTA_ON(mp) && gip == NULL) {
> -		flags |= (XFS_IS_GQUOTA_ON(mp) ?
> -				XFS_QMOPT_GQUOTA : XFS_QMOPT_PQUOTA);
> +	if (XFS_IS_GQUOTA_ON(mp) && gip == NULL) {
>  		error = xfs_qm_qino_alloc(mp, &gip,
> -					  sbflags | XFS_SB_GQUOTINO, flags);
> -		if (error) {
> -			if (uip)
> -				IRELE(uip);
> -
> -			return XFS_ERROR(error);
> -		}
> +					     sbflags | XFS_SB_GQUOTINO,
> +					     flags | XFS_QMOPT_GQUOTA);
> +		if (error)
> +			goto error_rele;
> +	}
> +	if (XFS_IS_PQUOTA_ON(mp) && pip == NULL) {
> +		error = xfs_qm_qino_alloc(mp, &pip,
> +					     sbflags | XFS_SB_GQUOTINO,
> +					     flags | XFS_QMOPT_PQUOTA);
> +		if (error)
> +			goto error_rele;
>  	}
>  
>  	mp->m_quotainfo->qi_uquotaip = uip;
>  	mp->m_quotainfo->qi_gquotaip = gip;
> +	mp->m_quotainfo->qi_pquotaip = pip;
>  
>  	return 0;
> +
> +error_rele:
> +	if (uip)
> +		IRELE(uip);
> +	if (gip)
> +		IRELE(gip);
> +	if (pip)
> +		IRELE(pip);
> +	return XFS_ERROR(error);
> +
>  }
>  
>  STATIC void
> @@ -1456,7 +1536,7 @@ xfs_qm_dqfree_one(
>  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
>  
>  	mutex_lock(&qi->qi_tree_lock);
> -	radix_tree_delete(XFS_DQUOT_TREE(qi, dqp->q_core.d_flags),
> +	radix_tree_delete(xfs_dquot_tree(qi, dqp->q_core.d_flags),
>  			  be32_to_cpu(dqp->q_core.d_id));
>  
>  	qi->qi_dquots--;
> @@ -1639,10 +1719,13 @@ xfs_qm_vop_dqalloc(
>  	prid_t			prid,
>  	uint			flags,
>  	struct xfs_dquot	**O_udqpp,
> -	struct xfs_dquot	**O_gdqpp)
> +	struct xfs_dquot	**O_gdqpp,
> +	struct xfs_dquot	**O_pdqpp)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_dquot	*uq, *gq;
> +	struct xfs_dquot	*uq = NULL;
> +	struct xfs_dquot	*gq = NULL;
> +	struct xfs_dquot	*pq = NULL;
>  	int			error;
>  	uint			lockflags;
>  
> @@ -1667,7 +1750,6 @@ xfs_qm_vop_dqalloc(
>  		}
>  	}
>  
> -	uq = gq = NULL;
>  	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
>  		if (ip->i_d.di_uid != uid) {
>  			/*
> @@ -1680,14 +1762,14 @@ xfs_qm_vop_dqalloc(
>  			 * holding ilock.
>  			 */
>  			xfs_iunlock(ip, lockflags);
> -			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t) uid,
> +			error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t) uid,
>  						 XFS_DQ_USER,
>  						 XFS_QMOPT_DQALLOC |
>  						 XFS_QMOPT_DOWARN,
> -						 &uq))) {
> -				ASSERT(error != ENOENT);
> +						 &uq);
> +			ASSERT(error != ENOENT);
> +			if (error)
>  				return error;
> -			}
>  			/*
>  			 * Get the ilock in the right order.
>  			 */
> @@ -1706,16 +1788,15 @@ xfs_qm_vop_dqalloc(
>  	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
>  		if (ip->i_d.di_gid != gid) {
>  			xfs_iunlock(ip, lockflags);
> -			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)gid,
> +			error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)gid,
>  						 XFS_DQ_GROUP,
>  						 XFS_QMOPT_DQALLOC |
>  						 XFS_QMOPT_DOWARN,
> -						 &gq))) {
> -				if (uq)
> -					xfs_qm_dqrele(uq);
> -				ASSERT(error != ENOENT);
> -				return error;
> -			}
> +						 &gq);
> +			ASSERT(error != ENOENT);
> +			if (error)
> +				goto error_rele;
> +
>  			xfs_dqunlock(gq);
>  			lockflags = XFS_ILOCK_SHARED;
>  			xfs_ilock(ip, lockflags);
> @@ -1723,25 +1804,25 @@ xfs_qm_vop_dqalloc(
>  			ASSERT(ip->i_gdquot);
>  			gq = xfs_qm_dqhold(ip->i_gdquot);
>  		}
> -	} else if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
> +	}
> +	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
>  		if (xfs_get_projid(ip) != prid) {
>  			xfs_iunlock(ip, lockflags);
> -			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)prid,
> +			error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)prid,
>  						 XFS_DQ_PROJ,
>  						 XFS_QMOPT_DQALLOC |
>  						 XFS_QMOPT_DOWARN,
> -						 &gq))) {
> -				if (uq)
> -					xfs_qm_dqrele(uq);
> -				ASSERT(error != ENOENT);
> -				return (error);
> -			}
> -			xfs_dqunlock(gq);
> +						 &pq);
> +			ASSERT(error != ENOENT);
> +			if (error)
> +				goto error_rele;
> +
> +			xfs_dqunlock(pq);
>  			lockflags = XFS_ILOCK_SHARED;
>  			xfs_ilock(ip, lockflags);
>  		} else {
> -			ASSERT(ip->i_gdquot);
> -			gq = xfs_qm_dqhold(ip->i_gdquot);
> +			ASSERT(ip->i_pdquot);
> +			pq = xfs_qm_dqhold(ip->i_pdquot);
>  		}
>  	}
>  	if (uq)
> @@ -1756,7 +1837,18 @@ xfs_qm_vop_dqalloc(
>  		*O_gdqpp = gq;
>  	else if (gq)
>  		xfs_qm_dqrele(gq);
> +	if (O_pdqpp)
> +		*O_pdqpp = pq;
> +	else if (pq)
> +		xfs_qm_dqrele(pq);
>  	return 0;
> +
> +error_rele:
> +	if (uq)
> +		xfs_qm_dqrele(uq);
> +	if (gq)
> +		xfs_qm_dqrele(gq);
> +	return error;
>  }
>  
>  /*
> @@ -1804,15 +1896,21 @@ xfs_qm_vop_chown(
>   */
>  int
>  xfs_qm_vop_chown_reserve(
> -	xfs_trans_t	*tp,
> -	xfs_inode_t	*ip,
> -	xfs_dquot_t	*udqp,
> -	xfs_dquot_t	*gdqp,
> -	uint		flags)
> +	xfs_trans_t		*tp,
> +	xfs_inode_t		*ip,
> +	struct xfs_dquot	*udqp,
> +	struct xfs_dquot	*gdqp,
> +	struct xfs_dquot	*pdqp,
> +	uint			flags)
>  {
>  	xfs_mount_t	*mp = ip->i_mount;
>  	uint		delblks, blkflags, prjflags = 0;
> -	xfs_dquot_t	*unresudq, *unresgdq, *delblksudq, *delblksgdq;
> +	struct xfs_dquot	*unresudq = NULL;
> +	struct xfs_dquot	*unresgdq = NULL;
> +	struct xfs_dquot	*unrespdq = NULL;
> +	struct xfs_dquot	*delblksudq = NULL;
> +	struct xfs_dquot	*delblksgdq = NULL;
> +	struct xfs_dquot	*delblkspdq = NULL;
>  	int		error;
>  
>  
> @@ -1820,7 +1918,6 @@ xfs_qm_vop_chown_reserve(
>  	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
>  
>  	delblks = ip->i_delayed_blks;
> -	delblksudq = delblksgdq = unresudq = unresgdq = NULL;
>  	blkflags = XFS_IS_REALTIME_INODE(ip) ?
>  			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
>  
> @@ -1837,25 +1934,29 @@ xfs_qm_vop_chown_reserve(
>  			unresudq = ip->i_udquot;
>  		}
>  	}
> -	if (XFS_IS_OQUOTA_ON(ip->i_mount) && gdqp) {
> -		if (XFS_IS_PQUOTA_ON(ip->i_mount) &&
> -		     xfs_get_projid(ip) != be32_to_cpu(gdqp->q_core.d_id))
> -			prjflags = XFS_QMOPT_ENOSPC;
> -
> -		if (prjflags ||
> -		    (XFS_IS_GQUOTA_ON(ip->i_mount) &&
> -		     ip->i_d.di_gid != be32_to_cpu(gdqp->q_core.d_id))) {
> -			delblksgdq = gdqp;
> -			if (delblks) {
> -				ASSERT(ip->i_gdquot);
> -				unresgdq = ip->i_gdquot;
> -			}
> +	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
> +	    ip->i_d.di_gid != be32_to_cpu(gdqp->q_core.d_id)) {
> +		delblksgdq = gdqp;
> +		if (delblks) {
> +			ASSERT(ip->i_gdquot);
> +			unresgdq = ip->i_gdquot;
> +		}
> +	}
> +
> +	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
> +	    xfs_get_projid(ip) != be32_to_cpu(pdqp->q_core.d_id)) {
> +		prjflags = XFS_QMOPT_ENOSPC;
> +		delblkspdq = pdqp;
> +		if (delblks) {
> +			ASSERT(ip->i_pdquot);
> +			unrespdq = ip->i_pdquot;
>  		}
>  	}
>  
> -	if ((error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
> -				delblksudq, delblksgdq, ip->i_d.di_nblocks, 1,
> -				flags | blkflags | prjflags)))
> +	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
> +			delblksudq, delblksgdq, delblkspdq, ip->i_d.di_nblocks,
> +			1, flags | blkflags | prjflags);
> +	if (error)
>  		return (error);
>  
>  	/*
> @@ -1868,15 +1969,17 @@ xfs_qm_vop_chown_reserve(
>  		/*
>  		 * Do the reservations first. Unreservation can't fail.
>  		 */
> -		ASSERT(delblksudq || delblksgdq);
> -		ASSERT(unresudq || unresgdq);
> -		if ((error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
> -				delblksudq, delblksgdq, (xfs_qcnt_t)delblks, 0,
> -				flags | blkflags | prjflags)))
> +		ASSERT(delblksudq || delblksgdq || delblkspdq);
> +		ASSERT(unresudq || unresgdq || unrespdq);
> +		error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
> +				delblksudq, delblksgdq, delblkspdq,
> +				(xfs_qcnt_t)delblks, 0,
> +				flags | blkflags | prjflags);
> +		if (error)
>  			return (error);
>  		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
> -				unresudq, unresgdq, -((xfs_qcnt_t)delblks), 0,
> -				blkflags);
> +				unresudq, unresgdq, unrespdq,
> +				-((xfs_qcnt_t)delblks), 0, blkflags);
>  	}
>  
>  	return (0);
> @@ -1915,7 +2018,8 @@ xfs_qm_vop_create_dqattach(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	struct xfs_dquot	*udqp,
> -	struct xfs_dquot	*gdqp)
> +	struct xfs_dquot	*gdqp,
> +	struct xfs_dquot	*pdqp)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  
> @@ -1935,13 +2039,18 @@ xfs_qm_vop_create_dqattach(
>  	}
>  	if (gdqp) {
>  		ASSERT(ip->i_gdquot == NULL);
> -		ASSERT(XFS_IS_OQUOTA_ON(mp));
> -		ASSERT((XFS_IS_GQUOTA_ON(mp) ?
> -			ip->i_d.di_gid : xfs_get_projid(ip)) ==
> -				be32_to_cpu(gdqp->q_core.d_id));
> -
> +		ASSERT(XFS_IS_GQUOTA_ON(mp));
> +		ASSERT(ip->i_d.di_gid == be32_to_cpu(gdqp->q_core.d_id));
>  		ip->i_gdquot = xfs_qm_dqhold(gdqp);
>  		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
>  	}
> +	if (pdqp) {
> +		ASSERT(ip->i_pdquot == NULL);
> +		ASSERT(XFS_IS_PQUOTA_ON(mp));
> +		ASSERT(xfs_get_projid(ip) == be32_to_cpu(pdqp->q_core.d_id));
> +
> +		ip->i_pdquot = xfs_qm_dqhold(pdqp);
> +		xfs_trans_mod_dquot(tp, pdqp, XFS_TRANS_DQ_ICOUNT, 1);
> +	}
>  }
>  
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 5d16a6e..f23b06b 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -44,9 +44,11 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
>  typedef struct xfs_quotainfo {
>  	struct radix_tree_root qi_uquota_tree;
>  	struct radix_tree_root qi_gquota_tree;
> +	struct radix_tree_root qi_pquota_tree;
>  	struct mutex qi_tree_lock;
> -	xfs_inode_t	*qi_uquotaip;	 /* user quota inode */
> -	xfs_inode_t	*qi_gquotaip;	 /* group quota inode */
> +	struct xfs_inode *qi_uquotaip;	 /* user quota inode */
> +	struct xfs_inode *qi_gquotaip;	 /* group quota inode */
> +	struct xfs_inode *qi_pquotaip;	 /* project quota inode */
>  	struct list_head qi_lru_list;
>  	struct mutex	 qi_lru_lock;
>  	int		 qi_lru_count;
> @@ -69,30 +71,45 @@ typedef struct xfs_quotainfo {
>  	struct shrinker  qi_shrinker;
>  } xfs_quotainfo_t;
>  
> -#define XFS_DQUOT_TREE(qi, type) \
> -	((type & XFS_DQ_USER) ? \
> -	 &((qi)->qi_uquota_tree) : \
> -	 &((qi)->qi_gquota_tree))
> -
> +static inline struct radix_tree_root *
> +xfs_dquot_tree(
> +	struct xfs_quotainfo	*qi,
> +	int			type)
> +{
> +	switch (type) {
> +	case XFS_DQ_USER:
> +		return &qi->qi_uquota_tree;
> +	case XFS_DQ_GROUP:
> +		return &qi->qi_gquota_tree;
> +	case XFS_DQ_PROJ:
> +		return &qi->qi_pquota_tree;
> +	default:
> +		ASSERT(0);
> +	}
> +	return NULL;
> +}
>  
>  extern int	xfs_qm_calc_dquots_per_chunk(struct xfs_mount *mp,
>  					     unsigned int nbblks);
> -extern void	xfs_trans_mod_dquot(xfs_trans_t *, xfs_dquot_t *, uint, long);
> -extern int	xfs_trans_reserve_quota_bydquots(xfs_trans_t *, xfs_mount_t *,
> -			xfs_dquot_t *, xfs_dquot_t *, long, long, uint);
> -extern void	xfs_trans_dqjoin(xfs_trans_t *, xfs_dquot_t *);
> -extern void	xfs_trans_log_dquot(xfs_trans_t *, xfs_dquot_t *);
> +extern void	xfs_trans_mod_dquot(xfs_trans_t *, struct xfs_dquot *, uint, long);
> +extern void	xfs_trans_dqjoin(xfs_trans_t *, struct xfs_dquot *);
> +extern void	xfs_trans_log_dquot(xfs_trans_t *, struct xfs_dquot *);
>  
>  /*
> - * We keep the usr and grp dquots separately so that locking will be easier
> - * to do at commit time. All transactions that we know of at this point
> + * We keep the usr, grp, and prj dquots separately so that locking will be
> + * easier to do at commit time. All transactions that we know of at this point
>   * affect no more than two dquots of one type. Hence, the TRANS_MAXDQS value.
>   */
> +enum {
> +	XFS_QM_TRANS_USR = 0,
> +	XFS_QM_TRANS_GRP,
> +	XFS_QM_TRANS_PROJ,
> +	XFS_QM_TRANS_DQTYPES
> +};
>  #define XFS_QM_TRANS_MAXDQS		2
> -typedef struct xfs_dquot_acct {
> -	xfs_dqtrx_t	dqa_usrdquots[XFS_QM_TRANS_MAXDQS];
> -	xfs_dqtrx_t	dqa_grpdquots[XFS_QM_TRANS_MAXDQS];
> -} xfs_dquot_acct_t;
> +struct xfs_dquot_acct {
> +	struct xfs_dqtrx dqs[XFS_QM_TRANS_DQTYPES][XFS_QM_TRANS_MAXDQS];
> +};
>  
>  /*
>   * Users are allowed to have a usage exceeding their softlimit for
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index 2d02eac..72a4fdd 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -115,7 +115,7 @@ xfs_qm_newmount(
>  	     (pquotaondisk && !XFS_IS_PQUOTA_ON(mp)) ||
>  	    (!pquotaondisk &&  XFS_IS_PQUOTA_ON(mp)) ||
>  	     (gquotaondisk && !XFS_IS_GQUOTA_ON(mp)) ||
> -	    (!gquotaondisk &&  XFS_IS_OQUOTA_ON(mp)))  &&
> +	    (!gquotaondisk &&  XFS_IS_GQUOTA_ON(mp)))  &&
>  	    xfs_dev_is_read_only(mp, "changing quota state")) {
>  		xfs_warn(mp, "please mount with%s%s%s%s.",
>  			(!quotaondisk ? "out quota" : ""),
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index f005f1d..9bec772 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -119,7 +119,8 @@ xfs_qm_scall_quotaoff(
>  		dqtype |= XFS_QMOPT_GQUOTA;
>  		flags |= (XFS_GQUOTA_CHKD | XFS_GQUOTA_ENFD);
>  		inactivate_flags |= XFS_GQUOTA_ACTIVE;
> -	} else if (flags & XFS_PQUOTA_ACCT) {
> +	}
> +	if (flags & XFS_PQUOTA_ACCT) {
>  		dqtype |= XFS_QMOPT_PQUOTA;
>  		flags |= (XFS_PQUOTA_CHKD | XFS_PQUOTA_ENFD);
>  		inactivate_flags |= XFS_PQUOTA_ACTIVE;
> @@ -214,10 +215,14 @@ xfs_qm_scall_quotaoff(
>  		IRELE(q->qi_uquotaip);
>  		q->qi_uquotaip = NULL;
>  	}
> -	if ((dqtype & (XFS_QMOPT_GQUOTA|XFS_QMOPT_PQUOTA)) && q->qi_gquotaip) {
> +	if ((dqtype & XFS_QMOPT_GQUOTA) && q->qi_gquotaip) {
>  		IRELE(q->qi_gquotaip);
>  		q->qi_gquotaip = NULL;
>  	}
> +	if ((dqtype & XFS_QMOPT_PQUOTA) && q->qi_pquotaip) {
> +		IRELE(q->qi_pquotaip);
> +		q->qi_pquotaip = NULL;
> +	}
>  
>  out_unlock:
>  	mutex_unlock(&q->qi_quotaofflock);
> @@ -853,9 +858,11 @@ xfs_dqrele_inode(
>  {
>  	/* skip quota inodes */
>  	if (ip == ip->i_mount->m_quotainfo->qi_uquotaip ||
> -	    ip == ip->i_mount->m_quotainfo->qi_gquotaip) {
> +	    ip == ip->i_mount->m_quotainfo->qi_gquotaip ||
> +	    ip == ip->i_mount->m_quotainfo->qi_pquotaip) {
>  		ASSERT(ip->i_udquot == NULL);
>  		ASSERT(ip->i_gdquot == NULL);
> +		ASSERT(ip->i_pdquot == NULL);
>  		return 0;
>  	}
>  
> @@ -864,10 +871,14 @@ xfs_dqrele_inode(
>  		xfs_qm_dqrele(ip->i_udquot);
>  		ip->i_udquot = NULL;
>  	}
> -	if (flags & (XFS_PQUOTA_ACCT|XFS_GQUOTA_ACCT) && ip->i_gdquot) {
> +	if ((flags & XFS_GQUOTA_ACCT) && ip->i_gdquot) {
>  		xfs_qm_dqrele(ip->i_gdquot);
>  		ip->i_gdquot = NULL;
>  	}
> +	if ((flags & XFS_PQUOTA_ACCT) && ip->i_pdquot) {
> +		xfs_qm_dqrele(ip->i_pdquot);
> +		ip->i_pdquot = NULL;
> +	}
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index ccff1a6..fe46c0c 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -272,10 +272,10 @@ typedef struct xfs_qoff_logformat {
>   * we didn't have the inode locked, the appropriate dquot(s) will be
>   * attached atomically.
>   */
> -#define XFS_NOT_DQATTACHED(mp, ip) ((XFS_IS_UQUOTA_ON(mp) &&\
> -				     (ip)->i_udquot == NULL) || \
> -				    (XFS_IS_OQUOTA_ON(mp) && \
> -				     (ip)->i_gdquot == NULL))
> +#define XFS_NOT_DQATTACHED(mp, ip) \
> +	((XFS_IS_UQUOTA_ON(mp) && (ip)->i_udquot == NULL) || \
> +	 (XFS_IS_GQUOTA_ON(mp) && (ip)->i_gdquot == NULL) || \
> +	 (XFS_IS_PQUOTA_ON(mp) && (ip)->i_pdquot == NULL))
>  
>  #define XFS_QM_NEED_QUOTACHECK(mp) \
>  	((XFS_IS_UQUOTA_ON(mp) && \
> @@ -330,17 +330,18 @@ extern int xfs_trans_reserve_quota_nblks(struct xfs_trans *,
>  		struct xfs_inode *, long, long, uint);
>  extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
>  		struct xfs_mount *, struct xfs_dquot *,
> -		struct xfs_dquot *, long, long, uint);
> +		struct xfs_dquot *, struct xfs_dquot *, long, long, uint);
>  
>  extern int xfs_qm_vop_dqalloc(struct xfs_inode *, uid_t, gid_t, prid_t, uint,
> -		struct xfs_dquot **, struct xfs_dquot **);
> +		struct xfs_dquot **, struct xfs_dquot **, struct xfs_dquot **);
>  extern void xfs_qm_vop_create_dqattach(struct xfs_trans *, struct xfs_inode *,
> -		struct xfs_dquot *, struct xfs_dquot *);
> +		struct xfs_dquot *, struct xfs_dquot *, struct xfs_dquot *);
>  extern int xfs_qm_vop_rename_dqattach(struct xfs_inode **);
>  extern struct xfs_dquot *xfs_qm_vop_chown(struct xfs_trans *,
>  		struct xfs_inode *, struct xfs_dquot **, struct xfs_dquot *);
>  extern int xfs_qm_vop_chown_reserve(struct xfs_trans *, struct xfs_inode *,
> -		struct xfs_dquot *, struct xfs_dquot *, uint);
> +		struct xfs_dquot *, struct xfs_dquot *,
> +		struct xfs_dquot *, uint);
>  extern int xfs_qm_dqattach(struct xfs_inode *, uint);
>  extern int xfs_qm_dqattach_locked(struct xfs_inode *, uint);
>  extern void xfs_qm_dqdetach(struct xfs_inode *);
> @@ -354,10 +355,12 @@ extern void xfs_qm_unmount_quotas(struct xfs_mount *);
>  #else
>  static inline int
>  xfs_qm_vop_dqalloc(struct xfs_inode *ip, uid_t uid, gid_t gid, prid_t prid,
> -		uint flags, struct xfs_dquot **udqp, struct xfs_dquot **gdqp)
> +		uint flags, struct xfs_dquot **udqp, struct xfs_dquot **gdqp,
> +		struct xfs_dquot **pdqp)
>  {
>  	*udqp = NULL;
>  	*gdqp = NULL;
> +	*pdqp = NULL;
>  	return 0;
>  }
>  #define xfs_trans_dup_dqinfo(tp, tp2)
> @@ -372,14 +375,15 @@ static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
>  }
>  static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
>  		struct xfs_mount *mp, struct xfs_dquot *udqp,
> -		struct xfs_dquot *gdqp, long nblks, long nions, uint flags)
> +		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp,
> +		long nblks, long nions, uint flags)
>  {
>  	return 0;
>  }
> -#define xfs_qm_vop_create_dqattach(tp, ip, u, g)
> +#define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
>  #define xfs_qm_vop_rename_dqattach(it)					(0)
>  #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
> -#define xfs_qm_vop_chown_reserve(tp, ip, u, g, fl)			(0)
> +#define xfs_qm_vop_chown_reserve(tp, ip, u, g, p, fl)			(0)
>  #define xfs_qm_dqattach(ip, fl)						(0)
>  #define xfs_qm_dqattach_locked(ip, fl)					(0)
>  #define xfs_qm_dqdetach(ip)
> @@ -393,8 +397,8 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
>  
>  #define xfs_trans_unreserve_quota_nblks(tp, ip, nblks, ninos, flags) \
>  	xfs_trans_reserve_quota_nblks(tp, ip, -(nblks), -(ninos), flags)
> -#define xfs_trans_reserve_quota(tp, mp, ud, gd, nb, ni, f) \
> -	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, nb, ni, \
> +#define xfs_trans_reserve_quota(tp, mp, ud, gd, pd, nb, ni, f) \
> +	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, pd, nb, ni, \
>  				f | XFS_QMOPT_RES_REGBLKS)
>  
>  extern int xfs_qm_dqcheck(struct xfs_mount *, xfs_disk_dquot_t *,
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 873fa5a..5feac04 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -560,14 +560,13 @@ xfs_showargs(
>  	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
>  		seq_puts(m, "," MNTOPT_UQUOTANOENF);
>  
> -	/* Either project or group quotas can be active, not both */
> -
>  	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
>  		if (mp->m_qflags & XFS_PQUOTA_ENFD)
>  			seq_puts(m, "," MNTOPT_PRJQUOTA);
>  		else
>  			seq_puts(m, "," MNTOPT_PQUOTANOENF);
> -	} else if (mp->m_qflags & XFS_GQUOTA_ACCT) {
> +	}
> +	if (mp->m_qflags & XFS_GQUOTA_ACCT) {
>  		if (mp->m_qflags & XFS_GQUOTA_ENFD)
>  			seq_puts(m, "," MNTOPT_GRPQUOTA);
>  		else
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 5f23438..d69e50a 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -365,7 +365,9 @@ xfs_symlink(
>  	int			n;
>  	xfs_buf_t		*bp;
>  	prid_t			prid;
> -	struct xfs_dquot	*udqp, *gdqp;
> +	struct xfs_dquot	*udqp = NULL;
> +	struct xfs_dquot	*gdqp = NULL;
> +	struct xfs_dquot	*pdqp = NULL;
>  	uint			resblks;
>  
>  	*ipp = NULL;
> @@ -392,7 +394,7 @@ xfs_symlink(
>  	 * Make sure that we have allocated dquot(s) on disk.
>  	 */
>  	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
> -			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
> +		XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp, &pdqp);
>  	if (error)
>  		goto std_return;
>  
> @@ -433,7 +435,8 @@ xfs_symlink(
>  	/*
>  	 * Reserve disk quota : blocks and inode.
>  	 */
> -	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp, resblks, 1, 0);
> +	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
> +						pdqp, resblks, 1, 0);
>  	if (error)
>  		goto error_return;
>  
> @@ -471,7 +474,7 @@ xfs_symlink(
>  	/*
>  	 * Also attach the dquot(s) to it, if applicable.
>  	 */
> -	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp);
> +	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
>  
>  	if (resblks)
>  		resblks -= XFS_IALLOC_SPACE_RES(mp);
> @@ -570,6 +573,7 @@ xfs_symlink(
>  	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(gdqp);
> +	xfs_qm_dqrele(pdqp);
>  
>  	*ipp = ip;
>  	return 0;
> @@ -583,6 +587,7 @@ xfs_symlink(
>  	xfs_trans_cancel(tp, cancel_flags);
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(gdqp);
> +	xfs_qm_dqrele(pdqp);
>  
>  	if (unlock_dp_on_error)
>  		xfs_iunlock(dp, XFS_ILOCK_EXCL);
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 8cdbd62..2bbad13 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -103,8 +103,6 @@ xfs_trans_dup_dqinfo(
>  		return;
>  
>  	xfs_trans_alloc_dqinfo(ntp);
> -	oqa = otp->t_dqinfo->dqa_usrdquots;
> -	nqa = ntp->t_dqinfo->dqa_usrdquots;
>  
>  	/*
>  	 * Because the quota blk reservation is carried forward,
> @@ -113,7 +111,10 @@ xfs_trans_dup_dqinfo(
>  	if(otp->t_flags & XFS_TRANS_DQ_DIRTY)
>  		ntp->t_flags |= XFS_TRANS_DQ_DIRTY;
>  
> -	for (j = 0; j < 2; j++) {
> +	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
> +		oqa = otp->t_dqinfo->dqs[j];
> +		nqa = ntp->t_dqinfo->dqs[j];
> +
>  		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
>  			if (oqa[i].qt_dquot == NULL)
>  				break;
> @@ -138,8 +139,6 @@ xfs_trans_dup_dqinfo(
>  			oq->qt_ino_res = oq->qt_ino_res_used;
>  
>  		}
> -		oqa = otp->t_dqinfo->dqa_grpdquots;
> -		nqa = ntp->t_dqinfo->dqa_grpdquots;
>  	}
>  }
>  
> @@ -166,8 +165,10 @@ xfs_trans_mod_dquot_byino(
>  
>  	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
>  		(void) xfs_trans_mod_dquot(tp, ip->i_udquot, field, delta);
> -	if (XFS_IS_OQUOTA_ON(mp) && ip->i_gdquot)
> +	if (XFS_IS_GQUOTA_ON(mp) && ip->i_gdquot)
>  		(void) xfs_trans_mod_dquot(tp, ip->i_gdquot, field, delta);
> +	if (XFS_IS_PQUOTA_ON(mp) && ip->i_pdquot)
> +		(void) xfs_trans_mod_dquot(tp, ip->i_pdquot, field, delta);
>  }
>  
>  STATIC xfs_dqtrx_t *
> @@ -178,15 +179,20 @@ xfs_trans_get_dqtrx(
>  	int		i;
>  	xfs_dqtrx_t	*qa;
>  
> -	qa = XFS_QM_ISUDQ(dqp) ?
> -		tp->t_dqinfo->dqa_usrdquots : tp->t_dqinfo->dqa_grpdquots;
> +	if (XFS_QM_ISUDQ(dqp))
> +		qa = tp->t_dqinfo->dqs[XFS_QM_TRANS_USR];
> +	else if (XFS_QM_ISGDQ(dqp))
> +		qa = tp->t_dqinfo->dqs[XFS_QM_TRANS_GRP];
> +	else if (XFS_QM_ISPDQ(dqp))
> +		qa = tp->t_dqinfo->dqs[XFS_QM_TRANS_PROJ];
> +	else
> +		return NULL;
>  
>  	for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
>  		if (qa[i].qt_dquot == NULL ||
>  		    qa[i].qt_dquot == dqp)
>  			return &qa[i];
>  	}
> -
>  	return NULL;
>  }
>  
> @@ -339,12 +345,10 @@ xfs_trans_apply_dquot_deltas(
>  		return;
>  
>  	ASSERT(tp->t_dqinfo);
> -	qa = tp->t_dqinfo->dqa_usrdquots;
> -	for (j = 0; j < 2; j++) {
> -		if (qa[0].qt_dquot == NULL) {
> -			qa = tp->t_dqinfo->dqa_grpdquots;
> +	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
> +		qa = tp->t_dqinfo->dqs[j];
> +		if (qa[0].qt_dquot == NULL)
>  			continue;
> -		}
>  
>  		/*
>  		 * Lock all of the dquots and join them to the transaction.
> @@ -495,10 +499,6 @@ xfs_trans_apply_dquot_deltas(
>  			ASSERT(dqp->q_res_rtbcount >=
>  				be64_to_cpu(dqp->q_core.d_rtbcount));
>  		}
> -		/*
> -		 * Do the group quotas next
> -		 */
> -		qa = tp->t_dqinfo->dqa_grpdquots;
>  	}
>  }
>  
> @@ -521,9 +521,10 @@ xfs_trans_unreserve_and_mod_dquots(
>  	if (!tp->t_dqinfo || !(tp->t_flags & XFS_TRANS_DQ_DIRTY))
>  		return;
>  
> -	qa = tp->t_dqinfo->dqa_usrdquots;
>  
> -	for (j = 0; j < 2; j++) {
> +	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
> +		qa = tp->t_dqinfo->dqs[j];
> +
>  		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
>  			qtrx = &qa[i];
>  			/*
> @@ -565,7 +566,6 @@ xfs_trans_unreserve_and_mod_dquots(
>  				xfs_dqunlock(dqp);
>  
>  		}
> -		qa = tp->t_dqinfo->dqa_grpdquots;
>  	}
>  }
>  
> @@ -736,8 +736,8 @@ error_return:
>  
>  /*
>   * Given dquot(s), make disk block and/or inode reservations against them.
> - * The fact that this does the reservation against both the usr and
> - * grp/prj quotas is important, because this follows a both-or-nothing
> + * The fact that this does the reservation against user, group and
> + * project quotas is important, because this follows a all-or-nothing
>   * approach.
>   *
>   * flags = XFS_QMOPT_FORCE_RES evades limit enforcement. Used by chown.
> @@ -748,15 +748,16 @@ error_return:
>   */
>  int
>  xfs_trans_reserve_quota_bydquots(
> -	xfs_trans_t	*tp,
> -	xfs_mount_t	*mp,
> -	xfs_dquot_t	*udqp,
> -	xfs_dquot_t	*gdqp,
> -	long		nblks,
> -	long		ninos,
> -	uint		flags)
> +	struct xfs_trans	*tp,
> +	struct xfs_mount	*mp,
> +	struct xfs_dquot	*udqp,
> +	struct xfs_dquot	*gdqp,
> +	struct xfs_dquot	*pdqp,
> +	long			nblks,
> +	long			ninos,
> +	uint			flags)
>  {
> -	int		resvd = 0, error;
> +	int	error;
>  
>  	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
>  		return 0;
> @@ -771,28 +772,34 @@ xfs_trans_reserve_quota_bydquots(
>  					(flags & ~XFS_QMOPT_ENOSPC));
>  		if (error)
>  			return error;
> -		resvd = 1;
>  	}
>  
>  	if (gdqp) {
>  		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags);
> -		if (error) {
> -			/*
> -			 * can't do it, so backout previous reservation
> -			 */
> -			if (resvd) {
> -				flags |= XFS_QMOPT_FORCE_RES;
> -				xfs_trans_dqresv(tp, mp, udqp,
> -						 -nblks, -ninos, flags);
> -			}
> -			return error;
> -		}
> +		if (error)
> +			goto unwind_usr;
> +	}
> +
> +	if (pdqp) {
> +		error = xfs_trans_dqresv(tp, mp, pdqp, nblks, ninos, flags);
> +		if (error)
> +			goto unwind_grp;
>  	}
>  
>  	/*
>  	 * Didn't change anything critical, so, no need to log
>  	 */
>  	return 0;
> +
> +unwind_grp:
> +	flags |= XFS_QMOPT_FORCE_RES;
> +	if (gdqp)
> +		xfs_trans_dqresv(tp, mp, gdqp, -nblks, -ninos, flags);
> +unwind_usr:
> +	flags |= XFS_QMOPT_FORCE_RES;
> +	if (udqp)
> +		xfs_trans_dqresv(tp, mp, udqp, -nblks, -ninos, flags);
> +	return error;
>  }
>  
>  
> @@ -830,6 +837,7 @@ xfs_trans_reserve_quota_nblks(
>  	 */
>  	return xfs_trans_reserve_quota_bydquots(tp, mp,
>  						ip->i_udquot, ip->i_gdquot,
> +						ip->i_pdquot,
>  						nblks, ninos, flags);
>  }
>  
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index 1501f4f..cd0d133 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -498,6 +498,7 @@ xfs_create(
>  	prid_t			prid;
>  	struct xfs_dquot	*udqp = NULL;
>  	struct xfs_dquot	*gdqp = NULL;
> +	struct xfs_dquot	*pdqp = NULL;
>  	uint			resblks;
>  	uint			log_res;
>  	uint			log_count;
> @@ -516,7 +517,7 @@ xfs_create(
>  	 * Make sure that we have allocated dquot(s) on disk.
>  	 */
>  	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
> -			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
> +		XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp, &pdqp);
>  	if (error)
>  		return error;
>  
> @@ -568,7 +569,8 @@ xfs_create(
>  	/*
>  	 * Reserve disk quota and the inode.
>  	 */
> -	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp, resblks, 1, 0);
> +	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
> +						pdqp, resblks, 1, 0);
>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -632,7 +634,7 @@ xfs_create(
>  	 * These ids of the inode couldn't have changed since the new
>  	 * inode has been locked ever since it was created.
>  	 */
> -	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp);
> +	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
>  
>  	error = xfs_bmap_finish(&tp, &free_list, &committed);
>  	if (error)
> @@ -644,6 +646,7 @@ xfs_create(
>  
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(gdqp);
> +	xfs_qm_dqrele(pdqp);
>  
>  	*ipp = ip;
>  	return 0;
> @@ -665,6 +668,7 @@ xfs_create(
>  
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(gdqp);
> +	xfs_qm_dqrele(pdqp);
>  
>  	if (unlock_dp_on_error)
>  		xfs_iunlock(dp, XFS_ILOCK_EXCL);
> @@ -1577,7 +1581,7 @@ xfs_free_file_space(
>  		}
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		error = xfs_trans_reserve_quota(tp, mp,
> -				ip->i_udquot, ip->i_gdquot,
> +				ip->i_udquot, ip->i_gdquot, ip->i_pdquot,
>  				resblks, 0, XFS_QMOPT_RES_REGBLKS);
>  		if (error)
>  			goto error1;
> 
Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
