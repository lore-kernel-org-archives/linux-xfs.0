Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF36DC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 23:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiGKXkf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 19:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiGKXkf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 19:40:35 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 91F4127FDB
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jul 2022 16:40:31 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 758F910E7DD0;
        Tue, 12 Jul 2022 09:40:30 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oB30v-00HO53-3v; Tue, 12 Jul 2022 09:40:29 +1000
Date:   Tue, 12 Jul 2022 09:40:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: AIL doesn't need manual pushing
Message-ID: <20220711234029.GD3861211@dread.disaster.area>
References: <20220708015558.1134330-1-david@fromorbit.com>
 <20220708015558.1134330-2-david@fromorbit.com>
 <Ysu88PpxIRs0An3W@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ysu88PpxIRs0An3W@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62ccb4ee
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=7-415B0cAAAA:8
        a=p6Q1hN5CBg3joVZ0x6UA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 10, 2022 at 11:02:24PM -0700, Christoph Hellwig wrote:
> This looks very nice, but a bunch of minor comments:
> 
> > This is silly and expensive. The AIL is perfectly capable of
> > calculating the push target itself, and it will always be running
> > when the AIL contains objects.
> > 
> > Modify the AIL to calculate it's 25% push target before it starts a
> > push using the same reserve grant head based calculation as is
> > currently used, and remove all the places where we ask the AIL to
> > push to a new 25% free target.
> > 
> 
> I suspect some of these "the AIL" to xfsaild or te AIL pusher for
> the sentences to make sense.

Sure. This is all pretty rough "I just go this working" code right
now.

> 
> > +#include "xfs_trans_priv.h"
> 
> > +#include "xfs_log_priv.h"
> 
> > -			threshold_lsn = xlog_grant_push_threshold(log, 0);
> > +			threshold_lsn = xfs_ail_push_target(log->l_ailp);
> 
> Should xfs_ail_push_target go into xfs_log.h instead of xfs_log_priv.h?

No.

The AIL should not be visible to anything except the log - the
xfs_mount and the transaction subsystem should know nothing about it
at all. And even with that isolation, the only external interfaces
should be the the commit completion inserting items into the AIL and
the AIL updating the amount of space it consumes.

Overall, our log/trans/log_item/ail headers and code structure is a
total mess.

The "trans_ail" namesapce needs to go away entirely - the AIL
has nothing to do with transactions at all - a rename of the
xfs_trans_ail.c file to xfs_ail.c needs to be done, the APIs need to
be renamed, and an xfs_ail.h needs to be created to expose the
-minimal- API needed for external interfacing with the AIL and get
all that stuff out of xfs_trans_priv.h.

Similarly, all the log reservation, ticket and grant head
reservation stuff needs to be moved out of xfs_log.c and into it's
own file source and header files.

xfs_log.h then should only include external interfaces to the log
(i.e. external calls from xfs_mount context into internal xlog
context) and xfs_log_priv.h only contains internal xlog context
structures and APIs.

Then we can separate the struct xfs_log_item and all the log item
futzing out of xfs_trans.h into xfs_log_item.h.

At the end of this, xfs_trans_priv.h should go away entirely,
xfs_trans.h is only used in front end transaction code,
xfs_log_item.h is only used back end transaction, CIL and AIL code,
xfs_log.h is only needed by the few places in high level code that
interface directly with the log, etc.

You can probably see me starting this re-org in this patchset by
moving and renaming the AIL bulk insert function - it has nothing to
do with transactions, but it is tightly intertwined with internal
CIL structures (the lv chain), log items and the AIL. Hence it
belongs in the CIL code, not the transaction code....

> > +int xlog_space_left(struct xlog	 *log, atomic64_t *head);
> 
> Nit: odd formatting with the tab before the *log.
> 
> > +xfs_lsn_t
> > +__xfs_ail_push_target(
> > +	struct xfs_ail		*ailp)
> > +{
> > +	struct xlog	*log = ailp->ail_log;
> > +	xfs_lsn_t	threshold_lsn = 0;
> > +	xfs_lsn_t	last_sync_lsn;
> > +	int		free_blocks;
> > +	int		free_bytes;
> > +	int		threshold_block;
> > +	int		threshold_cycle;
> > +	int		free_threshold;
> 
> This culd use a:
> 
> 	lockdep_assert_held(&ailp->ail_lock);
> 
> to document the locking assumptions.
> 
> > +	free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
> > +	free_blocks = BTOBBT(free_bytes);
> > +
> > +	/*
> > +	 * Set the threshold for the minimum number of free blocks in the
> > +	 * log to the maximum of what the caller needs, one quarter of the
> > +	 * log, and 256 blocks.
> > +	 */
> > +	free_threshold = log->l_logBBsize >> 2;
> > +	if (free_blocks >= free_threshold)
> 
> Nit: free_block is only used once, so there might not be much in a point
> in keeping it as a logcal variable.

Sure, but this all ends up changing
> 
> > +static inline void xfs_ail_push(struct xfs_ail *ailp)
> > +{
> > +	wake_up_process(ailp->ail_task);
> > +}
> > +
> > +static inline void xfs_ail_push_all(struct xfs_ail *ailp)
> > +{
> > +	if (!test_and_set_bit(XFS_AIL_OPSTATE_PUSH_ALL, &ailp->ail_opstate))
> > +		xfs_ail_push(ailp);
> > +}
> > +
> > +xfs_lsn_t		__xfs_ail_push_target(struct xfs_ail *ailp);
> > +static inline xfs_lsn_t xfs_ail_push_target(struct xfs_ail *ailp)
> > +{
> > +	xfs_lsn_t	lsn;
> > +
> > +	spin_lock(&ailp->ail_lock);
> > +	lsn = __xfs_ail_push_target(ailp);
> > +	spin_unlock(&ailp->ail_lock);
> > +	return lsn;
> > +}
> 
> Is there really any point in micro-optimizing these as inlines in
> a header?

It's not micro-optimisation - it's simply retaining the existing API
to reduce the amount of cognitive effort needed to understand the
accounting changes in the patchset. That's the important thing here
- the patch set is making a fundamental accounting change to
changing a core, proven algorithm that has been in production for
a couple of years short of 3 decades....

And keep in mind that, as per above, changing the API will come with
restructuring the code, so it's not something I want to change right
now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
