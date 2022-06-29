Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0948C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 21:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbiF2Vms (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 17:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiF2Vmr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 17:42:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598C837A17
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 14:42:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E477FB82779
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 21:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908F6C34114;
        Wed, 29 Jun 2022 21:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656538963;
        bh=lq6cw4xKGX3UBPUgEn2el/5XQvxudlfTq8Ww4MFc2XE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nHvG0lfNVTARcRLDJVeqxLsh0qrjZaTxxQs1Z6oGVZrSKouywwLeiDtVjw6glW7D6
         K9gJNYpwb+AitgjFhJ4D/jW4KLjtUMKU81fm/bCG3/mwHKOsEfaTy+LK1u6chut8XJ
         4q2NM4qoVo+WIXLKquwiTosnBickBFt4WgebXjkJJz6AGKBbrb4JLoLHtlGoFjbvh2
         FpRi9sXcGZBcX4ErjBuUtrDTuQfnb6M3LNMYpZEGG+qklePnlWA47V95bzpA0z/Bmj
         N50CfJBtq9Dhb9wHyxH8KiOWp7mWFuRQacUN6klwMptbKMSduqyE/oU5+FrUO5ELEI
         oyxXjaw3/DrXw==
Date:   Wed, 29 Jun 2022 14:42:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: add log item precommit operation
Message-ID: <YrzHU53bLN/4komZ@magnolia>
References: <20220627004336.217366-1-david@fromorbit.com>
 <20220627004336.217366-9-david@fromorbit.com>
 <YrzBEwKCEwa+aFie@magnolia>
 <20220629213437.GX227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629213437.GX227878@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 30, 2022 at 07:34:37AM +1000, Dave Chinner wrote:
> On Wed, Jun 29, 2022 at 02:16:03PM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 27, 2022 at 10:43:35AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > For inodes that are dirty, we have an attached cluster buffer that
> > > we want to use to track the dirty inode through the AIL.
> > > Unfortunately, locking the cluster buffer and adding it to the
> > > transaction when the inode is first logged in a transaction leads to
> > > buffer lock ordering inversions.
> > > 
> > > The specific problem is ordering against the AGI buffer. When
> > > modifying unlinked lists, the buffer lock order is AGI -> inode
> > > cluster buffer as the AGI buffer lock serialises all access to the
> > > unlinked lists. Unfortunately, functionality like xfs_droplink()
> > > logs the inode before calling xfs_iunlink(), as do various directory
> > > manipulation functions. The inode can be logged way down in the
> > > stack as far as the bmapi routines and hence, without a major
> > > rewrite of lots of APIs there's no way we can avoid the inode being
> > > logged by something until after the AGI has been logged.
> > > 
> > > As we are going to be using ordered buffers for inode AIL tracking,
> > > there isn't a need to actually lock that buffer against modification
> > > as all the modifications are captured by logging the inode item
> > > itself. Hence we don't actually need to join the cluster buffer into
> > > the transaction until just before it is committed. This means we do
> > > not perturb any of the existing buffer lock orders in transactions,
> > > and the inode cluster buffer is always locked last in a transaction
> > > that doesn't otherwise touch inode cluster buffers.
> > > 
> > > We do this by introducing a precommit log item method. A log item
> > > method is used because it is likely dquots will be moved to this
> > > same ordered buffer tracking scheme and hence will need a similar
> > 
> > Oh?
> 
> Stale comment from the original series a couple of year ago, I
> think.

aha!

> > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > index 82cf0189c0db..0acb31093d9f 100644
> > > --- a/fs/xfs/xfs_trans.c
> > > +++ b/fs/xfs/xfs_trans.c
> > > @@ -844,6 +844,90 @@ xfs_trans_committed_bulk(
> > >  	spin_unlock(&ailp->ail_lock);
> > >  }
> > >  
> > > +/*
> > > + * Sort transaction items prior to running precommit operations. This will
> > > + * attempt to order the items such that they will always be locked in the same
> > > + * order. Items that have no sort function are moved to the end of the list
> > > + * and so are locked last (XXX: need to check the logic matches the comment).
> > > + *
> > > + * This may need refinement as different types of objects add sort functions.
> > > + *
> > > + * Function is more complex than it needs to be because we are comparing 64 bit
> > > + * values and the function only returns 32 bit values.
> > > + */
> > > +static int
> > > +xfs_trans_precommit_sort(
> > > +	void			*unused_arg,
> > > +	const struct list_head	*a,
> > > +	const struct list_head	*b)
> > > +{
> > > +	struct xfs_log_item	*lia = container_of(a,
> > > +					struct xfs_log_item, li_trans);
> > > +	struct xfs_log_item	*lib = container_of(b,
> > > +					struct xfs_log_item, li_trans);
> > > +	int64_t			diff;
> > > +
> > > +	/*
> > > +	 * If both items are non-sortable, leave them alone. If only one is
> > > +	 * sortable, move the non-sortable item towards the end of the list.
> > > +	 */
> > > +	if (!lia->li_ops->iop_sort && !lib->li_ops->iop_sort)
> > > +		return 0;
> > > +	if (!lia->li_ops->iop_sort)
> > > +		return 1;
> > > +	if (!lib->li_ops->iop_sort)
> > > +		return -1;
> > > +
> > > +	diff = lia->li_ops->iop_sort(lia) - lib->li_ops->iop_sort(lib);
> > 
> > I'm kinda surprised the iop_sort method doesn't take both log item
> > pointers, like most sorting-comparator functions?  But I'll see, maybe
> > you're doing something clever wrt ordering of log items of differing
> > types, and hence the ->iop_sort implementations are required to return
> > some absolute priority or something.
> 
> Nope, we have to order item locking based on an unchanging
> characteristic of the object. log items can come and go, we want to
> lock items in consistent ascending order, so it has to be based on
> some kind of physical characteristic, like inode number, block
> address, etc.
> 
> e.g. If all objects are ordered by the physical location, we naturally
> get a lock order that can be applied sanely across differing object
> types e.g. AG headers will naturally sort and lock before buffers
> in the AG itself. e.g. inode cluster buffers for unlinked list
> manipulations will always get locked after the AGI....

<nod> So if (say) we were going to add dquots to this scheme, we'd
probably want to shift all the iop_sort functions to return (say) the
xfs_daddr_t of the associated item?

(Practically speaking, I don't know that I'd want to tie things down to
the disk address quite this soon, and since it's all incore code anyway
I don't think the precise type of the return values matter.)

Anyway, I'm satisfied--
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> Cheers,
> 
> Dave.
> > --D
> > 
> > > +	if (diff < 0)
> > > +		return -1;
> > > +	if (diff > 0)
> > > +		return 1;
> > > +	return 0;
> > > +}
> > > +
> > > +/*
> > > + * Run transaction precommit functions.
> > > + *
> > > + * If there is an error in any of the callouts, then stop immediately and
> > > + * trigger a shutdown to abort the transaction. There is no recovery possible
> > > + * from errors at this point as the transaction is dirty....
> > > + */
> > > +static int
> > > +xfs_trans_run_precommits(
> > > +	struct xfs_trans	*tp)
> > > +{
> > > +	struct xfs_mount	*mp = tp->t_mountp;
> > > +	struct xfs_log_item	*lip, *n;
> > > +	int			error = 0;
> > > +
> > > +	/*
> > > +	 * Sort the item list to avoid ABBA deadlocks with other transactions
> > > +	 * running precommit operations that lock multiple shared items such as
> > > +	 * inode cluster buffers.
> > > +	 */
> > > +	list_sort(NULL, &tp->t_items, xfs_trans_precommit_sort);
> > > +
> > > +	/*
> > > +	 * Precommit operations can remove the log item from the transaction
> > > +	 * if the log item exists purely to delay modifications until they
> > > +	 * can be ordered against other operations. Hence we have to use
> > > +	 * list_for_each_entry_safe() here.
> > > +	 */
> > > +	list_for_each_entry_safe(lip, n, &tp->t_items, li_trans) {
> > > +		if (!test_bit(XFS_LI_DIRTY, &lip->li_flags))
> > > +			continue;
> > > +		if (lip->li_ops->iop_precommit) {
> > > +			error = lip->li_ops->iop_precommit(tp, lip);
> > > +			if (error)
> > > +				break;
> > > +		}
> > > +	}
> > > +	if (error)
> > > +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > > +	return error;
> > > +}
> > > +
> > >  /*
> > >   * Commit the given transaction to the log.
> > >   *
> > > @@ -869,6 +953,13 @@ __xfs_trans_commit(
> > >  
> > >  	trace_xfs_trans_commit(tp, _RET_IP_);
> > >  
> > > +	error = xfs_trans_run_precommits(tp);
> > > +	if (error) {
> > > +		if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
> > > +			xfs_defer_cancel(tp);
> > > +		goto out_unreserve;
> > > +	}
> > > +
> > >  	/*
> > >  	 * Finish deferred items on final commit. Only permanent transactions
> > >  	 * should ever have deferred ops.
> > > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > > index 9561f193e7e1..64062e3b788b 100644
> > > --- a/fs/xfs/xfs_trans.h
> > > +++ b/fs/xfs/xfs_trans.h
> > > @@ -71,10 +71,12 @@ struct xfs_item_ops {
> > >  	void (*iop_format)(struct xfs_log_item *, struct xfs_log_vec *);
> > >  	void (*iop_pin)(struct xfs_log_item *);
> > >  	void (*iop_unpin)(struct xfs_log_item *, int remove);
> > > -	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
> > > +	uint64_t (*iop_sort)(struct xfs_log_item *lip);
> > > +	int (*iop_precommit)(struct xfs_trans *tp, struct xfs_log_item *lip);
> > >  	void (*iop_committing)(struct xfs_log_item *lip, xfs_csn_t seq);
> > > -	void (*iop_release)(struct xfs_log_item *);
> > >  	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
> > > +	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
> > > +	void (*iop_release)(struct xfs_log_item *);
> > 
> > Why did these get moved?
> 
> <shrug> reasons lost in the mist of times. Probably because I wanted
> the sort->precommit->committing->committed to be listed in the order
> they are actually called by a transaciton commit?
> 
> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
