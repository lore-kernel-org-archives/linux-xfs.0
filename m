Return-Path: <SRS0=EAe2=4B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B22C352A4
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 01:46:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E55A520659
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 01:46:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XDXyiU5R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729302AbgBMBqV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Feb 2020 20:46:21 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:33488 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729289AbgBMBqV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Feb 2020 20:46:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01D1e69w003648;
        Thu, 13 Feb 2020 01:46:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=jDYQ3r+yg71cVOFX29rh+olnSmOcZT1u6/CRte5jTs4=;
 b=XDXyiU5RirMS5YTpAG91b5P00W5zhcvjYW6x4VPpmIG2JyWQqmZ+cRrvex+ESR7DZC6D
 mBNxBR82au7I9tkJaq0JVm8v5S3agAySZrnDyNhafOHPPapl1kWJK3biCUKUbke/78yA
 T0JUvj8Hd6YWxZP6FeOSWfc2jD43As/dT6KMJ0VQl/zJm4BgJSUjyvNDpNuWzzv6Frbt
 Mn6uhBk1/ypfb7WmUOvug9BUeF7ncqsEnJFTcQuttHVxZgvyUIJ18d8auO4JppcGnTWI
 mTop3tLG213IEl0SGk/CS3al1pdrCM6oVK9BZ/yILAwNvIAzOxXT/YzPmgjBEQGUwJB/ rQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2y2p3spenq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Feb 2020 01:46:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01D1bXLp140262;
        Thu, 13 Feb 2020 01:46:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2y4kahafgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 01:46:18 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01D1kHRK029512;
        Thu, 13 Feb 2020 01:46:18 GMT
Received: from localhost (/10.159.151.237)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Feb 2020 17:46:17 -0800
Date:   Wed, 12 Feb 2020 17:46:14 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/14] xfs: refactor quota expiration timer modification
Message-ID: <20200213014614.GY6870@magnolia>
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <157784109369.1364230.637677553755124721.stgit@magnolia>
 <455264c4-435c-c2f7-4e2a-3f4614574050@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <455264c4-435c-c2f7-4e2a-3f4614574050@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002130012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002130012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 12, 2020 at 05:57:24PM -0600, Eric Sandeen wrote:
> On 12/31/19 7:11 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Define explicit limits on the range of quota grace period expiration
> > timeouts and refactor the code that modifies the timeouts into helpers
> > that clamp the values appropriately.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> ...
> 
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index ae7bb6361a99..44bae5f16b55 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -113,6 +113,36 @@ xfs_quota_exceeded(
> >  	return *hardlimit && count > be64_to_cpup(hardlimit);
> >  }
> >  
> > +/*
> > + * Clamp a quota grace period expiration timer to the range that we support.
> > + */
> > +static inline time64_t
> > +xfs_dquot_clamp_timer(
> > +	time64_t			timer)
> > +{
> > +	return clamp_t(time64_t, timer, XFS_DQ_TIMEOUT_MIN, XFS_DQ_TIMEOUT_MAX);
> > +}
> > +
> > +/* Set a quota grace period expiration timer. */
> > +static inline void
> > +xfs_quota_set_timer(
> > +	__be32			*dtimer,
> > +	time_t			limit)
> > +{
> > +	time64_t		new_timeout;
> > +
> > +	new_timeout = xfs_dquot_clamp_timer(get_seconds() + limit);
> > +	*dtimer = cpu_to_be32(new_timeout);
> > +}
> > +
> > +/* Clear a quota grace period expiration timer. */
> > +static inline void
> > +xfs_quota_clear_timer(
> > +	__be32			*dtimer)
> > +{
> > +	*dtimer = cpu_to_be32(0);
> 
> do we need to endian convert 0 to make sparse happy?  I don't see us doing
> that anywhere else.  TBH not really sure I see the reason for the function
> at all unless you really, really like the symmetry.
> 
> > +}
> > +
> >  /*
> >   * Check the limits and timers of a dquot and start or reset timers
> >   * if necessary.
> > @@ -152,14 +182,14 @@ xfs_qm_adjust_dqtimers(
> >  			&d->d_blk_softlimit, &d->d_blk_hardlimit);
> >  	if (!d->d_btimer) {
> >  		if (over) {
> > -			d->d_btimer = cpu_to_be32(get_seconds() +
> > +			xfs_quota_set_timer(&d->d_btimer,
> >  					mp->m_quotainfo->qi_btimelimit);
> >  		} else {
> >  			d->d_bwarns = 0;
> >  		}
> >  	} else {
> >  		if (!over) {
> > -			d->d_btimer = 0;
> > +			xfs_quota_clear_timer(&d->d_btimer);
> 
> yeah that's a very fancy way to say "= 0" ;)
> 
> ...

Yes, that's a fancy way to assign zero.  However, consider that for
bigtime support, I had to add an incore quota timer so that timers more
or less fire when they're supposed to, and now there's a function to
convert the incore timespec64 value to whatever is ondisk:

/* Clear a quota grace period expiration timer. */
static inline void
xfs_quota_clear_timer(
	struct xfs_disk_dquot	*ddq,
	time64_t		*itimer,
	__be32			*dtimer)
{
	struct timespec64	tv = { 0 };

	*itimer = tv.tv_sec;
	xfs_dquot_to_disk_timestamp(ddq, dtimer, &tv);
}

It was at *that* point in the patchset that it seemed easier to call a
small function three times than to open-code this three times.

> > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > index f67f3645efcd..52dc5326b7bf 100644
> > --- a/fs/xfs/xfs_ondisk.h
> > +++ b/fs/xfs/xfs_ondisk.h
> > @@ -25,6 +25,8 @@ xfs_check_ondisk_structs(void)
> >  	/* make sure timestamp limits are correct */
> >  	XFS_CHECK_VALUE(XFS_INO_TIME_MIN, 			-2147483648LL);
> >  	XFS_CHECK_VALUE(XFS_INO_TIME_MAX,			2147483647LL);
> > +	XFS_CHECK_VALUE(XFS_DQ_TIMEOUT_MIN,			1LL);
> > +	XFS_CHECK_VALUE(XFS_DQ_TIMEOUT_MAX,			4294967295LL);
> 
> again grumble grumble really not checking an ondisk structure.

Same answer as before. :)

--D

> >  	/* ag/file structures */
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_acl,			4);
> > 
