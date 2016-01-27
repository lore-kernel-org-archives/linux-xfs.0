Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 353457CA2
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 09:37:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E8D5E304039
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 07:37:14 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3CBbNXqQNkZlegLc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 27 Jan 2016 07:37:09 -0800 (PST)
Date: Wed, 27 Jan 2016 16:37:05 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] Split default quota limits by quota type
Message-ID: <20160127153705.GA17571@redhat.com>
References: <1453303127-27295-1-git-send-email-cmaiolino@redhat.com>
	<569FC41E.2040300@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <569FC41E.2040300@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

> > 
> > This patch aims to split the default quota value by quota type. Allowing each
> > quota type having different default values.
> > 
> > Default time limits are still set globally, but I don't mind to split them by
> > quota type too.
> 
> Hm, I guess it seems like it should be done; otherwise it's a weird
> caveat, isn't it?  "Default limits are set by type, but timers are
> inherited from whatever first default quota is found across all types"
> 
> So yeah, seems like it should be done for timers as well, IMHO;
> grace periods can be set for each default quota type, so they should
> be honored.
> 

Ok, I was just working on implement it, but honestly, I don't see the point now
in split time limits by user/group/project.

grace periods are set globally by default. We don't have specific quota grace
limits for each user or each group. Just a single value for them.

So, if we can not specify an individual grace period per-user or per-group, what
is the point in having these time limits split by user/group/project? We could
have the values divided by user/group/proj, but what's the sense on it? If we
have a default grace limit for users, it will be set to all users, if we have a
grace limit for groups, it will be enforced to all users anyway (since we can't
specify the group here either).

So, I wonder, does it make sense?

Looks a nice idea for the future, but for the current implementation it doesn't
make sense to me. But sure, let me know if I'm wrong :)

Cheers

> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Really just minor comments below; there is one code comment that needs to
> be removed.
> 
> Thanks!
> -Eric
> 
> > ---
> >  fs/xfs/xfs_dquot.c       | 26 +++++++------
> >  fs/xfs/xfs_qm.c          | 96 +++++++++++++++++++++++++++---------------------
> >  fs/xfs/xfs_qm.h          | 34 ++++++++++++++---
> >  fs/xfs/xfs_qm_syscalls.c | 15 +++++---
> >  fs/xfs/xfs_trans_dquot.c | 15 +++++---
> >  5 files changed, 114 insertions(+), 72 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index 9c44d38..23f551b 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -92,26 +92,28 @@ xfs_qm_adjust_dqlimits(
> >  {
> >  	struct xfs_quotainfo	*q = mp->m_quotainfo;
> >  	struct xfs_disk_dquot	*d = &dq->q_core;
> > +	struct xfs_def_quota	*defq;
> >  	int			prealloc = 0;
> >  
> >  	ASSERT(d->d_id);
> > +	defq = xfs_get_defquota(dq, q);
> >  
> > -	if (q->qi_bsoftlimit && !d->d_blk_softlimit) {
> > -		d->d_blk_softlimit = cpu_to_be64(q->qi_bsoftlimit);
> > +	if (defq->bsoftlimit && !d->d_blk_softlimit) {
> > +		d->d_blk_softlimit = cpu_to_be64(defq->bsoftlimit);
> >  		prealloc = 1;
> >  	}
> > -	if (q->qi_bhardlimit && !d->d_blk_hardlimit) {
> > -		d->d_blk_hardlimit = cpu_to_be64(q->qi_bhardlimit);
> > +	if (defq->bhardlimit && !d->d_blk_hardlimit) {
> > +		d->d_blk_hardlimit = cpu_to_be64(defq->bhardlimit);
> >  		prealloc = 1;
> >  	}
> > -	if (q->qi_isoftlimit && !d->d_ino_softlimit)
> > -		d->d_ino_softlimit = cpu_to_be64(q->qi_isoftlimit);
> > -	if (q->qi_ihardlimit && !d->d_ino_hardlimit)
> > -		d->d_ino_hardlimit = cpu_to_be64(q->qi_ihardlimit);
> > -	if (q->qi_rtbsoftlimit && !d->d_rtb_softlimit)
> > -		d->d_rtb_softlimit = cpu_to_be64(q->qi_rtbsoftlimit);
> > -	if (q->qi_rtbhardlimit && !d->d_rtb_hardlimit)
> > -		d->d_rtb_hardlimit = cpu_to_be64(q->qi_rtbhardlimit);
> > +	if (defq->isoftlimit && !d->d_ino_softlimit)
> > +		d->d_ino_softlimit = cpu_to_be64(defq->isoftlimit);
> > +	if (defq->ihardlimit && !d->d_ino_hardlimit)
> > +		d->d_ino_hardlimit = cpu_to_be64(defq->ihardlimit);
> > +	if (defq->rtbsoftlimit && !d->d_rtb_softlimit)
> > +		d->d_rtb_softlimit = cpu_to_be64(defq->rtbsoftlimit);
> > +	if (defq->rtbhardlimit && !d->d_rtb_hardlimit)
> > +		d->d_rtb_hardlimit = cpu_to_be64(defq->rtbhardlimit);
> >  
> >  	if (prealloc)
> >  		xfs_dquot_set_prealloc_limits(dq);
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index 532ab79..1bcb733 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -560,6 +560,54 @@ xfs_qm_shrink_count(
> >  	return list_lru_shrink_count(&qi->qi_lru, sc);
> >  }
> >  
> > +STATIC int
> > +xfs_qm_set_defquota(
> 
> It'd be a little easier to review if this were simply factored
> out in patch 1, then default quotas handled in patch 2, I think,
> but not that big a deal.
> 
> > +	xfs_mount_t	*mp,
> > +	uint		type,
> > +	xfs_quotainfo_t	*qinf)
> > +{
> > +	xfs_dquot_t		*dqp;
> > +	struct xfs_def_quota    *defq;
> > +	int			error;
> > +
> > +	error = xfs_qm_dqread(mp, 0, type, XFS_QMOPT_DOWARN, &dqp);
> > +
> > +	if (!error) {
> > +		xfs_disk_dquot_t        *ddqp = &dqp->q_core;
> > +
> > +		defq = xfs_get_defquota(dqp, qinf);
> > +
> > +		qinf->qi_btimelimit = ddqp->d_btimer ?
> > +			be32_to_cpu(ddqp->d_btimer) : XFS_QM_BTIMELIMIT;
> > +		qinf->qi_itimelimit = ddqp->d_itimer ?
> > +			be32_to_cpu(ddqp->d_itimer) : XFS_QM_ITIMELIMIT;
> > +		qinf->qi_rtbtimelimit = ddqp->d_rtbtimer ?
> > +			be32_to_cpu(ddqp->d_rtbtimer) : XFS_QM_RTBTIMELIMIT;
> > +		qinf->qi_bwarnlimit = ddqp->d_bwarns ?
> > +			be16_to_cpu(ddqp->d_bwarns) : XFS_QM_BWARNLIMIT;
> > +		qinf->qi_iwarnlimit = ddqp->d_iwarns ?
> > +			be16_to_cpu(ddqp->d_iwarns) : XFS_QM_IWARNLIMIT;
> > +		qinf->qi_rtbwarnlimit = ddqp->d_rtbwarns ?
> > +			be16_to_cpu(ddqp->d_rtbwarns) : XFS_QM_RTBWARNLIMIT;
> > +		defq->bhardlimit = be64_to_cpu(ddqp->d_blk_hardlimit);
> > +		defq->bsoftlimit = be64_to_cpu(ddqp->d_blk_softlimit);
> > +		defq->ihardlimit = be64_to_cpu(ddqp->d_ino_hardlimit);
> > +		defq->isoftlimit = be64_to_cpu(ddqp->d_ino_softlimit);
> > +		defq->rtbhardlimit = be64_to_cpu(ddqp->d_rtb_hardlimit);
> > +		defq->rtbsoftlimit = be64_to_cpu(ddqp->d_rtb_softlimit);
> > +		xfs_qm_dqdestroy(dqp);
> > +	} else {
> > +		qinf->qi_btimelimit = XFS_QM_BTIMELIMIT;
> > +		qinf->qi_itimelimit = XFS_QM_ITIMELIMIT;
> > +		qinf->qi_rtbtimelimit = XFS_QM_RTBTIMELIMIT;
> > +		qinf->qi_bwarnlimit = XFS_QM_BWARNLIMIT;
> > +		qinf->qi_iwarnlimit = XFS_QM_IWARNLIMIT;
> > +		qinf->qi_rtbwarnlimit = XFS_QM_RTBWARNLIMIT;
> > +	}
> > +
> > +	return error;
> > +}
> > +
> >  /*
> >   * This initializes all the quota information that's kept in the
> >   * mount structure
> > @@ -570,7 +618,6 @@ xfs_qm_init_quotainfo(
> >  {
> >  	xfs_quotainfo_t *qinf;
> >  	int		error;
> > -	xfs_dquot_t	*dqp;
> >  
> >  	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
> >  
> > @@ -614,47 +661,12 @@ xfs_qm_init_quotainfo(
> 
> There is a comment above this that should go away now:
> 
>          * We look at the USR dquot with id == 0 first, but if user quotas
>          * are not enabled we goto the GRP dquot with id == 0.
>          * We don't really care to keep separate default limits for user
>          * and group quotas, at least not at this point.
> 
> 
> >  	 * Since we may not have done a quotacheck by this point, just read
> >  	 * the dquot without attaching it to any hashtables or lists.
> >  	 */
> > -	error = xfs_qm_dqread(mp, 0,
> > -			XFS_IS_UQUOTA_RUNNING(mp) ? XFS_DQ_USER :
> > -			 (XFS_IS_GQUOTA_RUNNING(mp) ? XFS_DQ_GROUP :
> > -			  XFS_DQ_PROJ),
> > -			XFS_QMOPT_DOWARN, &dqp);
> > -	if (!error) {
> > -		xfs_disk_dquot_t	*ddqp = &dqp->q_core;
> > -
> > -		/*
> > -		 * The warnings and timers set the grace period given to
> > -		 * a user or group before he or she can not perform any
> > -		 * more writing. If it is zero, a default is used.
> > -		 */
> > -		qinf->qi_btimelimit = ddqp->d_btimer ?
> > -			be32_to_cpu(ddqp->d_btimer) : XFS_QM_BTIMELIMIT;
> > -		qinf->qi_itimelimit = ddqp->d_itimer ?
> > -			be32_to_cpu(ddqp->d_itimer) : XFS_QM_ITIMELIMIT;
> > -		qinf->qi_rtbtimelimit = ddqp->d_rtbtimer ?
> > -			be32_to_cpu(ddqp->d_rtbtimer) : XFS_QM_RTBTIMELIMIT;
> > -		qinf->qi_bwarnlimit = ddqp->d_bwarns ?
> > -			be16_to_cpu(ddqp->d_bwarns) : XFS_QM_BWARNLIMIT;
> > -		qinf->qi_iwarnlimit = ddqp->d_iwarns ?
> > -			be16_to_cpu(ddqp->d_iwarns) : XFS_QM_IWARNLIMIT;
> > -		qinf->qi_rtbwarnlimit = ddqp->d_rtbwarns ?
> > -			be16_to_cpu(ddqp->d_rtbwarns) : XFS_QM_RTBWARNLIMIT;
> > -		qinf->qi_bhardlimit = be64_to_cpu(ddqp->d_blk_hardlimit);
> > -		qinf->qi_bsoftlimit = be64_to_cpu(ddqp->d_blk_softlimit);
> > -		qinf->qi_ihardlimit = be64_to_cpu(ddqp->d_ino_hardlimit);
> > -		qinf->qi_isoftlimit = be64_to_cpu(ddqp->d_ino_softlimit);
> > -		qinf->qi_rtbhardlimit = be64_to_cpu(ddqp->d_rtb_hardlimit);
> > -		qinf->qi_rtbsoftlimit = be64_to_cpu(ddqp->d_rtb_softlimit);
> > -
> > -		xfs_qm_dqdestroy(dqp);
> > -	} else {
> > -		qinf->qi_btimelimit = XFS_QM_BTIMELIMIT;
> > -		qinf->qi_itimelimit = XFS_QM_ITIMELIMIT;
> > -		qinf->qi_rtbtimelimit = XFS_QM_RTBTIMELIMIT;
> > -		qinf->qi_bwarnlimit = XFS_QM_BWARNLIMIT;
> > -		qinf->qi_iwarnlimit = XFS_QM_IWARNLIMIT;
> > -		qinf->qi_rtbwarnlimit = XFS_QM_RTBWARNLIMIT;
> > -	}
> 
> 
> 
> > +	if (XFS_IS_UQUOTA_RUNNING(mp))
> > +		error = xfs_qm_set_defquota(mp, XFS_DQ_USER, qinf);
> 
> Hm, I guess the rest of the function looks at RUNNING not ENFORCED;
> for some reason I thought it would be ENFORCED, but *shrug* I guess
> it's right!
> 
> > +	if (XFS_IS_GQUOTA_RUNNING(mp))
> > +		error = xfs_qm_set_defquota(mp, XFS_DQ_GROUP, qinf);
> > +	if (XFS_IS_PQUOTA_RUNNING(mp))
> > +		error = xfs_qm_set_defquota(mp, XFS_DQ_PROJ, qinf);
> >  
> >  	qinf->qi_shrinker.count_objects = xfs_qm_shrink_count;
> >  	qinf->qi_shrinker.scan_objects = xfs_qm_shrink_scan;
> > diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> > index 996a040..45e2c36 100644
> > --- a/fs/xfs/xfs_qm.h
> > +++ b/fs/xfs/xfs_qm.h
> > @@ -53,6 +53,15 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
> >   */
> >  #define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
> >  
> > +struct xfs_def_quota {
> > +	xfs_qcnt_t       bhardlimit;     /* default data blk hard limit */
> > +	xfs_qcnt_t       bsoftlimit;	 /* default data blk soft limit */
> > +	xfs_qcnt_t       ihardlimit;	 /* default inode count hard limit */
> > +	xfs_qcnt_t       isoftlimit;	 /* default inode count soft limit */
> > +	xfs_qcnt_t	 rtbhardlimit;   /* default realtime blk hard limit */
> > +	xfs_qcnt_t	 rtbsoftlimit;   /* default realtime blk soft limit */
> > +};
> > +
> >  /*
> >   * Various quota information for individual filesystems.
> >   * The mount structure keeps a pointer to this.
> > @@ -76,12 +85,9 @@ typedef struct xfs_quotainfo {
> >  	struct mutex	 qi_quotaofflock;/* to serialize quotaoff */
> >  	xfs_filblks_t	 qi_dqchunklen;	 /* # BBs in a chunk of dqs */
> >  	uint		 qi_dqperchunk;	 /* # ondisk dqs in above chunk */
> > -	xfs_qcnt_t	 qi_bhardlimit;	 /* default data blk hard limit */
> > -	xfs_qcnt_t	 qi_bsoftlimit;	 /* default data blk soft limit */
> > -	xfs_qcnt_t	 qi_ihardlimit;	 /* default inode count hard limit */
> > -	xfs_qcnt_t	 qi_isoftlimit;	 /* default inode count soft limit */
> > -	xfs_qcnt_t	 qi_rtbhardlimit;/* default realtime blk hard limit */
> > -	xfs_qcnt_t	 qi_rtbsoftlimit;/* default realtime blk soft limit */
> > +	struct xfs_def_quota	qi_usr_default;
> > +	struct xfs_def_quota	qi_grp_default;
> > +	struct xfs_def_quota	qi_prj_default;
> >  	struct shrinker  qi_shrinker;
> >  } xfs_quotainfo_t;
> >  
> > @@ -171,4 +177,20 @@ extern int		xfs_qm_scall_setqlim(struct xfs_mount *, xfs_dqid_t, uint,
> >  extern int		xfs_qm_scall_quotaon(struct xfs_mount *, uint);
> >  extern int		xfs_qm_scall_quotaoff(struct xfs_mount *, uint);
> >  
> > +static inline struct xfs_def_quota *
> > +xfs_get_defquota(struct xfs_dquot *dqp, struct xfs_quotainfo *qi)
> > +{
> > +	struct xfs_def_quota *defq;
> > +
> > +	if (XFS_QM_ISUDQ(dqp))
> > +		defq = &qi->qi_usr_default;
> > +	else if (XFS_QM_ISGDQ(dqp))
> > +		defq = &qi->qi_grp_default;
> > +	else {
> > +		ASSERT(XFS_QM_ISPDQ(dqp));
> > +		defq = &qi->qi_prj_default;
> > +	}
> > +	return defq;
> > +}
> > +
> >  #endif /* __XFS_QM_H__ */
> > diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> > index 3640c6e..31830f0 100644
> > --- a/fs/xfs/xfs_qm_syscalls.c
> > +++ b/fs/xfs/xfs_qm_syscalls.c
> > @@ -404,6 +404,7 @@ xfs_qm_scall_setqlim(
> >  	struct xfs_disk_dquot	*ddq;
> >  	struct xfs_dquot	*dqp;
> >  	struct xfs_trans	*tp;
> > +	struct xfs_def_quota	*defq;
> >  	int			error;
> >  	xfs_qcnt_t		hard, soft;
> >  
> > @@ -431,6 +432,8 @@ xfs_qm_scall_setqlim(
> >  		ASSERT(error != -ENOENT);
> >  		goto out_unlock;
> >  	}
> > +
> > +	defq = xfs_get_defquota(dqp, q);
> >  	xfs_dqunlock(dqp);
> >  
> >  	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SETQLIM);
> > @@ -458,8 +461,8 @@ xfs_qm_scall_setqlim(
> >  		ddq->d_blk_softlimit = cpu_to_be64(soft);
> >  		xfs_dquot_set_prealloc_limits(dqp);
> >  		if (id == 0) {
> > -			q->qi_bhardlimit = hard;
> > -			q->qi_bsoftlimit = soft;
> > +			defq->bhardlimit = hard;
> > +			defq->bsoftlimit = soft;
> >  		}
> >  	} else {
> >  		xfs_debug(mp, "blkhard %Ld < blksoft %Ld", hard, soft);
> > @@ -474,8 +477,8 @@ xfs_qm_scall_setqlim(
> >  		ddq->d_rtb_hardlimit = cpu_to_be64(hard);
> >  		ddq->d_rtb_softlimit = cpu_to_be64(soft);
> >  		if (id == 0) {
> > -			q->qi_rtbhardlimit = hard;
> > -			q->qi_rtbsoftlimit = soft;
> > +			defq->rtbhardlimit = hard;
> > +			defq->rtbsoftlimit = soft;
> >  		}
> >  	} else {
> >  		xfs_debug(mp, "rtbhard %Ld < rtbsoft %Ld", hard, soft);
> > @@ -491,8 +494,8 @@ xfs_qm_scall_setqlim(
> >  		ddq->d_ino_hardlimit = cpu_to_be64(hard);
> >  		ddq->d_ino_softlimit = cpu_to_be64(soft);
> >  		if (id == 0) {
> > -			q->qi_ihardlimit = hard;
> > -			q->qi_isoftlimit = soft;
> > +			defq->ihardlimit = hard;
> > +			defq->isoftlimit = soft;
> >  		}
> >  	} else {
> >  		xfs_debug(mp, "ihard %Ld < isoft %Ld", hard, soft);
> > diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> > index 9951701..c3d5472 100644
> > --- a/fs/xfs/xfs_trans_dquot.c
> > +++ b/fs/xfs/xfs_trans_dquot.c
> > @@ -609,17 +609,20 @@ xfs_trans_dqresv(
> >  	xfs_qcnt_t	total_count;
> >  	xfs_qcnt_t	*resbcountp;
> >  	xfs_quotainfo_t	*q = mp->m_quotainfo;
> > +	struct xfs_def_quota	*defq;
> >  
> >  
> >  	xfs_dqlock(dqp);
> >  
> > +	defq = xfs_get_defquota(dqp, q);
> > +
> >  	if (flags & XFS_TRANS_DQ_RES_BLKS) {
> >  		hardlimit = be64_to_cpu(dqp->q_core.d_blk_hardlimit);
> >  		if (!hardlimit)
> > -			hardlimit = q->qi_bhardlimit;
> > +			hardlimit = defq->bhardlimit;
> >  		softlimit = be64_to_cpu(dqp->q_core.d_blk_softlimit);
> >  		if (!softlimit)
> > -			softlimit = q->qi_bsoftlimit;
> > +			softlimit = defq->bsoftlimit;
> >  		timer = be32_to_cpu(dqp->q_core.d_btimer);
> >  		warns = be16_to_cpu(dqp->q_core.d_bwarns);
> >  		warnlimit = dqp->q_mount->m_quotainfo->qi_bwarnlimit;
> > @@ -628,10 +631,10 @@ xfs_trans_dqresv(
> >  		ASSERT(flags & XFS_TRANS_DQ_RES_RTBLKS);
> >  		hardlimit = be64_to_cpu(dqp->q_core.d_rtb_hardlimit);
> >  		if (!hardlimit)
> > -			hardlimit = q->qi_rtbhardlimit;
> > +			hardlimit = defq->rtbhardlimit;
> >  		softlimit = be64_to_cpu(dqp->q_core.d_rtb_softlimit);
> >  		if (!softlimit)
> > -			softlimit = q->qi_rtbsoftlimit;
> > +			softlimit = defq->rtbsoftlimit;
> >  		timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
> >  		warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
> >  		warnlimit = dqp->q_mount->m_quotainfo->qi_rtbwarnlimit;
> > @@ -672,10 +675,10 @@ xfs_trans_dqresv(
> >  			warnlimit = dqp->q_mount->m_quotainfo->qi_iwarnlimit;
> >  			hardlimit = be64_to_cpu(dqp->q_core.d_ino_hardlimit);
> >  			if (!hardlimit)
> > -				hardlimit = q->qi_ihardlimit;
> > +				hardlimit = defq->ihardlimit;
> >  			softlimit = be64_to_cpu(dqp->q_core.d_ino_softlimit);
> >  			if (!softlimit)
> > -				softlimit = q->qi_isoftlimit;
> > +				softlimit = defq->isoftlimit;
> >  
> >  			if (hardlimit && total_count > hardlimit) {
> >  				xfs_quota_warn(mp, dqp, QUOTA_NL_IHARDWARN);
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
