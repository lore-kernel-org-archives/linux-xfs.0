Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E10C17F54
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 23:05:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A22B2304077
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 21:05:38 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id mVN44jp1t6yEuo6r (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 21:05:37 -0700 (PDT)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 10 Jul 2013 22:05:33 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 2A9A019D8036
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 22:05:20 -0600 (MDT)
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r6B45UOg347180 for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 22:05:30 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r6B483YK001725
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 22:08:03 -0600
Subject: Re: [PATCH v10 08/11] xfs: Add pquota fields where gquota is used.
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130711012335.GX3438@dastard>
References: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
	<1372371914-11370-9-git-send-email-sekharan@us.ibm.com>
	<20130710213907.GZ20932@sgi.com>
	<1373492798.6020.34.camel@chandra-dt.ibm.com>
	<20130711012335.GX3438@dastard>
Date: Wed, 10 Jul 2013 23:05:26 -0500
Message-ID: <1373515526.4555.0.camel@chandra-laptop.ibm.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Thu, 2013-07-11 at 11:23 +1000, Dave Chinner wrote:
> On Wed, Jul 10, 2013 at 04:46:38PM -0500, Chandra Seetharaman wrote:
> > > > @@ -1160,13 +1160,13 @@ xfs_ioctl_setattr(
> > > >  	 */
> > > >  	xfs_qm_dqrele(olddquot);
> > > >  	xfs_qm_dqrele(udqp);
> > > > -	xfs_qm_dqrele(gdqp);
> > > > +	xfs_qm_dqrele(pdqp);
> > > >  
> > > >  	return code;
> > > >  
> > > >   error_return:
> > > >  	xfs_qm_dqrele(udqp);
> > > > -	xfs_qm_dqrele(gdqp);
> > > > +	xfs_qm_dqrele(pdqp);
> > > >  	xfs_trans_cancel(tp, 0);
> > > >  	if (lock_flags)
> > > >  		xfs_iunlock(ip, lock_flags);
> > > 
> > > Here in xfs_ioctl_setattr, I'm not clear on why we're messing with the user
> > > dquot at all.  Could it be removed entirely?  A change in project id doesn't
> > > effect user quota, right?
> > > 
> > > Maybe that's an idea for a separate patch.
> > 
> > I will look into that after these get in :)
> 
> The user dquot may have group and/or project dquot hints attached to
> it. Therefore if we are changing project quota and user quotas are
> enabled, then we may have to remove the hint from the user dquot
> that points to the old project dquot....

Thanks for the explanation Dave.
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
