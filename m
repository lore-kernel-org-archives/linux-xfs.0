Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51518 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751173AbeECXrc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 19:47:32 -0400
Date: Thu, 3 May 2018 16:47:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/10] xfs: get rid of the log item descriptor
Message-ID: <20180503234729.GG26569@magnolia>
References: <20180502080157.11386-1-david@fromorbit.com>
 <20180502080157.11386-11-david@fromorbit.com>
 <20180502200510.GA4127@magnolia>
 <20180502215343.GB23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180502215343.GB23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 03, 2018 at 07:53:43AM +1000, Dave Chinner wrote:
> On Wed, May 02, 2018 at 01:05:10PM -0700, Darrick J. Wong wrote:
> > On Wed, May 02, 2018 at 06:01:57PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > It's just a connector between a transaction and a log item. There's
> > > a 1:1 relationship between a log item descriptor and a log item,
> > > and a 1:1 relationship between a log item descriptor and a
> > > transaction. Both relationships are created and terminated at the
> > > same time, so why do we even have the descriptor?
> > > 
> > > Replace it with a specific list_head in the log item and a new
> > > log item dirtied flag to replace the XFS_LID_DIRTY flag.
> > > 
> > > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> .....
> > >  		/*
> > >  		 * Skip items that do not have any vectors for writing. These
> > >  		 * log items must now be considered clean in this transaction,
> > > -		 * so clear the XFS_LID_DIRTY flag to ensure it doesn't get
> > > +		 * so clear the XFS_LI_DIRTY flag to ensure it doesn't get
> > >  		 * added to the CIL by mistake.
> > >  		 */
> > >  		if (!shadow->lv_niovecs && !ordered) {
> > > -			lidp->lid_flags &= ~XFS_LID_DIRTY;
> > > +			clear_bit(XFS_LI_DIRTY, &lip->li_flags);
> > 
> > So this requires "xfs: handle inconsistent log item formatting state
> > correctly" as a prerequisite...
> 
> Ah, forgot that was sitting high up in the patch stack. It's not
> dependent on it - and I can't remember exactly what the state of
> that patch was.
> 
> ...
> > > @@ -633,7 +629,7 @@ xfs_trans_binval(
> > >  	bip->bli_flags |= XFS_BLI_STALE;
> > >  
> > >  	/* Mark the log item as dirty. */
> > > -	bip->bli_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> > > +	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
> > >  	tp->t_flags |= XFS_TRANS_DIRTY;
> > 
> > ...but even with that patch, this hunk doesn't apply.  I've never seen
> > the comment in any patch.  What are the prerequisites for this series?
> 
> Ah, I also have the buffer range logging patch in the series up near
> the top with the other patch. Again, not dependent, just got so many
> stalled patches in my tree that have been sitting around for ages
> that I've forgotten where there are dependencies. 
> 
> I'll have to do some more reordering...

Ok.  The series looks ok so far at a quick glance.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
