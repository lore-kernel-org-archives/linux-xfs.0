Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D83C3A5A1
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 03:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D779322CED
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 03:16:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KWADQzDy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfH2DQa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 23:16:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40214 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfH2DQa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Aug 2019 23:16:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7T3Fi8h133659;
        Thu, 29 Aug 2019 03:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ahyE6UtWVXYU+a6VoTmgR1NkDhfi/IO1/mse5C+HNLw=;
 b=KWADQzDyCg53tmwCCE2hHYtK0Xq57V3OMbZEztgIR8Wcg7nY1sO9XIw5P+g0LAKzStft
 AERPajuWR5XWvoNMtxJMTrq9L681ADUBOaHPPsQCEOmuYxf987XFPQKCbwKGLBWYbazN
 DPfrUj3HFPAO4SCdPgNZkkmC/a08pzrnjNqZVc8HasJDymmcdgy2vc7IDk0bWNwSYrjZ
 uhgq4/4Xw4Y9/CFROCVu4oD69u+5HPes5m7Kky725EFEVNDUh9sWjujpmWy34H9NenzY
 GEUZ00i6oAuubfWlMVncfTpkv6m6v13BrsKSwOCG1cBH+I1qPZOGsLI2PYuSWml2qkgL ZQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2up6n0r04g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 03:16:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7T34O1i015083;
        Thu, 29 Aug 2019 03:16:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2unvty7dau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 03:16:00 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7T3Fxn6030439;
        Thu, 29 Aug 2019 03:15:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Aug 2019 20:15:59 -0700
Date:   Wed, 28 Aug 2019 20:15:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_scrub: check summary counters
Message-ID: <20190829031558.GM1037350@magnolia>
References: <156685445746.2839983.1426723444334605572.stgit@magnolia>
 <156685446969.2839983.12626550627146659080.stgit@magnolia>
 <20190827052726.GZ1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827052726.GZ1119@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290033
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 27, 2019 at 03:27:26PM +1000, Dave Chinner wrote:
> On Mon, Aug 26, 2019 at 02:21:09PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Teach scrub to ask the kernel to check and repair summary counters
> > during phase 7.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  scrub/phase4.c |   12 ++++++++++++
> >  scrub/phase7.c |   14 ++++++++++++++
> >  scrub/repair.c |    3 +++
> >  scrub/scrub.c  |   13 +++++++++++++
> >  scrub/scrub.h  |    2 ++
> >  5 files changed, 44 insertions(+)
> > 
> > 
> > diff --git a/scrub/phase4.c b/scrub/phase4.c
> > index 49f00723..c4da4852 100644
> > --- a/scrub/phase4.c
> > +++ b/scrub/phase4.c
> > @@ -107,6 +107,18 @@ bool
> >  xfs_repair_fs(
> >  	struct scrub_ctx		*ctx)
> >  {
> > +	bool				moveon;
> > +
> > +	/*
> > +	 * Check the summary counters early.  Normally we do this during phase
> > +	 * seven, but some of the cross-referencing requires fairly-accurate
> > +	 * counters, so counter repairs have to be put on the list now so that
> > +	 * they get fixed before we stop retrying unfixed metadata repairs.
> > +	 */
> > +	moveon = xfs_scrub_fs_summary(ctx, &ctx->action_lists[0]);
> > +	if (!moveon)
> > +		return false;
> 
> "moveon" doesn't really make sense to me here. i.e. I can't tell if
> "moveon = true" meant it failed or not, so I hav eno idea what the
> intent of the code here is, and the comment doesn't explain it at
> all, either.

FWIW I created Yet Another Cleanup Series that replaces all the moveon
things with regular old "returns 0 for success, nonzero for error GTFO"
semantics.  I'll tack that on the end of all the stuff I've sent so far.

--D

> > +
> >  	return xfs_process_action_items(ctx);
> >  }
> >  
> > diff --git a/scrub/phase7.c b/scrub/phase7.c
> > index 1c459dfc..b3156fdf 100644
> > --- a/scrub/phase7.c
> > +++ b/scrub/phase7.c
> > @@ -7,12 +7,15 @@
> >  #include <stdint.h>
> >  #include <stdlib.h>
> >  #include <sys/statvfs.h>
> > +#include "list.h"
> >  #include "path.h"
> >  #include "ptvar.h"
> >  #include "xfs_scrub.h"
> >  #include "common.h"
> > +#include "scrub.h"
> >  #include "fscounters.h"
> >  #include "spacemap.h"
> > +#include "repair.h"
> >  
> >  /* Phase 7: Check summary counters. */
> >  
> > @@ -91,6 +94,7 @@ xfs_scan_summary(
> >  	struct scrub_ctx	*ctx)
> >  {
> >  	struct summary_counts	totalcount = {0};
> > +	struct xfs_action_list	alist;
> >  	struct ptvar		*ptvar;
> >  	unsigned long long	used_data;
> >  	unsigned long long	used_rt;
> > @@ -110,6 +114,16 @@ xfs_scan_summary(
> >  	int			ip;
> >  	int			error;
> >  
> > +	/* Check and fix the fs summary counters. */
> > +	xfs_action_list_init(&alist);
> > +	moveon = xfs_scrub_fs_summary(ctx, &alist);
> > +	if (!moveon)
> > +		return false;
> > +	moveon = xfs_action_list_process(ctx, ctx->mnt.fd, &alist,
> > +			ALP_COMPLAIN_IF_UNFIXED | ALP_NOPROGRESS);
> > +	if (!moveon)
> > +		return moveon;
> 
> same here - "moveon" doesn't tell me if we're returning because the
> scrub failed or passed....
> 
> > +
> >  	/* Flush everything out to disk before we start counting. */
> >  	error = syncfs(ctx->mnt.fd);
> >  	if (error) {
> > diff --git a/scrub/repair.c b/scrub/repair.c
> > index 45450d8c..54639752 100644
> > --- a/scrub/repair.c
> > +++ b/scrub/repair.c
> > @@ -84,6 +84,9 @@ xfs_action_item_priority(
> >  	case XFS_SCRUB_TYPE_GQUOTA:
> >  	case XFS_SCRUB_TYPE_PQUOTA:
> >  		return PRIO(aitem, XFS_SCRUB_TYPE_UQUOTA);
> > +	case XFS_SCRUB_TYPE_FSCOUNTERS:
> > +		/* This should always go after AG headers no matter what. */
> > +		return PRIO(aitem, INT_MAX);
> >  	}
> >  	abort();
> >  }
> > diff --git a/scrub/scrub.c b/scrub/scrub.c
> > index 136ed529..a428b524 100644
> > --- a/scrub/scrub.c
> > +++ b/scrub/scrub.c
> > @@ -28,6 +28,7 @@ enum scrub_type {
> >  	ST_PERAG,	/* per-AG metadata */
> >  	ST_FS,		/* per-FS metadata */
> >  	ST_INODE,	/* per-inode metadata */
> > +	ST_SUMMARY,	/* summary counters (phase 7) */
> >  };
> 
> Hmmm - the previous patch used ST_FS for the summary counters.
> 
> Oh, wait, io/scrub.c has a duplicate scrub_type enum defined, and
> the table looks largely the same, too. Except now the summary type
> is different.
> 
> /me looks a bit closer...
> 
> Oh, the enum scrub_type definitions shadow the kernel enum
> xchk_type, but have different values for the same names. I'm
> just confused now...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
