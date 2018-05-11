Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41022 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751398AbeEKWoF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 May 2018 18:44:05 -0400
Date: Fri, 11 May 2018 15:43:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/8] xfs: refactor quota limits initialization
Message-ID: <20180511224345.GI11261@magnolia>
References: <152597988038.25215.9276761144353662866.stgit@magnolia>
 <152597988679.25215.8852024160735275694.stgit@magnolia>
 <20180511151918.GB105683@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180511151918.GB105683@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, May 11, 2018 at 11:19:18AM -0400, Brian Foster wrote:
> On Thu, May 10, 2018 at 12:18:06PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Replace all the if (!error) weirdness with helper functions that follow
> > our regular coding practices.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_qm.c |  141 ++++++++++++++++++++++++++++++-------------------------
> >  1 file changed, 77 insertions(+), 64 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index f927b7d72db1..9ce6dffc25f2 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -561,26 +561,87 @@ xfs_qm_set_defquota(
> ...
> > +/* Initialize quota time limits from the root dquot. */
> > +static void
> > +xfs_qm_init_timelimits(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_quotainfo	*qinf)
> > +{
> > +	struct xfs_disk_dquot	*ddqp;
> > +	struct xfs_dquot	*dqp;
> > +	uint			type;
> > +	int			error;
> > +
> > +	qinf->qi_btimelimit = XFS_QM_BTIMELIMIT;
> > +	qinf->qi_itimelimit = XFS_QM_ITIMELIMIT;
> > +	qinf->qi_rtbtimelimit = XFS_QM_RTBTIMELIMIT;
> > +	qinf->qi_bwarnlimit = XFS_QM_BWARNLIMIT;
> > +	qinf->qi_iwarnlimit = XFS_QM_IWARNLIMIT;
> > +	qinf->qi_rtbwarnlimit = XFS_QM_RTBWARNLIMIT;
> > +
> > +	/*
> > +	 * We try to get the limits from the superuser's limits fields.
> > +	 * This is quite hacky, but it is standard quota practice.
> > +	 *
> > +	 * Since we may not have done a quotacheck by this point, just read
> > +	 * the dquot without attaching it to any hashtables or lists.
> > +	 *
> > +	 * Timers and warnings are globally set by the first timer found in
> > +	 * user/group/proj quota types, otherwise a default value is used.
> > +	 * This should be split into different fields per quota type.
> > +	 */
> > +	if (XFS_IS_UQUOTA_RUNNING(mp))
> > +		type = XFS_DQ_USER;
> > +	else if (XFS_IS_GQUOTA_RUNNING(mp))
> > +		type = XFS_DQ_GROUP;
> > +	else
> > +		type = XFS_DQ_PROJ;
> > +	error = xfs_qm_dqget_uncached(mp, 0, type, &dqp);
> > +	if (error)
> > +		return;
> > +
> > +	ddqp = &dqp->q_core;
> > +	/*
> > +	 * The warnings and timers set the grace period given to
> > +	 * a user or group before he or she can not perform any
> > +	 * more writing. If it is zero, a default is used.
> > +	 */
> > +	qinf->qi_btimelimit = ddqp->d_btimer ?
> > +		be32_to_cpu(ddqp->d_btimer) : XFS_QM_BTIMELIMIT;
> > +	qinf->qi_itimelimit = ddqp->d_itimer ?
> > +		be32_to_cpu(ddqp->d_itimer) : XFS_QM_ITIMELIMIT;
> > +	qinf->qi_rtbtimelimit = ddqp->d_rtbtimer ?
> > +		be32_to_cpu(ddqp->d_rtbtimer) : XFS_QM_RTBTIMELIMIT;
> > +	qinf->qi_bwarnlimit = ddqp->d_bwarns ?
> > +		be16_to_cpu(ddqp->d_bwarns) : XFS_QM_BWARNLIMIT;
> > +	qinf->qi_iwarnlimit = ddqp->d_iwarns ?
> > +		be16_to_cpu(ddqp->d_iwarns) : XFS_QM_IWARNLIMIT;
> > +	qinf->qi_rtbwarnlimit = ddqp->d_rtbwarns ?
> > +		be16_to_cpu(ddqp->d_rtbwarns) : XFS_QM_RTBWARNLIMIT;
> 
> There's no need for these ternary statements if we initialized default
> values above. How about we just convert these to if checks? I.e.,
> 
> 	if (ddqp->d_btimer)
> 		qinf->qi_btimelimit = be32_to_cpu(ddqp->d_btimer);
> 	if (ddqp->d_itimer)
> 		qinf->qi_itimelimit = be32_to_cpu(ddqp->d_itimer);
> 	...
> 
> Otherwise looks Ok.

Fixed.

--D

> Brian
> 
> > +	xfs_qm_dqdestroy(dqp);
> >  }
> >  
> >  /*
> > @@ -592,8 +653,6 @@ xfs_qm_init_quotainfo(
> >  	struct xfs_mount	*mp)
> >  {
> >  	struct xfs_quotainfo	*qinf;
> > -	struct xfs_dquot	*dqp;
> > -	uint			type;
> >  	int			error;
> >  
> >  	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
> > @@ -626,53 +685,7 @@ xfs_qm_init_quotainfo(
> >  
> >  	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
> >  
> > -	/*
> > -	 * We try to get the limits from the superuser's limits fields.
> > -	 * This is quite hacky, but it is standard quota practice.
> > -	 *
> > -	 * Since we may not have done a quotacheck by this point, just read
> > -	 * the dquot without attaching it to any hashtables or lists.
> > -	 *
> > -	 * Timers and warnings are globally set by the first timer found in
> > -	 * user/group/proj quota types, otherwise a default value is used.
> > -	 * This should be split into different fields per quota type.
> > -	 */
> > -	if (XFS_IS_UQUOTA_RUNNING(mp))
> > -		type = XFS_DQ_USER;
> > -	else if (XFS_IS_GQUOTA_RUNNING(mp))
> > -		type = XFS_DQ_GROUP;
> > -	else
> > -		type = XFS_DQ_PROJ;
> > -	error = xfs_qm_dqget_uncached(mp, 0, type, &dqp);
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
> > -		xfs_qm_dqdestroy(dqp);
> > -	} else {
> > -		qinf->qi_btimelimit = XFS_QM_BTIMELIMIT;
> > -		qinf->qi_itimelimit = XFS_QM_ITIMELIMIT;
> > -		qinf->qi_rtbtimelimit = XFS_QM_RTBTIMELIMIT;
> > -		qinf->qi_bwarnlimit = XFS_QM_BWARNLIMIT;
> > -		qinf->qi_iwarnlimit = XFS_QM_IWARNLIMIT;
> > -		qinf->qi_rtbwarnlimit = XFS_QM_RTBWARNLIMIT;
> > -	}
> > +	xfs_qm_init_timelimits(mp, qinf);
> >  
> >  	if (XFS_IS_UQUOTA_RUNNING(mp))
> >  		xfs_qm_set_defquota(mp, XFS_DQ_USER, qinf);
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
