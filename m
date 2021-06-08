Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C826AC47082
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 21:56:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C2E86124B
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 21:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbhFHV5y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 17:57:54 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:47634 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234404AbhFHV5x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jun 2021 17:57:53 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 9731380B4EB;
        Wed,  9 Jun 2021 07:55:43 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lqjhG-00AXNX-Fx; Wed, 09 Jun 2021 07:55:42 +1000
Date:   Wed, 9 Jun 2021 07:55:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 5/9] xfs: force inode garbage collection before fallocate
 when space is low
Message-ID: <20210608215542.GL664593@dread.disaster.area>
References: <162310469340.3465262.504398465311182657.stgit@locust>
 <162310472140.3465262.3509717954267805085.stgit@locust>
 <20210608012605.GI664593@dread.disaster.area>
 <YL9Y9YM6VtxSnq+c@bfoster>
 <20210608153204.GS2945738@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608153204.GS2945738@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=7-415B0cAAAA:8
        a=9zZp27vEaiiRlEtZjvoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 08, 2021 at 08:32:04AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 08, 2021 at 07:48:05AM -0400, Brian Foster wrote:
> > users/workloads that might operate under these conditions? I guess
> > historically we've always recommended to not consistently operate in
> > <20% free space conditions, so to some degree there is an expectation
> > for less than optimal behavior if one decides to constantly bash an fs
> > into ENOSPC. Then again with large enough files, will/can we put the
> > filesystem into that state ourselves without any indication to the user?
> > 
> > I kind of wonder if unless/until there's some kind of efficient feedback
> > between allocation and "pending" free space, whether deferred
> > inactivation should be an optimization tied to some kind of heuristic
> > that balances the amount of currently available free space against
> > pending free space (but I've not combed through the code enough to grok
> > whether this already does something like that).
> 
> Ooh!  You mentioned "efficient feedback", and one sprung immediately to
> mind -- if the AG is near full (or above 80% full, or whatever) we
> schedule the per-AG inodegc worker immediately instead of delaying it.

That's what the lowspace thresholds in speculative preallocation are
for...

20% of a 1TB AG is an awful lot of freespace still remaining, and
if someone is asking for a 200GB fallocate(), they are always going
to get some fragmentation on a used, 80% full filesystem regardless
of deferred inode inactivation.

IMO, if you're going to do this, use the same thresholds we already
use to limit preallocation near global ENOSPC and graduate it to be
more severe the closer we get to global ENOSPC...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
