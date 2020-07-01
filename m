Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28666C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 17:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0C4620771
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 17:53:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PUXNBXSh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbgGARxt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 13:53:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42628 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgGARxt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 13:53:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061HrPxO023890;
        Wed, 1 Jul 2020 17:53:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=xcyYgIDG67Yx9unrZayHLt1w5l0hfL+/lhyYlpKyrdk=;
 b=PUXNBXShA6YJiwf11l1G960ZSjLM6T43zUl8D2pn4DWICWauawFsgJQdL9UWq0cmFnIi
 QiOo8HwlrgvCQgtkGSThrsciQicACwMpU3noyOA12LWQpAaMRDBn+xEZlGqMYpZOwtjl
 bRELOU7DXdTW9KeYJs6Dz2J1Vucxgv27/GRO44ZW6DzgxucYSBa6C/1bsfrUVUbe+zro
 K57oSTG+s3iZTHAWZXC5FbNgDP6MWkNmV30OiAJTjJ+hdaMijVsLg+G3tSCFWpd4JsRH
 6bPQZO9iXvST6JCFLc32fq9x6BWYNPfW11TYQkbgphOeIKAlMPwghQ8Eph6v85F9G+St QQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31ywrbt7h1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 01 Jul 2020 17:53:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061HWk1u053043;
        Wed, 1 Jul 2020 17:51:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31xg16vsgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jul 2020 17:51:38 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 061HpZux030210;
        Wed, 1 Jul 2020 17:51:35 GMT
Received: from localhost (/10.159.237.139)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Jul 2020 17:51:35 +0000
Date:   Wed, 1 Jul 2020 10:51:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 14/18] xfs: refactor quota exceeded test
Message-ID: <20200701175134.GU7606@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353180004.2864738.3571543752803090361.stgit@magnolia>
 <20200701085621.GN25171@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701085621.GN25171@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007010124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007010125
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 09:56:21AM +0100, Christoph Hellwig wrote:
> On Tue, Jun 30, 2020 at 08:43:20AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor the open-coded test for whether or not we're over quota.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_dquot.c |   95 ++++++++++++++++------------------------------------
> >  1 file changed, 30 insertions(+), 65 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index 35a113d1b42b..ef34c82c28a0 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -97,6 +97,33 @@ xfs_qm_adjust_dqlimits(
> >  		xfs_dquot_set_prealloc_limits(dq);
> >  }
> >  
> > +/*
> > + * Determine if this quota counter is over either limit and set the quota
> > + * timers as appropriate.
> > + */
> > +static inline void
> > +xfs_qm_adjust_res_timer(
> > +	struct xfs_dquot_res	*res,
> > +	struct xfs_def_qres	*dres)
> > +{
> > +	bool			over;
> > +
> > +#ifdef DEBUG
> > +	if (res->hardlimit)
> > +		ASSERT(res->softlimit <= res->hardlimit);
> > +#endif
> 
> Maybe:
> 	ASSERRT(!res->hardlimit || res->softlimit <= res->hardlimit);

Changed.

> 
> > +
> > +	over = (res->softlimit && res->count > res->softlimit) ||
> > +	       (res->hardlimit && res->count > res->hardlimit);
> > +
> > +	if (over && res->timer == 0)
> > +		res->timer = ktime_get_real_seconds() + dres->timelimit;
> > +	else if (!over && res->timer != 0)
> > +		res->timer = 0;
> > +	else if (!over && res->timer == 0)
> > +		res->warnings = 0;
> 
> What about:
> 
> 	if ((res->softlimit && res->count > res->softlimit) ||
> 	    (res->hardlimit && res->count > res->hardlimit)) {
> 		if (res->timer == 0)	
> 			res->timer = ktime_get_real_seconds() + dres->timelimit;
> 	} else {
> 		if (res->timer)
> 			res->timer = 0;
> 		else
> 			res->warnings = 0;
> 	}

I don't care either way, but the last time I sent this patch out, Eric
and Amir seemed to want a flatter if structure:

https://lore.kernel.org/linux-xfs/b979d33d-361b-88cd-699c-7e5f1c621698@sandeen.net/
https://lore.kernel.org/linux-xfs/CAOQ4uxiveTQu8_7UOvN07=P4o9hBBZTCyu4sSw5UpbrNPQL2pQ@mail.gmail.com/

Granted that was before I pulled the whole thing into a separate helper
function, so maybe the context is different here...?

--D
