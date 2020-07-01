Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9760C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 22:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DE95207E8
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 22:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgGAWCM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 18:02:12 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:50955 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727797AbgGAWCL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 18:02:11 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id D5EABD7BBD2;
        Thu,  2 Jul 2020 08:02:08 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jqknv-0000fY-BU; Thu, 02 Jul 2020 08:02:07 +1000
Date:   Thu, 2 Jul 2020 08:02:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: add log item precommit operation
Message-ID: <20200701220207.GU2005@dread.disaster.area>
References: <20200623095015.1934171-1-david@fromorbit.com>
 <20200623095015.1934171-3-david@fromorbit.com>
 <20200701143057.GA1087@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701143057.GA1087@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=Jo_vxD5OwoT7-CZN0N8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 10:30:57AM -0400, Brian Foster wrote:
> On Tue, Jun 23, 2020 at 07:50:13PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > For inodes that are dirty, we have an attached cluster buffer that
> > we want to use to track the dirty inode through the AIL.
> > Unfortunately, locking the cluster buffer and adding it to the
> > transaction when the inode is first logged in a transaction leads to
> > buffer lock ordering inversions.
> > 
> > The specific problem is ordering against the AGI buffer. When
> > modifying unlinked lists, the buffer lock order is AGI -> inode
> > cluster buffer as the AGI buffer lock serialises all access to the
> > unlinked lists. Unfortunately, functionality like xfs_droplink()
> > logs the inode before calling xfs_iunlink(), as do various directory
> > manipulation functions. The inode can be logged way down in the
> > stack as far as the bmapi routines and hence, without a major
> > rewrite of lots of APIs there's no way we can avoid the inode being
> > logged by something until after the AGI has been logged.
> > 
> > As we are going to be using ordered buffers for inode AIL tracking,
> > there isn't a need to actually lock that buffer against modification
> > as all the modifications are captured by logging the inode item
> > itself. Hence we don't actually need to join the cluster buffer into
> > the transaction until just before it is committed. This means we do
> > not perturb any of the existing buffer lock orders in transactions,
> > and the inode cluster buffer is always locked last in a transaction
> > that doesn't otherwise touch inode cluster buffers.
> > 
> > We do this by introducing a precommit log item method. A log item
> > method is used because it is likely dquots will be moved to this
> > same ordered buffer tracking scheme and hence will need a similar
> > callout. This commit just introduces the mechanism; the inode item
> > implementation is in followup commits.
> > 
> > The precommit items need to be sorted into consistent order as we
> > may be locking multiple items here. Hence if we have two dirty
> > inodes in cluster buffers A and B, and some other transaction has
> > two separate dirty inodes in the same cluster buffers, locking them
> > in different orders opens us up to ABBA deadlocks. Hence we sort the
> > items on the transaction based on the presence of a sort log item
> > method.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Seems like a nice abstraction, particularly when you consider the other
> use cases you described that should fall into place over time. A couple
> minor comments..
> 
> >  fs/xfs/xfs_icache.c |  1 +
> >  fs/xfs/xfs_trans.c  | 90 +++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_trans.h  |  6 ++-
> >  3 files changed, 95 insertions(+), 2 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 3c94e5ff4316..6f350490f84b 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -799,6 +799,89 @@ xfs_trans_committed_bulk(
> >  	spin_unlock(&ailp->ail_lock);
> >  }
> >  
> > +/*
> > + * Sort transaction items prior to running precommit operations. This will
> > + * attempt to order the items such that they will always be locked in the same
> > + * order. Items that have no sort function are moved to the end of the list
> > + * and so are locked last (XXX: need to check the logic matches the comment).
> > + *
> 
> Heh, I was going to ask what the expected behavior was with the various
> !iop_sort() cases and whether we can really expect those items to be
> isolated at the end of the list.
> 
> > + * This may need refinement as different types of objects add sort functions.
> > + *
> > + * Function is more complex than it needs to be because we are comparing 64 bit
> > + * values and the function only returns 32 bit values.
> > + */
> > +static int
> > +xfs_trans_precommit_sort(
> > +	void			*unused_arg,
> > +	struct list_head	*a,
> > +	struct list_head	*b)
> > +{
> > +	struct xfs_log_item	*lia = container_of(a,
> > +					struct xfs_log_item, li_trans);
> > +	struct xfs_log_item	*lib = container_of(b,
> > +					struct xfs_log_item, li_trans);
> > +	int64_t			diff;
> > +
> > +	if (!lia->li_ops->iop_sort && !lib->li_ops->iop_sort)
> > +		return 0;
> > +	if (!lia->li_ops->iop_sort)
> > +		return 1;
> > +	if (!lib->li_ops->iop_sort)
> > +		return -1;
> 
> I'm a little confused on what these values are supposed to mean if one
> of the two items is non-sortable. Is the purpose of this simply to move
> sortable items to the head and non-sortable toward the tail, as noted
> above?

If the log item doesn't have a sort function, it implies the object
is already locked and modified and there's no pre-commit operation
going to be performed on it. In that case, I decided to move them to
the tail of the list so that it would be easier to verify that the
items that need sorting were, indeed, sorted into the correct order.

The choice was arbitrary - the could be moved to the head of the
list or they could be left where they are any everything else is
ordered around them, but I went for the behaviour that it easy to
verify visually with debug output or via a list walk in a debugger...

> > +static int
> > +xfs_trans_run_precommits(
> > +	struct xfs_trans	*tp)
> > +{
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	struct xfs_log_item	*lip, *n;
> > +	int			error = 0;
> > +
> > +	if (XFS_FORCED_SHUTDOWN(mp))
> > +		return -EIO;
> > +
> 
> I'd rather not change behavior here. This effectively overrides the
> shutdown check in the caller because we get here regardless of whether
> the transaction has any pre-commit callouts or not. It seems like this
> is unnecessary, at least for the time being, if the precommit is
> primarily focused on sorting.

I put that there because if we are already shut down then there's no
point in even sorting or running pre-commits - they are going to
error out trying to access the objects they need to modify anyway.

It really isn't critical, just seemed superfluous to run code that
we already know will be cancelled and/or error out...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
