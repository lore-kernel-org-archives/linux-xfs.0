Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7783DC433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 18 May 2021 01:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 504986135F
	for <linux-xfs@archiver.kernel.org>; Tue, 18 May 2021 01:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237886AbhERBWh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 May 2021 21:22:37 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:36330 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237490AbhERBWh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 May 2021 21:22:37 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B70BF863284;
        Tue, 18 May 2021 11:21:18 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lioQ9-002Drc-Q5; Tue, 18 May 2021 11:21:17 +1000
Date:   Tue, 18 May 2021 11:21:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/22] xfs: collapse AG selection for inode allocation
Message-ID: <20210518012117.GG2893@dread.disaster.area>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-19-david@fromorbit.com>
 <YJvPiWfS4Jp2has7@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJvPiWfS4Jp2has7@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=HufvsI7bE3szMNcxdEkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 08:52:25AM -0400, Brian Foster wrote:
> On Thu, May 06, 2021 at 05:20:50PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs_dialloc_select_ag() does a lot of repetitive work. It first
> > calls xfs_ialloc_ag_select() to select the AG to start allocation
> > attempts in, which can do up to two entire loops across the perags
> > that inodes can be allocated in. This is simply checking if there is
> > spce available to allocate inodes in an AG, and it returns when it
> > finds the first candidate AG.
> > 
> > xfs_dialloc_select_ag() then does it's own iterative walk across
> > all the perags locking the AGIs and trying to allocate inodes from
> > the locked AG. It also doesn't limit the search to mp->m_maxagi,
> > so it will walk all AGs whether they can allocate inodes or not.
> > 
> > Hence if we are really low on inodes, we could do almost 3 entire
> > walks across the whole perag range before we find an allocation
> > group we can allocate inodes in or report ENOSPC.
> > 
> > Because xfs_ialloc_ag_select() returns on the first candidate AG it
> > finds, we can simply do these checks directly in
> > xfs_dialloc_select_ag() before we lock and try to allocate inodes.
> > This reduces the inode allocation pass down to 2 perag sweeps at
> > most - one for aligned inode cluster allocation and if we can't
> > allocate full, aligned inode clusters anywhere we'll do another pass
> > trying to do sparse inode cluster allocation.
> > 
> > This also removes a big chunk of duplicate code.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_ialloc.c | 221 +++++++++++++------------------------
> >  1 file changed, 75 insertions(+), 146 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index 872591e8f5cb..b22556556bba 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> ...
> > @@ -1778,10 +1669,41 @@ xfs_dialloc_select_ag(
> >  				break;
> >  		}
> >  
> > +		if (!pag->pagi_freecount)
> > +			goto nextag;
> 
> It looks like this would never allow for allocation of new inode
> chunks..?
> 
> > +		if (!okalloc)
> > +			goto nextag;

I guess I never tested this patch in isolation, and I fixed the bug
in one of the following patches. This should be:

		if (!pag->pagi_freecount && !okalloc)
			goto nextag;

Fixed.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
