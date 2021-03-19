Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C0BC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 02:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1A5564F18
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 02:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhCSCJL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 22:09:11 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:53525 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229820AbhCSCIt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Mar 2021 22:08:49 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id C339278BDD3;
        Fri, 19 Mar 2021 13:08:47 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lN4ZD-0049N2-2i; Fri, 19 Mar 2021 13:08:47 +1100
Date:   Fri, 19 Mar 2021 13:08:47 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] xfs: set a mount flag when perag reservation is
 active
Message-ID: <20210319020847.GR63242@dread.disaster.area>
References: <20210318161707.723742-1-bfoster@redhat.com>
 <20210318161707.723742-2-bfoster@redhat.com>
 <20210318205536.GO63242@dread.disaster.area>
 <20210318221901.GN22100@magnolia>
 <20210319010506.GP63242@dread.disaster.area>
 <20210319014303.GQ63242@dread.disaster.area>
 <20210319014821.GP22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319014821.GP22100@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=-By9AgeoYt3CjGHfWm8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 18, 2021 at 06:48:21PM -0700, Darrick J. Wong wrote:
> On Fri, Mar 19, 2021 at 12:43:03PM +1100, Dave Chinner wrote:
> > On Fri, Mar 19, 2021 at 12:05:06PM +1100, Dave Chinner wrote:
> > > On Thu, Mar 18, 2021 at 03:19:01PM -0700, Darrick J. Wong wrote:
> > > > TBH I think the COW recovery and the AG block reservation pieces are
> > > > prime candidates for throwing at an xfs_pwork workqueue so we can
> > > > perform those scans in parallel.
> > > 
> > > As I mentioned on #xfs, I think we only need to do the AG read if we
> > > are near enospc. i.e. we can take the entire reservation at mount
> > > time (which is fixed per-ag) and only take away the used from the
> > > reservation (i.e. return to the free space pool) when we actually
> > > access the AGF/AGI the first time. Or when we get a ENOSPC
> > > event, which might occur when we try to take the fixed reservation
> > > at mount time...
> > 
> > Which leaves the question about when we need to actually do the
> > accounting needed to fix the bug Brian is trying to fix. Can that be
> > delayed until we read the AGFs or have an ENOSPC event occur? Or
> > maybe some other "we are near ENOSPC and haven't read all AGFs yet"
> > threshold/trigger?
> 
> Or just load them in the background and let mount() return to userspace?

Perhaps, but that tends to have impacts on things that run
immediately after mount. e.g. it will screw with benchmarks in
unpredictable ways and I'm not going to like that at all. :(

i.e. I like the deterministic, repeatable behaviour we have right
now because it makes back-to-back performance testing easy to reason
about why performance/behaviour changed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
