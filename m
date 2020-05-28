Return-Path: <SRS0=OPd9=7K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B944C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 28 May 2020 02:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E8862084C
	for <linux-xfs@archiver.kernel.org>; Thu, 28 May 2020 02:46:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GA/4cf3y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgE1CqR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 May 2020 22:46:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43458 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbgE1CqR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 May 2020 22:46:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04S2SOFY022351;
        Thu, 28 May 2020 02:46:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=G39A/4UyERydEP85xt6VjuVAFue3xHhfhYVjhjED3lg=;
 b=GA/4cf3yl4tmXCe1XBbE7tomCG2m1IdfyrfNyEGgiVyI8IuQlC/DxxHTx1xelAeGAA5y
 J8MbY+7GcKjJgwm8OzMwYjHtS2B0qoQvF+mRDsOcMM8LGiX+evIQhBkNXd0H6tzA2nu7
 dtREFTVdJ4VCJ4dnkvcMvIdh/Fk+nd/MNvt988Pp0SsLO1rObT2JR1+zVxjfi7Rp+CH7
 iNkHj68Sk4cpYaJmbxN6AlTB5YQPqyMQYWvzrq3x1sg4bE6FxUybGpdxcvoN8TSyLEUl
 PxkI2gysJ5RmG75wA760yYJcVZRlW8XbQgQJZCnoVNoU4ZG2oC8UA0npB1TE2mTGWabv Ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 318xbk2kjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 28 May 2020 02:46:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04S2T5Q3128426;
        Thu, 28 May 2020 02:44:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 317ddrx10t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 May 2020 02:44:14 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04S2iEmX008248;
        Thu, 28 May 2020 02:44:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 May 2020 19:44:14 -0700
Date:   Wed, 27 May 2020 19:44:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [XFS SUMMIT] Ugh, Rebasing Sucks!
Message-ID: <20200528024410.GM252930@magnolia>
References: <20200527184858.GM8230@magnolia>
 <20200528000351.GA2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528000351.GA2040@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9634 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=1 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005280009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9634 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 cotscore=-2147483648
 suspectscore=1 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005280009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 28, 2020 at 10:03:51AM +1000, Dave Chinner wrote:
> On Wed, May 27, 2020 at 11:48:58AM -0700, Darrick J. Wong wrote:
> > Hi everyone,
> > 
> > Many of you have complained (both publicly and privately) about the
> > heavy cost of rebasing your development trees, particularly when you're
> > getting close to sending a series out for review.  I get it, there have
> > been a lot of large refactoring patchsets coming in the past few kernel
> > cycles, and this has caused a lot of treewide churn.  I don't mind
> > cleanups of things that have been weird and wonky about XFS for years,
> > but, frankly, rebasing is soul-grinding.
> > 
> > To that end, I propose reducing the frequency of (my own) for-next
> > pushes to reduce how often people feel compelled to rebase when they're
> > trying to get a series ready for review.
> > 
> > Specifically, I would like to make an informal for-next push schedule as
> > follows:
> > 
> >  1 Between -rc1 and -rc4, I'll collect critical bug fixes for the
> >    merge window that just closed.  These should be small changes, so
> >    I'll put them out incrementally with the goal of landing everything
> >    in -rc4, and they shouldn't cause major disruptions for anyone else
> >    working on a big patchset.  This is more or less what I've been doing
> >    up till now -- if it's been on the list for > 24h and someone's
> >    reviewed it, I'll put it in for-next for wider testing.
> > 
> >  2 A day or two after -rc4 drops.  This push is targeted for the next
> >    merge window.  Coming three weeks after -rc1, I hope this will give
> >    everyone enough time for a round of rebase, review, and debugging of
> >    large changesets after -rc1.  IOWs, the majority of patchsets should
> >    be ready to go in before we get halfway to the next merge window.
> > 
> >  3 Another push a day or two after -rc6 drops.  This will hopefully give
> >    everyone a second chance to land patchsets that were nearly ready but
> >    didn't quite make it for -rc4; or other cleanups that would have
> >    interfered with the first round.  Once this is out, we're more or
> >    less finished with the big patchsets.
> 
> This seems like a reasonable compromise - knowing when updates are
> expected goes a long way to being able to plan development and
> schedule dev tree updates to avoid repeated rebasing.
> 
> >  4 Perhaps another big push a day or two after -rc8 drops?  I'm not keen
> >    on doing this.  It's not often that the kernel goes beyond -rc6 and I
> >    find it really stressful when the -rc's drag on but people keep
> >    sending large new patchsets.  Talk about stumbling around in the
> >    dark...
> 
> IMO it's too late at -rc8 to be including big new changes for the
> merge window. Bug fixes are fine, but not cleanups or features at
> this point because there's too little test and soak time to catch
> brown paper bag bugs before it's in the mainline tree and in much
> more widespread use.

Fair enough.  I didn't really like this #4 anyway.  Withdrawn. :)

> Same goes for merging new stuff during the merge window - last time
> around we had updates right up to the merge window, then an update
> during the merge window for a second pull request. There just wasn't
> any time when the tree wasn't actively moving forward.

Urk, sorry about that... I was hoping to land a fix for $largeclient
but then the crazy just kept coming.  Never gonna do /that/ again. :/

> From my perspective, an update from for-next after the -rc6 update
> gets me all the stuff that will be in the next release. That's the
> major rebase for my work, and everything pulled in from for-next
> starts getting test coverage a couple of weeks out from the merge
> window.  Once the merge window closes, another local update to the
> -rc1 kernel (which should be a no-op for all XFS work) then gets
> test coverage for the next release. -rc1 to -rc4 is when
> review/rework for whatever I want merged in -rc4/-rc6 would get
> posted to the list....

<nod>

My workflow is rather different -- I rebase my dev tree off the latest
rc every week, and when a series is ready I port it to a branch off of
for-next.  Occasionally I'll port a refactoring from for-next into my
dev tree to keep the code bases similar.  Both trees get run through
fstests and $whatnot whenever they change, which mean that most mornings
I'm looking at nightlies.

> This means there's a single rebase event a cycle at -rc6, and the
> rest of the time the tree is pretty stable and the base tree I'm
> testing is almost always the tree that we need to focus dev testing
> on. That is, just before the merge window everyone should be testing
> for-next on a -rc6/-rc7 base, and once -rc1 is out, everyone should
> be testing that kernel through to ~-rc4 at which point it has
> largely stabilised and the cycle starts again....
> 
> >  5 Obviously, I wouldn't hold back on critical bug fixes to things that
> >    are broken in for-next, since the goal is to promote testing, not
> >    hinder it.
> 
> *nod*
> 
> > Hopefully this will cut down on the "arrrgh I was almost ready to send
> > this but then for-next jumped and nggghghghg" feelings. :/
> > 
> > Thoughts?  Flames?
> 
> Perhaps:
> 
> - each patch set that is posted should start with "this is aimed at
>   a 5.x.y-rc4/-rc6 merge" or "still work in progress" so that
>   everyone has some expectation of when changes are likely to land.

<nod> This would probably help with peoples' ability to distinguish
djwong patchbombs for submission vs. making backups on NYE. ;)

> or:
> 
> - aim to land features and complex bug fixes in -rc4 and cleanups in
>   -rc6, that way we naturally minimise the rebase work for the
>   features/bug fixes that are being landed. This may mean that -rc4
>   is a small merge if there are no features/bug fixes that meet the
>   -rc4 merge criteria...

I like that idea.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
