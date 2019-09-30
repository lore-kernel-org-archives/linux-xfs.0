Return-Path: <SRS0=9CIi=XZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457E8C32792
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 22:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 150B820842
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 22:37:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EpugJORa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfI3Whb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 18:37:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42686 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbfI3Whb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 18:37:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8UJP1Fc192722;
        Mon, 30 Sep 2019 19:29:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=BHJgBKgVpZWCZGX9bkFoXCvZVZeS7ev0gkIEMqPjB0A=;
 b=EpugJORadXplnLZ4vEEvf9ND2eUzUTgRzdJYEnAWUZ7nQQ2bxMZ3l2TaVc+v+FUZiPz5
 AC+Y2jvGVLwt8UsFqj+7mcIGPbMcwcJVJawZlybX05LVvM9FEiieET22UP5YSGR/t0oT
 q1lcWYuTmoJ7wdP1DQsvrhGEYGamK2UkQYMOxvUHMhGMaGriTg6c6KPKlV7Wa/BvNYtE
 xPRu5uZg/ArODQcivVFgF3Y7kML6sSEZnlzFHdVvzXPOKChJi9oWjgsGXHdygvEyzcXx
 tnP00W7yeaBbH2tp3RNqWYWUtHwexBA4/izEeZEHzSDt6rR2sAl45tyWi7M3oKzoW+TM eA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2va05rhc0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 19:29:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8UJTQeQ065701;
        Mon, 30 Sep 2019 19:29:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vbmpwve1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 19:29:29 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8UJT14a001518;
        Mon, 30 Sep 2019 19:29:01 GMT
Received: from localhost (/67.161.8.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 12:29:01 -0700
Date:   Mon, 30 Sep 2019 12:29:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/13] libfrog: fix workqueue error communication problems
Message-ID: <20190930192900.GB66746@magnolia>
References: <156944720314.297677.12837037497727069563.stgit@magnolia>
 <156944720949.297677.6259044122864374968.stgit@magnolia>
 <ffc61c3e-af9e-6203-c062-e00fbee0b141@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffc61c3e-af9e-6203-c062-e00fbee0b141@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909300172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909300172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 30, 2019 at 02:23:40PM -0500, Eric Sandeen wrote:
> On 9/25/19 4:33 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Convert all the workqueue functions to return positive error codes so
> > that we can move away from the libc-style indirect errno handling and
> > towards passing error codes directly back to callers.
> 
> This all looks fine, but it doesn't really do what the commit log says,
> right?

Urrrk... yes.  Clearly I stamped out the changelogs with a machine. :/

I /think/ most of the patches in that series actually have a return
conversion and a callsite conversion, but this one clearly is just...

"Convert workqueue functions to return errno errors from the C library,
then convert the callers to use str_liberror to report the runtime
error."

> The one spot where error return is changed, it was already
> positive; the rest is swapping str_liberror for str_info which is
> just cosmetic, right?

<shrug> Mostly cosmetic.  Before you'd get:

INFO: Could not create workqueue

Now you get:

ERROR: creating icount workqueue: Not enough frobs.

(and it actually records it as a runtime error :P)

--D

> -Eric
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  libfrog/workqueue.c |    4 ++--
> >  scrub/fscounters.c  |    5 ++---
> >  scrub/inodes.c      |    5 ++---
> >  scrub/phase2.c      |    8 +++-----
> >  scrub/phase4.c      |    6 +++---
> >  scrub/read_verify.c |    3 +--
> >  scrub/spacemap.c    |   11 ++++-------
> >  scrub/vfs.c         |    3 +--
> >  8 files changed, 18 insertions(+), 27 deletions(-)
> > 
> > 
> > diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
> > index 73114773..a806da3e 100644
> > --- a/libfrog/workqueue.c
> > +++ b/libfrog/workqueue.c
> > @@ -106,8 +106,8 @@ workqueue_add(
> >  	}
> >  
> >  	wi = malloc(sizeof(struct workqueue_item));
> > -	if (wi == NULL)
> > -		return ENOMEM;
> > +	if (!wi)
> > +		return errno;
> >  
> >  	wi->function = func;
> >  	wi->index = index;
> > diff --git a/scrub/fscounters.c b/scrub/fscounters.c
> > index ad467e0c..669c5ab0 100644
> > --- a/scrub/fscounters.c
> > +++ b/scrub/fscounters.c
> > @@ -115,15 +115,14 @@ xfs_count_all_inodes(
> >  			scrub_nproc_workqueue(ctx));
> >  	if (ret) {
> >  		moveon = false;
> > -		str_info(ctx, ctx->mntpoint, _("Could not create workqueue."));
> > +		str_liberror(ctx, ret, _("creating icount workqueue"));
> >  		goto out_free;
> >  	}
> >  	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
> >  		ret = workqueue_add(&wq, xfs_count_ag_inodes, agno, ci);
> >  		if (ret) {
> >  			moveon = false;
> > -			str_info(ctx, ctx->mntpoint,
> > -_("Could not queue AG %u icount work."), agno);
> > +			str_liberror(ctx, ret, _("queueing icount work"));
> >  			break;
> >  		}
> >  	}
> ...
> 
> 
