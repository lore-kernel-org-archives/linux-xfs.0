Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E8C6C7CA2
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 07:48:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 75E95AC003
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 05:48:33 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id izJ7FRcxmPmEBtu5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Jan 2016 05:48:32 -0800 (PST)
Date: Thu, 28 Jan 2016 14:48:27 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: split default quota limits by quota type V2
Message-ID: <20160128134827.GA4115@redhat.com>
References: <1453913878-30900-1-git-send-email-cmaiolino@redhat.com>
	<56A914BB.4050301@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56A914BB.4050301@sandeen.net>
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

On Wed, Jan 27, 2016 at 01:04:27PM -0600, Eric Sandeen wrote:
> On 1/27/16 10:57 AM, Carlos Maiolino wrote:
> > Default quotas are globally set due historical reasons. IRIX only supported user
> > and project quotas, and default quota was only applied to user quotas.
> > 
> > In Linux, when a default quota is set, all different quota types inherits the
> > same default value.
> > 
> > An user with a quota limit larger than the default quota value, will still be
> > limited to the default value because the group quotas also inherits the default
> > quotas. Unless the group which the user belongs to have a custom quota limit
> > set.
> > 
> > This patch aims to split the default quota value by quota type. Allowing each
> > quota type having different default values.
> > 
> > Default time limits are still set globally. XFS does not set a per-user/group
> > timer, but a single global timer, so, there is no reason to split time limits
> > too.
> > 
> 
> Hohum, found something else, sorry:
> 
Yep, I noticed it today's morning while playing with the time limits, but I
think I know how to fix it already, I'll test it and let you know.

Thanks for the heads up though :)


> > @@ -606,55 +653,15 @@ xfs_qm_init_quotainfo(
> >  	 * We try to get the limits from the superuser's limits fields.
> >  	 * This is quite hacky, but it is standard quota practice.
> >  	 *
> > -	 * We look at the USR dquot with id == 0 first, but if user quotas
> > -	 * are not enabled we goto the GRP dquot with id == 0.
> > -	 * We don't really care to keep separate default limits for user
> > -	 * and group quotas, at least not at this point.
> > -	 *
> >  	 * Since we may not have done a quotacheck by this point, just read
> >  	 * the dquot without attaching it to any hashtables or lists.
> >  	 */
> > -	error = xfs_qm_dqread(mp, 0,
> > -			XFS_IS_UQUOTA_RUNNING(mp) ? XFS_DQ_USER :
> > -			 (XFS_IS_GQUOTA_RUNNING(mp) ? XFS_DQ_GROUP :
> > -			  XFS_DQ_PROJ),
> > -			XFS_QMOPT_DOWARN, &dqp);
> 
> So here, we grab the *first* one that is running, and only that, to
> populate the defaults ...
> 
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
> 
> ... including the time limits.
> 
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
> > +	if (XFS_IS_UQUOTA_RUNNING(mp))
> > +		error = xfs_qm_set_defquota(mp, XFS_DQ_USER, qinf);
> > +	if (XFS_IS_GQUOTA_RUNNING(mp))
> > +		error = xfs_qm_set_defquota(mp, XFS_DQ_GROUP, qinf);
> > +	if (XFS_IS_PQUOTA_RUNNING(mp))
> > +		error = xfs_qm_set_defquota(mp, XFS_DQ_PROJ, qinf);
> 
> Here, you set the defaults for *each* one that is running, in succession.
> But xfs_qm_set_defquota() sets global time limits, so you may overwrite
> what you set earlier, for the previous type.  i.e. it's last one wins.
> 
> So before, the global grace period was set by the first quota found running;
> now it will be set by the last quota found running.  That's probably a difference
> in behavior you didn't intend.
> 
> (It's crazy behavior to start with, though; see my other email in this thread,
> but we probably shouldn't trade crazy(1) for crazy(1);  we should keep crazy(1)
> and fix it properly at some point)
> 
> -Eric
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
