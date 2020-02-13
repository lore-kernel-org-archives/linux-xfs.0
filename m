Return-Path: <SRS0=EAe2=4B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85616C352A4
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 01:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C34820724
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 01:53:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y5UAL0J2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgBMBxO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Feb 2020 20:53:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41508 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729333AbgBMBxN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Feb 2020 20:53:13 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01D1mTC5146645;
        Thu, 13 Feb 2020 01:53:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=NZW2I/pVH77oqbIXRFm69KGtvVTJ4NOdHPQkSDrc0js=;
 b=Y5UAL0J2M90aouvrDCjO6UArArxnw17JljnbAyKe0TRheP+l+EIU6rwqd0YkuBbu/nqI
 Fcy1JIIzJi5PwRUf5KsJZ9SAEBsb35AHdXQkrJhWT0ph7JMn2ZaQxYb3UFDIC4xSh1OA
 cd+cLUDl/R+cll71LigB3FaQnuLBfTr204lksteRMw9s9FnxNA3XUYW+TNxdN4vDRkXx
 VDjWJpdYL7XhijYvai8JXQQAYhvkFeJDXJVGMpChMCpYYFT1MWcfcJq7wjI61A+WXt1o
 TN0QNn/w1PqyvQdQl1hJ0r5At5xxJCp5LpJ5s5uw2F2kCWi7Csvbp+/nxCWoL+nN/Sk7 CA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2y2k88eppx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Feb 2020 01:53:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01D1rAY2165040;
        Thu, 13 Feb 2020 01:53:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2y4k33du6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 01:53:09 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01D1r6vw032147;
        Thu, 13 Feb 2020 01:53:06 GMT
Received: from localhost (/10.159.151.237)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Feb 2020 17:53:05 -0800
Date:   Wed, 12 Feb 2020 17:53:02 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/14] xfs: refactor default quota grace period setting
 code
Message-ID: <20200213015302.GZ6870@magnolia>
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <157784110016.1364230.5024129406313355261.stgit@magnolia>
 <2fde1e65-7ede-3c47-81bd-d39906a8dc77@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fde1e65-7ede-3c47-81bd-d39906a8dc77@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002130014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002130013
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 12, 2020 at 06:15:18PM -0600, Eric Sandeen wrote:
> On 12/31/19 7:11 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor the code that sets the default quota grace period into a helper
> > function so that we can override the ondisk behavior later.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_format.h |    8 ++++++++
> >  fs/xfs/xfs_ondisk.h        |    2 ++
> >  fs/xfs/xfs_qm_syscalls.c   |   35 +++++++++++++++++++++++------------
> >  fs/xfs/xfs_trans_dquot.c   |   16 ++++++++++++----
> >  4 files changed, 45 insertions(+), 16 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index 95761b38fe86..557db5e51eec 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -1188,6 +1188,10 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
> >   * time zero is the Unix epoch, Jan  1 00:00:01 UTC 1970.  An expiration value
> >   * of zero means that the quota limit has not been reached, and therefore no
> >   * expiration has been set.
> > + *
> > + * The length of quota grace periods are unsigned 32-bit quantities in units of
> > + * seconds (which are stored in the root dquot).  A value of zero means to use
> > + * the default period.
> 
> Doesn't a value of zero mean that the soft limit has not been exceeded, and no
> timer is in force?  And when soft limit is exceeded, the timer starts ticking
> based on the value in the root dquot?

Yes and yes.

> i.e. you can't set a custom per-user grace period, can you?

And yes.

> Perhaps:
> 
> * The length of quota grace periods are unsigned 32-bit quantities in units of
> * seconds.  The grace period for each quota type is stored in the root dquot
> * and is applied/transferred to a user quota when it exceeds a soft limit.

Much better.  I'll crib your version. :)

> >   */
> >  
> >  /*
> > @@ -1202,6 +1206,10 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
> >   */
> >  #define XFS_DQ_TIMEOUT_MAX	((int64_t)U32_MAX)
> >  
> > +/* Quota grace periods, ranging from zero (use the defaults) to ~136 years. */
> 
> same thing.  The default can be set between 0 and ~136 years, that gets transferred
> to any user who exceeds soft quota, and it counts down from there.

Yeah, I'll crib this too.

--D

> > +#define XFS_DQ_GRACE_MIN	((int64_t)0)
> > +#define XFS_DQ_GRACE_MAX	((int64_t)U32_MAX)
> > +
> >  /*
> >   * This is the main portion of the on-disk representation of quota
> >   * information for a user. This is the q_core of the struct xfs_dquot that
> > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > index 52dc5326b7bf..b8811f927a3c 100644
> > --- a/fs/xfs/xfs_ondisk.h
> > +++ b/fs/xfs/xfs_ondisk.h
> > @@ -27,6 +27,8 @@ xfs_check_ondisk_structs(void)
> >  	XFS_CHECK_VALUE(XFS_INO_TIME_MAX,			2147483647LL);
> >  	XFS_CHECK_VALUE(XFS_DQ_TIMEOUT_MIN,			1LL);
> >  	XFS_CHECK_VALUE(XFS_DQ_TIMEOUT_MAX,			4294967295LL);
> > +	XFS_CHECK_VALUE(XFS_DQ_GRACE_MIN,			0LL);
> > +	XFS_CHECK_VALUE(XFS_DQ_GRACE_MAX,			4294967295LL);
> 
> *cough* notondisk *cough*
> 
> >  
> >  	/* ag/file structures */
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_acl,			4);
> > diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> > index 74220948a360..20a6d304d1be 100644
> > --- a/fs/xfs/xfs_qm_syscalls.c
> > +++ b/fs/xfs/xfs_qm_syscalls.c
> > @@ -438,6 +438,20 @@ xfs_qm_scall_quotaon(
> >  	return 0;
> >  }
> >  
> > +/* Set a new quota grace period. */
> > +static inline void
> > +xfs_qm_set_grace(
> > +	time_t			*qi_limit,
>                                  ^ doesn't get used?
> > +	__be32			*dtimer,
> > +	const s64		grace)
> > +{
> > +	time64_t		new_grace;
> > +
> > +	new_grace = clamp_t(time64_t, grace, XFS_DQ_GRACE_MIN,
> > +					     XFS_DQ_GRACE_MAX);
> > +	*dtimer = cpu_to_be32(new_grace);
> 
> You've lost setting the qi_limit here (q->qi_btimelimit etc)
> 
> > +}
> > +
> >  #define XFS_QC_MASK \
> >  	(QC_LIMIT_MASK | QC_TIMER_MASK | QC_WARNS_MASK)
> >  
> > @@ -567,18 +581,15 @@ xfs_qm_scall_setqlim(
> >  		 * soft and hard limit values (already done, above), and
> >  		 * for warnings.
> >  		 */
> > -		if (newlim->d_fieldmask & QC_SPC_TIMER) {
> > -			q->qi_btimelimit = newlim->d_spc_timer;
> 
> i.e. qi_btimelimit never gets set now, which is what actually controls
> the timers when a uid/gid/pid goes over softlimit.
> 
> > -			ddq->d_btimer = cpu_to_be32(newlim->d_spc_timer);
> > -		}
> > -		if (newlim->d_fieldmask & QC_INO_TIMER) {
> > -			q->qi_itimelimit = newlim->d_ino_timer;
> > -			ddq->d_itimer = cpu_to_be32(newlim->d_ino_timer);
> > -		}
> > -		if (newlim->d_fieldmask & QC_RT_SPC_TIMER) {
> > -			q->qi_rtbtimelimit = newlim->d_rt_spc_timer;
> > -			ddq->d_rtbtimer = cpu_to_be32(newlim->d_rt_spc_timer);
> > -		}
> > +		if (newlim->d_fieldmask & QC_SPC_TIMER)
> > +			xfs_qm_set_grace(&q->qi_btimelimit, &ddq->d_btimer,
> > +					newlim->d_spc_timer);
> > +		if (newlim->d_fieldmask & QC_INO_TIMER)
> > +			xfs_qm_set_grace(&q->qi_itimelimit, &ddq->d_itimer,
> > +					newlim->d_ino_timer);
> > +		if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
> > +			xfs_qm_set_grace(&q->qi_rtbtimelimit, &ddq->d_rtbtimer,
> > +					newlim->d_rt_spc_timer);
> >  		if (newlim->d_fieldmask & QC_SPC_WARNS)
> >  			q->qi_bwarnlimit = newlim->d_spc_warns;
> >  		if (newlim->d_fieldmask & QC_INO_WARNS)
> > diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> > index 248cfc369efc..7a2a3bd11db9 100644
> > --- a/fs/xfs/xfs_trans_dquot.c
> > +++ b/fs/xfs/xfs_trans_dquot.c
> > @@ -563,6 +563,14 @@ xfs_quota_warn(
> >  			   mp->m_super->s_dev, type);
> >  }
> >  
> > +/* Has a quota grace period expired? */
> 
> seems like this is not part of "quota grace period setting code"
> - needs to be in a separate patch?

Yeah, it can be a separate refactor patch.


> > +static inline bool
> > +xfs_quota_timer_exceeded(
> > +	time64_t		timer)
> > +{
> > +	return timer != 0 && get_seconds() > timer;
> > +}
> > +
> >  /*
> >   * This reserves disk blocks and inodes against a dquot.
> >   * Flags indicate if the dquot is to be locked here and also
> > @@ -580,7 +588,7 @@ xfs_trans_dqresv(
> >  {
> >  	xfs_qcnt_t		hardlimit;
> >  	xfs_qcnt_t		softlimit;
> > -	time_t			timer;
> > +	time64_t		timer;
> 
> <this needs rebasing I guess, after b8a0880a37e2f43aa3bcd147182e95a4ebd82279>

Probably. :)

> >  	xfs_qwarncnt_t		warns;
> >  	xfs_qwarncnt_t		warnlimit;
> >  	xfs_qcnt_t		total_count;
> > @@ -635,7 +643,7 @@ xfs_trans_dqresv(
> >  				goto error_return;
> >  			}
> >  			if (softlimit && total_count > softlimit) {
> > -				if ((timer != 0 && get_seconds() > timer) ||
> > +				if (xfs_quota_timer_exceeded(timer) ||
> >  				    (warns != 0 && warns >= warnlimit)) {
> >  					xfs_quota_warn(mp, dqp,
> >  						       QUOTA_NL_BSOFTLONGWARN);
> > @@ -662,8 +670,8 @@ xfs_trans_dqresv(
> >  				goto error_return;
> >  			}
> >  			if (softlimit && total_count > softlimit) {
> > -				if  ((timer != 0 && get_seconds() > timer) ||
> > -				     (warns != 0 && warns >= warnlimit)) {
> > +				if (xfs_quota_timer_exceeded(timer) ||
> > +				    (warns != 0 && warns >= warnlimit)) {
> 
> TBH don't really see the point of this refactoring/helper, especially if not
> done for warns.  I think open coding is fine.

Yeah, in the end the helper doesn't add a lot anymore.  IIRC it did in
previous versions of this patch.

--D

> >  					xfs_quota_warn(mp, dqp,
> >  						       QUOTA_NL_ISOFTLONGWARN);
> >  					goto error_return;
> > 
