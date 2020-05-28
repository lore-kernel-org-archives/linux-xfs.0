Return-Path: <SRS0=OPd9=7K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9001DC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 May 2020 22:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65F37206F1
	for <linux-xfs@archiver.kernel.org>; Thu, 28 May 2020 22:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436867AbgE1Wjm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 May 2020 18:39:42 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:42645 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437076AbgE1Wjl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 May 2020 18:39:41 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 998CE5AB3C4;
        Fri, 29 May 2020 08:39:37 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jeRBU-0000qI-J2; Fri, 29 May 2020 08:39:32 +1000
Date:   Fri, 29 May 2020 08:39:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [XFS SUMMIT] Ugh, Rebasing Sucks!
Message-ID: <20200528223932.GB2040@dread.disaster.area>
References: <20200527184858.GM8230@magnolia>
 <20200528000351.GA2040@dread.disaster.area>
 <20200528024410.GM252930@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528024410.GM252930@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=17He3R-WFsF2997NZ5QA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 27, 2020 at 07:44:10PM -0700, Darrick J. Wong wrote:
> On Thu, May 28, 2020 at 10:03:51AM +1000, Dave Chinner wrote:
> > From my perspective, an update from for-next after the -rc6 update
> > gets me all the stuff that will be in the next release. That's the
> > major rebase for my work, and everything pulled in from for-next
> > starts getting test coverage a couple of weeks out from the merge
> > window.  Once the merge window closes, another local update to the
> > -rc1 kernel (which should be a no-op for all XFS work) then gets
> > test coverage for the next release. -rc1 to -rc4 is when
> > review/rework for whatever I want merged in -rc4/-rc6 would get
> > posted to the list....
> 
> <nod>
> 
> My workflow is rather different -- I rebase my dev tree off the latest
> rc every week, and when a series is ready I port it to a branch off of
> for-next.

I do actually update the base kernel quite frequently - usually
every monday after a -rc is released. This is easy, and rarely
causes rebase issues because all the XFS changes in the base tree
have already been in the for-next tree. i.e. my typical weekly
"rebase" is:

git remote update
for each git branch:
	guilt pop -a
	git reset --hard origin/master # latest Linus tree
	git merge linux-xfs/for-next
	<merge any dependencies>
	loop {
		guilt push -a
		<fix patch that doesn't apply>
	} until all patches applied

If there's no significant change in for-next, then this is all easy
and is done in a few minutes. But if there's substantial change to
for-next, then the problems occur when pushing the patches back
onto the stack...

I've always based my dev work on the for-next branch (or equivalent
dev tree tip) because that way I'm always testing the latest dev
code from everyone else and I know my code works with it.

> Occasionally I'll port a refactoring from for-next into my
> dev tree to keep the code bases similar. 

Yup, that's the "<merge any dependencies>" in the process above.
i.e. someone has posted a cleanup patchset that's going to be merged
into for-next before the work I'm doing. That's where all the recent
problems have been coming from - the pain either occurs at the next
for-next update, or I take it when it's clear it's going to be
merged soon...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
