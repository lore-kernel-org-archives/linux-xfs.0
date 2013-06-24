Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7122A7F37
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 18:25:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3E6E08F8035
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 16:25:40 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id KmaxGBvN0HXiCPI1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Jun 2013 16:25:39 -0700 (PDT)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 24 Jun 2013 17:25:39 -0600
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 4D9FE6E8047
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 19:25:32 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5ONP65C270190 for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 19:25:06 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r5ONP6tQ024064 for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 20:25:06 -0300
Subject: Re: [PATCH v9 3/6] xfs: Add pquota fields where gquota is used.
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130624080000.GN29376@dastard>
References: <1372042107-27332-1-git-send-email-sekharan@us.ibm.com>
	<1372042107-27332-4-git-send-email-sekharan@us.ibm.com>
	<20130624080000.GN29376@dastard>
Date: Mon, 24 Jun 2013 18:25:04 -0500
Message-ID: <1372116304.22504.92.camel@chandra-dt.ibm.com>
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
Cc: xfs@oss.sgi.com

On Mon, 2013-06-24 at 18:00 +1000, Dave Chinner wrote:

<snip>
> > @@ -559,8 +596,13 @@ xfs_qm_dqattach_locked(
> >  		 * 100% all the time. It is just a hint, and this will
> >  		 * succeed in general.
> >  		 */
> > -		if (ip->i_udquot->q_gdquot != ip->i_gdquot)
> > -			xfs_qm_dqattach_grouphint(ip->i_udquot, ip->i_gdquot);
> > +		if (XFS_IS_GQUOTA_ON(mp) &&
> > +				ip->i_udquot->q_gdquot != ip->i_gdquot)
> > +			xfs_qm_dqattach_hint(ip, XFS_DQ_GROUP);
> > +
> > +		if (XFS_IS_PQUOTA_ON(mp) &&
> > +				ip->i_udquot->q_pdquot != ip->i_pdquot)
> > +			xfs_qm_dqattach_hint(ip, XFS_DQ_PROJ);
> 
> Why do we need the XFS_IS_GQUOTA_ON/XFS_IS_PQUOTA_ON checks there?
> If group quotas are not on, then both the hint and in the
> inode pointers to the group dquot will be NULL, and therefore equal?
> i.e. we don't need to even check if quotas are enabled here...
> 
> Indeed, why pass (ip, quota type) to xfs_qm_dqattach_hint()? why not
> just pass the locations directly like:
> 
> 			xfs_qm_dqattach_hint(&ip->i_udquot->q_pdquot,
> 					     ip->i_pdquot):
> 

Just looked at xfs_qm_dqattach_hint(), it grabs the dqlock of
ip->i_udquot, which means I have to have i_udquot also as another
parameter.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
