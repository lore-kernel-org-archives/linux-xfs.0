Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CC5C47F3F
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 20:23:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BC87C304066
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 18:23:53 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7KLvuX8mb6zUYR1Q for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 18:23:52 -0700 (PDT)
Date: Thu, 11 Jul 2013 11:23:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v10 08/11] xfs: Add pquota fields where gquota is used.
Message-ID: <20130711012335.GX3438@dastard>
References: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
	<1372371914-11370-9-git-send-email-sekharan@us.ibm.com>
	<20130710213907.GZ20932@sgi.com>
	<1373492798.6020.34.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373492798.6020.34.camel@chandra-dt.ibm.com>
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
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Wed, Jul 10, 2013 at 04:46:38PM -0500, Chandra Seetharaman wrote:
> > > @@ -1160,13 +1160,13 @@ xfs_ioctl_setattr(
> > >  	 */
> > >  	xfs_qm_dqrele(olddquot);
> > >  	xfs_qm_dqrele(udqp);
> > > -	xfs_qm_dqrele(gdqp);
> > > +	xfs_qm_dqrele(pdqp);
> > >  
> > >  	return code;
> > >  
> > >   error_return:
> > >  	xfs_qm_dqrele(udqp);
> > > -	xfs_qm_dqrele(gdqp);
> > > +	xfs_qm_dqrele(pdqp);
> > >  	xfs_trans_cancel(tp, 0);
> > >  	if (lock_flags)
> > >  		xfs_iunlock(ip, lock_flags);
> > 
> > Here in xfs_ioctl_setattr, I'm not clear on why we're messing with the user
> > dquot at all.  Could it be removed entirely?  A change in project id doesn't
> > effect user quota, right?
> > 
> > Maybe that's an idea for a separate patch.
> 
> I will look into that after these get in :)

The user dquot may have group and/or project dquot hints attached to
it. Therefore if we are changing project quota and user quotas are
enabled, then we may have to remove the hint from the user dquot
that points to the old project dquot....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
