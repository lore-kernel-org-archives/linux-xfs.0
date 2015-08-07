Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E82ED7F56
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 17:45:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D564C304039
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 15:45:24 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jHCL0ZFBAzO8POvF for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 15:45:18 -0700 (PDT)
Date: Sat, 8 Aug 2015 08:45:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/11] xfs: fix efi/efd error handling to avoid fs
	shutdown hangs
Message-ID: <20150807224516.GF3902@dastard>
References: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
	<1438883072-28706-4-git-send-email-bfoster@redhat.com>
	<20150807004100.GD16638@dastard>
	<20150807120934.GC8322@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150807120934.GC8322@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 07, 2015 at 08:09:34AM -0400, Brian Foster wrote:
> On Fri, Aug 07, 2015 at 10:41:00AM +1000, Dave Chinner wrote:
> > On Thu, Aug 06, 2015 at 01:44:24PM -0400, Brian Foster wrote:
> > > diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> > > index 42c9b05..aceb54f 100644
> > > --- a/fs/xfs/xfs_extfree_item.c
> > > +++ b/fs/xfs/xfs_extfree_item.c
> > > @@ -61,9 +61,15 @@ __xfs_efi_release(
> > >  
> > >  	if (atomic_dec_and_test(&efip->efi_refcount)) {
> > >  		spin_lock(&ailp->xa_lock);
> > > -		/* xfs_trans_ail_delete() drops the AIL lock. */
> > > -		xfs_trans_ail_delete(ailp, &efip->efi_item,
> > > -				     SHUTDOWN_LOG_IO_ERROR);
> > > +		/*
> > > +		 * We don't know whether the EFI made it to the AIL. Remove it
> > > +		 * if so. Note that xfs_trans_ail_delete() drops the AIL lock.
> > > +		 */
> > > +		if (efip->efi_item.li_flags & XFS_LI_IN_AIL)
> > > +			xfs_trans_ail_delete(ailp, &efip->efi_item,
> > > +					     SHUTDOWN_LOG_IO_ERROR);
> > > +		else
> > > +			spin_unlock(&ailp->xa_lock);
> > >  		xfs_efi_item_free(efip);
> > >  	}
> > 
> > We now have a lot of this pattern:
> > 
> > 	spin_lock(&ailp->xa_lock);
> > 	if (lip->li_flags & XFS_LI_IN_AIL)
> > 		xfs_trans_ail_delete(ailp, lip, shutdown_reason);
> > 	else
> > 		spin_unlock(&ailp->xa_lock);
> > 
> > occurring in the code. Can you look into adding a helper function
> > for this, say xfs_trans_ail_remove()? (separate patch, of course!)
> > 
> 
> There was only one other instance of this with regard to the EFI that is
> ultimately replaced with an xfs_efi_release() call. I'll look into
> whether there's enough instances of this for other items to justify a
> helper.

A quick look shows at least another 4 outside the EFI code:

xfs_buf_item_unlock
xfs_qm_dqflush_done
xfs_qm_dqflush
xfs_iflush_abort

That's enough for a helper, I think.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
