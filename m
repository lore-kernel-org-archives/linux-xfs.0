Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4C4007F37
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 00:34:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A6EF304053
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 22:34:00 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ol5hxA7iLX1t4JNS for <xfs@oss.sgi.com>;
	Mon, 24 Jun 2013 22:33:58 -0700 (PDT)
Date: Tue, 25 Jun 2013 15:33:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v9 3/6] xfs: Add pquota fields where gquota is used.
Message-ID: <20130625053356.GT29376@dastard>
References: <1372042107-27332-1-git-send-email-sekharan@us.ibm.com>
	<1372042107-27332-4-git-send-email-sekharan@us.ibm.com>
	<20130624080000.GN29376@dastard>
	<1372116304.22504.92.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372116304.22504.92.camel@chandra-dt.ibm.com>
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

On Mon, Jun 24, 2013 at 06:25:04PM -0500, Chandra Seetharaman wrote:
> On Mon, 2013-06-24 at 18:00 +1000, Dave Chinner wrote:
> 
> <snip>
> > > @@ -559,8 +596,13 @@ xfs_qm_dqattach_locked(
> > >  		 * 100% all the time. It is just a hint, and this will
> > >  		 * succeed in general.
> > >  		 */
> > > -		if (ip->i_udquot->q_gdquot != ip->i_gdquot)
> > > -			xfs_qm_dqattach_grouphint(ip->i_udquot, ip->i_gdquot);
> > > +		if (XFS_IS_GQUOTA_ON(mp) &&
> > > +				ip->i_udquot->q_gdquot != ip->i_gdquot)
> > > +			xfs_qm_dqattach_hint(ip, XFS_DQ_GROUP);
> > > +
> > > +		if (XFS_IS_PQUOTA_ON(mp) &&
> > > +				ip->i_udquot->q_pdquot != ip->i_pdquot)
> > > +			xfs_qm_dqattach_hint(ip, XFS_DQ_PROJ);
> > 
> > Why do we need the XFS_IS_GQUOTA_ON/XFS_IS_PQUOTA_ON checks there?
> > If group quotas are not on, then both the hint and in the
> > inode pointers to the group dquot will be NULL, and therefore equal?
> > i.e. we don't need to even check if quotas are enabled here...
> > 
> > Indeed, why pass (ip, quota type) to xfs_qm_dqattach_hint()? why not
> > just pass the locations directly like:
> > 
> > 			xfs_qm_dqattach_hint(&ip->i_udquot->q_pdquot,
> > 					     ip->i_pdquot):
> > 
> 
> Just looked at xfs_qm_dqattach_hint(), it grabs the dqlock of
> ip->i_udquot, which means I have to have i_udquot also as another
> parameter.

Ah, it does too. Never mind, leave it as it is then. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
