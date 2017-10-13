Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38601 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750872AbdJMQVQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2017 12:21:16 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9DGLFUJ006844
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 13 Oct 2017 16:21:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9DGLFNA030910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 13 Oct 2017 16:21:15 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9DGLFKN009801
        for <linux-xfs@vger.kernel.org>; Fri, 13 Oct 2017 16:21:15 GMT
Date: Fri, 13 Oct 2017 09:21:14 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] xfs: Properly retry failed dquot items in case of
 error during buffer writeback
Message-ID: <20171013162114.GP7122@magnolia>
References: <20170825120752.22553-1-cmaiolino@redhat.com>
 <20170825170400.GS4796@magnolia>
 <20170825215701.GT4796@magnolia>
 <20170828092030.l5z2hruccr7ctvl3@hades.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170828092030.l5z2hruccr7ctvl3@hades.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Mon, Aug 28, 2017 at 11:20:30AM +0200, Carlos Maiolino wrote:
> Hi Darrick.
> 
> 
> > > > BTW, This patch should be applied only over branch xfs-4.14-merge, it requires
> > > > my previous patches, which are not in the master branch yet.
> > > 
> > > Looks ok, but is there an xfstests case to cover this?
> > 
> 
> No,
> 
> I still don't have a xfstests to cover it, I couldn't reproduce the problem with
> dquots yet, I'll focus more on this soon.
> 
> > > >  	if ((lip->li_flags & XFS_LI_IN_AIL) &&
> > > > -	    lip->li_lsn == qip->qli_flush_lsn) {
> > > > +	   (lip->li_lsn == qip->qli_flush_lsn) ||
> > > > +	    lip->li_flags & XFS_LI_FAILED) {
> > 
> 
> > ...come to think of it, shouldn't there be a couple extra pairs of parentheses
> > in this somewhere?...
> > 
> IIRC there is no need, && has a higher precedenc over ||, but I really don't
> mind to add an extra pair of () here.
> 
> > > >  
> > > >  		/* xfs_trans_ail_delete() drops the AIL lock. */
> > > >  		spin_lock(&ailp->xa_lock);
> > > > -		if (lip->li_lsn == qip->qli_flush_lsn)
> > > > +		if (lip->li_lsn == qip->qli_flush_lsn) {
> > > >  			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
> > > > -		else
> > > > +		} else if (lip->li_flags & XFS_LI_FAILED) {
> > > > +			xfs_clear_li_failed(lip);
> > > >  			spin_unlock(&ailp->xa_lock);
> > > > +		} else {
> > > > +			spin_unlock(&ailp->xa_lock);
> > > > +		}
> > > >  	}
> > > >  
> > > >  	/*
> > > > diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> > > > index 2c7a1629e064..35fd6d71bc42 100644
> > > > --- a/fs/xfs/xfs_dquot_item.c
> > > > +++ b/fs/xfs/xfs_dquot_item.c
> > > > @@ -137,6 +137,23 @@ xfs_qm_dqunpin_wait(
> > > >  	wait_event(dqp->q_pinwait, (atomic_read(&dqp->q_pincount) == 0));
> > > >  }
> > > >  
> > > > +/*
> > > > + * Callback used to mark a buffer with XFS_LI_FAILED when items in the buffer
> > > > + * have been failed during writeback
> > > > + *
> > > > + * this informs the AIL that the dquot is already flush locked on the next push,
> > > > + * and acquires a hold on the buffer to ensure that it isn't reclaimed before
> > > > + * dirty data makes it to disk.
> > > > + */
> > > > +STATIC void
> > > > +xfs_dquot_item_error(
> > > > +	struct xfs_log_item	*lip,
> > > > +	struct xfs_buf		*bp)
> > > > +{
> > > > +	ASSERT(XFS_DQ_IS_LOCKED(DQUOT_ITEM(lip)->qli_item));
> > 
> > ...and isn't this qli_dquot, not qli_item?
> > 
> 
> Yup, you are right.
> 
> > (Does this compile at all?)
> > 
> 
> Yes, it compiled the way it was :P
> 
> I'll wait for some extra comments here, before submitting a non-RFC patch, and
> will think about how can I reproduce it on xfstests, maybe filling the
> filesystem and then playing with quotas.

Has there been a rework of this patch?

--D

> 
> Thanks for the review Darrick.
> 
> Cheers.
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
