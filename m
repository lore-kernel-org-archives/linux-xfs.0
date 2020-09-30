Return-Path: <SRS0=giQg=DH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA66C4727E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 16:21:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 793E020759
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 16:21:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y/QP2d7/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731290AbgI3QVi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Sep 2020 12:21:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51366 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgI3QVh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Sep 2020 12:21:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08UGJBVl020189;
        Wed, 30 Sep 2020 16:21:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=F9noweUIrh9qk1xFOYdpbgCm5KznrdNFXqcvtFsKpRY=;
 b=Y/QP2d7/eeV5avocq+jZCwyLdHYVCuI4niTDHr+OX4s468gbL5EsHt0nnmdXMk/I8Igk
 TnOWrl6LQLtt06xM3i2WuyvnzOcHSbO+FMhw4+7dNST/H/uBJrP1uBzAzTJdpEgm40Vl
 i2Y98XAiWf+r6dbc7gT3Ps0aXgYJ9BpiPyUCZWBhHm9FM/47Ni91gnulpjuTKRpy6GSc
 V2vQ2daKr4ucTYTP/LlQZjNVq9vpn8BVQXpVL4glK/Hn0c0kFrOonCwmWOrnOYl+IMXb
 8yXe8OiZv0eGd44xrqcaFhgSAfVsnrtLPNlHYLp2upImz1sb7bNjPSoxPPW4POhmKisk tA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33sx9n9dnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 30 Sep 2020 16:21:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08UGEtf6016397;
        Wed, 30 Sep 2020 16:19:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33uv2fkn3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 16:19:34 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08UGJXno012040;
        Wed, 30 Sep 2020 16:19:34 GMT
Received: from localhost (/10.159.225.72)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Sep 2020 09:19:33 -0700
Date:   Wed, 30 Sep 2020 09:19:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] libxfs: disallow filesystems with reverse mapping and
 reflink and realtime
Message-ID: <20200930161932.GO49547@magnolia>
References: <20200930160112.GN49547@magnolia>
 <5806de04-b899-c6df-f387-6468c975cfd1@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5806de04-b899-c6df-f387-6468c975cfd1@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300128
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 30, 2020 at 11:09:29AM -0500, Eric Sandeen wrote:
> On 9/30/20 11:01 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Neither the kernel nor the code in xfsprogs support filesystems that
> > have (either reverse mapping btrees or reflink) enabled and a realtime
> > volume configured.  The kernel rejects such combinations and mkfs
> > refuses to format such a config, but xfsprogs doesn't check and can do
> > Bad Things, so port those checks before someone shreds their filesystem.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> 
> so now xfs_db won't even touch it, I'm not sure that's desirable.
> 
> # db/xfs_db fsfile
> xfs_db: Reflink not compatible with realtime device. Please try a newer xfsprogs.
> xfs_db: realtime device init failed
> xfs_db: device fsfile unusable (not an XFS filesystem?)

Er... did you specially craft fsfile to have rblocks>0 and reflink=1?
Or are you saying that it rejects any reflink=1 filesystem now?

--D

> 
> -Eric
> 
> > ---
> > v2: move code to rtmount_init where it belongs
> > ---
> >  libxfs/init.c |   15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> > 
> > diff --git a/libxfs/init.c b/libxfs/init.c
> > index cb8967bc77d4..330c645190d9 100644
> > --- a/libxfs/init.c
> > +++ b/libxfs/init.c
> > @@ -428,6 +428,21 @@ rtmount_init(
> >  	sbp = &mp->m_sb;
> >  	if (sbp->sb_rblocks == 0)
> >  		return 0;
> > +
> > +	if (xfs_sb_version_hasreflink(sbp)) {
> > +		fprintf(stderr,
> > +	_("%s: Reflink not compatible with realtime device. Please try a newer xfsprogs.\n"),
> > +				progname);
> > +		return -1;
> > +	}
> > +
> > +	if (xfs_sb_version_hasrmapbt(sbp)) {
> > +		fprintf(stderr,
> > +	_("%s: Reverse mapping btree not compatible with realtime device. Please try a newer xfsprogs.\n"),
> > +				progname);
> > +		return -1;
> > +	}
> > +
> >  	if (mp->m_rtdev_targp->dev == 0 && !(flags & LIBXFS_MOUNT_DEBUGGER)) {
> >  		fprintf(stderr, _("%s: filesystem has a realtime subvolume\n"),
> >  			progname);
> > 
