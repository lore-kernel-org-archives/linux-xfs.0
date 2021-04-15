Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75596C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 06:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E6276109F
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 06:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhDOG2v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Apr 2021 02:28:51 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:42373 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229503AbhDOG2v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Apr 2021 02:28:51 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 791CC8292ED;
        Thu, 15 Apr 2021 16:28:26 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lWvUG-008lmK-Cv; Thu, 15 Apr 2021 16:28:24 +1000
Date:   Thu, 15 Apr 2021 16:28:24 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] xfs: support deactivating AGs
Message-ID: <20210415062824.GN63242@dread.disaster.area>
References: <20210414195240.1802221-1-hsiangkao@redhat.com>
 <20210414195240.1802221-2-hsiangkao@redhat.com>
 <20210415034255.GJ63242@dread.disaster.area>
 <20210415042837.GA1864610@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415042837.GA1864610@xiangao.remote.csb>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_f
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=2MhjRsioMMF3azSO5UcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 15, 2021 at 12:28:37PM +0800, Gao Xiang wrote:
> Hi Dave,
> 
> On Thu, Apr 15, 2021 at 01:42:55PM +1000, Dave Chinner wrote:
> > On Thu, Apr 15, 2021 at 03:52:37AM +0800, Gao Xiang wrote:
> > > To get rid of paralleled requests related to AGs which are pending
> > > for shrinking, mark these perags as inactive rather than playing
> > > with per-ag structures theirselves.
> > > 
> > > Since in that way, a per-ag lock can be used to stablize the inactive
> > > status together with agi/agf buffer lock (which is much easier than
> > > adding more complicated perag_{get, put} pairs..) Also, Such per-ags
> > > can be released / reused when unmountfs / growfs.
> > > 
> > > On the read side, pag_inactive_rwsem can be unlocked immediately after
> > > the agf or agi buffer lock is acquired. However, pag_inactive_rwsem
> > > can only be unlocked after the agf/agi buffer locks are all acquired
> > > with the inactive status on the write side.
> > > 
> > > XXX: maybe there are some missing cases.
> > > 
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_ag.c     | 16 +++++++++++++---
> > >  fs/xfs/libxfs/xfs_alloc.c  | 12 +++++++++++-
> > >  fs/xfs/libxfs/xfs_ialloc.c | 26 +++++++++++++++++++++++++-
> > >  fs/xfs/xfs_mount.c         |  2 ++
> > >  fs/xfs/xfs_mount.h         |  6 ++++++
> > >  5 files changed, 57 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > > index c68a36688474..ba5702e5c9ad 100644
> > > --- a/fs/xfs/libxfs/xfs_ag.c
> > > +++ b/fs/xfs/libxfs/xfs_ag.c
> > > @@ -676,16 +676,24 @@ xfs_ag_get_geometry(
> > >  	if (agno >= mp->m_sb.sb_agcount)
> > >  		return -EINVAL;
> > >  
> > > +	pag = xfs_perag_get(mp, agno);
> > > +	down_read(&pag->pag_inactive_rwsem);
> > 
> > No need to encode the lock type in the lock name. We know it's a
> > rwsem from the lock API functions...
> > 
> > > +
> > > +	if (pag->pag_inactive) {
> > > +		error = -EBUSY;
> > > +		up_read(&pag->pag_inactive_rwsem);
> > > +		goto out;
> > > +	}
> > 
> > This looks kinda heavyweight. Having to take a rwsem whenever we do
> > a perag lookup to determine if we can access the perag completely
> > defeats the purpose of xfs_perag_get() being a lightweight, lockless
> > operation.
> 
> I'm not sure if it has some regression since write lock will be only
> taken when shrinking (shrinking is a rare operation), for most cases
> which is much similiar to perag radix root I think.

It's still an extra pair of atomic operation per xfs_perag_get/put()
call pairs. pag_inactive being true is the slow/rare path, so we
should be trying to keep the overhead of detecting that path out of
all our fast paths...

Indeed, xfs_perag_get() already shows up on profiles because of the
number of calls we make to it, so adding an extra atomic operation
for this operation is going to be noticable in terms of CPU usage,
if nothing else.

> The locking logic is that, when pag->pag_inactive = false -> true,
> the write lock, AGF/AGI locks all have to be taken in advance.
> 
> > 
> > I suspect what we really want here is active/passive references like
> > are used for the superblock, and an API that hides the
> > implementation from all the callers.
> 
> If my understanding is correct, my own observation these months is
> that the current XFS codebase is not well suitable to accept !pag
> (due to many logic assumes pag structure won't go away, since some
>  are indexed/passed by agno rather than some pag reference count).

Maybe so, but that's exactly what this patch is addressing - it's
adding a way to detect that perag has "gone away"i and should not be
referenced any more.

It wasn't until I saw this patch that I realised that there is a way
that we can, in fact, safely handle perags being freed by ensuring
that the RCU lookup fails for these "active" references....

> Even I think we could introduce some active references, but handle
> the cover range is still a big project. The current approach assumes
> pag won't go away except for umounting and blocks allocation / imap/
> ... paths to access that.

The way I described should work just fine - nobody should be
accessing the per-ag without a reference gained through a lookup in
some way.  Buffers carry a passive reference, because the per-ag
teardown will do the teardown of those references before the perag
is freed.  Everything else carries an active reference and so
teardown cannot begin until all active references go away.

> My current thought is that we could implement it in that way as the
> first step (in order to land the shrinking functionality to let
> end-users benefit of this), and by the codebase evolves, it can be
> transformed to a more gentle way.

I think converting this patchset to active/passive references ias
I've described solves the problem entirely - there's no "evolving"
needed as we can solve it with this one structural change...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
