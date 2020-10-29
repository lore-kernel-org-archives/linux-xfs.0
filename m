Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96949C4741F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 21:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F5F32151B
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 21:59:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Roi8VJ6Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725772AbgJ2V7H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 17:59:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49488 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ2V7H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 17:59:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TLmdaX077536;
        Thu, 29 Oct 2020 21:59:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=X0SfZcHSRqdkpO9bJKmgjJUlaN2oFNyWXcrXMX/DkkE=;
 b=Roi8VJ6ZkObsPqZ+MUyPHs2cGVF8twufcvfddTYV2O+QmCl3QWWYmFPDP1BjthLshj35
 PpQOn7sRwBHMOg7dZ8sOBjWvYDtIwf18mt/OKACENWvNO6SM3RMfyt0XuOPVALdJgjfL
 Hst2yD5dk9r0IaPTRpCrwqyPB0PgpA5rvktELOO/R24a0F8qqNE4ImiggtM2Gwg117zo
 KK+3ipJwzEKtKhtvjJKz7W3eblFkjYnNSPTlMrPIeRGBtFC71Db6V15guXX+ZC8qjgik
 KL41yK+mtF8yInl71ooD1TWNw5yEbnMxuyafH75QDmUf5MnqZAWAEOlCpIW4KtBBdQXP Rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34dgm4cux8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 21:59:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TLjRJu049323;
        Thu, 29 Oct 2020 21:59:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34cx6yyr75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 21:59:04 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09TLx3NG000568;
        Thu, 29 Oct 2020 21:59:03 GMT
Received: from localhost (/10.159.244.77)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 14:59:03 -0700
Date:   Thu, 29 Oct 2020 14:59:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH 1/4] generic: check userspace handling of extreme
 timestamps
Message-ID: <20201029215902.GL1061252@magnolia>
References: <160382543472.1203848.8335854864075548402.stgit@magnolia>
 <160382544101.1203848.15837078115947156573.stgit@magnolia>
 <CAOQ4uxh9ihsUTsuaFdDTkP4rguNyAfDKq3_k6y1iEpZ3qoU2TQ@mail.gmail.com>
 <20201029205543.GC1061252@magnolia>
 <CAOQ4uxjZ7tpkJAXVHWvj5M0G4QM4vSeQ+GXszSij7wVbePJdXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjZ7tpkJAXVHWvj5M0G4QM4vSeQ+GXszSij7wVbePJdXw@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=1 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290150
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 11:40:00PM +0200, Amir Goldstein wrote:
> On Thu, Oct 29, 2020 at 11:02 PM Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> >
> > On Thu, Oct 29, 2020 at 12:34:57PM +0200, Amir Goldstein wrote:
> > > On Wed, Oct 28, 2020 at 10:25 PM Darrick J. Wong
> > > <darrick.wong@oracle.com> wrote:
> > > >
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > >
> > > > These two tests ensure we can store and retrieve timestamps on the
> > > > extremes of the date ranges supported by userspace, and the common
> > > > places where overflows can happen.
> > > >
> > > > They differ from generic/402 in that they don't constrain the dates
> > > > tested to the range that the filesystem claims to support; we attempt
> > > > various things that /userspace/ can parse, and then check that the vfs
> > > > clamps and persists the values correctly.
> > >
> > > So this test will fail when run on stable kernels before the vfs
> > > clamping changes
> > > and there is no require_* to mitigate that failure.
> >
> > Yes, that is the intended outcome.  Those old kernels silently truncate
> > the high bits from those timestamps when inodes are flushed to disk, and
> > the only user-visible evidence of this comes much later when the system
> > reboots and suddenly the timestamps are wrong.  Clamping also seems a
> > little strange, but at least it's immediately obvious.
> >
> > It is very surprising that you could set a timestamp of 2 Apr 2500 on
> > ext2, ls your shiny futuristic timestamp, reboot, and have it become
> > 5 Nov 1955.  Only Marty McFly would be amused.
> >
> 
> OK. So we can call it a bug in old kernels that is not going to be fixed
> in stable updates. The minimum we can do for stable kernel testers is
> provide a decent way to exclude the tests for clamping.
> 
> I guess 'check -x bigtime' is decent enough.
> I might have named the group 'timelimit' but I can live with 'bigtime'.
> 
> So with fix for the rest of my minor nits, you may add:

Ok, I've fixed them all.  I also added warnings to 721 and 722 that the
test is expected to fail on pre-5.4 kernels.  Thanks for reviewing!

--D

> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> Thanks,
> Amir.
