Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 906AFC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 23:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6050C2071A
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 23:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgFRXEf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 19:04:35 -0400
Received: from [211.29.132.53] ([211.29.132.53]:37099 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1728387AbgFRXEe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jun 2020 19:04:34 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id C464AD5D71B;
        Fri, 19 Jun 2020 09:04:10 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jm3Zl-00015Z-1z; Fri, 19 Jun 2020 09:04:05 +1000
Date:   Fri, 19 Jun 2020 09:04:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Waiman Long <longman@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v4] xfs: Fix false positive lockdep warning with
 sb_internal & fs_reclaim
Message-ID: <20200618230405.GK2005@dread.disaster.area>
References: <20200618171941.9475-1-longman@redhat.com>
 <20200618225810.GJ2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618225810.GJ2005@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=7-415B0cAAAA:8
        a=k999_xXsWlR2ZBYdmagA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 19, 2020 at 08:58:10AM +1000, Dave Chinner wrote:
> On Thu, Jun 18, 2020 at 01:19:41PM -0400, Waiman Long wrote:
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 379cbff438bc..1b94b9bfa4d7 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -913,11 +913,33 @@ xfs_fs_freeze(
> >  	struct super_block	*sb)
> >  {
> >  	struct xfs_mount	*mp = XFS_M(sb);
> > +	unsigned long		pflags;
> > +	int			ret;
> >  
> > +	/*
> > +	 * A fs_reclaim pseudo lock is added to check for potential deadlock
> > +	 * condition with fs reclaim. The following lockdep splat was hit
> > +	 * occasionally. This is actually a false positive as the allocation
> > +	 * is being done only after the frozen filesystem is no longer dirty.
> > +	 * One way to avoid this splat is to add GFP_NOFS to the affected
> > +	 * allocation calls. This is what PF_MEMALLOC_NOFS is for.
> > +	 *
> > +	 *       CPU0                    CPU1
> > +	 *       ----                    ----
> > +	 *  lock(sb_internal);
> > +	 *                               lock(fs_reclaim);
> > +	 *                               lock(sb_internal);
> > +	 *  lock(fs_reclaim);
> > +	 *
> > +	 *  *** DEADLOCK ***
> > +	 */
> 
> The lockdep splat is detailed in the commit message - it most
> definitely does not need to be repeated in full here because:
> 
> 	a) it doesn't explain why the splat occurring is, and
> 	b) we most definitely don't care about how the lockdep check
> 	   that triggered it is implemented.

I should have added this:

	c) a lot of people don't understand what lockdep reports
	   are telling them is a problem.

I get a lot of questions like "I saw this lockdep thing, but I can't
work out what it actually means, so can you have a look at it
Dave?". Hence I think directly quoting something people tend not to
understand to explain the problem they didn't understand isn't the
best approach to improving understanding of the problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
