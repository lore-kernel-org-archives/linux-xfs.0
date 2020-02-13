Return-Path: <SRS0=EAe2=4B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 454C6C352A3
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 05:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 155CB2173E
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 05:33:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JFnDcTd+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgBMFdZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 00:33:25 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51210 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgBMFdZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Feb 2020 00:33:25 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01D5XLq0189077;
        Thu, 13 Feb 2020 05:33:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=xw5BN9RREHiY+U9JYDI9LIUgMyu9SDAVyfKomBIekuU=;
 b=JFnDcTd+usGQnhnlnkV8UXeYRU2IX57//ryyXUuTRqnK4qGLctuTd1hAqPYAht9eUIbA
 PjRICTmZ5P6a+WR4po1T7fXTGihq6bLxTS7rughG8L9ZQ9llpwvavhD66R03ArdWmVV2
 pbkp9gX65ZzK1rntAX0ES/e/Q1ghOldlotRghveYgKzkl0Fq3hsc6OMOt5OvMuVFwEsK
 NATXTiOOLMqkROnAAZ6KaBTGLynI7z2E/74jmWGCKe3HKCBPShat+VQ0tDMVBR9DYj+X
 zauXLsVquy0EWnMOUxy4KWkrPeA77HVVFnE6fDKijz1I6ds0Eek+ZMHalAx20cGRfojC WQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2y2p3sq444-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Feb 2020 05:33:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01D5XLWA133258;
        Thu, 13 Feb 2020 05:33:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2y4kahmhwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 05:33:21 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01D5XJeE030305;
        Thu, 13 Feb 2020 05:33:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Feb 2020 21:33:19 -0800
Date:   Wed, 12 Feb 2020 21:33:18 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/14] xfs: refactor quota expiration timer modification
Message-ID: <20200213053318.GR6874@magnolia>
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <157784109369.1364230.637677553755124721.stgit@magnolia>
 <455264c4-435c-c2f7-4e2a-3f4614574050@sandeen.net>
 <20200213014614.GY6870@magnolia>
 <30ee43c7-543f-6dd7-f68c-bdd5fe01c19b@sandeen.net>
 <e8d6702c-9e39-6e5e-e910-739b9b4558a3@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8d6702c-9e39-6e5e-e910-739b9b4558a3@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002130044
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002130044
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 12, 2020 at 09:32:33PM -0600, Eric Sandeen wrote:
> 
> 
> On 2/12/20 9:27 PM, Eric Sandeen wrote:
> > On 2/12/20 7:46 PM, Darrick J. Wong wrote:
> >> On Wed, Feb 12, 2020 at 05:57:24PM -0600, Eric Sandeen wrote:
> >>> On 12/31/19 7:11 PM, Darrick J. Wong wrote:
> >>>> From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > ...
> > 
> >>>>  	} else {
> >>>>  		if (!over) {
> >>>> -			d->d_btimer = 0;
> >>>> +			xfs_quota_clear_timer(&d->d_btimer);
> >>>
> >>> yeah that's a very fancy way to say "= 0" ;)
> >>>
> >>> ...
> >>
> >> Yes, that's a fancy way to assign zero.  However, consider that for
> >> bigtime support, I had to add an incore quota timer so that timers more
> >> or less fire when they're supposed to, and now there's a function to
> >> convert the incore timespec64 value to whatever is ondisk:
> >>
> >> /* Clear a quota grace period expiration timer. */
> >> static inline void
> >> xfs_quota_clear_timer(
> >> 	struct xfs_disk_dquot	*ddq,
> >> 	time64_t		*itimer,
> >> 	__be32			*dtimer)
> >> {
> >> 	struct timespec64	tv = { 0 };
> >>
> >> 	*itimer = tv.tv_sec;
> >> 	xfs_dquot_to_disk_timestamp(ddq, dtimer, &tv);
> >> }
> >>
> >> It was at *that* point in the patchset that it seemed easier to call a
> >> small function three times than to open-code this three times.
> > 
> > +void
> > +xfs_dquot_to_disk_timestamp(
> > +	__be32			*dtimer,
> > +	const struct timespec64	*tv)
> > +{
> > +	*dtimer = cpu_to_be32(tv->tv_sec);
> > +}
> > 
> >  static inline void
> >  xfs_quota_clear_timer(
> > +	time64_t		*itimer,
> >  	__be32			*dtimer)
> >  {
> > -	*dtimer = cpu_to_be32(0);
> > +	struct timespec64	tv = { 0 };
> > +
> > +	*itimer = tv.tv_sec;
> > +	xfs_dquot_to_disk_timestamp(dtimer, &tv);
> >  } 
> > 
> > xfs_quota_clear_timer(&dqp->q_btimer, &d->d_btimer);
> > 
> > That's still a very fancy way of saying:
> > 
> >         dqp->q_btimer = d->d_btimer = 0;
> > 
> > I think?  Can't really see what value the timespec64 adds here.
> > 
> > -Eric
> > 
> 
> Actually,
> 
>  xfs_quota_set_timer(
> +	time64_t		*itimer,
>  	__be32			*dtimer,
>  	time_t			limit)
>  {
> -	time64_t		new_timeout;
> +	struct timespec64	tv = { 0 };
>  
> -	new_timeout = xfs_dquot_clamp_timer(get_seconds() + limit);
> -	*dtimer = cpu_to_be32(new_timeout);
> +	tv.tv_sec = xfs_dquot_clamp_timer(ktime_get_real_seconds() + limit);
> +	*itimer = tv.tv_sec;
> +	xfs_dquot_to_disk_timestamp(dtimer, &tv);
>  }
> 
> I'm not sure why there's a timespec64 here either.  Isn't everything
> we're dealing with on timers in seconds, using only tv_sec, and time64_t would
> suffice instead of using a timespec64 just to carry around a seconds value?

Yes, the grace periods recorded in the timer fields in dquot 0 are
intervals measured in seconds.

However, for dquot != 0, the timer fields store the time of the
expiration, so I settled on timespec64 as the incore structure so that
XFS consistently uses struct timespec64 to represent specific points in
time.

(That and time64_t doesn't exist in userspace.)

--D

> -Eric
