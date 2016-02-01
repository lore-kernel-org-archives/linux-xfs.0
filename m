Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 720297CA3
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 03:57:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5EC4E304043
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 01:57:12 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id X3uqk0SrY35vlu5P (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 01 Feb 2016 01:57:11 -0800 (PST)
Date: Mon, 1 Feb 2016 10:57:07 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: Split default quota limits by quota type V3
Message-ID: <20160201095707.GB8141@redhat.com>
References: <1454000266-22541-1-git-send-email-cmaiolino@redhat.com>
	<56AA51B7.7030403@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56AA51B7.7030403@sandeen.net>
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

On Thu, Jan 28, 2016 at 11:36:55AM -0600, Eric Sandeen wrote:
> On 1/28/16 10:57 AM, Carlos Maiolino wrote:
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
> > timer, but a single global timer. For changing this behavior, some changes
> > should be made in user-space tools another bugs being fixed.
> 
> Some minor comments about comments below.  But the code looks fine to me,
> so:
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> and if you want to fix the comments & resend w/ my review tag I think that'd
> be ok.
> 
> Care to write an xfstests testcase for the default quota limit while you're
> at it?
> 
> Thanks,
> -Eric
> 
> > Changelog:
> > 
> > 	V2 - Remove comment about old behavior
> > 	V3 - Keep time limit configuration inside xfs_qm_init_quotainfo to keep
> > 	     the current behavior of quota timers
> > 
> > +	 *
> > +	 * Timers and warnings are globally set by the first timer found in
> > +	 * user/group/proj quota types, otherwise a default value is used.
> > +	 * This should be splitted into different fields per quota type.
> 
> s/splitted/split/
> 
> >  	 */
> >  	error = xfs_qm_dqread(mp, 0,
> >  			XFS_IS_UQUOTA_RUNNING(mp) ? XFS_DQ_USER :
> >  			 (XFS_IS_GQUOTA_RUNNING(mp) ? XFS_DQ_GROUP :
> >  			  XFS_DQ_PROJ),
> >  			XFS_QMOPT_DOWARN, &dqp);
> > +
> >  	if (!error) {
> >  		xfs_disk_dquot_t	*ddqp = &dqp->q_core;
> >  
> > -		/*
> > -		 * The warnings and timers set the grace period given to
> > -		 * a user or group before he or she can not perform any
> > -		 * more writing. If it is zero, a default is used.
> > -		 */
> 
> Not sure why you removed this comment?
> 
Regarding this comment, I think it's just redundant with the previous comment, I
left it in the code for the V4 though, I believe Dave can rip it off if it is
really redundant.

Cheers

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
