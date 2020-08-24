Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9962C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 02:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2D39206F7
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 02:34:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LgR5ov3a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgHXCe4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Aug 2020 22:34:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38616 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgHXCe4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Aug 2020 22:34:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07O2TCAV091210;
        Mon, 24 Aug 2020 02:34:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=RJtiDy0N3a9M1DXNgnH3a++r8ZsS7NsWfSLD6jEUTwM=;
 b=LgR5ov3a8EAVEfWo8TGlzxdk2n/8nDXUwKTwozMfT1zu/B7+QExvLuVwkJ/+FKLko1Hp
 FdPkghZ9oLNME4ZpuMO3yRdqfnvtFb/dHWusiK3TXv3dqF5zfLCmh4vXwGueDqdFXSJ2
 D6ZvN8e0SnnR799HBls4Rr6ti76veKMwu6UTJgn21sUMvUAbo7PIUJsKDhKcOp8VVC1P
 riXrjFN5oHzjiur6AZ5B6v9BRSY3aMQ88u0Anf1HT8Y54HNAJhPNToBpTrjUYwKz3io5
 vkKH6gG1vFoXcJUEyofnTyn5g6NgIZSXjmQkMIPthk6tHL+muMctf3GmCxomYY4Wx7fQ MQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 333w6tgkdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Aug 2020 02:34:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07O2YTaF118861;
        Mon, 24 Aug 2020 02:34:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 333rtvvah8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Aug 2020 02:34:49 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07O2Ym4d004012;
        Mon, 24 Aug 2020 02:34:48 GMT
Received: from localhost (/10.159.140.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Aug 2020 19:34:48 -0700
Date:   Sun, 23 Aug 2020 19:34:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 02/11] xfs: refactor quota expiration timer modification
Message-ID: <20200824023447.GP6096@magnolia>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797590052.965217.10856208107922013686.stgit@magnolia>
 <20200823235737.GK7941@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200823235737.GK7941@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9722 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9722 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=1 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008240008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 24, 2020 at 09:57:37AM +1000, Dave Chinner wrote:
> On Thu, Aug 20, 2020 at 07:11:40PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Define explicit limits on the range of quota grace period expiration
> > timeouts and refactor the code that modifies the timeouts into helpers
> > that clamp the values appropriately.  Note that we'll deal with the
> > grace period timer separately.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_format.h |   22 ++++++++++++++++++++++
> >  fs/xfs/xfs_dquot.c         |   13 ++++++++++++-
> >  fs/xfs/xfs_dquot.h         |    2 ++
> >  fs/xfs/xfs_ondisk.h        |    2 ++
> >  fs/xfs/xfs_qm_syscalls.c   |    9 +++++++--
> >  5 files changed, 45 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index b1b8a5c05cea..ef36978239ac 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -1197,6 +1197,28 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
> >  
> >  #define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK)
> >  
> > +/*
> > + * XFS Quota Timers
> > + * ================
> > + *
> > + * Quota grace period expiration timers are an unsigned 32-bit seconds counter;
> > + * time zero is the Unix epoch, Jan  1 00:00:01 UTC 1970.  An expiration value
> > + * of zero means that the quota limit has not been reached, and therefore no
> > + * expiration has been set.
> > + */
> > +
> > +/*
> > + * Smallest possible quota expiration with traditional timestamps, which is
> > + * Jan  1 00:00:01 UTC 1970.
> > + */
> > +#define XFS_DQ_TIMEOUT_MIN	((int64_t)1)
> > +
> > +/*
> > + * Largest possible quota expiration with traditional timestamps, which is
> > + * Feb  7 06:28:15 UTC 2106.
> > + */
> > +#define XFS_DQ_TIMEOUT_MAX	((int64_t)U32_MAX)
> 
> Same as last patch - these reference the unix epoch, so perhaps
> they should be named that way....
> 
> >   * This is the main portion of the on-disk representation of quota information
> >   * for a user.  We pad this with some more expansion room to construct the on
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index bcd73b9c2994..2425b1c30d11 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -98,6 +98,16 @@ xfs_qm_adjust_dqlimits(
> >  		xfs_dquot_set_prealloc_limits(dq);
> >  }
> >  
> > +/* Set the expiration time of a quota's grace period. */
> > +void
> > +xfs_dquot_set_timeout(
> > +	time64_t		*timer,
> > +	time64_t		value)
> > +{
> > +	*timer = clamp_t(time64_t, value, XFS_DQ_TIMEOUT_MIN,
> > +					  XFS_DQ_TIMEOUT_MAX);
> > +}
> > +
> 
> Not sure I see any benefit in passing *timer as a parameter over
> just returning a time64_t value...

I'll look into changing them, both for this and the next patch.
I /think/ it should be fairly straightforward.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
