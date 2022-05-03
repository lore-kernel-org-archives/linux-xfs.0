Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F67C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 06:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiECGrA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 02:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiECGrA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 02:47:00 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A91481008
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 23:43:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 846B910E60CA;
        Tue,  3 May 2022 16:43:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nlmFm-007QME-Q8; Tue, 03 May 2022 16:43:22 +1000
Date:   Tue, 3 May 2022 16:43:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Alli <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/16] xfs: switch attr remove to xfs_attri_set_iter
Message-ID: <20220503064322.GX1098723@dread.disaster.area>
References: <20220414094434.2508781-1-david@fromorbit.com>
 <20220414094434.2508781-14-david@fromorbit.com>
 <982e97f354d087b12e72e4a0c158fac30420fdf3.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <982e97f354d087b12e72e4a0c158fac30420fdf3.camel@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6270cf0c
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=XyvWQXIMFkdlmwCnEwYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 05:34:36PM -0700, Alli wrote:
> On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that xfs_attri_set_iter() has initial states for removing
> > attributes, switch the pure attribute removal code over to using it.
> > This requires attrs being removed to always be marked as INCOMPLETE
> > before we start the removal due to the fact we look up the attr to
> > remove again in xfs_attr_node_remove_attr().
> > 
> > Note: this drops the fillstate/refillstate optimisations from
> > the remove path that avoid having to look up the path again after
> > setting the incomplete flag and removeing remote attrs. Restoring
> > that optimisation to this path is future Dave's problem.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c | 26 +++++++++++++++-----------
> >  fs/xfs/xfs_attr_item.c   | 27 ++++++---------------------
> >  2 files changed, 21 insertions(+), 32 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 8665b74ddfaf..ccc72c0c3cf5 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -507,13 +507,11 @@ int xfs_attr_node_removename_setup(
> >  	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
> >  		XFS_ATTR_LEAF_MAGIC);
> >  
> > -	if (args->rmtblkno > 0) {
> > -		error = xfs_attr_leaf_mark_incomplete(args, *state);
> > -		if (error)
> > -			goto out;
> > -
> > +	error = xfs_attr_leaf_mark_incomplete(args, *state);
> > +	if (error)
> > +		goto out;
> > +	if (args->rmtblkno > 0)
> >  		error = xfs_attr_rmtval_invalidate(args);
> > -	}
> >  out:
> >  	if (error)
> >  		xfs_da_state_free(*state);
> > @@ -954,6 +952,13 @@ xfs_attr_remove_deferred(
> >  	if (error)
> >  		return error;
> >  
> > +	if (xfs_attr_is_shortform(args->dp))
> > +		new->xattri_dela_state = XFS_DAS_SF_REMOVE;
> > +	else if (xfs_attr_is_leaf(args->dp))
> > +		new->xattri_dela_state = XFS_DAS_LEAF_REMOVE;
> > +	else
> > +		new->xattri_dela_state = XFS_DAS_NODE_REMOVE;
> > +
> Mmmm, same issue here as in patch 4, this initial state configs would
> get missed during a replay since these routines are only used in the
> delayed attr code path, not the replay code path.

*nod*

I'm working on fixing this right now.

> > @@ -311,20 +308,9 @@ xfs_xattri_finish_update(
> >  		goto out;
> >  	}
> >  
> > -	switch (op) {
> > -	case XFS_ATTR_OP_FLAGS_SET:
> > -		error = xfs_attr_set_iter(attr);
> > -		if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
> > -			error = -EAGAIN;
> > -		break;
> > -	case XFS_ATTR_OP_FLAGS_REMOVE:
> > -		ASSERT(XFS_IFORK_Q(args->dp));
> > -		error = xfs_attr_remove_iter(attr);
> > -		break;
> > -	default:
> > -		error = -EFSCORRUPTED;
> > -		break;
> > -	}
> > +	error = xfs_attr_set_iter(attr);
> > +	if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
> > +		error = -EAGAIN;
> >  
> 
> The concern I have here is that op_flags is recorded and recovered from
> the log item (see xfs_attri_item_recover).  Where as xattri_dela_state
> is not.  What ever value was set in attr before the shut down would not
> be there upon recovery, and with out op_flag we wont know how to
> configure it.

Right, that's the real problem with the existing operational order
and intent contents - what is on disk and/or in the journal is not
consistent and is dependent on the state at which the operation
failed. hence to recover from this, we'd need to push the current
state into the intents as well.

That's pretty messy and nasty, and I'm trying to avoid that. This is
the reason why I've reworking the way the logged attribute is logged
and recovered in this series.

When we are doing a pure attr create, we have to consider:

- shortform create is a single transaction operation and so
  never leaves anything behind for recovery to clean up.
- leaf and node insertion of inline attributes are single
  transaction operations and never leave anything for
  recovery to clean up
- short-form to leaf and leaf to node operations roll the
  transaction without changing the attr contents, so if we
  crash after those conversions are committed, recovery only
  needs to create the new attr. IOWs, nothing to clean up
  before we run the create replay.
- creating a remote attr sets the INCOMPLETE flag on the new attr in
  when the name is inserted into the btree, and it is removed when
  the remote attr creation is complete. Hence there's a transient
  state in the journal where the attr is present but INCOMPLETE.

This last state is the problem - if recovery does not remove this
INCOMPLETE xattr, or it does not restart the recovery from the exact
point it failed, we will leave stale INCOMPLETE xattrs in the btree
whenever we recover from a crash. That leaves us with two choices;
either we:

- put a whole lot more state into the intent to enable exact
continuation of the operation (logging state and remote attr extent
target); or
- we just remove the INCOMPLETE xattr and run a normal create
  operation to recreate the entire xattr.


When we are doing a replace, we have similar state based problems -
did we crash during create or removal? IF we are doing the create
first, then we can crash with both a new incomplete and an old valid
xattr of the given name. ANd after we flip the flags over, we have
a new valid and an old incomplete old xattr, and like the create
state we can't tell which is which.

Now what do we do in recovery - which one is the one we have to
remove? Or do we have to remove both? We ahve the same problem as a
pure create - we don't know what to do without knowing the exact
state of the operation.

However, if we change the replace operation to do things in a
different order because we have an intent that stores the new attr
{name, value} pair, we can avoid this whole problem. THat isL

- log the new attr intent atomically with marking the existing attr
  INCOMPLETE.
- remove the old INCOMPLETE attr
- insert the new attr as per the pure create above

If we crash at any point during this operation, we will only ever
see a single INCOMPLETE entry under the name of the new attr,
regardless of whether we failed during the remove of the old xattr
of the create of the new xattr. And because of the intents, we'll
always have the new xattr name+val at recovery time.

Pure remove has the same problem - partial remove still needs
recovery to clean up, but we don't want partially removed xattrs to
ever be visible to userspace. Hence the logged remove operation is:

- log the new attr intent atomically with marking the existing attr
  INCOMPLETE.
- remove the old INCOMPLETE attr

And now the recovery operation is simply "remove the INCOMPLETE
xattr under the logged name".

IOWs, we now have the same recovery path for all three logged xattr
operations:

- remove the INCOMPLETE xattr under the logged name if it exists
  to return the attr fork to a known good state.
- for set/replace, create the new xattr that was logged in the
  intent.

To return to the original question, this means all recovery needs to
know is whether we are recovering a SET/REPLACE or a REMOVE
operation along with the logged xattr name/val pair from the intent.
We don't need to know what state we crashed in, nor do we need to
know partial setup/teardown target/state in the journal because all
we ever need to do to get back to a known good state is teardown
the existing INCOMPLETE xattr....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
