Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16754 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932635AbdERQyF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2017 12:54:05 -0400
Date: Thu, 18 May 2017 09:53:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: avoid mount-time deadlock in CoW extent recovery
Message-ID: <20170518165358.GZ4519@birch.djwong.org>
References: <20170517010728.GS4519@birch.djwong.org>
 <20170518115306.GA18240@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170518115306.GA18240@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>

On Thu, May 18, 2017 at 07:53:06AM -0400, Brian Foster wrote:
> On Tue, May 16, 2017 at 06:07:28PM -0700, Darrick J. Wong wrote:
> > If a malicious user corrupts the refcount btree to cause a cycle between
> > different levels of the tree, the next mount attempt will deadlock in
> > the CoW recovery routine while grabbing buffer locks.  We can use the
> > ability to re-grab a buffer that was previous locked to a transaction to
> > avoid deadlocks, so do that here.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: leave a comment discussing why we use an empty transaction
> > ---
> >  fs/xfs/libxfs/xfs_refcount.c |   39 +++++++++++++++++++++++++++++----------
> >  1 file changed, 29 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> > index b177ef3..3d2b29b 100644
> > --- a/fs/xfs/libxfs/xfs_refcount.c
> > +++ b/fs/xfs/libxfs/xfs_refcount.c
> ...
> > @@ -1676,8 +1691,15 @@ xfs_refcount_recover_cow_leftovers(
> >  		error = xfs_trans_commit(tp);
> >  		if (error)
> >  			goto out_free;
> > +
> > +		list_del(&rr->rr_list);
> > +		kmem_free(rr);
> >  	}
> >  
> > +	return error;
> > +out_defer:
> > +	xfs_defer_cancel(&dfops);
> > +	xfs_trans_cancel(tp);
> >  out_free:
> >  	/* Free the leftover list */
> >  	list_for_each_entry_safe(rr, n, &debris, rr_list) {
> > @@ -1688,11 +1710,8 @@ xfs_refcount_recover_cow_leftovers(
> >  
> >  out_cursor:
> >  	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> > -	xfs_buf_relse(agbp);
> > -	goto out_free;
> > -
> 
> Previously we had this jump to out_free here which presumably would
> handle the case of a query range error with a populated list. Now it
> looks like we just break down the cursor/transaction and return. Is that
> case not possible?

Oops, yeah, I'll go refactor the exit paths again.  Thanks for catching this.

--D

> 
> Brian
> 
> > -out_defer:
> > -	xfs_defer_cancel(&dfops);
> > +	xfs_trans_brelse(tp, agbp);
> > +out_trans:
> >  	xfs_trans_cancel(tp);
> > -	goto out_free;
> > +	return error;
> >  }
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
