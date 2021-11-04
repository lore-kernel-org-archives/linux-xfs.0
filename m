Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E3F8C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 01:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B06F611CA
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 01:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhKDBcp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Nov 2021 21:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230198AbhKDBco (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Nov 2021 21:32:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3B0F604DC;
        Thu,  4 Nov 2021 01:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635989407;
        bh=inY9wFVb2pvq4N1STY3VyggQrwjqpw5wSnDOQW2NE3E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VdpXswJnUdUuiUHsIb/w2Mb57ebLfVN1JP2Ju3B+FAjhHNxdIE5gXMWFbIC+wLHJx
         Y3I3DbrLPlU+1iMOjRmh00sY0orFXTGdFz+HhLmDKoEYnYK2UoxDrb0nUSH3gVebjd
         HWLDsGcW5uX8Y+jCgtdHpvGKIguoeS4iuAZ37ZL33RijZe30WcuI+mGAcg9NyzYrYd
         voAp3Iuu1KrQQn60L88oDBIxzkbh6UjViOHMAky2tkXYjafrsPWsy3xTElLha4Y7Uw
         gw90EKgjOLWj6YDPMJu6Q1Rz06n5JbqbHfhhZlUk0M1auaGhAcVPxn3d8okOkD5JbG
         cdXE7mfQi2r6A==
Date:   Wed, 3 Nov 2021 18:30:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Fix double unlock in defer capture code
Message-ID: <20211104013007.GP24307@magnolia>
References: <20211103213309.824096-1-allison.henderson@oracle.com>
 <20211104001633.GD449541@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104001633.GD449541@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 04, 2021 at 11:16:33AM +1100, Dave Chinner wrote:
> On Wed, Nov 03, 2021 at 02:33:09PM -0700, Allison Henderson wrote:
> > The new deferred attr patch set uncovered a double unlock in the
> > recent port of the defer ops capture and continue code.  During log
> > recovery, we're allowed to hold buffers to a transaction that's being
> > used to replay an intent item.  When we capture the resources as part
> > of scheduling a continuation of an intent chain, we call xfs_buf_hold
> > to retain our reference to the buffer beyond the transaction commit,
> > but we do /not/ call xfs_trans_bhold to maintain the buffer lock.
> > This means that xfs_defer_ops_continue needs to relock the buffers
> > before xfs_defer_restore_resources joins then tothe new transaction.
> > 
> > Additionally, the buffers should not be passed back via the dres
> > structure since they need to remain locked unlike the inodes.  So
> > simply set dr_bufs to zero after populating the dres structure.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_defer.c | 40 ++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 39 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 0805ade2d300..734ac9fd2628 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> > @@ -22,6 +22,7 @@
> >  #include "xfs_refcount.h"
> >  #include "xfs_bmap.h"
> >  #include "xfs_alloc.h"
> > +#include "xfs_buf.h"
> >  
> >  static struct kmem_cache	*xfs_defer_pending_cache;
> >  
> > @@ -762,6 +763,33 @@ xfs_defer_ops_capture_and_commit(
> >  	return 0;
> >  }
> >  
> > +static void
> > +xfs_defer_relock_buffers(
> > +	struct xfs_defer_capture	*dfc)
> > +{
> > +	struct xfs_defer_resources	*dres = &dfc->dfc_held;
> > +	unsigned int			i, j;
> > +
> > +	/*
> > +	 * Sort the elements via bubble sort.  (Remember, there are at most 2
> > +	 * elements to sort, so this is adequate.)
> > +	 */
> 
> Seems like overkill if we only have two buffers that can be held.
> All we need if there are only two buffers is a swap() call.
> 
> However, locking arbitrary buffers based on disk address order is
> also theoretically incorrect.
> 
> For example, if the two buffers we have held the AGF and AGI buffers
> for a given AG, then this will lock the AGF before the AGI. However,
> the lock order for AGI vs AGF is AGI first, hence we'd be locking
> these buffers in the wrong order here. Another example is that btree
> buffers are generally locked in parent->child order or
> sibling->sibling order, not disk offset order.
> 
> Hence I'm wondering is this generalisation is a safe method of
> locking buffers.
> 
> In general, the first locked and joined buffer in a transaction is
> always the first that should be locked. Hence I suspect we need to
> ensure that the dres->dr_bp array always reflects the order in which
> buffers were joined to a transaction so that we can simply lock them
> in ascending array index order and not need to care what the
> relationship between the buffers are...

/me agrees with that; I think you ought to be able to skip the sort
entirely because the dr_bp array is loaded in order of the transaction
items, which means that we'd be locking them in the same order as the
transaction.

> > +	for (i = 0; i < dres->dr_bufs; i++) {
> > +		for (j = 1; j < dres->dr_bufs; j++) {
> > +			if (xfs_buf_daddr(dres->dr_bp[j]) <
> > +				xfs_buf_daddr(dres->dr_bp[j - 1])) {
> > +				struct xfs_buf  *temp = dres->dr_bp[j];
> > +
> > +				dres->dr_bp[j] = dres->dr_bp[j - 1];
> > +				dres->dr_bp[j - 1] = temp;
> > +			}
> > +		}
> > +	}
> > +
> > +	for (i = 0; i < dres->dr_bufs; i++)
> > +		xfs_buf_lock(dres->dr_bp[i]);
> > +}
> > +
> >  /*
> >   * Attach a chain of captured deferred ops to a new transaction and free the
> >   * capture structure.  If an inode was captured, it will be passed back to the
> > @@ -777,15 +805,25 @@ xfs_defer_ops_continue(
> >  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> >  	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
> >  
> > -	/* Lock and join the captured inode to the new transaction. */
> > +	/* Lock the captured resources to the new transaction. */
> >  	if (dfc->dfc_held.dr_inos == 2)
> >  		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
> >  				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
> >  	else if (dfc->dfc_held.dr_inos == 1)
> >  		xfs_ilock(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL);
> > +
> > +	xfs_defer_relock_buffers(dfc);
> > +
> > +	/* Join the captured resources to the new transaction. */
> >  	xfs_defer_restore_resources(tp, &dfc->dfc_held);
> >  	memcpy(dres, &dfc->dfc_held, sizeof(struct xfs_defer_resources));
> >  
> > +	/*
> > +	 * Inodes must be passed back to the log recovery code to be unlocked,
> > +	 * but buffers do not.  Ignore the captured buffers
> > +	 */
> > +	dres->dr_bufs = 0;
> 
> I'm not sure what this comment is supposed to indicate. This seems
> to be infrastructure specific to log recovery, not general runtime
> functionality, but even in that context I don't really understand
> what it means or why it is done...

The defer_capture machinery picks up inodes that were ijoined with
lock_flags==0 (i.e. caller will unlock explicitly), which is why they
have to be passed back out after the entire transaction sequence
completes.

By contrast, the defer capture machinery picks up buffers with BLI_HOLD
set on the log item.  These are only meant to maintain the hold across
the next transaction roll (or the next defer_finish invocation), which
means that the caller is responsible for unlocking and releasing the
buffer (or I guess re-holding it) during that next transaction.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
