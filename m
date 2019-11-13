Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E946C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 00:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 230D02084E
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 00:01:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q9n7acWk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfKMABu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 19:01:50 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51196 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbfKMABu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 19:01:50 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xACNXl5B135992;
        Wed, 13 Nov 2019 00:01:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=D7riiirlQDbbWZXNM11pAPABYEv3JYWrl7J7BNCUCow=;
 b=q9n7acWkokwa/iGvh2+RGuAINfVf7L9spn2qA9d5TMkpKWaN4ZW8b8flYQEY53LP/dud
 lvqnZn4zdK2/PflqeMRZV547c1W8DsSmjyKT3t9zU53Din8DsQRyZuMC6IPFYBvrn6t1
 148AS1CNeZyy2+ubduHFY/1rgtgFSXSjZHAcpHXorclltPCFG9I9F6gjCUTZK7K0xmcC
 hcDrDX+Sa+QOH7M3uFV0jZyTLHJ5OZ0evZ6UVGp2UUFR4xPNWwQKojFeLZfC9ygHeluy
 o4og+K/ZANUuTk3g17fFDoIyPLtxOGnU/fBNabuA8Y+HmIt27HwhrFC8N72+zTXf5Ply vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w5mvtrdxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 00:01:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xACNXDHZ087244;
        Wed, 13 Nov 2019 00:01:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2w7vpn98pb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 00:01:46 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAD01jXv012120;
        Wed, 13 Nov 2019 00:01:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 16:01:44 -0800
Date:   Tue, 12 Nov 2019 16:01:43 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add a if_xfs_meta_bad macro for testing and
 logging bad metadata
Message-ID: <20191113000143.GC6219@magnolia>
References: <157343507145.1945685.2940312466469213044.stgit@magnolia>
 <157343507829.1945685.13191379852906635565.stgit@magnolia>
 <20191111134904.GB46312@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111134904.GB46312@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911120201
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911120201
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 11, 2019 at 08:51:19AM -0500, Brian Foster wrote:
> On Sun, Nov 10, 2019 at 05:17:58PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a new macro, if_xfs_meta_bad, which we will use to integrate some
> > corruption reporting when the corruption test expression is true.  This
> > will be used in the next patch to remove the ugly XFS_WANT_CORRUPT*
> > macros.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> Ooh a new bikeshed... :)
> 
> >  fs/xfs/xfs_linux.h |   16 +++++++++++++++-
> >  1 file changed, 15 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> > index 2271db4e8d66..d0fb1e612c42 100644
> > --- a/fs/xfs/xfs_linux.h
> > +++ b/fs/xfs/xfs_linux.h
> > @@ -229,6 +229,10 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
> >  #define ASSERT(expr)	\
> >  	(likely(expr) ? (void)0 : assfail(NULL, #expr, __FILE__, __LINE__))
> >  
> > +#define xfs_meta_bad(mp, expr)	\
> > +	(unlikely(expr) ? assfail((mp), #expr, __FILE__, __LINE__), \
> > +			  true : false)
> > +
> >  #else	/* !DEBUG */
> >  
> >  #ifdef XFS_WARN
> > @@ -236,13 +240,23 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
> >  #define ASSERT(expr)	\
> >  	(likely(expr) ? (void)0 : asswarn(NULL, #expr, __FILE__, __LINE__))
> >  
> > +#define xfs_meta_bad(mp, expr)	\
> > +	(unlikely(expr) ? asswarn((mp), #expr, __FILE__, __LINE__), \
> > +			  true : false)
> > +
> >  #else	/* !DEBUG && !XFS_WARN */
> >  
> > -#define ASSERT(expr)	((void)0)
> > +#define ASSERT(expr)		((void)0)
> > +
> > +#define xfs_meta_bad(mp, expr)	\
> > +	(unlikely(expr) ? XFS_ERROR_REPORT(#expr, XFS_ERRLEVEL_LOW, (mp)), \
> > +			  true : false)
> >  
> >  #endif /* XFS_WARN */
> >  #endif /* DEBUG */
> >  
> > +#define if_xfs_meta_bad(mp, expr)	if (xfs_meta_bad((mp), (expr)))
> > +
> d
> FWIW, 'xfs_meta_bad' doesn't really tell me anything about what the
> macro is for, particularly since the logic that determines whether
> metadata is bad is fed into it. IOW, I read that and expect the macro to
> actually do something generic to determine whether metadata is bad.
> 
> Also having taken a quick look at the next patch, I agree with Christoph
> on embedding if logic into the macro itself, at least with respect to
> readability. It makes the code look like a typo/syntax error to me. :P

It's not just you. ;)

> I agree that the existing macros are ugly, but they at least express
> operational semantics reasonably well between [_RETURN|_GOTO]. If we
> really want to fix the latter bit, perhaps the best incremental step is
> to drop the branching logic and naming portion from the existing macros
> and leave everything else as is (from the commit logs, it sounds like
> this is more along the lines of your previous version, just without the
> name change). From there perhaps we can come up with better naming
> eventually. Just a thought.

<nod> I couldn't come up with much better than XFS_IS_CORRUPT, though I
see Dave's point about:

if (XFS_IS_CORRUPT(mp,
    xfs_measure_something() > BADNESS) {
	xfs_error(mp, "OHNO");
	return -EFSCORRUPTED;
}

Is a bit hard to read.

if (XFS_IS_CORRUPT(mp,
		   xfs_measure_something() > BADNESS) {
	xfs_error(mp, "OHNO");
	return -EFSCORRUPTED;
}

Isn't awesome either, but it at least works and is a bit more obvious.
:/

--D

> Brian
> 
> >  #define STATIC static noinline
> >  
> >  #ifdef CONFIG_XFS_RT
> > 
> 
