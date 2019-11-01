Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38DABCA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 21:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 091AF21734
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 21:48:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oZRaw6WB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfKAVsr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 17:48:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58396 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAVsr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 17:48:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1LjZDc105605;
        Fri, 1 Nov 2019 21:48:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=fl3XouavKgwTL/7GkFZCzrqb5bN9V+t8h24w+HGc6e8=;
 b=oZRaw6WBgPO7h/DPp4SVjLwc54U57jRMHsMt+74kMCtxft7P79a0CeNTieeDHg8fxKSL
 F2BzBT/bED2b4XlOhj8NFnS5BjATN5K6Ijpt8u1KXfXjupo407fi92CsGmcb0i4+L5fM
 dUW9XEnVLne/XjxLl6ysd1sceJMRb1Cb2fKxtaXfEsO6pjQuaQ/uff9t61ACwTgnNVvW
 fgIS/Kh0VUKjn/QLF0CGtOfWDgVpuu5mhq1qC2hvqqBDv0B4zXH19t2TRRQu2Ee9JHKA
 wSzqFThH8Muii0cbR0ykb3PR4+Hw1EntnK0Tlx4Fiesq38XYbJlYrQEfWtPn5YM8MYPq yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vxwhfva2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 21:48:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1Lj1EY029704;
        Fri, 1 Nov 2019 21:46:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w0utgtxvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 21:46:43 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA1LkgfF009624;
        Fri, 1 Nov 2019 21:46:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Nov 2019 14:46:42 -0700
Date:   Fri, 1 Nov 2019 14:46:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs_scrub: refactor xfs_scrub_excessive_errors
Message-ID: <20191101214641.GK15222@magnolia>
References: <157177012894.1460394.4672572733673534420.stgit@magnolia>
 <157177016827.1460394.10119847764483927499.stgit@magnolia>
 <1ef6570e-e32f-7925-7f3c-27a0cdf1d059@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ef6570e-e32f-7925-7f3c-27a0cdf1d059@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911010200
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911010200
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 04:25:55PM -0500, Eric Sandeen wrote:
> On 10/22/19 1:49 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor this helper to avoid cycling the scrub context lock when the
> > user hasn't configured a maximum error count threshold.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  scrub/common.c |   13 ++++++++++---
> >  1 file changed, 10 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/scrub/common.c b/scrub/common.c
> > index b1c6abd1..261c6bb2 100644
> > --- a/scrub/common.c
> > +++ b/scrub/common.c
> > @@ -33,13 +33,20 @@ bool
> >  xfs_scrub_excessive_errors(
> >  	struct scrub_ctx	*ctx)
> >  {
> > -	bool			ret;
> > +	unsigned long long	errors_seen;
> > +
> > +	/*
> > +	 * We only set max_errors at the start of the program, so it's safe to
> > +	 * access it locklessly.
> > +	 */
> > +	if (ctx->max_errors <= 0)
> 
> max_errors is an /unsigned/ long long, 'sup w/ the < part?

Being thorough. :)

> == maybe?

Yes, that works.

--D

> > +		return false;
> >  
> >  	pthread_mutex_lock(&ctx->lock);
> > -	ret = ctx->max_errors > 0 && ctx->corruptions_found >= ctx->max_errors;
> > +	errors_seen = ctx->corruptions_found;
> >  	pthread_mutex_unlock(&ctx->lock);
> >  
> > -	return ret;
> > +	return errors_seen >= ctx->max_errors;
> >  }
> >  
> >  static struct {
> > 
