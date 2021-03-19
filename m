Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7EB7C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 22:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E42F6197D
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 22:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhCSWVW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 18:21:22 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54610 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230226AbhCSWU6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Mar 2021 18:20:58 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 701241041CDC;
        Sat, 20 Mar 2021 09:20:55 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lNNUD-004T8I-Ee; Sat, 20 Mar 2021 09:20:53 +1100
Date:   Sat, 20 Mar 2021 09:20:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hsiangkao@redhat.com
Subject: Re: [PATCH 2/7] repair: Protect bad inode list with mutex
Message-ID: <20210319222053.GT63242@dread.disaster.area>
References: <20210319013355.776008-1-david@fromorbit.com>
 <20210319013355.776008-3-david@fromorbit.com>
 <20210319182011.GT22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319182011.GT22100@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=XAQwWEGoRrOlOaaqmywA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 11:20:11AM -0700, Darrick J. Wong wrote:
> On Fri, Mar 19, 2021 at 12:33:50PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > To enable phase 6 parallelisation, we need to protect the bad inode
> > list from concurrent modification and/or access. Wrap it with a
> > mutex and clean up the nasty typedefs.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> FWIW, if you (Gao at this point, I surmise) want to dig deeper into the
> comment that Christoph made during the last review of this patchset,
> repair already /does/ have a resizing array structure in repair/slab.c.

Put it in another patchset, please.

Everyone, can we please get out of the habit of asking for extra
cleanups to be done as a condition for getting a change
merged just because the patchset makes a change to slightly crufty
but perfectly working code?

Cleaning up this code is not necessary for this patchset to achieve
it's goals or make forwards progress. Yes, the code that locking is
being added to is slightly crusty, but it is not broken nor is
showing up on profiles as being a performance, scalability or memory
usage limiting factor. Changing the algorithm of this code is
therefore unnecessary to acheive the goals of this patchset.

IOWs, put this aside this cleanup as future work on a rainy day
when we have fixed all the bigger scalability problems and have
nothing better to do.

"If it ain't broke, don't fix it."

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
