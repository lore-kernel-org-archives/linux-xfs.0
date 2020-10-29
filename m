Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5F91C4363A
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 17:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DA4720704
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 17:32:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E5ujJMYn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgJ2Rco (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 13:32:44 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38646 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbgJ2Rcn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 13:32:43 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09THPTmS189916;
        Thu, 29 Oct 2020 17:32:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=aVTTdDqWAfLBW+wUu9axjUdzFWnWpnZdHME61ijBP6k=;
 b=E5ujJMYnpIpgiMJxAyIGF7LrRpAxNaaGxCsLXpi1pJrK2Ud/04vQX+LBo+cono9WfSfH
 ZF28jsaO6It4W1L6H+BvJ/EhvcBwNab8sa1OFcSy/U0hvyXWkWbLhSwxENe0y9dvXe8X
 EO4tTxcx8okkVxxDoWXubMil0Eb30mVNZFGSCotlykfvrWgSa/TeGdKdVJWv6mquP6/V
 JYib6o4lfO1CjHCocS2qVhnF08yo2PUSRDlnpbCIAukD07P84td7U1JDX91bq/6IsuwO
 PUkfHPJulYWirNISGjkAZoeY6vzqakxQCFz/8/iZppHDM6ODFIJm3QDOCeqQAFAv9qhF eg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34c9sb69m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 17:32:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09THUYw1084875;
        Thu, 29 Oct 2020 17:32:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34cwuq1tkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 17:32:38 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09THWa8K018840;
        Thu, 29 Oct 2020 17:32:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 10:32:35 -0700
Date:   Thu, 29 Oct 2020 10:32:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/26] xfs_quota: convert time_to_string to use time64_t
Message-ID: <20201029173234.GE1061260@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375527834.881414.2581158648212089750.stgit@magnolia>
 <20201029094712.GI2091@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029094712.GI2091@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290121
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 09:47:12AM +0000, Christoph Hellwig wrote:
> On Mon, Oct 26, 2020 at 04:34:38PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Rework the time_to_string helper to be capable of dealing with 64-bit
> > timestamps.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  quota/quota.c  |   16 ++++++++++------
> >  quota/quota.h  |    2 +-
> >  quota/report.c |   16 ++++++++++------
> >  quota/util.c   |    5 +++--
> >  4 files changed, 24 insertions(+), 15 deletions(-)
> > 
> > 
> > diff --git a/quota/quota.c b/quota/quota.c
> > index 9545cc430a93..8ba0995d9174 100644
> > --- a/quota/quota.c
> > +++ b/quota/quota.c
> > @@ -48,6 +48,7 @@ quota_mount(
> >  	uint		flags)
> >  {
> >  	fs_disk_quota_t	d;
> > +	time64_t	timer;
> >  	char		*dev = mount->fs_name;
> >  	char		c[8], h[8], s[8];
> >  	uint		qflags;
> > @@ -100,6 +101,7 @@ quota_mount(
> >  	}
> >  
> >  	if (form & XFS_BLOCK_QUOTA) {
> > +		timer = d.d_btimer;
> >  		qflags = (flags & HUMAN_FLAG);
> >  		if (d.d_blk_hardlimit && d.d_bcount > d.d_blk_hardlimit)
> >  			qflags |= LIMIT_FLAG;
> > @@ -111,16 +113,17 @@ quota_mount(
> >  				bbs_to_string(d.d_blk_softlimit, s, sizeof(s)),
> >  				bbs_to_string(d.d_blk_hardlimit, h, sizeof(h)),
> >  				d.d_bwarns,
> > -				time_to_string(d.d_btimer, qflags));
> > +				time_to_string(timer, qflags));
> 
> What do the local variables buy us over just relying on the implicit cast
> to a larger integer type?

It's a setup to avoid long lines of nested function call crud once we
get to patch 23.  Without the local variable, the fprintf turns into
this ugliness:

			fprintf(fp, " %6s %6s %6s  %02d %8s ",
				bbs_to_string(d.d_bcount, c, sizeof(c)),
				bbs_to_string(d.d_blk_softlimit, s, sizeof(s)),
				bbs_to_string(d.d_blk_hardlimit, h, sizeof(h)),
				d.d_bwarns,
				time_to_string(decode_timer(&d, d.d_itimer,
								d.d_itimer_hi),
						qflags));

Which I guess is also fine but I kind of hate function call inside
function call inside function call combined with high indent levels.

--D
