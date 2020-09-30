Return-Path: <SRS0=giQg=DH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 184ABC4727C
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 15:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A824A20759
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 15:52:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eVA1Gj0h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbgI3PwR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Sep 2020 11:52:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55414 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgI3PwQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Sep 2020 11:52:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08UFnJl5161826;
        Wed, 30 Sep 2020 15:52:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=dUZVtzQDJNueS+gMM+ZQ0911LwkB7bG6fkV4cQIAETM=;
 b=eVA1Gj0hVjxLuhbiKjYgcBg4C8dMbnUQ2boTR4kn5pHQoBhDo9q2J6grGkbzNl1zybBN
 c6G5CtdTpph51LxI90vm04jDWbHfA+JF8kELB1Tc/oya24L3THjRlsZB8dp4D4Osajb4
 BAayQssaxrW36Tas8a2i8Dz2ZAjb14w4TKSGPzie92WjHxOZRQ5UsElH0xBGBp/yfdJN
 RQyiJBF9+tum0JwUF5KdIapXXDZkL2gJBWK5GSnyR3fBEjeAoNQtsWg/pLwmsJwmmcoG
 t8joP/ps8aUmaJ7xtuy9s0WuWXI+FPDa2fz1kHvp3qm3i4Db8O/mgkZh03TnSkqGBsGl 0w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33sx9n988u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 30 Sep 2020 15:52:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08UFpBNW111680;
        Wed, 30 Sep 2020 15:52:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33uv2fj9m9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 15:52:11 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08UFqAYD013543;
        Wed, 30 Sep 2020 15:52:10 GMT
Received: from localhost (/10.159.225.72)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Sep 2020 08:52:09 -0700
Date:   Wed, 30 Sep 2020 08:52:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] libxfs: disallow filesystems with reverse mapping and
 reflink and realtime
Message-ID: <20200930155208.GF49559@magnolia>
References: <20200930145840.GL49547@magnolia>
 <bf8fbe05-fea9-9571-0584-04be70c2d3dd@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf8fbe05-fea9-9571-0584-04be70c2d3dd@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300125
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 30, 2020 at 10:31:21AM -0500, Eric Sandeen wrote:
> On 9/30/20 9:58 AM, Darrick J. Wong wrote:
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
> seems fine in general but a couple thoughts...
> 
> > ---
> >  libxfs/init.c |   14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/libxfs/init.c b/libxfs/init.c
> > index cb8967bc77d4..1a966084ffea 100644
> > --- a/libxfs/init.c
> > +++ b/libxfs/init.c
> > @@ -724,6 +724,20 @@ libxfs_mount(
> >  		exit(1);
> >  	}
> >  
> > +	if (xfs_sb_version_hasreflink(sbp) && sbp->sb_rblocks) {
> 
> Hm, we really don't use xfs_sb_version_hasrealtime() very
> consistently, but it might be worth doing here?

Nah, I'll move it to rtmount_init.

> I wish we had a feature flag to cross-ref against, a corruption in
> sb_rblocks will lead to an untouchable filesystem, but I guess there's
> nothing we can do about that.

I guess xfs_repair could add a -E killrt=1 flag that would read the sb,
zero out sb_rblocks, and pass that to libxfs_mount.

> Actually, would it help to cross-check against the rtdev arg as well?
> Should we do anything different if the user actually specified a
> realtime device on the commandline?

I doubt it?  I mean, the fs allege it has an rt volume and some
unsupported feature; it doesn't matter if the user did or didn't pass an
rtdev.

> I mean, I suppose 

you suppose...?

> 
> > +		fprintf(stderr,
> > +	_("%s: Reflink not compatible with realtime device. Please try a newer xfsprogs.\n"),
> 
> I like this optimism.  ;)

Optimism?

/me now has an xfsprogs that /does/ support rt rmap and reflink, though
at current patch review rates it won't hit the list until 2024, and
that's assuming I can keep ahead of all the bitrot in rtrmap...

--D

> 
> 
> > +				progname);
> > +		exit(1);
> > +	}
> > +
> > +	if (xfs_sb_version_hasrmapbt(sbp) && sbp->sb_rblocks) {
> > +		fprintf(stderr,
> > +	_("%s: Reverse mapping btree not compatible with realtime device. Please try a newer xfsprogs.\n"),
> > +				progname);
> > +		exit(1);
> > +	}
> > +
> >  	xfs_da_mount(mp);
> >  
> >  	if (xfs_sb_version_hasattr2(&mp->m_sb))
> > 
