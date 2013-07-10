Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 171287F3F
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 16:46:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 052278F8040
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 14:46:43 -0700 (PDT)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154]) by
	cuda.sgi.com with ESMTP id L8ElPvXTVZr95Tw4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 14:46:42 -0700 (PDT)
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 10 Jul 2013 15:46:41 -0600
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id A2D0D1FF002E
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 15:41:20 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r6ALkdiw159054 for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 15:46:39 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r6ALkdhW017547
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 15:46:39 -0600
Subject: Re: [PATCH v10 08/11] xfs: Add pquota fields where gquota is used.
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130710213907.GZ20932@sgi.com>
References: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
	<1372371914-11370-9-git-send-email-sekharan@us.ibm.com>
	<20130710213907.GZ20932@sgi.com>
Date: Wed, 10 Jul 2013 16:46:38 -0500
Message-ID: <1373492798.6020.34.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

I am rolling up a new set with changes based on David's comments and
Jan's comments.

Will address your comments too.
On Wed, 2013-07-10 at 16:39 -0500, Ben Myers wrote:
> Hi Chandra,
> 
> On Thu, Jun 27, 2013 at 05:25:11PM -0500, Chandra Seetharaman wrote:
> > Add project quota changes to all the places where group quota field
> > is used:
> >    * add separate project quota members into various structures
> >    * split project quota and group quotas so that instead of overriding
> >      the group quota members incore, the new project quota members are
> >      used instead
> >    * get rid of usage of the OQUOTA flag incore, in favor of separate
> >    * group and project quota flags.
> 
>      ^ * is extra?

will fix
> 
> >    * add a project dquot argument to various functions.
> > 
> > Not using the pquotino field from superblock yet.
> > 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> Patch looks good to me.
> 
> Reviewed-by: Ben Myers <bpm@sgi.com>
> 
> I had just a few tiny nits and questions I found in review.  If you were not
> already planning to repost I suggest you ignore them.  ;)
> 
> Regards,
> 	Ben
> 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 5e99968..71a8bc5 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -928,7 +928,7 @@ xfs_ioctl_setattr(
> >  	struct xfs_trans	*tp;
> >  	unsigned int		lock_flags = 0;
> >  	struct xfs_dquot	*udqp = NULL;
> > -	struct xfs_dquot	*gdqp = NULL;
> > +	struct xfs_dquot	*pdqp = NULL;
> >  	struct xfs_dquot	*olddquot = NULL;
> >  	int			code;
> >  
> > @@ -957,7 +957,7 @@ xfs_ioctl_setattr(
> >  	if (XFS_IS_QUOTA_ON(mp) && (mask & FSX_PROJID)) {
> >  		code = xfs_qm_vop_dqalloc(ip, ip->i_d.di_uid,
> >  					 ip->i_d.di_gid, fa->fsx_projid,
> > -					 XFS_QMOPT_PQUOTA, &udqp, &gdqp);
> > +					 XFS_QMOPT_PQUOTA, &udqp, NULL, &pdqp);
> >  		if (code)
> >  			return code;
> >  	}
> > @@ -994,8 +994,8 @@ xfs_ioctl_setattr(
> >  		    XFS_IS_PQUOTA_ON(mp) &&
> >  		    xfs_get_projid(ip) != fa->fsx_projid) {
> >  			ASSERT(tp);
> > -			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
> > -						capable(CAP_FOWNER) ?
> > +			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, NULL,
> > +						pdqp, capable(CAP_FOWNER) ?
> >  						XFS_QMOPT_FORCE_RES : 0);
> >  			if (code)	/* out of quota */
> >  				goto error_return;
> > @@ -1113,7 +1113,7 @@ xfs_ioctl_setattr(
> >  		if (xfs_get_projid(ip) != fa->fsx_projid) {
> >  			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
> >  				olddquot = xfs_qm_vop_chown(tp, ip,
> > -							&ip->i_gdquot, gdqp);
> > +							&ip->i_pdquot, pdqp);
> >  			}
> >  			xfs_set_projid(ip, fa->fsx_projid);
> >  
> > @@ -1160,13 +1160,13 @@ xfs_ioctl_setattr(
> >  	 */
> >  	xfs_qm_dqrele(olddquot);
> >  	xfs_qm_dqrele(udqp);
> > -	xfs_qm_dqrele(gdqp);
> > +	xfs_qm_dqrele(pdqp);
> >  
> >  	return code;
> >  
> >   error_return:
> >  	xfs_qm_dqrele(udqp);
> > -	xfs_qm_dqrele(gdqp);
> > +	xfs_qm_dqrele(pdqp);
> >  	xfs_trans_cancel(tp, 0);
> >  	if (lock_flags)
> >  		xfs_iunlock(ip, lock_flags);
> 
> Here in xfs_ioctl_setattr, I'm not clear on why we're messing with the user
> dquot at all.  Could it be removed entirely?  A change in project id doesn't
> effect user quota, right?
> 
> Maybe that's an idea for a separate patch.

I will look into that after these get in :)
> 
> >  STATIC void
> > -xfs_qm_dqattach_grouphint(
> > -	xfs_dquot_t	*udq,
> > -	xfs_dquot_t	*gdq)
> > +xfs_qm_dqattach_hint(
> > +	struct xfs_inode	*ip,
> > +	int			type)
> >  {
> > -	xfs_dquot_t	*tmp;
> > +	struct xfs_dquot **dqhint;
> 
> Maybe clearer as dqhintp.
> 
sure.
> > +	struct xfs_dquot *dqp;
> > +	struct xfs_dquot *udq = ip->i_udquot;
> >  
> >  	xfs_dqlock(udq);
> >  
> > -	tmp = udq->q_gdquot;
> > -	if (tmp) {
> > -		if (tmp == gdq)
> 
> If I understand this xfs_qm_dqattach_hint correctly, this might be nice:
> 
> 	ASSERT(type == XFS_DQ_GROUP || type == XFS_DQ_PROJ);

will do.

> 
> > diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> > index 2d02eac..72a4fdd 100644
> > --- a/fs/xfs/xfs_qm_bhv.c
> > +++ b/fs/xfs/xfs_qm_bhv.c
> > @@ -115,7 +115,7 @@ xfs_qm_newmount(
> >  	     (pquotaondisk && !XFS_IS_PQUOTA_ON(mp)) ||
> >  	    (!pquotaondisk &&  XFS_IS_PQUOTA_ON(mp)) ||
> >  	     (gquotaondisk && !XFS_IS_GQUOTA_ON(mp)) ||
> > -	    (!gquotaondisk &&  XFS_IS_OQUOTA_ON(mp)))  &&
> > +	    (!gquotaondisk &&  XFS_IS_GQUOTA_ON(mp)))  &&
> 
> These are not in the usual user/group/project order, and so are some other
> checks in this function.  Could be cleaned up.  Maybe a different patch too.
> 
I thought I fixed all of them around. Will fix this too.
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
