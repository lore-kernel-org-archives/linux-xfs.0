Return-Path: <SRS0=cy20=AN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E559DC433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 00:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B77EC2077D
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 00:09:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OE7l6Jw+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgGBAJT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 20:09:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39084 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbgGBAJT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 20:09:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06207O8s089334;
        Thu, 2 Jul 2020 00:09:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=OCwHGe2QcayAllu0Xj3/Bv0+NRRWvDeDGS8kn20oIVY=;
 b=OE7l6Jw+5L5NsPq87ajJC9TqCLPDtpP5QThg1Lh9zqFB2LyQEECTAxbQ2Nj4GTiVy8+o
 /eSQB3ybEMENhOA72YKv3Oa0WFYe4ui3JoZrWqS9Sbi5+gLSqIjvKY0mIsCu93pFQwBx
 Tb8H5vinxlMSQgT9gIuGKzb7Npk1C9pWVvpIoO2geqH+kuMVPF6T09+iCHtkjLd1URrg
 yVMTXUgLxK2Buya8WOLofRmXOq6huZNP6zBufQX3dOrwSo8cuI0WSZVNwonXOvsmTpFk
 UCRwmo9oWTOQkxz0aemIugjOrZsKvIhYCw40UeVIkSi1nxogzu1R0MaIZreBtA95ib+G hQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31ywrbupdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 00:09:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06202ddH148136;
        Thu, 2 Jul 2020 00:07:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 31xfvupbrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 00:07:15 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06207EXT022127;
        Thu, 2 Jul 2020 00:07:15 GMT
Received: from localhost (/10.159.237.139)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 00:07:14 +0000
Date:   Wed, 1 Jul 2020 17:07:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/18] xfs: refactor default quota limits by resource
Message-ID: <20200702000713.GZ7606@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353178739.2864738.11605071453935920102.stgit@magnolia>
 <20200701233001.GD2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701233001.GD2005@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=1 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007010166
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 02, 2020 at 09:30:01AM +1000, Dave Chinner wrote:
> On Tue, Jun 30, 2020 at 08:43:07AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Now that we've split up the dquot resource fields into separate structs,
> > do the same for the default limits to enable further refactoring.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_dquot.c       |   30 +++++++++++++++---------------
> >  fs/xfs/xfs_qm.c          |   36 ++++++++++++++++++------------------
> >  fs/xfs/xfs_qm.h          |   22 ++++++++++------------
> >  fs/xfs/xfs_qm_syscalls.c |   24 ++++++++++++------------
> >  fs/xfs/xfs_quotaops.c    |   12 ++++++------
> >  fs/xfs/xfs_trans_dquot.c |   18 +++++++++---------
> >  6 files changed, 70 insertions(+), 72 deletions(-)
> 
> A few things here, starting with the "defq" naming. These are
> quota limits, not "default quotas". I'd suggest taht this whole
> set of structures need to be renamed as "quota limits". e.g
> 
> struct xfs_quota_limits {
> 	xfs_qcnt_t		hard;	/* default hard limit */
> 	xfs_qcnt_t		soft;	/* default soft limit */
> 	time64_t		time;	/* limit for timers */
> 	xfs_qwarncnt_t		warn;	/* limit for warnings */

Ahaha, much better naming.  Thank you!

> };
> 
> Then we have
> 
> 	qlim = xfs_qm_get_default_limits(q, xfs_dquot_type(dq));
> > 
> > 
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index 2d6b50760962..6975c27145fc 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -76,22 +76,22 @@ xfs_qm_adjust_dqlimits(
> >  	ASSERT(dq->q_id);
> >  	defq = xfs_get_defquota(q, xfs_dquot_type(dq));
> >  
> > -	if (defq->bsoftlimit && !dq->q_blk.softlimit) {
> > -		dq->q_blk.softlimit = defq->bsoftlimit;
> > +	if (defq->dfq_blk.softlimit && !dq->q_blk.softlimit) {
> > +		dq->q_blk.softlimit = defq->dfq_blk.softlimit;
> >  		prealloc = 1;
> >  	}
> > -	if (defq->bhardlimit && !dq->q_blk.hardlimit) {
> > -		dq->q_blk.hardlimit = defq->bhardlimit;
> > +	if (defq->dfq_blk.hardlimit && !dq->q_blk.hardlimit) {
> > +		dq->q_blk.hardlimit = defq->dfq_blk.hardlimit;
> >  		prealloc = 1;
> >  	}
> > -	if (defq->isoftlimit && !dq->q_ino.softlimit)
> > -		dq->q_ino.softlimit = defq->isoftlimit;
> > -	if (defq->ihardlimit && !dq->q_ino.hardlimit)
> > -		dq->q_ino.hardlimit = defq->ihardlimit;
> > -	if (defq->rtbsoftlimit && !dq->q_rtb.softlimit)
> > -		dq->q_rtb.softlimit = defq->rtbsoftlimit;
> > -	if (defq->rtbhardlimit && !dq->q_rtb.hardlimit)
> > -		dq->q_rtb.hardlimit = defq->rtbhardlimit;
> > +	if (defq->dfq_ino.softlimit && !dq->q_ino.softlimit)
> > +		dq->q_ino.softlimit = defq->dfq_ino.softlimit;
> > +	if (defq->dfq_ino.hardlimit && !dq->q_ino.hardlimit)
> > +		dq->q_ino.hardlimit = defq->dfq_ino.hardlimit;
> > +	if (defq->dfq_rtb.softlimit && !dq->q_rtb.softlimit)
> > +		dq->q_rtb.softlimit = defq->dfq_rtb.softlimit;
> > +	if (defq->dfq_rtb.hardlimit && !dq->q_rtb.hardlimit)
> > +		dq->q_rtb.hardlimit = defq->dfq_rtb.hardlimit;
> 
> And all this turns into somthing much easier to read:
> 
> ....
> 	if (qlim->ino.soft && !dq->q_ino.softlimit)
> 		dq->q_ino.softlimit = qlim->ino.soft;
> 	if (qlim->ino.hard && !dq->q_ino.hardlimit)
> 		dq->q_ino.hardlimit = qlim->ino.hard;
> ....

<nod> Will do.

> I'll also suggest we don't need to check qlim values here. It could
> just be:
> 
> 	if (!dq->q_ino.softlimit)
> 		dq->q_ino.softlimit = qlim->ino.soft;
> 	if (!dq->q_ino.hardlimit)
> 		dq->q_ino.hardlimit = qlim->ino.hard;

Separate patch, but yes, I don't think we really need to check that the
defaults are set, because (afaict) xfs_qm_set_defquota always sets them
to something nowadays, even if that something is a zero limit in the root
dquot.

> 
> > @@ -41,20 +41,18 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
> >   */
> >  #define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
> >  
> > +struct xfs_def_qres {
> > +	xfs_qcnt_t		hardlimit;	/* default hard limit */
> > +	xfs_qcnt_t		softlimit;	/* default soft limit */
> > +	time64_t		timelimit;	/* limit for timers */
> > +	xfs_qwarncnt_t		warnlimit;	/* limit for warnings */
> > +};
> 
> As I implied above, this is a quota limits structure, not a "default
> quota" structure. I'm not sure what the "res" in the name means,
> either...

default quota resource limit, but xfs_quota_limits fits the bill
nicely.

> > +
> >  /* Defaults for each quota type: time limits, warn limits, usage limits */
> >  struct xfs_def_quota {
> > -	time64_t	btimelimit;	/* limit for blks timer */
> > -	time64_t	itimelimit;	/* limit for inodes timer */
> > -	time64_t	rtbtimelimit;	/* limit for rt blks timer */
> > -	xfs_qwarncnt_t	bwarnlimit;	/* limit for blks warnings */
> > -	xfs_qwarncnt_t	iwarnlimit;	/* limit for inodes warnings */
> > -	xfs_qwarncnt_t	rtbwarnlimit;	/* limit for rt blks warnings */
> > -	xfs_qcnt_t	bhardlimit;	/* default data blk hard limit */
> > -	xfs_qcnt_t	bsoftlimit;	/* default data blk soft limit */
> > -	xfs_qcnt_t	ihardlimit;	/* default inode count hard limit */
> > -	xfs_qcnt_t	isoftlimit;	/* default inode count soft limit */
> > -	xfs_qcnt_t	rtbhardlimit;	/* default realtime blk hard limit */
> > -	xfs_qcnt_t	rtbsoftlimit;	/* default realtime blk soft limit */
> > +	struct xfs_def_qres	dfq_blk;
> > +	struct xfs_def_qres	dfq_ino;
> > +	struct xfs_def_qres	dfq_rtb;
> >  };
> 
> The namespacing of these variables adds no value. It just makes the
> code more verbose and harder to read. e.g.
> 
> > diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> > index 1b2b70b1660f..393b88612cc8 100644
> > --- a/fs/xfs/xfs_qm_syscalls.c
> > +++ b/fs/xfs/xfs_qm_syscalls.c
> > @@ -502,8 +502,8 @@ xfs_qm_scall_setqlim(
> >  		dqp->q_blk.softlimit = soft;
> >  		xfs_dquot_set_prealloc_limits(dqp);
> >  		if (id == 0) {
> > -			defq->bhardlimit = hard;
> > -			defq->bsoftlimit = soft;
> > +			defq->dfq_blk.hardlimit = hard;
> > +			defq->dfq_blk.softlimit = soft;
> 
> IMO, these sorts of changes decrease the reability of the code. I'd
> much prefer something like:
> 
>  		if (id == 0) {
> -			defq->bhardlimit = hard;
> -			defq->bsoftlimit = soft;
> +			qlim->blk.hard = hard;
> +			qlim->blk.soft = soft;
> 
> As it is still clear we are changing the hard block quota limits...

<nod> Done.  Thanks for slogging through this growing patchset...

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
