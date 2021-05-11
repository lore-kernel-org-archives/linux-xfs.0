Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D1D6C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 22:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23558616EA
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 22:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhEKWDb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 18:03:31 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58398 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229637AbhEKWDa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 May 2021 18:03:30 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0368B1043BF1;
        Wed, 12 May 2021 08:02:19 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lgaSJ-00ERnz-8n; Wed, 12 May 2021 08:02:19 +1000
Date:   Wed, 12 May 2021 08:02:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/22] xfs: remove agno from btree cursor
Message-ID: <20210511220219.GV63242@dread.disaster.area>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-17-david@fromorbit.com>
 <YJp54LyDZliZVR1H@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJp54LyDZliZVR1H@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=6gVBBrpqVJ2gsszt4tcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 11, 2021 at 08:34:40AM -0400, Brian Foster wrote:
> On Thu, May 06, 2021 at 05:20:48PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that everything passes a perag, the agno is not needed anymore.
> > Convert all the users to use pag->pag_agno instead and remove the
> > agno from the cursor. This was largely done as an automated search
> > and replace.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c          |   2 +-
> >  fs/xfs/libxfs/xfs_alloc_btree.c    |   1 -
> >  fs/xfs/libxfs/xfs_btree.c          |  12 ++--
> >  fs/xfs/libxfs/xfs_btree.h          |   1 -
> >  fs/xfs/libxfs/xfs_ialloc.c         |   2 +-
> >  fs/xfs/libxfs/xfs_ialloc_btree.c   |   7 +-
> >  fs/xfs/libxfs/xfs_refcount.c       |  82 +++++++++++-----------
> >  fs/xfs/libxfs/xfs_refcount_btree.c |  11 ++-
> >  fs/xfs/libxfs/xfs_rmap.c           | 108 ++++++++++++++---------------
> >  fs/xfs/libxfs/xfs_rmap_btree.c     |   1 -
> >  fs/xfs/scrub/agheader_repair.c     |   2 +-
> >  fs/xfs/scrub/alloc.c               |   3 +-
> >  fs/xfs/scrub/bmap.c                |   2 +-
> >  fs/xfs/scrub/ialloc.c              |   9 +--
> >  fs/xfs/scrub/refcount.c            |   3 +-
> >  fs/xfs/scrub/rmap.c                |   3 +-
> >  fs/xfs/scrub/trace.c               |   3 +-
> >  fs/xfs/xfs_fsmap.c                 |   4 +-
> >  fs/xfs/xfs_trace.h                 |   4 +-
> >  19 files changed, 130 insertions(+), 130 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> > index b23f949ee15c..d1dfad0204e3 100644
> > --- a/fs/xfs/libxfs/xfs_rmap.c
> > +++ b/fs/xfs/libxfs/xfs_rmap.c
> ...
> > @@ -2389,7 +2389,7 @@ xfs_rmap_finish_one(
> >  	 * the startblock, get one now.
> >  	 */
> >  	rcur = *pcur;
> > -	if (rcur != NULL && rcur->bc_ag.agno != pag->pag_agno) {
> > +	if (rcur != NULL && rcur->bc_ag.pag != pag) {
> 
> I wonder a bit about this sort of logic if the goal is to ultimately
> allow for dynamic instantiation of perag structures, though it's
> probably not an issue here.

The cursor will have an active reference, hence the perag it holds
cannot be reclaimed until it drops it's reference. THis is the
reason for pushing the perag into the cursor - we can guarantee the
existence of the perag for as long as a btree cursor chain (i.e. the
original cursor + all it's children that were duplicated from it).

Hence I think that checks that the pag is the same memory
address indicate that the perag is still the same. 

> >  		xfs_rmap_finish_one_cleanup(tp, rcur, 0);
> >  		rcur = NULL;
> >  		*pcur = NULL;
> ...
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 808ae337b222..5ba9c6396dcb 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -3730,7 +3730,7 @@ TRACE_EVENT(xfs_btree_commit_afakeroot,
> >  	TP_fast_assign(
> >  		__entry->dev = cur->bc_mp->m_super->s_dev;
> >  		__entry->btnum = cur->bc_btnum;
> > -		__entry->agno = cur->bc_ag.agno;
> > +		__entry->agno = cur->bc_ag.pag->pag_agno;
> 
> It would be nice if we did this with some of the other tracepoints
> rather than pulling ->pag_agno out at every callsite, but that's
> probably something for another patch. All in all this looks fine to me:

Yeah, that's something to clean up down the track. Cleaning up
tracepoints have been low on my priority list - just retaining what
they capture is sufficient for the initial conversion....

> Reviewed-by: Brian Foster <bfoster@redhat.com>

Ta.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
