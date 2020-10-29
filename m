Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18476C55179
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 20:41:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DA7820790
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 20:41:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jpypp/0a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgJ2Uk5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 16:40:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42486 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbgJ2Ujk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 16:39:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TI9EaT016952;
        Thu, 29 Oct 2020 18:28:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=klqK/8o+fHkmByVey+E77SQ1SHs7Mu+NBbofRU/6N94=;
 b=jpypp/0a+K/RqyYByfzngIOOVsv/AqIZvI5SNfKmttL1FnMDIp3MvxzKvN9ctKbqS0kw
 y2GE4LqaG4n+cFN6zJ/GGZWTvW+a+n6x3oAANghyyXahVklqgBCR1nQXZKm+cRPNuYH5
 1JePj12y24itWkQ7TMiEWbDVuUpwokZZCetot3aofxe6M/V1slDSSYVnrCc2xa0guJGq
 WHj78sHMOfK1HSIw1DRUSbVR3kL77mjOmKRW9dPn6mXrYw93W/WIqTFQcfDZ7u1GnozL
 1T1jx4ygtbbcVBA2DFFHIelff0T2WoyNRZAksM6L6KY4EIpR0ZRrrUWtglHi3xTq6P1s fA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34cc7m6ch0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 18:28:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TIBSYJ177198;
        Thu, 29 Oct 2020 18:28:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34cx6ysss2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 18:28:04 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TIS3eN009826;
        Thu, 29 Oct 2020 18:28:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 11:28:03 -0700
Date:   Thu, 29 Oct 2020 11:28:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 2/4] xfs/122: add legacy timestamps to ondisk checker
Message-ID: <20201029182802.GV1061252@magnolia>
References: <160382543472.1203848.8335854864075548402.stgit@magnolia>
 <160382544732.1203848.9001133589345314135.stgit@magnolia>
 <CAOQ4uxi8=dYG95SJMc07oTidcc1nJheUzPVhNThykrtmT5a+kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi8=dYG95SJMc07oTidcc1nJheUzPVhNThykrtmT5a+kg@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290127
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 01:28:07PM +0200, Amir Goldstein wrote:
> On Wed, Oct 28, 2020 at 10:25 PM Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Add these new ondisk structures.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> > ---
> >  tests/xfs/122     |    1 +
> >  tests/xfs/122.out |    1 +
> >  2 files changed, 2 insertions(+)
> >
> >
> > diff --git a/tests/xfs/122 b/tests/xfs/122
> > index a4248031..db21f2d5 100755
> > --- a/tests/xfs/122
> > +++ b/tests/xfs/122
> > @@ -182,6 +182,7 @@ struct xfs_iext_cursor
> >  struct xfs_ino_geometry
> >  struct xfs_attrlist
> >  struct xfs_attrlist_ent
> > +struct xfs_legacy_ictimestamp
> 
> <OCD move near xfs_ictimestamp_t similar to other adjacent struct and
> typedefs />

Ok will do.

--D

> 
> Thanks,
> Amir.
