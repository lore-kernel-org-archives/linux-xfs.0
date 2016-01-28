Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A1C687CA2
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 11:37:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9F49D8F8039
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 09:37:00 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id nEJxDdiBfOsH6TJJ for <xfs@oss.sgi.com>;
	Thu, 28 Jan 2016 09:36:56 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 587FB63C6064
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 11:36:56 -0600 (CST)
Subject: Re: [PATCH] xfs: Split default quota limits by quota type V3
References: <1454000266-22541-1-git-send-email-cmaiolino@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56AA51B7.7030403@sandeen.net>
Date: Thu, 28 Jan 2016 11:36:55 -0600
MIME-Version: 1.0
In-Reply-To: <1454000266-22541-1-git-send-email-cmaiolino@redhat.com>
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
To: xfs@oss.sgi.com

On 1/28/16 10:57 AM, Carlos Maiolino wrote:
> Default quotas are globally set due historical reasons. IRIX only supported user
> and project quotas, and default quota was only applied to user quotas.
> 
> In Linux, when a default quota is set, all different quota types inherits the
> same default value.
> 
> An user with a quota limit larger than the default quota value, will still be
> limited to the default value because the group quotas also inherits the default
> quotas. Unless the group which the user belongs to have a custom quota limit
> set.
> 
> This patch aims to split the default quota value by quota type. Allowing each
> quota type having different default values.
> 
> Default time limits are still set globally. XFS does not set a per-user/group
> timer, but a single global timer. For changing this behavior, some changes
> should be made in user-space tools another bugs being fixed.

Some minor comments about comments below.  But the code looks fine to me,
so:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

and if you want to fix the comments & resend w/ my review tag I think that'd
be ok.

Care to write an xfstests testcase for the default quota limit while you're
at it?

Thanks,
-Eric

> Changelog:
> 
> 	V2 - Remove comment about old behavior
> 	V3 - Keep time limit configuration inside xfs_qm_init_quotainfo to keep
> 	     the current behavior of quota timers
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_dquot.c       | 26 +++++++++++---------
>  fs/xfs/xfs_qm.c          | 64 +++++++++++++++++++++++++++++++++++-------------
>  fs/xfs/xfs_qm.h          | 34 ++++++++++++++++++++-----
>  fs/xfs/xfs_qm_syscalls.c | 15 +++++++-----
>  fs/xfs/xfs_trans_dquot.c | 15 +++++++-----
>  5 files changed, 107 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 9c44d38..23f551b 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -92,26 +92,28 @@ xfs_qm_adjust_dqlimits(
>  {
>  	struct xfs_quotainfo	*q = mp->m_quotainfo;
>  	struct xfs_disk_dquot	*d = &dq->q_core;
> +	struct xfs_def_quota	*defq;
>  	int			prealloc = 0;
>  
>  	ASSERT(d->d_id);
> +	defq = xfs_get_defquota(dq, q);
>  
> -	if (q->qi_bsoftlimit && !d->d_blk_softlimit) {
> -		d->d_blk_softlimit = cpu_to_be64(q->qi_bsoftlimit);
> +	if (defq->bsoftlimit && !d->d_blk_softlimit) {
> +		d->d_blk_softlimit = cpu_to_be64(defq->bsoftlimit);
>  		prealloc = 1;
>  	}
> -	if (q->qi_bhardlimit && !d->d_blk_hardlimit) {
> -		d->d_blk_hardlimit = cpu_to_be64(q->qi_bhardlimit);
> +	if (defq->bhardlimit && !d->d_blk_hardlimit) {
> +		d->d_blk_hardlimit = cpu_to_be64(defq->bhardlimit);
>  		prealloc = 1;
>  	}
> -	if (q->qi_isoftlimit && !d->d_ino_softlimit)
> -		d->d_ino_softlimit = cpu_to_be64(q->qi_isoftlimit);
> -	if (q->qi_ihardlimit && !d->d_ino_hardlimit)
> -		d->d_ino_hardlimit = cpu_to_be64(q->qi_ihardlimit);
> -	if (q->qi_rtbsoftlimit && !d->d_rtb_softlimit)
> -		d->d_rtb_softlimit = cpu_to_be64(q->qi_rtbsoftlimit);
> -	if (q->qi_rtbhardlimit && !d->d_rtb_hardlimit)
> -		d->d_rtb_hardlimit = cpu_to_be64(q->qi_rtbhardlimit);
> +	if (defq->isoftlimit && !d->d_ino_softlimit)
> +		d->d_ino_softlimit = cpu_to_be64(defq->isoftlimit);
> +	if (defq->ihardlimit && !d->d_ino_hardlimit)
> +		d->d_ino_hardlimit = cpu_to_be64(defq->ihardlimit);
> +	if (defq->rtbsoftlimit && !d->d_rtb_softlimit)
> +		d->d_rtb_softlimit = cpu_to_be64(defq->rtbsoftlimit);
> +	if (defq->rtbhardlimit && !d->d_rtb_hardlimit)
> +		d->d_rtb_hardlimit = cpu_to_be64(defq->rtbhardlimit);
>  
>  	if (prealloc)
>  		xfs_dquot_set_prealloc_limits(dq);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 532ab79..4cbb22b 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -560,6 +560,37 @@ xfs_qm_shrink_count(
>  	return list_lru_shrink_count(&qi->qi_lru, sc);
>  }
>  
> +STATIC void
> +xfs_qm_set_defquota(
> +	xfs_mount_t	*mp,
> +	uint		type,
> +	xfs_quotainfo_t	*qinf)
> +{
> +	xfs_dquot_t		*dqp;
> +	struct xfs_def_quota    *defq;
> +	int			error;
> +
> +	error = xfs_qm_dqread(mp, 0, type, XFS_QMOPT_DOWARN, &dqp);
> +
> +	if (!error) {
> +		xfs_disk_dquot_t        *ddqp = &dqp->q_core;
> +
> +		defq = xfs_get_defquota(dqp, qinf);
> +
> +		/*
> +		 * Timers and warnings have been already set, let's just set the
> +		 * default limits for this quota type
> +		 */
> +		defq->bhardlimit = be64_to_cpu(ddqp->d_blk_hardlimit);
> +		defq->bsoftlimit = be64_to_cpu(ddqp->d_blk_softlimit);
> +		defq->ihardlimit = be64_to_cpu(ddqp->d_ino_hardlimit);
> +		defq->isoftlimit = be64_to_cpu(ddqp->d_ino_softlimit);
> +		defq->rtbhardlimit = be64_to_cpu(ddqp->d_rtb_hardlimit);
> +		defq->rtbsoftlimit = be64_to_cpu(ddqp->d_rtb_softlimit);
> +		xfs_qm_dqdestroy(dqp);
> +	}
> +}
> +
>  /*
>   * This initializes all the quota information that's kept in the
>   * mount structure
> @@ -606,27 +637,22 @@ xfs_qm_init_quotainfo(
>  	 * We try to get the limits from the superuser's limits fields.
>  	 * This is quite hacky, but it is standard quota practice.
>  	 *
> -	 * We look at the USR dquot with id == 0 first, but if user quotas
> -	 * are not enabled we goto the GRP dquot with id == 0.
> -	 * We don't really care to keep separate default limits for user
> -	 * and group quotas, at least not at this point.
> -	 *
>  	 * Since we may not have done a quotacheck by this point, just read
>  	 * the dquot without attaching it to any hashtables or lists.
> +	 *
> +	 * Timers and warnings are globally set by the first timer found in
> +	 * user/group/proj quota types, otherwise a default value is used.
> +	 * This should be splitted into different fields per quota type.

s/splitted/split/

>  	 */
>  	error = xfs_qm_dqread(mp, 0,
>  			XFS_IS_UQUOTA_RUNNING(mp) ? XFS_DQ_USER :
>  			 (XFS_IS_GQUOTA_RUNNING(mp) ? XFS_DQ_GROUP :
>  			  XFS_DQ_PROJ),
>  			XFS_QMOPT_DOWARN, &dqp);
> +
>  	if (!error) {
>  		xfs_disk_dquot_t	*ddqp = &dqp->q_core;
>  
> -		/*
> -		 * The warnings and timers set the grace period given to
> -		 * a user or group before he or she can not perform any
> -		 * more writing. If it is zero, a default is used.
> -		 */

Not sure why you removed this comment?

>  		qinf->qi_btimelimit = ddqp->d_btimer ?
>  			be32_to_cpu(ddqp->d_btimer) : XFS_QM_BTIMELIMIT;
>  		qinf->qi_itimelimit = ddqp->d_itimer ?
> @@ -639,13 +665,6 @@ xfs_qm_init_quotainfo(
>  			be16_to_cpu(ddqp->d_iwarns) : XFS_QM_IWARNLIMIT;
>  		qinf->qi_rtbwarnlimit = ddqp->d_rtbwarns ?
>  			be16_to_cpu(ddqp->d_rtbwarns) : XFS_QM_RTBWARNLIMIT;
> -		qinf->qi_bhardlimit = be64_to_cpu(ddqp->d_blk_hardlimit);
> -		qinf->qi_bsoftlimit = be64_to_cpu(ddqp->d_blk_softlimit);
> -		qinf->qi_ihardlimit = be64_to_cpu(ddqp->d_ino_hardlimit);
> -		qinf->qi_isoftlimit = be64_to_cpu(ddqp->d_ino_softlimit);
> -		qinf->qi_rtbhardlimit = be64_to_cpu(ddqp->d_rtb_hardlimit);
> -		qinf->qi_rtbsoftlimit = be64_to_cpu(ddqp->d_rtb_softlimit);
> -
>  		xfs_qm_dqdestroy(dqp);
>  	} else {
>  		qinf->qi_btimelimit = XFS_QM_BTIMELIMIT;
> @@ -656,6 +675,17 @@ xfs_qm_init_quotainfo(
>  		qinf->qi_rtbwarnlimit = XFS_QM_RTBWARNLIMIT;
>  	}
>  
> +	/*
> +	 * Default quota values are set by quota type, timer and warn limits
> +	 * have already been setpreviously, no need for error check here.

"set previously" - and, not sure the comment about error checking is needed.
Previously, if we couldn't read the inode, we set timers but no limits.
And the limits were (and still are) zalloc'd so it's safe to ignore
the errors, I guess.


> +	 */
> +	if (XFS_IS_UQUOTA_RUNNING(mp))
> +		xfs_qm_set_defquota(mp, XFS_DQ_USER, qinf);
> +	if (XFS_IS_GQUOTA_RUNNING(mp))
> +		xfs_qm_set_defquota(mp, XFS_DQ_GROUP, qinf);
> +	if (XFS_IS_PQUOTA_RUNNING(mp))
> +		xfs_qm_set_defquota(mp, XFS_DQ_PROJ, qinf);
> +
>  	qinf->qi_shrinker.count_objects = xfs_qm_shrink_count;
>  	qinf->qi_shrinker.scan_objects = xfs_qm_shrink_scan;
>  	qinf->qi_shrinker.seeks = DEFAULT_SEEKS;
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 996a040..45e2c36 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -53,6 +53,15 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
>   */
>  #define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
>  
> +struct xfs_def_quota {
> +	xfs_qcnt_t       bhardlimit;     /* default data blk hard limit */
> +	xfs_qcnt_t       bsoftlimit;	 /* default data blk soft limit */
> +	xfs_qcnt_t       ihardlimit;	 /* default inode count hard limit */
> +	xfs_qcnt_t       isoftlimit;	 /* default inode count soft limit */
> +	xfs_qcnt_t	 rtbhardlimit;   /* default realtime blk hard limit */
> +	xfs_qcnt_t	 rtbsoftlimit;   /* default realtime blk soft limit */
> +};
> +
>  /*
>   * Various quota information for individual filesystems.
>   * The mount structure keeps a pointer to this.
> @@ -76,12 +85,9 @@ typedef struct xfs_quotainfo {
>  	struct mutex	 qi_quotaofflock;/* to serialize quotaoff */
>  	xfs_filblks_t	 qi_dqchunklen;	 /* # BBs in a chunk of dqs */
>  	uint		 qi_dqperchunk;	 /* # ondisk dqs in above chunk */
> -	xfs_qcnt_t	 qi_bhardlimit;	 /* default data blk hard limit */
> -	xfs_qcnt_t	 qi_bsoftlimit;	 /* default data blk soft limit */
> -	xfs_qcnt_t	 qi_ihardlimit;	 /* default inode count hard limit */
> -	xfs_qcnt_t	 qi_isoftlimit;	 /* default inode count soft limit */
> -	xfs_qcnt_t	 qi_rtbhardlimit;/* default realtime blk hard limit */
> -	xfs_qcnt_t	 qi_rtbsoftlimit;/* default realtime blk soft limit */
> +	struct xfs_def_quota	qi_usr_default;
> +	struct xfs_def_quota	qi_grp_default;
> +	struct xfs_def_quota	qi_prj_default;
>  	struct shrinker  qi_shrinker;
>  } xfs_quotainfo_t;
>  
> @@ -171,4 +177,20 @@ extern int		xfs_qm_scall_setqlim(struct xfs_mount *, xfs_dqid_t, uint,
>  extern int		xfs_qm_scall_quotaon(struct xfs_mount *, uint);
>  extern int		xfs_qm_scall_quotaoff(struct xfs_mount *, uint);
>  
> +static inline struct xfs_def_quota *
> +xfs_get_defquota(struct xfs_dquot *dqp, struct xfs_quotainfo *qi)
> +{
> +	struct xfs_def_quota *defq;
> +
> +	if (XFS_QM_ISUDQ(dqp))
> +		defq = &qi->qi_usr_default;
> +	else if (XFS_QM_ISGDQ(dqp))
> +		defq = &qi->qi_grp_default;
> +	else {
> +		ASSERT(XFS_QM_ISPDQ(dqp));
> +		defq = &qi->qi_prj_default;
> +	}
> +	return defq;
> +}
> +
>  #endif /* __XFS_QM_H__ */
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 3640c6e..31830f0 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -404,6 +404,7 @@ xfs_qm_scall_setqlim(
>  	struct xfs_disk_dquot	*ddq;
>  	struct xfs_dquot	*dqp;
>  	struct xfs_trans	*tp;
> +	struct xfs_def_quota	*defq;
>  	int			error;
>  	xfs_qcnt_t		hard, soft;
>  
> @@ -431,6 +432,8 @@ xfs_qm_scall_setqlim(
>  		ASSERT(error != -ENOENT);
>  		goto out_unlock;
>  	}
> +
> +	defq = xfs_get_defquota(dqp, q);
>  	xfs_dqunlock(dqp);
>  
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SETQLIM);
> @@ -458,8 +461,8 @@ xfs_qm_scall_setqlim(
>  		ddq->d_blk_softlimit = cpu_to_be64(soft);
>  		xfs_dquot_set_prealloc_limits(dqp);
>  		if (id == 0) {
> -			q->qi_bhardlimit = hard;
> -			q->qi_bsoftlimit = soft;
> +			defq->bhardlimit = hard;
> +			defq->bsoftlimit = soft;
>  		}
>  	} else {
>  		xfs_debug(mp, "blkhard %Ld < blksoft %Ld", hard, soft);
> @@ -474,8 +477,8 @@ xfs_qm_scall_setqlim(
>  		ddq->d_rtb_hardlimit = cpu_to_be64(hard);
>  		ddq->d_rtb_softlimit = cpu_to_be64(soft);
>  		if (id == 0) {
> -			q->qi_rtbhardlimit = hard;
> -			q->qi_rtbsoftlimit = soft;
> +			defq->rtbhardlimit = hard;
> +			defq->rtbsoftlimit = soft;
>  		}
>  	} else {
>  		xfs_debug(mp, "rtbhard %Ld < rtbsoft %Ld", hard, soft);
> @@ -491,8 +494,8 @@ xfs_qm_scall_setqlim(
>  		ddq->d_ino_hardlimit = cpu_to_be64(hard);
>  		ddq->d_ino_softlimit = cpu_to_be64(soft);
>  		if (id == 0) {
> -			q->qi_ihardlimit = hard;
> -			q->qi_isoftlimit = soft;
> +			defq->ihardlimit = hard;
> +			defq->isoftlimit = soft;
>  		}
>  	} else {
>  		xfs_debug(mp, "ihard %Ld < isoft %Ld", hard, soft);
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 9951701..c3d5472 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -609,17 +609,20 @@ xfs_trans_dqresv(
>  	xfs_qcnt_t	total_count;
>  	xfs_qcnt_t	*resbcountp;
>  	xfs_quotainfo_t	*q = mp->m_quotainfo;
> +	struct xfs_def_quota	*defq;
>  
>  
>  	xfs_dqlock(dqp);
>  
> +	defq = xfs_get_defquota(dqp, q);
> +
>  	if (flags & XFS_TRANS_DQ_RES_BLKS) {
>  		hardlimit = be64_to_cpu(dqp->q_core.d_blk_hardlimit);
>  		if (!hardlimit)
> -			hardlimit = q->qi_bhardlimit;
> +			hardlimit = defq->bhardlimit;
>  		softlimit = be64_to_cpu(dqp->q_core.d_blk_softlimit);
>  		if (!softlimit)
> -			softlimit = q->qi_bsoftlimit;
> +			softlimit = defq->bsoftlimit;
>  		timer = be32_to_cpu(dqp->q_core.d_btimer);
>  		warns = be16_to_cpu(dqp->q_core.d_bwarns);
>  		warnlimit = dqp->q_mount->m_quotainfo->qi_bwarnlimit;
> @@ -628,10 +631,10 @@ xfs_trans_dqresv(
>  		ASSERT(flags & XFS_TRANS_DQ_RES_RTBLKS);
>  		hardlimit = be64_to_cpu(dqp->q_core.d_rtb_hardlimit);
>  		if (!hardlimit)
> -			hardlimit = q->qi_rtbhardlimit;
> +			hardlimit = defq->rtbhardlimit;
>  		softlimit = be64_to_cpu(dqp->q_core.d_rtb_softlimit);
>  		if (!softlimit)
> -			softlimit = q->qi_rtbsoftlimit;
> +			softlimit = defq->rtbsoftlimit;
>  		timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
>  		warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
>  		warnlimit = dqp->q_mount->m_quotainfo->qi_rtbwarnlimit;
> @@ -672,10 +675,10 @@ xfs_trans_dqresv(
>  			warnlimit = dqp->q_mount->m_quotainfo->qi_iwarnlimit;
>  			hardlimit = be64_to_cpu(dqp->q_core.d_ino_hardlimit);
>  			if (!hardlimit)
> -				hardlimit = q->qi_ihardlimit;
> +				hardlimit = defq->ihardlimit;
>  			softlimit = be64_to_cpu(dqp->q_core.d_ino_softlimit);
>  			if (!softlimit)
> -				softlimit = q->qi_isoftlimit;
> +				softlimit = defq->isoftlimit;
>  
>  			if (hardlimit && total_count > hardlimit) {
>  				xfs_quota_warn(mp, dqp, QUOTA_NL_IHARDWARN);
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
