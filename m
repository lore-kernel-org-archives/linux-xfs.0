Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50315C19F2D
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Aug 2022 01:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiHJB6j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 21:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiHJB6O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 21:58:14 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 586757E322
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 18:58:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-193-158.pa.nsw.optusnet.com.au [49.181.193.158])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8279162D086;
        Wed, 10 Aug 2022 11:58:11 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oLaz3-00BGIy-I0; Wed, 10 Aug 2022 11:58:09 +1000
Date:   Wed, 10 Aug 2022 11:58:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v2 01/18] xfs: Fix multi-transaction larp replay
Message-ID: <20220810015809.GK3600936@dread.disaster.area>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
 <20220804194013.99237-2-allison.henderson@oracle.com>
 <YvKQ5+XotiXFDpTA@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvKQ5+XotiXFDpTA@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62f310b3
        a=SeswVvpAPK2RnNNwqI8AaA==:117 a=SeswVvpAPK2RnNNwqI8AaA==:17
        a=kj9zAlcOel0A:10 a=biHskzXt2R4A:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=4qbWr1NDMORvN67zLPUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 09, 2022 at 09:52:55AM -0700, Darrick J. Wong wrote:
> On Thu, Aug 04, 2022 at 12:39:56PM -0700, Allison Henderson wrote:
> > Recent parent pointer testing has exposed a bug in the underlying
> > attr replay.  A multi transaction replay currently performs a
> > single step of the replay, then deferrs the rest if there is more
> > to do.

Yup.

> > This causes race conditions with other attr replays that
> > might be recovered before the remaining deferred work has had a
> > chance to finish.

What other attr replays are we racing against?  There can only be
one incomplete attr item intent/done chain per inode present in log
recovery, right?

> > This can lead to interleaved set and remove
> > operations that may clobber the attribute fork.  Fix this by
> > deferring all work for any attribute operation.

Which means this should be an impossible situation.

That is, if we crash before the final attrd DONE intent is written
to the log, it means that new attr intents for modifications made
*after* the current attr modification was completed will not be
present in the log. We have strict ordering of committed operations
in the journal, hence an operation on an inode has an incomplete
intent *must* be the last operation and the *only* incomplete intent
that is found in the journal for that inode.

Hence from an operational ordering persepective, this explanation
for issue being seen doesn't make any sense to me.  If there are
multiple incomplete attri intents then we've either got a runtime
journalling problem (a white-out issue? failing to relog the inode
in each new intent?) or a log recovery problem (failing to match
intent-done pairs correctly?), not a recovery deferral issue.

Hence I think we're still looking for the root cause of this
problem...

> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/xfs_attr_item.c | 35 ++++++++---------------------------
> >  1 file changed, 8 insertions(+), 27 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> > index 5077a7ad5646..c13d724a3e13 100644
> > --- a/fs/xfs/xfs_attr_item.c
> > +++ b/fs/xfs/xfs_attr_item.c
> > @@ -635,52 +635,33 @@ xfs_attri_item_recover(
> >  		break;
> >  	case XFS_ATTRI_OP_FLAGS_REMOVE:
> >  		if (!xfs_inode_hasattr(args->dp))
> > -			goto out;
> > +			return 0;
> >  		attr->xattri_dela_state = xfs_attr_init_remove_state(args);
> >  		break;
> >  	default:
> >  		ASSERT(0);
> > -		error = -EFSCORRUPTED;
> > -		goto out;
> > +		return -EFSCORRUPTED;
> >  	}
> >  
> >  	xfs_init_attr_trans(args, &tres, &total);
> >  	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
> >  	if (error)
> > -		goto out;
> > +		return error;
> >  
> >  	args->trans = tp;
> >  	done_item = xfs_trans_get_attrd(tp, attrip);
> > +	args->trans->t_flags |= XFS_TRANS_HAS_INTENT_DONE;
> > +	set_bit(XFS_LI_DIRTY, &done_item->attrd_item.li_flags);
> >  
> >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> >  	xfs_trans_ijoin(tp, ip, 0);
> >  
> > -	error = xfs_xattri_finish_update(attr, done_item);
> > -	if (error == -EAGAIN) {
> > -		/*
> > -		 * There's more work to do, so add the intent item to this
> > -		 * transaction so that we can continue it later.
> > -		 */
> > -		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
> > -		error = xfs_defer_ops_capture_and_commit(tp, capture_list);
> > -		if (error)
> > -			goto out_unlock;
> > -
> > -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > -		xfs_irele(ip);
> > -		return 0;
> > -	}
> > -	if (error) {
> > -		xfs_trans_cancel(tp);
> > -		goto out_unlock;
> > -	}
> > -
> > +	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
> 
> This seems a little convoluted to me.  Maybe?  Maybe not?
> 
> 1. Log recovery recreates an incore xfs_attri_log_item from what it
> finds in the log.
> 
> 2. This function then logs an xattrd for the recovered xattri item.
> 
> 3. Then it creates a new xfs_attr_intent to complete the operation.
> 
> 4. Finally, it calls xfs_defer_ops_capture_and_commit, which logs a new
> xattri for the intent created in step 3 and also commits the xattrd for
> the first xattri.
> 
> IOWs, the only difference between before and after is that we're not
> advancing one more step through the state machine as part of log
> recovery.  From the perspective of the log, the recovery function merely
> replaces the recovered xattri log item with a new one.
> 
> Why can't we just attach the recovered xattri to the xfs_defer_pending
> that is created to point to the xfs_attr_intent that's created in step
> 3, and skip the xattrd?

Remember that attribute intents are different to all other intent
types that we have. The existing extent based intents define a
single indepedent operation that needs to be performed, and each
step of the intent chain is completely independent of the previous
step in the chain.  e.g. removing the extent from the rmap btree is
completely independent of removing it from the inode bmap btree -
all that matters is that the removal from the bmbt happens first.
The rmapbt removal can happen at any time after than, and is
completely independent of any other bmbt or rmapbt operation.
Similarly, the EFI can processed independently of all bmapbt and
rmapbt modifications, it just has to happen after those
modifications are done.

Hence if we crash during recovery, we can just restart from
where-ever we got to in the middle of the intent chains and not have
to care at all.  IOWs, eventual consistency works with these chains
because there is no dependencies between each step of the intent
chain and each step is completely independent of the other steps.

Attribute intent chains are completely different. They link steps in
a state machine together in a non-trivial, highly dependent chain.
We can't just restart the chain in the middle like we can for the
BUI->RUI->CUI->EFI chain because the on-disk attribute is in an
unknown state and recovering that exact state is .... complex.

Hence the the first step of recovery is to return the attribute we
are trying to modify back to a known state. That means we have to
perform a removal of any existing attribute under that name first.
Hence this first step should be replacing the existing attr intent
with the intent that defines the recovery operation we are going to
perform.

That means we need to translate set to replace so that cleanup is
run first, replace needs to clean up the attr under that name
regardless of whether it has the incomplete bit set on it or not.
Remove is the only operation that runs the same as at runtime, as
cleanup for remove is just repeating the remove operation from
scratch.

> I /think/ the answer to that question is that we might need to move the
> log tail forward to free enough log space to finish the intent items, so
> creating the extra xattrd/xattri (a) avoid the complexity of submitting
> an incore intent item *and* a log intent item to the defer ops
> machinery; and (b) avoid livelocks in log recovery.  Therefore, we
> actually need to do it this way.

We really need the initial operation to rewrite the intent to match
the recovery operation we are going to perform. Everything else is
secondary.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
