Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F5CC433C1
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 22:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AEB3619D8
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 22:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbhCWWlC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 18:41:02 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:52841 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234158AbhCWWkj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Mar 2021 18:40:39 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A1F76827E55;
        Wed, 24 Mar 2021 09:40:37 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lOphU-005zUV-Vg; Wed, 24 Mar 2021 09:40:36 +1100
Date:   Wed, 24 Mar 2021 09:40:36 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] xfs: set a mount flag when perag reservation is
 active
Message-ID: <20210323224036.GJ63242@dread.disaster.area>
References: <20210318161707.723742-1-bfoster@redhat.com>
 <20210318161707.723742-2-bfoster@redhat.com>
 <20210318205536.GO63242@dread.disaster.area>
 <20210318221901.GN22100@magnolia>
 <20210319010506.GP63242@dread.disaster.area>
 <20210319014303.GQ63242@dread.disaster.area>
 <YFS7IbGIyf4VqF59@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFS7IbGIyf4VqF59@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=6RKVXk6y1sDKWcmH7FUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
        a=fCgQI5UlmZDRPDxm0A3o:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 10:54:25AM -0400, Brian Foster wrote:
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
> > 
> 
> Technically there isn't a hard requirement to read in any AGFs at mount
> time. The tradeoff is that leaves a gap in effectiveness until at least
> the majority of allocbt blocks have been accounted for (via perag agf
> initialization). The in-core counter simply folds into the reservation
> set aside value, so it would just remain at 0 at reservation time and
> behave as if the mechanism didn't exist in the first place. The obvious
> risk is a user can mount the fs and immediately acquire reservation
> without having populated the counter from enough AGs to prevent the
> reservation overrun problem. For that reason, I didn't really consider
> the "lazy" init approach a suitable fix and hooked onto the (mostly)
> preexisting perag res behavior to initialize the appropriate structures
> at mount time.
> 
> If that underlying mount time behavior changes, it's not totally clear
> to me how that impacts this patch. If the perag res change relies on an
> overestimated mount time reservation and a fallback to a hard scan on
> -ENOSPC, then I wonder whether the overestimated reservation might
> effectively subsume whatever the allocbt set aside might be for that AG.
> If so, and the perag init effectively transfers excess reservation back
> to free space at the same time allocbt blocks are accounted for (and set
> aside from subsequent reservations), perhaps that has a similar net
> effect as the current behavior (of initializing the allocbt count at
> mount time)..?
> 
> One problem is that might be hard to reason about even with code in
> place, let alone right now when the targeted behavior is still
> vaporware. OTOH, I suppose that if we do know right now that the perag
> res scan will still fall back to mount time scans beyond some low free
> space threshold, perhaps it's just a matter of factoring allocbt set
> aside into the threshold somehow so that we know the counter will always
> be initialized before a user can over reserve blocks.

Yeah, that seems reasonable to me. I don't think it's difficult to
handle - just set the setaside to maximum at mount time, then as we
read in AGFs we replace the maximum setaside for that AG with the
actual btree block usage. If we hit ENOSPC, then we can read in the
uninitialised pags to reduce the setaside from the maximum to the
actual values and return that free space back to the global pool...

> As it is, I don't
> really have a strong opinion on whether we should try to make this fix
> now and preserve it, or otherwise table it and revisit once we know what
> the resulting perag res code will look like. Thoughts?

It sounds like we have a solid plan to address the AG header access
at mount time, adding this code now doesn't make anything worse,
nor does it appear to prevent us from fixing the AG header access
problem in the future. So I'm happy for this fix to go ahead as it
stands.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
