Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF6AC433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 21:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07C9023435
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 21:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbhAGVzc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 16:55:32 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55822 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727835AbhAGVza (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jan 2021 16:55:30 -0500
Received: from dread.disaster.area (pa49-179-167-107.pa.nsw.optusnet.com.au [49.179.167.107])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DDF833C28B5;
        Fri,  8 Jan 2021 08:54:45 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kxdEy-0046v2-K7; Fri, 08 Jan 2021 08:54:44 +1100
Date:   Fri, 8 Jan 2021 08:54:44 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Donald Buczek <buczek@molgen.mpg.de>, linux-xfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+linux-xfs@molgen.mpg.de
Subject: Re: [PATCH] xfs: Wake CIL push waiters more reliably
Message-ID: <20210107215444.GG331610@dread.disaster.area>
References: <1705b481-16db-391e-48a8-a932d1f137e7@molgen.mpg.de>
 <20201229235627.33289-1-buczek@molgen.mpg.de>
 <20201230221611.GC164134@dread.disaster.area>
 <20210104162353.GA254939@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104162353.GA254939@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=+wqVUQIkAh0lLYI+QRsciw==:117 a=+wqVUQIkAh0lLYI+QRsciw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=7-415B0cAAAA:8
        a=3RWKWmqAdg96zEk6hCgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 04, 2021 at 11:23:53AM -0500, Brian Foster wrote:
> On Thu, Dec 31, 2020 at 09:16:11AM +1100, Dave Chinner wrote:
> > On Wed, Dec 30, 2020 at 12:56:27AM +0100, Donald Buczek wrote:
> > > If the value goes below the limit while some threads are
> > > already waiting but before the push worker gets to it, these threads are
> > > not woken.
> > > 
> > > Always wake all CIL push waiters. Test with waitqueue_active() as an
> > > optimization. This is possible, because we hold the xc_push_lock
> > > spinlock, which prevents additions to the waitqueue.
> > > 
> > > Signed-off-by: Donald Buczek <buczek@molgen.mpg.de>
> > > ---
> > >  fs/xfs/xfs_log_cil.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > > index b0ef071b3cb5..d620de8e217c 100644
> > > --- a/fs/xfs/xfs_log_cil.c
> > > +++ b/fs/xfs/xfs_log_cil.c
> > > @@ -670,7 +670,7 @@ xlog_cil_push_work(
> > >  	/*
> > >  	 * Wake up any background push waiters now this context is being pushed.
> > >  	 */
> > > -	if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))
> > > +	if (waitqueue_active(&cil->xc_push_wait))
> > >  		wake_up_all(&cil->xc_push_wait);
> > 
> > That just smells wrong to me. It *might* be correct, but this
> > condition should pair with the sleep condition, as space used by a
> > CIL context should never actually decrease....
> > 
> 
> ... but I'm a little confused by this assertion. The shadow buffer
> allocation code refers to the possibility of shadow buffers falling out
> that are smaller than currently allocated buffers. Further, the
> _insert_format_items() code appears to explicitly optimize for this
> possibility by reusing the active buffer, subtracting the old size/count
> values from the diff variables and then reformatting the latest
> (presumably smaller) item to the lv.

Individual items might shrink, but the overall transaction should
grow. Think of a extent to btree conversion of an inode fork. THe
data in the inode fork decreases from a list of extents to a btree
root block pointer, so the inode item shrinks. But then we add a new
btree root block that contains all the extents + the btree block
header, and it gets rounded up to ithe 128 byte buffer logging chunk
size.

IOWs, while the inode item has decreased in size, the overall
space consumed by the transaction has gone up and so the CIL ctx
used_space should increase. Hence we can't just look at individual
log items and whether they have decreased in size - we have to look
at all the items in the transaction to understand how the space used
in that transaction has changed. i.e. it's the aggregation of all
items in the transaction that matter here, not so much the
individual items.

> Of course this could just be implementation detail. I haven't dug into
> the details in the remainder of this thread and I don't have specific
> examples off the top of my head, but perhaps based on the ability of
> various structures to change formats and the ability of log vectors to
> shrink in size, shouldn't we expect the possibility of a CIL context to
> shrink in size as well? Just from poking around the CIL it seems like
> the surrounding code supports it (xlog_cil_insert_items() checks len > 0
> for recalculating split res as well)...

Yes, there may be situations where it decreases. It may be this is
fine, but the assumption *I've made* in lots of the CIL push code is
that ctx->used_space rarely, if ever, will go backwards.

e.g. we run the first transaction into the CIL, it steals the sapce
needed for the cil checkpoint headers for the transaciton. Then if
the space returned by the item formatting is negative (because it is
in the AIL and being relogged), the CIL checkpoint now doesn't have
the space reserved it needs to run a checkpoint. That transaction is
a sync transaction, so it forces the log, and now we push the CIL
without sufficient reservation to write out the log headers and the
items we just formatted....

So, yeah, shrinking transaction space usage definitely violates some
of the assumptions the code makes about how relogging works. It's
entirely possible the assumptions I've made are not entirely correct
in some corner cases - those particular cases are what we need to
ferret out here, and then decide if they are correct or not and deal
with it from there...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
