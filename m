Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A285C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 01:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53A5064E6B
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 01:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhCSBng (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 21:43:36 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:37194 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229736AbhCSBnF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Mar 2021 21:43:05 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 23CA778B9B8;
        Fri, 19 Mar 2021 12:43:04 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lN4AJ-0048w3-IY; Fri, 19 Mar 2021 12:43:03 +1100
Date:   Fri, 19 Mar 2021 12:43:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] xfs: set a mount flag when perag reservation is
 active
Message-ID: <20210319014303.GQ63242@dread.disaster.area>
References: <20210318161707.723742-1-bfoster@redhat.com>
 <20210318161707.723742-2-bfoster@redhat.com>
 <20210318205536.GO63242@dread.disaster.area>
 <20210318221901.GN22100@magnolia>
 <20210319010506.GP63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319010506.GP63242@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=o8f2Czh7q9dNR2Z0awQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 12:05:06PM +1100, Dave Chinner wrote:
> On Thu, Mar 18, 2021 at 03:19:01PM -0700, Darrick J. Wong wrote:
> > TBH I think the COW recovery and the AG block reservation pieces are
> > prime candidates for throwing at an xfs_pwork workqueue so we can
> > perform those scans in parallel.
> 
> As I mentioned on #xfs, I think we only need to do the AG read if we
> are near enospc. i.e. we can take the entire reservation at mount
> time (which is fixed per-ag) and only take away the used from the
> reservation (i.e. return to the free space pool) when we actually
> access the AGF/AGI the first time. Or when we get a ENOSPC
> event, which might occur when we try to take the fixed reservation
> at mount time...

Which leaves the question about when we need to actually do the
accounting needed to fix the bug Brian is trying to fix. Can that be
delayed until we read the AGFs or have an ENOSPC event occur? Or
maybe some other "we are near ENOSPC and haven't read all AGFs yet"
threshold/trigger?

If that's the case, then I'm happy to have this patchset proceed as
it stands under the understanding that there will be follow up to
make the clean, lots of space free mount case avoid reading the the
AG headers.

If it can't be made constrained, then I think we probably need to
come up with a different approach that doesn't require reading every
AG header on every mount...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
